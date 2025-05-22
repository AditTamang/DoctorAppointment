<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>Medical Records | Doctor Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .medical-records-container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-top: 20px;
        }
        
        .patient-info {
            background-color: #f8f9fc;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 4px solid #4e73df;
        }
        
        .patient-info h3 {
            margin: 0 0 15px 0;
            color: #333;
            font-size: 20px;
            font-weight: 600;
        }
        
        .patient-details {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .patient-detail {
            flex: 1;
            min-width: 200px;
        }
        
        .patient-detail h4 {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .patient-detail p {
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }
        
        .records-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 2px solid #eee;
            padding-bottom: 15px;
        }
        
        .records-header h2 {
            font-size: 24px;
            color: #333;
            font-weight: 600;
        }
        
        .records-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }
        
        .records-table th {
            background-color: #f8f9fc;
            color: #333;
            font-weight: 600;
            text-align: left;
            padding: 14px 15px;
            border-bottom: 2px solid #e3e6f0;
        }
        
        .records-table td {
            padding: 14px 15px;
            border-bottom: 1px solid #e3e6f0;
            color: #555;
        }
        
        .records-table tr:hover {
            background-color: #f8f9fc;
        }
        
        .record-actions {
            display: flex;
            gap: 10px;
        }
        
        .record-actions a {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .record-actions .view-btn {
            background-color: #4e73df;
            color: white;
        }
        
        .record-actions .edit-btn {
            background-color: #1cc88a;
            color: white;
        }
        
        .empty-records {
            text-align: center;
            padding: 40px 0;
            color: #666;
        }
        
        .empty-records i {
            font-size: 48px;
            color: #ddd;
            margin-bottom: 15px;
        }
        
        .empty-records p {
            font-size: 16px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h1>Medical Records</h1>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/doctor/view-patient?id=${patient.id}" class="back-btn">
                        <i class="fas fa-arrow-left"></i> Back to Patient Details
                    </a>
                </div>
            </div>

            <% if (request.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("successMessage") %>
            </div>
            <% } %>

            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>

            <%
            Patient patient = (Patient) request.getAttribute("patient");
            List<MedicalRecord> medicalRecords = (List<MedicalRecord>) request.getAttribute("medicalRecords");

            if (patient != null) {
                String fullName = patient.getFirstName() + " " + patient.getLastName();
            %>
            <div class="medical-records-container">
                <div class="patient-info">
                    <h3>Patient Information</h3>
                    <div class="patient-details">
                        <div class="patient-detail">
                            <h4>Name</h4>
                            <p><%= fullName %></p>
                        </div>
                        <div class="patient-detail">
                            <h4>Age</h4>
                            <p><%= patient.getAge() %> years</p>
                        </div>
                        <div class="patient-detail">
                            <h4>Gender</h4>
                            <p><%= patient.getGender() != null ? patient.getGender() : "Not specified" %></p>
                        </div>
                        <div class="patient-detail">
                            <h4>Blood Group</h4>
                            <p><%= patient.getBloodGroup() != null ? patient.getBloodGroup() : "Not specified" %></p>
                        </div>
                    </div>
                </div>

                <div class="records-header">
                    <h2>Medical Records History</h2>
                    <a href="${pageContext.request.contextPath}/doctor/add-medical-record?patientId=<%= patient.getId() %>" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Record
                    </a>
                </div>

                <% if (medicalRecords != null && !medicalRecords.isEmpty()) { %>
                <table class="records-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Diagnosis</th>
                            <th>Treatment</th>
                            <th>Notes</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (MedicalRecord record : medicalRecords) { %>
                        <tr>
                            <td><%= record.getRecordDate() %></td>
                            <td><%= record.getDiagnosis() != null ? record.getDiagnosis() : "Not specified" %></td>
                            <td><%= record.getTreatment() != null ? record.getTreatment() : "Not specified" %></td>
                            <td><%= record.getNotes() != null ? record.getNotes() : "None" %></td>
                            <td>
                                <div class="record-actions">
                                    <a href="${pageContext.request.contextPath}/doctor/view-medical-record?id=<%= record.getId() %>" class="view-btn">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <a href="${pageContext.request.contextPath}/doctor/edit-medical-record?id=<%= record.getId() %>" class="edit-btn">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="empty-records">
                    <i class="fas fa-file-medical-alt"></i>
                    <p>No medical records found for this patient.</p>
                    <a href="${pageContext.request.contextPath}/doctor/add-medical-record?patientId=<%= patient.getId() %>" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add First Medical Record
                    </a>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="alert alert-danger">
                Patient not found.
            </div>
            <% } %>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
