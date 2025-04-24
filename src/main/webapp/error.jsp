<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Doctor Appointment System</title>
    <style>
        <%@include file="./assets/css/style.css"%>
    </style>
    <style>
        .error-container {
            max-width: 800px;
            margin: 100px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .error-icon {
            font-size: 80px;
            color: #e74c3c;
            margin-bottom: 20px;
        }

        .error-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 15px;
        }

        .error-message {
            font-size: 18px;
            color: #666;
            margin-bottom: 30px;
        }

        .error-details {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
            text-align: left;
            overflow-x: auto;
        }

        .error-actions {
            margin-top: 20px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border-radius: 5px;
            text-decoration: none;
            margin: 0 10px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #388E3C;
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid #4CAF50;
            color: #4CAF50;
        }

        .btn-outline:hover {
            background-color: #4CAF50;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-exclamation-circle"></i>
        </div>
        <h1 class="error-title">Oops! Something went wrong</h1>
        <p class="error-message">We're sorry, but an error occurred while processing your request.</p>

        <%
        // Get status code
        Integer statusCode = (Integer)request.getAttribute("javax.servlet.error.status_code");
        String errorMessage = (String)request.getAttribute("javax.servlet.error.message");

        if (statusCode != null) {
        %>
            <div class="error-details">
                <h3>Error Details:</h3>
                <p><strong>Status Code:</strong> <%= statusCode %></p>
                <% if (statusCode == 503) { %>
                    <p><strong>Message:</strong> The server is temporarily unavailable, possibly due to database initialization. Please try again in a moment.</p>
                    <p>This might happen during the first run when the database is being set up.</p>
                <% } else if (errorMessage != null && !errorMessage.isEmpty()) { %>
                    <p><strong>Message:</strong> <%= errorMessage %></p>
                <% } %>
            </div>
        <% } else if (exception != null) { %>
            <div class="error-details">
                <h3>Error Details:</h3>
                <p><strong>Type:</strong> <%= exception.getClass().getName() %></p>
                <p><strong>Message:</strong> <%= exception.getMessage() %></p>
            </div>
        <% } %>

        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/" class="btn">Go to Home</a>
            <a href="javascript:history.back()" class="btn btn-outline">Go Back</a>
            <% if (statusCode != null && statusCode == 503) { %>
                <a href="javascript:window.location.reload()" class="btn" style="background-color: #2196F3;">Retry</a>
            <% } %>
        </div>
    </div>

    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>
