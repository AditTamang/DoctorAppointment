package com.doctorapp.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
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
     * Check if a table exists in the database
     */
    private static boolean tableExists(Connection conn, String tableName) throws SQLException {
        DatabaseMetaData meta = conn.getMetaData();
        ResultSet rs = meta.getTables(null, null, tableName, new String[] {"TABLE"});
        boolean exists = rs.next();
        rs.close();
        return exists;
    }

    /**
     * Create the appointments table if it doesn't exist
     */
    private static void createAppointmentsTableIfNotExists(Connection conn) throws SQLException {
        if (!tableExists(conn, "appointments")) {
            LOGGER.info("Creating appointments table...");

            // First disable foreign key checks
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET FOREIGN_KEY_CHECKS=0");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Could not disable foreign key checks: " + e.getMessage());
                // Continue anyway
            }

            String createTableSQL =
                "CREATE TABLE appointments (" +
                "    id INT AUTO_INCREMENT PRIMARY KEY," +
                "    patient_id INT NOT NULL," +
                "    doctor_id INT NOT NULL," +
                "    schedule_id INT NOT NULL," +
                "    appointment_date DATE NOT NULL," +
                "    appointment_time TIME NOT NULL," +
                "    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING'," +
                "    reason VARCHAR(255)," +
                "    symptoms TEXT," +
                "    notes TEXT," +
                "    diagnosis TEXT," +
                "    treatment TEXT," +
                "    fee DECIMAL(10, 2) DEFAULT 0.00," +
                "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                "    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE," +
                "    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE," +
                "    FOREIGN KEY (schedule_id) REFERENCES doctor_schedules(id) ON DELETE CASCADE" +
                ")";

            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
                LOGGER.info("Appointments table created successfully.");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error creating appointments table: " + e.getMessage());

                // Try creating without foreign keys if it failed
                String createTableWithoutFKSQL =
                    "CREATE TABLE appointments (" +
                    "    id INT AUTO_INCREMENT PRIMARY KEY," +
                    "    patient_id INT NOT NULL," +
                    "    doctor_id INT NOT NULL," +
                    "    schedule_id INT NOT NULL," +
                    "    appointment_date DATE NOT NULL," +
                    "    appointment_time TIME NOT NULL," +
                    "    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING'," +
                    "    reason VARCHAR(255)," +
                    "    symptoms TEXT," +
                    "    notes TEXT," +
                    "    diagnosis TEXT," +
                    "    treatment TEXT," +
                    "    fee DECIMAL(10, 2) DEFAULT 0.00," +
                    "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                    ")";

                try (Statement stmt2 = conn.createStatement()) {
                    stmt2.execute(createTableWithoutFKSQL);
                    LOGGER.info("Appointments table created successfully without foreign keys.");
                } catch (SQLException e2) {
                    LOGGER.log(Level.SEVERE, "Failed to create appointments table even without foreign keys: " + e2.getMessage());
                }
            }

            // Re-enable foreign key checks
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET FOREIGN_KEY_CHECKS=1");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Could not re-enable foreign key checks: " + e.getMessage());
                // Continue anyway
            }
        } else {
            LOGGER.info("Appointments table already exists.");
        }
    }

    /**
     * Create the doctor_schedules table if it doesn't exist
     */
    private static void createDoctorSchedulesTableIfNotExists(Connection conn) throws SQLException {
        if (!tableExists(conn, "doctor_schedules")) {
            LOGGER.info("Creating doctor_schedules table...");

            // First disable foreign key checks
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET FOREIGN_KEY_CHECKS=0");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Could not disable foreign key checks: " + e.getMessage());
                // Continue anyway
            }

            String createTableSQL =
                "CREATE TABLE doctor_schedules (" +
                "    id INT AUTO_INCREMENT PRIMARY KEY," +
                "    doctor_id INT NOT NULL," +
                "    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL," +
                "    start_time TIME NOT NULL," +
                "    end_time TIME NOT NULL," +
                "    break_start_time TIME," +
                "    break_end_time TIME," +
                "    slot_duration INT DEFAULT 30," +
                "    max_appointments INT DEFAULT 20," +
                "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                "    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE" +
                ")";

            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
                LOGGER.info("Doctor_schedules table created successfully.");

                // Insert a default schedule for each doctor
                try {
                    String insertDefaultScheduleSQL =
                        "INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, slot_duration) " +
                        "SELECT id, 'Monday', '09:00:00', '17:00:00', 30 FROM doctors";
                    stmt.execute(insertDefaultScheduleSQL);
                    LOGGER.info("Default schedules inserted for doctors.");
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Could not insert default schedules: " + e.getMessage());
                    // Continue anyway
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error creating doctor_schedules table: " + e.getMessage());

                // Try creating without foreign keys if it failed
                String createTableWithoutFKSQL =
                    "CREATE TABLE doctor_schedules (" +
                    "    id INT AUTO_INCREMENT PRIMARY KEY," +
                    "    doctor_id INT NOT NULL," +
                    "    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL," +
                    "    start_time TIME NOT NULL," +
                    "    end_time TIME NOT NULL," +
                    "    break_start_time TIME," +
                    "    break_end_time TIME," +
                    "    slot_duration INT DEFAULT 30," +
                    "    max_appointments INT DEFAULT 20," +
                    "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                    ")";

                try (Statement stmt2 = conn.createStatement()) {
                    stmt2.execute(createTableWithoutFKSQL);
                    LOGGER.info("Doctor_schedules table created successfully without foreign keys.");

                    // Insert a default schedule for each doctor
                    try {
                        String insertDefaultScheduleSQL =
                            "INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, slot_duration) " +
                            "SELECT id, 'Monday', '09:00:00', '17:00:00', 30 FROM doctors";
                        stmt2.execute(insertDefaultScheduleSQL);
                        LOGGER.info("Default schedules inserted for doctors.");
                    } catch (SQLException e2) {
                        LOGGER.log(Level.WARNING, "Could not insert default schedules: " + e2.getMessage());
                        // Continue anyway
                    }
                } catch (SQLException e2) {
                    LOGGER.log(Level.SEVERE, "Failed to create doctor_schedules table even without foreign keys: " + e2.getMessage());
                }
            }

            // Re-enable foreign key checks
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET FOREIGN_KEY_CHECKS=1");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Could not re-enable foreign key checks: " + e.getMessage());
                // Continue anyway
            }
        } else {
            LOGGER.info("Doctor_schedules table already exists.");
        }
    }

    /**
     * Sort DDL statements to ensure proper table creation order
     * This ensures tables with foreign keys are created after the tables they reference
     */
    private static List<String> sortDDLStatements(List<String> ddlStatements) {
        // Define the order of table creation based on dependencies
        // The order is critical - tables with foreign keys must come after the tables they reference
        List<String> tableOrder = List.of(
            "users",                        // Base table with no dependencies
            "departments",                  // Base table with no dependencies
            "doctor_registration_requests", // References no other tables
            "contact_messages",             // References no other tables
            "announcements",                // References no other tables
            "doctors",                      // References users and departments
            "patients",                     // References users
            "doctor_settings",              // References doctors
            "doctor_ratings",               // References doctors and patients
            "doctor_schedules",             // References doctors
            "appointments",                 // References patients, doctors, and doctor_schedules
            "prescriptions"                 // References appointments
        );

        // Sort the DDL statements based on the table order
        List<String> sortedDDL = new ArrayList<>();

        // First add all DROP TABLE statements in reverse order
        for (int i = tableOrder.size() - 1; i >= 0; i--) {
            String tableName = tableOrder.get(i);
            for (String statement : ddlStatements) {
                if (statement.toUpperCase().contains("DROP TABLE IF EXISTS " + tableName)) {
                    sortedDDL.add(statement);
                }
            }
        }

        // Then add all CREATE TABLE statements in proper order
        for (String tableName : tableOrder) {
            for (String statement : ddlStatements) {
                if (statement.toUpperCase().contains("CREATE TABLE " + tableName)) {
                    sortedDDL.add(statement);
                }
            }
        }

        // Add any remaining DDL statements
        for (String statement : ddlStatements) {
            if (!sortedDDL.contains(statement)) {
                sortedDDL.add(statement);
            }
        }

        return sortedDDL;
    }

    /**
     * Execute a single SQL statement with better error handling
     */
    private static void executeSingleStatement(Connection conn, String statement) {
        if (statement == null || statement.trim().isEmpty()) {
            LOGGER.warning("Skipping empty SQL statement");
            return;
        }

        // Skip comments
        if (statement.trim().startsWith("--")) {
            LOGGER.fine("Skipping comment: " + statement);
            return;
        }

        try (Statement stmt = conn.createStatement()) {
            LOGGER.info("Executing SQL: " + statement);
            boolean isResultSet = stmt.execute(statement);

            if (!isResultSet) {
                int updateCount = stmt.getUpdateCount();
                LOGGER.info("SQL executed successfully. Rows affected: " + updateCount);
            } else {
                LOGGER.info("SQL executed successfully. Result set returned.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error executing SQL statement: " + statement);
            LOGGER.log(Level.WARNING, "Error message: " + e.getMessage());
            LOGGER.log(Level.WARNING, "SQL Error Code: " + e.getErrorCode());
            LOGGER.log(Level.WARNING, "SQL State: " + e.getSQLState());

            // For duplicate key errors, log more details
            if (e.getErrorCode() == 1062) { // MySQL duplicate key error
                LOGGER.log(Level.WARNING, "Duplicate key error. This might be expected if the record already exists.");
            }

            // Continue execution - don't throw exception
        }
    }

    /**
     * Create the database if it doesn't exist
     */
    private static void createDatabaseIfNotExists() {
        String url = "jdbc:mysql://localhost:3306?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String username = "root";
        String password = "";
        String dbName = "doctor_appointment";

        LOGGER.info("Checking if database exists and creating if needed...");

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            LOGGER.info("MySQL JDBC driver loaded successfully");

            // Connect to MySQL server (not to a specific database)
            try (Connection conn = DriverManager.getConnection(url, username, password)) {
                LOGGER.info("Connected to MySQL server");

                // Check if database exists
                try (ResultSet resultSet = conn.getMetaData().getCatalogs()) {
                    boolean dbExists = false;
                    while (resultSet.next()) {
                        String databaseName = resultSet.getString(1);
                        if (databaseName.equalsIgnoreCase(dbName)) {
                            dbExists = true;
                            break;
                        }
                    }

                    // Create database if it doesn't exist
                    if (!dbExists) {
                        LOGGER.info("Database '" + dbName + "' does not exist. Creating it...");
                        try (Statement stmt = conn.createStatement()) {
                            // Create database with proper character set and collation
                            String sql = "CREATE DATABASE " + dbName +
                                         " CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
                            stmt.executeUpdate(sql);
                            LOGGER.info("Database '" + dbName + "' created successfully.");

                            // Grant privileges to ensure the user has access
                            try {
                                String grantSql = "GRANT ALL PRIVILEGES ON " + dbName + ".* TO '" +
                                                 username + "'@'localhost'";
                                stmt.executeUpdate(grantSql);
                                LOGGER.info("Privileges granted on database '" + dbName + "'");
                            } catch (SQLException e) {
                                // This might fail if the user doesn't have GRANT permission, which is okay
                                LOGGER.log(Level.WARNING, "Could not grant privileges: " + e.getMessage());
                            }
                        }
                    } else {
                        LOGGER.info("Database '" + dbName + "' already exists.");
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found: " + e.getMessage(), e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error connecting to MySQL server: " + e.getMessage(), e);

            // More detailed error information
            LOGGER.log(Level.SEVERE, "SQL State: " + e.getSQLState());
            LOGGER.log(Level.SEVERE, "Error Code: " + e.getErrorCode());

            // Check if MySQL is running
            LOGGER.log(Level.SEVERE, "Please ensure MySQL server is running on localhost:3306");
        }
    }

    /**
     * Initialize the database by executing SQL scripts
     */
    public static void initialize() {
        LOGGER.info("Initializing database...");

        // First, ensure the database exists
        createDatabaseIfNotExists();

        try {
            // Load the SQL script
            InputStream is = DatabaseInitializer.class.getClassLoader().getResourceAsStream("schema.sql");

            // If still not found, log an error
            if (is == null) {
                LOGGER.severe("ERROR: schema.sql not found in classpath. Database initialization will fail.");
                throw new IOException("schema.sql not found in classpath");
            }

            LOGGER.info("Found schema.sql in classpath, reading file...");

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

            LOGGER.info("Successfully read schema.sql, processing statements...");

            // Process the script to separate DDL (table creation) and DML (data insertion) statements
            List<String> ddlStatements = new ArrayList<>();
            List<String> dmlStatements = new ArrayList<>();

            // Split the script into individual statements
            String[] allStatements = sqlScript.toString().split(";");
            LOGGER.info("Found " + allStatements.length + " SQL statements to process");

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

            LOGGER.info("Categorized statements: " + ddlStatements.size() + " DDL, " +
                       dmlStatements.size() + " DML statements");

            // Sort DDL statements to ensure proper table creation order
            List<String> sortedDDL = sortDDLStatements(ddlStatements);
            LOGGER.info("Sorted DDL statements for proper table creation order");

            // Execute statements in proper order
            try (Connection conn = DBConnection.getConnection()) {
                LOGGER.info("Database connection established successfully");

                // Disable foreign key checks temporarily
                executeSingleStatement(conn, "SET FOREIGN_KEY_CHECKS=0");
                LOGGER.info("Foreign key checks disabled for schema creation");

                // Execute each DDL statement individually for better error handling
                LOGGER.info("Executing DDL statements to create tables...");
                for (String statement : sortedDDL) {
                    executeSingleStatement(conn, statement);
                }
                LOGGER.info("All DDL statements executed successfully");

                // Re-enable foreign key checks
                executeSingleStatement(conn, "SET FOREIGN_KEY_CHECKS=1");
                LOGGER.info("Foreign key checks re-enabled");

                // Then execute all DML statements to insert data
                if (!dmlStatements.isEmpty()) {
                    LOGGER.info("Executing DML statements to insert data...");
                    for (String statement : dmlStatements) {
                        executeSingleStatement(conn, statement);
                    }
                    LOGGER.info("All DML statements executed successfully");
                }

                LOGGER.info("Database schema initialization completed successfully");

                // Now check and create required tables if they don't exist
                try {
                    // First check and create doctor_schedules table if needed
                    createDoctorSchedulesTableIfNotExists(conn);

                    // Then check and create appointments table if needed
                    createAppointmentsTableIfNotExists(conn);

                    LOGGER.info("Additional table checks completed successfully");
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error checking or creating tables: " + e.getMessage(), e);
                    LOGGER.log(Level.SEVERE, "SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
                }

                // Insert admin data first
                try {
                    // Load the admin data SQL script
                    InputStream adminDataIs = DatabaseInitializer.class.getClassLoader().getResourceAsStream("admin_data.sql");
                    if (adminDataIs != null) {
                        LOGGER.info("Loading admin data from admin_data.sql...");

                        // Read the SQL script
                        StringBuilder adminDataSql = new StringBuilder();
                        try (BufferedReader reader = new BufferedReader(new InputStreamReader(adminDataIs))) {
                            String line;
                            while ((line = reader.readLine()) != null) {
                                // Skip comments and empty lines
                                if (line.trim().startsWith("--") || line.trim().isEmpty()) {
                                    continue;
                                }
                                adminDataSql.append(line);
                                if (line.trim().endsWith(";")) {
                                    adminDataSql.append("\n");
                                } else {
                                    adminDataSql.append(" ");
                                }
                            }
                        }

                        // Split the script into individual statements
                        String[] adminDataStatements = adminDataSql.toString().split(";");
                        LOGGER.info("Found " + adminDataStatements.length + " admin data statements to execute");

                        // Disable foreign key checks for admin data insertion
                        executeSingleStatement(conn, "SET FOREIGN_KEY_CHECKS=0");

                        // Execute each statement
                        for (String statement : adminDataStatements) {
                            statement = statement.trim();
                            if (!statement.isEmpty()) {
                                try {
                                    // Try to delete any existing admin user first to avoid duplicates
                                    if (statement.contains("'admin'") || statement.contains("'test'")) {
                                        String email = statement.contains("'admin@example.com'") ? "admin@example.com" : "test@gmail.com";
                                        String deleteStatement = "DELETE FROM users WHERE email = '" + email + "'";
                                        executeSingleStatement(conn, deleteStatement);
                                        LOGGER.info("Deleted existing admin user with email: " + email);
                                    }
                                    // Now execute the insert
                                    executeSingleStatement(conn, statement);
                                } catch (Exception e) {
                                    LOGGER.log(Level.WARNING, "Error executing admin data statement: " + e.getMessage(), e);
                                }
                            }
                        }

                        // Re-enable foreign key checks
                        executeSingleStatement(conn, "SET FOREIGN_KEY_CHECKS=1");

                        LOGGER.info("Admin data loaded successfully");
                    } else {
                        LOGGER.warning("admin_data.sql not found in classpath. No admin data will be loaded.");
                    }
                } catch (IOException e) {
                    LOGGER.log(Level.WARNING, "Error reading admin data file: " + e.getMessage(), e);
                }

                // Insert sample data if needed
                try {
                    // Load the sample data SQL script
                    InputStream sampleDataIs = DatabaseInitializer.class.getClassLoader().getResourceAsStream("sample_data.sql");
                    if (sampleDataIs != null) {
                        LOGGER.info("Loading sample data from sample_data.sql...");

                        // Read the SQL script
                        StringBuilder sampleDataSql = new StringBuilder();
                        try (BufferedReader reader = new BufferedReader(new InputStreamReader(sampleDataIs))) {
                            String line;
                            while ((line = reader.readLine()) != null) {
                                // Skip comments and empty lines
                                if (line.trim().startsWith("--") || line.trim().isEmpty()) {
                                    continue;
                                }
                                sampleDataSql.append(line);
                                if (line.trim().endsWith(";")) {
                                    sampleDataSql.append("\n");
                                } else {
                                    sampleDataSql.append(" ");
                                }
                            }
                        }

                        // Split the script into individual statements
                        String[] sampleDataStatements = sampleDataSql.toString().split(";");
                        LOGGER.info("Found " + sampleDataStatements.length + " sample data statements to execute");

                        // Disable foreign key checks for sample data insertion
                        executeSingleStatement(conn, "SET FOREIGN_KEY_CHECKS=0");

                        // Execute each statement
                        for (String statement : sampleDataStatements) {
                            statement = statement.trim();
                            if (!statement.isEmpty()) {
                                executeSingleStatement(conn, statement);
                            }
                        }

                        // Re-enable foreign key checks
                        executeSingleStatement(conn, "SET FOREIGN_KEY_CHECKS=1");

                        LOGGER.info("Sample data loaded successfully");
                    } else {
                        LOGGER.warning("sample_data.sql not found in classpath. No sample data will be loaded.");
                    }
                } catch (IOException e) {
                    LOGGER.log(Level.WARNING, "Error reading sample data file: " + e.getMessage(), e);
                }

                LOGGER.info("Database initialization completed successfully");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Database SQL error: " + e.getMessage(), e);
                LOGGER.log(Level.SEVERE, "SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
            } catch (ClassNotFoundException e) {
                LOGGER.log(Level.SEVERE, "Database driver not found: " + e.getMessage(), e);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading SQL script: " + e.getMessage(), e);
        }
    }



    // Database initialization is now handled by AppInitializer
}
