<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.DoctorRegistrationRequest" %>
<%@ page import="com.doctorapp.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Request Details | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Include CSS files using JSP include directive -->
    <style>
        <%@ include file="../css/common.css" %>
        <%@ include file="../css/adminDashboard.css" %>
    </style>
    <style>
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }

        .pending {
            background-color: #fff8e1;
            color: #ff8f00;
        }

        .approved {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .rejected {
            background-color: #ffebee;
            color: #c62828;
        }

        /* Improved alert styles */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-weight: 500;
        }

        .alert-success {
            background-color: #e8f5e9;
            color: #2e7d32;
            border-left: 4px solid #2e7d32;
        }

        .alert-danger {
            background-color: #ffebee;
            color: #c62828;
            border-left: 4px solid #c62828;
        }

        .detail-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .detail-header {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .detail-header h3 {
            font-size: 18px;
            font-weight: 600;
            margin: 0;
        }

        .detail-body {
            padding: 20px;
        }

        .detail-row {
            display: flex;
            margin-bottom: 15px;
        }

        .detail-label {
            width: 200px;
            font-weight: 500;
            color: #555;
        }

        .detail-value {
            flex: 1;
        }

        .detail-section {
            margin-bottom: 30px;
        }

        .detail-section h4 {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #f0f0f0;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: #4e73df;
            color: white;
        }

        .btn-success {
            background-color: #1cc88a;
            color: white;
        }

        .btn-danger {
            background-color: #e74a3b;
            color: white;
        }

        .btn i {
            font-size: 14px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #4e73df;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 20px;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .admin-notes {
            background-color: #f8f9fc;
            padding: 15px;
            border-radius: 4px;
            margin-top: 10px;
        }

        .admin-notes h5 {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <img src="../assets/images/logo.png" alt="Logo">
                    <h2>Med<span>Doc</span></h2>
                </div>
                <button id="sidebarClose" class="sidebar-close">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/redirect-dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/doctorDashboard">
                            <i class="fas fa-user-md"></i>
                            <span>Doctors</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/doctor-requests">
                            <i class="fas fa-user-plus"></i>
                            <span>Doctor Requests</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/patients">
                            <i class="fas fa-users"></i>
                            <span>Patients</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/appointments">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/specializations">
                            <i class="fas fa-stethoscope"></i>
                            <span>Specializations</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/reports">
                            <i class="fas fa-chart-bar"></i>
                            <span>Reports</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                    <li class="logout">
                        <a href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="dashboard-main">
            <div class="dashboard-nav">
                <button id="menuToggle" class="menu-toggle">
                    <i class="fas fa-bars"></i>
                </button>

                <div class="nav-right">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search...">
                    </div>

                    <div class="nav-user">
                        <img src="../assets/images/admin-avatar.png" alt="Admin">
                        <div class="user-info">
                            <h4>Administrator</h4>
                            <p>Admin</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <a href="${pageContext.request.contextPath}/admin/doctor-requests" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Doctor Requests
                </a>

                <div class="page-header">
                    <h1>Doctor Registration Request Details</h1>
                    <p>Review doctor registration request</p>
                </div>

                <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("message") %>
                </div>
                <% } %>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                <%
                DoctorRegistrationRequest doctorRequest = (DoctorRegistrationRequest) request.getAttribute("doctorRequest");
                if (doctorRequest != null) {
                %>
                <div class="detail-card">
                    <div class="detail-header">
                        <h3>Request #<%= doctorRequest.getId() %></h3>
                        <span class="status-badge <%= doctorRequest.getStatus().toLowerCase() %>">
                            <%= doctorRequest.getStatus() %>
                        </span>
                    </div>
                    <div class="detail-body">
                        <div class="detail-section">
                            <h4>Personal Information</h4>
                            <div class="detail-row">
                                <div class="detail-label">Full Name</div>
                                <div class="detail-value"><%= doctorRequest.getFirstName() + " " + doctorRequest.getLastName() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Email</div>
                                <div class="detail-value"><%= doctorRequest.getEmail() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Phone</div>
                                <div class="detail-value"><%= doctorRequest.getPhone() != null ? doctorRequest.getPhone() : "Not provided" %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Date of Birth</div>
                                <div class="detail-value"><%= doctorRequest.getDateOfBirth() != null ? doctorRequest.getDateOfBirth() : "Not provided" %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Gender</div>
                                <div class="detail-value"><%= doctorRequest.getGender() != null ? doctorRequest.getGender() : "Not provided" %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Address</div>
                                <div class="detail-value"><%= doctorRequest.getAddress() != null ? doctorRequest.getAddress() : "Not provided" %></div>
                            </div>
                        </div>

                        <div class="detail-section">
                            <h4>Professional Information</h4>
                            <div class="detail-row">
                                <div class="detail-label">Specialization</div>
                                <div class="detail-value"><%= doctorRequest.getSpecialization() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Qualification</div>
                                <div class="detail-value"><%= doctorRequest.getQualification() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Experience</div>
                                <div class="detail-value"><%= doctorRequest.getExperience() != null ? doctorRequest.getExperience() : "Not provided" %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Bio</div>
                                <div class="detail-value"><%= doctorRequest.getBio() != null ? doctorRequest.getBio() : "Not provided" %></div>
                            </div>
                        </div>

                        <div class="detail-section">
                            <h4>Request Information</h4>
                            <div class="detail-row">
                                <div class="detail-label">Request Date</div>
                                <div class="detail-value"><%= doctorRequest.getCreatedAt() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Last Updated</div>
                                <div class="detail-value"><%= doctorRequest.getUpdatedAt() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Status</div>
                                <div class="detail-value">
                                    <span class="status-badge <%= doctorRequest.getStatus().toLowerCase() %>">
                                        <%= doctorRequest.getStatus() %>
                                    </span>
                                </div>
                            </div>

                            <% if (doctorRequest.getAdminNotes() != null && !doctorRequest.getAdminNotes().isEmpty()) { %>
                            <div class="detail-row">
                                <div class="detail-label">Admin Notes</div>
                                <div class="detail-value">
                                    <div class="admin-notes">
                                        <h5>Notes from Administrator:</h5>
                                        <p><%= doctorRequest.getAdminNotes() %></p>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>

                        <% if ("PENDING".equals(doctorRequest.getStatus())) { %>
                        <div class="action-buttons">
                            <button class="btn btn-success" onclick="approveRequest(<%= doctorRequest.getId() %>)">
                                <i class="fas fa-check"></i> Approve Request
                            </button>
                            <button class="btn btn-danger" onclick="rejectRequest(<%= doctorRequest.getId() %>)">
                                <i class="fas fa-times"></i> Reject Request
                            </button>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } else { %>
                <div class="alert alert-danger">
                    Doctor registration request not found.
                </div>
                <% } %>
            </div>

            <!-- Dashboard Footer -->
            <div class="dashboard-footer">
                <p>&copy; 2023 MedDoc. All rights reserved.</p>
                <p>Version 1.0</p>
            </div>
        </div>
    </div>

    <!-- Approve Request Modal -->
    <div id="approveModal" class="modal" style="display: none;">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Approve Doctor Registration</h2>
            <p>Are you sure you want to approve this doctor registration request?</p>
            <form id="approveForm" action="${pageContext.request.contextPath}/admin/doctor-request/approve" method="post">
                <input type="hidden" id="approveId" name="id">
                <div class="form-group">
                    <label for="approveNotes">Admin Notes (Optional)</label>
                    <textarea id="approveNotes" name="adminNotes" rows="4" class="form-control"></textarea>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-secondary" onclick="closeModal('approveModal')">Cancel</button>
                    <button type="submit" class="btn-primary">Approve</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Reject Request Modal -->
    <div id="rejectModal" class="modal" style="display: none;">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Reject Doctor Registration</h2>
            <p>Are you sure you want to reject this doctor registration request?</p>
            <form id="rejectForm" action="${pageContext.request.contextPath}/admin/doctor-request/reject" method="post">
                <input type="hidden" id="rejectId" name="id">
                <div class="form-group">
                    <label for="rejectNotes">Rejection Reason (Required)</label>
                    <textarea id="rejectNotes" name="adminNotes" rows="4" class="form-control" required></textarea>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-secondary" onclick="closeModal('rejectModal')">Cancel</button>
                    <button type="submit" class="btn-primary">Reject</button>
                </div>
            </form>
        </div>
    </div>

    <style>
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
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            width: 500px;
            max-width: 90%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: #333;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
    </style>

    <script>
        // Function to show the approve modal
        function approveRequest(id) {
            document.getElementById('approveId').value = id;
            document.getElementById('approveModal').style.display = 'block';
        }

        // Function to show the reject modal
        function rejectRequest(id) {
            document.getElementById('rejectId').value = id;
            document.getElementById('rejectModal').style.display = 'block';
        }

        // Function to close modals
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        // Close modal when clicking on the X
        var closeButtons = document.getElementsByClassName('close');
        for (var i = 0; i < closeButtons.length; i++) {
            closeButtons[i].addEventListener('click', function() {
                this.parentElement.parentElement.style.display = 'none';
            });
        }

        // Close modal when clicking outside of it
        window.onclick = function(event) {
            if (event.target.className === 'modal') {
                event.target.style.display = 'none';
            }
        };
    </script>
</body>
</html>
