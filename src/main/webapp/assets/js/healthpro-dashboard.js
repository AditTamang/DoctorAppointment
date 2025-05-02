/**
 * HealthPro Dashboard JavaScript
 * This file contains all the JavaScript functionality for the HealthPro dashboard
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize the dashboard
    initDashboard();
    
    // Set up event listeners
    setupEventListeners();
});

/**
 * Initialize the dashboard
 */
function initDashboard() {
    // Initialize sidebar toggle
    initSidebarToggle();
    
    // Initialize tabs
    initTabs();
    
    // Initialize dropdowns
    initDropdowns();
}

/**
 * Set up event listeners
 */
function setupEventListeners() {
    // Profile action buttons
    setupProfileActions();
    
    // Search functionality
    setupSearch();
    
    // Table actions
    setupTableActions();
}

/**
 * Initialize sidebar toggle functionality
 */
function initSidebarToggle() {
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = document.querySelector('.sidebar-toggle');
    
    if (toggleBtn) {
        toggleBtn.addEventListener('click', function() {
            sidebar.classList.toggle('sidebar-collapsed');
        });
    }
    
    // Check for mobile view and collapse sidebar by default
    if (window.innerWidth < 992) {
        sidebar.classList.add('sidebar-collapsed');
    }
}

/**
 * Initialize tabs functionality
 */
function initTabs() {
    const tabs = document.querySelectorAll('.tab');
    
    tabs.forEach(tab => {
        tab.addEventListener('click', function() {
            // Remove active class from all tabs
            tabs.forEach(t => t.classList.remove('active'));
            
            // Add active class to clicked tab
            this.classList.add('active');
            
            // Here you would typically show/hide content based on the selected tab
            // For example:
            // const tabId = this.getAttribute('data-tab');
            // document.querySelectorAll('.tab-content').forEach(content => content.style.display = 'none');
            // document.getElementById(tabId).style.display = 'block';
        });
    });
}

/**
 * Initialize dropdowns
 */
function initDropdowns() {
    // User profile dropdown
    const userProfile = document.querySelector('.user-profile');
    
    if (userProfile) {
        userProfile.addEventListener('click', function(e) {
            // Toggle dropdown menu
            // Implementation would depend on your dropdown structure
            // For example:
            // const dropdown = document.querySelector('.user-dropdown');
            // dropdown.classList.toggle('show');
            
            // Prevent event from bubbling up
            e.stopPropagation();
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function() {
            // const dropdown = document.querySelector('.user-dropdown');
            // if (dropdown.classList.contains('show')) {
            //     dropdown.classList.remove('show');
            // }
        });
    }
}

/**
 * Set up profile action buttons
 */
function setupProfileActions() {
    // Edit profile button
    const editProfileBtn = document.querySelector('.btn-primary');
    if (editProfileBtn) {
        editProfileBtn.addEventListener('click', function() {
            window.location.href = contextPath + '/doctor/edit-profile';
        });
    }
    
    // Set active/inactive button
    const setActiveBtn = document.querySelector('.btn-outline');
    if (setActiveBtn) {
        setActiveBtn.addEventListener('click', function() {
            // Toggle doctor status
            // This would typically make an AJAX call to update the status
            // For example:
            // fetch(contextPath + '/doctor/toggle-status', {
            //     method: 'POST',
            //     headers: {
            //         'Content-Type': 'application/json',
            //     },
            // })
            // .then(response => response.json())
            // .then(data => {
            //     if (data.success) {
            //         // Update button text based on new status
            //         this.textContent = data.status === 'ACTIVE' ? 'Set Active Off' : 'Set Active On';
            //     }
            // });
        });
    }
    
    // Delete profile button
    const deleteProfileBtn = document.querySelector('.btn-danger');
    if (deleteProfileBtn) {
        deleteProfileBtn.addEventListener('click', function() {
            if (confirm('Are you sure you want to delete your profile? This action cannot be undone.')) {
                // Delete profile
                // This would typically make an AJAX call to delete the profile
                // For example:
                // window.location.href = contextPath + '/doctor/delete-profile';
            }
        });
    }
}

/**
 * Set up search functionality
 */
function setupSearch() {
    const searchInput = document.querySelector('.search-input');
    
    if (searchInput) {
        searchInput.addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
                // Perform search
                // This would typically make an AJAX call to search
                // For example:
                // window.location.href = contextPath + '/search?q=' + this.value;
            }
        });
    }
}

/**
 * Set up table action buttons
 */
function setupTableActions() {
    // View buttons
    const viewButtons = document.querySelectorAll('.action-btn.view');
    viewButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Get the ID from the data attribute or from the row
            // const id = this.closest('tr').getAttribute('data-id');
            // window.location.href = contextPath + '/doctor/view-details?id=' + id;
        });
    });
    
    // Edit buttons
    const editButtons = document.querySelectorAll('.action-btn.edit');
    editButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Get the ID from the data attribute or from the row
            // const id = this.closest('tr').getAttribute('data-id');
            // window.location.href = contextPath + '/doctor/edit-details?id=' + id;
        });
    });
    
    // Delete buttons
    const deleteButtons = document.querySelectorAll('.action-btn.delete');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            if (confirm('Are you sure you want to delete this item? This action cannot be undone.')) {
                // Get the ID from the data attribute or from the row
                // const id = this.closest('tr').getAttribute('data-id');
                // window.location.href = contextPath + '/doctor/delete-item?id=' + id;
            }
        });
    });
}
