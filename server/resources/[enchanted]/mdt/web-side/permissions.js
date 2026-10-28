(function () {
    const CATEGORIES = [
        {
            title: "Avisos & Mural",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>`,
            items: [
                { key: "Board", label: "Mural de avisos", desc: "Permite atualizar e publicar avisos gerais" }
            ]
        },
        {
            title: "Membros & Oficiais",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>`,
            items: [
                { key: "Management.View", label: "Gestão de membros", desc: "Permite acessar a aba administrativa de membros" },
                { key: "Management.Create", label: "Adicionar membros", desc: "Permite adicionar novos membros" },
                { key: "Management.Edit", label: "Trocar membro de cargo", desc: "Permite trocar o cargo de um membro" },
                { key: "Management.Dismiss", label: "Demitir membros", desc: "Permite demitir membros" }
            ]
        },
        {
            title: "Patrulhamento",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>`,
            items: [
                { key: "Patrol.View", label: "Ver patrulhas", desc: "Visualizar unidades e patrulhamentos ativos" },
                { key: "Patrol.Create", label: "Iniciar patrulha", desc: "Criar ou iniciar novo patrulhamento" },
                { key: "Patrol.Edit", label: "Editar patrulha", desc: "Alterar dados de patrulhamentos existentes" },
                { key: "Patrol.Delete", label: "Finalizar patrulha", desc: "Encerrar ou remover patrulhamentos" }
            ]
        },
        {
            title: "Operações Policiais",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polygon points="10 8 16 12 10 16 10 8"/></svg>`,
            items: [
                { key: "Operations.View", label: "Ver operações", desc: "Visualizar operações especiais ativas" },
                { key: "Operations.Create", label: "Criar operação", desc: "Abrir nova operação policial no mapa" },
                { key: "Operations.Edit", label: "Editar operação", desc: "Modificar informações de operações" },
                { key: "Operations.Delete", label: "Encerrar operação", desc: "Finalizar ou cancelar operações" }
            ]
        },
        {
            title: "Boletins de Ocorrência",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>`,
            items: [
                { key: "PoliceReports.View", label: "Ver boletins", desc: "Visualizar lista de ocorrências registradas" },
                { key: "PoliceReports.Create", label: "Lavrar boletim", desc: "Registrar novo boletim de ocorrência" },
                { key: "PoliceReports.Edit", label: "Editar boletim", desc: "Alterar relatórios e informações do B.O." },
                { key: "PoliceReports.Archive", label: "Arquivar boletim", desc: "Arquivar ou encerrar boletins de ocorrência" }
            ]
        },
        {
            title: "Corregedoria Interna",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>`,
            items: [
                { key: "InternalAffairs.View", label: "Ver investigações", desc: "Acessar processos disciplinares e denúncias" },
                { key: "InternalAffairs.Create", label: "Abrir investigação", desc: "Instaurar processo na corregedoria" },
                { key: "InternalAffairs.Edit", label: "Editar processo", desc: "Adicionar relatórios e provas ao processo" },
                { key: "InternalAffairs.Archive", label: "Arquivar processo", desc: "Concluir ou arquivar casos disciplinares" }
            ]
        },
        {
            title: "Mandados & Procurados",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="22" y1="12" x2="18" y2="12"/><line x1="6" y1="12" x2="2" y2="12"/><line x1="12" y1="6" x2="12" y2="2"/><line x1="12" y1="22" x2="12" y2="18"/></svg>`,
            items: [
                { key: "Wanted.View", label: "Ver procurados", desc: "Visualizar lista de mandados de prisão ativos" },
                { key: "Wanted.Create", label: "Expedir mandado", desc: "Inserir cidadão na lista de procurados" },
                { key: "Wanted.Edit", label: "Editar mandado", desc: "Atualizar informações e crimes do procurado" },
                { key: "Wanted.Delete", label: "Revogar mandado", desc: "Remover ou revogar mandado de prisão" }
            ]
        },
        {
            title: "Medalhas & Condecorações",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>`,
            items: [
                { key: "Medals.View", label: "Ver medalhas", desc: "Visualizar catálogo de condecorações" },
                { key: "Medals.Create", label: "Criar medalha", desc: "Cadastrar nova honraria ou medalha" },
                { key: "Medals.Assign", label: "Condecorar oficial", desc: "Atribuir honraria a um oficial" },
                { key: "Medals.Edit", label: "Editar medalha", desc: "Alterar nome e descrição da condecoração" },
                { key: "Medals.Delete", label: "Excluir medalha", desc: "Remover condecoração do sistema" }
            ]
        },
        {
            title: "Unidades & Divisões",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>`,
            items: [
                { key: "Units.View", label: "Ver unidades", desc: "Visualizar divisões especiais (ex: CORE, GATE, BOPE)" },
                { key: "Units.Create", label: "Criar unidade", desc: "Fundar nova divisão ou agrupamento" },
                { key: "Units.Assign", label: "Atribuir oficiais", desc: "Adicionar ou transferir policiais para a unidade" },
                { key: "Units.Edit", label: "Editar unidade", desc: "Alterar sigla, nome e insígnias da divisão" },
                { key: "Units.Delete", label: "Excluir unidade", desc: "Encerrar e deletar a unidade especializada" }
            ]
        },
        {
            title: "Banco da Corporação",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg>`,
            items: [
                { key: "Bank.View", label: "Ver saldo", desc: "Acessar saldo e extrato financeiro da polícia" },
                { key: "Bank.Deposit", label: "Depositar verba", desc: "Adicionar fundos aos cofres da corporação" },
                { key: "Bank.Withdraw", label: "Sacar verba", desc: "Retirar fundos da conta da corporação" },
                { key: "Bank.Transfer", label: "Transferir verba", desc: "Transferir dinheiro corporativo para outrem" }
            ]
        },
        {
            title: "Ações Operacionais & Legislação",
            icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>`,
            items: [
                { key: "Arrest", label: "Aplicar prisão", desc: "Registrar e encaminhar indivíduos para a penitenciária" },
                { key: "Fine", label: "Aplicar multas", desc: "Aplicar infrações de trânsito e penalidades pecuniárias" },
                { key: "Warning", label: "Aplicar advertência", desc: "Registrar advertências disciplinares no histórico" },
                { key: "ClearRecord", label: "Limpar ficha", desc: "Excluir histórico de crimes e antecedentes criminais" },
                { key: "SeizedVehicles", label: "Veículos apreendidos", desc: "Gerenciar pátio e apreensão de veículos" },
                { key: "Firearms", label: "Porte de armas", desc: "Gerenciar e emitir autorização de porte de armamento" },
                { key: "Flyingarms", label: "Porte aéreo", desc: "Gerenciar e emitir habilitação de pilotagem policial" },
                { key: "EditPenalCode", label: "Código penal", desc: "Criar, alterar e remover artigos e penas no código" }
            ]
        }
    ];

    let permissionsState = {};
    let hierarchyState = [];
    let currentSelectedRank = null; // null represents "Selecione uma opção" like image 2
    let isOverlayOpen = false;
    let isDropdownOpen = false;

    function postNUI(endpoint, data) {
        return fetch(`https://${GetParentResourceName()}/${endpoint}`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify(data || {})
        }).then(r => r.json()).catch(() => null);
    }

    function getPermissionValue(rankKey, path) {
        if (!permissionsState[rankKey]) return false;
        const parts = path.split(".");
        if (parts.length === 1) {
            return !!permissionsState[rankKey][parts[0]];
        } else if (parts.length === 2) {
            const cat = permissionsState[rankKey][parts[0]];
            return cat && typeof cat === "object" ? !!cat[parts[1]] : false;
        }
        return false;
    }

    function setPermissionValue(rankKey, path, value) {
        if (!permissionsState[rankKey]) permissionsState[rankKey] = {};
        const parts = path.split(".");
        if (parts.length === 1) {
            permissionsState[rankKey][parts[0]] = value;
        } else if (parts.length === 2) {
            if (!permissionsState[rankKey][parts[0]] || typeof permissionsState[rankKey][parts[0]] !== "object") {
                permissionsState[rankKey][parts[0]] = {};
            }
            permissionsState[rankKey][parts[0]][parts[1]] = value;
        }
    }

    function buildCategoriesHTML(rankIndex) {
        let categoriesHTML = "";
        const isRank1 = rankIndex === "1";

        CATEGORIES.forEach(cat => {
            let cardsHTML = "";
            cat.items.forEach(item => {
                const checked = getPermissionValue(rankIndex, item.key) ? "checked" : "";
                cardsHTML += `
                    <div class="mdt-perms-card">
                        <div class="mdt-perms-card-details">
                            <p class="mdt-perms-card-title">${item.label}</p>
                            <p class="mdt-perms-card-desc">${item.desc}</p>
                        </div>
                        <label class="mdt-perms-switch">
                            <input type="checkbox" data-key="${item.key}" ${checked} ${isRank1 ? "disabled" : ""}>
                            <span class="mdt-perms-slider"></span>
                        </label>
                    </div>
                `;
            });

            categoriesHTML += `
                <div class="mdt-perms-category-block">
                    <div class="mdt-perms-category-header">
                        ${cat.icon}
                        <span>${cat.title}</span>
                    </div>
                    <div class="mdt-perms-category-grid">
                        ${cardsHTML}
                    </div>
                </div>
            `;
        });

        return `
            <div class="mdt-perms-content">
                ${categoriesHTML}
                <button id="mdt-perms-save-btn" class="mdt-perms-save-btn">Salvar alterações</button>
            </div>
        `;
    }

    function buildEmptyStateHTML() {
        return `
            <div class="mdt-perms-empty-state">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mdt-perms-empty-icon">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>
                </svg>
                <p class="mdt-perms-empty-text">Selecione um cargo acima para editar as permissões.</p>
            </div>
        `;
    }

    function buildPageHTML() {
        let selectedLabel = "Selecione uma opção";
        let isPlaceholder = true;

        if (currentSelectedRank === "1") {
            currentSelectedRank = null;
        }

        if (currentSelectedRank !== null) {
            const rankNum = parseInt(currentSelectedRank);
            if (hierarchyState[rankNum - 1]) {
                selectedLabel = hierarchyState[rankNum - 1];
                isPlaceholder = false;
            }
        }

        let dropdownItemsHTML = "";
        hierarchyState.forEach((roleName, index) => {
            if (index === 0) return; // O primeiro cargo tem todas as permissões liberadas por padrão e não deve aparecer na lista
            const rankIndex = (index + 1).toString();
            const isSelected = rankIndex === currentSelectedRank;
            dropdownItemsHTML += `
                <div class="mdt-role-dropdown-item ${isSelected ? "selected" : ""}" data-rank="${rankIndex}">
                    <span>${roleName}</span>
                </div>
            `;
        });

        const innerContent = currentSelectedRank === null
            ? buildEmptyStateHTML()
            : buildCategoriesHTML(currentSelectedRank);

        return `
            <div id="mdt-permissions-page">
                <div class="mdt-page-header">
                    <div class="mdt-page-header-title">
                        <svg viewBox="0 0 24 24" width="24" height="24" fill="none" class="w-6 h-6 min-w-6 text-white/50">
                            <path d="M18 10.9971C17.6078 10.1968 16.5481 9.02153 14.3703 9.07154C14.3703 9.07154 12.6431 8.99652 10.6906 8.99652C8.73815 8.99652 7.82408 9.04224 6.25999 9.07154C5.25872 9.04653 3.35629 9.2716 2.48018 11.3472C1.90445 13.0976 1.87941 16.7736 2.22986 18.6241C2.30496 19.5744 2.80559 20.8998 4.35757 21.6C5.30878 22.1001 6.83573 21.9 7.9872 22.0001M5.98465 8.1963C5.93458 5.82065 5.83445 3.94514 8.58796 2.39472C9.51414 2.01962 10.8909 1.69453 12.5931 2.49475C14.3703 3.57004 14.5917 4.70802 14.7458 4.99543C15.1713 6.12074 14.9461 7.72117 14.9961 8.37135" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            <path d="M15.5 19.7351C15.5 20.9792 14.4911 21.9656 13.2552 21.9656C12.0194 21.9656 11 20.9792 11 19.7351C11 18.4911 12.0194 17.4915 13.2552 17.4915C14.4911 17.4915 15.5 18.4911 15.5 19.7351Z" stroke="currentColor" stroke-width="2"/>
                            <path d="M15.2251 17.7909L17.2156 15.8482M22.0001 15.8482L20.3731 14.3089C19.6001 13.5692 18.9501 14.2149 18.6264 14.4906L17.2156 15.8482M17.2156 15.8482L18.8251 17.3936" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                        </svg>
                        <h1>Permissões</h1>
                    </div>
                    <p class="mdt-page-header-desc">Gerencie as permissões dos membros da organização, o que cada um pode ou não fazer.</p>
                </div>

                <div class="mdt-role-select-box">
                    <div id="mdt-role-select-trigger" class="mdt-role-select-trigger ${isDropdownOpen ? "active" : ""}">
                        <div class="mdt-role-select-info">
                            <span class="mdt-role-select-label">Cargo</span>
                            <span class="mdt-role-select-value ${isPlaceholder ? "placeholder" : ""}">${selectedLabel}</span>
                        </div>
                        <svg viewBox="0 0 20 20" fill="currentColor" class="mdt-role-select-icon">
                            <path fill-rule="evenodd" d="M10 3a.75.75 0 0 1 .55.24l3.25 3.5a.75.75 0 1 1-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 0 1-1.1-1.02l3.25-3.5A.75.75 0 0 1 10 3zm-3.75 9.24a.75.75 0 0 1 1.1 1.02L10 16.148l2.7-2.908a.75.75 0 1 1 1.1 1.02l-3.25 3.5a.75.75 0 0 1-1.1 0l-3.25-3.5a.75.75 0 0 1 .05-1.02z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                    <div id="mdt-role-dropdown" class="mdt-role-dropdown ${isDropdownOpen ? "open" : ""}">
                        ${dropdownItemsHTML}
                    </div>
                </div>

                <div id="mdt-perms-content-area">
                    ${innerContent}
                </div>
            </div>
        `;
    }

    function selectRank(rankIndex) {
        currentSelectedRank = rankIndex;
        isDropdownOpen = false;

        const trigger = document.getElementById("mdt-role-select-trigger");
        const valEl = trigger ? trigger.querySelector(".mdt-role-select-value") : null;
        const rankNum = parseInt(rankIndex);
        const roleName = hierarchyState[rankNum - 1] || "Selecione uma opção";
        if (valEl) {
            valEl.innerText = roleName;
            valEl.classList.remove("placeholder");
        }
        if (trigger) trigger.classList.remove("active");

        const dropdown = document.getElementById("mdt-role-dropdown");
        if (dropdown) {
            dropdown.classList.remove("open");
            dropdown.querySelectorAll(".mdt-role-dropdown-item").forEach(item => {
                if (item.getAttribute("data-rank") === rankIndex) {
                    item.classList.add("selected");
                } else {
                    item.classList.remove("selected");
                }
            });
        }

        const contentArea = document.getElementById("mdt-perms-content-area");
        if (!contentArea) return;

        const hasExistingContent = contentArea.querySelector(".mdt-perms-content");
        if (!hasExistingContent) {
            contentArea.innerHTML = buildCategoriesHTML(rankIndex);
        } else {
            const isRank1 = rankIndex === "1";
            const checkboxes = contentArea.querySelectorAll(".mdt-perms-switch input[type='checkbox']");
            checkboxes.forEach(cb => {
                const key = cb.getAttribute("data-key");
                cb.checked = getPermissionValue(rankIndex, key);
                cb.disabled = isRank1;
            });
        }
    }

    function renderPage() {
        const existingPage = document.getElementById("mdt-permissions-page");
        if (existingPage) existingPage.remove();

        const contentArea = document.querySelector(".flex-1.relative.overflow-hidden");
        if (!contentArea) return;

        contentArea.insertAdjacentHTML("beforeend", buildPageHTML());
        attachPageEvents();
    }

    function openPermissionsOverlay() {
        postNUI("Permissions").then(response => {
            if (!response || !response.Hierarchy || !response.Permissions) {
                return;
            }

            hierarchyState = response.Hierarchy;
            permissionsState = response.Permissions;

            renderPage();
            isOverlayOpen = true;
            document.body.classList.add("mdt-perms-open");

            const navBtn = document.getElementById("mdt-perms-nav-btn");
            if (navBtn) {
                navBtn.className = "cursor-pointer rounded p-1.5 !text-white transition-colors";
            }
        });
    }

    function closePermissionsOverlay() {
        const page = document.getElementById("mdt-permissions-page");
        if (page) page.remove();
        isOverlayOpen = false;
        isDropdownOpen = false;
        document.body.classList.remove("mdt-perms-open");

        const navBtn = document.getElementById("mdt-perms-nav-btn");
        if (navBtn) {
            navBtn.className = "cursor-pointer rounded p-1.5 text-white/10 transition-colors hover:text-white/30";
        }
    }

    function attachPageEvents() {
        const page = document.getElementById("mdt-permissions-page");
        if (!page) return;

        const trigger = document.getElementById("mdt-role-select-trigger");
        const dropdown = document.getElementById("mdt-role-dropdown");

        if (trigger && dropdown) {
            trigger.onclick = function (e) {
                e.stopPropagation();
                isDropdownOpen = !isDropdownOpen;
                if (isDropdownOpen) {
                    dropdown.classList.add("open");
                    trigger.classList.add("active");
                } else {
                    dropdown.classList.remove("open");
                    trigger.classList.remove("active");
                }
            };

            dropdown.onclick = function (e) {
                const item = e.target.closest(".mdt-role-dropdown-item");
                if (item) {
                    e.stopPropagation();
                    const rank = item.getAttribute("data-rank");
                    selectRank(rank);
                }
            };
        }

        page.onclick = function (e) {
            if (isDropdownOpen && !e.target.closest(".mdt-role-select-box")) {
                isDropdownOpen = false;
                if (dropdown) dropdown.classList.remove("open");
                if (trigger) trigger.classList.remove("active");
            }
        };

        page.onchange = function (e) {
            if (e.target && e.target.matches(".mdt-perms-switch input[type='checkbox']")) {
                const key = e.target.getAttribute("data-key");
                if (currentSelectedRank) {
                    setPermissionValue(currentSelectedRank, key, e.target.checked);
                }
            }
        };

        page.addEventListener("click", function (e) {
            const saveBtn = e.target.closest("#mdt-perms-save-btn");
            if (saveBtn) {
                saveBtn.disabled = true;
                const originalText = saveBtn.innerText;
                saveBtn.innerText = "Salvando alterações...";

                postNUI("SavePermissions", { Permissions: permissionsState }).then(() => {
                    saveBtn.disabled = false;
                    saveBtn.innerText = originalText;
                }).catch(() => {
                    saveBtn.disabled = false;
                    saveBtn.innerText = originalText;
                });
            }
        });
    }

    // Hook into Bottom Footer Bar
    function checkAndInjectNavButton() {
        const oldBtns = document.querySelectorAll("#mdt-perms-nav-btn, #mdt-perms-nav-wrapper");

        // Find the bottom bar specifically
        const footer = document.querySelector("div[class*='min-h-20']") || document.querySelector(".h-20.min-h-20");
        if (!footer) {
            oldBtns.forEach(el => el.remove());
            return;
        }

        const navContainer = footer.querySelector(".flex.items-center.gap-2");
        if (!navContainer) return;

        // Already properly injected
        if (navContainer.querySelector("#mdt-perms-nav-wrapper")) {
            return;
        }

        oldBtns.forEach(el => el.remove());

        postNUI("Player").then(playerData => {
            if (!playerData || !playerData[1] || playerData[1].Level !== 1) {
                return;
            }

            if (navContainer.querySelector("#mdt-perms-nav-wrapper")) return;

            const wrapper = document.createElement("div");
            wrapper.id = "mdt-perms-nav-wrapper";
            wrapper.className = "flex items-center justify-center";

            const navBtn = document.createElement("button");
            navBtn.id = "mdt-perms-nav-btn";
            navBtn.className = "cursor-pointer rounded p-1.5 text-white/10 transition-colors hover:text-white/30";
            navBtn.innerHTML = `
                <svg class="w-5 h-5 min-w-max" viewBox="0 0 24 24" fill="none">
                    <path d="M18 10.9971C17.6078 10.1968 16.5481 9.02153 14.3703 9.07154C14.3703 9.07154 12.6431 8.99652 10.6906 8.99652C8.73815 8.99652 7.82408 9.04224 6.25999 9.07154C5.25872 9.04653 3.35629 9.2716 2.48018 11.3472C1.90445 13.0976 1.87941 16.7736 2.22986 18.6241C2.30496 19.5744 2.80559 20.8998 4.35757 21.6C5.30878 22.1001 6.83573 21.9 7.9872 22.0001M5.98465 8.1963C5.93458 5.82065 5.83445 3.94514 8.58796 2.39472C9.51414 2.01962 10.8909 1.69453 12.5931 2.49475C14.3703 3.57004 14.5917 4.70802 14.7458 4.99543C15.1713 6.12074 14.9461 7.72117 14.9961 8.37135" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                    <path d="M15.5 19.7351C15.5 20.9792 14.4911 21.9656 13.2552 21.9656C12.0194 21.9656 11 20.9792 11 19.7351C11 18.4911 12.0194 17.4915 13.2552 17.4915C14.4911 17.4915 15.5 18.4911 15.5 19.7351Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M15.2251 17.7909L17.2156 15.8482M22.0001 15.8482L20.3731 14.3089C19.6001 13.5692 18.9501 14.2149 18.6264 14.4906L17.2156 15.8482M17.2156 15.8482L18.8251 17.3936" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
            `;

            const tooltip = document.createElement("div");
            tooltip.className = "mdt-perms-nav-tooltip";
            tooltip.innerText = "Permissões";

            navBtn.addEventListener("click", function (e) {
                e.stopPropagation();
                if (isOverlayOpen) {
                    closePermissionsOverlay();
                } else {
                    openPermissionsOverlay();
                }
            });

            wrapper.appendChild(navBtn);
            wrapper.appendChild(tooltip);

            // Insert before the last button (the exit button)
            const exitBtn = navContainer.lastElementChild;
            if (exitBtn) {
                navContainer.insertBefore(wrapper, exitBtn);
            } else {
                navContainer.appendChild(wrapper);
            }

            // Clicking any other button in the bottom bar closes the permissions page
            navContainer.addEventListener("click", function (e) {
                if (!wrapper.contains(e.target) && isOverlayOpen) {
                    closePermissionsOverlay();
                }
            });
        });
    }

    const observer = new MutationObserver(() => {
        checkAndInjectNavButton();
    });

    observer.observe(document.body, { childList: true, subtree: true });

    window.addEventListener("keydown", function (e) {
        if (e.key === "Escape" && isOverlayOpen) {
            closePermissionsOverlay();
        }
    });

    window.addEventListener("message", function (event) {
        const item = event.data;
        if (item && item.Action === "Close") {
            closePermissionsOverlay();
        }
        if (item && item.Action === "Notify" && item.Payload && !Array.isArray(item.Payload) && typeof item.Payload === "object") {
            window.postMessage({
                Action: "Notify",
                Payload: [item.Payload.Title, item.Payload.Message, item.Payload.Type]
            }, "*");
        }
    });
})();
