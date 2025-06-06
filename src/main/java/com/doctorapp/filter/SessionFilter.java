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

        // Always create a session if it doesn't exist
        HttpSession session = httpRequest.getSession(true);

        // Only log for patient dashboard to avoid spam
        if (path.contains("/patient/dashboard")) {
            System.out.println("SessionFilter: Path: " + path + ", Session ID: " + session.getId() + ", URI: " + requestURI);
        }

        // Check if user is authenticated
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
                    // Redirect to appropriate dashboard if not an admin
                    if ("PATIENT".equals(user.getRole())) {
                        httpResponse.sendRedirect(contextPath + "/patient/dashboard");
                    } else if ("DOCTOR".equals(user.getRole())) {
                        httpResponse.sendRedirect(contextPath + "/doctor/dashboard");
                    } else {
                        httpResponse.sendRedirect(contextPath + "/login");
                    }
                    return;
                }
            }

            // Doctor area protection
            if (requestURI.contains("/doctor/") || requestURI.startsWith(contextPath + "/doctor/")) {
                // If the user is a doctor and accessing doctor dashboard or related resources, allow access
                if ("DOCTOR".equals(user.getRole())) {
                    // Allow access to all doctor resources for doctors
                    chain.doFilter(request, response);
                    return;
                } else if ("ADMIN".equals(user.getRole())) {
                    // Allow access to doctor resources for admins
                    chain.doFilter(request, response);
                    return;
                } else {
                    // Redirect to appropriate dashboard if not a doctor or admin
                    if ("PATIENT".equals(user.getRole())) {
                        httpResponse.sendRedirect(contextPath + "/patient/dashboard");
                    } else {
                        httpResponse.sendRedirect(contextPath + "/login");
                    }
                    return;
                }
            }

            // Patient area protection
            if (requestURI.contains("/patient/") || requestURI.startsWith(contextPath + "/patient/")) {
                if (!"PATIENT".equals(user.getRole()) && !"ADMIN".equals(user.getRole())) {
                    // Redirect to appropriate dashboard if not a patient or admin
                    if ("DOCTOR".equals(user.getRole())) {
                        httpResponse.sendRedirect(contextPath + "/doctor/dashboard");
                    } else {
                        httpResponse.sendRedirect(contextPath + "/login");
                    }
                    return;
                }
            }

            // Handle dashboard access based on role
            if (requestURI.equals(contextPath + "/redirect-dashboard")) {
                // Only redirect if accessing the main /redirect-dashboard URL directly
                // This prevents redirects when forwarding from role-specific dashboards

                // Redirect to role-specific dashboard if accessing the general dashboard
                if ("ADMIN".equals(user.getRole())) {
                    httpResponse.sendRedirect(contextPath + "/admin/dashboard");
                    return;
                } else if ("DOCTOR".equals(user.getRole())) {
                    httpResponse.sendRedirect(contextPath + "/doctor/dashboard");
                    return;
                } else if ("PATIENT".equals(user.getRole())) {
                    httpResponse.sendRedirect(contextPath + "/patient/dashboard");
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
