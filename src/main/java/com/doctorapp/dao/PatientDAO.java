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

import com.doctorapp.model.Patient;
import com.doctorapp.model.MedicalRecord;
import com.doctorapp.model.Prescription;
import com.doctorapp.util.DBConnection;

public class PatientDAO {
    private static final Logger LOGGER = Logger.getLogger(PatientDAO.class.getName());

    // Add a new patient
    public boolean addPatient(Patient patient) {
        // First check if a patient with this user_id already exists
        Patient existingPatient = getPatientByUserId(patient.getUserId());
        if (existingPatient != null) {
            // Patient already exists, update only the fields that are provided
            // and preserve existing data for fields that are not provided
            if (patient.getBloodGroup() == null || patient.getBloodGroup().isEmpty()) {
                patient.setBloodGroup(existingPatient.getBloodGroup());
            }
            if (patient.getAllergies() == null || patient.getAllergies().isEmpty()) {
                patient.setAllergies(existingPatient.getAllergies());
            }
            if (patient.getMedicalHistory() == null || patient.getMedicalHistory().isEmpty()) {
                patient.setMedicalHistory(existingPatient.getMedicalHistory());
            }

            // Set the existing patient ID to ensure we update the correct record
            patient.setId(existingPatient.getId());

            // Update the patient with preserved data
            return updatePatient(patient);
        }

        // Insert new patient
        String query = "INSERT INTO patients (user_id, blood_group, allergies, medical_history) " +
                      "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, patient.getUserId());
            pstmt.setString(2, patient.getBloodGroup());
            pstmt.setString(3, patient.getAllergies());
            pstmt.setString(4, patient.getMedicalHistory());

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        patient.setId(generatedKeys.getInt(1));
                    }
                }
            }

            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error adding patient", e);
            return false;
        }
    }

    // Get patient by user ID
    public Patient getPatientByUserId(int userId) {
        String query = "SELECT p.*, u.email FROM patients p JOIN users u ON p.user_id = u.id WHERE p.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFirstName(rs.getString("first_name"));
                    patient.setLastName(rs.getString("last_name"));
                    patient.setDateOfBirth(rs.getString("date_of_birth"));
                    patient.setGender(rs.getString("gender"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setAddress(rs.getString("address"));
                    patient.setBloodGroup(rs.getString("blood_group"));
                    patient.setAllergies(rs.getString("allergies"));
                    patient.setMedicalHistory(rs.getString("medical_history"));
                    patient.setEmail(rs.getString("email"));

                    return patient;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting patient by user ID: " + userId, e);
        }

        return null;
    }

    // Update patient
    public boolean updatePatient(Patient patient) {
        // Get the existing patient to preserve data that's not being updated
        Patient existingPatient = getPatientById(patient.getId());
        if (existingPatient == null) {
            LOGGER.log(Level.WARNING, "Patient not found with ID: " + patient.getId());
            return false;
        }

        // First update the user information in the users table
        String userQuery = "UPDATE users SET first_name = ?, last_name = ?, date_of_birth = ?, gender = ?, " +
                          "phone = ?, address = ? WHERE id = ?";

        // Then update the patient-specific information
        String patientQuery = "UPDATE patients SET blood_group = ?, allergies = ?, medical_history = ? " +
                             "WHERE id = ?";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // First update user information, only if the fields are provided
            try (PreparedStatement userStmt = conn.prepareStatement(userQuery)) {
                // Use provided values or existing values if not provided
                userStmt.setString(1,
                    (patient.getFirstName() != null && !patient.getFirstName().isEmpty()) ?
                    patient.getFirstName() : existingPatient.getFirstName());

                userStmt.setString(2,
                    (patient.getLastName() != null && !patient.getLastName().isEmpty()) ?
                    patient.getLastName() : existingPatient.getLastName());

                userStmt.setString(3,
                    (patient.getDateOfBirth() != null && !patient.getDateOfBirth().isEmpty()) ?
                    patient.getDateOfBirth() : existingPatient.getDateOfBirth());

                userStmt.setString(4,
                    (patient.getGender() != null && !patient.getGender().isEmpty()) ?
                    patient.getGender() : existingPatient.getGender());

                userStmt.setString(5,
                    (patient.getPhone() != null && !patient.getPhone().isEmpty()) ?
                    patient.getPhone() : existingPatient.getPhone());

                userStmt.setString(6,
                    (patient.getAddress() != null && !patient.getAddress().isEmpty()) ?
                    patient.getAddress() : existingPatient.getAddress());

                userStmt.setInt(7, patient.getUserId());

                userStmt.executeUpdate();
            }

            // Then update patient information, only if the fields are provided
            try (PreparedStatement patientStmt = conn.prepareStatement(patientQuery)) {
                patientStmt.setString(1,
                    (patient.getBloodGroup() != null && !patient.getBloodGroup().isEmpty()) ?
                    patient.getBloodGroup() : existingPatient.getBloodGroup());

                patientStmt.setString(2,
                    (patient.getAllergies() != null && !patient.getAllergies().isEmpty()) ?
                    patient.getAllergies() : existingPatient.getAllergies());

                patientStmt.setString(3,
                    (patient.getMedicalHistory() != null && !patient.getMedicalHistory().isEmpty()) ?
                    patient.getMedicalHistory() : existingPatient.getMedicalHistory());

                patientStmt.setInt(4, patient.getId());

                patientStmt.executeUpdate();
            }

            // Commit the transaction
            conn.commit();
            return true;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error updating patient", e);
            // Rollback the transaction on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            return false;
        } finally {
            // Restore auto-commit
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", closeEx);
                }
            }
        }
    }

    // Get total number of patients
    public int getTotalPatients() {
        String query = "SELECT COUNT(*) FROM patients";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting total patients count", e);
        }

        return 0;
    }

    // Get patient ID by user ID
    public int getPatientIdByUserId(int userId) {
        String query = "SELECT id FROM patients WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting patient ID by user ID: " + userId, e);
        }

        return 0;
    }

    // Get patient by ID
    public Patient getPatientById(int patientId) {
        String query = "SELECT p.*, u.email FROM patients p JOIN users u ON p.user_id = u.id WHERE p.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFirstName(rs.getString("first_name"));
                    patient.setLastName(rs.getString("last_name"));
                    patient.setDateOfBirth(rs.getString("date_of_birth"));
                    patient.setGender(rs.getString("gender"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setAddress(rs.getString("address"));
                    patient.setBloodGroup(rs.getString("blood_group"));
                    patient.setAllergies(rs.getString("allergies"));
                    patient.setEmail(rs.getString("email"));

                    return patient;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting patient by ID: " + patientId, e);
        }

        return null;
    }

    // Get recent patients by doctor
    public List<Patient> getRecentPatientsByDoctor(int doctorId, int limit) {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT DISTINCT p.*, u.email, MAX(a.appointment_date) as last_visit " +
                      "FROM patients p " +
                      "JOIN appointments a ON p.id = a.patient_id " +
                      "JOIN users u ON p.user_id = u.id " +
                      "WHERE a.doctor_id = ? " +
                      "GROUP BY p.id " +
                      "ORDER BY last_visit DESC " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, doctorId);
            pstmt.setInt(2, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFirstName(rs.getString("first_name"));
                    patient.setLastName(rs.getString("last_name"));
                    patient.setDateOfBirth(rs.getString("date_of_birth"));
                    patient.setGender(rs.getString("gender"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setAddress(rs.getString("address"));
                    patient.setBloodGroup(rs.getString("blood_group"));
                    patient.setAllergies(rs.getString("allergies"));
                    patient.setEmail(rs.getString("email"));
                    patient.setLastVisit(rs.getString("last_visit"));

                    patients.add(patient);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent patients by doctor ID: " + doctorId, e);
        }

        return patients;
    }

    // Get recent medical records
    public List<MedicalRecord> getRecentMedicalRecords(int patientId, int limit) {
        List<MedicalRecord> records = new ArrayList<>();
        String query = "SELECT mr.*, d.first_name as doctor_first_name, d.last_name as doctor_last_name " +
                      "FROM medical_records mr " +
                      "JOIN doctors d ON mr.doctor_id = d.id " +
                      "WHERE mr.patient_id = ? " +
                      "ORDER BY mr.record_date DESC " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

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
                    record.setRecordType(rs.getString("record_type"));
                    record.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));

                    records.add(record);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent medical records for patient ID: " + patientId, e);
        }

        return records;
    }

    // Get all patients
    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT p.*, u.first_name, u.last_name, u.email, u.phone, u.address, u.gender, u.date_of_birth, " +
                      "(SELECT MAX(a.appointment_date) FROM appointments a WHERE a.patient_id = p.id) as last_visit " +
                      "FROM patients p " +
                      "JOIN users u ON p.user_id = u.id " +
                      "ORDER BY p.id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Patient patient = new Patient();
                patient.setId(rs.getInt("id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFirstName(rs.getString("first_name"));
                patient.setLastName(rs.getString("last_name"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setAddress(rs.getString("address"));
                patient.setGender(rs.getString("gender"));
                patient.setDateOfBirth(rs.getString("date_of_birth"));
                patient.setBloodGroup(rs.getString("blood_group"));
                patient.setAllergies(rs.getString("allergies"));
                patient.setMedicalHistory(rs.getString("medical_history"));

                // Set last visit date if available
                java.sql.Date lastVisit = rs.getDate("last_visit");
                if (lastVisit != null) {
                    patient.setLastVisit(lastVisit.toString());
                }

                // Set status based on whether they have active appointments
                patient.setStatus("Active");

                patients.add(patient);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting all patients", e);
        }

        return patients;
    }

    // Delete a patient
    public boolean deletePatient(int id) {
        String query = "DELETE FROM patients WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error deleting patient with ID: " + id, e);
            return false;
        }
    }

    // Get recent patients
    public List<Patient> getRecentPatients(int limit) {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT p.*, u.first_name, u.last_name, u.email, u.phone, u.address, u.gender, u.date_of_birth, " +
                      "(SELECT MAX(a.appointment_date) FROM appointments a WHERE a.patient_id = p.id) as last_visit " +
                      "FROM patients p " +
                      "JOIN users u ON p.user_id = u.id " +
                      "ORDER BY p.id DESC " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFirstName(rs.getString("first_name"));
                    patient.setLastName(rs.getString("last_name"));
                    patient.setEmail(rs.getString("email"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setAddress(rs.getString("address"));
                    patient.setGender(rs.getString("gender"));
                    patient.setDateOfBirth(rs.getString("date_of_birth"));
                    patient.setBloodGroup(rs.getString("blood_group"));
                    patient.setAllergies(rs.getString("allergies"));
                    patient.setMedicalHistory(rs.getString("medical_history"));

                    // Set last visit date if available
                    java.sql.Date lastVisit = rs.getDate("last_visit");
                    if (lastVisit != null) {
                        patient.setLastVisit(lastVisit.toString());
                    }

                    // Set status based on whether they have active appointments
                    patient.setStatus("Active");

                    patients.add(patient);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent patients", e);
        }

        return patients;
    }

    // Get current prescriptions
    public List<Prescription> getCurrentPrescriptions(int patientId) {
        List<Prescription> prescriptions = new ArrayList<>();
        String query = "SELECT p.*, d.first_name as doctor_first_name, d.last_name as doctor_last_name " +
                      "FROM prescriptions p " +
                      "JOIN doctors d ON p.doctor_id = d.id " +
                      "WHERE p.patient_id = ? AND p.end_date >= CURRENT_DATE " +
                      "ORDER BY p.start_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Prescription prescription = new Prescription();
                    prescription.setId(rs.getInt("id"));
                    prescription.setPatientId(rs.getInt("patient_id"));
                    prescription.setDoctorId(rs.getInt("doctor_id"));
                    prescription.setMedicationName(rs.getString("medication_name"));
                    prescription.setDosage(rs.getString("dosage"));
                    prescription.setFrequency(rs.getString("frequency"));
                    prescription.setDuration(rs.getString("duration"));
                    prescription.setStartDate(rs.getString("start_date"));
                    prescription.setEndDate(rs.getString("end_date"));
                    prescription.setInstructions(rs.getString("instructions"));
                    prescription.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));

                    // Check if prescription is active
                    java.util.Date today = new java.util.Date();
                    java.util.Date endDate = rs.getDate("end_date");
                    prescription.setActive(endDate != null && endDate.after(today));

                    prescriptions.add(prescription);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting current prescriptions for patient ID: " + patientId, e);
        }

        return prescriptions;
    }
}
