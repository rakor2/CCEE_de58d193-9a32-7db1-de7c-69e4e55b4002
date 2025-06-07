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
    DPrint('Waiting 200 ticks before applying parameters')
    Helpers.Timer:OnTicks(200, function()
        DPrint('Boom')
        local lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
        Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(lastParameters))
    end)
end)



function ForceLoad()
    local lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
    Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(lastParameters))
end

Ext.RegisterNetListener('ForceLoad', function (channel, payload, user)
    DPrint('Force load')
    ForceLoad()
end)