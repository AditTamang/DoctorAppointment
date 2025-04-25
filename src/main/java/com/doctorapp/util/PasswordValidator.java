package com.doctorapp.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utility class for validating password complexity
 */
public class PasswordValidator {
    
    /**
     * Validates if a password meets the complexity requirements:
     * - At least 8 characters long
     * - Contains at least one special character
     * - Contains at least one uppercase letter
     * - Contains at least one lowercase letter
     * - Contains at least one digit
     * 
     * @param password The password to validate
     * @return true if the password meets all requirements, false otherwise
     */
    public static boolean isValid(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        // Check for at least one special character
        Pattern specialCharPattern = Pattern.compile("[^a-zA-Z0-9]");
        Matcher specialCharMatcher = specialCharPattern.matcher(password);
        boolean hasSpecialChar = specialCharMatcher.find();
        
        // Check for at least one uppercase letter
        Pattern uppercasePattern = Pattern.compile("[A-Z]");
        Matcher uppercaseMatcher = uppercasePattern.matcher(password);
        boolean hasUppercase = uppercaseMatcher.find();
        
        // Check for at least one lowercase letter
        Pattern lowercasePattern = Pattern.compile("[a-z]");
        Matcher lowercaseMatcher = lowercasePattern.matcher(password);
        boolean hasLowercase = lowercaseMatcher.find();
        
        // Check for at least one digit
        Pattern digitPattern = Pattern.compile("[0-9]");
        Matcher digitMatcher = digitPattern.matcher(password);
        boolean hasDigit = digitMatcher.find();
        
        return hasSpecialChar && hasUppercase && hasLowercase && hasDigit;
    }
    
    /**
     * Gets a descriptive error message for password validation failures
     * 
     * @param password The password that failed validation
     * @return A descriptive error message
     */
    public static String getValidationErrorMessage(String password) {
        StringBuilder errorMessage = new StringBuilder("Password must:");
        
        if (password == null || password.length() < 8) {
            errorMessage.append(" be at least 8 characters long;");
        }
        
        // Check for special character
        Pattern specialCharPattern = Pattern.compile("[^a-zA-Z0-9]");
        Matcher specialCharMatcher = specialCharPattern.matcher(password);
        if (!specialCharMatcher.find()) {
            errorMessage.append(" contain at least one special character;");
        }
        
        // Check for uppercase
        Pattern uppercasePattern = Pattern.compile("[A-Z]");
        Matcher uppercaseMatcher = uppercasePattern.matcher(password);
        if (!uppercaseMatcher.find()) {
            errorMessage.append(" contain at least one uppercase letter;");
        }
        
        // Check for lowercase
        Pattern lowercasePattern = Pattern.compile("[a-z]");
        Matcher lowercaseMatcher = lowercasePattern.matcher(password);
        if (!lowercaseMatcher.find()) {
            errorMessage.append(" contain at least one lowercase letter;");
        }
        
        // Check for digit
        Pattern digitPattern = Pattern.compile("[0-9]");
        Matcher digitMatcher = digitPattern.matcher(password);
        if (!digitMatcher.find()) {
            errorMessage.append(" contain at least one digit;");
        }
        
        return errorMessage.toString();
    }
}
