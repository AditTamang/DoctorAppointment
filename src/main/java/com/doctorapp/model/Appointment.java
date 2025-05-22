package com.doctorapp.model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.Date;

public class Appointment {
    private int id;
    private int patientId;
    private int doctorId;
    private String patientName;
    private String doctorName;
    private Date appointmentDate;
    private String appointmentTime;
    // Status values: "PENDING", "CONFIRMED", "CANCELLED", "COMPLETED"
    private String status;
    private String symptoms;
    private String prescription;
    private String reason;
    private String reschedulingReason;
    private String notes;
    private double fee;
    private String doctorSpecialization;
    private String medicalReport;
    private String patientImage;

    public Appointment() {
    }

    public Appointment(int id, int patientId, int doctorId, String patientName, String doctorName,
                      Date appointmentDate, String appointmentTime, String status,
                      String symptoms, String prescription) {
        this.id = id;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.patientName = patientName;
        this.doctorName = doctorName;
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
        this.status = status;
        this.symptoms = symptoms;
        this.prescription = prescription;
    }

    // Basic getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    // Convert LocalDate to Date for appointment date
    public void setAppointmentDate(LocalDate localDate) {
        if (localDate != null) {
            this.appointmentDate = Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        }
    }

    // Get appointment date as LocalDate
    public LocalDate getAppointmentLocalDate() {
        if (appointmentDate != null) {
            return appointmentDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        }
        return null;
    }

    public String getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(String appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    // Convert LocalTime to String for appointment time
    public void setAppointmentTime(LocalTime localTime) {
        if (localTime != null) {
            this.appointmentTime = localTime.toString();
        }
    }

    // Get appointment time as LocalTime
    public LocalTime getAppointmentLocalTime() {
        if (appointmentTime != null && !appointmentTime.isEmpty()) {
            try {
                return LocalTime.parse(appointmentTime);
            } catch (Exception e) {
                // Try parsing time format like "10:00 AM"
                try {
                    return LocalTime.parse(appointmentTime, java.time.format.DateTimeFormatter.ofPattern("h:mm a"));
                } catch (Exception ex) {
                    return null;
                }
            }
        }
        return null;
    }

    // Get status with UI-friendly conversion
    public String getStatus() {
        if ("CONFIRMED".equals(status)) {
            return "APPROVED";
        } else if ("CANCELLED".equals(status) && this.reason != null && !this.reason.isEmpty()) {
            return "REJECTED";
        }
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Get original status without UI conversion
    public String getRawStatus() {
        return status;
    }

    public String getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(String symptoms) {
        this.symptoms = symptoms;
    }

    public String getPrescription() {
        return prescription;
    }

    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }

    /**
     * Get the reason for the appointment or rescheduling
     * @return The reason, prioritizing rescheduling reason if available
     */
    public String getReason() {
        // If reschedulingReason is available, return it instead
        if (reschedulingReason != null && !reschedulingReason.isEmpty()) {
            return reschedulingReason;
        }
        return reason;
    }

    /**
     * Set the reason for the appointment
     * @param reason The appointment reason
     */
    public void setReason(String reason) {
        this.reason = reason;
    }

    /**
     * Get the reason for rescheduling the appointment
     * @return The rescheduling reason
     */
    public String getReschedulingReason() {
        return reschedulingReason;
    }

    /**
     * Set the reason for rescheduling the appointment
     * @param reschedulingReason The reason for rescheduling
     */
    public void setReschedulingReason(String reschedulingReason) {
        this.reschedulingReason = reschedulingReason;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public double getFee() {
        return fee;
    }

    public void setFee(double fee) {
        this.fee = fee;
    }

    public String getDoctorSpecialization() {
        return doctorSpecialization;
    }

    public void setDoctorSpecialization(String doctorSpecialization) {
        this.doctorSpecialization = doctorSpecialization;
    }

    public String getMedicalReport() {
        return medicalReport;
    }

    public void setMedicalReport(String medicalReport) {
        this.medicalReport = medicalReport;
    }

    public String getPatientImage() {
        return patientImage;
    }

    public void setPatientImage(String patientImage) {
        this.patientImage = patientImage;
    }

    // Format date and time for display (e.g., "Jan 15, 2023 at 10:00 AM")
    public String getFormattedDateTime() {
        if (appointmentDate == null) {
            return "";
        }
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MMM dd, yyyy");
        return dateFormat.format(appointmentDate) + " at " + appointmentTime;
    }

    // Format date in ISO format (yyyy-MM-dd)
    public String getFormattedDate() {
        if (appointmentDate == null) {
            return "";
        }
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
        return dateFormat.format(appointmentDate);
    }
}
