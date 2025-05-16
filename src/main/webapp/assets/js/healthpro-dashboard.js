/**
 * HealthPro Dashboard JavaScript
 * This file contains all the JavaScript functionality for the HealthPro dashboard
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Dashboard JS loaded');
    // Initialize the dashboard
    initDashboard();

    // Set up event listeners
    setupEventListeners();

    // Initialize stats counters
    initStatsCounters();
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

            // Get the tab content to show
            const tabName = this.textContent.trim().toLowerCase();
            const tabContents = document.querySelectorAll('.tab-content');

            // Hide all tab contents
            tabContents.forEach(content => {
                content.style.display = 'none';
            });

            // Show the selected tab content
            const selectedContent = document.getElementById(tabName + '-content');
            if (selectedContent) {
                selectedContent.style.display = 'block';
            } else {
                // If no specific content found, show the first one as default
                if (tabContents.length > 0) {
                    tabContents[0].style.display = 'block';
                }
            }
        });
    });

    // Activate the first tab by default
    if (tabs.length > 0) {
        tabs[0].click();
    }
}

/**
 * Initialize dropdowns
 */
function initDropdowns() {
    // User profile dropdown
    const userProfile = document.querySelector('.user-profile');

    if (userProfile) {
        userProfile.addEventListener('click', function(e) {
            // Create dropdown if it doesn't exist
            let dropdown = document.querySelector('.user-dropdown');

            if (!dropdown) {
                dropdown = document.createElement('div');
                dropdown.className = 'user-dropdown';
                dropdown.innerHTML = `
                    <ul>
                        <li><a href="${contextPath}/doctor/profile"><i class="fas fa-user"></i> My Profile</a></li>
                        <li><a href="${contextPath}/doctor/settings"><i class="fas fa-cog"></i> Settings</a></li>
                        <li><a href="${contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                `;
                document.body.appendChild(dropdown);
            }

            // Position the dropdown
            const rect = userProfile.getBoundingClientRect();
            dropdown.style.top = (rect.bottom + window.scrollY) + 'px';
            dropdown.style.right = (window.innerWidth - rect.right) + 'px';

            // Toggle visibility
            dropdown.classList.toggle('show');

            // Prevent event from bubbling up
            e.stopPropagation();
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function() {
            const dropdown = document.querySelector('.user-dropdown');
            if (dropdown && dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            }
        });
    }
}

/**
 * Initialize stats counters with animation
 */
function initStatsCounters() {
    const statValues = document.querySelectorAll('.stat-value');

    statValues.forEach(statValue => {
        const targetValue = parseInt(statValue.textContent.trim(), 10);
        if (!isNaN(targetValue)) {
            // Start from 0
            let currentValue = 0;
            const duration = 1500; // Animation duration in ms
            const interval = 50; // Update interval in ms
            const steps = duration / interval;
            const increment = targetValue / steps;

            // Animate the counter
            const counter = setInterval(() => {
                currentValue += increment;

                // Check if we've reached the target
                if (currentValue >= targetValue) {
                    clearInterval(counter);
                    currentValue = targetValue;
                }

                // Update the display
                // For decimal values (like ratings), show one decimal place
                if (statValue.textContent.includes('.')) {
                    statValue.textContent = currentValue.toFixed(1);
                } else {
                    statValue.textContent = Math.floor(currentValue);
                }
            }, interval);
        }
    });
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
            fetch(contextPath + '/doctor/toggle-status', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Network response was not ok');
            })
            .then(data => {
                if (data.success) {
                    // Update button text based on new status
                    this.textContent = data.status === 'ACTIVE' ? 'Set Active Off' : 'Set Active On';

                    // Show a success message
                    showNotification('Status updated successfully', 'success');
                } else {
                    showNotification('Failed to update status', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                // If the fetch fails, still toggle the button text for demo purposes
                const currentText = this.textContent;
                this.textContent = currentText.includes('Off') ? 'Set Active On' : 'Set Active Off';
                showNotification('Status updated (demo mode)', 'success');
            });
        });
    }

    // Delete profile button
    const deleteProfileBtn = document.querySelector('.btn-danger');
    if (deleteProfileBtn) {
        deleteProfileBtn.addEventListener('click', function() {
            if (confirm('Are you sure you want to delete your profile? This action cannot be undone.')) {
                // In a real app, this would make an AJAX call to delete the profile
                // For demo purposes, just show a notification
                showNotification('Profile deletion is disabled in demo mode', 'warning');
            }
        });
    }
}

/**
 * Show a notification message
 * @param {string} message - The message to display
 * @param {string} type - The type of notification (success, error, warning, info)
 */
function showNotification(message, type = 'info') {
    // Create notification element if it doesn't exist
    let notification = document.querySelector('.notification');

    if (!notification) {
        notification = document.createElement('div');
        notification.className = 'notification';
        document.body.appendChild(notification);
    }

    // Set the message and type
    notification.textContent = message;
    notification.className = 'notification ' + type;

    // Show the notification
    notification.classList.add('show');

    // Hide after 3 seconds
    setTimeout(() => {
        notification.classList.remove('show');
    }, 3000);
}

/**
 * Set up search functionality
 */
function setupSearch() {
    const searchInput = document.querySelector('.search-input');

    if (searchInput) {
        searchInput.addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
                const searchTerm = this.value.trim().toLowerCase();

                if (searchTerm) {
                    // Filter table rows based on search term
                    const tableRows = document.querySelectorAll('table tbody tr');

                    tableRows.forEach(row => {
                        const text = row.textContent.toLowerCase();
                        if (text.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });

                    // Show a message if no results found
                    const visibleRows = document.querySelectorAll('table tbody tr:not([style*="display: none"])');
                    if (visibleRows.length === 0) {
                        showNotification('No results found for "' + searchTerm + '"', 'info');
                    } else {
                        showNotification('Found ' + visibleRows.length + ' results for "' + searchTerm + '"', 'success');
                    }
                } else {
                    // If search term is empty, show all rows
                    const tableRows = document.querySelectorAll('table tbody tr');
                    tableRows.forEach(row => {
                        row.style.display = '';
                    });
                }
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

            // Get the row data
            const row = this.closest('tr');
            const id = row.cells[0].textContent;
            const name = row.cells[1].textContent;

            // Show details in a modal
            showModal('View Details', `
                <h3>Details for ${name}</h3>
                <p><strong>ID:</strong> ${id}</p>
                <p><strong>Name:</strong> ${name}</p>
                <p><strong>Date:</strong> ${row.cells[2].textContent}</p>
                <p><strong>Status:</strong> ${row.cells[3].textContent}</p>
                <p><strong>Notes:</strong> ${row.cells[row.cells.length - 1].textContent}</p>
            `);
        });
    });

    // Edit buttons
    const editButtons = document.querySelectorAll('.action-btn.edit');
    editButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();

            // Get the row data
            const row = this.closest('tr');
            const id = row.cells[0].textContent;
            const name = row.cells[1].textContent;

            // Redirect to edit page or show edit modal
            // window.location.href = contextPath + '/doctor/edit-details?id=' + id;

            // For demo, just show a notification
            showNotification('Edit functionality is not implemented in demo mode', 'info');
        });
    });

    // Delete buttons
    const deleteButtons = document.querySelectorAll('.action-btn.delete');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();

            // Get the row data
            const row = this.closest('tr');
            const id = row.cells[0].textContent;
            const name = row.cells[1].textContent;

            if (confirm(`Are you sure you want to delete the record for ${name}?`)) {
                // For demo, just remove the row
                row.remove();
                showNotification('Record deleted successfully', 'success');
            }
        });
    });
}

/**
 * Show a modal dialog
 * @param {string} title - The modal title
 * @param {string} content - The HTML content for the modal body
 */
function showModal(title, content) {
    // Create modal if it doesn't exist
    let modal = document.querySelector('.modal');

    if (!modal) {
        modal = document.createElement('div');
        modal.className = 'modal';
        modal.innerHTML = `
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title"></h2>
                    <span class="modal-close">&times;</span>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button class="btn btn-primary modal-ok">OK</button>
                </div>
            </div>
        `;
        document.body.appendChild(modal);

        // Set up close button
        const closeBtn = modal.querySelector('.modal-close');
        closeBtn.addEventListener('click', () => {
            modal.style.display = 'none';
        });

        // Set up OK button
        const okBtn = modal.querySelector('.modal-ok');
        okBtn.addEventListener('click', () => {
            modal.style.display = 'none';
        });

        // Close when clicking outside the modal
        window.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.style.display = 'none';
            }
        });
    }

    // Set the title and content
    modal.querySelector('.modal-title').textContent = title;
    modal.querySelector('.modal-body').innerHTML = content;

    // Show the modal
    modal.style.display = 'block';
}
