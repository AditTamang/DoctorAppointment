<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Doctor Appointment System</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS (Bootstrap Replacement) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-custom.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: #333;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: #fff;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 100;
            transition: all 0.3s;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h3 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .profile-info {
            margin-top: 10px;
        }

        .user-name {
            font-weight: 500;
        }

        .user-role {
            font-size: 0.8rem;
            opacity: 0.7;
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
            transition: all 0.3s;
        }

        .menu-link:hover {
            background-color: #34495e;
            color: #fff;
        }

        .menu-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .menu-item.active .menu-link {
            background-color: #1abc9c;
            color: #fff;
        }

        /* Main Content */
        .main-content {
            margin-left: 250px;
            padding: 20px;
            transition: all 0.3s;
        }

        /* Dashboard Cards */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            border: none;
        }

        .card-header {
            color: #fff;
            padding: 15px;
            font-weight: 600;
        }

        .doctors-card .card-header { background-color: #4e73df; }
        .patients-card .card-header { background-color: #1cc88a; }
        .bookings-card .card-header { background-color: #36b9cc; }
        .sessions-card .card-header { background-color: #f6c23e; }

        .card-body {
            padding: 20px;
            text-align: center;
        }

        .card-value {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .card-label {
            color: #6c757d;
            font-size: 1rem;
        }

        /* Tables */
        .table-section {
            margin-bottom: 30px;
        }

        .table-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .table-header {
            padding: 15px 20px;
            background-color: #4e73df;
            color: #fff;
        }

        .table-header h5 {
            margin: 0;
            font-weight: 600;
        }

        .table-header small {
            display: block;
            margin-top: 5px;
            opacity: 0.8;
        }

        .table {
            margin-bottom: 0;
        }

        .table th, .table td {
            padding: 12px 15px;
            vertical-align: middle;
        }

        .show-all-btn {
            display: block;
            text-align: center;
            padding: 10px;
            background-color: #4e73df;
            color: #fff;
            text-decoration: none;
            font-weight: 500;
        }

        .show-all-btn:hover {
            background-color: #3a5cbe;
            color: #fff;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .dashboard-cards {
                grid-template-columns: repeat(2, 1fr);
            }

            .sidebar {
                width: 70px;
            }

            .sidebar-header h3, .profile-info, .menu-link span {
                display: none;
            }

            .menu-link i {
                margin-right: 0;
                font-size: 1.2rem;
            }

            .main-content {
                margin-left: 70px;
            }
        }

        @media (max-width: 768px) {
            .dashboard-cards {
                grid-template-columns: 1fr;
            }

            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .sidebar-menu {
                display: flex;
                flex-wrap: wrap;
            }

            .menu-item {
                flex: 1;
                min-width: 80px;
                text-align: center;
            }

            .menu-link {
                flex-direction: column;
                padding: 10px;
            }

            .menu-link i {
                margin: 0 0 5px 0;
            }

            .menu-link span {
                display: block;
                font-size: 0.8rem;
            }

            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <!-- Include the standardized sidebar -->
    <jsp:include page="admin-sidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <h1 class="h3 mb-4">Dashboard</h1>
            <p class="mb-4">Welcome to the admin dashboard!</p>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Error!</strong> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Dashboard Cards -->
            <div class="dashboard-cards">
                <div class="card doctors-card">
                    <div class="card-header">
                        <i class="fas fa-user-md"></i> Doctors
                    </div>
                    <div class="card-body">
                        <div class="card-value">${doctorCount}</div>
                        <div class="card-label">Total Doctors</div>
                    </div>
                </div>

                <div class="card patients-card">
                    <div class="card-header">
                        <i class="fas fa-users"></i> Patients
                    </div>
                    <div class="card-body">
                        <div class="card-value">${patientCount}</div>
                        <div class="card-label">Total Patients</div>
                    </div>
                </div>

                <div class="card bookings-card">
                    <div class="card-header">
                        <i class="fas fa-calendar-check"></i> New Booking
                    </div>
                    <div class="card-body">
                        <div class="card-value">${newBookingCount}</div>
                        <div class="card-label">Pending Appointments</div>
                    </div>
                </div>

                <div class="card sessions-card">
                    <div class="card-header">
                        <i class="fas fa-calendar-day"></i> Today Sessions
                    </div>
                    <div class="card-body">
                        <div class="card-value">${todaySessionCount}</div>
                        <div class="card-label">Appointments Today</div>
                    </div>
                </div>
            </div>

            <!-- Appointments Section -->
            <div class="row mt-4">
                <div class="col-md-6 table-section">
                    <div class="table-card">
                        <div class="table-header">
                            <h5>Upcoming Appointments until Next Friday</h5>
                            <small>Have Quick access to Upcoming Appointments next 7 days</small>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Appointment #</th>
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
                        <a href="${pageContext.request.contextPath}/admin/appointments" class="show-all-btn">Show all Appointments</a>
                    </div>
                </div>

                <div class="col-md-6 table-section">
                    <div class="table-card">
                        <div class="table-header">
                            <h5>Upcoming Sessions until Next Friday</h5>
                            <small>Have Quick access to upcoming Sessions that scheduled until 7 days</small>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover">
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
                        <a href="${pageContext.request.contextPath}/admin/appointments" class="show-all-btn">Show all Sessions</a>
                    </div>
                </div>
            </div>

            <!-- Doctors and Patients Section -->
            <div class="row mt-4">
                <div class="col-md-6 table-section">
                    <div class="table-card">
                        <div class="table-header" style="background-color: #36b9cc;">
                            <h5>Recent Doctors</h5>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover">
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
                                                        <div class="d-flex align-items-center">
                                                            <img src="${doctor.profileImage != null ? doctor.profileImage : '../assets/images/doctors/default-doctor.png'}"
                                                                 alt="${doctor.name}" class="rounded-circle me-2" width="40" height="40">
                                                            <div>
                                                                <div class="fw-bold">${doctor.name}</div>
                                                                <small>${doctor.email}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${doctor.specialization}</td>
                                                    <td>
                                                        <span class="badge bg-success">Active</span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/doctors/view?id=${doctor.id}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/doctors/edit?id=${doctor.id}" class="btn btn-sm btn-primary">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="#" onclick="confirmDelete(${doctor.id})" class="btn btn-sm btn-danger">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
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
                        <a href="${pageContext.request.contextPath}/admin/doctors" class="show-all-btn" style="background-color: #36b9cc;">View All Doctors</a>
                    </div>
                </div>

                <div class="col-md-6 table-section">
                    <div class="table-card">
                        <div class="table-header" style="background-color: #1cc88a;">
                            <h5>Recent Patients</h5>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover">
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
                                                        <div class="d-flex align-items-center">
                                                            <img src="../assets/images/patients/default-patient.png"
                                                                 alt="${appointment.patientName}" class="rounded-circle me-2" width="40" height="40">
                                                            <div>
                                                                <div class="fw-bold">${appointment.patientName}</div>
                                                                <small>Patient ID: ${appointment.patientId}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${appointment.getFormattedDate()}</td>
                                                    <td>
                                                        <span class="badge bg-success">Active</span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/patients/view?id=${appointment.patientId}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/patients/edit?id=${appointment.patientId}" class="btn btn-sm btn-primary">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="#" onclick="confirmDeletePatient(${appointment.patientId})" class="btn btn-sm btn-danger">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
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
                        <a href="${pageContext.request.contextPath}/admin/patients" class="show-all-btn" style="background-color: #1cc88a;">View All Patients</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

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
                window.location.href = '${pageContext.request.contextPath}/admin/patients/delete?id=' + patientId;
            }
        }
    </script>

    <!-- Custom JavaScript (Bootstrap Replacement) -->
    <script src="${pageContext.request.contextPath}/assets/js/admin-custom.js"></script>
</body>
</html>
