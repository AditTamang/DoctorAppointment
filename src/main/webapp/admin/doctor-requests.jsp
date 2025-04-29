<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
 <%@ page import="java.util.List" %>
 <%@ page import="com.doctorapp.model.DoctorRegistrationRequest" %>
 <%@ page import="com.doctorapp.model.User" %>
 <!DOCTYPE html>
 <html lang="en">
 <head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>Doctor Registration Requests | Admin Dashboard</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
     <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
     <!-- Include CSS files using JSP include directive -->
     <style>
         <%@ include file="../css/common.css" %>
         <%@ include file="../css/adminDashboard.css" %>
     </style>
     <style>
         /* Status badges */
         .status-badge {
             display: inline-block;
             padding: 4px 8px;
             border-radius: 4px;
             font-size: 12px;
             font-weight: 600;
             text-transform: uppercase;
             letter-spacing: 0.5px;
         }
 
         .status-pending {
             background-color: #fff8e1;
             color: #ff9800;
             border: 1px solid #ffcc80;
         }
 
         .status-approved {
             background-color: #e8f5e9;
             color: #4caf50;
             border: 1px solid #a5d6a7;
         }
 
         .status-rejected {
             background-color: #ffebee;
             color: #f44336;
             border: 1px solid #ef9a9a;
         }
 
         /* Card header styling */
         .card-header {
             display: flex;
             justify-content: space-between;
             align-items: center;
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
                         <a href="${pageContext.request.contextPath}/dashboard">
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
                 <div class="page-header">
                     <h1>Doctor Registration Requests</h1>
                     <p>Manage doctor registration requests</p>
                 </div>
 
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
                 <div class="alert alert-success">
                     <%= message %>
                 </div>
                 <% } %>
 
                 <% if (error != null) { %>
                 <div class="alert alert-danger">
                     <%= error %>
                 </div>
                 <% } %>
 
                 <div class="card">
                     <div class="card-header">
                         <h3>Pending Doctor Requests</h3>
                         <h3>Doctor Registration Requests</h3>
                     </div>
                     <div class="card-body">
                         <%
                         List<DoctorRegistrationRequest> requests = (List<DoctorRegistrationRequest>) request.getAttribute("requests");
                         if (requests != null && !requests.isEmpty()) {
                         %>
                         <div class="table-responsive">
                             <table class="request-table">
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
                                                 <a href="${pageContext.request.contextPath}/admin/doctor-request/view?id=<%= req.getId() %>" class="btn-icon btn-view" title="View Details">
                                                     <i class="fas fa-eye"></i>
                                                 </a>
                                                 <% if ("PENDING".equals(req.getStatus())) { %>
                                                 <a href="#" class="btn-icon btn-approve" title="Approve" onclick="approveRequest(<%= req.getId() %>)">
                                                     <i class="fas fa-check"></i>
                                                 </a>
                                                 <a href="#" class="btn-icon btn-reject" title="Reject" onclick="rejectRequest(<%= req.getId() %>)">
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
 
         // No filter function needed as we only show pending requests
     </script>
 </body>
 </html>