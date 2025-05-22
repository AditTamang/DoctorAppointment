<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - HealthCare</title>
    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/logo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
   <style>
        <%@include file="./assets/css/style.css"%>
        <%@include file="./assets/css/auth.css"%>

        .password-hint {
            font-size: 0.8rem;
            color: #666;
            margin-top: 5px;
            display: block;
        }

        input:invalid {
            border-color: #dc3545;
        }

        input:valid {
            border-color: #28a745;
        }
    </style>
</head>
<body>
    <!-- Register Form Container -->
    <div class="auth-container">
        <!-- Left Side with Image -->
        <div class="auth-left">
            <div class="auth-image">
                <img src="https://img.freepik.com/free-photo/team-young-specialist-doctors-standing-corridor-hospital_1303-21199.jpg?w=2000&t=st=1682430456~exp=1682431056~hmac=2d7e1b4e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e" alt="Healthcare">
                <div class="auth-overlay">
                    <h3>Join Our HealthCare Community</h3>
                    <p>Get access to the best medical services and professionals</p>
                </div>
            </div>
        </div>

        <!-- Right Side with Registration Form -->
        <div class="auth-right">
            <a href="index.jsp" class="logo" style="display: inline-block; margin-bottom: 2rem; text-decoration: none; font-size: 1.8rem; font-weight: 700; color: var(--dark-color);">
                <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="HealthCare Logo" style="height: 40px; margin-right: 10px; vertical-align: middle;">
                Health<span style="color: var(--primary-color);">Care</span>
            </a>

            <h2>Create Account</h2>
            <p class="auth-subtitle">Please fill in your details to register</p>

            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <div class="user-type-selector">
                <div class="user-type-option active" data-type="patient">
                    <i class="fas fa-user"></i> <span>Patient</span>
                </div>
                <div class="user-type-option" data-type="doctor">
                    <i class="fas fa-user-md"></i> <span>Doctor</span>
                </div>
            </div>

            <!-- Patient Registration Form -->
            <form action="register" method="post" id="patientForm" class="user-type-form active">
                <input type="hidden" name="role" value="PATIENT">

                <div class="form-group">
                    <label for="patient-name" class="form-label">Full Name</label>
                    <div style="position: relative;">
                        <i class="fas fa-user" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                        <input type="text" id="patient-name" name="name" class="form-control" style="padding-left: 45px;" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="patient-email" class="form-label">Email Address</label>
                    <div style="position: relative;">
                        <i class="fas fa-envelope" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                        <input type="email" id="patient-email" name="email" class="form-control" style="padding-left: 45px;" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="patient-phone" class="form-label">Phone Number</label>
                    <div style="position: relative;">
                        <i class="fas fa-phone" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                        <input type="tel" id="patient-phone" name="phone" class="form-control" style="padding-left: 45px;" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="patient-dob" class="form-label">Date of Birth</label>
                        <div style="position: relative;">
                            <i class="fas fa-calendar" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <input type="date" id="patient-dob" name="dateOfBirth" class="form-control" style="padding-left: 45px;" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="patient-gender" class="form-label">Gender</label>
                        <div style="position: relative;">
                            <i class="fas fa-venus-mars" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <select id="patient-gender" name="gender" class="form-control" style="padding-left: 45px;" required>
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="patient-address" class="form-label">Address</label>
                    <div style="position: relative;">
                        <i class="fas fa-map-marker-alt" style="position: absolute; left: 15px; top: 20px; color: #666;"></i>
                        <textarea id="patient-address" name="address" class="form-control" style="padding-left: 45px; padding-top: 15px;" rows="2" placeholder="Enter your address" required></textarea>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="patient-blood" class="form-label">Blood Group</label>
                        <div style="position: relative;">
                            <i class="fas fa-tint" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <select id="patient-blood" name="bloodGroup" class="form-control" style="padding-left: 45px;">
                                <option value="">Select Blood Group</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="patient-allergies" class="form-label">Allergies (if any)</label>
                        <div style="position: relative;">
                            <i class="fas fa-allergies" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <input type="text" id="patient-allergies" name="allergies" class="form-control" style="padding-left: 45px;" placeholder="Enter allergies if any">
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="patient-password" class="form-label">Password</label>
                        <div style="position: relative;">
                            <i class="fas fa-lock" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <input type="password" id="patient-password" name="password" class="form-control" style="padding-left: 45px; padding-right: 45px;"
                                   pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                                   title="Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character" required>
                            <span class="password-toggle" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;" onclick="togglePasswordVisibility('patient-password')">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-off"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye" style="display: none;"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </span>
                        </div>
                        <small class="password-hint">Password must be at least 8 characters long and include uppercase, lowercase, number, and special character</small>
                    </div>

                    <div class="form-group">
                        <label for="patient-confirm-password" class="form-label">Confirm Password</label>
                        <div style="position: relative;">
                            <i class="fas fa-lock" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <input type="password" id="patient-confirm-password" name="confirmPassword" class="form-control" style="padding-left: 45px; padding-right: 45px;" required>
                            <span class="password-toggle" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;" onclick="togglePasswordVisibility('patient-confirm-password')">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-off"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye" style="display: none;"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 2rem;">
                    <div style="display: flex; align-items: center;">
                        <input type="checkbox" id="patient-terms" name="terms" required>
                        <label for="patient-terms" style="margin-left: 10px; cursor: pointer; font-size: 0.9rem;">
                            I agree to the <a href="#" style="color: var(--primary-color);">Terms of Service</a> and <a href="#" style="color: var(--primary-color);">Privacy Policy</a>
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Register as Patient <i class="fas fa-user-plus" style="margin-left: 5px;"></i></button>
                </div>
            </form>

            <!-- Doctor Registration Form -->
            <form action="register" method="post" id="doctorForm" class="user-type-form">
                <input type="hidden" name="role" value="DOCTOR">

                <div class="alert alert-info" style="margin-bottom: 20px;">
                    <i class="fas fa-info-circle"></i>
                    Doctor registrations require admin approval. Your account will be pending until approved by an administrator.
                </div>

                <div class="form-group">
                    <label for="doctor-name" class="form-label">Full Name</label>
                    <div style="position: relative;">
                        <i class="fas fa-user-md" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                        <input type="text" id="doctor-name" name="name" class="form-control" style="padding-left: 45px;" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="doctor-email" class="form-label">Email Address</label>
                    <div style="position: relative;">
                        <i class="fas fa-envelope" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                        <input type="email" id="doctor-email" name="email" class="form-control" style="padding-left: 45px;" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="doctor-phone" class="form-label">Phone Number</label>
                    <div style="position: relative;">
                        <i class="fas fa-phone" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                        <input type="tel" id="doctor-phone" name="phone" class="form-control" style="padding-left: 45px;" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="doctor-specialization" class="form-label">Specialization</label>
                        <div style="position: relative;">
                            <i class="fas fa-stethoscope" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <select id="doctor-specialization" name="specialization" class="form-control" style="padding-left: 45px;" required>
                                <option value="">Select Specialization</option>
                                <option value="Cardiology">Cardiology</option>
                                <option value="Dermatology">Dermatology</option>
                                <option value="Endocrinology">Endocrinology</option>
                                <option value="Gastroenterology">Gastroenterology</option>
                                <option value="Neurology">Neurology</option>
                                <option value="Obstetrics">Obstetrics</option>
                                <option value="Ophthalmology">Ophthalmology</option>
                                <option value="Orthopedics">Orthopedics</option>
                                <option value="Pediatrics">Pediatrics</option>
                                <option value="Psychiatry">Psychiatry</option>
                                <option value="Urology">Urology</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="doctor-experience" class="form-label">Experience (years)</label>
                        <div style="position: relative;">
                            <i class="fas fa-briefcase" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <input type="number" id="doctor-experience" name="experience" min="0" max="70" class="form-control" style="padding-left: 45px;" placeholder="Years of experience" required>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="doctor-qualification" class="form-label">Qualification</label>
                    <div style="position: relative;">
                        <i class="fas fa-graduation-cap" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                        <input type="text" id="doctor-qualification" name="qualification" class="form-control" style="padding-left: 45px;" placeholder="Your medical qualifications" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="doctor-address" class="form-label">Address</label>
                    <div style="position: relative;">
                        <i class="fas fa-map-marker-alt" style="position: absolute; left: 15px; top: 20px; color: #666;"></i>
                        <textarea id="doctor-address" name="address" class="form-control" style="padding-left: 45px; padding-top: 15px;" rows="2" placeholder="Your clinic/hospital address" required></textarea>
                    </div>
                </div>

                <div class="form-group">
                    <label for="doctor-bio" class="form-label">Professional Bio</label>
                    <div style="position: relative;">
                        <i class="fas fa-info-circle" style="position: absolute; left: 15px; top: 20px; color: #666;"></i>
                        <textarea id="doctor-bio" name="bio" class="form-control" style="padding-left: 45px; padding-top: 15px;" rows="3" placeholder="Brief description of your professional experience"></textarea>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="doctor-password" class="form-label">Password</label>
                        <div style="position: relative;">
                            <i class="fas fa-lock" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <input type="password" id="doctor-password" name="password" class="form-control" style="padding-left: 45px; padding-right: 45px;"
                                   pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                                   title="Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character" required>
                            <span class="password-toggle" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;" onclick="togglePasswordVisibility('doctor-password')">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-off"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye" style="display: none;"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </span>
                        </div>
                        <small class="password-hint">Password must be at least 8 characters long and include uppercase, lowercase, number, and special character</small>
                    </div>

                    <div class="form-group">
                        <label for="doctor-confirm-password" class="form-label">Confirm Password</label>
                        <div style="position: relative;">
                            <i class="fas fa-lock" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                            <input type="password" id="doctor-confirm-password" name="confirmPassword" class="form-control" style="padding-left: 45px; padding-right: 45px;" required>
                            <span class="password-toggle" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;" onclick="togglePasswordVisibility('doctor-confirm-password')">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-off"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye" style="display: none;"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 2rem;">
                    <div style="display: flex; align-items: center;">
                        <input type="checkbox" id="doctor-terms" name="terms" required>
                        <label for="doctor-terms" style="margin-left: 10px; cursor: pointer; font-size: 0.9rem;">
                            I agree to the <a href="#" style="color: var(--primary-color);">Terms of Service</a> and <a href="#" style="color: var(--primary-color);">Privacy Policy</a>
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Submit Doctor Application <i class="fas fa-paper-plane" style="margin-left: 5px;"></i></button>
                </div>
            </form>

            <div class="auth-links">
                <p>Already have an account? <a href="login">Login here</a></p>
            </div>

            <div class="social-login">
                <p>or</p>
                <button class="social-btn google-btn"><i class="fab fa-google"></i> Continue with Google</button>
                <button class="social-btn facebook-btn"><i class="fab fa-facebook-f"></i> Continue with Facebook</button>
            </div>

            <div style="text-align: center; margin-top: 2rem;">
                <a href="index.jsp" style="color: var(--text-light); font-size: 0.9rem; text-decoration: none;">
                    <i class="fas fa-home" style="margin-right: 5px;"></i> Back to Home
                </a>
            </div>
        </div>
    </div>



    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        // User type selection functionality
        document.addEventListener('DOMContentLoaded', function() {
            const userTypeOptions = document.querySelectorAll('.user-type-option');
            const patientForm = document.getElementById('patientForm');
            const doctorForm = document.getElementById('doctorForm');

            // Handle user type selection
            userTypeOptions.forEach(option => {
                option.addEventListener('click', function() {
                    // Remove active class from all options
                    userTypeOptions.forEach(opt => opt.classList.remove('active'));

                    // Add active class to clicked option
                    this.classList.add('active');

                    // Show corresponding form
                    const userType = this.getAttribute('data-type');
                    if (userType === 'patient') {
                        patientForm.classList.add('active');
                        doctorForm.classList.remove('active');
                    } else {
                        doctorForm.classList.add('active');
                        patientForm.classList.remove('active');
                    }
                });
            });

            // Form validation
            const validatePassword = function(formId) {
                const form = document.getElementById(formId);
                const password = form.querySelector('input[name="password"]');
                const confirmPassword = form.querySelector('input[name="confirmPassword"]');

                // Password complexity validation
                const passwordValue = password.value;
                const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

                if (!passwordRegex.test(passwordValue)) {
                    password.setCustomValidity('Password must be at least 8 characters long and include uppercase, lowercase, number, and special character');
                    return false;
                } else {
                    password.setCustomValidity('');
                }

                // Password match validation
                if (password.value !== confirmPassword.value) {
                    confirmPassword.setCustomValidity('Passwords do not match');
                    return false;
                } else {
                    confirmPassword.setCustomValidity('');
                    return true;
                }
            };

            patientForm.addEventListener('submit', function(e) {
                if (!validatePassword('patientForm')) {
                    e.preventDefault();
                }
            });

            doctorForm.addEventListener('submit', function(e) {
                if (!validatePassword('doctorForm')) {
                    e.preventDefault();
                }
            });
        });

        // Function to toggle password visibility
        function togglePasswordVisibility(inputId) {
            const passwordInput = document.getElementById(inputId);
            const eyeOffIcon = document.querySelector(`#${inputId} ~ .password-toggle .eye-off`);
            const eyeIcon = document.querySelector(`#${inputId} ~ .password-toggle .eye`);

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                eyeOffIcon.style.display = 'none';
                eyeIcon.style.display = 'inline-block';
            } else {
                passwordInput.type = 'password';
                eyeOffIcon.style.display = 'inline-block';
                eyeIcon.style.display = 'none';
            }
        }
    </script>
</body>
</html>
