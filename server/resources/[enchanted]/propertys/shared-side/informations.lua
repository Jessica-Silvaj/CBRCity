-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
Informations = {
	Amethyst = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Amethyst.png"
	},
	Amber = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Amber.png"
	},
	Sapphire = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Sapphire.png"
	},
	Emerald = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Emerald.png"
	},
	Topaz = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Topaz.png"
	},
	Opal = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Opal.png"
	},
	Jade = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Jade.png"
	},
	Pearl = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Pearl.png"
	},
	Aquamarine = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Aquamarine.png"
	},
	Turquoise = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Turquoise.png"
	},
	Onyx = {
		Price = 2000000,
		Gemstone = 100000,
		Image = "nui://dynamic/web-side/shells/Onyx.png"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Informations",function()
	local Interiors = {}
	for Name in pairs(Informations) do
		Interiors[#Interiors + 1] = Name
	end

	return Interiors[math.random(1,#Interiors)]
end)