package com.doctorapp.service;

import com.doctorapp.dao.PatientDAO;
import com.doctorapp.model.Patient;
import com.doctorapp.model.MedicalRecord;
import com.doctorapp.model.Prescription;

import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service layer for Patient-related operations.
 * This class acts as an intermediary between controllers and DAOs.
 */
public class PatientService {
    private static final Logger LOGGER = Logger.getLogger(PatientService.class.getName());
    private PatientDAO patientDAO;

    public PatientService() {
        this.patientDAO = new PatientDAO();
    }

    /**
     * Add a new patient
     * @param patient The patient to add
     * @return true if addition was successful, false otherwise
     */
    public boolean addPatient(Patient patient) {
        try {
            return patientDAO.addPatient(patient);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding patient", e);
            return false;
        }
    }

    /**
     * Get a patient by ID
     * @param id Patient ID
     * @return Patient object if found, null otherwise
     */
    public Patient getPatientById(int id) {
        try {
            return patientDAO.getPatientById(id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting patient by ID: " + id, e);
            return null;
        }
    }

    /**
     * Get a patient by user ID
     * @param userId User ID
     * @return Patient object if found, null otherwise
     */
    public Patient getPatientByUserId(int userId) {
        try {
            return patientDAO.getPatientByUserId(userId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting patient by user ID: " + userId, e);
            return null;
        }
    }

    /**
     * Get patient ID by user ID
     * @param userId User ID
     * @return Patient ID if found, 0 otherwise
     */
    public int getPatientIdByUserId(int userId) {
        try {
            return patientDAO.getPatientIdByUserId(userId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting patient ID by user ID: " + userId, e);
            return 0;
        }
    }

    /**
     * Get all patients
     * @return List of all patients
     */
    public List<Patient> getAllPatients() {
        try {
            return patientDAO.getAllPatients();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting all patients", e);
            return Collections.emptyList();
        }
    }

    /**
     * Update a patient
     * @param patient The patient to update
     * @return true if update was successful, false otherwise
     */
    public boolean updatePatient(Patient patient) {
        try {
            return patientDAO.updatePatient(patient);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating patient", e);
            return false;
        }
    }

    /**
     * Delete a patient
     * @param id Patient ID
     * @return true if deletion was successful, false otherwise
     */
    public boolean deletePatient(int id) {
        try {
            return patientDAO.deletePatient(id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting patient with ID: " + id, e);
            return false;
        }
    }

    /**
     * Get total number of patients
     * @return Total number of patients
     */
    public int getTotalPatients() {
        try {
            return patientDAO.getTotalPatients();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting total patients count", e);
            return 0;
        }
    }

    /**
     * Get recent medical records for a patient
     * @param patientId Patient ID
     * @param limit Number of records to return
     * @return List of recent medical records
     */
    public List<MedicalRecord> getRecentMedicalRecords(int patientId, int limit) {
        try {
            return patientDAO.getRecentMedicalRecords(patientId, limit);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting recent medical records for patient ID: " + patientId, e);
            return Collections.emptyList();
        }
    }

    /**
     * Get current prescriptions for a patient
     * @param patientId Patient ID
     * @return List of current prescriptions
     */
    public List<Prescription> getCurrentPrescriptions(int patientId) {
        try {
            return patientDAO.getCurrentPrescriptions(patientId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting current prescriptions for patient ID: " + patientId, e);
            return Collections.emptyList();
        }
    }
}
