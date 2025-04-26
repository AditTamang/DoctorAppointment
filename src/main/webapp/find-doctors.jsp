<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find Doctors - HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Doctor Search and Filter Styles */
        .search-container {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .search-header {
            margin-bottom: 20px;
        }
        
        .search-header h2 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 5px;
        }
        
        .search-header p {
            color: #666;
            font-size: 0.9rem;
        }
        
        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .search-group {
            flex: 1;
            min-width: 200px;
        }
        
        .search-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
            font-size: 0.9rem;
        }
        
        .search-input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 0.9rem;
            transition: border-color 0.3s;
        }
        
        .search-input:focus {
            border-color: #4e73df;
            outline: none;
        }
        
        .search-select {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 0.9rem;
            appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg fill="%23555" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/><path d="M0 0h24v24H0z" fill="none"/></svg>');
            background-repeat: no-repeat;
            background-position: right 10px center;
            background-size: 20px;
        }
        
        .search-button {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .search-button:hover {
            background-color: #3a5fc8;
        }
        
        .search-button-container {
            display: flex;
            align-items: flex-end;
            margin-top: 24px;
        }
        
        /* Specialty Filter Styles */
        .specialty-filters {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .specialty-filter {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: #555;
            transition: transform 0.3s;
            flex: 1;
            min-width: 100px;
            max-width: 120px;
            background-color: #fff;
            border-radius: 10px;
            padding: 15px 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border: 2px solid transparent;
        }
        
        .specialty-filter:hover {
            transform: translateY(-5px);
        }
        
        .specialty-filter.active {
            border-color: #4e73df;
            color: #4e73df;
        }
        
        .specialty-icon {
            width: 50px;
            height: 50px;
            background-color: #f0f4ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            font-size: 1.5rem;
            color: #4e73df;
        }
        
        .specialty-filter.active .specialty-icon {
            background-color: #4e73df;
            color: white;
        }
        
        .specialty-filter span {
            font-size: 0.85rem;
            font-weight: 500;
            text-align: center;
        }
        
        /* Doctor List Styles */
        .doctors-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .doctors-count h3 {
            font-size: 1.2rem;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .count-badge {
            background-color: #f0f4ff;
            color: #4e73df;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .doctors-sort select {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 0.9rem;
            color: #555;
            background-color: #fff;
            cursor: pointer;
        }
        
        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .doctor-card {
            background-color: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
        }
        
        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }
        
        .doctor-status {
            position: absolute;
            top: 15px;
            left: 15px;
            background-color: rgba(46, 204, 113, 0.9);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 500;
            z-index: 1;
        }
        
        .doctor-img {
            height: 200px;
            position: relative;
            overflow: hidden;
        }
        
        .doctor-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }
        
        .doctor-card:hover .doctor-img img {
            transform: scale(1.05);
        }
        
        .doctor-rating {
            position: absolute;
            bottom: 10px;
            left: 10px;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 5px 10px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.8rem;
        }
        
        .doctor-rating i {
            color: #ffc107;
        }
        
        .doctor-info {
            padding: 20px;
        }
        
        .doctor-info h3 {
            margin: 0 0 5px 0;
            font-size: 1.1rem;
            color: #333;
        }
        
        .doctor-info .specialization {
            color: #4e73df;
            font-weight: 500;
            margin-bottom: 5px;
            font-size: 0.9rem;
        }
        
        .doctor-info p {
            color: #666;
            font-size: 0.85rem;
            margin-bottom: 15px;
            line-height: 1.5;
        }
        
        .doctor-meta {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .doctor-meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.85rem;
            color: #555;
        }
        
        .doctor-meta-item i {
            color: #4e73df;
        }
        
        .doctor-actions {
            display: flex;
            gap: 10px;
        }
        
        .doctor-actions a {
            flex: 1;
            text-align: center;
            padding: 8px 0;
            border-radius: 5px;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            transition: background-color 0.3s, color 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }
        
        .doctor-actions .btn-primary {
            background-color: #4e73df;
            color: white;
        }
        
        .doctor-actions .btn-primary:hover {
            background-color: #3a5fc8;
        }
        
        .doctor-actions .btn-outline {
            border: 1px solid #4e73df;
            color: #4e73df;
            background-color: transparent;
        }
        
        .doctor-actions .btn-outline:hover {
            background-color: #4e73df;
            color: white;
        }
        
        .no-results-card {
            grid-column: 1 / -1;
            background-color: #fff;
            border-radius: 10px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }
        
        .no-results-icon {
            font-size: 3rem;
            color: #4e73df;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        .no-results-card h3 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 10px;
        }
        
        .no-results-card p {
            color: #666;
            margin-bottom: 20px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .no-results-card .btn-primary {
            display: inline-block;
            background-color: #4e73df;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s;
        }
        
        .no-results-card .btn-primary:hover {
            background-color: #3a5fc8;
        }
        
        /* Pagination Styles */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-top: 30px;
        }
        
        .pagination a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 5px;
            text-decoration: none;
            color: #555;
            font-weight: 500;
            transition: background-color 0.3s, color 0.3s;
        }
        
        .pagination-number {
            background-color: #f0f4ff;
        }
        
        .pagination-number.active {
            background-color: #4e73df;
            color: white;
        }
        
        .pagination-number:hover:not(.active) {
            background-color: #e0e7ff;
        }
        
        .pagination-arrow {
            background-color: #f0f4ff;
        }
        
        .pagination-arrow:hover {
            background-color: #e0e7ff;
        }
        
        .pagination-dots {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            color: #555;
        }
        
        /* Responsive Styles */
        @media (max-width: 768px) {
            .search-form {
                flex-direction: column;
            }
            
            .search-group {
                width: 100%;
            }
            
            .doctors-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .doctors-sort {
                width: 100%;
            }
            
            .doctors-sort select {
                width: 100%;
            }
            
            .doctors-grid {
                grid-template-columns: 1fr;
            }
            
            .specialty-filters {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Find Doctors</h1>
        
        <!-- Search and Filter Section -->
        <div class="search-container">
            <div class="search-header">
                <h2>Search Doctor</h2>
                <p>Find the right doctor for your needs</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/doctors" method="get" class="search-form">
                <div class="search-group">
                    <label for="search">Search Doctor</label>
                    <input type="text" id="search" name="search" placeholder="Search by name or specialty" class="search-input">
                </div>
                
                <div class="search-group">
                    <label for="specialization">Specialization</label>
                    <select id="specialization" name="specialization" class="search-select">
                        <option value="">All Specializations</option>
                        <option value="Cardiologist" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Cardiologist") ? "selected" : "" %>>Cardiologist</option>
                        <option value="Neurologist" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Neurologist") ? "selected" : "" %>>Neurologist</option>
                        <option value="Orthopedic" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Orthopedic") ? "selected" : "" %>>Orthopedic</option>
                        <option value="Dermatologist" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Dermatologist") ? "selected" : "" %>>Dermatologist</option>
                        <option value="Pediatrician" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Pediatrician") ? "selected" : "" %>>Pediatrician</option>
                        <option value="Gynecologist" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Gynecologist") ? "selected" : "" %>>Gynecologist</option>
                    </select>
                </div>
                
                <div class="search-group">
                    <label for="experience">Experience</label>
                    <select id="experience" name="experience" class="search-select">
                        <option value="">Any Experience</option>
                        <option value="0-5">0-5 Years</option>
                        <option value="5-10">5-10 Years</option>
                        <option value="10+">10+ Years</option>
                    </select>
                </div>
                
                <div class="search-group search-button-container">
                    <button type="submit" class="search-button">
                        <i class="fas fa-filter"></i> Apply Filters
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Specialty Quick Filters -->
        <div class="specialty-filters">
            <a href="javascript:void(0);" onclick="filterBySpecialty('')" class="specialty-filter <%= request.getAttribute("specialization") == null ? "active" : "" %>">
                <div class="specialty-icon">
                    <i class="fas fa-user-md"></i>
                </div>
                <span>All</span>
            </a>
            <a href="javascript:void(0);" onclick="filterBySpecialty('Cardiologist')" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Cardiologist") ? "active" : "" %>">
                <div class="specialty-icon">
                    <i class="fas fa-heartbeat"></i>
                </div>
                <span>Cardiology</span>
            </a>
            <a href="javascript:void(0);" onclick="filterBySpecialty('Neurologist')" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Neurologist") ? "active" : "" %>">
                <div class="specialty-icon">
                    <i class="fas fa-brain"></i>
                </div>
                <span>Neurology</span>
            </a>
            <a href="javascript:void(0);" onclick="filterBySpecialty('Orthopedic')" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Orthopedic") ? "active" : "" %>">
                <div class="specialty-icon">
                    <i class="fas fa-bone"></i>
                </div>
                <span>Orthopedic</span>
            </a>
            <a href="javascript:void(0);" onclick="filterBySpecialty('Dermatologist')" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Dermatologist") ? "active" : "" %>">
                <div class="specialty-icon">
                    <i class="fas fa-allergies"></i>
                </div>
                <span>Dermatology</span>
            </a>
            <a href="javascript:void(0);" onclick="filterBySpecialty('Pediatrician')" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Pediatrician") ? "active" : "" %>">
                <div class="specialty-icon">
                    <i class="fas fa-baby"></i>
                </div>
                <span>Pediatrics</span>
            </a>
            <a href="javascript:void(0);" onclick="filterBySpecialty('Gynecologist')" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Gynecologist") ? "active" : "" %>">
                <div class="specialty-icon">
                    <i class="fas fa-venus"></i>
                </div>
                <span>Gynecology</span>
            </a>
        </div>
        
        <!-- Doctor Count -->
        <%
        List<Doctor> doctors = null;
        try {
            doctors = (List<Doctor>) request.getAttribute("doctors");
        } catch (Exception e) {
        }
        String specialization = (String) request.getAttribute("specialization");
        int doctorCount = doctors != null ? doctors.size() : 0;
        %>
        <div class="doctors-header">
            <div class="doctors-count">
                <h3>
                    <% if(specialization != null && !specialization.isEmpty()) { %>
                        <span class="highlight"><%= specialization %></span> Doctors
                    <% } else { %>
                        All Doctors
                    <% } %>
                    <span class="count-badge"><%= doctorCount %> found</span>
                </h3>
            </div>
            <div class="doctors-sort">
                <select class="form-control" id="sortDoctors" onchange="sortDoctors(this.value)">
                    <option value="recommended">Sort by: Recommended</option>
                    <option value="experience">Sort by: Experience</option>
                    <option value="fee-low">Sort by: Fee (Low to High)</option>
                    <option value="fee-high">Sort by: Fee (High to Low)</option>
                </select>
            </div>
        </div>
        
        <div class="doctors-grid">
            <%
            if(doctors != null && !doctors.isEmpty()) {
                for(int i = 0; i < doctors.size(); i++) {
                    Doctor doctor = doctors.get(i);
            %>
            <div class="doctor-card">
                <div class="doctor-status">Available Today</div>
                <div class="doctor-img">
                    <img src="${pageContext.request.contextPath}${doctor.imageUrl != null && !doctor.imageUrl.isEmpty() ? (doctor.imageUrl.startsWith('/') ? doctor.imageUrl : '/assets/images/doctors/'.concat(doctor.imageUrl)) : '/assets/images/doctors/d1.png'}" alt="${doctor.name}">
                    <div class="doctor-rating">
                        <i class="fas fa-star"></i>
                        <span>4.8</span>
                        <span>(120)</span>
                    </div>
                </div>
                <div class="doctor-info">
                    <h3><%= doctor.getName() %></h3>
                    <p class="specialization"><%= doctor.getSpecialization() %></p>
                    <p><%= doctor.getQualification() != null ? doctor.getQualification() : "Specialist Doctor" %></p>
                    
                    <div class="doctor-meta">
                        <div class="doctor-meta-item">
                            <i class="fas fa-briefcase"></i>
                            <span><%= doctor.getExperience() != null ? doctor.getExperience() + " Years" : "Experienced" %></span>
                        </div>
                        <div class="doctor-meta-item">
                            <i class="fas fa-money-bill-wave"></i>
                            <span><%= doctor.getConsultationFee() != null ? "$" + doctor.getConsultationFee() : "$100" %></span>
                        </div>
                    </div>
                    
                    <div class="doctor-actions">
                        <a href="${pageContext.request.contextPath}/doctor/details?id=<%= doctor.getId() %>" class="btn-primary"><i class="fas fa-eye"></i> View Profile</a>
                        <a href="${pageContext.request.contextPath}/appointment/book?doctorId=<%= doctor.getId() %>" class="btn-outline"><i class="fas fa-calendar-check"></i> Book</a>
                    </div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="no-results-card">
                <div class="no-results-icon">
                    <i class="fas fa-user-md"></i>
                </div>
                <h3>No Doctors Found</h3>
                <p>We couldn't find any approved doctors matching your criteria. Please try a different specialization or check back later.</p>
                <p>Our admin team is reviewing doctor applications. New doctors will be available soon!</p>
                <a href="${pageContext.request.contextPath}/doctors" class="btn-primary">View All Doctors</a>
            </div>
            <% } %>
        </div>
        
        <!-- Pagination -->
        <% if(doctors != null && !doctors.isEmpty() && doctors.size() > 10) { %>
        <div class="pagination">
            <a href="javascript:void(0);" class="pagination-arrow">
                <i class="fas fa-chevron-left"></i>
            </a>
            <a href="javascript:void(0);" class="pagination-number active">1</a>
            <a href="javascript:void(0);" class="pagination-number">2</a>
            <a href="javascript:void(0);" class="pagination-number">3</a>
            <span class="pagination-dots">...</span>
            <a href="javascript:void(0);" class="pagination-number">10</a>
            <a href="javascript:void(0);" class="pagination-arrow">
                <i class="fas fa-chevron-right"></i>
            </a>
        </div>
        <% } %>
    </div>
    
    <script>
        // Function to filter doctors by specialty
        function filterBySpecialty(specialty) {
            // Update the active class on the specialty filters
            document.querySelectorAll('.specialty-filter').forEach(filter => {
                filter.classList.remove('active');
            });
            
            // Find the clicked filter and add the active class
            if (specialty === '') {
                document.querySelector('.specialty-filter:first-child').classList.add('active');
            } else {
                document.querySelectorAll('.specialty-filter').forEach(filter => {
                    if (filter.querySelector('span').textContent.trim() === specialty ||
                        filter.querySelector('span').textContent.trim() === specialty + 'y') {
                        filter.classList.add('active');
                    }
                });
            }
            
            // Redirect to the appropriate URL
            if (specialty === '') {
                window.location.href = '${pageContext.request.contextPath}/doctors';
            } else {
                window.location.href = '${pageContext.request.contextPath}/doctors?specialization=' + specialty;
            }
        }
        
        // Function to sort doctors
        function sortDoctors(sortBy) {
            // This would be implemented with server-side sorting in a real application
            console.log("Sorting by: " + sortBy);
            // For now, we'll just reload the page to demonstrate the concept
            // In a real application, you would add the sort parameter to the URL
            // window.location.href = '${pageContext.request.contextPath}/doctors?sort=' + sortBy;
        }
    </script>
</body>
</html>
