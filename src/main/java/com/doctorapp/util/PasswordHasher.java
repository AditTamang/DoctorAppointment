package com.doctorapp.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Simple password hashing utility
 */
public class PasswordHasher {

    // Use a secure random for salt generation
    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Hash a password using a simple BCrypt-like approach
     * @param password The password to hash
     * @return The hashed password
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }

        try {
            // Generate a random salt (16 bytes)
            byte[] salt = new byte[16];
            RANDOM.nextBytes(salt);

            // Combine password and salt, then hash with SHA-256
            String saltedPassword = password + Base64.getEncoder().encodeToString(salt);
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(saltedPassword.getBytes());

            // Format as BCrypt-like string for compatibility
            String hash = Base64.getEncoder().encodeToString(hashedBytes);
            String saltBase64 = Base64.getEncoder().encodeToString(salt);

            // Format: $bcrypt$salt$hash
            return "$bcrypt$" + saltBase64 + "$" + hash;
        } catch (NoSuchAlgorithmException e) {
            // Fall back to simple Base64 encoding if hashing fails
            System.err.println("Hashing failed, falling back to Base64: " + e.getMessage());
            return encodeBase64(password);
        }
    }

    /**
     * Simple Base64 encoding for backward compatibility
     * @param input The string to encode
     * @return Base64 encoded string
     */
    public static String encodeBase64(String input) {
        return Base64.getEncoder().encodeToString(input.getBytes());
    }

    /**
     * Verify a password against a stored hash
     * @param password The password to verify
     * @param storedHash The stored hash
     * @return true if the password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash) {
        if (password == null || storedHash == null) {
            return false;
        }

        try {
            // Check if it's our BCrypt-like format
            if (storedHash.startsWith("$bcrypt$")) {
                // Split the hash into parts
                String[] parts = storedHash.split("\\$");
                if (parts.length != 4) {
                    return false;
                }

                // Extract salt and hash
                String salt = parts[2];
                String hash = parts[3];

                // Recreate the hash with the same salt
                String saltedPassword = password + salt;
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hashedBytes = md.digest(saltedPassword.getBytes());
                String newHash = Base64.getEncoder().encodeToString(hashedBytes);

                // Compare the hashes
                return hash.equals(newHash);
            }

            // Try Base64 encoding for backward compatibility
            String base64Password = encodeBase64(password);
            if (base64Password.equals(storedHash)) {
                return true;
            }

            // Try SHA-256 for backward compatibility
            try {
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hashedPassword = md.digest(password.getBytes());
                String sha256Hash = Base64.getEncoder().encodeToString(hashedPassword);
                return sha256Hash.equals(storedHash);
            } catch (NoSuchAlgorithmException e) {
                System.err.println("SHA-256 verification failed: " + e.getMessage());
            }

            return false;
        } catch (Exception e) {
            System.err.println("Password verification failed: " + e.getMessage());
            return false;
        }
    }
}
