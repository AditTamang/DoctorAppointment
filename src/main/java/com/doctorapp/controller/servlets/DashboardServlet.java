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
         // Get the logged-in doctor's ID
         HttpSession session = request.getSession(false);
         User user = (User) session.getAttribute("user");
         int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());

         if (doctorId == 0) {
             // Doctor profile not found, redirect to complete profile
             response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
             return;
         }

         // Load doctor dashboard data
         request.setAttribute("totalPatients", doctorDAO.getTotalPatientsByDoctor(doctorId));
         request.setAttribute("weeklyAppointments", appointmentDAO.getWeeklyAppointmentsByDoctor(doctorId));
         request.setAttribute("pendingReports", doctorDAO.getPendingReportsByDoctor(doctorId));
         request.setAttribute("averageRating", doctorDAO.getAverageRatingByDoctor(doctorId));

         // Get today's appointments
         request.setAttribute("todayAppointments", appointmentDAO.getTodayAppointmentsByDoctor(doctorId));
         request.setAttribute("recentPatients", patientDAO.getRecentPatientsByDoctor(doctorId, 4));
         request.setAttribute("upcomingAppointments", appointmentDAO.getUpcomingAppointmentsByDoctor(doctorId, 4));

         // Forward to doctor dashboard
         request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
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