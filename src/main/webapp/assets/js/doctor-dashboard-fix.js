/**
 * Doctor Dashboard JavaScript - Fixed Version
 * Handles appointment management functionality
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize tab switching
    initTabSwitching();

    // Initialize appointment action buttons
    initAppointmentActions();

    // Initialize search functionality
    initSearch();

    // Initialize date filter
    initDateFilter();
});

/**
 * Initialize tab switching functionality
 */
function initTabSwitching() {
    const tabs = document.querySelectorAll('.appointment-tab');
    const tabContents = document.querySelectorAll('.tab-content');

    tabs.forEach(tab => {
        tab.addEventListener('click', function() {
            // Get the tab name
            const tabName = this.getAttribute('data-tab');

            // Remove active class from all tabs
            tabs.forEach(t => t.classList.remove('active'));

            // Add active class to clicked tab
            this.classList.add('active');

            // Hide all tab contents
            tabContents.forEach(content => {
                content.style.display = 'none';
            });

            // Show the selected tab content
            const selectedContent = document.getElementById(tabName);
            if (selectedContent) {
                selectedContent.style.display = 'block';
            }
        });
    });
}

/**
 * Initialize appointment action buttons
 */
function initAppointmentActions() {
    // Add event listeners to all action buttons
    document.querySelectorAll('.action-btn').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const appointmentId = this.getAttribute('data-appointment-id');

            if (this.classList.contains('approve-btn')) {
                updateAppointmentStatus(appointmentId, 'APPROVED');
            } else if (this.classList.contains('reject-btn')) {
                updateAppointmentStatus(appointmentId, 'REJECTED');
            } else if (this.classList.contains('complete-btn')) {
                updateAppointmentStatus(appointmentId, 'COMPLETED');
            } else if (this.classList.contains('view-btn')) {
                viewAppointmentDetails(appointmentId);
            }
        });
    });
}

/**
 * Update appointment status
 * @param {string} appointmentId - The ID of the appointment
 * @param {string} status - The new status (APPROVED, REJECTED, or COMPLETED)
 */
function updateAppointmentStatus(appointmentId, status) {
    // Confirm the action
    let confirmMessage = '';
    switch (status) {
        case 'APPROVED':
            confirmMessage = 'Are you sure you want to approve this appointment?';
            break;
        case 'REJECTED':
            confirmMessage = 'Are you sure you want to reject this appointment?';
            break;
        case 'COMPLETED':
            confirmMessage = 'Are you sure you want to mark this appointment as completed?';
            break;
        default:
            confirmMessage = 'Are you sure you want to update this appointment status?';
    }

    if (!confirm(confirmMessage)) {
        return;
    }

    // Create form data
    const formData = new FormData();
    formData.append('id', appointmentId);
    formData.append('status', status);

    // Get the context path
    const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';

    // Send AJAX request
    fetch(`${contextPath}/doctor/appointment/update-status-fix`, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            // Update UI
            updateAppointmentUI(appointmentId, status);

            // Show success message
            showNotification(`Appointment ${status.toLowerCase()} successfully`, 'success');

            // Reload the page after a short delay
            setTimeout(() => {
                window.location.reload();
            }, 1500);
        } else {
            throw new Error('Failed to update appointment status');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Failed to update appointment status. Please try again.', 'error');
    });
}

/**
 * Update appointment UI after status change
 * @param {string} appointmentId - The ID of the appointment
 * @param {string} status - The new status
 */
function updateAppointmentUI(appointmentId, status) {
    const appointmentRow = document.querySelector(`tr[data-appointment-id="${appointmentId}"]`);
    if (!appointmentRow) return;

    // Update status cell
    const statusCell = appointmentRow.querySelector('.status-cell');
    if (statusCell) {
        let statusHTML = '';

        if (status === 'APPROVED') {
            statusHTML = '<span class="status-badge approved">Approved</span>';
        } else if (status === 'REJECTED') {
            statusHTML = '<span class="status-badge rejected">Rejected</span>';
        } else if (status === 'COMPLETED') {
            statusHTML = '<span class="status-badge completed">Completed</span>';
        }

        statusCell.innerHTML = statusHTML;
    }

    // Update action cell
    const actionCell = appointmentRow.querySelector('.action-cell');
    if (actionCell) {
        let actionHTML = '';

        if (status === 'APPROVED') {
            actionHTML = `
                <div class="action-buttons">
                    <button class="action-btn view-btn" data-appointment-id="${appointmentId}">
                        <i class="fas fa-eye"></i> View
                    </button>
                    <button class="action-btn complete-btn" data-appointment-id="${appointmentId}">
                        <i class="fas fa-check-double"></i> Complete
                    </button>
                </div>
            `;
        } else {
            actionHTML = `
                <div class="action-buttons">
                    <button class="action-btn view-btn" data-appointment-id="${appointmentId}">
                        <i class="fas fa-eye"></i> View
                    </button>
                </div>
            `;
        }

        actionCell.innerHTML = actionHTML;

        // Re-initialize buttons
        const viewBtn = actionCell.querySelector('.view-btn');
        if (viewBtn) {
            viewBtn.addEventListener('click', function(e) {
                e.preventDefault();
                viewAppointmentDetails(appointmentId);
            });
        }

        const completeBtn = actionCell.querySelector('.complete-btn');
        if (completeBtn) {
            completeBtn.addEventListener('click', function(e) {
                e.preventDefault();
                updateAppointmentStatus(appointmentId, 'COMPLETED');
            });
        }
    }
}

/**
 * View appointment details
 * @param {string} appointmentId - The ID of the appointment
 */
function viewAppointmentDetails(appointmentId) {
    // Get the context path
    const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';

    // Redirect to appointment details page
    window.location.href = `${contextPath}/doctor/appointment/details?id=${appointmentId}`;
}

/**
 * Initialize search functionality
 */
function initSearch() {
    const searchInput = document.getElementById('search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const activeTab = document.querySelector('.appointment-tab.active').getAttribute('data-tab');
            const tableRows = document.querySelectorAll(`#${activeTab} tbody tr`);

            tableRows.forEach(row => {
                if (row.querySelector('td.empty-state')) {
                    return; // Skip empty state rows
                }

                const patientName = row.querySelector('td:first-child').textContent.toLowerCase();
                if (patientName.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });

            // Check if all rows are hidden, show empty state
            const visibleRows = Array.from(tableRows).filter(row => row.style.display !== 'none' && !row.querySelector('td.empty-state'));
            const emptyStateRow = document.querySelector(`#${activeTab} tbody tr td.empty-state`);

            if (visibleRows.length === 0 && !emptyStateRow) {
                const tbody = document.querySelector(`#${activeTab} tbody`);
                const tr = document.createElement('tr');
                tr.classList.add('empty-search-results');
                tr.innerHTML = `
                    <td colspan="6" class="empty-state">
                        <h4>No results found</h4>
                        <p>No appointments match your search criteria.</p>
                    </td>
                `;
                tbody.appendChild(tr);
            } else if (visibleRows.length > 0) {
                const emptySearchResults = document.querySelector(`#${activeTab} tbody tr.empty-search-results`);
                if (emptySearchResults) {
                    emptySearchResults.remove();
                }
            }
        });
    }
}

/**
 * Initialize date filter functionality
 */
function initDateFilter() {
    const dateFilter = document.getElementById('date-filter');
    if (dateFilter) {
        dateFilter.addEventListener('change', function() {
            const filterValue = this.value;
            const activeTab = document.querySelector('.appointment-tab.active').getAttribute('data-tab');
            const tableRows = document.querySelectorAll(`#${activeTab} tbody tr`);

            if (filterValue === 'all') {
                tableRows.forEach(row => {
                    if (!row.querySelector('td.empty-state')) {
                        row.style.display = '';
                    }
                });
                return;
            }

            const today = new Date();
            today.setHours(0, 0, 0, 0);

            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);

            const weekEnd = new Date(today);
            weekEnd.setDate(weekEnd.getDate() + 7);

            const monthEnd = new Date(today);
            monthEnd.setMonth(monthEnd.getMonth() + 1);

            tableRows.forEach(row => {
                if (row.querySelector('td.empty-state')) {
                    return; // Skip empty state rows
                }

                const dateCell = row.querySelector('td:nth-child(2)').textContent;
                const appointmentDate = new Date(dateCell);
                appointmentDate.setHours(0, 0, 0, 0);

                let showRow = false;

                switch (filterValue) {
                    case 'today':
                        showRow = appointmentDate.getTime() === today.getTime();
                        break;
                    case 'tomorrow':
                        showRow = appointmentDate.getTime() === tomorrow.getTime();
                        break;
                    case 'week':
                        showRow = appointmentDate >= today && appointmentDate < weekEnd;
                        break;
                    case 'month':
                        showRow = appointmentDate >= today && appointmentDate < monthEnd;
                        break;
                }

                row.style.display = showRow ? '' : 'none';
            });

            // Check if all rows are hidden, show empty state
            const visibleRows = Array.from(tableRows).filter(row => row.style.display !== 'none' && !row.querySelector('td.empty-state'));
            const emptyStateRow = document.querySelector(`#${activeTab} tbody tr td.empty-state`);

            if (visibleRows.length === 0 && !emptyStateRow) {
                const tbody = document.querySelector(`#${activeTab} tbody`);
                const tr = document.createElement('tr');
                tr.classList.add('empty-filter-results');
                tr.innerHTML = `
                    <td colspan="6" class="empty-state">
                        <h4>No results found</h4>
                        <p>No appointments match your filter criteria.</p>
                    </td>
                `;
                tbody.appendChild(tr);
            } else if (visibleRows.length > 0) {
                const emptyFilterResults = document.querySelector(`#${activeTab} tbody tr.empty-filter-results`);
                if (emptyFilterResults) {
                    emptyFilterResults.remove();
                }
            }
        });
    }
}

/**
 * Show notification
 * @param {string} message - The message to display
 * @param {string} type - The type of notification (success, error)
 */
function showNotification(message, type = 'success') {
    const container = document.getElementById('notification-container');
    if (!container) {
        // Create container if it doesn't exist
        const newContainer = document.createElement('div');
        newContainer.id = 'notification-container';
        document.body.appendChild(newContainer);
        container = newContainer;
    }

    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;

    // Add to container
    container.appendChild(notification);

    // Show notification
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);

    // Remove notification after 3 seconds
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            container.removeChild(notification);
        }, 300);
    }, 3000);
}
