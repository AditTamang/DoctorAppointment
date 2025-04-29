<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get patient data from request attributes
    Patient patient = (Patient) request.getAttribute("patient");
    List<Appointment> upcomingAppointments = (List<Appointment>) request.getAttribute("upcomingAppointments");
    List<Appointment> pastAppointments = (List<Appointment>) request.getAttribute("pastAppointments");
    List<Appointment> cancelledAppointments = (List<Appointment>) request.getAttribute("cancelledAppointments");
    Integer totalVisits = (Integer) request.getAttribute("totalVisits");
    Integer upcomingVisitsCount = (Integer) request.getAttribute("upcomingVisitsCount");
    Integer totalDoctors = (Integer) request.getAttribute("totalDoctors");

    // Set default values if attributes are null
    if (totalVisits == null) totalVisits = 0;
    if (upcomingVisitsCount == null) upcomingVisitsCount = 0;
    if (totalDoctors == null) totalDoctors = 0;
    if (upcomingAppointments == null) upcomingAppointments = new java.util.ArrayList<>();
    if (pastAppointments == null) pastAppointments = new java.util.ArrayList<>();
    if (cancelledAppointments == null) cancelledAppointments = new java.util.ArrayList<>();

    // Get active tab
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null) {
        activeTab = "appointments"; // Default tab
    }

    // Get current date for display
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String currentDate = dateFormat.format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/newPatientDashboard.css">
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
                        <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="Patient">
                    <% } %>
                </div>
                <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
                <p class="user-email"><%= user.getEmail() %></p>
                <p class="user-phone"><%= user.getPhone() %></p>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/dashboard-old" class="active">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/appointments">
                            <i class="fas fa-calendar-check"></i>
                            <span>My Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/sessions">
                            <i class="fas fa-clock"></i>
                            <span>My Sessions</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctors">
                            <i class="fas fa-user-md"></i>
                            <span>Find Doctors</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/profile">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient/settings">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                </ul>
            </div>

            <div class="logout-btn">
                <a href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Log out</span>
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="dashboard-header">
                <a href="${pageContext.request.contextPath}/" class="back-button">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
                <div class="appointment-manager">Appointment Manager</div>
                <div class="today-date">Today's Date: <%= currentDate %></div>
            </div>

            <!-- Navigation Tabs -->
            <div class="dashboard-tabs">
                <a href="${pageContext.request.contextPath}/patient/dashboard-old?tab=appointments" class="tab-button <%= activeTab.equals("appointments") ? "active" : "" %>">
                    <i class="fas fa-calendar-check"></i> My Appointments
                </a>
                <a href="${pageContext.request.contextPath}/patient/dashboard-old?tab=sessions" class="tab-button <%= activeTab.equals("sessions") ? "active" : "" %>">
                    <i class="fas fa-clock"></i> My Sessions
                </a>
            </div>

            <!-- My Appointments Section -->
            <div class="appointment-section" style="display: <%= activeTab.equals("appointments") ? "block" : "none" %>">
                <h3>My Appointments <span class="appointment-count">(<%= upcomingAppointments.size() %>)</span></h3>

                <div class="appointment-filters">
                    <div class="date-filter">
                        <input type="date" id="appointmentDate" value="<%= currentDate %>">
                    </div>
                    <button class="filter-button" id="filterAppointments">
                        <i class="fas fa-filter"></i> Filter
                    </button>
                </div>

                <table class="appointment-table">
                    <thead>
                        <tr>
                            <th>Patient name</th>
                            <th>Appointment number</th>
                            <th>Session Title</th>
                            <th>Session Date & Time</th>
                            <th>Appointment Date</th>
                            <th>Events</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (upcomingAppointments.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="text-align: center;">No appointments found. <a href="${pageContext.request.contextPath}/doctors">Book an appointment</a> with a doctor.</td>
                            </tr>
                        <% } else { %>
                            <%
                            int appointmentCount = 1;
                            for (Appointment appointment : upcomingAppointments) {
                                // Format dates for display
                                String sessionDate = "";
                                String appointmentDate = "";
                                if (appointment.getAppointmentDate() != null) {
                                    SimpleDateFormat displayFormat = new SimpleDateFormat("yyyy-MM-dd");
                                    appointmentDate = displayFormat.format(appointment.getAppointmentDate());
                                    sessionDate = displayFormat.format(appointment.getAppointmentDate()) + " " + appointment.getAppointmentTime();
                                }
                            %>
                                <tr>
                                    <td><%= appointment.getPatientName() != null ? appointment.getPatientName() : user.getFirstName() + " " + user.getLastName() %></td>
                                    <td><span class="appointment-number"><%= appointmentCount %></span></td>
                                    <td class="session-title">2</td>
                                    <td class="session-date"><%= sessionDate %></td>
                                    <td class="appointment-date"><%= appointmentDate %></td>
                                    <td>
                                        <button class="cancel-btn" onclick="confirmCancel(<%= appointment.getId() %>)">
                                            <i class="fas fa-times"></i> Cancel
                                        </button>
                                    </td>
                                </tr>
                            <%
                                appointmentCount++;
                            } %>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- My Sessions Section -->
            <div class="session-section" style="display: <%= activeTab.equals("sessions") ? "block" : "none" %>">
                <h3>My Sessions <span class="session-count">(2)</span></h3>

                <div class="appointment-filters">
                    <div class="date-filter">
                        <input type="date" id="sessionDate" value="<%= currentDate %>">
                    </div>
                    <button class="filter-button" id="filterSessions">
                        <i class="fas fa-filter"></i> Filter
                    </button>
                </div>

                <table class="session-table">
                    <thead>
                        <tr>
                            <th>Session Title</th>
                            <th>Scheduled Date & Time</th>
                            <th>Max num that can be booked</th>
                            <th>Events</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td>2023-10-26 10:00</td>
                            <td class="max-bookings">2</td>
                            <td>
                                <div class="action-buttons">
                                    <button class="view-btn">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                    <button class="cancel-session-btn">
                                        <i class="fas fa-times"></i> Cancel Session
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td>2023-10-28 10:00</td>
                            <td class="max-bookings">4</td>
                            <td>
                                <div class="action-buttons">
                                    <button class="view-btn">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                    <button class="cancel-session-btn">
                                        <i class="fas fa-times"></i> Cancel Session
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- JavaScript for functionality -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Filter appointments by date
            document.getElementById('filterAppointments').addEventListener('click', function() {
                const date = document.getElementById('appointmentDate').value;
                window.location.href = '${pageContext.request.contextPath}/patient/dashboard-old?date=' + date;
            });

            // Filter sessions by date
            document.getElementById('filterSessions').addEventListener('click', function() {
                const date = document.getElementById('sessionDate').value;
                window.location.href = '${pageContext.request.contextPath}/patient/dashboard-old?tab=sessions&date=' + date;
            });
        });

        // Function to confirm appointment cancellation
        function confirmCancel(appointmentId) {
            if (confirm('Are you sure you want to cancel this appointment?')) {
                window.location.href = '${pageContext.request.contextPath}/appointment/cancel?id=' + appointmentId;
            }
        }
    </script>
</body>
</html>
