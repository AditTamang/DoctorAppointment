<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor data from request attribute
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    if (doctor == null) {
        // Redirect to profile servlet to load the data
        response.sendRedirect(request.getContextPath() + "/doctor/profile");
        return;
    }

    // Get doctor information
    String doctorName = "Dr. " + user.getFirstName() + " " + user.getLastName();
    String specialty = doctor.getSpecialization() != null ? doctor.getSpecialization() : "Cardiologist";
    String university = "Harvard University"; // This should be fetched from the database
    String qualification = doctor.getQualification() != null ? doctor.getQualification() : "MD, PHD";
    String email = doctor.getEmail() != null ? doctor.getEmail() : user.getEmail();
    String phone = doctor.getPhone() != null ? doctor.getPhone() : user.getPhone();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctorDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
    <style>
        /* Main Content Styling */
        .main-content {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .profile-edit-container {
            background-color: #fff;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            width: 100%;
            max-width: 900px;
        }

        .profile-edit-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .profile-edit-header h2 {
            font-size: 22px;
            font-weight: 600;
            color: #333;
        }

        .profile-edit-content {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
        }

        .form-group {
            margin-bottom: 20px;
            background-color: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        .form-group:hover {
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #555;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #4361ee;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
            outline: none;
        }

        .form-group textarea {
            height: 120px;
            resize: vertical;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .profile-image-upload {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            width: 100%;
        }

        .profile-image-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 25px;
            border: 4px solid #f0f2f5;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .profile-image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-image-actions {
            display: flex;
            flex-direction: column;
            gap: 12px;
            flex: 1;
        }

        .profile-actions {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            justify-content: center;
            width: 100%;
        }

        .profile-actions button,
        .profile-actions a {
            padding: 12px 25px;
            font-size: 15px;
            font-weight: 600;
            border-radius: 6px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .profile-actions button:hover,
        .profile-actions a:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        .profile-actions .btn-primary {
            background-color: #4361ee;
            color: white;
            border: none;
        }

        .profile-actions .btn-primary:hover {
            background-color: #3a56d4;
        }

        .alert {
            padding: 15px;
            margin-bottom: 25px;
            border: 1px solid transparent;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
            width: 100%;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .alert i {
            margin-right: 10px;
            font-size: 16px;
        }

        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        @media (max-width: 768px) {
            .profile-edit-container {
                padding: 15px;
                margin-bottom: 20px;
            }

            .profile-edit-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }

            .profile-edit-content {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .form-group.full-width {
                grid-column: span 1;
            }

            .profile-image-upload {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .profile-image-preview {
                margin-right: 0;
                margin-bottom: 15px;
            }

            .profile-image-actions {
                width: 100%;
            }

            .profile-actions {
                flex-direction: column;
                width: 100%;
            }

            .profile-actions button,
            .profile-actions a {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .profile-edit-container {
                padding: 12px;
            }

            .form-group {
                padding: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <div class="top-header-left">
                    <a href="${pageContext.request.contextPath}/doctor/profile" class="active">Profile</a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments">Appointment Management</a>
                    <a href="${pageContext.request.contextPath}/doctor/patients">Patient Details</a>
                </div>

                <div class="top-header-right">
                    <div class="search-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="user-profile-icon">
                        <%
                        String headerImagePath = "";
                        if (doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty()) {
                            headerImagePath = request.getContextPath() + doctor.getProfileImage();
                        } else if (doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty()) {
                            headerImagePath = request.getContextPath() + doctor.getImageUrl();
                        } else {
                            headerImagePath = request.getContextPath() + "/assets/images/doctors/default-doctor.png";
                        }
                        %>
                        <img src="<%= headerImagePath %>" alt="Doctor">
                    </div>
                </div>
            </div>

            <!-- Edit Profile Form -->
            <div class="profile-edit-container">
                <div class="profile-edit-header">
                    <h2>Edit Profile</h2>
                    <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Back to Profile
                    </a>
                </div>

                <form id="edit-profile-form" action="${pageContext.request.contextPath}/doctor/profile/update" method="post" enctype="multipart/form-data" onsubmit="return validateForm();">
                    <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">
                    <!-- Add success/error message display -->
                    <% if (request.getAttribute("successMessage") != null) { %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <%= request.getAttribute("successMessage") %>
                        </div>
                    <% } %>
                    <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("errorMessage") %>
                        </div>
                    <% } %>

                    <div class="profile-image-upload">
                        <div class="profile-image-preview">
                            <%
                            String previewImagePath = "";
                            if (doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty()) {
                                previewImagePath = request.getContextPath() + doctor.getProfileImage();
                            } else if (doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty()) {
                                previewImagePath = request.getContextPath() + doctor.getImageUrl();
                            } else {
                                previewImagePath = request.getContextPath() + "/assets/images/doctors/default-doctor.png";
                            }
                            %>
                            <img src="<%= previewImagePath %>" alt="Doctor" id="profile-preview">
                        </div>
                        <div class="profile-image-actions">
                            <input type="file" id="profile-image" name="profileImage" accept="image/*" style="display: none;">
                            <button type="button" class="btn btn-outline" id="upload-btn">
                                <i class="fas fa-upload"></i> Upload Image
                            </button>
                            <button type="button" class="btn btn-outline" id="remove-btn">
                                <i class="fas fa-trash"></i> Remove Image
                            </button>
                        </div>
                    </div>

                    <div class="profile-edit-content">
                        <div class="form-group">
                            <label for="first-name">First Name</label>
                            <input type="text" id="first-name" name="firstName" value="<%= user.getFirstName() %>">
                        </div>

                        <div class="form-group">
                            <label for="last-name">Last Name</label>
                            <input type="text" id="last-name" name="lastName" value="<%= user.getLastName() %>">
                        </div>

                        <div class="form-group">
                            <label for="specialization">Specialization</label>
                            <input type="text" id="specialization" name="specialization" value="<%= specialty %>">
                        </div>

                        <div class="form-group">
                            <label for="qualification">Qualification</label>
                            <input type="text" id="qualification" name="qualification" value="<%= qualification %>">
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= email %>">
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="tel" id="phone" name="phone" value="<%= phone %>">
                        </div>

                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status">
                                <option value="ACTIVE" <%= doctor.getStatus() != null && doctor.getStatus().equals("ACTIVE") ? "selected" : "" %>>Active</option>
                                <option value="INACTIVE" <%= doctor.getStatus() != null && doctor.getStatus().equals("INACTIVE") ? "selected" : "" %>>Inactive</option>
                                <option value="PENDING" <%= doctor.getStatus() != null && doctor.getStatus().equals("PENDING") ? "selected" : "" %>>Pending</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="experience">Experience (years)</label>
                            <input type="number" id="experience" name="experience" value="<%= doctor.getExperience() != null ? doctor.getExperience() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="consultationFee">Consultation Fee ($)</label>
                            <input type="text" id="consultationFee" name="consultationFee" value="<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="availableDays">Available Days</label>
                            <input type="text" id="availableDays" name="availableDays" value="<%= doctor.getAvailableDays() != null ? doctor.getAvailableDays() : "Monday,Tuesday,Wednesday,Thursday,Friday" %>">
                        </div>

                        <div class="form-group">
                            <label for="availableTime">Available Hours</label>
                            <input type="text" id="availableTime" name="availableTime" value="<%= doctor.getAvailableTime() != null ? doctor.getAvailableTime() : "09:00 AM - 05:00 PM" %>">
                        </div>

                        <div class="form-group full-width">
                            <label for="address">Address</label>
                            <input type="text" id="address" name="address" value="<%= doctor.getAddress() != null ? doctor.getAddress() : "" %>">
                        </div>

                        <div class="form-group full-width">
                            <label for="bio">Biography</label>
                            <textarea id="bio" name="bio"><%= doctor.getBio() != null ? doctor.getBio() : "Dr. " + user.getFirstName() + " " + user.getLastName() + " is a highly skilled " + specialty + " with many years of experience. Specializing in comprehensive care, Dr. " + user.getFirstName() + " " + user.getLastName() + " is dedicated to providing personalized treatment plans for each patient." %></textarea>
                        </div>
                    </div>

                    <div class="profile-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-outline" id="cancel-btn">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Show success message if present
            const successMessage = document.querySelector('.alert-success');
            if (successMessage) {
                // Auto-hide the success message after 5 seconds
                setTimeout(function() {
                    successMessage.style.display = 'none';
                }, 5000);
            }
            // Profile image upload
            const uploadBtn = document.getElementById('upload-btn');
            const removeBtn = document.getElementById('remove-btn');
            const profileImage = document.getElementById('profile-image');
            const profilePreview = document.getElementById('profile-preview');
            let imageRemoved = false;

            if (uploadBtn) {
                uploadBtn.addEventListener('click', function() {
                    profileImage.click();
                });
            }

            if (profileImage) {
                profileImage.addEventListener('change', function() {
                    if (this.files && this.files[0]) {
                        // Check file size first
                        const fileSize = this.files[0].size / 1024 / 1024; // in MB
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

                        // If all checks pass, show preview
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            profilePreview.src = e.target.result;
                            imageRemoved = false;
                        };
                        reader.readAsDataURL(this.files[0]);

                        console.log('File selected:', this.files[0].name, 'Size:', fileSize.toFixed(2) + 'MB', 'Type:', fileType);

                        // Remove any hidden field indicating image removal
                        let removeImageField = document.getElementById('remove-image');
                        if (removeImageField) {
                            removeImageField.value = 'false';
                        }
                    }
                });
            }

            if (removeBtn) {
                removeBtn.addEventListener('click', function() {
                    profilePreview.src = '${pageContext.request.contextPath}/assets/images/doctors/default-doctor.png';
                    profileImage.value = '';
                    imageRemoved = true;

                    // Add a hidden field to indicate image removal
                    let removeImageField = document.getElementById('remove-image');
                    if (!removeImageField) {
                        removeImageField = document.createElement('input');
                        removeImageField.type = 'hidden';
                        removeImageField.id = 'remove-image';
                        removeImageField.name = 'removeImage';
                        document.getElementById('edit-profile-form').appendChild(removeImageField);
                    }
                    removeImageField.value = 'true';
                });
            }

            // Form validation function
            window.validateForm = function() {
                // Get form values
                const firstName = document.getElementById('first-name').value;
                const lastName = document.getElementById('last-name').value;
                const specialization = document.getElementById('specialization').value;
                const email = document.getElementById('email').value;
                const phone = document.getElementById('phone').value;
                const profileImageInput = document.getElementById('profile-image');

                // Validate form
                if (!firstName || !lastName || !specialization || !email || !phone) {
                    alert('Please fill in all required fields.');
                    return false;
                }

                // Validate email
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert('Please enter a valid email address.');
                    return false;
                }

                // Validate file upload if a file is selected
                if (profileImageInput && profileImageInput.files && profileImageInput.files.length > 0) {
                    const file = profileImageInput.files[0];

                    // Check file size
                    const fileSize = file.size / 1024 / 1024; // in MB
                    if (fileSize > 5) {
                        alert('File size exceeds 5MB. Please choose a smaller image.');
                        return false;
                    }

                    // Check file type
                    const fileType = file.type;
                    if (!fileType.match('image.*')) {
                        alert('Please select an image file.');
                        return false;
                    }

                    console.log('File validation passed:', file.name, 'Size:', fileSize.toFixed(2) + 'MB');
                }

                console.log('Form validation passed, submitting...');
                return true;
            };
        });
    </script>
</body>
</html>
