<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.service.PatientService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get appointments from request
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");

    // Create date formatter
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patientDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-pages.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-confirmation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-confirm-fix.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-profile-image.css">
    <style>
        /* Fix for doctor initials */
        .doctor-small-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #4CAF50;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }

        .doctor-small-avatar .initials {
            color: white;
            font-size: 1.2rem;
            font-weight: 600;
            text-transform: uppercase;
        }
    </style>
</head>
<body data-context-path="${pageContext.request.contextPath}" class="patient-appointments">
    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="patient-sidebar.jsp">
            <jsp:param name="activePage" value="appointments" />
        </jsp:include>

        <!-- Main Content -->
        <div class="dashboard-main">
            <!-- Top Navigation -->
            <div class="dashboard-nav">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </div>

                <div class="nav-right">
                    <div class="nav-user">
                        <div class="user-image" data-default-image="/assets/images/patients/default.jpg" data-initials="<%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %>">
                            <%
                            // Get patient information from session or request
                            Patient patient = (Patient) session.getAttribute("patient");
                            // If patient is not in session, we'll just use initials

                            if (patient != null && patient.getProfileImage() != null && !patient.getProfileImage().isEmpty()) {
                            %>
                                <img src="${pageContext.request.contextPath}${patient.getProfileImage()}" alt="<%= user.getFirstName() %>"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/patients/default.jpg'">
                            <% } else { %>
                                <div class="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                            <% } %>
                        </div>
                        <div class="user-info">
                            <h4><%= user.getFirstName() + " " + user.getLastName() %></h4>
                            <p>Patient</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="content-header">
                    <h2>My Appointments</h2>
                    <a href="${pageContext.request.contextPath}/doctors" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Book New Appointment
                    </a>
                </div>

                <%
                // Display success message if present
                String message = request.getParameter("message");
                if (message != null) {
                    String alertClass = "success";
                    String alertMessage = "";

                    if ("rescheduled".equals(message)) {
                        alertMessage = "Your appointment has been successfully rescheduled.";
                    } else if ("cancelled".equals(message)) {
                        alertMessage = "Your appointment has been successfully cancelled.";
                    }

                    if (!alertMessage.isEmpty()) {
                %>
                <div class="alert alert-<%= alertClass %>" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 5px solid #4CAF50;">
                    <i class="fas fa-check-circle" style="margin-right: 10px;"></i> <%= alertMessage %>
                </div>
                <%
                    }
                }

                // Display error message if present
                String error = request.getParameter("error");
                if (error != null && !error.isEmpty()) {
                %>
                <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 5px solid #dc3545;">
                    <i class="fas fa-exclamation-circle" style="margin-right: 10px;"></i> <%= error %>
                </div>
                <% } %>

                <div class="appointment-tabs">
                    <button class="tab-button active" data-tab="all">
                        <i class="fas fa-calendar-alt"></i> All
                    </button>
                    <button class="tab-button" data-tab="upcoming">
                        <i class="fas fa-clock"></i> Upcoming
                    </button>
                    <button class="tab-button" data-tab="completed">
                        <i class="fas fa-check-circle"></i> Completed
                    </button>
                    <button class="tab-button" data-tab="cancelled">
                        <i class="fas fa-times-circle"></i> Cancelled
                    </button>
                </div>

                <div class="appointment-list">
                    <% if (appointments == null || appointments.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="fas fa-calendar-times"></i>
                            <h4>No appointments found</h4>
                            <p>You don't have any appointments yet. Book an appointment with a doctor to get started.</p>
                        </div>
                    <% } else { %>
                        <% for (Appointment appointment : appointments) { %>
                            <div class="appointment-card" data-status="<%= appointment.getStatus().toLowerCase() %>">
                                <div class="appointment-card-header">
                                    <div class="appointment-date">
                                        <%= appointment.getAppointmentDate() != null ? dateFormat.format(appointment.getAppointmentDate()) : "Date not set" %>
                                    </div>
                                    <div class="appointment-status">
                                        <span class="status-badge status-<%= appointment.getStatus().toLowerCase() %>">
                                            <%= appointment.getStatus() %>
                                        </span>
                                    </div>
                                </div>
                                <div class="appointment-card-body">
                                    <div class="appointment-doctor">
                                        <div class="doctor-small-avatar" data-default-image="/assets/images/doctors/default-doctor.png" data-initials="<%= appointment.getDoctorName() != null ? appointment.getDoctorName().charAt(0) : 'D' %>">
                                            <div class="profile-initials"><%= appointment.getDoctorName() != null ? appointment.getDoctorName().charAt(0) : 'D' %></div>
                                        </div>
                                        <div class="appointment-doctor-info">
                                            <div class="appointment-doctor-name"><%= appointment.getDoctorName() != null ? appointment.getDoctorName() : "Doctor" %></div>
                                            <div class="appointment-doctor-specialty">
                                                <%= appointment.getDoctorSpecialization() != null ? appointment.getDoctorSpecialization() : "Specialist" %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="appointment-time">
                                        <i class="far fa-clock"></i> <%= appointment.getAppointmentTime() %>
                                    </div>
                                    <% if (appointment.getReason() != null && !appointment.getReason().isEmpty()) { %>
                                        <div class="appointment-reason">
                                            <strong>Reason:</strong> <%= appointment.getReason() %>
                                        </div>
                                    <% } %>
                                </div>
                                <div class="appointment-card-footer">
                                    <div class="appointment-actions">
                                        <a href="${pageContext.request.contextPath}/appointment/details?id=<%= appointment.getId() %>" class="btn btn-sm btn-outline">
                                            <i class="fas fa-eye"></i> View Details
                                        </a>
                                        <% if ("PENDING".equals(appointment.getStatus()) || "APPROVED".equals(appointment.getStatus())) { %>
                                            <button class="btn btn-sm btn-danger cancel-appointment" data-id="<%= appointment.getId() %>">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div id="confirmationModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Cancel Appointment</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to cancel this appointment?</p>
                <p>This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button id="confirmCancel" class="btn btn-danger">Yes, Cancel</button>
                <button id="cancelAction" class="btn btn-outline">No, Keep It</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/profile-image-handler.js"></script>
    <script>
        // Initialize profile image handling
        document.addEventListener('DOMContentLoaded', function() {
            handleImageLoadErrors();
        });

        // Toggle sidebar on mobile
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
        });

        // Tab switching
        document.querySelectorAll('.tab-button').forEach(button => {
            button.addEventListener('click', function() {
                // Remove active class from all buttons
                document.querySelectorAll('.tab-button').forEach(btn => {
                    btn.classList.remove('active');
                });

                // Add active class to clicked button
                this.classList.add('active');

                // Get the tab value
                const tab = this.getAttribute('data-tab');

                // Show all cards if "all" tab is selected
                if (tab === 'all') {
                    document.querySelectorAll('.appointment-card').forEach(card => {
                        card.style.display = 'block';
                    });
                } else {
                    // Hide all cards
                    document.querySelectorAll('.appointment-card').forEach(card => {
                        card.style.display = 'none';
                    });

                    // Show only cards with matching status
                    document.querySelectorAll(`.appointment-card[data-status="${tab}"]`).forEach(card => {
                        card.style.display = 'block';
                    });
                }
            });
        });

        // Cancel appointment functionality
        const modal = document.getElementById('confirmationModal');
        const closeBtn = document.querySelector('.close');
        const cancelBtn = document.getElementById('cancelAction');
        const confirmBtn = document.getElementById('confirmCancel');
        let appointmentToCancel = null;

        // Open modal when cancel button is clicked
        document.querySelectorAll('.cancel-appointment').forEach(button => {
            button.addEventListener('click', function() {
                appointmentToCancel = this.getAttribute('data-id');
                modal.style.display = 'block';
            });
        });

        // Close modal when X is clicked
        closeBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });

        // Close modal when "No, Keep It" is clicked
        cancelBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });

        // Close modal when clicking outside of it
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });

        // Handle appointment cancellation
        confirmBtn.addEventListener('click', function() {
            if (appointmentToCancel) {
                // Send AJAX request to cancel appointment
                fetch('${pageContext.request.contextPath}/appointment/cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: 'id=' + appointmentToCancel
                })
                .then(response => {
                    if (response.ok) {
                        // Update UI to show appointment as cancelled
                        const appointmentCard = document.querySelector(`.appointment-card .cancel-appointment[data-id="${appointmentToCancel}"]`).closest('.appointment-card');

                        // Update status badge
                        const statusBadge = appointmentCard.querySelector('.status-badge');
                        statusBadge.className = 'status-badge status-cancelled';
                        statusBadge.textContent = 'CANCELLED';

                        // Update data-status attribute
                        appointmentCard.setAttribute('data-status', 'cancelled');

                        // Remove cancel button
                        appointmentCard.querySelector('.cancel-appointment').remove();

                        // Close modal
                        modal.style.display = 'none';

                        // Show success message
                        alert('Appointment cancelled successfully');
                    } else {
                        throw new Error('Failed to cancel appointment');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to cancel appointment. Please try again.');
                    modal.style.display = 'none';
                });
            }
        });
    </script>
</body>
</html>
