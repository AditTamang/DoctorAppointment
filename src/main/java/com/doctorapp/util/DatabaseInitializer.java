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
 * Simple database initializer that loads and executes the schema.sql script.
 * This class is automatically loaded when the application starts.
 */
public class DatabaseInitializer {

    private static final Logger LOGGER = Logger.getLogger(DatabaseInitializer.class.getName());
    private static boolean initialized = false;

    /**
     * Initialize the database by executing the schema.sql script
     */
    public static synchronized void initialize() {
        if (initialized) {
            LOGGER.fine("Database already initialized.");
            return;
        }

        LOGGER.info("Initializing database...");

        // Initialize schema
        initializeSchema();

        // Initialize test data
        initializeTestData();

        // Mark as initialized
        initialized = true;
    }

    /**
     * Initialize the database schema by executing the schema.sql script
     */
    private static void initializeSchema() {
        LOGGER.info("Initializing database schema...");

        try {
            // Load the schema.sql script
            InputStream is = DatabaseInitializer.class.getClassLoader().getResourceAsStream("schema.sql");

            // If not found, log an error
            if (is == null) {
                LOGGER.warning("schema.sql not found in classpath. Database schema initialization failed.");
                return;
            }

            // Execute the SQL script
            executeSqlScript(is, "schema.sql");

            LOGGER.info("Database schema initialization completed successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error initializing database schema", e);
        }
    }

    /**
     * Initialize test data by executing the test-data.sql script
     */
    private static void initializeTestData() {
        LOGGER.info("Initializing test data...");

        try {
            // Load the test-data.sql script
            InputStream is = DatabaseInitializer.class.getClassLoader().getResourceAsStream("test-data.sql");

            // If not found, log an error
            if (is == null) {
                LOGGER.warning("test-data.sql not found in classpath. Test data initialization skipped.");
                return;
            }

            // Execute the SQL script
            executeSqlScript(is, "test-data.sql");

            LOGGER.info("Test data initialization completed successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error initializing test data", e);
        }
    }

    /**
     * Execute an SQL script from an input stream
     */
    private static void executeSqlScript(InputStream is, String scriptName) throws IOException, SQLException, ClassNotFoundException {
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

        // Split the script into individual statements
        String[] statements = sqlScript.toString().split(";\\s*\n");

        // Execute each statement
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
                        LOGGER.log(Level.WARNING, "Error executing SQL statement from " + scriptName + ": " + e.getMessage());
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
                LOGGER.log(Level.SEVERE, "Error executing SQL statements from " + scriptName, e);
                throw e;
            } finally {
                // Restore auto-commit
                conn.setAutoCommit(true);
            }
        }
    }
}
