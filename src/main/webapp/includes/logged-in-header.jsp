<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Simplified header for logged-in users -->
<header class="header">
    <div class="container">
        <nav class="navbar">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Med<span>Doc</span></a>
            <ul class="nav-links">
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'ADMIN'}">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'DOCTOR'}">
                        <li><a href="${pageContext.request.contextPath}/doctor/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'PATIENT'}">
                        <li><a href="${pageContext.request.contextPath}/contact-us"><i class="fas fa-envelope"></i> Contact</a></li>
                        <li><a href="${pageContext.request.contextPath}/doctors"><i class="fas fa-user-md"></i> Find Doctors</a></li>
                        <li><a href="${pageContext.request.contextPath}/about-us.jsp"><i class="fas fa-info-circle"></i> About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/profile-redirect"><i class="fas fa-user"></i> Profile</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout" class="btn btn-primary"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/profile-redirect">Profile</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout" class="btn btn-primary">Logout</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
            <div class="mobile-menu">
                <i class="fas fa-bars"></i>
            </div>
        </nav>
    </div>
</header>
