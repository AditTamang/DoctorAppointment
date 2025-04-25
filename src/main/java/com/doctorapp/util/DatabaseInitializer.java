package com.doctorapp.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database initializer that loads and executes SQL scripts to set up the database.
 * This class is automatically loaded when the application starts.
 */
public class DatabaseInitializer {

    private static final Logger LOGGER = Logger.getLogger(DatabaseInitializer.class.getName());

    /**
     * Execute a list of SQL statements
     * @param conn Database connection
     * @param statements List of SQL statements to execute
     */
    private static void executeStatements(Connection conn, List<String> statements) {
        try {
            // Disable auto-commit for batch operations
            conn.setAutoCommit(false);

            try (Statement stmt = conn.createStatement()) {
                for (String statement : statements) {
                    try {
                        LOGGER.info("Executing SQL: " + statement);
                        stmt.execute(statement);
                    } catch (SQLException e) {
                        LOGGER.log(Level.WARNING, "Error executing SQL statement: " + statement, e);
                        // Continue with other statements
                    }
                }

                // Commit the transaction
                conn.commit();
            } catch (SQLException e) {
                // Rollback on error
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
                LOGGER.log(Level.SEVERE, "Error executing SQL statements", e);
            } finally {
                // Restore auto-commit
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error managing transaction", e);
        }
    }

    /**
     * Initialize the database by executing SQL scripts
     */
    public static void initialize() {
        LOGGER.info("Initializing database...");

        try {
            // Load the SQL script
            InputStream is = DatabaseInitializer.class.getClassLoader().getResourceAsStream("schema.sql");

            // If still not found, log an error
            if (is == null) {
                LOGGER.severe("ERROR: schema.sql not found in classpath. Database initialization will fail.");
                throw new IOException("schema.sql not found in classpath");
            }

            // Read the SQL script
            StringBuilder sqlScript = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    // Skip comments and empty lines
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

            // Process the script to separate DDL (table creation) and DML (data insertion) statements
            List<String> ddlStatements = new ArrayList<>();
            List<String> dmlStatements = new ArrayList<>();

            // Split the script into individual statements
            String[] allStatements = sqlScript.toString().split(";\\s*\n");

            // Categorize statements
            for (String statement : allStatements) {
                statement = statement.trim();
                if (statement.isEmpty()) {
                    continue;
                }

                // Skip CREATE DATABASE and USE statements
                if (statement.toUpperCase().startsWith("CREATE DATABASE") ||
                    statement.toUpperCase().startsWith("USE ")) {
                    LOGGER.info("Skipping database statement: " + statement);
                    continue;
                }

                // Add to appropriate list
                if (statement.toUpperCase().startsWith("CREATE TABLE") ||
                    statement.toUpperCase().startsWith("DROP TABLE") ||
                    statement.toUpperCase().startsWith("ALTER TABLE")) {
                    ddlStatements.add(statement);
                } else {
                    dmlStatements.add(statement);
                }
            }

            // Execute statements in proper order
            try (Connection conn = DBConnection.getConnection()) {
                // First execute all DDL statements to create tables
                LOGGER.info("Executing DDL statements to create tables...");
                executeStatements(conn, ddlStatements);

                // Then execute all DML statements to insert data
                LOGGER.info("Executing DML statements to insert data...");
                executeStatements(conn, dmlStatements);

                LOGGER.info("Database initialization completed successfully.");
            } catch (SQLException | ClassNotFoundException e) {
                LOGGER.log(Level.SEVERE, "Database connection error", e);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading SQL script", e);
        }
    }

    // Database initialization is now handled by AppInitializer
}
