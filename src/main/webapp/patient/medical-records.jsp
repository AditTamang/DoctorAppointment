<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.MedicalRecord" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Records | Patient Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        .dashboard-content {
            flex: 1;
            padding: 20px;
            margin-left: 220px;
        }
        
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .dashboard-header h1 {
            font-size: 24px;
            color: #333;
            margin: 0;
        }
        
        .medical-records-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .medical-records-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .medical-records-table th,
        .medical-records-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .medical-records-table th {
            background-color: #f5f5f5;
            font-weight: 600;
            color: #333;
        }
        
        .medical-records-table tr:hover {
            background-color: #f9f9f9;
        }
        
        .no-records {
            text-align: center;
            padding: 30px;
            color: #666;
            font-style: italic;
        }
        
        .record-date {
            font-weight: 600;
            color: #4CAF50;
        }
        
        .doctor-name {
            color: #2196F3;
            font-weight: 500;
        }
        
        @media (max-width: 768px) {
            .dashboard-content {
                margin-left: 0;
                padding: 15px;
            }
            
            .medical-records-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <%
        // Get current user from session
        User user = (User) session.getAttribute("user");
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get patient and medical records from request attributes
        Patient patient = (Patient) request.getAttribute("patient");
        List<MedicalRecord> medicalRecords = (List<MedicalRecord>) request.getAttribute("medicalRecords");
    %>
    <div class="dashboard-container">
        <!-- Include the sidebar -->
        <jsp:include page="patient-sidebar.jsp" />
        
        <!-- Main Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h1>My Medical Records</h1>
            </div>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>
            
            <div class="medical-records-container">
                <% if (medicalRecords != null && !medicalRecords.isEmpty()) { %>
                <table class="medical-records-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Doctor</th>
                            <th>Diagnosis</th>
                            <th>Treatment</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (MedicalRecord record : medicalRecords) { %>
                        <tr>
                            <td class="record-date"><%= record.getRecordDate() %></td>
                            <td class="doctor-name"><%= record.getDoctorName() != null ? record.getDoctorName() : "Unknown Doctor" %></td>
                            <td><%= record.getDiagnosis() != null ? record.getDiagnosis() : "Not specified" %></td>
                            <td><%= record.getTreatment() != null ? record.getTreatment() : "Not specified" %></td>
                            <td><%= record.getNotes() != null ? record.getNotes() : "None" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="no-records">
                    <i class="fas fa-file-medical fa-3x" style="color: #ddd; margin-bottom: 15px;"></i>
                    <p>No medical records found. Your medical history will appear here after your doctor visits.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
