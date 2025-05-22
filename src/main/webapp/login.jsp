<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - HealthCare</title>
    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/logo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        <%@include file="./assets/css/style.css"%>

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .login-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            padding: 2rem;
        }

        .logo {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: #2c3e50;
        }

        .logo span {
            color: #3498db;
        }

        h2 {
            font-size: 1.8rem;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: #7f8c8d;
            margin-bottom: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #2c3e50;
        }

        .form-control {
            width: 100%;
            padding: 0.8rem 1rem;
            font-size: 1rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f0f7ff;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #3498db;
        }

        .input-group {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
            cursor: pointer;
            display: flex;
            align-items: center;
        }

        .password-toggle i {
            font-size: 1.2rem;
            color: #7f8c8d;
        }

        .form-control.with-icon {
            padding-left: 40px;
            padding-right: 40px;
        }

        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
        }

        .remember-me input {
            margin-right: 0.5rem;
        }

        .forgot-link {
            color: #3498db;
            text-decoration: none;
        }

        .btn-login {
            display: block;
            width: 100%;
            padding: 0.8rem;
            background: linear-gradient(to right, #3498db, #2ecc71);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: opacity 0.3s;
        }

        .btn-login:hover {
            opacity: 0.9;
        }

        .register-link {
            text-align: center;
            margin-top: 1.5rem;
        }

        .register-link a {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 1.5rem 0;
        }

        .divider::before, .divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px solid #ddd;
        }

        .divider span {
            padding: 0 10px;
            color: #7f8c8d;
        }

        .google-btn {
            display: block;
            width: 100%;
            padding: 0.8rem;
            background-color: white;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .google-btn i {
            margin-right: 10px;
            color: #DB4437;
        }

        .alert {
            padding: 0.8rem;
            border-radius: 5px;
            margin-bottom: 1.5rem;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="HealthCare Logo" style="height: 40px; margin-right: 10px;">
            Health<span>Care</span>
        </div>

        <h2>Welcome Back</h2>
        <p class="subtitle">Please login to your account</p>

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
                <div class="input-group">
                    <i class="fas fa-envelope input-icon"></i>
                    <input type="email" id="email" name="email" class="form-control with-icon" placeholder="admin@gmail.com" required>
                </div>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <div class="input-group">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" class="form-control with-icon" placeholder="••••••" required>
                    <span class="password-toggle" onclick="togglePasswordVisibility('password')">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-off"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye" style="display: none;"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                    </span>
                </div>
            </div>

            <div class="remember-forgot">
                <div class="remember-me">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe">Remember me</label>
                </div>
                <a href="#" class="forgot-link">Forgot Password?</a>
            </div>

            <button type="submit" class="btn-login">
                Login <i class="fas fa-sign-in-alt" style="margin-left: 5px;"></i>
            </button>
        </form>

        <div class="register-link">
            Don't have an account? <a href="register">Register here</a>
        </div>

        <div class="divider">
            <span>or</span>
        </div>

        <button class="google-btn">
            <i class="fab fa-google"></i> Continue with Google
        </button>
    </div>
    <script>
        function togglePasswordVisibility(inputId) {
            const passwordInput = document.getElementById(inputId);
            const eyeOffIcon = document.querySelector('.password-toggle .eye-off');
            const eyeIcon = document.querySelector('.password-toggle .eye');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                eyeOffIcon.style.display = 'none';
                eyeIcon.style.display = 'inline-block';
            } else {
                passwordInput.type = 'password';
                eyeOffIcon.style.display = 'inline-block';
                eyeIcon.style.display = 'none';
            }
        }
    </script>
</body>
</html>
