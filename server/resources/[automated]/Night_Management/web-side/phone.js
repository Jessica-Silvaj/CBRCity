// Aplicativos do celular: grupos com acesso a cada app e empresas do app Serviços
$(function () {
    const resource = window.GetParentResourceName ? window.GetParentResourceName() : 'Night_Management';
    const post = (name, data = {}) => $.post(`https://${resource}/${name}`, JSON.stringify(data));
    let phone = { Apps: {}, Defaults: {}, Companies: [], Groups: [] };
    let apps = [];

    // O config.lua aceita lista de grupos ou { grupo = cargo mínimo }
    const groupList = value => Array.isArray(value) ? value : Object.keys(value || {});

    function appGroups(id) {
        if (Object.prototype.hasOwnProperty.call(phone.Apps, id)) return { list: groupList(phone.Apps[id]), custom: true };
        return { list: groupList(phone.Defaults[id]), custom: false };
    }

    function renderApps() {
        const body = $('#phone-apps-body').empty();
        const search = ($('#phone-app-search').val() || '').toLowerCase();
        const filtered = apps.filter(a => !search || a.name.toLowerCase().includes(search) || a.id.toLowerCase().includes(search));
        if (!filtered.length) {
            body.append('<tr><td colspan="3" style="text-align: center; color: var(--text-muted);">Nenhum app encontrado. O lb-phone precisa estar iniciado.</td></tr>');
            return;
        }
        filtered.forEach(app => {
            const { list, custom } = appGroups(app.id);
            const row = $('<tr>');
            $('<td>').append($('<b>').text(app.name), $('<div style="font-size: 0.8em; color: var(--text-muted);">').text(app.id + (app.custom ? ' (personalizado)' : ''))).appendTo(row);

            const cell = $('<td>').appendTo(row);
            if (!list.length) $('<span style="color: var(--text-muted);">').text('Todos').appendTo(cell);
            list.forEach(group => {
                $('<span class="phone-chip">').text(group).append(
                    $('<i class="fa-solid fa-xmark" title="Remover">').on('click', () => post('savePhoneApp', { App: app.id, Groups: list.filter(g => g !== group) }))
                ).appendTo(cell);
            });

            const actions = $('<td>').appendTo(row);
            const wrap = $('<div class="form-group phone-app-actions">').appendTo(actions);
            const select = $('<select>').append($('<option value="">').text('Adicionar grupo...'));
            phone.Groups.filter(g => !list.includes(g)).forEach(g => select.append($('<option>').val(g).text(g)));
            select.on('change', function () {
                if (this.value) post('savePhoneApp', { App: app.id, Groups: list.concat(this.value) });
            }).appendTo(wrap);
            if (custom) {
                $('<button class="btn-icon" type="button" title="Voltar ao padrão do config">').html('<i class="fa-solid fa-rotate-left"></i>').on('click', () => post('savePhoneApp', { App: app.id, Groups: [], Reset: true })).appendTo(wrap);
            }
            body.append(row);
        });
    }

    function resetCompany() {
        $('#phone-company-form')[0].reset();
        $('#phone-company-index').val('');
        $('#phone-company-save').html('<i class="fa-solid fa-plus"></i> Adicionar Empresa');
        $('#phone-company-cancel').hide();
    }

    function editCompany(company, index) {
        const location = company.location || {};
        const coords = location.coords || {};
        $('#phone-company-index').val(index + 1);
        $('#phone-company-job').val(company.job);
        $('#phone-company-name').val(company.name);
        $('#phone-company-icon').val(company.icon || '');
        $('#phone-company-ranks').val((company.bossRanks || []).join(', '));
        $('#phone-company-location').val(location.name || '');
        $('#phone-company-x').val(coords.x ?? '');
        $('#phone-company-y').val(coords.y ?? '');
        $('#phone-company-message').prop('checked', company.canMessage === true);
        $('#phone-company-call').prop('checked', company.canCall === true);
        $('#phone-company-save').html('<i class="fa-solid fa-floppy-disk"></i> Salvar Empresa');
        $('#phone-company-cancel').show();
    }

    function renderCompanies() {
        const selected = $('#phone-company-job').val();
        $('#phone-company-job').empty();
        phone.Groups.forEach(g => $('#phone-company-job').append($('<option>').val(g).text(g)));
        if (selected) $('#phone-company-job').val(selected);

        const body = $('#phone-companies-body').empty();
        if (!phone.Companies.length) {
            body.append('<tr><td colspan="4" style="text-align: center; color: var(--text-muted);">Nenhuma empresa cadastrada.</td></tr>');
            return;
        }
        phone.Companies.forEach((company, index) => {
            const row = $('<tr>');
            const name = $('<td>').appendTo(row);
            if (company.icon) $('<img style="width: 24px; height: 24px; border-radius: 6px; vertical-align: middle; margin-right: 8px;">').attr('src', company.icon).appendTo(name);
            $('<span>').text(company.name).appendTo(name);
            $('<td>').text(company.job).appendTo(row);
            $('<td>').text([company.canMessage ? 'Mensagens' : null, company.canCall ? 'Ligações' : null].filter(Boolean).join(' e ') || 'Nenhum').appendTo(row);
            const actions = $('<td>').appendTo(row);
            $('<button class="btn-icon" type="button" title="Editar">').html('<i class="fa-solid fa-pen"></i>').on('click', () => editCompany(company, index)).appendTo(actions);
            $('<button class="btn-icon delete" type="button" title="Remover">').html('<i class="fa-solid fa-trash"></i>').on('click', () => {
                post('deletePhoneCompany', { index: index + 1 });
                resetCompany();
            }).appendTo(actions);
            body.append(row);
        });
    }

    $('.nav-item').on('click', function () {
        const page = $(this).data('page');
        if (page === 'manage-phone-apps') {
            post('phoneApps').done(result => {
                apps = typeof result === 'string' ? JSON.parse(result) : (result || []);
                renderApps();
            });
            post('requestPhone');
        }
        if (page === 'manage-phone-companies') {
            resetCompany();
            post('requestPhone');
        }
    });

    $('#phone-app-search').on('input', renderApps);
    $('#phone-company-cancel').on('click', resetCompany);
    $('#phone-company-here').on('click', () => post('phonePosition').done(result => {
        if (typeof result === 'string') result = JSON.parse(result);
        $('#phone-company-x').val(result.X.toFixed(2));
        $('#phone-company-y').val(result.Y.toFixed(2));
    }));

    $('#phone-company-form').on('submit', function (event) {
        event.preventDefault();
        const index = $('#phone-company-index').val();
        post('savePhoneCompany', {
            index: index ? Number(index) : null,
            job: $('#phone-company-job').val(),
            name: $('#phone-company-name').val(),
            icon: $('#phone-company-icon').val(),
            bossRanks: $('#phone-company-ranks').val(),
            locationName: $('#phone-company-location').val(),
            x: Number($('#phone-company-x').val()),
            y: Number($('#phone-company-y').val()),
            canMessage: $('#phone-company-message').is(':checked'),
            canCall: $('#phone-company-call').is(':checked')
        });
        resetCompany();
    });

    window.addEventListener('message', event => {
        if (!event.data || event.data.action !== 'updatePhone') return;
        phone = Object.assign({ Apps: {}, Defaults: {}, Companies: [], Groups: [] }, event.data.data);
        if (Array.isArray(phone.Apps)) phone.Apps = {};
        renderApps();
        renderCompanies();
    });
});
