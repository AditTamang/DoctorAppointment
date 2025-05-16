package com.doctorapp.util;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.http.HttpServletResponse;

/**
 * Utility class for sending JSON responses
 */
public class JsonResponse {

    /**
     * Send a JSON response with success and message
     *
     * @param response The HTTP response
     * @param success Whether the operation was successful
     * @param message The message to send
     * @throws IOException If an I/O error occurs
     */
    public static void send(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
        out.flush();
    }

    /**
     * Send a JSON response with success, message, and additional data
     *
     * @param response The HTTP response
     * @param success Whether the operation was successful
     * @param message The message to send
     * @param key The key for the additional data
     * @param value The value for the additional data
     * @throws IOException If an I/O error occurs
     */
    public static void send(HttpServletResponse response, boolean success, String message, String key, String value) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\"" + message + "\",\"" + key + "\":\"" + value + "\"}");
        out.flush();
    }
}
