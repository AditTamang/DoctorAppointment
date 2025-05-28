/**
 * Profile Image Handler
 * Utility functions for handling profile images across the application
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize profile image handling
    initProfileImageHandling();
});

/**
 * Initialize profile image handling
 */
function initProfileImageHandling() {
    // Handle profile image upload preview
    const profileImageInput = document.getElementById('profileImage');
    if (profileImageInput) {
        profileImageInput.addEventListener('change', handleProfileImageChange);
    }

    // Handle profile image removal
    const removeImageBtn = document.querySelector('.remove-image-btn');
    if (removeImageBtn) {
        removeImageBtn.addEventListener('click', handleProfileImageRemoval);
    }

    // Handle image loading errors
    handleImageLoadErrors();
}

/**
 * Handle profile image change
 * @param {Event} event - The change event
 */
function handleProfileImageChange(event) {
    if (this.files && this.files[0]) {
        const reader = new FileReader();

        reader.onload = function(e) {
            // Update all profile images on the page
            updateAllProfileImages(e.target.result);

            // Reset remove flag if it exists
            const removeImageFlag = document.getElementById('removeImage');
            if (removeImageFlag) {
                removeImageFlag.value = "false";
            }
        };

        reader.readAsDataURL(this.files[0]);
    }
}

/**
 * Handle profile image removal
 */
function handleProfileImageRemoval() {
    // Get all profile image containers
    const imageContainers = document.querySelectorAll('.profile-image, .patient-avatar, .user-avatar, .doctor-image, .profile-avatar');

    imageContainers.forEach(container => {
        // Get the initials from data attribute
        const initials = container.getAttribute('data-initials');

        // Find the image element
        const img = container.querySelector('img');

        if (img) {
            // Remove the image
            img.remove();

            // Create and add initials element if we have initials data
            if (initials) {
                const initialsElement = document.createElement('div');
                initialsElement.className = 'profile-initials';
                initialsElement.textContent = initials;
                container.appendChild(initialsElement);
            }
        }
    });

    // Clear file input if it exists
    const profileImageInput = document.getElementById('profileImage');
    if (profileImageInput) {
        profileImageInput.value = '';
    }

    // Set remove flag if it exists
    const removeImageFlag = document.getElementById('removeImage');
    if (removeImageFlag) {
        removeImageFlag.value = "true";
    }
}

/**
 * Update all profile images on the page
 * @param {string} imageSrc - The image source
 * @param {boolean} isPath - Whether the image source is a path or a data URL
 */
function updateAllProfileImages(imageSrc, isPath = false) {
    // Get all profile image containers
    const imageContainers = document.querySelectorAll('.profile-image, .patient-avatar, .user-avatar, .doctor-image, .profile-avatar');

    imageContainers.forEach(container => {
        // Find the image element
        const img = container.querySelector('img');

        if (img) {
            // If it's a path, prepend the context path
            if (isPath) {
                const contextPath = document.body.getAttribute('data-context-path') || '';
                img.src = contextPath + imageSrc;
            } else {
                img.src = imageSrc;
            }
        } else {
            // If there's no image element but there are initials, replace with image
            const initials = container.querySelector('.profile-initials, .user-initials');
            if (initials) {
                // Store the initials text for potential fallback
                const initialsText = initials.textContent;

                // Remove initials
                container.removeChild(initials);

                // Create and add image
                const newImg = document.createElement('img');
                if (isPath) {
                    const contextPath = document.body.getAttribute('data-context-path') || '';
                    newImg.src = contextPath + imageSrc;
                } else {
                    newImg.src = imageSrc;
                }
                newImg.alt = "Profile";

                // Add error handler to fallback to initials if image fails to load
                newImg.addEventListener('error', function() {
                    this.remove();
                    const newInitials = document.createElement('div');
                    newInitials.className = 'profile-initials';
                    newInitials.textContent = initialsText;
                    container.appendChild(newInitials);
                });

                container.appendChild(newImg);
            }
        }
    });
}

/**
 * Handle image loading errors - FIXED to prevent infinite loops
 */
function handleImageLoadErrors() {
    // Get all profile images
    const profileImages = document.querySelectorAll('.profile-image img, .patient-avatar img, .user-avatar img, .doctor-image img, .profile-avatar img');

    profileImages.forEach(img => {
        // Add error handler if not already present
        if (!img.hasAttribute('data-error-handler-added')) {
            img.setAttribute('data-error-handler-added', 'true');

            img.addEventListener('error', function(event) {
                // Prevent infinite loops by checking if we've already tried to fix this image
                if (this.hasAttribute('data-error-handled')) {
                    return;
                }
                this.setAttribute('data-error-handled', 'true');

                // Get the container
                const container = this.parentNode;

                // Get the default image path from the data attribute or use a fallback
                const defaultImagePath = container.getAttribute('data-default-image') || '/assets/images/patients/default.jpg';
                const contextPath = document.body.getAttribute('data-context-path') || '';
                const fullDefaultPath = contextPath + defaultImagePath;

                // Check if we're already trying to load the default image
                if (this.src === fullDefaultPath || this.src.endsWith(defaultImagePath)) {
                    // Default image also failed, fall back to initials
                    const initials = container.getAttribute('data-initials');
                    if (initials) {
                        // Remove the image
                        this.remove();

                        // Check if initials element already exists
                        const existingInitials = container.querySelector('.profile-initials');
                        if (!existingInitials) {
                            // Create and add initials element
                            const initialsElement = document.createElement('div');
                            initialsElement.className = 'profile-initials';
                            initialsElement.textContent = initials;
                            container.appendChild(initialsElement);
                        }
                    }
                } else {
                    // Try to load the default image
                    this.src = fullDefaultPath;
                }
            }, { once: true }); // Use once: true to prevent multiple handlers
        }
    });

    // Also handle containers that should display initials but don't have an image yet
    const containers = document.querySelectorAll('.profile-image, .patient-avatar, .user-avatar, .doctor-image, .profile-avatar');

    containers.forEach(container => {
        // Check if container has initials data but no image and no initials element
        const initials = container.getAttribute('data-initials');
        const hasImage = container.querySelector('img');
        const hasInitials = container.querySelector('.profile-initials');

        if (initials && !hasImage && !hasInitials) {
            // Create and add initials element
            const initialsElement = document.createElement('div');
            initialsElement.className = 'profile-initials';
            initialsElement.textContent = initials;
            container.appendChild(initialsElement);
        }
    });
}
