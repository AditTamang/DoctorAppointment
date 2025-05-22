<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Verify doctor is logged in
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor profile data
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/profile");
        return;
    }

    // Set default values
    String doctorName = "Dr. " + user.getFirstName() + " " + user.getLastName();
    String specialty = doctor.getSpecialization() != null ? doctor.getSpecialization() : "Cardiologist";
    String qualification = doctor.getQualification() != null ? doctor.getQualification() : "MD, PHD";
    String email = doctor.getEmail() != null ? doctor.getEmail() : user.getEmail();
    String phone = doctor.getPhone() != null ? doctor.getPhone() : user.getPhone();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | MedDoc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctorDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile.css">
    <style>
        /* Base Styles */
        body, .dashboard-container {
            background-color: #f5f5f5;
            font-family: 'Poppins', sans-serif;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            background-color: #f5f5f5;
            margin-left: 220px;
        }

        /* Edit Profile Container */
        .edit-profile-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            max-width: 850px;
            margin: 0 auto;
            overflow: hidden;
        }

        .edit-profile-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .edit-profile-header h2 {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }

        .back-to-profile {
            color: #4CAF50;
            text-decoration: none;
            font-size: 14px;
            display: flex;
            align-items: center;
        }

        .back-to-profile i {
            margin-right: 5px;
        }

        /* Form Styles */
        .edit-profile-form {
            padding: 20px;
        }

        .form-row {
            display: flex;
            margin-bottom: 20px;
        }

        .form-group {
            flex: 1;
            margin-right: 15px;
        }

        .form-group.full-width {
            flex: 0 0 100%;
            width: 100%;
        }

        .form-group:last-child {
            margin-right: 0;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            color: #666;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            color: #333;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #4CAF50;
            outline: none;
            box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.1);
        }

        /* Profile Image Section */
        .profile-image-section {
            text-align: center;
            padding: 30px 20px;
            border-bottom: 1px solid #eee;
            background-color: #f9f9f9;
        }

        .profile-image-container {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            overflow: hidden;
            margin: 0 auto 15px;
            border: 3px solid #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            background-color: #fff;
            position: relative;
        }

        .profile-image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .image-upload-actions {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-upload, .btn-remove {
            padding: 8px 15px;
            font-size: 13px;
            border-radius: 4px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .btn-upload {
            background-color: #4CAF50;
            color: white;
            border: none;
        }

        .btn-remove {
            background-color: #f44336;
            color: white;
            border: none;
        }

        .btn-upload i, .btn-remove i {
            margin-right: 5px;
        }

        /* Form Actions */
        .form-actions {
            padding: 20px;
            text-align: center;
            border-top: 1px solid #eee;
            background-color: #f9f9f9;
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

        /* Responsive Styles */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .edit-profile-container {
                max-width: 100%;
            }

            .edit-profile-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .form-row {
                flex-direction: column;
            }

            .form-group {
                margin-right: 0;
            }

            .image-upload-actions {
                flex-direction: column;
                gap: 10px;
            }

            .btn-upload, .btn-remove {
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .edit-profile-container {
                padding: 15px 10px;
            }

            .profile-image-section {
                padding: 20px 10px;
            }

            .form-actions {
                padding: 15px 10px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

        <div class="main-content">
            <div class="top-header">
                <div class="top-header-right">
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
                    </div>
                </div>
            </div>

            <div class="edit-profile-container">
                <div class="edit-profile-header">
                    <h2>Edit Profile</h2>
                    <a href="${pageContext.request.contextPath}/doctor/profile" class="back-to-profile">
                        <i class="fas fa-arrow-left"></i> Back to Profile
                    </a>
                </div>

                <form id="edit-profile-form" action="${pageContext.request.contextPath}/doctor/profile/update" method="post" enctype="multipart/form-data" onsubmit="return validateForm();" class="edit-profile-form">
                    <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">
                    <% if (request.getAttribute("successMessage") != null) { %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <%= request.getAttribute("successMessage") %>
                        </div>
                    <% } %>
                    <% if (session.getAttribute("successMessage") != null) { %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <%= session.getAttribute("successMessage") %>
                        </div>
                        <% session.removeAttribute("successMessage"); %>
                    <% } %>
                    <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("errorMessage") %>
                        </div>
                    <% } %>
                    <% if (session.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= session.getAttribute("errorMessage") %>
                        </div>
                        <% session.removeAttribute("errorMessage"); %>
                    <% } %>

                    <div class="profile-image-section">
                        <div class="profile-image-container">
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
                            <%
                            boolean useDefaultImage = previewImagePath.contains("default-doctor.png");
                            if (!useDefaultImage) {
                            %>
                                <img src="<%= previewImagePath %>" alt="Doctor" id="profile-preview"
                                     onerror="this.onerror=null; this.parentNode.innerHTML = '<div class=\'profile-initials\'><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>'; document.getElementById('remove-image').value = 'true';">
                            <% } else { %>
                                <div class="profile-initials" id="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                            <% } %>
                        </div>
                        <div class="image-upload-actions">
                            <input type="file" id="profile-image" name="profileImage" accept="image/*" style="display: none;">
                            <input type="hidden" id="remove-image" name="removeImage" value="false">
                            <button type="button" class="btn-upload" id="upload-btn">
                                <i class="fas fa-upload"></i> Upload Image
                            </button>
                            <button type="button" class="btn-remove" id="remove-btn">
                                <i class="fas fa-trash"></i> Remove Image
                            </button>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="first-name">First Name</label>
                            <input type="text" id="first-name" name="firstName" value="<%= user.getFirstName() %>">
                            <div class="error-message" id="firstName-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>

                        <div class="form-group">
                            <label for="last-name">Last Name</label>
                            <input type="text" id="last-name" name="lastName" value="<%= user.getLastName() %>">
                            <div class="error-message" id="lastName-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="specialization">Specialization</label>
                            <input type="text" id="specialization" name="specialization" value="<%= specialty %>">
                            <div class="error-message" id="specialization-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>

                        <div class="form-group">
                            <label for="qualification">Qualification</label>
                            <input type="text" id="qualification" name="qualification" value="<%= qualification %>">
                            <div class="error-message" id="qualification-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= email %>">
                            <div class="error-message" id="email-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="tel" id="phone" name="phone" value="<%= phone %>">
                            <div class="error-message" id="phone-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="address">Address</label>
                            <input type="text" id="address" name="address" value="<%= doctor.getAddress() != null ? doctor.getAddress() : "" %>">
                            <div class="error-message" id="address-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="experience">Experience (years)</label>
                            <input type="text" id="experience" name="experience" value="<%= doctor.getExperience() != null ? doctor.getExperience() : "" %>">
                            <div class="error-message" id="experience-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>

                        <div class="form-group">
                            <label for="consultationFee">Consultation Fee ($)</label>
                            <input type="text" id="consultationFee" name="consultationFee" value="<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "" %>">
                            <div class="error-message" id="consultationFee-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="availableDays">Available Days (comma separated)</label>
                            <input type="text" id="availableDays" name="availableDays" value="<%= doctor.getAvailableDays() != null ? doctor.getAvailableDays() : "" %>" placeholder="e.g. Monday, Wednesday, Friday">
                            <div class="error-message" id="availableDays-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>

                        <div class="form-group">
                            <label for="availableTime">Available Hours</label>
                            <input type="text" id="availableTime" name="availableTime" value="<%= doctor.getAvailableTime() != null ? doctor.getAvailableTime() : "" %>" placeholder="e.g. 9:00 AM - 5:00 PM">
                            <div class="error-message" id="availableTime-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group full-width">
                            <label for="bio">Biography</label>
                            <textarea id="bio" name="bio" rows="4"><%= doctor.getBio() != null ? doctor.getBio() : "" %></textarea>
                            <div class="error-message" id="bio-error" style="color: #f44336; font-size: 12px; margin-top: 5px; display: none;"></div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-upload" id="saveChangesBtn">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/doctor/profile" class="btn-remove">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>

                    <!-- Form submission status message -->
                    <div id="formSubmissionStatus" style="display: none; margin-top: 15px; padding: 10px; border-radius: 4px; text-align: center;">
                        <i class="status-icon"></i>
                        <span class="status-message"></span>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-hide success message
            const successMessage = document.querySelector('.alert-success');
            if (successMessage) {
                setTimeout(function() {
                    successMessage.style.display = 'none';
                }, 5000);
            }

            // Image upload handling
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
                        // Check file size (5MB max)
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
                            // Check if we have initials displayed
                            const initials = document.getElementById('profile-initials');
                            if (initials) {
                                // Replace initials with image
                                const container = document.querySelector('.profile-image-container');
                                container.innerHTML = '<img src="' + e.target.result + '" alt="Doctor" id="profile-preview">';
                            } else {
                                // Just update the image src
                                profilePreview.src = e.target.result;
                            }
                            imageRemoved = false;
                        };
                        reader.readAsDataURL(this.files[0]);

                        // Reset removal flag
                        document.getElementById('remove-image').value = 'false';
                    }
                });
            }

            if (removeBtn) {
                removeBtn.addEventListener('click', function() {
                    // Replace image with initials
                    const container = document.querySelector('.profile-image-container');
                    container.innerHTML = '<div class="profile-initials" id="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>';

                    // Reset file input
                    profileImage.value = '';
                    imageRemoved = true;

                    // Mark image for removal
                    document.getElementById('remove-image').value = 'true';
                });
            }

            // Add input event listeners to clear validation errors when user types
            const formInputs = document.querySelectorAll('input, textarea');
            formInputs.forEach(input => {
                input.addEventListener('input', function() {
                    // Clear error message for this field
                    const fieldName = this.name;
                    const errorElement = document.getElementById(fieldName + '-error');
                    if (errorElement) {
                        errorElement.style.display = 'none';
                        errorElement.textContent = '';
                    }

                    // Reset border color
                    this.style.borderColor = '';
                });
            });

            // Form validation
            window.validateForm = function() {
                // Clear all previous error messages
                const errorMessages = document.querySelectorAll('.error-message');
                errorMessages.forEach(msg => {
                    msg.style.display = 'none';
                    msg.textContent = '';
                });

                // Reset all input borders
                formInputs.forEach(input => {
                    input.style.borderColor = '';
                });

                // Check required fields
                const firstName = document.getElementById('first-name').value;
                const lastName = document.getElementById('last-name').value;
                const specialization = document.getElementById('specialization').value;
                const email = document.getElementById('email').value;
                const phone = document.getElementById('phone').value;

                let hasError = false;

                if (!firstName) {
                    displayFieldError('firstName', 'First name is required');
                    hasError = true;
                }

                if (!lastName) {
                    displayFieldError('lastName', 'Last name is required');
                    hasError = true;
                }

                if (!specialization) {
                    displayFieldError('specialization', 'Specialization is required');
                    hasError = true;
                }

                if (!email) {
                    displayFieldError('email', 'Email is required');
                    hasError = true;
                } else {
                    // Check email format
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(email)) {
                        displayFieldError('email', 'Please enter a valid email address');
                        hasError = true;
                    }
                }

                if (!phone) {
                    displayFieldError('phone', 'Phone number is required');
                    hasError = true;
                }

                // Check uploaded image
                const profileImageInput = document.getElementById('profile-image');
                if (profileImageInput && profileImageInput.files && profileImageInput.files.length > 0) {
                    const file = profileImageInput.files[0];
                    const fileSize = file.size / 1024 / 1024;

                    if (fileSize > 5) {
                        alert('File size exceeds 5MB. Please choose a smaller image.');
                        hasError = true;
                    }

                    if (!file.type.match('image.*')) {
                        alert('Please select an image file.');
                        hasError = true;
                    }
                }

                if (hasError) {
                    // Scroll to the first error
                    const firstError = document.querySelector('.error-message[style*="display: block"]');
                    if (firstError) {
                        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                    return false;
                }

                return true;
            };

            // Helper function to display field errors
            function displayFieldError(fieldName, errorMessage) {
                const errorElement = document.getElementById(fieldName + '-error');
                const inputField = document.getElementById(fieldName) || document.getElementById(fieldName.replace(/([A-Z])/g, "-$1").toLowerCase());

                if (errorElement) {
                    errorElement.textContent = errorMessage;
                    errorElement.style.display = 'block';
                }

                if (inputField) {
                    inputField.style.borderColor = '#f44336';
                }
            }

            // Function to update the profile display after successful update
            function updateProfileDisplay(data) {
                console.log('Updating profile display with data:', data);

                // Update the profile header if it exists
                const profileName = document.querySelector('.profile-header h2');
                if (profileName && data.name) {
                    profileName.textContent = data.name;
                }

                // Update form fields with the latest data
                if (data.firstName) document.getElementById('first-name').value = data.firstName;
                if (data.lastName) document.getElementById('last-name').value = data.lastName;
                if (data.email) document.getElementById('email').value = data.email;
                if (data.phone) document.getElementById('phone').value = data.phone;
                if (data.specialization) document.getElementById('specialization').value = data.specialization;
                if (data.qualification) document.getElementById('qualification').value = data.qualification;
                if (data.experience) document.getElementById('experience').value = data.experience;
                if (data.consultationFee) document.getElementById('consultationFee').value = data.consultationFee;
                if (data.availableDays) document.getElementById('availableDays').value = data.availableDays;
                if (data.availableTime) document.getElementById('availableTime').value = data.availableTime;
                if (data.address) document.getElementById('address').value = data.address;
                if (data.bio) document.getElementById('bio').value = data.bio;

                // Update any other elements that need to be refreshed
                // This will depend on what data is returned from the server

                // Clear any previous error messages
                const errorMessages = document.querySelectorAll('.error-message');
                errorMessages.forEach(msg => msg.remove());

                // Show a success message that will fade out
                const successMessage = document.createElement('div');
                successMessage.className = 'success-message';
                successMessage.style.position = 'fixed';
                successMessage.style.top = '20px';
                successMessage.style.right = '20px';
                successMessage.style.backgroundColor = '#e8f5e9';
                successMessage.style.color = '#2e7d32';
                successMessage.style.padding = '15px 20px';
                successMessage.style.borderRadius = '4px';
                successMessage.style.boxShadow = '0 2px 10px rgba(0,0,0,0.1)';
                successMessage.style.zIndex = '9999';
                successMessage.style.transition = 'opacity 0.5s ease-in-out';
                successMessage.innerHTML = '<i class="fas fa-check-circle" style="margin-right: 10px;"></i> Profile updated successfully';

                document.body.appendChild(successMessage);

                // Fade out and remove after 3 seconds
                setTimeout(() => {
                    successMessage.style.opacity = '0';
                    setTimeout(() => {
                        successMessage.remove();
                    }, 500);
                }, 3000);
            }

            // Handle form submission with AJAX
            const form = document.querySelector('form');
            const saveBtn = document.getElementById('saveChangesBtn');
            const statusDiv = document.getElementById('formSubmissionStatus');

            if (form && saveBtn) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();

                    if (!validateForm()) {
                        return;
                    }

                    // Disable the save button to prevent multiple submissions
                    saveBtn.disabled = true;
                    saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';

                    // Get form data
                    const formData = new FormData(form);

                    // Send AJAX request
                    fetch(form.action, {
                        method: 'POST',
                        body: formData,
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        // Show status message
                        statusDiv.style.display = 'block';

                        if (data.success) {
                            statusDiv.style.backgroundColor = '#e8f5e9';
                            statusDiv.style.color = '#2e7d32';
                            statusDiv.style.border = '1px solid #c8e6c9';
                            statusDiv.querySelector('.status-icon').className = 'status-icon fas fa-check-circle';
                            statusDiv.querySelector('.status-message').textContent = data.message || 'Profile updated successfully';

                            // Refresh parent page if it exists
                            if (window.opener && !window.opener.closed && window.opener.refreshProfileData) {
                                window.opener.refreshProfileData();
                            }

                            // Update the UI to show success without redirecting
                            // Change the button text back after a delay
                            setTimeout(() => {
                                saveBtn.disabled = false;
                                saveBtn.innerHTML = '<i class="fas fa-save"></i> Save Changes';

                                // Update any fields that need to be refreshed
                                updateProfileDisplay(data);
                            }, 1500);
                        } else {
                            statusDiv.style.backgroundColor = '#ffebee';
                            statusDiv.style.color = '#c62828';
                            statusDiv.style.border = '1px solid #ffcdd2';
                            statusDiv.querySelector('.status-icon').className = 'status-icon fas fa-times-circle';
                            statusDiv.querySelector('.status-message').textContent = data.message || 'Failed to update profile';

                            // Clear any previous error messages
                            const errorMessages = document.querySelectorAll('.error-message');
                            errorMessages.forEach(msg => {
                                msg.style.display = 'none';
                                msg.textContent = '';
                            });

                            // Display validation errors if they exist
                            if (data.errors) {
                                console.log("Validation errors received:", data.errors);

                                // Loop through all error fields and display them
                                for (const field in data.errors) {
                                    const errorElement = document.getElementById(field + '-error');
                                    if (errorElement) {
                                        errorElement.textContent = data.errors[field];
                                        errorElement.style.display = 'block';

                                        // Highlight the input field with error
                                        const inputField = document.getElementById(field);
                                        if (inputField) {
                                            inputField.style.borderColor = '#f44336';
                                        }
                                    }
                                }

                                // Scroll to the first error
                                const firstErrorField = Object.keys(data.errors)[0];
                                if (firstErrorField) {
                                    const firstErrorElement = document.getElementById(firstErrorField);
                                    if (firstErrorElement) {
                                        firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
                                    }
                                }
                            }

                            // Re-enable the save button
                            saveBtn.disabled = false;
                            saveBtn.innerHTML = '<i class="fas fa-save"></i> Save Changes';
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);

                        // Show error message
                        statusDiv.style.display = 'block';
                        statusDiv.style.backgroundColor = '#ffebee';
                        statusDiv.style.color = '#c62828';
                        statusDiv.style.border = '1px solid #ffcdd2';
                        statusDiv.querySelector('.status-icon').className = 'status-icon fas fa-times-circle';
                        statusDiv.querySelector('.status-message').textContent = 'An error occurred. Please try again.';

                        // Add a more visible error message at the top of the form
                        const errorBanner = document.createElement('div');
                        errorBanner.className = 'alert alert-danger';
                        errorBanner.innerHTML = '<i class="fas fa-exclamation-circle"></i> An error occurred while saving your profile. Please try again.';

                        // Insert at the beginning of the form content
                        const firstElement = form.querySelector('.profile-image-section');
                        form.insertBefore(errorBanner, firstElement);

                        // Scroll to the top of the form
                        errorBanner.scrollIntoView({ behavior: 'smooth', block: 'start' });

                        // Remove the error banner after 5 seconds
                        setTimeout(() => {
                            errorBanner.remove();
                        }, 5000);

                        // Re-enable the save button
                        saveBtn.disabled = false;
                        saveBtn.innerHTML = '<i class="fas fa-save"></i> Save Changes';
                    });
                });
            }
        });
    </script>
</body>
</html>
