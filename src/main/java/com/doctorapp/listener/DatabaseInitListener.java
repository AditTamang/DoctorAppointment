package com.doctorapp.listener;

import com.doctorapp.util.DatabaseInitializer;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database initialization listener that runs when the application starts.
 * This listener ensures the database tables are created if they don't exist.
 */
@WebListener
public class DatabaseInitListener implements ServletContextListener {
    
    private static final Logger LOGGER = Logger.getLogger(DatabaseInitListener.class.getName());
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Database initialization starting...");
        
        try {
            // Initialize the database
            DatabaseInitializer.initialize();
            LOGGER.info("Database initialization completed successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error initializing database", e);
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to do on shutdown
    }
}
