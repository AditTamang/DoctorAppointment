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
    String specialty = "Dermatologist"; // This should be fetched from the database
    String university = "Harvard University"; // This should be fetched from the database
    String qualification = "MD, PHD"; // This should be fetched from the database
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Profile | HealthPro Portal</title>
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
                    <li class="active">
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
                    <a href="index.jsp" class="active">Profile</a>
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

            <!-- Profile Section -->
            <div class="profile-section">
                <div class="profile-header">
                    <div class="doctor-image">
                        <img src="${pageContext.request.contextPath}/assets/images/doctor.png" alt="Doctor">
                    </div>
                    <div class="profile-info">
                        <h2><%= doctorName %></h2>
                        <p><%= specialty %></p>
                        <p><%= university %></p>
                        <p><%= qualification %></p>
                    </div>
                    <div class="profile-actions">
                        <a href="edit-profile.jsp" class="btn btn-primary">Edit Profile</a>
                        <button class="btn btn-danger">Delete Profile</button>
                        <button class="btn btn-outline">Set Active Off</button>
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
                                    <a href="#" class="action-btn view" title="View Details"><i class="fas fa-eye"></i></a>
                                    <a href="#" class="action-btn reschedule" title="Reschedule"><i class="fas fa-calendar-alt"></i></a>
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
                                    <a href="#" class="action-btn view" title="View Details"><i class="fas fa-eye"></i></a>
                                    <a href="#" class="action-btn reschedule" title="Reschedule"><i class="fas fa-calendar-alt"></i></a>
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
                                    <a href="#" class="action-btn view" title="View Details"><i class="fas fa-eye"></i></a>
                                    <a href="#" class="action-btn approve" title="Approve"><i class="fas fa-check"></i></a>
                                    <a href="#" class="action-btn reject" title="Reject"><i class="fas fa-times"></i></a>
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
                                    <a href="#" class="action-btn view" title="View Details"><i class="fas fa-eye"></i></a>
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
                                    <a href="#" class="action-btn view" title="View Details"><i class="fas fa-eye"></i></a>
                                    <a href="#" class="action-btn reschedule" title="Reschedule"><i class="fas fa-calendar-alt"></i></a>
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
        // Tab switching functionality
        document.addEventListener('DOMContentLoaded', function() {
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

            // Profile button functionality
            const deleteProfileBtn = document.querySelector('.btn-danger');
            if (deleteProfileBtn) {
                deleteProfileBtn.addEventListener('click', function() {
                    if (confirm('Are you sure you want to delete your profile? This action cannot be undone.')) {
                        // Send delete request to server
                        console.log('Profile deletion requested');
                    }
                });
            }

            const setActiveBtn = document.querySelector('.btn-outline');
            if (setActiveBtn) {
                setActiveBtn.addEventListener('click', function() {
                    const isActive = this.textContent.includes('Off');
                    if (isActive) {
                        this.textContent = 'Set Active On';
                        // Update status on server
                    } else {
                        this.textContent = 'Set Active Off';
                        // Update status on server
                    }
                });
            }

            // Appointment action buttons functionality
            const viewButtons = document.querySelectorAll('.action-btn.view');
            viewButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const appointmentId = this.closest('tr').querySelector('td:first-child').textContent;
                    window.location.href = 'appointment-details.jsp?id=' + appointmentId;
                });
            });

            // Reschedule appointment functionality
            const rescheduleButtons = document.querySelectorAll('.action-btn.reschedule');
            rescheduleButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const appointmentId = this.closest('tr').querySelector('td:first-child').textContent;
                    const patientName = this.closest('tr').querySelector('.patient-name').textContent;

                    // Create a modal for rescheduling
                    const modal = document.createElement('div');
                    modal.className = 'modal';
                    modal.innerHTML = `
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Reschedule Appointment</h3>
                                <span class="close">&times;</span>
                            </div>
                            <div class="modal-body">
                                <p>Reschedule appointment for <strong>${patientName}</strong></p>
                                <div class="form-group">
                                    <label for="reschedule-date">New Date</label>
                                    <input type="date" id="reschedule-date">
                                </div>
                                <div class="form-group">
                                    <label for="reschedule-time">New Time</label>
                                    <input type="time" id="reschedule-time">
                                </div>
                                <div class="form-group">
                                    <label for="reschedule-reason">Reason for Rescheduling</label>
                                    <textarea id="reschedule-reason" rows="3"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-outline modal-cancel">Cancel</button>
                                <button class="btn btn-primary modal-save">Save Changes</button>
                            </div>
                        </div>
                    `;

                    document.body.appendChild(modal);

                    // Set minimum date to today
                    const today = new Date().toISOString().split('T')[0];
                    modal.querySelector('#reschedule-date').min = today;

                    // Add modal styles if not already in CSS
                    const style = document.createElement('style');
                    style.textContent = `
                        .modal {
                            display: block;
                            position: fixed;
                            z-index: 1000;
                            left: 0;
                            top: 0;
                            width: 100%;
                            height: 100%;
                            background-color: rgba(0,0,0,0.5);
                        }
                        .modal-content {
                            background-color: #fff;
                            margin: 10% auto;
                            padding: 20px;
                            border-radius: 8px;
                            width: 500px;
                            max-width: 90%;
                        }
                        .modal-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 15px;
                            padding-bottom: 10px;
                            border-bottom: 1px solid #e0e0e0;
                        }
                        .modal-footer {
                            display: flex;
                            justify-content: flex-end;
                            gap: 10px;
                            margin-top: 20px;
                            padding-top: 15px;
                            border-top: 1px solid #e0e0e0;
                        }
                        .close {
                            font-size: 24px;
                            font-weight: bold;
                            cursor: pointer;
                        }
                        .form-group {
                            margin-bottom: 15px;
                        }
                        .form-group label {
                            display: block;
                            margin-bottom: 5px;
                            font-weight: 500;
                        }
                        .form-group input, .form-group textarea {
                            width: 100%;
                            padding: 8px;
                            border: 1px solid #ddd;
                            border-radius: 4px;
                        }
                    `;
                    document.head.appendChild(style);

                    // Close modal functionality
                    const closeModal = () => {
                        document.body.removeChild(modal);
                    };

                    modal.querySelector('.close').addEventListener('click', closeModal);
                    modal.querySelector('.modal-cancel').addEventListener('click', closeModal);

                    // Save changes functionality
                    modal.querySelector('.modal-save').addEventListener('click', function() {
                        const newDate = modal.querySelector('#reschedule-date').value;
                        const newTime = modal.querySelector('#reschedule-time').value;
                        const reason = modal.querySelector('#reschedule-reason').value;

                        if (!newDate || !newTime) {
                            alert('Please select both date and time for rescheduling.');
                            return;
                        }

                        // Here you would send the data to the server
                        console.log('Rescheduling appointment', {
                            appointmentId,
                            newDate,
                            newTime,
                            reason
                        });

                        // Update the UI to reflect the change
                        const dateCell = btn.closest('tr').querySelector('.appointment-date');
                        dateCell.textContent = newDate;

                        // Close the modal
                        closeModal();

                        // Show success message
                        alert('Appointment rescheduled successfully!');
                    });
                });
            });

            // Approve appointment functionality
            const approveButtons = document.querySelectorAll('.action-btn.approve');
            approveButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const appointmentId = this.closest('tr').querySelector('td:first-child').textContent;
                    const patientName = this.closest('tr').querySelector('.patient-name').textContent;

                    if (confirm(`Are you sure you want to approve the appointment for ${patientName}?`)) {
                        // Here you would send the approval to the server
                        console.log('Approving appointment', appointmentId);

                        // Update the UI to reflect the change
                        const statusCell = btn.closest('tr').querySelector('.status-badge');
                        statusCell.className = 'status-badge active';
                        statusCell.textContent = 'Active';

                        // Replace approve/reject buttons with reschedule button
                        const actionCell = btn.closest('td');
                        actionCell.innerHTML = `
                            <a href="#" class="action-btn view" title="View Details"><i class="fas fa-eye"></i></a>
                            <a href="#" class="action-btn reschedule" title="Reschedule"><i class="fas fa-calendar-alt"></i></a>
                        `;

                        // Show success message
                        alert('Appointment approved successfully!');

                        // Add event listener to the new reschedule button
                        const newRescheduleBtn = actionCell.querySelector('.action-btn.reschedule');
                        newRescheduleBtn.addEventListener('click', function(e) {
                            e.preventDefault();
                            // Trigger click on an existing reschedule button to reuse the code
                            document.querySelector('.action-btn.reschedule').click();
                        });
                    }
                });
            });

            // Reject appointment functionality
            const rejectButtons = document.querySelectorAll('.action-btn.reject');
            rejectButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const appointmentId = this.closest('tr').querySelector('td:first-child').textContent;
                    const patientName = this.closest('tr').querySelector('.patient-name').textContent;

                    // Create a modal for rejection reason
                    const modal = document.createElement('div');
                    modal.className = 'modal';
                    modal.innerHTML = `
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Reject Appointment</h3>
                                <span class="close">&times;</span>
                            </div>
                            <div class="modal-body">
                                <p>Reject appointment for <strong>${patientName}</strong></p>
                                <div class="form-group">
                                    <label for="reject-reason">Reason for Rejection</label>
                                    <textarea id="reject-reason" rows="3" placeholder="Please provide a reason for rejecting this appointment"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-outline modal-cancel">Cancel</button>
                                <button class="btn btn-danger modal-reject">Reject Appointment</button>
                            </div>
                        </div>
                    `;

                    document.body.appendChild(modal);

                    // Close modal functionality
                    const closeModal = () => {
                        document.body.removeChild(modal);
                    };

                    modal.querySelector('.close').addEventListener('click', closeModal);
                    modal.querySelector('.modal-cancel').addEventListener('click', closeModal);

                    // Reject functionality
                    modal.querySelector('.modal-reject').addEventListener('click', function() {
                        const reason = modal.querySelector('#reject-reason').value;

                        if (!reason) {
                            alert('Please provide a reason for rejecting the appointment.');
                            return;
                        }

                        // Here you would send the data to the server
                        console.log('Rejecting appointment', {
                            appointmentId,
                            reason
                        });

                        // Update the UI to reflect the change
                        const statusCell = btn.closest('tr').querySelector('.status-badge');
                        statusCell.className = 'status-badge cancelled';
                        statusCell.textContent = 'Rejected';

                        // Update the action buttons
                        const actionCell = btn.closest('td');
                        actionCell.innerHTML = `
                            <a href="#" class="action-btn view" title="View Details"><i class="fas fa-eye"></i></a>
                        `;

                        // Close the modal
                        closeModal();

                        // Show success message
                        alert('Appointment rejected successfully!');
                    });
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
        });
    </script>
</body>
</html>