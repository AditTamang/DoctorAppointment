<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fc;
            color: #333;
            line-height: 1.5;
        }
        
        .error-container {
            max-width: 800px;
            margin: 100px auto;
            padding: 40px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .error-code {
            font-size: 120px;
            font-weight: 700;
            color: #4e73df;
            margin-bottom: 20px;
            line-height: 1;
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
        
        .error-image {
            max-width: 300px;
            margin: 20px auto;
        }
        
        .error-actions {
            margin-top: 30px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: #4e73df;
            color: white;
            border-radius: 5px;
            text-decoration: none;
            margin: 0 10px;
            transition: background-color 0.3s;
            font-weight: 500;
        }
        
        .btn:hover {
            background-color: #3a56b0;
        }
        
        .btn-outline {
            background-color: transparent;
            border: 1px solid #4e73df;
            color: #4e73df;
        }
        
        .btn-outline:hover {
            background-color: #4e73df;
            color: white;
        }
        
        .search-box {
            max-width: 500px;
            margin: 30px auto;
            position: relative;
        }
        
        .search-input {
            width: 100%;
            padding: 12px 20px;
            padding-left: 45px;
            border: 1px solid #ddd;
            border-radius: 50px;
            font-size: 16px;
            outline: none;
            transition: all 0.3s;
        }
        
        .search-input:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.25);
        }
        
        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
        }
        
        .search-button {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background-color: #4e73df;
            color: white;
            border: none;
            border-radius: 50px;
            padding: 8px 20px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .search-button:hover {
            background-color: #3a56b0;
        }
        
        .suggested-links {
            margin-top: 30px;
            text-align: center;
        }
        
        .suggested-links h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #333;
        }
        
        .suggested-links ul {
            list-style: none;
            padding: 0;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 10px;
        }
        
        .suggested-links li a {
            display: inline-block;
            padding: 8px 15px;
            background-color: #f0f2f5;
            color: #333;
            border-radius: 5px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .suggested-links li a:hover {
            background-color: #4e73df;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">404</div>
        <h1 class="error-title">Page Not Found</h1>
        <p class="error-message">The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
        
        <img src="${pageContext.request.contextPath}/assets/images/404.svg" alt="404 Error" class="error-image">
        
        <div class="search-box">
            <i class="fas fa-search search-icon"></i>
            <input type="text" class="search-input" placeholder="Search for pages...">
            <button class="search-button">Search</button>
        </div>
        
        <div class="suggested-links">
            <h3>You might want to check these pages:</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/doctors"><i class="fas fa-user-md"></i> Doctors</a></li>
                <li><a href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> Login</a></li>
                <li><a href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Register</a></li>
                <li><a href="${pageContext.request.contextPath}/contact-us.jsp"><i class="fas fa-envelope"></i> Contact Us</a></li>
            </ul>
        </div>
        
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/" class="btn"><i class="fas fa-home"></i> Go to Home</a>
            <a href="javascript:history.back()" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Go Back</a>
        </div>
    </div>
</body>
</html>
