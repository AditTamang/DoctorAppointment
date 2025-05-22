package com.doctorapp.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Initializes database by executing schema.sql when application starts
 */
public class DatabaseInitializer {

    private static final Logger LOGGER = Logger.getLogger(DatabaseInitializer.class.getName());
    private static boolean initialized = false;

    /**
     * Initialize database with schema.sql
     */
    public static synchronized void initialize() {
        if (initialized) {
            LOGGER.fine("Database already initialized.");
            return;
        }

        LOGGER.info("Initializing database...");

        try {
            // Try to load consolidated_schema.sql first, fall back to schema.sql if not found
            InputStream is = DatabaseInitializer.class.getClassLoader().getResourceAsStream("consolidated_schema.sql");

            // If consolidated schema is not found, try the original schema
            if (is == null) {
                LOGGER.info("consolidated_schema.sql not found, trying schema.sql instead.");
                is = DatabaseInitializer.class.getClassLoader().getResourceAsStream("schema.sql");
            }

            if (is == null) {
                LOGGER.warning("Neither consolidated_schema.sql nor schema.sql found in classpath. Database initialization failed.");
                return;
            }

            // Read SQL script
            StringBuilder sqlScript = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    // Skip SQL comments and empty lines
                    if (line.trim().startsWith("--") || line.trim().isEmpty()) {
                        continue;
                    }
                    sqlScript.append(line);
                    if (line.trim().endsWith(";")) {
                        sqlScript.append("\n");
                    } else {
                        sqlScript.append(" ");
                    }
                }
            }

            // Split into individual SQL statements
            String[] statements = sqlScript.toString().split(";\\s*\n");
            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false);

                try (Statement stmt = conn.createStatement()) {
                    for (String statement : statements) {
                        statement = statement.trim();
                        if (statement.isEmpty()) {
                            continue;
                        }

                        try {
                            LOGGER.fine("Executing SQL: " + statement);
                            stmt.execute(statement);
                        } catch (SQLException e) {
                            LOGGER.log(Level.WARNING, "Error executing SQL statement: " + e.getMessage());
                            // Continue execution with remaining statements
                        }
                    }

                    conn.commit();
                    LOGGER.info("Database initialization completed successfully.");
                    initialized = true;
                } catch (SQLException e) {
                    // Rollback transaction on error
                    try {
                        conn.rollback();
                    } catch (SQLException rollbackEx) {
                        LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                    }
                    LOGGER.log(Level.SEVERE, "Error executing SQL statements", e);
                } finally {
                    conn.setAutoCommit(true);
                }
            }
        } catch (IOException | SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error initializing database", e);
        }
    }
}
