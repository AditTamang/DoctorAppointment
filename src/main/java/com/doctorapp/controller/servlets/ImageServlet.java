package com.doctorapp.controller.servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet for serving images from the permanent directory
 * Mapping is defined in web.xml
 */
public class ImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Remove the leading slash
        String fileName = pathInfo.substring(1);

        // Get the permanent directory path
        String webappPath = request.getServletContext().getRealPath("/");
        String projectRoot = new File(webappPath).getParentFile().getParentFile().getAbsolutePath();
        String permanentDirPath = projectRoot + File.separator + "doctor-images";

        // Check if the file exists in the permanent directory
        File file = new File(permanentDirPath, fileName);

        if (!file.exists()) {
            // If not found in permanent directory, try the webapp directory
            String webappImagePath = request.getServletContext().getRealPath("/assets/images/doctors/" + fileName);
            file = new File(webappImagePath);

            if (!file.exists()) {
                // If still not found, return 404
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }

        // Set the content type based on the file extension
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);

        // Set content length
        response.setContentLength((int) file.length());

        // Copy the file to the response output stream
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            System.err.println("Error serving image: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
