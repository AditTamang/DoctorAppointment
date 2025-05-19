<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Patient" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Patient | Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .form-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 20px;
            max-width: 1000px;
            margin-left: auto;
            margin-right: auto;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .form-control:focus {
            border-color: #4e73df;
            outline: none;
            box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.1);
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .form-col {
            flex: 1;
            min-width: 250px;
        }

        .btn-primary, .btn-secondary {
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.3s ease;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background-color: #4e73df;
            color: #fff;
        }

        .btn-primary:hover {
            background-color: #3756a4;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-secondary {
            background-color: #f8f9fc;
            color: #5a5c69;
            border: 1px solid #ddd;
        }

        .btn-secondary:hover {
            background-color: #eaecf4;
            transform: translateY(-2px);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
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
                <h1>Edit Patient</h1>
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
            %>
            <div class="form-container">
                <h2 class="page-title">Edit Patient Information</h2>
                <form action="${pageContext.request.contextPath}/admin/update-patient" method="post">
                    <input type="hidden" name="id" value="<%= patient.getId() %>">

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="firstName">First Name</label>
                                <input type="text" id="firstName" name="firstName" class="form-control" value="<%= patient.getFirstName() %>" required>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="lastName">Last Name</label>
                                <input type="text" id="lastName" name="lastName" class="form-control" value="<%= patient.getLastName() %>" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" class="form-control" value="<%= patient.getEmail() != null ? patient.getEmail() : "" %>">
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="phone">Phone</label>
                                <input type="tel" id="phone" name="phone" class="form-control" value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>">
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="age">Age</label>
                                <input type="number" id="age" name="age" class="form-control" value="<%= patient.getAge() %>" min="0" max="120">
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="gender">Gender</label>
                                <select id="gender" name="gender" class="form-control">
                                    <option value="" <%= patient.getGender() == null || patient.getGender().isEmpty() ? "selected" : "" %>>Select Gender</option>
                                    <option value="Male" <%= "Male".equals(patient.getGender()) ? "selected" : "" %>>Male</option>
                                    <option value="Female" <%= "Female".equals(patient.getGender()) ? "selected" : "" %>>Female</option>
                                    <option value="Other" <%= "Other".equals(patient.getGender()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea id="address" name="address" class="form-control" rows="3"><%= patient.getAddress() != null ? patient.getAddress() : "" %></textarea>
                    </div>

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
                        <a href="${pageContext.request.contextPath}/admin/view-patient?id=<%= patient.getId() %>" class="btn-secondary">Cancel</a>
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
    </script>
</body>
</html>
