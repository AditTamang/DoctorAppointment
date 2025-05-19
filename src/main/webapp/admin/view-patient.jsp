<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Patient" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Details | Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
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
            display: flex;
            align-items: center;
        }

        .profile-info p i {
            margin-right: 10px;
            color: #4e73df;
            width: 20px;
            text-align: center;
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

        .btn-danger {
            background-color: #e74a3b;
            color: white;
            border: none;
        }

        .btn-danger:hover {
            background-color: #c23321;
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

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }
        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border-radius: 8px;
            width: 400px;
            max-width: 90%;
            text-align: center;
        }
        .modal-title {
            margin-top: 0;
            color: #333;
        }
        .modal-text {
            margin-bottom: 20px;
            color: #666;
        }
        .modal-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .btn-modal {
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: 500;
            cursor: pointer;
            border: none;
            transition: all 0.3s ease;
        }
        .btn-confirm {
            background-color: #e74a3b;
            color: white;
        }
        .btn-confirm:hover {
            background-color: #c13325;
        }
        .btn-cancel {
            background-color: #f8f9fc;
            color: #666;
            border: 1px solid #ddd;
        }
        .btn-cancel:hover {
            background-color: #eaecf4;
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

            .profile-info p {
                justify-content: center;
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
        <!-- Include the standardized sidebar -->
        <jsp:include page="admin-sidebar.jsp">
            <jsp:param name="activePage" value="patients" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <a href="${pageContext.request.contextPath}/admin/patients" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Patients
            </a>

            <div class="page-header">
                <h1>Patient Details</h1>
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
                        <% if (patient.getProfileImage() != null && !patient.getProfileImage().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}${patient.getProfileImage()}" alt="<%= fullName %>">
                        <% } else { %>
                            <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="<%= fullName %>">
                        <% } %>
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
                    </div>

                    <div class="detail-section">
                        <h3>Medical Information</h3>
                        <div class="detail-row">
                            <div class="detail-label">Allergies</div>
                            <div class="detail-value"><%= allergies %></div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Medical History</div>
                            <div class="detail-value"><%= medicalHistory %></div>
                        </div>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/admin/edit-patient?id=<%= patient.getId() %>" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Edit Patient
                    </a>
                    <a href="#" onclick="confirmDelete(<%= patient.getId() %>)" class="btn btn-danger">
                        <i class="fas fa-trash"></i> Delete Patient
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

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h3 class="modal-title">Confirm Deletion</h3>
            <p class="modal-text">Are you sure you want to delete this patient? This action cannot be undone.</p>
            <div class="modal-actions">
                <button class="btn-modal btn-cancel" onclick="closeModal()">Cancel</button>
                <a href="#" id="confirmDeleteBtn" class="btn-modal btn-confirm">Delete</a>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar on mobile
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menuToggle');
            if (menuToggle) {
                menuToggle.addEventListener('click', function() {
                    document.querySelector('.sidebar').classList.toggle('active');
                });
            }
        });

        // Delete confirmation modal
        function confirmDelete(patientId) {
            document.getElementById('deleteModal').style.display = 'block';
            document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/admin/delete-patient?id=' + patientId;
        }

        function closeModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
</html>
