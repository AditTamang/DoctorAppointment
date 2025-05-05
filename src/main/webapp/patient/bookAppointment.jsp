<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Redirect to the new dynamic booking page
    String redirectUrl = request.getContextPath() + "/patient/dynamic-booking";

    // Preserve any query parameters
    String queryString = request.getQueryString();
    if (queryString != null && !queryString.isEmpty()) {
        redirectUrl += "?" + queryString;
    }

    response.sendRedirect(redirectUrl);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Redirecting to Appointment Booking</title>
</head>
<body>
    <p>Redirecting to the appointment booking page...</p>
    <script>
        // Redirect to the dynamic booking page
        window.location.href = "<%= redirectUrl %>";
    </script>
</body>
</html>
