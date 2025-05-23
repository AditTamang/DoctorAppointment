package com.doctorapp.service;

 import com.doctorapp.dao.DoctorRegistrationRequestDAO;
 import com.doctorapp.dao.UserDAO;
 import com.doctorapp.model.DoctorRegistrationRequest;

 import java.util.List;

 /**
  * Service class for doctor registration requests
  */
 public class DoctorRegistrationService {
     private DoctorRegistrationRequestDAO requestDAO;
     private UserDAO userDAO;

     public DoctorRegistrationService() {
         this.requestDAO = new DoctorRegistrationRequestDAO();
         this.userDAO = new UserDAO();
     }

     /**
      * Create a new doctor registration request
      * @param request The doctor registration request to create
      * @return true if the request was created successfully, false otherwise
      */
     public boolean createRequest(DoctorRegistrationRequest request) {
         // Check if email already exists in users table
         if (userDAO.emailExists(request.getEmail())) {
             return false;
         }


         // Check if email already exists in requests table
         if (requestDAO.emailExists(request.getEmail())) {
             return false;
         }


         return requestDAO.createRequest(request);
     }

     /**
      * Get all doctor registration requests
      * @return List of all doctor registration requests
      */
     public List<DoctorRegistrationRequest> getAllRequests() {
         return requestDAO.getAllRequests();
     }

     /**
      * Get all pending doctor registration requests
      * @return List of pending doctor registration requests
      */
     public List<DoctorRegistrationRequest> getPendingRequests() {
         return requestDAO.getPendingRequests();
     }

     /**
      * Get a doctor registration request by ID
      * @param id The ID of the request
      * @return The doctor registration request, or null if not found
      */
     public DoctorRegistrationRequest getRequestById(int id) {
         return requestDAO.getRequestById(id);
     }

     /**
      * Approve a doctor registration request
      * @param id The ID of the request
      * @param adminNotes Admin notes about the approval
      * @return true if the approval was successful, false otherwise
      */
     public boolean approveRequest(int id, String adminNotes) {
         return requestDAO.approveRequest(id, adminNotes);
     }

     /**
      * Reject a doctor registration request
      * @param id The ID of the request
      * @param adminNotes Admin notes about the rejection
      * @return true if the rejection was successful, false otherwise
      */
     public boolean rejectRequest(int id, String adminNotes) {
         return requestDAO.rejectRequest(id, adminNotes);
     }

     /**
      * Check if a doctor is approved
      * @param userId The user ID of the doctor
      * @return true if the doctor is approved, false otherwise
      */
     public boolean isDoctorApproved(int userId) {
         if (userId <= 0) {
             return false;
         }

         try {
             return userDAO.isDoctorApproved(userId);
         } catch (Exception e) {
             System.err.println("Error checking doctor approval status: " + e.getMessage());
             // Default to not approved for safety
             return false;
         }
     }

     /**
      * Check if a doctor has a pending registration request
      * @param email The email of the doctor
      * @return true if the doctor has a pending request, false otherwise
      */
     public boolean hasPendingRequest(String email) {
         if (email == null || email.trim().isEmpty()) {
             return false;
         }

         try {
             List<DoctorRegistrationRequest> pendingRequests = getPendingRequests();
             if (pendingRequests == null) {
                 return false;
             }

             return pendingRequests.stream()
                     .anyMatch(req -> email.equals(req.getEmail()));
         } catch (Exception e) {
             System.err.println("Error checking for pending requests: " + e.getMessage());
             return false;
         }
     }
 }