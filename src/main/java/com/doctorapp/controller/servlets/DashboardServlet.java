package com.doctorapp.controller.servlets;

 import java.io.IOException;

 import com.doctorapp.dao.AppointmentDAO;
 import com.doctorapp.dao.DoctorDAO;
 import com.doctorapp.dao.PatientDAO;
 import com.doctorapp.dao.UserDAO;
 import com.doctorapp.model.User;

 import jakarta.servlet.ServletException;
 import jakarta.servlet.annotation.WebServlet;
 import jakarta.servlet.http.HttpServlet;
 import jakarta.servlet.http.HttpServletRequest;
 import jakarta.servlet.http.HttpServletResponse;
 import jakarta.servlet.http.HttpSession;

 @WebServlet("/dashboard")
 public class DashboardServlet extends HttpServlet {
     private static final long serialVersionUID = 1L;

     private UserDAO userDAO;
     private DoctorDAO doctorDAO;
     private PatientDAO patientDAO;
     private AppointmentDAO appointmentDAO;

     public void init() {
         userDAO = new UserDAO();
         doctorDAO = new DoctorDAO();
         patientDAO = new PatientDAO();
         appointmentDAO = new AppointmentDAO();
     }

     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         try {
             System.out.println("DashboardServlet: doGet method called");

             // Always create a session if it doesn't exist
             HttpSession session = request.getSession(true);
             System.out.println("DashboardServlet: Session ID: " + session.getId());

             // Check if user is logged in
             if (session.getAttribute("user") == null) {
                 System.out.println("DashboardServlet: No user in session, redirecting to login");
                 response.sendRedirect(request.getContextPath() + "/login.jsp");
                 return;
             }

             User user = (User) session.getAttribute("user");
             String role = user.getRole();

             System.out.println("DashboardServlet: User ID: " + user.getId() + ", Username: " + user.getUsername() + ", Role: " + role);

             // Route to appropriate dashboard based on role
             switch (role) {
                 case "ADMIN":
                     System.out.println("DashboardServlet: Loading admin dashboard");
                     loadAdminDashboard(request, response);
                     break;
                 case "DOCTOR":
                     System.out.println("DashboardServlet: Loading doctor dashboard");
                     loadDoctorDashboard(request, response);
                     break;
                 case "PATIENT":
                     System.out.println("DashboardServlet: Loading patient dashboard");
                     loadPatientDashboard(request, response);
                     break;
                 default:
                     // Invalid role, redirect to login
                     System.out.println("DashboardServlet: Invalid role: " + role);
                     session.invalidate();
                     response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid role: " + role);
                     break;
             }
         } catch (Exception e) {
             System.err.println("DashboardServlet Error: " + e.getMessage());
             e.printStackTrace();
             response.sendRedirect(request.getContextPath() + "/error.jsp");
         }
     }

     private void loadAdminDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         try {
             System.out.println("Loading admin dashboard data");
             // Load admin dashboard data
             int totalDoctors = doctorDAO.getTotalDoctors();
             int totalPatients = patientDAO.getTotalPatients();
             int totalAppointments = appointmentDAO.getTotalAppointments();
             double totalRevenue = appointmentDAO.getTotalRevenue();

             // Get doctor counts by status
             int approvedDoctors = doctorDAO.getApprovedDoctorsCount();
             int pendingDoctors = doctorDAO.getPendingDoctorsCount();
             int rejectedDoctors = doctorDAO.getRejectedDoctorsCount();

             // Get today's appointments count
             int todayAppointments = appointmentDAO.getTodayAppointmentsCount();

             // Get new bookings count (pending appointments)
             int newBookings = appointmentDAO.getPendingAppointmentsCount();

             System.out.println("Admin dashboard stats: Doctors=" + totalDoctors + ", Patients=" + totalPatients + ", Appointments=" + totalAppointments);
             System.out.println("Doctor status counts: Approved=" + approvedDoctors + ", Pending=" + pendingDoctors + ", Rejected=" + rejectedDoctors);

             // Set attributes for the dashboard
             request.setAttribute("totalDoctors", totalDoctors);
             request.setAttribute("totalPatients", totalPatients);
             request.setAttribute("totalAppointments", totalAppointments);
             request.setAttribute("totalRevenue", totalRevenue);
             request.setAttribute("approvedDoctors", approvedDoctors);
             request.setAttribute("pendingDoctors", pendingDoctors);
             request.setAttribute("rejectedDoctors", rejectedDoctors);
             request.setAttribute("todayAppointments", todayAppointments);
             request.setAttribute("newBookings", newBookings);

             // Get upcoming appointments and sessions
             request.setAttribute("upcomingAppointments", appointmentDAO.getUpcomingAppointments(5));
             request.setAttribute("upcomingSessions", appointmentDAO.getUpcomingSessions(5));
             request.setAttribute("recentAppointments", appointmentDAO.getRecentAppointments(5));
             request.setAttribute("topDoctors", doctorDAO.getTopDoctors(3));

             System.out.println("Forwarding to admin/index.jsp");
             // Forward to admin dashboard
             request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
         } catch (Exception e) {
             System.err.println("Error loading admin dashboard: " + e.getMessage());
             e.printStackTrace();
             response.sendRedirect(request.getContextPath() + "/error.jsp");
         }
     }

     private void loadDoctorDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         try {
             // Get the logged-in doctor's ID
             HttpSession session = request.getSession(false);
             User user = (User) session.getAttribute("user");

             if (user == null) {
                 // User not found in session, redirect to login
                 response.sendRedirect(request.getContextPath() + "/login.jsp");
                 return;
             }

             int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());

             if (doctorId == 0) {
                 // Doctor profile not found, redirect to complete profile
                 response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
                 return;
             }

             // Get doctor details first
             com.doctorapp.model.Doctor doctor = doctorDAO.getDoctorById(doctorId);
             request.setAttribute("doctor", doctor);

             // Set default values for all attributes to prevent null pointer exceptions
             request.setAttribute("totalPatients", 0);
             request.setAttribute("weeklyAppointments", 0);
             request.setAttribute("pendingReports", 0);
             request.setAttribute("averageRating", 0.0);
             request.setAttribute("todayAppointments", 0);
             request.setAttribute("recentPatients", java.util.Collections.emptyList());
             request.setAttribute("upcomingAppointments", java.util.Collections.emptyList());

             // Now try to load actual data
             try {
                 request.setAttribute("totalPatients", doctorDAO.getTotalPatientsByDoctor(doctorId));
             } catch (Exception e) {
                 System.err.println("Error loading total patients: " + e.getMessage());
             }

             try {
                 request.setAttribute("weeklyAppointments", appointmentDAO.getWeeklyAppointmentsByDoctor(doctorId));
             } catch (Exception e) {
                 System.err.println("Error loading weekly appointments: " + e.getMessage());
             }

             try {
                 request.setAttribute("pendingReports", doctorDAO.getPendingReportsByDoctor(doctorId));
             } catch (Exception e) {
                 System.err.println("Error loading pending reports: " + e.getMessage());
             }

             try {
                 request.setAttribute("averageRating", doctorDAO.getAverageRatingByDoctor(doctorId));
             } catch (Exception e) {
                 System.err.println("Error loading average rating: " + e.getMessage());
             }

             try {
                 request.setAttribute("todayAppointments", appointmentDAO.getTodayAppointmentsCountByDoctor(doctorId));
             } catch (Exception e) {
                 System.err.println("Error loading today's appointments count: " + e.getMessage());
             }

             try {
                 request.setAttribute("recentPatients", patientDAO.getRecentPatientsByDoctor(doctorId, 4));
             } catch (Exception e) {
                 System.err.println("Error loading recent patients: " + e.getMessage());
             }

             try {
                 request.setAttribute("upcomingAppointments", appointmentDAO.getUpcomingAppointmentsByDoctor(doctorId, 4));
             } catch (Exception e) {
                 System.err.println("Error loading upcoming appointments: " + e.getMessage());
             }

             // Forward to new doctor dashboard
             request.getRequestDispatcher("/doctor/new-dashboard.jsp").forward(request, response);
         } catch (Exception e) {
             System.err.println("Error in loadDoctorDashboard: " + e.getMessage());
             e.printStackTrace();
             // Set error message and forward to error page
             request.setAttribute("errorMessage", "An error occurred while loading the dashboard: " + e.getMessage());
             request.getRequestDispatcher("/error.jsp").forward(request, response);
         }
     }

     private void loadPatientDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         // Always redirect to the patient dashboard servlet which will handle all the logic
         // Using the controller.patient.PatientDashboardServlet
         response.sendRedirect(request.getContextPath() + "/patient/dashboard");
     }

     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         doGet(request, response);
     }
 }