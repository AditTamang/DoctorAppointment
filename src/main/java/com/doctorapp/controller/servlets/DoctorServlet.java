package com.doctorapp.controller.servlets;

 import java.io.IOException;
 import java.util.List;

 import com.doctorapp.model.Doctor;
 import com.doctorapp.model.User;
 import com.doctorapp.service.DoctorService;

 import jakarta.servlet.ServletException;
 import jakarta.servlet.annotation.WebServlet;
 import jakarta.servlet.http.HttpServlet;
 import jakarta.servlet.http.HttpServletRequest;
 import jakarta.servlet.http.HttpServletResponse;
 import jakarta.servlet.http.HttpSession;

 @WebServlet(urlPatterns = {
     "/doctors",
     "/doctor/details",
     "/admin/doctors",
     "/admin/doctor/add",
     "/admin/doctor/edit",
     "/admin/doctor/delete"
 })
 public class DoctorServlet extends HttpServlet {
     private static final long serialVersionUID = 1L;
     private DoctorService doctorService;

     public void init() {
         doctorService = new DoctorService();
     }

     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         String action = request.getServletPath();

         switch (action) {
             case "/doctors":
                 listDoctors(request, response);
                 break;
             case "/doctor/details":
                 showDoctorDetails(request, response);
                 break;
             case "/admin/doctors":
                 listDoctorsForAdmin(request, response);
                 break;
             case "/admin/doctor/add":
                 showAddDoctorForm(request, response);
                 break;
             case "/admin/doctor/edit":
                 showEditDoctorForm(request, response);
                 break;
             case "/admin/doctor/view":
                 viewDoctorDetails(request, response);
                 break;
             case "/admin/doctor/delete":
                 deleteDoctor(request, response);
                 break;
             default:
                 response.sendRedirect(request.getContextPath() + "/index.jsp");
                 break;
         }
     }

     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         String action = request.getServletPath();

         switch (action) {
             case "/admin/doctor/add":
                 addDoctor(request, response);
                 break;
             case "/admin/doctor/edit":
                 updateDoctor(request, response);
                 break;
             case "/admin/doctor/delete":
                 deleteDoctor(request, response);
                 break;
             default:
                 response.sendRedirect(request.getContextPath() + "/index.jsp");
                 break;
         }
     }

     private void listDoctors(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         // Get filter parameters
         String specialization = request.getParameter("specialization");
         String search = request.getParameter("search");
         String experience = request.getParameter("experience");

         List<Doctor> doctors;

         try {
             // First get doctors based on specialization
             if (specialization != null && !specialization.isEmpty()) {
                 // Use approved doctors by specialization for public display
                 System.out.println("Fetching doctors with specialization: " + specialization);
                 doctors = doctorService.getApprovedDoctorsBySpecialization(specialization);
             } else if (search != null && !search.isEmpty()) {
                 // Search for doctors by name or specialization
                 System.out.println("Searching for doctors with term: " + search);
                 doctors = doctorService.searchApprovedDoctors(search);
             } else {
                 // Use approved doctors for public display
                 System.out.println("Fetching all approved doctors");
                 doctors = doctorService.getApprovedDoctors();
             }

             // Apply additional filters in memory
             if (experience != null && !experience.isEmpty() && doctors != null) {
                 // Filter by experience range
                 System.out.println("Filtering by experience: " + experience);
                 List<Doctor> filteredDoctors = new java.util.ArrayList<>();

                 for (Doctor doctor : doctors) {
                     String docExperience = doctor.getExperience();
                     if (docExperience != null && !docExperience.isEmpty()) {
                         try {
                             // Extract numeric value from experience string
                             int years = Integer.parseInt(docExperience.replaceAll("[^0-9]", ""));

                             if (experience.equals("0-5") && years >= 0 && years <= 5) {
                                 filteredDoctors.add(doctor);
                             } else if (experience.equals("5-10") && years > 5 && years <= 10) {
                                 filteredDoctors.add(doctor);
                             } else if (experience.equals("10+") && years > 10) {
                                 filteredDoctors.add(doctor);
                             }
                         } catch (NumberFormatException e) {
                             // If we can't parse the experience, skip this doctor
                             System.out.println("Could not parse experience: " + docExperience);
                         }
                     }
                 }

                 doctors = filteredDoctors;
             }

             System.out.println("Found " + (doctors != null ? doctors.size() : 0) + " doctors after filtering");
         } catch (Exception e) {
             System.err.println("Error filtering doctors: " + e.getMessage());
             e.printStackTrace();
             doctors = new java.util.ArrayList<>();
             request.setAttribute("error", "An error occurred while filtering doctors. Please try again.");
         }

         // Set attributes for the JSP
         request.setAttribute("specialization", specialization);
         request.setAttribute("search", search);
         request.setAttribute("experience", experience);
         request.setAttribute("doctors", doctors);
         request.getRequestDispatcher("/doctors.jsp").forward(request, response);
     }

     private void showDoctorDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         try {
             String idParam = request.getParameter("id");
             System.out.println("Received request to show doctor details with ID: " + idParam);

             if (idParam == null || idParam.trim().isEmpty()) {
                 System.err.println("Doctor ID parameter is missing or empty");
                 request.setAttribute("error", "Doctor ID is required.");
                 request.getRequestDispatcher("/doctors.jsp").forward(request, response);
                 return;
             }

             int id = Integer.parseInt(idParam);
             System.out.println("Fetching doctor with ID: " + id);
             Doctor doctor = doctorService.getDoctorById(id);

             if (doctor != null) {
                 System.out.println("Doctor found: " + doctor.getName());

                 // Always set doctor as active to ensure profile is viewable
                 // This is a temporary fix until the status column is properly added to the database
                 if (doctor.getStatus() == null) {
                     System.out.println("Doctor status is null, setting to ACTIVE by default");
                     doctor.setStatus("ACTIVE");
                 }

                 // Always show the doctor profile regardless of status
                 // We'll assume all doctors in the system are active
                 System.out.println("Forwarding to doctor-details.jsp");
                 request.setAttribute("doctor", doctor);
                 request.getRequestDispatcher("/doctor-details.jsp").forward(request, response);
             } else {
                 // Doctor not found, redirect to doctors list
                 System.err.println("No doctor found with ID: " + id);
                 request.setAttribute("error", "Doctor not found.");
                 request.getRequestDispatcher("/doctors.jsp").forward(request, response);
             }
         } catch (NumberFormatException e) {
             // Handle invalid doctor ID
             System.err.println("Invalid doctor ID format: " + e.getMessage());
             request.setAttribute("error", "Invalid doctor ID format.");
             request.getRequestDispatcher("/doctors.jsp").forward(request, response);
         } catch (Exception e) {
             // Log any other errors
             System.err.println("Error showing doctor details: " + e.getMessage());
             e.printStackTrace();

             // Add error information to request for better debugging
             request.setAttribute("errorMessage", "An error occurred while retrieving doctor details: " + e.getMessage());
             request.getRequestDispatcher("/error.jsp").forward(request, response);
         }
     }

     private void listDoctorsForAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         // Check if user is admin
         HttpSession session = request.getSession(false);
         if (session == null || session.getAttribute("user") == null) {
             response.sendRedirect(request.getContextPath() + "/login.jsp");
             return;
         }

         User user = (User) session.getAttribute("user");
         if (!"ADMIN".equals(user.getRole())) {
             response.sendRedirect(request.getContextPath() + "/dashboard");
             return;
         }

         List<Doctor> doctors = doctorService.getAllDoctors();
         request.setAttribute("doctors", doctors);
         request.getRequestDispatcher("/admin/doctors.jsp").forward(request, response);
     }

     private void showAddDoctorForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         // Check if user is admin
         HttpSession session = request.getSession(false);
         if (session == null || session.getAttribute("user") == null) {
             response.sendRedirect(request.getContextPath() + "/login.jsp");
             return;
         }

         User user = (User) session.getAttribute("user");
         if (!"ADMIN".equals(user.getRole())) {
             response.sendRedirect(request.getContextPath() + "/dashboard");
             return;
         }

         request.getRequestDispatcher("/admin/add-doctor.jsp").forward(request, response);
     }

     private void showEditDoctorForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         // Check if user is admin
         HttpSession session = request.getSession(false);
         if (session == null || session.getAttribute("user") == null) {
             response.sendRedirect(request.getContextPath() + "/login.jsp");
             return;
         }

         User user = (User) session.getAttribute("user");
         if (!"ADMIN".equals(user.getRole())) {
             response.sendRedirect(request.getContextPath() + "/dashboard");
             return;
         }

         int id = Integer.parseInt(request.getParameter("id"));
         Doctor doctor = doctorService.getDoctorById(id);

         if (doctor != null) {
             request.setAttribute("doctor", doctor);
             request.getRequestDispatcher("/admin/edit-doctor.jsp").forward(request, response);
         } else {
             response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
         }
     }

     private void addDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         // Check if user is admin
         HttpSession session = request.getSession(false);
         if (session == null || session.getAttribute("user") == null) {
             response.sendRedirect(request.getContextPath() + "/login.jsp");
             return;
         }

         User user = (User) session.getAttribute("user");
         if (!"ADMIN".equals(user.getRole())) {
             response.sendRedirect(request.getContextPath() + "/dashboard");
             return;
         }

         // Get form data
         String name = request.getParameter("name");
         String specialization = request.getParameter("specialization");
         String qualification = request.getParameter("qualification");
         String experience = request.getParameter("experience");
         String email = request.getParameter("email");
         String phone = request.getParameter("phone");
         String address = request.getParameter("address");
         String consultationFee = request.getParameter("consultationFee");
         String availableDays = request.getParameter("availableDays");
         String availableTime = request.getParameter("availableTime");
         String imageUrl = request.getParameter("imageUrl");

         // Create doctor object
         Doctor doctor = new Doctor();
         doctor.setName(name);
         doctor.setSpecialization(specialization);
         doctor.setQualification(qualification);
         doctor.setExperience(experience);
         doctor.setEmail(email);
         doctor.setPhone(phone);
         doctor.setAddress(address);
         doctor.setConsultationFee(consultationFee);
         doctor.setAvailableDays(availableDays);
         doctor.setAvailableTime(availableTime);
         doctor.setImageUrl(imageUrl);

         // Add doctor to database
         if (doctorService.addDoctor(doctor)) {
             request.setAttribute("message", "Doctor added successfully!");
         } else {
             request.setAttribute("error", "Failed to add doctor. Please try again.");
         }

         // Forward back to the form
         request.getRequestDispatcher("/admin/add-doctor.jsp").forward(request, response);
     }

     private void updateDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         // Check if user is admin
         HttpSession session = request.getSession(false);
         if (session == null || session.getAttribute("user") == null) {
             response.sendRedirect(request.getContextPath() + "/login.jsp");
             return;
         }

         User user = (User) session.getAttribute("user");
         if (!"ADMIN".equals(user.getRole())) {
             response.sendRedirect(request.getContextPath() + "/dashboard");
             return;
         }

         // Get form data
         int id = Integer.parseInt(request.getParameter("id"));
         String name = request.getParameter("name");
         String specialization = request.getParameter("specialization");
         String qualification = request.getParameter("qualification");
         String experience = request.getParameter("experience");
         String email = request.getParameter("email");
         String phone = request.getParameter("phone");
         String address = request.getParameter("address");
         String consultationFee = request.getParameter("consultationFee");
         String availableDays = request.getParameter("availableDays");
         String availableTime = request.getParameter("availableTime");
         String imageUrl = request.getParameter("imageUrl");

         // Create doctor object
         Doctor doctor = new Doctor();
         doctor.setId(id);
         doctor.setName(name);
         doctor.setSpecialization(specialization);
         doctor.setQualification(qualification);
         doctor.setExperience(experience);
         doctor.setEmail(email);
         doctor.setPhone(phone);
         doctor.setAddress(address);
         doctor.setConsultationFee(consultationFee);
         doctor.setAvailableDays(availableDays);
         doctor.setAvailableTime(availableTime);
         doctor.setImageUrl(imageUrl);

         // Update doctor in database
         if (doctorService.updateDoctor(doctor)) {
             request.setAttribute("message", "Doctor updated successfully!");
         } else {
             request.setAttribute("error", "Failed to update doctor. Please try again.");
         }

         // Forward back to the form
         request.setAttribute("doctor", doctor);
         request.getRequestDispatcher("/admin/edit-doctor.jsp").forward(request, response);
     }

     private void viewDoctorDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         // Check if user is admin
         HttpSession session = request.getSession(false);
         if (session == null || session.getAttribute("user") == null) {
             response.sendRedirect(request.getContextPath() + "/login.jsp");
             return;
         }

         User user = (User) session.getAttribute("user");
         if (!"ADMIN".equals(user.getRole())) {
             response.sendRedirect(request.getContextPath() + "/dashboard");
             return;
         }

         // Get doctor ID
         int id = Integer.parseInt(request.getParameter("id"));
         Doctor doctor = doctorService.getDoctorById(id);

         if (doctor != null) {
             request.setAttribute("doctor", doctor);
             request.getRequestDispatcher("/admin/view-doctor.jsp").forward(request, response);
         } else {
             response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
         }
     }

     private void deleteDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         // Check if user is admin
         HttpSession session = request.getSession(false);
         if (session == null || session.getAttribute("user") == null) {
             response.sendRedirect(request.getContextPath() + "/login.jsp");
             return;
         }

         User user = (User) session.getAttribute("user");
         if (!"ADMIN".equals(user.getRole())) {
             response.sendRedirect(request.getContextPath() + "/dashboard");
             return;
         }

         // Get doctor ID
         int id = Integer.parseInt(request.getParameter("id"));

         // Delete doctor from database
         if (doctorService.deleteDoctor(id)) {
             request.setAttribute("message", "Doctor deleted successfully!");
         } else {
             request.setAttribute("error", "Failed to delete doctor. Please try again.");
         }

         // Redirect to doctors list
         response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
     }
}