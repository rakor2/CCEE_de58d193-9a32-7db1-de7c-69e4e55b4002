---@diagnostic disable: param-type-mismatch


Ext.RegisterNetListener('UpdateParameters', function (channel, payload, user)
    local lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
    Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(lastParameters))
end)


--LevelGameplayStarted
Ext.RegisterNetListener('WhenLevelGameplayStarted', function (channel, payload, user)
    if _C() then
        CzechCCState()
        GetAllParameterNames(_C())
        Helpers.Timer:OnTicks(200, function ()
            DPrint('Elements:UpdateElements')
            Elements:UpdateElements(_C().Uuid.EntityUuid)
        end)
    end
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


--Preset reload on mirror exit
Ext.RegisterNetListener('CAC', function (channel, payload, user)
    RealodPreset()
end)


--Client Control
Ext.Entity.OnCreate("ClientControl", function(entity, ct, c)
    Apply.entity = entity
    ClientControl = true
    -- DPrint(entity.Uuid.EntityUuid)
     Elements:UpdateElements(entity.Uuid.EntityUuid)
     
     Helpers.Timer:OnTicks(5, function ()
        ClientControl = false
     end)
end)

--Paperdoll --make a check for transparent attack doll
Ext.Entity.OnCreate("ClientPaperdoll", function(entity, componentType, component)
    -- DPrint('ClientPaperdoll|OnCreate')
    Helpers.Timer:OnTicks(5, function ()
        local owner = Paperdoll.GetDollOwner(entity)
        if owner then
            DPrint('Dummy/Doll owner: ' .. owner.DisplayName.Name:Get())
            ApplyParametersToDollsTest(entity, owner.Uuid.EntityUuid)
        end
    end)
end)

--PM dummies
Ext.Entity.OnCreate("ClientEquipmentVisuals", function(entity, componentType, component)
    Helpers.Timer:OnTicks(40, function ()
        if entity:GetAllComponentNames(false)[2] == 'ecl::dummy::AnimationStateComponent' then
            DPrint('CEV|PM dummies')
            ApplyParametersToPMDummies()
        end
    end)
end)



Ext.Entity.OnChange("ItemDye", function(entity)
    TempThingy()
end)



Ext.Events.ResetCompleted:Subscribe(function()
    TempThingy()
    CCEE_MT()
    CzechCCState()
    Elements:UpdateElements(_C().Uuid.EntityUuid)
end)

--Systems

-- Ext.Entity.OnSystemUpdate("ClientEquipmentVisuals", function()

--     local visuals = Ext.System.ClientEquipmentVisuals.DyeUpdates
--     for k, entity in pairs(visuals) do
--         DPrint('DyeUpdates')
--         DPrint(entity)
--     end

-- end)



-- Ext.Entity.OnSystemUpdate("ClientCharacterManager", function()
    
--     local visuals = Ext.System.ClientVisualsVisibilityState.UnloadVisuals
--     for entity, v in pairs(visuals) do
--         DPrint('1')
--         DDump(v)
--         -- DPrint('ClientCharacterManager')
--         DPrint(entity)
--     end

-- end)

-- Maybe this instead of ArmorState, Equiped, Uneqipped, but it doesn't show which entity requested 
-- Ext.Entity.OnSystemUpdate("ClientEquipmentVisuals", function()

--     local visuals = Ext.System.ClientEquipmentVisuals.UnloadRequests
--     for k, vis in pairs(visuals) do
--         DDump(vis)
--     end

-- end)



--bruh
-- Ext.Entity.OnChange("Unsheath", function(entity)
--     if ClientControl == true then --bruh x2
--         return
--     end
--     -- DPrint(entity.DisplayName.Name:Get())
--     -- DPrint('Unsheath all')
--     local origins = Ext.Entity.GetAllEntitiesWithComponent('Origin')

--     for bruh = 1, #origins do
--         if entity == origins[bruh] then

--             -- DPrint(entity.DisplayName.Name:Get())
--             -- DPrint('Unsheath')

--             --tbd: AT LEAST only skin color resets, so I just need to update only it 
--             Helpers.Timer:OnTicks(30, function () --giga bruh
--                 Ext.Net.PostMessageToServer('UpdateParametersSingle', entity.Uuid.EntityUuid)
--             end)

--             Helpers.Timer:OnTicks(84, function () --giga bruh x2
--                 Ext.Net.PostMessageToServer('UpdateParametersSingle', entity.Uuid.EntityUuid)
--             end)
--         end
--     end
-- end)