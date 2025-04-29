// Wait for the document to be ready
$(document).ready(function() {
    // Add active class to current menu item
    const currentLocation = window.location.pathname;
    $('.menu-link').each(function() {
        const linkPath = $(this).attr('href');
        if (currentLocation.includes(linkPath) && linkPath !== '/') {
            $(this).parent().addClass('active');
        }
    });

    // Initialize tooltips
    $('[data-toggle="tooltip"]').tooltip();

    // Initialize popovers
    $('[data-toggle="popover"]').popover();

    // Smooth scrolling for anchor links
    $('a.smooth-scroll').click(function(event) {
        if (this.hash !== '') {
            event.preventDefault();
            const hash = this.hash;
            $('html, body').animate({
                scrollTop: $(hash).offset().top
            }, 800, function() {
                window.location.hash = hash;
            });
        }
    });
});
