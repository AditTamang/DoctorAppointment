package com.doctorapp.listener;

import java.util.logging.Logger;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Database initialization listener that runs when the application starts.
 * This listener has been deprecated in favor of AppInitializer.
 * Kept for backward compatibility but does not perform any initialization.
 */
@WebListener
public class DatabaseInitListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(DatabaseInitListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("DatabaseInitListener is deprecated. Database initialization is now handled by AppInitializer.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to do on shutdown
    }
}
