<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details | HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patientDashboard.css">
    <style>
        .appointment-details-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .appointment-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .appointment-header {
            background-color: #4e73df;
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .appointment-header h2 {
            margin: 0;
            font-size: 24px;
        }
        
        .appointment-body {
            padding: 30px;
        }
        
        .appointment-section {
            margin-bottom: 30px;
        }
        
        .appointment-section h3 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #333;
            font-size: 18px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 15px;
        }
        
        .detail-label {
            flex: 1;
            font-weight: 500;
            color: #555;
        }
        
        .detail-value {
            flex: 2;
            color: #333;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .status-badge.confirmed {
            background-color: rgba(28, 200, 138, 0.1);
            color: #1cc88a;
        }
        
        .status-badge.pending {
            background-color: rgba(246, 194, 62, 0.1);
            color: #f6c23e;
        }
        
        .status-badge.cancelled {
            background-color: rgba(231, 74, 59, 0.1);
            color: #e74a3b;
        }
        
        .status-badge.completed {
            background-color: rgba(78, 115, 223, 0.1);
            color: #4e73df;
        }
        
        .appointment-actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background-color: #4e73df;
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            background-color: #2e59d9;
        }
        
        .btn-danger {
            background-color: #e74a3b;
            color: white;
            border: none;
        }
        
        .btn-danger:hover {
            background-color: #d52a1a;
        }
        
        .btn-secondary {
            background-color: #f8f9fc;
            color: #333;
            border: 1px solid #ddd;
        }
        
        .btn-secondary:hover {
            background-color: #eaecf4;
        }
        
        .prescription-box {
            background-color: #f8f9fc;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-top: 10px;
        }
        
        .prescription-box p {
            margin: 0;
            white-space: pre-line;
        }
        
        .no-data {
            color: #888;
            font-style: italic;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get appointment from request
        Appointment appointment = (Appointment) request.getAttribute("appointment");
        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            return;
        }
        
        // Format date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
        String formattedDate = appointment.getAppointmentDate() != null ? 
                              dateFormat.format(appointment.getAppointmentDate()) : "";
        
        // Determine status class
        String statusClass = "pending";
        if ("CONFIRMED".equals(appointment.getStatus())) {
            statusClass = "confirmed";
        } else if ("CANCELLED".equals(appointment.getStatus())) {
            statusClass = "cancelled";
        } else if ("COMPLETED".equals(appointment.getStatus())) {
            statusClass = "completed";
        }
    %>

    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Patient Dashboard</h3>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            Dashboard
                        </a>
                    </li>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/patient/appointments">
                            <i class="fas fa-calendar-check"></i>
                            My Appointments
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/book-appointment">
                            <i class="fas fa-calendar-plus"></i>
                            Book Appointment
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/medical-records">
                            <i class="fas fa-file-medical"></i>
                            Medical Records
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/prescriptions">
                            <i class="fas fa-prescription"></i>
                            Prescriptions
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/profile-legacy">
                            <i class="fas fa-user"></i>
                            My Profile
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i>
                            Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="appointment-details-container">
                <div class="appointment-card">
                    <div class="appointment-header">
                        <h2>Appointment Details</h2>
                    </div>
                    
                    <div class="appointment-body">
                        <div class="appointment-section">
                            <h3>Appointment Information</h3>
                            
                            <div class="detail-row">
                                <div class="detail-label">Appointment ID</div>
                                <div class="detail-value">#<%= appointment.getId() %></div>
                            </div>
                            
                            <div class="detail-row">
                                <div class="detail-label">Status</div>
                                <div class="detail-value">
                                    <span class="status-badge <%= statusClass %>"><%= appointment.getStatus() %></span>
                                </div>
                            </div>
                            
                            <div class="detail-row">
                                <div class="detail-label">Date</div>
                                <div class="detail-value"><%= formattedDate %></div>
                            </div>
                            
                            <div class="detail-row">
                                <div class="detail-label">Time</div>
                                <div class="detail-value"><%= appointment.getAppointmentTime() %></div>
                            </div>
                            
                            <div class="detail-row">
                                <div class="detail-label">Doctor</div>
                                <div class="detail-value">Dr. <%= appointment.getDoctorName() %></div>
                            </div>
                            
                            <div class="detail-row">
                                <div class="detail-label">Specialization</div>
                                <div class="detail-value"><%= appointment.getDoctorSpecialization() != null ? appointment.getDoctorSpecialization() : "General Physician" %></div>
                            </div>
                            
                            <div class="detail-row">
                                <div class="detail-label">Consultation Fee</div>
                                <div class="detail-value">$<%= String.format("%.2f", appointment.getFee()) %></div>
                            </div>
                        </div>
                        
                        <div class="appointment-section">
                            <h3>Reason for Visit</h3>
                            <p><%= appointment.getReason() != null ? appointment.getReason() : "<span class='no-data'>No reason provided</span>" %></p>
                        </div>
                        
                        <div class="appointment-section">
                            <h3>Symptoms</h3>
                            <p><%= appointment.getSymptoms() != null ? appointment.getSymptoms() : "<span class='no-data'>No symptoms provided</span>" %></p>
                        </div>
                        
                        <div class="appointment-section">
                            <h3>Doctor's Notes</h3>
                            <p><%= appointment.getNotes() != null ? appointment.getNotes() : "<span class='no-data'>No notes available</span>" %></p>
                        </div>
                        
                        <% if ("COMPLETED".equals(appointment.getStatus()) && appointment.getPrescription() != null && !appointment.getPrescription().isEmpty()) { %>
                        <div class="appointment-section">
                            <h3>Prescription</h3>
                            <div class="prescription-box">
                                <p><%= appointment.getPrescription() %></p>
                            </div>
                        </div>
                        <% } %>
                        
                        <div class="appointment-actions">
                            <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-secondary">Back to Dashboard</a>
                            
                            <% if (!"CANCELLED".equals(appointment.getStatus()) && !"COMPLETED".equals(appointment.getStatus())) { %>
                            <a href="${pageContext.request.contextPath}/patient/cancel-appointment?id=<%= appointment.getId() %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this appointment?')">Cancel Appointment</a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
