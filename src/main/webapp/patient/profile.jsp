<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get patient data from request attributes if available
    Patient patient = (Patient) request.getAttribute("patient");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patientDashboard.css">
    <style>
        /* Profile Page Specific Styles */
        .profile-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
            width: 100%;
        }

        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 30px;
            border: 5px solid #f0f0f0;
            flex-shrink: 0;
        }

        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-initials {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #4CAF50;
            color: white;
            font-size: 2.5rem;
            font-weight: 600;
        }

        .profile-info {
            flex: 1;
        }

        .profile-info h2 {
            font-size: 1.8rem;
            margin-bottom: 10px;
            color: #333;
        }

        .profile-info p {
            color: #666;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .profile-info p i {
            margin-right: 10px;
            color: #4CAF50;
            width: 20px;
            text-align: center;
        }

        .profile-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
        }

        .detail-card {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .detail-card h3 {
            font-size: 1.2rem;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .detail-card h3 i {
            margin-right: 10px;
            color: #4CAF50;
        }

        .detail-item {
            display: flex;
            margin-bottom: 15px;
        }

        .detail-label {
            font-weight: 600;
            width: 40%;
            color: #555;
            padding-right: 15px;
        }

        .detail-value {
            width: 60%;
            color: #333;
        }

        .edit-profile-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
            transition: all 0.3s ease;
            border: none;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
        }

        .edit-profile-btn i {
            margin-right: 8px;
        }

        .edit-profile-btn:hover {
            background-color: #388E3C;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Form Styles */
        input[type="text"],
        input[type="tel"],
        input[type="email"],
        input[type="date"],
        select,
        textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #fff;
        }

        input[type="text"]:focus,
        input[type="tel"]:focus,
        input[type="email"]:focus,
        input[type="date"]:focus,
        select:focus,
        textarea:focus {
            border-color: #4CAF50;
            outline: none;
            box-shadow: 0 0 8px rgba(76, 175, 80, 0.3);
        }

        .form-error {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: flex;
            align-items: center;
        }

        .form-error:before {
            content: "⚠";
            margin-right: 5px;
        }

        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .alert i {
            margin-right: 10px;
            font-size: 18px;
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

        @media (max-width: 992px) {
            .profile-details {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }

        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
            }

            .profile-image {
                margin-right: 0;
                margin-bottom: 20px;
            }

            .detail-item {
                flex-direction: column;
            }

            .detail-label, .detail-value {
                width: 100%;
            }

            .detail-label {
                margin-bottom: 5px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="patient-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="dashboard-header">
                <div class="welcome-text">
                    <h2>My Profile</h2>
                    <p>View your registration details</p>
                </div>
            </div>

            <!-- Profile Content -->
            <div class="profile-container">
                <div class="profile-header">
                    <div class="profile-image">
                        <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                            <div class="profile-initials">AT</div>
                        <% } else { %>
                            <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="Patient">
                        <% } %>
                    </div>
                    <div class="profile-info">
                        <h2><%= user.getFirstName() + " " + user.getLastName() %></h2>
                        <p><i class="fas fa-envelope"></i> <%= user.getEmail() %></p>
                        <p><i class="fas fa-phone"></i> <%= user.getPhone() != null ? user.getPhone() : "No phone number" %></p>
                    </div>
                </div>

                <!-- Success or Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${successMessage}
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>

                <!-- Profile Form -->
                <form action="${pageContext.request.contextPath}/patient/profile/update" method="post">
                    <div class="profile-details">
                        <div class="detail-card">
                            <h3><i class="fas fa-user"></i> Personal Information</h3>
                            <div class="detail-item">
                                <div class="detail-label">First Name</div>
                                <div class="detail-value">
                                    <input type="text" name="firstName" value="<%= user.getFirstName() %>" required>
                                    <c:if test="${not empty firstNameError}">
                                        <div class="form-error">${firstNameError}</div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Last Name</div>
                                <div class="detail-value">
                                    <input type="text" name="lastName" value="<%= user.getLastName() %>" required>
                                    <c:if test="${not empty lastNameError}">
                                        <div class="form-error">${lastNameError}</div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Email</div>
                                <div class="detail-value"><%= user.getEmail() %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Phone</div>
                                <div class="detail-value">
                                    <input type="tel" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
                                    <c:if test="${not empty phoneError}">
                                        <div class="form-error">${phoneError}</div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Date of Birth</div>
                                <div class="detail-value">
                                    <input type="date" name="dateOfBirth" value="<%= user.getDateOfBirth() != null ? user.getDateOfBirth() : "" %>">
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Gender</div>
                                <div class="detail-value">
                                    <select name="gender">
                                        <option value="" <%= user.getGender() == null ? "selected" : "" %>>Select Gender</option>
                                        <option value="Male" <%= "Male".equals(user.getGender()) ? "selected" : "" %>>Male</option>
                                        <option value="Female" <%= "Female".equals(user.getGender()) ? "selected" : "" %>>Female</option>
                                        <option value="Other" <%= "Other".equals(user.getGender()) ? "selected" : "" %>>Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="detail-card">
                            <h3><i class="fas fa-heartbeat"></i> Medical Information</h3>
                            <div class="detail-item">
                                <div class="detail-label">Address</div>
                                <div class="detail-value">
                                    <textarea name="address" rows="3"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">Blood Group</div>
                                <div class="detail-value">
                                    <select name="bloodGroup">
                                        <option value="" <%= patient == null || patient.getBloodGroup() == null ? "selected" : "" %>>Select Blood Group</option>
                                        <option value="A+" <%= patient != null && "A+".equals(patient.getBloodGroup()) ? "selected" : "" %>>A+</option>
                                        <option value="A-" <%= patient != null && "A-".equals(patient.getBloodGroup()) ? "selected" : "" %>>A-</option>
                                        <option value="B+" <%= patient != null && "B+".equals(patient.getBloodGroup()) ? "selected" : "" %>>B+</option>
                                        <option value="B-" <%= patient != null && "B-".equals(patient.getBloodGroup()) ? "selected" : "" %>>B-</option>
                                        <option value="AB+" <%= patient != null && "AB+".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB+</option>
                                        <option value="AB-" <%= patient != null && "AB-".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB-</option>
                                        <option value="O+" <%= patient != null && "O+".equals(patient.getBloodGroup()) ? "selected" : "" %>>O+</option>
                                        <option value="O-" <%= patient != null && "O-".equals(patient.getBloodGroup()) ? "selected" : "" %>>O-</option>
                                    </select>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Allergies</div>
                                <div class="detail-value">
                                    <textarea name="allergies" rows="3"><%= patient != null && patient.getAllergies() != null ? patient.getAllergies() : "" %></textarea>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Medical History</div>
                                <div class="detail-value">
                                    <textarea name="medicalHistory" rows="5"><%= patient != null && patient.getMedicalHistory() != null ? patient.getMedicalHistory() : "" %></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div style="text-align: center; margin-top: 20px;">
                        <button type="submit" class="edit-profile-btn">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
