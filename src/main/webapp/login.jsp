<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <style>
        <%@include file="./assets/css/style.css"%>
    </style>
</head>
<body>
    <!-- Login Form Container -->
    <div class="auth-container">
        <!-- Left Side with Image -->
        <div class="auth-left">
            <div class="auth-image">
                <img src="https://img.freepik.com/free-photo/doctor-nurses-special-equipment_23-2148980721.jpg?w=2000&t=st=1682430456~exp=1682431056~hmac=2d7e1b4e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e" alt="Healthcare">
                <div class="auth-overlay">
                    <h3>Welcome to HealthCare</h3>
                    <p>Your health is our priority. Login to access our services.</p>
                </div>
            </div>
        </div>

        <!-- Right Side with Login Form -->
        <div class="auth-right">
            <a href="index.jsp" class="logo" style="display: inline-block; margin-bottom: 2rem; text-decoration: none; font-size: 1.8rem; font-weight: 700; color: var(--dark-color);">Health<span style="color: var(--primary-color);">Care</span></a>

            <h2>Welcome Back</h2>
            <p class="auth-subtitle">Please login to your account</p>

            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if(request.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= request.getAttribute("message") %>
                </div>
            <% } %>

            <% if(request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getParameter("error") %>
                </div>
            <% } %>

            <form action="login" method="post">
                <% if(request.getParameter("redirect") != null) { %>
                    <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") %>">
                <% } %>
                <div class="form-group">
                    <label for="email" class="form-label">Email Address</label>
                    <div style="position: relative;">
                        <i class="fas fa-envelope" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                        <input type="email" id="email" name="email" class="form-control" style="padding-left: 45px;" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <div style="position: relative;">
                        <i class="fas fa-lock" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                        <input type="password" id="password" name="password" class="form-control" style="padding-left: 45px;" required>
                    </div>
                </div>
                <div class="form-group" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember" style="margin-left: 5px; cursor: pointer;">Remember me</label>
                    </div>
                    <a href="#" style="color: var(--primary-color); font-size: 0.9rem;">Forgot Password?</a>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Login <i class="fas fa-sign-in-alt" style="margin-left: 5px;"></i></button>
                </div>
            </form>

            <div class="auth-links">
                <p>Don't have an account? <a href="register">Register here</a></p>
            </div>

            <div class="social-login">
                <p>or</p>
                <button class="social-btn google-btn"><i class="fab fa-google"></i> Continue with Google</button>
                <button class="social-btn facebook-btn"><i class="fab fa-facebook-f"></i> Continue with Facebook</button>
            </div>

            <div style="text-align: center; margin-top: 2rem;">
                <a href="index.jsp" style="color: var(--text-light); font-size: 0.9rem; text-decoration: none;">
                    <i class="fas fa-home" style="margin-right: 5px;"></i> Back to Home
                </a>
            </div>
        </div>
    </div>



    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
