-- function testS()
--     _C().Vars.NRD_Whatever = 333
--     DPrint(_C().Vars.NRD_Whatever)
-- end

-- Ext.RegisterConsoleCommand('tS', testS)


---@param ticks integer # Ticks to wait befor applying parameters 
---@param entity EntityHandle
---@param singleEntity boolean # Apply parameters to single character or all characters
---@param onlyVis boolean 
function UpdateParameters(ticks, entity, singleEntity, onlyVis)
    -- DDump(Helpers.ModVars.Get(ModuleUUID).CCEE)
    local uuid
    if entity ~= nil then
        uuid = entity.Uuid.EntityUuid
    else
        uuid = ''
    end
    local payload = {
        single = singleEntity,
        entityUuid = uuid,
        TICKS_TO_WAIT = ticks,
        lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE,
        matParameters = Helpers.ModVars.Get(ModuleUUID).CCEE_MT
    }



    DPrint('UpdateParameters')

    if onlyVis == true then
        Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
    else
        if Helpers.ModVars.Get(ModuleUUID).CCEE then 
            Ext.Net.BroadcastMessage('LoadMatVars', Ext.Json.Stringify(payload))
            Helpers.Timer:OnTicks(15, function ()
                Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
            end)
        end
    end

end



function applyCharacterCreationAppearance(charEntity, savedAppearance)
    local CCA = charEntity.CharacterCreationAppearance
    for i = 1, #savedAppearance.AdditionalChoices do
        CCA.AdditionalChoices[i] = savedAppearance.AdditionalChoices[i]
    end
    for i = 1, #savedAppearance.Elements do
        CCA.Elements[i].Color = savedAppearance.Elements[i].Color
        CCA.Elements[i].ColorIntensity = savedAppearance.Elements[i].ColorIntensity
        CCA.Elements[i].GlossyTint = savedAppearance.Elements[i].GlossyTint
        CCA.Elements[i].Material = savedAppearance.Elements[i].Material
        CCA.Elements[i].MetallicTint = savedAppearance.Elements[i].MetallicTint
    end
    CCA.EyeColor = savedAppearance.EyeColor
    CCA.HairColor = savedAppearance.HairColor
    CCA.SecondEyeColor = savedAppearance.SecondEyeColor
    CCA.SkinColor = savedAppearance.SkinColor
    for i = 1, #savedAppearance.Visuals do
        CCA.Visuals[i] = savedAppearance.Visuals[i]
    end
end


-- eventID = Ext.Events.Tick:Subscribe(function()
--     Ext.Entity.OnChange("DisplayName", function(entity)
--         DPrint('123')
--     end)
-- end)
