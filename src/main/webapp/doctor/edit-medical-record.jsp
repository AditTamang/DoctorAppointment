<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.MedicalRecord" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Medical Record | Doctor Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-sidebar-clean.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .medical-record-container {
            max-width: 900px;
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
        
        .form-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 2px solid #eee;
            padding-bottom: 15px;
        }
        
        .form-header h2 {
            font-size: 24px;
            color: #333;
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #d1d3e2;
            border-radius: 5px;
            font-size: 15px;
            color: #333;
            transition: border-color 0.2s ease;
        }
        
        .form-control:focus {
            border-color: #4e73df;
            outline: none;
        }
        
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .btn-primary {
            background-color: #4e73df;
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            background-color: #2e59d9;
        }
        
        .btn-success {
            background-color: #1cc88a;
            color: white;
            border: none;
        }
        
        .btn-success:hover {
            background-color: #169b6b;
        }
        
        .btn-secondary {
            background-color: #858796;
            color: white;
            border: none;
        }
        
        .btn-secondary:hover {
            background-color: #717384;
        }
        
        .record-meta {
            display: flex;
            justify-content: space-between;
            background-color: #f8f9fc;
            padding: 15px;
            border-radius: 8px;
            margin-top: 30px;
            border-left: 4px solid #1cc88a;
        }
        
        .record-meta-item {
            flex: 1;
        }
        
        .record-meta-item h4 {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .record-meta-item p {
            font-size: 15px;
            color: #333;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <div class="dashboard-header">
                <h1>Edit Medical Record</h1>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/doctor/medical-records?patientId=${patient.id}" class="back-btn">
                        <i class="fas fa-arrow-left"></i> Back to Medical Records
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
            MedicalRecord medicalRecord = (MedicalRecord) request.getAttribute("medicalRecord");

            if (patient != null && medicalRecord != null) {
                String fullName = patient.getFirstName() + " " + patient.getLastName();
            %>
            <div class="medical-record-container">
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

                <div class="form-header">
                    <h2>Edit Medical Record</h2>
                    <span class="record-date">Date: <%= medicalRecord.getRecordDate() %></span>
                </div>

                <form action="${pageContext.request.contextPath}/doctor/update-medical-record" method="post">
                    <input type="hidden" name="recordId" value="<%= medicalRecord.getId() %>">
                    <input type="hidden" name="patientId" value="<%= patient.getId() %>">
                    
                    <div class="form-group">
                        <label for="diagnosis">Diagnosis</label>
                        <textarea class="form-control" id="diagnosis" name="diagnosis" required><%= medicalRecord.getDiagnosis() != null ? medicalRecord.getDiagnosis() : "" %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="treatment">Treatment</label>
                        <textarea class="form-control" id="treatment" name="treatment" required><%= medicalRecord.getTreatment() != null ? medicalRecord.getTreatment() : "" %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="notes">Notes</label>
                        <textarea class="form-control" id="notes" name="notes"><%= medicalRecord.getNotes() != null ? medicalRecord.getNotes() : "" %></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/doctor/view-medical-record?id=<%= medicalRecord.getId() %>" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
            <% } else { %>
            <div class="alert alert-danger">
                Medical record or patient not found.
            </div>
            <% } %>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
