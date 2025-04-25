package com.doctorapp.controller.admin;

import java.io.IOException;
import java.util.List;

import com.doctorapp.model.DoctorRegistrationRequest;
import com.doctorapp.model.User;
import com.doctorapp.service.DoctorRegistrationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle doctor registration requests in the admin dashboard
 */
@WebServlet(urlPatterns = {
    "/admin/doctor-requests",
    "/admin/doctor-request/view",
    "/admin/doctor-request/approve",
    "/admin/doctor-request/reject"
})
public class DoctorRequestsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorRegistrationService doctorRegistrationService;

    @Override
    public void init() {
        doctorRegistrationService = new DoctorRegistrationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        // Check if user is logged in and is an admin
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

        // Route to appropriate handler based on path
        if (path.equals("/admin/doctor-requests")) {
            listDoctorRequests(request, response);
        } else if (path.equals("/admin/doctor-request/view")) {
            viewDoctorRequest(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        // Check if user is logged in and is an admin
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

        // Route to appropriate handler based on path
        if (path.equals("/admin/doctor-request/approve")) {
            approveDoctorRequest(request, response);
        } else if (path.equals("/admin/doctor-request/reject")) {
            rejectDoctorRequest(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");
        }
    }

    /**
     * List all doctor registration requests
     */
    private void listDoctorRequests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<DoctorRegistrationRequest> requests = doctorRegistrationService.getAllRequests();
        request.setAttribute("requests", requests);
        request.getRequestDispatcher("/admin/doctor-requests.jsp").forward(request, response);
    }

    /**
     * View a specific doctor registration request
     */
    private void viewDoctorRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            DoctorRegistrationRequest doctorRequest = doctorRegistrationService.getRequestById(id);

            if (doctorRequest == null) {
                request.setAttribute("error", "Doctor request not found");
                request.getRequestDispatcher("/admin/doctor-requests.jsp").forward(request, response);
                return;
            }

            request.setAttribute("doctorRequest", doctorRequest);
            request.getRequestDispatcher("/admin/doctor-request-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");
        }
    }

    /**
     * Approve a doctor registration request
     */
    private void approveDoctorRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String adminNotes = request.getParameter("adminNotes");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            // Get the request details before approval
            DoctorRegistrationRequest doctorRequest = doctorRegistrationService.getRequestById(id);

            if (doctorRequest != null && "PENDING".equals(doctorRequest.getStatus())) {
                boolean success = doctorRegistrationService.approveRequest(id, adminNotes);

                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("message", "Doctor registration approved and account created successfully! Request has been removed from the system.");
                } else {
                    session.setAttribute("error", "Failed to approve doctor registration request. Please try again.");
                }
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Invalid request or request is not in PENDING state.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");
        }
    }

    /**
     * Reject a doctor registration request
     */
    private void rejectDoctorRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String adminNotes = request.getParameter("adminNotes");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            // Get the request details before rejection
            DoctorRegistrationRequest doctorRequest = doctorRegistrationService.getRequestById(id);

            if (doctorRequest != null && "PENDING".equals(doctorRequest.getStatus())) {
                boolean success = doctorRegistrationService.rejectRequest(id, adminNotes);

                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("message", "Doctor registration request rejected and removed from the system successfully!");
                } else {
                    session.setAttribute("error", "Failed to reject doctor registration request. Please try again.");
                }
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Invalid request or request is not in PENDING state.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/doctor-requests");
        }
    }
}
