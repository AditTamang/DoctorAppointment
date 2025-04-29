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
 %>
 <!DOCTYPE html>
 <html lang="en">
 <head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>Doctor Dashboard | Doctor Appointment System</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
     <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctorDashboard.css">
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
                         <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                     <% } %>
                 </div>
                 <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
                 <p class="user-email"><%= user.getEmail() %></p>
                 <p class="user-phone"><%= user.getPhone() %></p>
             </div>
             
 
             <div class="sidebar-menu">
                 <ul>
                     <li class="active">
                         <a href="index.jsp">
                             <i class="fas fa-tachometer-alt"></i>
                             <span>Dashboard</span>
                         </a>
                     </li>
                     <li>
                         <a href="appointments.jsp">
                             <i class="fas fa-calendar-check"></i>
                             <span>Appointments</span>
                         </a>
                     </li>
                     <li>
                         <a href="patients.jsp">
                             <i class="fas fa-users"></i>
                             <span>My Patients</span>
                         </a>
                     </li>
                     <li>
                         <a href="schedule.jsp">
                             <i class="fas fa-clock"></i>
                             <span>Schedule</span>
                         </a>
                     </li>
                     <li>
                         <a href="prescriptions.jsp">
                             <i class="fas fa-prescription"></i>
                             <span>Prescriptions</span>
                         </a>
                     </li>
                     <li>
                         <a href="messages.jsp">
                             <i class="fas fa-comment-medical"></i>
                             <span>Messages</span>
                             <span class="badge">5</span>
                         </a>
                     </li>
                     <li>
                         <a href="profile.jsp">
                             <i class="fas fa-user-md"></i>
                             <span>My Profile</span>
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
         <div class="dashboard-main">
             <!-- Top Navigation -->
             <div class="dashboard-nav">
                 <div class="menu-toggle" id="menuToggle">
                     <i class="fas fa-bars"></i>
                 </div>
                 
 
                 <div class="nav-right">
                     <div class="logout-nav">
                         <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                             <i class="fas fa-sign-out-alt"></i> Logout
                         </a>
                     </div>
                 </div>
             </div>
             
 
             <!-- Dashboard Content -->
             <div class="dashboard-content">
                 <div class="page-header">
                     <h1>Doctor Dashboard</h1>
                     <p>Welcome back, Dr. John Smith</p>
                 </div>
                 
 
                 <!-- Today's Summary -->
                 <div class="today-summary">
                     <div class="summary-header">
                         <h3>Today's Summary</h3>
                         <p class="date">Monday, April 18, 2023</p>
                     </div>
                     
 
                     <div class="stats-container">
                         <div class="stat-card">
                             <div class="stat-card-icon blue">
                                 <i class="fas fa-calendar-check"></i>
                             </div>
                             <div class="stat-card-info">
                                 <h3>Today's Appointments</h3>
                                 <h2>8</h2>
                                 <p><span class="positive"><i class="fas fa-arrow-up"></i> 2</span> from yesterday</p>
                             </div>
                         </div>
                         
 
                         <div class="stat-card">
                             <div class="stat-card-icon green">
                                 <i class="fas fa-user-check"></i>
                             </div>
                             <div class="stat-card-info">
                                 <h3>Patients Attended</h3>
                                 <h2>5</h2>
                                 <p>3 more to go</p>
                             </div>
                         </div>
                         
 
                         <div class="stat-card">
                             <div class="stat-card-icon purple">
                                 <i class="fas fa-file-medical"></i>
                             </div>
                             <div class="stat-card-info">
                                 <h3>Prescriptions</h3>
                                 <h2>12</h2>
                                 <p><span class="positive"><i class="fas fa-arrow-up"></i> 4</span> from yesterday</p>
                             </div>
                         </div>
                         
 
                         <div class="stat-card">
                             <div class="stat-card-icon orange">
                                 <i class="fas fa-clock"></i>
                             </div>
                             <div class="stat-card-info">
                                 <h3>Working Hours</h3>
                                 <h2>6.5</h2>
                                 <p>of 8 hours</p>
                             </div>
                         </div>
                     </div>
                 </div>
                 
 
                 <!-- Upcoming Appointments -->
                 <div class="upcoming-appointments">
                     <div class="section-header">
                         <h3>Upcoming Appointments</h3>
                         <a href="appointments.jsp" class="view-all">View All</a>
                     </div>
                     
 
                     <div class="appointment-timeline">
                         <div class="timeline-item current">
                             <div class="timeline-time">
                                 <h4>10:30 AM</h4>
                                 <p>Current</p>
                             </div>
                             <div class="timeline-content">
                                 <div class="appointment-card">
                                     <div class="appointment-info">
                                         <div class="patient-info">
                                             <img src="../images/patients/patient1.jpg" alt="Patient">
                                             <div>
                                                 <h4>Robert Wilson</h4>
                                                 <p>42 years, Male</p>
                                                 <span class="appointment-type new">New Patient</span>
                                             </div>
                                         </div>
                                         <div class="appointment-details">
                                             <div class="detail-item">
                                                 <i class="fas fa-heartbeat"></i>
                                                 <span>Heart Checkup</span>
                                             </div>
                                             <div class="detail-item">
                                                 <i class="fas fa-phone"></i>
                                                 <span>+1 234 567 890</span>
                                             </div>
                                         </div>
                                     </div>
                                     <div class="appointment-actions">
                                         <button class="btn btn-primary"><i class="fas fa-check-circle"></i> Start Session</button>
                                         <button class="btn btn-outline"><i class="fas fa-times-circle"></i> Cancel</button>
                                     </div>
                                 </div>
                             </div>
                         </div>
                         
 
                         <div class="timeline-item">
                             <div class="timeline-time">
                                 <h4>11:15 AM</h4>
                                 <p>In 45 min</p>
                             </div>
                             <div class="timeline-content">
                                 <div class="appointment-card">
                                     <div class="appointment-info">
                                         <div class="patient-info">
                                             <img src="../images/patients/patient2.jpg" alt="Patient">
                                             <div>
                                                 <h4>Emily Parker</h4>
                                                 <p>35 years, Female</p>
                                                 <span class="appointment-type followup">Follow-up</span>
                                             </div>
                                         </div>
                                         <div class="appointment-details">
                                             <div class="detail-item">
                                                 <i class="fas fa-heartbeat"></i>
                                                 <span>Blood Pressure Check</span>
                                             </div>
                                             <div class="detail-item">
                                                 <i class="fas fa-phone"></i>
                                                 <span>+1 987 654 321</span>
                                             </div>
                                         </div>
                                     </div>
                                     <div class="appointment-actions">
                                         <button class="btn btn-outline"><i class="fas fa-file-medical"></i> View Records</button>
                                         <button class="btn btn-outline"><i class="fas fa-times-circle"></i> Cancel</button>
                                     </div>
                                 </div>
                             </div>
                         </div>
                         
 
                         <div class="timeline-item">
                             <div class="timeline-time">
                                 <h4>1:30 PM</h4>
                                 <p>In 3 hours</p>
                             </div>
                             <div class="timeline-content">
                                 <div class="appointment-card">
                                     <div class="appointment-info">
                                         <div class="patient-info">
                                             <img src="../images/patients/patient3.jpg" alt="Patient">
                                             <div>
                                                 <h4>David Thompson</h4>
                                                 <p>58 years, Male</p>
                                                 <span class="appointment-type emergency">Emergency</span>
                                             </div>
                                         </div>
                                         <div class="appointment-details">
                                             <div class="detail-item">
                                                 <i class="fas fa-heartbeat"></i>
                                                 <span>Chest Pain</span>
                                             </div>
                                             <div class="detail-item">
                                                 <i class="fas fa-phone"></i>
                                                 <span>+1 456 789 012</span>
                                             </div>
                                         </div>
                                     </div>
                                     <div class="appointment-actions">
                                         <button class="btn btn-outline"><i class="fas fa-file-medical"></i> View Records</button>
                                         <button class="btn btn-outline"><i class="fas fa-times-circle"></i> Cancel</button>
                                     </div>
                                 </div>
                             </div>
                         </div>
                     </div>
                 </div>
                 
 
                 <!-- Charts and Patient Stats -->
                 <div class="charts-container">
                     <div class="chart-card">
                         <div class="chart-header">
                             <h3>Appointment Statistics</h3>
                             <div class="chart-actions">
                                 <select>
                                     <option>This Week</option>
                                     <option>This Month</option>
                                     <option>This Year</option>
                                 </select>
                             </div>
                         </div>
                         <div class="chart-body">
                             <canvas id="appointmentChart"></canvas>
                         </div>
                     </div>
                     
 
                     <div class="chart-card">
                         <div class="chart-header">
                             <h3>Patient Demographics</h3>
                             <div class="chart-actions">
                                 <select>
                                     <option>Age</option>
                                     <option>Gender</option>
                                     <option>Condition</option>
                                 </select>
                             </div>
                         </div>
                         <div class="chart-body">
                             <canvas id="demographicsChart"></canvas>
                         </div>
                     </div>
                 </div>
                 
 
                 <!-- Recent Patients -->
                 <div class="recent-patients">
                     <div class="section-header">
                         <h3>Recent Patients</h3>
                         <a href="patients.jsp" class="view-all">View All</a>
                     </div>
                     
 
                     <div class="table-responsive">
                         <table>
                             <thead>
                                 <tr>
                                     <th>Patient</th>
                                     <th>Last Visit</th>
                                     <th>Diagnosis</th>
                                     <th>Status</th>
                                     <th>Action</th>
                                 </tr>
                             </thead>
                             <tbody>
                                 <tr>
                                     <td>
                                         <div class="user-info">
                                             <img src="../images/patients/patient1.jpg" alt="Patient">
                                             <div>
                                                 <h4>Robert Wilson</h4>
                                                 <p>42 years, Male</p>
                                             </div>
                                         </div>
                                     </td>
                                     <td>Today, 10:30 AM</td>
                                     <td>Hypertension</td>
                                     <td><span class="status-badge active">Active</span></td>
                                     <td>
                                         <div class="action-buttons">
                                             <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                             <a href="#" class="btn-icon edit"><i class="fas fa-file-medical"></i></a>
                                             <a href="#" class="btn-icon message"><i class="fas fa-comment-medical"></i></a>
                                         </div>
                                     </td>
                                 </tr>
                                 <tr>
                                     <td>
                                         <div class="user-info">
                                             <img src="../images/patients/patient2.jpg" alt="Patient">
                                             <div>
                                                 <h4>Emily Parker</h4>
                                                 <p>35 years, Female</p>
                                             </div>
                                         </div>
                                     </td>
                                     <td>Yesterday, 2:15 PM</td>
                                     <td>Arrhythmia</td>
                                     <td><span class="status-badge active">Active</span></td>
                                     <td>
                                         <div class="action-buttons">
                                             <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                             <a href="#" class="btn-icon edit"><i class="fas fa-file-medical"></i></a>
                                             <a href="#" class="btn-icon message"><i class="fas fa-comment-medical"></i></a>
                                         </div>
                                     </td>
                                 </tr>
                                 <tr>
                                     <td>
                                         <div class="user-info">
                                             <img src="../images/patients/patient3.jpg" alt="Patient">
                                             <div>
                                                 <h4>David Thompson</h4>
                                                 <p>58 years, Male</p>
                                             </div>
                                         </div>
                                     </td>
                                     <td>Apr 15, 2023</td>
                                     <td>Coronary Artery Disease</td>
                                     <td><span class="status-badge pending">Pending</span></td>
                                     <td>
                                         <div class="action-buttons">
                                             <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                             <a href="#" class="btn-icon edit"><i class="fas fa-file-medical"></i></a>
                                             <a href="#" class="btn-icon message"><i class="fas fa-comment-medical"></i></a>
                                         </div>
                                     </td>
                                 </tr>
                                 <tr>
                                     <td>
                                         <div class="user-info">
                                             <img src="../images/patients/patient4.jpg" alt="Patient">
                                             <div>
                                                 <h4>Jennifer Adams</h4>
                                                 <p>29 years, Female</p>
                                             </div>
                                         </div>
                                     </td>
                                     <td>Apr 12, 2023</td>
                                     <td>Mitral Valve Prolapse</td>
                                     <td><span class="status-badge completed">Completed</span></td>
                                     <td>
                                         <div class="action-buttons">
                                             <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                             <a href="#" class="btn-icon edit"><i class="fas fa-file-medical"></i></a>
                                             <a href="#" class="btn-icon message"><i class="fas fa-comment-medical"></i></a>
                                         </div>
                                     </td>
                                 </tr>
                             </tbody>
                         </table>
                     </div>
                 </div>
             </div>
             
 
             <!-- Footer -->
             <div class="dashboard-footer">
                 <p>&copy; 2023 HealthCare. All Rights Reserved.</p>
                 <p>Version 1.0.0</p>
             </div>
         </div>
     </div>
     
 
     <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
     <script>
         // Toggle sidebar on mobile
         document.getElementById('menuToggle').addEventListener('click', function() {
             document.querySelector('.dashboard-sidebar').classList.toggle('active');
         });
         
 
         document.getElementById('sidebarClose').addEventListener('click', function() {
             document.querySelector('.dashboard-sidebar').classList.remove('active');
         });
         
 
         // Charts
         const appointmentCtx = document.getElementById('appointmentChart').getContext('2d');
         const appointmentChart = new Chart(appointmentCtx, {
             type: 'line',
             data: {
                 labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                 datasets: [{
                     label: 'Appointments',
                     data: [8, 10, 6, 12, 8, 5, 8],
                     backgroundColor: 'rgba(78, 84, 200, 0.1)',
                     borderColor: '#4e54c8',
                     borderWidth: 2,
                     tension: 0.4,
                     fill: true
                 }]
             },
             options: {
                 responsive: true,
                 maintainAspectRatio: false,
                 plugins: {
                     legend: {
                         display: false
                     }
                 },
                 scales: {
                     y: {
                         beginAtZero: true,
                         grid: {
                             display: true,
                             color: 'rgba(0, 0, 0, 0.05)'
                         }
                     },
                     x: {
                         grid: {
                             display: false
                         }
                     }
                 }
             }
         });
         
 
         const demographicsCtx = document.getElementById('demographicsChart').getContext('2d');
         const demographicsChart = new Chart(demographicsCtx, {
             type: 'doughnut',
             data: {
                 labels: ['0-18', '19-35', '36-50', '51-65', '65+'],
                 datasets: [{
                     data: [15, 30, 25, 20, 10],
                     backgroundColor: [
                         '#4e54c8',
                         '#00d2ff',
                         '#ff6b6b',
                         '#2ecc71',
                         '#f39c12'
                     ],
                     borderWidth: 0
                 }]
             },
             options: {
                 responsive: true,
                 maintainAspectRatio: false,
                 plugins: {
                     legend: {
                         position: 'right'
                     }
                 },
                 cutout: '70%'
             }
         });
     </script>
 </body>
 </html>