package com.doctorapp.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

/**
 * Application initializer that runs when the application starts.
 * This class is responsible for initializing the database and other application components.
 */
@WebListener
public class AppInitializer implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(AppInitializer.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Application starting up...");

        // Initialize the database
        DatabaseInitializer.initialize();

        LOGGER.info("Application startup complete.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Application shutting down...");

        // Close all database connections
        DBConnection.closeAllConnections();

        LOGGER.info("Application shutdown complete.");
    }
}
