Ext.Osiris.RegisterListener("Equipped", 2, "after", function(item, character)
    ForceLoad()
end)

Ext.Osiris.RegisterListener("Unequipped", 2, "after", function(item, character)
    ForceLoad()
end)

Ext.Entity.Subscribe("ArmorSetState", function(entity)
    Helpers.Timer:OnTicks(3, function()
        ForceLoad()
    end)
end)


Ext.RegisterNetListener('SendModVars', function (channel, payload, user)
    local lastParameters = Ext.Json.Parse(payload)
    Helpers.ModVars.Get(ModuleUUID).CCEE = lastParameters
    -- DDump(Helpers.ModVars.Get(ModuleUUID).CCEE)
end)


--Only sp for now
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    DPrint('LevelGameplayStarted')

    local ticksToWait = 200
    local payload = {
        ticksToWait = ticksToWait,
        lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
    }

    if Helpers.ModVars.Get(ModuleUUID).CCEE then 
        Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
    end

end)


Ext.Osiris.RegisterListener("AutomatedDialogStarted", 2, "after", function(dialog, instanceId)
    -- DPrint('AutomatedDialogStarted')
    Ext.Net.BroadcastMessage('LoadParameters', '')
end)



Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceId)
    -- DPrint('DialogStarted')
    Ext.Net.BroadcastMessage('LoadParameters', '')
end)


-- Ext.Osiris.RegisterListener("CombatStarted", 2, "after", function(dialog, instanceId)
--     -- DPrint('CombatStarted')
--     Ext.Net.BroadcastMessage('LoadParameters', '')
-- end)


function ForceLoad(ticksToWait)
    
    local payload = {
        ticksToWait = ticksToWait,
        lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
    }

    if Helpers.ModVars.Get(ModuleUUID).CCEE then 
        Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
    end
    
end

Ext.RegisterNetListener('ForceLoad', function (channel, payload, user)
    DPrint('Force load')
    ForceLoad(1)
end)



Ext.RegisterNetListener('stop', function (channel, payload, user)
    Osi.PlayLoopingAnimation(GetHostCharacter(), "", '', "", "", "", "", "")
end)


