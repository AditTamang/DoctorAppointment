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
    String doctorName = "Dr. " + user.getFirstName() + " " + user.getLastName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile-dashboard.css">
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
                    <li class="active">
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
                    <li>
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
                    <a href="appointments.jsp" class="active">Appointment Management</a>
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
            
            <!-- Appointment Management Section -->
            <div class="appointment-section">
                <div class="appointment-header">
                    <h2>Appointment Management</h2>
                </div>
                
                <div class="appointment-tabs">
                    <div class="appointment-tab active" data-tab="upcoming">Upcoming</div>
                    <div class="appointment-tab" data-tab="past">Past</div>
                    <div class="appointment-tab" data-tab="pending">Pending</div>
                </div>
                
                <div class="appointment-filter">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search">
                    </div>
                    <button class="filter-btn">
                        <i class="fas fa-filter"></i> Filter
                    </button>
                </div>
                
                <div class="appointment-content">
                    <table class="appointment-table">
                        <thead>
                            <tr>
                                <th>Appointment ID</th>
                                <th>Patient Name</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Assigned Doctor</th>
                                <th>Action</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>001</td>
                                <td class="patient-name">John Doe</td>
                                <td class="appointment-date">2023-10-10</td>
                                <td><span class="status-badge active">Active</span></td>
                                <td>
                                    <div class="assigned-doctor">
                                        <div class="doctor-avatar">
                                            <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                                        </div>
                                        <div class="assigned-doctor-info">
                                            <span class="assigned-doctor-name"><%= doctorName %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <a href="appointment-details.jsp?id=001" class="action-btn view"><i class="fas fa-eye"></i></a>
                                    <a href="edit-appointment.jsp?id=001" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                    <a href="#" class="action-btn delete" data-id="001"><i class="fas fa-trash"></i></a>
                                </td>
                                <td>
                                    <span class="notes-badge">Follow-up required</span>
                                </td>
                            </tr>
                            <tr>
                                <td>002</td>
                                <td class="patient-name">Jane Smith</td>
                                <td class="appointment-date">2023-10-11</td>
                                <td><span class="status-badge active">Active</span></td>
                                <td>
                                    <div class="assigned-doctor">
                                        <div class="doctor-avatar">
                                            <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                                        </div>
                                        <div class="assigned-doctor-info">
                                            <span class="assigned-doctor-name"><%= doctorName %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <a href="appointment-details.jsp?id=002" class="action-btn view"><i class="fas fa-eye"></i></a>
                                    <a href="edit-appointment.jsp?id=002" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                    <a href="#" class="action-btn delete" data-id="002"><i class="fas fa-trash"></i></a>
                                </td>
                                <td>
                                    <span class="notes-badge">First consultation</span>
                                </td>
                            </tr>
                            <tr>
                                <td>003</td>
                                <td class="patient-name">Emily Brown</td>
                                <td class="appointment-date">2023-10-12</td>
                                <td><span class="status-badge pending">Pending</span></td>
                                <td>
                                    <div class="assigned-doctor">
                                        <div class="doctor-avatar">
                                            <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                                        </div>
                                        <div class="assigned-doctor-info">
                                            <span class="assigned-doctor-name"><%= doctorName %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <a href="appointment-details.jsp?id=003" class="action-btn view"><i class="fas fa-eye"></i></a>
                                    <a href="edit-appointment.jsp?id=003" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                    <a href="#" class="action-btn delete" data-id="003"><i class="fas fa-trash"></i></a>
                                </td>
                                <td>
                                    <span class="notes-badge">No-show</span>
                                </td>
                            </tr>
                            <tr>
                                <td>004</td>
                                <td class="patient-name">David Wilson</td>
                                <td class="appointment-date">2023-10-13</td>
                                <td><span class="status-badge completed">Completed</span></td>
                                <td>
                                    <div class="assigned-doctor">
                                        <div class="doctor-avatar">
                                            <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                                        </div>
                                        <div class="assigned-doctor-info">
                                            <span class="assigned-doctor-name"><%= doctorName %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <a href="appointment-details.jsp?id=004" class="action-btn view"><i class="fas fa-eye"></i></a>
                                    <a href="edit-appointment.jsp?id=004" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                    <a href="#" class="action-btn delete" data-id="004"><i class="fas fa-trash"></i></a>
                                </td>
                                <td>
                                    <span class="notes-badge">Routine check-up</span>
                                </td>
                            </tr>
                            <tr>
                                <td>005</td>
                                <td class="patient-name">Sarah White</td>
                                <td class="appointment-date">2023-10-14</td>
                                <td><span class="status-badge active">Active</span></td>
                                <td>
                                    <div class="assigned-doctor">
                                        <div class="doctor-avatar">
                                            <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                                        </div>
                                        <div class="assigned-doctor-info">
                                            <span class="assigned-doctor-name"><%= doctorName %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <a href="appointment-details.jsp?id=005" class="action-btn view"><i class="fas fa-eye"></i></a>
                                    <a href="edit-appointment.jsp?id=005" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                    <a href="#" class="action-btn delete" data-id="005"><i class="fas fa-trash"></i></a>
                                </td>
                                <td>
                                    <span class="notes-badge">Follow-up in 2 weeks</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching functionality
            const tabs = document.querySelectorAll('.appointment-tab');
            
            tabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    // Remove active class from all tabs
                    tabs.forEach(t => t.classList.remove('active'));
                    
                    // Add active class to clicked tab
                    this.classList.add('active');
                    
                    // Here you would typically show/hide content based on the selected tab
                    // For now, we're just showing the same content for all tabs
                    const tabName = this.getAttribute('data-tab');
                    console.log('Switched to tab:', tabName);
                    
                    // In a real implementation, you would fetch data for the selected tab
                    // and update the table content
                });
            });
            
            // Search functionality
            const searchInput = document.querySelector('.search-box input');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase();
                    const rows = document.querySelectorAll('.appointment-table tbody tr');
                    
                    rows.forEach(row => {
                        const patientName = row.querySelector('.patient-name').textContent.toLowerCase();
                        const appointmentId = row.querySelector('td:first-child').textContent.toLowerCase();
                        
                        if (patientName.includes(searchTerm) || appointmentId.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }
            
            // Delete appointment functionality
            const deleteButtons = document.querySelectorAll('.action-btn.delete');
            deleteButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const appointmentId = this.getAttribute('data-id');
                    
                    if (confirm('Are you sure you want to delete this appointment?')) {
                        // In a real application, you would send a request to the server
                        alert('Appointment deleted successfully!');
                        // Remove the row from the table
                        this.closest('tr').remove();
                    }
                });
            });
        });
    </script>
</body>
</html>
