package com.doctorapp.controller.servlets;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/about-us", "/aboutus"})
public class AboutUsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("AboutUsServlet: doGet method called");
        try {
            // Forward to the about-us.jsp page
            request.getRequestDispatcher("/about-us.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in AboutUsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}