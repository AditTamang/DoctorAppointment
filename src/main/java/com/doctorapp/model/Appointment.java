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
    private String status; // "PENDING", "CONFIRMED", "CANCELLED", "COMPLETED"
    private String symptoms;
    private String prescription;
    private String reason;
    private String notes;
    private double fee;
    private String doctorSpecialization;
    private String medicalReport;

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

    // Getters and Setters
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

    // Method to handle LocalDate
    public void setAppointmentDate(LocalDate localDate) {
        if (localDate != null) {
            this.appointmentDate = Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        }
    }

    // Method to get LocalDate
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

    // Method to handle LocalTime
    public void setAppointmentTime(LocalTime localTime) {
        if (localTime != null) {
            this.appointmentTime = localTime.toString();
        }
    }

    // Method to get LocalTime
    public LocalTime getAppointmentLocalTime() {
        if (appointmentTime != null && !appointmentTime.isEmpty()) {
            try {
                return LocalTime.parse(appointmentTime);
            } catch (Exception e) {
                // Handle time formats like "10:00 AM"
                try {
                    return LocalTime.parse(appointmentTime, java.time.format.DateTimeFormatter.ofPattern("h:mm a"));
                } catch (Exception ex) {
                    return null;
                }
            }
        }
        return null;
    }

    public String getStatus() {
        // Convert database status to UI status if needed
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

    // Get the raw database status
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

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
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

    // Helper method to format date and time
    public String getFormattedDateTime() {
        if (appointmentDate == null) {
            return "";
        }

        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MMM dd, yyyy");
        return dateFormat.format(appointmentDate) + " at " + appointmentTime;
    }

    // Helper method to format just the date
    public String getFormattedDate() {
        if (appointmentDate == null) {
            return "";
        }

        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
        return dateFormat.format(appointmentDate);
    }
}
