<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.DoctorDAO" %>
<%@ page import="com.doctorapp.dao.PatientDAO" %>
<%@ page import="com.doctorapp.dao.AppointmentDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            background-color: #4e73df;
            color: #fff;
        }
        
        .sidebar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
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
            background-color: #f8f9fc;
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
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
        
        .stat-icon.doctors {
            background-color: rgba(78, 115, 223, 0.1);
            color: #4e73df;
        }
        
        .stat-icon.patients {
            background-color: rgba(28, 200, 138, 0.1);
            color: #1cc88a;
        }
        
        .stat-icon.appointments {
            background-color: rgba(246, 194, 62, 0.1);
            color: #f6c23e;
        }
        
        .stat-icon.revenue {
            background-color: rgba(231, 74, 59, 0.1);
            color: #e74a3b;
        }
        
        .stat-info h3 {
            margin: 0 0 5px;
            font-size: 18px;
            font-weight: 600;
        }
        
        .stat-info p {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
        }
        
        .card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
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
        }
        
        .card-body {
            padding: 20px;
        }
        
        .table-responsive {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        table th, table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        table th {
            background-color: #f8f9fc;
            font-weight: 600;
        }
        
        table tr:hover {
            background-color: #f8f9fc;
        }
        
        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status.active {
            background-color: rgba(28, 200, 138, 0.1);
            color: #1cc88a;
        }
        
        .status.pending {
            background-color: rgba(246, 194, 62, 0.1);
            color: #f6c23e;
        }
        
        .status.cancelled {
            background-color: rgba(231, 74, 59, 0.1);
            color: #e74a3b;
        }
        
        .btn {
            display: inline-block;
            padding: 8px 15px;
            background-color: #4e73df;
            color: #fff;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #2e59d9;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .btn-view {
            background-color: #4e73df;
        }
        
        .btn-edit {
            background-color: #1cc88a;
        }
        
        .btn-delete {
            background-color: #e74a3b;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
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
        
        // Load admin dashboard data directly
        DoctorDAO doctorDAO = new DoctorDAO();
        PatientDAO patientDAO = new PatientDAO();
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        
        int totalDoctors = doctorDAO.getTotalDoctors();
        int totalPatients = patientDAO.getTotalPatients();
        int totalAppointments = appointmentDAO.getTotalAppointments();
        double totalRevenue = appointmentDAO.getTotalRevenue();
        
        List<Doctor> recentDoctors = doctorDAO.getRecentDoctors(5);
        List<Patient> recentPatients = patientDAO.getRecentPatients(5);
        List<Appointment> recentAppointments = appointmentDAO.getRecentAppointments(5);
    %>

    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Dashboard</h3>
            </div>
            
            <div class="sidebar-menu">
                <ul>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/doctors">
                            <i class="fas fa-user-md"></i> Doctors
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/patients">
                            <i class="fas fa-user-injured"></i> Patients
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/appointments">
                            <i class="fas fa-calendar-check"></i> Appointments
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/departments">
                            <i class="fas fa-hospital"></i> Departments
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i> Settings
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h1>Admin Dashboard</h1>
                <div>
                    <span>Welcome, <%= currentUser.getFirstName() %> <%= currentUser.getLastName() %></span>
                </div>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-icon doctors">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Doctors</h3>
                        <p><%= totalDoctors %></p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon patients">
                        <i class="fas fa-user-injured"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Patients</h3>
                        <p><%= totalPatients %></p>
                    </div>
                </div>
                
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
                    <div class="stat-icon revenue">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Revenue</h3>
                        <p>$<%= String.format("%.2f", totalRevenue) %></p>
                    </div>
                </div>
            </div>
            
            <!-- Recent Doctors -->
            <div class="card">
                <div class="card-header">
                    <h2>Recent Doctors</h2>
                    <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-sm">View All</a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Specialization</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recentDoctors != null && !recentDoctors.isEmpty()) {
                                    for (Doctor doctor : recentDoctors) { %>
                                <tr>
                                    <td><%= doctor.getName() %></td>
                                    <td><%= doctor.getSpecialization() %></td>
                                    <td><%= doctor.getEmail() %></td>
                                    <td><%= doctor.getPhone() %></td>
                                    <td><span class="status active">Active</span></td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/doctor?id=<%= doctor.getId() %>" class="btn btn-sm btn-view">View</a>
                                            <a href="${pageContext.request.contextPath}/admin/doctor/edit?id=<%= doctor.getId() %>" class="btn btn-sm btn-edit">Edit</a>
                                        </div>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr>
                                    <td colspan="6">No doctors found</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Recent Patients -->
            <div class="card">
                <div class="card-header">
                    <h2>Recent Patients</h2>
                    <a href="${pageContext.request.contextPath}/admin/patients" class="btn btn-sm">View All</a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Gender</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recentPatients != null && !recentPatients.isEmpty()) {
                                    for (Patient patient : recentPatients) { %>
                                <tr>
                                    <td><%= patient.getFirstName() + " " + patient.getLastName() %></td>
                                    <td><%= patient.getEmail() %></td>
                                    <td><%= patient.getPhone() %></td>
                                    <td><%= patient.getGender() %></td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/patient?id=<%= patient.getId() %>" class="btn btn-sm btn-view">View</a>
                                            <a href="${pageContext.request.contextPath}/admin/patient/edit?id=<%= patient.getId() %>" class="btn btn-sm btn-edit">Edit</a>
                                        </div>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr>
                                    <td colspan="5">No patients found</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Recent Appointments -->
            <div class="card">
                <div class="card-header">
                    <h2>Recent Appointments</h2>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-sm">View All</a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Doctor</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recentAppointments != null && !recentAppointments.isEmpty()) {
                                    for (Appointment appointment : recentAppointments) { 
                                        String statusClass = "pending";
                                        if ("CONFIRMED".equals(appointment.getStatus())) {
                                            statusClass = "active";
                                        } else if ("CANCELLED".equals(appointment.getStatus())) {
                                            statusClass = "cancelled";
                                        }
                                    %>
                                <tr>
                                    <td><%= appointment.getPatientName() %></td>
                                    <td><%= appointment.getDoctorName() %></td>
                                    <td><%= appointment.getAppointmentDate() %></td>
                                    <td><%= appointment.getAppointmentTime() %></td>
                                    <td><span class="status <%= statusClass %>"><%= appointment.getStatus() %></span></td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/appointment?id=<%= appointment.getId() %>" class="btn btn-sm btn-view">View</a>
                                        </div>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr>
                                    <td colspan="6">No appointments found</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Add any JavaScript functionality here
    </script>
</body>
</html>
