package com.doctorapp.model;

public class User {
    private int id;
    private String username;
    private String email;
    private String password;
    private String phone;
    private String role; // "ADMIN", "PATIENT", "DOCTOR"
    private String firstName;
    private String lastName;
    private String dateOfBirth;
    private String gender;
    private String address;

    public User() {
    }

    public User(int id, String username, String email, String password, String phone, String role,
                String firstName, String lastName) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    // Constructor without firstName and lastName for backward compatibility
    public User(int id, String username, String email, String password, String phone, String role) {
        this(id, username, email, password, phone, role, "", "");
    }

    // Constructor without phone for backward compatibility
    public User(int id, String username, String email, String password, String role) {
        this(id, username, email, password, "", role, "", "");
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    // For backward compatibility with existing code
    public String getName() {
        return username;
    }

    public void setName(String name) {
        this.username = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
