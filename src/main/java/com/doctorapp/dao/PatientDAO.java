package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.model.MedicalRecord;
import com.doctorapp.model.Patient;
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
        String query = "INSERT INTO patients (user_id, blood_group, allergies, medical_history, profile_image) " +
                      "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, patient.getUserId());
            pstmt.setString(2, patient.getBloodGroup());
            pstmt.setString(3, patient.getAllergies());
            pstmt.setString(4, patient.getMedicalHistory());
            pstmt.setString(5, patient.getProfileImage() != null ? patient.getProfileImage() : "/assets/images/patients/default.jpg");

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
        String query = "SELECT p.*, u.first_name, u.last_name, u.email, u.date_of_birth, u.gender, u.phone, u.address " +
                      "FROM patients p JOIN users u ON p.user_id = u.id WHERE p.user_id = ?";

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
        // Try different update approaches to handle different database schemas
        try {
            // First try the simple approach as it's more likely to work in most cases
            boolean result = updatePatientSimple(patient);
            if (result) {
                LOGGER.log(Level.INFO, "Successfully updated patient with simple approach");
                return true;
            }

            // If simple approach fails, try the join approach
            LOGGER.log(Level.INFO, "Simple approach didn't update any rows, trying join approach...");
            return updatePatientWithJoin(patient);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating patient: " + e.getMessage(), e);
            return false;
        }
    }

    // Update patient with join approach (for schema with separate users and patients tables)
    private boolean updatePatientWithJoin(Patient patient) {
        // Get the existing patient to preserve data that's not being updated
        Patient existingPatient = getPatientById(patient.getId());
        if (existingPatient == null) {
            LOGGER.log(Level.WARNING, "Patient not found with ID: " + patient.getId());
            return false;
        }

        LOGGER.log(Level.INFO, "Updating patient with ID: " + patient.getId() + " using join approach");

        // First update the user information in the users table
        String userQuery = "UPDATE users SET first_name = ?, last_name = ?, date_of_birth = ?, gender = ?, " +
                          "phone = ?, address = ?, username = ? WHERE id = ?";

        // Then update the patient-specific information
        String patientQuery = "UPDATE patients SET blood_group = ?, allergies = ?, medical_history = ?, profile_image = ? " +
                             "WHERE id = ?";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // First update user information, only if the fields are provided
            try (PreparedStatement userStmt = conn.prepareStatement(userQuery)) {
                // Use provided values or existing values if not provided
                String firstName = (patient.getFirstName() != null && !patient.getFirstName().isEmpty()) ?
                    patient.getFirstName() : existingPatient.getFirstName();
                userStmt.setString(1, firstName);

                String lastName = (patient.getLastName() != null && !patient.getLastName().isEmpty()) ?
                    patient.getLastName() : existingPatient.getLastName();
                userStmt.setString(2, lastName);

                // Handle date_of_birth (DATE type in database)
                if (patient.getDateOfBirth() != null && !patient.getDateOfBirth().isEmpty()) {
                    try {
                        // Try to parse the date in various formats
                        java.sql.Date sqlDate = null;
                        String dobStr = patient.getDateOfBirth().trim();

                        // Log the date string for debugging
                        LOGGER.log(Level.INFO, "Attempting to parse DOB: " + dobStr);

                        // Try yyyy-MM-dd format (SQL standard)
                        try {
                            sqlDate = java.sql.Date.valueOf(dobStr);
                        } catch (IllegalArgumentException e) {
                            LOGGER.log(Level.INFO, "Not in yyyy-MM-dd format, trying other formats");
                        }

                        // Try MM/dd/yyyy format
                        if (sqlDate == null && dobStr.matches("\\d{1,2}/\\d{1,2}/\\d{4}")) {
                            try {
                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy");
                                java.util.Date date = sdf.parse(dobStr);
                                sqlDate = new java.sql.Date(date.getTime());
                                LOGGER.log(Level.INFO, "Parsed as MM/dd/yyyy: " + sqlDate);
                            } catch (Exception e) {
                                LOGGER.log(Level.WARNING, "Error parsing MM/dd/yyyy: " + e.getMessage());
                            }
                        }

                        // Try dd/MM/yyyy format
                        if (sqlDate == null && dobStr.matches("\\d{1,2}/\\d{1,2}/\\d{4}")) {
                            try {
                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                java.util.Date date = sdf.parse(dobStr);
                                sqlDate = new java.sql.Date(date.getTime());
                                LOGGER.log(Level.INFO, "Parsed as dd/MM/yyyy: " + sqlDate);
                            } catch (Exception e) {
                                LOGGER.log(Level.WARNING, "Error parsing dd/MM/yyyy: " + e.getMessage());
                            }
                        }

                        // Try MMM dd, yyyy format (e.g., "Jan 31, 2000")
                        if (sqlDate == null) {
                            try {
                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy", java.util.Locale.ENGLISH);
                                java.util.Date date = sdf.parse(dobStr);
                                sqlDate = new java.sql.Date(date.getTime());
                                LOGGER.log(Level.INFO, "Parsed as MMM dd, yyyy: " + sqlDate);
                            } catch (Exception e) {
                                LOGGER.log(Level.WARNING, "Error parsing MMM dd, yyyy: " + e.getMessage());
                            }
                        }

                        if (sqlDate != null) {
                            userStmt.setDate(3, sqlDate);
                            LOGGER.log(Level.INFO, "Successfully set DOB to: " + sqlDate);
                        } else {
                            // If all parsing attempts fail, use existing value or null
                            LOGGER.log(Level.WARNING, "Could not parse date in any format: " + dobStr);
                            if (existingPatient.getDateOfBirth() != null && !existingPatient.getDateOfBirth().isEmpty()) {
                                try {
                                    sqlDate = java.sql.Date.valueOf(existingPatient.getDateOfBirth());
                                    userStmt.setDate(3, sqlDate);
                                    LOGGER.log(Level.INFO, "Using existing DOB: " + sqlDate);
                                } catch (IllegalArgumentException ex) {
                                    userStmt.setNull(3, java.sql.Types.DATE);
                                    LOGGER.log(Level.WARNING, "Existing DOB invalid, setting to NULL");
                                }
                            } else {
                                userStmt.setNull(3, java.sql.Types.DATE);
                                LOGGER.log(Level.WARNING, "No existing DOB, setting to NULL");
                            }
                        }
                    } catch (Exception e) {
                        // Catch-all for any unexpected errors
                        LOGGER.log(Level.SEVERE, "Unexpected error processing DOB: " + e.getMessage(), e);
                        userStmt.setNull(3, java.sql.Types.DATE);
                    }
                } else if (existingPatient.getDateOfBirth() != null && !existingPatient.getDateOfBirth().isEmpty()) {
                    try {
                        java.sql.Date sqlDate = java.sql.Date.valueOf(existingPatient.getDateOfBirth());
                        userStmt.setDate(3, sqlDate);
                        LOGGER.log(Level.INFO, "Using existing DOB (no new value provided): " + sqlDate);
                    } catch (IllegalArgumentException e) {
                        userStmt.setNull(3, java.sql.Types.DATE);
                        LOGGER.log(Level.WARNING, "Existing DOB invalid, setting to NULL");
                    }
                } else {
                    userStmt.setNull(3, java.sql.Types.DATE);
                    LOGGER.log(Level.INFO, "No DOB provided, setting to NULL");
                }

                userStmt.setString(4,
                    (patient.getGender() != null && !patient.getGender().isEmpty()) ?
                    patient.getGender() : existingPatient.getGender());

                userStmt.setString(5,
                    (patient.getPhone() != null && !patient.getPhone().isEmpty()) ?
                    patient.getPhone() : existingPatient.getPhone());

                userStmt.setString(6,
                    (patient.getAddress() != null) ? // Allow empty address
                    patient.getAddress() : existingPatient.getAddress());

                // Set username to first_name + last_name
                String username = firstName + " " + lastName;
                userStmt.setString(7, username);

                userStmt.setInt(8, patient.getUserId());

                int rowsAffected = userStmt.executeUpdate();
                LOGGER.log(Level.INFO, "Updated user information: " + rowsAffected + " rows affected");
            }

            // Then update patient information, only if the fields are provided
            try (PreparedStatement patientStmt = conn.prepareStatement(patientQuery)) {
                // Preserve existing values if new values are null
                String bloodGroup = patient.getBloodGroup();
                if (bloodGroup == null || bloodGroup.isEmpty()) {
                    bloodGroup = existingPatient.getBloodGroup();
                }
                patientStmt.setString(1, bloodGroup != null ? bloodGroup : "");
                // Update the patient object with the value that will be saved
                patient.setBloodGroup(bloodGroup);

                String allergies = patient.getAllergies();
                if (allergies == null) { // Allow empty allergies
                    allergies = existingPatient.getAllergies();
                }
                patientStmt.setString(2, allergies != null ? allergies : "");
                // Update the patient object with the value that will be saved
                patient.setAllergies(allergies);

                String medicalHistory = patient.getMedicalHistory();
                if (medicalHistory == null) { // Allow empty medical history
                    medicalHistory = existingPatient.getMedicalHistory();
                }
                patientStmt.setString(3, medicalHistory != null ? medicalHistory : "");
                // Update the patient object with the value that will be saved
                patient.setMedicalHistory(medicalHistory);

                // Handle profile image
                String profileImage = patient.getProfileImage();
                if (profileImage == null || profileImage.isEmpty()) {
                    profileImage = existingPatient.getProfileImage();
                    if (profileImage == null || profileImage.isEmpty()) {
                        profileImage = "/assets/images/patients/default.jpg";
                    }
                }
                patientStmt.setString(4, profileImage);
                // Update the patient object with the value that will be saved
                patient.setProfileImage(profileImage);

                patientStmt.setInt(5, patient.getId());

                int rowsAffected = patientStmt.executeUpdate();
                LOGGER.log(Level.INFO, "Updated patient information: " + rowsAffected + " rows affected");
            }

            // Commit the transaction
            conn.commit();
            LOGGER.log(Level.INFO, "Patient update committed successfully");

            // Log the updated patient information
            LOGGER.log(Level.INFO, "Updated patient information: " +
                      "ID=" + patient.getId() + ", " +
                      "UserID=" + patient.getUserId() + ", " +
                      "Name=" + patient.getFirstName() + " " + patient.getLastName() + ", " +
                      "BloodGroup=" + patient.getBloodGroup() + ", " +
                      "Allergies=" + patient.getAllergies() + ", " +
                      "MedicalHistory=" + patient.getMedicalHistory() + ", " +
                      "ProfileImage=" + patient.getProfileImage());

            return true;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error updating patient with join approach: " + e.getMessage(), e);
            // Rollback the transaction on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            throw new RuntimeException("Failed to update patient with join approach", e);
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

    // Update patient with simple approach (for schema with patients table only)
    private boolean updatePatientSimple(Patient patient) {
        // Get the existing patient to preserve data that's not being updated
        Patient existingPatient = getPatientById(patient.getId());
        if (existingPatient == null) {
            LOGGER.log(Level.WARNING, "Patient not found with ID: " + patient.getId());
            return false;
        }

        LOGGER.log(Level.INFO, "Updating patient with ID: " + patient.getId() + " using simple approach");

        Connection conn = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. First update the patients table
            StringBuilder patientQueryBuilder = new StringBuilder("UPDATE patients SET ");
            List<Object> patientParams = new ArrayList<>();

            // Update blood_group, allergies, medical_history, and profile_image fields
            patientQueryBuilder.append("blood_group = ?, allergies = ?, medical_history = ?, profile_image = ? ");

            // Preserve existing values if new values are null
            String bloodGroup = patient.getBloodGroup();
            if (bloodGroup == null && existingPatient != null) {
                bloodGroup = existingPatient.getBloodGroup();
            }
            patientParams.add(bloodGroup != null ? bloodGroup : "");

            String allergies = patient.getAllergies();
            if (allergies == null && existingPatient != null) {
                allergies = existingPatient.getAllergies();
            }
            patientParams.add(allergies != null ? allergies : "");

            String medicalHistory = patient.getMedicalHistory();
            if (medicalHistory == null && existingPatient != null) {
                medicalHistory = existingPatient.getMedicalHistory();
            }
            patientParams.add(medicalHistory != null ? medicalHistory : "");

            // Handle profile image
            String profileImage = patient.getProfileImage();
            if (profileImage == null || profileImage.isEmpty()) {
                profileImage = existingPatient.getProfileImage();
                if (profileImage == null || profileImage.isEmpty()) {
                    profileImage = "/assets/images/patients/default.jpg";
                }
            }
            patientParams.add(profileImage);

            // Add WHERE clause
            String patientQuery = patientQueryBuilder + "WHERE id = ?";
            patientParams.add(patient.getId());

            LOGGER.log(Level.INFO, "Patient ID: " + patient.getId());
            LOGGER.log(Level.INFO, "Blood Group: " + bloodGroup);
            LOGGER.log(Level.INFO, "Allergies: " + allergies);
            LOGGER.log(Level.INFO, "Medical History: " + medicalHistory);
            LOGGER.log(Level.INFO, "Profile Image: " + profileImage);

            LOGGER.log(Level.INFO, "Patient update query: " + patientQuery);

            try (PreparedStatement pstmt = conn.prepareStatement(patientQuery)) {
                // Set parameters
                for (int i = 0; i < patientParams.size(); i++) {
                    pstmt.setObject(i + 1, patientParams.get(i));
                }

                int rowsAffected = pstmt.executeUpdate();
                LOGGER.log(Level.INFO, "Updated patient table: " + rowsAffected + " rows affected");

                // Update the patient object with the values that were actually saved
                patient.setBloodGroup(bloodGroup);
                patient.setAllergies(allergies);
                patient.setMedicalHistory(medicalHistory);
                patient.setProfileImage(profileImage);
            }

            // 2. Now update the users table
            if (patient.getUserId() > 0) {
                String userQuery = "UPDATE users SET first_name = ?, last_name = ?, date_of_birth = ?, gender = ?, " +
                                  "phone = ?, address = ?, username = ? WHERE id = ?";

                try (PreparedStatement userStmt = conn.prepareStatement(userQuery)) {
                    // Use provided values or existing values if not provided
                    String firstName = (patient.getFirstName() != null && !patient.getFirstName().isEmpty()) ?
                        patient.getFirstName() : existingPatient.getFirstName();
                    userStmt.setString(1, firstName);

                    // Update the patient object with the value that will be saved
                    patient.setFirstName(firstName);

                    String lastName = (patient.getLastName() != null && !patient.getLastName().isEmpty()) ?
                        patient.getLastName() : existingPatient.getLastName();
                    userStmt.setString(2, lastName);

                    // Update the patient object with the value that will be saved
                    patient.setLastName(lastName);

                    // Handle date_of_birth (DATE type in database)
                    String dateOfBirth = patient.getDateOfBirth();
                    java.sql.Date sqlDate = null;

                    if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                        try {
                            sqlDate = java.sql.Date.valueOf(dateOfBirth);
                            userStmt.setDate(3, sqlDate);
                            LOGGER.log(Level.INFO, "Setting DOB to: " + sqlDate);
                        } catch (IllegalArgumentException e) {
                            // If date format is invalid, try to parse it in different formats
                            LOGGER.log(Level.WARNING, "Invalid date format: " + dateOfBirth + ", trying other formats");
                            try {
                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy");
                                java.util.Date date = sdf.parse(dateOfBirth);
                                sqlDate = new java.sql.Date(date.getTime());
                                userStmt.setDate(3, sqlDate);
                                LOGGER.log(Level.INFO, "Parsed DOB as MM/dd/yyyy: " + sqlDate);
                            } catch (Exception ex) {
                                // If still can't parse, use existing value or null
                                if (existingPatient.getDateOfBirth() != null && !existingPatient.getDateOfBirth().isEmpty()) {
                                    try {
                                        sqlDate = java.sql.Date.valueOf(existingPatient.getDateOfBirth());
                                        userStmt.setDate(3, sqlDate);
                                        dateOfBirth = existingPatient.getDateOfBirth();
                                        LOGGER.log(Level.INFO, "Using existing DOB: " + sqlDate);
                                    } catch (Exception exc) {
                                        userStmt.setNull(3, java.sql.Types.DATE);
                                        dateOfBirth = null;
                                        LOGGER.log(Level.WARNING, "Existing DOB invalid, setting to NULL");
                                    }
                                } else {
                                    userStmt.setNull(3, java.sql.Types.DATE);
                                    dateOfBirth = null;
                                    LOGGER.log(Level.WARNING, "No valid DOB, setting to NULL");
                                }
                            }
                        }
                    } else if (existingPatient.getDateOfBirth() != null && !existingPatient.getDateOfBirth().isEmpty()) {
                        try {
                            sqlDate = java.sql.Date.valueOf(existingPatient.getDateOfBirth());
                            userStmt.setDate(3, sqlDate);
                            dateOfBirth = existingPatient.getDateOfBirth();
                            LOGGER.log(Level.INFO, "Using existing DOB: " + sqlDate);
                        } catch (Exception e) {
                            userStmt.setNull(3, java.sql.Types.DATE);
                            dateOfBirth = null;
                            LOGGER.log(Level.WARNING, "Existing DOB invalid, setting to NULL");
                        }
                    } else {
                        userStmt.setNull(3, java.sql.Types.DATE);
                        dateOfBirth = null;
                        LOGGER.log(Level.INFO, "No DOB provided, setting to NULL");
                    }

                    // Update the patient object with the value that will be saved
                    patient.setDateOfBirth(dateOfBirth);

                    String gender = (patient.getGender() != null && !patient.getGender().isEmpty()) ?
                        patient.getGender() : existingPatient.getGender();
                    userStmt.setString(4, gender);
                    // Update the patient object with the value that will be saved
                    patient.setGender(gender);

                    String phone = (patient.getPhone() != null && !patient.getPhone().isEmpty()) ?
                        patient.getPhone() : existingPatient.getPhone();
                    userStmt.setString(5, phone);
                    // Update the patient object with the value that will be saved
                    patient.setPhone(phone);

                    String address = (patient.getAddress() != null) ? // Allow empty address
                        patient.getAddress() : existingPatient.getAddress();
                    userStmt.setString(6, address);
                    // Update the patient object with the value that will be saved
                    patient.setAddress(address);

                    // Set username to first_name + last_name
                    String username = firstName + " " + lastName;
                    userStmt.setString(7, username);

                    userStmt.setInt(8, patient.getUserId());

                    int rowsAffected = userStmt.executeUpdate();
                    LOGGER.log(Level.INFO, "Updated user table: " + rowsAffected + " rows affected");
                }
            } else {
                LOGGER.log(Level.WARNING, "No user ID found for patient ID: " + patient.getId() + ", skipping user update");
            }

            // Commit the transaction
            conn.commit();
            LOGGER.log(Level.INFO, "Patient update committed successfully");

            // Log the updated patient information
            LOGGER.log(Level.INFO, "Updated patient information: " +
                      "ID=" + patient.getId() + ", " +
                      "UserID=" + patient.getUserId() + ", " +
                      "Name=" + patient.getFirstName() + " " + patient.getLastName() + ", " +
                      "BloodGroup=" + patient.getBloodGroup() + ", " +
                      "Allergies=" + patient.getAllergies() + ", " +
                      "MedicalHistory=" + patient.getMedicalHistory() + ", " +
                      "ProfileImage=" + patient.getProfileImage());

            success = true;
            return true;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error updating patient with simple approach: " + e.getMessage(), e);
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
            // Restore auto-commit and close connection
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

    // Search for patients by name or email
    public List<Patient> searchPatients(String searchTerm) {
        // Try different query formats to handle different database schemas
        try {
            return searchPatientsWithJoin(searchTerm);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error searching patients with join query: " + e.getMessage());
            LOGGER.log(Level.INFO, "Trying alternative query format...");

            try {
                return searchPatientsSimple(searchTerm);
            } catch (Exception e2) {
                LOGGER.log(Level.SEVERE, "Error searching patients with simple query: " + e2.getMessage());
                return Collections.emptyList();
            }
        }
    }

    // Search for patients with join query (for schema with separate users and patients tables)
    private List<Patient> searchPatientsWithJoin(String searchTerm) {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT p.*, u.first_name, u.last_name, u.email, u.phone, u.address, u.gender, " +
                      "u.date_of_birth " +
                      "FROM patients p " +
                      "JOIN users u ON p.user_id = u.id " +
                      "WHERE u.first_name LIKE ? OR u.last_name LIKE ? OR u.email LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setBloodGroup(rs.getString("blood_group"));
                    patient.setAllergies(rs.getString("allergies"));
                    patient.setMedicalHistory(rs.getString("medical_history"));
                    patient.setFirstName(rs.getString("first_name"));
                    patient.setLastName(rs.getString("last_name"));
                    patient.setEmail(rs.getString("email"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setAddress(rs.getString("address"));
                    patient.setGender(rs.getString("gender"));

                    // Try to get profile image
                    try {
                        String profileImage = rs.getString("profile_image");
                        if (profileImage != null && !profileImage.isEmpty()) {
                            patient.setProfileImage(profileImage);
                        }
                    } catch (Exception e) {
                        // Ignore if profile_image is not available
                    }

                    // Try to get date_of_birth and calculate age
                    try {
                        String dateOfBirth = rs.getString("date_of_birth");
                        patient.setDateOfBirth(dateOfBirth);
                        // Age will be calculated by the getAge() method in Patient class
                    } catch (Exception e) {
                        // Ignore if date_of_birth is not available
                    }

                    patients.add(patient);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error searching for patients with join query: " + e.getMessage(), e);
            throw new RuntimeException("Failed to search patients with join query", e);
        }

        return patients;
    }

    // Search for patients with simple query (for schema with patients table only)
    private List<Patient> searchPatientsSimple(String searchTerm) {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT * FROM patients WHERE first_name LIKE ? OR last_name LIKE ? OR email LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));

                    // Try to get user_id if it exists
                    try {
                        patient.setUserId(rs.getInt("user_id"));
                    } catch (Exception e) {
                        // Ignore if user_id doesn't exist
                    }

                    // Try to get other fields if they exist
                    try { patient.setFirstName(rs.getString("first_name")); } catch (Exception e) {}
                    try { patient.setLastName(rs.getString("last_name")); } catch (Exception e) {}
                    try { patient.setEmail(rs.getString("email")); } catch (Exception e) {}
                    try { patient.setPhone(rs.getString("phone")); } catch (Exception e) {}
                    try { patient.setAddress(rs.getString("address")); } catch (Exception e) {}
                    try { patient.setGender(rs.getString("gender")); } catch (Exception e) {}
                    try { patient.setDateOfBirth(rs.getString("date_of_birth")); } catch (Exception e) {}
                    try { patient.setBloodGroup(rs.getString("blood_group")); } catch (Exception e) {}
                    try { patient.setAllergies(rs.getString("allergies")); } catch (Exception e) {}
                    try { patient.setMedicalHistory(rs.getString("medical_history")); } catch (Exception e) {}
                    try { patient.setProfileImage(rs.getString("profile_image")); } catch (Exception e) {}

                    // Set status
                    patient.setStatus("Active");

                    patients.add(patient);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error searching for patients with simple query: " + e.getMessage(), e);
            throw new RuntimeException("Failed to search patients with simple query", e);
        }

        return patients;
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
        // Try different query formats to handle different database schemas
        try {
            return getPatientByIdWithJoin(patientId);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting patient by ID with join query: " + e.getMessage());
            LOGGER.log(Level.INFO, "Trying alternative query format...");

            try {
                return getPatientByIdSimple(patientId);
            } catch (Exception e2) {
                LOGGER.log(Level.SEVERE, "Error getting patient by ID with simple query: " + e2.getMessage());
                return null;
            }
        }
    }

    // Get patient by ID with join query (for schema with separate users and patients tables)
    private Patient getPatientByIdWithJoin(int patientId) {
        String query = "SELECT p.*, u.first_name, u.last_name, u.email, u.date_of_birth, u.gender, u.phone, u.address " +
                      "FROM patients p JOIN users u ON p.user_id = u.id WHERE p.id = ?";

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

                    // Handle date_of_birth which might be in different formats
                    try {
                        patient.setDateOfBirth(rs.getString("date_of_birth"));
                    } catch (Exception e) {
                        // Ignore if date_of_birth is not available or in wrong format
                    }

                    patient.setGender(rs.getString("gender"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setAddress(rs.getString("address"));
                    patient.setBloodGroup(rs.getString("blood_group"));
                    patient.setAllergies(rs.getString("allergies"));
                    patient.setMedicalHistory(rs.getString("medical_history"));
                    patient.setEmail(rs.getString("email"));

                    // Get profile image if it exists
                    try {
                        String profileImage = rs.getString("profile_image");
                        if (profileImage != null && !profileImage.isEmpty()) {
                            patient.setProfileImage(profileImage);
                        }
                    } catch (Exception e) {
                        // Ignore if profile_image is not available
                    }

                    return patient;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting patient by ID with join query: " + e.getMessage(), e);
            throw new RuntimeException("Failed to get patient by ID with join query", e);
        }

        return null;
    }

    // Get patient by ID with simple query (for schema with patients table only)
    private Patient getPatientByIdSimple(int patientId) {
        String query = "SELECT * FROM patients WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));

                    // Try to get user_id if it exists
                    try {
                        patient.setUserId(rs.getInt("user_id"));
                    } catch (Exception e) {
                        // Ignore if user_id doesn't exist
                    }

                    // Try to get other fields if they exist
                    try { patient.setFirstName(rs.getString("first_name")); } catch (Exception e) {}
                    try { patient.setLastName(rs.getString("last_name")); } catch (Exception e) {}
                    try { patient.setEmail(rs.getString("email")); } catch (Exception e) {}
                    try { patient.setPhone(rs.getString("phone")); } catch (Exception e) {}
                    try { patient.setAddress(rs.getString("address")); } catch (Exception e) {}
                    try { patient.setGender(rs.getString("gender")); } catch (Exception e) {}
                    try { patient.setDateOfBirth(rs.getString("date_of_birth")); } catch (Exception e) {}
                    try { patient.setBloodGroup(rs.getString("blood_group")); } catch (Exception e) {}
                    try { patient.setAllergies(rs.getString("allergies")); } catch (Exception e) {}
                    try { patient.setMedicalHistory(rs.getString("medical_history")); } catch (Exception e) {}
                    try { patient.setProfileImage(rs.getString("profile_image")); } catch (Exception e) {}

                    // Set default values for missing fields
                    if (patient.getFirstName() == null) patient.setFirstName("Patient");
                    if (patient.getLastName() == null) patient.setLastName("#" + patient.getId());

                    return patient;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting patient by ID with simple query: " + e.getMessage(), e);
            throw new RuntimeException("Failed to get patient by ID with simple query", e);
        }

        return null;
    }

    // Get recent patients by doctor
    public List<Patient> getRecentPatientsByDoctor(int doctorId, int limit) {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT DISTINCT p.*, u.first_name, u.last_name, u.email, u.date_of_birth, u.gender, u.phone, u.address, " +
                      "MAX(a.appointment_date) as last_visit " +
                      "FROM patients p " +
                      "JOIN appointments a ON p.id = a.patient_id " +
                      "JOIN users u ON p.user_id = u.id " +
                      "WHERE a.doctor_id = ? " +
                      "GROUP BY p.id, u.first_name, u.last_name, u.email, u.date_of_birth, u.gender, u.phone, u.address " +
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

                    // Get user information from the users table
                    patient.setFirstName(rs.getString("first_name"));
                    patient.setLastName(rs.getString("last_name"));
                    patient.setDateOfBirth(rs.getString("date_of_birth"));
                    patient.setGender(rs.getString("gender"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setAddress(rs.getString("address"));

                    // Get patient-specific information
                    patient.setBloodGroup(rs.getString("blood_group"));
                    patient.setAllergies(rs.getString("allergies"));
                    patient.setEmail(rs.getString("email"));
                    patient.setLastVisit(rs.getString("last_visit"));

                    // Try to get profile image
                    try {
                        String profileImage = rs.getString("profile_image");
                        if (profileImage != null && !profileImage.isEmpty()) {
                            patient.setProfileImage(profileImage);
                        }
                    } catch (Exception e) {
                        // Ignore if profile_image is not available
                    }

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
        String query = "SELECT mr.*, d.name as doctor_name " +
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
                    record.setDoctorName(rs.getString("doctor_name"));

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

        // Try different query formats to handle different database schemas
        try {
            return getAllPatientsWithJoin();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting patients with join query: " + e.getMessage());
            LOGGER.log(Level.INFO, "Trying alternative query format...");

            try {
                return getAllPatientsSimple();
            } catch (Exception e2) {
                LOGGER.log(Level.SEVERE, "Error getting patients with simple query: " + e2.getMessage());
                return Collections.emptyList();
            }
        }
    }

    // Get all patients with join query (for schema with separate users and patients tables)
    private List<Patient> getAllPatientsWithJoin() {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT p.*, u.first_name, u.last_name, u.email, u.phone, u.address, u.gender, " +
                      "u.date_of_birth, (SELECT MAX(a.appointment_date) FROM appointments a " +
                      "WHERE a.patient_id = p.id) as last_visit " +
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

                // Handle date_of_birth which might be in different formats
                try {
                    patient.setDateOfBirth(rs.getString("date_of_birth"));
                } catch (Exception e) {
                    // Ignore if date_of_birth is not available or in wrong format
                }

                patient.setBloodGroup(rs.getString("blood_group"));
                patient.setAllergies(rs.getString("allergies"));
                patient.setMedicalHistory(rs.getString("medical_history"));

                // Set last visit date if available
                try {
                    java.sql.Date lastVisit = rs.getDate("last_visit");
                    if (lastVisit != null) {
                        patient.setLastVisit(lastVisit.toString());
                    }
                } catch (Exception e) {
                    // Ignore if last_visit is not available
                }

                // Set status based on whether they have active appointments
                patient.setStatus("Active");

                patients.add(patient);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting all patients with join query", e);
            throw new RuntimeException("Failed to get patients with join query", e);
        }

        return patients;
    }

    // Get all patients with simple query (for schema with patients table only)
    private List<Patient> getAllPatientsSimple() {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT * FROM patients ORDER BY id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Patient patient = new Patient();
                patient.setId(rs.getInt("id"));

                // Try to get user_id if it exists
                try {
                    patient.setUserId(rs.getInt("user_id"));
                } catch (Exception e) {
                    // Ignore if user_id doesn't exist
                }

                // Try to get first_name and last_name if they exist in patients table
                try {
                    patient.setFirstName(rs.getString("first_name"));
                    patient.setLastName(rs.getString("last_name"));
                } catch (Exception e) {
                    // If not available, set default values
                    patient.setFirstName("Patient");
                    patient.setLastName("#" + patient.getId());
                }

                // Try to get other fields if they exist
                try { patient.setEmail(rs.getString("email")); } catch (Exception e) {}
                try { patient.setPhone(rs.getString("phone")); } catch (Exception e) {}
                try { patient.setAddress(rs.getString("address")); } catch (Exception e) {}
                try { patient.setGender(rs.getString("gender")); } catch (Exception e) {}
                try { patient.setDateOfBirth(rs.getString("date_of_birth")); } catch (Exception e) {}
                try { patient.setBloodGroup(rs.getString("blood_group")); } catch (Exception e) {}
                try { patient.setAllergies(rs.getString("allergies")); } catch (Exception e) {}
                try { patient.setMedicalHistory(rs.getString("medical_history")); } catch (Exception e) {}

                // Set status
                patient.setStatus("Active");

                patients.add(patient);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting all patients with simple query", e);
            throw new RuntimeException("Failed to get patients with simple query", e);
        }

        return patients;
    }

    // Delete a patient
    public boolean deletePatient(int id) {
        LOGGER.log(Level.INFO, "Deleting patient with ID: " + id);

        // First get the patient to get the user_id
        Patient patient = getPatientById(id);
        if (patient == null) {
            LOGGER.log(Level.WARNING, "Patient not found with ID: " + id);
            return false;
        }

        int userId = patient.getUserId();
        LOGGER.log(Level.INFO, "Associated user ID: " + userId);

        Connection conn = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // First delete from patients table
            String patientQuery = "DELETE FROM patients WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(patientQuery)) {
                pstmt.setInt(1, id);
                int rowsAffected = pstmt.executeUpdate();
                LOGGER.log(Level.INFO, "Deleted from patients table: " + rowsAffected + " rows affected");

                if (rowsAffected == 0) {
                    // No rows deleted, rollback and return false
                    conn.rollback();
                    LOGGER.log(Level.WARNING, "No rows deleted from patients table");
                    return false;
                }
            }

            // Delete appointments associated with this patient
            String appointmentsQuery = "DELETE FROM appointments WHERE patient_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(appointmentsQuery)) {
                pstmt.setInt(1, id);
                int rowsAffected = pstmt.executeUpdate();
                LOGGER.log(Level.INFO, "Deleted from appointments table: " + rowsAffected + " rows affected");
            }

            // Delete medical records associated with this patient
            String medicalRecordsQuery = "DELETE FROM medical_records WHERE patient_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(medicalRecordsQuery)) {
                pstmt.setInt(1, id);
                int rowsAffected = pstmt.executeUpdate();
                LOGGER.log(Level.INFO, "Deleted from medical_records table: " + rowsAffected + " rows affected");
            }

            // Delete prescriptions associated with this patient
            String prescriptionsQuery = "DELETE FROM prescriptions WHERE patient_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(prescriptionsQuery)) {
                pstmt.setInt(1, id);
                int rowsAffected = pstmt.executeUpdate();
                LOGGER.log(Level.INFO, "Deleted from prescriptions table: " + rowsAffected + " rows affected");
            }

            // Finally, delete the user record if it exists and is not used by other entities
            if (userId > 0) {
                // Check if this user is also a doctor
                String checkDoctorQuery = "SELECT COUNT(*) FROM doctors WHERE user_id = ?";
                boolean isDoctor = false;

                try (PreparedStatement pstmt = conn.prepareStatement(checkDoctorQuery)) {
                    pstmt.setInt(1, userId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            isDoctor = true;
                        }
                    }
                }

                if (!isDoctor) {
                    // User is not a doctor, safe to delete
                    String userQuery = "DELETE FROM users WHERE id = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(userQuery)) {
                        pstmt.setInt(1, userId);
                        int rowsAffected = pstmt.executeUpdate();
                        LOGGER.log(Level.INFO, "Deleted from users table: " + rowsAffected + " rows affected");
                    }
                } else {
                    LOGGER.log(Level.INFO, "User is also a doctor, not deleting user record");
                }
            }

            // Commit the transaction
            conn.commit();
            LOGGER.log(Level.INFO, "Patient deletion committed successfully");
            success = true;
            return true;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error deleting patient with ID: " + id, e);
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
            // Restore auto-commit and close connection
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
        String query = "SELECT p.*, d.name as doctor_name " +
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
                    prescription.setDoctorName(rs.getString("doctor_name"));

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
