<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.service.PatientService" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get appointment from request attribute
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    if (appointment == null) {
        response.sendRedirect(request.getContextPath() + "/patient/appointments");
        return;
    }

    // Format date
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    String formattedDate = appointment.getAppointmentDate() != null ?
                          dateFormat.format(appointment.getAppointmentDate()) : "";

    // Determine status class
    String statusClass = "pending";
    if ("APPROVED".equals(appointment.getStatus())) {
        statusClass = "approved";
    } else if ("CANCELLED".equals(appointment.getStatus())) {
        statusClass = "cancelled";
    } else if ("COMPLETED".equals(appointment.getStatus())) {
        statusClass = "completed";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patientDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-reschedule.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-details.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-profile-image.css">
</head>
<body data-context-path="${pageContext.request.contextPath}">
    <div class="dashboard-container">
        <!-- Include Patient Sidebar -->
        <jsp:include page="patient-sidebar.jsp" />

        <!-- Main Content -->
        <div class="dashboard-main">
            <!-- Top Navigation -->
            <div class="dashboard-nav">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </div>

                <div class="nav-right">
                    <div class="nav-user">
                        <div class="user-image" data-default-image="/assets/images/patients/default.jpg" data-initials="<%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %>">
                            <%
                            // Get patient information from session or request
                            Patient patient = (Patient) session.getAttribute("patient");
                            // If patient is not in session, we'll just use initials

                            if (patient != null && patient.getProfileImage() != null && !patient.getProfileImage().isEmpty()) {
                            %>
                                <img src="${pageContext.request.contextPath}${patient.getProfileImage()}" alt="<%= user.getFirstName() %>"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/patients/default.jpg'">
                            <% } else { %>
                                <div class="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                            <% } %>
                        </div>
                        <div class="user-info">
                            <h4><%= user.getFirstName() + " " + user.getLastName() %></h4>
                            <p>Patient</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="content-header">
                    <h2>Appointment Details</h2>
                    <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Back to Appointments
                    </a>
                </div>

                <!-- Appointment Details -->
                <div class="appointment-details-container">
                    <div class="appointment-details-header">
                        <h2>Appointment #<%= appointment.getId() %></h2>
                        <span class="status-badge status-<%= statusClass %>"><%= appointment.getStatus() %></span>
                    </div>

                    <div class="appointment-details-content">
                        <div class="detail-item">
                            <label>Doctor</label>
                            <p><%= appointment.getDoctorName() %></p>
                        </div>

                        <div class="detail-item">
                            <label>Specialization</label>
                            <p><%= appointment.getDoctorSpecialization() != null ? appointment.getDoctorSpecialization() : "Not specified" %></p>
                        </div>

                        <div class="detail-item">
                            <label>Date</label>
                            <p><%= formattedDate %></p>
                        </div>

                        <div class="detail-item">
                            <label>Time</label>
                            <p><%= appointment.getAppointmentTime() %></p>
                        </div>

                        <div class="detail-item">
                            <label>Type</label>
                            <p>In-Person Consultation</p>
                        </div>

                        <div class="detail-item">
                            <label>Reason for Visit</label>
                            <p><%= appointment.getReason() != null ? appointment.getReason() : "Not specified" %></p>
                        </div>

                        <% if (appointment.getSymptoms() != null && !appointment.getSymptoms().isEmpty()) { %>
                        <div class="detail-item">
                            <label>Symptoms</label>
                            <p><%= appointment.getSymptoms() %></p>
                        </div>
                        <% } %>
                    </div>

                    <div class="appointment-actions">
                        <% if ("PENDING".equals(appointment.getStatus())) { %>
                            <button id="rescheduleBtn" class="btn btn-primary">
                                <i class="fas fa-calendar-alt"></i> Reschedule
                            </button>
                        <% } %>
                        <% if ("PENDING".equals(appointment.getStatus()) || "APPROVED".equals(appointment.getStatus())) { %>
                            <button id="cancelBtn" class="btn btn-danger">
                                <i class="fas fa-times"></i> Cancel Appointment
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Reschedule Modal -->
    <div id="rescheduleModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-calendar-alt"></i> Reschedule Appointment</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <!-- Patient Profile Section -->
                <div class="patient-profile">
                    <div class="patient-avatar" data-default-image="/assets/images/patients/default.jpg" data-initials="<%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %>">
                        <% if (patient != null && patient.getProfileImage() != null && !patient.getProfileImage().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}${patient.getProfileImage()}" alt="<%= user.getFirstName() %>"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/patients/default.jpg'">
                        <% } else { %>
                            <div class="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                        <% } %>
                    </div>
                    <div class="patient-info">
                        <h4><%= user.getFirstName() + " " + user.getLastName() %></h4>
                        <p>Appointment with Dr. <%= appointment.getDoctorName() %></p>
                    </div>
                </div>

                <form id="rescheduleForm" action="${pageContext.request.contextPath}/appointment/reschedule" method="post">
                    <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">

                    <div class="form-group">
                        <label for="newDate">New Date</label>
                        <input type="date" id="newDate" name="newDate" required>
                    </div>

                    <div class="form-group">
                        <label for="newTime">New Time</label>
                        <select id="newTime" name="newTime" required>
                            <option value="">Select a time</option>
                            <option value="09:00 AM">09:00 AM</option>
                            <option value="09:30 AM">09:30 AM</option>
                            <option value="10:00 AM">10:00 AM</option>
                            <option value="10:30 AM">10:30 AM</option>
                            <option value="11:00 AM">11:00 AM</option>
                            <option value="11:30 AM">11:30 AM</option>
                            <option value="12:00 PM">12:00 PM</option>
                            <option value="12:30 PM">12:30 PM</option>
                            <option value="01:00 PM">01:00 PM</option>
                            <option value="01:30 PM">01:30 PM</option>
                            <option value="02:00 PM">02:00 PM</option>
                            <option value="02:30 PM">02:30 PM</option>
                            <option value="03:00 PM">03:00 PM</option>
                            <option value="03:30 PM">03:30 PM</option>
                            <option value="04:00 PM">04:00 PM</option>
                            <option value="04:30 PM">04:30 PM</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="reason">Reason for Rescheduling</label>
                        <textarea id="reason" name="reason" rows="3" placeholder="Please provide a reason for rescheduling this appointment" required></textarea>
                    </div>

                    <div class="modal-footer">
                        <button type="button" id="cancelReschedule" class="btn btn-outline">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check"></i> Confirm Reschedule
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Cancel Modal -->
    <div id="cancelModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-exclamation-triangle"></i> Cancel Appointment</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <!-- Patient Profile Section -->
                <div class="patient-profile">
                    <div class="patient-avatar" data-default-image="/assets/images/patients/default.jpg" data-initials="<%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %>">
                        <% if (patient != null && patient.getProfileImage() != null && !patient.getProfileImage().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}${patient.getProfileImage()}" alt="<%= user.getFirstName() %>"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/patients/default.jpg'">
                        <% } else { %>
                            <div class="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                        <% } %>
                    </div>
                    <div class="patient-info">
                        <h4><%= user.getFirstName() + " " + user.getLastName() %></h4>
                        <p>Appointment with Dr. <%= appointment.getDoctorName() %></p>
                    </div>
                </div>

                <div class="warning-message">
                    <p>Are you sure you want to cancel this appointment?</p>
                    <p>This action cannot be undone.</p>
                </div>

                <div class="modal-footer">
                    <button id="cancelAction" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> No, Keep It
                    </button>
                    <button id="confirmCancel" class="btn btn-danger">
                        <i class="fas fa-times"></i> Yes, Cancel
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="loading-overlay">
        <div class="loading-spinner"></div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/profile-image-handler.js"></script>
    <script>
        // Toggle sidebar on mobile
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
        });

        // Initialize date and time pickers with improved functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize profile image handling
            handleImageLoadErrors();
            // Set minimum date to tomorrow for the date picker (can't reschedule for today)
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            const tomorrowStr = tomorrow.toISOString().split('T')[0];

            const dateInput = document.getElementById('newDate');
            dateInput.min = tomorrowStr;

            // Set default date to 3 days from now
            const defaultDate = new Date();
            defaultDate.setDate(defaultDate.getDate() + 3);
            dateInput.value = defaultDate.toISOString().split('T')[0];

            // Highlight weekends in the date picker with custom styling
            dateInput.addEventListener('focus', function() {
                // Add custom styling for date picker (browser support varies)
                const style = document.createElement('style');
                style.textContent = `
                    input[type="date"]::-webkit-calendar-picker-indicator {
                        background-color: #f5f5f5;
                        padding: 5px;
                        border-radius: 4px;
                        cursor: pointer;
                    }
                `;
                document.head.appendChild(style);
            });

            // Reschedule modal functionality with improved animations
            const rescheduleModal = document.getElementById('rescheduleModal');
            const rescheduleBtn = document.getElementById('rescheduleBtn');
            const cancelRescheduleBtn = document.getElementById('cancelReschedule');
            const rescheduleCloseBtn = rescheduleModal.querySelector('.close');

            if (rescheduleBtn) {
                rescheduleBtn.addEventListener('click', function() {
                    // Show modal with smooth animation
                    rescheduleModal.style.display = 'block';
                    document.body.style.overflow = 'hidden'; // Prevent scrolling

                    // Set focus on the date input after a short delay
                    setTimeout(() => {
                        document.getElementById('newDate').focus();
                    }, 300);
                });
            }

            if (cancelRescheduleBtn) {
                cancelRescheduleBtn.addEventListener('click', function() {
                    closeRescheduleModal();
                });
            }

            if (rescheduleCloseBtn) {
                rescheduleCloseBtn.addEventListener('click', function() {
                    closeRescheduleModal();
                });
            }

            // Function to close reschedule modal with animation
            function closeRescheduleModal() {
                const modalContent = rescheduleModal.querySelector('.modal-content');
                modalContent.style.animation = 'slideDown 0.3s ease forwards';

                setTimeout(() => {
                    rescheduleModal.style.display = 'none';
                    document.body.style.overflow = ''; // Restore scrolling
                    modalContent.style.animation = 'slideUp 0.3s ease forwards';
                }, 250);
            }

            // Cancel modal functionality with improved animations
            const cancelModal = document.getElementById('cancelModal');
            const cancelBtn = document.getElementById('cancelBtn');
            const cancelActionBtn = document.getElementById('cancelAction');
            const confirmCancelBtn = document.getElementById('confirmCancel');
            const cancelCloseBtn = cancelModal.querySelector('.close');

            if (cancelBtn) {
                cancelBtn.addEventListener('click', function() {
                    // Show modal with smooth animation
                    cancelModal.style.display = 'block';
                    document.body.style.overflow = 'hidden'; // Prevent scrolling
                });
            }

            if (cancelActionBtn) {
                cancelActionBtn.addEventListener('click', function() {
                    closeCancelModal();
                });
            }

            if (cancelCloseBtn) {
                cancelCloseBtn.addEventListener('click', function() {
                    closeCancelModal();
                });
            }

            // Function to close cancel modal with animation
            function closeCancelModal() {
                const modalContent = cancelModal.querySelector('.modal-content');
                modalContent.style.animation = 'slideDown 0.3s ease forwards';

                setTimeout(() => {
                    cancelModal.style.display = 'none';
                    document.body.style.overflow = ''; // Restore scrolling
                    modalContent.style.animation = 'slideUp 0.3s ease forwards';
                }, 250);
            }

            // Close modals when clicking outside
            window.addEventListener('click', function(event) {
                if (event.target === rescheduleModal) {
                    closeRescheduleModal();
                }
                if (event.target === cancelModal) {
                    closeCancelModal();
                }
            });

            // Add keydown event to close modals with Escape key
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    if (rescheduleModal.style.display === 'block') {
                        closeRescheduleModal();
                    }
                    if (cancelModal.style.display === 'block') {
                        closeCancelModal();
                    }
                }
            });

            // Loading overlay functions
            const loadingOverlay = document.getElementById('loadingOverlay');

            function showLoading() {
                loadingOverlay.classList.add('active');
            }

            function hideLoading() {
                loadingOverlay.classList.remove('active');
            }

            // Handle appointment cancellation
            if (confirmCancelBtn) {
                confirmCancelBtn.addEventListener('click', function() {
                    // Show loading overlay
                    showLoading();

                    // Send AJAX request to cancel appointment
                    fetch('${pageContext.request.contextPath}/appointment/cancel', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        body: 'id=<%= appointment.getId() %>'
                    })
                    .then(response => {
                        if (response.ok) {
                            // Redirect to appointments page with success message
                            window.location.href = '${pageContext.request.contextPath}/patient/appointments?message=cancelled';
                        } else {
                            throw new Error('Failed to cancel appointment');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        hideLoading();
                        alert('Failed to cancel appointment. Please try again.');
                        cancelModal.style.display = 'none';
                    });
                });
            }

            // Handle form submission for rescheduling
            const rescheduleForm = document.getElementById('rescheduleForm');
            if (rescheduleForm) {
                rescheduleForm.addEventListener('submit', function(e) {
                    e.preventDefault();

                    // Check if appointment status allows rescheduling
                    const appointmentStatus = '<%= appointment.getStatus() %>';
                    if (appointmentStatus !== 'PENDING') {
                        alert('Only pending appointments can be rescheduled.');
                        return;
                    }

                    // Basic form validation
                    const newDate = document.getElementById('newDate').value;
                    const newTime = document.getElementById('newTime').value;
                    const reason = document.getElementById('reason').value;

                    // Validate each field individually for better error messages
                    if (!newDate) {
                        alert('Please select a new date for the appointment.');
                        document.getElementById('newDate').focus();
                        return;
                    }

                    if (!newTime) {
                        alert('Please select a new time for the appointment.');
                        document.getElementById('newTime').focus();
                        return;
                    }

                    if (!reason.trim()) {
                        alert('Please provide a reason for rescheduling the appointment.');
                        document.getElementById('reason').focus();
                        return;
                    }

                    // Show loading overlay
                    showLoading();

                    const formData = new FormData(rescheduleForm);
                    const searchParams = new URLSearchParams();

                    for (const pair of formData) {
                        searchParams.append(pair[0], pair[1]);
                    }

                    // Log the form data being sent
                    console.log('Sending appointment reschedule request with data:', {
                        appointmentId: formData.get('appointmentId'),
                        newDate: formData.get('newDate'),
                        newTime: formData.get('newTime'),
                        reason: formData.get('reason')
                    });

                    // Send AJAX request to reschedule appointment
                    console.log('Sending request to: ${pageContext.request.contextPath}/appointment/reschedule');
                    console.log('Request body:', searchParams.toString());

                    // Show loading overlay before sending request
                    showLoading();

                    // Add a hidden field to indicate this is not an AJAX request
                    const hiddenField = document.createElement('input');
                    hiddenField.type = 'hidden';
                    hiddenField.name = 'isRegularSubmission';
                    hiddenField.value = 'true';
                    rescheduleForm.appendChild(hiddenField);

                    // Submit the form directly for a regular form submission
                    // This will allow the server to handle the redirect
                    rescheduleForm.submit();
                });
            }
        });
    </script>
</body>
</html>
