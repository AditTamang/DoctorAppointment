<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="dashboard-header">
    <div class="header-left">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <i class="fas fa-hospital"></i> MedDoc
        </a>
        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
    
    <div class="header-search">
        <form>
            <input type="text" placeholder="Search...">
            <button type="submit"><i class="fas fa-search"></i></button>
        </form>
    </div>
    
    <div class="header-actions">
        <div class="notification-bell">
            <i class="fas fa-bell"></i>
            <span class="badge">3</span>
            <div class="dropdown-menu">
                <div class="dropdown-header">
                    <h4>Notifications</h4>
                    <a href="#">Mark all as read</a>
                </div>
                <div class="dropdown-body">
                    <a href="#" class="dropdown-item unread">
                        <div class="item-icon"><i class="fas fa-calendar-check"></i></div>
                        <div class="item-content">
                            <p>Your appointment with Dr. Smith has been confirmed</p>
                            <span class="item-time">2 hours ago</span>
                        </div>
                    </a>
                    <a href="#" class="dropdown-item unread">
                        <div class="item-icon"><i class="fas fa-prescription"></i></div>
                        <div class="item-content">
                            <p>New prescription has been added to your account</p>
                            <span class="item-time">Yesterday</span>
                        </div>
                    </a>
                    <a href="#" class="dropdown-item">
                        <div class="item-icon"><i class="fas fa-file-medical"></i></div>
                        <div class="item-content">
                            <p>Your medical report is ready for download</p>
                            <span class="item-time">3 days ago</span>
                        </div>
                    </a>
                </div>
                <div class="dropdown-footer">
                    <a href="#">View all notifications</a>
                </div>
            </div>
        </div>
        
        <div class="message-icon">
            <i class="fas fa-envelope"></i>
            <span class="badge">2</span>
            <div class="dropdown-menu">
                <div class="dropdown-header">
                    <h4>Messages</h4>
                    <a href="#">Mark all as read</a>
                </div>
                <div class="dropdown-body">
                    <a href="#" class="dropdown-item unread">
                        <div class="item-avatar">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Doctor">
                        </div>
                        <div class="item-content">
                            <h5>Dr. Johnson</h5>
                            <p>Please confirm your appointment for tomorrow</p>
                            <span class="item-time">1 hour ago</span>
                        </div>
                    </a>
                    <a href="#" class="dropdown-item unread">
                        <div class="item-avatar">
                            <img src="${pageContext.request.contextPath}/assets/images/admin/admin1.png" alt="Admin">
                        </div>
                        <div class="item-content">
                            <h5>Admin</h5>
                            <p>Your account has been verified successfully</p>
                            <span class="item-time">Yesterday</span>
                        </div>
                    </a>
                </div>
                <div class="dropdown-footer">
                    <a href="#">View all messages</a>
                </div>
            </div>
        </div>
        
        <div class="user-profile">
            <c:choose>
                <c:when test="${sessionScope.user.role == 'DOCTOR'}">
                    <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Doctor">
                </c:when>
                <c:when test="${sessionScope.user.role == 'PATIENT'}">
                    <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/assets/images/admin/admin1.png" alt="Admin">
                </c:otherwise>
            </c:choose>
            <span>${sessionScope.user.username}</span>
            <i class="fas fa-chevron-down"></i>
            
            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/profile" class="dropdown-item">
                    <i class="fas fa-user"></i> My Profile
                </a>
                <a href="${pageContext.request.contextPath}/settings" class="dropdown-item">
                    <i class="fas fa-cog"></i> Settings
                </a>
                <div class="dropdown-divider"></div>
                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>
</header>

<script>
    // Toggle dropdown menus
    document.addEventListener('DOMContentLoaded', function() {
        const dropdownTriggers = document.querySelectorAll('.notification-bell, .message-icon, .user-profile');
        
        dropdownTriggers.forEach(trigger => {
            trigger.addEventListener('click', function(e) {
                e.stopPropagation();
                const dropdown = this.querySelector('.dropdown-menu');
                
                // Close all other dropdowns
                document.querySelectorAll('.dropdown-menu').forEach(menu => {
                    if (menu !== dropdown) {
                        menu.classList.remove('show');
                    }
                });
                
                // Toggle current dropdown
                dropdown.classList.toggle('show');
            });
        });
        
        // Close dropdowns when clicking outside
        document.addEventListener('click', function() {
            document.querySelectorAll('.dropdown-menu').forEach(menu => {
                menu.classList.remove('show');
            });
        });
        
        // Prevent dropdown from closing when clicking inside it
        document.querySelectorAll('.dropdown-menu').forEach(menu => {
            menu.addEventListener('click', function(e) {
                e.stopPropagation();
            });
        });
    });
</script>
