<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect to the new doctor dashboard
    response.sendRedirect(request.getContextPath() + "/doctor/index.jsp");
%>
