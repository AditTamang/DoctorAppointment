package com.doctorapp.controller.admin;

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

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet for handling patient management operations by admin
 */
@WebServlet(urlPatterns = {
    "/admin/view-patient",
    "/admin/edit-patient",
    "/admin/update-patient",
    "/admin/delete-patient"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class AdminPatientManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminPatientManagementServlet.class.getName());

    private PatientService patientService;

    @Override
    public void init() {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Check if user is logged in and is an admin
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (!"ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
                return;
            }

            String action = request.getServletPath();
            LOGGER.log(Level.INFO, "Action: " + action);

            switch (action) {
                case "/admin/view-patient":
                    viewPatient(request, response);
                    break;
                case "/admin/edit-patient":
                    showEditForm(request, response);
                    break;
                case "/admin/delete-patient":
                    deletePatient(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/patients");
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AdminPatientManagementServlet.doGet", e);
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Check if user is logged in and is an admin
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (!"ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
                return;
            }

            String action = request.getServletPath();
            LOGGER.log(Level.INFO, "Action: " + action);

            switch (action) {
                case "/admin/update-patient":
                    updatePatient(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/patients");
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AdminPatientManagementServlet.doPost", e);
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    private void viewPatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Patient ID parameter is missing");
                request.getSession().setAttribute("errorMessage", "Patient ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                return;
            }

            int id = Integer.parseInt(idParam);
            LOGGER.log(Level.INFO, "Viewing patient with ID: " + id);

            Patient patient = patientService.getPatientById(id);

            if (patient == null) {
                LOGGER.log(Level.WARNING, "Patient not found with ID: " + id);
                request.getSession().setAttribute("errorMessage", "Patient not found");
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                return;
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/admin/view-patient.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid patient ID format: " + request.getParameter("id"), e);
            request.getSession().setAttribute("errorMessage", "Invalid patient ID format");
            response.sendRedirect(request.getContextPath() + "/admin/patients");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error viewing patient: " + e.getMessage(), e);
            request.getSession().setAttribute("errorMessage", "An error occurred while viewing the patient");
            response.sendRedirect(request.getContextPath() + "/admin/patients");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Patient ID parameter is missing");
                request.getSession().setAttribute("errorMessage", "Patient ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                return;
            }

            int id = Integer.parseInt(idParam);
            LOGGER.log(Level.INFO, "Showing edit form for patient with ID: " + id);

            Patient patient = patientService.getPatientById(id);

            if (patient == null) {
                LOGGER.log(Level.WARNING, "Patient not found with ID: " + id);
                request.getSession().setAttribute("errorMessage", "Patient not found");
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                return;
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/admin/edit-patient.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid patient ID format: " + request.getParameter("id"), e);
            request.getSession().setAttribute("errorMessage", "Invalid patient ID format");
            response.sendRedirect(request.getContextPath() + "/admin/patients");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error showing edit form: " + e.getMessage(), e);
            request.getSession().setAttribute("errorMessage", "An error occurred while preparing the edit form");
            response.sendRedirect(request.getContextPath() + "/admin/patients");
        }
    }

    private void updatePatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Patient ID parameter is missing");
                request.getSession().setAttribute("errorMessage", "Patient ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                return;
            }

            int id = Integer.parseInt(idParam);
            LOGGER.log(Level.INFO, "Updating patient with ID: " + id);

            Patient patient = patientService.getPatientById(id);

            if (patient == null) {
                LOGGER.log(Level.WARNING, "Patient not found with ID: " + id);
                request.getSession().setAttribute("errorMessage", "Patient not found");
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                return;
            }

            // Store original values for logging
            String originalFirstName = patient.getFirstName();
            String originalLastName = patient.getLastName();

            // Update patient information
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String bloodGroup = request.getParameter("bloodGroup");
            String allergies = request.getParameter("allergies");
            String medicalHistory = request.getParameter("medicalHistory");

            // Only update fields that are provided and not empty
            if (firstName != null && !firstName.trim().isEmpty()) {
                patient.setFirstName(firstName);
                LOGGER.log(Level.INFO, "Updating firstName from '" + originalFirstName + "' to '" + firstName + "'");
            }

            if (lastName != null && !lastName.trim().isEmpty()) {
                patient.setLastName(lastName);
                LOGGER.log(Level.INFO, "Updating lastName from '" + originalLastName + "' to '" + lastName + "'");
            }

            if (email != null && !email.trim().isEmpty()) {
                patient.setEmail(email);
                LOGGER.log(Level.INFO, "Updating email to '" + email + "'");
            }

            if (phone != null && !phone.trim().isEmpty()) {
                patient.setPhone(phone);
                LOGGER.log(Level.INFO, "Updating phone to '" + phone + "'");
            }

            if (address != null) { // Allow empty address
                patient.setAddress(address);
                LOGGER.log(Level.INFO, "Updating address to '" + address + "'");
            }

            if (gender != null && !gender.trim().isEmpty()) {
                patient.setGender(gender);
                LOGGER.log(Level.INFO, "Updating gender to '" + gender + "'");
            }

            if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                patient.setDateOfBirth(dateOfBirth);
                LOGGER.log(Level.INFO, "Updating dateOfBirth to '" + dateOfBirth + "'");
            }

            String ageStr = request.getParameter("age");
            if (ageStr != null && !ageStr.isEmpty()) {
                try {
                    int age = Integer.parseInt(ageStr);
                    // We don't directly set age as it's a calculated field from dateOfBirth
                    // But we can log it for debugging
                    LOGGER.log(Level.INFO, "Age parameter provided: " + age + ", but not directly set as it's calculated from dateOfBirth");
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid age format: " + ageStr, e);
                }
            }

            if (bloodGroup != null && !bloodGroup.trim().isEmpty()) {
                patient.setBloodGroup(bloodGroup);
                LOGGER.log(Level.INFO, "Updating bloodGroup to '" + bloodGroup + "'");
            }

            if (allergies != null) { // Allow empty allergies
                patient.setAllergies(allergies);
                LOGGER.log(Level.INFO, "Updating allergies to '" + allergies + "'");
            }

            if (medicalHistory != null) { // Allow empty medical history
                patient.setMedicalHistory(medicalHistory);
                LOGGER.log(Level.INFO, "Updating medicalHistory to '" + medicalHistory + "'");
            }

            // Handle profile image upload
            try {
                // Check if the request is multipart
                boolean isMultipart = request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/");
                LOGGER.log(Level.INFO, "Is multipart request: " + isMultipart);

                if (isMultipart) {
                    // Check for new image upload
                    Part filePart = request.getPart("profileImage");
                    LOGGER.log(Level.INFO, "File part: " + filePart);

                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = getSubmittedFileName(filePart);
                        LOGGER.log(Level.INFO, "File name: " + fileName);

                        if (fileName != null && !fileName.isEmpty()) {
                            // Create directory if it doesn't exist
                            String uploadPath = request.getServletContext().getRealPath("/assets/images/patients/");
                            LOGGER.log(Level.INFO, "Upload path: " + uploadPath);

                            // Make sure the directory exists
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                boolean created = uploadDir.mkdirs();
                                LOGGER.log(Level.INFO, "Directory created: " + created);
                            }

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

                                // Log the full path for debugging
                                LOGGER.log(Level.INFO, "Full image path: " + filePath);
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

            LOGGER.log(Level.INFO, "Patient data prepared for update: " +
                      "firstName=" + patient.getFirstName() +
                      ", lastName=" + patient.getLastName() +
                      ", bloodGroup=" + patient.getBloodGroup());

            boolean updated = patientService.updatePatient(patient);

            if (updated) {
                LOGGER.log(Level.INFO, "Patient updated successfully");
                request.getSession().setAttribute("successMessage", "Patient updated successfully");

                // Refresh patient data
                patient = patientService.getPatientById(id);
                if (patient != null) {
                    request.setAttribute("patient", patient);
                    request.getRequestDispatcher("/admin/view-patient.jsp").forward(request, response);
                } else {
                    LOGGER.log(Level.WARNING, "Could not retrieve updated patient data");
                    response.sendRedirect(request.getContextPath() + "/admin/patients");
                }
            } else {
                LOGGER.log(Level.WARNING, "Failed to update patient");
                request.getSession().setAttribute("errorMessage", "Failed to update patient");
                response.sendRedirect(request.getContextPath() + "/admin/patients");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid patient ID format: " + request.getParameter("id"), e);
            request.getSession().setAttribute("errorMessage", "Invalid patient ID format");
            response.sendRedirect(request.getContextPath() + "/admin/patients");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating patient: " + e.getMessage(), e);
            request.getSession().setAttribute("errorMessage", "An error occurred while updating the patient: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/patients");
        }
    }

    // Helper method to get the submitted file name from a Part
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }

    private void deletePatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Patient ID parameter is missing");
                request.getSession().setAttribute("errorMessage", "Patient ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                return;
            }

            int id = Integer.parseInt(idParam);
            LOGGER.log(Level.INFO, "Deleting patient with ID: " + id);

            // First check if the patient exists
            Patient patient = patientService.getPatientById(id);
            if (patient == null) {
                LOGGER.log(Level.WARNING, "Patient not found with ID: " + id);
                request.getSession().setAttribute("errorMessage", "Patient not found");
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                return;
            }

            // Log patient details before deletion for audit purposes
            LOGGER.log(Level.INFO, "Deleting patient: " + patient.getFirstName() + " " + patient.getLastName() +
                      " (ID: " + patient.getId() + ", User ID: " + patient.getUserId() + ")");

            boolean deleted = patientService.deletePatient(id);

            if (deleted) {
                LOGGER.log(Level.INFO, "Patient deleted successfully");
                request.getSession().setAttribute("successMessage", "Patient deleted successfully");
            } else {
                LOGGER.log(Level.WARNING, "Failed to delete patient");
                request.getSession().setAttribute("errorMessage", "Failed to delete patient");
            }

            response.sendRedirect(request.getContextPath() + "/admin/patients");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid patient ID format: " + request.getParameter("id"), e);
            request.getSession().setAttribute("errorMessage", "Invalid patient ID format");
            response.sendRedirect(request.getContextPath() + "/admin/patients");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting patient: " + e.getMessage(), e);
            request.getSession().setAttribute("errorMessage", "An error occurred while deleting the patient: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/patients");
        }
    }
}
