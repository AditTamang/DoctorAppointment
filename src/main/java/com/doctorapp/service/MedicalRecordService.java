package com.doctorapp.service;

import com.doctorapp.dao.MedicalRecordDAO;
import com.doctorapp.dao.PatientDAO;
import com.doctorapp.model.MedicalRecord;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

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
     * Get medical records by patient ID
     * @param patientId Patient ID
     * @return List of medical records
     */
    public List<MedicalRecord> getMedicalRecordsByPatientId(int patientId) {
        try {
            List<MedicalRecord> records = new ArrayList<>();

            // Try both methods and combine the results
            try {
                // First try the new method from MedicalRecordDAO
                records.addAll(medicalRecordDAO.getMedicalRecordsByPatientId(patientId, 100));
                LOGGER.log(Level.INFO, "Retrieved " + records.size() + " records from MedicalRecordDAO");
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error using MedicalRecordDAO: " + e.getMessage());
            }

            // If we didn't get any records from MedicalRecordDAO, try PatientDAO
            if (records.isEmpty()) {
                try {
                    records.addAll(patientDAO.getRecentMedicalRecords(patientId, 100));
                    LOGGER.log(Level.INFO, "Retrieved " + records.size() + " records from PatientDAO");
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error using PatientDAO: " + e.getMessage());
                }
            }

            return records;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting medical records for patient ID: " + patientId, e);
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
