<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Details | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .patient-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .patient-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-size: 40px;
            color: #6c757d;
        }
        .patient-info {
            flex: 1;
        }
        .patient-name {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
            color: #343a40;
        }
        .patient-details {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 10px;
            margin-bottom: 5px;
        }
        .patient-detail {
            display: flex;
            align-items: center;
        }
        .patient-detail i {
            margin-right: 8px;
            color: #6c757d;
            width: 20px;
            text-align: center;
        }
        .section {
            margin-bottom: 30px;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #343a40;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 10px;
        }
        .appointment-list {
            width: 100%;
            border-collapse: collapse;
        }
        .appointment-list th, .appointment-list td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        .appointment-list th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #495057;
        }
        .appointment-list tr:hover {
            background-color: #f8f9fa;
        }
        .status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-confirmed {
            background-color: #d4edda;
            color: #155724;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-completed {
            background-color: #cce5ff;
            color: #004085;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .medical-info {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .medical-card {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #007bff;
        }
        .medical-card h4 {
            margin-top: 0;
            color: #343a40;
            font-size: 16px;
        }
        .medical-card p {
            margin-bottom: 0;
            color: #6c757d;
        }
        .add-button {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 15px;
        }
        .filter-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .search-box {
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            width: 250px;
        }
        .filter-dropdown {
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            background-color: white;
        }
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .pagination a {
            color: #007bff;
            padding: 8px 16px;
            text-decoration: none;
            border: 1px solid #dee2e6;
            margin: 0 4px;
        }
        .pagination a.active {
            background-color: #007bff;
            color: white;
            border: 1px solid #007bff;
        }
        .pagination a:hover:not(.active) {
            background-color: #e9ecef;
        }
        @media (max-width: 768px) {
            .patient-header {
                flex-direction: column;
                text-align: center;
            }
            .patient-avatar {
                margin-right: 0;
                margin-bottom: 15px;
            }
            .patient-details {
                grid-template-columns: 1fr;
            }
            .medical-info {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%
        // Get the current user from the session
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"DOCTOR".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get the patient from the request
        Patient patient = (Patient) request.getAttribute("patient");
        List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
        List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    %>

    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="../includes/sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Navbar -->
            <jsp:include page="../includes/navbar.jsp" />

            <!-- Content -->
            <div class="container">
                <% if (patient != null) { %>
                    <!-- Patient Header -->
                    <div class="patient-header">
                        <div class="patient-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="patient-info">
                            <h1 class="patient-name"><%= patient.getFirstName() + " " + patient.getLastName() %></h1>
                            <div class="patient-details">
                                <div class="patient-detail">
                                    <i class="fas fa-envelope"></i>
                                    <span><%= patient.getEmail() != null ? patient.getEmail() : "N/A" %></span>
                                </div>
                                <div class="patient-detail">
                                    <i class="fas fa-phone"></i>
                                    <span><%= patient.getPhone() != null ? patient.getPhone() : "N/A" %></span>
                                </div>
                                <div class="patient-detail">
                                    <i class="fas fa-calendar"></i>
                                    <span><%= patient.getDateOfBirth() != null ? patient.getDateOfBirth() : "N/A" %></span>
                                </div>
                                <div class="patient-detail">
                                    <i class="fas fa-venus-mars"></i>
                                    <span><%= patient.getGender() != null ? patient.getGender() : "N/A" %></span>
                                </div>
                            </div>
                            <div class="patient-details">
                                <div class="patient-detail">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span><%= patient.getAddress() != null ? patient.getAddress() : "N/A" %></span>
                                </div>
                                <div class="patient-detail">
                                    <i class="fas fa-tint"></i>
                                    <span>Blood Group: <%= patient.getBloodGroup() != null ? patient.getBloodGroup() : "N/A" %></span>
                                </div>
                                <div class="patient-detail">
                                    <i class="fas fa-calendar-check"></i>
                                    <span>Last Visit: <%= patient.getLastVisit() != null ? patient.getLastVisit() : "N/A" %></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Medical Information -->
                    <div class="section">
                        <h2 class="section-title">Medical Information</h2>
                        <div class="medical-info">
                            <div class="medical-card">
                                <h4>Allergies</h4>
                                <p><%= patient.getAllergies() != null && !patient.getAllergies().isEmpty() ? patient.getAllergies() : "No known allergies" %></p>
                            </div>
                            <div class="medical-card">
                                <h4>Medical History</h4>
                                <p><%= patient.getMedicalHistory() != null && !patient.getMedicalHistory().isEmpty() ? patient.getMedicalHistory() : "No medical history recorded" %></p>
                            </div>
                        </div>
                    </div>

                    <!-- Appointment History -->
                    <div class="section">
                        <h2 class="section-title">Appointment History</h2>
                        <% if (appointments != null && !appointments.isEmpty()) { %>
                            <table class="appointment-list">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Reason</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Appointment appointment : appointments) { %>
                                        <tr>
                                            <td><%= appointment.getAppointmentDate() %></td>
                                            <td><%= appointment.getAppointmentTime() %></td>
                                            <td><%= appointment.getReason() != null ? appointment.getReason() : "N/A" %></td>
                                            <td>
                                                <span class="status status-<%= appointment.getStatus().toLowerCase() %>">
                                                    <%= appointment.getStatus() %>
                                                </span>
                                            </td>
                                            <td class="action-buttons">
                                                <% if ("PENDING".equals(appointment.getStatus())) { %>
                                                    <form action="${pageContext.request.contextPath}/doctor/appointment" method="post">
                                                        <input type="hidden" name="action" value="updateStatus">
                                                        <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                        <input type="hidden" name="status" value="APPROVED">
                                                        <button type="submit" class="btn btn-success">Approve</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/doctor/appointment" method="post">
                                                        <input type="hidden" name="action" value="updateStatus">
                                                        <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                        <input type="hidden" name="status" value="REJECTED">
                                                        <button type="submit" class="btn btn-danger">Reject</button>
                                                    </form>
                                                <% } else if ("CONFIRMED".equals(appointment.getStatus())) { %>
                                                    <form action="${pageContext.request.contextPath}/doctor/appointment" method="post">
                                                        <input type="hidden" name="action" value="updateStatus">
                                                        <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                        <input type="hidden" name="status" value="COMPLETED">
                                                        <button type="submit" class="btn btn-primary">Mark Complete</button>
                                                    </form>
                                                <% } %>
                                                <a href="${pageContext.request.contextPath}/doctor/appointment?id=<%= appointment.getId() %>" class="btn btn-warning">View Details</a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } else { %>
                            <p>No appointment history found for this patient.</p>
                        <% } %>
                    </div>
                <% } else if (patients != null && !patients.isEmpty()) { %>
                    <!-- Patient List -->
                    <div class="section">
                        <h2 class="section-title">Patient List</h2>
                        <div class="filter-section">
                            <input type="text" class="search-box" placeholder="Search patients..." id="searchPatients">
                            <select class="filter-dropdown" id="statusFilter">
                                <option value="all">All Statuses</option>
                                <option value="active">Active</option>
                                <option value="pending">Pending</option>
                                <option value="completed">Completed</option>
                            </select>
                        </div>
                        <table class="appointment-list" id="patientTable">
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Age</th>
                                    <th>Gender</th>
                                    <th>Phone</th>
                                    <th>Last Visit</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Patient p : patients) { %>
                                    <tr>
                                        <td><%= p.getFirstName() + " " + p.getLastName() %></td>
                                        <td><%= p.getDateOfBirth() != null ? calculateAge(p.getDateOfBirth()) : "N/A" %></td>
                                        <td><%= p.getGender() != null ? p.getGender() : "N/A" %></td>
                                        <td><%= p.getPhone() != null ? p.getPhone() : "N/A" %></td>
                                        <td><%= p.getLastVisit() != null ? p.getLastVisit() : "N/A" %></td>
                                        <td>
                                            <span class="status status-<%= p.getStatus() != null ? p.getStatus().toLowerCase() : "unknown" %>">
                                                <%= p.getStatus() != null ? p.getStatus() : "Unknown" %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/doctor/patient-details?id=<%= p.getId() %>&doctorId=<%= currentUser.getId() %>" class="btn btn-primary">View Details</a>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <div class="pagination">
                            <a href="#">&laquo;</a>
                            <a href="#" class="active">1</a>
                            <a href="#">2</a>
                            <a href="#">3</a>
                            <a href="#">&raquo;</a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="section">
                        <h2 class="section-title">No Patient Data</h2>
                        <p>No patient information is available.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        // Function to calculate age from date of birth
        function calculateAge(dateOfBirth) {
            const dob = new Date(dateOfBirth);
            const today = new Date();
            let age = today.getFullYear() - dob.getFullYear();
            const monthDiff = today.getMonth() - dob.getMonth();
            
            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
                age--;
            }
            
            return age;
        }
        
        // Search and filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchPatients');
            const statusFilter = document.getElementById('statusFilter');
            const patientTable = document.getElementById('patientTable');
            
            if (searchInput && statusFilter && patientTable) {
                const filterPatients = () => {
                    const searchTerm = searchInput.value.toLowerCase();
                    const statusValue = statusFilter.value.toLowerCase();
                    const rows = patientTable.querySelectorAll('tbody tr');
                    
                    rows.forEach(row => {
                        const patientName = row.cells[0].textContent.toLowerCase();
                        const patientStatus = row.cells[5].textContent.trim().toLowerCase();
                        
                        const matchesSearch = patientName.includes(searchTerm);
                        const matchesStatus = statusValue === 'all' || patientStatus.includes(statusValue);
                        
                        row.style.display = matchesSearch && matchesStatus ? '' : 'none';
                    });
                };
                
                searchInput.addEventListener('input', filterPatients);
                statusFilter.addEventListener('change', filterPatients);
            }
        });
    </script>
</body>
</html>

<%!
    // Helper method to calculate age from date of birth
    private int calculateAge(String dateOfBirth) {
        if (dateOfBirth == null || dateOfBirth.isEmpty()) {
            return 0;
        }
        
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.util.Date dob = sdf.parse(dateOfBirth);
            java.util.Calendar dobCal = java.util.Calendar.getInstance();
            dobCal.setTime(dob);
            
            java.util.Calendar today = java.util.Calendar.getInstance();
            
            int age = today.get(java.util.Calendar.YEAR) - dobCal.get(java.util.Calendar.YEAR);
            
            if (today.get(java.util.Calendar.MONTH) < dobCal.get(java.util.Calendar.MONTH) ||
                (today.get(java.util.Calendar.MONTH) == dobCal.get(java.util.Calendar.MONTH) &&
                 today.get(java.util.Calendar.DAY_OF_MONTH) < dobCal.get(java.util.Calendar.DAY_OF_MONTH))) {
                age--;
            }
            
            return age;
        } catch (Exception e) {
            return 0;
        }
    }
%>
