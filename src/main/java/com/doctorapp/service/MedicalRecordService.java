package com.doctorapp.service;

import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.dao.MedicalRecordDAO;
import com.doctorapp.dao.PatientDAO;
import com.doctorapp.model.MedicalRecord;

/**
 * Service layer for MedicalRecord-related operations.
 * This class acts as an intermediary between controllers and DAOs.
 */
public class MedicalRecordService {
    private static final Logger LOGGER = Logger.getLogger(MedicalRecordService.class.getName());
    private PatientDAO patientDAO;
    private MedicalRecordDAO medicalRecordDAO;

    public MedicalRecordService() {
        this.patientDAO = new PatientDAO();
        this.medicalRecordDAO = new MedicalRecordDAO();
    }

    /**
     * Get medical records by patient ID - OPTIMIZED FOR SPEED
     * @param patientId Patient ID
     * @return List of medical records
     */
    public List<MedicalRecord> getMedicalRecordsByPatientId(int patientId) {
        try {
            // Fast path - try primary DAO first with limit for performance
            List<MedicalRecord> records = medicalRecordDAO.getMedicalRecordsByPatientId(patientId, 15);
            if (!records.isEmpty()) {
                return records;
            }

            // Fallback only if needed - no logging for performance
            return patientDAO.getRecentMedicalRecords(patientId, 15);
        } catch (Exception e) {
            // Minimal error handling for performance
            return Collections.emptyList();
        }
    }

    /**
     * Add a new medical record
     * @param medicalRecord The medical record to add
     * @return true if addition was successful, false otherwise
     */
    public boolean addMedicalRecord(MedicalRecord medicalRecord) {
        try {
            return medicalRecordDAO.addMedicalRecord(medicalRecord);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding medical record", e);
            return false;
        }
    }

    /**
     * Get a medical record by ID
     * @param id Medical record ID
     * @return Medical record if found, null otherwise
     */
    public MedicalRecord getMedicalRecordById(int id) {
        try {
            return medicalRecordDAO.getMedicalRecordById(id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting medical record by ID: " + id, e);
            return null;
        }
    }

    /**
     * Check if a patient has access to a specific medical record
     * @param patientId Patient ID
     * @param recordId Medical record ID
     * @return true if the patient has access, false otherwise
     */
    public boolean canPatientAccessRecord(int patientId, int recordId) {
        try {
            MedicalRecord record = getMedicalRecordById(recordId);
            if (record == null) {
                LOGGER.log(Level.WARNING, "Medical record not found: " + recordId);
                return false;
            }

            // Check if the record belongs to the patient
            boolean hasAccess = (record.getPatientId() == patientId);

            if (!hasAccess) {
                LOGGER.log(Level.WARNING, "Access denied: Patient ID {0} attempted to access record ID {1} belonging to patient ID {2}",
                    new Object[]{patientId, recordId, record.getPatientId()});
            }

            return hasAccess;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking patient access to medical record", e);
            return false;
        }
    }

    /**
     * Update a medical record
     * @param medicalRecord The medical record to update
     * @return true if update was successful, false otherwise
     */
    public boolean updateMedicalRecord(MedicalRecord medicalRecord) {
        try {
            return medicalRecordDAO.updateMedicalRecord(medicalRecord);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating medical record", e);
            return false;
        }
    }

    /**
     * Delete a medical record
     * @param id Medical record ID
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteMedicalRecord(int id) {
        try {
            return medicalRecordDAO.deleteMedicalRecord(id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting medical record", e);
            return false;
        }
    }
}
