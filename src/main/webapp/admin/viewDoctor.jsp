<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.dao.DoctorDAO" %>
<%@ page import="com.doctorapp.dao.AppointmentDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Profile | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/dashboard.css">
    <style>
        .profile-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
            overflow: hidden;
        }
        .profile-header {
            background-color: #4e73df;
            color: #fff;
            padding: 30px;
            position: relative;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 50px;
            color: #4e73df;
            border: 5px solid rgba(255, 255, 255, 0.3);
        }
        .profile-name {
            font-size: 24px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 5px;
        }
        .profile-specialization {
            font-size: 16px;
            text-align: center;
            opacity: 0.9;
            margin-bottom: 15px;
        }
        .profile-stats {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 20px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-value {
            font-size: 24px;
            font-weight: 600;
        }
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }
        .profile-actions {
            position: absolute;
            top: 20px;
            right: 20px;
            display: flex;
            gap: 10px;
        }
        .btn-action {
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-action i {
            margin-right: 5px;
        }
        .btn-edit {
            background-color: #fff;
            color: #4e73df;
        }
        .btn-delete {
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
        }
        .btn-action:hover {
            opacity: 0.9;
        }
        .profile-body {
            padding: 30px;
        }
        .profile-section {
            margin-bottom: 30px;
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 1px solid #e3e6f0;
            padding-bottom: 10px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        .info-item {
            margin-bottom: 15px;
        }
        .info-label {
            font-size: 14px;
            color: #858796;
            margin-bottom: 5px;
        }
        .info-value {
            font-size: 16px;
            font-weight: 500;
            color: #333;
        }
        .bio-text {
            line-height: 1.6;
            color: #333;
        }
        .appointment-list {
            margin-top: 20px;
        }
        .appointment-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #e3e6f0;
        }
        .appointment-item:last-child {
            border-bottom: none;
        }
        .appointment-date {
            width: 100px;
            text-align: center;
            padding-right: 15px;
        }
        .appointment-day {
            font-size: 18px;
            font-weight: 600;
            color: #4e73df;
        }
        .appointment-month {
            font-size: 14px;
            color: #858796;
        }
        .appointment-details {
            flex: 1;
        }
        .appointment-patient {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 5px;
        }
        .appointment-time {
            font-size: 14px;
            color: #858796;
        }
        .appointment-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-align: center;
            margin-left: 15px;
        }
        .status-confirmed {
            background-color: rgba(28, 200, 138, 0.1);
            color: #1cc88a;
        }
        .status-pending {
            background-color: rgba(246, 194, 62, 0.1);
            color: #f6c23e;
        }
        .status-cancelled {
            background-color: rgba(231, 74, 59, 0.1);
            color: #e74a3b;
        }
        .status-completed {
            background-color: rgba(78, 115, 223, 0.1);
            color: #4e73df;
        }
        .no-data {
            text-align: center;
            padding: 20px;
            color: #858796;
        }
        @media (max-width: 768px) {
            .profile-actions {
                position: static;
                justify-content: center;
                margin-top: 20px;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .profile-stats {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in and is an admin
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get doctor ID from request parameter
        String doctorIdStr = request.getParameter("id");
        int doctorId = 0;
        Doctor doctor = null;
        
        if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
            try {
                doctorId = Integer.parseInt(doctorIdStr);
                DoctorDAO doctorDAO = new DoctorDAO();
                doctor = doctorDAO.getDoctorById(doctorId);
            } catch (NumberFormatException e) {
                // Invalid doctor ID
            }
        }
        
        if (doctor == null) {
            // Redirect to doctor list if doctor not found
            response.sendRedirect(request.getContextPath() + "/admin/doctors");
            return;
        }
        
        // Get recent appointments for this doctor
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> recentAppointments = appointmentDAO.getAppointmentsByDoctorId(doctorId, 5);
    %>

    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Dashboard</h3>
            </div>
            
            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/doctors">
                            <i class="fas fa-user-md"></i>
                            <span>Doctors</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/patients">
                            <i class="fas fa-user-injured"></i>
                            <span>Patients</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/appointments">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h1>Doctor Profile</h1>
                <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Doctors
                </a>
            </div>
            
            <div class="profile-container">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <h2 class="profile-name">Dr. <%= doctor.getName() %></h2>
                    <div class="profile-specialization"><%= doctor.getSpecialization() %></div>
                    
                    <div class="profile-stats">
                        <div class="stat-item">
                            <div class="stat-value"><%= doctor.getAppointmentCount() %></div>
                            <div class="stat-label">Appointments</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value"><%= doctor.getExperience() %></div>
                            <div class="stat-label">Years Experience</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">$<%= doctor.getConsultationFee() %></div>
                            <div class="stat-label">Consultation Fee</div>
                        </div>
                    </div>
                    
                    <div class="profile-actions">
                        <a href="${pageContext.request.contextPath}/admin/edit-doctor?id=<%= doctor.getId() %>" class="btn-action btn-edit">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a href="#" class="btn-action btn-delete" onclick="confirmDelete(<%= doctor.getId() %>)">
                            <i class="fas fa-trash"></i> Delete
                        </a>
                    </div>
                </div>
                
                <div class="profile-body">
                    <div class="profile-section">
                        <h3 class="section-title">Personal Information</h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Email</div>
                                <div class="info-value"><%= doctor.getEmail() %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Phone</div>
                                <div class="info-value"><%= doctor.getPhone() %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Address</div>
                                <div class="info-value"><%= doctor.getAddress() %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Status</div>
                                <div class="info-value"><%= doctor.getStatus() %></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="profile-section">
                        <h3 class="section-title">Professional Information</h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Specialization</div>
                                <div class="info-value"><%= doctor.getSpecialization() %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Qualifications</div>
                                <div class="info-value"><%= doctor.getQualifications() %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Experience</div>
                                <div class="info-value"><%= doctor.getExperience() %> years</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Consultation Fee</div>
                                <div class="info-value">$<%= doctor.getConsultationFee() %></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="profile-section">
                        <h3 class="section-title">About Doctor</h3>
                        <p class="bio-text"><%= doctor.getBio() != null ? doctor.getBio() : "No bio available." %></p>
                    </div>
                    
                    <div class="profile-section">
                        <h3 class="section-title">Recent Appointments</h3>
                        <div class="appointment-list">
                            <% if (recentAppointments != null && !recentAppointments.isEmpty()) {
                                for (Appointment appointment : recentAppointments) {
                                    String statusClass = "status-pending";
                                    if ("CONFIRMED".equals(appointment.getStatus())) {
                                        statusClass = "status-confirmed";
                                    } else if ("CANCELLED".equals(appointment.getStatus())) {
                                        statusClass = "status-cancelled";
                                    } else if ("COMPLETED".equals(appointment.getStatus())) {
                                        statusClass = "status-completed";
                                    }
                            %>
                            <div class="appointment-item">
                                <div class="appointment-date">
                                    <div class="appointment-day"><%= appointment.getAppointmentDate().getDate() %></div>
                                    <div class="appointment-month"><%= new java.text.SimpleDateFormat("MMM yyyy").format(appointment.getAppointmentDate()) %></div>
                                </div>
                                <div class="appointment-details">
                                    <div class="appointment-patient"><%= appointment.getPatientName() %></div>
                                    <div class="appointment-time"><%= appointment.getAppointmentTime() %></div>
                                </div>
                                <div class="appointment-status <%= statusClass %>">
                                    <%= appointment.getStatus() %>
                                </div>
                            </div>
                            <% } } else { %>
                            <div class="no-data">
                                <p>No recent appointments found.</p>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function confirmDelete(doctorId) {
            if (confirm("Are you sure you want to delete this doctor?")) {
                window.location.href = "${pageContext.request.contextPath}/admin/delete-doctor?id=" + doctorId;
            }
        }
    </script>
</body>
</html>
