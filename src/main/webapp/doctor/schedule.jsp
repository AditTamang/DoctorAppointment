<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.DoctorSchedule" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Schedule | Doctor Dashboard</title>

    <!-- Favicon -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard-complete.css">
    <style>
        /* Additional CSS fixes */
        .form-row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -10px 15px;
        }
        .form-group {
            flex: 1;
            padding: 0 10px;
            margin-bottom: 15px;
            min-width: 200px;
        }
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }
        .edit-form {
            display: none;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 4px;
            margin-top: 10px;
        }
        .edit-form.active {
            display: block;
        }
        .edit-row {
            display: none;
        }
        .edit-row.active {
            display: table-row;
        }
        .empty-state {
            text-align: center;
            padding: 30px 20px;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #adb5bd;
        }
        .empty-state p {
            font-size: 16px;
            color: #6c757d;
            margin-bottom: 20px;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-badge.pending {
            background-color: #f39c12;
            color: white;
        }
        .status-badge.approved {
            background-color: #2ecc71;
            color: white;
        }
        .status-badge.rejected {
            background-color: #e74c3c;
            color: white;
        }
        .status-badge.completed {
            background-color: #3498db;
            color: white;
        }
        .text-center {
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content" id="main-content">
            <!-- Top Header -->
            <header class="top-header">
                <div class="header-nav">
                    <a href="${pageContext.request.contextPath}/doctor/dashboard">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments">Appointments</a>
                    <a href="${pageContext.request.contextPath}/doctor/schedule" class="active">Availability</a>
                </div>

                <div class="header-actions">
                    <div class="search-container">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" class="search-input" placeholder="Search...">
                    </div>

                    <div class="user-profile">
                        <img src="${(doctor != null && doctor.profileImage != null) ? doctor.profileImage : pageContext.request.contextPath.concat('/assets/images/default-doctor.png')}" alt="Doctor Profile">
                        <div class="user-info">
                            <span class="user-name">Dr. ${(user != null) ? user.firstName : ''} ${(user != null) ? user.lastName : ''}</span>
                            <span class="user-role">${(doctor != null) ? doctor.specialization : 'Specialist'}</span>
                        </div>
                        <i class="fas fa-chevron-down dropdown-icon"></i>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <!-- Welcome Section -->
                <div class="welcome-section">
                    <div class="welcome-header">
                        <div class="welcome-title">
                            <h2>Manage Your Availability</h2>
                            <p>Set your working hours and break times for each day of the week.</p>
                        </div>
                    </div>
                </div>

            <div class="dashboard-main">
                <!-- Alert Messages -->
                <c:if test="${param.success != null}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <c:choose>
                            <c:when test="${param.success == 'added'}">
                                Schedule has been added successfully.
                            </c:when>
                            <c:when test="${param.success == 'updated'}">
                                Schedule has been updated successfully.
                            </c:when>
                            <c:when test="${param.success == 'deleted'}">
                                Schedule has been deleted successfully.
                            </c:when>
                            <c:otherwise>
                                Operation completed successfully.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <c:if test="${param.error != null}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <c:choose>
                            <c:when test="${param.error == 'missing_fields'}">
                                Please fill in all required fields.
                            </c:when>
                            <c:when test="${param.error == 'schedule_exists'}">
                                A schedule for this day already exists. Please update the existing schedule.
                            </c:when>
                            <c:when test="${param.error == 'add_failed'}">
                                Failed to add schedule. Please try again.
                            </c:when>
                            <c:when test="${param.error == 'update_failed'}">
                                Failed to update schedule. Please try again.
                            </c:when>
                            <c:when test="${param.error == 'delete_failed'}">
                                Failed to delete schedule. Please try again.
                            </c:when>
                            <c:when test="${param.error == 'schedule_not_found'}">
                                Schedule not found.
                            </c:when>
                            <c:otherwise>
                                An error occurred: ${param.message}
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Add New Schedule Form -->
                <div class="content-card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-plus-circle"></i> Add New Schedule
                        </h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/doctor/schedule/add" method="post" class="schedule-form" id="scheduleForm">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="dayOfWeek">Day of Week</label>
                                    <select name="dayOfWeek" id="dayOfWeek" class="form-control" required>
                                        <option value="">Select Day</option>
                                        <option value="Monday">Monday</option>
                                        <option value="Tuesday">Tuesday</option>
                                        <option value="Wednesday">Wednesday</option>
                                        <option value="Thursday">Thursday</option>
                                        <option value="Friday">Friday</option>
                                        <option value="Saturday">Saturday</option>
                                        <option value="Sunday">Sunday</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="startTime">Start Time</label>
                                    <input type="time" name="startTime" id="startTime" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="endTime">End Time</label>
                                    <input type="time" name="endTime" id="endTime" class="form-control" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="breakStartTime">Break Start Time (Optional)</label>
                                    <input type="time" name="breakStartTime" id="breakStartTime" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label for="breakEndTime">Break End Time (Optional)</label>
                                    <input type="time" name="breakEndTime" id="breakEndTime" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label for="maxAppointments">Max Appointments</label>
                                    <input type="number" name="maxAppointments" id="maxAppointments" class="form-control" value="20" min="1" max="50" required>
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Save Schedule
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Current Schedules -->
                <div class="content-card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-calendar-alt"></i> Current Schedules
                        </h3>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty schedules}">
                                <div class="table-container">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Day</th>
                                                <th>Start Time</th>
                                                <th>End Time</th>
                                                <th>Break Time</th>
                                                <th>Max Appointments</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="schedule" items="${schedules}">
                                                <tr>
                                                    <td>${schedule.dayOfWeek}</td>
                                                    <td>${schedule.formattedStartTime}</td>
                                                    <td>${schedule.formattedEndTime}</td>
                                                    <td>
                                                        <c:if test="${not empty schedule.breakStartTime and not empty schedule.breakEndTime}">
                                                            ${schedule.formattedBreakStartTime} - ${schedule.formattedBreakEndTime}
                                                        </c:if>
                                                        <c:if test="${empty schedule.breakStartTime or empty schedule.breakEndTime}">
                                                            No break
                                                        </c:if>
                                                    </td>
                                                    <td>${schedule.maxAppointments}</td>
                                                    <td>
                                                        <div class="table-actions">
                                                            <a href="#" class="action-btn edit" title="Edit" onclick="showEditForm(${schedule.id})">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/doctor/schedule/delete?scheduleId=${schedule.id}" class="action-btn delete" title="Delete" onclick="return confirm('Are you sure you want to delete this schedule?')">
                                                                <i class="fas fa-trash"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr class="edit-row" id="editRow${schedule.id}">
                                                    <td colspan="6">
                                                        <div id="editForm${schedule.id}" class="edit-form">
                                                            <form action="${pageContext.request.contextPath}/doctor/schedule/update" method="post">
                                                                <input type="hidden" name="scheduleId" value="${schedule.id}">
                                                                <div class="form-row">
                                                                    <div class="form-group">
                                                                        <label>Day: ${schedule.dayOfWeek}</label>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label for="startTime${schedule.id}">Start Time</label>
                                                                        <input type="time" name="startTime" id="startTime${schedule.id}" class="form-control" value="${schedule.formattedStartTime}" required>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label for="endTime${schedule.id}">End Time</label>
                                                                        <input type="time" name="endTime" id="endTime${schedule.id}" class="form-control" value="${schedule.formattedEndTime}" required>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="form-group">
                                                                        <label for="breakStartTime${schedule.id}">Break Start Time</label>
                                                                        <input type="time" name="breakStartTime" id="breakStartTime${schedule.id}" class="form-control" value="${schedule.formattedBreakStartTime}">
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label for="breakEndTime${schedule.id}">Break End Time</label>
                                                                        <input type="time" name="breakEndTime" id="breakEndTime${schedule.id}" class="form-control" value="${schedule.formattedBreakEndTime}">
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label for="maxAppointments${schedule.id}">Max Appointments</label>
                                                                        <input type="number" name="maxAppointments" id="maxAppointments${schedule.id}" class="form-control" value="${schedule.maxAppointments}" min="1" max="50" required>
                                                                    </div>
                                                                </div>
                                                                <div class="form-actions">
                                                                    <button type="submit" class="btn btn-success">
                                                                        <i class="fas fa-save"></i> Update
                                                                    </button>
                                                                    <button type="button" class="btn btn-danger" onclick="hideEditForm(${schedule.id})">
                                                                        <i class="fas fa-times"></i> Cancel
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-calendar-times"></i>
                                    <p>No schedules found. Please add your availability using the form above.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            </div>
        </div>
    </div>

    <script>
        // Set context path for JavaScript
        const contextPath = '${pageContext.request.contextPath}';

        // Show edit form
        function showEditForm(scheduleId) {
            document.getElementById('editForm' + scheduleId).classList.add('active');
            document.getElementById('editRow' + scheduleId).classList.add('active');
        }

        // Hide edit form
        function hideEditForm(scheduleId) {
            document.getElementById('editForm' + scheduleId).classList.remove('active');
            document.getElementById('editRow' + scheduleId).classList.remove('active');
        }

        // Toggle sidebar
        if (document.getElementById('sidebar-toggle')) {
            document.getElementById('sidebar-toggle').addEventListener('click', function() {
                document.getElementById('sidebar').classList.toggle('sidebar-collapsed');
                document.getElementById('main-content').classList.toggle('main-content-expanded');
            });
        }

        // Validate time inputs
        document.addEventListener('DOMContentLoaded', function() {
            const startTimeInput = document.getElementById('startTime');
            const endTimeInput = document.getElementById('endTime');
            const breakStartTimeInput = document.getElementById('breakStartTime');
            const breakEndTimeInput = document.getElementById('breakEndTime');

            // Form validation
            if (document.getElementById('scheduleForm')) {
                document.getElementById('scheduleForm').addEventListener('submit', function(e) {
                    // Check if day is selected
                    const dayOfWeek = document.getElementById('dayOfWeek');
                    if (!dayOfWeek.value) {
                        e.preventDefault();
                        alert('Please select a day of the week');
                        return false;
                    }

                    // Check if end time is after start time
                    if (endTimeInput.value <= startTimeInput.value) {
                        e.preventDefault();
                        alert('End time must be after start time');
                        return false;
                    }

                    // Check if break times are valid
                    if (breakStartTimeInput.value && breakEndTimeInput.value) {
                        if (breakEndTimeInput.value <= breakStartTimeInput.value) {
                            e.preventDefault();
                            alert('Break end time must be after break start time');
                            return false;
                        }

                        if (breakStartTimeInput.value < startTimeInput.value || breakEndTimeInput.value > endTimeInput.value) {
                            e.preventDefault();
                            alert('Break time must be within working hours');
                            return false;
                        }
                    }

                    return true;
                });
            }

            // Validate end time is after start time
            if (endTimeInput) {
                endTimeInput.addEventListener('change', function() {
                    if (startTimeInput.value && endTimeInput.value) {
                        if (endTimeInput.value <= startTimeInput.value) {
                            alert('End time must be after start time');
                            endTimeInput.value = '';
                        }
                    }
                });
            }

            // Validate break times are within working hours
            function validateBreakTimes() {
                if (breakStartTimeInput && breakEndTimeInput &&
                    breakStartTimeInput.value && breakEndTimeInput.value) {
                    if (breakEndTimeInput.value <= breakStartTimeInput.value) {
                        alert('Break end time must be after break start time');
                        breakEndTimeInput.value = '';
                        return;
                    }

                    if (startTimeInput.value && endTimeInput.value) {
                        if (breakStartTimeInput.value < startTimeInput.value || breakEndTimeInput.value > endTimeInput.value) {
                            alert('Break times must be within working hours');
                            breakStartTimeInput.value = '';
                            breakEndTimeInput.value = '';
                        }
                    }
                }
            }

            if (breakStartTimeInput) {
                breakStartTimeInput.addEventListener('change', validateBreakTimes);
            }

            if (breakEndTimeInput) {
                breakEndTimeInput.addEventListener('change', validateBreakTimes);
            }
        });
    </script>
</body>
</html>
