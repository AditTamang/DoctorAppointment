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
        .profile-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
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

        .profile-info h2 {
            font-size: 1.8rem;
            margin-bottom: 5px;
            color: #333;
        }

        .profile-info p {
            color: #666;
            margin-bottom: 5px;
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
        }

        .detail-card h3 {
            font-size: 1.2rem;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .detail-item {
            display: flex;
            margin-bottom: 15px;
        }

        .detail-label {
            font-weight: 600;
            width: 40%;
            color: #555;
        }

        .detail-value {
            width: 60%;
            color: #333;
        }

        .edit-profile-btn {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
            transition: background-color 0.3s;
        }

        .edit-profile-btn:hover {
            background-color: #388E3C;
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

            .profile-details {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="user-profile">
                <div class="profile-image">
                    <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                        <div class="profile-initials">AT</div>
                    <% } else { %>
                        <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="Patient">
                    <% } %>
                </div>
                <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
                <p class="user-email"><%= user.getEmail() %></p>
                <p class="user-phone"><%= user.getPhone() != null ? user.getPhone() : "No phone number" %></p>
            </div>

            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/patient/dashboard">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctors">
                        <i class="fas fa-user-md"></i>
                        <span>Find Doctors</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/profile" class="active">
                        <i class="fas fa-user"></i>
                        <span>My Profile</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/patient/changePassword.jsp">
                        <i class="fas fa-lock"></i>
                        <span>Change Password</span>
                    </a>
                </li>
            </ul>

            <div class="logout-btn">
                <a href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>

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

                <div class="profile-details">
                    <div class="detail-card">
                        <h3>Personal Information</h3>
                        <div class="detail-item">
                            <div class="detail-label">Full Name</div>
                            <div class="detail-value"><%= user.getFirstName() + " " + user.getLastName() %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Email</div>
                            <div class="detail-value"><%= user.getEmail() %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Phone</div>
                            <div class="detail-value"><%= user.getPhone() != null ? user.getPhone() : "Not provided" %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Date of Birth</div>
                            <div class="detail-value"><%= user.getDateOfBirth() != null ? user.getDateOfBirth() : "Not provided" %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Gender</div>
                            <div class="detail-value"><%= user.getGender() != null ? user.getGender() : "Not provided" %></div>
                        </div>
                    </div>

                    <div class="detail-card">
                        <h3>Address Information</h3>
                        <div class="detail-item">
                            <div class="detail-label">Address</div>
                            <div class="detail-value"><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></div>
                        </div>

                        <% if (patient != null) { %>
                            <div class="detail-item">
                                <div class="detail-label">Blood Group</div>
                                <div class="detail-value"><%= patient.getBloodGroup() != null ? patient.getBloodGroup() : "Not provided" %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Allergies</div>
                                <div class="detail-value"><%= patient.getAllergies() != null ? patient.getAllergies() : "None" %></div>
                            </div>
                        <% } else { %>
                            <div class="detail-item">
                                <div class="detail-label">Blood Group</div>
                                <div class="detail-value">Not provided</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Allergies</div>
                                <div class="detail-value">None</div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
