<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Doctor Appointment System</title>
    <!-- Include CSS files -->
    <!-- Bootstrap CSS -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<!-- Custom CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            border-radius: 10px 10px 0 0;
            font-weight: bold;
        }
        .status-card {
            text-align: center;
            padding: 20px;
        }
        .status-card h3 {
            font-size: 2.5rem;
            margin: 10px 0;
            color: #333;
        }
        .status-card p {
            font-size: 1.2rem;
            color: #666;
        }
        .doctors-icon { background-color: #4e73df; }
        .patients-icon { background-color: #1cc88a; }
        .bookings-icon { background-color: #36b9cc; }
        .sessions-icon { background-color: #f6c23e; }

        .table th, .table td {
            vertical-align: middle;
        }
        .action-buttons .btn {
            margin-right: 5px;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-active {
            background-color: #1cc88a;
            color: white;
        }
        .status-inactive {
            background-color: #e74a3b;
            color: white;
        }
        .status-pending {
            background-color: #f6c23e;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Include admin sidebar -->
    <div class="sidebar">
    <div class="sidebar-header">
        <h3>Doctor App</h3>
        <div class="profile-info">
            <c:if test="${not empty user}">
                <div class="user-name">${user.firstName} ${user.lastName}</div>
                <div class="user-role">Administrator</div>
            </c:if>
        </div>
    </div>
    <ul class="sidebar-menu">
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/admin/doctors" class="menu-link">
                <i class="fas fa-user-md"></i>
                <span>Doctors</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/admin/doctor-requests" class="menu-link">
                <i class="fas fa-user-plus"></i>
                <span>Doctor Requests</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/admin/patients" class="menu-link">
                <i class="fas fa-users"></i>
                <span>Patients</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/admin/appointments" class="menu-link">
                <i class="fas fa-calendar-check"></i>
                <span>Appointments</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/logout" class="menu-link">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </li>
    </ul>
</div>

<style>
    .sidebar {
        width: 250px;
        height: 100vh;
        background-color: #343a40;
        color: #fff;
        position: fixed;
        top: 0;
        left: 0;
        overflow-y: auto;
    }

    .sidebar-header {
        padding: 20px;
        border-bottom: 1px solid #4b545c;
    }

    .sidebar-header h3 {
        margin: 0;
        font-size: 1.5rem;
        color: #fff;
    }

    .profile-info {
        margin-top: 15px;
    }

    .user-name {
        font-weight: bold;
        font-size: 1rem;
    }

    .user-role {
        font-size: 0.8rem;
        color: #adb5bd;
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
        color: #fff;
        text-decoration: none;
        transition: background-color 0.3s;
    }

    .menu-link:hover {
        background-color: #4b545c;
        color: #fff;
        text-decoration: none;
    }

    .menu-link i {
        margin-right: 10px;
        width: 20px;
        text-align: center;
    }

    .main-content {
        margin-left: 250px;
        padding: 20px;
    }
</style>

    <div class="main-content">
        <div class="container-fluid p-4">
            <h1 class="h3 mb-4 text-gray-800">Dashboard</h1>
            <p class="mb-4">Welcome to the admin dashboard!</p>

            <!-- Display error message if any -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Error!</strong> ${error}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </c:if>

            <div class="row">
                <div class="col-xl-3 col-md-6">
                    <div class="card">
                        <div class="card-header doctors-icon text-white">
                            <i class="fas fa-user-md"></i> Doctors
                        </div>
                        <div class="status-card">
                            <h3>${doctorCount}</h3>
                            <p>Total Doctors</p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="card">
                        <div class="card-header patients-icon text-white">
                            <i class="fas fa-users"></i> Patients
                        </div>
                        <div class="status-card">
                            <h3>${patientCount}</h3>
                            <p>Total Patients</p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="card">
                        <div class="card-header bookings-icon text-white">
                            <i class="fas fa-calendar-check"></i> New Booking
                        </div>
                        <div class="status-card">
                            <h3>${newBookingCount}</h3>
                            <p>Pending Appointments</p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="card">
                        <div class="card-header sessions-icon text-white">
                            <i class="fas fa-calendar-day"></i> Today Sessions
                        </div>
                        <div class="status-card">
                            <h3>${todaySessionCount}</h3>
                            <p>Appointments Today</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h6 class="m-0 font-weight-bold">Upcoming Appointments until Next Friday</h6>
                            <small>Have Quick access to Upcoming Appointments next 7 days</small>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered">
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
                                                        <td>${appointment.formattedDate} ${appointment.appointmentTime}</td>
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
                            <div class="text-center mt-3">
                                <a href="appointments.jsp" class="btn btn-primary">Show all Appointments</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h6 class="m-0 font-weight-bold">Upcoming Sessions until Next Friday</h6>
                            <small>Have Quick access to upcoming Sessions that scheduled until 7 days</small>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered">
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
                                                        <td>${session.formattedDate} ${session.appointmentTime}</td>
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
                            <div class="text-center mt-3">
                                <a href="sessions.jsp" class="btn btn-primary">Show all Sessions</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Recent Doctors</h6>
                            <a href="doctors.jsp" class="text-white">View All</a>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
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
                                                                     alt="${doctor.name}" class="rounded-circle mr-2" width="40" height="40">
                                                                <div>
                                                                    <div class="font-weight-bold">${doctor.name}</div>
                                                                    <small>${doctor.email}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>${doctor.specialization}</td>
                                                        <td>
                                                            <span class="status-badge status-active">Active</span>
                                                        </td>
                                                        <td class="action-buttons">
                                                            <a href="viewDoctor.jsp?id=${doctor.id}" class="btn btn-sm btn-info">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="editDoctor.jsp?id=${doctor.id}" class="btn btn-sm btn-primary">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="#" class="btn btn-sm btn-danger">
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
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Recent Patients</h6>
                            <a href="patients.jsp" class="text-white">View All</a>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
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
                                                                     alt="${appointment.patientName}" class="rounded-circle mr-2" width="40" height="40">
                                                                <div>
                                                                    <div class="font-weight-bold">${appointment.patientName}</div>
                                                                    <small>Patient ID: ${appointment.patientId}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>${appointment.formattedDate}</td>
                                                        <td>
                                                            <span class="status-badge status-active">Active</span>
                                                        </td>
                                                        <td class="action-buttons">
                                                            <a href="viewPatient.jsp?id=${appointment.patientId}" class="btn btn-sm btn-info">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="editPatient.jsp?id=${appointment.patientId}" class="btn btn-sm btn-primary">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="#" class="btn btn-sm btn-danger">
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
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include JavaScript files -->
    <!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
