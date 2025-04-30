<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Your Profile - Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        <%@include file="../assets/css/style.css"%>
    </style>
    <style>
        /* Complete Profile Page Styles */
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: #2563eb;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #6b7280;
            font-size: 16px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .alert-danger {
            background-color: #fee2e2;
            color: #ef4444;
            border: 1px solid #fecaca;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 5px;
            font-size: 16px;
            font-family: 'Poppins', sans-serif;
        }
        
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: #2563eb;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn:hover {
            background-color: #1e40af;
        }
        
        .btn-block {
            display: block;
            width: 100%;
        }
        
        .footer {
            text-align: center;
            margin-top: 30px;
            color: #6b7280;
        }
        
        .footer a {
            color: #2563eb;
            text-decoration: none;
        }
        
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Complete Your Doctor Profile</h1>
            <p>Please provide the following information to complete your profile</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/doctor/complete-profile" method="post">
            <div class="form-group">
                <label for="specialization">Specialization</label>
                <select id="specialization" name="specialization" required>
                    <option value="">Select Specialization</option>
                    <option value="Cardiology">Cardiology</option>
                    <option value="Dermatology">Dermatology</option>
                    <option value="Endocrinology">Endocrinology</option>
                    <option value="Gastroenterology">Gastroenterology</option>
                    <option value="Neurology">Neurology</option>
                    <option value="Obstetrics and Gynecology">Obstetrics and Gynecology</option>
                    <option value="Oncology">Oncology</option>
                    <option value="Ophthalmology">Ophthalmology</option>
                    <option value="Orthopedics">Orthopedics</option>
                    <option value="Pediatrics">Pediatrics</option>
                    <option value="Psychiatry">Psychiatry</option>
                    <option value="Urology">Urology</option>
                    <option value="General Medicine">General Medicine</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="qualification">Qualification</label>
                <input type="text" id="qualification" name="qualification" placeholder="e.g., MBBS, MD, MS" required>
            </div>
            
            <div class="form-group">
                <label for="experience">Experience (in years)</label>
                <input type="number" id="experience" name="experience" min="0" max="50" required>
            </div>
            
            <div class="form-group">
                <label for="consultationFee">Consultation Fee</label>
                <input type="number" id="consultationFee" name="consultationFee" min="0" required>
            </div>
            
            <div class="form-group">
                <label for="bio">Bio/Description</label>
                <textarea id="bio" name="bio" rows="5" placeholder="Tell us about yourself and your practice"></textarea>
            </div>
            
            <div class="form-group">
                <label for="profileImage">Profile Image URL</label>
                <input type="text" id="profileImage" name="profileImage" placeholder="URL to your profile image">
            </div>
            
            <button type="submit" class="btn btn-block">Complete Profile</button>
        </form>
        
        <div class="footer">
            <p>Already have a complete profile? <a href="${pageContext.request.contextPath}/doctor/dashboard">Go to Dashboard</a></p>
        </div>
    </div>
</body>
</html>
