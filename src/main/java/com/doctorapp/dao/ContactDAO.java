package com.doctorapp.dao;

import com.doctorapp.model.Contact;
import com.doctorapp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {

    // Add a new contact message
    public boolean addContactMessage(Contact contact) {
        String query = "INSERT INTO contact_messages (name, email, subject, message, created_at, is_read) VALUES (?, ?, ?, ?, NOW(), ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, contact.getName());
            pstmt.setString(2, contact.getEmail());
            pstmt.setString(3, contact.getSubject());
            pstmt.setString(4, contact.getMessage());
            pstmt.setBoolean(5, contact.isRead());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all contact messages
    public List<Contact> getAllContactMessages() {
        List<Contact> contacts = new ArrayList<>();
        String query = "SELECT * FROM contact_messages ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Contact contact = new Contact();
                contact.setId(rs.getInt("id"));
                contact.setName(rs.getString("name"));
                contact.setEmail(rs.getString("email"));
                contact.setSubject(rs.getString("subject"));
                contact.setMessage(rs.getString("message"));
                contact.setCreatedAt(rs.getTimestamp("created_at"));
                contact.setRead(rs.getBoolean("is_read"));

                contacts.add(contact);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return contacts;
    }

    // Get unread contact messages
    public List<Contact> getUnreadContactMessages() {
        List<Contact> contacts = new ArrayList<>();
        String query = "SELECT * FROM contact_messages WHERE is_read = false ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Contact contact = new Contact();
                contact.setId(rs.getInt("id"));
                contact.setName(rs.getString("name"));
                contact.setEmail(rs.getString("email"));
                contact.setSubject(rs.getString("subject"));
                contact.setMessage(rs.getString("message"));
                contact.setCreatedAt(rs.getTimestamp("created_at"));
                contact.setRead(rs.getBoolean("is_read"));

                contacts.add(contact);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return contacts;
    }

    // Mark a contact message as read
    public boolean markAsRead(int contactId) {
        String query = "UPDATE contact_messages SET is_read = true WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, contactId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a contact message
    public boolean deleteContactMessage(int contactId) {
        String query = "DELETE FROM contact_messages WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, contactId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get a contact message by ID
    public Contact getContactMessageById(int contactId) {
        String query = "SELECT * FROM contact_messages WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, contactId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Contact contact = new Contact();
                    contact.setId(rs.getInt("id"));
                    contact.setName(rs.getString("name"));
                    contact.setEmail(rs.getString("email"));
                    contact.setSubject(rs.getString("subject"));
                    contact.setMessage(rs.getString("message"));
                    contact.setCreatedAt(rs.getTimestamp("created_at"));
                    contact.setRead(rs.getBoolean("is_read"));

                    return contact;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }
}
