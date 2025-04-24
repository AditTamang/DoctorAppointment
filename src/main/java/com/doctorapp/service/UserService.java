package com.doctorapp.service;

import com.doctorapp.dao.UserDAO;
import com.doctorapp.model.User;
import java.util.List;

/**
 * Service layer for User-related operations.
 * This class acts as an intermediary between controllers and DAOs.
 */
public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    /**
     * Check if an email already exists in the database
     * @param email The email to check
     * @return true if the email exists, false otherwise
     */
    public boolean emailExists(String email) {
        return userDAO.emailExists(email);
    }

    /**
     * Register a new user
     * @param user The user to register
     * @return true if registration was successful, false otherwise
     */
    public boolean registerUser(User user) {
        return userDAO.registerUser(user);
    }

    /**
     * Authenticate a user
     * @param email User's email
     * @param password User's password
     * @return User object if authentication is successful, null otherwise
     */
    public User login(String email, String password) {
        return userDAO.login(email, password);
    }

    /**
     * Get a user by email
     * @param email User's email
     * @return User object if found, null otherwise
     */
    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }

    /**
     * Get a user by ID
     * @param id User's ID
     * @return User object if found, null otherwise
     */
    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }

    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    /**
     * Update a user
     * @param user The user to update
     * @return true if update was successful, false otherwise
     */
    public boolean updateUser(User user) {
        return userDAO.updateUser(user);
    }

    /**
     * Save patient details for a user
     * @param userId User ID
     * @param dateOfBirth Date of birth
     * @param gender Gender
     * @param address Address
     * @param bloodGroup Blood group
     * @param allergies Allergies
     * @return true if save was successful, false otherwise
     */
    public boolean savePatientDetails(int userId, String dateOfBirth, String gender, String address, String bloodGroup, String allergies) {
        return userDAO.savePatientDetails(userId, dateOfBirth, gender, address, bloodGroup, allergies);
    }

    /**
     * Save doctor details for a user
     * @param userId User ID
     * @param specialization Specialization
     * @param qualification Qualification
     * @param experience Experience
     * @param address Address
     * @param bio Bio
     * @return true if save was successful, false otherwise
     */
    public boolean saveDoctorDetails(int userId, String specialization, String qualification, String experience, String address, String bio) {
        return userDAO.saveDoctorDetails(userId, specialization, qualification, experience, address, bio);
    }

    /**
     * Delete a user
     * @param id User ID
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteUser(int id) {
        return userDAO.deleteUser(id);
    }
}
