var radioState = {
    conectado: false,
    radios: [],
    volumeAtual: 60,
    hudAtiva: false,
    radioAtual: null
};

var volumeTimeout;

$(document).ready(function () {
    window.addEventListener("message", function (event) {

        switch (event.data.action) {
            case "openRadio":
                var item = event.data
                $('.overlay2').show(0);

                $('#frequenciaInput').focus();
                $('.radio-container').fadeIn(400);
                break;

            case "closeRadio":
                var item = event.data
                $('.overlay2').hide(0);
                $('.overlay').hide(0);
                $('.popup-radio-anim').hide(0);
                $('.popup-players').hide(0);

                $('.radio-container').fadeOut(400);
                break;

            case "adicionarRadio":
                var item = event.data
                adicionarRadioNaLista(item.radio);
                $('.radio-item').removeClass('selected');
                $(`.radio-item[data-radio-id="${item.radio.id}"]`).addClass('selected');
                break;

            case "removerRadio":
                var item = event.data
                removerRadioDaLista(item.radioId);
                break;


            case "falando":
                var item = event.data
                atualizarUsuarioConectado(item.nome, item.id, item.status);
                break;

            case "toggleMicrofone":
                var item = event.data
                atualizarEstadoMicrofone(item.radioId, item.mic);
                break;

            case "toggleHudRadio":
                var item = event.data
                atualizarEstadoHud(item.hudAtiva);
                break;

            case "atualizarVolume":
                var item = event.data
                atualizarVolumeDisplay(item.volume);
                break;

            case "limparRadios":
                var item = event.data
                limparListaRadios();
                break;

            case "limparConectados":
                $('.conectados').empty();
                break;

            case "navegarRadio":
                var item = event.data
                navegarParaRadio(item.radioId, item.indice);
                break;

            case "atualizarUsuarioConectado":
                var item = event.data
                atualizarUsuarioConectado(item.nome, item.id, item.status);
                break;

        }
    });

    document.addEventListener("keydown", function (event) {
        if (event.keyCode == 27) {
            $.post("http://radio/close");
        } else if (event.keyCode == 13) {
            conectarFrequencia();
        }
    })

    $('#volumeSlider').on('input', function () {
        var volume = $(this).val();
        $('#volumePercentage').text(volume + '%');

        clearTimeout(volumeTimeout);

        volumeTimeout = setTimeout(function () {
            atualizarVolume(volume);
        }, 500);
    });

    $('#volumeSlider').on('change', function () {
        var volume = $(this).val();
        clearTimeout(volumeTimeout);
        atualizarVolume(volume);
    });
});

function closeRadio() {
    $.post("http://radio/close");
}

function conectarFrequencia() {
    var frequencia = $('#frequenciaInput').val().trim();

    if (!frequencia || frequencia === '') {
        return;
    }

    var frequenciaNum = parseFloat(frequencia);

    if (isNaN(frequenciaNum) || frequenciaNum < 1 || frequenciaNum > 1000) {
        return;
    }

    // Verificar se já está conectado nesta frequência
    var jaConectado = false;
    radioState.radios.forEach(function (radio) {
        if (radio.frequencia === frequenciaNum) {
            jaConectado = true;
        }
    });

    if (jaConectado) {
        return;
    }

    $.post("http://radio/conectarFrequencia", JSON.stringify({
        frequencia: frequenciaNum
    }));



    $('#frequenciaInput').val('');
}

function GetPlayers() {
    $.post("http://radio/GetPlayers", JSON.stringify({}), (data) => {
        let players = data.players;
        $('.overflow-players').empty();
        players.forEach((key, value) => {

            $('.overflow-players').prepend(`

 				<div class="item-player">
                    <img src="assets/imagem-invalida-user.png" alt="" onerror="this.src='assets/imagem-invalida-user.png'">
                    <div class="nome-player">${key.nome}</div>
                </div>

            `)
        });
    });
}

function adicionarRadioNaLista(radio) {
    var radioItem = $(`
		<div class="radio-item" data-radio-id="${radio.id}">
			<div class="radio-info">
				<div class="radio-nome-tipo">
					<span>${radio.nome}</span>
					<span class="radio-tipo ${radio.tipo}">${radio.tipo === 'publica' ? 'Pública' : 'Privada'}</span>
				</div>
			</div>
			<div class="radio-controls">
				<button class="control-btn volume-btn" onclick="mostrarControlesVolume(${radio.id})" title="Volume">
					<i class="fas fa-volume-up"></i>
				</button>
				<button class="control-btn danger remove-btn" onclick="desconectarFrequencia(${radio.id})" title="Desconectar">
					<i class="fas fa-times"></i>
				</button>
			</div>
		</div>
	`);

    $('#radiosList').append(radioItem);
    radioState.radios.push(radio);
    radioState.conectado = true;
    radioState.radioAtual = radio;

    atualizarBotoesSistema();
    mostrarEfeitoPowerButton();
}

function removerRadioDaLista(radioId) {
    $(`.radio-item[data-radio-id="${radioId}"]`).fadeOut(300, function () {
        $(this).remove();
    });

    radioState.radios = radioState.radios.filter(function (radio) {
        return radio.id !== radioId;
    });

    if (radioState.radios.length === 0) {
        radioState.conectado = false;
    }

    atualizarBotoesSistema();
}

function desconectarFrequencia(radioId) {
    $.post("http://radio/desconectarFrequencia", JSON.stringify({
        radioId: radioId
    }));
}

function toggleMicrofone(radioId) {
    $.post("http://radio/toggleMicrofone", JSON.stringify({
        radioId: radioId
    }));
}

function atualizarEstadoMicrofone(radioId, mic) {
    var micBtn = $(`.radio-item[data-radio-id="${radioId}"] .mic-btn`);

    if (mic) {
        micBtn.addClass('active');
    } else {
        micBtn.removeClass('active');
    }
}

function mostrarControlesVolume(radioId) {
    var radio = radioState.radios.find(function (r) {
        return r.id === radioId;
    });

    if (radio) {
        radioState.radioAtual = radio;
        $('#volumeSlider').val(radio.volume);
        $('#volumePercentage').text(radio.volume + '%');
        $('#volumeControls').fadeIn(300);
    }
}

function atualizarVolume(volume) {
    if (radioState.radioAtual) {
        radioState.radioAtual.volume = parseInt(volume);
        $('#volumePercentage').text(volume + '%');

        $.post("http://radio/atualizarVolume", JSON.stringify({
            volume: parseInt(volume),
            radioId: radioState.radioAtual.id
        }));
    }
}

function atualizarVolumeDisplay(volume) {
    radioState.volumeAtual = volume;
    $('#volumeSlider').val(volume);
    $('#volumePercentage').text(volume + '%');
}

function fecharControlesVolume() {
    $('#volumeControls').fadeOut(300);
}

function toggleHudRadio() {
    $.post("http://radio/toggleHudRadio", JSON.stringify({}));
}

function atualizarEstadoHud(hudAtiva) {
    radioState.hudAtiva = hudAtiva;

    var hudBtn = $('#hudRadioBtn');
    var statusDot = $('#hudStatusIndicator .status-dot');
    var statusText = $('#hudStatusIndicator .status-text');

    if (hudAtiva) {
        hudBtn.addClass('active');
        statusDot.addClass('active');
        statusText.addClass('active').text('Ativado');
    } else {
        hudBtn.removeClass('active');
        statusDot.removeClass('active');
        statusText.removeClass('active').text('Desativado');
    }
}

function desligarTodos() {
    $.post("http://radio/desligarTodos", JSON.stringify({}));
}

function limparListaRadios() {
    $('#radiosList').empty();
    radioState.radios = [];
    radioState.conectado = false;
    atualizarBotoesSistema();
}

function atualizarBotoesSistema() {
    var powerBtn = $('#powerBtn');

    if (radioState.conectado) {
        powerBtn.addClass('active');
        setTimeout(function () {
            powerBtn.removeClass('active');
        }, 3000);
    } else {
        powerBtn.removeClass('active');
    }
}




$(document).click(function (e) {
    if (!$(e.target).closest('.volume-controls, .volume-btn').length) {
        $('#volumeControls').fadeOut(300);
    }
});

$('.volume-controls').click(function (e) {
    e.stopPropagation();
});

function navegarParaRadio(radioId, indice) {
    $('.radio-item').removeClass('selected');
    $(`.radio-item[data-radio-id="${radioId}"]`).addClass('selected');

    var radio = radioState.radios.find(function (r) {
        return r.id === radioId;
    });

    if (radio) {
        radioState.radioAtual = radio;
    }

    mostrarEfeitoPowerButton();
}

function mostrarEfeitoPowerButton() {
    var powerBtn = $('#powerBtn');

    powerBtn.addClass('power-connected-effect');

    setTimeout(function () {
        powerBtn.removeClass('power-connected-effect');
    }, 3000);
}

mostrarPopupUsuarios = function () {
    GetPlayers();
    $('.overlay').fadeIn(0);
    $('.popup-players').fadeIn(300);
}

fecharPopupUsuarios = function () {
    $('.popup-players').fadeOut(300);
    $('.overlay').fadeOut(0);
}

mostrarPopupAnimacoes = function () {
    $('.overlay').fadeIn(0);
    $('.popup-radio-anim').fadeIn(300);
}

fecharPopupAnimacoes = function () {
    $('.popup-radio-anim').fadeOut(300);
    $('.overlay').fadeOut(0);
}

selecionarAnimacao = function (id) {
    $('.animacao-item').removeClass('active');
    $(`.animacao-item[data-animacao-id="${id}"]`).addClass('active');

    fecharPopupAnimacoes();

    $.post("http://radio/selecionarAnimacao", JSON.stringify({
        id: id
    }));

}

function atualizarUsuarioConectado(nome, id, status) {
    var conectadosContainer = $('.conectados');
    var itemId = `conectado-${id}`;

    if (status) {
        if ($(`#${itemId}`).length === 0) {
            var itemConectado = $(`
				<div class="item-conectado" id="${itemId}">
					<i class="fa-solid fa-microphone"></i> 
					<span>${nome}</span>
				</div>
			`);
            conectadosContainer.append(itemConectado);
        }
    } else {
        $(`#${itemId}`).fadeOut(0, function () {
            $(this).remove();
        });
    }
}
