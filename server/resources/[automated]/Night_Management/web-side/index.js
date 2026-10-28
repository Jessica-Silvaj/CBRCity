let currentRouteCoordTarget = null;
$(document).ready(function () {
    let editingId = null;
    let currentElevatorFloorRow = null;
    const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'Night_Management';
    const baseUrl = `https://${resourceName}/`;

    // Listen for NUI messages
    window.addEventListener('message', function (event) {
        let data = event.data;
        if (data.action === "show") {
            if (data.allowedCategories) {
                window.CurrentPermissions = data.detailedPermissions || {};
                const categoryMap = {
                    'BAÚS': 'Chests',
                    'GARAGENS': 'Garages',
                    'CONCESSIONÁRIAS': 'PDM',
                    'LOJAS': 'Shops',
                    'CRAFTING': 'Crafting',
                    'BLIPS': 'Blips',
                    'NPCS': 'NPCs',
                    'RÁDIOS': 'Radio',
                    'ELEVADORES': 'Elevators',
                    'ROUPAS': 'Appearance',
                    'BARBEARIAS': 'Appearance',
                    'TATUAGENS': 'Appearance',
                    'VESTIÁRIOS': 'Cloakroom',
                    'LSCUSTOMS': 'LSCustoms',
                    'PORTAS': 'Doors',
                    'SAFEZONES': 'Safezones',
                    'DESMANCHES': 'Desmanches',
                    'ROTAS': 'Routes',
                    'LAVAGEM': 'Moneywash',
                    'DENSIDADE': 'Density',
                    'CLEARAREA': 'ClearArea',
                    'PERMISSÕES': 'Permissions',
                    'WEBHOOKS': 'Webhooks',
                    'BATE-PONTOS': 'Services',
                    'GRUPOS': 'Groups',
                    'PROPS': 'Props',
                    'ATMS': 'Atms',
                    'ROUBOS': 'Atms',
                    'CASAS': 'Atms'
                };
                // Props é um módulo novo (server-side/props.lua): libera junto com a categoria ClearArea
                data.allowedCategories.Props = data.allowedCategories.Props || data.allowedCategories.ClearArea;
                // ATMs também é módulo novo (server-side/atms.lua): libera junto com Props
                data.allowedCategories.Atms = data.allowedCategories.Atms || data.allowedCategories.Props;
                window.categoryMap = categoryMap;
                $('.nav-category').each(function () {
                    let catText = $(this).find('.category-header span').text().trim();
                    let permKey = categoryMap[catText];
                    if (permKey && data.allowedCategories[permKey]) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });

                // Show first available category if needed
                if ($('.nav-item.active').closest('.nav-category').is(':hidden')) {
                    let firstVisibleItem = $('.nav-category:visible').first().find('.nav-item').first();
                    if (firstVisibleItem.length > 0) {
                        $('.nav-item').removeClass('active');
                        firstVisibleItem.addClass('active');
                        $('.page-content').hide();
                        $('#' + firstVisibleItem.data('page')).show();
                    }
                }
            }

            if (data.theme) {
                let root = document.documentElement;
                // Fundo fica sempre escuro (style.css); a cor principal (Theme.main) é só o destaque
                if (data.theme.mainText) {
                    root.style.setProperty('--text-main', data.theme.mainText);
                }
                let primaryColor = data.theme.main || data.theme.mainText || '#ffffff';
                if (primaryColor) {
                    root.style.setProperty('--primary', primaryColor);
                    root.style.setProperty('--primary-hover', primaryColor + 'CC');
                    root.style.setProperty('--secondary', primaryColor + '80');
                }
                if (data.theme.reject && data.theme.reject.background) {
                    root.style.setProperty('--danger', data.theme.reject.background);
                    root.style.setProperty('--danger-hover', data.theme.reject.background + 'CC');
                }
            }
            $("#ui-wrapper").fadeIn(300);
        } else if (data.action === "hide") {
            $("#ui-wrapper").fadeOut(300);
        } else if (data.action === "updateCoords") {
            $("#chest-x").val(data.coords.X.toFixed(2));
            $("#chest-y").val(data.coords.Y.toFixed(2));
            $("#chest-z").val(data.coords.Z.toFixed(2));
        } else if (data.action === "updateCoordsGarage") {
            $("#garage-x").val(data.coords.X.toFixed(2));
            $("#garage-y").val(data.coords.Y.toFixed(2));
            $("#garage-z").val(data.coords.Z.toFixed(2));
        } else if (data.action === "updateCoordsDesmanche") {
            $("#desmanche-x").val(data.coords.X.toFixed(2));
            $("#desmanche-y").val(data.coords.Y.toFixed(2));
            $("#desmanche-z").val(data.coords.Z.toFixed(2));
        } else if (data.action === "updateCoordsRouteInit") {
            if (data.coords) {
                $("#route-init-x").val(parseFloat(data.coords.X).toFixed(2));
                $("#route-init-y").val(parseFloat(data.coords.Y).toFixed(2));
                $("#route-init-z").val(parseFloat(data.coords.Z).toFixed(2));
            }
        } else if (data.action === "updateCoordsRouteCoord") {
            if (currentRouteCoordTarget && data.coords) {
                currentRouteCoordTarget.find(".route-coord-x").val(parseFloat(data.coords.X).toFixed(2));
                currentRouteCoordTarget.find(".route-coord-y").val(parseFloat(data.coords.Y).toFixed(2));
                currentRouteCoordTarget.find(".route-coord-z").val(parseFloat(data.coords.Z).toFixed(2));
                currentRouteCoordTarget.find(".get-coords-btn-rc").html('<i class="fa-solid fa-location-dot"></i>');
            }
        } else if (data.action === "updateCoordsSpawn") {
            if (currentSpawnRow) {
                currentSpawnRow.find(".spw-x").val(data.coords.X.toFixed(2));
                currentSpawnRow.find(".spw-y").val(data.coords.Y.toFixed(2));
                currentSpawnRow.find(".spw-z").val(data.coords.Z.toFixed(2));
                currentSpawnRow.find(".spw-h").val(data.coords.H.toFixed(2));
            }
        } else if (data.action === "updateCoordsPdm") {
            $("#pdm-x").val(data.coords.X.toFixed(2));
            $("#pdm-y").val(data.coords.Y.toFixed(2));
            $("#pdm-z").val(data.coords.Z.toFixed(2));
        } else if (data.action === "updateCoordsPdmSpawn") {
            if (currentPdmSpawnTarget) {
                $(`#pdm-${currentPdmSpawnTarget}-x`).val(data.coords.X.toFixed(2));
                $(`#pdm-${currentPdmSpawnTarget}-y`).val(data.coords.Y.toFixed(2));
                $(`#pdm-${currentPdmSpawnTarget}-z`).val(data.coords.Z.toFixed(2));
                $(`#pdm-${currentPdmSpawnTarget}-h`).val(data.coords.H.toFixed(2));
            }
        } else if (data.action === "loadChests") {
            renderChestsTable(data.chests);
        } else if (data.action === "loadDoors") {
            renderDoorsTable(data.doors);
        } else if (data.action === "loadGarages") {
            renderGaragesTable(data.garages);
        } else if (data.action === "updateAdminRoles") {
            let select = $("#permissions-role-select");
            select.empty();
            select.append('<option value="">Selecione um Cargo</option>');
            if (data.roles && data.roles.length > 0) {
                data.roles.forEach(role => {
                    select.append(`<option value="${role}">${role}</option>`);
                });
            }
        } else if (data.action === "updateRolePermissions") {
            renderPermissionsUI(data.role, data.permissions);
        } else if (data.action === "updateWebhooks") {
            renderWebhooksUI(data.webhooks);
        } else if (data.action === "loadPdms") {
            renderPdmsTable(data.pdms);
        } else if (data.action === "loadVehicleClasses") {
            let container = $("#garage-classes");
            let pdmContainer = $("#pdm-classes");
            container.empty();
            pdmContainer.empty();
            if (data.classes && data.classes.length > 0) {
                data.classes.forEach(c => {
                    container.append(`<label class="class-checkbox"><input type="checkbox" value="${c}"> ${c}</label>`);
                    pdmContainer.append(`<label class="class-checkbox"><input type="checkbox" value="${c}"> ${c}</label>`);
                });
            } else {
                container.append('<p style="color:var(--text-muted);font-size:12px;">Nenhuma classe encontrada ou erro ao carregar.</p>');
                pdmContainer.append('<p style="color:var(--text-muted);font-size:12px;">Nenhuma classe encontrada ou erro ao carregar.</p>');
            }
        } else if (data.action === "pushSpawns") {
            if (data.spawns && data.spawns.length > 0) {
                data.spawns.forEach(s => {
                    let template = document.getElementById("spawn-template").content.cloneNode(true);
                    $("#spawn-list").append(template);
                    let row = $(".spawn-item").last();
                    row.find(".spw-x").val(s[0].toFixed(2));
                    row.find(".spw-y").val(s[1].toFixed(2));
                    row.find(".spw-z").val(s[2].toFixed(2));
                    row.find(".spw-h").val(s[3].toFixed(2));
                });
            }
        } else if (data.action === "pushPdmSpawns") {
            // Not used anymore with explicit fields
        } else if (data.action === "chestSaved") {
            resetForm();
            $('[data-page="manage-chests"]').click();
        } else if (data.action === "garageSaved") {
            resetGarageForm();
            $('[data-page="manage-garages"]').click();
        } else if (data.action === "pdmSaved") {
            resetPdmForm();
            $('[data-page="manage-pdms"]').click();
        } else if (data.action === "updateShops") {
            let tbody = $("#shops-table tbody");
            tbody.empty();
            if (data.shops && data.shops.length > 0) {
                data.shops.forEach(s => {
                    tbody.append(`
                        <tr>
                            <td>#${s.id}</td>
                            <td>${s.Name}</td>
                            <td>${s.Mode}</td>
                            <td>${(s.X || 0).toFixed(1)}, ${(s.Y || 0).toFixed(1)}, ${(s.Z || 0).toFixed(1)}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-shop" data-x="${s.X}" data-y="${s.Y}" data-z="${s.Z}" title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-shop" data-shop='${JSON.stringify(s).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-shop" data-id="${s.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhuma loja encontrada.</td></tr>');
            }
        } else if (data.action === "shopSaved") {
            resetShopForm();
            $('[data-page="manage-shops"]').click();
        } else if (data.action === "updateShopConfigs") {
            let tbody = $("#shop-configs-table tbody");
            tbody.empty();
            let shopModeSelect = $("#shop-mode");
            let currentMode = shopModeSelect.val();
            shopModeSelect.empty();
            shopModeSelect.append('<option value="">Selecione um Tipo...</option>');

            if (data.configs) {
                Object.keys(data.configs).forEach(mode => {
                    shopModeSelect.append(`<option value="${mode}">${mode}</option>`);

                    let cfg = data.configs[mode];
                    let itemCount = cfg.List ? Object.keys(cfg.List).length : 0;
                    tbody.append(`
                        <tr>
                            <td>${mode}</td>
                            <td>${cfg.Mode} / ${cfg.Type}</td>
                            <td>${itemCount} itens</td>
                            <td class="action-btns">
                                <button class="btn-icon edit-shop-config" data-mode='${mode}' data-config='${JSON.stringify(cfg).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-shop-config" data-mode="${mode}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="4" style="text-align: center; color: var(--text-muted);">Nenhum tipo de loja encontrado.</td></tr>');
            }
            if (currentMode) {
                shopModeSelect.val(currentMode);
            }
        } else if (data.action === "shopConfigSaved") {
            resetShopConfigForm();
            $('[data-page="manage-shop-configs"]').click();
        } else if (data.action === "pushCoordsShop") {
            if (data.x) $("#shop-x").val(data.x.toFixed(2));
            if (data.y) $("#shop-y").val(data.y.toFixed(2));
            if (data.z) $("#shop-z").val(data.z.toFixed(2));
        } else if (data.action === "updateCraftings") {
            let tbody = $("#craftings-table tbody");
            tbody.empty();
            if (data.craftings && data.craftings.length > 0) {
                data.craftings.forEach(s => {
                    tbody.append(`
                        <tr>
                            <td>#${s.id}</td>
                            <td>${s.Name}</td>
                            <td>${s.Mode}</td>
                            <td>${(s.X || 0).toFixed(1)}, ${(s.Y || 0).toFixed(1)}, ${(s.Z || 0).toFixed(1)}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-crafting" data-x="${s.X}" data-y="${s.Y}" data-z="${s.Z}" title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-crafting" data-crafting='${JSON.stringify(s).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-crafting" data-id="${s.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhum local de crafting encontrado.</td></tr>');
            }
        } else if (data.action === "craftingSaved") {
            resetCraftingForm();
            $('[data-page="manage-craftings"]').click();
        } else if (data.action === "updateCraftingConfigs") {
            let tbody = $("#crafting-configs-table tbody");
            tbody.empty();
            let modeSelect = $("#crafting-mode");
            let currentMode = modeSelect.val();
            modeSelect.empty();
            modeSelect.append('<option value="">Selecione um Tipo...</option>');

            if (data.configs) {
                Object.keys(data.configs).forEach(mode => {
                    modeSelect.append(`<option value="${mode}">${mode}</option>`);

                    let cfg = data.configs[mode];
                    let itemCount = cfg.List ? Object.keys(cfg.List).length : 0;
                    tbody.append(`
                        <tr>
                            <td>${mode}</td>
                            <td>${cfg.Permission || "Nenhuma"}</td>
                            <td>${itemCount} receitas</td>
                            <td class="action-btns">
                                <button class="btn-icon edit-crafting-config" data-mode='${mode}' data-config='${JSON.stringify(cfg).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-crafting-config" data-mode="${mode}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="4" style="text-align: center; color: var(--text-muted);">Nenhuma receita encontrada.</td></tr>');
            }
            if (currentMode) {
                modeSelect.val(currentMode);
            }
        } else if (data.action === "craftingConfigSaved") {
            resetCraftingConfigForm();
            $('[data-page="manage-crafting-configs"]').click();
        } else if (data.action === "pushCoordsCrafting") {
            if (data.x) $("#crafting-x").val(data.x.toFixed(2));
            if (data.y) $("#crafting-y").val(data.y.toFixed(2));
            if (data.z) $("#crafting-z").val(data.z.toFixed(2));
        } else if (data.action === "updateBlips") {
            let tbody = $("#blips-table tbody");
            tbody.empty();
            if (data.blips && data.blips.length > 0) {
                data.blips.forEach(b => {
                    tbody.append(`
                        <tr>
                            <td>#${b.id}</td>
                            <td>${b.Name}</td>
                            <td>${(b.X || 0).toFixed(1)}, ${(b.Y || 0).toFixed(1)}, ${(b.Z || 0).toFixed(1)}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-blip" data-x="${b.X}" data-y="${b.Y}" data-z="${b.Z}" title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-blip" data-blip='${JSON.stringify(b).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-blip" data-id="${b.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="4" style="text-align: center; color: var(--text-muted);">Nenhum blip encontrado.</td></tr>');
            }
        } else if (data.action === "blipSaved") {
            resetBlipForm();
            $('[data-page="manage-blips"]').click();
        } else if (data.action === "pushCoordsBlip") {
            if (data.x) $("#blip-x").val(data.x.toFixed(2));
            if (data.y) $("#blip-y").val(data.y.toFixed(2));
            if (data.z) $("#blip-z").val(data.z.toFixed(2));
        } else if (data.action === "updateNpcs") {
            let tbody = $("#npcs-table tbody");
            tbody.empty();
            if (data.npcs && data.npcs.length > 0) {
                data.npcs.forEach(n => {
                    tbody.append(`
                        <tr>
                            <td>#${n.id}</td>
                            <td>${n.Name} <br><small>${n.Model}</small></td>
                            <td>${(n.X || 0).toFixed(1)}, ${(n.Y || 0).toFixed(1)}, ${(n.Z || 0).toFixed(1)}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-npc" data-x="${n.X}" data-y="${n.Y}" data-z="${n.Z}" title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-npc" data-npc='${JSON.stringify(n).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-npc" data-id="${n.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="4" style="text-align: center; color: var(--text-muted);">Nenhum NPC encontrado.</td></tr>');
            }
        } else if (data.action === "npcSaved") {
            resetNpcForm();
            $('[data-page="manage-npcs"]').click();
        } else if (data.action === "pushCoordsNpc") {
            if (data.x) $("#npc-x").val(data.x.toFixed(2));
            if (data.y) $("#npc-y").val(data.y.toFixed(2));
            if (data.z) $("#npc-z").val(data.z.toFixed(2));
            if (data.h) $("#npc-h").val(data.h.toFixed(2));
        } else if (data.action === "updateAppearances") {
            let tbody = $("#appearances-table tbody");
            tbody.empty();
            if (data.appearances && data.appearances.length > 0) {
                data.appearances.forEach(a => {
                    tbody.append(`
                        <tr>
                            <td>#${a.id}</td>
                            <td>${a.Type}</td>
                            <td>${a.Permission || "-"}</td>
                            <td>${(a.X || 0).toFixed(1)}, ${(a.Y || 0).toFixed(1)}, ${(a.Z || 0).toFixed(1)}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-appearance" data-x="${a.X}" data-y="${a.Y}" data-z="${a.Z}" title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-appearance" data-appearance='${JSON.stringify(a).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-appearance" data-id="${a.id}" data-type="${a.Type}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="4" style="text-align: center; color: var(--text-muted);">Nenhuma loja de estética encontrada.</td></tr>');
            }
        } else if (data.action === "appearanceSaved") {
            resetAppearanceForm();
            $('[data-page="manage-appearances"]').click();
        } else if (data.action === "pushCoordsAppearance") {
            if (data.x) $("#appearance-x").val(data.x.toFixed(2));
            if (data.y) $("#appearance-y").val(data.y.toFixed(2));
            if (data.z) $("#appearance-z").val(data.z.toFixed(2));
        } else if (data.action === "loadRadios") {
            let tbody = $("#radios-table tbody");
            tbody.empty();
            if (data.radios && data.radios.length > 0) {
                data.radios.forEach(r => {
                    tbody.append(`
                        <tr>
                            <td>${r.frequencia}</td>
                            <td>${r.permissao || "Pública"}</td>
                            <td class="action-btns">
                                <button class="btn-icon edit-radio" data-frequencia="${r.frequencia}" data-permissao="${r.permissao || ""}" title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-radio" data-frequencia="${r.frequencia}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="3" style="text-align: center; color: var(--text-muted);">Nenhuma rádio encontrada.</td></tr>');
            }
        } else if (data.action === "radioSaved") {
            resetRadioForm();
            $('[data-page="manage-radios"]').click();
        } else if (data.action === "updateCloakrooms") {
            let tbody = $("#cloakrooms-table tbody");
            tbody.empty();
            if (data.cloakrooms && data.cloakrooms.length > 0) {
                data.cloakrooms.forEach(c => {
                    tbody.append(`
                        <tr>
                            <td>#${c.id}</td>
                            <td>${c.Name}</td>
                            <td>${c.Permission || "Nenhuma"}</td>
                            <td>${(c.X || 0).toFixed(1)}, ${(c.Y || 0).toFixed(1)}, ${(c.Z || 0).toFixed(1)}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-cloakroom" data-x="${c.X}" data-y="${c.Y}" data-z="${c.Z}" title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-cloakroom" data-cloakroom='${JSON.stringify(c).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-cloakroom" data-id="${c.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhum vestiário encontrado.</td></tr>');
            }
        } else if (data.action === "cloakroomSaved") {
            resetCloakroomForm();
            $('[data-page="manage-cloakrooms"]').click();
        } else if (data.action === "pushCoordsCloakroom") {
            if (data.x) $("#cloakroom-x").val(data.x.toFixed(2));
            if (data.y) $("#cloakroom-y").val(data.y.toFixed(2));
            if (data.z) $("#cloakroom-z").val(data.z.toFixed(2));
        } else if (data.action === "pushCurrentClothes") {
            if (currentFillTarget) {
                let clothes = data.clothes;
                let modelName = data.model || "mp_m_freemode_01";
                let existingContent = currentFillTarget.val() || "";

                let luaString = "";
                let models = ["mp_m_freemode_01", "mp_f_freemode_01"];

                models.forEach((m, index) => {
                    if (m === modelName) {
                        luaString += `["${m}"] = {\n`;
                        for (let k in clothes) {
                            luaString += `    ["${k}"] = { item = ${clothes[k].item}, texture = ${clothes[k].texture} },\n`;
                        }
                        luaString = luaString.replace(/,\n$/, "\n");
                        luaString += `}`;
                    } else {
                        let regex = new RegExp(`\\["${m}"\\]\\s*=\\s*\\{(?:[^{}]|\\{[^{}]*\\})*\\}`);
                        let match = existingContent.match(regex);

                        if (match) {
                            luaString += match[0];
                        } else {
                            luaString += `["${m}"] = {\n`;
                            for (let k in clothes) {
                                luaString += `    ["${k}"] = { item = 1, texture = 0 },\n`;
                            }
                            luaString = luaString.replace(/,\n$/, "\n");
                            luaString += `}`;
                        }
                    }
                    if (index === 0) luaString += ",\n";
                });

                currentFillTarget.val(luaString);
                currentFillTarget = null;
            }
        } else if (data.action === "loadElevators") {
            let tbody = $("#elevators-table tbody");
            tbody.empty();
            if (data.elevators && data.elevators.length > 0) {
                let grouped = {};
                data.elevators.forEach(e => {
                    if (!grouped[e.elevator_id]) grouped[e.elevator_id] = [];
                    grouped[e.elevator_id].push(e);
                });
                Object.keys(grouped).forEach(groupId => {
                    let count = grouped[groupId].length;
                    let floorsJson = encodeURIComponent(JSON.stringify(grouped[groupId]));
                    tbody.append(`
                        <tr>
                            <td>#${groupId}</td>
                            <td>${count} Andares</td>
                            <td class="action-btns">
                                <button class="btn-icon edit-elevator-group" data-group="${groupId}" data-floors="${floorsJson}" title="Editar Elevador">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete-elevator-group" data-group="${groupId}" title="Deletar Elevador">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="3" style="text-align: center; color: var(--text-muted);">Nenhum elevador encontrado.</td></tr>');
            }
        } else if (data.action === "elevatorSaved") {
            resetElevatorForm();
            $('[data-page="manage-elevators"]').click();
        } else if (data.action === "pushCoordsElevatorFloor") {
            if (currentElevatorFloorRow) {
                currentElevatorFloorRow.find(".ef-x").val(data.x.toFixed(2));
                currentElevatorFloorRow.find(".ef-y").val(data.y.toFixed(2));
                currentElevatorFloorRow.find(".ef-z").val(data.z.toFixed(2));
                if (data.h !== undefined) {
                    currentElevatorFloorRow.find(".ef-h").val(data.h.toFixed(2));
                }
            }
        } else if (data.action === "pushCoordsSafezone") {
            if (safezoneMode === 'z') {
                if (data.z) {
                    $("#safezone-minz").val((data.z - 1.5).toFixed(2));
                    $("#safezone-maxz").val((data.z + 2.5).toFixed(2));
                }
            } else if (safezoneMode === 'point') {
                if (data.x && data.y) {
                    safezonePoints.push({ x: parseFloat(data.x.toFixed(2)), y: parseFloat(data.y.toFixed(2)) });
                    renderSafezonePoints();
                }
            }
        } else if (data.action === "updateSafezones") {
            let tbody = $("#safezones-table tbody");
            tbody.empty();
            if (data.safezones && data.safezones.length > 0) {
                data.safezones.forEach(s => {
                    let pts = [];
                    try { pts = JSON.parse(s.points) || []; } catch (e) { }
                    tbody.append(`
                        <tr>
                            <td>#${s.id}</td>
                            <td>${s.Name}</td>
                            <td>${pts.length} Pontos</td>
                            <td>${(s.minZ || 0).toFixed(1)} a ${(s.maxZ || 0).toFixed(1)}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-safezone" data-points='${s.points}' title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-safezone" data-safezone='${JSON.stringify(s).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-safezone" data-id="${s.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhuma safezone encontrada.</td></tr>');
            }
        } else if (data.action === "safezoneSaved") {
            resetSafezoneForm();
            $('[data-page="manage-safezones"]').click();
        } else if (data.action === "loadDensity") {
            if (data.density) {
                $("#density-vehicle").val(data.density.VehicleDensity.toFixed(1));
                $("#density-random-vehicle").val(data.density.RandomVehicleDensity.toFixed(1));
                $("#density-parked-vehicle").val(data.density.ParkedVehicleDensity.toFixed(1));
                $("#density-scenario-ped").val(data.density.ScenarioPedDensity.toFixed(1));
                $("#density-ped").val(data.density.PedDensity.toFixed(1));
            }
        } else if (data.action === "densitySaved") {
            // Pode adicionar uma notificação visual aqui futuramente
        } else if (data.action === "updateClearAreas") {
            let tbody = $("#clearareas-table tbody");
            tbody.empty();
            if (data.clearareas && data.clearareas.length > 0) {
                data.clearareas.forEach(c => {
                    let opts = [];
                    if (c.ClearPeds) opts.push("Peds");
                    if (c.ClearVehicles) opts.push("Veículos");
                    tbody.append(`
                        <tr>
                            <td>#${c.id}</td>
                            <td>${c.Name}</td>
                            <td>${c.Radius.toFixed(1)}</td>
                            <td>${opts.join(", ")}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-cleararea" data-x="${c.X}" data-y="${c.Y}" data-z="${c.Z}" title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-cleararea" data-cleararea='${JSON.stringify(c).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-cleararea" data-id="${c.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhuma área encontrada.</td></tr>');
            }
        } else if (data.action === "clearareaSaved") {
            resetClearAreaForm();
            $('[data-page="manage-clearareas"]').click();
        } else if (data.action === "pushCoordsClearArea") {
            if (data.x) $("#cleararea-x").val(data.x.toFixed(2));
            if (data.y) $("#cleararea-y").val(data.y.toFixed(2));
            if (data.z) $("#cleararea-z").val(data.z.toFixed(2));
        } else if (data.action === "loadServices") {
            renderServicesTable(data.services);
        } else if (data.action === "serviceSaved") {
            resetServiceForm();
            $('[data-page="manage-services"]').click();
        } else if (data.action === "pushCoordsService") {
            if (data.x) $("#service-x").val(parseFloat(data.x).toFixed(2));
            if (data.y) $("#service-y").val(parseFloat(data.y).toFixed(2));
            if (data.z) $("#service-z").val(parseFloat(data.z).toFixed(2));
        } else if (data.action === "loadGroups") {
            if (window.renderGroupsTable) window.renderGroupsTable(data.groups);
        } else if (data.action === "groupSaved") {
            if (window.resetGroupForm) window.resetGroupForm();
            $('[data-page="manage-groups"]').click();
        }
    });

    // Close Button
    $("#close-btn").click(function () {
        $.post(baseUrl + "close", JSON.stringify({}));
    });

    // Escape Key
    document.onkeyup = function (data) {
        if (data.key === "Escape") {
            $.post(baseUrl + "close", JSON.stringify({}));
        }
    };

    // Navigation Toggle
    $(".category-header").click(function () {
        $(this).toggleClass("open");
        $(this).next(".nav-items-wrapper").slideToggle(250);
    });

    // Navigation Items
    $(".nav-item").click(function () {
        $(".nav-item").removeClass("active");
        $(this).addClass("active");

        let page = $(this).data("page");
        $(".page-content").hide();
        $("#" + page).fadeIn(200);

        if (page === "create-chest") {
            resetForm();
        } else if (page === "manage-chests") {
            $.post(baseUrl + "requestChests", JSON.stringify({}));
        } else if (page === "manage-doors") {
            $.post(baseUrl + "requestDoors", JSON.stringify({}));
        } else if (page === "create-garage") {
            resetGarageForm();
            $.post(baseUrl + "requestVehicleClasses", JSON.stringify({}));
        } else if (page === "manage-garages") {
            $.post(baseUrl + "requestGarages", JSON.stringify({}));
        } else if (page === "create-shop-config") {
            resetShopConfigForm();
        } else if (page === "manage-shop-configs") {
            $.post(baseUrl + "requestShopConfigs", JSON.stringify({}));
        } else if (page === "create-crafting") {
            resetCraftingForm();
            $.post(baseUrl + "requestCraftingConfigs", JSON.stringify({}));
        } else if (page === "manage-craftings") {
            $.post(baseUrl + "requestCraftings", JSON.stringify({}));
        } else if (page === "create-crafting-config") {
            resetCraftingConfigForm();
        } else if (page === "manage-crafting-configs") {
            $.post(baseUrl + "requestCraftingConfigs", JSON.stringify({}));
        } else if (page === "create-blip") {
            resetBlipForm();
        } else if (page === "manage-blips") {
            $.post(baseUrl + "requestBlips", JSON.stringify({}));
        } else if (page === "create-npc") {
            resetNpcForm();
        } else if (page === "manage-npcs") {
            $.post(baseUrl + "requestNpcs", JSON.stringify({}));
        } else if (page === "create-appearance") {
            resetAppearanceForm();
            let type = $(this).data("type");
            if (type) {
                $("#appearance-type").val(type);
                let tStr = type === "skinshop" ? "Loja de Roupas" : (type === "barbershop" ? "Barbearia" : "Estúdio de Tatuagem");
                setTimeout(() => { $("#page-title").text("Criar " + tStr); }, 10);
            }
        } else if (page === "manage-appearances") {
            let type = $(this).data("type");
            $.post(baseUrl + "requestAppearances", JSON.stringify({ type: type }));
            if (type) {
                let tStr = type === "skinshop" ? "Lojas de Roupas" : (type === "barbershop" ? "Barbearias" : "Estúdios de Tatuagem");
                setTimeout(() => { $("#page-title").text("Gerenciar " + tStr); }, 10);
            }
        } else if (page === "create-radio") {
            resetRadioForm();
        } else if (page === "manage-radios") {
            $.post(baseUrl + "requestRadios", JSON.stringify({}));
        } else if (page === "create-cloakroom") {
            resetCloakroomForm();
        } else if (page === "manage-cloakrooms") {
            $.post(baseUrl + "requestCloakrooms", JSON.stringify({}));
        } else if (page === "create-elevator") {
            resetElevatorForm();
        } else if (page === "manage-elevators") {
            $.post(baseUrl + "requestElevators", JSON.stringify({}));
        } else if (page === "create-safezone") {
            resetSafezoneForm();
        } else if (page === "manage-safezones") {
            $.post(baseUrl + "requestSafezones", JSON.stringify({}));
        } else if (page === "settings-desmanche") {
            $.post(baseUrl + "requestSettings", JSON.stringify({ module: "desmanche" }));
        } else if (page === "manage-density") {
            $.post(baseUrl + "requestDensity", JSON.stringify({}));
        } else if (page === "create-cleararea") {
            resetClearAreaForm();
        } else if (page === "manage-clearareas") {
            $.post(baseUrl + "requestClearAreas", JSON.stringify({}));
        } else if (page === "create-service") {
            resetServiceForm();
        } else if (page === "manage-services") {
            $.post(baseUrl + "requestServices", JSON.stringify({}));
        } else if (page === "create-group") {
            if (window.resetGroupForm) window.resetGroupForm();
        } else if (page === "manage-groups") {
            $.post(baseUrl + "requestGroups", JSON.stringify({}));
        }

        let titleMap = {
            "create-group": "Criar Grupos",
            "manage-groups": "Gerenciar Grupos",
            "create-chest": "Criar Baú",
            "manage-chests": "Gerenciar Baús",
            "create-blip": "Criar Blip",
            "manage-blips": "Gerenciar Blips",
            "create-crafting": "Criar Local de Crafting",
            "manage-craftings": "Gerenciar Locais de Crafting",
            "create-crafting-config": "Criar Receita de Crafting",
            "manage-crafting-configs": "Gerenciar Receitas de Crafting",
            "create-elevator": "Criar Andar de Elevador",
            "manage-elevators": "Gerenciar Elevadores",
            "create-garage": "Criar Garagem",
            "manage-garages": "Gerenciar Garagens",
            "create-shop": "Criar Loja",
            "manage-shops": "Gerenciar Lojas",
            "create-shop-config": "Criar Tipo de Loja",
            "manage-shop-configs": "Gerenciar Tipos de Lojas",
            "create-moneywash": "Criar Máquina",
            "manage-moneywash": "Gerenciar Máquinas",
            "create-npc": "Criar NPC",
            "manage-npcs": "Gerenciar NPCs",
            "manage-doors": "Gerenciar Portas",
            "create-radio": "Criar Rádio",
            "manage-radios": "Gerenciar Rádios",
            "create-safezone": "Criar Safezone",
            "manage-safezones": "Gerenciar Safezones",
            "create-cloakroom": "Criar Vestiário",
            "manage-cloakrooms": "Gerenciar Vestiários",
            "manage-density": "Configurações de Densidade",
            "create-cleararea": "Criar ClearArea",
            "manage-clearareas": "Gerenciar ClearAreas",
            "manage-permissions": "Configurar Permissões",
            "manage-webhooks": "Configurar Webhooks",
            "create-service": "Criar Bate Ponto",
            "manage-services": "Gerenciar Bate Pontos",
            "manage-robberies": "Gerenciar Roubos",
            "create-house": "Adicionar Casa",
            "manage-houses": "Gerenciar Casas",
            "manage-stocks": "Estoque de Veículos",
            "create-blip": "Criar Marcação",
            "manage-blips": "Gerenciar Marcações"
        };
        if (titleMap[page]) {
            $("#page-title").text(titleMap[page]);
        }
    });

    // Add Access Level
    $("#add-access").click(function () {
        let template = document.getElementById("access-template").content.cloneNode(true);
        $("#access-list").append(template);
    });

    // Remove Access Level
    $(document).on("click", ".remove-access", function () {
        $(this).closest(".access-item").remove();
    });

    // Get Current Coords
    $("#get-coords").click(function () {
        $.post(baseUrl + "getCoordsChest", JSON.stringify({}));
    });

    // Save Chest
    $("#save-chest").click(function () {
        let id = $("#edit-chest-id").val();
        let name = $("#chest-name").val();
        let x = parseFloat($("#chest-x").val());
        let y = parseFloat($("#chest-y").val());
        let z = parseFloat($("#chest-z").val());

        if (!name || isNaN(x) || isNaN(y) || isNaN(z)) {
            // Use a proper notification in production
            return;
        }

        let accesses = [];
        $(".access-item").each(function () {
            let label = $(this).find(".acc-label").val();
            let perm = $(this).find(".acc-perm").val();
            let weight = parseInt($(this).find(".acc-weight").val());
            let slots = parseInt($(this).find(".acc-slots").val());

            if (label) {
                accesses.push({
                    label: label,
                    permission: perm,
                    weight: weight,
                    slots: slots
                });
            }
        });

        if (accesses.length === 0) {
            return;
        }

        $.post(baseUrl + "saveChest", JSON.stringify({
            id: id || null,
            name: name,
            coords: { x: x, y: y, z: z },
            accesses: accesses
        }));
    });

    // --- GARAGE LOGIC ---
    let currentSpawnRow = null;

    $(document).on("change", ".class-checkbox input[type='checkbox']", function () {
        if ($(this).is(":checked")) {
            $(this).parent(".class-checkbox").addClass("active");
        } else {
            $(this).parent(".class-checkbox").removeClass("active");
        }
    });

    $("#add-spawn").click(function () {
        let template = document.getElementById("spawn-template").content.cloneNode(true);
        $("#spawn-list").append(template);
    });

    $(document).on("click", ".remove-spawn", function () {
        $(this).closest(".spawn-item").remove();
    });

    $("#start-spawn-editor").click(function () {
        let id = $("#edit-garage-id").val() || "new";
        let name = $("#garage-name").val() || "Sem Nome";
        $.post(baseUrl + "startSpawnEditor", JSON.stringify({ id: id, name: name }));
    });

    $("#get-garage-coords").click(function () {
        $.post(baseUrl + "getCoordsGarage", JSON.stringify({}));
    });

    $(document).on("click", ".get-spw-coords", function () {
        currentSpawnRow = $(this).closest(".spawn-item");
        $.post(baseUrl + "getCoordsSpawn", JSON.stringify({}));
    });

    $("#save-garage").click(function () {
        let id = $("#edit-garage-id").val();
        let name = $("#garage-name").val();
        let permission = $("#garage-permission").val();
        let cnh = $("#garage-cnh").val();
        let job = $("#garage-job").val();
        let x = parseFloat($("#garage-x").val());
        let y = parseFloat($("#garage-y").val());
        let z = parseFloat($("#garage-z").val());

        if (!name || isNaN(x) || isNaN(y) || isNaN(z)) {
            return;
        }

        let classes = [];
        $("#garage-classes input[type='checkbox']:checked").each(function () {
            classes.push($(this).val());
        });

        let specificVehicles = $("#garage-specific-vehicles").val();
        if (specificVehicles && specificVehicles.trim() !== "") {
            let specificArr = specificVehicles.split(",");
            specificArr.forEach(v => {
                let trimmed = v.trim();
                if (trimmed !== "" && !classes.includes(trimmed)) {
                    classes.push(trimmed);
                }
            });
        }

        let spawns = [];
        $(".spawn-item").each(function () {
            let sx = parseFloat($(this).find(".spw-x").val());
            let sy = parseFloat($(this).find(".spw-y").val());
            let sz = parseFloat($(this).find(".spw-z").val());
            let sh = parseFloat($(this).find(".spw-h").val());

            if (!isNaN(sx) && !isNaN(sy) && !isNaN(sz) && !isNaN(sh)) {
                spawns.push([sx, sy, sz, sh]);
            }
        });

        if (spawns.length === 0) {
            return;
        }

        $.post(baseUrl + "saveGarage", JSON.stringify({
            id: id || null,
            name: name,
            permission: permission,
            cnh: cnh,
            job: job,
            classes: classes,
            coords: { x: x, y: y, z: z },
            spawns: spawns
        }));
    });

    function resetGarageForm() {
        $("#edit-garage-id").val("");
        $("#garage-name").val("");
        $("#garage-permission").val("");
        $("#garage-cnh").val("");
        $("#garage-job").val("");
        $("#garage-x").val("");
        $("#garage-y").val("");
        $("#garage-z").val("");
        $("#garage-classes input[type='checkbox']").prop("checked", false).trigger("change");
        $("#garage-specific-vehicles").val("");
        $("#spawn-list").empty();

        $("#page-title").text("Criar Garagem");
        $("#save-garage").text("Salvar Garagem");

        $("#add-spawn").click();
    }

    function renderGaragesTable(garages) {
        let tbody = $("#garages-table tbody");
        tbody.empty();

        if (!garages || garages.length === 0) {
            tbody.append(`<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhuma garagem encontrada.</td></tr>`);
            return;
        }

        garages.forEach(g => {
            let spawnCount = 0;
            try {
                let spawns = JSON.parse(g.Spawns);
                spawnCount = spawns.length || 0;
            } catch (e) { }

            let classesList = "";
            try {
                let classes = JSON.parse(g.Classes);
                classesList = classes.join(", ") || "Todas";
            } catch (e) { classesList = "Todas"; }

            tbody.append(`
                <tr>
                    <td>#${g.id}</td>
                    <td>${g.Name}</td>
                    <td>${classesList}</td>
                    <td>${spawnCount} Vagas</td>
                    <td class="action-btns">
                        <button class="btn-icon tp-garage" data-x="${g.X}" data-y="${g.Y}" data-z="${g.Z}" title="Teleportar até a Garagem">
                            <i class="fa-solid fa-location-dot"></i>
                        </button>
                        <button class="btn-icon edit-garage" data-id="${g.id}" data-garage='${JSON.stringify(g).replace(/'/g, "&#39;")}' title="Editar Garagem">
                            <i class="fa-solid fa-pen"></i>
                        </button>
                        <button class="btn-icon delete delete-garage" data-id="${g.id}" title="Apagar Garagem">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </td>
                </tr>
            `);
        });
    }

    // Edit Garage
    $(document).on("click", ".edit-garage", function () {
        let g = $(this).data("garage");

        $(".nav-item").removeClass("active");
        $('[data-page="create-garage"]').addClass("active");
        $(".page-content").hide();
        $("#create-garage").show();

        // Check if we already have classes loaded, if not, wait for them.
        // Actually, we can just request them, and set a tiny delay to check them.
        if ($("#garage-classes .class-checkbox").length === 0) {
            $.post(baseUrl + "requestVehicleClasses", JSON.stringify({}));
        }

        $("#page-title").text("Editar Garagem: " + g.Name);
        $("#save-garage").text("Atualizar Garagem");

        $("#edit-garage-id").val(g.id);
        $("#garage-name").val(g.Name);
        $("#garage-permission").val(g.Permission || "");
        $("#garage-cnh").val(g.CNH || "");
        $("#garage-job").val(g.Job || "");
        $("#garage-x").val(g.X);
        $("#garage-y").val(g.Y);
        $("#garage-z").val(g.Z);

        setTimeout(() => {
            $("#garage-classes input[type='checkbox']").prop("checked", false).trigger("change");
            let specificArr = [];
            try {
                let classes = JSON.parse(g.Classes);
                if (Array.isArray(classes)) {
                    classes.forEach(c => {
                        let checkbox = $(`#garage-classes input[value="${c}"]`);
                        if (checkbox.length > 0) {
                            checkbox.prop("checked", true).trigger("change");
                        } else {
                            // If it's not a checkbox, it's a specific vehicle!
                            specificArr.push(c);
                        }
                    });
                }
            } catch (e) { }
            $("#garage-specific-vehicles").val(specificArr.join(", "));
        }, 150);

        $("#spawn-list").empty();
        try {
            let spawns = JSON.parse(g.Spawns);
            if (Array.isArray(spawns)) {
                spawns.forEach(spw => {
                    let template = document.getElementById("spawn-template").content.cloneNode(true);
                    $("#spawn-list").append(template);
                    let lastItem = $(".spawn-item").last();
                    lastItem.find(".spw-x").val(spw[0]);
                    lastItem.find(".spw-y").val(spw[1]);
                    lastItem.find(".spw-z").val(spw[2]);
                    lastItem.find(".spw-h").val(spw[3]);
                });
            }
        } catch (e) { }
    });

    // Delete Garage
    $(document).on("click", ".delete-garage", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteGarage", JSON.stringify({ id: id }));
        setTimeout(() => {
            $.post(baseUrl + "requestGarages", JSON.stringify({}));
        }, 300);
    });

    // Teleport Garage
    $(document).on("click", ".tp-garage", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x) && !isNaN(y) && !isNaN(z)) {
            $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z })); // Reusing teleport function since it just tps
        }
    });

    // --- PDM LOGIC ---
    let currentPdmSpawnTarget = null;

    $('[data-page="create-pdm"]').click(function () {
        resetPdmForm();
        if ($("#pdm-classes .class-checkbox").length === 0) {
            $.post(baseUrl + "requestVehicleClasses", JSON.stringify({}));
        }
    });

    $('[data-page="manage-pdms"]').click(function () {
        $.post(baseUrl + "requestPdms", JSON.stringify({}));
    });

    $("#get-pdm-coords").click(function () {
        $.post(baseUrl + "getCoordsPdm", JSON.stringify({}));
    });

    $(document).on("click", ".get-pdm-specific-coords", function () {
        currentPdmSpawnTarget = $(this).data("target");
        $.post(baseUrl + "getCoordsPdmSpawn", JSON.stringify({}));
    });

    $("#save-pdm").click(function () {
        let id = $("#edit-pdm-id").val();
        let name = $("#pdm-name").val();
        let permission = $("#pdm-permission").val();
        let x = parseFloat($("#pdm-x").val());
        let y = parseFloat($("#pdm-y").val());
        let z = parseFloat($("#pdm-z").val());
        let logo = $("#pdm-logo").val();

        if (!name || isNaN(x) || isNaN(y) || isNaN(z)) {
            return;
        }

        let classes = [];
        $("#pdm-classes input[type='checkbox']:checked").each(function () {
            classes.push($(this).val());
        });

        let specificVehicles = $("#pdm-specific-vehicles").val();
        if (specificVehicles && specificVehicles.trim() !== "") {
            let specificArr = specificVehicles.split(",");
            specificArr.forEach(v => {
                let trimmed = v.trim();
                if (trimmed !== "" && !classes.includes(trimmed)) {
                    classes.push(trimmed);
                }
            });
        }

        let getSpecificCoords = (target) => {
            let cx = parseFloat($(`#pdm-${target}-x`).val());
            let cy = parseFloat($(`#pdm-${target}-y`).val());
            let cz = parseFloat($(`#pdm-${target}-z`).val());
            let ch = parseFloat($(`#pdm-${target}-h`).val());
            if (!isNaN(cx) && !isNaN(cy) && !isNaN(cz) && !isNaN(ch)) {
                return [cx, cy, cz, ch];
            }
            return null;
        };

        let cam = getSpecificCoords("cam");
        let spawn = getSpecificCoords("spawn");
        let driveIn = getSpecificCoords("drivein");
        let driveOut = getSpecificCoords("driveout");

        $.post(baseUrl + "savePdm", JSON.stringify({
            id: id || null,
            name: name,
            permission: permission,
            classes: classes,
            coords: { x: x, y: y, z: z },
            cam: cam,
            spawn: spawn,
            driveIn: driveIn,
            driveOut: driveOut,
            logo: logo
        }));
    });

    function resetPdmForm() {
        $("#edit-pdm-id").val("");
        $("#pdm-name").val("");
        $("#pdm-permission").val("");
        $("#pdm-x").val("");
        $("#pdm-y").val("");
        $("#pdm-z").val("");
        $("#pdm-logo").val("");
        $("#pdm-classes input[type='checkbox']").prop("checked", false).trigger("change");
        $("#pdm-specific-vehicles").val("");

        let targets = ["cam", "spawn", "drivein", "driveout"];
        targets.forEach(t => {
            $(`#pdm-${t}-x`).val("");
            $(`#pdm-${t}-y`).val("");
            $(`#pdm-${t}-z`).val("");
            $(`#pdm-${t}-h`).val("");
        });

        $("#page-title").text("Criar PDM");
        $("#save-pdm").text("Salvar PDM");
    }

    function renderPdmsTable(pdms) {
        let tbody = $("#pdms-table tbody");
        tbody.empty();

        if (!pdms || pdms.length === 0) {
            tbody.append(`<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhuma PDM encontrada.</td></tr>`);
            return;
        }

        pdms.forEach(g => {
            let classesList = "";
            try {
                let classes = JSON.parse(g.Classes);
                classesList = classes.join(", ") || "Todas";
            } catch (e) { classesList = "Todas"; }

            tbody.append(`
                <tr>
                    <td>#${g.id}</td>
                    <td>${g.Name}</td>
                    <td>${classesList}</td>
                    <td>PDM</td>
                    <td class="action-btns">
                        <button class="btn-icon tp-garage" data-x="${g.X}" data-y="${g.Y}" data-z="${g.Z}" title="Teleportar até a PDM">
                            <i class="fa-solid fa-location-dot"></i>
                        </button>
                        <button class="btn-icon edit-pdm" data-id="${g.id}" data-pdm='${JSON.stringify(g).replace(/'/g, "&#39;")}' title="Editar PDM">
                            <i class="fa-solid fa-pen"></i>
                        </button>
                        <button class="btn-icon delete delete-pdm" data-id="${g.id}" title="Apagar PDM">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </td>
                </tr>
            `);
        });
    }

    // Edit PDM
    $(document).on("click", ".edit-pdm", function () {
        let g = $(this).data("pdm");

        $(".nav-item").removeClass("active");
        $('[data-page="create-pdm"]').addClass("active");
        $(".page-content").hide();
        $("#create-pdm").show();

        if ($("#pdm-classes .class-checkbox").length === 0) {
            $.post(baseUrl + "requestVehicleClasses", JSON.stringify({}));
        }

        $("#page-title").text("Editar PDM: " + g.Name);
        $("#save-pdm").text("Atualizar PDM");

        $("#edit-pdm-id").val(g.id);
        $("#pdm-name").val(g.Name);
        $("#pdm-permission").val(g.Permission || "");
        $("#pdm-logo").val(g.Logo || "");
        $("#pdm-x").val(g.X);
        $("#pdm-y").val(g.Y);
        $("#pdm-z").val(g.Z);

        setTimeout(() => {
            $("#pdm-classes input[type='checkbox']").prop("checked", false).trigger("change");
            let specificArr = [];
            try {
                let classes = JSON.parse(g.Classes);
                if (Array.isArray(classes)) {
                    classes.forEach(c => {
                        let checkbox = $(`#pdm-classes input[value="${c}"]`);
                        if (checkbox.length > 0) {
                            checkbox.prop("checked", true).trigger("change");
                        } else {
                            specificArr.push(c);
                        }
                    });
                }
            } catch (e) { }
            $("#pdm-specific-vehicles").val(specificArr.join(", "));
        }, 150);

        let targets = ["cam", "spawn", "drivein", "driveout"];
        targets.forEach(t => {
            let fieldMap = {
                "cam": g.Cam,
                "spawn": g.Spawn,
                "drivein": g.DriveIn,
                "driveout": g.DriveOut
            };

            try {
                let val = fieldMap[t];
                if (val && typeof val === "string") {
                    let parsed = JSON.parse(val);
                    if (Array.isArray(parsed) && parsed.length >= 4) {
                        $(`#pdm-${t}-x`).val(parsed[0]);
                        $(`#pdm-${t}-y`).val(parsed[1]);
                        $(`#pdm-${t}-z`).val(parsed[2]);
                        $(`#pdm-${t}-h`).val(parsed[3]);
                    }
                }
            } catch (e) { }
        });
    });

    // Delete PDM
    $(document).on("click", ".delete-pdm", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deletePdm", JSON.stringify({ id: id }));
        setTimeout(() => {
            $.post(baseUrl + "requestPdms", JSON.stringify({}));
        }, 300);
    });

    // --- SHOPS LOGIC ---
    $("#get-shop-coords").click(function () {
        $.post(baseUrl + "getCoordsShop", JSON.stringify({}));
    });

    $("#save-shop").click(function () {
        let id = $("#edit-shop-id").val();
        let name = $("#shop-name").val();
        let mode = $("#shop-mode").val();
        let type = $("#shop-type").val();
        let x = parseFloat($("#shop-x").val());
        let y = parseFloat($("#shop-y").val());
        let z = parseFloat($("#shop-z").val());
        let circle = $("#shop-circle").val() ? parseFloat($("#shop-circle").val()) : null;
        let route = $("#shop-route").val() ? parseInt($("#shop-route").val()) : null;

        if (!name || !mode || isNaN(x) || isNaN(y) || isNaN(z)) {
            return;
        }

        let data = {
            id: id !== "" ? parseInt(id) : null,
            name: name,
            mode: mode,
            type: type,
            coords: { x: x, y: y, z: z },
            circle: circle,
            route: route
        };

        $.post(baseUrl + "saveShop", JSON.stringify(data));
    });

    function resetShopForm() {
        $("#edit-shop-id").val("");
        $("#shop-name").val("");
        $("#shop-mode").val("");
        $("#shop-type").val("Buy");
        $("#shop-x").val("");
        $("#shop-y").val("");
        $("#shop-z").val("");
        $("#shop-circle").val("");
        $("#shop-route").val("");

        $("#page-title").text("Criar Loja");
        $("#save-shop").text("Salvar Loja");
    }

    $('[data-page="create-shop"]').click(function () {
        resetShopForm();
        $.post(baseUrl + "requestShopConfigs", JSON.stringify({}));
    });

    $('[data-page="manage-shops"]').click(function () {
        $.post(baseUrl + "requestShops", JSON.stringify({}));
    });

    $(document).on("click", ".edit-shop", function () {
        let s = $(this).data("shop");

        $(".nav-item").removeClass("active");
        $('[data-page="create-shop"]').addClass("active");
        $(".page-content").hide();
        $("#create-shop").fadeIn(200);

        $("#page-title").text("Editar Loja: " + s.Name);
        $("#save-shop").text("Atualizar Loja");

        $("#edit-shop-id").val(s.id);
        $("#shop-name").val(s.Name);
        $("#shop-mode").val(s.Mode);
        $("#shop-type").val(s.Type || "Buy");
        $("#shop-x").val(s.X);
        $("#shop-y").val(s.Y);
        $("#shop-z").val(s.Z);
        if (s.Circle !== null) $("#shop-circle").val(s.Circle);
        if (s.Route !== null) $("#shop-route").val(s.Route);
    });

    $(document).on("click", ".delete-shop", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteShop", JSON.stringify({ id: id }));
        setTimeout(() => {
            $.post(baseUrl + "requestShops", JSON.stringify({}));
        }, 300);
    });

    $(document).on("click", ".tp-shop", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x) && !isNaN(y) && !isNaN(z)) {
            $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
        }
    });


    // --- SHOP CONFIGS LOGIC ---
    $("#add-shop-item").click(function () {
        let template = document.getElementById("shop-item-template").content.cloneNode(true);
        $("#shop-item-list").append(template);
    });

    $(document).on("click", ".remove-shop-item", function () {
        $(this).closest(".shop-item-row").remove();
    });

    $("#save-shop-config").click(function () {
        let isNew = $("#edit-shop-config-isnew").val() === "true";
        let mode = $("#shop-config-mode").val();
        let action = $("#shop-config-action").val();
        let type = $("#shop-config-type").val();
        let item = $("#shop-config-item").val() || "";
        let perm = $("#shop-config-permission").val() || "";

        if (!mode || mode.trim() === "") {
            return;
        }

        let listObj = {};
        $(".shop-item-row").each(function () {
            let itemName = $(this).find(".si-name").val().trim();
            let itemPrice = parseInt($(this).find(".si-price").val());
            if (itemName !== "" && !isNaN(itemPrice)) {
                listObj[itemName] = itemPrice;
            }
        });

        let data = {
            isNew: isNew,
            mode: mode,
            action: action,
            type: type,
            item: item,
            permission: perm,
            list: listObj
        };

        $.post(baseUrl + "saveShopConfig", JSON.stringify(data));
    });

    function resetShopConfigForm() {
        $("#edit-shop-config-isnew").val("true");
        $("#shop-config-mode").val("").prop("disabled", false);
        $("#shop-config-action").val("Buy");
        $("#shop-config-type").val("Cash");
        $("#shop-config-item").val("");
        $("#shop-config-permission").val("");

        $("#shop-item-list").empty();
        $("#add-shop-item").click(); // add one blank
    }

    $(document).on("click", ".edit-shop-config", function () {
        let mode = $(this).data("mode");
        let cfg = $(this).data("config");

        $(".nav-item").removeClass("active");
        $('[data-page="create-shop-config"]').addClass("active");
        $(".page-content").hide();
        $("#create-shop-config").fadeIn(200);

        $("#edit-shop-config-isnew").val("false");
        $("#shop-config-mode").val(mode).prop("disabled", true);
        $("#shop-config-action").val(cfg.Mode || "Buy");
        $("#shop-config-type").val(cfg.Type || "Cash");
        $("#shop-config-item").val(cfg.Item || "");
        $("#shop-config-permission").val(cfg.Permission || "");

        $("#shop-item-list").empty();

        if (cfg.List) {
            Object.keys(cfg.List).forEach(itemName => {
                let template = document.getElementById("shop-item-template").content.cloneNode(true);
                $("#shop-item-list").append(template);
                let lastItem = $(".shop-item-row").last();
                lastItem.find(".si-name").val(itemName);
                lastItem.find(".si-price").val(cfg.List[itemName]);
            });
        }
    });

    $(document).on("click", ".delete-shop-config", function () {
        let mode = $(this).data("mode");
        $.post(baseUrl + "deleteShopConfig", JSON.stringify({ mode: mode }));
        setTimeout(() => {
            $.post(baseUrl + "requestShopConfigs", JSON.stringify({}));
        }, 300);
    });

    function resetForm() {
        $("#edit-chest-id").val("");
        $("#chest-name").val("");
        $("#chest-x").val("");
        $("#chest-y").val("");
        $("#chest-z").val("");
        $("#access-list").empty();
        $("#page-title").text("Criar Baú");
        $("#save-chest").text("Salvar Baú");

        // Add one default access
        $("#add-access").click();
    }

    function renderChestsTable(chests) {
        let tbody = $("#chests-table tbody");
        tbody.empty();

        if (!chests || chests.length === 0) {
            tbody.append(`<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhum baú encontrado.</td></tr>`);
            return;
        }

        chests.forEach(chest => {
            let accessCount = 0;
            let chestName = chest.Name || chest.name;
            try {
                let conf = chest.Configuration || chest.config;
                let accesses = typeof conf === "string" ? JSON.parse(conf) : conf;
                accessCount = accesses.length;
            } catch (e) { }

            tbody.append(`
                <tr>
                    <td>#${chest.id}</td>
                    <td>${chestName}</td>
                    <td>${(chest.X || chest.x).toFixed(1)}, ${(chest.Y || chest.y).toFixed(1)}, ${(chest.Z || chest.z).toFixed(1)}</td>
                    <td>${accessCount} Acessos</td>
                    <td class="action-btns">
                        <button class="btn-icon tp-chest" data-x="${chest.X || chest.x}" data-y="${chest.Y || chest.y}" data-z="${chest.Z || chest.z}" title="Teleportar até o Baú">
                            <i class="fa-solid fa-location-dot"></i>
                        </button>
                        <button class="btn-icon edit-chest" data-id="${chest.id}" data-chest='${JSON.stringify(chest).replace(/'/g, "&#39;")}' title="Editar Baú">
                            <i class="fa-solid fa-pen"></i>
                        </button>
                        <button class="btn-icon delete delete-chest" data-id="${chest.id}" title="Apagar Baú">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </td>
                </tr>
            `);
        });
    }

    // Edit Chest
    $(document).on("click", ".edit-chest", function () {
        let chest = $(this).data("chest");
        let chestName = chest.Name || chest.name;

        // Switch to create form
        $(".nav-item").removeClass("active");
        $('[data-page="create-chest"]').addClass("active");
        $(".page-content").hide();
        $("#create-chest").show();

        $("#page-title").text("Editar Baú: " + chestName);
        $("#save-chest").text("Atualizar Baú");

        $("#edit-chest-id").val(chest.id);
        $("#chest-name").val(chestName);
        $("#chest-x").val(chest.X || chest.x);
        $("#chest-y").val(chest.Y || chest.y);
        $("#chest-z").val(chest.Z || chest.z);

        $("#access-list").empty();

        try {
            let conf = chest.Configuration || chest.config;
            let accesses = typeof conf === "string" ? JSON.parse(conf) : conf;
            accesses.forEach(acc => {
                let template = document.getElementById("access-template").content.cloneNode(true);
                $("#access-list").append(template);

                let lastItem = $(".access-item").last();
                lastItem.find(".acc-label").val(acc.label);
                lastItem.find(".acc-perm").val(acc.permission);
                lastItem.find(".acc-weight").val(acc.weight);
                lastItem.find(".acc-slots").val(acc.slots);
            });
        } catch (e) { }
    });

    // Delete Chest
    $(document).on("click", ".delete-chest", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteChest", JSON.stringify({ id: id }));
        setTimeout(() => {
            $.post(baseUrl + "requestChests", JSON.stringify({}));
        }, 300);
    });

    // Teleport Chest
    $(document).on("click", ".tp-chest", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x) && !isNaN(y) && !isNaN(z)) {
            $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
        }
    });

    // Category Collapse/Expand Toggle
    $(document).on("click", ".category-header", function () {
        $(this).toggleClass("collapsed");
        let wrapper = $(this).next(".nav-items-wrapper");

        if ($(this).hasClass("collapsed")) {
            wrapper.css("height", "0");
        } else {
            // Calculate natural height
            let height = 0;
            wrapper.children().each(function () {
                height += $(this).outerHeight(true);
            });
            wrapper.css("height", height + "px");

            // Set it back to auto after animation to support responsiveness
            setTimeout(() => {
                if (!$(this).hasClass("collapsed")) wrapper.css("height", "auto");
            }, 300);
        }
    });

    // ==========================================
    // CRAFTING LOGIC
    // ==========================================

    function resetCraftingForm() {
        $("#edit-crafting-id").val("");
        $("#crafting-name").val("");
        $("#crafting-x").val("");
        $("#crafting-y").val("");
        $("#crafting-z").val("");
        $("#crafting-circle").val("0.1");
        // Don't reset mode here, let it keep last selected if possible
    }

    $("#get-crafting-coords").click(function () {
        $.post(baseUrl + "getCoordsCrafting", JSON.stringify({}));
    });

    $("#save-crafting").click(function () {
        let id = $("#edit-crafting-id").val();
        let name = $("#crafting-name").val();
        let x = parseFloat($("#crafting-x").val());
        let y = parseFloat($("#crafting-y").val());
        let z = parseFloat($("#crafting-z").val());
        let circle = parseFloat($("#crafting-circle").val());
        let mode = $("#crafting-mode").val();

        if (!name || isNaN(x) || isNaN(y) || isNaN(z) || !mode) return;

        $.post(baseUrl + "saveCrafting", JSON.stringify({
            id: id || null,
            name: name,
            mode: mode,
            coords: { x: x, y: y, z: z, circle: isNaN(circle) ? 0.1 : circle }
        }));
    });

    $(document).on("click", ".edit-crafting", function () {
        let crafting = $(this).data("crafting");
        if (typeof crafting === "string") crafting = JSON.parse(crafting);

        $(".nav-item").removeClass("active");
        $("[data-page='create-crafting']").addClass("active");
        $(".page-content").hide();
        $("#create-crafting").show();

        $("#edit-crafting-id").val(crafting.id);
        $("#crafting-name").val(crafting.Name);
        $("#crafting-x").val(crafting.X);
        $("#crafting-y").val(crafting.Y);
        $("#crafting-z").val(crafting.Z);
        $("#crafting-circle").val(crafting.Circle || 0.1);

        setTimeout(() => {
            $("#crafting-mode").val(crafting.Mode);
        }, 100);
    });

    $(document).on("click", ".delete-crafting", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteCrafting", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestCraftings", JSON.stringify({})); }, 300);
    });

    $(document).on("click", ".tp-crafting", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x)) $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    // ==========================================
    // CRAFTING CONFIGS LOGIC
    // ==========================================

    function resetCraftingConfigForm() {
        $("#edit-crafting-config-isnew").val("true");
        $("#crafting-config-mode").val("").prop("disabled", false);
        $("#crafting-config-permission").val("");
        $("#crafting-recipe-list").empty();
    }

    $("#add-crafting-recipe").click(function () {
        let template = document.getElementById("crafting-recipe-template").content.cloneNode(true);
        $("#crafting-recipe-list").append(template);
    });

    $(document).on("click", ".remove-crafting-recipe", function () {
        $(this).closest(".crafting-recipe-row").remove();
    });

    $(document).on("click", ".add-cr-ingredient", function () {
        let template = document.getElementById("crafting-ingredient-template").content.cloneNode(true);
        $(this).parent().prev(".cr-ingredients-list").append(template);
    });

    $(document).on("click", ".remove-cr-ingredient", function () {
        $(this).closest(".crafting-ingredient-row").remove();
    });

    $("#save-crafting-config").click(function () {
        let mode = $("#crafting-config-mode").val();
        let permission = $("#crafting-config-permission").val() || "";
        let isNew = $("#edit-crafting-config-isnew").val() === "true";

        if (!mode) return;

        let recipes = {};
        $(".crafting-recipe-row").each(function () {
            let resultItem = $(this).find(".cr-result").val();
            let amount = parseInt($(this).find(".cr-amount").val()) || 1;

            if (resultItem) {
                let required = {};
                $(this).find(".crafting-ingredient-row").each(function () {
                    let ingName = $(this).find(".ci-name").val();
                    let ingAmt = parseInt($(this).find(".ci-amount").val()) || 1;
                    if (ingName) required[ingName] = ingAmt;
                });

                recipes[resultItem] = {
                    Amount: amount,
                    Required: required
                };
            }
        });

        $.post(baseUrl + "saveCraftingConfig", JSON.stringify({
            mode: mode,
            isNew: isNew,
            permission: permission,
            list: recipes
        }));
    });

    $(document).on("click", ".edit-crafting-config", function () {
        let mode = $(this).data("mode");
        let cfg = $(this).data("config");
        if (typeof cfg === "string") cfg = JSON.parse(cfg);

        $(".nav-item").removeClass("active");
        $("[data-page='create-crafting-config']").addClass("active");
        $(".page-content").hide();
        $("#create-crafting-config").show();

        $("#edit-crafting-config-isnew").val("false");
        $("#crafting-config-mode").val(mode).prop("disabled", true);
        $("#crafting-config-permission").val(cfg.Permission || "");

        $("#crafting-recipe-list").empty();

        if (cfg.List) {
            Object.keys(cfg.List).forEach(resultItem => {
                let recipe = cfg.List[resultItem];

                let template = document.getElementById("crafting-recipe-template").content.cloneNode(true);
                $("#crafting-recipe-list").append(template);
                let row = $(".crafting-recipe-row").last();

                row.find(".cr-result").val(resultItem);
                row.find(".cr-amount").val(recipe.Amount || 1);

                let ingList = row.find(".cr-ingredients-list");
                if (recipe.Required) {
                    Object.keys(recipe.Required).forEach(ingName => {
                        let ingTpl = document.getElementById("crafting-ingredient-template").content.cloneNode(true);
                        ingList.append(ingTpl);
                        let ingRow = ingList.find(".crafting-ingredient-row").last();
                        ingRow.find(".ci-name").val(ingName);
                        ingRow.find(".ci-amount").val(recipe.Required[ingName]);
                    });
                }
            });
        }
    });

    $(document).on("click", ".delete-crafting-config", function () {
        let mode = $(this).data("mode");
        $.post(baseUrl + "deleteCraftingConfig", JSON.stringify({ mode: mode }));
        setTimeout(() => { $.post(baseUrl + "requestCraftingConfigs", JSON.stringify({})); }, 300);
    });

    // ==========================================
    // BLIPS LOGIC
    // ==========================================

    function resetBlipForm() {
        $("#edit-blip-id").val("");
        $("#blip-name").val("");
        $("#blip-x").val("");
        $("#blip-y").val("");
        $("#blip-z").val("");
        $("#blip-sprite").val("1");
        $("#blip-color").val("0");
        $("#blip-scale").val("0.5");
    }

    $("#get-coords-blip").click(function () {
        $.post(baseUrl + "getCoordsBlip", JSON.stringify({}));
    });

    $("#save-blip").click(function () {
        let id = $("#edit-blip-id").val();
        let name = $("#blip-name").val();
        let x = parseFloat($("#blip-x").val());
        let y = parseFloat($("#blip-y").val());
        let z = parseFloat($("#blip-z").val());
        let sprite = parseInt($("#blip-sprite").val()) || 1;
        let color = parseInt($("#blip-color").val()) || 0;
        let scale = parseFloat($("#blip-scale").val()) || 0.5;

        if (!name || isNaN(x) || isNaN(y) || isNaN(z)) return;

        $.post(baseUrl + "saveBlip", JSON.stringify({
            id: id ? parseInt(id) : null,
            name: name,
            x: x,
            y: y,
            z: z,
            sprite: sprite,
            color: color,
            scale: scale
        }));
    });

    $(document).on("click", ".edit-blip", function () {
        let blip = $(this).data("blip");
        if (typeof blip === "string") blip = JSON.parse(blip);

        $(".nav-item").removeClass("active");
        $("[data-page='create-blip']").addClass("active");
        $(".page-content").hide();
        $("#create-blip").show();

        $("#edit-blip-id").val(blip.id);
        $("#blip-name").val(blip.Name);
        $("#blip-x").val(blip.X);
        $("#blip-y").val(blip.Y);
        $("#blip-z").val(blip.Z);
        $("#blip-sprite").val(blip.Sprite);
        $("#blip-color").val(blip.Color);
        $("#blip-scale").val(blip.Scale);
    });

    $(document).on("click", ".delete-blip", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteBlip", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestBlips", JSON.stringify({})); }, 300);
    });

    $(document).on("click", ".tp-blip", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x)) $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    // ==========================================
    // NPCS LOGIC
    // ==========================================

    function resetNpcForm() {
        $("#edit-npc-id").val("");
        $("#npc-name").val("");
        $("#npc-model").val("");
        $("#npc-x").val("");
        $("#npc-y").val("");
        $("#npc-z").val("");
        $("#npc-h").val("");
        $("#npc-distance").val("50");
        $("#npc-collision").prop("checked", true);
        $("#npc-animdict").val("");
        $("#npc-animname").val("");
        $("#npc-route").val("");
    }

    $("#get-coords-npc").click(function () {
        $.post(baseUrl + "getCoordsNpc", JSON.stringify({}));
    });

    $("#save-npc").click(function () {
        let id = $("#edit-npc-id").val();
        let name = $("#npc-name").val();
        let model = $("#npc-model").val();
        let x = parseFloat($("#npc-x").val());
        let y = parseFloat($("#npc-y").val());
        let z = parseFloat($("#npc-z").val());
        let h = parseFloat($("#npc-h").val());
        let distance = parseInt($("#npc-distance").val()) || 50;
        let collision = $("#npc-collision").is(":checked") ? 1 : 0;
        let animdict = $("#npc-animdict").val();
        let animname = $("#npc-animname").val();
        let route = parseInt($("#npc-route").val()) || null;

        if (!name || !model || isNaN(x) || isNaN(y) || isNaN(z) || isNaN(h)) return;

        $.post(baseUrl + "saveNpc", JSON.stringify({
            id: id ? parseInt(id) : null,
            name: name,
            model: model,
            x: x,
            y: y,
            z: z,
            h: h,
            distance: distance,
            collision: collision,
            animdict: animdict,
            animname: animname,
            route: route
        }));
    });

    $(document).on("click", ".edit-npc", function () {
        let npc = $(this).data("npc");
        if (typeof npc === "string") npc = JSON.parse(npc);

        $(".nav-item").removeClass("active");
        $("[data-page='create-npc']").addClass("active");
        $(".page-content").hide();
        $("#create-npc").show();

        $("#edit-npc-id").val(npc.id);
        $("#npc-name").val(npc.Name);
        $("#npc-model").val(npc.Model);
        $("#npc-x").val(npc.X);
        $("#npc-y").val(npc.Y);
        $("#npc-z").val(npc.Z);
        $("#npc-h").val(npc.H);
        $("#npc-distance").val(npc.Distance);
        $("#npc-collision").prop("checked", npc.Collision === 1 || npc.Collision === true);
        $("#npc-animdict").val(npc.AnimDict || "");
        $("#npc-animname").val(npc.AnimName || "");
        $("#npc-route").val(npc.Route || "");
    });

    $(document).on("click", ".delete-npc", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteNpc", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestNpcs", JSON.stringify({})); }, 300);
    });

    $(document).on("click", ".tp-npc", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x)) $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    // ==========================================
    // APPEARANCE LOGIC
    // ==========================================

    function resetAppearanceForm() {
        $("#edit-appearance-id").val("");
        $("#appearance-type").val("skinshop");
        $("#appearance-x").val("");
        $("#appearance-y").val("");
        $("#appearance-z").val("");
        $("#appearance-permission").val("");
        $("#page-title").text("Criar Loja de Estética");
        $("#save-appearance").text("Salvar Loja");
    }

    $("#get-coords-appearance").click(function () {
        $.post(baseUrl + "getCoordsAppearance", JSON.stringify({}));
    });

    $("#save-appearance").click(function () {
        let id = $("#edit-appearance-id").val();
        let type = $("#appearance-type").val();
        let x = parseFloat($("#appearance-x").val());
        let y = parseFloat($("#appearance-y").val());
        let z = parseFloat($("#appearance-z").val());
        let permission = $("#appearance-permission").val() || "";

        if (!type || isNaN(x) || isNaN(y) || isNaN(z)) return;

        $.post(baseUrl + "saveAppearance", JSON.stringify({
            id: id ? parseInt(id) : null,
            type: type,
            x: x,
            y: y,
            z: z,
            permission: permission
        }));
    });

    $(document).on("click", ".edit-appearance", function () {
        let app = $(this).data("appearance");
        if (typeof app === "string") app = JSON.parse(app);

        $(".nav-item").removeClass("active");
        $("[data-page='create-appearance']").addClass("active");
        $(".page-content").hide();
        $("#create-appearance").show();

        $("#page-title").text("Editar Loja de Estética");
        $("#save-appearance").text("Atualizar Loja");

        $("#edit-appearance-id").val(app.id);
        $("#appearance-type").val(app.Type);
        $("#appearance-x").val(app.X);
        $("#appearance-y").val(app.Y);
        $("#appearance-z").val(app.Z);
        $("#appearance-permission").val(app.Permission || "");
    });

    $(document).on("click", ".delete-appearance", function () {
        let id = $(this).data("id");
        let type = $(this).data("type");
        $.post(baseUrl + "deleteAppearance", JSON.stringify({ id: id, type: type }));
        setTimeout(() => { $.post(baseUrl + "requestAppearances", JSON.stringify({ type: type })); }, 300);
    });

    $(document).on("click", ".tp-appearance", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x)) $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    // Initialize with one empty access field
    resetForm();

    // Initialize wrappers height
    $(".nav-items-wrapper").css("height", "auto");

    // Make access list sortable
    if ($.fn.sortable) {
        $("#access-list").sortable({
            handle: ".drag-handle",
            axis: "y",
            cursor: "move",
            opacity: 0.8
        });
    }

    // --- RADIOS LOGIC ---
    function resetRadioForm() {
        $("#edit-radio-frequencia").val("");
        $("#radio-frequency").val("").prop("disabled", false);
        $("#radio-permission").val("");

        $("#page-title").text("Criar Rádio");
        $("#save-radio").text("Salvar Rádio");
    }

    $("#save-radio").click(function () {
        let isEdit = $("#edit-radio-frequencia").val() !== "";
        let frequencia = parseInt($("#radio-frequency").val());
        let permissao = $("#radio-permission").val();

        if (isNaN(frequencia) || frequencia <= 0 || frequencia > 999) {
            // Use a simple alert for invalid frequency for now
            return;
        }

        $.post(baseUrl + "saveRadio", JSON.stringify({
            frequencia: frequencia,
            permissao: permissao,
            isEdit: isEdit
        }));
    });

    $(document).on("click", ".edit-radio", function () {
        let frequencia = $(this).data("frequencia");
        let permissao = $(this).data("permissao");

        $(".nav-item").removeClass("active");
        $('[data-page="create-radio"]').addClass("active");
        $(".page-content").hide();
        $("#create-radio").fadeIn(200);

        $("#page-title").text("Editar Rádio: " + frequencia);
        $("#save-radio").text("Atualizar Rádio");

        $("#edit-radio-frequencia").val(frequencia);
        $("#radio-frequency").val(frequencia).prop("disabled", true);
        $("#radio-permission").val(permissao);
    });

    $(document).on("click", ".delete-radio", function () {
        let frequencia = $(this).data("frequencia");
        $.post(baseUrl + "deleteRadio", JSON.stringify({ frequencia: frequencia }));
        setTimeout(() => {
            $.post(baseUrl + "requestRadios", JSON.stringify({}));
        }, 300);
    });

    // ==========================================
    // CLOAKROOMS LOGIC
    // ==========================================

    function resetCloakroomForm() {
        $("#edit-cloakroom-id").val("");
        $("#cloakroom-name").val("");
        $("#cloakroom-permission").val("");
        $("#cloakroom-x").val("");
        $("#cloakroom-y").val("");
        $("#cloakroom-z").val("");
        $("#cloakroom-preset-list").empty();

        $("#page-title").text("Criar Vestiário");
        $("#save-cloakroom").text("Salvar Vestiário");
    }

    $("#get-coords-cloakroom").click(function () {
        $.post(baseUrl + "getCoordsCloakroom", JSON.stringify({}));
    });

    $("#add-cloakroom-preset").click(function () {
        let template = document.getElementById("cloakroom-preset-template").content.cloneNode(true);
        $("#cloakroom-preset-list").append(template);
    });

    $(document).on("click", ".remove-cloakroom-preset", function () {
        $(this).closest(".cloakroom-preset-row").remove();
    });

    let currentFillTarget = null;
    $(document).on("click", ".fill-current-clothes", function () {
        currentFillTarget = $(this).siblings(".cp-code");
        $.post(baseUrl + "getCurrentClothes", JSON.stringify({}));
    });

    $("#save-cloakroom").click(function () {
        let id = $("#edit-cloakroom-id").val();
        let name = $("#cloakroom-name").val();
        let permission = $("#cloakroom-permission").val() || "";
        let x = parseFloat($("#cloakroom-x").val());
        let y = parseFloat($("#cloakroom-y").val());
        let z = parseFloat($("#cloakroom-z").val());

        if (!name || isNaN(x) || isNaN(y) || isNaN(z)) {
            return;
        }

        let presets = {};
        let orderIndex = 1;
        $(".cloakroom-preset-row").each(function () {
            let presetName = $(this).find(".cp-name").val();
            let presetPerm = $(this).find(".cp-perm").val() || "";

            if (presetName && presetName.trim() !== "") {
                let code = $(this).find(".cp-code").val();
                presets[presetName] = { perm: presetPerm, code: code, order: orderIndex++ };
            }
        });

        $.post(baseUrl + "saveCloakroom", JSON.stringify({
            id: id ? parseInt(id) : null,
            name: name,
            permission: permission,
            x: x,
            y: y,
            z: z,
            presets: presets
        }));
    });

    $(document).on("click", ".edit-cloakroom", function () {
        let cloakroom = $(this).data("cloakroom");
        if (typeof cloakroom === "string") cloakroom = JSON.parse(cloakroom);

        $(".nav-item").removeClass("active");
        $("[data-page='create-cloakroom']").addClass("active");
        $(".page-content").hide();
        $("#create-cloakroom").show();

        $("#page-title").text("Editar Vestiário: " + cloakroom.Name);
        $("#save-cloakroom").text("Atualizar Vestiário");

        $("#edit-cloakroom-id").val(cloakroom.id);
        $("#cloakroom-name").val(cloakroom.Name);
        $("#cloakroom-permission").val(cloakroom.Permission || "");
        $("#cloakroom-x").val(cloakroom.X);
        $("#cloakroom-y").val(cloakroom.Y);
        $("#cloakroom-z").val(cloakroom.Z);

        $("#cloakroom-preset-list").empty();

        if (cloakroom.Presets) {
            let presetsData = typeof cloakroom.Presets === "string" ? JSON.parse(cloakroom.Presets) : cloakroom.Presets;

            let keys = Object.keys(presetsData);
            keys.sort((a, b) => {
                let orderA = presetsData[a].order || 999;
                let orderB = presetsData[b].order || 999;
                return orderA - orderB;
            });

            keys.forEach(presetName => {
                let pData = presetsData[presetName];

                let template = document.getElementById("cloakroom-preset-template").content.cloneNode(true);
                $("#cloakroom-preset-list").append(template);
                let row = $(".cloakroom-preset-row").last();

                row.find(".cp-name").val(presetName);
                row.find(".cp-perm").val(pData.perm || "");

                function objectToLuaTableString(obj, indent = "") {
                    if (typeof obj !== "object" || obj === null) {
                        return typeof obj === "string" ? '"' + obj + '"' : obj;
                    }
                    if (obj.hasOwnProperty("item") && obj.hasOwnProperty("texture")) {
                        return `{ item = ${obj.item}, texture = ${obj.texture} }`;
                    }
                    let str = "{\n";
                    let keys = Object.keys(obj);
                    keys.forEach((key, index) => {
                        if (key === "perm" || key === "code" || key === "order") return;
                        let val = obj[key];
                        let luaKey = typeof key === "number" || !isNaN(key) ? `[${key}]` : `["${key}"]`;
                        str += indent + "    " + luaKey + " = ";
                        if (typeof val === "object") {
                            str += objectToLuaTableString(val, indent + "    ");
                        } else {
                            str += typeof val === "string" ? '"' + val + '"' : val;
                        }
                        str += index < keys.length - 1 ? ",\n" : "\n";
                    });
                    str += indent + "}";
                    return str;
                }

                let luaCodeStr = "";
                let hasCode = false;
                Object.keys(pData).forEach(key => {
                    if (key !== "perm" && key !== "code" && key !== "order" && pData[key]) {
                        luaCodeStr += `["${key}"] = ` + objectToLuaTableString(pData[key], "") + ",\n";
                        hasCode = true;
                    }
                });

                if (hasCode) {
                    luaCodeStr = luaCodeStr.replace(/,\n$/, "");
                    row.find(".cp-code").val(luaCodeStr);
                } else if (pData.code) {
                    row.find(".cp-code").val(pData.code);
                }
            });
        }
    });

    $(document).on("click", ".delete-cloakroom", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteCloakroom", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestCloakrooms", JSON.stringify({})); }, 300);
    });

    $(document).on("click", ".tp-cloakroom", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x)) $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    // ==========================================
    // ELEVATORS LOGIC
    // ==========================================


    window.resetElevatorForm = function () {
        $("#edit-elevator-id").val("");
        $("#elevator-id-group").val("");
        $("#elevator-floor-list").empty();

        $("#page-title").text("Criar Elevador (Grupo)");
        $("#save-elevator").text("Salvar Elevador");
    }

    $("#add-elevator-floor").click(function () {
        let template = document.getElementById("elevator-floor-template").content.cloneNode(true);
        $("#elevator-floor-list").append(template);
    });

    $(document).on("click", ".remove-elevator-floor", function () {
        $(this).closest(".elevator-floor-row").remove();
    });

    $(document).on("click", ".get-coords-elevator-floor", function () {
        currentElevatorFloorRow = $(this).closest(".elevator-floor-row");
        $.post(baseUrl + "getCoordsElevator", JSON.stringify({}));
    });

    $("#save-elevator").click(function () {
        let elevator_id = $("#elevator-id-group").val();
        if (!elevator_id) return;

        let floors = [];
        $(".elevator-floor-row").each(function () {
            let name = $(this).find(".ef-name").val();
            let perm = $(this).find(".ef-perm").val();
            let x = parseFloat($(this).find(".ef-x").val());
            let y = parseFloat($(this).find(".ef-y").val());
            let z = parseFloat($(this).find(".ef-z").val());
            let h = parseFloat($(this).find(".ef-h").val());

            if (name && !isNaN(x) && !isNaN(y) && !isNaN(z)) {
                floors.push({
                    name: name,
                    permission: perm,
                    coords: { x: x, y: y, z: z, h: isNaN(h) ? 0.0 : h }
                });
            }
        });

        if (floors.length === 0) return;

        $.post(baseUrl + "saveElevator", JSON.stringify({
            elevator_id: elevator_id,
            floors: floors
        }));
    });

    $(document).on("click", ".edit-elevator-group", function () {
        let elevator_id = $(this).data("group");
        let groupFloors = JSON.parse(decodeURIComponent($(this).attr("data-floors")));

        $(".nav-item").removeClass("active");
        $('[data-page="create-elevator"]').addClass("active");
        $(".page-content").hide();
        $("#create-elevator").show();

        $("#page-title").text("Editar Elevador: " + elevator_id);
        $("#save-elevator").text("Atualizar Elevador");

        resetElevatorForm();
        $("#elevator-id-group").val(elevator_id);

        groupFloors.forEach(f => {
            $("#add-elevator-floor").click();
            let lastRow = $(".elevator-floor-row").last();
            lastRow.find(".ef-name").val(f.name);
            lastRow.find(".ef-perm").val(f.permission || "");
            try {
                let c = JSON.parse(f.coords);
                lastRow.find(".ef-x").val(c.x);
                lastRow.find(".ef-y").val(c.y);
                lastRow.find(".ef-z").val(c.z);
                if (c.h !== undefined) {
                    lastRow.find(".ef-h").val(c.h);
                }
            } catch (err) { }
        });
    });

    $(document).on("click", ".delete-elevator-group", function () {
        let elevator_id = $(this).data("group");
        $.post(baseUrl + "deleteElevator", JSON.stringify({ id: elevator_id }));
        setTimeout(() => { $.post(baseUrl + "requestElevators", JSON.stringify({})); }, 300);
    });
    // LSCUSTOMS
    window.addEventListener('message', function (event) {
        let data = event.data;
        if (data.action === "loadLSCustoms") {
            let tbody = $("#lscustoms-table tbody");
            tbody.empty();
            if (data.lscustoms && data.lscustoms.length > 0) {
                data.lscustoms.forEach(c => {
                    tbody.append(`
                        <tr>
                            <td>#${c.id}</td>
                            <td>${c.Name}</td>
                            <td>${(c.X || 0).toFixed(1)}, ${(c.Y || 0).toFixed(1)}, ${(c.Z || 0).toFixed(1)}, ${(c.H || 0).toFixed(1)}</td>
                            <td>${c.Permission || "Nenhuma"}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-lscustoms" data-x="${c.X}" data-y="${c.Y}" data-z="${c.Z}" title="Teleportar">
                                    <i class="fa-solid fa-location-dot"></i>
                                </button>
                                <button class="btn-icon edit-lscustoms" data-lscustoms='${JSON.stringify(c).replace(/'/g, "&#39;")}' title="Editar">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-icon delete delete-lscustoms" data-id="${c.id}" title="Deletar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            } else {
                tbody.append('<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhum local encontrado.</td></tr>');
            }
        } else if (data.action === "updateCoordsLSCustoms") {
            $("#lscustoms-x").val(data.coords.X.toFixed(2));
            $("#lscustoms-y").val(data.coords.Y.toFixed(2));
            $("#lscustoms-z").val(data.coords.Z.toFixed(2));
            $("#lscustoms-h").val(data.coords.H.toFixed(2));
        }
    });

    $(".nav-item").click(function () {
        let page = $(this).data("page");
        if (page === "create-lscustoms") {
            resetLSCustomsForm();
        } else if (page === "manage-lscustoms") {
            $.post(baseUrl + "requestLSCustoms", JSON.stringify({}));
        } else if (page === "create-door-setup") {
            resetDoorSetupForm();
        } else if (page === "manage-doors") {
            $.post(baseUrl + "requestDoors", JSON.stringify({}));
        }
    });

    $("#get-lscustoms-coords").click(function () {
        $.post(baseUrl + "getCoordsLSCustoms", JSON.stringify({}));
    });

    $("#save-lscustoms").click(function () {
        let id = $("#edit-lscustoms-id").val();
        let name = $("#lscustoms-name").val();
        let x = parseFloat($("#lscustoms-x").val());
        let y = parseFloat($("#lscustoms-y").val());
        let z = parseFloat($("#lscustoms-z").val());
        let h = parseFloat($("#lscustoms-h").val());
        let permission = $("#lscustoms-permission").val();
        let logo = $("#lscustoms-logo").val();

        if (!name || isNaN(x) || isNaN(y) || isNaN(z) || isNaN(h)) {
            return;
        }

        let data = {
            name: name,
            coords: { x: x, y: y, z: z, h: h },
            permission: permission,
            logo: logo
        };
        if (id) data.id = parseInt(id);

        $.post(baseUrl + "saveLSCustoms", JSON.stringify(data));
        resetLSCustomsForm();
        $('[data-page="manage-lscustoms"]').click();
    });

    $(document).on("click", ".edit-lscustoms", function () {
        let c = JSON.parse(decodeURIComponent($(this).attr("data-lscustoms")));
        $(".nav-item").removeClass("active");
        $('[data-page="create-lscustoms"]').addClass("active");
        $(".page-content").hide();
        $("#create-lscustoms").show();

        $("#page-title").text("Editar LSCustoms");
        $("#save-lscustoms").text("Atualizar Local");

        $("#edit-lscustoms-id").val(c.id);
        $("#lscustoms-name").val(c.Name);
        $("#lscustoms-x").val(c.X.toFixed(2));
        $("#lscustoms-y").val(c.Y.toFixed(2));
        $("#lscustoms-z").val(c.Z.toFixed(2));
        $("#lscustoms-h").val(c.H ? c.H.toFixed(2) : (0).toFixed(2));
        $("#lscustoms-permission").val(c.Permission || "");
        $("#lscustoms-logo").val(c.Logo || "lscustoms.png");
    });

    $(document).on("click", ".delete-lscustoms", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteLSCustoms", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestLSCustoms", JSON.stringify({})); }, 300);
    });

    $(document).on("click", ".tp-lscustoms", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    function resetLSCustomsForm() {
        $("#edit-lscustoms-id").val("");
        $("#lscustoms-name").val("");
        $("#lscustoms-x").val("");
        $("#lscustoms-y").val("");
        $("#lscustoms-z").val("");
        $("#lscustoms-h").val("");
        $("#lscustoms-permission").val("");
        $("#lscustoms-logo").val("lscustoms.png");
        $("#page-title").text("Criar LSCustoms");
        $("#save-lscustoms").text("Salvar Local");
    }

    $("#cloakroom-preset-list").sortable({
        handle: '.drag-handle',
        axis: 'y',
        cursor: 'grabbing'
    });

    // ==========================================
    // DOORS LOGIC
    // ==========================================

    $("#start-door-setup").click(function () {
        let name = $("#door-name").val() || "Porta";
        let isDouble = $("#door-is-double").is(":checked");
        let distance = parseFloat($("#door-distance").val()) || 2.0;
        let permission = $("#door-permission").val();

        $.post(baseUrl + "close", JSON.stringify({}));
        $.post(baseUrl + "startDoorSetup", JSON.stringify({
            name: name,
            isDouble: isDouble,
            distance: distance,
            permission: permission
        }));
    });

    $("#save-door-edit").click(function () {
        let id = $("#edit-door-id").val();
        let name = $("#door-name").val() || "Porta";
        let distance = parseFloat($("#door-distance").val()) || 2.0;
        let permission = $("#door-permission").val();

        $.post(baseUrl + "editDoorConfig", JSON.stringify({
            id: parseInt(id),
            name: name,
            distance: distance,
            permission: permission
        }));

        resetDoorSetupForm();
        $('[data-page="manage-doors"]').click();
    });

    $(document).on("click", ".edit-door", function () {
        let d = JSON.parse(decodeURIComponent($(this).attr("data-door")));
        $(".nav-item").removeClass("active");
        $('[data-page="create-door-setup"]').addClass("active");
        $(".page-content").hide();
        $("#create-door-setup").show();

        $("#page-title").text("Editar Porta #" + d.id);

        $("#edit-door-id").val(d.id);
        $("#door-name").val(d.name || d.Name || "");
        $("#door-is-double").prop("checked", d.other != null).prop("disabled", true); // Cannot change double status after creation
        $("#door-distance").val(d.distance);
        $("#door-permission").val(d.permission || "");

        $("#door-new-actions").hide();
        $("#door-edit-actions").show();
    });

    function resetDoorSetupForm() {
        $("#edit-door-id").val("");
        $("#door-name").val("");
        $("#door-is-double").prop("checked", false).prop("disabled", false);
        $("#door-distance").val("2.0");
        $("#door-permission").val("");
        $("#door-new-actions").show();
        $("#door-edit-actions").hide();
        $("#page-title").text("Criar Portas");
    }

    function renderDoorsTable(doors) {
        let tbody = $("#doors-table tbody");
        tbody.empty();
        if (!doors || doors.length === 0) {
            tbody.append("<tr><td colspan='5' style='text-align:center;'>Nenhuma porta encontrada</td></tr>");
            return;
        }

        doors.forEach(d => {
            let coordsObj = null;
            try {
                coordsObj = JSON.parse(d.coords);
            } catch (e) {
                console.error("Erro no JSON da porta ID " + d.id);
            }

            let coordsStr = coordsObj ? `${coordsObj.x.toFixed(2)}, ${coordsObj.y.toFixed(2)}, ${coordsObj.z.toFixed(2)}` : "Inválido";

            let tr = `<tr>
                <td>#${d.id}${d.other ? ' (Dupla)' : ''}</td>
                <td><strong>${d.name || d.Name || "Porta"}</strong><br><small style="color:#aaa;">Hash: ${d.hash}</small></td>
                <td>${d.distance}</td>
                <td><small>${d.permission || "Livre"}</small></td>
                <td class="action-btns">
                    <button class="btn-icon teleport-door" data-x="${coordsObj ? coordsObj.x : 0}" data-y="${coordsObj ? coordsObj.y : 0}" data-z="${coordsObj ? coordsObj.z : 0}" title="Teleportar">
                        <i class="fa-solid fa-location-dot"></i>
                    </button>
                    <button class="btn-icon edit-door" data-door='${encodeURIComponent(JSON.stringify(d))}' title="Editar">
                        <i class="fa-solid fa-pen"></i>
                    </button>
                    <button class="btn-icon delete delete-door" data-id="${d.id}" title="Apagar">
                        <i class="fa-solid fa-trash-can"></i>
                    </button>
                </td>
            </tr>`;
            tbody.append(tr);
        });
    }

    $(document).on("click", ".teleport-door", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    $(document).on("click", ".delete-door", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteDoor", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestDoors", JSON.stringify({})); }, 300);
    });

    // ==========================================
    // SAFEZONES (POLY)
    // ==========================================
    let safezonePoints = [];
    let safezoneMode = 'point'; // 'point' ou 'z'

    function renderSafezonePoints() {
        let list = $("#safezone-points-list");
        list.empty();
        safezonePoints.forEach((p, idx) => {
            list.append(`
                <div class="access-item" style="display: flex; justify-content: space-between; align-items: center; padding: 10px 16px;">
                    <span style="font-size: 14px; font-weight: 500;">Ponto ${idx + 1}: X: ${p.x}, Y: ${p.y}</span>
                    <button class="btn-icon delete remove-safezone-point" data-idx="${idx}"><i class="fa-solid fa-trash"></i></button>
                </div>
            `);
        });
    }

    $(document).on("click", ".remove-safezone-point", function () {
        let idx = $(this).data("idx");
        safezonePoints.splice(idx, 1);
        renderSafezonePoints();
    });

    $("#add-safezone-point").click(function () {
        safezonePoints.push({ x: 0.0, y: 0.0 });
        renderSafezonePoints();
    });

    $("#get-safezone-point").click(function () {
        safezoneMode = 'point';
        $.post(baseUrl + "getCoordsSafezone", JSON.stringify({}));
    });

    $("#get-safezone-z").click(function () {
        safezoneMode = 'z';
        $.post(baseUrl + "getCoordsSafezone", JSON.stringify({}));
    });

    $("#toggle-safezone-preview").click(function () {
        if (safezonePoints.length < 3) return; // PolyZone precisa de no mínimo 3 pontos

        let minZ = parseFloat($("#safezone-minz").val()) || 0.0;
        let maxZ = parseFloat($("#safezone-maxz").val()) || 50.0;
        let btn = $(this);
        let previewing = btn.hasClass("active");

        if (previewing) {
            btn.removeClass("active");
            btn.find("span").text("Visualizar Polígono");
            $.post(baseUrl + "togglePreviewSafezone", JSON.stringify({ state: false }));
        } else {
            btn.addClass("active");
            btn.find("span").text("Parar Visualização");
            $.post(baseUrl + "togglePreviewSafezone", JSON.stringify({
                state: true,
                points: safezonePoints,
                minZ: minZ,
                maxZ: maxZ
            }));
        }
    });

    $("#save-safezone").click(function () {
        let id = $("#edit-safezone-id").val();
        let name = $("#safezone-name").val();
        let minZ = parseFloat($("#safezone-minz").val());
        let maxZ = parseFloat($("#safezone-maxz").val());

        if (!name || isNaN(minZ) || isNaN(maxZ) || safezonePoints.length < 3) return;

        let data = {
            name: name,
            points: safezonePoints,
            minZ: minZ,
            maxZ: maxZ
        };
        if (id) data.id = parseInt(id);

        $.post(baseUrl + "saveSafezone", JSON.stringify(data));
    });

    $(document).on("click", ".edit-safezone", function () {
        let sStr = $(this).attr("data-safezone");
        if (!sStr) return;
        let s = JSON.parse(sStr.replace(/&#39;/g, "'"));

        $(".nav-item").removeClass("active");
        $('[data-page="create-safezone"]').addClass("active");
        $(".page-content").hide();
        $("#create-safezone").fadeIn(200);

        $("#page-title").text("Editar Safezone #" + s.id);

        $("#edit-safezone-id").val(s.id);
        $("#safezone-name").val(s.Name || "");
        $("#safezone-minz").val(s.minZ != null ? s.minZ.toFixed(2) : "");
        $("#safezone-maxz").val(s.maxZ != null ? s.maxZ.toFixed(2) : "");

        try {
            safezonePoints = JSON.parse(s.points) || [];
        } catch (e) { safezonePoints = []; }
        renderSafezonePoints();
    });

    $(document).on("click", ".delete-safezone", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteSafezone", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestSafezones", JSON.stringify({})); }, 300);
    });

    $(document).on("click", ".tp-safezone", function () {
        let ptsStr = $(this).attr("data-points");
        try {
            let pts = JSON.parse(ptsStr);
            if (pts && pts.length > 0) {
                // Teleporta pro primeiro ponto
                $.post(baseUrl + "teleport", JSON.stringify({ x: pts[0].x, y: pts[0].y, z: parseFloat($("#safezones-table").find(`button[data-points='${ptsStr}']`).closest("tr").find("td:eq(3)").text().split(" ")[0]) || 30.0 }));
            }
        } catch (e) { }
    });

    function resetSafezoneForm() {
        $("#edit-safezone-id").val("");
        $("#safezone-name").val("");
        $("#safezone-minz").val("");
        $("#safezone-maxz").val("");
        safezonePoints = [];
        renderSafezonePoints();
        $("#page-title").text("Criar Safezone");

        let prevBtn = $("#toggle-safezone-preview");
        if (prevBtn.hasClass("active")) {
            prevBtn.removeClass("active");
            prevBtn.find("span").text("Visualizar Polígono");
            $.post(baseUrl + "togglePreviewSafezone", JSON.stringify({ state: false }));
        }
    }

    // ==========================================
    // DESMANCHES LOGIC
    // ==========================================
    window.addEventListener("message", function (event) {
        let action = event.data.action;

        if (action === "updateDesmanches") {
            let tbody = $("#desmanches-table tbody");
            tbody.empty();
            let desmanches = event.data.desmanches;

            if (!desmanches || desmanches.length === 0) {
                tbody.append(`<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhum desmanche encontrado.</td></tr>`);
                return;
            }

            desmanches.forEach(d => {
                let config = {};
                try {
                    config = JSON.parse(d.Configuration);
                } catch (e) { }
                let blipStr = config.blip ? `${config.blip.x.toFixed(1)}, ${config.blip.y.toFixed(1)}, ${config.blip.z.toFixed(1)}` : 'N/A';

                tbody.append(`
                    <tr>
                        <td>#${d.id}</td>
                        <td>${d.Name}</td>
                        <td>${config.permission || 'Nenhuma'}</td>
                        <td>${blipStr}</td>
                        <td class="action-btns">
                            <button class="btn-icon tp-desmanche" data-x="${config.blip ? config.blip.x : 0}" data-y="${config.blip ? config.blip.y : 0}" data-z="${config.blip ? config.blip.z : 0}" title="Teleportar">
                                <i class="fa-solid fa-location-dot"></i>
                            </button>
                            <button class="btn-icon edit-desmanche" data-desmanche='${JSON.stringify(d).replace(/'/g, "&#39;")}' title="Editar Desmanche">
                                <i class="fa-solid fa-pen"></i>
                            </button>
                            <button class="btn-icon delete delete-desmanche" data-id="${d.id}" title="Apagar Desmanche">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `);
            });
        }

        if (action === "desmancheSaved") {
            $.post(baseUrl + "requestDesmanches", JSON.stringify({}));
            $(".nav-item").removeClass("active");
            $("[data-page='manage-desmanches']").addClass("active");
            $(".page-content").hide();
            $("#manage-desmanches").fadeIn(200);
            resetDesmancheForm();
        }

        if (action === "pushCoordsDesmanche") {
            let target = event.data.target;
            if (target === "blip") {
                $("#desmanche-blip-x").val(event.data.x.toFixed(2));
                $("#desmanche-blip-y").val(event.data.y.toFixed(2));
                $("#desmanche-blip-z").val(event.data.z.toFixed(2));
            } else if (target === "shelf") {
                $("#desmanche-shelf-x").val(event.data.x.toFixed(2));
                $("#desmanche-shelf-y").val(event.data.y.toFixed(2));
                $("#desmanche-shelf-z").val(event.data.z.toFixed(2));
                $("#desmanche-shelf-h").val(event.data.h.toFixed(2));
            }
        }

        if (action === "updateSettings" && event.data.module === "desmanche") {
            let cfg = event.data.config || {};
            $("#desmanche-st-wait").val(cfg.timeWaitBeforeStart ?? 15);
            $("#desmanche-st-duration").val(cfg.timeToFinish ?? 10);
            $("#desmanche-st-anim").val(cfg.animationTime ?? 5);
            $("#desmanche-st-dist").val(cfg.distanceToSeeText ?? 20);
            $("#desmanche-st-shelf").val(cfg.shelfObjectName || 'v_ind_cf_shelf2');
            $("#desmanche-st-npc").val(cfg.canChopNPCVehicles ? "true" : "false");
            $("#desmanche-st-auto").val(cfg.autoChop ? "true" : "false");

            let prohib = cfg.prohibiteVehicles || [];
            $("#desmanche-st-prohibited").val(prohib.join(", "));
        }
    });

    $('[data-page="manage-desmanches"]').click(function () {
        $.post(baseUrl + "requestDesmanches", JSON.stringify({}));
    });

    $('[data-page="settings-desmanche"]').click(function () {
        $.post(baseUrl + "requestSettings", JSON.stringify({ module: "desmanche" }));
    });

    $("#save-desmanche-settings").click(function () {
        let prohibStr = $("#desmanche-st-prohibited").val();
        let prohibArr = prohibStr.split(',').map(s => s.trim()).filter(s => s !== "");

        let config = {
            timeWaitBeforeStart: parseInt($("#desmanche-st-wait").val()) || 15,
            timeToFinish: parseInt($("#desmanche-st-duration").val()) || 10,
            animationTime: parseInt($("#desmanche-st-anim").val()) || 5,
            distanceToSeeText: parseInt($("#desmanche-st-dist").val()) || 20,
            shelfObjectName: $("#desmanche-st-shelf").val() || 'v_ind_cf_shelf2',
            canChopNPCVehicles: $("#desmanche-st-npc").val() === "true",
            autoChop: $("#desmanche-st-auto").val() === "true",
            prohibiteVehicles: prohibArr
        };

        $.post(baseUrl + "saveSettings", JSON.stringify({
            module: "desmanche",
            config: config
        }));
    });

    $(".get-desmanche-coords").click(function () {
        let target = $(this).data("target");
        $.post(baseUrl + "getCoordsDesmanche", JSON.stringify({ target: target }));
    });

    $("#save-desmanche").click(function () {
        let id = $("#edit-desmanche-id").val();
        let name = $("#desmanche-name").val();
        let permission = $("#desmanche-permission").val();
        let requireItem = $("#desmanche-requireItem").val();
        let requireItemAmount = parseInt($("#desmanche-requireItemAmount").val()) || 0;
        let darkMoneyItem = $("#desmanche-darkMoneyItem").val();
        let paymentMultiplier = parseInt($("#desmanche-paymentMultiplier").val()) || 40;

        let blipX = parseFloat($("#desmanche-blip-x").val());
        let blipY = parseFloat($("#desmanche-blip-y").val());
        let blipZ = parseFloat($("#desmanche-blip-z").val());

        let shelfX = parseFloat($("#desmanche-shelf-x").val());
        let shelfY = parseFloat($("#desmanche-shelf-y").val());
        let shelfZ = parseFloat($("#desmanche-shelf-z").val());
        let shelfH = parseFloat($("#desmanche-shelf-h").val());

        if (!name || isNaN(blipX) || isNaN(shelfX)) return;

        let config = {
            permission: permission || false,
            requireItem: requireItem || false,
            requireItemAmount: requireItemAmount,
            darkMoneyItem: darkMoneyItem || 'dirtydollar',
            paymentMultiplier: paymentMultiplier,
            blip: { x: blipX, y: blipY, z: blipZ },
            shelf: { cds: { x: shelfX, y: shelfY, z: shelfZ }, h: shelfH }
        };

        $.post(baseUrl + "saveDesmanche", JSON.stringify({
            id: id ? parseInt(id) : null,
            name: name,
            config: config
        }));
    });

    $(document).on("click", ".edit-desmanche", function () {
        let dStr = $(this).attr("data-desmanche");
        if (!dStr) return;
        let d = JSON.parse(dStr.replace(/&#39;/g, "'"));
        let config = {};
        try { config = JSON.parse(d.Configuration); } catch (e) { }

        $(".nav-item").removeClass("active");
        $('[data-page="create-desmanche"]').addClass("active");
        $(".page-content").hide();
        $("#create-desmanche").fadeIn(200);

        $("#page-title").text("Editar Desmanche");

        $("#edit-desmanche-id").val(d.id);
        $("#desmanche-name").val(d.Name);
        $("#desmanche-permission").val(config.permission || "");
        $("#desmanche-requireItem").val(config.requireItem || "");
        $("#desmanche-requireItemAmount").val(config.requireItemAmount || 0);
        $("#desmanche-darkMoneyItem").val(config.darkMoneyItem || "dirtydollar");
        $("#desmanche-paymentMultiplier").val(config.paymentMultiplier || 40);

        if (config.blip) {
            $("#desmanche-blip-x").val(config.blip.x);
            $("#desmanche-blip-y").val(config.blip.y);
            $("#desmanche-blip-z").val(config.blip.z);
        }
        if (config.shelf && config.shelf.cds) {
            $("#desmanche-shelf-x").val(config.shelf.cds.x);
            $("#desmanche-shelf-y").val(config.shelf.cds.y);
            $("#desmanche-shelf-z").val(config.shelf.cds.z);
            $("#desmanche-shelf-h").val(config.shelf.h);
        }
    });

    $(document).on("click", ".delete-desmanche", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteDesmanche", JSON.stringify({ id: id }));
        setTimeout(() => { $.post(baseUrl + "requestDesmanches", JSON.stringify({})); }, 300);
    });

    $(document).on("click", ".tp-desmanche", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x)) $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    function resetDesmancheForm() {
        $("#edit-desmanche-id").val("");
        $("#desmanche-name").val("");
        $("#desmanche-permission").val("");
        $("#desmanche-blip-x").val("");
        $("#desmanche-blip-y").val("");
        $("#desmanche-blip-z").val("");
        $("#desmanche-shelf-x").val("");
        $("#desmanche-shelf-y").val("");
        $("#desmanche-shelf-z").val("");
        $("#desmanche-shelf-h").val("");
        $("#desmanche-requireItem").val("");
        $("#desmanche-requireItemAmount").val("0");
        $("#desmanche-darkMoneyItem").val("dirtydollar");
        $("#desmanche-paymentMultiplier").val("40");
        $("#page-title").text("Criar Desmanche");
    }

    // Injetar barra de pesquisa dinamicamente
    $('.page-content[id^="manage-"]').each(function () {
        let tableContainer = $(this).find('.table-container');
        if (tableContainer.length > 0 && $(this).find('.search-bar-container').length === 0) {
            tableContainer.before('<div class="search-bar-container"><i class="fa-solid fa-magnifying-glass search-icon"></i><input type="text" class="search-input" placeholder="Procurar (Nome, ID)..."></div>');
        }
    });

    // Lógica da busca
    $(document).on('keyup', '.search-input:not([data-custom-search])', function () {
        let value = $(this).val().toLowerCase();
        let tbody = $(this).closest('.page-content').find('tbody');
        if (tbody.length > 0) {
            tbody.find('tr').filter(function () {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
            });
        }
    });

    // ==========================================
    // SERVICES (BATE-PONTOS) LOGIC
    // ==========================================

    function resetServiceForm() {
        $("#edit-service-id").val("");
        $("#service-permission").val("");
        $("#service-distance").val("1.5");
        $("#service-weight").val("1.0");
        $("#service-x").val("");
        $("#service-y").val("");
        $("#service-z").val("");

        $("#page-title").text("Criar Bate Ponto");
        $("#save-service-btn").text("Salvar Bate Ponto");
    }
    window.resetServiceForm = resetServiceForm;

    $("#get-coords-service").click(function () {
        $.post(baseUrl + "getCoordsService", JSON.stringify({}));
        $.post(baseUrl + "getCoords", JSON.stringify({ type: 3 }), function(coords) {
            if (coords && coords.x !== undefined) {
                $("#service-x").val(parseFloat(coords.x).toFixed(2));
                $("#service-y").val(parseFloat(coords.y).toFixed(2));
                $("#service-z").val(parseFloat(coords.z).toFixed(2));
            }
        });
    });

    $("#save-service-btn").click(function () {
        let id = $("#edit-service-id").val();
        let permission = $("#service-permission").val();
        let distance = parseFloat($("#service-distance").val()) || 1.5;
        let weight = parseFloat($("#service-weight").val()) || 1.0;
        let x = parseFloat($("#service-x").val());
        let y = parseFloat($("#service-y").val());
        let z = parseFloat($("#service-z").val());

        if (!permission || permission.trim() === "" || isNaN(x) || isNaN(y) || isNaN(z)) {
            return;
        }

        let data = {
            id: id !== "" ? parseInt(id) : null,
            permission: permission.trim(),
            distance: distance,
            weight: weight,
            coords: { x: x, y: y, z: z }
        };

        $.post(baseUrl + "saveService", JSON.stringify(data));
    });

    function renderServicesTable(services) {
        let tbody = $("#services-table tbody");
        tbody.empty();

        if (services && services.length > 0) {
            services.forEach(s => {
                let sJson = encodeURIComponent(JSON.stringify(s));
                tbody.append(`
                    <tr>
                        <td>#${s.id}</td>
                        <td><span style="font-weight: 600; color: #fff;">${s.Permission}</span></td>
                        <td>${(s.X || 0).toFixed(2)}, ${(s.Y || 0).toFixed(2)}, ${(s.Z || 0).toFixed(2)}</td>
                        <td>${(s.Distance || 1.5).toFixed(1)}</td>
                        <td>${(s.Weight || 1.0).toFixed(1)}</td>
                        <td class="action-btns">
                            <button class="btn-icon tp-service" data-x="${s.X}" data-y="${s.Y}" data-z="${s.Z}" title="Teleportar">
                                <i class="fa-solid fa-location-dot"></i>
                            </button>
                            <button class="btn-icon edit-service" data-service="${decodeURIComponent(sJson).replace(/"/g, '&quot;')}" title="Editar">
                                <i class="fa-solid fa-pen"></i>
                            </button>
                            <button class="btn-icon delete delete-service" data-id="${s.id}" title="Deletar">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `);
            });
        } else {
            tbody.append('<tr><td colspan="6" style="text-align: center; color: var(--text-muted);">Nenhum bate ponto encontrado.</td></tr>');
        }
    }
    window.renderServicesTable = renderServicesTable;

    $(document).on("click", ".edit-service", function () {
        let s = $(this).data("service");
        if (typeof s === "string") s = JSON.parse(s);

        $(".nav-item").removeClass("active");
        $('[data-page="create-service"]').addClass("active");
        $(".page-content").hide();
        $("#create-service").show();

        $("#page-title").text("Editar Bate Ponto: " + s.Permission);
        $("#save-service-btn").text("Atualizar Bate Ponto");

        $("#edit-service-id").val(s.id);
        $("#service-permission").val(s.Permission);
        $("#service-distance").val(s.Distance || 1.5);
        $("#service-weight").val(s.Weight || 1.0);
        $("#service-x").val((s.X || 0).toFixed(2));
        $("#service-y").val((s.Y || 0).toFixed(2));
        $("#service-z").val((s.Z || 0).toFixed(2));
    });

    $(document).on("click", ".delete-service", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteService", JSON.stringify({ id: id }));
        setTimeout(() => {
            $.post(baseUrl + "requestServices", JSON.stringify({}));
        }, 300);
    });

    $(document).on("click", ".tp-service", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        if (!isNaN(x) && !isNaN(y) && !isNaN(z)) {
            $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
        }
    });

    // ==========================================
    // ==========================================
    // GROUPS (GRUPOS / CARGOS) LOGIC & BUILDER
    // ==========================================
    let cachedGroupsList = [];

    // Helper: Select type card
    function selectGroupType(type) {
        $("#group-type").val(type);
        $(".group-type-card").removeClass("active");
        $(`.group-type-card[data-type="${type}"]`).addClass("active");
    }

    // Helper: Render visual cargo rows
    function renderCargoRows(hierarchyList, salaryList) {
        let container = $("#group-cargos-list");
        container.empty();

        if (!hierarchyList || hierarchyList.length === 0) {
            hierarchyList = ["Líder"];
        }

        hierarchyList.forEach((cName, idx) => {
            let sal = (salaryList && salaryList[idx] !== undefined && salaryList[idx] !== null) ? salaryList[idx] : "";
            let total = hierarchyList.length;
            let levelBadgeText = `Nível ${idx + 1}`;

            container.append(`
                <div class="cargo-row-item" data-index="${idx}">
                    <div class="cargo-level-badge">${levelBadgeText}</div>
                    <div style="flex: 2;">
                        <input type="text" class="cargo-name" value="${cName}" placeholder="Ex: Coronel" style="width: 100%; padding: 10px 14px; font-size: 13px; background: var(--bg-card); border: 1px solid var(--border); border-radius: 6px; color: #fff;">
                    </div>
                    <div style="flex: 1.2;">
                        <input type="number" class="cargo-salary" value="${sal}" placeholder="Ex: 5000 (Opcional)" min="0" style="width: 100%; padding: 10px 14px; font-size: 13px; background: var(--bg-card); border: 1px solid var(--border); border-radius: 6px; color: #fff;">
                    </div>
                    <div class="cargo-row-actions">
                        <button type="button" class="cargo-action-btn cargo-move-up" title="Mover para cima" ${idx === 0 ? 'disabled style="opacity:0.25;cursor:not-allowed;"' : ''}><i class="fa-solid fa-arrow-up"></i></button>
                        <button type="button" class="cargo-action-btn cargo-move-down" title="Mover para baixo" ${idx === total - 1 ? 'disabled style="opacity:0.25;cursor:not-allowed;"' : ''}><i class="fa-solid fa-arrow-down"></i></button>
                        <button type="button" class="cargo-action-btn btn-remove cargo-remove" title="Remover Cargo"><i class="fa-solid fa-trash"></i></button>
                    </div>
                </div>
            `);
        });
    }

    // Read current cargo rows data
    function getCargosData() {
        let hierarchy = [];
        let salary = [];
        $("#group-cargos-list .cargo-row-item").each(function () {
            let name = $(this).find(".cargo-name").val().trim();
            let salRaw = $(this).find(".cargo-salary").val().trim();
            if (name) {
                hierarchy.push(name);
                if (salRaw !== "") {
                    let n = parseInt(salRaw);
                    salary.push(isNaN(n) ? 0 : n);
                } else {
                    salary.push(0);
                }
            }
        });
        return { hierarchy, salary };
    }


    // Add cargo button
    $(document).on("click", "#add-cargo-btn", function () {
        let data = getCargosData();
        data.hierarchy.push(`Cargo ${data.hierarchy.length + 1}`);
        data.salary.push(0);
        renderCargoRows(data.hierarchy, data.salary);
    });

    // Move cargo up
    $(document).on("click", ".cargo-move-up", function () {
        let row = $(this).closest(".cargo-row-item");
        let idx = parseInt(row.data("index"));
        if (idx > 0) {
            let data = getCargosData();
            let tempH = data.hierarchy[idx];
            data.hierarchy[idx] = data.hierarchy[idx - 1];
            data.hierarchy[idx - 1] = tempH;

            let tempS = data.salary[idx];
            data.salary[idx] = data.salary[idx - 1];
            data.salary[idx - 1] = tempS;

            renderCargoRows(data.hierarchy, data.salary);
        }
    });

    // Move cargo down
    $(document).on("click", ".cargo-move-down", function () {
        let row = $(this).closest(".cargo-row-item");
        let idx = parseInt(row.data("index"));
        let data = getCargosData();
        if (idx < data.hierarchy.length - 1) {
            let tempH = data.hierarchy[idx];
            data.hierarchy[idx] = data.hierarchy[idx + 1];
            data.hierarchy[idx + 1] = tempH;

            let tempS = data.salary[idx];
            data.salary[idx] = data.salary[idx + 1];
            data.salary[idx + 1] = tempS;

            renderCargoRows(data.hierarchy, data.salary);
        }
    });

    // Remove cargo
    $(document).on("click", ".cargo-remove", function () {
        let row = $(this).closest(".cargo-row-item");
        let idx = parseInt(row.data("index"));
        let data = getCargosData();
        if (data.hierarchy.length > 1) {
            data.hierarchy.splice(idx, 1);
            data.salary.splice(idx, 1);
            renderCargoRows(data.hierarchy, data.salary);
        } else {
            data.hierarchy = ["Membro"];
            data.salary = [0];
            renderCargoRows(data.hierarchy, data.salary);
        }
    });

    // Group Type Cards click
    $(document).on("click", ".group-type-card", function () {
        selectGroupType($(this).data("type"));
    });

    function resetGroupForm() {
        $("#edit-group-original-name").val("");
        $("#group-name").val("").prop("disabled", false);
        $("#group-label").val("");
        selectGroupType("Work");
        $("#group-permissions").val("");
        $("#group-max").val("");
        $("#group-backpack").val("0");
        $("#group-markers").val("");

        renderCargoRows(["Líder", "Sub-Líder", "Membro"], [0, 0, 0]);

        $("#group-service").prop("checked", true);
        $("#group-rejoin-service").prop("checked", true);
        $("#group-chat").prop("checked", false);
        $("#group-block").prop("checked", false);
        $("#group-banned").prop("checked", false);
        $("#group-security-cam").prop("checked", false);
        $("#group-domination").prop("checked", false);
        $("#group-chest").prop("checked", false);

        $("#page-title").text("Criar Grupos");
        $("#save-group-btn").text("Salvar Grupo");
    }
    window.resetGroupForm = resetGroupForm;

    // Initialize default rows on ready
    renderCargoRows(["Líder", "Sub-Líder", "Membro"], [0, 0, 0]);

    $("#save-group-btn").click(function () {
        let originalName = $("#edit-group-original-name").val();
        let name = $("#group-name").val().trim();
        let label = $("#group-label").val().trim();
        let type = $("#group-type").val() || "Work";
        let permsRaw = $("#group-permissions").val().trim();
        let maxVal = $("#group-max").val().trim();
        let backpackVal = parseInt($("#group-backpack").val()) || 0;
        let markersVal = $("#group-markers").val().trim();

        if (!name) {
            $("#group-name").focus();
            return;
        }

        let permissions = [];
        if (permsRaw) {
            permsRaw.split(";").forEach(p => {
                let clean = p.trim();
                if (clean) permissions.push(clean);
            });
        }
        if (permissions.length === 0) permissions.push(name);

        let cargoData = getCargosData();
        let hierarchy = cargoData.hierarchy;
        let salary = cargoData.salary;

        if (hierarchy.length === 0) {
            hierarchy = ["Membro"];
            salary = [0];
        }

        let groupData = {
            originalName: originalName || null,
            name: name,
            label: label || name,
            type: type,
            permissions: permissions,
            hierarchy: hierarchy,
            salary: salary,
            maxMembers: maxVal !== "" ? parseInt(maxVal) : null,
            backpack: backpackVal,
            markers: markersVal !== "" ? parseInt(markersVal) : null,
            service: $("#group-service").is(":checked"),
            rejoinService: $("#group-rejoin-service").is(":checked"),
            chat: $("#group-chat").is(":checked"),
            block: $("#group-block").is(":checked"),
            banned: $("#group-banned").is(":checked"),
            securityCam: $("#group-security-cam").is(":checked"),
            domination: $("#group-domination").is(":checked"),
            chest: $("#group-chest").is(":checked")
        };

        $.post(baseUrl + "saveGroup", JSON.stringify(groupData));
    });

    function renderGroupsTable(groups) {
        let tbody = $("#groups-list");
        tbody.empty();

        if (groups && groups.length > 0) {
            groups.forEach(g => {
                let perms = [];
                try {
                    perms = JSON.parse(g.permissions || "[]");
                } catch(e) { perms = [g.name]; }

                let hier = [];
                try {
                    hier = JSON.parse(g.hierarchy || "[]");
                } catch(e) { hier = []; }

                let permsText = perms.join(", ");
                let hierText = hier.length > 0 ? (hier.slice(0, 3).join(" > ") + (hier.length > 3 ? ` (+${hier.length - 3})` : "")) : "Nenhum";
                let gJson = encodeURIComponent(JSON.stringify(g));

                tbody.append(`
                    <tr>
                        <td><span style="font-weight: 700; color: #fff;">${g.name}</span></td>
                        <td>${g.label || g.name}</td>
                        <td><span class="badge" style="background: rgba(255,255,255,0.08); padding: 4px 8px; border-radius: 4px; font-size: 11px;">${g.type || "Work"}</span></td>
                        <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${permsText}">${permsText}</td>
                        <td style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${hier.join(' > ')}">${hierText}</td>
                        <td>${g.service ? '<span style="color: #4ade80;"><i class="fa-solid fa-check"></i> Sim</span>' : '<span style="color: var(--text-muted);"><i class="fa-solid fa-xmark"></i> Não</span>'}</td>
                        <td class="action-btns">
                            <button class="btn-icon edit-group" data-group="${decodeURIComponent(gJson).replace(/"/g, '&quot;')}" title="Editar">
                                <i class="fa-solid fa-pen"></i>
                            </button>
                            <button class="btn-icon delete delete-group" data-name="${g.name}" title="Deletar">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `);
            });
        } else {
            tbody.append('<tr><td colspan="7" style="text-align: center; color: var(--text-muted); padding: 20px;">Nenhum grupo encontrado.</td></tr>');
        }
    }
    window.renderGroupsTable = renderGroupsTable;

    $(document).on("click", ".edit-group", function () {
        let g = $(this).data("group");
        if (typeof g === "string") g = JSON.parse(g);

        $(".nav-item").removeClass("active");
        $('[data-page="create-group"]').addClass("active");
        $(".page-content").hide();
        $("#create-group").show();

        $("#page-title").text("Editar Grupo: " + g.name);
        $("#save-group-btn").text("Atualizar Grupo");

        $("#edit-group-original-name").val(g.name);
        $("#group-name").val(g.name).prop("disabled", true);
        $("#group-label").val(g.label || g.name);
        selectGroupType(g.type || "Work");

        let perms = [];
        try { perms = JSON.parse(g.permissions || "[]"); } catch(e) { perms = []; }
        $("#group-permissions").val(perms.join(";"));

        let hier = [];
        try { hier = JSON.parse(g.hierarchy || "[]"); } catch(e) { hier = []; }

        let sal = [];
        try { sal = JSON.parse(g.salary || "[]"); } catch(e) { sal = []; }

        renderCargoRows(hier, sal);

        $("#group-max").val(g.max_members !== null && g.max_members !== undefined ? g.max_members : "");
        $("#group-backpack").val(g.backpack || 0);
        $("#group-markers").val(g.markers !== null && g.markers !== undefined ? g.markers : "");

        $("#group-service").prop("checked", g.service == 1);
        $("#group-rejoin-service").prop("checked", g.rejoin_service == 1);
        $("#group-chat").prop("checked", g.chat == 1);
        $("#group-block").prop("checked", g.block == 1);
        $("#group-banned").prop("checked", g.banned == 1);
        $("#group-security-cam").prop("checked", g.security_cam == 1);
        $("#group-domination").prop("checked", g.domination == 1);
        $("#group-chest").prop("checked", g.chest == 1);
    });

    $(document).on("click", ".delete-group", function () {
        let name = $(this).data("name");
        if (!name) return;
        $.post(baseUrl + "deleteGroup", JSON.stringify({ name: name }));
    });

});

// -----------------------------------------------------------------------------------------------------------------------------------------
// ROTAS
// -----------------------------------------------------------------------------------------------------------------------------------------
$(document).ready(function () {
    const baseUrl = `https://${window.GetParentResourceName ? window.GetParentResourceName() : 'Night_Management'}/`;

    // Fetch and populate routes
    function loadRoutes() {
        $.post(baseUrl + "getRoutes", JSON.stringify({}), function (data) {
            let tbody = $("#routes-table tbody");
            tbody.empty();
            if (data) {
                data.forEach(function (r) {
                    let itemsCount = r.list ? Object.keys(JSON.parse(r.list)).length : 0;
                    let coordsCount = r.coords ? Object.keys(JSON.parse(r.coords)).length : 0;

                    let initStr = r.init;
                    if (!initStr || initStr === "null") {
                        if (r.coords) {
                            try {
                                let coordsArr = JSON.parse(r.coords);
                                if (coordsArr.length > 0) {
                                    initStr = JSON.stringify(coordsArr[0]);
                                }
                            } catch (e) { }
                        }
                    }

                    let html = `
                        <tr>
                            <td>${r.name}</td>
                            <td>${r.mode}</td>
                            <td>${r.permission || 'Nenhuma'}</td>
                            <td>${itemsCount}</td>
                            <td>${coordsCount}</td>
                            <td class="action-btns">
                                <button class="btn-icon tp-route" data-init='${initStr}' title="Teleportar"><i class="fa-solid fa-location-dot"></i></button>
                                <button class="btn-icon edit-route" data-id="${r.id}" data-info='${JSON.stringify(r).replace(/'/g, "&#39;")}' title="Editar Rota"><i class="fa-solid fa-pen"></i></button>
                                <button class="btn-icon delete delete-route" data-id="${r.id}" title="Apagar Rota"><i class="fa-solid fa-trash"></i></button>
                            </td>
                        </tr>
                    `;
                    tbody.append(html);
                });
            }
        });
    }

    $('[data-page="manage-routes"]').click(function () {
        loadRoutes();
    });

    $(document).on("click", ".tp-route", function () {
        let initStr = $(this).attr("data-init");
        if (initStr && initStr !== "null") {
            try {
                let init = JSON.parse(initStr);
                if (init && init.x !== undefined) {
                    $.post(baseUrl + "teleport", JSON.stringify({ x: parseFloat(init.x), y: parseFloat(init.y), z: parseFloat(init.z) }));
                }
            } catch (e) { }
        }
    });

    // Add Item logic
    $(".add-item-btn").click(function () {
        let idx = Date.now();
        let html = `
            <div class="access-item route-item-row" data-id="${idx}" style="margin-bottom: 12px; padding: 16px; display: flex; gap: 16px; align-items: center;">
                <div class="drag-handle" style="display: flex; align-items: center; justify-content: center; width: 40px; padding-right: 16px; margin: 0;" title="Item">
                    <i class="fa-solid fa-box" style="font-size: 1.2rem; color: var(--text-muted);"></i>
                </div>
                <div style="flex: 1; display: flex; flex-direction: column; gap: 12px;">
                    <div style="display: flex; gap: 16px;">
                        <div class="form-group" style="flex: 2; margin: 0;">
                            <label>Nome do Spawn do Item</label>
                            <input type="text" class="route-item-name" placeholder="Ex: aluminum">
                        </div>
                        <div class="form-group" style="flex: 1; margin: 0;">
                            <label>Chance (%)</label>
                            <input type="number" class="route-item-chance" value="50">
                        </div>
                    </div>
                    <div style="display: flex; gap: 16px;">
                        <div class="form-group" style="flex: 1; margin: 0;">
                            <label>Minimo</label>
                            <input type="number" class="route-item-min" value="1">
                        </div>
                        <div class="form-group" style="flex: 1; margin: 0;">
                            <label>Máximo</label>
                            <input type="number" class="route-item-max" value="5">
                        </div>
                        <div class="form-group" style="flex: 1; margin: 0;">
                            <label>Preço</label>
                            <input type="number" class="route-item-price" value="0">
                        </div>
                    </div>
                </div>
                <button type="button" class="btn-square btn-danger remove-item-btn" style="margin-left: 8px; flex-shrink: 0;" title="Remover Item"><i class="fa-solid fa-trash"></i></button>
            </div>
        `;
        $("#route-items-list").append(html);
    });

    // Add Route Coord
    $(".add-route-coord-btn").click(function () {
        let idx = Date.now();
        let html = `
            <div class="access-item route-coord-row" data-id="${idx}" style="margin-bottom: 12px;">
                <div class="access-row">
                    <div class="drag-handle" title="Coordenada">
                        <i class="fa-solid fa-map-location-dot"></i>
                    </div>
                    <div class="form-group">
                        <label>Coordenada X</label>
                        <input type="number" class="route-coord-x" placeholder="X" step="0.01">
                    </div>
                    <div class="form-group">
                        <label>Coordenada Y</label>
                        <input type="number" class="route-coord-y" placeholder="Y" step="0.01">
                    </div>
                    <div class="form-group">
                        <label>Coordenada Z</label>
                        <input type="number" class="route-coord-z" placeholder="Z" step="0.01">
                    </div>
                    <button type="button" class="btn-square btn-secondary-square get-coords-btn-rc" title="Pegar Atual"><i class="fa-solid fa-location-dot"></i></button>
                    <button type="button" class="btn-square btn-danger remove-item-btn" title="Remover"><i class="fa-solid fa-trash"></i></button>
                </div>
            </div>
        `;
        $("#route-coords-list").append(html);
    });

    $(document).on("click", ".remove-item-btn", function () {
        $(this).closest(".access-item").remove();
    });

    $(document).on("click", ".get-coords-btn-rc", function () {
        let btn = $(this);
        btn.html('<i class="fa-solid fa-spinner fa-spin"></i>');
        currentRouteCoordTarget = btn.closest(".route-coord-row");
        $.post(baseUrl + 'getCoordsForRouteCoord', JSON.stringify({}));
        setTimeout(() => { btn.html('<i class="fa-solid fa-location-dot"></i>'); }, 2000); // fallback
    });

    $(document).on("click", ".get-coords-btn", function () {
        let btn = $(this);
        let targetId = btn.data("target");
        if (targetId === 'route-init-coords') {
            btn.html('<i class="fa-solid fa-spinner fa-spin"></i>');
            $.post(baseUrl + 'getCoordsForRouteInit', JSON.stringify({}));
            setTimeout(() => { btn.html('<i class="fa-solid fa-location-dot"></i>'); }, 2000); // fallback
        }
    });

    $(".clear-coords-btn").click(function () {
        let targetId = $(this).data("target");
        if (targetId === "route-init-coords") {
            $("#route-init-x").val("");
            $("#route-init-y").val("");
            $("#route-init-z").val("");
        } else {
            $("#" + targetId).val("");
        }
    });

    // Save
    $("#save-route-btn").click(function () {
        let items = [];
        $(".route-item-row").each(function () {
            let name = $(this).find(".route-item-name").val();
            if (name) {
                items.push({
                    Item: name,
                    Chance: parseInt($(this).find(".route-item-chance").val()) || 50,
                    Min: parseInt($(this).find(".route-item-min").val()) || 1,
                    Max: parseInt($(this).find(".route-item-max").val()) || 1,
                    Price: parseInt($(this).find(".route-item-price").val()) || 0
                });
            }
        });

        let coords = [];
        $(".route-coord-row").each(function () {
            let cx = $(this).find(".route-coord-x").val();
            let cy = $(this).find(".route-coord-y").val();
            let cz = $(this).find(".route-coord-z").val();
            if (cx !== "" && cy !== "" && cz !== "") {
                coords.push({ x: parseFloat(cx), y: parseFloat(cy), z: parseFloat(cz) });
            }
        });

        let expName = $("#route-exp-name").val();
        let expAmount = parseInt($("#route-exp-amount").val());
        let expData = null;
        if (expName && expAmount) {
            expData = { Name: expName, Amount: expAmount };
        }

        let initX = $("#route-init-x").val();
        let initY = $("#route-init-y").val();
        let initZ = $("#route-init-z").val();
        let initCoords = (initX !== "" && initY !== "" && initZ !== "") ? { x: parseFloat(initX), y: parseFloat(initY), z: parseFloat(initZ) } : null;

        let routeData = {
            id: $("#edit-route-id").val(),
            name: $("#route-name").val(),
            permission: $("#route-permission").val(),
            mode: $("#route-mode").val(),
            circle: parseFloat($("#route-circle").val()) || 1.0,
            wanted: $("#route-wanted").val() !== "" ? parseInt($("#route-wanted").val()) : false,
            battlepass: $("#route-battlepass").val() !== "" ? parseInt($("#route-battlepass").val()) : false,
            isRoute: $("#route-is-route").is(":checked"),
            debugPoly: $("#route-debugpoly").is(":checked"),
            loop: $("#route-is-loop").is(":checked"),
            initCoords: initCoords,
            experience: expData,
            list: items,
            coords: coords
        };

        if (!routeData.name || !routeData.mode || !routeData.initCoords || routeData.list.length === 0 || routeData.coords.length === 0) {
            // Se usar notify no painel, pode ser adaptado, mas o alert bloqueia nativamente
            alert("Preencha todos os campos obrigatórios: Nome da Rota, Modo, Coordenada Inicial, pelo menos um Item e pelo menos uma Coordenada de Entrega!");
            return;
        }

        $.post(baseUrl + "saveRoute", JSON.stringify(routeData), function (res) {
            if (res.status) {
                $('[data-page="manage-routes"]').click();
                $("#edit-route-id").val("");
                $("#route-name").val("");
                $("#route-items-list").empty();
                $("#route-coords-list").empty();
            }
        });
    });

    $(document).on("click", ".delete-route", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteRoute", JSON.stringify({ id: id }), function (res) {
            if (res.status) {
                loadRoutes();
            }
        });
    });

    $(document).on("click", ".edit-route", function () {
        let info = $(this).data("info");

        $("#page-title").text("Editar Rota: " + info.name);
        $("#save-route-btn").text("Atualizar Rota");

        $("#edit-route-id").val(info.id);
        $("#route-name").val(info.name);
        $("#route-permission").val(info.permission || "");
        $("#route-mode").val(info.mode);
        $("#route-circle").val(info.circle);

        if (info.wanted) $("#route-wanted").val(info.wanted); else $("#route-wanted").val("");
        if (info.battlepass) $("#route-battlepass").val(info.battlepass); else $("#route-battlepass").val("");

        $("#route-is-route").prop("checked", info.route == 1);
        $("#route-debugpoly").prop("checked", info.debugpoly == 1);
        $("#route-is-loop").prop("checked", info.loop == 1);

        if (info.init) {
            try {
                let init = JSON.parse(info.init);
                $("#route-init-x").val(init.x !== undefined ? init.x : "");
                $("#route-init-y").val(init.y !== undefined ? init.y : "");
                $("#route-init-z").val(init.z !== undefined ? init.z : "");
            } catch (e) {
                $("#route-init-x").val("");
                $("#route-init-y").val("");
                $("#route-init-z").val("");
            }
        } else {
            $("#route-init-x").val("");
            $("#route-init-y").val("");
            $("#route-init-z").val("");
        }

        if (info.experience) {
            try {
                let ex = JSON.parse(info.experience);
                $("#route-exp-name").val(ex.Name || "");
                $("#route-exp-amount").val(ex.Amount || "");
            } catch (e) { }
        } else {
            $("#route-exp-name").val("");
            $("#route-exp-amount").val("");
        }

        $("#route-items-list").empty();
        if (info.list) {
            try {
                let items = JSON.parse(info.list);
                items.forEach(function (it) {
                    $(".add-item-btn").click();
                    let lastRow = $(".route-item-row").last();
                    lastRow.find(".route-item-name").val(it.Item);
                    lastRow.find(".route-item-chance").val(it.Chance);
                    lastRow.find(".route-item-min").val(it.Min);
                    lastRow.find(".route-item-max").val(it.Max);
                    lastRow.find(".route-item-price").val(it.Price);
                });
            } catch (e) { }
        }

        $("#route-coords-list").empty();
        if (info.coords) {
            try {
                let coords = JSON.parse(info.coords);
                coords.forEach(function (coord) {
                    $(".add-route-coord-btn").click();
                    let lastRow = $(".route-coord-row").last();
                    lastRow.find(".route-coord-x").val(coord.x !== undefined ? coord.x : "");
                    lastRow.find(".route-coord-y").val(coord.y !== undefined ? coord.y : "");
                    lastRow.find(".route-coord-z").val(coord.z !== undefined ? coord.z : "");
                });
            } catch (e) { }
        }

        $('.nav-item').removeClass('active');
        $('[data-page="create-route"]').addClass('active');
        $('.page-content').hide();
        $('#create-route').show();
    });

    $('[data-page="create-route"]').click(function () {
        $("#page-title").text("Criar Nova Rota");
        $("#save-route-btn").text("Salvar Rota");
        $("#edit-route-id").val("");
        $("#route-name").val("");
        $("#route-permission").val("");
        $("#route-mode").val("Sequential");
        $("#route-circle").val("1.0");
        $("#route-wanted").val("");
        $("#route-battlepass").val("");
        $("#route-is-route").prop("checked", true);
        $("#route-debugpoly").prop("checked", false);
        $("#route-is-loop").prop("checked", false);
        $("#route-init-x").val("");
        $("#route-init-y").val("");
        $("#route-init-z").val("");
        $("#route-exp-name").val("");
        $("#route-exp-amount").val("");
        $("#route-items-list").empty();
        $("#route-coords-list").empty();
    });

    /* ========================================================================== */
    /* MONEYWASH LOGIC */
    /* ========================================================================== */

    let moneywashData = [];

    window.addEventListener('message', function (event) {
        if (event.data.action === "loadMoneywash") {
            moneywashData = event.data.machines || [];
            renderMoneywashes();
        } else if (event.data.action === "moneywashSaved") {
            document.getElementById('edit-moneywash-id').value = '';
            document.getElementById('moneywash-name').value = '';
            document.getElementById('moneywash-permission').value = '';
            document.getElementById('moneywash-x').value = '';
            document.getElementById('moneywash-y').value = '';
            document.getElementById('moneywash-z').value = '';
            document.getElementById('moneywash-h').value = '';
            document.getElementById('moneywash-hash').value = 'bkr_prop_prtmachine_dryer_spin';
            document.getElementById('moneywash-tax').value = '5';
            document.getElementById('moneywash-battery').value = 'washbattery';
            document.getElementById('moneywash-bleach').value = 'washbleach';
            document.getElementById('moneywash-dirty-item').value = 'dirtydollar';
            document.getElementById('moneywash-clean-item').value = 'dollar';
            document.getElementById('moneywash-wet-item').value = 'wetdollar';
            document.getElementById('moneywash-amount').value = '500';
            document.getElementById('moneywash-time').value = '10';
            document.getElementById('moneywash-battery-duration').value = '604800';
            document.getElementById('moneywash-bleach-duration').value = '21600';
            document.getElementById('moneywash-bleach-bonus').value = '50';
            document.getElementById('moneywash-dry-amount').value = '200';
            document.getElementById('moneywash-dry-time').value = '30';
            document.getElementById('moneywash-dry-tax').value = '30';
            $.post(baseUrl + 'requestMoneywash', JSON.stringify({}));
            $('[data-page="manage-moneywash"]').click();
        }
    });

    // Setup click listener for requesting moneywash when page opens
    document.querySelector('.nav-item[data-page="manage-moneywash"]').addEventListener('click', () => {
        $.post(baseUrl + 'requestMoneywash', JSON.stringify({}));
    });

    // Get coords
    $('#get-moneywash-coords').click(function () {
        $.post(baseUrl + 'getCoordsMoneywash', JSON.stringify({}), function (data) {
        });
    });
    // Need to capture updateCoords for moneywash if it's active
    window.addEventListener('message', function (event) {
        if (event.data.action === "updateCoordsMoneywash") {
            if ($('.nav-item[data-page="create-moneywash"]').hasClass('active')) {
                $('#moneywash-x').val(event.data.coords.X.toFixed(2));
                $('#moneywash-y').val(event.data.coords.Y.toFixed(2));
                $('#moneywash-z').val((event.data.coords.Z - 1.0).toFixed(2)); // Adjust Z for ground
                $('#moneywash-h').val(event.data.coords.H.toFixed(2));
            }
        }
    });

    // Save
    $('#save-moneywash-btn').click(function () {
        const id = $('#edit-moneywash-id').val();
        const name = $('#moneywash-name').val();
        const permission = $('#moneywash-permission').val();
        const spawnProp = $('#moneywash-spawn-prop').is(':checked');
        const hash = spawnProp ? $('#moneywash-hash').val() : "";
        const x = parseFloat($('#moneywash-x').val());
        const y = parseFloat($('#moneywash-y').val());
        const z = parseFloat($('#moneywash-z').val());
        const h = parseFloat($('#moneywash-h').val());
        const tax = parseInt($('#moneywash-tax').val()) || 5;
        const batteryItem = $('#moneywash-battery').val() || "washbattery";
        const bleachItem = $('#moneywash-bleach').val() || "washbleach";
        const dirtyItem = $('#moneywash-dirty-item').val() || "dirtydollar";
        const cleanItem = $('#moneywash-clean-item').val() || "dollar";
        const wetItem = $('#moneywash-wet-item').val() || "wetdollar";
        const washAmount = parseInt($('#moneywash-amount').val()) || 500;
        const washTime = parseInt($('#moneywash-time').val()) || 10;
        const batteryDuration = parseInt($('#moneywash-battery-duration').val()) || 604800;
        const bleachDuration = parseInt($('#moneywash-bleach-duration').val()) || 21600;
        const bleachBonus = parseInt($('#moneywash-bleach-bonus').val()) || 50;
        const dryAmount = parseInt($('#moneywash-dry-amount').val()) || 200;
        const dryTime = parseInt($('#moneywash-dry-time').val()) || 30;
        const dryTax = parseInt($('#moneywash-dry-tax').val()) || 30;

        if (!name || isNaN(x) || isNaN(y) || isNaN(z)) {
            return;
        }

        $.post(baseUrl + 'saveMoneywash', JSON.stringify({
            id: id !== '' ? parseInt(id) : null,
            name: name,
            permission: permission,
            hash: hash,
            tax: tax,
            batteryItem: batteryItem,
            bleachItem: bleachItem,
            dirtyItem: dirtyItem,
            cleanItem: cleanItem,
            wetItem: wetItem,
            washAmount: washAmount,
            washTime: washTime,
            batteryDuration: batteryDuration,
            bleachDuration: bleachDuration,
            bleachBonus: bleachBonus,
            dryAmount: dryAmount,
            dryTime: dryTime,
            dryTax: dryTax,
            coords: { x: x, y: y, z: z, h: h }
        }));
    });

    function renderMoneywashes() {
        const list = $('#moneywash-list');
        list.empty();

        if (!moneywashData || moneywashData.length === 0) {
            list.append(`<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhuma máquina encontrada.</td></tr>`);
            return;
        }

        moneywashData.forEach(m => {
            const item = `
            <tr>
                <td>#${m.id || "N/A"}</td>
                <td>${m.Name}</td>
                <td>${m.Permission || 'Nenhuma'}</td>
                <td>${m.Tax || 5}%</td>
                <td class="action-btns">
                    <button class="btn-icon tp-moneywash-btn" data-id="${m.id}" title="Teleportar">
                        <i class="fa-solid fa-location-dot"></i>
                    </button>
                    <button class="btn-icon edit-moneywash-btn" data-id="${m.id}" title="Editar">
                        <i class="fa-solid fa-pen"></i>
                    </button>
                    <button class="btn-icon delete delete-moneywash-btn" data-id="${m.id}" title="Excluir">
                        <i class="fa-solid fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
            list.append(item);
        });

        $('.tp-moneywash-btn').click(function () {
            const id = parseInt($(this).data('id'));
            const m = moneywashData.find(x => x.id === id);
            if (m) $.post(baseUrl + 'teleport', JSON.stringify({ x: m.X, y: m.Y, z: m.Z }));
        });

        $('.edit-moneywash-btn').click(function () {
            const id = parseInt($(this).data('id'));
            const m = moneywashData.find(x => x.id === id);
            if (m) {
                $('#edit-moneywash-id').val(m.id);
                $('#moneywash-name').val(m.Name);
                $('#moneywash-permission').val(m.Permission);
                if (m.Hash && m.Hash !== "") {
                    $('#moneywash-hash').val(m.Hash);
                    $('#moneywash-spawn-prop').prop('checked', true);
                } else {
                    $('#moneywash-hash').val('bkr_prop_prtmachine_dryer_spin');
                    $('#moneywash-spawn-prop').prop('checked', false);
                }
                $('#moneywash-x').val(m.X);
                $('#moneywash-y').val(m.Y);
                $('#moneywash-z').val(m.Z);
                $('#moneywash-h').val(m.H);
                $('#moneywash-tax').val(m.Tax || 5);
                $('#moneywash-battery').val(m.BatteryItem || 'washbattery');
                $('#moneywash-bleach').val(m.BleachItem || 'washbleach');
                $('#moneywash-dirty-item').val(m.DirtyItem || 'dirtydollar');
                $('#moneywash-clean-item').val(m.CleanItem || 'dollar');
                $('#moneywash-wet-item').val(m.WetItem || 'wetdollar');
                $('#moneywash-amount').val(m.WashAmount || 500);
                $('#moneywash-time').val(m.WashTime || 10);
                $('#moneywash-battery-duration').val(m.BatteryDuration || 604800);
                $('#moneywash-bleach-duration').val(m.BleachDuration || 21600);
                $('#moneywash-bleach-bonus').val(m.BleachBonus || 50);
                $('#moneywash-dry-amount').val(m.DryAmount || 200);
                $('#moneywash-dry-time').val(m.DryTime || 30);
                $('#moneywash-dry-tax').val(m.DryTax || 30);
                $('[data-page="create-moneywash"]').click();
            }
        });

        $('.delete-moneywash-btn').click(function () {
            const id = parseInt($(this).data('id'));
            $.post(baseUrl + 'deleteMoneywash', JSON.stringify({ id: id }));
        });
    }

    // --- DENSITY LOGIC ---
    $("#save-density").click(function () {
        let vehicle = parseFloat($("#density-vehicle").val()) || 0.0;
        let randomVehicle = parseFloat($("#density-random-vehicle").val()) || 0.0;
        let parkedVehicle = parseFloat($("#density-parked-vehicle").val()) || 0.0;
        let scenarioPed = parseFloat($("#density-scenario-ped").val()) || 0.0;
        let ped = parseFloat($("#density-ped").val()) || 0.0;

        $.post(baseUrl + "saveDensity", JSON.stringify({
            VehicleDensity: vehicle,
            RandomVehicleDensity: randomVehicle,
            ParkedVehicleDensity: parkedVehicle,
            ScenarioPedDensity: scenarioPed,
            PedDensity: ped
        }));
    });

    // --- CLEARAREA LOGIC ---
    function resetClearAreaForm() {
        $("#edit-cleararea-id").val("");
        $("#cleararea-name").val("");
        $("#cleararea-x").val("");
        $("#cleararea-y").val("");
        $("#cleararea-z").val("");
        $("#cleararea-radius").val("100.0");
        $("#cleararea-peds").prop("checked", true);
        $("#cleararea-vehicles").prop("checked", true);
    }

    $("#get-cleararea-coords").click(function () {
        $.post(baseUrl + "getCoordsClearArea", JSON.stringify({}));
    });

    $("#save-cleararea").click(function () {
        let id = $("#edit-cleararea-id").val();
        let name = $("#cleararea-name").val();
        let x = parseFloat($("#cleararea-x").val());
        let y = parseFloat($("#cleararea-y").val());
        let z = parseFloat($("#cleararea-z").val());
        let radius = parseFloat($("#cleararea-radius").val()) || 100.0;
        let clearPeds = $("#cleararea-peds").is(":checked");
        let clearVehicles = $("#cleararea-vehicles").is(":checked");

        if (!name || isNaN(x) || isNaN(y) || isNaN(z)) {
            return;
        }

        $.post(baseUrl + "saveClearArea", JSON.stringify({
            id: id || null,
            name: name,
            x: x,
            y: y,
            z: z,
            radius: radius,
            clearPeds: clearPeds,
            clearVehicles: clearVehicles
        }));
    });

    $(document).on("click", ".tp-cleararea", function () {
        let x = parseFloat($(this).data("x"));
        let y = parseFloat($(this).data("y"));
        let z = parseFloat($(this).data("z"));
        $.post(baseUrl + "teleport", JSON.stringify({ x: x, y: y, z: z }));
    });

    $(document).on("click", ".edit-cleararea", function () {
        let c = JSON.parse($(this).attr("data-cleararea").replace(/&#39;/g, "'"));
        $("#edit-cleararea-id").val(c.id);
        $("#cleararea-name").val(c.Name);
        $("#cleararea-x").val(c.X);
        $("#cleararea-y").val(c.Y);
        $("#cleararea-z").val(c.Z);
        $("#cleararea-radius").val(c.Radius);
        $("#cleararea-peds").prop("checked", c.ClearPeds);
        $("#cleararea-vehicles").prop("checked", c.ClearVehicles);
        $('[data-page="create-cleararea"]').click();
    });

    $(document).on("click", ".delete-cleararea", function () {
        let id = $(this).data("id");
        $.post(baseUrl + "deleteClearArea", JSON.stringify({ id: id }));
    });

    // Moneywash Save Logic
    $('#save-moneywash').click(function () {
        const id = $('#edit-moneywash-id').val();
        const name = $('#moneywash-name').val();
        const permission = $('#moneywash-permission').val();
        const hash = $('#moneywash-hash').val();
        const tax = parseInt($('#moneywash-tax').val()) || 5;
        const x = parseFloat($('#moneywash-x').val());
        const y = parseFloat($('#moneywash-y').val());
        const z = parseFloat($('#moneywash-z').val());
        const h = parseFloat($('#moneywash-h').val());

        const batteryItem = $('#moneywash-battery').val() || 'washbattery';
        const bleachItem = $('#moneywash-bleach').val() || 'washbleach';
        const dirtyItem = $('#moneywash-dirty-item').val() || 'dirtydollar';
        const cleanItem = $('#moneywash-clean-item').val() || 'dollar';
        const wetItem = $('#moneywash-wet-item').val() || 'wetdollar';

        const washAmount = parseInt($('#moneywash-amount').val()) || 500;
        const washTime = parseInt($('#moneywash-time').val()) || 10;

        const batteryDuration = parseInt($('#moneywash-battery-duration').val()) || 604800;
        const bleachDuration = parseInt($('#moneywash-bleach-duration').val()) || 21600;
        const bleachBonus = parseInt($('#moneywash-bleach-bonus').val()) || 50;
        const dryAmount = parseInt($('#moneywash-dry-amount').val()) || 200;
        const dryTime = parseInt($('#moneywash-dry-time').val()) || 30;
        const dryTax = parseInt($('#moneywash-dry-tax').val()) || 30;

        if (!name || isNaN(x) || isNaN(y) || isNaN(z)) {
            return;
        }

        $.post(baseUrl + 'saveMoneywash', JSON.stringify({
            id: id !== '' ? parseInt(id) : null,
            name: name,
            permission: permission,
            hash: hash,
            tax: tax,
            batteryItem: batteryItem,
            bleachItem: bleachItem,
            dirtyItem: dirtyItem,
            cleanItem: cleanItem,
            wetItem: wetItem,
            washAmount: washAmount,
            washTime: washTime,
            batteryDuration: batteryDuration,
            bleachDuration: bleachDuration,
            bleachBonus: bleachBonus,
            dryAmount: dryAmount,
            dryTime: dryTime,
            dryTax: dryTax,
            coords: { x: x, y: y, z: z, h: h }
        }));
    });

    // ==========================================
    // PERMISSIONS
    // ==========================================
    $(document).on("click", ".nav-item[data-page='manage-permissions']", function () {
        $.post(baseUrl + "requestAdminRoles", JSON.stringify({}));
    });

    $("#permissions-role-select").change(function () {
        let role = $(this).val();
        if (role !== "") {
            $.post(baseUrl + "requestRolePermissions", JSON.stringify({ role: role }));
        } else {
            $("#permissions-container").hide();
        }
    });

    window.renderPermissionsUI = function (role, permissions) {
        let container = $("#permissions-list");
        container.empty();

        for (let catName in window.categoryMap) {
            let catKey = window.categoryMap[catName];

            let p = permissions[catKey] || { view: false, manage: false, teleport: false };

            let html = `
                <div class="permission-item" data-cat="${catKey}" style="background: linear-gradient(145deg, rgba(25,25,25,0.8), rgba(15,15,15,0.9)); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05); display: flex; flex-direction: column; gap: 15px; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
                    <div style="display: flex; align-items: center; gap: 12px; padding-bottom: 12px; border-bottom: 1px solid rgba(255,255,255,0.05);">
                        <div style="width: 38px; height: 38px; border-radius: 10px; background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255,255,255,0.1); display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; box-shadow: 0 0 10px var(--primary);">
                            <i class="fa-solid ${{
                    'BAÚS': 'fa-box',
                    'GARAGENS': 'fa-warehouse',
                    'CONCESSIONÁRIAS': 'fa-car',
                    'LOJAS': 'fa-shopping-cart',
                    'CRAFTING': 'fa-hammer',
                    'BLIPS': 'fa-map-marker-alt',
                    'NPCS': 'fa-user-tie',
                    'RÁDIOS': 'fa-walkie-talkie',
                    'ELEVADORES': 'fa-elevator',
                    'ROUPAS': 'fa-shirt',
                    'BARBEARIAS': 'fa-scissors',
                    'TATUAGENS': 'fa-pen-nib',
                    'VESTIÁRIOS': 'fa-user-nurse',
                    'LSCUSTOMS': 'fa-wrench',
                    'PORTAS': 'fa-door-closed',
                    'SAFEZONES': 'fa-shield-halved',
                    'DESMANCHES': 'fa-car-burst',
                    'ROTAS': 'fa-route',
                    'LAVAGEM': 'fa-money-bill-transfer',
                    'DENSIDADE': 'fa-users',
                    'CLEARAREA': 'fa-broom',
                    'PERMISSÕES': 'fa-user-shield',
                    'BATE-PONTOS': 'fa-business-time',
                    'GRUPOS': 'fa-users-gear'
                }[catName] || 'fa-layer-group'
                }"></i>
                        </div>
                        <span style="font-weight: 700; font-size: 16px; color: #fff; letter-spacing: 0.5px; text-transform: uppercase;">${catName}</span>
                    </div>
                    
                    <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                        <!-- VER -->
                        <div style="flex: 1; min-width: 200px; background: rgba(0,0,0,0.4); padding: 15px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.03); display: flex; align-items: center; justify-content: space-between; transition: background 0.2s;">
                            <div style="display: flex; flex-direction: column;">
                                <span style="font-size: 14px; font-weight: 600; color: #fff; display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-eye" style="color: #aaa;"></i> Ver</span>
                                <span style="font-size: 12px; color: #888; margin-top: 4px;">Pode visualizar e acessar a aba da categoria</span>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" class="perm-view" ${p.view ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <!-- GERENCIAR -->
                        <div style="flex: 1; min-width: 200px; background: rgba(0,0,0,0.4); padding: 15px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.03); display: flex; align-items: center; justify-content: space-between; transition: background 0.2s;">
                            <div style="display: flex; flex-direction: column;">
                                <span style="font-size: 14px; font-weight: 600; color: #fff; display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-pen-to-square" style="color: #aaa;"></i> Gerenciar</span>
                                <span style="font-size: 12px; color: #888; margin-top: 4px;">Pode criar, editar e excluir configurações</span>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" class="perm-manage" ${p.manage ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        ${catKey !== 'Permissions' && catKey !== 'Webhooks' ? `
                        <!-- TELEPORTE -->
                        <div style="flex: 1; min-width: 200px; background: rgba(0,0,0,0.4); padding: 15px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.03); display: flex; align-items: center; justify-content: space-between; transition: background 0.2s;">
                            <div style="display: flex; flex-direction: column;">
                                <span style="font-size: 14px; font-weight: 600; color: #fff; display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-location-dot" style="color: #aaa;"></i> Teleporte</span>
                                <span style="font-size: 12px; color: #888; margin-top: 4px;">Pode se teleportar para as coordenadas</span>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" class="perm-teleport" ${p.teleport ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>
                        ` : ''}
                    </div>
                </div>
            `;
            container.append(html);
        }

        $("#permissions-container").fadeIn();
    };

    $("#save-permissions").click(function () {
        let role = $("#permissions-role-select").val();
        if (!role) return;

        let permissions = {};
        $(".permission-item").each(function () {
            let catKey = $(this).data("cat");
            let view = $(this).find(".perm-view").is(":checked");
            let manage = $(this).find(".perm-manage").is(":checked");
            let teleport = $(this).find(".perm-teleport").is(":checked");
            permissions[catKey] = { view: view, manage: manage, teleport: teleport };
        });

        $.post(baseUrl + "saveRolePermissions", JSON.stringify({ role: role, permissions: permissions }));
    });

    $(document).on("click", ".nav-item[data-page='manage-webhooks']", function () {
        $.post(baseUrl + "requestWebhooks");
    });

    window.renderWebhooksUI = function (webhooks) {
        let container = $("#webhooks-container");
        container.empty();
        let html = "";
        let cats = ["Chests", "Garages", "PDM", "Shops", "Crafting", "Skinshop", "Barbershop", "Tattooshop", "Radio", "Cloakroom", "Elevators", "Safezones", "LSCustoms", "Doors", "Blips", "NPCs", "Desmanches", "Routes", "Moneywash", "Density", "ClearArea", "Services", "Groups", "Config"];
        cats.forEach(c => {
            let link = webhooks[c] || "";
            html += `
                <div class="form-group" style="background: rgba(0,0,0,0.4); padding: 15px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.03);">
                    <label style="color: #fff; font-weight: 600;"><i class="fa-solid fa-link" style="color: var(--primary);"></i> ${c}</label>
                    <input type="text" class="form-control webhook-input" data-cat="${c}" value="${link}" placeholder="URL do Webhook do Discord">
                </div>
            `;
        });
        container.html(html);
    }

    $("#save-webhooks-btn").click(function () {
        let webhooks = {};
        $(".webhook-input").each(function () {
            let cat = $(this).data("cat");
            let val = $(this).val();
            webhooks[cat] = val;
        });
        $.post(baseUrl + "saveWebhooks", JSON.stringify(webhooks));
    });

    const observer = new MutationObserver(function (mutations) {
        if (!window.CurrentPermissions || !window.categoryMap) return;
        let activeCatElement = $('.nav-item.active').closest('.nav-category').find('.category-header span');
        if (activeCatElement.length === 0) return;
        let activeCat = activeCatElement.text().trim();

        let permKey = window.categoryMap[activeCat];
        if (permKey && window.CurrentPermissions[permKey]) {
            let p = window.CurrentPermissions[permKey];
            if (!p.manage) {
                $('.edit-btn, .delete-btn, .btn-primary:not(#save-permissions), .btn-danger, .create-btn, .edit-service, .delete-service').hide();
            } else {
                $('.edit-btn, .delete-btn, .btn-primary:not(#save-permissions), .btn-danger, .create-btn, .edit-service, .delete-service').show();
            }
            if (!p.teleport) {
                $('.teleport-btn, .tp-btn, .tp-cleararea, .tp-service').hide();
            } else {
                $('.teleport-btn, .tp-btn, .tp-cleararea, .tp-service').show();
            }
        }
    });
    observer.observe(document.querySelector('.main-content'), { childList: true, subtree: true });

});

// ==========================================
// PROPS DA CIDADE (client-side/props.lua + server-side/props.lua)
// ==========================================
$(function () {
    const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'Night_Management';
    const baseUrl = `https://${resourceName}/`;

    function resetPropForm() {
        $("#edit-prop-id").val("");
        $("#prop-name").val("");
        $("#prop-model").val("");
        $("#prop-distance").val("100");
        $("#prop-collision").prop("checked", true);
    }

    // Fecha o painel pelo callback normal e depois entra no modo de posicionamento
    function startPlacement(data) {
        $.post(baseUrl + "close", JSON.stringify({})).always(function () {
            $.post(baseUrl + "placeProp", JSON.stringify(data));
        });
    }

    window.addEventListener("message", function (event) {
        const data = event.data;
        if (data.action !== "updateProps") return;

        const tbody = $("#props-table tbody");
        tbody.empty();
        if (data.props && data.props.length > 0) {
            data.props.forEach(p => {
                const row = $(`
                    <tr>
                        <td>#${p.id}</td>
                        <td></td>
                        <td>${(p.X || 0).toFixed(1)}, ${(p.Y || 0).toFixed(1)}, ${(p.Z || 0).toFixed(1)}</td>
                        <td class="action-btns">
                            <button class="btn-icon tp-prop" title="Teleportar"><i class="fa-solid fa-location-dot"></i></button>
                            <button class="btn-icon move-prop" title="Reposicionar no jogo"><i class="fa-solid fa-up-down-left-right"></i></button>
                            <button class="btn-icon edit-prop" title="Editar"><i class="fa-solid fa-pen"></i></button>
                            <button class="btn-icon delete delete-prop" title="Deletar"><i class="fa-solid fa-trash"></i></button>
                        </td>
                    </tr>`);
                row.find("td").eq(1).append(document.createTextNode(p.Name), "<br>", $("<small>").text(p.Model));
                row.find(".tp-prop").on("click", () => $.post(baseUrl + "teleport", JSON.stringify({ x: p.X, y: p.Y, z: p.Z })));
                row.find(".move-prop").on("click", () => startPlacement({ id: p.id, name: p.Name, model: p.Model, distance: p.Distance, collision: p.Collision }));
                row.find(".delete-prop").on("click", () => $.post(baseUrl + "deleteProp", JSON.stringify({ id: p.id })));
                row.find(".edit-prop").on("click", () => {
                    $(".nav-item").removeClass("active");
                    $("[data-page='create-prop']").addClass("active");
                    $(".page-content").hide();
                    $("#create-prop").show();
                    $("#edit-prop-id").val(p.id);
                    $("#prop-name").val(p.Name);
                    $("#prop-model").val(p.Model);
                    $("#prop-distance").val(p.Distance);
                    $("#prop-collision").prop("checked", !!p.Collision);
                });
                tbody.append(row);
            });
        } else {
            tbody.append('<tr><td colspan="4" style="text-align: center; color: var(--text-muted);">Nenhum prop encontrado.</td></tr>');
        }
    });

    $(".nav-item").on("click", function () {
        const page = $(this).data("page");
        if (page === "create-prop") {
            resetPropForm();
        } else if (page === "manage-props") {
            $.post(baseUrl + "requestProps", JSON.stringify({}));
        }
    });

    $("#place-prop").on("click", function () {
        const id = $("#edit-prop-id").val();
        const name = $("#prop-name").val().trim();
        const model = $("#prop-model").val().trim();
        if (!model) return;

        startPlacement({
            id: id ? parseInt(id) : null,
            name: name || model,
            model: model,
            distance: parseInt($("#prop-distance").val()) || 100,
            collision: $("#prop-collision").is(":checked")
        });
    });
});

// ==========================================
// CAIXAS ELETRÔNICOS (client-side/atms.lua + server-side/atms.lua)
// ==========================================
$(function () {
    const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'Night_Management';
    const baseUrl = `https://${resourceName}/`;

    function resetAtmForm() {
        $("#edit-atm-id").val("");
        $("#atm-kind").val("atm").trigger("change");
        $("#atm-name").val("");
        $("#atm-x").val("");
        $("#atm-y").val("");
        $("#atm-z").val("");
        $("#atm-model").val("");
        $("#atm-open").prop("checked", true);
        $("#atm-rob").prop("checked", true);
        $("#atm-start").val("");
        $("#atm-end").val("");
    }

    function hasHour(value) {
        return value !== null && value !== undefined;
    }

    window.addEventListener("message", function (event) {
        const data = event.data;
        if (data.action !== "updateAtms") return;

        const tbody = $("#atms-table tbody");
        tbody.empty();
        if (data.atms && data.atms.length > 0) {
            data.atms.forEach(a => {
                const options = [];
                if (a.Open) options.push("Abrir");
                if (a.Rob) options.push(hasHour(a.StartHour) ? `Roubar (${a.StartHour}h às ${a.EndHour}h)` : "Roubar");

                const row = $(`
                    <tr>
                        <td>#${a.id}</td>
                        <td></td>
                        <td>${(a.X || 0).toFixed(1)}, ${(a.Y || 0).toFixed(1)}, ${(a.Z || 0).toFixed(1)}</td>
                        <td></td>
                        <td class="action-btns">
                            <button class="btn-icon tp-atm" title="Teleportar"><i class="fa-solid fa-location-dot"></i></button>
                            <button class="btn-icon edit-atm" title="Editar"><i class="fa-solid fa-pen"></i></button>
                            <button class="btn-icon delete delete-atm" title="Deletar"><i class="fa-solid fa-trash"></i></button>
                        </td>
                    </tr>`);
                row.find("td").eq(1).append(document.createTextNode(a.Name), "<br>", $("<small>").text(a.Kind === "agency" ? "Agência" : (a.Model || "modelo não detectado")));
                row.find("td").eq(3).text(options.length ? options.join(" / ") : "Nenhuma");
                row.find(".tp-atm").on("click", () => $.post(baseUrl + "teleport", JSON.stringify({ x: a.X, y: a.Y, z: a.Z })));
                row.find(".delete-atm").on("click", () => $.post(baseUrl + "deleteAtm", JSON.stringify({ id: a.id })));
                row.find(".edit-atm").on("click", () => {
                    $(".nav-item").removeClass("active");
                    $("[data-page='create-atm']").addClass("active");
                    $(".page-content").hide();
                    $("#create-atm").show();
                    $("#edit-atm-id").val(a.id);
                    $("#atm-kind").val(a.Kind || "atm").trigger("change");
                    $("#atm-name").val(a.Name);
                    $("#atm-x").val(a.X);
                    $("#atm-y").val(a.Y);
                    $("#atm-z").val(a.Z);
                    $("#atm-model").val(a.Model || "");
                    $("#atm-open").prop("checked", !!a.Open);
                    $("#atm-rob").prop("checked", !!a.Rob);
                    $("#atm-start").val(hasHour(a.StartHour) ? a.StartHour : "");
                    $("#atm-end").val(hasHour(a.EndHour) ? a.EndHour : "");
                });
                tbody.append(row);
            });
        } else {
            tbody.append('<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Nenhum ATM encontrado.</td></tr>');
        }
    });

    $(".nav-item").on("click", function () {
        const page = $(this).data("page");
        if (page === "create-atm") {
            resetAtmForm();
        } else if (page === "manage-atms") {
            $.post(baseUrl + "requestAtms", JSON.stringify({}));
        }
    });

    $("#atm-here").on("click", function () {
        $.post(baseUrl + "atmHere", JSON.stringify({ kind: $("#atm-kind").val() }), function (result) {
            if (typeof result === "string") result = JSON.parse(result);
            $("#atm-x").val(result.x.toFixed(2));
            $("#atm-y").val(result.y.toFixed(2));
            $("#atm-z").val(result.z.toFixed(2));
            $("#atm-model").val(result.model || "");
        });
    });

    $("#save-atm").on("click", function () {
        const id = $("#edit-atm-id").val();
        const x = parseFloat($("#atm-x").val());
        const y = parseFloat($("#atm-y").val());
        const z = parseFloat($("#atm-z").val());
        if (isNaN(x) || isNaN(y) || isNaN(z)) return;

        const start = $("#atm-start").val();
        const end = $("#atm-end").val();

        $.post(baseUrl + "saveAtm", JSON.stringify({
            id: id ? parseInt(id) : null,
            name: $("#atm-name").val().trim(),
            x: x, y: y, z: z,
            kind: $("#atm-kind").val(),
            model: $("#atm-model").val(),
            open: $("#atm-open").is(":checked"),
            rob: $("#atm-rob").is(":checked"),
            startHour: start !== "" && end !== "" ? parseInt(start) : null,
            endHour: start !== "" && end !== "" ? parseInt(end) : null
        }));
    });
});
$(function () {
    const resource = window.GetParentResourceName ? window.GetParentResourceName() : 'Night_Management';
    const post = (name, data = {}) => $.post(`https://${resource}/${name}`, JSON.stringify(data));
    let houses = [];
    let interiors = {};
    let housePage = 0;
    const pageSize = 50;
    const fields = [['Police', 0, 1000], ['Delay', 0, 604800], ['Timer', 1, 86400], ['Wanted', 0, 86400], ['Min', 0, 100000000], ['Max', 0, 100000000]];

    $('#atm-kind').on('change', function () {
        const agency = $(this).val() === 'agency';
        $('#atm-model').prop('disabled', agency);
        $('#atm-rob').prop('disabled', agency);
        $('#atm-start, #atm-end').prop('disabled', agency);
        if (agency) $('#atm-rob').prop('checked', false);
    });

    $('.nav-item').on('click', function () {
        if ($(this).data('page') === 'manage-robberies') post('requestRobberies');
        if ($(this).data('page') === 'manage-houses') post('requestHouses');
        if ($(this).data('page') === 'manage-stocks') post('requestStocks');
        if ($(this).data('page') === 'manage-blips') post('requestBlips');
        if ($(this).data('page') === 'create-blip') newBlip();
        if ($(this).data('page') === 'create-house') { newHouse(); post('requestHouses'); }
    });

    function renderRobberies(entries) {
        const body = $('#robberies-body').empty();
        entries.forEach(entry => {
            const row = $('<tr>');
            $('<td>').text(`${entry.Name} (${entry.id})`).append($('<small>').text(` — ${entry.Item || 'sem item'}`)).appendTo(row);
            const enabled = $('<input type="checkbox">').prop('checked', entry.Enabled);
            $('<td>').append(enabled).appendTo(row);
            const inputs = {};
            fields.forEach(([key, min, max]) => {
                inputs[key] = $('<input type="number" step="1" required>').attr({ min, max, 'aria-label': key }).val(entry[key]).css('width', '95px');
                $('<td>').append(inputs[key]).appendTo(row);
            });
            const save = $('<button class="btn-icon" type="button" title="Salvar">').html('<i class="fa-solid fa-floppy-disk"></i>').on('click', function () {
                const data = { id: entry.id, Enabled: enabled.is(':checked') };
                for (const [key] of fields) {
                    if (!inputs[key][0].reportValidity()) return;
                    data[key] = Number(inputs[key].val());
                }
                if (data.Min > data.Max) { inputs.Min[0].setCustomValidity('O mínimo não pode superar o máximo.'); inputs.Min[0].reportValidity(); inputs.Min[0].setCustomValidity(''); return; }
                post('saveRobbery', data);
            });
            $('<td class="action-btns">').append(save).appendTo(row);
            body.append(row);
        });
    }

    function newHouse() {
        $('#house-form')[0].reset();
        $('#house-id').val('');
        $('#save-house').html('<i class="fa-solid fa-floppy-disk"></i> Salvar Casa');
        $('#house-interior').trigger('change');
    }
    function editHouse(id) {
        $('.nav-item').removeClass('active');
        $('[data-page="create-house"]').addClass('active');
        $('.page-content').hide();
        $('#create-house').fadeIn(200);
        $('#page-title').text(`Editar Casa: ${id}`);
        $('#save-house').html('<i class="fa-solid fa-floppy-disk"></i> Atualizar Casa');
        $('#house-id').val(id);
    }
    function renderHouses() {
        const body = $('#houses-body').empty();
        const search = $('#house-search').val().trim().toLowerCase();
        const filtered = houses.filter(h => `${h.id} ${h.Interior || ''} ${h.X} ${h.Y} ${h.Z}`.toLowerCase().includes(search));
        housePage = Math.max(0, Math.min(housePage, Math.ceil(filtered.length / pageSize) - 1));
        filtered.slice(housePage * pageSize, (housePage + 1) * pageSize).forEach(h => {
            const row = $('<tr>');
            $('<td>').text(h.id).appendTo(row);
            $('<td>').text([h.X, h.Y, h.Z].map(v => v.toFixed(2)).join(', ')).appendTo(row);
            $('<td>').text(h.Interior || 'Escolhido na compra').appendTo(row);
            $('<td>').text(h.Price ? h.Price.toLocaleString('pt-BR') : 'Conforme interior').appendTo(row);
            const actions = $('<td class="action-btns">').appendTo(row);
            $('<button type="button" class="btn-icon" title="Teleportar">').html('<i class="fa-solid fa-location-dot"></i>').on('click', () => post('teleport', { x: h.X, y: h.Y, z: h.Z })).appendTo(actions);
            $('<button type="button" class="btn-icon" title="Editar">').html('<i class="fa-solid fa-pen"></i>').on('click', () => {
                editHouse(h.id);
                for (const key of ['X', 'Y', 'Z']) $(`#house-${key}`).val(h[key]);
                $('#house-interior').val(h.Interior || Object.keys(interiors)[0]);
                $('#house-price').val(h.Price || interiors[$('#house-interior').val()]);
            }).appendTo(actions);
            body.append(row);
        });
        const pager = $('#houses-pager').empty();
        $('<span>').text(`${filtered.length} casas — Página ${housePage + 1} de ${Math.max(1, Math.ceil(filtered.length / pageSize))}`).appendTo(pager);
        $('<button type="button" class="btn-secondary">').html('<i class="fa-solid fa-chevron-left"></i> Anterior').prop('disabled', housePage === 0).on('click', () => { housePage--; renderHouses(); }).appendTo(pager);
        $('<button type="button" class="btn-secondary">').html('Próxima <i class="fa-solid fa-chevron-right"></i>').prop('disabled', (housePage + 1) * pageSize >= filtered.length).on('click', () => { housePage++; renderHouses(); }).appendTo(pager);
    }
    let stocks = [];
    let stockPage = 0;
    function renderStocks() {
        const body = $('#stocks-body').empty();
        const search = $('#stock-search').val().trim().toLowerCase();
        const filtered = stocks.filter(s => `${s.Name} ${s.id} ${s.Class}`.toLowerCase().includes(search));
        stockPage = Math.max(0, Math.min(stockPage, Math.ceil(filtered.length / pageSize) - 1));
        filtered.slice(stockPage * pageSize, (stockPage + 1) * pageSize).forEach(s => {
            const row = $('<tr>');
            $('<td>').text(s.Name).append($('<small>').text(` — ${s.id}${s.Custom ? ' (editado)' : ''}`)).appendTo(row);
            $('<td>').text(s.Class).appendTo(row);
            $('<td>').text(s.Sold).appendTo(row);
            const input = $('<input type="number" step="1" min="0" max="100000" placeholder="Ilimitado">').attr('aria-label', 'Estoque').val(s.Stock ?? '').css('width', '110px');
            $('<td>').append(input).appendTo(row);
            const free = s.Stock == null ? 'Ilimitado' : Math.max(0, s.Stock - s.Sold);
            $('<td>').text(free).css('color', free === 0 ? 'var(--danger, #e74c3c)' : '').appendTo(row);
            const actions = $('<td class="action-btns">').appendTo(row);
            $('<button class="btn-icon" type="button" title="Salvar">').html('<i class="fa-solid fa-floppy-disk"></i>').on('click', () => {
                if (!input[0].reportValidity()) return;
                const value = input.val().trim();
                post('saveStock', { id: s.id, Stock: value === '' ? null : Number(value) });
            }).appendTo(actions);
            if (s.Custom) {
                $('<button class="btn-icon" type="button" title="Restaurar valor do config">').html('<i class="fa-solid fa-rotate-left"></i>').on('click', () => post('saveStock', { id: s.id, Reset: true })).appendTo(actions);
            }
            body.append(row);
        });
        const pager = $('#stocks-pager').empty();
        $('<span>').text(`${filtered.length} veículos — Página ${stockPage + 1} de ${Math.max(1, Math.ceil(filtered.length / pageSize))}`).appendTo(pager);
        $('<button type="button" class="btn-secondary">').html('<i class="fa-solid fa-chevron-left"></i> Anterior').prop('disabled', stockPage === 0).on('click', () => { stockPage--; renderStocks(); }).appendTo(pager);
        $('<button type="button" class="btn-secondary">').html('Próxima <i class="fa-solid fa-chevron-right"></i>').prop('disabled', (stockPage + 1) * pageSize >= filtered.length).on('click', () => { stockPage++; renderStocks(); }).appendTo(pager);
    }
    $('#stock-search').on('input', () => { stockPage = 0; renderStocks(); });

    // Cores de blip do GTA (ID → nome / cor aproximada)
    const blipColors = [
        [0, 'Branco', '#fefefe'], [1, 'Vermelho', '#e03232'], [2, 'Verde', '#71cb71'], [3, 'Azul', '#5db6e5'],
        [4, 'Branco 2', '#f0f0f0'], [5, 'Amarelo', '#eec64e'], [6, 'Vermelho claro', '#c25050'], [7, 'Roxo', '#9c6eaf'],
        [8, 'Rosa', '#fe7ac3'], [9, 'Laranja claro', '#f59d79'], [10, 'Marrom claro', '#b18f83'], [11, 'Verde água', '#8dcea7'],
        [12, 'Azul piscina', '#70a8ae'], [13, 'Lilás', '#d3d1e7'], [15, 'Azul ciano', '#2dd5e5'], [17, 'Laranja', '#ea8e50'],
        [18, 'Azul claro', '#8bacdb'], [19, 'Rosa escuro', '#d3627c'], [21, 'Marrom', '#a06c3d'], [25, 'Verde escuro', '#3b8f3e'],
        [26, 'Azul escuro', '#486cbc'], [27, 'Roxo escuro', '#a65fbd'], [29, 'Azul marinho', '#3a64bf'], [38, 'Azul royal', '#2c6ebb'],
        [40, 'Cinza escuro', '#4b4b4b'], [43, 'Verde limão', '#9ae44a'], [46, 'Dourado', '#ecf029'], [47, 'Laranja escuro', '#f9a52a'],
        [48, 'Rosa choque', '#f43ea8'], [49, 'Vermelho escuro', '#e04d4d'], [52, 'Verde musgo', '#418f5f'], [57, 'Azul petróleo', '#3bb6c5'],
        [59, 'Vermelho vinho', '#a61e1e'], [62, 'Cinza', '#7e7e7e'], [69, 'Verde neon', '#69e463'], [81, 'Laranja neon', '#f3901f'],
        [83, 'Roxo neon', '#a14ee5'], [85, 'Preto', '#252525']
    ];
    blipColors.forEach(([id, name, hex]) => $('#blip-color').append($('<option>').val(id).text(`${id} — ${name}`).css('color', hex)));
    const blipColorName = id => (blipColors.find(c => c[0] === id) || [id, `Cor ${id}`])[1];
    const blipColorHex = id => (blipColors.find(c => c[0] === id) || [0, '', '#ffffff'])[2];

    let blips = [];
    function newBlip() {
        $('#blip-form')[0].reset();
        $('#blip-id').val('');
        $('#blip-color').val(0);
        $('#save-blip').html('<i class="fa-solid fa-floppy-disk"></i> Salvar Marcação');
    }
    function editBlip(b) {
        $('.nav-item').removeClass('active');
        $('[data-page="create-blip"]').addClass('active');
        $('.page-content').hide();
        $('#create-blip').fadeIn(200);
        $('#page-title').text(`Editar Marcação: ${b.Name}`);
        $('#blip-id').val(b.id);
        $('#blip-name').val(b.Name);
        $('#blip-sprite').val(b.Sprite);
        if (!$('#blip-color option').filter((_, o) => Number(o.value) === b.Color).length) $('#blip-color').append($('<option>').val(b.Color).text(`${b.Color} — Cor ${b.Color}`));
        $('#blip-color').val(b.Color);
        $('#blip-scale').val(b.Scale);
        $('#blip-shortrange').val(b.ShortRange ? '1' : '0');
        for (const key of ['X', 'Y', 'Z']) $(`#blip-${key}`).val(b[key]);
        $('#save-blip').html('<i class="fa-solid fa-floppy-disk"></i> Atualizar Marcação');
    }
    function renderBlips() {
        const body = $('#blips-body').empty();
        blips.forEach(b => {
            const row = $('<tr>');
            $('<td>').text(b.Name).appendTo(row);
            $('<td>').text(b.Sprite).appendTo(row);
            $('<td>').append($('<span>').css({ display: 'inline-block', width: '10px', height: '10px', borderRadius: '50%', background: blipColorHex(b.Color), marginRight: '6px' })).append(document.createTextNode(blipColorName(b.Color))).appendTo(row);
            $('<td>').text(b.Scale).appendTo(row);
            $('<td>').text([b.X, b.Y, b.Z].map(v => Number(v).toFixed(2)).join(', ')).appendTo(row);
            const actions = $('<td class="action-btns">').appendTo(row);
            $('<button type="button" class="btn-icon" title="Teleportar">').html('<i class="fa-solid fa-location-dot"></i>').on('click', () => post('teleport', { x: b.X, y: b.Y, z: b.Z })).appendTo(actions);
            $('<button type="button" class="btn-icon" title="Editar">').html('<i class="fa-solid fa-pen"></i>').on('click', () => editBlip(b)).appendTo(actions);
            // Dois cliques para excluir (confirm() não funciona no NUI)
            const remove = $('<button type="button" class="btn-icon" title="Excluir">').html('<i class="fa-solid fa-trash"></i>').on('click', () => {
                if (remove.data('armed')) return post('deleteBlip', { id: b.id });
                remove.data('armed', true).attr('title', 'Clique de novo para excluir').css('color', '#e74c3c');
                setTimeout(() => remove.data('armed', false).attr('title', 'Excluir').css('color', ''), 3000);
            }).appendTo(actions);
            body.append(row);
        });
        if (!blips.length) body.append($('<tr>').append($('<td colspan="6">').css('color', 'var(--text-muted)').text('Nenhuma marcação criada.')));
    }
    $('#blip-here').on('click', () => post('houseHere').done(result => {
        if (typeof result === 'string') result = JSON.parse(result);
        for (const key of ['X', 'Y', 'Z']) $(`#blip-${key}`).val(result[key].toFixed(2));
    }));
    $('#blip-form').on('submit', function (event) {
        event.preventDefault();
        const data = {
            id: $('#blip-id').val() || null,
            Name: $('#blip-name').val().trim(),
            Sprite: Number($('#blip-sprite').val()),
            Color: Number($('#blip-color').val()),
            Scale: Number($('#blip-scale').val()),
            ShortRange: $('#blip-shortrange').val() === '1'
        };
        for (const key of ['X', 'Y', 'Z']) data[key] = Number($(`#blip-${key}`).val());
        post('saveBlip', data);
        if (!data.id) newBlip();
    });

    window.addEventListener('message', event => {
        const message = event.data;
        if (message.action === 'updateRobberies') renderRobberies(message.data);
        if (message.action === 'updateStocks') { stocks = message.data; renderStocks(); }
        if (message.action === 'updateBlips') { blips = message.data; renderBlips(); }
        if (message.action === 'updateHouses') {
            houses = message.data.houses;
            if (message.data.selected && $('#create-house').is(':visible')) editHouse(message.data.selected);
            interiors = message.data.interiors;
            const selected = $('#house-interior').val();
            $('#house-interior').empty();
            Object.keys(interiors).sort().forEach(name => $('#house-interior').append($('<option>').val(name).text(name)));
            if (selected && interiors[selected]) $('#house-interior').val(selected);
            if (!$('#house-price').val()) $('#house-interior').trigger('change');
            renderHouses();
        }
    });
    $('#house-search').on('input', () => { housePage = 0; renderHouses(); });
    $('#house-interior').on('change', function () { $('#house-price').val(interiors[$(this).val()] || ''); });
    $('#house-here').on('click', () => post('houseHere').done(result => {
        if (typeof result === 'string') result = JSON.parse(result);
        for (const key of ['X', 'Y', 'Z']) $(`#house-${key}`).val(result[key].toFixed(2));
    }));
    $('#house-form').on('submit', function (event) {
        event.preventDefault();
        const data = { id: $('#house-id').val(), Interior: $('#house-interior').val(), Price: Number($('#house-price').val()) };
        for (const key of ['X', 'Y', 'Z']) data[key] = Number($(`#house-${key}`).val());
        post('saveHouse', data);
    });
});
