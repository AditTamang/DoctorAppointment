<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Doctor Appointment System</title>
    <!-- Include CSS files -->
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS (Bootstrap Replacement) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-custom.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: #f8f9fa;
            color: #333;
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            height: 100vh;
            background-color: #2c3e50;
            color: #fff;
            position: fixed;
            top: 0;
            left: 0;
            overflow-y: auto;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h3 {
            margin: 0;
            font-size: 1.5rem;
            color: #fff;
            font-weight: 600;
        }

        .profile-info {
            margin-top: 15px;
        }

        .user-name {
            font-weight: 500;
            font-size: 1rem;
        }

        .user-role {
            font-size: 0.8rem;
            color: rgba(255, 255, 255, 0.7);
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .menu-item {
            margin: 0;
        }

        .menu-link {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: #ecf0f1;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .menu-link:hover {
            background-color: #34495e;
            color: #fff;
            text-decoration: none;
        }

        .menu-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 20px;
            transition: all 0.3s ease;
        }

        /* Dashboard Stats Cards */
        .stats-cards {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-card {
            flex: 1;
            min-width: 200px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .stat-card-header {
            padding: 15px;
            color: white;
            font-weight: 600;
        }

        .doctors-header { background-color: #4e73df; }
        .patients-header { background-color: #1cc88a; }
        .bookings-header { background-color: #36b9cc; }
        .sessions-header { background-color: #f6c23e; }

        .stat-card-body {
            padding: 20px;
            text-align: center;
        }

        .stat-card-value {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-card-label {
            color: #6c757d;
            font-size: 1rem;
        }

        /* Appointment Tables */
        .appointment-section {
            margin-bottom: 30px;
        }

        .appointment-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .appointment-card-header {
            padding: 15px 20px;
            background-color: #4e73df;
            color: white;
        }

        .appointment-card-header h5 {
            margin: 0;
            font-weight: 600;
        }

        .appointment-card-header small {
            display: block;
            margin-top: 5px;
            opacity: 0.8;
        }

        .appointment-table {
            width: 100%;
            border-collapse: collapse;
        }

        .appointment-table th,
        .appointment-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        .appointment-table th {
            font-weight: 600;
            color: #495057;
        }

        .appointment-table tr:last-child td {
            border-bottom: none;
        }

        .show-all-btn {
            display: block;
            text-align: center;
            padding: 10px;
            background-color: #4e73df;
            color: white;
            text-decoration: none;
            border-radius: 0 0 8px 8px;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .show-all-btn:hover {
            background-color: #3a5cbe;
            color: white;
        }

        /* Doctor and Patient Tables */
        .tables-section {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }

        .table-card {
            flex: 1;
            min-width: 300px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .table-card-header {
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-card-header h5 {
            margin: 0;
            font-weight: 600;
            color: white;
        }

        .table-card-header a {
            color: white;
            text-decoration: none;
        }

        .doctors-table-header { background-color: #36b9cc; }
        .patients-table-header { background-color: #1cc88a; }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .user-details {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: 600;
        }

        .user-email, .user-id {
            font-size: 0.8rem;
            color: #6c757d;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            text-align: center;
        }

        .active-badge {
            background-color: #1cc88a;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .action-btn {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-decoration: none;
            transition: opacity 0.3s;
        }

        .view-btn { background-color: #36b9cc; }
        .edit-btn { background-color: #4e73df; }
        .delete-btn { background-color: #e74a3b; }
</head>
<body>
    <!-- Include admin sidebar -->
    <jsp:include page="admin-sidebar.jsp" />

    <div class="main-content">
        <div class="container-fluid p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 mb-0 text-gray-800">Dashboard</h1>
                    <p class="mb-0">Welcome to the admin dashboard!</p>
                </div>
            </div>

            <!-- Display error message if any -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Error!</strong> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-card-header doctors-header">
                        <i class="fas fa-user-md"></i> Doctors
                    </div>
                    <div class="stat-card-body">
                        <div class="stat-card-value">${doctorCount}</div>
                        <div class="stat-card-label">Total Doctors</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header patients-header">
                        <i class="fas fa-users"></i> Patients
                    </div>
                    <div class="stat-card-body">
                        <div class="stat-card-value">${patientCount}</div>
                        <div class="stat-card-label">Total Patients</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header bookings-header">
                        <i class="fas fa-calendar-check"></i> New Booking
                    </div>
                    <div class="stat-card-body">
                        <div class="stat-card-value">${newBookingCount}</div>
                        <div class="stat-card-label">Pending Appointments</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header sessions-header">
                        <i class="fas fa-calendar-day"></i> Today Sessions
                    </div>
                    <div class="stat-card-body">
                        <div class="stat-card-value">${todaySessionCount}</div>
                        <div class="stat-card-label">Appointments Today</div>
                    </div>
                </div>
            </div>

            <!-- Appointments Section -->
            <div class="row">
                <div class="col-md-6 appointment-section">
                    <div class="appointment-card">
                        <div class="appointment-card-header">
                            <h5>Upcoming Appointments until Next Friday</h5>
                            <small>Have Quick access to Upcoming Appointments next 7 days</small>
                        </div>
                        <div class="table-responsive">
                            <table class="appointment-table">
                                <thead>
                                    <tr>
                                        <th>Appointment number</th>
                                        <th>Patient name</th>
                                        <th>Doctor</th>
                                        <th>Session</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty upcomingAppointments}">
                                            <c:forEach var="appointment" items="${upcomingAppointments}">
                                                <tr>
                                                    <td>${appointment.id}</td>
                                                    <td>${appointment.patientName}</td>
                                                    <td>${appointment.doctorName}</td>
                                                    <td>${appointment.getFormattedDate()} ${appointment.appointmentTime}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="text-center">No upcoming appointments found</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <a href="javascript:void(0);" onclick="showAllAppointments()" class="show-all-btn">Show all Appointments</a>
                    </div>
                </div>

                <div class="col-md-6 appointment-section">
                    <div class="appointment-card">
                        <div class="appointment-card-header">
                            <h5>Upcoming Sessions until Next Friday</h5>
                            <small>Have Quick access to upcoming Sessions that scheduled until 7 days</small>
                        </div>
                        <div class="table-responsive">
                            <table class="appointment-table">
                                <thead>
                                    <tr>
                                        <th>Session Title</th>
                                        <th>Doctor</th>
                                        <th>Scheduled Date & Time</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty upcomingSessions}">
                                            <c:forEach var="session" items="${upcomingSessions}">
                                                <tr>
                                                    <td>Appointment #${session.id}</td>
                                                    <td>${session.doctorName}</td>
                                                    <td>${session.getFormattedDate()} ${session.appointmentTime}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="3" class="text-center">No upcoming sessions found</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <a href="javascript:void(0);" onclick="showAllSessions()" class="show-all-btn">Show all Sessions</a>
                    </div>
                </div>
            </div>

            <!-- Tables Section -->
            <div class="tables-section">
                <div class="table-card">
                    <div class="table-card-header doctors-table-header">
                        <h5>Recent Doctors</h5>
                        <a href="${pageContext.request.contextPath}/admin/doctors">View All</a>
                    </div>
                    <div class="table-responsive">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Doctor</th>
                                    <th>Specialization</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty topDoctors}">
                                        <c:forEach var="doctor" items="${topDoctors}">
                                            <tr>
                                                <td>
                                                    <div class="user-info">
                                                        <img src="${pageContext.request.contextPath}${doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty() ? doctor.getProfileImage() : (doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty() ? doctor.getImageUrl() : '/assets/images/doctors/default-doctor.png')}"
                                                             alt="${doctor.name}" class="user-avatar">
                                                        <div class="user-details">
                                                            <div class="user-name">${doctor.name}</div>
                                                            <div class="user-email">${doctor.email}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>${doctor.specialization}</td>
                                                <td>
                                                    <span class="status-badge active-badge">Active</span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/admin/doctors/view?id=${doctor.id}" class="action-btn view-btn">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/doctors/edit?id=${doctor.id}" class="action-btn edit-btn">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="#" onclick="confirmDelete(${doctor.id})" class="action-btn delete-btn">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center">No doctors found</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="table-card">
                    <div class="table-card-header patients-table-header">
                        <h5>Recent Patients</h5>
                        <a href="${pageContext.request.contextPath}/admin/patients">View All</a>
                    </div>
                    <div class="table-responsive">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Last Visit</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentAppointments}">
                                        <c:forEach var="appointment" items="${recentAppointments}">
                                            <tr>
                                                <td>
                                                    <div class="user-info">
                                                        <c:set var="patientImage" value="${appointment.patientImage != null && !appointment.patientImage.isEmpty() ? appointment.patientImage : '/assets/images/patients/default.jpg'}" />
                                                        <img src="${pageContext.request.contextPath}${patientImage}"
                                                             alt="${appointment.patientName}" class="user-avatar">
                                                        <div class="user-details">
                                                            <div class="user-name">${appointment.patientName}</div>
                                                            <div class="user-id">Patient ID: ${appointment.patientId}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>${appointment.getFormattedDate()}</td>
                                                <td>
                                                    <span class="status-badge active-badge">Active</span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/admin/view-patient?id=${appointment.patientId}" class="action-btn view-btn" title="View Patient">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/edit-patient?id=${appointment.patientId}" class="action-btn edit-btn" title="Edit Patient">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="#" onclick="confirmDeletePatient(${appointment.patientId})" class="action-btn delete-btn" title="Delete Patient">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center">No patients found</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include JavaScript files -->
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Custom JS -->
    <script>
        // Function to confirm doctor deletion
        function confirmDelete(doctorId) {
            if (confirm('Are you sure you want to delete this doctor?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/doctors/delete?id=' + doctorId;
            }
        }

        // Function to confirm patient deletion
        function confirmDeletePatient(patientId) {
            if (confirm('Are you sure you want to delete this patient?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/delete-patient?id=' + patientId;
            }
        }

        // Function to show all appointments
        function showAllAppointments() {
            window.location.href = '${pageContext.request.contextPath}/appointments';
        }

        // Function to show all sessions
        function showAllSessions() {
            // Since sessions are the same as appointments, we'll use the same endpoint
            window.location.href = '${pageContext.request.contextPath}/appointments';
        }

        // Add active class to current menu item
        document.addEventListener('DOMContentLoaded', function() {
            // Get current path
            const path = window.location.pathname;

            // Find all menu items
            const menuItems = document.querySelectorAll('.menu-item');

            // Loop through menu items and add active class to current one
            menuItems.forEach(item => {
                const link = item.querySelector('a').getAttribute('href');
                if (path.includes(link)) {
                    item.classList.add('active');
                }
            });
        });
    </script>

    <style>
        /* Additional responsive styles */
        @media (max-width: 1200px) {
            .stats-cards {
                flex-wrap: wrap;
            }

            .stat-card {
                flex: 1 1 calc(50% - 15px);
                margin-bottom: 15px;
            }

            .tables-section {
                flex-direction: column;
            }

            .table-card {
                margin-bottom: 20px;
            }
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
                overflow: visible;
                z-index: 999;
            }

            .sidebar .sidebar-header h3,
            .sidebar .profile-info,
            .sidebar .menu-link span {
                display: none;
            }

            .sidebar .menu-link i {
                margin-right: 0;
                font-size: 1.2rem;
            }

            .main-content {
                margin-left: 70px;
            }

            .appointment-table th:nth-child(3),
            .appointment-table td:nth-child(3) {
                display: none;
            }
        }

        @media (max-width: 768px) {
            body {
                display: block;
            }

            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .sidebar-menu {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
            }

            .menu-item {
                width: auto;
            }

            .main-content {
                margin-left: 0;
            }

            .stat-card {
                flex: 1 1 100%;
            }

            .appointment-card-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .appointment-card-header small {
                margin-top: 5px;
            }

            .appointment-table th:nth-child(4),
            .appointment-table td:nth-child(4) {
                display: none;
            }

            .user-email, .user-id {
                display: none;
            }
        }

        @media (max-width: 576px) {
            .appointment-table th:nth-child(2),
            .appointment-table td:nth-child(2) {
                display: none;
            }

            .action-buttons {
                flex-direction: column;
                gap: 3px;
            }
        }

        /* Active menu item */
        .menu-item.active .menu-link {
            background-color: #1abc9c;
            color: white;
        }
    </style>

    <!-- Custom JavaScript (Bootstrap Replacement) -->
    <script src="${pageContext.request.contextPath}/assets/js/admin-custom.js"></script>
</body>
</html>
