package com.doctorapp.service;

import java.util.List;

import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Doctor;

/**
 * Service layer for Doctor-related operations.
 * This class acts as an intermediary between controllers and DAOs.
 */
public class DoctorService {
    private DoctorDAO doctorDAO;

    public DoctorService() {
        this.doctorDAO = new DoctorDAO();
    }

    /**
     * Add a new doctor
     * @param doctor The doctor to add
     * @return true if addition was successful, false otherwise
     */
    public boolean addDoctor(Doctor doctor) {
        return doctorDAO.addDoctor(doctor);
    }

    /**
     * Get a doctor by ID
     * @param id Doctor's ID
     * @return Doctor object if found, null otherwise
     */
    public Doctor getDoctorById(int id) {
        return doctorDAO.getDoctorById(id);
    }

    /**
     * Get all doctors
     * @return List of all doctors
     */
    public List<Doctor> getAllDoctors() {
        return doctorDAO.getAllDoctors();
    }

    /**
     * Search doctors by name or email
     * @param searchTerm Term to search for in name or email
     * @return List of doctors matching the search term
     */
    public List<Doctor> searchDoctors(String searchTerm) {
        return doctorDAO.searchDoctors(searchTerm);
    }

    /**
     * Get doctors by specialization
     * @param specialization Specialization to filter by
     * @return List of doctors with the specified specialization
     */
    public List<Doctor> getDoctorsBySpecialization(String specialization) {
        return doctorDAO.getDoctorsBySpecialization(specialization);
    }

    /**
     * Update a doctor
     * @param doctor The doctor to update
     * @return true if update was successful, false otherwise
     */
    public boolean updateDoctor(Doctor doctor) {
        return doctorDAO.updateDoctor(doctor);
    }

    /**
     * Delete a doctor
     * @param id Doctor's ID
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteDoctor(int id) {
        return doctorDAO.deleteDoctor(id);
    }

    /**
     * Get total number of doctors
     * @return Total number of doctors
     */
    public int getTotalDoctors() {
        return doctorDAO.getTotalDoctors();
    }

    /**
     * Get top doctors based on ratings or appointments
     * @param limit Number of doctors to return
     * @return List of top doctors
     */
    public List<Doctor> getTopDoctors(int limit) {
        return doctorDAO.getTopDoctors(limit);
    }
}
