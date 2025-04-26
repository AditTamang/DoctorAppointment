<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="doctorapp" uri="http://doctorapp.com/tags" %>

<%-- This will check if the user is logged in, if not redirect to login page --%>
<doctorapp:auth />

<%-- This will check if the user is logged in AND has the ADMIN role, if not redirect to login page --%>
<%-- <doctorapp:auth role="ADMIN" /> --%>

<%-- This will check if the user is logged in AND has the DOCTOR role, if not redirect to the specified URL --%>
<%-- <doctorapp:auth role="DOCTOR" redirectUrl="${pageContext.request.contextPath}/access-denied.jsp" /> --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Protected Page</title>
</head>
<body>
    <h1>Protected Content</h1>
    <p>This content is only visible to logged-in users.</p>
    
    <p>Current user: ${sessionScope.user.username}</p>
    <p>Role: ${sessionScope.user.role}</p>
    
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</body>
</html>
