<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag import="com.doctorapp.util.SessionUtil" %>
<%@ tag import="com.doctorapp.model.User" %>
<%@ attribute name="role" required="false" %>
<%@ attribute name="redirectUrl" required="false" %>

<%
    // Check if user is logged in
    User currentUser = SessionUtil.getCurrentUser(request);
    boolean isLoggedIn = (currentUser != null);
    
    // Check if user has the required role (if specified)
    boolean hasRequiredRole = true;
    if (role != null && !role.isEmpty()) {
        hasRequiredRole = isLoggedIn && role.equals(currentUser.getRole());
    }
    
    // If not logged in or doesn't have required role, redirect
    if (!isLoggedIn || !hasRequiredRole) {
        String redirectTo = redirectUrl != null ? redirectUrl : request.getContextPath() + "/login";
        response.sendRedirect(redirectTo);
        return;
    }
%>
