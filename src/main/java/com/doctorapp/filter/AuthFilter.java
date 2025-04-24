package com.doctorapp.filter;

import java.io.IOException;

import com.doctorapp.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Authentication and authorization filter for the Doctor Appointment System.
 * This filter protects resources that require authentication and enforces role-based access control.
 */
@WebFilter(urlPatterns = {
    "/dashboard", 
    "/profile", 
    "/appointments", 
    "/appointment/*", 
    "/doctor/appointments", 
    "/admin/*"
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code, if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Get the current session without creating a new one
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        // Get the requested URL
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // If user is not logged in and trying to access a protected resource
        if (!isLoggedIn) {
            // Redirect to login page with the original request URL as a parameter
            httpResponse.sendRedirect(contextPath + "/login?redirect=" + requestURI);
            return;
        }
        
        // For role-based access control
        User user = (User) session.getAttribute("user");
        
        // Admin area protection
        if (requestURI.contains("/admin/") || requestURI.startsWith(contextPath + "/admin/")) {
            if (!"ADMIN".equals(user.getRole())) {
                // Redirect to dashboard if not an admin
                httpResponse.sendRedirect(contextPath + "/dashboard");
                return;
            }
        }
        
        // Doctor area protection
        if (requestURI.contains("/doctor/") || requestURI.startsWith(contextPath + "/doctor/")) {
            if (!"DOCTOR".equals(user.getRole()) && !"ADMIN".equals(user.getRole())) {
                // Redirect to dashboard if not a doctor or admin
                httpResponse.sendRedirect(contextPath + "/dashboard");
                return;
            }
        }
        
        // Patient area protection
        if (requestURI.contains("/patient/") || requestURI.startsWith(contextPath + "/patient/")) {
            if (!"PATIENT".equals(user.getRole()) && !"ADMIN".equals(user.getRole())) {
                // Redirect to dashboard if not a patient or admin
                httpResponse.sendRedirect(contextPath + "/dashboard");
                return;
            }
        }
        
        // Continue the filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code, if needed
    }
}
