package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.model.Contact;
import com.doctorapp.model.User;
import com.doctorapp.dao.ContactDAO;
import com.doctorapp.util.PasswordHasher;

@WebServlet(urlPatterns = {
    "/contact-us",
    "/contact/submit",
    "/admin/contacts",
    "/admin/contact/view",
    "/admin/contact/mark-read",
    "/admin/contact/delete"
})
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ContactDAO contactDAO;

    public void init() {
        contactDAO = new ContactDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/contact-us":
                showContactForm(request, response);
                break;
            case "/admin/contacts":
                listContacts(request, response);
                break;
            case "/admin/contact/view":
                viewContact(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/contact/submit":
                submitContactForm(request, response);
                break;
            case "/admin/contact/mark-read":
                markContactAsRead(request, response);
                break;
            case "/admin/contact/delete":
                deleteContact(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    private void showContactForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to the contact-us.jsp page
        request.getRequestDispatcher("/contact-us.jsp").forward(request, response);
    }

    private void submitContactForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Create a new Contact object
        Contact contact = new Contact(name, email, subject, message);

        // Save to database
        boolean success = contactDAO.addContactMessage(contact);

        if (success) {
            // Set success message
            request.setAttribute("successMessage", "Your message has been sent successfully. We will get back to you soon!");
        } else {
            // Set error message
            request.setAttribute("errorMessage", "There was an error sending your message. Please try again later.");
        }

        // Forward back to contact form
        request.getRequestDispatcher("/contact-us.jsp").forward(request, response);
    }

    private void listContacts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get all contact messages
        List<Contact> contacts = contactDAO.getAllContactMessages();
        request.setAttribute("contacts", contacts);

        // Forward to admin contacts page
        request.getRequestDispatcher("/admin/contacts.jsp").forward(request, response);
    }

    private void viewContact(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get contact ID
        int contactId = Integer.parseInt(request.getParameter("id"));

        // Get contact message
        Contact contact = contactDAO.getContactMessageById(contactId);
        
        if (contact != null) {
            // Mark as read
            contactDAO.markAsRead(contactId);
            
            // Set contact in request
            request.setAttribute("contact", contact);
            
            // Forward to contact view page
            request.getRequestDispatcher("/admin/contact-view.jsp").forward(request, response);
        } else {
            // Contact not found
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
        }
    }

    private void markContactAsRead(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get contact ID
        int contactId = Integer.parseInt(request.getParameter("id"));

        // Mark as read
        contactDAO.markAsRead(contactId);

        // Redirect back to contacts list
        response.sendRedirect(request.getContextPath() + "/admin/contacts");
    }

    private void deleteContact(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get contact ID
        int contactId = Integer.parseInt(request.getParameter("id"));

        // Delete contact
        contactDAO.deleteContactMessage(contactId);

        // Redirect back to contacts list
        response.sendRedirect(request.getContextPath() + "/admin/contacts");
    }
}
