<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor data from request attribute
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctors");
        return;
    }

    // Get available time slots
    List<String> availableTimeSlots = (List<String>) request.getAttribute("availableTimeSlots");
    if (availableTimeSlots == null) {
        availableTimeSlots = java.util.Arrays.asList("09:00 AM", "10:00 AM", "11:00 AM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patientDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-booking.css">
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
                        <div class="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                    <% } %>
                </div>
                <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
                <p class="user-role">Patient</p>
            </div>

            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/patient/dashboard">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/appointments">
                        <i class="fas fa-calendar-check"></i>
                        <span>My Appointments</span>
                    </a>
                </li>
                <li class="active">
                    <a href="${pageContext.request.contextPath}/doctors">
                        <i class="fas fa-user-md"></i>
                        <span>Find Doctors</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/patient/medicalRecords.jsp">
                        <i class="fas fa-file-medical"></i>
                        <span>Medical Records</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/patient/profile">
                        <i class="fas fa-user"></i>
                        <span>My Profile</span>
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

        <!-- Main Content -->
        <div class="dashboard-main">
            <!-- Top Navigation -->
            <div class="dashboard-nav">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </div>

                <div class="nav-right">
                    <div class="nav-user">
                        <div class="user-image">
                            <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                                <div class="user-initials">AT</div>
                            <% } else { %>
                                <div class="user-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
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
                <div class="page-header">
                    <h1>Book an Appointment</h1>
                    <p>Schedule an appointment with your selected doctor</p>
                </div>

                <!-- Success or Error Messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>

                <div class="booking-container">
                    <div class="booking-header">
                        <div class="doctor-avatar">
                            <img src="${pageContext.request.contextPath}${doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty() ? (doctor.getImageUrl().startsWith('/') ? doctor.getImageUrl() : '/assets/images/doctors/'.concat(doctor.getImageUrl())) : '/assets/images/doctors/d1.png'}" alt="Doctor Profile">
                        </div>
                        <div class="doctor-info">
                            <h2><%= doctor.getName().startsWith("Dr.") ? doctor.getName() : "Dr. " + doctor.getName() %></h2>
                            <p><i class="fas fa-stethoscope"></i> <%= doctor.getSpecialization() %></p>
                            <p><i class="fas fa-graduation-cap"></i> <%= doctor.getQualification() != null ? doctor.getQualification() : "Qualified Professional" %></p>
                            <p><i class="fas fa-clock"></i> <%= doctor.getExperience() != null ? doctor.getExperience() : "Experienced" %></p>
                            <p><i class="fas fa-money-bill-wave"></i> Consultation Fee: $<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "Consultation fee will be discussed" %></p>
                        </div>
                    </div>

                    <div class="booking-body">
                        <form action="${pageContext.request.contextPath}/appointment/confirm" method="post">
                            <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">
                            <input type="hidden" name="patientId" value="${patientId}">

                            <div class="booking-section">
                                <h3>Appointment Details</h3>
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="appointmentDate">Appointment Date</label>
                                        <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" value="${appointmentDate}" min="<%= java.time.LocalDate.now() %>" required>
                                        <c:if test="${not empty dateError}">
                                            <div class="form-error">${dateError}</div>
                                        </c:if>
                                    </div>

                                    <div class="form-group">
                                        <label>Appointment Time</label>
                                        <div class="time-slots">
                                            <%
                                            for (String timeSlot : availableTimeSlots) {
                                                boolean isSelected = timeSlot.equals(request.getAttribute("appointmentTime"));
                                            %>
                                            <div class="time-slot">
                                                <input type="radio" id="time_<%= timeSlot.replace(" ", "_").replace(":", "") %>"
                                                       name="appointmentTime" value="<%= timeSlot %>"
                                                       <%= isSelected ? "checked" : "" %> required>
                                                <label for="time_<%= timeSlot.replace(" ", "_").replace(":", "") %>"><%= timeSlot %></label>
                                            </div>
                                            <% } %>
                                        </div>
                                        <c:if test="${not empty timeError}">
                                            <div class="form-error">${timeError}</div>
                                        </c:if>
                                    </div>

                                    <div class="form-group-full">
                                        <label for="reason">Reason for Visit</label>
                                        <input type="text" id="reason" name="reason" class="form-control" value="${reason}" placeholder="e.g., Regular checkup, Consultation, Follow-up" required>
                                        <c:if test="${not empty reasonError}">
                                            <div class="form-error">${reasonError}</div>
                                        </c:if>
                                    </div>

                                    <div class="form-group-full">
                                        <label for="symptoms">Symptoms (if any)</label>
                                        <textarea id="symptoms" name="symptoms" class="form-control" placeholder="Describe your symptoms or health concerns">${symptoms}</textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/doctors" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-calendar-check"></i> Confirm Booking
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar on mobile
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
        });

        // Set min date for appointment date picker
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appointmentDate').min = today;

        // Check if doctor is available on selected date
        document.getElementById('appointmentDate').addEventListener('change', function() {
            const selectedDate = new Date(this.value);
            const dayOfWeek = selectedDate.toLocaleString('en-us', { weekday: 'long' });

            // Get doctor's available days
            const availableDays = "<%= doctor.getAvailableDays() != null ? doctor.getAvailableDays() : "Monday,Tuesday,Wednesday,Thursday,Friday" %>".split(',');

            // Check if selected day is in doctor's available days
            const isDoctorAvailable = availableDays.some(day => day.trim() === dayOfWeek);

            if (!isDoctorAvailable) {
                alert(`Dr. <%= doctor.getName() %> is not available on ${dayOfWeek}s. Please select another date.`);
                this.value = '';
            }
        });

        // Form validation
        document.querySelector('form').addEventListener('submit', function(event) {
            let isValid = true;
            const appointmentDate = document.getElementById('appointmentDate').value;
            const appointmentTime = document.querySelector('input[name="appointmentTime"]:checked');
            const reason = document.getElementById('reason').value;

            // Check if date is selected
            if (!appointmentDate) {
                isValid = false;
                if (!document.querySelector('.date-error')) {
                    const dateField = document.getElementById('appointmentDate');
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'form-error date-error';
                    errorDiv.textContent = 'Please select an appointment date';
                    dateField.parentNode.appendChild(errorDiv);
                }
            } else {
                const dateError = document.querySelector('.date-error');
                if (dateError) dateError.remove();
            }

            // Check if time is selected
            if (!appointmentTime) {
                isValid = false;
                if (!document.querySelector('.time-error')) {
                    const timeSlots = document.querySelector('.time-slots');
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'form-error time-error';
                    errorDiv.textContent = 'Please select an appointment time';
                    timeSlots.parentNode.appendChild(errorDiv);
                }
            } else {
                const timeError = document.querySelector('.time-error');
                if (timeError) timeError.remove();
            }

            // Check if reason is provided
            if (!reason.trim()) {
                isValid = false;
                if (!document.querySelector('.reason-error')) {
                    const reasonField = document.getElementById('reason');
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'form-error reason-error';
                    errorDiv.textContent = 'Please provide a reason for your visit';
                    reasonField.parentNode.appendChild(errorDiv);
                }
            } else {
                const reasonError = document.querySelector('.reason-error');
                if (reasonError) reasonError.remove();
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    </script>
</body>
</html>
