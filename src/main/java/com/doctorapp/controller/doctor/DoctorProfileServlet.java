package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.DoctorService;
import com.doctorapp.service.UserService;
import com.doctorapp.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet for handling doctor profile operations
 */
@WebServlet(urlPatterns = {
    "/doctor/profile",
    "/doctor/profile/update",
    "/doctor/edit-profile"
})
@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class DoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;
    private UserService userService;

    public void init() {
        doctorService = new DoctorService();
        userService = new UserService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/doctor/profile":
                showDoctorProfile(request, response);
                break;
            case "/doctor/edit-profile":
                showEditProfileForm(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/doctor/profile/update":
                updateDoctorProfile(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                break;
        }
    }

    /**
     * Show doctor profile page
     */
    private void showDoctorProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get doctor details
        Doctor doctor = doctorService.getDoctorByUserId(user.getId());

        if (doctor == null) {
            // This should not happen for approved doctors
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Doctor profile not found");
            return;
        }

        // Check if there's a success message in the session
        if (request.getSession().getAttribute("successMessage") != null) {
            // Keep it in the session for the JSP to display
            System.out.println("Success message found in session: " + request.getSession().getAttribute("successMessage"));
        }

        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/doctor/profile.jsp").forward(request, response);
    }

    /**
     * Show edit profile form
     */
    private void showEditProfileForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get doctor details
        Doctor doctor = doctorService.getDoctorByUserId(user.getId());

        if (doctor == null) {
            // This should not happen for approved doctors
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Doctor profile not found");
            return;
        }

        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/doctor/edit-profile.jsp").forward(request, response);
    }

    /**
     * Update doctor profile
     */
    private void updateDoctorProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
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
        System.out.println("Form data received:");
        System.out.println("firstName: " + firstName);
        System.out.println("lastName: " + lastName);
        System.out.println("email: " + email);
        System.out.println("phone: " + phone);
        System.out.println("address: " + address);
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
            // Get doctor details again
            Doctor doctor = doctorService.getDoctorByUserId(user.getId());
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/doctor/edit-profile.jsp").forward(request, response);
            return;
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

        // Update doctor information
        Doctor doctor = doctorService.getDoctorByUserId(user.getId());

        if (doctor != null) {
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

            // Set status if provided
            if (status != null && !status.isEmpty()) {
                doctor.setStatus(status);
            }

            // Handle profile image upload or removal
            try {
                System.out.println("Starting image handling process");
                // Check if image should be removed
                String removeImage = request.getParameter("removeImage");
                if (removeImage != null && removeImage.equals("true")) {
                    // Set image URL to null or default
                    doctor.setImageUrl("");
                    System.out.println("Image removed");
                } else {
                    try {
                        System.out.println("Checking for file upload");
                        // Check if the request is multipart
                        boolean isMultipart = request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/");
                        System.out.println("Is multipart request: " + isMultipart);

                        if (!isMultipart) {
                            System.out.println("Not a multipart request, skipping file upload");
                        } else {
                            // Check for new image upload
                            Part filePart = null;
                            try {
                                filePart = request.getPart("profileImage");
                                System.out.println("File part: " + filePart);
                                System.out.println("File size: " + (filePart != null ? filePart.getSize() : "null"));
                            } catch (Exception e) {
                                System.err.println("Error getting part 'profileImage': " + e.getMessage());
                                e.printStackTrace();
                            }

                            if (filePart != null && filePart.getSize() > 0) {
                            String fileName = getSubmittedFileName(filePart);
                            System.out.println("File name: " + fileName);

                            if (fileName != null && !fileName.isEmpty()) {
                                // Create directory if it doesn't exist
                                String uploadPath = request.getServletContext().getRealPath("/assets/images/doctors/");
                                System.out.println("Upload path: " + uploadPath);

                                // Make sure the assets/images/doctors directory exists
                                File uploadDir = new File(uploadPath);
                                if (!uploadDir.exists()) {
                                    boolean created = uploadDir.mkdirs();
                                    System.out.println("Directory created: " + created);

                                    if (!created) {
                                        // Try to create parent directories one by one
                                        File assetsDir = new File(request.getServletContext().getRealPath("/assets/"));
                                        if (!assetsDir.exists()) {
                                            boolean assetsCreated = assetsDir.mkdir();
                                            System.out.println("Assets directory created: " + assetsCreated);
                                        }

                                        File imagesDir = new File(request.getServletContext().getRealPath("/assets/images/"));
                                        if (!imagesDir.exists()) {
                                            boolean imagesCreated = imagesDir.mkdir();
                                            System.out.println("Images directory created: " + imagesCreated);
                                        }

                                        // Try again to create the doctors directory
                                        boolean doctorsCreated = uploadDir.mkdir();
                                        System.out.println("Doctors directory created (second attempt): " + doctorsCreated);
                                    }
                                }

                                // Check if directory is writable
                                if (!uploadDir.canWrite()) {
                                    System.out.println("Warning: Upload directory is not writable: " + uploadPath);
                                    // Try to make it writable
                                    boolean madeWritable = uploadDir.setWritable(true, false);
                                    System.out.println("Made directory writable: " + madeWritable);
                                }

                                // Generate unique filename to avoid overwriting
                                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                                String filePath = uploadPath + File.separator + uniqueFileName;
                                System.out.println("File will be saved to: " + filePath);

                                // Save the file
                                try {
                                    filePart.write(filePath);
                                    System.out.println("File written successfully to: " + filePath);
                                } catch (Exception e) {
                                    System.err.println("Error writing file: " + e.getMessage());
                                    e.printStackTrace();

                                    // Try alternative method to save the file
                                    try {
                                        java.io.InputStream inputStream = filePart.getInputStream();
                                        java.io.FileOutputStream outputStream = new java.io.FileOutputStream(filePath);
                                        byte[] buffer = new byte[8192];
                                        int bytesRead;
                                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                                            outputStream.write(buffer, 0, bytesRead);
                                        }
                                        outputStream.close();
                                        inputStream.close();
                                        System.out.println("File saved using alternative method to: " + filePath);
                                    } catch (Exception ex) {
                                        System.err.println("Alternative file saving method failed: " + ex.getMessage());
                                        ex.printStackTrace();
                                    }
                                }

                                // Update the doctor's image URL
                                String imageUrl = "/assets/images/doctors/" + uniqueFileName;
                                doctor.setImageUrl(imageUrl);
                                System.out.println("Image uploaded to: " + filePath);
                                System.out.println("Image URL set to: " + imageUrl);
                            }
                            }
                        }
                    } catch (IllegalStateException e) {
                        System.err.println("IllegalStateException: " + e.getMessage());
                        e.printStackTrace();
                        request.setAttribute("errorMessage", "Error uploading image: No multi-part configuration provided. Please contact support.");
                    } catch (Exception e) {
                        System.err.println("Error processing image upload: " + e.getMessage());
                        e.printStackTrace();
                        request.setAttribute("errorMessage", "Error uploading image: " + e.getMessage());
                    }
                }
            } catch (Exception e) {
                System.err.println("Error handling image: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error handling image: " + e.getMessage());
                // Continue with the update even if image handling fails
            }

            System.out.println("Updating doctor with ID: " + doctor.getId());
            System.out.println("Doctor specialization: " + doctor.getSpecialization());
            System.out.println("Doctor qualification: " + doctor.getQualification());
            System.out.println("Doctor experience: " + doctor.getExperience());
            System.out.println("Doctor consultation fee: " + doctor.getConsultationFee());
            System.out.println("Doctor available days: " + doctor.getAvailableDays());
            System.out.println("Doctor available time: " + doctor.getAvailableTime());
            System.out.println("Doctor bio: " + doctor.getBio());
            System.out.println("Doctor image URL: " + doctor.getImageUrl());

            boolean doctorUpdated = doctorService.updateDoctor(doctor);
            System.out.println("Doctor update result: " + doctorUpdated);
            System.out.println("User update result: " + userUpdated);

            if (userUpdated && doctorUpdated) {
                // Update session with new user data
                session.setAttribute("user", user);

                // Set success message and redirect to profile page
                request.getSession().setAttribute("successMessage", "Profile updated successfully");
                response.sendRedirect(request.getContextPath() + "/doctor/profile");
                return;
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }
        } else {
            request.setAttribute("errorMessage", "Doctor record not found. Please contact support.");
        }

        // Refresh doctor data
        doctor = doctorService.getDoctorByUserId(user.getId());
        request.setAttribute("doctor", doctor);

        // Forward to edit-profile.jsp to show the success/error message
        request.getRequestDispatcher("/doctor/edit-profile.jsp").forward(request, response);
    }

    /**
     * Helper method to get the submitted filename from a Part
     */
    private String getSubmittedFileName(Part part) {
        if (part == null) {
            return null;
        }

        try {
            // First try the standard method (works in most servlet containers)
            String fileName = part.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                System.out.println("Got filename using getSubmittedFileName(): " + fileName);
                return cleanFileName(fileName);
            }
        } catch (Exception e) {
            System.out.println("getSubmittedFileName() not available: " + e.getMessage());
            // Continue with the fallback method
        }

        // Fallback method: parse the content-disposition header
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) {
            return null;
        }

        System.out.println("Content disposition: " + contentDisp);

        for (String cd : contentDisp.split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                String cleanFileName = cleanFileName(fileName);
                System.out.println("Extracted filename from header: " + cleanFileName);
                return cleanFileName;
            }
        }

        // If we still don't have a filename, generate one
        String generatedFileName = "image_" + System.currentTimeMillis() + ".jpg";
        System.out.println("Generated filename: " + generatedFileName);
        return generatedFileName;
    }

    /**
     * Helper method to clean a filename by removing path information
     */
    private String cleanFileName(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "image_" + System.currentTimeMillis() + ".jpg";
        }

        // Handle both Unix and Windows file paths
        String cleanFileName = fileName;
        if (fileName.contains("/")) {
            cleanFileName = fileName.substring(fileName.lastIndexOf('/') + 1);
        }
        if (cleanFileName.contains("\\")) {
            cleanFileName = cleanFileName.substring(cleanFileName.lastIndexOf('\\') + 1);
        }

        // Remove any invalid characters
        cleanFileName = cleanFileName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");

        // If filename is empty after cleaning, generate one
        if (cleanFileName.isEmpty()) {
            cleanFileName = "image_" + System.currentTimeMillis() + ".jpg";
        }

        return cleanFileName;
    }
}
