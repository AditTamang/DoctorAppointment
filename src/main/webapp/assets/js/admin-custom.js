/**
 * Custom JavaScript to replace Bootstrap functionality
 */

// Custom Modal implementation to replace Bootstrap Modal
class CustomModal {
    constructor(element) {
        this.element = element;
        this.backdrop = null;
    }

    show() {
        // Create backdrop if it doesn't exist
        if (!document.querySelector('.modal-backdrop')) {
            this.backdrop = document.createElement('div');
            this.backdrop.className = 'modal-backdrop';
            document.body.appendChild(this.backdrop);
        }

        // Show modal
        this.element.classList.add('show');
        document.body.classList.add('modal-open');
    }

    hide() {
        this.element.classList.remove('show');
        document.body.classList.remove('modal-open');

        // Remove backdrop
        if (this.backdrop) {
            this.backdrop.remove();
            this.backdrop = null;
        }
    }

    toggle() {
        if (this.element.classList.contains('show')) {
            this.hide();
        } else {
            this.show();
        }
    }

    static getInstance(element) {
        return new CustomModal(element);
    }
}

// Make CustomModal available globally
window.customModal = {
    Modal: CustomModal
};

document.addEventListener('DOMContentLoaded', function() {
    // Alert dismissal
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        const closeBtn = alert.querySelector('.btn-close');
        if (closeBtn) {
            closeBtn.addEventListener('click', function() {
                alert.style.display = 'none';
            });
        }
    });

    // Dropdown functionality
    const dropdownToggles = document.querySelectorAll('.dropdown-toggle');
    dropdownToggles.forEach(function(toggle) {
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            const dropdown = this.nextElementSibling;

            // Close all other dropdowns
            document.querySelectorAll('.dropdown-menu.show').forEach(function(menu) {
                if (menu !== dropdown) {
                    menu.classList.remove('show');
                }
            });

            // Toggle current dropdown
            dropdown.classList.toggle('show');
        });
    });

    // Close dropdowns when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.dropdown')) {
            document.querySelectorAll('.dropdown-menu.show').forEach(function(menu) {
                menu.classList.remove('show');
            });
        }
    });

    // Modal functionality
    const modalTriggers = document.querySelectorAll('[data-toggle="modal"]');
    modalTriggers.forEach(function(trigger) {
        trigger.addEventListener('click', function(e) {
            e.preventDefault();
            const modalId = this.getAttribute('data-target');
            const modal = document.querySelector(modalId);

            if (modal) {
                modal.classList.add('show');
                document.body.classList.add('modal-open');

                // Create backdrop if it doesn't exist
                if (!document.querySelector('.modal-backdrop')) {
                    const backdrop = document.createElement('div');
                    backdrop.className = 'modal-backdrop';
                    document.body.appendChild(backdrop);
                }
            }
        });
    });

    // Close modal functionality
    const modalCloseButtons = document.querySelectorAll('[data-dismiss="modal"]');
    modalCloseButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            const modal = this.closest('.modal');
            if (modal) {
                modal.classList.remove('show');
                document.body.classList.remove('modal-open');

                // Remove backdrop
                const backdrop = document.querySelector('.modal-backdrop');
                if (backdrop) {
                    backdrop.remove();
                }
            }
        });
    });

    // Close modal when clicking outside
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal') && e.target.classList.contains('show')) {
            e.target.classList.remove('show');
            document.body.classList.remove('modal-open');

            // Remove backdrop
            const backdrop = document.querySelector('.modal-backdrop');
            if (backdrop) {
                backdrop.remove();
            }
        }
    });

    // Tooltip functionality
    const tooltips = document.querySelectorAll('[data-toggle="tooltip"]');
    tooltips.forEach(function(tooltip) {
        const title = tooltip.getAttribute('title') || tooltip.getAttribute('data-title');
        if (title) {
            tooltip.addEventListener('mouseenter', function() {
                // Create tooltip element
                const tooltipElement = document.createElement('div');
                tooltipElement.className = 'custom-tooltip';
                tooltipElement.textContent = title;
                document.body.appendChild(tooltipElement);

                // Position tooltip
                const rect = tooltip.getBoundingClientRect();
                tooltipElement.style.top = (rect.top - tooltipElement.offsetHeight - 5) + 'px';
                tooltipElement.style.left = (rect.left + (rect.width / 2) - (tooltipElement.offsetWidth / 2)) + 'px';
                tooltipElement.style.opacity = '1';
            });

            tooltip.addEventListener('mouseleave', function() {
                const tooltipElement = document.querySelector('.custom-tooltip');
                if (tooltipElement) {
                    tooltipElement.remove();
                }
            });
        }
    });

    // Collapse functionality
    const collapseToggles = document.querySelectorAll('[data-toggle="collapse"]');
    collapseToggles.forEach(function(toggle) {
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('data-target') || this.getAttribute('href');
            const target = document.querySelector(targetId);

            if (target) {
                target.classList.toggle('show');
            }
        });
    });

    // Tab functionality
    const tabLinks = document.querySelectorAll('[data-toggle="tab"]');
    tabLinks.forEach(function(link) {
        link.addEventListener('click', function(e) {
            e.preventDefault();

            // Remove active class from all tabs
            const tabContainer = this.closest('.nav-tabs, .nav-pills');
            if (tabContainer) {
                tabContainer.querySelectorAll('.nav-link').forEach(function(navLink) {
                    navLink.classList.remove('active');
                });
            }

            // Add active class to clicked tab
            this.classList.add('active');

            // Hide all tab content
            const tabContentContainer = document.querySelector(this.getAttribute('data-tab-content') || '.tab-content');
            if (tabContentContainer) {
                tabContentContainer.querySelectorAll('.tab-pane').forEach(function(pane) {
                    pane.classList.remove('active');
                });
            }

            // Show target tab content
            const targetId = this.getAttribute('data-target') || this.getAttribute('href');
            const target = document.querySelector(targetId);
            if (target) {
                target.classList.add('active');
            }
        });
    });
});
