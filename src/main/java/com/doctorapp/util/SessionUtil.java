package com.doctorapp.util;

import java.util.UUID;

import com.doctorapp.model.User;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class for session and cookie management.
 * Provides methods for creating, validating, and managing user sessions and cookies.
 */
public class SessionUtil {

    public static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes in seconds
    public static final int COOKIE_TIMEOUT = 60 * 60; // 1 hour in seconds
    public static final int COOKIE_TIMEOUT_REMEMBER_ME = COOKIE_TIMEOUT * 24 * 7; // 7 days in seconds
    public static final String LOGIN_COOKIE_NAME = "loginToken";

    /**
     * Create a new session for the user
     *
     * @param request  The HTTP request
     * @param response The HTTP response
     * @param user     The authenticated user
     * @param rememberMe Whether to remember the user (extends cookie lifetime)
     * @return The created session
     */
    public static HttpSession createUserSession(HttpServletRequest request, HttpServletResponse response, User user, boolean rememberMe) {
        // Create or get the session
        HttpSession session = request.getSession(true);

        // Set session attributes
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("newLogin", true);

        // Set session timeout
        session.setMaxInactiveInterval(SESSION_TIMEOUT);

        // Create login cookie
        String token = UUID.randomUUID().toString();
        Cookie loginCookie = new Cookie(LOGIN_COOKIE_NAME, token);
        loginCookie.setHttpOnly(true);
        loginCookie.setPath("/");

        // Set cookie timeout based on remember me option
        if (rememberMe) {
            loginCookie.setMaxAge(COOKIE_TIMEOUT_REMEMBER_ME); // 7 days
        } else {
            loginCookie.setMaxAge(COOKIE_TIMEOUT); // 1 hour
        }

        // Add cookie to response
        response.addCookie(loginCookie);

        return session;
    }

    /**
     * Invalidate the user session and remove cookies
     *
     * @param request  The HTTP request
     * @param response The HTTP response
     */
    public static void invalidateUserSession(HttpServletRequest request, HttpServletResponse response) {
        // Invalidate the session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Remove the login cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (LOGIN_COOKIE_NAME.equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setPath("/");
                    cookie.setMaxAge(0); // Expire immediately
                    response.addCookie(cookie);
                }
            }
        }
    }

    /**
     * Get the current user from the session
     *
     * @param request The HTTP request
     * @return The current user, or null if not logged in
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }

    /**
     * Check if the user is logged in
     *
     * @param request The HTTP request
     * @return true if the user is logged in, false otherwise
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    /**
     * Check if the user has the specified role
     *
     * @param request The HTTP request
     * @param role    The role to check
     * @return true if the user has the role, false otherwise
     */
    public static boolean hasRole(HttpServletRequest request, String role) {
        User user = getCurrentUser(request);
        return user != null && role.equals(user.getRole());
    }

    /**
     * Refresh the login cookie to extend its expiration
     *
     * @param request  The HTTP request
     * @param response The HTTP response
     */
    public static void refreshLoginCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (LOGIN_COOKIE_NAME.equals(cookie.getName())) {
                    // Create a new cookie with the same value but updated expiration
                    Cookie refreshedCookie = new Cookie(LOGIN_COOKIE_NAME, cookie.getValue());
                    refreshedCookie.setHttpOnly(true);
                    refreshedCookie.setPath("/");
                    refreshedCookie.setMaxAge(COOKIE_TIMEOUT);
                    response.addCookie(refreshedCookie);
                    break;
                }
            }
        }
    }
}
