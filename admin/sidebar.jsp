<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
