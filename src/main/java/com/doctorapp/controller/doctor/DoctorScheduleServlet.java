package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.sql.Time;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.model.User;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.DoctorSchedule;
import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.dao.DoctorScheduleDAO;

/**
 * Servlet to handle doctor schedule operations
 */
@WebServlet(urlPatterns = {
    "/doctor/schedule",
    "/doctor/schedule/add",
    "/doctor/schedule/update",
    "/doctor/schedule/delete"
})
public class DoctorScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DoctorDAO doctorDAO;
    private DoctorScheduleDAO scheduleDAO;
    
    public void init() {
        doctorDAO = new DoctorDAO();
        scheduleDAO = new DoctorScheduleDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Check if user is logged in and is a doctor
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        // Get doctor information
        Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=profile_not_found");
            return;
        }
        
        // Get doctor schedules
        List<DoctorSchedule> schedules = scheduleDAO.getSchedulesByDoctorId(doctor.getId());
        request.setAttribute("schedules", schedules);
        request.setAttribute("doctor", doctor);
        
        // Forward to the schedule management page
        request.getRequestDispatcher("/doctor/schedule.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Check if user is logged in and is a doctor
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        // Get doctor information
        Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=profile_not_found");
            return;
        }
        
        // Handle different operations based on the path
        if (path.equals("/doctor/schedule/add")) {
            addSchedule(request, response, doctor.getId());
        } else if (path.equals("/doctor/schedule/update")) {
            updateSchedule(request, response);
        } else if (path.equals("/doctor/schedule/delete")) {
            deleteSchedule(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
        }
    }
    
    /**
     * Add a new schedule for a doctor
     */
    private void addSchedule(HttpServletRequest request, HttpServletResponse response, int doctorId) throws IOException {
        try {
            // Get parameters from the request
            String dayOfWeek = request.getParameter("dayOfWeek");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String breakStartTimeStr = request.getParameter("breakStartTime");
            String breakEndTimeStr = request.getParameter("breakEndTime");
            String maxAppointmentsStr = request.getParameter("maxAppointments");
            
            // Validate required parameters
            if (dayOfWeek == null || startTimeStr == null || endTimeStr == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=missing_fields");
                return;
            }
            
            // Check if a schedule already exists for this day
            if (scheduleDAO.hasScheduleForDay(doctorId, dayOfWeek)) {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=schedule_exists");
                return;
            }
            
            // Create a new schedule
            DoctorSchedule schedule = new DoctorSchedule();
            schedule.setDoctorId(doctorId);
            schedule.setDayOfWeek(dayOfWeek);
            schedule.setStartTime(Time.valueOf(startTimeStr + ":00"));
            schedule.setEndTime(Time.valueOf(endTimeStr + ":00"));
            
            // Set optional parameters
            if (breakStartTimeStr != null && !breakStartTimeStr.isEmpty()) {
                schedule.setBreakStartTime(Time.valueOf(breakStartTimeStr + ":00"));
            }
            
            if (breakEndTimeStr != null && !breakEndTimeStr.isEmpty()) {
                schedule.setBreakEndTime(Time.valueOf(breakEndTimeStr + ":00"));
            }
            
            if (maxAppointmentsStr != null && !maxAppointmentsStr.isEmpty()) {
                schedule.setMaxAppointments(Integer.parseInt(maxAppointmentsStr));
            } else {
                schedule.setMaxAppointments(20); // Default value
            }
            
            // Add the schedule to the database
            boolean success = scheduleDAO.addSchedule(schedule);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?success=added");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=add_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=exception&message=" + e.getMessage());
        }
    }
    
    /**
     * Update an existing schedule
     */
    private void updateSchedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Get parameters from the request
            String scheduleIdStr = request.getParameter("scheduleId");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String breakStartTimeStr = request.getParameter("breakStartTime");
            String breakEndTimeStr = request.getParameter("breakEndTime");
            String maxAppointmentsStr = request.getParameter("maxAppointments");
            
            // Validate required parameters
            if (scheduleIdStr == null || startTimeStr == null || endTimeStr == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=missing_fields");
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdStr);
            
            // Get the existing schedule
            DoctorSchedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=schedule_not_found");
                return;
            }
            
            // Update the schedule
            schedule.setStartTime(Time.valueOf(startTimeStr + ":00"));
            schedule.setEndTime(Time.valueOf(endTimeStr + ":00"));
            
            // Set optional parameters
            if (breakStartTimeStr != null && !breakStartTimeStr.isEmpty()) {
                schedule.setBreakStartTime(Time.valueOf(breakStartTimeStr + ":00"));
            } else {
                schedule.setBreakStartTime(null);
            }
            
            if (breakEndTimeStr != null && !breakEndTimeStr.isEmpty()) {
                schedule.setBreakEndTime(Time.valueOf(breakEndTimeStr + ":00"));
            } else {
                schedule.setBreakEndTime(null);
            }
            
            if (maxAppointmentsStr != null && !maxAppointmentsStr.isEmpty()) {
                schedule.setMaxAppointments(Integer.parseInt(maxAppointmentsStr));
            }
            
            // Update the schedule in the database
            boolean success = scheduleDAO.updateSchedule(schedule);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=update_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=exception&message=" + e.getMessage());
        }
    }
    
    /**
     * Delete a schedule
     */
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Get the schedule ID from the request
            String scheduleIdStr = request.getParameter("scheduleId");
            
            if (scheduleIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=missing_id");
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdStr);
            
            // Delete the schedule
            boolean success = scheduleDAO.deleteSchedule(scheduleId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=delete_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=exception&message=" + e.getMessage());
        }
    }
}
