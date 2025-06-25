---@diagnostic disable: param-type-mismatch

TICKS_TO_WAIT = 2
TICKS_TO_LOAD = 10


--Only sp for now
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    DPrint('LevelGameplayStarted')
    UpdateParameters(3, nil, false)

    Helpers.ModVars.Get(ModuleUUID).CCEE = Helpers.ModVars.Get(ModuleUUID).CCEE or {}
    Helpers.ModVars.Get(ModuleUUID).CCEE_MT = Helpers.ModVars.Get(ModuleUUID).CCEE_MT or {}
    Ext.Net.BroadcastMessage('WhenLevelGameplayStarted', '')
    Ext.Net.BroadcastMessage('CCEE_MT', Ext.Json.Stringify(Helpers.ModVars.Get(ModuleUUID).CCEE_MT))
    DPrint('beep')
end)


Ext.RegisterNetListener('ResetAllData', function (channel, payload, user)
    Helpers.ModVars:Get(ModuleUUID).CCEE = {}
    Helpers.ModVars:Get(ModuleUUID).CCEE_MT = {}
end)



Ext.RegisterNetListener('Replicate', function (channel, payload, user)
    local entity = Ext.Json.Parse(payload)
     Ext.Entity.Get(entity):Replicate('GameObjectVisual')
     Helpers.Timer:OnTicks(10, function ()
        Utils:AntiSpam(500, function ()
            UpdateParameters(4, Ext.Entity.Get(entity), true, true)
        end)
     end)
end)



Ext.RegisterNetListener('SendModVars', function (channel, payload, user)
    local lastParameters = Ext.Json.Parse(payload)
    Helpers.ModVars.Get(ModuleUUID).CCEE = lastParameters
    -- DDump(Helpers.ModVars.Get(ModuleUUID).CCEE)
end)


Ext.RegisterNetListener('SendMatVars', function (channel, payload, user)
    DPrint('SendMatVars')
    local matParameters = Ext.Json.Parse(payload)
    Helpers.ModVars.Get(ModuleUUID).CCEE_MT.MatData = matParameters
    local vars = Helpers.ModVars.Get(ModuleUUID).CCEE_MT
    Helpers.ModVars.Get(ModuleUUID).CCEE_MT = vars
end)

function WatchingMrForsenRn()
    Ext.Net.BroadcastMessage('ForceMatData', Ext.Json.Stringify(Helpers.ModVars.Get(ModuleUUID).CCEE_MT.MatData))
end

Ext.RegisterConsoleCommand('f', WatchingMrForsenRn)

Ext.RegisterNetListener('UsedMatVars', function (channel, payload, user)
    DPrint('UsedMatVars')

    local data = Ext.Json.Parse(payload)
    Helpers.ModVars.Get(ModuleUUID).CCEE_MT['UsedSkinUUID'] = data.UsedSkinUUID
    Helpers.ModVars.Get(ModuleUUID).CCEE_MT['SkinMap'] = data.SkinMap
    local vars = Helpers.ModVars.Get(ModuleUUID).CCEE_MT
    Helpers.ModVars.Get(ModuleUUID).CCEE_MT = vars
end)


Ext.RegisterNetListener('UpdateParameters', function (channel, payload, user)
    UpdateParameters(4, nil, false, false)
end)



Ext.Osiris.RegisterListener("Equipped", 2, "after", function(item, character)
    DPrint('Equipped')
    UpdateParameters(38, Ext.Entity.Get(character), true)
end)


Ext.Osiris.RegisterListener("Unequipped", 2, "after", function(item, character)
    DPrint('Unequipped')
    UpdateParameters(39, Ext.Entity.Get(character), true)
end)


Ext.Entity.Subscribe("ArmorSetState", function(entity)
    DPrint('ArmorSetState')
    UpdateParameters(40, Ext.Entity.Get(entity), true)
end)

Ext.Osiris.RegisterListener("CombatStarted", 1, "after", function(combatGuid)
    DPrint('CombatStarted')
    UpdateParameters(2, nil, false)
end)

-- Ext.Osiris.RegisterListener("CombatEnded", 1, "after", function(combatGuid)
--     DPrint('CombatEnded')
--     -- Ext.Net.BroadcastMessage('LoadParameters', '')
--     UpdateParameters(2, nil, false)
-- end)

Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceId)
    DPrint('DialogStarted')
        Ext.Net.BroadcastMessage('LoadDollParameters', '')
end)






Ext.RegisterNetListener('UpdateParametersSingle', function (channel, payload, user)
    local entity = Ext.Entity.Get(payload)
    -- DPrint('----------------')
    -- DPrint(entity.DisplayName.Name:Get())
    UpdateParameters(0, entity, true)
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
        Helpers.ModVars.Get(ModuleUUID).CCEE[uuid] = params[1]
        local vars = Helpers.ModVars.Get(ModuleUUID).CCEE
        Helpers.ModVars.Get(ModuleUUID).CCEE = vars
        Helpers.Timer:OnTicks(4, function ()
            for _, v in pairs(Ext.Entity.Get(uuid).CharacterCreationAppearance.Visuals) do
                Osi.RemoveCustomVisualOvirride(uuid, v)
                -- DPrint('RemoveCustomVisualOvirride')
            end
        end)
        Helpers.Timer:OnTicks(8, function ()
            Helpers.Timer:OnTicks(20, function ()
                if params[2] then
                    for _, visUuid in pairs(params[2]) do
                        if visUuid then
                            Osi.AddCustomVisualOverride(uuid, visUuid)
                            -- DPrint('AddCustomVisualOverride')
                        end
                    end
                    UpdateParameters(50, entity, true)
                end
            end)
        end)
    end
end)


Ext.Osiris.RegisterListener("ChangeAppearanceCompleted", 1, "after", function(character)
    DPrint('ChangeAppearanceCompleted')
    local entity = Ext.Entity.Get(character)
    Ext.Net.PostMessageToUser(entity.UserReservedFor.UserID, 'CAC', '')
end)


-- Ext.Osiris.RegisterListener("CharacterCreationStarted", 0, "after", function(character)
--     DPrint('CharacterCreationStarted')
--     DPrint(character)
-- end)

-- Ext.Osiris.RegisterListener("CharacterCreationFinished", 0, "after", function(character)
--     DPrint('CharacterCreationFinished')
--     DPrint(character)
-- end)
