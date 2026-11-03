-----------------------------------------------------------------------------------------------------------------------------------------
-- /gravar: liga/desliga a gravação do Rockstar Editor
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gravar",function()
	if IsRecording() then
		StopRecordingAndSaveClip()
		TriggerEvent("Notify","Rockstar Editor","Gravação salva no Rockstar Editor.","verde",5000)
	else
		StartRecording(1)
		TriggerEvent("Notify","Rockstar Editor","Gravação iniciada. Use <b>/gravar</b> de novo para salvar.","amarelo",5000)
	end
end,false)
