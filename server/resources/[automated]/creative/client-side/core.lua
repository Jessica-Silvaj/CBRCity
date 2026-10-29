-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local CONTROLS = { 37,204,211,349,192,157,158,159,160,161,162,163,164,165 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local SpawnedBlips = {}
-- Reduz pela metade a densidade ambiente configurada no painel gestor.
local AmbientDensityMultiplier = 0.5
-- +20% para NPCs andando (estacionados mantidos).
local TrafficPedMultiplier = AmbientDensityMultiplier * 1.2
-- +50% para carros circulando.
local TrafficVehicleMultiplier = AmbientDensityMultiplier * 1.5
local CurrentDensity = {
    VehicleDensity = 0.0,
    RandomVehicleDensity = 0.0,
    ParkedVehicleDensity = 0.0,
    ScenarioPedDensity = 0.0,
    PedDensity = 0.0
}
local ClearAreaList = {}

RegisterNetEvent("creative:updateFromAdmin")
AddEventHandler("creative:updateFromAdmin", function(blips, npcs, density, clearareas)
    if density then
        CurrentDensity = density
    end
    if clearareas then
        ClearAreaList = clearareas
    end
	for _, blip in pairs(SpawnedBlips) do
		if DoesBlipExist(blip) then RemoveBlip(blip) end
	end
	SpawnedBlips = {}

	if blips then
		CreateThread(function()
			local CachedCoords = {}
			for _, blipData in pairs(blips) do
				local blipCoords = string.format("%.2f_%.2f", blipData.X, blipData.Y)
				if not CachedCoords[blipCoords] then
					CachedCoords[blipCoords] = true
					
					local BlipName = tostring(blipData.Name)
					local cleanKey = string.gsub(BlipName, "[^%a%d]", "")
					local GTXKey = "BL_" .. string.sub(cleanKey, 1, 20)
					AddTextEntry(GTXKey, BlipName)

					local blipId = AddBlipForCoord(tonumber(blipData.X)+0.0, tonumber(blipData.Y)+0.0, tonumber(blipData.Z)+0.0)
					SetBlipSprite(blipId, math.floor(tonumber(blipData.Sprite)))
					SetBlipDisplay(blipId, 4)
					SetBlipAsShortRange(blipId, true)
					SetBlipColour(blipId, math.floor(tonumber(blipData.Color)))
					
					SetBlipScale(blipId, tonumber(blipData.Scale) + 0.0)

					BeginTextCommandSetBlipName(GTXKey)
					EndTextCommandSetBlipName(blipId)
					table.insert(SpawnedBlips, blipId)

					-- Cartão com imagem e descrição ao passar o mouse no mapa (client-side/blipcards.lua)
					if ApplyBlipCard then
						pcall(ApplyBlipCard,blipId,BlipName)
					end
				end
			end
		end)
	end
end)

CreateThread(function()
	Wait(2000)
	TriggerServerEvent("creative:requestSync")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local TELEPORT = {
	{ vec3(357.96,-1408.7,32.42),vec3(335.11,-1432.36,46.51) },
	{ vec3(335.11,-1432.36,46.51),vec3(357.96,-1408.7,32.42) },

	{ vec3(-741.07,5593.13,41.66),vec3(446.19,5568.79,781.19) },
	{ vec3(446.19,5568.79,781.19),vec3(-741.07,5593.13,41.66) },

	{ vec3(-740.78,5597.04,41.66),vec3(446.37,5575.02,781.19) },
	{ vec3(446.37,5575.02,781.19),vec3(-740.78,5597.04,41.66) },

	{ vec3(-71.05,-801.01,44.23),vec3(-75.0,-824.54,321.29) },
	{ vec3(-75.0,-824.54,321.29),vec3(-71.05,-801.01,44.23) },

	{ vec3(254.06,225.28,101.87),vec3(252.32,220.21,101.67) },
	{ vec3(252.32,220.21,101.67),vec3(254.06,225.28,101.87) }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALPHAS
-----------------------------------------------------------------------------------------------------------------------------------------
local ALPHAS = {
	{ vec3(-1891.97,-1729.96,0.54),100,53,300.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISLAND
-----------------------------------------------------------------------------------------------------------------------------------------
local ISLAND = {
	"h4_islandairstrip",
	"h4_islandairstrip_props",
	"h4_islandx_mansion",
	"h4_islandx_mansion_props",
	"h4_islandx_props",
	"h4_islandxdock",
	"h4_islandxdock_props",
	"h4_islandxdock_props_2",
	"h4_islandxtower",
	"h4_islandx_maindock",
	"h4_islandx_maindock_props",
	"h4_islandx_maindock_props_2",
	"h4_IslandX_Mansion_Vault",
	"h4_islandairstrip_propsb",
	"h4_beach",
	"h4_beach_props",
	"h4_beach_bar_props",
	"h4_islandx_barrack_props",
	"h4_islandx_checkpoint",
	"h4_islandx_checkpoint_props",
	"h4_islandx_Mansion_Office",
	"h4_islandx_Mansion_LockUp_01",
	"h4_islandx_Mansion_LockUp_02",
	"h4_islandx_Mansion_LockUp_03",
	"h4_islandairstrip_hangar_props",
	"h4_IslandX_Mansion_B",
	"h4_islandairstrip_doorsclosed",
	"h4_Underwater_Gate_Closed",
	"h4_mansion_gate_closed",
	"h4_aa_guns",
	"h4_IslandX_Mansion_GuardFence",
	"h4_IslandX_Mansion_Entrance_Fence",
	"h4_IslandX_Mansion_B_Side_Fence",
	"h4_IslandX_Mansion_Lights",
	"h4_islandxcanal_props",
	"h4_beach_props_party",
	"h4_islandX_Terrain_props_06_a",
	"h4_islandX_Terrain_props_06_b",
	"h4_islandX_Terrain_props_06_c",
	"h4_islandX_Terrain_props_05_a",
	"h4_islandX_Terrain_props_05_b",
	"h4_islandX_Terrain_props_05_c",
	"h4_islandX_Terrain_props_05_d",
	"h4_islandX_Terrain_props_05_e",
	"h4_islandX_Terrain_props_05_f",
	"h4_islandx_terrain_01",
	"h4_islandx_terrain_02",
	"h4_islandx_terrain_03",
	"h4_islandx_terrain_04",
	"h4_islandx_terrain_05",
	"h4_islandx_terrain_06",
	"h4_ne_ipl_00",
	"h4_ne_ipl_01",
	"h4_ne_ipl_02",
	"h4_ne_ipl_03",
	"h4_ne_ipl_04",
	"h4_ne_ipl_05",
	"h4_ne_ipl_06",
	"h4_ne_ipl_07",
	"h4_ne_ipl_08",
	"h4_ne_ipl_09",
	"h4_nw_ipl_00",
	"h4_nw_ipl_01",
	"h4_nw_ipl_02",
	"h4_nw_ipl_03",
	"h4_nw_ipl_04",
	"h4_nw_ipl_05",
	"h4_nw_ipl_06",
	"h4_nw_ipl_07",
	"h4_nw_ipl_08",
	"h4_nw_ipl_09",
	"h4_se_ipl_00",
	"h4_se_ipl_01",
	"h4_se_ipl_02",
	"h4_se_ipl_03",
	"h4_se_ipl_04",
	"h4_se_ipl_05",
	"h4_se_ipl_06",
	"h4_se_ipl_07",
	"h4_se_ipl_08",
	"h4_se_ipl_09",
	"h4_sw_ipl_00",
	"h4_sw_ipl_01",
	"h4_sw_ipl_02",
	"h4_sw_ipl_03",
	"h4_sw_ipl_04",
	"h4_sw_ipl_05",
	"h4_sw_ipl_06",
	"h4_sw_ipl_07",
	"h4_sw_ipl_08",
	"h4_sw_ipl_09",
	"h4_islandx_mansion",
	"h4_islandxtower_veg",
	"h4_islandx_sea_mines",
	"h4_islandx",
	"h4_islandx_barrack_hatch",
	"h4_islandxdock_water_hatch",
	"h4_beach_party",
	"h4_mph4_terrain_01_grass_0",
	"h4_mph4_terrain_01_grass_1",
	"h4_mph4_terrain_02_grass_0",
	"h4_mph4_terrain_02_grass_1",
	"h4_mph4_terrain_02_grass_2",
	"h4_mph4_terrain_02_grass_3",
	"h4_mph4_terrain_04_grass_0",
	"h4_mph4_terrain_04_grass_1",
	"h4_mph4_terrain_04_grass_2",
	"h4_mph4_terrain_04_grass_3",
	"h4_mph4_terrain_05_grass_0",
	"h4_mph4_terrain_06_grass_0",
	"h4_mph4_airstrip_interior_0_airstrip_hanger"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- IPL_LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local IPL_LIST = {
	{
		Props = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		Coords = vec3(-1150.70,-1520.70,10.60)
	},{
		Props = {
			"csr_beforeMission",
			"csr_inMission"
		},
		Coords = vec3(-47.10,-1115.30,26.50)
	},{
		Props = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		Coords = vec3(-802.30,175.00,72.80)
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Blackout",nil,function(Name,Key,Value)
	SetArtificialLightsState(Value)
	SetArtificialLightsStateAffectsVehicles(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	AddTextEntryByHash(0x4B7B2734,"Ace Jones Dr")
	AddTextEntryByHash(0x7EC39AE2,"Algonquin Blvd")
	AddTextEntryByHash(0x92E1C090,"Alhambra Dr")
	AddTextEntryByHash(0xD39FE932,"Armadillo Ave")
	AddTextEntryByHash(0xB76E170F,"Calafia Rd")
	AddTextEntryByHash(0x5AA123E0,"Cassidy Trail")
	AddTextEntryByHash(0x261C80DB,"Cascabel Ave")
	AddTextEntryByHash(0xEA41FBE8,"Cat-Claw Ave")
	AddTextEntryByHash(0xEF17EFC8,"Chianski Passage")
	AddTextEntryByHash(0xF5196793,"Cholla Rd")
	AddTextEntryByHash(0x36A6BE4B,"Cholla Springs Ave")
	AddTextEntryByHash(0x8A00A702,"Duluoz Ave")
	AddTextEntryByHash(0x953094ED,"East Joshua Road")
	AddTextEntryByHash(0xCB000216,"El Gordo Dr")
	AddTextEntryByHash(0xF641831C,"Fort Zancudo Approach Rd")
	AddTextEntryByHash(0x4DCE72D8,"Grapeseed Ave")
	AddTextEntryByHash(0x3132B9A5,"Grapeseed Main St")
	AddTextEntryByHash(0xCD357E0E,"Ineseno Road")
	AddTextEntryByHash(0x8F9D12E7,"Joad Ln")
	AddTextEntryByHash(0x0A5BFF42,"Joshua Rd")
	AddTextEntryByHash(0xDE37DA0C,"Lesbos Ln")
	AddTextEntryByHash(0x5C483E1D,"Lolita Ave")
	AddTextEntryByHash(0x32D92D45,"Marina Dr")
	AddTextEntryByHash(0x594944F9,"Meringue Ln")
	AddTextEntryByHash(0x906B3D92,"Mountain View Dr")
	AddTextEntryByHash(0x63F44C25,"Niland Ave")
	AddTextEntryByHash(0x269FDEE5,"North Calafia Way")
	AddTextEntryByHash(0x245499BF,"Nowhere Rd")
	AddTextEntryByHash(0xF8D909E5,"Paleto Blvd")
	AddTextEntryByHash(0x155FBE2B,"Panorama Dr")
	AddTextEntryByHash(0x9A95814F,"Procopio Dr")
	AddTextEntryByHash(0x8F7BEC48,"Procopio Promenade")
	AddTextEntryByHash(0xED13B4BC,"Pyrite Ave")
	AddTextEntryByHash(0xBF442E1F,"Raton Pass")
	AddTextEntryByHash(0xF5C37F6E,"Route 68")
	AddTextEntryByHash(0x38E0429C,"Seaview Rd")
	AddTextEntryByHash(0x538A9910,"Smoke Tree Rd")
	AddTextEntryByHash(0x98F59B29,"Union Rd")
	AddTextEntryByHash(0x21CFAEFC,"Zancudo Ave")
	AddTextEntryByHash(0x6398B275,"Zancudo Grande Valley")
	AddTextEntryByHash(0x8CD2E019,"Abattoir Ave")
	AddTextEntryByHash(0xDDCBDC74,"Abe Milton Pkwy")
	AddTextEntryByHash(0x40D0731C,"Adam's Apple Blvd")
	AddTextEntryByHash(0x8CCFEA79,"Aguja St")
	AddTextEntryByHash(0x08B9CC73,"Alta St")
	AddTextEntryByHash(0x1EA69437,"Amarillo Vista")
	AddTextEntryByHash(0x29E328A9,"Amarillo Way")
	AddTextEntryByHash(0xBA0E09C7,"Americano Way")
	AddTextEntryByHash(0x80CBFBCF,"South Arsenal St")
	AddTextEntryByHash(0x34627A5F,"Atlee St")
	AddTextEntryByHash(0x96B2B85F,"Autopia Pkwy")
	AddTextEntryByHash(0x78905544,"Bait St")
	AddTextEntryByHash(0x15E466FD,"Banham Canyon Dr")
	AddTextEntryByHash(0x26944B16,"Barbareno Rd")
	AddTextEntryByHash(0x6F927644,"Bay City Ave")
	AddTextEntryByHash(0xEDC3B8F4,"Bay City Incline")
	AddTextEntryByHash(0xF5EFE777,"Baytree Canyon Rd")
	AddTextEntryByHash(0xB7229694,"Boulevard Del Perro")
	AddTextEntryByHash(0x22198C67,"Bridge St")
	AddTextEntryByHash(0x5F27252E,"Brouge Ave")
	AddTextEntryByHash(0xCED31768,"Buccaneer Way")
	AddTextEntryByHash(0x80323559,"Buen Vino Rd")
	AddTextEntryByHash(0x8519F0E9,"Caesars Place")
	AddTextEntryByHash(0x46EC8CF6,"Calais Ave")
	AddTextEntryByHash(0x131DF79C,"Capital Blvd")
	AddTextEntryByHash(0x40468D03,"Carcer Way")
	AddTextEntryByHash(0x56F28308,"Carson Ave")
	AddTextEntryByHash(0x29DDB334,"Chum St")
	AddTextEntryByHash(0x3A82547D,"Chupacabra St")
	AddTextEntryByHash(0xE657DF40,"Clinton Ave")
	AddTextEntryByHash(0x9ACC3D68,"Cockingend Dr")
	AddTextEntryByHash(0x7E8446DD,"Conquistador St")
	AddTextEntryByHash(0x09A04736,"Cortes St")
	AddTextEntryByHash(0x186A32D2,"Cougar Ave")
	AddTextEntryByHash(0xBEA2B02D,"Covenant Ave")
	AddTextEntryByHash(0x7BD54361,"Cox Way")
	AddTextEntryByHash(0xE10C41BE,"Crusade Rd")
	AddTextEntryByHash(0x45B1CA3D,"Davis Ave")
	AddTextEntryByHash(0x072580D7,"Decker St")
	AddTextEntryByHash(0x6D5EEFEC,"Dorset Dr")
	AddTextEntryByHash(0x6705124C,"Dorset Pl")
	AddTextEntryByHash(0x75E5EA92,"Dry Dock St")
	AddTextEntryByHash(0xCABEF9A8,"Dunstable Dr")
	AddTextEntryByHash(0xE0D4A5CB,"Dunstable Ln")
	AddTextEntryByHash(0x6635C142,"Dutch London St")
	AddTextEntryByHash(0xEDEB73E4,"East Galileo Ave")
	AddTextEntryByHash(0x6CC8B86E,"East Mirror Dr")
	AddTextEntryByHash(0x410A49CD,"Eastbourne Way")
	AddTextEntryByHash(0x6418F6FE,"Eclipse Blvd")
	AddTextEntryByHash(0xD0B11243,"Edwood Way")
	AddTextEntryByHash(0xB44C8E74,"El Burro Blvd")
	AddTextEntryByHash(0x7FADF1B2,"El Rancho Blvd")
	AddTextEntryByHash(0x0798837A,"Elgin Ave")
	AddTextEntryByHash(0x2C72B469,"Equality Way")
	AddTextEntryByHash(0x4E853514,"Exceptionalists Way")
	AddTextEntryByHash(0x90963D6A,"Fantastic Pl")
	AddTextEntryByHash(0xF3B2BE94,"Fenwell Pl")
	AddTextEntryByHash(0xE94A6DDC,"Forum Dr")
	AddTextEntryByHash(0xD9B72921,"Fudge Ln")
	AddTextEntryByHash(0x85F5588B,"Galileo Rd")
	AddTextEntryByHash(0xD5A607F8,"Gentry Lane")
	AddTextEntryByHash(0x534D8027,"Ginger St")
	AddTextEntryByHash(0xC431BCEE,"Glory Way")
	AddTextEntryByHash(0x7F84CC28,"Goma St")
	AddTextEntryByHash(0x4C9260C4,"Greenwich Pkwy")
	AddTextEntryByHash(0xD72068C5,"Greenwich Way")
	AddTextEntryByHash(0x00CC5CA0,"Grove St")
	AddTextEntryByHash(0x897BB935,"Hanger Way")
	AddTextEntryByHash(0x5E315A37,"Hardy Way")
	AddTextEntryByHash(0x605D416C,"Hawick Ave")
	AddTextEntryByHash(0xDB0C8D26,"Heritage Way")
	AddTextEntryByHash(0x65BCFFA3,"Hillcrest Ave")
	AddTextEntryByHash(0xA1F822A2,"Hillcrest Ridge Access Rd")
	AddTextEntryByHash(0xC4A300EF,"Imagination Court")
	AddTextEntryByHash(0x434CC15C,"Integrity Way")
	AddTextEntryByHash(0x4B5B59A7,"Innocence Blvd")
	AddTextEntryByHash(0x5FEE2991,"Invention Court")
	AddTextEntryByHash(0x661AA779,"Jamestown St")
	AddTextEntryByHash(0xFB90B746,"Kimble Hill Dr")
	AddTextEntryByHash(0xCC628804,"Kortz Dr")
	AddTextEntryByHash(0x98295423,"Labor Pl")
	AddTextEntryByHash(0x973B8B6,"Laguna Pl")
	AddTextEntryByHash(0x5E4F2EE7,"Lake Vinewood Dr")
	AddTextEntryByHash(0xF0089E63,"Las Lagunas Blvd")
	AddTextEntryByHash(0x2F26BBD7,"Liberty St")
	AddTextEntryByHash(0xFF521E51,"Lindsay Circus")
	AddTextEntryByHash(0x9DB39520,"Little Bighorn Ave")
	AddTextEntryByHash(0x64306156,"Macdonald St")
	AddTextEntryByHash(0xFF357E7B,"Mad Wayne Thunder Dr")
	AddTextEntryByHash(0xCF1A660B,"Magellan Ave")
	AddTextEntryByHash(0xE7073C86,"Marathon Ave")
	AddTextEntryByHash(0x4A3712C2,"Marlowe Dr")
	AddTextEntryByHash(0x7EFD9AFE,"Melanoma St")
	AddTextEntryByHash(0x639007F6,"Meteor St")
	AddTextEntryByHash(0xBDB7B4F7,"Milton Rd")
	AddTextEntryByHash(0x1FA2C931,"Mirror Park Blvd")
	AddTextEntryByHash(0x0CC8AAE6,"Mirror Pl")
	AddTextEntryByHash(0xC122D85F,"Morningwood Blvd")
	AddTextEntryByHash(0xD3CD9C6E,"Mt Haan Dr")
	AddTextEntryByHash(0x946FDCC9,"Mt Haan Rd")
	AddTextEntryByHash(0x5EBC827B,"Mt Vinewood Dr")
	AddTextEntryByHash(0x9117E6AD,"Movie Star Way")
	AddTextEntryByHash(0x5C033D11,"Mutiny Rd")
	AddTextEntryByHash(0x07AB9391,"Nikola Ave")
	AddTextEntryByHash(0x7D92FF5A,"Nikola Pl")
	AddTextEntryByHash(0x995C30AA,"Normandy Dr")
	AddTextEntryByHash(0xDE65DFA8,"North Archer Ave")
	AddTextEntryByHash(0xA2F6CA31,"North Conker Ave")
	AddTextEntryByHash(0xB74C0D46,"North Sheldon Ave")
	AddTextEntryByHash(0x59920DAD,"North Rockford Dr")
	AddTextEntryByHash(0x20101F69,"Occupation Ave")
	AddTextEntryByHash(0xB87FAA60,"Orchardville Ave")
	AddTextEntryByHash(0x520BFB49,"Palomino Ave")
	AddTextEntryByHash(0xA5883BDE,"Peaceful St")
	AddTextEntryByHash(0x909B5591,"Perth St")
	AddTextEntryByHash(0x1919AEB5,"Picture Perfect Drive")
	AddTextEntryByHash(0x7C7282C1,"Plaice Pl")
	AddTextEntryByHash(0x66006A97,"Playa Vista")
	AddTextEntryByHash(0xCCD0D983,"Popular St")
	AddTextEntryByHash(0x7D75C728,"Portola Dr")
	AddTextEntryByHash(0xF959D26E,"Power St")
	AddTextEntryByHash(0x0D5F14E6,"Prosperity St")
	AddTextEntryByHash(0x4C0674B7,"Prosperity Street Promenade")
	AddTextEntryByHash(0x05EFF99A,"Red Desert Ave")
	AddTextEntryByHash(0x284CD97B,"Richman St")
	AddTextEntryByHash(0x159B0DF9,"Rockford Dr")
	AddTextEntryByHash(0xD631D46B,"Roy Lowenstein Blvd")
	AddTextEntryByHash(0x9735407C,"Rub St")
	AddTextEntryByHash(0xB4A79707,"Sam Austin Dr")
	AddTextEntryByHash(0xF2C73716,"San Andreas Ave")
	AddTextEntryByHash(0xDA9DCCFB,"San Vitus Blvd")
	AddTextEntryByHash(0x502503F,"Sandcastle Way")
	AddTextEntryByHash(0x003F6701,"Senora Rd")
	AddTextEntryByHash(0xC7A93BB0,"Senora Way")
	AddTextEntryByHash(0xD529ED93,"Shank St")
	AddTextEntryByHash(0x7727141A,"Signal St")
	AddTextEntryByHash(0x5C3E7D79,"Sinner St")
	AddTextEntryByHash(0x73F8ADE1,"South Boulevard Del Perro")
	AddTextEntryByHash(0xCDF48F9E,"South Mo Milton Dr")
	AddTextEntryByHash(0x01D80573,"South Rockford Dr")
	AddTextEntryByHash(0xC5438966,"South Shambles St")
	AddTextEntryByHash(0x917FD2AB,"Spanish Ave")
	AddTextEntryByHash(0xBED67F35,"Steele Way")
	AddTextEntryByHash(0x3FD7E083,"Strangeways Dr")
	AddTextEntryByHash(0x68DF3909,"Strawberry Ave")
	AddTextEntryByHash(0x101C10C8,"Supply St")
	AddTextEntryByHash(0xA6761DA3,"Sustancia Rd")
	AddTextEntryByHash(0x4F69F80D,"Swiss St")
	AddTextEntryByHash(0x24349A67,"Tackle St")
	AddTextEntryByHash(0x3D7A8076,"Tangerine St")
	AddTextEntryByHash(0x1EBDEABC,"Tongva Dr")
	AddTextEntryByHash(0x44A9B903,"Tower Way")
	AddTextEntryByHash(0x332A2A65,"Tug St")
	AddTextEntryByHash(0x85F57AFA,"O'Neil Way")
	AddTextEntryByHash(0xD7C3E89F,"Utopia Gardens")
	AddTextEntryByHash(0x84B5FCB9,"Vespucci Blvd")
	AddTextEntryByHash(0xC527457D,"Vinewood Blvd")
	AddTextEntryByHash(0xD513F002,"Vinewood Park Dr")
	AddTextEntryByHash(0x43CE38FF,"Vitus St")
	AddTextEntryByHash(0x75723A2C,"Voodoo Place")
	AddTextEntryByHash(0x983A7D65,"West Eclipse Blvd")
	AddTextEntryByHash(0xB23474,"West Mirror Drive")
	AddTextEntryByHash(0xFFFC76B4,"Whispymound Dr")
	AddTextEntryByHash(0xB4BB47B3,"Wild Oats Dr")
	AddTextEntryByHash(0xCE9D4092,"York St")
	AddTextEntryByHash(0x0F020961,"Zancudo Barranca")
	AddTextEntryByHash(0x96B41893,"Zancudo Rd")
	AddTextEntryByHash(0x12057A99,"Del Perro Fwy")
	AddTextEntryByHash(0xC8690C80,"Del Perro Fwy")
	AddTextEntryByHash(0x2E49B265,"Elysian Fields Fwy")
	AddTextEntryByHash(0x4DFC3A0B,"La Puerta Fwy")
	AddTextEntryByHash(0xAC9F694E,"Los Santos Freeway")
	AddTextEntryByHash(0x192E8516,"Olympic Fwy")
	AddTextEntryByHash(0x9B01C923,"Senora Fwy")
	AddTextEntryByHash(0xF83C4076,"Palomino Freeway")
	AddTextEntryByHash(0xF5DE6511,"Palomino Fwy")
	AddTextEntryByHash(0xE7932A4B,"Great Ocean Hwy")
	AddTextEntryByHash(0x73F16A64,"Cavalry Blvd")
	AddTextEntryByHash(0xF5BF6BDD,"Runway1")
	AddTextEntryByHash(0x7999837,"Route 68")

	if GlobalState.Blackout then
		SetArtificialLightsState(true)
		SetArtificialLightsStateAffectsVehicles(false)
	end

	while true do
		local Pid = PlayerId()
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			DisableControlAction(0,345,true)

			local Vehicle = GetVehiclePedIsUsing(Ped)
			if not GetPedConfigFlag(Ped,184,true) then
				SetPedConfigFlag(Ped,184,true)
			end

			if GetPedInVehicleSeat(Vehicle,0) == Ped and GetIsTaskActive(Ped,165) then
				SetPedIntoVehicle(Ped,Vehicle,0)
			end

			if IsPedInAnyHeli(Ped) and IsControlJustPressed(1,154) and not IsAnyPedRappellingFromHeli(Vehicle) and (GetPedInVehicleSeat(Vehicle,1) == Ped or GetPedInVehicleSeat(Vehicle,2) == Ped) then
				TaskRappelFromHeli(Ped,1)
			end
		else
			if GetPedConfigFlag(Ped,184,true) then
				SetPedConfigFlag(Ped,184,false)
			end
		end

		for Number = 1,22 do
			if Number ~= 14 and Number ~= 16 then
				HideHudComponentThisFrame(Number)
			end
		end

		for _,control in ipairs(CONTROLS) do
			DisableControlAction(0,control,true)
		end

		DisableVehicleDistantlights(true)
		SetAllVehicleGeneratorsActive()
		CancelCurrentPoliceReport()
		BlockWeaponWheelThisFrame()
		SetCreateRandomCops(false)
		SetPoliceRadarBlips(false)
		DistantCopCarSirens(false)
		SetPauseMenuActive(false)
		SetGarbageTrucks(false)
		SetRandomTrains(false)
		SetRandomBoats(false)

		SetVehicleDensityMultiplierThisFrame(CurrentDensity.VehicleDensity * TrafficVehicleMultiplier)
		SetRandomVehicleDensityMultiplierThisFrame(CurrentDensity.RandomVehicleDensity * TrafficVehicleMultiplier)
		SetParkedVehicleDensityMultiplierThisFrame(CurrentDensity.ParkedVehicleDensity * AmbientDensityMultiplier)
		SetScenarioPedDensityMultiplierThisFrame(CurrentDensity.ScenarioPedDensity * TrafficPedMultiplier, CurrentDensity.ScenarioPedDensity * TrafficPedMultiplier)
		SetPedDensityMultiplierThisFrame(CurrentDensity.PedDensity * TrafficPedMultiplier)

		if IsPedArmed(Ped,6) then
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
		end

		if IsPedUsingActionMode(Ped) then
			SetPedUsingActionMode(Ped,-1,-1,1)
		end

		SetPlayerTargetingMode(3)
		DisablePlayerVehicleRewards(Pid)
		SetPlayerLockonRangeOverride(Pid,0.0)
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetPedInfiniteAmmoClip(Ped,false)

		if IsPlayerWantedLevelGreater(Pid,0) then
			ClearPlayerWantedLevel(Pid)
		end

		-- Native cutscenes own lighting, weather and clock during playback.
		if not IsCutsceneActive() and not IsCutscenePlaying() then
			if LocalPlayer.state.Active and not LocalPlayer.state.Propertys then
				NetworkOverrideClockTime(GlobalState.Hours,GlobalState.Minutes,0)
	
				SetWeatherTypeNowPersist(GlobalState.Weather)
				SetOverrideWeather(GlobalState.Weather)
				SetWeatherTypeNow(GlobalState.Weather)
			else
				NetworkOverrideClockTime(12,0,0)
	
				SetWeatherTypeNow("EXTRASUNNY")
				SetOverrideWeather("EXTRASUNNY")
				SetWeatherTypeNowPersist("EXTRASUNNY")
			end
		end

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _,v in pairs(IPL_LIST) do
		local Interior = GetInteriorAtCoords(v.Coords)
		LoadInterior(Interior)

		if v.Props then
			for _,Index in pairs(v.Props) do
				EnableInteriorProp(Interior,Index)
			end
		end

		RefreshInterior(Interior)
	end

	for _,v in ipairs(ALPHAS) do
		local Radius = v[1]
		local Blip = AddBlipForRadius(Radius.x,Radius.y,Radius.z,v[4])
		SetBlipAlpha(Blip,v[2])
		SetBlipColour(Blip,v[3])
	end



	local teleportData = {}
	for _,v in ipairs(TELEPORT) do
		table.insert(teleportData,{ v[1],2.5,"E","Pressione","para acessar" })
	end

	TriggerEvent("hoverfy:Insert",teleportData)

	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			for Number = 1,#TELEPORT do
				if #(Coords - TELEPORT[Number][1]) <= 1.0 then
					TimeDistance = 1

					if IsControlJustPressed(1,38) then
						SetEntityCoordsNoOffset(Ped,TELEPORT[Number][2])
					end
				end
			end
		end

		InvalidateVehicleIdleCam()
		InvalidateIdleCam()

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPEZA DE ENTIDADES LOCAIS: recursos que criam peds/veículos locais legítimos e não podem ter eles apagados
-- (ex.: pré-visualização de animações do spectrem_director, que mostra "The preview subject is no longer available").
-----------------------------------------------------------------------------------------------------------------------------------------
local KeepLocalEntities = {
	["spectrem_director"] = true,
	["saltytrains"] = true,
	["kq_link"] = true,
	["kq_jobcontracts"] = true,
	["kq_powerwashing"] = true
}

local function Protected(Entity)
	local Script = GetEntityScript(Entity)
	return Script ~= nil and KeepLocalEntities[Script] == true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local IslandLoaded = false
	for _,v in pairs(ISLAND) do
		RequestIpl(v)
	end

	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		if #(Coords - vec3(4840.57,-5174.42,2.0)) <= 2000 then
			if not IslandLoaded then
				IslandLoaded = true
				SetIslandHopperEnabled("HeistIsland",true)
				SetAiGlobalPathNodesType(1)
				SetDeepOceanScaler(0.0)
				LoadGlobalWaterType(1)
			end
		else
			if IslandLoaded then
				IslandLoaded = false
				SetIslandHopperEnabled("HeistIsland",false)
				SetAiGlobalPathNodesType(0)
				SetDeepOceanScaler(1.0)
				LoadGlobalWaterType(0)
			end
		end

		for _,Entity in pairs(GetGamePool("CPed")) do
			if (NetworkGetEntityOwner(Entity) == -1 or NetworkGetEntityOwner(Entity) == PlayerId()) and not DecorGetBool(Entity,"CREATIVE_PED") and not NetworkGetEntityIsNetworked(Entity) and not Protected(Entity) then
				if IsPedInAnyVehicle(Entity) then
					local Vehicle = GetVehiclePedIsUsing(Entity)
					if NetworkGetEntityIsNetworked(Vehicle) then
						TriggerServerEvent("garages:Delete",NetworkGetNetworkIdFromEntity(Vehicle),GetVehicleNumberPlateText(Vehicle))
					else
						DeleteEntity(Vehicle)
					end
				else
					DeleteEntity(Entity)
				end
			end
		end

		for _,Vehicle in pairs(GetGamePool("CVehicle")) do
			if (NetworkGetEntityOwner(Vehicle) == -1 or NetworkGetEntityOwner(Vehicle) == PlayerId()) and not NetworkGetEntityIsNetworked(Vehicle) and GetVehicleNumberPlateText(Vehicle) ~= "PDMSPORT" and not Protected(Vehicle) then
				DeleteEntity(Vehicle)
			end
		end

		for Number = 1,121 do
			EnableDispatchService(Number,false)
		end

		Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAYO PERICO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        SetRadarAsExteriorThisFrame()
        SetRadarAsInteriorThisFrame("h4_fake_islandx", vec(4700.0, -5145.0), 0, 0)
    end
end)
------------------------------------------------------------------------------------------
-- CLEARAREA
------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(0)
        for _, area in ipairs(ClearAreaList) do
            if area.ClearPeds then
                ClearAreaOfPeds(area.X + 0.0, area.Y + 0.0, area.Z + 0.0, area.Radius + 0.0, 1)
            end
            if area.ClearVehicles then
                ClearAreaOfVehicles(area.X + 0.0, area.Y + 0.0, area.Z + 0.0, area.Radius + 0.0, false, false, false, false, false)
            end
        end
    end
end)
------------------------------------------------------------------------------------------
-- AREASSEMNPC
------------------------------------------------------------------------------------------
-- Áreas fixas sem NPCs a pé. Carros de NPC circulando são mantidos.
local NoNpcAreas = {
    { Name = "Praca", X = 195.17, Y = -933.77, Z = 30.69, Radius = 80.0 }
}

CreateThread(function()
    for _, area in ipairs(NoNpcAreas) do
        area.Pop = AddPopMultiplierSphere(area.X, area.Y, area.Z, area.Radius, 0.0, 1.0, false, true)
    end

    while true do
        local coords = GetEntityCoords(PlayerPedId())
        for _, area in ipairs(NoNpcAreas) do
            if #(coords - vec3(area.X, area.Y, area.Z)) <= area.Radius + 150.0 then
                for _, ped in ipairs(GetGamePool("CPed")) do
                    if not IsPedAPlayer(ped) and not IsPedInAnyVehicle(ped, true) and #(GetEntityCoords(ped) - vec3(area.X, area.Y, area.Z)) <= area.Radius then
                        local population = GetEntityPopulationType(ped)
                        if population >= 1 and population <= 5 and NetworkHasControlOfEntity(ped) then
                            DeleteEntity(ped)
                        end
                    end
                end
            end
        end
        Wait(500)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, area in ipairs(NoNpcAreas) do
        if area.Pop then RemovePopMultiplierSphere(area.Pop, false) end
    end
end)
------------------------------------------------------------------------------------------
-- BLOQUEARRADIO
------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            SetVehicleRadioEnabled(GetVehiclePedIsIn(PlayerPedId(), false), false)
            SetVehRadioStation(GetVehiclePedIsIn(PlayerPedId(), false), "OFF")
            DisableControlAction(0, 81, true)  -- INPUT_VEH_PREV_RADIO
            DisableControlAction(0, 82, true)  -- INPUT_VEH_NEXT_RADIO
            DisableControlAction(0, 83, true)  -- INPUT_VEH_PREV_RADIO_TRACK
            DisableControlAction(0, 84, true)  -- INPUT_VEH_NEXT_RADIO_TRACK
            DisableControlAction(0, 85, true)  -- INPUT_VEH_RADIO_WHEEL
        end
    end
end)