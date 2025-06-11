
TICKS_TO_WAIT = 1
TICKS_TO_LOAD = 10


--Only sp for now
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    DPrint('LevelGameplayStarted')
    UpdateParameters(0, nil, false)
    Ext.Net.BroadcastMessage('WhenLevelGameplayStarted', '')
end)


Ext.Osiris.RegisterListener("Equipped", 2, "after", function(item, character)
    DPrint('Equipped')
    UpdateParameters(3, Ext.Entity.Get(character), true)
end)

Ext.Osiris.RegisterListener("Unequipped", 2, "after", function(item, character)
    DPrint('Unequipped')
    UpdateParameters(3, Ext.Entity.Get(character), true)
end)

Ext.Entity.Subscribe("ArmorSetState", function(entity)
    -- DPrint(entity)
    UpdateParameters(3, Ext.Entity.Get(entity), true)
    DPrint('ArmorSetState')
end)


Ext.Osiris.RegisterListener("AutomatedDialogStarted", 2, "after", function(dialog, instanceId)
    -- DPrint('AutomatedDialogStarted')
    -- Ext.Net.BroadcastMessage('LoadParameters', '')
    -- UpdateParameters(0, nil, false)
    -- DPrint('AutomatedDialogStarted')
end)


Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceId)
    -- DPrint('DialogStarted')
    -- Ext.Net.BroadcastMessage('LoadParameters', '')
    UpdateParameters(0, nil, false)
    DPrint('DialogStarted')
end)


Ext.Osiris.RegisterListener("CombatStarted", 1, "after", function(combatGuid)
    DPrint('CombatStarted')
    -- Ext.Net.BroadcastMessage('LoadParameters', '')
    UpdateParameters(0, nil, false)

end)





Ext.RegisterNetListener('SendModVars', function (channel, payload, user)
    local lastParameters = Ext.Json.Parse(payload)
    Helpers.ModVars.Get(ModuleUUID).CCEE = lastParameters
    -- DDump(Helpers.ModVars.Get(ModuleUUID).CCEE)
end)


Ext.RegisterNetListener('LoadLocalSettings', function (channel, payload, user)

    local name = LocalSettings.FileName
    LocalSettings.FileName = "CCEE"
    local localData = LocalSettings:Get('CCEE')
    LocalSettings.FileName = name

    local payload = {
        TICKS_TO_WAIT = 4,
        lastParameters = localData
    }

    Helpers.Timer:OnTicks(TICKS_TO_LOAD, function ()
        Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
    end)




end)



Ext.RegisterNetListener('UpdateParameters', function (channel, payload, user)
    UpdateParameters(1, nil, false)
end)


Ext.RegisterNetListener('stop', function (channel, payload, user)
    Osi.PlayLoopingAnimation(GetHostCharacter(), "", '', "", "", "", "", "")
end)


Ext.RegisterNetListener('dumpVars', function (channel, payload, user)
    DDump(Helpers.ModVars.Get(ModuleUUID))
end)