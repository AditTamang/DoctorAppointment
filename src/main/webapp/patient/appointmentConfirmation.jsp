<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.DoctorDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Confirmation | HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/appointment-confirmation.css">
</head>
<body>
    <%
        // Check if user is logged in
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get appointment from request or session
        Appointment appointment = (Appointment) request.getAttribute("appointment");
        if (appointment == null) {
            appointment = (Appointment) session.getAttribute("appointment");
            if (appointment == null) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                return;
            }
        }

        // Get doctor details - first try from request, then session, then database if not found
        Doctor doctor = (Doctor) request.getAttribute("doctor");
        if (doctor == null) {
            doctor = (Doctor) session.getAttribute("doctor");
            if (doctor == null) {
                DoctorDAO doctorDAO = new DoctorDAO();
                doctor = doctorDAO.getDoctorById(appointment.getDoctorId());
                if (doctor == null) {
                    System.out.println("Doctor not found for ID: " + appointment.getDoctorId());
                    response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                    return;
                }
            }
        }

        // Debug information
        System.out.println("Appointment confirmation page loaded with data:");
        System.out.println("Appointment ID: " + appointment.getId());
        System.out.println("Patient ID: " + appointment.getPatientId());
        System.out.println("Doctor ID: " + appointment.getDoctorId());
        System.out.println("Date: " + appointment.getAppointmentDate());
        System.out.println("Time: " + appointment.getAppointmentTime());
        System.out.println("Status: " + appointment.getStatus());

        // Format date
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MMMM dd, yyyy");
        String formattedDate = appointment.getAppointmentDate() != null ?
                              dateFormat.format(appointment.getAppointmentDate()) : "";
    %>

    <div class="container">
        <div class="confirmation-card">
            <div class="confirmation-header">
                <div class="confirmation-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h1 class="confirmation-title">Appointment Confirmed</h1>
                <p class="confirmation-subtitle">Your appointment has been successfully booked</p>
            </div>

            <div class="confirmation-body">
                <div class="confirmation-message">
                    <p>Thank you for booking an appointment with us. We have sent a confirmation email to your registered email address. Please arrive 15 minutes before your scheduled appointment time.</p>
                </div>

                <div class="appointment-details">
                    <div class="detail-item">
                        <div class="detail-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div class="detail-content">
                            <div class="detail-label">Date</div>
                            <div class="detail-value"><%= formattedDate %></div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="detail-content">
                            <div class="detail-label">Time</div>
                            <div class="detail-value"><%= appointment.getAppointmentTime() %></div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <i class="fas fa-tag"></i>
                        </div>
                        <div class="detail-content">
                            <div class="detail-label">Appointment ID</div>
                            <div class="detail-value">#<%= appointment.getId() %></div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <div class="detail-content">
                            <div class="detail-label">Status</div>
                            <div class="detail-value"><%= appointment.getStatus() %></div>
                        </div>
                    </div>
                </div>

                <div class="doctor-info">
                    <div class="doctor-avatar">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="doctor-details">
                        <h3 class="doctor-name">Dr. <%= doctor.getName() != null ? doctor.getName() : (doctor.getFirstName() + " " + doctor.getLastName()) %></h3>
                        <div class="doctor-specialization"><%= doctor.getSpecialization() %></div>
                        <div class="doctor-contact">
                            <i class="fas fa-phone"></i>
                            <%= doctor.getPhone() != null ? doctor.getPhone() : "Contact information not available" %>
                        </div>
                    </div>
                </div>

                <div class="instructions">
                    <h3>Important Instructions</h3>
                    <ul>
                        <li>Please arrive 15 minutes before your scheduled appointment time.</li>
                        <li>Bring your ID and insurance card (if applicable).</li>
                        <li>If you need to cancel or reschedule, please do so at least 24 hours in advance.</li>
                        <li>Wear a mask and follow all safety protocols during your visit.</li>
                        <li>If you have any symptoms like fever, cough, or shortness of breath, please call us before your appointment.</li>
                    </ul>
                </div>
            </div>

            <div class="confirmation-footer">
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-primary">Go to Dashboard</a>
                <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-secondary">View All Appointments</a>
            </div>
        </div>

        <div class="contact-support">
            <p>If you have any questions, please contact our support team at <a href="mailto:support@healthcare.com">support@healthcare.com</a> or call us at +1 (123) 456-7890.</p>
        </div>
    </div>
</body>
</html>
