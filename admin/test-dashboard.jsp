<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h1>Admin Dashboard Test</h1>
        <p>This is a simple test page to verify that the admin dashboard is working correctly.</p>
        
        <div class="card mt-4">
            <div class="card-header">
                <h5>Test User Information</h5>
            </div>
            <div class="card-body">
                <p>The following user will be used to test the admin dashboard:</p>
                <ul>
                    <li><strong>Username:</strong> admin</li>
                    <li><strong>Role:</strong> ADMIN</li>
                </ul>
                
                <form action="${pageContext.request.contextPath}/admin/dashboard" method="get">
                    <button type="submit" class="btn btn-primary">Go to Admin Dashboard</button>
                </form>
            </div>
        </div>
        
        <div class="card mt-4">
            <div class="card-header">
                <h5>Session Information</h5>
            </div>
            <div class="card-body">
                <p>Creating a test user session for admin access:</p>
                <%
                    // Create a test user for admin access
                    com.doctorapp.model.User adminUser = new com.doctorapp.model.User();
                    adminUser.setId(1);
                    adminUser.setUsername("admin");
                    adminUser.setFirstName("Admin");
                    adminUser.setLastName("User");
                    adminUser.setRole("ADMIN");
                    
                    // Set the user in the session
                    session.setAttribute("user", adminUser);
                %>
                <div class="alert alert-success">
                    Test user created and added to session. You can now access the admin dashboard.
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
