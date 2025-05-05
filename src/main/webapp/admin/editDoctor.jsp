<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.DoctorDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Doctor | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/dashboard.css">
    <style>
        .form-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 20px;
        }
        .form-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #d1d3e2;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            border-color: #4e73df;
            outline: none;
        }
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-col {
            flex: 1;
        }
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
        }
        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
        }
        .btn i {
            margin-right: 5px;
        }
        .btn-primary {
            background-color: #4e73df;
            color: #fff;
        }
        .btn-success {
            background-color: #1cc88a;
            color: #fff;
        }
        .btn-danger {
            background-color: #e74a3b;
            color: #fff;
        }
        .btn-secondary {
            background-color: #858796;
            color: #fff;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
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
        .form-section {
            margin-bottom: 30px;
            border-bottom: 1px solid #e3e6f0;
            padding-bottom: 20px;
        }
        .form-section-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #4e73df;
        }
        .checkbox-group {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 10px;
        }
        .checkbox-item {
            display: flex;
            align-items: center;
        }
        .checkbox-item input {
            margin-right: 5px;
        }
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in and is an admin
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get doctor ID from request parameter
        String doctorIdStr = request.getParameter("id");
        int doctorId = 0;
        Doctor doctor = null;
        
        if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
            try {
                doctorId = Integer.parseInt(doctorIdStr);
                DoctorDAO doctorDAO = new DoctorDAO();
                doctor = doctorDAO.getDoctorById(doctorId);
            } catch (NumberFormatException e) {
                // Invalid doctor ID
            }
        }
        
        if (doctor == null) {
            // Redirect to doctor list if doctor not found
            response.sendRedirect(request.getContextPath() + "/admin/doctors");
            return;
        }
        
        // Check for success message
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");
    %>

    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Dashboard</h3>
            </div>
            
            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/doctors">
                            <i class="fas fa-user-md"></i>
                            <span>Doctors</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/patients">
                            <i class="fas fa-user-injured"></i>
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
                        <a href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h1>Edit Doctor</h1>
                <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Doctors
                </a>
            </div>
            
            <% if (successMessage != null) { %>
            <div class="alert alert-success">
                <%= successMessage %>
            </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
            <div class="alert alert-danger">
                <%= errorMessage %>
            </div>
            <% } %>
            
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/update-doctor" method="post">
                    <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">
                    
                    <div class="form-section">
                        <div class="form-section-title">Personal Information</div>
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="firstName">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" value="<%= doctor.getFirstName() %>" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="lastName">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" value="<%= doctor.getLastName() %>" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="email">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= doctor.getEmail() %>" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="phone">Phone</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" value="<%= doctor.getPhone() %>" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="address">Address</label>
                            <input type="text" class="form-control" id="address" name="address" value="<%= doctor.getAddress() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <div class="form-section-title">Professional Information</div>
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="specialization">Specialization</label>
                                    <select class="form-control" id="specialization" name="specialization" required>
                                        <option value="Cardiology" <%= "Cardiology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Cardiology</option>
                                        <option value="Neurology" <%= "Neurology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Neurology</option>
                                        <option value="Orthopedics" <%= "Orthopedics".equals(doctor.getSpecialization()) ? "selected" : "" %>>Orthopedics</option>
                                        <option value="Pediatrics" <%= "Pediatrics".equals(doctor.getSpecialization()) ? "selected" : "" %>>Pediatrics</option>
                                        <option value="Dermatology" <%= "Dermatology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Dermatology</option>
                                        <option value="Ophthalmology" <%= "Ophthalmology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Ophthalmology</option>
                                        <option value="Gynecology" <%= "Gynecology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Gynecology</option>
                                        <option value="Urology" <%= "Urology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Urology</option>
                                        <option value="Psychiatry" <%= "Psychiatry".equals(doctor.getSpecialization()) ? "selected" : "" %>>Psychiatry</option>
                                        <option value="General Medicine" <%= "General Medicine".equals(doctor.getSpecialization()) ? "selected" : "" %>>General Medicine</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="experience">Years of Experience</label>
                                    <input type="number" class="form-control" id="experience" name="experience" value="<%= doctor.getExperience() %>" min="0" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="qualifications">Qualifications</label>
                            <input type="text" class="form-control" id="qualifications" name="qualifications" value="<%= doctor.getQualifications() %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="bio">Bio/Description</label>
                            <textarea class="form-control" id="bio" name="bio" rows="4"><%= doctor.getBio() %></textarea>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <div class="form-section-title">Consultation Information</div>
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="consultationFee">Consultation Fee ($)</label>
                                    <input type="number" class="form-control" id="consultationFee" name="consultationFee" value="<%= doctor.getConsultationFee() %>" min="0" step="0.01" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="status">Status</label>
                                    <select class="form-control" id="status" name="status" required>
                                        <option value="active" <%= "active".equals(doctor.getStatus()) ? "selected" : "" %>>Active</option>
                                        <option value="inactive" <%= "inactive".equals(doctor.getStatus()) ? "selected" : "" %>>Inactive</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
