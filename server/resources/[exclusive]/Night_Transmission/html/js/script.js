window.addEventListener('message', function (event) {
    let data = event.data;

    if (data.action === "show") {
        document.getElementById("hud-container").style.display = "block";
    } else if (data.action === "hide") {
        document.getElementById("hud-container").style.display = "none";
    } else if (data.action === "update") {
        // Update Gear
        let gearEl = document.getElementById("gear");
        if (gearEl) {
            let displayGear = data.gear;
            if (displayGear === 0) displayGear = "N";
            else if (displayGear === -1) displayGear = "R";

            if (data.gear !== window.lastGear) {
                gearEl.classList.remove("gear-shift");
                void gearEl.offsetWidth; // trigger reflow
                gearEl.classList.add("gear-shift");
                window.lastGear = data.gear;
            }
            gearEl.innerText = displayGear;
        }

        // Update Mode
        let modeEl = document.getElementById("mode");
        if (modeEl) {
            modeEl.innerText = data.mode === "manual" ? "MANUAL" : "AUTO";
        }
    }
});
