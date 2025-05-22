<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Patient" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Patient | Doctor Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
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
                <h1>Edit Patient Information</h1>
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
                <h2 class="page-title">Edit <%= fullName %>'s Medical Information</h2>
                <form action="${pageContext.request.contextPath}/doctor/edit-patient" method="post">
                    <input type="hidden" name="id" value="<%= patient.getId() %>">

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="bloodGroup">Blood Group</label>
                                <select id="bloodGroup" name="bloodGroup" class="form-control">
                                    <option value="" <%= patient.getBloodGroup() == null || patient.getBloodGroup().isEmpty() ? "selected" : "" %>>Select Blood Group</option>
                                    <option value="A+" <%= "A+".equals(patient.getBloodGroup()) ? "selected" : "" %>>A+</option>
                                    <option value="A-" <%= "A-".equals(patient.getBloodGroup()) ? "selected" : "" %>>A-</option>
                                    <option value="B+" <%= "B+".equals(patient.getBloodGroup()) ? "selected" : "" %>>B+</option>
                                    <option value="B-" <%= "B-".equals(patient.getBloodGroup()) ? "selected" : "" %>>B-</option>
                                    <option value="AB+" <%= "AB+".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB+</option>
                                    <option value="AB-" <%= "AB-".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB-</option>
                                    <option value="O+" <%= "O+".equals(patient.getBloodGroup()) ? "selected" : "" %>>O+</option>
                                    <option value="O-" <%= "O-".equals(patient.getBloodGroup()) ? "selected" : "" %>>O-</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="allergies">Allergies</label>
                        <textarea id="allergies" name="allergies" class="form-control" rows="3"><%= patient.getAllergies() != null ? patient.getAllergies() : "" %></textarea>
                    </div>

                    <div class="form-group">
                        <label for="medicalHistory">Medical History</label>
                        <textarea id="medicalHistory" name="medicalHistory" class="form-control" rows="5"><%= patient.getMedicalHistory() != null ? patient.getMedicalHistory() : "" %></textarea>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/doctor/view-patient?id=<%= patient.getId() %>" class="btn-secondary">Cancel</a>
                        <button type="submit" class="btn-primary">Update Patient</button>
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
