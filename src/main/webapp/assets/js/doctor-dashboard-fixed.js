/**
 * Doctor Dashboard JavaScript
 * This file contains all the JavaScript functionality for the doctor dashboard
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize the dashboard
    initDashboard();

    // Set up event listeners
    setupEventListeners();

    // Load initial data
    loadDashboardData();
});

/**
 * Initialize the dashboard
 */
function initDashboard() {
    // Set current date in the header
    updateCurrentDate();

    // Initialize sidebar toggle
    initSidebarToggle();

    // Initialize section navigation
    initSectionNavigation();
}

/**
 * Update the current date display in the header
 */
function updateCurrentDate() {
    const currentDateElement = document.getElementById('current-date');
    if (currentDateElement) {
        const now = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        currentDateElement.textContent = now.toLocaleDateString('en-US', options);
    }
}

/**
 * Initialize the sidebar toggle functionality
 */
function initSidebarToggle() {
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const sidebar = document.getElementById('sidebar');

    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
        });
    }

    // Handle responsive behavior
    handleResponsiveSidebar();
    window.addEventListener('resize', handleResponsiveSidebar);
}

/**
 * Handle responsive sidebar behavior
 */
function handleResponsiveSidebar() {
    const sidebar = document.getElementById('sidebar');

    if (sidebar) {
        if (window.innerWidth < 992) {
            sidebar.classList.add('collapsed');
        } else {
            sidebar.classList.remove('collapsed');
        }
    }
}

/**
 * Initialize section navigation
 */
function initSectionNavigation() {
    const navLinks = document.querySelectorAll('.sidebar-nav a');
    const sections = document.querySelectorAll('.dashboard-section');

    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();

            // Get the target section ID from the href attribute
            const targetId = this.getAttribute('href');

            // Hide all sections
            sections.forEach(section => {
                section.classList.remove('active');
            });

            // Show the target section
            const targetSection = document.querySelector(targetId);
            if (targetSection) {
                targetSection.classList.add('active');

                // Load section content if needed
                loadSectionContent(targetId);
            }

            // Update active navigation link
            navLinks.forEach(navLink => {
                navLink.parentElement.classList.remove('active');
            });
            this.parentElement.classList.add('active');

            // Close sidebar on mobile
            if (window.innerWidth < 768) {
                const sidebar = document.getElementById('sidebar');
                if (sidebar) {
                    sidebar.classList.add('collapsed');
                }
            }
        });
    });

    // Check if there's a hash in the URL and navigate to that section
    if (window.location.hash) {
        const targetLink = document.querySelector('.sidebar-nav a[href="' + window.location.hash + '"]');
        if (targetLink) {
            targetLink.click();
        }
    }
}

/**
 * Load content for a specific section
 * @param {string} sectionId - The ID of the section to load content for
 */
function loadSectionContent(sectionId) {
    // Remove the # from the section ID
    const section = sectionId.substring(1);

    switch (section) {
        case 'profile-section':
            loadProfileSection();
            break;
        case 'appointments-section':
            loadAppointmentsSection();
            break;
        case 'patients-section':
            loadPatientsSection();
            break;
        case 'availability-section':
            loadAvailabilitySection();
            break;
        case 'packages-section':
            loadPackagesSection();
            break;
        case 'settings-section':
            loadSettingsSection();
            break;
    }
}

/**
 * Set up event listeners for various dashboard elements
 */
function setupEventListeners() {
    // Status toggle
    const statusToggle = document.getElementById('status-toggle');
    if (statusToggle) {
        statusToggle.addEventListener('change', function() {
            updateDoctorStatus(this.checked);
        });
    }

    // Appointment action buttons
    setupAppointmentActions();

    // Notification dropdown
    setupNotificationDropdown();

    // Account dropdown
    setupAccountDropdown();

    // Search functionality
    setupSearch();
}

/**
 * Set up event listeners for appointment action buttons
 */
function setupAppointmentActions() {
    // View appointment details
    document.querySelectorAll('.btn-view').forEach(btn => {
        btn.addEventListener('click', function() {
            const appointmentId = this.getAttribute('data-appointment-id');
            viewAppointmentDetails(appointmentId);
        });
    });

    // Reschedule appointment
    document.querySelectorAll('.btn-reschedule').forEach(btn => {
        btn.addEventListener('click', function() {
            const appointmentId = this.getAttribute('data-appointment-id');
            rescheduleAppointment(appointmentId);
        });
    });

    // Cancel appointment
    document.querySelectorAll('.btn-cancel').forEach(btn => {
        btn.addEventListener('click', function() {
            const appointmentId = this.getAttribute('data-appointment-id');
            cancelAppointment(appointmentId);
        });
    });
}

/**
 * Set up notification dropdown
 */
function setupNotificationDropdown() {
    const notificationBtn = document.querySelector('.notification-btn');
    const notificationDropdown = document.querySelector('.notification-dropdown');

    if (notificationBtn && notificationDropdown) {
        notificationBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            notificationDropdown.style.display = notificationDropdown.style.display === 'block' ? 'none' : 'block';
        });

        document.addEventListener('click', function(e) {
            if (!notificationBtn.contains(e.target) && !notificationDropdown.contains(e.target)) {
                notificationDropdown.style.display = 'none';
            }
        });
    }
}

/**
 * Set up account dropdown
 */
function setupAccountDropdown() {
    const accountBtn = document.querySelector('.account-btn');
    const accountDropdown = document.querySelector('.account-dropdown-menu');

    if (accountBtn && accountDropdown) {
        accountBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            accountDropdown.style.display = accountDropdown.style.display === 'block' ? 'none' : 'block';
        });

        document.addEventListener('click', function(e) {
            if (!accountBtn.contains(e.target) && !accountDropdown.contains(e.target)) {
                accountDropdown.style.display = 'none';
            }
        });
    }
}

/**
 * Set up search functionality
 */
function setupSearch() {
    const searchInput = document.querySelector('.search-input');
    const searchBtn = document.querySelector('.search-btn');

    if (searchInput && searchBtn) {
        searchBtn.addEventListener('click', function() {
            performSearch(searchInput.value);
        });

        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                performSearch(this.value);
            }
        });
    }
}

/**
 * Load dashboard data
 */
function loadDashboardData() {
    // This function would typically make AJAX calls to fetch data from the server
    // For now, we'll just simulate loading data
    console.log('Loading dashboard data...');
}

/**
 * Update doctor status
 * @param {boolean} isActive - Whether the doctor is active or not
 */
function updateDoctorStatus(isActive) {
    const statusText = document.getElementById('status-text');
    const statusIndicator = document.querySelector('.status-indicator');

    if (statusText && statusIndicator) {
        if (isActive) {
            statusText.textContent = 'Active';
            statusIndicator.classList.remove('inactive');
            statusIndicator.classList.add('active');
        } else {
            statusText.textContent = 'Inactive';
            statusIndicator.classList.remove('active');
            statusIndicator.classList.add('inactive');
        }

        // Send status update to server
        fetch(window.location.origin + '/doctor/update-status', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'status=' + (isActive ? 'ACTIVE' : 'INACTIVE')
        })
        .then(response => response.json())
        .then(data => {
            console.log('Status updated:', data);
        })
        .catch(error => {
            console.error('Error updating status:', error);
        });
    }
}

/**
 * View appointment details
 * @param {string} appointmentId - The ID of the appointment to view
 */
function viewAppointmentDetails(appointmentId) {
    console.log('Viewing appointment details for ID:', appointmentId);

    // Fetch appointment details from server
    fetch(window.location.origin + '/doctor/appointment?id=' + appointmentId)
    .then(response => response.json())
    .then(data => {
        // Populate and show the appointment detail modal
        const modal = document.getElementById('appointmentDetailModal');
        if (modal) {
            // Populate modal content with appointment details
            // This would be implemented based on the actual data structure

            // Show the modal using our custom modal implementation
            const customModalInstance = new customModal.Modal(modal);
            customModalInstance.show();
        }
    })
    .catch(error => {
        console.error('Error fetching appointment details:', error);
    });
}

/**
 * Reschedule an appointment
 * @param {string} appointmentId - The ID of the appointment to reschedule
 */
function rescheduleAppointment(appointmentId) {
    console.log('Rescheduling appointment with ID:', appointmentId);
    // Implementation would depend on the specific requirements
}

/**
 * Cancel an appointment
 * @param {string} appointmentId - The ID of the appointment to cancel
 */
function cancelAppointment(appointmentId) {
    console.log('Cancelling appointment with ID:', appointmentId);

    if (confirm('Are you sure you want to cancel this appointment?')) {
        // Send cancellation request to server
        fetch(window.location.origin + '/doctor/cancel-appointment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'id=' + appointmentId
        })
        .then(response => response.json())
        .then(data => {
            console.log('Appointment cancelled:', data);
            // Refresh the appointments list
            loadDashboardData();
        })
        .catch(error => {
            console.error('Error cancelling appointment:', error);
        });
    }
}

/**
 * Perform search
 * @param {string} query - The search query
 */
function performSearch(query) {
    console.log('Searching for:', query);

    if (query.trim() === '') {
        return;
    }

    // Send search request to server
    fetch(window.location.origin + '/doctor/search?q=' + encodeURIComponent(query))
    .then(response => response.json())
    .then(data => {
        console.log('Search results:', data);
        // Display search results
        // Implementation would depend on the specific requirements
    })
    .catch(error => {
        console.error('Error performing search:', error);
    });
}

/**
 * Load profile section content
 */
function loadProfileSection() {
    const profileSection = document.getElementById('profile-section');

    if (profileSection && profileSection.children.length === 0) {
        // Only load if the section is empty
        fetch(window.location.origin + '/doctor/profile')
        .then(response => response.text())
        .then(html => {
            profileSection.innerHTML = html;
            // Initialize any profile-specific functionality
        })
        .catch(error => {
            console.error('Error loading profile section:', error);
            profileSection.innerHTML = '<div class="error-message">Failed to load profile information. Please try again later.</div>';
        });
    }
}

/**
 * Load appointments section content
 */
function loadAppointmentsSection() {
    const appointmentsSection = document.getElementById('appointments-section');

    if (appointmentsSection && appointmentsSection.children.length === 0) {
        // Only load if the section is empty
        fetch(window.location.origin + '/doctor/appointments')
        .then(response => response.text())
        .then(html => {
            appointmentsSection.innerHTML = html;
            // Initialize appointments-specific functionality
            initAppointmentsTabs();
        })
        .catch(error => {
            console.error('Error loading appointments section:', error);
            appointmentsSection.innerHTML = '<div class="error-message">Failed to load appointments. Please try again later.</div>';
        });
    }
}

/**
 * Initialize appointments tabs
 */
function initAppointmentsTabs() {
    // This would be implemented once the appointments section is loaded
}

/**
 * Load patients section content
 */
function loadPatientsSection() {
    const patientsSection = document.getElementById('patients-section');

    if (patientsSection && patientsSection.children.length === 0) {
        // Only load if the section is empty
        fetch(window.location.origin + '/doctor/patients')
        .then(response => response.text())
        .then(html => {
            patientsSection.innerHTML = html;
            // Initialize patients-specific functionality
        })
        .catch(error => {
            console.error('Error loading patients section:', error);
            patientsSection.innerHTML = '<div class="error-message">Failed to load patients information. Please try again later.</div>';
        });
    }
}

/**
 * Load availability section content
 */
function loadAvailabilitySection() {
    const availabilitySection = document.getElementById('availability-section');

    if (availabilitySection && availabilitySection.children.length === 0) {
        // Only load if the section is empty
        fetch(window.location.origin + '/doctor/availability')
        .then(response => response.text())
        .then(html => {
            availabilitySection.innerHTML = html;
            // Initialize availability calendar
            initAvailabilityCalendar();
        })
        .catch(error => {
            console.error('Error loading availability section:', error);
            availabilitySection.innerHTML = '<div class="error-message">Failed to load availability settings. Please try again later.</div>';
        });
    }
}

/**
 * Initialize availability calendar
 */
function initAvailabilityCalendar() {
    // This would be implemented once the availability section is loaded
    // Using FullCalendar library
}

/**
 * Load health packages section content
 */
function loadPackagesSection() {
    const packagesSection = document.getElementById('packages-section');

    if (packagesSection && packagesSection.children.length === 0) {
        // Only load if the section is empty
        fetch(window.location.origin + '/doctor/packages')
        .then(response => response.text())
        .then(html => {
            packagesSection.innerHTML = html;
            // Initialize packages-specific functionality
        })
        .catch(error => {
            console.error('Error loading packages section:', error);
            packagesSection.innerHTML = '<div class="error-message">Failed to load health packages. Please try again later.</div>';
        });
    }
}

/**
 * Load settings section content
 */
function loadSettingsSection() {
    const settingsSection = document.getElementById('settings-section');

    if (settingsSection && settingsSection.children.length === 0) {
        // Only load if the section is empty
        fetch(window.location.origin + '/doctor/settings')
        .then(response => response.text())
        .then(html => {
            settingsSection.innerHTML = html;
            // Initialize settings-specific functionality
        })
        .catch(error => {
            console.error('Error loading settings section:', error);
            settingsSection.innerHTML = '<div class="error-message">Failed to load settings. Please try again later.</div>';
        });
    }
}
