// Abas Inventário / Veículos da Central Administrativa + catálogos /item e /car por categoria.
// Native router pages and selected-player tabs share catalogs and inline actions.
(function () {
    const Resource = window.GetParentResourceName ? window.GetParentResourceName() : "ticket";
    const ImageUrl = (index) => `nui://vrp/config/inventory/${index}.png`;

    function Post(name, data) {
        return fetch(`https://${Resource}/${name}`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify(data || {})
        }).then((r) => r.json()).catch(() => false);
    }

    function El(tag, attrs, ...children) {
        const node = document.createElement(tag);
        for (const [key, value] of Object.entries(attrs || {})) {
            if (key === "class") node.className = value;
            else if (key.startsWith("on")) node.addEventListener(key.slice(2), value);
            else if (value !== undefined && value !== null && value !== false) node.setAttribute(key, value);
        }
        for (const child of children.flat()) {
            if (child === null || child === undefined || child === false) continue;
            node.append(child instanceof Node ? child : document.createTextNode(String(child)));
        }
        return node;
    }

    function Img(index) {
        const img = El("img", { src: ImageUrl(index), draggable: "false" });
        img.onerror = () => { img.style.visibility = "hidden"; };
        return img;
    }

    // ---------------------------------------------------------------- modais
    const overlays = new Set();

    function Overlay(content, onClose, bound = true) {
        const host = document.querySelector(".adm-catalog")?.parentElement || document.getElementById("adm-inventory") || document.getElementById("adm-vehicles");
        const overlay = El("div", { class: "adm-inline-actions" }, content);
        if (!host || !host.isConnected) { queueMicrotask(() => onClose && onClose()); return { close() {} }; }
        for (const previous of [...overlays]) previous.close();
        overlay.bound = bound;
        overlay.addEventListener("mousedown", (e) => { if (e.target === overlay) Close(); });
        function Close() { overlay.remove(); overlays.delete(overlay); onClose && onClose(); }
        overlay.close = Close;
        overlays.add(overlay);
        host.append(overlay);
        return overlay;
    }

    function CloseAllOverlays() {
        for (const overlay of [...overlays]) overlay.close();
    }

    // Confirmação com botões livres: [{ text, class, value }]
    function Confirm(title, text, buttons, bound = true) {
        return new Promise((resolve) => {
            let overlay;
            const actions = buttons.map((b) =>
                El("button", { class: `adm-btn ${b.class || ""}`, onclick: () => { resolve(b.value); overlay.close(); } }, b.text)
            );
            overlay = Overlay(El("div", { class: "adm-confirm" }, El("h2", null, title), El("p", null, text), El("div", { class: "adm-actions" }, actions)), () => resolve(null), bound);
        });
    }

    // Catálogo por categoria (usado pelo /item e pelo /car)
    function Catalog(title, categories, renderCard, bound = true, host) {
        if (!host || !host.isConnected) return;
        const names = Object.keys(categories).sort((a, b) => a.localeCompare(b, "pt-BR"));
        let current = names[0];
        let query = "";

        const grid = El("div", { class: "adm-grid" });
        const cats = El("div", { class: "adm-cats" });
        const search = El("input", { class: "adm-search", placeholder: "Buscar em todas as categorias..." });
        let overlay;

        function Render() {
            cats.replaceChildren(...names.map((name) =>
                El("button", { class: `adm-cat ${name === current && !query ? "active" : ""}`, onclick: () => { current = name; query = ""; search.value = ""; Render(); } },
                    name, El("span", null, categories[name].length))
            ));

            let list;
            if (query) {
                const q = query.toLowerCase();
                list = names.flatMap((name) => categories[name]).filter((e) =>
                    String(e.Name).toLowerCase().includes(q) || String(e.Item || e.Model).toLowerCase().includes(q));
            } else {
                list = categories[current] || [];
            }

            grid.replaceChildren(...(list.length ? list.map((entry) => renderCard(entry, () => overlay.close())) : [El("div", { class: "adm-empty" }, "Nada encontrado.")]));
        }

        search.addEventListener("input", () => { query = search.value.trim(); Render(); });

        CloseAllOverlays();
        function Back() {
            CloseAllOverlays();
            if (!host.isConnected) return;
            if (host.id === "adm-inventory") RenderInventory(host);
            else if (host.id === "adm-vehicles") RenderVehicles(host);
            else window.dispatchEvent(new CustomEvent("adm:back"));
        }
        overlay = { close: Back };
        host.replaceChildren(El("div", { class: "adm-catalog" },
            El("div", { class: "adm-modal-head" }, El("h2", null, title), search, El("button", { class: "adm-btn", onclick: Back }, "Voltar")),
            El("div", { class: "adm-modal-body" }, cats, grid)
        ));

        Render();
        search.focus();
    }

    // ---------------------------------------------------------------- inventário
    let itemCatalog = null;

    async function RenderInventory(root) {
        const passport = root.dataset.passport;
        root.replaceChildren(El("div", { class: "adm-empty" }, "Carregando inventário..."));

        const data = await Post("AdminInventory", { Passport: passport });
        if (root.dataset.passport !== passport) return;
        if (!data) { root.replaceChildren(El("div", { class: "adm-empty" }, "Sem permissão ou jogador inválido.")); return; }

        const status = data.Online ? El("span", { class: "adm-badge on" }, "online") : El("span", { class: "adm-badge off" }, "offline");
        const head = El("div", { class: "adm-head" },
            El("h3", null, `Inventário de #${passport}`, status)
        );

        const slots = new Map(data.Items.map(item => [Number(item.Slot), item]));
        const details = El("div", { class: "adm-item-details" }, El("p", { class: "adm-empty" }, "Selecione um item para ver os detalhes."));
        const cells = [];
        const formatWeight = value => Number(value || 0).toLocaleString("pt-BR", { maximumFractionDigits: 2 });
        function Select(item, cell) {
            for (const other of cells) other.classList.remove("selected");
            cell.classList.add("selected");
            const quantity = El("input", { class: "adm-qty", type: "number", min: "1", max: item.Amount, value: "1" });
            const feedback = El("p", { class: "adm-sub", role: "status" });
            const remove = El("button", { class: "adm-btn red", disabled: data.Online ? null : "", onclick: async () => {
                const amount = Number(quantity.value);
                if (!Number.isInteger(amount) || amount < 1 || amount > item.Amount) {
                    feedback.textContent = "Informe uma quantidade valida."; return;
                }
                remove.disabled = true;
                const ok = await Post("AdminInventoryRemove", { Passport: passport, Item: item.Item, Amount: amount, Slot: item.Slot });
                if (ok && root.isConnected && root.dataset.passport === passport) RenderInventory(root);
                else { remove.disabled = !data.Online; feedback.textContent = "Nao foi possivel remover o item."; }
            } }, "Remover item");
            details.replaceChildren(Img(item.Index), El("h3", null, item.Name),
                El("p", { class: "adm-sub" }, item.Item),
                El("p", { class: "adm-sub" }, `Slot ${item.Slot} | ${item.Amount}x | ${formatWeight(item.Weight * item.Amount)} kg`),
                El("label", null, "Quantidade", quantity), remove,
                !data.Online ? El("p", { class: "adm-sub" }, "Jogador offline: remocao indisponivel.") : null, feedback);
        }
        const slotCount = Math.max(Number(data.Slots) || 25, ...slots.keys());
        for (let number = 1; number <= slotCount; number++) {
            const item = slots.get(number);
            const cell = El("button", { type: "button", class: `adm-slot ${item ? "occupied" : "empty"}`,
                title: item ? `${item.Name} | ${item.Amount}x | slot ${number}` : `Slot ${number} vazio`,
                "aria-label": item ? `Slot ${number}: ${item.Name}, ${item.Amount} unidades` : `Slot ${number} vazio`,
                "data-rarity": item?.Rarity || "normal", disabled: item ? null : "",
                onclick: () => item && Select(item, cell) },
                El("span", { class: "adm-slot-number" }, number),
                item ? El("span", { class: "adm-slot-amount" }, `${item.Amount}x`) : null,
                item ? Img(item.Index) : null,
                item ? El("span", { class: "adm-slot-name" }, item.Name) : null);
            cells.push(cell);
        }
        const ratio = data.MaxWeight > 0 ? Math.min(100, data.Weight / data.MaxWeight * 100) : 0;
        const weight = El("div", { class: "adm-weight" },
            El("div", { class: "adm-head" }, El("span", null, "Mochila"),
                El("span", null, `${formatWeight(data.Weight)} / ${formatWeight(data.MaxWeight)} kg`)),
            El("div", { class: "adm-weight-track" }, El("div", { style: `width:${ratio}%` })));
        root.replaceChildren(head, weight, El("div", { class: "adm-inventory-layout" },
            El("div", { class: "adm-slot-grid" }, cells), details));

    }

    async function OpenItemCatalog(root) {
        if (!itemCatalog) itemCatalog = await Post("AdminItemCatalog");
        if (!itemCatalog) { root.replaceChildren(El("div", { class: "adm-empty" }, "Nao foi possivel carregar os itens. Verifique sua permissao.")); return; }
        const passport = root.dataset.passport;

        Catalog(`/item — dar item para #${passport}`, itemCatalog, (entry, close) =>
            El("div", { class: "adm-card", onclick: async () => {
                const amount = await AskAmount(entry.Name);
                if (!amount) return;
                if (await Post("AdminItemGive", { Passport: passport, Item: entry.Item, Amount: amount })) {
                    close();

                }
            } }, Img(entry.Index), El("span", { class: "adm-name" }, entry.Name), El("span", { class: "adm-sub" }, entry.Item)), true, root
        );
    }

    function AskAmount(name) {
        return new Promise((resolve) => {
            let overlay;
            const input = El("input", { class: "adm-qty", type: "number", min: "1", value: "1", style: "width:100%" });
            const confirm = () => { const n = Number(input.value); if (!Number.isInteger(n) || n <= 0) { input.setCustomValidity("Informe uma quantidade inteira maior que zero."); input.reportValidity(); return; } resolve(n); overlay.close(); };
            input.addEventListener("keydown", (e) => { if (e.key === "Enter") confirm(); });
            overlay = Overlay(El("div", { class: "adm-confirm" },
                El("h2", null, name), El("p", null, "Quantidade:"), input,
                El("div", { class: "adm-actions" },
                    El("button", { class: "adm-btn", onclick: () => { overlay.close(); resolve(null); } }, "Cancelar"),
                    El("button", { class: "adm-btn main", onclick: confirm }, "Entregar"))
            ), () => resolve(null));
            input.focus();
            input.select();
        });
    }

    // ---------------------------------------------------------------- veículos
    let vehicleCatalog = null;

    async function RenderVehicles(root) {
        const passport = root.dataset.passport;
        root.replaceChildren(El("div", { class: "adm-empty" }, "Carregando veículos..."));

        const list = await Post("AdminVehicles", { Passport: passport });
        if (root.dataset.passport !== passport) return;
        if (!list) { root.replaceChildren(El("div", { class: "adm-empty" }, "Sem permissão ou jogador inválido.")); return; }

        const head = El("div", { class: "adm-head" },
            El("h3", null, `Veículos de #${passport}`, El("span", { class: "adm-badge" }, list.length))
        );

        const rows = list.map((v) => El("div", { class: "adm-row" },
            El("div", { class: "adm-info" },
                El("span", { class: "adm-name" }, v.Name, v.Arrest ? El("span", { class: "adm-badge warn" }, "apreendido") : null),
                El("span", { class: "adm-sub" }, `${v.Vehicle} · placa ${v.Plate} · ${v.Class}`)),
            El("button", { class: "adm-btn", title: "Spawnar uma cópia perto de você (/car)", onclick: () => Spawn(v.Vehicle, v.Name) }, "Spawnar"),
            v.Arrest ? El("button", { class: "adm-btn green", onclick: async () => {
                if (await Post("AdminVehicleRelease", { Passport: passport, Vehicle: v.Vehicle })) RenderVehicles(root);
            } }, "Liberar") : null,
            El("button", { class: "adm-btn red", onclick: async () => {
                const ok = await Confirm("Remover veículo", `Remover ${v.Name} (${v.Plate}) da garagem de #${passport}?`, [
                    { text: "Cancelar", value: false }, { text: "Remover", class: "red", value: true }]);
                if (ok && await Post("AdminVehicleRemove", { Passport: passport, Vehicle: v.Vehicle })) RenderVehicles(root);
            } }, "Remover")
        ));

        root.replaceChildren(head, rows.length ? El("div", { class: "adm-list" }, rows) : El("div", { class: "adm-empty" }, "Nenhum veículo."));
    }

    async function Spawn(model, name) {
        const ok = await Confirm("Spawnar veículo", `Spawnar ${name} (${model}) perto de você?`, [
            { text: "Cancelar", value: false }, { text: "Spawnar", class: "main", value: true }]);
        if (ok) Post("AdminVehicleSpawn", { Model: model });
    }

    async function OpenVehicleCatalog(root) {
        if (!vehicleCatalog) vehicleCatalog = await Post("AdminVehicleCatalog");
        if (!vehicleCatalog) { root.replaceChildren(El("div", { class: "adm-empty" }, "Nao foi possivel carregar os veiculos. Verifique sua permissao.")); return; }
        const passport = root.dataset.passport;

        Catalog(`/car — veículos para #${passport}`, vehicleCatalog, (entry, close) =>
            El("div", { class: "adm-card", onclick: async () => {
                const action = await Confirm(entry.Name, `O que deseja fazer com ${entry.Name} (${entry.Model})?`, [
                    { text: "Cancelar", value: null },
                    { text: "Só spawnar", value: "spawn" },
                    { text: `Adicionar à garagem de #${passport}`, class: "main", value: "give" }]);

                if (action === "spawn") {
                    close();
                    Post("AdminVehicleSpawn", { Model: entry.Model });
                } else if (action === "give") {
                    if (await Post("AdminVehicleGive", { Passport: passport, Model: entry.Model })) {


                        const spawn = await Confirm("Veículo adicionado", `Deseja spawnar o ${entry.Name} agora?`, [
                            { text: "Não", value: false }, { text: "Sim, spawnar", class: "main", value: true }]);
                        if (spawn) Post("AdminVehicleSpawn", { Model: entry.Model });
                        close();
                    }
                }
            } }, El("span", { class: "adm-name" }, entry.Name), El("span", { class: "adm-sub" }, entry.Model)), true, root
        );
    }

    // ---------------------------------------------------------------- /item e /car pelo menu (sem jogador selecionado)
    function AskPassportAndAmount(title, withAmount, defaultPassport) {
        return new Promise((resolve) => {
            let overlay;
            const passport = El("input", { class: "adm-qty", type: "number", min: "1", value: String(defaultPassport || ""), style: "width:100%" });
            const amount = withAmount ? El("input", { class: "adm-qty", type: "number", min: "1", value: "1", style: "width:100%" }) : null;
            const confirm = () => {
                const p = Number(passport.value), a = amount ? Number(amount.value) : 1;
                if (!Number.isInteger(p) || p <= 0) { passport.setCustomValidity("Informe um passaporte valido."); passport.reportValidity(); return; }
                if (!Number.isInteger(a) || a <= 0) { amount.setCustomValidity("Informe uma quantidade inteira maior que zero."); amount.reportValidity(); return; }
                resolve({ passport: p, amount: a });
                overlay.close();
            };
            for (const input of [passport, amount]) if (input) input.addEventListener("keydown", (e) => { if (e.key === "Enter") confirm(); });
            overlay = Overlay(El("div", { class: "adm-confirm" },
                El("h2", null, title),
                El("p", null, "Passaporte:"), passport,
                amount ? El("p", null, "Quantidade:") : null, amount,
                El("div", { class: "adm-actions" },
                    El("button", { class: "adm-btn", onclick: () => { overlay.close(); resolve(null); } }, "Cancelar"),
                    El("button", { class: "adm-btn main", onclick: confirm }, "Entregar"))
            ), () => resolve(null), false);
            passport.focus();
            passport.select();
        });
    }

    async function MenuItem(root) {
        root.replaceChildren(El("div", { class: "adm-empty" }, "Carregando itens..."));
        if (!itemCatalog) itemCatalog = await Post("AdminItemCatalog");
        if (!itemCatalog) { root.replaceChildren(El("div", { class: "adm-empty" }, "Nao foi possivel carregar os itens. Verifique sua permissao.")); return; }
        const self = await Post("AdminSelf");

        Catalog("Dar item", itemCatalog, (entry) =>
            El("div", { class: "adm-card", onclick: async () => {
                const data = await AskPassportAndAmount(entry.Name, true, self);
                if (data) Post("AdminItemGive", { Passport: data.passport, Item: entry.Item, Amount: data.amount });
            } }, Img(entry.Index), El("span", { class: "adm-name" }, entry.Name), El("span", { class: "adm-sub" }, entry.Item)),
        false, root);
    }

    async function MenuCar(root) {
        root.replaceChildren(El("div", { class: "adm-empty" }, "Carregando veiculos..."));
        if (!vehicleCatalog) vehicleCatalog = await Post("AdminVehicleCatalog");
        if (!vehicleCatalog) { root.replaceChildren(El("div", { class: "adm-empty" }, "Nao foi possivel carregar os veiculos. Verifique sua permissao.")); return; }
        const self = await Post("AdminSelf");

        Catalog("Veículos", vehicleCatalog, (entry, close) =>
            El("div", { class: "adm-card", onclick: async () => {
                const action = await Confirm(entry.Name, `O que deseja fazer com ${entry.Name} (${entry.Model})?`, [
                    { text: "Cancelar", value: null },
                    { text: "Só spawnar", value: "spawn" },
                    { text: "Adicionar à garagem de um jogador", class: "main", value: "give" }], false);

                if (action === "spawn") {
                    close();
                    Post("AdminVehicleSpawn", { Model: entry.Model });
                } else if (action === "give") {
                    const data = await AskPassportAndAmount(`${entry.Name} — garagem de qual passaporte?`, false, self);
                    if (data && await Post("AdminVehicleGive", { Passport: data.passport, Model: entry.Model })) {
                        const spawn = await Confirm("Veículo adicionado", `Deseja spawnar o ${entry.Name} agora?`, [
                            { text: "Não", value: false }, { text: "Sim, spawnar", class: "main", value: true }], false);
                        if (spawn) { close(); Post("AdminVehicleSpawn", { Model: entry.Model }); }
                    }
                }
            } }, El("span", { class: "adm-name" }, entry.Name), El("span", { class: "adm-sub" }, entry.Model)),
        false, root);
    }



    // ---------------------------------------------------------------- observa as abas do Vue
    const rendered = new WeakMap();

    function Scan() {
        for (const [id, render] of [["adm-inventory", RenderInventory], ["adm-vehicles", RenderVehicles], ["adm-catalog-items", MenuItem], ["adm-catalog-vehicles", MenuCar]]) {
            const root = document.getElementById(id);
            if (root && (!rendered.has(root) || rendered.get(root) !== root.dataset.passport)) {
                rendered.set(root, root.dataset.passport);
                render(root);
            }
        }

        for (const overlay of [...overlays]) if (!overlay.isConnected) overlay.close();
    }



    new MutationObserver(Scan).observe(document.body, { childList: true, subtree: true, attributes: true, attributeFilter: ["data-passport"] });
})();
