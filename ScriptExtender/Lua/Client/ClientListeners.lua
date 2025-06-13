Ext.RegisterNetListener('UpdateParameters', function (channel, payload, user)
    local lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
    Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(lastParameters))
end)


Ext.RegisterNetListener('LoadDollParameters',function (channel, payload, user)
    Helpers.Timer:OnTicks(2, function ()
        ApplyParametersToDolls()
    end)

end)


Ext.RegisterNetListener('WhenLevelGameplayStarted', function (channel, payload, user)
    -- GetAllParameterNames(_C())
    Helpers.Timer:OnTicks(100, function ()
        Elements:UpdateElements(_C().Uuid.EntityUuid)
    end)
end)



Ext.Entity.OnCreate("ClientControl", function(entity, ct, c)
    -- DPrint(entity.Uuid.EntityUuid)
     Elements:UpdateElements(entity.Uuid.EntityUuid)
end)




Ext.Entity.OnChange("ItemDye", function(entity)
    TempThingy()
end)


-- Ext.Entity.OnCreate("ClientControl", function(entity, ct, c)

--     DPrint('')


-- end)

-- Ext.Entity.OnChange("GameObjectVisual", function(entity)
--     DPrint(entity)
--     DPrint('GameObjectVisual')
-- end)



-- Ext.Entity.OnChange("CharacterCreationAppearance", function(entity)
--     DPrint(entity)
--     DPrint('CharacterCreationAppearance')
-- end)