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

    // Get doctor information from request attribute
    Doctor doctor = (Doctor) request.getAttribute("doctor");

    // Set default doctor name
    String doctorName = "Dr. " + user.getFirstName() + " " + user.getLastName();

    // If doctor object is available, use its name
    if (doctor != null && doctor.getName() != null && !doctor.getName().isEmpty()) {
        doctorName = doctor.getName();
    }
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
        <!-- Include the standardized sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <div class="top-header-left">
                    <a href="${pageContext.request.contextPath}/doctor/dashboard">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments">Appointment Management</a>
                    <a href="${pageContext.request.contextPath}/doctor/patients">Patient Details</a>
                </div>

                <div class="top-header-right">
                    <div class="search-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="user-profile-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/default-doctor.png" alt="Doctor">
                    </div>
                </div>
            </div>

            <!-- Availability Settings -->
            <div class="availability-container">
                <div class="availability-header">
                    <h2>Set Availability</h2>
                </div>

                <form id="availability-form" action="${pageContext.request.contextPath}/doctor/update-availability" method="post" enctype="application/x-www-form-urlencoded">
                    <div class="availability-content">
                        <div class="availability-section">
                            <h3>Weekly Schedule</h3>

                            <%
                            // Parse available days from doctor object
                            String availableDays = (doctor != null && doctor.getAvailableDays() != null) ? doctor.getAvailableDays() : "Monday,Tuesday,Wednesday,Thursday,Friday";
                            String[] days = availableDays.split(",");

                            // Create a set for easy checking
                            java.util.Set<String> availableDaysSet = new java.util.HashSet<>();
                            for (String day : days) {
                                availableDaysSet.add(day.trim());
                            }

                            // Parse available time from doctor object
                            String availableTime = (doctor != null && doctor.getAvailableTime() != null) ? doctor.getAvailableTime() : "09:00 AM - 05:00 PM";
                            String startTime = "09:00";
                            String endTime = "17:00";

                            if (availableTime.contains("-")) {
                                String[] times = availableTime.split("-");
                                if (times.length == 2) {
                                    String startTimeStr = times[0].trim();
                                    String endTimeStr = times[1].trim();

                                    // Convert from AM/PM format to 24-hour format if needed
                                    if (startTimeStr.contains("AM") || startTimeStr.contains("PM")) {
                                        try {
                                            java.text.SimpleDateFormat inputFormat = new java.text.SimpleDateFormat("hh:mm a");
                                            java.text.SimpleDateFormat outputFormat = new java.text.SimpleDateFormat("HH:mm");

                                            java.util.Date date = inputFormat.parse(startTimeStr);
                                            startTime = outputFormat.format(date);

                                            date = inputFormat.parse(endTimeStr);
                                            endTime = outputFormat.format(date);
                                        } catch (Exception e) {
                                            // Use default values if parsing fails
                                            e.printStackTrace();
                                        }
                                    } else {
                                        startTime = startTimeStr;
                                        endTime = endTimeStr;
                                    }
                                }
                            }
                            %>

                            <div class="day-item">
                                <input type="checkbox" id="monday" name="days" value="Monday" class="day-checkbox" <%= availableDaysSet.contains("Monday") ? "checked" : "" %>>
                                <label for="monday" class="day-label">Monday</label>
                                <div class="time-inputs">
                                    <input type="time" name="monday-start" value="<%= startTime %>" class="start-time" <%= !availableDaysSet.contains("Monday") ? "disabled" : "" %>>
                                    <span class="time-separator">to</span>
                                    <input type="time" name="monday-end" value="<%= endTime %>" class="end-time" <%= !availableDaysSet.contains("Monday") ? "disabled" : "" %>>
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="tuesday" name="days" value="Tuesday" class="day-checkbox" <%= availableDaysSet.contains("Tuesday") ? "checked" : "" %>>
                                <label for="tuesday" class="day-label">Tuesday</label>
                                <div class="time-inputs">
                                    <input type="time" name="tuesday-start" value="<%= startTime %>" class="start-time" <%= !availableDaysSet.contains("Tuesday") ? "disabled" : "" %>>
                                    <span class="time-separator">to</span>
                                    <input type="time" name="tuesday-end" value="<%= endTime %>" class="end-time" <%= !availableDaysSet.contains("Tuesday") ? "disabled" : "" %>>
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="wednesday" name="days" value="Wednesday" class="day-checkbox" <%= availableDaysSet.contains("Wednesday") ? "checked" : "" %>>
                                <label for="wednesday" class="day-label">Wednesday</label>
                                <div class="time-inputs">
                                    <input type="time" name="wednesday-start" value="<%= startTime %>" class="start-time" <%= !availableDaysSet.contains("Wednesday") ? "disabled" : "" %>>
                                    <span class="time-separator">to</span>
                                    <input type="time" name="wednesday-end" value="<%= endTime %>" class="end-time" <%= !availableDaysSet.contains("Wednesday") ? "disabled" : "" %>>
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="thursday" name="days" value="Thursday" class="day-checkbox" <%= availableDaysSet.contains("Thursday") ? "checked" : "" %>>
                                <label for="thursday" class="day-label">Thursday</label>
                                <div class="time-inputs">
                                    <input type="time" name="thursday-start" value="<%= startTime %>" class="start-time" <%= !availableDaysSet.contains("Thursday") ? "disabled" : "" %>>
                                    <span class="time-separator">to</span>
                                    <input type="time" name="thursday-end" value="<%= endTime %>" class="end-time" <%= !availableDaysSet.contains("Thursday") ? "disabled" : "" %>>
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="friday" name="days" value="Friday" class="day-checkbox" <%= availableDaysSet.contains("Friday") ? "checked" : "" %>>
                                <label for="friday" class="day-label">Friday</label>
                                <div class="time-inputs">
                                    <input type="time" name="friday-start" value="<%= startTime %>" class="start-time" <%= !availableDaysSet.contains("Friday") ? "disabled" : "" %>>
                                    <span class="time-separator">to</span>
                                    <input type="time" name="friday-end" value="<%= endTime %>" class="end-time" <%= !availableDaysSet.contains("Friday") ? "disabled" : "" %>>
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="saturday" name="days" value="Saturday" class="day-checkbox" <%= availableDaysSet.contains("Saturday") ? "checked" : "" %>>
                                <label for="saturday" class="day-label">Saturday</label>
                                <div class="time-inputs">
                                    <input type="time" name="saturday-start" value="<%= startTime %>" class="start-time" <%= !availableDaysSet.contains("Saturday") ? "disabled" : "" %>>
                                    <span class="time-separator">to</span>
                                    <input type="time" name="saturday-end" value="<%= endTime %>" class="end-time" <%= !availableDaysSet.contains("Saturday") ? "disabled" : "" %>>
                                </div>
                            </div>

                            <div class="day-item">
                                <input type="checkbox" id="sunday" name="days" value="Sunday" class="day-checkbox" <%= availableDaysSet.contains("Sunday") ? "checked" : "" %>>
                                <label for="sunday" class="day-label">Sunday</label>
                                <div class="time-inputs">
                                    <input type="time" name="sunday-start" value="<%= startTime %>" class="start-time" <%= !availableDaysSet.contains("Sunday") ? "disabled" : "" %>>
                                    <span class="time-separator">to</span>
                                    <input type="time" name="sunday-end" value="<%= endTime %>" class="end-time" <%= !availableDaysSet.contains("Sunday") ? "disabled" : "" %>>
                                </div>
                            </div>

                            <div class="break-time">
                                <h4>Break Time</h4>
                                <div class="time-inputs">
                                    <input type="time" value="12:00" id="break-start" name="break-start">
                                    <span class="time-separator">to</span>
                                    <input type="time" value="13:00" id="break-end" name="break-end">
                                </div>
                            </div>

                            <!-- Hidden fields to store the final values -->
                            <input type="hidden" id="availableDays" name="availableDays" value="<%= availableDays %>">
                            <input type="hidden" id="availableTime" name="availableTime" value="<%= availableTime %>">
                        </div>

                        <div class="availability-section">
                            <h3>Appointment Settings</h3>

                            <div class="slot-duration">
                                <h4>Appointment Duration</h4>
                                <select id="slot-duration" name="slotDuration">
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
                                    <!-- Vacation items will be added dynamically -->
                                </div>
                            </div>
                        </div>

                        <div class="availability-actions">
                            <button type="button" class="btn btn-outline" id="cancel-btn">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save Changes
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
                    updateAvailableDays();
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
                        window.location.href = '${pageContext.request.contextPath}/doctor/dashboard';
                    }
                });
            }

            // Function to update available days hidden field
            function updateAvailableDays() {
                const checkedDays = Array.from(document.querySelectorAll('.day-checkbox:checked'))
                    .map(checkbox => checkbox.value);

                document.getElementById('availableDays').value = checkedDays.join(',');
            }

            // Function to update available time hidden field
            function updateAvailableTime() {
                // Get the first checked day's time range
                const firstCheckedDay = document.querySelector('.day-checkbox:checked');
                if (firstCheckedDay) {
                    const dayItem = firstCheckedDay.closest('.day-item');
                    const startTime = dayItem.querySelector('.start-time').value;
                    const endTime = dayItem.querySelector('.end-time').value;

                    // Convert to 12-hour format with AM/PM
                    const startDate = new Date();
                    const [startHours, startMinutes] = startTime.split(':');
                    startDate.setHours(parseInt(startHours, 10));
                    startDate.setMinutes(parseInt(startMinutes, 10));

                    const endDate = new Date();
                    const [endHours, endMinutes] = endTime.split(':');
                    endDate.setHours(parseInt(endHours, 10));
                    endDate.setMinutes(parseInt(endMinutes, 10));

                    const startFormatted = startDate.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
                    const endFormatted = endDate.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });

                    document.getElementById('availableTime').value = startFormatted + ' - ' + endFormatted;
                }
            }

            // Form submission
            const form = document.getElementById('availability-form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();

                    // Update hidden fields before submission
                    updateAvailableDays();
                    updateAvailableTime();

                    // Create URL-encoded form data
                    const formData = new URLSearchParams(new FormData(form));

                    // Submit the form using fetch API
                    fetch(form.action, {
                        method: 'POST',
                        body: formData,
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-Requested-With': 'XMLHttpRequest'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Show success message
                            alert(data.message || 'Availability settings saved successfully!');

                            // Redirect to dashboard
                            window.location.href = '${pageContext.request.contextPath}/doctor/dashboard';
                        } else {
                            // Show error message
                            alert(data.message || 'Failed to save availability settings. Please try again.');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('An error occurred while saving availability settings. Please try again.');
                    });
                });
            }

            // Initialize available days on page load
            updateAvailableDays();

            // Add event listeners for time inputs
            document.querySelectorAll('.time-inputs input').forEach(input => {
                input.addEventListener('change', updateAvailableTime);
            });

            // Initialize available time on page load
            updateAvailableTime();
        });
    </script>
</body>
</html>
