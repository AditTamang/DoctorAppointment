package com.doctorapp.controller.patient;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.model.Patient;
import com.doctorapp.model.User;
import com.doctorapp.service.PatientService;
import com.doctorapp.service.UserService;
import com.doctorapp.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet for handling patient profile operations
 */
@WebServlet(urlPatterns = {
    "/patient/profile",
    "/patient/profile/update"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class PatientProfileServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(PatientProfileServlet.class.getName());
    private static final long serialVersionUID = 1L;
    private PatientService patientService;
    private UserService userService;

    public void init() {
        patientService = new PatientService();
        userService = new UserService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/patient/profile":
                showPatientProfile(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/patient/profile/update":
                updatePatientProfile(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                break;
        }
    }

    /**
     * Show patient profile page
     */
    private void showPatientProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get patient details
        int patientId = patientService.getPatientIdByUserId(user.getId());
        Patient patient = patientService.getPatientById(patientId);

        if (patient == null) {
            // Create a new patient record if it doesn't exist
            patient = new Patient();
            patient.setUserId(user.getId());
            patient.setFirstName(user.getFirstName());
            patient.setLastName(user.getLastName());
            patient.setEmail(user.getEmail());
            patient.setPhone(user.getPhone());
            patient.setAddress(user.getAddress());

            // Save the new patient
            patientService.addPatient(patient);

            // Get the newly created patient
            patientId = patientService.getPatientIdByUserId(user.getId());
            patient = patientService.getPatientById(patientId);
        }

        // Set patient in both request and session for consistent access across all pages
        request.setAttribute("patient", patient);
        session.setAttribute("patient", patient);
        LOGGER.log(Level.INFO, "Patient object set in both request and session in showPatientProfile");

        // Always show the standard profile page
        request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
    }

    /**
     * Handle profile image upload separately
     */
    private void updateProfileImage(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Get patient information
            int patientId = patientService.getPatientIdByUserId(user.getId());
            Patient patient = patientService.getPatientById(patientId);

            if (patient == null) {
                // Create a new patient record instead of redirecting to avoid loops
                patient = new Patient();
                patient.setUserId(user.getId());
                patient.setFirstName(user.getFirstName());
                patient.setLastName(user.getLastName());
                patient.setEmail(user.getEmail());
                patient.setPhone(user.getPhone());
                patient.setAddress(user.getAddress());
                patient.setGender(user.getGender());
                patient.setDateOfBirth(user.getDateOfBirth());
                // Set default profile image
                patient.setProfileImage("/assets/images/patients/default.jpg");
            }

            // Check if image should be removed
            String removeImage = request.getParameter("removeImage");
            if (removeImage != null && removeImage.equals("true")) {
                // Set profile image to default
                patient.setProfileImage("/assets/images/patients/default.jpg");
                LOGGER.log(Level.INFO, "Image removed and set to default");

                boolean updated = patientService.updatePatient(patient);
                if (updated) {
                    session.setAttribute("successMessage", "Profile image removed successfully");
                } else {
                    session.setAttribute("errorMessage", "Failed to remove profile image");
                }

                response.sendRedirect(request.getContextPath() + "/patient/profile?view=dashboard");
                return;
            }

            // Check if the request is multipart
            boolean isMultipart = request.getContentType() != null &&
                                 request.getContentType().toLowerCase().startsWith("multipart/");

            if (!isMultipart) {
                session.setAttribute("errorMessage", "Invalid request type for image upload");
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            }

            // Get the profile image part
            Part filePart = request.getPart("profileImage");

            if (filePart == null || filePart.getSize() <= 0) {
                session.setAttribute("errorMessage", "No image file selected");
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            }

            // Get the file name
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Create the upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" +
                              File.separator + "images" + File.separator + "patients";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean dirCreated = uploadDir.mkdirs();
                LOGGER.log(Level.INFO, "Upload directory created: " + dirCreated);
                LOGGER.log(Level.INFO, "Upload directory path: " + uploadDir.getAbsolutePath());
            }

            // Generate a unique file name to prevent overwriting
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            String filePath = uploadPath + File.separator + uniqueFileName;

            // Save the file
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                LOGGER.log(Level.INFO, "File saved to: " + filePath);

                // Update the patient's profile image with correct path
                String imageUrl = "/assets/images/patients/" + uniqueFileName;
                patient.setProfileImage(imageUrl);
                LOGGER.log(Level.INFO, "Profile image set to: " + imageUrl);

                // Log the file details for debugging
                File savedFile = new File(filePath);
                LOGGER.log(Level.INFO, "File exists: " + savedFile.exists());
                LOGGER.log(Level.INFO, "File size: " + savedFile.length() + " bytes");
            }

            boolean updated = patientService.updatePatient(patient);
            if (updated) {
                // Update the patient in the session
                session.setAttribute("patient", patient);
                session.setAttribute("successMessage", "Profile image updated successfully");
                LOGGER.log(Level.INFO, "Profile image updated successfully and patient object refreshed in session");
            } else {
                session.setAttribute("errorMessage", "Failed to update profile image");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error handling image upload: " + e.getMessage(), e);
            session.setAttribute("errorMessage", "Error uploading image: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/patient/profile");
    }

    /**
     * Update patient profile
     */
    private void updatePatientProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Check if this is just a profile image update
        String updateType = request.getParameter("updateType");
        if (updateType != null && updateType.equals("profileImage")) {
            updateProfileImage(request, response, user);
            return;
        }

        // Get form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String allergies = request.getParameter("allergies");
        String medicalHistory = request.getParameter("medicalHistory");

        // Validate input
        boolean hasError = false;

        if (!ValidationUtil.isValidName(firstName)) {
            request.setAttribute("firstNameError", "Please enter a valid first name");
            hasError = true;
        }

        if (!ValidationUtil.isValidName(lastName)) {
            request.setAttribute("lastNameError", "Please enter a valid last name");
            hasError = true;
        }

        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Please enter a valid phone number");
            hasError = true;
        }

        if (hasError) {
            // Get patient details again
            int patientId = patientService.getPatientIdByUserId(user.getId());
            Patient patient = patientService.getPatientById(patientId);
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
            return;
        }

        // Update user information
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        user.setAddress(address);
        user.setDateOfBirth(dateOfBirth);
        user.setGender(gender);

        boolean userUpdated = userService.updateUser(user);

        // Update patient information
        int patientId = patientService.getPatientIdByUserId(user.getId());
        Patient patient = patientService.getPatientById(patientId);

        if (patient != null) {
            patient.setBloodGroup(bloodGroup);
            patient.setAllergies(allergies);
            patient.setMedicalHistory(medicalHistory);

            // Handle profile image upload
            try {
                // Check if the request is multipart
                boolean isMultipart = request.getContentType() != null &&
                                     request.getContentType().toLowerCase().startsWith("multipart/");

                if (isMultipart) {
                    // Get the profile image part
                    Part filePart = request.getPart("profileImage");

                    if (filePart != null && filePart.getSize() > 0) {
                        // Get the file name
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                        // Create the upload directory if it doesn't exist
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" +
                                          File.separator + "images" + File.separator + "patients";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            boolean dirCreated = uploadDir.mkdirs();
                            LOGGER.log(Level.INFO, "Upload directory created: " + dirCreated);
                            LOGGER.log(Level.INFO, "Upload directory path: " + uploadDir.getAbsolutePath());

                            // If directory creation failed, try to create parent directories
                            if (!dirCreated) {
                                File parentDir = uploadDir.getParentFile();
                                if (parentDir != null && !parentDir.exists()) {
                                    boolean parentDirCreated = parentDir.mkdirs();
                                    LOGGER.log(Level.INFO, "Parent directory created: " + parentDirCreated);

                                    // Try again to create the upload directory
                                    dirCreated = uploadDir.mkdirs();
                                    LOGGER.log(Level.INFO, "Second attempt to create upload directory: " + dirCreated);
                                }
                            }
                        }

                        // Log directory information
                        LOGGER.log(Level.INFO, "Upload directory exists: " + uploadDir.exists());
                        LOGGER.log(Level.INFO, "Upload directory is directory: " + uploadDir.isDirectory());
                        LOGGER.log(Level.INFO, "Upload directory can write: " + uploadDir.canWrite());

                        // Generate a unique file name to prevent overwriting
                        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                        String filePath = uploadPath + File.separator + uniqueFileName;

                        // Save the file
                        try (InputStream input = filePart.getInputStream()) {
                            Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                            LOGGER.log(Level.INFO, "File saved to: " + filePath);

                            // Update the patient's profile image with correct path
                            String imageUrl = "/assets/images/patients/" + uniqueFileName;
                            patient.setProfileImage(imageUrl);
                            LOGGER.log(Level.INFO, "Profile image set to: " + imageUrl);

                            // Log the file details for debugging
                            File savedFile = new File(filePath);
                            LOGGER.log(Level.INFO, "File exists: " + savedFile.exists());
                            LOGGER.log(Level.INFO, "File size: " + savedFile.length() + " bytes");

                            // Ensure the profile image is set in the patient object
                            if (patient.getProfileImage() == null || !patient.getProfileImage().equals(imageUrl)) {
                                LOGGER.log(Level.WARNING, "Profile image not set correctly, forcing it");
                                patient.setProfileImage(imageUrl);
                            }
                        }
                    }
                }

                // Check if image should be removed
                String removeImage = request.getParameter("removeImage");
                if (removeImage != null && removeImage.equals("true")) {
                    // Set profile image to default
                    patient.setProfileImage("/assets/images/patients/default.jpg");
                    LOGGER.log(Level.INFO, "Image removed and set to default");
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error handling image upload: " + e.getMessage(), e);
                // Continue with the update even if image handling fails
            }

            boolean patientUpdated = patientService.updatePatient(patient);

            if (userUpdated && patientUpdated) {
                // Update session with new user data
                session.setAttribute("user", user);

                // Update the patient in the session
                session.setAttribute("patient", patient);
                LOGGER.log(Level.INFO, "Patient object refreshed in session after profile update");

                // Use session attribute instead of request attribute for redirect
                session.setAttribute("successMessage", "Profile updated successfully");
                System.out.println("Profile updated successfully for user ID: " + user.getId());

                // Redirect instead of forward to avoid form resubmission
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            } else {
                // Use session attribute instead of request attribute for redirect
                session.setAttribute("errorMessage", "Failed to update profile. Please try again.");
                System.err.println("Failed to update profile for user ID: " + user.getId() +
                                  ". User update: " + userUpdated + ", Patient update: " + patientUpdated);

                // Redirect instead of forward to avoid form resubmission
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            }
        } else {
            // Create a new patient record if it doesn't exist
            patient = new Patient();
            patient.setUserId(user.getId());
            patient.setFirstName(user.getFirstName());
            patient.setLastName(user.getLastName());
            patient.setEmail(user.getEmail());
            patient.setPhone(user.getPhone());
            patient.setAddress(user.getAddress());
            patient.setBloodGroup(bloodGroup);
            patient.setAllergies(allergies);
            patient.setMedicalHistory(medicalHistory);

            // Set default profile image
            patient.setProfileImage("/assets/images/patients/default.jpg");

            // Handle profile image upload
            try {
                // Check if the request is multipart
                boolean isMultipart = request.getContentType() != null &&
                                     request.getContentType().toLowerCase().startsWith("multipart/");

                if (isMultipart) {
                    // Get the profile image part
                    Part filePart = request.getPart("profileImage");

                    if (filePart != null && filePart.getSize() > 0) {
                        // Get the file name
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                        // Create the upload directory if it doesn't exist
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" +
                                          File.separator + "images" + File.separator + "patients";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            boolean dirCreated = uploadDir.mkdirs();
                            LOGGER.log(Level.INFO, "Upload directory created for new patient: " + dirCreated);
                            LOGGER.log(Level.INFO, "Upload directory path: " + uploadDir.getAbsolutePath());

                            // If directory creation failed, try to create parent directories
                            if (!dirCreated) {
                                File parentDir = uploadDir.getParentFile();
                                if (parentDir != null && !parentDir.exists()) {
                                    boolean parentDirCreated = parentDir.mkdirs();
                                    LOGGER.log(Level.INFO, "Parent directory created: " + parentDirCreated);

                                    // Try again to create the upload directory
                                    dirCreated = uploadDir.mkdirs();
                                    LOGGER.log(Level.INFO, "Second attempt to create upload directory: " + dirCreated);
                                }
                            }
                        }

                        // Log directory information
                        LOGGER.log(Level.INFO, "Upload directory exists: " + uploadDir.exists());
                        LOGGER.log(Level.INFO, "Upload directory is directory: " + uploadDir.isDirectory());
                        LOGGER.log(Level.INFO, "Upload directory can write: " + uploadDir.canWrite());

                        // Generate a unique file name to prevent overwriting
                        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                        String filePath = uploadPath + File.separator + uniqueFileName;

                        // Save the file
                        try (InputStream input = filePart.getInputStream()) {
                            Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                            LOGGER.log(Level.INFO, "File saved to: " + filePath);

                            // Update the patient's profile image
                            String imageUrl = "/assets/images/patients/" + uniqueFileName;
                            patient.setProfileImage(imageUrl);
                            LOGGER.log(Level.INFO, "Profile image set to: " + imageUrl);
                        }
                    }
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error handling image upload for new patient: " + e.getMessage(), e);
                // Continue with the creation even if image handling fails
            }

            boolean patientAdded = patientService.addPatient(patient);

            if (userUpdated && patientAdded) {
                // Update session with new user data
                session.setAttribute("user", user);

                // Update the patient in the session
                session.setAttribute("patient", patient);
                LOGGER.log(Level.INFO, "Patient object added to session after profile creation");

                // Use session attribute instead of request attribute for redirect
                session.setAttribute("successMessage", "Profile created successfully");
                System.out.println("Profile created successfully for user ID: " + user.getId());

                // Redirect instead of forward to avoid form resubmission
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            } else {
                // Use session attribute instead of request attribute for redirect
                session.setAttribute("errorMessage", "Failed to create profile. Please try again.");
                System.err.println("Failed to create profile for user ID: " + user.getId() +
                                  ". User update: " + userUpdated + ", Patient add: " + patientAdded);

                // Redirect instead of forward to avoid form resubmission
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            }
        }
    }
}
