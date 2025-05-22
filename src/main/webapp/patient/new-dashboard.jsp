<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get patient data from request attributes
    Patient patient = (Patient) request.getAttribute("patient");
    Integer totalVisits = (Integer) request.getAttribute("totalVisits");
    Integer upcomingVisitsCount = (Integer) request.getAttribute("upcomingVisitsCount");
    Integer totalDoctors = (Integer) request.getAttribute("totalDoctors");
    List<Appointment> upcomingAppointments = (List<Appointment>) request.getAttribute("upcomingAppointments");
    List<Appointment> pastAppointments = (List<Appointment>) request.getAttribute("pastAppointments");
    List<Appointment> cancelledAppointments = (List<Appointment>) request.getAttribute("cancelledAppointments");

    // Set default values if attributes are null
    if (totalVisits == null) totalVisits = 0;
    if (upcomingVisitsCount == null) upcomingVisitsCount = 0;
    if (totalDoctors == null) totalDoctors = 0;
    if (upcomingAppointments == null) upcomingAppointments = new java.util.ArrayList<>();
    if (pastAppointments == null) pastAppointments = new java.util.ArrayList<>();
    if (cancelledAppointments == null) cancelledAppointments = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-profile-image.css">
    <style>
        /* Main Content Styles */
        .main-content {
            flex: 1;
            padding: 20px;
            margin-left: 220px;
            background-color: #f5f5f5;
            min-height: 100vh;
        }

        /* Profile Header */
        .profile-header {
            margin-bottom: 20px;
        }

        .profile-header h2 {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .profile-header p {
            color: #666;
            font-size: 14px;
        }

        /* Profile Card */
        .profile-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        /* Success Message */
        .success-message {
            display: flex;
            align-items: center;
            background-color: #d4edda;
            color: #155724;
            padding: 12px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .success-message i {
            margin-right: 10px;
            font-size: 16px;
        }

        /* Patient Info */
        .patient-info {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .patient-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 20px;
            border: 3px solid #f5f5f5;
        }

        .patient-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .patient-details h3 {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .patient-contact {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .patient-contact p {
            display: flex;
            align-items: center;
            color: #666;
            font-size: 14px;
        }

        .patient-contact p i {
            width: 20px;
            margin-right: 8px;
            color: #4CAF50;
        }

        /* Profile Picture Section */
        .profile-picture-section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            text-align: center;
        }

        .profile-picture-section h3 {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-picture-section h3 i {
            margin-right: 8px;
            color: #4CAF50;
        }

        .profile-picture-actions {
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .btn-upload {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .btn-remove {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .btn-upload i, .btn-remove i {
            margin-right: 5px;
        }

        .btn-upload:hover, .btn-remove:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }

        /* Information Sections */
        .info-section {
            margin-bottom: 20px;
        }

        .info-section h3 {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .info-section h3 i {
            margin-right: 8px;
            color: #4CAF50;
        }

        .form-row {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }

        .form-group {
            flex: 1;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #555;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        /* Form Actions */
        .form-actions {
            text-align: center;
            margin-top: 20px;
            padding: 15px;
            border-top: 1px solid #eee;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
            }
            .form-row {
                flex-direction: column;
            }
        }
    </style>
</head>
<body data-context-path="${pageContext.request.contextPath}">
    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="patient-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Profile Header -->
            <div class="profile-header">
                <h2>My Profile</h2>
                <p>View your registration details</p>
            </div>

            <!-- Profile Card -->
            <div class="profile-card">
                <% if (session.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <span>Profile updated successfully</span>
                </div>
                <% session.removeAttribute("successMessage"); %>
                <% } %>

                <!-- Patient Info -->
                <div class="patient-info">
                    <div class="patient-avatar" data-default-image="/assets/images/patients/default.jpg" data-initials="<%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %>">
                        <%
                        if (patient != null && patient.getProfileImage() != null && !patient.getProfileImage().isEmpty()) {
                        %>
                            <img src="${pageContext.request.contextPath}${patient.getProfileImage()}" alt="<%= user.getFirstName() %>"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/patients/default.jpg'">
                        <% } else { %>
                            <div class="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                        <% } %>
                    </div>
                    <div class="patient-details">
                        <h3><%= user.getFirstName() + " " + user.getLastName() %></h3>
                        <div class="patient-contact">
                            <p><i class="fas fa-envelope"></i> <%= user.getEmail() %></p>
                            <p><i class="fas fa-phone"></i> <%= user.getPhone() != null ? user.getPhone() : "No phone number" %></p>
                        </div>
                    </div>
                </div>

                <!-- Profile Picture Update Section -->
                <div class="profile-picture-section">
                    <h3><i class="fas fa-camera"></i> Update Profile Picture</h3>
                    <div class="profile-picture-actions">
                        <form action="${pageContext.request.contextPath}/patient/profile/update" method="post" enctype="multipart/form-data" id="profile-image-form">
                            <input type="hidden" name="updateType" value="profileImage">
                            <input type="file" id="profileImage" name="profileImage" accept="image/*" style="display: none;">
                            <input type="hidden" id="removeImage" name="removeImage" value="false">
                            <button type="button" class="btn-upload" onclick="document.getElementById('profileImage').click();">
                                <i class="fas fa-upload"></i> Upload New Image
                            </button>
                        </form>
                        <button type="button" class="btn-remove" onclick="removeProfileImage()">
                            <i class="fas fa-trash"></i> Remove Image
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/profile-image-handler.js"></script>
    <script>
        // Set context path for JavaScript
        const contextPath = '${pageContext.request.contextPath}';

        // Initialize profile image handling
        document.addEventListener('DOMContentLoaded', function() {
            handleImageLoadErrors();
        });

        // Handle profile image upload
        document.addEventListener('DOMContentLoaded', function() {
            const profileImage = document.getElementById('profileImage');
            if (profileImage) {
                profileImage.addEventListener('change', function() {
                    if (this.files && this.files[0]) {
                        // Check file size (max 5MB)
                        const fileSize = this.files[0].size / 1024 / 1024;
                        if (fileSize > 5) {
                            alert('File size exceeds 5MB. Please choose a smaller image.');
                            this.value = '';
                            return false;
                        }

                        // Check file type
                        const fileType = this.files[0].type;
                        if (!fileType.match('image.*')) {
                            alert('Please select an image file.');
                            this.value = '';
                            return false;
                        }

                        // Preview image
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const avatarImages = document.querySelectorAll('.patient-avatar img');
                            avatarImages.forEach(img => {
                                img.src = e.target.result;
                            });
                        };
                        reader.readAsDataURL(this.files[0]);

                        // Submit the form
                        document.getElementById('profile-image-form').submit();
                    }
                });
            }
        });

        // Function to remove profile image
        function removeProfileImage() {
            if (confirm('Are you sure you want to remove your profile image?')) {
                // Get all profile image containers
                const imageContainers = document.querySelectorAll('.patient-avatar');

                imageContainers.forEach(container => {
                    // Get the initials from data attribute
                    const initials = container.getAttribute('data-initials');

                    // Find the image element
                    const img = container.querySelector('img');

                    if (img) {
                        // Remove the image
                        img.remove();

                        // Create and add initials element if we have initials data
                        if (initials) {
                            const initialsElement = document.createElement('div');
                            initialsElement.className = 'profile-initials';
                            initialsElement.textContent = initials;
                            container.appendChild(initialsElement);
                        }
                    }
                });

                document.getElementById('removeImage').value = 'true';
                document.getElementById('profile-image-form').submit();
            }
        }
    </script>
</body>
</html>
