-- Joalheria (Vangelico / cfx-fm-jewelry): anéis de namoro, noivado e casamento.
-- A tabela `relationships` é criada sozinha pelo resource marriage ao iniciar.
-- Coordenadas aproximadas do balcão: ajuste no painel se o MLO mudar a posição.

INSERT INTO `shop_configs` (`Mode`,`Action`,`Type`,`Item`,`Permission`,`List`) VALUES
('Joalheria','Buy','Cash',NULL,NULL,'{"datingbox":5000,"engagementbox":15000,"weddingbox":20000,"alliance3":150000}')
ON DUPLICATE KEY UPDATE `List` = VALUES(`List`);

INSERT INTO `shops` (`Name`,`Mode`,`Type`,`X`,`Y`,`Z`,`Circle`,`Route`) VALUES
('Joalheria','Joalheria','Buy',-623.03,-229.24,38.06,NULL,NULL);

INSERT INTO `blips` (`Name`,`X`,`Y`,`Z`,`Sprite`,`Color`,`Scale`) VALUES
('Joalheria',-630.4,-236.7,38.06,796,5,0.7);

INSERT INTO `npcs` (`Name`,`Model`,`X`,`Y`,`Z`,`H`,`Distance`,`Collision`,`AnimDict`,`AnimName`,`Route`) VALUES
('Joalheria','u_f_y_jewelass_01',-623.03,-229.24,38.06,306.0,50,1,NULL,NULL,NULL);
