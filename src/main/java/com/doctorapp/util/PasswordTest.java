package com.doctorapp.util;

/**
 * Simple test class for the PasswordHasher
 * This can be removed after testing
 */
public class PasswordTest {
    public static void main(String[] args) {
        // Test password
        String password = "test123";
        
        // Test hashing
        System.out.println("Testing password hashing...");
        String hashedPassword = PasswordHasher.hashPassword(password);
        System.out.println("Hashed password: " + hashedPassword);
        
        // Test verification
        boolean verify = PasswordHasher.verifyPassword(password, hashedPassword);
        System.out.println("Verify password: " + verify);
        
        // Test with wrong password
        boolean wrongVerify = PasswordHasher.verifyPassword("wrongpassword", hashedPassword);
        System.out.println("Wrong password verify: " + wrongVerify);
        
        // Test backward compatibility with Base64
        System.out.println("\nTesting backward compatibility with Base64...");
        String base64Password = PasswordHasher.encodeBase64(password);
        System.out.println("Base64 password: " + base64Password);
        
        boolean base64Verify = PasswordHasher.verifyPassword(password, base64Password);
        System.out.println("Base64 verify: " + base64Verify);
        
        // Test backward compatibility with SHA-256
        System.out.println("\nTesting backward compatibility with SHA-256...");
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            String sha256Hash = java.util.Base64.getEncoder().encodeToString(hashedBytes);
            System.out.println("SHA-256 hash: " + sha256Hash);
            
            boolean sha256Verify = PasswordHasher.verifyPassword(password, sha256Hash);
            System.out.println("SHA-256 verify: " + sha256Verify);
        } catch (Exception e) {
            System.err.println("SHA-256 test failed: " + e.getMessage());
        }
    }
}
