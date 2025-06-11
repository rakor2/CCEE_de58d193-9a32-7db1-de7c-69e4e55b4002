Ext.RegisterNetListener('UpdateParameters', function (channel, payload, user)
    local lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
    Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(lastParameters))
end)

Ext.RegisterNetListener('LoadParameters',function (channel, payload, user)
    Helpers.Timer:OnTicks(2, function ()
        ApplyParametersToDolls()
    end)

end)

Ext.RegisterNetListener('WhenLevelGameplayStarted', function (channel, payload, user)
    
    KeybindingManager:Bind({
        ScanCode = tostring(GetKeybind(1,320)):upper(),
        Callback = function()

            Helpers.Timer:OnTicks(30, function ()
            --no double calls on my watch
            local s, _ = pcall(function()
                return Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.DOFStrength
            end)

                if s then
                    ApplyParametersToDummies()
                end

            end)

        end,
    })

end)