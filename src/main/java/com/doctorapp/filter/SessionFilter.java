package com.doctorapp.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import com.doctorapp.model.User;
import com.doctorapp.util.SessionUtil;

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
 * Comprehensive filter to manage sessions, cookies, authentication, and authorization.
 * This filter handles session validation, cookie management, and role-based access control.
 */
@WebFilter(filterName = "SessionFilter", urlPatterns = {"/*"})
public class SessionFilter implements Filter {

    // List of paths that don't require authentication
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/", "/login", "/register", "/logout", "/index.jsp", "/login.jsp", "/register.jsp",
            "/about-us", "/contact-us", "/doctors", "/assets/", "/error.jsp", "/404.jsp",
            "/index", "/home", "/css/", "/js/", "/images/", "/fonts/"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getServletPath();
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Special handling for root context - always allow access
        if (requestURI.equals(contextPath) || requestURI.equals(contextPath + "/")) {
            chain.doFilter(request, response);
            return;
        }

        // Allow access to public resources without authentication
        if (isPublicResource(path, httpRequest)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is authenticated
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = SessionUtil.isLoggedIn(httpRequest);

        if (isLoggedIn) {
            User user = SessionUtil.getCurrentUser(httpRequest);

            // Refresh the session and cookie
            SessionUtil.refreshLoginCookie(httpRequest, httpResponse);
            session.setMaxInactiveInterval(SessionUtil.SESSION_TIMEOUT);

            // Check if this is a new login and handle accordingly
            if (session.getAttribute("newLogin") != null && (Boolean) session.getAttribute("newLogin")) {
                // Remove the new login flag
                session.removeAttribute("newLogin");
            }

            // Role-based access control
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

            // Handle dashboard access based on role
            if (requestURI.endsWith("/dashboard") || requestURI.equals(contextPath + "/dashboard")) {
                // Redirect to role-specific dashboard if accessing the general dashboard
                if ("ADMIN".equals(user.getRole())) {
                    httpResponse.sendRedirect(contextPath + "/admin/index.jsp");
                    return;
                } else if ("DOCTOR".equals(user.getRole())) {
                    httpResponse.sendRedirect(contextPath + "/doctor/doctorDashboard.jsp");
                    return;
                } else if ("PATIENT".equals(user.getRole())) {
                    httpResponse.sendRedirect(contextPath + "/patient/patientDashboard.jsp");
                    return;
                }
            }

            // Continue with the request
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            String loginURL = httpRequest.getContextPath() + "/login";
            String redirectParam = "?redirect=" + httpRequest.getRequestURI();

            // Add query string if present
            if (httpRequest.getQueryString() != null) {
                redirectParam += "?" + httpRequest.getQueryString();
            }

            httpResponse.sendRedirect(loginURL + redirectParam);
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }

    /**
     * Check if the requested resource is public (doesn't require authentication)
     */
    private boolean isPublicResource(String path, HttpServletRequest request) {
        // Check if this is the root context or empty path
        if (path == null || path.isEmpty() || "/".equals(path)) {
            return true;
        }

        // Check if the path is in the public paths list
        for (String publicPath : PUBLIC_PATHS) {
            if (path.equals(publicPath) || (publicPath != null && path.startsWith(publicPath))) {
                return true;
            }
        }

        // Check for static resources
        if (path.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$")) {
            return true;
        }

        // Check if this is a welcome file (index.jsp or index.html)
        if (path.endsWith("/index.jsp") || path.endsWith("/index.html")) {
            return true;
        }

        // Check if this is the context root with no path
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        if (requestURI.equals(contextPath) || requestURI.equals(contextPath + "/")) {
            return true;
        }

        return false;
    }
}
