var quantidade = 0
var categoria = ""
var filtar_por = "id"
var cargo = "Membro"

$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showMenu":
				var item = event.data
                lista()
				$("body").fadeIn(500);
			break;
		}
	});
	document.addEventListener("keydown",function(event) {
		if (event.key == "Escape"){
			$("body").fadeOut();	
			$.post("http://Night_Initial/close");
		}
	})
});

function lista(){
    $.post("http://Night_Initial/GetVehicles",JSON.stringify({}),(data) => {
		let GetVehicles = data.GetVehicles.sort((a,b) => (b.item > a.item) ? 1: -1);
		$('.overflow-carros').empty()
		GetVehicles.forEach((key,value) => {
        if(key.data){

            $('.overflow-carros').prepend(`

                <div class="item">
					<div class="imagem">
						<div class="data">${key.data} DIAS</div>
						<img src="assets/${key.carro}.png" alt="">
						<div class="nome">${key.nome}</div>
					</div>
					<div class="botao-resgatar" onclick="Resgatar(this)" data-carro="${key.carro}">RESGATAR</div>
				</div>
	
			`)

        } else {

			$('.overflow-carros').prepend(`

                <div class="item">
					<div class="imagem">
						<img src="assets/${key.carro}.png" alt="">
						<div class="nome">${key.nome}</div>
					</div>
					<div class="botao-resgatar" onclick="Resgatar(this)" data-carro="${key.carro}">RESGATAR</div>
				</div>
	
			`)

        }
		});
    });
}

function Resgatar(data) {
	$("body").fadeOut();	
	$.post("http://Night_Initial/close");
	$.post("https://Night_Initial/resgatar", JSON.stringify({
		carro: data.dataset.carro,
	  }), (data) => {  
	
	});
}

