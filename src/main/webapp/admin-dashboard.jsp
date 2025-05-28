<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.DoctorDAO" %>
<%@ page import="com.doctorapp.dao.PatientDAO" %>
<%@ page import="com.doctorapp.dao.AppointmentDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | HealthCare</title>
    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/logo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Include CSS files using JSP include directive -->
    <style>
        <%@ include file="css/common.css" %>
        <%@ include file="css/adminDashboard.css" %>
    </style>
</head>
<body>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Load admin dashboard data directly
    DoctorDAO doctorDAO = new DoctorDAO();
    PatientDAO patientDAO = new PatientDAO();
    AppointmentDAO appointmentDAO = new AppointmentDAO();

    int totalDoctors = doctorDAO.getTotalDoctors();
    int totalPatients = patientDAO.getTotalPatients();
    int totalAppointments = appointmentDAO.getTotalAppointments();
    double totalRevenue = appointmentDAO.getTotalRevenue();

    // Set attributes
    request.setAttribute("totalDoctors", totalDoctors);
    request.setAttribute("totalPatients", totalPatients);
    request.setAttribute("totalAppointments", totalAppointments);
    request.setAttribute("totalRevenue", totalRevenue);
    request.setAttribute("recentAppointments", appointmentDAO.getRecentAppointments(5));
    request.setAttribute("topDoctors", doctorDAO.getTopDoctors(3));

    // Forward to the admin dashboard
    request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
%>
</body>
</html>
