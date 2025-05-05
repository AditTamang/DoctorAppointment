package com.doctorapp.model;

import java.sql.Time;
import java.sql.Timestamp;

/**
 * Model class for doctor schedules
 */
public class DoctorSchedule {
    private int id;
    private int doctorId;
    private String dayOfWeek;
    private Time startTime;
    private Time endTime;
    private Time breakStartTime;
    private Time breakEndTime;
    private int maxAppointments;
    private boolean isAvailable;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public DoctorSchedule() {
    }

    public DoctorSchedule(int doctorId, String dayOfWeek, Time startTime, Time endTime) {
        this.doctorId = doctorId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isAvailable = true;
        this.maxAppointments = 20; // Default value
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public Time getBreakStartTime() {
        return breakStartTime;
    }

    public void setBreakStartTime(Time breakStartTime) {
        this.breakStartTime = breakStartTime;
    }

    public Time getBreakEndTime() {
        return breakEndTime;
    }

    public void setBreakEndTime(Time breakEndTime) {
        this.breakEndTime = breakEndTime;
    }

    public int getMaxAppointments() {
        return maxAppointments;
    }

    public void setMaxAppointments(int maxAppointments) {
        this.maxAppointments = maxAppointments;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Helper methods
    public String getFormattedStartTime() {
        return startTime != null ? startTime.toString() : "";
    }

    public String getFormattedEndTime() {
        return endTime != null ? endTime.toString() : "";
    }

    public String getFormattedBreakStartTime() {
        return breakStartTime != null ? breakStartTime.toString() : "";
    }

    public String getFormattedBreakEndTime() {
        return breakEndTime != null ? breakEndTime.toString() : "";
    }

    @Override
    public String toString() {
        return "DoctorSchedule{" +
                "id=" + id +
                ", doctorId=" + doctorId +
                ", dayOfWeek='" + dayOfWeek + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", maxAppointments=" + maxAppointments +
                ", isAvailable=" + isAvailable +
                '}';
    }
}
