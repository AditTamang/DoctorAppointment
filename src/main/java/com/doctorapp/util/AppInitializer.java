package com.doctorapp.util;

import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

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

        try {
            // Initialize the database if needed
            LOGGER.info("Initializing database if needed...");
            DatabaseInitializer.initialize();

            LOGGER.info("Database setup completed successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during database setup", e);
        }

        LOGGER.info("Application startup complete.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Application shutting down...");
    }
}
