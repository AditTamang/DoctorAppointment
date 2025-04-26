package com.doctorapp.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class PasswordHasher {

    // Hash a password with SHA-256
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    // Simple Base64 encoding for testing
    public static String encodeBase64(String input) {
        return Base64.getEncoder().encodeToString(input.getBytes());
    }

    // Verify a password against a stored hash
    public static boolean verifyPassword(String password, String storedHash) {
        // First try to match with SHA-256 hash
        String newHash = hashPassword(password);
        if (newHash.equals(storedHash)) {
            return true;
        }

        // If that fails, try simple Base64 encoding (for test accounts)
        String base64Password = encodeBase64(password);
        return base64Password.equals(storedHash);
    }
}
