<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Get the doctor and user objects from the session
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    User user = (User) session.getAttribute("user");

    // Get appointments
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("upcomingAppointments");

    // Get dashboard data with null checks
    Integer totalPatientsObj = (Integer) request.getAttribute("totalPatients");
    Integer weeklyAppointmentsObj = (Integer) request.getAttribute("weeklyAppointments");
    Double averageRatingObj = (Double) request.getAttribute("averageRating");
    Integer todayAppointmentsObj = (Integer) request.getAttribute("todayAppointments");

    // Set default values if null
    int totalPatients = (totalPatientsObj != null) ? totalPatientsObj : 0;
    int weeklyAppointments = (weeklyAppointmentsObj != null) ? weeklyAppointmentsObj : 0;
    double averageRating = (averageRatingObj != null) ? averageRatingObj : 0.0;
    int todayAppointments = (todayAppointmentsObj != null) ? todayAppointmentsObj : 0;

    // Get recent patients
    List<Patient> recentPatients = (List<Patient>) request.getAttribute("recentPatients");

    // Format date
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy");
    String currentDate = dateFormat.format(new Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard</title>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-profile-dashboard.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Profile Overview -->
            <div class="profile-overview">
                <div class="doctor-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/default-doctor.png" alt="Doctor Profile" class="profile-image">
                    <div class="profile-info">
                        <h2>Dr. ${user.firstName} ${user.lastName}</h2>
                        <p>${doctor.specialization}</p>
                        <p><i class="fas fa-graduation-cap"></i> ${doctor.qualification != null ? doctor.qualification : 'MBBS'}</p>
                        <p><i class="fas fa-envelope"></i> ${doctor.email}</p>
                        <p><i class="fas fa-phone"></i> ${doctor.phone != null ? doctor.phone : 'Not available'}</p>

                        <div class="profile-actions">
                            <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-primary">Edit Profile</a>
                            <a href="${pageContext.request.contextPath}/doctor/availability" class="btn btn-success">Set Availability</a>
                            <button id="toggle-status-btn" class="btn btn-outline">Set Active ${doctor.status == 'ACTIVE' ? 'Off' : 'On'}</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-icon primary">
                        <i class="fas fa-calendar-day"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-value"><%= todayAppointments %></div>
                        <div class="stat-label">Today's Appointments</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon success">
                        <i class="fas fa-calendar-week"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-value"><%= weeklyAppointments %></div>
                        <div class="stat-label">This Week's Total</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon warning">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-value"><%= totalPatients %></div>
                        <div class="stat-label">Total Patients</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon info">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-value"><%= String.format("%.1f", averageRating) %></div>
                        <div class="stat-label">Average Rating</div>
                    </div>
                </div>
            </div>

            <!-- Appointment Management -->
            <div class="appointment-management">
                <div class="section-header">
                    <h2>Appointment Management</h2>
                </div>

                <div class="tabs">
                    <div class="tab active">Upcoming</div>
                    <div class="tab">Past</div>
                    <div class="tab">Pending</div>
                </div>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Appointment ID</th>
                                <th>Patient Name</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Assigned Doctor</th>
                                <th>Action</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(appointments != null && !appointments.isEmpty()) {
                                for(Appointment appointment : appointments) {
                                    String appointmentId = String.valueOf(appointment.getId());
                                    String patientName = appointment.getPatientName() != null ? appointment.getPatientName() : "Unknown";

                                    // Use the getFormattedDate method to safely convert Date to String
                                    String appointmentDate = "Not set";
                                    if (appointment.getAppointmentDate() != null) {
                                        try {
                                            String formattedDate = appointment.getFormattedDate();
                                            if (formattedDate != null && !formattedDate.isEmpty()) {
                                                appointmentDate = formattedDate;
                                            }
                                        } catch (Exception e) {
                                            System.err.println("Error formatting appointment date: " + e.getMessage());
                                        }
                                    }

                                    String status = appointment.getStatus() != null ? appointment.getStatus() : "Pending";
                                    String statusClass = status.toLowerCase();
                                    String notes = appointment.getNotes() != null ? appointment.getNotes() : "No notes";
                            %>
                            <tr>
                                <td><%= appointmentId %></td>
                                <td><%= patientName %></td>
                                <td><%= appointmentDate %></td>
                                <td><span class="status <%= statusClass %>"><%= status %></span></td>
                                <td>
                                    <img src="${pageContext.request.contextPath}/assets/images/default-doctor.png" alt="Doctor" style="width: 30px; height: 30px; border-radius: 50%;">
                                </td>
                                <td>
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/doctor/appointment-details?id=<%= appointment.getId() %>" class="action-btn view"><i class="fas fa-eye"></i></a>
                                        <a href="${pageContext.request.contextPath}/doctor/edit-appointment?id=<%= appointment.getId() %>" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                    </div>
                                </td>
                                <td><%= notes %></td>
                            </tr>
                            <% } } else { %>
                            <tr>
                                <td colspan="7">No upcoming appointments</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Recent Patients -->
            <div class="appointment-management">
                <div class="section-header">
                    <h2>Recent Patients</h2>
                    <a href="${pageContext.request.contextPath}/doctor/patients" class="btn btn-outline">View All</a>
                </div>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Age</th>
                                <th>Gender</th>
                                <th>Last Visit</th>
                                <th>Contact</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(recentPatients != null && !recentPatients.isEmpty()) {
                                for(Patient patient : recentPatients) {
                                    String firstName = (patient.getFirstName() != null) ? patient.getFirstName() : "";
                                    String lastName = (patient.getLastName() != null) ? patient.getLastName() : "";
                                    String fullName = firstName + " " + lastName;
                                    if (fullName.trim().isEmpty()) fullName = "Unknown";

                                    int age = patient.getAge();
                                    String gender = (patient.getGender() != null) ? patient.getGender() : "Not specified";
                                    String lastVisit = (patient.getLastVisit() != null) ? patient.getLastVisit() : "N/A";
                                    String phone = (patient.getPhone() != null) ? patient.getPhone() : "Not available";
                            %>
                            <tr>
                                <td><%= fullName %></td>
                                <td><%= age %></td>
                                <td><%= gender %></td>
                                <td><%= lastVisit %></td>
                                <td><%= phone %></td>
                                <td>
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/doctor/patient-details?id=<%= patient.getId() %>" class="action-btn view"><i class="fas fa-eye"></i></a>
                                        <a href="${pageContext.request.contextPath}/doctor/edit-patient?id=<%= patient.getId() %>" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                    </div>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr>
                                <td>Peter Church</td>
                                <td>42</td>
                                <td>Male</td>
                                <td>2023-10-05</td>
                                <td>+1 234 567 890</td>
                                <td>
                                    <div class="table-actions">
                                        <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                        <a href="#" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Set context path for JavaScript
        const contextPath = '${pageContext.request.contextPath}';

        document.addEventListener('DOMContentLoaded', function() {
            // Toggle status button functionality
            const toggleStatusBtn = document.getElementById('toggle-status-btn');
            if (toggleStatusBtn) {
                toggleStatusBtn.addEventListener('click', function() {
                    // Confirm before changing status
                    const currentStatus = '${doctor.status}';
                    const newStatus = currentStatus == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
                    const confirmMessage = currentStatus == 'ACTIVE'
                        ? 'Are you sure you want to set your status to inactive? You will not receive new appointments.'
                        : 'Are you sure you want to set your status to active? You will start receiving new appointments.';

                    if (confirm(confirmMessage)) {
                        // Send request to toggle status
                        fetch(contextPath + '/doctor/toggle-status', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                                'X-Requested-With': 'XMLHttpRequest'
                            }
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                // Update button text
                                toggleStatusBtn.textContent = 'Set Active ' + (data.status == 'ACTIVE' ? 'Off' : 'On');

                                // Show success message
                                alert(data.message || 'Status updated successfully!');

                                // Reload the page to reflect changes
                                window.location.reload();
                            } else {
                                // Show error message
                                alert(data.message || 'Failed to update status. Please try again.');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('An error occurred while updating status. Please try again.');
                        });
                    }
                });
            }

            // Tab functionality
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    // Remove active class from all tabs
                    tabs.forEach(t => t.classList.remove('active'));

                    // Add active class to clicked tab
                    this.classList.add('active');

                    // Here you would typically load different content based on the selected tab
                    // For now, we'll just show an alert
                    alert('Loading ' + this.textContent + ' appointments...');

                    // In a real implementation, you would fetch data from the server
                    // and update the table content
                });
            });

            // Action buttons functionality
            const viewButtons = document.querySelectorAll('.action-btn.view');
            viewButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    // If the button doesn't have an href attribute, prevent default and show alert
                    if (!this.getAttribute('href') || this.getAttribute('href') === '#') {
                        e.preventDefault();
                        alert('Viewing details...');
                    }
                });
            });

            const editButtons = document.querySelectorAll('.action-btn.edit');
            editButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    // If the button doesn't have an href attribute, prevent default and show alert
                    if (!this.getAttribute('href') || this.getAttribute('href') === '#') {
                        e.preventDefault();
                        alert('Editing details...');
                    }
                });
            });
        });
    </script>
</body>
</html>
