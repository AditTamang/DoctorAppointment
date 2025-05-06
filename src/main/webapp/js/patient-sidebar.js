// Patient Sidebar JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Mobile menu toggle
    const menuToggle = document.querySelector('.menu-toggle');
    if (menuToggle) {
        menuToggle.addEventListener('click', function() {
            const sidebar = document.querySelector('.sidebar');
            const sidebarMenu = document.querySelector('.sidebar-menu');
            
            if (sidebar) {
                sidebar.classList.toggle('active');
            }
            
            if (sidebarMenu) {
                sidebarMenu.classList.toggle('active');
            }
        });
    }
    
    // Close sidebar when clicking outside on mobile
    document.addEventListener('click', function(event) {
        const sidebar = document.querySelector('.sidebar');
        const menuToggle = document.querySelector('.menu-toggle');
        
        if (sidebar && menuToggle && window.innerWidth <= 768) {
            if (!sidebar.contains(event.target) && !menuToggle.contains(event.target)) {
                sidebar.classList.remove('active');
                document.querySelector('.sidebar-menu').classList.remove('active');
            }
        }
    });
    
    // Add mobile menu toggle button if it doesn't exist
    const sidebar = document.querySelector('.sidebar');
    if (sidebar && !document.querySelector('.menu-toggle')) {
        const menuToggle = document.createElement('div');
        menuToggle.className = 'menu-toggle';
        menuToggle.innerHTML = '<i class="fas fa-bars"></i>';
        
        sidebar.appendChild(menuToggle);
        
        menuToggle.addEventListener('click', function() {
            sidebar.classList.toggle('active');
            document.querySelector('.sidebar-menu').classList.toggle('active');
        });
    }
});
