-- Remove a Manicure e a Loja de Eletrônicos (DigitalDen) - mapas Unhas e DigitalDen retirados do servidor
DELETE FROM `blips` WHERE `Name` = 'Manicure';
DELETE FROM `blips` WHERE `Name` = 'Loja de Eletronicos' AND ABS(`X` + 1526.57) < 1 AND ABS(`Y` + 404.98) < 1;
DELETE FROM `npcs` WHERE `Name` = 'Eletronics' AND ABS(`X` + 1529.66) < 1 AND ABS(`Y` + 400.48) < 1;
DELETE FROM `shops` WHERE `Mode` = 'Eletronics' AND ABS(`X` + 1529.06) < 1 AND ABS(`Y` + 400.97) < 1;
