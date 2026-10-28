// Atalhos de Pelúcias e Capinhas na barra inferior do pause, logo depois do botão de Skin de arma.
// O menu do pause é um bundle protegido, então os botões são inseridos no DOM com o mesmo HTML/classes
// dos botões nativos (Skin, HUD, Mapa...). A barra é achada pela estrutura (links #/...), sem medir
// posição, para os botões entrarem no mesmo instante em que a barra aparece.
(() => {
    "use strict";

    const ICON_ATTRS = 'xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" fill="none" class="size-5 min-w-max"';
    const STROKE = 'stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"';

    const items = [
        {
            id: "plushies", label: "Pelúcias", route: "Plushies",
            icon: `<path ${STROKE} d="M6 8a3 3 0 1 1 3-4m6 0a3 3 0 1 1 3 4"/><path ${STROKE} d="M5 12a7 7 0 0 1 14 0v2a7 7 0 0 1-14 0z"/><path ${STROKE} d="M9 12h.01M15 12h.01"/><path ${STROKE} d="m10 15 2 1 2-1m-2 1v2"/>`
        },
        {
            id: "phonecases", label: "Capinhas", route: "PhoneCases",
            icon: `<rect ${STROKE} x="6" y="2" width="12" height="20" rx="3"/><rect ${STROKE} x="8.5" y="4.5" width="3" height="4.5" rx="1"/><path ${STROKE} d="M10 19h4"/>`
        }
    ];

    let pending = false;

    const tip = document.createElement("div");
    tip.className = "cbr-collection-tip";
    document.body.appendChild(tip);

    async function openCollection(item) {
        if (pending) return;
        pending = true;
        document.documentElement.classList.add("cbr-collection-open");
        try {
            const resource = typeof GetParentResourceName === "function" ? GetParentResourceName() : "pause";
            const response = await fetch(`https://${resource}/${item.route}`, {
                method: "POST", headers: { "Content-Type": "application/json; charset=UTF-8" }, body: "{}"
            });
            const result = await response.json().catch(() => null);
            if (result && result.ok === false) document.documentElement.classList.remove("cbr-collection-open");
        } catch (error) {
            document.documentElement.classList.remove("cbr-collection-open");
            console.error("[CBR CITY] Falha ao abrir " + item.label, error);
        } finally {
            pending = false;
        }
    }

    function findBar() {
        const link = document.querySelector('#app a[href="#/Code"], #app a[href="#/Daily"], #app a[href="#/Premium"]');
        return link ? link.parentElement : null;
    }

    function mount() {
        const bar = findBar();
        if (!bar || bar.querySelector("[data-cbr-collection]")) return;

        // botão de Skin de arma = primeiro <button> nativo da barra (depois dos links #/...)
        const skin = Array.from(bar.children).find((el) => el.tagName === "BUTTON" && !el.dataset.cbrCollection);
        let anchor = skin || null;

        for (const item of items) {
            const button = document.createElement("button");
            button.type = "button";
            button.dataset.cbrCollection = item.id;
            button.className = skin ? skin.className : "p-2 transition-colors text-white/50 hover:text-white";
            button.title = item.label;
            button.setAttribute("aria-label", item.label);
            button.innerHTML = `<svg ${ICON_ATTRS}>${item.icon}</svg>`;
            // nome em balão ao passar o mouse, como no botão de Skin; fica no body porque a barra corta o que passa da borda
            button.addEventListener("mouseenter", () => {
                const rect = button.getBoundingClientRect();
                tip.textContent = item.label;
                tip.style.left = `${rect.left + rect.width / 2}px`;
                tip.style.top = `${rect.top - 8}px`;
                tip.classList.add("show");
            });
            button.addEventListener("mouseleave", () => tip.classList.remove("show"));
            button.addEventListener("click", (event) => {
                event.preventDefault();
                event.stopPropagation();
                openCollection(item);
            });
            bar.insertBefore(button, anchor ? anchor.nextSibling : null);
            anchor = button;
        }
    }

    // MutationObserver roda antes da próxima pintura: os botões já aparecem junto com a barra
    new MutationObserver(mount).observe(document.getElementById("app"), { childList: true, subtree: true });

    window.addEventListener("message", (event) => {
        if (event.data && event.data.Action === "Open") {
            document.documentElement.classList.remove("cbr-collection-open");
            mount();
        }
    });

    mount();
})();
