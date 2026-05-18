console.log("[Shorts Blocker] running");

// Redirect Shorts pages
if (window.location.href.includes("/shorts/")) {
    window.location.replace("https://www.youtube.com/");
}

// Remove Shorts elements repeatedly because YouTube is dynamic
function removeShorts() {

    document.querySelectorAll(`
        ytm-shorts-lockup-view-model,
        ytm-reel-item-renderer,
        ytm-reel-lockup-view-model,
        ytd-reel-shelf-renderer,
        ytm-reel-shelf-renderer,
        ytd-rich-shelf-renderer[is-shorts]
    `).forEach(el => {
        el.style.display = "none";
    });

    // Hide Shorts tab/buttons
    document.querySelectorAll(`
        a[href^="/shorts"],
        a[href*="shorts"],
        [aria-label="Shorts"]
    `).forEach(el => {
        el.style.display = "none";
    });
}

removeShorts();

new MutationObserver(() => {
    removeShorts();

    // Re-block direct navigation
    if (window.location.href.includes("/shorts/")) {
        window.location.replace("https://www.youtube.com/");
    }

}).observe(document.documentElement, {
    childList: true,
    subtree: true
});
