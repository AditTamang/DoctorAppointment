<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor information
    String doctorName = "Dr. Harlan Drake";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set Availability | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile-dashboard.css">
    <style>
        .availability-container {
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .availability-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
        }

        .availability-header h2 {
            font-size: 20px;
            font-weight: 600;
        }

        .availability-content {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .availability-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }

        .availability-section h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }

        .day-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .day-checkbox {
            margin-right: 10px;
        }

        .day-label {
            font-weight: 500;
            width: 100px;
        }

        .time-inputs {
            display: flex;
            align-items: center;
            flex: 1;
        }

        .time-inputs input {
            width: 100px;
            padding: 8px;
            border: 1px solid #ced4da;
            border-radius: 5px;
        }

        .time-separator {
            margin: 0 10px;
            color: #6c757d;
        }

        .break-time {
            margin-top: 20px;
        }

        .break-time h4 {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 10px;
            color: #333;
        }

        .slot-duration {
            margin-top: 20px;
        }

        .slot-duration h4 {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 10px;
            color: #333;
        }

        .slot-duration select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
        }

        .vacation-section {
            margin-top: 20px;
        }

        .vacation-section h4 {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 10px;
            color: #333;
        }

        .vacation-inputs {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }

        .vacation-inputs input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
        }

        .vacation-list {
            margin-top: 15px;
        }

        .vacation-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        .vacation-item-dates {
            font-weight: 500;
        }

        .vacation-item-remove {
            color: #dc3545;
            cursor: pointer;
        }

        .availability-actions {
            grid-column: span 2;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        @media (max-width: 768px) {
            .availability-content {
                grid-template-columns: 1fr;
            }

            .availability-actions {
                grid-column: span 1;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="HealthPro Logo">
                <h2>HealthPro Portal</h2>
            </div>

            <div class="profile-overview">
                <h3><i class="fas fa-user-md"></i> <span>Profile Overview</span></h3>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="index.jsp">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="appointments.jsp">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointment Management</span>
                        </a>
                    </li>
                    <li>
                        <a href="patients.jsp">
                            <i class="fas fa-user-injured"></i>
                            <span>Patient Details</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="availability.jsp">
                            <i class="fas fa-clock"></i>
                            <span>Set Availability</span>
                        </a>
                    </li>
                    <li>
                        <a href="health-packages.jsp">
                            <i class="fas fa-box-open"></i>
                            <span>Health Packages</span>
                        </a>
                    </li>
                    <li>
                        <a href="preferences.jsp">
                            <i class="fas fa-cog"></i>
                            <span>UI Preferences</span>
                        </a>
                    </li>
                    <li class="logout">
                        <a href="../logout">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <div class="top-header-left">
                    <a href="index.jsp">Profile</a>
                    <a href="appointments.jsp">Appointment Management</a>
                    <a href="patients.jsp">Patient Details</a>
                </div>

                <div class="top-header-right">
                    <div class="search-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="user-profile-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                    </div>
                </div>
            </div>

            <!-- Availability Settings -->
            <div class="availability-container">
                <div class="availability-header">
                    <h2>Set Availability</h2>
                </div>

                <form id="availability-form">
                    <div class="availability-content">
                        <div class="availability-section">
                            <h3>Weekly Schedule</h3>

                            <div class="day-item">
                                <input type="checkbox" id="monday" class="day-checkbox" checked>
                                <label for="monday" class="day-label">Monday</label>
                                <div class="time-inputs">
                                    <input type="time" value="09:00" class="start-time">
                                    <span class="time-separator">to</span>
                                    <input type="time" value="17:00" class="end-time">
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="tuesday" class="day-checkbox" checked>
                                <label for="tuesday" class="day-label">Tuesday</label>
                                <div class="time-inputs">
                                    <input type="time" value="09:00" class="start-time">
                                    <span class="time-separator">to</span>
                                    <input type="time" value="17:00" class="end-time">
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="wednesday" class="day-checkbox" checked>
                                <label for="wednesday" class="day-label">Wednesday</label>
                                <div class="time-inputs">
                                    <input type="time" value="09:00" class="start-time">
                                    <span class="time-separator">to</span>
                                    <input type="time" value="17:00" class="end-time">
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="thursday" class="day-checkbox" checked>
                                <label for="thursday" class="day-label">Thursday</label>
                                <div class="time-inputs">
                                    <input type="time" value="09:00" class="start-time">
                                    <span class="time-separator">to</span>
                                    <input type="time" value="17:00" class="end-time">
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="friday" class="day-checkbox" checked>
                                <label for="friday" class="day-label">Friday</label>
                                <div class="time-inputs">
                                    <input type="time" value="09:00" class="start-time">
                                    <span class="time-separator">to</span>
                                    <input type="time" value="17:00" class="end-time">
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="saturday" class="day-checkbox">
                                <label for="saturday" class="day-label">Saturday</label>
                                <div class="time-inputs">
                                    <input type="time" value="10:00" class="start-time" disabled>
                                    <span class="time-separator">to</span>
                                    <input type="time" value="14:00" class="end-time" disabled>
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="sunday" class="day-checkbox">
                                <label for="sunday" class="day-label">Sunday</label>
                                <div class="time-inputs">
                                    <input type="time" value="10:00" class="start-time" disabled>
                                    <span class="time-separator">to</span>
                                    <input type="time" value="14:00" class="end-time" disabled>
                                </div>
                            </div>

                            <div class="break-time">
                                <h4>Break Time</h4>
                                <div class="time-inputs">
                                    <input type="time" value="12:00" id="break-start">
                                    <span class="time-separator">to</span>
                                    <input type="time" value="13:00" id="break-end">
                                </div>
                            </div>
                        </div>

                        <div class="availability-section">
                            <h3>Appointment Settings</h3>

                            <div class="slot-duration">
                                <h4>Appointment Duration</h4>
                                <select id="slot-duration">
                                    <option value="15">15 minutes</option>
                                    <option value="30" selected>30 minutes</option>
                                    <option value="45">45 minutes</option>
                                    <option value="60">60 minutes</option>
                                </select>
                            </div>

                            <div class="vacation-section">
                                <h4>Vacation/Time Off</h4>
                                <div class="vacation-inputs">
                                    <input type="date" id="vacation-start" min="<%= java.time.LocalDate.now() %>">
                                    <input type="date" id="vacation-end" min="<%= java.time.LocalDate.now() %>">
                                    <button type="button" class="btn btn-outline" id="add-vacation">
                                        <i class="fas fa-plus"></i> Add
                                    </button>
                                </div>

                                <div class="vacation-list">
                                    <div class="vacation-item">
                                        <span class="vacation-item-dates">Dec 24, 2023 - Jan 2, 2024</span>
                                        <span class="vacation-item-remove"><i class="fas fa-times"></i></span>
                                    </div>
                                    <div class="vacation-item">
                                        <span class="vacation-item-dates">Nov 23, 2023 - Nov 26, 2023</span>
                                        <span class="vacation-item-remove"><i class="fas fa-times"></i></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="availability-actions">
                            <button type="button" class="btn btn-outline" id="cancel-btn">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Upload Changes
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Day checkbox functionality
            const dayCheckboxes = document.querySelectorAll('.day-checkbox');
            dayCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const timeInputs = this.parentElement.querySelectorAll('.time-inputs input');
                    timeInputs.forEach(input => {
                        input.disabled = !this.checked;
                    });
                });
            });

            // Add vacation functionality
            const addVacationBtn = document.getElementById('add-vacation');
            const vacationStart = document.getElementById('vacation-start');
            const vacationEnd = document.getElementById('vacation-end');
            const vacationList = document.querySelector('.vacation-list');

            if (addVacationBtn) {
                addVacationBtn.addEventListener('click', function() {
                    if (!vacationStart.value || !vacationEnd.value) {
                        alert('Please select both start and end dates.');
                        return;
                    }

                    const startDate = new Date(vacationStart.value);
                    const endDate = new Date(vacationEnd.value);

                    if (endDate < startDate) {
                        alert('End date cannot be before start date.');
                        return;
                    }

                    const startFormatted = startDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
                    const endFormatted = endDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });

                    const vacationItem = document.createElement('div');
                    vacationItem.className = 'vacation-item';
                    vacationItem.innerHTML = `
                        <span class="vacation-item-dates">${startFormatted} - ${endFormatted}</span>
                        <span class="vacation-item-remove"><i class="fas fa-times"></i></span>
                    `;

                    vacationList.appendChild(vacationItem);

                    // Clear inputs
                    vacationStart.value = '';
                    vacationEnd.value = '';

                    // Add remove functionality
                    const removeBtn = vacationItem.querySelector('.vacation-item-remove');
                    removeBtn.addEventListener('click', function() {
                        vacationItem.remove();
                    });
                });
            }

            // Remove vacation functionality
            const removeVacationBtns = document.querySelectorAll('.vacation-item-remove');
            removeVacationBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    this.closest('.vacation-item').remove();
                });
            });

            // Cancel button functionality
            const cancelBtn = document.getElementById('cancel-btn');
            if (cancelBtn) {
                cancelBtn.addEventListener('click', function() {
                    if (confirm('Are you sure you want to cancel? Any unsaved changes will be lost.')) {
                        window.location.href = 'index.jsp';
                    }
                });
            }

            // Form submission
            const form = document.getElementById('availability-form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();

                    // In a real application, you would collect all the form data and send it to the server
                    alert('Availability settings saved successfully!');
                    window.location.href = 'index.jsp';
                });
            }
        });
    </script>
</body>
</html>
