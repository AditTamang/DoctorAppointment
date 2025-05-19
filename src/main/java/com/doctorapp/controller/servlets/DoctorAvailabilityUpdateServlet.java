package com.doctorapp.controller.servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

import com.doctorapp.dao.DoctorAvailabilityDAO;
import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.User;
import com.doctorapp.util.JsonResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle doctor availability updates
 */
@WebServlet("/doctor/update-availability")
@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class DoctorAvailabilityUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final DoctorDAO doctorDAO;
    private final DoctorAvailabilityDAO availabilityDAO;

    public DoctorAvailabilityUpdateServlet() {
        super();
        doctorDAO = new DoctorDAO();
        availabilityDAO = new DoctorAvailabilityDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Check if user is logged in and is a doctor
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                JsonResponse.send(response, false, "You must be logged in to update availability");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (!"DOCTOR".equals(user.getRole())) {
                JsonResponse.send(response, false, "Only doctors can update availability");
                return;
            }

            // Get doctor information
            int userId = user.getId();
            int doctorId = doctorDAO.getDoctorIdByUserId(userId);

            if (doctorId == 0) {
                // Create a new doctor record if one doesn't exist
                doctorId = createNewDoctorRecord(user);

                if (doctorId == 0) {
                    JsonResponse.send(response, false, "Could not create doctor profile");
                    return;
                }
            }

            // Get availability data from request
            // Check if the request is multipart
            String availableDays;
            String availableTime;

            if (request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
                // Handle multipart form data
                jakarta.servlet.http.Part availableDaysPart = request.getPart("availableDays");
                jakarta.servlet.http.Part availableTimePart = request.getPart("availableTime");

                availableDays = readPartAsString(availableDaysPart);
                availableTime = readPartAsString(availableTimePart);
            } else {
                // Handle regular form data
                availableDays = request.getParameter("availableDays");
                availableTime = request.getParameter("availableTime");
            }

            System.out.println("Updating availability for doctor ID: " + doctorId);
            System.out.println("Available days: " + availableDays);
            System.out.println("Available time: " + availableTime);

            // Validate input
            if (availableDays == null || availableDays.isEmpty()) {
                JsonResponse.send(response, false, "Available days cannot be empty");
                return;
            }

            if (availableTime == null || availableTime.isEmpty()) {
                JsonResponse.send(response, false, "Available time cannot be empty");
                return;
            }

            // Update doctor availability
            boolean updated = availabilityDAO.updateDoctorAvailability(doctorId, availableDays, availableTime);

            if (updated) {
                // Update the doctor in session
                com.doctorapp.model.Doctor updatedDoctor = doctorDAO.getDoctorById(doctorId);
                if (updatedDoctor != null) {
                    session.setAttribute("doctor", updatedDoctor);
                    System.out.println("Updated doctor in session: " + updatedDoctor.getId());
                    System.out.println("Available days: " + updatedDoctor.getAvailableDays());
                    System.out.println("Available time: " + updatedDoctor.getAvailableTime());
                }

                JsonResponse.send(response, true, "Availability updated successfully");
            } else {
                JsonResponse.send(response, false, "Failed to update availability");
            }
        } catch (Exception e) {
            System.err.println("Error updating doctor availability: " + e.getMessage());
            JsonResponse.send(response, false, "An error occurred while updating availability");
        }
    }

    /**
     * Create a new doctor record for the user
     * @param user The user
     * @return The new doctor ID, or 0 if creation failed
     */
    private int createNewDoctorRecord(User user) {
        try {
            // Create a new doctor record
            com.doctorapp.model.Doctor newDoctor = new com.doctorapp.model.Doctor();
            newDoctor.setUserId(user.getId());
            newDoctor.setName("Dr. " + user.getFirstName() + " " + user.getLastName());
            newDoctor.setSpecialization("General Medicine");
            newDoctor.setQualification("MBBS");
            newDoctor.setExperience("0 years");
            newDoctor.setEmail(user.getEmail());
            newDoctor.setPhone(user.getPhone());
            newDoctor.setAddress(user.getAddress());
            newDoctor.setConsultationFee("1000");
            newDoctor.setAvailableDays("Monday,Tuesday,Wednesday,Thursday,Friday");
            newDoctor.setAvailableTime("09:00 AM - 05:00 PM");
            newDoctor.setStatus("ACTIVE");

            boolean added = doctorDAO.addDoctor(newDoctor);
            if (added) {
                return doctorDAO.getDoctorIdByUserId(user.getId());
            }
        } catch (Exception e) {
            System.err.println("Error creating doctor record: " + e.getMessage());
        }

        return 0;
    }

    /**
     * Read a Part as a String
     * @param part The Part to read
     * @return The Part content as a String, or null if the Part is null
     * @throws IOException If an I/O error occurs
     */
    private String readPartAsString(jakarta.servlet.http.Part part) throws IOException {
        if (part == null) {
            return null;
        }

        try (InputStream inputStream = part.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {

            StringBuilder content = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                content.append(line);
            }

            return content.toString();
        }
    }
}
