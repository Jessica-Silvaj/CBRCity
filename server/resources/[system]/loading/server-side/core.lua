-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnecting",function(_,_,deferrals)
	deferrals.defer()

	-- Cópia do Theme do vRP com a cor do loading (LoadingColor no shared-side)
	local LoadingTheme = {}
	for Key,Value in pairs(Theme) do
		LoadingTheme[Key] = Value
	end
	LoadingTheme.main = LoadingColor or Theme.main

	deferrals.handover({
		video = Video,
		socials = Socials,
		playlist = Playlist,
		theme = LoadingTheme,
		autoplay = Autoplay,
		autoplayInterval = AutoplayInterval,
		shortcuts = Shortcuts,
		keybindings = Keybindings,
		progress = Progress,
		classification = Classification,
		classificationAge = ClassificationAge,
		classificationTitle = ClassificationTitle,
		classificationText = ClassificationText,
		tips = Tips,
		tipsSlides = TipsSlides
	})

	deferrals.done()
end)