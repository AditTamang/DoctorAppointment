/**
 * Dashboard Debug Script - Helps identify and fix loading issues
 */

// Debug flag - set to false in production
const DEBUG_MODE = true;

function debugLog(message, data = null) {
    if (DEBUG_MODE) {
        console.log('[Dashboard Debug]', message, data || '');
    }
}

// Monitor page loading and reloading
let pageLoadCount = 0;
let lastLoadTime = Date.now();

document.addEventListener('DOMContentLoaded', function() {
    pageLoadCount++;
    const currentTime = Date.now();
    const timeSinceLastLoad = currentTime - lastLoadTime;
    
    debugLog(`Page loaded ${pageLoadCount} times. Time since last load: ${timeSinceLastLoad}ms`);
    
    // Detect rapid reloading (potential infinite loop)
    if (pageLoadCount > 3 && timeSinceLastLoad < 2000) {
        console.error('[Dashboard Debug] RAPID RELOADING DETECTED! Possible infinite loop.');
        // Store in sessionStorage to persist across reloads
        sessionStorage.setItem('dashboardReloadIssue', 'true');
    }
    
    lastLoadTime = currentTime;
    
    // Check for previous reload issues
    if (sessionStorage.getItem('dashboardReloadIssue') === 'true') {
        console.warn('[Dashboard Debug] Previous reload issue detected. Monitoring...');
    }
    
    // Monitor image loading
    monitorImageLoading();
    
    // Monitor JavaScript errors
    monitorJavaScriptErrors();
    
    // Monitor network requests
    monitorNetworkRequests();
});

function monitorImageLoading() {
    const images = document.querySelectorAll('img');
    debugLog(`Found ${images.length} images on page`);
    
    images.forEach((img, index) => {
        // Track loading state
        img.addEventListener('load', function() {
            debugLog(`Image ${index + 1} loaded successfully: ${this.src}`);
        });
        
        img.addEventListener('error', function() {
            console.warn(`[Dashboard Debug] Image ${index + 1} failed to load: ${this.src}`);
            
            // Check if this is causing a reload loop
            if (this.hasAttribute('data-error-count')) {
                const errorCount = parseInt(this.getAttribute('data-error-count')) + 1;
                this.setAttribute('data-error-count', errorCount);
                
                if (errorCount > 3) {
                    console.error(`[Dashboard Debug] Image ${index + 1} has failed ${errorCount} times. Stopping attempts.`);
                    this.style.display = 'none';
                    return;
                }
            } else {
                this.setAttribute('data-error-count', '1');
            }
        });
    });
}

function monitorJavaScriptErrors() {
    window.addEventListener('error', function(event) {
        console.error('[Dashboard Debug] JavaScript Error:', {
            message: event.message,
            filename: event.filename,
            lineno: event.lineno,
            colno: event.colno,
            error: event.error
        });
    });
    
    window.addEventListener('unhandledrejection', function(event) {
        console.error('[Dashboard Debug] Unhandled Promise Rejection:', event.reason);
    });
}

function monitorNetworkRequests() {
    // Monitor fetch requests
    const originalFetch = window.fetch;
    window.fetch = function(...args) {
        debugLog('Fetch request:', args[0]);
        return originalFetch.apply(this, args)
            .then(response => {
                debugLog('Fetch response:', response.status, response.url);
                return response;
            })
            .catch(error => {
                console.error('[Dashboard Debug] Fetch error:', error);
                throw error;
            });
    };
}

// Function to clear reload issue flag
function clearReloadIssue() {
    sessionStorage.removeItem('dashboardReloadIssue');
    debugLog('Reload issue flag cleared');
}

// Function to check dashboard health
function checkDashboardHealth() {
    const healthReport = {
        pageLoadCount: pageLoadCount,
        imagesLoaded: document.querySelectorAll('img:not([data-error-handled])').length,
        imagesFailed: document.querySelectorAll('img[data-error-handled]').length,
        jsErrors: window.jsErrorCount || 0,
        reloadIssue: sessionStorage.getItem('dashboardReloadIssue') === 'true'
    };
    
    console.log('[Dashboard Debug] Health Report:', healthReport);
    return healthReport;
}

// Expose debug functions globally
window.dashboardDebug = {
    clearReloadIssue,
    checkHealth: checkDashboardHealth,
    debugLog
};

// Auto-clear reload issue after 30 seconds of stable operation
setTimeout(() => {
    if (pageLoadCount <= 3) {
        clearReloadIssue();
        debugLog('Dashboard appears stable, clearing any previous reload issues');
    }
}, 30000);
