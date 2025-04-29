package com.doctorapp.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

/**
 * Database connection listener to ensure all connections are closed when the application shuts down.
 */
@WebListener
public class DatabaseConnectionListener implements ServletContextListener {
    private static final Logger LOGGER = Logger.getLogger(DatabaseConnectionListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Application starting up - initializing database connection pool");
        // Nothing to do here, connections will be created on demand
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Application shutting down - closing all database connections");
        // Close all database connections
        DBConnection.closeAllConnections();
    }
}
