<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
     // Redirect to the patient dashboard servlet
     response.sendRedirect(request.getContextPath() + "/patient/dashboard");
 %>