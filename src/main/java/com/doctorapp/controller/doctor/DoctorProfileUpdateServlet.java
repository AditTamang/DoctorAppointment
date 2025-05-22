package com.doctorapp.controller.doctor;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.DoctorService;
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
 * Servlet for handling doctor profile update operations
 * This is the single implementation for all doctor profile updates
 */
@WebServlet(urlPatterns = {
    "/doctor/profile/update",
    "/doctor/update-profile-image"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class DoctorProfileUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;
    private UserService userService;

    @Override
    public void init() {
        doctorService = new DoctorService();
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get the action from the servlet path
        String action = request.getServletPath();

        // Handle different actions
        switch (action) {
            case "/doctor/update-profile-image":
                updateProfileImage(request, response, user);
                return;
            case "/doctor/profile/update":
                // Check if this is just a profile image update
                String updateType = request.getParameter("updateType");
                if (updateType != null && updateType.equals("profileImage")) {
                    updateProfileImage(request, response, user);
                    return;
                }
                break;
            default:
                // Continue with normal profile update
                break;
        }

        // Get form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String experience = request.getParameter("experience");
        String consultationFee = request.getParameter("consultationFee");
        String availableDays = request.getParameter("availableDays");
        String availableTime = request.getParameter("availableTime");
        String bio = request.getParameter("bio");
        String status = request.getParameter("status");

        // Debug form data
        System.out.println("Form data received in DoctorProfileUpdateServlet:");
        System.out.println("firstName: " + firstName);
        System.out.println("lastName: " + lastName);
        System.out.println("email: " + email);
        System.out.println("phone: " + phone);
        System.out.println("specialization: " + specialization);
        System.out.println("qualification: " + qualification);
        System.out.println("experience: " + experience);
        System.out.println("consultationFee: " + consultationFee);
        System.out.println("availableDays: " + availableDays);
        System.out.println("availableTime: " + availableTime);
        System.out.println("bio: " + bio);
        System.out.println("status: " + status);

        // Validate input
        boolean hasError = false;

        // Check for null values and provide defaults
        firstName = (firstName != null) ? firstName : user.getFirstName();
        lastName = (lastName != null) ? lastName : user.getLastName();
        email = (email != null) ? email : user.getEmail();
        phone = (phone != null) ? phone : user.getPhone();
        address = (address != null) ? address : user.getAddress();

        // Get doctor to retrieve existing values for doctor-specific fields
        Doctor doctor = doctorService.getDoctorByUserId(user.getId());
        if (doctor != null) {
            // Ensure doctor ID and user ID are set correctly
            if (doctor.getId() <= 0) {
                int doctorId = doctorService.getDoctorIdByUserId(user.getId());
                if (doctorId > 0) {
                    doctor.setId(doctorId);
                    System.out.println("Set doctor ID to: " + doctorId + " from user ID: " + user.getId());
                } else {
                    System.out.println("Warning: Could not find doctor ID for user ID: " + user.getId());
                }
            }

            // Make sure user ID is set
            doctor.setUserId(user.getId());

            // Use provided values or fall back to existing values
            specialization = (specialization != null) ? specialization : doctor.getSpecialization();
            qualification = (qualification != null) ? qualification : doctor.getQualification();
            experience = (experience != null) ? experience : doctor.getExperience();
            consultationFee = (consultationFee != null) ? consultationFee : doctor.getConsultationFee();
            availableDays = (availableDays != null) ? availableDays : doctor.getAvailableDays();
            availableTime = (availableTime != null) ? availableTime : doctor.getAvailableTime();
            bio = (bio != null) ? bio : doctor.getBio();
            status = (status != null) ? status : doctor.getStatus();
        }

        // Now validate with non-null values
        if (!ValidationUtil.isValidName(firstName)) {
            request.setAttribute("firstNameError", "Please enter a valid first name");
            hasError = true;
        }

        if (!ValidationUtil.isValidName(lastName)) {
            request.setAttribute("lastNameError", "Please enter a valid last name");
            hasError = true;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("emailError", "Please enter a valid email address");
            hasError = true;
        }

        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Please enter a valid phone number");
            hasError = true;
        }

        if (ValidationUtil.isNullOrEmpty(specialization)) {
            request.setAttribute("specializationError", "Please select a specialization");
            hasError = true;
        }

        if (ValidationUtil.isNullOrEmpty(qualification)) {
            request.setAttribute("qualificationError", "Please enter your qualification");
            hasError = true;
        }

        if (hasError) {
            // Check if this is an AJAX request
            String xRequestedWith = request.getHeader("X-Requested-With");
            boolean isAjaxRequest = "XMLHttpRequest".equals(xRequestedWith);

            if (isAjaxRequest) {
                // For AJAX requests, return JSON with validation errors
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                StringBuilder errorJson = new StringBuilder();
                errorJson.append("{");
                errorJson.append("\"success\":false,");
                errorJson.append("\"message\":\"Please correct the validation errors\",");
                errorJson.append("\"errors\":{");

                // Add all validation errors
                if (request.getAttribute("firstNameError") != null) {
                    errorJson.append("\"firstName\":\"").append(request.getAttribute("firstNameError")).append("\",");
                }
                if (request.getAttribute("lastNameError") != null) {
                    errorJson.append("\"lastName\":\"").append(request.getAttribute("lastNameError")).append("\",");
                }
                if (request.getAttribute("emailError") != null) {
                    errorJson.append("\"email\":\"").append(request.getAttribute("emailError")).append("\",");
                }
                if (request.getAttribute("phoneError") != null) {
                    errorJson.append("\"phone\":\"").append(request.getAttribute("phoneError")).append("\",");
                }
                if (request.getAttribute("specializationError") != null) {
                    errorJson.append("\"specialization\":\"").append(request.getAttribute("specializationError")).append("\",");
                }
                if (request.getAttribute("qualificationError") != null) {
                    errorJson.append("\"qualification\":\"").append(request.getAttribute("qualificationError")).append("\",");
                }

                // Add validation errors for other fields
                if (request.getAttribute("experienceError") != null) {
                    errorJson.append("\"experience\":\"").append(request.getAttribute("experienceError")).append("\",");
                }
                if (request.getAttribute("consultationFeeError") != null) {
                    errorJson.append("\"consultationFee\":\"").append(request.getAttribute("consultationFeeError")).append("\",");
                }
                if (request.getAttribute("availableDaysError") != null) {
                    errorJson.append("\"availableDays\":\"").append(request.getAttribute("availableDaysError")).append("\",");
                }
                if (request.getAttribute("availableTimeError") != null) {
                    errorJson.append("\"availableTime\":\"").append(request.getAttribute("availableTimeError")).append("\",");
                }
                if (request.getAttribute("addressError") != null) {
                    errorJson.append("\"address\":\"").append(request.getAttribute("addressError")).append("\",");
                }
                if (request.getAttribute("bioError") != null) {
                    errorJson.append("\"bio\":\"").append(request.getAttribute("bioError")).append("\",");
                }

                // Remove trailing comma if present
                String jsonStr = errorJson.toString();
                if (jsonStr.endsWith(",")) {
                    jsonStr = jsonStr.substring(0, jsonStr.length() - 1);
                }

                jsonStr += "}}";
                System.out.println("Sending validation error JSON: " + jsonStr);
                response.getWriter().write(jsonStr);
                return;
            } else {
                // For regular form submissions, forward to edit-profile.jsp with error attributes
                request.setAttribute("doctor", doctor);
                request.setAttribute("errorMessage", "Please correct the validation errors");
                request.getRequestDispatcher("/doctor/edit-profile.jsp").forward(request, response);
                return;
            }
        }

        // Update user information
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);

        // Update username to match first and last name
        String username = firstName + " " + lastName;
        user.setUsername(username);

        boolean userUpdated = userService.updateUser(user);
        System.out.println("User update result: " + userUpdated);

        if (doctor != null) {
            // Make sure doctor ID is set correctly
            if (doctor.getId() <= 0) {
                int doctorId = doctorService.getDoctorIdByUserId(user.getId());
                if (doctorId > 0) {
                    doctor.setId(doctorId);
                    System.out.println("Set doctor ID to: " + doctorId + " from user ID: " + user.getId());
                } else {
                    System.out.println("Warning: Could not find doctor ID for user ID: " + user.getId());
                }
            }

            // Make sure user ID is set
            doctor.setUserId(user.getId());

            // Set the doctor's name based on the user's first and last name
            String doctorName = "Dr. " + firstName + " " + lastName;
            doctor.setName(doctorName);

            // Set the doctor's email and phone from the user's information
            doctor.setEmail(user.getEmail());
            doctor.setPhone(user.getPhone());
            doctor.setAddress(user.getAddress());

            // Set the doctor's specialization and other fields
            doctor.setSpecialization(specialization);
            doctor.setQualification(qualification);
            doctor.setExperience(experience);
            doctor.setConsultationFee(consultationFee);
            doctor.setAvailableDays(availableDays);
            doctor.setAvailableTime(availableTime);
            doctor.setBio(bio);

            // Set status if provided, otherwise maintain current status
            if (status != null && !status.isEmpty()) {
                doctor.setStatus(status);
            } else {
                // Ensure status is not set to null
                if (doctor.getStatus() == null || doctor.getStatus().isEmpty()) {
                    doctor.setStatus("ACTIVE");
                }
            }

            // Log the doctor object before update
            System.out.println("Doctor object before update:");
            System.out.println("Doctor ID: " + doctor.getId());
            System.out.println("User ID: " + doctor.getUserId());
            System.out.println("Name: " + doctor.getName());
            System.out.println("Email: " + doctor.getEmail());
            System.out.println("Phone: " + doctor.getPhone());
            System.out.println("Specialization: " + doctor.getSpecialization());
            System.out.println("Qualification: " + doctor.getQualification());
            System.out.println("Experience: " + doctor.getExperience());
            System.out.println("Consultation Fee: " + doctor.getConsultationFee());
            System.out.println("Available Days: " + doctor.getAvailableDays());
            System.out.println("Available Time: " + doctor.getAvailableTime());
            System.out.println("Bio: " + doctor.getBio());

            // Handle profile image upload or removal
            try {
                System.out.println("Starting image handling process");
                // Check if image should be removed
                String removeImage = request.getParameter("removeImage");
                if (removeImage != null && removeImage.equals("true")) {
                    // Set image URL and profile image to default
                    doctor.setImageUrl("/assets/images/doctors/default-doctor.png");
                    doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
                    System.out.println("Image removed and set to default");
                } else {
                    try {
                        // Check for new image upload
                        Part filePart = request.getPart("profileImage");

                        if (filePart != null && filePart.getSize() > 0) {
                            String fileName = getSubmittedFileName(filePart);
                            System.out.println("File name: " + fileName);

                            if (fileName != null && !fileName.isEmpty()) {
                                // Create directory if it doesn't exist
                                String webappUploadPath = request.getServletContext().getRealPath("/assets/images/doctors/");
                                System.out.println("Webapp upload path: " + webappUploadPath);

                                // Make sure the webapp directory exists
                                File webappUploadDir = new File(webappUploadPath);
                                if (!webappUploadDir.exists()) {
                                    webappUploadDir.mkdirs();
                                }

                                // Generate unique filename to avoid overwriting
                                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                                String webappFilePath = webappUploadPath + File.separator + uniqueFileName;

                                // Save the file
                                filePart.write(webappFilePath);

                                // Update the doctor's image URL and profile image
                                String imageUrl = "/assets/images/doctors/" + uniqueFileName;
                                doctor.setImageUrl(imageUrl);
                                doctor.setProfileImage(imageUrl);
                                System.out.println("Image URL set to: " + imageUrl);
                            }
                        }
                    } catch (IOException e) {
                        System.err.println("Error processing image upload: " + e.getMessage());
                        request.setAttribute("errorMessage", "Error uploading image: " + e.getMessage());
                    } catch (Exception e) {
                        System.err.println("Unexpected error processing image upload: " + e.getMessage());
                        request.setAttribute("errorMessage", "Unexpected error uploading image");
                    }
                }
            } catch (Exception e) {
                System.err.println("Error handling image: " + e.getMessage());
                request.setAttribute("errorMessage", "Error processing image: " + e.getMessage());
            }

            boolean doctorUpdated = doctorService.updateDoctor(doctor);
            System.out.println("Doctor update result: " + doctorUpdated);
            System.out.println("User update result: " + userUpdated);

            if (userUpdated && doctorUpdated) {
                // Update session with new user data
                session.setAttribute("user", user);
                session.setAttribute("doctor", doctor);

                // Check if this is an AJAX request
                String xRequestedWith = request.getHeader("X-Requested-With");
                boolean isAjaxRequest = "XMLHttpRequest".equals(xRequestedWith);

                if (isAjaxRequest) {
                    // For AJAX requests, return JSON response with more details
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    // Create a more detailed JSON response
                    StringBuilder jsonResponse = new StringBuilder();
                    jsonResponse.append("{");
                    jsonResponse.append("\"success\":true,");
                    jsonResponse.append("\"message\":\"Profile updated successfully\",");
                    jsonResponse.append("\"name\":\"").append(doctor.getName()).append("\",");
                    jsonResponse.append("\"firstName\":\"").append(user.getFirstName()).append("\",");
                    jsonResponse.append("\"lastName\":\"").append(user.getLastName()).append("\",");
                    jsonResponse.append("\"email\":\"").append(doctor.getEmail()).append("\",");
                    jsonResponse.append("\"phone\":\"").append(doctor.getPhone() != null ? doctor.getPhone() : "").append("\",");
                    jsonResponse.append("\"specialization\":\"").append(doctor.getSpecialization() != null ? doctor.getSpecialization() : "").append("\",");
                    jsonResponse.append("\"qualification\":\"").append(doctor.getQualification() != null ? doctor.getQualification() : "").append("\",");
                    jsonResponse.append("\"experience\":\"").append(doctor.getExperience() != null ? doctor.getExperience() : "").append("\",");
                    jsonResponse.append("\"consultationFee\":\"").append(doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "").append("\",");
                    jsonResponse.append("\"availableDays\":\"").append(doctor.getAvailableDays() != null ? doctor.getAvailableDays() : "").append("\",");
                    jsonResponse.append("\"availableTime\":\"").append(doctor.getAvailableTime() != null ? doctor.getAvailableTime() : "").append("\",");
                    jsonResponse.append("\"address\":\"").append(doctor.getAddress() != null ? doctor.getAddress().replace("\"", "\\\"") : "").append("\",");
                    jsonResponse.append("\"bio\":\"").append(doctor.getBio() != null ? doctor.getBio().replace("\"", "\\\"").replace("\n", "\\n") : "").append("\",");
                    jsonResponse.append("\"profileImage\":\"").append(doctor.getProfileImage() != null ? doctor.getProfileImage() : "").append("\"");
                    jsonResponse.append("}");

                    response.getWriter().write(jsonResponse.toString());
                    return;
                } else {
                    // Set success message and redirect to edit profile page
                    session.setAttribute("successMessage", "Profile updated successfully");
                    response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
                    return;
                }
            } else {
                // Determine which update failed
                String errorMessage = "Failed to update profile. ";
                if (!userUpdated) {
                    errorMessage += "User information could not be saved. ";
                }
                if (!doctorUpdated) {
                    errorMessage += "Doctor information could not be saved. ";
                }
                errorMessage += "Please try again.";

                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    // AJAX error response with more details
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    StringBuilder errorJson = new StringBuilder();
                    errorJson.append("{");
                    errorJson.append("\"success\":false,");
                    errorJson.append("\"message\":\"").append(errorMessage).append("\",");
                    errorJson.append("\"error\":\"Database update failed\",");
                    errorJson.append("\"userUpdated\":").append(userUpdated).append(",");
                    errorJson.append("\"doctorUpdated\":").append(doctorUpdated);
                    errorJson.append("}");

                    response.getWriter().write(errorJson.toString());
                    return;
                } else {
                    request.setAttribute("errorMessage", errorMessage);
                    // Forward back to the edit form with the error message
                    request.setAttribute("doctor", doctor);
                    request.getRequestDispatcher("/doctor/edit-profile.jsp").forward(request, response);
                    return;
                }
            }
        } else {
            request.setAttribute("errorMessage", "Doctor record not found. Please contact support.");
        }

        // If we get here, there was an error
        doctor = doctorService.getDoctorByUserId(user.getId());
        request.setAttribute("doctor", doctor);

        // Check if this is an AJAX request
        String xRequestedWith = request.getHeader("X-Requested-With");
        boolean isAjaxRequest = "XMLHttpRequest".equals(xRequestedWith);

        if (isAjaxRequest) {
            // For AJAX requests, return JSON error response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            StringBuilder errorJson = new StringBuilder();
            errorJson.append("{");
            errorJson.append("\"success\":false,");
            errorJson.append("\"message\":\"").append(request.getAttribute("errorMessage")).append("\",");
            errorJson.append("\"error\":\"Doctor record not found\"");
            errorJson.append("}");

            response.getWriter().write(errorJson.toString());
        } else {
            // For regular requests, forward to edit-profile.jsp with error message
            request.getRequestDispatcher("/doctor/edit-profile.jsp").forward(request, response);
        }
    }

    /**
     * Helper method to get the submitted filename from a Part
     */
    private String getSubmittedFileName(Part part) {
        if (part == null) {
            return null;
        }

        try {
            String fileName = part.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                return fileName;
            }
        } catch (RuntimeException e) {
            System.err.println("Error getting submitted filename: " + e.getMessage());
            // Continue with the fallback method
        }

        // Fallback method: parse the content-disposition header
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) {
            return null;
        }

        for (String cd : contentDisp.split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName;
            }
        }

        // If we still don't have a filename, generate one
        return "image_" + System.currentTimeMillis() + ".jpg";
    }

    /**
     * Handle profile image upload separately
     */
    private void updateProfileImage(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if this is an AJAX request
        String xRequestedWith = request.getHeader("X-Requested-With");
        boolean isAjaxRequest = "XMLHttpRequest".equals(xRequestedWith);

        try {
            // Get doctor information
            Doctor doctor = doctorService.getDoctorByUserId(user.getId());

            if (doctor == null) {
                if (isAjaxRequest) {
                    sendJsonResponse(response, false, "Doctor record not found. Please complete your profile first.", null);
                    return;
                } else {
                    session.setAttribute("errorMessage", "Doctor record not found. Please complete your profile first.");
                    response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
                    return;
                }
            }

            // Check if image should be removed
            String removeImage = request.getParameter("removeImage");
            if (removeImage != null && removeImage.equals("true")) {
                // Set image URL and profile image to default
                doctor.setImageUrl("/assets/images/doctors/default-doctor.png");
                doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
                System.out.println("Image removed and set to default");

                boolean updated = doctorService.updateDoctor(doctor);
                if (updated) {
                    session.setAttribute("doctor", doctor);

                    if (isAjaxRequest) {
                        sendJsonResponse(response, true, "Profile image removed successfully", doctor);
                        return;
                    } else {
                        session.setAttribute("successMessage", "Profile image removed successfully");
                        response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
                        return;
                    }
                } else {
                    if (isAjaxRequest) {
                        sendJsonResponse(response, false, "Failed to remove profile image", null);
                        return;
                    } else {
                        session.setAttribute("errorMessage", "Failed to remove profile image");
                        response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
                        return;
                    }
                }
            }

            // Check if the request is multipart
            boolean isMultipart = request.getContentType() != null &&
                                 request.getContentType().toLowerCase().startsWith("multipart/");

            if (!isMultipart) {
                if (isAjaxRequest) {
                    sendJsonResponse(response, false, "Invalid request type for image upload", null);
                    return;
                } else {
                    session.setAttribute("errorMessage", "Invalid request type for image upload");
                    response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
                    return;
                }
            }

            // Get the profile image part
            Part filePart = request.getPart("profileImage");

            if (filePart == null || filePart.getSize() <= 0) {
                if (isAjaxRequest) {
                    sendJsonResponse(response, false, "No image file selected", null);
                    return;
                } else {
                    session.setAttribute("errorMessage", "No image file selected");
                    response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
                    return;
                }
            }

            // Get the file name
            String fileName = getSubmittedFileName(filePart);

            // Create the upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" +
                              File.separator + "images" + File.separator + "doctors";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean dirCreated = uploadDir.mkdirs();
                System.out.println("Upload directory created: " + dirCreated);
                System.out.println("Upload directory path: " + uploadDir.getAbsolutePath());
            }

            // Generate a unique file name to prevent overwriting
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadPath + File.separator + uniqueFileName;

            // Save the file using try-with-resources to ensure stream is closed
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                System.out.println("File saved to: " + filePath);

                // Verify file was saved successfully
                File savedFile = new File(filePath);
                if (savedFile.exists()) {
                    System.out.println("File exists: " + savedFile.exists());
                    System.out.println("File size: " + savedFile.length() + " bytes");
                } else {
                    throw new IOException("Failed to save file to: " + filePath);
                }
            }

            // Update the doctor's image URL and profile image
            String imageUrl = "/assets/images/doctors/" + uniqueFileName;
            doctor.setImageUrl(imageUrl);
            doctor.setProfileImage(imageUrl);
            System.out.println("Image URL set to: " + imageUrl);

            boolean updated = doctorService.updateDoctor(doctor);
            if (updated) {
                // Update the doctor in session
                session.setAttribute("doctor", doctor);

                if (isAjaxRequest) {
                    sendJsonResponse(response, true, "Profile image updated successfully", doctor);
                    return;
                } else {
                    session.setAttribute("successMessage", "Profile image updated successfully");
                    response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
                    return;
                }
            } else {
                if (isAjaxRequest) {
                    sendJsonResponse(response, false, "Failed to update profile image", null);
                    return;
                } else {
                    session.setAttribute("errorMessage", "Failed to update profile image");
                    response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
                    return;
                }
            }

        } catch (Exception e) {
            System.err.println("Error handling image upload: " + e.getMessage());
            e.printStackTrace();

            if (isAjaxRequest) {
                sendJsonResponse(response, false, "Error uploading image: " + e.getMessage(), null);
                return;
            } else {
                session.setAttribute("errorMessage", "Error uploading image: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
                return;
            }
        }
    }

    /**
     * Helper method to send JSON responses for AJAX requests
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Doctor doctor) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":").append(success).append(",");
        json.append("\"message\":\"").append(message).append("\"");

        if (doctor != null) {
            json.append(",\"name\":\"").append(doctor.getName()).append("\"");
            json.append(",\"email\":\"").append(doctor.getEmail() != null ? doctor.getEmail() : "").append("\"");
            json.append(",\"phone\":\"").append(doctor.getPhone() != null ? doctor.getPhone() : "").append("\"");
            json.append(",\"specialization\":\"").append(doctor.getSpecialization() != null ? doctor.getSpecialization() : "").append("\"");
            json.append(",\"profileImage\":\"").append(doctor.getProfileImage() != null ? doctor.getProfileImage() : "").append("\"");
        }

        json.append("}");
        response.getWriter().write(json.toString());
    }
}
