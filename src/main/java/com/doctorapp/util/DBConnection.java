package com.doctorapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/doctor_appointment?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Get a connection
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            // Try to load the driver from the lib directory using class loader
            try {
                // Try to find the JAR file using the class loader
                ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
                if (classLoader == null) {
                    classLoader = DBConnection.class.getClassLoader();
                }

                // Try to load the driver directly
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver", true, classLoader);
                    return DriverManager.getConnection(URL, USERNAME, PASSWORD);
                } catch (ClassNotFoundException ex) {
                    System.err.println("Still couldn't find driver with context class loader: " + ex.getMessage());
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
                        System.out.println("Found MySQL connector at: " + file.getAbsolutePath());
                        break;
                    }
                }

                if (jarFile != null) {
                    java.net.URL url = jarFile.toURI().toURL();
                    java.net.URLClassLoader urlClassLoader = (java.net.URLClassLoader) ClassLoader.getSystemClassLoader();
                    java.lang.reflect.Method method = java.net.URLClassLoader.class.getDeclaredMethod("addURL", java.net.URL.class);
                    method.setAccessible(true);
                    method.invoke(urlClassLoader, url);
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    return DriverManager.getConnection(URL, USERNAME, PASSWORD);
                } else {
                    throw new ClassNotFoundException("MySQL JDBC driver not found in any of the expected locations");
                }
            } catch (Exception ex) {
                throw new ClassNotFoundException("Failed to load MySQL JDBC driver: " + ex.getMessage(), ex);
            }
        } catch (SQLException e) {
            System.err.println("Failed to connect to database: " + e.getMessage());
            // Create a dummy in-memory H2 database as fallback
            try {
                Class.forName("org.h2.Driver");
                return DriverManager.getConnection("jdbc:h2:mem:doctor_appointment;DB_CLOSE_DELAY=-1", "sa", "");
            } catch (Exception ex) {
                System.err.println("Failed to create H2 in-memory database: " + ex.getMessage());
                throw e; // Re-throw the original exception if H2 fallback fails
            }
        }
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
