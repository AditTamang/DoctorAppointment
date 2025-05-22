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
    <title>Medical Records | MedDoc</title>
    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/logo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-profile-image.css">
    <style>
        /* Main Container Styles */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        /* Content Area Styles */
        .dashboard-content {
            flex: 1;
            padding: 25px;
            margin-left: 250px;
            transition: margin-left 0.3s ease;
        }

        /* Header Styles */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .dashboard-header h1 {
            font-size: 28px;
            color: #2c3e50;
            margin: 0;
            font-weight: 600;
        }

        /* Medical Records Container */
        .medical-records-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 25px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        .medical-records-container:hover {
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
        }

        /* Table Styles */
        .medical-records-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 8px;
            overflow: hidden;
        }

        .medical-records-table th,
        .medical-records-table td {
            padding: 15px 20px;
            text-align: left;
        }

        .medical-records-table th {
            background-color: #3CCFCF;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 0.5px;
        }

        .medical-records-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .medical-records-table tr:hover {
            background-color: #f1f8ff;
        }

        .medical-records-table td {
            border-bottom: 1px solid #e0e0e0;
        }

        /* Empty State Styles */
        .no-records {
            text-align: center;
            padding: 50px 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            border: 1px dashed #ccc;
        }

        .no-records i {
            color: #3CCFCF;
            margin-bottom: 20px;
            font-size: 48px;
        }

        .no-records p {
            color: #6c757d;
            font-size: 16px;
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Action Buttons */
        .actions {
            text-align: center;
        }

        .btn-view {
            display: inline-block;
            background-color: #3CCFCF;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
        }

        .btn-view:hover {
            background-color: #2ba3a3;
        }

        /* Data Formatting */
        .record-date {
            font-weight: 600;
            color: #3CCFCF;
        }

        .doctor-name {
            color: #2c3e50;
            font-weight: 500;
        }

        /* Alert Styles */
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-left-color: #dc3545;
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .dashboard-content {
                margin-left: 0;
                padding: 20px;
            }

            .dashboard-header h1 {
                font-size: 24px;
            }
        }

        @media (max-width: 768px) {
            .medical-records-table {
                display: block;
                overflow-x: auto;
            }

            .medical-records-table th,
            .medical-records-table td {
                padding: 12px 15px;
            }

            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        @media (max-width: 576px) {
            .dashboard-content {
                padding: 15px;
            }

            .medical-records-container {
                padding: 15px;
            }
        }
    </style>
</head>
<body data-context-path="${pageContext.request.contextPath}">
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
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>

            <div class="alert" style="background-color: #e7f3fe; color: #0c5460; border-left-color: #2196F3;">
                <i class="fas fa-info-circle"></i>
                <strong>Privacy Notice:</strong> Your medical records are private and secure. Only you and your healthcare providers can access this information.
            </div>

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
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (MedicalRecord record : medicalRecords) { %>
                        <tr>
                            <td class="record-date"><%= record.getFormattedDate() != null && !record.getFormattedDate().isEmpty() ? record.getFormattedDate() : record.getRecordDate() %></td>
                            <td class="doctor-name"><%= record.getDoctorName() != null ? record.getDoctorName() : "Unknown Doctor" %></td>
                            <td><%= record.getDiagnosis() != null ? record.getDiagnosis() : "Not specified" %></td>
                            <td><%= record.getTreatment() != null ? record.getTreatment() : "Not specified" %></td>
                            <td><%= record.getNotes() != null ? record.getNotes() : "None" %></td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/patient/medical-record/view?id=<%= record.getId() %>" class="btn-view">
                                    <i class="fas fa-eye"></i> View
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="no-records">
                    <i class="fas fa-file-medical"></i>
                    <p>No medical records found. Your medical history will appear here after your doctor visits.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/profile-image-handler.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize profile image handling
            handleImageLoadErrors();
        });
    </script>
</body>
</html>
