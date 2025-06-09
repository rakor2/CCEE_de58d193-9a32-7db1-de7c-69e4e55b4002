Ext.RegisterNetListener('UpdateParameters', function (channel, payload, user)
    local lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
    Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(lastParameters))
end)

Ext.RegisterNetListener('LoadParameters',function (channel, payload, user)
    ApplyParametersToDolls()
end)