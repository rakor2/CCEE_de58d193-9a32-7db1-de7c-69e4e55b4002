---@diagnostic disable: param-type-mismatch


Ext.RegisterNetListener('UpdateParameters', function (channel, payload, user)
    local lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
    Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(lastParameters))
end)





Ext.RegisterNetListener('WhenLevelGameplayStarted', function (channel, payload, user)
    GetAllParameterNames(_C())
    Helpers.Timer:OnTicks(100, function ()
        DPrint('Elements:UpdateElements')
        Elements:UpdateElements(_C().Uuid.EntityUuid)
    end)
    if _C() then
        GetAllParameterNames(_C())
        Helpers.Timer:OnTicks(200, function ()
            DPrint('Elements:UpdateElements')
            Elements:UpdateElements(_C().Uuid.EntityUuid)
        end)
    end
end)


Ext.Entity.OnCreate("ClientControl", function(entity, ct, c)
    -- DPrint(entity.Uuid.EntityUuid)
     Elements:UpdateElements(entity.Uuid.EntityUuid)
end)


Ext.Entity.OnChange("ItemDye", function(entity)
    TempThingy()
end)


--Paperdoll --make a check for transparent attack doll
Ext.Entity.OnCreate("ClientPaperdoll", function(entity, componentType, component)
    DPrint('ClientPaperdollOnCreate')
    Helpers.Timer:OnTicks(5, function ()
        local owner = Paperdoll.GetDollOwner(entity)
        if owner then
            DPrint('Dummy/Doll owner: ' .. owner.DisplayName.Name:Get())
            ApplyParametersToDollsTest(entity, owner.Uuid.EntityUuid)
        end
    end)
end)


--TLPreviewDummy
Ext.RegisterNetListener('LoadDollParameters',function (channel, payload, user)
    -- Helpers.Timer:OnTicks(1, function ()
    --     ApplyParametersToDolls()
    -- end)
    local entity = Ext.Entity.GetAllEntitiesWithComponent("TLPreviewDummy")
    for q = 1, #entity do
        local dummy = entity[q].TLPreviewDummy
        if dummy ~= nil and entity[q].ClientTimelineActorControl ~= nil then
            local actorLink = entity[q].ClientTimelineActorControl.field_0
            local owner
            for i, v in pairs(Ext.Entity.GetAllEntitiesWithComponent("Origin")) do
                if v.TimelineActorData ~= nil and v.TimelineActorData.field_0 == actorLink then
                    owner = v
                    DPrint('Dummy/Doll owner: ' .. owner.DisplayName.Name:Get())
                    Helpers.Timer:OnTicks(2, function ()
                        ApplyParametersToDollsTest(entity[q], owner.Uuid.EntityUuid)
                    end)
                end
            end
        end
    end
end)


Ext.Entity.OnCreate("ClientEquipmentVisuals", function(entity, componentType, component)
    Helpers.Timer:OnTicks(40, function ()
        if entity:GetAllComponentNames(false)[2] == 'ecl::dummy::AnimationStateComponent' then
            DPrint('CEV|PM dummies')
            ApplyParametersToDummies()
        end
    end)
end)


--TLPreviewDummy
-- Ext.Entity.OnCreate("ClientEquipmentVisuals", function(entity)
--     DPrint(entity)
--     local dummy = entity.TLPreviewDummy
--     if dummy ~= nil and entity.ClientTimelineActorControl ~= nil then
--         DPrint('ClientEquipmentVisuals')
--         -- Match and find owner
--         local actorLink = entity.ClientTimelineActorControl.field_0
--         local owner
--         -- DPrint(actorLink)
--         for i, v in ipairs(Ext.Entity.GetAllEntitiesWithComponent("ClientEquipmentVisuals")) do
--             -- Owner character should have TimelineActorData but not ClientTimelineActorControl
--             if v.TimelineActorData ~= nil and not v.ClientTimelineActorControl and v.TimelineActorData.field_0 == actorLink then
--                 owner = v
--                 -- DPrint('-------------')
--                 -- DPrint(owner)
--                 Helpers.Timer:OnTicks(30, function ()
--                     DPrint(owner.DisplayName.Name:Get())
--                     ApplyParametersToDollsTest(entity, owner.Uuid.EntityUuid)
--                 end)

--             end
--         end
--     end


--     local tl = Ext.Entity.GetAllEntitiesWithComponent('TLPreviewDummy')
--     DDump(tl)

-- end)

-- Ext.Entity.OnCreate("TLPreviewDummy", function(entity, componentType, component)
--     DPrint('TLPreviewDummy')
--     local dummy = entity.TLPreviewDummy
--     DPrint(entity)
--     DDump(entity.ClientTimelineActorControl)

--     if dummy ~= nil and entity.ClientTimelineActorControl ~= nil then
--         DPrint('ClientEquipmentVisuals')
--         -- Match and find owner
--         local actorLink = entity.ClientTimelineActorControl.field_0
--         local owner
--         -- DPrint(actorLink)
--         for i, v in ipairs(Ext.Entity.GetAllEntitiesWithComponent("ClientEquipmentVisuals")) do
--             -- Owner character should have TimelineActorData but not ClientTimelineActorControl
--             if v.TimelineActorData ~= nil and not v.ClientTimelineActorControl and v.TimelineActorData.field_0 == actorLink then
--                 owner = v
--                 -- DPrint('-------------')
--                 -- DPrint(owner)
--                 Helpers.Timer:OnTicks(30, function ()
--                     DPrint(owner.DisplayName.Name:Get())
--                     ApplyParametersToDollsTest(entity, owner.Uuid.EntityUuid)
--                 end)

--             end
--         end
--     end

-- end)




-- Ext.Entity.OnChange("CharacterCreationAppearance", function(entity)
--     DPrint(entity)
--     DPrint('CharacterCreationAppearance')
-- end)







--Systems

-- Ext.Entity.OnSystemUpdate("ClientEquipmentVisuals", function()

--     local visuals = Ext.System.ClientEquipmentVisuals.DyeUpdates
--     for k, entity in pairs(visuals) do
--         DPrint('DyeUpdates')
--         DPrint(entity)
--     end

-- end)


-- Ext.Entity.OnSystemUpdate("ClientEquipmentVisuals", function()

--     local visuals = Ext.System.ClientEquipmentVisuals.InventoryEvents
--     for entity, v in pairs(visuals) do
--         DPrint(entity)
--     end

-- end)

--Maybe this instead of ArmorState, Equiped, Uneqipped, but it doesn't show which entity requested 
-- Ext.Entity.OnSystemUpdate("ClientEquipmentVisuals", function()

--     local visuals = Ext.System.ClientEquipmentVisuals.UnloadRequests
--     for k, vis in pairs(visuals) do
--         DDump(vis)
--     end

-- end)
