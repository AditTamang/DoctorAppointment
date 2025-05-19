<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.PatientDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Management | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .patient-list {
            margin-top: 20px;
        }
        .patient-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .patient-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .patient-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-size: 30px;
            color: #777;
            flex-shrink: 0;
        }
        .patient-info {
            flex: 1;
        }
        .patient-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #333;
        }
        .patient-details {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 10px;
        }
        .patient-detail {
            display: flex;
            align-items: center;
            font-size: 14px;
            color: #666;
        }
        .patient-detail i {
            margin-right: 5px;
            color: #4e73df;
            width: 16px;
        }
        .patient-actions {
            display: flex;
            gap: 10px;
        }
        .btn-action {
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        .btn-action i {
            margin-right: 5px;
        }
        .btn-view {
            background-color: #4e73df;
            color: white;
        }
        .btn-view:hover {
            background-color: #3756a4;
        }
        .btn-edit {
            background-color: #36b9cc;
            color: white;
        }
        .btn-edit:hover {
            background-color: #2a8c9a;
        }
        .btn-delete {
            background-color: #e74a3b;
            color: white;
        }
        .btn-delete:hover {
            background-color: #c13325;
        }
        .search-bar {
            display: flex;
            margin-bottom: 20px;
        }
        .search-input {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px 0 0 4px;
            font-size: 14px;
        }
        .search-btn {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 0 20px;
            border-radius: 0 4px 4px 0;
            cursor: pointer;
        }
        .no-data {
            background-color: #f8f9fc;
            padding: 30px;
            text-align: center;
            border-radius: 8px;
            margin-top: 20px;
        }
        .no-data p {
            color: #666;
            font-size: 16px;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .btn-primary {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        .btn-primary i {
            margin-right: 5px;
        }
        .btn-primary:hover {
            background-color: #3756a4;
            transform: translateY(-2px);
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

        /* Responsive styles */
        @media (max-width: 768px) {
            .patient-card {
                flex-direction: column;
                text-align: center;
            }
            .patient-avatar {
                margin-right: 0;
                margin-bottom: 15px;
            }
            .patient-details {
                justify-content: center;
            }
            .patient-actions {
                margin-top: 15px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in and is an admin
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get patients from request attribute (set by AdminPatientsServlet)
        List<Patient> patients = (List<Patient>) request.getAttribute("patients");
        if (patients == null) {
            // Fallback to direct DAO access if attribute is not set
            PatientDAO patientDAO = new PatientDAO();
            patients = patientDAO.getAllPatients();
        }
    %>

    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="admin-sidebar.jsp">
            <jsp:param name="activePage" value="patients" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h1>Patient Management</h1>
                <a href="${pageContext.request.contextPath}/admin/add-patient" class="btn-primary">
                    <i class="fas fa-plus"></i> Add New Patient
                </a>
            </div>

            <!-- Search and Filter -->
            <form action="${pageContext.request.contextPath}/admin/patients" method="get" class="search-bar">
                <input type="text" name="search" class="search-input" placeholder="Search patients by name or email..."
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="search-btn">
                    <i class="fas fa-search"></i>
                </button>
            </form>

            <!-- Patient List -->
            <div class="patient-list">
                <% if (patients != null && !patients.isEmpty()) {
                    for (Patient patient : patients) { %>
                <div class="patient-card">
                    <div class="patient-avatar">
                        <% if (patient.getProfileImage() != null && !patient.getProfileImage().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}${patient.getProfileImage()}" alt="<%= patient.getFirstName() %>" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                        <% } else { %>
                            <i class="fas fa-user"></i>
                        <% } %>
                    </div>
                    <div class="patient-info">
                        <h3 class="patient-name"><%= patient.getFirstName() + " " + patient.getLastName() %></h3>
                        <div class="patient-details">
                            <div class="patient-detail">
                                <i class="fas fa-envelope"></i>
                                <%= patient.getEmail() != null ? patient.getEmail() : "No email" %>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-phone"></i>
                                <%= patient.getPhone() != null ? patient.getPhone() : "No phone" %>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-birthday-cake"></i>
                                <%= patient.getAge() > 0 ? patient.getAge() + " years" : "Age not specified" %>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-venus-mars"></i>
                                <%= patient.getGender() != null ? patient.getGender() : "Not specified" %>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-tint"></i>
                                <%= patient.getBloodGroup() != null ? patient.getBloodGroup() : "Not specified" %>
                            </div>
                        </div>
                        <div class="patient-actions">
                            <a href="${pageContext.request.contextPath}/admin/view-patient?id=<%= patient.getId() %>" class="btn-action btn-view">
                                <i class="fas fa-eye"></i> View
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/edit-patient?id=<%= patient.getId() %>" class="btn-action btn-edit">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="#" class="btn-action btn-delete" onclick="confirmDelete(<%= patient.getId() %>)">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="no-data">
                    <p>No patients found.</p>
                </div>
                <% } %>
            </div>
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
