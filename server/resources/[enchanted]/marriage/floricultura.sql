-- Floricultura (barraca na Praça Legion): flores, mimos e pelúcias para presentear.
-- Usar o item segura o presente na mão; enviar pelo inventário entrega ao jogador mais próximo.
-- Coordenadas da barraca: centro da Praça Legion. Ajuste no painel se quiser mudar o ponto.

INSERT INTO `shop_configs` (`Mode`,`Action`,`Type`,`Item`,`Permission`,`List`) VALUES
('Floricultura','Buy','Cash',NULL,NULL,'{"rose":150,"flowerbouquet":500,"strawberrybouquet":800,"teddybear":600,"heartballoon":300,"rainbowballoon":300,"giftbox":250,"giftbox2":250,"lovecake":700,"heartgift":400,"chocolate":25,"hellokitty":400,"kuromi":400,"mymelody":400,"cinnamoroll":400,"pompompurin":400,"pochacco":400,"badtzmaru":400}')
ON DUPLICATE KEY UPDATE `List` = VALUES(`List`);

INSERT INTO `shops` (`Name`,`Mode`,`Type`,`X`,`Y`,`Z`,`Circle`,`Route`) VALUES
('Floricultura','Floricultura','Buy',195.17,-933.77,30.69,NULL,NULL);

INSERT INTO `blips` (`Name`,`X`,`Y`,`Z`,`Sprite`,`Color`,`Scale`) VALUES
('Floricultura',195.17,-933.77,30.69,52,8,0.7);

INSERT INTO `npcs` (`Name`,`Model`,`X`,`Y`,`Z`,`H`,`Distance`,`Collision`,`AnimDict`,`AnimName`,`Route`) VALUES
('Floricultura','a_f_y_hipster_01',195.17,-933.77,30.69,160.0,50,1,NULL,NULL,NULL);
