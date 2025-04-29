package com.doctorapp.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

import com.doctorapp.model.Department;
import com.doctorapp.model.User;
import com.doctorapp.service.DepartmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling department operations
 */
@WebServlet(urlPatterns = {
    "/admin/departments",
    "/admin/department/add",
    "/admin/department/edit",
    "/admin/department/delete",
    "/admin/department/view"
})
public class DepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DepartmentServlet.class.getName());
    private DepartmentService departmentService;

    @Override
    public void init() {
        departmentService = new DepartmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getServletPath();

        switch (action) {
            case "/admin/departments":
                listDepartments(request, response);
                break;
            case "/admin/department/add":
                showAddDepartmentForm(request, response);
                break;
            case "/admin/department/edit":
                showEditDepartmentForm(request, response);
                break;
            case "/admin/department/view":
                viewDepartment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getServletPath();

        switch (action) {
            case "/admin/department/add":
                addDepartment(request, response);
                break;
            case "/admin/department/edit":
                updateDepartment(request, response);
                break;
            case "/admin/department/delete":
                deleteDepartment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                break;
        }
    }

    private void listDepartments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Department> departments = departmentService.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin/departments.jsp").forward(request, response);
    }

    private void showAddDepartmentForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/admin/department-form.jsp").forward(request, response);
    }

    private void showEditDepartmentForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Department department = departmentService.getDepartmentById(id);
        request.setAttribute("department", department);
        request.getRequestDispatcher("/admin/department-form.jsp").forward(request, response);
    }

    private void viewDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Department department = departmentService.getDepartmentById(id);
        request.setAttribute("department", department);
        request.getRequestDispatcher("/admin/department-view.jsp").forward(request, response);
    }

    private void addDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        Department department = new Department();
        department.setName(name);
        department.setDescription(description);
        department.setStatus(status != null ? status : "ACTIVE");

        if (departmentService.addDepartment(department)) {
            request.setAttribute("message", "Department added successfully!");
        } else {
            request.setAttribute("error", "Failed to add department. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        Department department = new Department();
        department.setId(id);
        department.setName(name);
        department.setDescription(description);
        department.setStatus(status != null ? status : "ACTIVE");

        if (departmentService.updateDepartment(department)) {
            request.setAttribute("message", "Department updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update department. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        if (departmentService.deleteDepartment(id)) {
            request.setAttribute("message", "Department deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete department. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }
}
