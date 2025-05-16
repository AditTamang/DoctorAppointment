package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.doctorapp.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet to display database schema information
 * This is a diagnostic tool to help identify column names and table structure
 */
@WebServlet("/admin/database-schema")
public class DatabaseSchemaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Schema</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("h1, h2 { color: #333; }");
        out.println("table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }");
        out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        out.println("th { background-color: #f2f2f2; }");
        out.println("tr:nth-child(even) { background-color: #f9f9f9; }");
        out.println("</style>");
        out.println("</head><body>");
        
        out.println("<h1>Database Schema Information</h1>");
        
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            
            // Get database product name and version
            out.println("<h2>Database Information</h2>");
            out.println("<p>Database: " + metaData.getDatabaseProductName() + " " + metaData.getDatabaseProductVersion() + "</p>");
            
            // Get all tables
            out.println("<h2>Tables</h2>");
            try (ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"})) {
                while (tables.next()) {
                    String tableName = tables.getString("TABLE_NAME");
                    
                    // Skip system tables
                    if (tableName.startsWith("SYS") || tableName.startsWith("INFORMATION_SCHEMA")) {
                        continue;
                    }
                    
                    out.println("<h3>Table: " + tableName + "</h3>");
                    
                    // Get columns for this table
                    out.println("<table>");
                    out.println("<tr><th>Column Name</th><th>Type</th><th>Size</th><th>Nullable</th></tr>");
                    
                    try (ResultSet columns = metaData.getColumns(null, null, tableName, null)) {
                        while (columns.next()) {
                            String columnName = columns.getString("COLUMN_NAME");
                            String columnType = columns.getString("TYPE_NAME");
                            int columnSize = columns.getInt("COLUMN_SIZE");
                            String nullable = columns.getInt("NULLABLE") == DatabaseMetaData.columnNullable ? "Yes" : "No";
                            
                            out.println("<tr>");
                            out.println("<td>" + columnName + "</td>");
                            out.println("<td>" + columnType + "</td>");
                            out.println("<td>" + columnSize + "</td>");
                            out.println("<td>" + nullable + "</td>");
                            out.println("</tr>");
                        }
                    }
                    
                    out.println("</table>");
                    
                    // Show sample data
                    out.println("<h4>Sample Data</h4>");
                    out.println("<table>");
                    
                    try (Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName + " LIMIT 5")) {
                        
                        // Get column count
                        int columnCount = rs.getMetaData().getColumnCount();
                        
                        // Print column headers
                        out.println("<tr>");
                        for (int i = 1; i <= columnCount; i++) {
                            out.println("<th>" + rs.getMetaData().getColumnName(i) + "</th>");
                        }
                        out.println("</tr>");
                        
                        // Print data rows
                        while (rs.next()) {
                            out.println("<tr>");
                            for (int i = 1; i <= columnCount; i++) {
                                String value = rs.getString(i);
                                out.println("<td>" + (value != null ? value : "NULL") + "</td>");
                            }
                            out.println("</tr>");
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='" + 4 + "'>Error getting sample data: " + e.getMessage() + "</td></tr>");
                    }
                    
                    out.println("</table>");
                }
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            out.println("<h2>Error</h2>");
            out.println("<p>Error accessing database: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("</body></html>");
    }
}
