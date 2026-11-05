// Alphas, teleports e nomes de ruas do painel gestor (server-side/world.lua)
$(function () {
    const baseUrl = `https://${window.GetParentResourceName ? window.GetParentResourceName() : 'Night_Management'}/`;
    const titles = {
        "create-alpha": "Criar Blip Alpha",
        "manage-alphas": "Gerenciar Blips Alphas",
        "create-teleport": "Criar Teleport",
        "manage-teleports": "Gerenciar Teleports",
        "create-street": "Criar Nome de Rua",
        "manage-streets": "Gerenciar Nomes de Ruas"
    };

    window.addEventListener("message", function (event) {
        const data = event.data;
        if (data.action === "updateAlphas") {
            let tbody = $("#alphas-table tbody");
            tbody.empty();
            if (data.alphas && data.alphas.length > 0) {
                data.alphas.forEach(a => {
                    let name = a.name !== undefined ? a.name : (a.Name || '');
                    let x = parseFloat(a.x !== undefined ? a.x : a.X) || 0;
                    let y = parseFloat(a.y !== undefined ? a.y : a.Y) || 0;
                    let z = parseFloat(a.z !== undefined ? a.z : a.Z) || 0;
                    let radius = a.radius !== undefined ? a.radius : a.Radius;
                    let color = a.color !== undefined ? a.color : a.Color;
                    let alpha = a.alpha !== undefined ? a.alpha : a.Alpha;
                    tbody.append(`
                        <tr>
                            <td>#${a.id}</td>
                            <td>${name}</td>
                            <td>${x.toFixed(1)}, ${y.toFixed(1)}, ${z.toFixed(1)}</td>
                            <td>${radius}m</td>
                            <td>${color}</td>
                            <td>${alpha}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-alpha" data-x="${x}" data-y="${y}" data-z="${z}" title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-alpha" data-alpha='${JSON.stringify(a).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-alpha" data-id="${a.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="7" style="text-align: center; color: var(--text-muted);">Nenhum blip alpha encontrado.</td></tr>');
            }
        } else if (data.action === "alphaSaved") {
            if (window.resetAlphaForm) window.resetAlphaForm();
            $('[data-page="manage-alphas"]').click();
        } else if (data.action === "pushCoordsAlpha") {
            if (data.x) $("#alpha-x").val(data.x.toFixed(2));
            if (data.y) $("#alpha-y").val(data.y.toFixed(2));
            if (data.z) $("#alpha-z").val(data.z.toFixed(2));
        } else if (data.action === "updateTeleports") {
            let tbody = $("#teleports-table tbody");
            tbody.empty();
            if (data.teleports && data.teleports.length > 0) {
                data.teleports.forEach(t => {
                    let name = t.name !== undefined ? t.name : (t.Name || '');
                    let x1 = parseFloat(t.x1 !== undefined ? t.x1 : t.X1) || 0;
                    let y1 = parseFloat(t.y1 !== undefined ? t.y1 : t.Y1) || 0;
                    let z1 = parseFloat(t.z1 !== undefined ? t.z1 : t.Z1) || 0;
                    let x2 = parseFloat(t.x2 !== undefined ? t.x2 : t.X2) || 0;
                    let y2 = parseFloat(t.y2 !== undefined ? t.y2 : t.Y2) || 0;
                    let z2 = parseFloat(t.z2 !== undefined ? t.z2 : t.Z2) || 0;
                    tbody.append(`
                        <tr>
                            <td>#${t.id}</td>
                            <td>${name}</td>
                            <td>${x1.toFixed(1)}, ${y1.toFixed(1)}, ${z1.toFixed(1)}</td>
                            <td>${x2.toFixed(1)}, ${y2.toFixed(1)}, ${z2.toFixed(1)}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-teleport-1" data-x="${x1}" data-y="${y1}" data-z="${z1}" title="Teleportar para Pos 1">
                                    <i class="fa-solid fa-circle-arrow-right"></i>
                                </button>
                                <button class="btn-icon tp-teleport-2" data-x="${x2}" data-y="${y2}" data-z="${z2}" title="Teleportar para Pos 2">
                                    <i class="fa-solid fa-circle-arrow-left"></i>
                                </button>
                                <button class="btn-icon edit-teleport" data-teleport='${JSON.stringify(t).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-teleport" data-id="${t.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhum teleport encontrado.</td></tr>');
            }
        } else if (data.action === "teleportSaved") {
            if (window.resetTeleportForm) window.resetTeleportForm();
            $('[data-page="manage-teleports"]').click();
        } else if (data.action === "pushCoordsTeleport1") {
            if (data.x) $("#teleport-x1").val(data.x.toFixed(2));
            if (data.y) $("#teleport-y1").val(data.y.toFixed(2));
            if (data.z) $("#teleport-z1").val(data.z.toFixed(2));
        } else if (data.action === "pushCoordsTeleport2") {
            if (data.x) $("#teleport-x2").val(data.x.toFixed(2));
            if (data.y) $("#teleport-y2").val(data.y.toFixed(2));
            if (data.z) $("#teleport-z2").val(data.z.toFixed(2));
        } else if (data.action === "updateStreets") {
            window.allStreets = data.streets || [];
            if (window.renderStreetsTable) window.renderStreetsTable(window.allStreets);
        } else if (data.action === "streetSaved") {
            if (window.resetStreetForm) window.resetStreetForm();
            $('[data-page="manage-streets"]').click();
        } else if (data.action === "pushCurrentStreet") {
            if (data.hash) $("#street-hash").val(data.hash);
            if (data.name) $("#street-name").val(data.name);
        }
    });

    $(".nav-item").on("click", function () {
        const page = $(this).data("page");
        if (titles[page]) setTimeout(() => { $("#page-title").text(titles[page]); }, 20);
        if (page === "create-alpha") {
            window.resetAlphaForm();
        } else if (page === "manage-alphas") {
            $.post(baseUrl + "requestAlphas", JSON.stringify({}));
        } else if (page === "create-teleport") {
            window.resetTeleportForm();
        } else if (page === "manage-teleports") {
            $.post(baseUrl + "requestTeleports", JSON.stringify({}));
        } else if (page === "create-street") {
            window.resetStreetForm();
        } else if (page === "manage-streets") {
            $.post(baseUrl + "requestStreets", JSON.stringify({}));
        }
    });

    // ==========================================
    // ALPHAS LOGIC
    // ==========================================
    window.resetAlphaForm = function() {
        $("#edit-alpha-id").val("");
        $("#alpha-name").val("");
        $("#alpha-x").val("");
        $("#alpha-y").val("");
        $("#alpha-z").val("");
        $("#alpha-radius").val("100.0");
        $("#alpha-color").val("53");
        $("#alpha-alpha").val("100");
    };

    $("#get-coords-alpha").click(function () {
        $.post(baseUrl + "getCoordsAlpha", JSON.stringify({}));
    });

    $("#save-alpha").click(function () {
        let id = $("#edit-alpha-id").val();
        let name = $("#alpha-name").val();
        let x = parseFloat($("#alpha-x").val());
        let y = parseFloat($("#alpha-y").val());
        let z = parseFloat($("#alpha-z").val());
        let radius = parseFloat($("#alpha-radius").val()) || 100.0;
        let color = parseInt($("#alpha-color").val()) || 53;
        let alpha = parseInt($("#alpha-alpha").val()) || 100;

        if (!name || isNaN(x) || isNaN(y) || isNaN(z)) return;

        $.post(baseUrl + "saveAlpha", JSON.stringify({
            id: id ? parseInt(id) : null,
            name: name,
            x: x,
            y: y,
            z: z,
            radius: radius,
            color: color,
            alpha: alpha
        }));
    });

    $(document).on("click", ".edit-alpha", function () {
        let alpha = $(this).data("alpha");
        if (typeof alpha === "string") alpha = JSON.parse(alpha);

        $(".nav-item").removeClass("active");
        $("[data-page='create-alpha']").addClass("active");
        $(".page-content").hide();
        $("#create-alpha").show();

        $("#edit-alpha-id").val(alpha.id);
        $("#alpha-name").val(alpha.name !== undefined ? alpha.name : alpha.Name);
        $("#alpha-x").val(alpha.x !== undefined ? alpha.x : alpha.X);
        $("#alpha-y").val(alpha.y !== undefined ? alpha.y : alpha.Y);
        $("#alpha-z").val(alpha.z !== undefined ? alpha.z : alpha.Z);
        $("#alpha-radius").val(alpha.radius !== undefined ? alpha.radius : alpha.Radius);
        $("#alpha-color").val(alpha.color !== undefined ? alpha.color : alpha.Color);
        $("#alpha-alpha").val(alpha.alpha !== undefined ? alpha.alpha : alpha.Alpha);
    });

    $(document).on("click", ".delete-alpha", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteAlpha", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestAlphas", JSON.stringify({})); }, 300);
    });

    $(document).on("click", ".tp-alpha", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x)) $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    // ==========================================
    // TELEPORTS LOGIC
    // ==========================================
    window.resetTeleportForm = function() {
        $("#edit-teleport-id").val("");
        $("#teleport-name").val("");
        $("#teleport-x1").val("");
        $("#teleport-y1").val("");
        $("#teleport-z1").val("");
        $("#teleport-x2").val("");
        $("#teleport-y2").val("");
        $("#teleport-z2").val("");
    };

    $("#get-coords-teleport-1").click(function () {
        $.post(baseUrl + "getCoordsTeleport1", JSON.stringify({}));
    });

    $("#get-coords-teleport-2").click(function () {
        $.post(baseUrl + "getCoordsTeleport2", JSON.stringify({}));
    });

    $("#save-teleport").click(function () {
        let id = $("#edit-teleport-id").val();
        let name = $("#teleport-name").val();
        let x1 = parseFloat($("#teleport-x1").val());
        let y1 = parseFloat($("#teleport-y1").val());
        let z1 = parseFloat($("#teleport-z1").val());
        let x2 = parseFloat($("#teleport-x2").val());
        let y2 = parseFloat($("#teleport-y2").val());
        let z2 = parseFloat($("#teleport-z2").val());

        if (!name || isNaN(x1) || isNaN(y1) || isNaN(z1) || isNaN(x2) || isNaN(y2) || isNaN(z2)) return;

        $.post(baseUrl + "saveTeleport", JSON.stringify({
            id: id ? parseInt(id) : null,
            name: name,
            x1: x1,
            y1: y1,
            z1: z1,
            x2: x2,
            y2: y2,
            z2: z2
        }));
    });

    $(document).on("click", ".edit-teleport", function () {
        let teleport = $(this).data("teleport");
        if (typeof teleport === "string") teleport = JSON.parse(teleport);

        $(".nav-item").removeClass("active");
        $("[data-page='create-teleport']").addClass("active");
        $(".page-content").hide();
        $("#create-teleport").show();

        $("#edit-teleport-id").val(teleport.id);
        $("#teleport-name").val(teleport.name !== undefined ? teleport.name : teleport.Name);
        $("#teleport-x1").val(teleport.x1 !== undefined ? teleport.x1 : teleport.X1);
        $("#teleport-y1").val(teleport.y1 !== undefined ? teleport.y1 : teleport.Y1);
        $("#teleport-z1").val(teleport.z1 !== undefined ? teleport.z1 : teleport.Z1);
        $("#teleport-x2").val(teleport.x2 !== undefined ? teleport.x2 : teleport.X2);
        $("#teleport-y2").val(teleport.y2 !== undefined ? teleport.y2 : teleport.Y2);
        $("#teleport-z2").val(teleport.z2 !== undefined ? teleport.z2 : teleport.Z2);
    });

    $(document).on("click", ".delete-teleport", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteTeleport", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestTeleports", JSON.stringify({})); }, 300);
    });

    $(document).on("click", ".tp-teleport-1", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x)) $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    $(document).on("click", ".tp-teleport-2", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x)) $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    // ==========================================
    // STREETS LOGIC
    // ==========================================
    window.allStreets = [];

    window.resetStreetForm = function() {
        $("#edit-street-id").val("");
        $("#street-hash").val("");
        $("#street-name").val("");
    };

    $("#get-current-street").click(function () {
        $.post(baseUrl + "getCurrentStreet", JSON.stringify({}));
    });

    window.renderStreetsTable = function(streetsList) {
        let tbody = $("#streets-table tbody");
        tbody.empty();
        if (streetsList && streetsList.length > 0) {
            streetsList.forEach(s => {
                let hash = s.hash !== undefined ? s.hash : (s.Hash || '');
                let name = s.name !== undefined ? s.name : (s.Name || '');
                tbody.append(`
                    <tr>
                        <td>#${s.id}</td>
                        <td><code>${hash}</code></td>
                        <td>${name}</td>
                        <td class="action-btns">
                            <button class="btn-icon edit-street" data-street='${JSON.stringify(s).replace(/'/g, "&#39;")}' title="Editar">
                                <i class="fa-solid fa-pen"></i>
                            </button>
                            <button class="btn-icon delete delete-street" data-id="${s.id}" title="Deletar">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `);
            });
        } else {
            tbody.append('<tr><td colspan="4" style="text-align: center; color: var(--text-muted);">Nenhuma rua encontrada.</td></tr>');
        }
    };

    $("#save-street").click(function () {
        let id = $("#edit-street-id").val();
        let hash = $("#street-hash").val().trim();
        let name = $("#street-name").val().trim();

        if (!hash || !name) return;

        $.post(baseUrl + "saveStreet", JSON.stringify({
            id: id ? parseInt(id) : null,
            hash: hash,
            name: name
        }));
    });

    $(document).on("click", ".edit-street", function () {
        let street = $(this).data("street");
        if (typeof street === "string") street = JSON.parse(street);

        $(".nav-item").removeClass("active");
        $("[data-page='create-street']").addClass("active");
        $(".page-content").hide();
        $("#create-street").show();

        $("#edit-street-id").val(street.id);
        $("#street-hash").val(street.hash !== undefined ? street.hash : street.Hash);
        $("#street-name").val(street.name !== undefined ? street.name : street.Name);
    });

    $(document).on("click", ".delete-street", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteStreet", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestStreets", JSON.stringify({})); }, 300);
    });

});
