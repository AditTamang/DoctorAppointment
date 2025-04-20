package com.doctorapp.service;

import com.doctorapp.dao.AppointmentDAO;
import com.doctorapp.model.Appointment;
import java.util.List;

/**
 * Service layer for Appointment-related operations.
 * This class acts as an intermediary between controllers and DAOs.
 */
public class AppointmentService {
    private AppointmentDAO appointmentDAO;

    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
    }

    /**
     * Book a new appointment
     * @param appointment The appointment to book
     * @return true if booking was successful, false otherwise
     */
    public boolean bookAppointment(Appointment appointment) {
        return appointmentDAO.bookAppointment(appointment);
    }

    /**
     * Get an appointment by ID
     * @param id Appointment ID
     * @return Appointment object if found, null otherwise
     */
    public Appointment getAppointmentById(int id) {
        return appointmentDAO.getAppointmentById(id);
    }

    /**
     * Get appointments by patient ID
     * @param patientId Patient ID
     * @return List of appointments for the patient
     */
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        return appointmentDAO.getAppointmentsByPatientId(patientId);
    }

    /**
     * Get appointments by doctor ID
     * @param doctorId Doctor ID
     * @return List of appointments for the doctor
     */
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        return appointmentDAO.getAppointmentsByDoctorId(doctorId);
    }

    /**
     * Get all appointments
     * @return List of all appointments
     */
    public List<Appointment> getAllAppointments() {
        return appointmentDAO.getAllAppointments();
    }

    /**
     * Update appointment status
     * @param id Appointment ID
     * @param status New status
     * @return true if update was successful, false otherwise
     */
    public boolean updateAppointmentStatus(int id, String status) {
        return appointmentDAO.updateAppointmentStatus(id, status);
    }

    /**
     * Update appointment prescription
     * @param id Appointment ID
     * @param prescription New prescription
     * @return true if update was successful, false otherwise
     */
    public boolean updateAppointmentPrescription(int id, String prescription) {
        return appointmentDAO.updateAppointmentPrescription(id, prescription);
    }

    /**
     * Delete an appointment
     * @param id Appointment ID
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteAppointment(int id) {
        return appointmentDAO.deleteAppointment(id);
    }

    /**
     * Get recent appointments
     * @param limit Number of appointments to return
     * @return List of recent appointments
     */
    public List<Appointment> getRecentAppointments(int limit) {
        return appointmentDAO.getRecentAppointments(limit);
    }

    /**
     * Get today's appointments by doctor
     * @param doctorId Doctor ID
     * @return List of today's appointments for the doctor
     */
    public List<Appointment> getTodayAppointmentsByDoctor(int doctorId) {
        return appointmentDAO.getTodayAppointmentsByDoctor(doctorId);
    }

    /**
     * Get next appointment by patient
     * @param patientId Patient ID
     * @return Next appointment for the patient
     */
    public Appointment getNextAppointmentByPatient(int patientId) {
        return appointmentDAO.getNextAppointmentByPatient(patientId);
    }

    /**
     * Get upcoming appointments by patient
     * @param patientId Patient ID
     * @param limit Number of appointments to return
     * @return List of upcoming appointments for the patient
     */
    public List<Appointment> getUpcomingAppointmentsByPatient(int patientId, int limit) {
        return appointmentDAO.getUpcomingAppointmentsByPatient(patientId, limit);
    }

    /**
     * Get total number of appointments
     * @return Total number of appointments
     */
    public int getTotalAppointments() {
        return appointmentDAO.getTotalAppointments();
    }

    /**
     * Get total revenue from appointments
     * @return Total revenue
     */
    public double getTotalRevenue() {
        return appointmentDAO.getTotalRevenue();
    }

    /**
     * Get appointments by patient
     * @param patientId Patient ID
     * @return List of appointments for the patient
     */
    public List<Appointment> getAppointmentsByPatient(int patientId) {
        return appointmentDAO.getAppointmentsByPatient(patientId);
    }
}
