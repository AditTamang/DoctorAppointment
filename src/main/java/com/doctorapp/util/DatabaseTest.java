package com.doctorapp.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * A simple test class to verify database connection and initialization
 */
public class DatabaseTest {
    
    public static void main(String[] args) {
        try {
            System.out.println("Testing database connection and initialization...");
            
            // Initialize the database
            DatabaseInitializer.initialize();
            
            // Get a connection
            Connection conn = DBConnection.getConnection();
            System.out.println("Database connection successful!");
            
            // Check if users table exists and has data
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Users table exists and has " + count + " records.");
            }
            
            // Close resources
            rs.close();
            stmt.close();
            DBConnection.closeConnection(conn);
            
            System.out.println("Database test completed successfully!");
        } catch (Exception e) {
            System.err.println("Database test failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
