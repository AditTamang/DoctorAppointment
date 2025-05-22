<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sessions | MedDoc</title>
    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/logo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Main Container Styles */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        /* Content Area Styles */
        .dashboard-content {
            flex: 1;
            padding: 25px;
            margin-left: 250px;
            transition: margin-left 0.3s ease;
        }

        /* Header Styles */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .dashboard-header h1 {
            font-size: 28px;
            color: #2c3e50;
            margin: 0;
            font-weight: 600;
        }

        /* Sessions Container */
        .sessions-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 25px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        .sessions-container:hover {
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
        }

        /* Table Styles */
        .sessions-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 8px;
            overflow: hidden;
        }

        .sessions-table th,
        .sessions-table td {
            padding: 15px 20px;
            text-align: left;
        }

        .sessions-table th {
            background-color: #3CCFCF;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 0.5px;
        }

        .sessions-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .sessions-table tr:hover {
            background-color: #f1f8ff;
        }

        .sessions-table td {
            border-bottom: 1px solid #e0e0e0;
        }

        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pending {
            background-color: #FFF3CD;
            color: #856404;
        }

        .status-approved, .status-confirmed {
            background-color: #D4EDDA;
            color: #155724;
        }

        .status-completed {
            background-color: #CCE5FF;
            color: #004085;
        }

        .status-cancelled, .status-rejected {
            background-color: #F8D7DA;
            color: #721C24;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-view {
            background-color: #3CCFCF;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-view:hover {
            background-color: #2ba3a3;
        }

        .btn-cancel {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-cancel:hover {
            background-color: #c82333;
        }

        /* Empty State Styles */
        .no-sessions {
            text-align: center;
            padding: 50px 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            border: 1px dashed #ccc;
        }

        .no-sessions i {
            color: #3CCFCF;
            margin-bottom: 20px;
            font-size: 48px;
        }

        .no-sessions p {
            color: #6c757d;
            font-size: 16px;
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Alert Styles */
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-left-color: #28a745;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-left-color: #dc3545;
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .dashboard-content {
                margin-left: 0;
                padding: 20px;
            }

            .dashboard-header h1 {
                font-size: 24px;
            }
        }

        @media (max-width: 768px) {
            .sessions-table {
                display: block;
                overflow-x: auto;
            }

            .sessions-table th,
            .sessions-table td {
                padding: 12px 15px;
            }

            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        @media (max-width: 576px) {
            .dashboard-content {
                padding: 15px;
            }

            .sessions-container {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <%
        // Get current user from session
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get sessions from request attributes
        List<Appointment> sessions = (List<Appointment>) request.getAttribute("sessions");

        // Set active page for sidebar
        String activePage = "sessions";
    %>
    <div class="dashboard-container">
        <!-- Include the sidebar -->
        <jsp:include page="admin-sidebar.jsp" />

        <!-- Main Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h1>Session Management</h1>
            </div>

            <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("message") %>
            </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <div class="sessions-container">
                <% if (sessions != null && !sessions.isEmpty()) { %>
                <table class="sessions-table">
                    <thead>
                        <tr>
                            <th>Session Title</th>
                            <th>Doctor</th>
                            <th>Scheduled Date & Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Appointment session : sessions) { %>
                        <tr>
                            <td>Appointment #<%= session.getId() %></td>
                            <td><%= session.getDoctorName() != null ? session.getDoctorName() : "Unknown" %></td>
                            <td>
                                <%
                                    if (session.getAppointmentDate() != null) {
                                        // Use the built-in formatter from the Appointment class
                                        String formattedDate = session.getFormattedDate();
                                        String appointmentTime = session.getAppointmentTime();

                                        if (appointmentTime != null && !appointmentTime.isEmpty()) {
                                            out.print(formattedDate + " " + appointmentTime);
                                        } else {
                                            out.print(formattedDate);
                                        }
                                    } else {
                                        out.print("Not specified");
                                    }
                                %>
                            </td>
                            <td>
                                <%
                                    String status = session.getStatus();
                                    String statusClass = "";

                                    if ("PENDING".equalsIgnoreCase(status)) {
                                        statusClass = "status-pending";
                                    } else if ("APPROVED".equalsIgnoreCase(status) || "CONFIRMED".equalsIgnoreCase(status)) {
                                        statusClass = "status-approved";
                                    } else if ("COMPLETED".equalsIgnoreCase(status)) {
                                        statusClass = "status-completed";
                                    } else if ("CANCELLED".equalsIgnoreCase(status) || "REJECTED".equalsIgnoreCase(status)) {
                                        statusClass = "status-cancelled";
                                    }
                                %>
                                <span class="status-badge <%= statusClass %>"><%= status %></span>
                            </td>
                            <td class="action-buttons">
                                <a href="${pageContext.request.contextPath}/appointment/details?id=<%= session.getId() %>" class="btn-view">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <% if (!"CANCELLED".equalsIgnoreCase(status) && !"COMPLETED".equalsIgnoreCase(status) && !"REJECTED".equalsIgnoreCase(status)) { %>
                                <button class="btn-cancel" onclick="cancelSession(<%= session.getId() %>)">
                                    <i class="fas fa-times"></i> Cancel
                                </button>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="no-sessions">
                    <i class="fas fa-calendar-times"></i>
                    <p>No sessions found. New sessions will appear here when they are scheduled.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function cancelSession(sessionId) {
            if (confirm('Are you sure you want to cancel this session?')) {
                // Create form
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/appointment/cancel';

                // Create hidden input for appointment ID
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = sessionId;

                // Append input to form
                form.appendChild(idInput);

                // Append form to body and submit
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
