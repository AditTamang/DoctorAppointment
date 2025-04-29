<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - Doctor Appointment System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .access-denied-container {
            text-align: center;
            padding: 50px 20px;
            max-width: 600px;
            margin: 50px auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        
        .access-denied-icon {
            font-size: 80px;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        
        .access-denied-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 15px;
        }
        
        .access-denied-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .back-button {
            display: inline-block;
            padding: 12px 25px;
            background-color: #3498db;
            color: white;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s;
        }
        
        .back-button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <div class="access-denied-container">
        <div class="access-denied-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <h1 class="access-denied-title">Access Denied</h1>
        <p class="access-denied-message">
            Sorry, you don't have permission to access this page. 
            This area is restricted to authorized users only.
        </p>
        <a href="${pageContext.request.contextPath}/index.jsp" class="back-button">
            <i class="fas fa-home"></i> Go to Homepage
        </a>
    </div>
</body>
</html>
