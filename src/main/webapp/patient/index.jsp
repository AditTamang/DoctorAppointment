<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
     // Prevent redirect loops by checking referer
     String referer = request.getHeader("Referer");
     String currentURL = request.getRequestURL().toString();

     System.out.println("Patient index.jsp called - Referer: " + referer + ", Current: " + currentURL);

     // Only redirect if not coming from dashboard to prevent loops
     if (referer == null || !referer.contains("/patient/dashboard")) {
         System.out.println("Patient index.jsp: Redirecting to dashboard");
         response.sendRedirect(request.getContextPath() + "/patient/dashboard");
     } else {
         System.out.println("Patient index.jsp: Preventing redirect loop");
         // Just show a simple message instead of redirecting
         out.println("<html><body><h3>Patient Dashboard</h3><p>Loading...</p><script>window.location.href='" + request.getContextPath() + "/patient/dashboard';</script></body></html>");
     }
 %>