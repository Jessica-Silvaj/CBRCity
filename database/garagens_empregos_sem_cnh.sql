-- Garagens de emprego liberadas sem CNH (Lixeiro, Taxi, Caminhoneiro, Transportador, Rebocador, Correios, Leiteiro...)
UPDATE `garages` SET `CNH` = '' WHERE `Job` IS NOT NULL AND `Job` <> '';
