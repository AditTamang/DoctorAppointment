package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.model.MedicalRecord;
import com.doctorapp.util.DBConnection;

public class MedicalRecordDAO {
    private static final Logger LOGGER = Logger.getLogger(MedicalRecordDAO.class.getName());

    /**
     * Add a new medical record
     * @param medicalRecord The medical record to add
     * @return true if addition was successful, false otherwise
     */
    public boolean addMedicalRecord(MedicalRecord medicalRecord) {
        String query = "INSERT INTO medical_records (patient_id, doctor_id, record_date, diagnosis, treatment, notes) " +
                      "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, medicalRecord.getPatientId());
            pstmt.setInt(2, medicalRecord.getDoctorId());
            pstmt.setString(3, medicalRecord.getRecordDate());
            pstmt.setString(4, medicalRecord.getDiagnosis());
            pstmt.setString(5, medicalRecord.getTreatment());
            pstmt.setString(6, medicalRecord.getNotes());

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        medicalRecord.setId(generatedKeys.getInt(1));
                    }
                }
            }

            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error adding medical record", e);
            return false;
        }
    }

    /**
     * Get medical records by patient ID
     * @param patientId The patient ID
     * @param limit Maximum number of records to return
     * @return List of medical records
     */
    public List<MedicalRecord> getMedicalRecordsByPatientId(int patientId, int limit) {
        List<MedicalRecord> records = new ArrayList<>();
        String query = "SELECT mr.*, d.name as doctor_name " +
                      "FROM medical_records mr " +
                      "JOIN doctors d ON mr.doctor_id = d.id " +
                      "WHERE mr.patient_id = ? " +
                      "ORDER BY mr.record_date DESC " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setQueryTimeout(2); // Fast timeout for medical records
            pstmt.setInt(1, patientId);
            pstmt.setInt(2, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MedicalRecord record = new MedicalRecord();
                    record.setId(rs.getInt("id"));
                    record.setPatientId(rs.getInt("patient_id"));
                    record.setDoctorId(rs.getInt("doctor_id"));
                    record.setRecordDate(rs.getString("record_date"));
                    record.setDiagnosis(rs.getString("diagnosis"));
                    record.setTreatment(rs.getString("treatment"));
                    record.setNotes(rs.getString("notes"));
                    record.setDoctorName(rs.getString("doctor_name"));

                    records.add(record);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting medical records for patient ID: " + patientId, e);
        }

        return records;
    }

    /**
     * Get a medical record by ID
     * @param id The medical record ID
     * @return The medical record, or null if not found
     */
    public MedicalRecord getMedicalRecordById(int id) {
        String query = "SELECT mr.*, d.name as doctor_name " +
                      "FROM medical_records mr " +
                      "JOIN doctors d ON mr.doctor_id = d.id " +
                      "WHERE mr.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setQueryTimeout(2); // Fast timeout for single record lookup
            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    MedicalRecord record = new MedicalRecord();
                    record.setId(rs.getInt("id"));
                    record.setPatientId(rs.getInt("patient_id"));
                    record.setDoctorId(rs.getInt("doctor_id"));
                    record.setRecordDate(rs.getString("record_date"));
                    record.setDiagnosis(rs.getString("diagnosis"));
                    record.setTreatment(rs.getString("treatment"));
                    record.setNotes(rs.getString("notes"));
                    record.setDoctorName(rs.getString("doctor_name"));

                    return record;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting medical record by ID: " + id, e);
        }

        return null;
    }

    /**
     * Update a medical record
     * @param medicalRecord The medical record to update
     * @return true if update was successful, false otherwise
     */
    public boolean updateMedicalRecord(MedicalRecord medicalRecord) {
        String query = "UPDATE medical_records SET diagnosis = ?, treatment = ?, notes = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, medicalRecord.getDiagnosis());
            pstmt.setString(2, medicalRecord.getTreatment());
            pstmt.setString(3, medicalRecord.getNotes());
            pstmt.setInt(4, medicalRecord.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error updating medical record", e);
            return false;
        }
    }

    /**
     * Delete a medical record
     * @param id The medical record ID
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteMedicalRecord(int id) {
        String query = "DELETE FROM medical_records WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error deleting medical record", e);
            return false;
        }
    }
}
