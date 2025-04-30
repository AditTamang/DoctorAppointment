package com.doctorapp.controller.auth;

import com.doctorapp.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Use SessionUtil to the invalidate the session and remove cookies
        SessionUtil.invalidateUserSession(request, response);

        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}