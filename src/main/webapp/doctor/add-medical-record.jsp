<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Patient" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Medical Record | Doctor Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Form styles are now in doctor-common.css */

        /* Button styles are now in doctor-common.css */

        /* Alert and back button styles are now in doctor-common.css */

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #4e73df;
            padding-bottom: 10px;
            display: inline-block;
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        .patient-info {
            background-color: #f8f9fc;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #4e73df;
        }

        .patient-info h3 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 18px;
            font-weight: 600;
        }

        .patient-info p {
            margin: 0 0 5px 0;
            color: #666;
            font-size: 14px;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }

            .form-col {
                width: 100%;
            }

            .form-actions {
                justify-content: center;
            }
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
                <h1>Add Medical Record</h1>
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
            if (patient != null) {
                String fullName = patient.getFirstName() + " " + patient.getLastName();
            %>
            <div class="form-container">
                <div class="patient-info">
                    <h3>Patient Information</h3>
                    <p><strong>Name:</strong> <%= fullName %></p>
                    <p><strong>Age:</strong> <%= patient.getAge() %> years</p>
                    <p><strong>Gender:</strong> <%= patient.getGender() != null ? patient.getGender() : "Not specified" %></p>
                    <p><strong>Blood Group:</strong> <%= patient.getBloodGroup() != null ? patient.getBloodGroup() : "Not specified" %></p>
                    <p><strong>Allergies:</strong> <%= patient.getAllergies() != null ? patient.getAllergies() : "None" %></p>
                </div>

                <h2 class="page-title">New Medical Record</h2>
                <form action="${pageContext.request.contextPath}/doctor/add-medical-record" method="post">
                    <input type="hidden" name="patientId" value="<%= patient.getId() %>">

                    <div class="form-group">
                        <label for="diagnosis">Diagnosis</label>
                        <textarea id="diagnosis" name="diagnosis" class="form-control" rows="3" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="treatment">Treatment</label>
                        <textarea id="treatment" name="treatment" class="form-control" rows="3" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="notes">Additional Notes</label>
                        <textarea id="notes" name="notes" class="form-control" rows="5"></textarea>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/doctor/view-patient?id=<%= patient.getId() %>" class="btn-secondary">Cancel</a>
                        <button type="submit" class="btn-primary">Save Medical Record</button>
                    </div>
                </form>
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
