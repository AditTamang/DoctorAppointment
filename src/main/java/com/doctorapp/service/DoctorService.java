package com.doctorapp.service;

 import java.util.List;

 import com.doctorapp.dao.DoctorDAO;
 import com.doctorapp.model.Doctor;

 /**
  * Service layer for Doctor-related operations.
  * This class acts as an intermediary between controllers and DAOs.
  */
 public class DoctorService {
     private DoctorDAO doctorDAO;

     public DoctorService() {
         this.doctorDAO = new DoctorDAO();
     }

     /**
      * Add a new doctor
      * @param doctor The doctor to add
      * @return true if addition was successful, false otherwise
      */
     public boolean addDoctor(Doctor doctor) {
         return doctorDAO.addDoctor(doctor);
     }

     /**
      * Get a doctor by ID
      * @param id Doctor's ID
      * @return Doctor object if found, null otherwise
      */
     public Doctor getDoctorById(int id) {
         return doctorDAO.getDoctorById(id);
     }

     /**
      * Get all doctors (for admin use)
      * @return List of all doctors
      */
     public List<Doctor> getAllDoctors() {
         return doctorDAO.getAllDoctors();
     }

     /**
      * Get only approved doctors (for public display)
      * @return List of approved doctors
      */
     public List<Doctor> getApprovedDoctors() {
         return doctorDAO.getApprovedDoctors();
     }

     /**
      * Search doctors by name or email (for admin use)
      * @param searchTerm Term to search for in name or email
      * @return List of doctors matching the search term
      */
     public List<Doctor> searchDoctors(String searchTerm) {
         return doctorDAO.searchDoctors(searchTerm);
     }

     /**
      * Search approved doctors by name or specialization (for public display)
      * @param searchTerm Term to search for in name or specialization
      * @return List of approved doctors matching the search term
      */
     public List<Doctor> searchApprovedDoctors(String searchTerm) {
         return doctorDAO.searchApprovedDoctors(searchTerm);
     }

     /**
      * Get doctors by specialization (for admin use)
      * @param specialization Specialization to filter by
      * @return List of doctors with the specified specialization
      */
     public List<Doctor> getDoctorsBySpecialization(String specialization) {
         return doctorDAO.getDoctorsBySpecialization(specialization);
     }

     /**
      * Get approved doctors by specialization (for public display)
      * @param specialization Specialization to filter by
      * @return List of approved doctors with the specified specialization
      */
     public List<Doctor> getApprovedDoctorsBySpecialization(String specialization) {
         return doctorDAO.getApprovedDoctorsBySpecialization(specialization);
     }

     /**
      * Update a doctor
      * @param doctor The doctor to update
      * @return true if update was successful, false otherwise
      */
     public boolean updateDoctor(Doctor doctor) {
         return doctorDAO.updateDoctor(doctor);
     }

     /**
      * Delete a doctor
      * @param id Doctor's ID
      * @return true if deletion was successful, false otherwise
      */
     public boolean deleteDoctor(int id) {
         return doctorDAO.deleteDoctor(id);
     }

     /**
      * Get total number of doctors
      * @return Total number of doctors
      */
     public int getTotalDoctors() {
         return doctorDAO.getTotalDoctors();
     }

     /**
      * Get total number of approved doctors
      * @return Total number of approved doctors
      */
     public int getTotalApprovedDoctors() {
         return doctorDAO.getApprovedDoctorsCount();
     }

     /**
      * Get top doctors based on ratings or appointments
      * @param limit Number of doctors to return
      * @return List of top doctors
      */
     public List<Doctor> getTopDoctors(int limit) {
         return doctorDAO.getTopDoctors(limit);
     }

     /**
      * Get a doctor by user ID
      * @param userId User ID
      * @return Doctor object if found, null otherwise
      */
     public Doctor getDoctorByUserId(int userId) {
         return doctorDAO.getDoctorByUserId(userId);
     }

     /**
      * Increment the patient count for a doctor
      * @param doctorId Doctor ID
      * @return true if update was successful, false otherwise
      */
     public boolean incrementPatientCount(int doctorId) {
         // Get the doctor
         Doctor doctor = getDoctorById(doctorId);
         if (doctor == null) {
             return false;
         }

         // Increment patient count
         doctor.setPatientCount(doctor.getPatientCount() + 1);

         // Update doctor
         return updateDoctor(doctor);
     }
 }