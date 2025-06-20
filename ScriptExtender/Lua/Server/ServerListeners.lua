---@diagnostic disable: param-type-mismatch

TICKS_TO_WAIT = 2
TICKS_TO_LOAD = 10


--Only sp for now
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    DPrint('LevelGameplayStarted')
    UpdateParameters(1, nil, false)
    Ext.Net.BroadcastMessage('WhenLevelGameplayStarted', '')
    Helpers.ModVars.Get(ModuleUUID).CCEE = Helpers.ModVars.Get(ModuleUUID).CCEE or {}
    DPrint('beep')  
end)





Ext.Osiris.RegisterListener("Equipped", 2, "after", function(item, character)
    DPrint('Equipped')
    UpdateParameters(40, Ext.Entity.Get(character), true)
end)

Ext.Osiris.RegisterListener("Unequipped", 2, "after", function(item, character)
    DPrint('Unequipped')
    UpdateParameters(40, Ext.Entity.Get(character), true)
end)

Ext.Entity.Subscribe("ArmorSetState", function(entity)
    UpdateParameters(40, Ext.Entity.Get(entity), true)
    DPrint('ArmorSetState')
end)



--    Ext.Entity.OnSystemUpdate("ServerSpell", function()
--         local unprep = Ext.System.ServerSpell.PlayerUnprepareSpell
--         for entity, spells in pairs(unprep) do
--             ReAddSpellsOnHotBar(entity, Ext.Types.Serialize(spells))
--         end
--     end)

-- Ext.Osiris.RegisterListener("AutomatedDialogStarted", 2, "after", function(dialog, instanceId)
--     -- DPrint('AutomatedDialogStarted')
--     Ext.Net.BroadcastMessage('LoadDollParameters', '')
--     -- UpdateParameters(0, nil, false)
--     DPrint('AutomatedDialogStarted')
-- end)


Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceId)

    DPrint('DialogStarted')

        Ext.Net.BroadcastMessage('LoadDollParameters', '')
        -- UpdateParameters(10, nil, false)


end)


Ext.Osiris.RegisterListener("CombatStarted", 1, "after", function(combatGuid)
    DPrint('CombatStarted')
    -- Ext.Net.BroadcastMessage('LoadParameters', '')
    UpdateParameters(2, nil, false)

end)


-- Ext.Osiris.RegisterListener("GainedControl", 1, "after", function(targer)
--     Ext.Net.BroadcastMessage('UpdateParametersTemp')
-- end)




Ext.RegisterNetListener('SendModVars', function (channel, payload, user)
    local lastParameters = Ext.Json.Parse(payload)
    Helpers.ModVars.Get(ModuleUUID).CCEE = lastParameters
    -- DDump(Helpers.ModVars.Get(ModuleUUID).CCEE)
end)






Ext.RegisterNetListener('LoadLocalSettings', function (channel, payload, user)

    local data = SafeLoadFile('CCEE')

    local payload = {
        TICKS_TO_WAIT = 4,
        lastParameters = data
    }

    Helpers.Timer:OnTicks(TICKS_TO_LOAD, function ()
        Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
    end)


end)



Ext.RegisterNetListener('UpdateParameters', function (channel, payload, user)
    UpdateParameters(3, nil, false)
end)


Ext.RegisterNetListener('stop', function (channel, payload, user)
    Osi.PlayLoopingAnimation(_C().Uuid.EntityUuid, "", '', "", "", "", "", "")
end)


Ext.RegisterNetListener('dumpVars', function (channel, payload, user)
    DDump(Helpers.ModVars.Get(ModuleUUID))
end)


Ext.RegisterNetListener('ResetCurrentCharacter', function (channel, payload, user)
    _C():Replicate('GameObjectVisual')
    _C():Replicate("CharacterCreationAppearance")
end)



Ext.RegisterNetListener('LoadPreset', function (channel, payload, user)

    local data = Ext.Json.Parse(payload)

    for uuid, params in pairs(data) do
        -- DDump(uuid)
        -- DPrint('------------')
        -- DDump(params)
        local entity = Ext.Entity.Get(uuid)


        entity:Replicate('GameObjectVisual')
        entity:Replicate("CharacterCreationAppearance")
        entity:Replicate("ItemDye")
    

        Helpers.ModVars.Get(ModuleUUID).CCEE[uuid] = params[1]
        local vars = Helpers.ModVars.Get(ModuleUUID).CCEE
        Helpers.ModVars.Get(ModuleUUID).CCEE = vars


        local ent = Ext.Entity.Get(uuid)


        Helpers.Timer:OnTicks(4, function ()
            
            for _,v in pairs(ent.CharacterCreationAppearance.Visuals) do
                Osi.RemoveCustomVisualOvirride(uuid, v)
                DPrint('RemoveCustomVisualOvirride')
            end
    
        end)


        Helpers.Timer:OnTicks(8, function ()

            Helpers.Timer:OnTicks(20, function ()

                if params[2] then 

                    for _, visUuid in pairs(params[2]) do
                        if visUuid then
                            Osi.AddCustomVisualOverride(uuid, visUuid)
                            DPrint('AddCustomVisualOverride')
                        end
                    end

                    UpdateParameters(60, entity, true)

                end

            end)
        end)
    end
end)

--temp
Ext.RegisterNetListener('LoadPreset2', function (channel, payload, user)

    local data = Ext.Json.Parse(payload)

    for uuid, params in pairs(data) do

        local entity = Ext.Entity.Get(uuid)


        entity:Replicate('GameObjectVisual')
        entity:Replicate("CharacterCreationAppearance")
        entity:Replicate("ItemDye")
    

        Helpers.ModVars.Get(ModuleUUID).CCEE[uuid] = params[1]
        local vars = Helpers.ModVars.Get(ModuleUUID).CCEE
        Helpers.ModVars.Get(ModuleUUID).CCEE = vars


        local ent = Ext.Entity.Get(uuid)

        Helpers.Timer:OnTicks(8, function ()

            Helpers.Timer:OnTicks(20, function ()

                if params[2] then 

                    for _, visUuid in pairs(params[2]) do
                        if visUuid then
                            Osi.AddCustomVisualOverride(uuid, visUuid)
                        end
                    end

                    UpdateParameters(60, entity, true)

                end

            end)
        end)
    end
end)








-- Ext.Osiris.RegisterListener("CharacterCreationStarted", 0, "after", function(character)
--     DPrint('CharacterCreationStarted')
--     DPrint(character)
-- end)

-- Ext.Osiris.RegisterListener("CharacterCreationFinished", 0, "after", function(character) 
--     DPrint('CharacterCreationFinished')
--     DPrint(character)
-- end)

-- Ext.Osiris.RegisterListener("ChangeAppearanceCompleted", 1, "after", function(character) 
--     DPrint('ChangeAppearanceCompleted')
--     DPrint(character)
-- end)



-- Ext.Entity.Subscribe("ItemDye", function(entity)
--     UpdateParameters(3, nil, false)
-- end)


-- Ext.Entity.Subscribe("GameObjectVisual", function(entity)
--     DPrint(entity)
--     DPrint('GameObjectVisual')
-- end)



-- Ext.Entity.Subscribe("CharacterCreationAppearance", function(entity)
--     DPrint(entity)
--     DPrint('CharacterCreationAppearance')
-- end)


-- Ext.Entity.Subscribe("ItemDye", function(entity)
--     DPrint(entity)
--     DPrint('ItemDye')
-- end)

