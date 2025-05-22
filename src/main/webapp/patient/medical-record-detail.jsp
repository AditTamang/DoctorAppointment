<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.MedicalRecord" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Record Details | MedDoc</title>
    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/logo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
        
        /* Medical Record Detail Container */
        .medical-record-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 25px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }
        
        .medical-record-container:hover {
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
        }
        
        /* Record Header */
        .record-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .record-date {
            font-size: 18px;
            font-weight: 600;
            color: #3CCFCF;
        }
        
        .doctor-name {
            font-size: 16px;
            color: #2c3e50;
        }
        
        /* Record Content */
        .record-section {
            margin-bottom: 25px;
        }
        
        .record-section h3 {
            font-size: 18px;
            color: #2c3e50;
            margin-bottom: 10px;
            padding-bottom: 8px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .record-section p {
            font-size: 16px;
            color: #333;
            line-height: 1.6;
        }
        
        /* Back Button */
        .back-button {
            display: inline-flex;
            align-items: center;
            background-color: #3CCFCF;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-top: 20px;
        }
        
        .back-button i {
            margin-right: 8px;
        }
        
        .back-button:hover {
            background-color: #2ba3a3;
            transform: translateY(-2px);
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
        
        .alert-info {
            background-color: #e7f3fe;
            color: #0c5460;
            border-left-color: #2196F3;
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
            .record-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .record-date {
                margin-bottom: 10px;
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
            
            .medical-record-container {
                padding: 15px;
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
        
        // Get patient and medical record from request attributes
        Patient patient = (Patient) request.getAttribute("patient");
        MedicalRecord medicalRecord = (MedicalRecord) request.getAttribute("medicalRecord");
        
        if (medicalRecord == null) {
            response.sendRedirect(request.getContextPath() + "/patient/medical-records");
            return;
        }
    %>
    <div class="dashboard-container">
        <!-- Include the sidebar -->
        <jsp:include page="patient-sidebar.jsp" />
        
        <!-- Main Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h1>Medical Record Details</h1>
            </div>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>
            
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                <strong>Privacy Notice:</strong> Your medical records are private and secure. Only you and your healthcare providers can access this information.
            </div>
            
            <div class="medical-record-container">
                <div class="record-header">
                    <div class="record-date">
                        <i class="fas fa-calendar-alt"></i>
                        <%= medicalRecord.getFormattedDate() != null && !medicalRecord.getFormattedDate().isEmpty() ? 
                            medicalRecord.getFormattedDate() : medicalRecord.getRecordDate() %>
                    </div>
                    <div class="doctor-name">
                        <i class="fas fa-user-md"></i>
                        Doctor: <%= medicalRecord.getDoctorName() != null ? medicalRecord.getDoctorName() : "Unknown Doctor" %>
                    </div>
                </div>
                
                <div class="record-section">
                    <h3>Diagnosis</h3>
                    <p><%= medicalRecord.getDiagnosis() != null ? medicalRecord.getDiagnosis() : "Not specified" %></p>
                </div>
                
                <div class="record-section">
                    <h3>Treatment</h3>
                    <p><%= medicalRecord.getTreatment() != null ? medicalRecord.getTreatment() : "Not specified" %></p>
                </div>
                
                <div class="record-section">
                    <h3>Notes</h3>
                    <p><%= medicalRecord.getNotes() != null ? medicalRecord.getNotes() : "None" %></p>
                </div>
                
                <a href="${pageContext.request.contextPath}/patient/medical-records" class="back-button">
                    <i class="fas fa-arrow-left"></i> Back to Medical Records
                </a>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
