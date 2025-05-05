<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.DoctorDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-booking.css">
    <style>
        /* Additional styles for dynamic calendar */
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 5px;
        }

        .calendar-day {
            padding: 10px;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .calendar-day:hover:not(.disabled) {
            background-color: #e6f7f7;
        }

        .calendar-day.disabled {
            color: #ccc;
            cursor: not-allowed;
        }

        .calendar-day.today {
            background-color: #e6f7f7;
            font-weight: bold;
        }

        .calendar-day.selected {
            background-color: #3CCFCF;
            color: white;
        }

        .time-slots {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }

        .time-slot {
            padding: 8px 15px;
            background-color: #f5f5f5;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .time-slot:hover:not(.disabled) {
            background-color: #e6f7f7;
        }

        .time-slot.disabled {
            color: #ccc;
            cursor: not-allowed;
            background-color: #f9f9f9;
        }

        .time-slot.selected {
            background-color: #3CCFCF;
            color: white;
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

        // Get all doctors
        DoctorDAO doctorDAO = new DoctorDAO();
        List<Doctor> doctors = doctorDAO.getAllDoctors();

        // Get selected doctor if any
        String doctorIdStr = request.getParameter("doctorId");
        Doctor selectedDoctor = null;
        if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
            try {
                int doctorId = Integer.parseInt(doctorIdStr);
                selectedDoctor = doctorDAO.getDoctorById(doctorId);
            } catch (NumberFormatException e) {
                // Invalid doctor ID
            }
        }

        // Get current step
        String stepStr = request.getParameter("step");
        int currentStep = 1;
        if (stepStr != null && !stepStr.isEmpty()) {
            try {
                currentStep = Integer.parseInt(stepStr);
                if (currentStep < 1 || currentStep > 3) {
                    currentStep = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid step
            }
        }

        // Get current date for calendar
        Calendar calendar = Calendar.getInstance();
        int currentYear = calendar.get(Calendar.YEAR);
        int currentMonth = calendar.get(Calendar.MONTH);
        int currentDay = calendar.get(Calendar.DAY_OF_MONTH);

        // Get month and year from parameters if provided
        String monthStr = request.getParameter("month");
        String yearStr = request.getParameter("year");

        if (monthStr != null && yearStr != null) {
            try {
                int month = Integer.parseInt(monthStr);
                int year = Integer.parseInt(yearStr);
                if (month >= 0 && month <= 11 && year >= currentYear) {
                    currentMonth = month;
                    currentYear = year;
                }
            } catch (NumberFormatException e) {
                // Invalid month or year
            }
        }

        // Set calendar to first day of the month
        calendar.set(currentYear, currentMonth, 1);
        int firstDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
        int daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

        // Format month name
        SimpleDateFormat monthFormat = new SimpleDateFormat("MMMM yyyy");
        String monthName = monthFormat.format(calendar.getTime());

        // Get selected date if any
        String selectedDateStr = request.getParameter("date");
        Date selectedDate = null;
        if (selectedDateStr != null && !selectedDateStr.isEmpty()) {
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                selectedDate = dateFormat.parse(selectedDateStr);
            } catch (Exception e) {
                // Invalid date
            }
        }

        // Get selected time if any
        String selectedTime = request.getParameter("time");
    %>

    <div class="container">
        <div class="booking-container">
            <div class="booking-header">
                <h2>Book an Appointment</h2>
            </div>

            <div class="booking-steps">
                <div class="step <%= currentStep >= 1 ? "active" : "" %> <%= currentStep > 1 ? "completed" : "" %>">
                    <div class="step-number">1</div>
                    <div class="step-label">Select Doctor</div>
                </div>
                <div class="step <%= currentStep >= 2 ? "active" : "" %> <%= currentStep > 2 ? "completed" : "" %>">
                    <div class="step-number">2</div>
                    <div class="step-label">Choose Date & Time</div>
                </div>
                <div class="step <%= currentStep >= 3 ? "active" : "" %>">
                    <div class="step-number">3</div>
                    <div class="step-label">Confirm Details</div>
                </div>
            </div>

            <div class="booking-body">
                <% if (currentStep == 1) { %>
                <!-- Step 1: Select Doctor -->
                <div class="booking-section">
                    <h3>Select a Doctor</h3>

                    <div class="form-group">
                        <label class="form-label" for="specialization">Filter by Specialization</label>
                        <select class="form-control" id="specialization" onchange="filterDoctors()">
                            <option value="">All Specializations</option>
                            <option value="Cardiology">Cardiology</option>
                            <option value="Neurology">Neurology</option>
                            <option value="Orthopedics">Orthopedics</option>
                            <option value="Pediatrics">Pediatrics</option>
                            <option value="Dermatology">Dermatology</option>
                            <option value="Ophthalmology">Ophthalmology</option>
                            <option value="Gynecology">Gynecology</option>
                            <option value="Urology">Urology</option>
                            <option value="Psychiatry">Psychiatry</option>
                            <option value="General Medicine">General Medicine</option>
                        </select>
                    </div>

                    <div class="doctor-list">
                        <% if (doctors != null && !doctors.isEmpty()) {
                            for (Doctor doctor : doctors) { %>
                        <div class="doctor-card" data-specialization="<%= doctor.getSpecialization() %>" onclick="selectDoctor(<%= doctor.getId() %>)">
                            <div class="doctor-header">
                                <div class="doctor-avatar">
                                    <i class="fas fa-user-md"></i>
                                </div>
                                <h3 class="doctor-name">Dr. <%= doctor.getName() %></h3>
                                <div class="doctor-specialization"><%= doctor.getSpecialization() %></div>
                            </div>
                            <div class="doctor-body">
                                <div class="doctor-info">
                                    <i class="fas fa-graduation-cap"></i>
                                    <%= doctor.getQualification() %>
                                </div>
                                <div class="doctor-info">
                                    <i class="fas fa-briefcase"></i>
                                    <%= doctor.getExperience() %> years experience
                                </div>
                                <div class="doctor-info">
                                    <i class="fas fa-dollar-sign"></i>
                                    Consultation Fee: $<%= doctor.getConsultationFee() %>
                                </div>
                                <div class="doctor-rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star-half-alt"></i>
                                    <span>4.5 (120 reviews)</span>
                                </div>
                            </div>
                        </div>
                        <% } } else { %>
                        <p>No doctors available at the moment.</p>
                        <% } %>
                    </div>
                </div>
                <% } else if (currentStep == 2 && selectedDoctor != null) { %>
                <!-- Step 2: Choose Date & Time -->
                <div class="booking-section">
                    <h3>Choose Date & Time</h3>

                    <div class="calendar">
                        <div class="calendar-header">
                            <div class="calendar-title"><%= monthName %></div>
                            <div class="calendar-nav">
                                <button class="calendar-nav-btn" onclick="changeMonth(<%= currentMonth == 0 ? 11 : currentMonth - 1 %>, <%= currentMonth == 0 ? currentYear - 1 : currentYear %>)">
                                    <i class="fas fa-chevron-left"></i>
                                </button>
                                <button class="calendar-nav-btn" onclick="changeMonth(<%= currentMonth == 11 ? 0 : currentMonth + 1 %>, <%= currentMonth == 11 ? currentYear + 1 : currentYear %>)">
                                    <i class="fas fa-chevron-right"></i>
                                </button>
                            </div>
                        </div>

                        <div class="calendar-grid">
                            <div class="calendar-day-header">Sun</div>
                            <div class="calendar-day-header">Mon</div>
                            <div class="calendar-day-header">Tue</div>
                            <div class="calendar-day-header">Wed</div>
                            <div class="calendar-day-header">Thu</div>
                            <div class="calendar-day-header">Fri</div>
                            <div class="calendar-day-header">Sat</div>

                            <%
                            // Add empty cells for days before the first day of the month
                            for (int i = 1; i < firstDayOfWeek; i++) { %>
                                <div class="calendar-day disabled"></div>
                            <% }

                            // Add cells for each day of the month
                            Calendar today = Calendar.getInstance();
                            for (int day = 1; day <= daysInMonth; day++) {
                                Calendar dayCalendar = Calendar.getInstance();
                                dayCalendar.set(currentYear, currentMonth, day);

                                boolean isPast = dayCalendar.before(today) &&
                                                (dayCalendar.get(Calendar.YEAR) != today.get(Calendar.YEAR) ||
                                                 dayCalendar.get(Calendar.MONTH) != today.get(Calendar.MONTH) ||
                                                 dayCalendar.get(Calendar.DAY_OF_MONTH) != today.get(Calendar.DAY_OF_MONTH));

                                boolean isToday = dayCalendar.get(Calendar.YEAR) == today.get(Calendar.YEAR) &&
                                                 dayCalendar.get(Calendar.MONTH) == today.get(Calendar.MONTH) &&
                                                 dayCalendar.get(Calendar.DAY_OF_MONTH) == today.get(Calendar.DAY_OF_MONTH);

                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                String dateStr = dateFormat.format(dayCalendar.getTime());

                                boolean isSelected = false;
                                if (selectedDate != null) {
                                    Calendar selectedCal = Calendar.getInstance();
                                    selectedCal.setTime(selectedDate);
                                    isSelected = dayCalendar.get(Calendar.YEAR) == selectedCal.get(Calendar.YEAR) &&
                                                dayCalendar.get(Calendar.MONTH) == selectedCal.get(Calendar.MONTH) &&
                                                dayCalendar.get(Calendar.DAY_OF_MONTH) == selectedCal.get(Calendar.DAY_OF_MONTH);
                                }

                                String dayClass = isPast ? "calendar-day disabled" :
                                                isToday ? "calendar-day today" :
                                                isSelected ? "calendar-day selected" : "calendar-day";
                            %>
                                <div class="<%= dayClass %>"
                                     <%= !isPast ? "onclick=\"selectDate('" + dateStr + "')\"" : "" %>
                                     data-date="<%= dateStr %>">
                                    <%= day %>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <h3>Available Time Slots</h3>
                    <div class="time-slots" id="timeSlots">
                        <% if (selectedDate != null) {
                            // Get available time slots for the selected doctor and date
                            String[] defaultTimeSlots = {"09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM",
                                                        "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM",
                                                        "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM",
                                                        "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM"};

                            // In a real implementation, you would get booked slots from the database
                            // For now, we'll simulate some booked slots
                            String[] bookedSlots = {"10:00 AM", "10:30 AM", "03:30 PM"};

                            for (String timeSlot : defaultTimeSlots) {
                                boolean isBooked = false;
                                for (String bookedSlot : bookedSlots) {
                                    if (timeSlot.equals(bookedSlot)) {
                                        isBooked = true;
                                        break;
                                    }
                                }

                                boolean isSelected = timeSlot.equals(selectedTime);
                                String timeClass = isBooked ? "time-slot disabled" :
                                                 isSelected ? "time-slot selected" : "time-slot";
                            %>
                                <div class="<%= timeClass %>"
                                     <%= !isBooked ? "onclick=\"selectTime('" + timeSlot + "')\"" : "" %>
                                     data-time="<%= timeSlot %>">
                                    <%= timeSlot %>
                                </div>
                            <% }
                        } else { %>
                            <p>Please select a date to view available time slots.</p>
                        <% } %>
                    </div>
                </div>
                <% } else if (currentStep == 3 && selectedDoctor != null && selectedDate != null && selectedTime != null) { %>
                <!-- Step 3: Confirm Details -->
                <form action="${pageContext.request.contextPath}/appointment/confirm" method="post" id="appointmentForm">
                    <input type="hidden" name="doctorId" value="<%= selectedDoctor.getId() %>">
                    <input type="hidden" name="patientId" value="<%= currentUser.getId() %>">
                    <input type="hidden" name="appointmentDate" value="<%= new SimpleDateFormat("yyyy-MM-dd").format(selectedDate) %>">
                    <input type="hidden" name="appointmentTime" value="<%= selectedTime %>">

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
                                    <input type="tel" class="form-control" id="phone" value="<%= currentUser.getPhone() %>" readonly>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="date">Appointment Date</label>
                                    <input type="text" class="form-control" id="date" value="<%= new SimpleDateFormat("MMMM d, yyyy").format(selectedDate) %>" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="time">Appointment Time</label>
                                    <input type="text" class="form-control" id="time" value="<%= selectedTime %>" readonly>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label class="form-label" for="doctor">Doctor</label>
                                    <input type="text" class="form-control" id="doctor" value="Dr. <%= selectedDoctor.getName() %>" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="reason">Reason for Visit</label>
                            <textarea class="form-control" id="reason" name="reason" rows="3" placeholder="Please describe your symptoms or reason for the appointment" required></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="symptoms">Symptoms</label>
                            <textarea class="form-control" id="symptoms" name="symptoms" rows="2" placeholder="Describe your symptoms in detail"></textarea>
                        </div>
                    </div>

                    <div class="booking-section">
                        <h3>Payment Summary</h3>

                        <div class="summary-item">
                            <div class="summary-label">Consultation Fee</div>
                            <div class="summary-value">$<%= selectedDoctor.getConsultationFee() %></div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Booking Fee</div>
                            <div class="summary-value">$5.00</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Tax</div>
                            <div class="summary-value">$<%
                                String taxValue = "0.00";
                                try {
                                    taxValue = String.format("%.2f", Double.parseDouble(selectedDoctor.getConsultationFee()) * 0.1);
                                } catch (NumberFormatException e) {
                                    // Use default value if parsing fails
                                }
                                out.print(taxValue);
                            %></div>
                        </div>
                        <div class="summary-item total">
                            <div class="summary-label">Total</div>
                            <div class="summary-value">$<%
                                String totalValue = "5.00";
                                try {
                                    double fee = Double.parseDouble(selectedDoctor.getConsultationFee());
                                    totalValue = String.format("%.2f", fee + 5.0 + (fee * 0.1));
                                } catch (NumberFormatException e) {
                                    // Use default value if parsing fails
                                }
                                out.print(totalValue);
                            %></div>
                        </div>

                        <input type="hidden" name="fee" value="<%
                            String feeValue = "0.00";
                            try {
                                feeValue = selectedDoctor.getConsultationFee();
                            } catch (Exception e) {
                                // Use default value if any error occurs
                            }
                            out.print(feeValue);
                        %>">
                    </div>
                </form>
                <% } else { %>
                <div class="booking-section">
                    <p>Please select a doctor to continue.</p>
                    <a href="?step=1" class="btn btn-primary">Go Back</a>
                </div>
                <% } %>
            </div>

            <div class="booking-footer">
                <% if (currentStep > 1) { %>
                <a href="?step=<%= currentStep - 1 %><%= selectedDoctor != null ? "&doctorId=" + selectedDoctor.getId() : "" %><%= selectedDate != null ? "&date=" + new SimpleDateFormat("yyyy-MM-dd").format(selectedDate) : "" %><%= selectedTime != null ? "&time=" + selectedTime : "" %>" class="btn btn-secondary">Previous</a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-secondary">Cancel</a>
                <% } %>

                <% if (currentStep < 3) { %>
                    <% if ((currentStep == 1 && selectedDoctor != null) ||
                          (currentStep == 2 && selectedDoctor != null && selectedDate != null && selectedTime != null)) { %>
                        <a href="?step=<%= currentStep + 1 %>&doctorId=<%= selectedDoctor.getId() %><%= selectedDate != null ? "&date=" + new SimpleDateFormat("yyyy-MM-dd").format(selectedDate) : "" %><%= selectedTime != null ? "&time=" + selectedTime : "" %>" class="btn btn-primary">Next</a>
                    <% } else if (currentStep == 1) { %>
                        <button class="btn btn-primary" disabled>Next</button>
                    <% } else if (currentStep == 2) { %>
                        <button class="btn btn-primary" disabled>Next</button>
                    <% } %>
                <% } else { %>
                <button type="submit" form="appointmentForm" class="btn btn-primary">Confirm Booking</button>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function selectDoctor(doctorId) {
            window.location.href = "?step=2&doctorId=" + doctorId;
        }

        function filterDoctors() {
            const specialization = document.getElementById('specialization').value;
            const doctorCards = document.querySelectorAll('.doctor-card');

            doctorCards.forEach(card => {
                if (specialization === '' || card.dataset.specialization === specialization) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        function changeMonth(month, year) {
            const currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('month', month);
            currentUrl.searchParams.set('year', year);
            window.location.href = currentUrl.toString();
        }

        function selectDate(date) {
            const currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('date', date);
            // Remove time when changing date
            currentUrl.searchParams.delete('time');
            window.location.href = currentUrl.toString();
        }

        function selectTime(time) {
            const currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('time', time);
            window.location.href = currentUrl.toString();
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Set selected specialization if any
            const urlParams = new URLSearchParams(window.location.search);
            const specialization = urlParams.get('specialization');
            if (specialization) {
                document.getElementById('specialization').value = specialization;
                filterDoctors();
            }
        });
    </script>
</body>
</html>
