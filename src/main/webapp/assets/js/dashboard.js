// Dashboard JavaScript for Doctor Appointment System

document.addEventListener('DOMContentLoaded', function() {
    // Sidebar Toggle
    const menuToggle = document.getElementById('menuToggle');
    const sidebarClose = document.getElementById('sidebarClose');
    const sidebar = document.querySelector('.sidebar');
    const mainContent = document.querySelector('.main-content');
    
    if (menuToggle) {
        menuToggle.addEventListener('click', function() {
            sidebar.classList.add('active');
        });
    }
    
    if (sidebarClose) {
        sidebarClose.addEventListener('click', function() {
            sidebar.classList.remove('active');
        });
    }
    
    // Handle window resize
    window.addEventListener('resize', function() {
        if (window.innerWidth > 992) {
            sidebar.classList.remove('active');
        }
    });
    
    // Dropdown Toggles
    const userProfile = document.querySelector('.user-profile');
    if (userProfile) {
        userProfile.addEventListener('click', function(e) {
            e.stopPropagation();
            this.classList.toggle('active');
        });
    }
    
    // Close dropdowns when clicking outside
    document.addEventListener('click', function() {
        const dropdowns = document.querySelectorAll('.active');
        dropdowns.forEach(dropdown => {
            if (dropdown !== sidebar) {
                dropdown.classList.remove('active');
            }
        });
    });
    
    // Chart animations
    const animateCharts = () => {
        // Animate bar charts
        const barItems = document.querySelectorAll('.bar-fill');
        barItems.forEach(bar => {
            const height = bar.style.height;
            bar.style.height = '0';
            setTimeout(() => {
                bar.style.height = height;
            }, 100);
        });
        
        // Animate donut chart
        const donutSegments = document.querySelectorAll('.donut-segment');
        donutSegments.forEach((segment, index) => {
            segment.style.opacity = '0';
            setTimeout(() => {
                segment.style.opacity = '1';
            }, 100 * index);
        });
        
        // Animate stat cards
        const statCards = document.querySelectorAll('.stat-card');
        statCards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 100 * index);
        });
    };
    
    // Run animations when page loads
    setTimeout(animateCharts, 300);
    
    // Initialize tooltips
    const initTooltips = () => {
        const tooltips = document.querySelectorAll('[data-tooltip]');
        tooltips.forEach(tooltip => {
            tooltip.addEventListener('mouseenter', function() {
                const tooltipText = this.getAttribute('data-tooltip');
                const tooltipEl = document.createElement('div');
                tooltipEl.className = 'tooltip';
                tooltipEl.textContent = tooltipText;
                this.appendChild(tooltipEl);
                
                setTimeout(() => {
                    tooltipEl.style.opacity = '1';
                    tooltipEl.style.transform = 'translate(-50%, -10px)';
                }, 10);
            });
            
            tooltip.addEventListener('mouseleave', function() {
                const tooltipEl = this.querySelector('.tooltip');
                if (tooltipEl) {
                    tooltipEl.style.opacity = '0';
                    tooltipEl.style.transform = 'translate(-50%, 0)';
                    setTimeout(() => {
                        tooltipEl.remove();
                    }, 300);
                }
            });
        });
    };
    
    initTooltips();
    
    // Tab switching functionality
    const initTabs = () => {
        const tabButtons = document.querySelectorAll('[data-tab-target]');
        const tabContents = document.querySelectorAll('[data-tab-content]');
        
        tabButtons.forEach(button => {
            button.addEventListener('click', () => {
                const target = button.dataset.tabTarget;
                
                // Deactivate all tabs
                tabButtons.forEach(btn => btn.classList.remove('active'));
                tabContents.forEach(content => content.classList.remove('active'));
                
                // Activate clicked tab
                button.classList.add('active');
                document.querySelector(target).classList.add('active');
            });
        });
    };
    
    initTabs();
    
    // Data line animation for charts
    const dataPoints = document.querySelectorAll('.data-point');
    if (dataPoints.length > 0) {
        const dataLine = document.querySelector('.data-line');
        if (dataLine) {
            // Create path for data line
            let path = '';
            dataPoints.forEach((point, index) => {
                const x = point.style.getPropertyValue('--x');
                const y = point.style.getPropertyValue('--y');
                if (index === 0) {
                    path += `M ${x} ${y}`;
                } else {
                    path += ` L ${x} ${y}`;
                }
            });
            
            // Animate data line
            setTimeout(() => {
                dataLine.style.opacity = '1';
            }, 500);
        }
    }
    
    // Appointment card hover effects
    const appointmentCards = document.querySelectorAll('.appointment-card');
    appointmentCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 8px 15px rgba(0, 0, 0, 0.1)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '0 2px 5px rgba(0, 0, 0, 0.1)';
        });
    });
});
