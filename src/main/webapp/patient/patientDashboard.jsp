<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.AppointmentDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/patientDashboard.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fc;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background-color: #4e73df;
            color: #fff;
            transition: all 0.3s;
        }

        .sidebar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h3 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
        }

        .sidebar-menu {
            padding: 20px 0;
        }

        .sidebar-menu ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu li a {
            display: block;
            padding: 10px 20px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s;
        }

        .sidebar-menu li a:hover,
        .sidebar-menu li.active a {
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .main-content {
            flex: 1;
            padding: 20px;
        }

        .page-header {
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
            color: #333;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4e73df;
            color: #fff;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #2e59d9;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            padding: 20px;
            display: flex;
            align-items: center;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 24px;
        }

        .stat-icon.appointments {
            background-color: rgba(78, 115, 223, 0.1);
            color: #4e73df;
        }

        .stat-icon.upcoming {
            background-color: rgba(28, 200, 138, 0.1);
            color: #1cc88a;
        }

        .stat-icon.completed {
            background-color: rgba(246, 194, 62, 0.1);
            color: #f6c23e;
        }

        .stat-icon.cancelled {
            background-color: rgba(231, 74, 59, 0.1);
            color: #e74a3b;
        }

        .stat-info h3 {
            margin: 0 0 5px;
            font-size: 14px;
            font-weight: 500;
            color: #666;
        }

        .stat-info p {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
            color: #333;
        }

        .card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }

        .card-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h2 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .card-body {
            padding: 20px;
        }

        .appointment-list {
            margin-top: 20px;
        }

        .appointment-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: all 0.3s;
        }

        .appointment-item:hover {
            background-color: #f8f9fc;
        }

        .appointment-item:last-child {
            border-bottom: none;
        }

        .appointment-date {
            width: 80px;
            text-align: center;
            margin-right: 20px;
        }

        .appointment-day {
            font-size: 24px;
            font-weight: 700;
            color: #4e73df;
        }

        .appointment-month {
            font-size: 14px;
            color: #666;
        }

        .appointment-info {
            flex: 1;
        }

        .appointment-doctor {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .appointment-time {
            font-size: 14px;
            color: #666;
            display: flex;
            align-items: center;
        }

        .appointment-time i {
            margin-right: 5px;
            color: #4e73df;
        }

        .appointment-status {
            margin-left: 20px;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .appointment-status.confirmed {
            background-color: rgba(28, 200, 138, 0.1);
            color: #1cc88a;
        }

        .appointment-status.pending {
            background-color: rgba(246, 194, 62, 0.1);
            color: #f6c23e;
        }

        .appointment-status.cancelled {
            background-color: rgba(231, 74, 59, 0.1);
            color: #e74a3b;
        }

        .appointment-status.completed {
            background-color: rgba(78, 115, 223, 0.1);
            color: #4e73df;
        }

        .appointment-actions {
            margin-left: 20px;
            display: flex;
            gap: 10px;
        }

        .action-btn {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s;
        }

        .action-btn.view {
            background-color: #4e73df;
        }

        .action-btn.edit {
            background-color: #1cc88a;
        }

        .action-btn.cancel {
            background-color: #e74a3b;
        }

        .action-btn:hover {
            opacity: 0.8;
            transform: scale(1.1);
        }

        .doctor-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .doctor-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s;
        }

        .doctor-card:hover {
            transform: translateY(-5px);
        }

        .doctor-header {
            background-color: #f8f9fc;
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        .doctor-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 30px;
            color: #4e73df;
        }

        .doctor-name {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .doctor-specialization {
            font-size: 14px;
            color: #666;
        }

        .doctor-body {
            padding: 15px;
        }

        .doctor-info {
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .doctor-info i {
            margin-right: 10px;
            color: #4e73df;
            width: 20px;
            text-align: center;
        }

        .doctor-actions {
            display: flex;
            justify-content: center;
            margin-top: 15px;
        }

        .doctor-btn {
            padding: 8px 15px;
            background-color: #4e73df;
            color: #fff;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .doctor-btn:hover {
            background-color: #2e59d9;
        }

        .no-data {
            text-align: center;
            padding: 30px;
            color: #666;
        }

        .no-data i {
            font-size: 50px;
            color: #ddd;
            margin-bottom: 15px;
        }

        .no-data p {
            margin: 0;
            font-size: 16px;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-bottom: 20px;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }

            .appointment-item {
                flex-direction: column;
                text-align: center;
            }

            .appointment-date {
                margin-right: 0;
                margin-bottom: 10px;
            }

            .appointment-status {
                margin-left: 0;
                margin-top: 10px;
            }

            .appointment-actions {
                margin-left: 0;
                margin-top: 10px;
                justify-content: center;
            }
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

        // Get appointments for the current user
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> upcomingAppointments = appointmentDAO.getUpcomingAppointmentsByPatientId(currentUser.getId());
        List<Appointment> recentAppointments = appointmentDAO.getRecentAppointmentsByPatientId(currentUser.getId());

        // Count appointments by status
        int totalAppointments = appointmentDAO.getTotalAppointmentsByPatientId(currentUser.getId());
        int upcomingCount = appointmentDAO.getUpcomingAppointmentCountByPatientId(currentUser.getId());
        int completedCount = appointmentDAO.getCompletedAppointmentCountByPatientId(currentUser.getId());
        int cancelledCount = appointmentDAO.getCancelledAppointmentCountByPatientId(currentUser.getId());
    %>

    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Patient Dashboard</h3>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/patient/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            Dashboard
                        </a>
                    </li>
                    <li>
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
            <div class="page-header">
                <h1>Welcome, <%= currentUser.getFirstName() %>!</h1>
                <a href="${pageContext.request.contextPath}/doctors" class="btn">
                    <i class="fas fa-plus"></i> Book New Appointment
                </a>
            </div>

            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-icon appointments">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Appointments</h3>
                        <p><%= totalAppointments %></p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon upcoming">
                        <i class="fas fa-calendar"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Upcoming Appointments</h3>
                        <p><%= upcomingCount %></p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon completed">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Completed Appointments</h3>
                        <p><%= completedCount %></p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon cancelled">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Cancelled Appointments</h3>
                        <p><%= cancelledCount %></p>
                    </div>
                </div>
            </div>

            <!-- Upcoming Appointments -->
            <div class="card">
                <div class="card-header">
                    <h2>Upcoming Appointments</h2>
                    <a href="${pageContext.request.contextPath}/patient/appointments" class="btn">View All</a>
                </div>
                <div class="card-body">
                    <div class="appointment-list">
                        <% if (upcomingAppointments != null && !upcomingAppointments.isEmpty()) {
                            for (Appointment appointment : upcomingAppointments) {
                                String statusClass = "pending";
                                if ("CONFIRMED".equals(appointment.getStatus())) {
                                    statusClass = "confirmed";
                                } else if ("CANCELLED".equals(appointment.getStatus())) {
                                    statusClass = "cancelled";
                                } else if ("COMPLETED".equals(appointment.getStatus())) {
                                    statusClass = "completed";
                                }

                                // Format date
                                java.util.Date appointmentDate = appointment.getAppointmentDate();
                                java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("dd");
                                java.text.SimpleDateFormat monthFormat = new java.text.SimpleDateFormat("MMM");
                                String day = dayFormat.format(appointmentDate);
                                String month = monthFormat.format(appointmentDate);
                        %>
                        <div class="appointment-item">
                            <div class="appointment-date">
                                <div class="appointment-day"><%= day %></div>
                                <div class="appointment-month"><%= month %></div>
                            </div>
                            <div class="appointment-info">
                                <div class="appointment-doctor">Dr. <%= appointment.getDoctorName() %></div>
                                <div class="appointment-time">
                                    <i class="fas fa-clock"></i>
                                    <%= appointment.getAppointmentTime() %> | <%= appointment.getDoctorSpecialization() %>
                                </div>
                            </div>
                            <div class="appointment-status <%= statusClass %>">
                                <%= appointment.getStatus() %>
                            </div>
                            <div class="appointment-actions">
                                <a href="${pageContext.request.contextPath}/patient/appointment?id=<%= appointment.getId() %>" class="action-btn view">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <% if (!"CANCELLED".equals(appointment.getStatus()) && !"COMPLETED".equals(appointment.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/patient/cancel-appointment?id=<%= appointment.getId() %>" class="action-btn cancel" onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                    <i class="fas fa-times"></i>
                                </a>
                                <% } %>
                            </div>
                        </div>
                        <% } } else { %>
                        <div class="no-data">
                            <i class="fas fa-calendar-times"></i>
                            <p>You have no upcoming appointments.</p>
                            <a href="${pageContext.request.contextPath}/doctors" class="btn" style="margin-top: 15px;">Book an Appointment</a>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Recent Appointments -->
            <div class="card">
                <div class="card-header">
                    <h2>Recent Appointments</h2>
                </div>
                <div class="card-body">
                    <div class="appointment-list">
                        <% if (recentAppointments != null && !recentAppointments.isEmpty()) {
                            for (Appointment appointment : recentAppointments) {
                                String statusClass = "pending";
                                if ("CONFIRMED".equals(appointment.getStatus())) {
                                    statusClass = "confirmed";
                                } else if ("CANCELLED".equals(appointment.getStatus())) {
                                    statusClass = "cancelled";
                                } else if ("COMPLETED".equals(appointment.getStatus())) {
                                    statusClass = "completed";
                                }

                                // Format date
                                java.util.Date appointmentDate = appointment.getAppointmentDate();
                                java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("dd");
                                java.text.SimpleDateFormat monthFormat = new java.text.SimpleDateFormat("MMM");
                                String day = dayFormat.format(appointmentDate);
                                String month = monthFormat.format(appointmentDate);
                        %>
                        <div class="appointment-item">
                            <div class="appointment-date">
                                <div class="appointment-day"><%= day %></div>
                                <div class="appointment-month"><%= month %></div>
                            </div>
                            <div class="appointment-info">
                                <div class="appointment-doctor">Dr. <%= appointment.getDoctorName() %></div>
                                <div class="appointment-time">
                                    <i class="fas fa-clock"></i>
                                    <%= appointment.getAppointmentTime() %> | <%= appointment.getDoctorSpecialization() %>
                                </div>
                            </div>
                            <div class="appointment-status <%= statusClass %>">
                                <%= appointment.getStatus() %>
                            </div>
                            <div class="appointment-actions">
                                <a href="${pageContext.request.contextPath}/patient/appointment?id=<%= appointment.getId() %>" class="action-btn view">
                                    <i class="fas fa-eye"></i>
                                </a>
                            </div>
                        </div>
                        <% } } else { %>
                        <div class="no-data">
                            <i class="fas fa-history"></i>
                            <p>You have no recent appointments.</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
