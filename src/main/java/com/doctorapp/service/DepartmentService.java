package com.doctorapp.service;

import java.util.List;

import com.doctorapp.dao.DepartmentDAO;
import com.doctorapp.model.Department;

/**
 * Service class for Department
 */
public class DepartmentService {
    private DepartmentDAO departmentDAO;

    public DepartmentService() {
        this.departmentDAO = new DepartmentDAO();
    }

    /**
     * Get all departments
     * @return List of departments
     */
    public List<Department> getAllDepartments() {
        return departmentDAO.getAllDepartments();
    }

    /**
     * Get department by ID
     * @param id Department ID
     * @return Department object
     */
    public Department getDepartmentById(int id) {
        return departmentDAO.getDepartmentById(id);
    }

    /**
     * Add a new department
     * @param department Department object
     * @return true if successful, false otherwise
     */
    public boolean addDepartment(Department department) {
        return departmentDAO.addDepartment(department);
    }

    /**
     * Update a department
     * @param department Department object
     * @return true if successful, false otherwise
     */
    public boolean updateDepartment(Department department) {
        return departmentDAO.updateDepartment(department);
    }

    /**
     * Delete a department
     * @param id Department ID
     * @return true if successful, false otherwise
     */
    public boolean deleteDepartment(int id) {
        return departmentDAO.deleteDepartment(id);
    }

    /**
     * Get total number of departments
     * @return Total number of departments
     */
    public int getTotalDepartments() {
        return departmentDAO.getTotalDepartments();
    }
}
