package com.doctorapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static final List<Connection> activeConnections = new ArrayList<>();
    // Simplified URL for faster connections
    private static final String URL = "jdbc:mysql://localhost:3306/doctor_appointment?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&connectTimeout=3000&socketTimeout=5000";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";
    private static boolean driverLoaded = false;

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load driver only once for faster subsequent connections
        if (!driverLoaded) {
            synchronized(DBConnection.class) {
                if (!driverLoaded) {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    driverLoaded = true;
                }
            }
        }

        // Create new connection directly - simple and fast
        Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        synchronized(activeConnections) {
            activeConnections.add(conn);
        }
        return conn;
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            synchronized(activeConnections) {
                activeConnections.remove(connection);
            }

            // Simply close the connection - no pooling for faster performance
            try {
                connection.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing database connection", e);
            }
        }
    }

    /**
     * Close all active database connections
     * This method is called when the application shuts down
     */
    public static void closeAllConnections() {
        synchronized(activeConnections) {
            LOGGER.info("Closing all database connections: " + activeConnections.size() + " active connections");
            List<Connection> connectionsToClose = new ArrayList<>(activeConnections);
            for (Connection conn : connectionsToClose) {
                try {
                    if (conn != null && !conn.isClosed()) {
                        conn.close();
                        LOGGER.info("Closed database connection");
                    }
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Error closing database connection during shutdown", e);
                }
            }
            activeConnections.clear();
            LOGGER.info("All database connections closed");
        }
    }
}
