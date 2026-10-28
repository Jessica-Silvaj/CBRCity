let currentJob = null;
let config = null;

window.addEventListener('message', function(event) {
    if (event.data.type == "open") {
        $('body').css('display', 'flex');
        config = event.data.config;
        
        const jobKeys = Object.keys(config.Jobs);
        if(jobKeys.length > 0) {
            populateSidebar(config);
            selectJob(jobKeys[0]); // Auto-seleciona o primeiro
        }
    }
});

const populateSidebar = (config) => {
    $("#jobList").empty();
    Object.entries(config.Jobs).forEach(([jobKey, job]) => {
        const itemHtml = `
            <div class="job-item group cursor-pointer rounded-lg border border-transparent p-3 transition-all duration-200 hover:bg-white/5" id="job-item-${jobKey}" onclick="selectJob('${jobKey}')">
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-md bg-app-bg border border-app-border flex items-center justify-center text-gray-500 group-hover:text-app-primary transition-colors icon-container">
                            <i class="fa-solid ${job.icon || 'fa-briefcase'} text-lg"></i>
                        </div>
                        <div>
                            <h3 class="font-bold text-gray-300 text-sm group-hover:text-white transition-colors title-text">${job.name}</h3>
                            <p class="text-xs text-gray-500 font-medium mt-0.5">${job.tags[0] || 'Carreira'}</p>
                        </div>
                    </div>
                    <i class="fa-solid fa-chevron-right text-xs text-gray-600 opacity-0 group-hover:opacity-100 transition-opacity"></i>
                </div>
            </div>
        `;
        $("#jobList").append(itemHtml);
    });
}

window.selectJob = (jobKey) => {
    currentJob = jobKey;
    const job = config.Jobs[jobKey];
    
    // Reseta estado ativo de todos
    $(".job-item").removeClass("bg-app-primary/10 border-app-primary/20");
    $(".job-item").addClass("border-transparent");
    $(".job-item .title-text").removeClass("text-app-primary").addClass("text-gray-300");
    $(".job-item .icon-container").removeClass("text-app-primary border-app-primary/30").addClass("text-gray-500 border-app-border");

    // Ativa o selecionado
    $(`#job-item-${jobKey}`).removeClass("border-transparent");
    $(`#job-item-${jobKey}`).addClass("bg-app-primary/10 border-app-primary/30");
    $(`#job-item-${jobKey} .title-text`).addClass("text-app-primary").removeClass("text-gray-300");
    $(`#job-item-${jobKey} .icon-container`).addClass("text-app-primary border-app-primary/50").removeClass("text-gray-500 border-app-border");

    // Prepara as tags (removendo "bg-" do config se existir, ou usando as classes completas do config)
    const tagsHtml = job.tags.map((tag, index) => {
        const colorClass = config.tagColors[index] || 'bg-gray-800 text-gray-300';
        return `<span class="px-2.5 py-1 rounded-md text-[10px] font-extrabold uppercase tracking-wider ${colorClass} shadow-sm">${tag}</span>`;
    }).join('');

    // Prepara Ações
    const actionsHtml = job.paidActions.map((action) => 
        `<li class="flex items-center gap-2 before:content-[''] before:block before:w-1.5 before:h-1.5 before:rounded-sm before:bg-app-primary font-medium">${action}</li>`
    ).join('');

    // Renderiza a direita
    const detailsHtml = `
        <div class="h-80 w-full relative shrink-0 border-b border-app-border bg-app-bg">
            <img src="./img/${job.image}" class="absolute inset-0 h-full w-full object-cover opacity-75" alt="" />
            <div class="absolute inset-0 bg-gradient-to-t from-app-bg via-app-bg/80 to-transparent"></div>
            <div class="absolute bottom-6 left-8 right-8">
                <div class="flex items-end justify-between gap-4">
                    <div>
                        <h2 class="text-4xl font-extrabold text-white tracking-tight drop-shadow-md">${job.name}</h2>
                        <div class="flex gap-2 mt-3">
                            ${tagsHtml}
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="p-8 flex-1 overflow-y-auto pb-28">
            <p class="text-gray-400 text-sm font-medium leading-relaxed mb-8">${job.description}</p>
            
            <div class="grid grid-cols-2 gap-6">
                <!-- Instruções -->
                <div class="flex flex-col">
                    <h3 class="text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-3 flex items-center gap-2">
                        <i class="fa-solid fa-clipboard-list text-gray-400"></i> Instruções
                    </h3>
                    <div class="bg-app-surface border border-app-border rounded-xl p-5 flex-1 shadow-sm">
                        <p class="text-sm text-gray-300 font-medium leading-relaxed">${job.instructions}</p>
                    </div>
                </div>

                <!-- Ações -->
                <div class="flex flex-col">
                    <h3 class="text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-3 flex items-center gap-2">
                        <i class="fa-solid fa-sack-dollar text-app-primary"></i> Ações Pagas
                    </h3>
                    <div class="bg-app-primary/5 border border-app-primary/20 rounded-xl p-5 flex-1 shadow-sm">
                        <ul class="text-sm text-app-primary/90 space-y-2.5">
                            ${actionsHtml}
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Rodapé de Ação -->
        <div class="absolute bottom-0 left-0 right-0 p-6 bg-gradient-to-t from-app-bg via-app-bg to-transparent flex justify-end">
            <button class="w-64 flex items-center justify-center gap-3 bg-app-primary hover:bg-app-primary-hover text-black py-3.5 rounded-xl font-extrabold text-sm tracking-wide uppercase transition-all duration-300 shadow-[0_0_20px_rgba(46,139,87,0.15)] hover:shadow-[0_0_30px_rgba(46,139,87,0.4)] hover:-translate-y-0.5 active:translate-y-0" onclick="startJob('${jobKey}')">
                <i class="fa-solid fa-signature text-lg"></i>
                Assinar Contrato
            </button>
        </div>
    `;

    $("#jobDetails").html(detailsHtml);
}

window.startJob = (jobKey) => {
    $('body').css('display', 'none');
    $.post(`https://${GetParentResourceName()}/startJob`, JSON.stringify({
        rank: config.Jobs[jobKey].rank,
    }));
}

document.onkeyup = function (data) {
    if (data.which == 27) { // ESC
        $('body').css('display', 'none');
        currentJob = null;
        $("#jobList").empty();
        $("#jobDetails").empty();
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    }
};