<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.service.DoctorRegistrationService" %>
<!-- Include Admin Sidebar CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-sidebar.css">
<!-- Include Admin Sidebar Fix CSS (this should override any conflicting styles) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-sidebar-fix.css">
<%
    // Get current user from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get current page path to highlight active menu item
    String currentPath = request.getRequestURI();

    // Extract the last part of the path for active menu highlighting
    String activePage = "";
    if (currentPath.contains("/")) {
        activePage = currentPath.substring(currentPath.lastIndexOf("/") + 1);
        // Handle default page (index.jsp or empty path)
        if (activePage.isEmpty() || activePage.equals("dashboard")) {
            activePage = "dashboard";
        }
    }

    // Override activePage if it's passed as a parameter
    String activePageParam = request.getParameter("activePage");
    if (activePageParam != null && !activePageParam.isEmpty()) {
        activePage = activePageParam;
    }

    // Get the count of pending doctor requests
    DoctorRegistrationService doctorRegistrationService = new DoctorRegistrationService();
    int pendingRequestsCount = doctorRegistrationService.getPendingRequests().size();
%>

<div class="sidebar">
    <div class="sidebar-header">
        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="MedDoc" style="height: 40px; margin-right: 10px;">
        <h3>MedDoc</h3>
        <div class="profile-info">
            <c:if test="${not empty user}">
                <div class="profile-image">
                    <img src="${pageContext.request.contextPath}/assets/images/admin/adit.jpg" alt="${user.firstName} ${user.lastName}" />
                </div>
                <div class="user-name">${user.firstName} ${user.lastName}</div>
                <div class="user-role">Administrator</div>
            </c:if>
            <c:if test="${empty user}">
                <div class="profile-image">
                    <img src="${pageContext.request.contextPath}/assets/images/admin/adit.jpg" alt="Default Avatar" />
                </div>
                <div class="user-name">Admin</div>
                <div class="user-role">Administrator</div>
            </c:if>
        </div>
    </div>
    <ul class="sidebar-menu">
        <li class="menu-item <%= activePage.equals("dashboard") || activePage.isEmpty() ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="menu-item <%= activePage.equals("doctors") || activePage.equals("doctorDashboard") || activePage.contains("doctor") && !activePage.contains("doctor-requests") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/admin/doctors" class="menu-link">
                <i class="fas fa-user-md"></i>
                <span>Doctors</span>
            </a>
        </li>
        <li class="menu-item <%= activePage.equals("doctor-requests") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/admin/doctor-requests" class="menu-link">
                <i class="fas fa-user-plus"></i>
                <span>Doctor Requests</span>
                <% if (pendingRequestsCount > 0) { %>
                    <span class="badge badge-primary"><%= pendingRequestsCount %></span>
                <% } %>
            </a>
        </li>
        <li class="menu-item <%= activePage.equals("patients") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/admin/patients" class="menu-link">
                <i class="fas fa-users"></i>
                <span>Patients</span>
            </a>
        </li>
        <li class="menu-item <%= activePage.equals("appointments") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/appointments" class="menu-link">
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

<!-- Add sidebar toggle script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Create a toggle button for mobile view
        const createToggleButton = function() {
            if (!document.querySelector('.menu-toggle')) {
                const toggleBtn = document.createElement('button');
                toggleBtn.className = 'menu-toggle';
                toggleBtn.innerHTML = '<i class="fas fa-bars"></i>';
                toggleBtn.style.position = 'fixed';
                toggleBtn.style.top = '10px';
                toggleBtn.style.right = '10px';
                toggleBtn.style.zIndex = '1001';
                toggleBtn.style.display = 'none';
                toggleBtn.style.padding = '10px';
                toggleBtn.style.backgroundColor = '#fff';
                toggleBtn.style.border = 'none';
                toggleBtn.style.borderRadius = '5px';
                toggleBtn.style.boxShadow = '0 2px 5px rgba(0,0,0,0.1)';
                toggleBtn.style.cursor = 'pointer';

                // Add event listener to toggle sidebar
                toggleBtn.addEventListener('click', function() {
                    document.querySelector('.sidebar').classList.toggle('active');
                });

                // Append to body
                document.body.appendChild(toggleBtn);

                // Show toggle button on mobile
                const mediaQuery = window.matchMedia('(max-width: 768px)');
                const handleMediaChange = function(e) {
                    toggleBtn.style.display = e.matches ? 'block' : 'none';
                };
                mediaQuery.addListener(handleMediaChange);
                handleMediaChange(mediaQuery);
            }
        };

        // Call the function to create toggle button
        createToggleButton();
    });
</script>
