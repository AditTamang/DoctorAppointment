package com.doctorapp.filter;

import java.io.IOException;
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

import com.doctorapp.model.User;

/**
 * Authentication and authorization filter for the application.
 * This filter checks if the user is logged in and has the appropriate role
 * for accessing protected resources.
 */
@WebFilter(urlPatterns = {
    "/admin/*",
    "/doctor/*",
    "/patient/*",
    "/profile",
    "/appointments",
    "/appointment/*"
},
dispatcherTypes = {
    jakarta.servlet.DispatcherType.REQUEST,
    jakarta.servlet.DispatcherType.FORWARD
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();

        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (!isLoggedIn) {
            // Save the requested URL for redirect after login
            httpRequest.getSession().setAttribute("redirectAfterLogin", requestURI.substring(httpRequest.getContextPath().length()));
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=Please login to access this page");
            return;
        }

        // User is logged in, check role-based access
        User user = (User) session.getAttribute("user");
        if (user == null) {
            // This shouldn't happen, but just in case
            httpRequest.getSession().setAttribute("redirectAfterLogin", requestURI.substring(httpRequest.getContextPath().length()));
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=Session expired. Please login again.");
            return;
        }
        String userRole = user.getRole();

        // Check admin area access
        if (requestURI.contains("/admin/") && !"ADMIN".equals(userRole)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
            return;
        }

        // Check doctor area access
        if (requestURI.contains("/doctor/") && !"DOCTOR".equals(userRole) && !"ADMIN".equals(userRole)) {
            // Allow access to doctor/details for all authenticated users
            if (!requestURI.contains("/doctor/details")) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
                return;
            }
        }

        // Check patient area access
        if (requestURI.contains("/patient/") && !"PATIENT".equals(userRole)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
            return;
        }

        // Continue with the request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
