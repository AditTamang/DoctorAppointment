<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.MedicalRecord" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Details | Doctor Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .patient-profile {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 20px;
            max-width: 1000px;
            margin-left: auto;
            margin-right: auto;
        }

        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .profile-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 30px;
            border: 4px solid #4e73df;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            flex-shrink: 0;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-image i {
            font-size: 80px;
            color: #aaa;
        }

        .profile-info {
            flex: 1;
            min-width: 250px;
        }

        .profile-info h2 {
            margin: 0 0 5px 0;
            color: #333;
            font-size: 28px;
            font-weight: 600;
        }

        .profile-info p {
            margin: 0 0 12px 0;
            color: #666;
            font-size: 16px;
        }

        .profile-details {
            margin-top: 30px;
        }

        .detail-section {
            margin-bottom: 30px;
            background-color: #f8f9fc;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #4e73df;
        }

        .detail-section h3 {
            margin: 0 0 20px 0;
            color: #333;
            font-size: 20px;
            font-weight: 600;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .detail-row {
            display: flex;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .detail-label {
            width: 180px;
            font-weight: 600;
            color: #555;
            font-size: 14px;
        }

        .detail-value {
            flex: 1;
            color: #333;
            font-size: 15px;
            min-width: 250px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .btn-primary {
            background-color: #4e73df;
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background-color: #3756a4;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
            border: none;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #4e73df;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .back-btn:hover {
            color: #3756a4;
            transform: translateX(-3px);
        }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .appointments-section, .medical-records-section {
            margin-top: 30px;
        }

        .appointments-table, .medical-records-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .appointments-table th, .medical-records-table th {
            background-color: #f8f9fc;
            color: #333;
            font-weight: 600;
            text-align: left;
            padding: 12px 15px;
            border-bottom: 2px solid #e3e6f0;
        }

        .appointments-table td, .medical-records-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #e3e6f0;
            color: #555;
        }

        .appointments-table tr:hover, .medical-records-table tr:hover {
            background-color: #f8f9fc;
        }

        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-scheduled {
            background-color: #cce5ff;
            color: #004085;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .profile-image {
                margin-right: 0;
                margin-bottom: 20px;
            }

            .detail-row {
                flex-direction: column;
            }

            .detail-label {
                width: 100%;
                margin-bottom: 5px;
            }

            .action-buttons {
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
                <h1>Patient Details</h1>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="back-btn">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
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
            List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
            List<MedicalRecord> medicalRecords = (List<MedicalRecord>) request.getAttribute("medicalRecords");

            if (patient != null) {
                String fullName = patient.getFirstName() + " " + patient.getLastName();
                int age = patient.getAge();
                String gender = (patient.getGender() != null) ? patient.getGender() : "Not specified";
                String phone = (patient.getPhone() != null) ? patient.getPhone() : "Not available";
                String email = (patient.getEmail() != null) ? patient.getEmail() : "Not available";
                String address = (patient.getAddress() != null) ? patient.getAddress() : "Not available";
                String bloodGroup = (patient.getBloodGroup() != null) ? patient.getBloodGroup() : "Not specified";
                String allergies = (patient.getAllergies() != null) ? patient.getAllergies() : "None";
                String medicalHistory = (patient.getMedicalHistory() != null) ? patient.getMedicalHistory() : "None";
            %>
            <div class="patient-profile">
                <div class="profile-header">
                    <div class="profile-image">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="profile-info">
                        <h2><%= fullName %></h2>
                        <p><i class="fas fa-birthday-cake"></i> Age: <%= age %> years</p>
                        <p><i class="fas fa-venus-mars"></i> Gender: <%= gender %></p>
                        <p><i class="fas fa-envelope"></i> Email: <%= email %></p>
                        <p><i class="fas fa-phone"></i> Phone: <%= phone %></p>
                    </div>
                </div>

                <div class="profile-details">
                    <div class="detail-section">
                        <h3>Personal Information</h3>
                        <div class="detail-row">
                            <div class="detail-label">Address</div>
                            <div class="detail-value"><%= address %></div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Blood Group</div>
                            <div class="detail-value"><%= bloodGroup %></div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Allergies</div>
                            <div class="detail-value"><%= allergies %></div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Medical History</div>
                            <div class="detail-value"><%= medicalHistory %></div>
                        </div>
                    </div>

                    <% if (appointments != null && !appointments.isEmpty()) { %>
                    <div class="appointments-section">
                        <h3>Appointment History</h3>
                        <table class="appointments-table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Appointment appointment : appointments) { %>
                                <tr>
                                    <td><%= appointment.getAppointmentDate() %></td>
                                    <td><%= appointment.getAppointmentTime() %></td>
                                    <td><%= appointment.getReason() != null ? appointment.getReason() : "Not specified" %></td>
                                    <td>
                                        <span class="status status-<%= appointment.getStatus().toLowerCase() %>">
                                            <%= appointment.getStatus() %>
                                        </span>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="detail-section">
                        <h3>Appointment History</h3>
                        <p>No appointments found for this patient.</p>
                    </div>
                    <% } %>

                    <% if (medicalRecords != null && !medicalRecords.isEmpty()) { %>
                    <div class="medical-records-section">
                        <h3>Medical Records</h3>
                        <table class="medical-records-table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Diagnosis</th>
                                    <th>Treatment</th>
                                    <th>Notes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (MedicalRecord record : medicalRecords) { %>
                                <tr>
                                    <td><%= record.getRecordDate() %></td>
                                    <td><%= record.getDiagnosis() != null ? record.getDiagnosis() : "Not specified" %></td>
                                    <td><%= record.getTreatment() != null ? record.getTreatment() : "Not specified" %></td>
                                    <td><%= record.getNotes() != null ? record.getNotes() : "None" %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="detail-section">
                        <h3>Medical Records</h3>
                        <p>No medical records found for this patient.</p>
                    </div>
                    <% } %>
                </div>

                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/doctor/edit-patient?id=<%= patient.getId() %>" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Edit Patient Information
                    </a>
                    <a href="${pageContext.request.contextPath}/doctor/add-medical-record?patientId=<%= patient.getId() %>" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add Medical Record
                    </a>
                </div>
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
