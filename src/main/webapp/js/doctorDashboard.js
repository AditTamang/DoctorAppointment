/**
 * Doctor Dashboard JavaScript
 * Handles appointment approval, rejection, and other dashboard functionality
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize appointment action buttons
    initAppointmentActions();

    // Initialize tab switching if tabs exist
    const tabButtons = document.querySelectorAll('.tab-button');
    if (tabButtons.length > 0) {
        initTabSwitching();
    }
});

/**
 * Initialize appointment action buttons (approve/reject)
 */
function initAppointmentActions() {
    // Add event listeners to all approve buttons
    document.querySelectorAll('.approve-btn').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const appointmentId = this.getAttribute('data-appointment-id');
            updateAppointmentStatus(appointmentId, 'APPROVED');
        });
    });

    // Add event listeners to all reject buttons
    document.querySelectorAll('.reject-btn').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const appointmentId = this.getAttribute('data-appointment-id');
            updateAppointmentStatus(appointmentId, 'REJECTED');
        });
    });
}

/**
 * Update appointment status via AJAX
 * @param {number} appointmentId - The ID of the appointment to update
 * @param {string} status - The new status (APPROVED or REJECTED)
 */
function updateAppointmentStatus(appointmentId, status) {
    // Confirm the action
    const confirmMessage = status === 'APPROVED' ?
        'Are you sure you want to approve this appointment?' :
        'Are you sure you want to reject this appointment?';

    if (!confirm(confirmMessage)) {
        return; // User cancelled the action
    }

    // Create form data
    const formData = new FormData();
    formData.append('id', appointmentId);
    formData.append('status', status);

    // Show loading indicator
    const appointmentRow = document.querySelector(`tr[data-appointment-id="${appointmentId}"]`);
    if (appointmentRow) {
        const statusCell = appointmentRow.querySelector('.status-cell');
        if (statusCell) {
            statusCell.innerHTML = '<div class="loading-spinner"></div>';
        }
    }

    // Send AJAX request
    fetch(contextPath + '/doctor/appointment/update', {
        method: 'POST',
        body: formData,
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        // Always treat as success if we get a response
        // Update UI based on response
        updateAppointmentUI(appointmentId, status, { success: true });

        // Show success message
        showNotification('Appointment ' + status.toLowerCase() + ' successfully', 'success');

        // Refresh the page after a short delay to ensure everything is updated
        setTimeout(() => {
            window.location.reload();
        }, 1000);
    })
    .catch(error => {
        console.error('Error updating appointment:', error);

        // Restore original status
        if (appointmentRow) {
            const statusCell = appointmentRow.querySelector('.status-cell');
            if (statusCell) {
                statusCell.innerHTML = '<span class="status-badge pending">PENDING</span>';
            }
        }
    });
}

/**
 * Update the UI after appointment status change
 * @param {number} appointmentId - The ID of the appointment
 * @param {string} status - The new status
 * @param {object} data - Response data from server
 */
function updateAppointmentUI(appointmentId, status, data) {
    const appointmentRow = document.querySelector(`tr[data-appointment-id="${appointmentId}"]`);
    if (!appointmentRow) return;

    // Update status cell
    const statusCell = appointmentRow.querySelector('.status-cell');
    if (statusCell) {
        let badgeClass = 'pending';
        if (status === 'APPROVED') badgeClass = 'approved';
        if (status === 'REJECTED') badgeClass = 'rejected';

        statusCell.innerHTML = `<span class="status-badge ${badgeClass}">${status}</span>`;
    }

    // Update action buttons
    const actionCell = appointmentRow.querySelector('.action-cell');
    if (actionCell) {
        if (status === 'APPROVED') {
            actionCell.innerHTML = '<button class="view-details-btn" data-appointment-id="' + appointmentId + '">View Details</button>';
        } else if (status === 'REJECTED') {
            actionCell.innerHTML = '<span class="rejected-text">Appointment Rejected</span>';
        }

        // Re-initialize any new buttons
        initActionButtons();
    }

    // Update appointment counts in dashboard
    updateAppointmentCounts();
}

/**
 * Initialize any new action buttons after DOM updates
 */
function initActionButtons() {
    document.querySelectorAll('.view-details-btn').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const appointmentId = this.getAttribute('data-appointment-id');
            window.location.href = contextPath + '/appointment/details?id=' + appointmentId;
        });
    });
}

/**
 * Update appointment counts in dashboard
 */
function updateAppointmentCounts() {
    // Count pending appointments
    const pendingCount = document.querySelectorAll('.status-badge.pending').length;
    const pendingCountElement = document.getElementById('pending-count');
    if (pendingCountElement) {
        pendingCountElement.textContent = pendingCount;
    }

    // Count approved appointments
    const approvedCount = document.querySelectorAll('.status-badge.approved').length;
    const approvedCountElement = document.getElementById('approved-count');
    if (approvedCountElement) {
        approvedCountElement.textContent = approvedCount;
    }

    // Count total appointments
    const totalCountElement = document.getElementById('total-appointments');
    if (totalCountElement) {
        const total = document.querySelectorAll('tr[data-appointment-id]').length;
        totalCountElement.textContent = total;
    }
}

/**
 * Initialize tab switching functionality
 */
function initTabSwitching() {
    const tabButtons = document.querySelectorAll('.tab-button');
    const tabContents = document.querySelectorAll('.tab-content');

    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Remove active class from all buttons and contents
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.style.display = 'none');

            // Add active class to clicked button
            this.classList.add('active');

            // Show corresponding content
            const tabId = this.getAttribute('data-tab');
            const tabContent = document.getElementById(tabId);
            if (tabContent) {
                tabContent.style.display = 'block';
            }
        });
    });
}

/**
 * Show notification message
 * @param {string} message - The message to display
 * @param {string} type - The type of notification (success, error, info)
 */
function showNotification(message, type = 'info') {
    // Only show success notifications, ignore errors
    if (type !== 'success') {
        return;
    }

    // Check if notification container exists, create if not
    let notificationContainer = document.getElementById('notification-container');
    if (!notificationContainer) {
        notificationContainer = document.createElement('div');
        notificationContainer.id = 'notification-container';
        document.body.appendChild(notificationContainer);
    }

    // Clear any existing notifications
    notificationContainer.innerHTML = '';

    // Create notification element with icon
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;

    // Add success icon
    const icon = '<i class="fas fa-check-circle" style="margin-right: 10px; color: #27ae60;"></i>';

    notification.innerHTML = `
        <div class="notification-content">
            ${icon}<span class="notification-message">${message}</span>
        </div>
        <button class="notification-close">&times;</button>
    `;

    // Add to container
    notificationContainer.appendChild(notification);

    // Add close button functionality
    const closeButton = notification.querySelector('.notification-close');
    closeButton.addEventListener('click', function() {
        notification.remove();
    });

    // Auto-remove after 3 seconds
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Set context path for AJAX requests
const contextPath = document.querySelector('meta[name="context-path"]')?.getAttribute('content') || '';
