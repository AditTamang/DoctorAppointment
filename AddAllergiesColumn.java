import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class AddAllergiesColumn {
    private static final String URL = "jdbc:mysql://localhost:3306/doctor_appointment?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    public static void main(String[] args) {
        System.out.println("Adding allergies column to patients table if it doesn't exist...");
        
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Get a connection
            try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                 Statement stmt = conn.createStatement()) {
                
                // Direct SQL approach - check if column exists and add it if it doesn't
                String checkColumnSQL = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS " +
                                       "WHERE TABLE_SCHEMA = 'doctor_appointment' " +
                                       "AND TABLE_NAME = 'patients' " +
                                       "AND COLUMN_NAME = 'allergies'";
                
                int columnCount = 0;
                var rs = stmt.executeQuery(checkColumnSQL);
                if (rs.next()) {
                    columnCount = rs.getInt(1);
                }
                
                if (columnCount == 0) {
                    System.out.println("Allergies column does not exist. Adding it now...");
                    String alterTableSQL = "ALTER TABLE patients ADD COLUMN allergies TEXT";
                    stmt.execute(alterTableSQL);
                    System.out.println("Successfully added allergies column to patients table.");
                } else {
                    System.out.println("Allergies column already exists in patients table.");
                }
            }
            
            System.out.println("Operation completed successfully.");
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        }
    }
}
