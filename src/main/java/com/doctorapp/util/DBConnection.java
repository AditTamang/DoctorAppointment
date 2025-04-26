package com.doctorapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/doctor_appointment?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&createDatabaseIfNotExist=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    // MySQL driver class name
    private static final String MYSQL_DRIVER = "com.mysql.cj.jdbc.Driver";

    // Connection pool - simple implementation
    private static final ConcurrentHashMap<Thread, Connection> connectionPool = new ConcurrentHashMap<>();

    // Flag to track if driver is loaded
    private static boolean driverLoaded = false;

    /**
     * Get a database connection
     * @return Connection object
     * @throws SQLException if a database access error occurs
     * @throws ClassNotFoundException if the driver class is not found
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Check if current thread already has a connection
        Thread currentThread = Thread.currentThread();
        Connection existingConn = connectionPool.get(currentThread);

        if (existingConn != null && !existingConn.isClosed()) {
            // Reuse existing connection
            return existingConn;
        }

        // Load driver only once
        if (!driverLoaded) {
            loadDriver();
        }

        try {
            // Get a new connection
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            LOGGER.info("Database connection established successfully");

            // Store in pool
            connectionPool.put(currentThread, conn);
            return conn;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to connect to database: " + e.getMessage(), e);

            // Try connecting to MySQL server without specifying database
            try {
                String rootUrl = "jdbc:mysql://localhost:3306?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                Connection conn = DriverManager.getConnection(rootUrl, USERNAME, PASSWORD);
                LOGGER.info("Connected to MySQL server without database");

                // Create the database if it doesn't exist
                try (java.sql.Statement stmt = conn.createStatement()) {
                    stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS doctor_appointment");
                    LOGGER.info("Created doctor_appointment database");
                }

                // Close the connection and reconnect with the database
                conn.close();
                Connection newConn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                connectionPool.put(currentThread, newConn);
                return newConn;
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Failed to create database: " + ex.getMessage(), ex);

                // Create a dummy in-memory H2 database as fallback
                try {
                    LOGGER.info("Attempting to use H2 in-memory database as fallback");
                    Class.forName("org.h2.Driver");
                    Connection h2Conn = DriverManager.getConnection("jdbc:h2:mem:doctor_appointment;DB_CLOSE_DELAY=-1", "sa", "");
                    connectionPool.put(currentThread, h2Conn);
                    return h2Conn;
                } catch (Exception h2Ex) {
                    LOGGER.log(Level.SEVERE, "Failed to create H2 in-memory database: " + h2Ex.getMessage(), h2Ex);
                    throw e; // Re-throw the original exception if H2 fallback fails
                }
            }
        }
    }

    /**
     * Load the MySQL JDBC driver
     * @throws ClassNotFoundException if the driver class is not found
     */
    private static synchronized void loadDriver() throws ClassNotFoundException {
        if (driverLoaded) {
            return;
        }

        try {
            // Load the MySQL JDBC driver
            Class.forName(MYSQL_DRIVER);
            LOGGER.info("MySQL JDBC driver loaded successfully");
            driverLoaded = true;
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found: " + e.getMessage(), e);

            // Try to load the driver from the lib directory using class loader
            try {
                // Try to find the JAR file using the class loader
                ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
                if (classLoader == null) {
                    classLoader = DBConnection.class.getClassLoader();
                }

                // Try to load the driver directly with the class loader
                try {
                    Class.forName(MYSQL_DRIVER, true, classLoader);
                    LOGGER.info("MySQL JDBC driver loaded with context class loader");
                    driverLoaded = true;
                    return;
                } catch (ClassNotFoundException ex) {
                    LOGGER.log(Level.WARNING, "Still couldn't find driver with context class loader: " + ex.getMessage());
                }

                // If that fails, try to find the JAR file in various locations
                String[] possiblePaths = {
                    "WEB-INF/lib/mysql-connector-j-9.2.0.jar",
                    "src/main/webapp/WEB-INF/lib/mysql-connector-j-9.2.0.jar",
                    "../lib/mysql-connector-j-9.2.0.jar",
                    "lib/mysql-connector-j-9.2.0.jar"
                };

                java.io.File jarFile = null;
                for (String path : possiblePaths) {
                    java.io.File file = new java.io.File(path);
                    if (file.exists()) {
                        jarFile = file;
                        LOGGER.info("Found MySQL connector at: " + file.getAbsolutePath());
                        break;
                    }
                }

                if (jarFile != null) {
                    java.net.URL url = jarFile.toURI().toURL();
                    java.net.URLClassLoader urlClassLoader = (java.net.URLClassLoader) ClassLoader.getSystemClassLoader();
                    java.lang.reflect.Method method = java.net.URLClassLoader.class.getDeclaredMethod("addURL", java.net.URL.class);
                    method.setAccessible(true);
                    method.invoke(urlClassLoader, url);
                    Class.forName(MYSQL_DRIVER);
                    LOGGER.info("MySQL JDBC driver loaded dynamically");
                    driverLoaded = true;
                } else {
                    throw new ClassNotFoundException("MySQL JDBC driver not found in any of the expected locations");
                }
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Failed to load MySQL JDBC driver: " + ex.getMessage(), ex);
                throw new ClassNotFoundException("Failed to load MySQL JDBC driver: " + ex.getMessage(), ex);
            }
        }
    }

    /**
     * Close a database connection
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                // Don't actually close the connection, just return it to the pool
                // We'll let the connection pool manage the lifecycle

                // Only log at fine level to reduce console spam
                LOGGER.fine("Connection returned to pool");
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error managing connection: " + e.getMessage(), e);
            }
        }
    }

    /**
     * Close all connections in the pool
     * This should be called when the application is shutting down
     */
    public static void closeAllConnections() {
        LOGGER.info("Closing all database connections");
        for (Connection conn : connectionPool.values()) {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing connection: " + e.getMessage(), e);
            }
        }
        connectionPool.clear();
    }
}
