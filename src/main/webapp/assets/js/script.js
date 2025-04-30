// Main JavaScript for Doctor Appointment System
// Enhanced to replace Bootstrap functionality

document.addEventListener('DOMContentLoaded', function() {
    // Mobile Menu Toggle
    const mobileMenuBtn = document.querySelector('.mobile-menu');
    const navLinks = document.querySelector('.nav-links');

    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', function() {
            navLinks.classList.toggle('show');
            this.classList.toggle('active');
        });
    }

    // Dropdown functionality (Bootstrap replacement)
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

    // Modal functionality (Bootstrap replacement)
    const modalTriggers = document.querySelectorAll('[data-toggle="modal"]');

    modalTriggers.forEach(function(trigger) {
        trigger.addEventListener('click', function(e) {
            e.preventDefault();
            const modalId = this.getAttribute('data-target');
            const modal = document.querySelector(modalId);

            if (modal) {
                modal.classList.add('show');
                document.body.classList.add('modal-open');
            }
        });
    });

    // Close modal with close button
    const modalCloseButtons = document.querySelectorAll('[data-dismiss="modal"]');

    modalCloseButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            const modal = this.closest('.modal');

            if (modal) {
                modal.classList.remove('show');
                document.body.classList.remove('modal-open');
            }
        });
    });

    // Close modal when clicking outside
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal') && e.target.classList.contains('show')) {
            e.target.classList.remove('show');
            document.body.classList.remove('modal-open');
        }
    });

    // Password visibility toggle
    const passwordToggles = document.querySelectorAll('.password-toggle');

    passwordToggles.forEach(toggle => {
        toggle.addEventListener('click', function() {
            const passwordField = this.previousElementSibling;
            const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordField.setAttribute('type', type);
            this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
        });
    });

    // Form validation
    const forms = document.querySelectorAll('form');

    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const requiredFields = form.querySelectorAll('[required]');
            let isValid = true;

            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.classList.add('is-invalid');
                } else {
                    field.classList.remove('is-invalid');
                }
            });

            if (!isValid) {
                e.preventDefault();
                alert('Please fill in all required fields');
            }
        });
    });

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();

            const targetId = this.getAttribute('href');
            if (targetId === '#') return;

            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80,
                    behavior: 'smooth'
                });
            }
        });
    });

    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');

    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            setTimeout(() => {
                alert.style.display = 'none';
            }, 500);
        }, 5000);
    });

    // Tabs functionality (Bootstrap replacement)
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

            // Add active class to current tab
            this.classList.add('active');

            // Hide all tab content
            const tabContentId = this.getAttribute('href') || this.getAttribute('data-target');
            const tabContents = document.querySelectorAll('.tab-pane');

            tabContents.forEach(function(content) {
                content.classList.remove('active', 'show');
            });

            // Show current tab content
            const activeContent = document.querySelector(tabContentId);
            if (activeContent) {
                activeContent.classList.add('active', 'show');
            }
        });
    });

    // Collapse functionality (Bootstrap replacement)
    const collapseToggles = document.querySelectorAll('[data-toggle="collapse"]');

    collapseToggles.forEach(function(toggle) {
        toggle.addEventListener('click', function(e) {
            e.preventDefault();

            const targetId = this.getAttribute('data-target') || this.getAttribute('href');
            const target = document.querySelector(targetId);

            if (target) {
                target.classList.toggle('show');

                // Update aria-expanded attribute
                const expanded = target.classList.contains('show');
                this.setAttribute('aria-expanded', expanded);
            }
        });
    });
});
