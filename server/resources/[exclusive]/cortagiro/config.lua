Config = {

    flameSize = 2.5, -- O padrão do fogo é 1.5, mais que 2.5 vai ficar bem ruim

    volume = 0.4, -- O padrão que deixamos é 0.9, mas vc pode aumentar ou diminuir como for melhor pro seu servidor
    
    Cars = { -- Aqui você pode adicionar mais carros se quiser, basta colocar o nome de spawn e restartar o script
        "jester", 
        "adder",
        "BCs_VpAr8pl"
    }, 

    explosionSpeed = 300, -- Eu recomendo que no máximo esteja em 350, mais que isso fica estranho, sempre valores positivos. O padrão é 250
    
    RPM = 0.55, -- RPM que irá acionar o script ( valores entre 0.35 e 0.75 ficam bem bons )

    comando = "cortagiro", -- Comando para ligar e desligar o script

    permissao = 'Admin', -- Permissao para usar ( permissão, nao GRUPO)

    sempreLigado = false  -- use true ou false, recomendo sempre false
}