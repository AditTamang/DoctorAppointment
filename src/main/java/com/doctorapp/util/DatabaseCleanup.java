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
 * Utility class to clean up unnecessary tables from the database
 */
public class DatabaseCleanup {
    private static final Logger LOGGER = Logger.getLogger(DatabaseCleanup.class.getName());

    /**
     * Execute the SQL script to drop unnecessary tables
     */
    public static void cleanupDatabase() {
        LOGGER.info("Starting database cleanup to remove unnecessary tables...");

        try {
            // Load the SQL script
            InputStream is = DatabaseCleanup.class.getClassLoader().getResourceAsStream("drop_unnecessary_tables.sql");

            if (is == null) {
                LOGGER.severe("ERROR: drop_unnecessary_tables.sql not found in classpath. Database cleanup will be skipped.");
                return;
            }

            LOGGER.info("Found drop_unnecessary_tables.sql in classpath, reading file...");

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

            LOGGER.info("Successfully read drop_unnecessary_tables.sql, processing statements...");

            // Split the script into individual statements
            String[] statements = sqlScript.toString().split(";");
            LOGGER.info("Found " + statements.length + " SQL statements to process");

            // Execute statements
            try (Connection conn = DBConnection.getConnection()) {
                LOGGER.info("Database connection established successfully");

                for (String statement : statements) {
                    statement = statement.trim();
                    if (!statement.isEmpty()) {
                        try (Statement stmt = conn.createStatement()) {
                            LOGGER.info("Executing SQL: " + statement);
                            stmt.execute(statement);
                            LOGGER.info("SQL executed successfully");
                        } catch (SQLException e) {
                            // Log the error but continue with other statements
                            LOGGER.log(Level.WARNING, "Error executing SQL statement: " + statement);
                            LOGGER.log(Level.WARNING, "Error message: " + e.getMessage());
                        }
                    }
                }

                LOGGER.info("Database cleanup completed successfully");
            } catch (SQLException | ClassNotFoundException e) {
                LOGGER.log(Level.SEVERE, "Database error during cleanup: " + e.getMessage(), e);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading SQL script: " + e.getMessage(), e);
        }
    }
}
