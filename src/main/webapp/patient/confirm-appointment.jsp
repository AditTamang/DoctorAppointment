<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.DoctorDAO" %>
<%@ page import="com.doctorapp.dao.PatientDAO" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.dao.AppointmentDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Appointment | HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .booking-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .booking-header {
            background-color: #4285f4;
            color: white;
            padding: 20px;
            text-align: center;
        }
        .booking-header h2 {
            margin: 0;
            font-size: 24px;
        }
        .booking-steps {
            display: flex;
            justify-content: space-between;
            padding: 20px;
            background-color: #f9f9f9;
            border-bottom: 1px solid #eee;
        }
        .step {
            display: flex;
            align-items: center;
            position: relative;
            flex: 1;
            text-align: center;
            justify-content: center;
        }
        .step:not(:last-child):after {
            content: '';
            position: absolute;
            right: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 100%;
            height: 2px;
            background-color: #ddd;
            z-index: 1;
        }
        .step-number {
            width: 30px;
            height: 30px;
            background-color: #ddd;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 10px;
            z-index: 2;
        }
        .step.active .step-number {
            background-color: #4285f4;
            color: white;
        }
        .step.completed .step-number {
            background-color: #34a853;
            color: white;
        }
        .step-label {
            font-weight: 500;
            z-index: 2;
        }
        .booking-body {
            padding: 30px;
        }
        .booking-section {
            margin-bottom: 30px;
        }
        .booking-section h3 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #333;
            font-size: 18px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .form-row {
            display: flex;
            margin-bottom: 15px;
            gap: 15px;
        }
        .form-col {
            flex: 1;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #555;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }
        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .summary-item:last-child {
            border-bottom: none;
            font-weight: bold;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #ddd;
        }
        .booking-footer {
            padding: 20px;
            background-color: #f9f9f9;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: space-between;
        }
        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-primary {
            background-color: #4285f4;
            color: white;
            border: none;
        }
        .btn-primary:hover {
            background-color: #3367d6;
        }
        .btn-secondary {
            background-color: #f1f1f1;
            color: #333;
            border: 1px solid #ddd;
        }
        .btn-secondary:hover {
            background-color: #e5e5e5;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get doctor ID from request parameter
        String doctorIdStr = request.getParameter("doctorId");
        int doctorId = 0;

        try {
            doctorId = Integer.parseInt(doctorIdStr);
        } catch (NumberFormatException e) {
            // Invalid doctor ID
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            return;
        }

        // Get doctor details
        DoctorDAO doctorDAO = new DoctorDAO();
        Doctor doctor = doctorDAO.getDoctorById(doctorId);

        if (doctor == null) {
            // Doctor not found
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            return;
        }

        // Get patient ID
        PatientDAO patientDAO = new PatientDAO();
        int patientId = patientDAO.getPatientIdByUserId(currentUser.getId());

        if (patientId == 0) {
            // Patient not found
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            return;
        }

        // Process form submission
        String errorMessage = null;
        String successMessage = null;

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Get form data
            String appointmentDateStr = request.getParameter("appointmentDate");
            String appointmentTime = request.getParameter("appointmentTime");
            String reason = request.getParameter("reason");
            String notes = request.getParameter("notes");

            // Validate form data
            if (appointmentDateStr == null || appointmentDateStr.isEmpty() ||
                appointmentTime == null || appointmentTime.isEmpty() ||
                reason == null || reason.isEmpty()) {
                errorMessage = "Please fill in all required fields.";
            } else {
                try {
                    // Parse appointment date
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date appointmentDate = dateFormat.parse(appointmentDateStr);

                    // Create appointment object
                    Appointment appointment = new Appointment();
                    appointment.setPatientId(patientId);
                    appointment.setDoctorId(doctorId);
                    appointment.setAppointmentDate(appointmentDate);
                    appointment.setAppointmentTime(appointmentTime);
                    appointment.setReason(reason);
                    appointment.setSymptoms(reason); // Set symptoms same as reason for now
                    appointment.setNotes(notes);
                    appointment.setStatus("PENDING");

                    // Set fee from doctor's consultation fee
                    if (doctor.getConsultationFee() != null && !doctor.getConsultationFee().isEmpty()) {
                        try {
                            double fee = Double.parseDouble(doctor.getConsultationFee());
                            appointment.setFee(fee);
                        } catch (NumberFormatException e) {
                            appointment.setFee(0.0);
                        }
                    } else {
                        appointment.setFee(0.0);
                    }

                    // Book appointment
                    AppointmentDAO appointmentDAO = new AppointmentDAO();

                    // Add debug logging
                    System.out.println("Attempting to book appointment with data:");
                    System.out.println("Patient ID: " + appointment.getPatientId());
                    System.out.println("Doctor ID: " + appointment.getDoctorId());
                    System.out.println("Date: " + appointment.getAppointmentDate());
                    System.out.println("Time: " + appointment.getAppointmentTime());
                    System.out.println("Reason: " + appointment.getReason());
                    System.out.println("Symptoms: " + appointment.getSymptoms());
                    System.out.println("Notes: " + appointment.getNotes());
                    System.out.println("Status: " + appointment.getStatus());
                    System.out.println("Fee: " + appointment.getFee());

                    // Ensure all required fields are set
                    if (appointment.getPatientId() <= 0) {
                        System.out.println("ERROR: Invalid patient ID: " + appointment.getPatientId());
                        errorMessage = "Invalid patient ID. Please try again.";
                    } else if (appointment.getDoctorId() <= 0) {
                        System.out.println("ERROR: Invalid doctor ID: " + appointment.getDoctorId());
                        errorMessage = "Invalid doctor ID. Please try again.";
                    } else if (appointment.getAppointmentDate() == null) {
                        System.out.println("ERROR: Appointment date is null");
                        errorMessage = "Please select a valid appointment date.";
                    } else if (appointment.getAppointmentTime() == null || appointment.getAppointmentTime().isEmpty()) {
                        System.out.println("ERROR: Appointment time is null or empty");
                        errorMessage = "Please select a valid appointment time.";
                    } else {
                        boolean booked = appointmentDAO.bookAppointment(appointment);

                        if (booked) {
                            // Set success message
                            successMessage = "Appointment booked successfully!";

                            // Set appointment in session for confirmation page
                            session.setAttribute("appointment", appointment);

                            // Set doctor in session for confirmation page
                            session.setAttribute("doctor", doctor);

                            // Redirect to confirmation page
                            response.sendRedirect(request.getContextPath() + "/patient/appointmentConfirmation.jsp");
                            return;
                        } else {
                            errorMessage = "Failed to book appointment. Please try again.";
                            System.out.println("Failed to book appointment. AppointmentDAO.bookAppointment returned false.");
                        }
                    }
                } catch (ParseException e) {
                    errorMessage = "Invalid appointment date format.";
                }
            }
        }
    %>

    <div class="container">
        <div class="booking-container">
            <div class="booking-header">
                <h2>Book an Appointment</h2>
            </div>

            <div class="booking-steps">
                <div class="step completed">
                    <div class="step-number">1</div>
                    <div class="step-label">Select Doctor</div>
                </div>
                <div class="step completed">
                    <div class="step-number">2</div>
                    <div class="step-label">Choose Date & Time</div>
                </div>
                <div class="step active">
                    <div class="step-number">3</div>
                    <div class="step-label">Confirm Details</div>
                </div>
            </div>

            <div class="booking-body">
                <% if (errorMessage != null) { %>
                <div class="alert alert-danger">
                    <%= errorMessage %>
                </div>
                <% } %>

                <% if (successMessage != null) { %>
                <div class="alert alert-success">
                    <%= successMessage %>
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/patient/confirm-appointment.jsp" method="post">
                    <input type="hidden" name="doctorId" value="<%= doctorId %>">

                    <div class="booking-section">
                        <h3>Appointment Details</h3>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="name">Patient Name</label>
                                    <input type="text" class="form-control" id="name" value="<%= currentUser.getFirstName() + " " + currentUser.getLastName() %>" readonly>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="email">Email</label>
                                    <input type="email" class="form-control" id="email" value="<%= currentUser.getEmail() %>" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="phone">Phone</label>
                                    <input type="tel" class="form-control" id="phone" value="<%= currentUser.getPhone() != null ? currentUser.getPhone() : "" %>" readonly>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="appointmentDate">Appointment Date</label>
                                    <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="appointmentTime">Appointment Time</label>
                                    <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="doctor">Doctor</label>
                                    <input type="text" class="form-control" id="doctor" value="Dr. <%= doctor.getFirstName() + " " + doctor.getLastName() %>" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="reason">Reason for Visit</label>
                            <textarea class="form-control" id="reason" name="reason" rows="3" placeholder="Please describe your symptoms or reason for the appointment" required></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="notes">Additional Notes</label>
                            <textarea class="form-control" id="notes" name="notes" rows="2" placeholder="Any additional information you want to provide"></textarea>
                        </div>
                    </div>

                    <div class="booking-section">
                        <h3>Payment Summary</h3>

                        <div class="summary-item">
                            <div class="summary-label">Consultation Fee</div>
                            <div class="summary-value">$<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "0.00" %></div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Booking Fee</div>
                            <div class="summary-value">$5.00</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Tax</div>
                            <div class="summary-value">$<%= String.format("%.2f", (doctor.getConsultationFee() != null && !doctor.getConsultationFee().isEmpty() ? Double.parseDouble(doctor.getConsultationFee()) * 0.1 : 0.0)) %></div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Total</div>
                            <div class="summary-value">$<%= String.format("%.2f", (doctor.getConsultationFee() != null && !doctor.getConsultationFee().isEmpty() ? Double.parseDouble(doctor.getConsultationFee()) + 5.0 + (Double.parseDouble(doctor.getConsultationFee()) * 0.1) : 5.0)) %></div>
                        </div>
                    </div>

                    <div class="booking-footer">
                        <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">Confirm Booking</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
