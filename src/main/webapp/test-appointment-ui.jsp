<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Appointment UI</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background-color: #f5f5f5;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        h1 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .ui-preview {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .ui-preview img {
            width: 100%;
            height: auto;
            display: block;
        }
        
        .ui-description {
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .ui-description h2 {
            margin-bottom: 15px;
            color: #333;
        }
        
        .ui-description p {
            margin-bottom: 15px;
            line-height: 1.6;
            color: #555;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn:hover {
            background-color: #388E3C;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Appointment Booking UI Test</h1>
        
        <div class="ui-preview">
            <img src="https://i.imgur.com/example-image.jpg" alt="UI Preview" onerror="this.src='https://via.placeholder.com/1200x600?text=Appointment+Booking+UI'">
        </div>
        
        <div class="ui-description">
            <h2>New Appointment Booking UI</h2>
            <p>This is a test page for the new appointment booking UI. The new UI features:</p>
            <ul>
                <li>A clean, modern design with a green header</li>
                <li>Patient information displayed in the header</li>
                <li>Simplified appointment booking form</li>
                <li>Easy-to-select time slots</li>
                <li>Responsive design that works on all devices</li>
            </ul>
            <p>Click the button below to test the new appointment booking UI:</p>
            <a href="appointment/book?doctorId=1" class="btn">Test New UI</a>
        </div>
    </div>
</body>
</html>
