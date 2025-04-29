package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.model.Department;
import com.doctorapp.util.DBConnection;

/**
 * Data Access Object for Department
 */
public class DepartmentDAO {
    private static final Logger LOGGER = Logger.getLogger(DepartmentDAO.class.getName());

    /**
     * Get all departments
     * @return List of departments
     */
    public List<Department> getAllDepartments() {
        List<Department> departments = new ArrayList<>();
        String query = "SELECT * FROM departments WHERE status = 'ACTIVE' ORDER BY name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Department department = new Department();
                department.setId(rs.getInt("id"));
                department.setName(rs.getString("name"));
                department.setDescription(rs.getString("description"));
                department.setStatus(rs.getString("status"));
                department.setCreatedAt(rs.getString("created_at"));
                department.setUpdatedAt(rs.getString("updated_at"));
                departments.add(department);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting all departments", e);
        }

        return departments;
    }

    /**
     * Get department by ID
     * @param id Department ID
     * @return Department object
     */
    public Department getDepartmentById(int id) {
        String query = "SELECT * FROM departments WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Department department = new Department();
                    department.setId(rs.getInt("id"));
                    department.setName(rs.getString("name"));
                    department.setDescription(rs.getString("description"));
                    department.setStatus(rs.getString("status"));
                    department.setCreatedAt(rs.getString("created_at"));
                    department.setUpdatedAt(rs.getString("updated_at"));
                    return department;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting department by ID: " + id, e);
        }

        return null;
    }

    /**
     * Add a new department
     * @param department Department object
     * @return true if successful, false otherwise
     */
    public boolean addDepartment(Department department) {
        String query = "INSERT INTO departments (name, description, status) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, department.getName());
            pstmt.setString(2, department.getDescription());
            pstmt.setString(3, department.getStatus() != null ? department.getStatus() : "ACTIVE");

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error adding department", e);
            return false;
        }
    }

    /**
     * Update a department
     * @param department Department object
     * @return true if successful, false otherwise
     */
    public boolean updateDepartment(Department department) {
        String query = "UPDATE departments SET name = ?, description = ?, status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, department.getName());
            pstmt.setString(2, department.getDescription());
            pstmt.setString(3, department.getStatus());
            pstmt.setInt(4, department.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error updating department", e);
            return false;
        }
    }

    /**
     * Delete a department
     * @param id Department ID
     * @return true if successful, false otherwise
     */
    public boolean deleteDepartment(int id) {
        String query = "DELETE FROM departments WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error deleting department", e);
            return false;
        }
    }

    /**
     * Get total number of departments
     * @return Total number of departments
     */
    public int getTotalDepartments() {
        String query = "SELECT COUNT(*) FROM departments";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting total departments", e);
        }

        return 0;
    }
}
