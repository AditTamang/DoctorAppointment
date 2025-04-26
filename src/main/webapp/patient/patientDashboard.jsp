<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get patient data from request attributes
    Patient patient = (Patient) request.getAttribute("patient");
    List<Appointment> upcomingAppointments = (List<Appointment>) request.getAttribute("upcomingAppointments");
    List<Appointment> pastAppointments = (List<Appointment>) request.getAttribute("pastAppointments");
    List<Appointment> cancelledAppointments = (List<Appointment>) request.getAttribute("cancelledAppointments");
    Integer totalVisits = (Integer) request.getAttribute("totalVisits");
    Integer upcomingVisitsCount = (Integer) request.getAttribute("upcomingVisitsCount");
    Integer totalDoctors = (Integer) request.getAttribute("totalDoctors");

    // Set default values if attributes are null
    if (totalVisits == null) totalVisits = 0;
    if (upcomingVisitsCount == null) upcomingVisitsCount = 0;
    if (totalDoctors == null) totalDoctors = 0;
    if (upcomingAppointments == null) upcomingAppointments = new java.util.ArrayList<>();
    if (pastAppointments == null) pastAppointments = new java.util.ArrayList<>();
    if (cancelledAppointments == null) cancelledAppointments = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patientDashboard.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="user-profile">
                <div class="profile-image">
                    <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                        <div class="profile-initials">AT</div>
                    <% } else { %>
                        <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="Patient">
                    <% } %>
                </div>
                <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
                <p class="user-email"><%= user.getEmail() %></p>
                <p class="user-phone"><%= user.getPhone() %></p>
            </div>

            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/patient/patientDashboard.jsp" class="active">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/appointments">
                        <i class="fas fa-calendar-check"></i>
                        <span>My Appointments</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctors">
                        <i class="fas fa-user-md"></i>
                        <span>Find Doctors</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/patient/medicalRecords.jsp">
                        <i class="fas fa-file-medical"></i>
                        <span>Medical Records</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/patient/profile.jsp">
                        <i class="fas fa-user"></i>
                        <span>My Profile</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/patient/changePassword.jsp">
                        <i class="fas fa-lock"></i>
                        <span>Change Password</span>
                    </a>
                </li>
            </ul>

            <div class="logout-btn">
                <a href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="dashboard-header">
                <div class="welcome-text">
                    <h2>Welcome, <%= user.getFirstName() %>!</h2>
                    <p>Here's an overview of your health appointments</p>
                </div>

                <a href="${pageContext.request.contextPath}/doctors" class="new-appointment-btn">
                    <i class="fas fa-plus"></i> New Appointment
                </a>
            </div>

            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-value"><%= totalVisits %></div>
                        <div class="stat-label">Total Visits</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-value"><%= upcomingVisitsCount %></div>
                        <div class="stat-label">Upcoming Visits</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-value"><%= totalDoctors %></div>
                        <div class="stat-label">Total Doctors</div>
                    </div>
                </div>
            </div>

            <!-- Appointment Section -->
            <div class="appointment-section">
                <h3>Latest Appointments</h3>

                <!-- Appointment Tabs -->
                <div class="appointment-tabs">
                    <button class="tab-button active" data-tab="upcoming">Upcoming</button>
                    <button class="tab-button" data-tab="past">Past</button>
                    <button class="tab-button" data-tab="cancelled">Cancelled</button>
                </div>

                <!-- Appointment Lists -->
                <div class="appointment-list" id="upcoming-appointments">
                    <% if (upcomingAppointments.isEmpty()) { %>
                        <div class="no-appointments">
                            <p>No upcoming appointments. <a href="${pageContext.request.contextPath}/doctors">Book an appointment</a> with a doctor.</p>
                        </div>
                    <% } else { %>
                        <% for (Appointment appointment : upcomingAppointments) { %>
                            <div class="appointment-card">
                                <div class="appointment-header">
                                    <div class="appointment-date">
                                        <div class="date-box">
                                            <%
                                                java.text.SimpleDateFormat monthFormat = new java.text.SimpleDateFormat("MMM");
                                                java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("dd");
                                                java.text.SimpleDateFormat yearFormat = new java.text.SimpleDateFormat("yyyy");
                                                String month = monthFormat.format(appointment.getAppointmentDate());
                                                String day = dayFormat.format(appointment.getAppointmentDate());
                                                String year = yearFormat.format(appointment.getAppointmentDate());
                                            %>
                                            <div class="month"><%= month.toUpperCase() %></div>
                                            <div class="day"><%= day %></div>
                                            <div class="year"><%= year %></div>
                                        </div>
                                        <div class="time"><%= appointment.getAppointmentTime() %></div>
                                    </div>
                                    <div class="appointment-status <%= appointment.getStatus().toLowerCase() %>">
                                        <%= appointment.getStatus() %>
                                    </div>
                                </div>
                                <div class="appointment-body">
                                    <div class="doctor-info">
                                        <div class="doctor-image">
                                            <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                                        </div>
                                        <div class="doctor-details">
                                            <h4><%= appointment.getDoctorName() %></h4>
                                            <p><%= appointment.getDoctorSpecialization() != null ? appointment.getDoctorSpecialization() : "Specialist" %></p>
                                        </div>
                                    </div>
                                    <div class="appointment-info">
                                        <div class="info-item">
                                            <i class="fas fa-stethoscope"></i>
                                            <span>Consultation</span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <span>In-Person</span>
                                        </div>
                                        <% if (appointment.getSymptoms() != null && !appointment.getSymptoms().isEmpty()) { %>
                                            <div class="info-item">
                                                <i class="fas fa-comment-medical"></i>
                                                <span><%= appointment.getSymptoms() %></span>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="appointment-actions">
                                        <a href="${pageContext.request.contextPath}/appointment/details?id=<%= appointment.getId() %>" class="action-btn reschedule-btn">
                                            <i class="fas fa-calendar-alt"></i> Reschedule
                                        </a>
                                        <a href="javascript:void(0);" onclick="confirmCancel(<%= appointment.getId() %>)" class="action-btn cancel-btn">
                                            <i class="fas fa-times"></i> Cancel
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>

                <div class="appointment-list" id="past-appointments" style="display: none;">
                    <% if (pastAppointments.isEmpty()) { %>
                        <div class="no-appointments">
                            <p>No past appointments found.</p>
                        </div>
                    <% } else { %>
                        <% for (Appointment appointment : pastAppointments) { %>
                            <div class="appointment-card">
                                <div class="appointment-header">
                                    <div class="appointment-date">
                                        <div class="date-box">
                                            <%
                                                java.text.SimpleDateFormat monthFormat = new java.text.SimpleDateFormat("MMM");
                                                java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("dd");
                                                java.text.SimpleDateFormat yearFormat = new java.text.SimpleDateFormat("yyyy");
                                                String month = monthFormat.format(appointment.getAppointmentDate());
                                                String day = dayFormat.format(appointment.getAppointmentDate());
                                                String year = yearFormat.format(appointment.getAppointmentDate());
                                            %>
                                            <div class="month"><%= month.toUpperCase() %></div>
                                            <div class="day"><%= day %></div>
                                            <div class="year"><%= year %></div>
                                        </div>
                                        <div class="time"><%= appointment.getAppointmentTime() %></div>
                                    </div>
                                    <div class="appointment-status completed">
                                        COMPLETED
                                    </div>
                                </div>
                                <div class="appointment-body">
                                    <div class="doctor-info">
                                        <div class="doctor-image">
                                            <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                                        </div>
                                        <div class="doctor-details">
                                            <h4><%= appointment.getDoctorName() %></h4>
                                            <p><%= appointment.getDoctorSpecialization() != null ? appointment.getDoctorSpecialization() : "Specialist" %></p>
                                        </div>
                                    </div>
                                    <div class="appointment-info">
                                        <div class="info-item">
                                            <i class="fas fa-stethoscope"></i>
                                            <span>Consultation</span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <span>In-Person</span>
                                        </div>
                                        <% if (appointment.getSymptoms() != null && !appointment.getSymptoms().isEmpty()) { %>
                                            <div class="info-item">
                                                <i class="fas fa-comment-medical"></i>
                                                <span><%= appointment.getSymptoms() %></span>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="appointment-actions">
                                        <a href="${pageContext.request.contextPath}/appointment/details?id=<%= appointment.getId() %>" class="action-btn reschedule-btn">
                                            <i class="fas fa-eye"></i> View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>

                <div class="appointment-list" id="cancelled-appointments" style="display: none;">
                    <% if (cancelledAppointments.isEmpty()) { %>
                        <div class="no-appointments">
                            <p>No cancelled appointments found.</p>
                        </div>
                    <% } else { %>
                        <% for (Appointment appointment : cancelledAppointments) { %>
                            <div class="appointment-card">
                                <div class="appointment-header">
                                    <div class="appointment-date">
                                        <div class="date-box">
                                            <%
                                                java.text.SimpleDateFormat monthFormat = new java.text.SimpleDateFormat("MMM");
                                                java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("dd");
                                                java.text.SimpleDateFormat yearFormat = new java.text.SimpleDateFormat("yyyy");
                                                String month = monthFormat.format(appointment.getAppointmentDate());
                                                String day = dayFormat.format(appointment.getAppointmentDate());
                                                String year = yearFormat.format(appointment.getAppointmentDate());
                                            %>
                                            <div class="month"><%= month.toUpperCase() %></div>
                                            <div class="day"><%= day %></div>
                                            <div class="year"><%= year %></div>
                                        </div>
                                        <div class="time"><%= appointment.getAppointmentTime() %></div>
                                    </div>
                                    <div class="appointment-status cancelled">
                                        CANCELLED
                                    </div>
                                </div>
                                <div class="appointment-body">
                                    <div class="doctor-info">
                                        <div class="doctor-image">
                                            <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                                        </div>
                                        <div class="doctor-details">
                                            <h4><%= appointment.getDoctorName() %></h4>
                                            <p><%= appointment.getDoctorSpecialization() != null ? appointment.getDoctorSpecialization() : "Specialist" %></p>
                                        </div>
                                    </div>
                                    <div class="appointment-info">
                                        <div class="info-item">
                                            <i class="fas fa-stethoscope"></i>
                                            <span>Consultation</span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <span>In-Person</span>
                                        </div>
                                        <% if (appointment.getSymptoms() != null && !appointment.getSymptoms().isEmpty()) { %>
                                            <div class="info-item">
                                                <i class="fas fa-comment-medical"></i>
                                                <span><%= appointment.getSymptoms() %></span>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="appointment-actions">
                                        <a href="${pageContext.request.contextPath}/doctors" class="action-btn reschedule-btn">
                                            <i class="fas fa-redo"></i> Book Again
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for Tab Switching -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching functionality
            const tabButtons = document.querySelectorAll('.tab-button');
            const appointmentLists = document.querySelectorAll('.appointment-list');

            tabButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons
                    tabButtons.forEach(btn => btn.classList.remove('active'));

                    // Add active class to clicked button
                    this.classList.add('active');

                    // Hide all appointment lists
                    appointmentLists.forEach(list => list.style.display = 'none');

                    // Show the selected appointment list
                    const tabId = this.getAttribute('data-tab');
                    document.getElementById(tabId + '-appointments').style.display = 'block';
                });
            });
        });

        // Function to confirm appointment cancellation
        function confirmCancel(appointmentId) {
            if (confirm('Are you sure you want to cancel this appointment?')) {
                window.location.href = '${pageContext.request.contextPath}/appointment/cancel?id=' + appointmentId;
            }
        }
    </script>
</body>
</html>
