<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.DoctorRegistrationRequest" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Registration Requests | Admin Dashboard</title>
    <!-- Include CSS files -->
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom Framework CSS (Bootstrap Replacement) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-framework.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            border-radius: 10px 10px 0 0;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Status badges */
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-pending {
            background-color: #f6c23e;
            color: white;
        }

        .status-approved {
            background-color: #1cc88a;
            color: white;
        }

        .status-rejected {
            background-color: #e74a3b;
            color: white;
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

        .request-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .request-table th, .request-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        .request-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        .request-table tr:hover {
            background-color: #f9f9f9;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-icon {
            width: 32px;
            height: 32px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-icon:hover {
            opacity: 0.8;
        }

        .btn-view {
            background-color: #4e73df;
        }

        .btn-approve {
            background-color: #1cc88a;
        }

        .btn-reject {
            background-color: #e74a3b;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            background-color: #f8f9fc;
            border-radius: 8px;
            margin-top: 20px;
        }

        .empty-state i {
            font-size: 48px;
            color: #d1d3e2;
            margin-bottom: 15px;
        }

        .empty-state h3 {
            font-size: 18px;
            color: #5a5c69;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #858796;
            max-width: 500px;
            margin: 0 auto;
        }
        /* Sidebar styles */
        .sidebar {
            width: 250px;
            height: 100vh;
            background-color: #343a40;
            color: #fff;
            position: fixed;
            top: 0;
            left: 0;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid #4b545c;
        }

        .sidebar-header h3 {
            margin: 0;
            font-size: 1.5rem;
            color: #fff;
        }

        .profile-info {
            margin-top: 15px;
        }

        .user-name {
            font-weight: bold;
            font-size: 1rem;
        }

        .user-role {
            font-size: 0.8rem;
            color: #adb5bd;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .menu-item {
            margin: 0;
        }

        .menu-item.active .menu-link {
            background-color: #4e73df;
        }

        .menu-link {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: #fff;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .menu-link:hover {
            background-color: #4b545c;
            color: #fff;
            text-decoration: none;
        }

        .menu-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
    </style>
</head>
<body>
    <!-- Include the standardized sidebar -->
    <jsp:include page="admin-sidebar.jsp" />

    <div class="main-content">
        <div class="container-fluid p-4">
            <h1 class="h3 mb-4 text-gray-800">Doctor Registration Requests</h1>
            <p class="mb-4">Manage doctor registration requests</p>

            <%
            // Check for messages in both request and session
            String message = (String) request.getAttribute("message");
            String error = (String) request.getAttribute("error");

            // Check session for messages
            if (message == null) {
                message = (String) session.getAttribute("message");
                if (message != null) {
                    // Remove from session after displaying
                    session.removeAttribute("message");
                }
            }

            if (error == null) {
                error = (String) session.getAttribute("error");
                if (error != null) {
                    // Remove from session after displaying
                    session.removeAttribute("error");
                }
            }

            if (message != null) {
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Success!</strong> <%= message %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <% } %>

            <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error!</strong> <%= error %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <% } %>

            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h6 class="m-0 font-weight-bold">Doctor Registration Requests</h6>
                </div>
                <div class="card-body">
                    <%
                    List<DoctorRegistrationRequest> requests = (List<DoctorRegistrationRequest>) request.getAttribute("requests");
                    if (requests != null && !requests.isEmpty()) {
                    %>
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Specialization</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (DoctorRegistrationRequest req : requests) { %>
                                <tr>
                                    <td><%= req.getId() %></td>
                                    <td><%= req.getFirstName() + " " + req.getLastName() %></td>
                                    <td><%= req.getEmail() %></td>
                                    <td><%= req.getSpecialization() %></td>
                                    <td><%= req.getCreatedAt() %></td>
                                    <td>
                                        <%
                                        String status = req.getStatus();
                                        String statusClass = "";

                                        if ("PENDING".equals(status)) {
                                            statusClass = "status-pending";
                                        } else if ("APPROVED".equals(status)) {
                                            statusClass = "status-approved";
                                        } else if ("REJECTED".equals(status)) {
                                            statusClass = "status-rejected";
                                        }
                                        %>
                                        <span class="status-badge <%= statusClass %>"><%= status %></span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/doctor-request/view?id=<%= req.getId() %>" class="btn btn-sm btn-info" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <% if ("PENDING".equals(req.getStatus())) { %>
                                            <a href="#" class="btn btn-sm btn-success" title="Approve" onclick="approveRequest(<%= req.getId() %>)">
                                                <i class="fas fa-check"></i>
                                            </a>
                                            <a href="#" class="btn btn-sm btn-danger" title="Reject" onclick="rejectRequest(<%= req.getId() %>)">
                                                <i class="fas fa-times"></i>
                                            </a>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-user-md"></i>
                        <h3>No Doctor Registration Requests</h3>
                        <p>There are no doctor registration requests at the moment. New requests will appear here when doctors register.</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- Approve Request Modal -->
    <div id="approveModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Approve Doctor Registration</h5>
                <button type="button" class="close" onclick="closeModal('approveModal')">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to approve this doctor registration request?</p>
                <form id="approveForm" action="${pageContext.request.contextPath}/admin/doctor-request/approve" method="post">
                    <input type="hidden" id="approveId" name="id">
                    <div class="form-group">
                        <label for="approveNotes">Admin Notes (Optional)</label>
                        <textarea id="approveNotes" name="adminNotes" rows="4" class="form-control"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('approveModal')">Cancel</button>
                <button type="button" class="btn btn-success" onclick="document.getElementById('approveForm').submit()">Approve</button>
            </div>
        </div>
    </div>

    <!-- Reject Request Modal -->
    <div id="rejectModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Reject Doctor Registration</h5>
                <button type="button" class="close" onclick="closeModal('rejectModal')">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to reject this doctor registration request?</p>
                <form id="rejectForm" action="${pageContext.request.contextPath}/admin/doctor-request/reject" method="post">
                    <input type="hidden" id="rejectId" name="id">
                    <div class="form-group">
                        <label for="rejectNotes">Rejection Reason (Required)</label>
                        <textarea id="rejectNotes" name="adminNotes" rows="4" class="form-control" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('rejectModal')">Cancel</button>
                <button type="button" class="btn btn-danger" onclick="document.getElementById('rejectForm').submit()">Reject</button>
            </div>
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
            border-radius: 8px;
            width: 500px;
            max-width: 90%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 20px;
            border-bottom: 1px solid #e3e6f0;
        }

        .modal-title {
            margin: 0;
            font-weight: 600;
            color: #333;
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding: 15px 20px;
            border-top: 1px solid #e3e6f0;
        }

        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            background: none;
            border: none;
            padding: 0;
        }

        .close:hover {
            color: #333;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #d1d3e2;
            border-radius: 4px;
            font-size: 14px;
        }
    </style>

    <!-- Include JavaScript files -->
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>

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

        // Close modal when clicking outside of it
        window.onclick = function(event) {
            if (event.target.className === 'modal') {
                event.target.style.display = 'none';
            }
        };
    </script>
</body>
</html>