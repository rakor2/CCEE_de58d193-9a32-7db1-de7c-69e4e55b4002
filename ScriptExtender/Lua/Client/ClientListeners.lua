---@diagnostic disable: param-type-mismatch


--LevelGameplayStarted
Ext.RegisterNetListener('CCEE_WhenLevelGameplayStarted', function (channel, payload, user)
    Helpers.Timer:OnTicks(100, function ()
        StartPMSub()
    end)


    Ext.Net.PostMessageToServer('CCEE_RequestMatVars', '')
    if _C() then
        CzechCCState()
        getAllParameterNames(_C())
        Helpers.Timer:OnTicks(200, function ()
            DPrint('Elements:UpdateElements')
            Elements:UpdateElements(_C().Uuid.EntityUuid)
        end)
    end
    ApplyParametersToTLPreview() --in cases like the transponder cutscenes, when cutscene starts right after gameplay started
end)



Ext.RegisterNetListener('CCEE_BroadcastMatVars', function (channel, payload, user)
    Globals.MatVars = Ext.Json.Parse(payload).MatVars
end)


-- Ext.RegisterNetListener('CCEE_UpdateParameters_OnlyVis', function (channel, payload, user)
--     DPrint('1')
--     local LastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
--     Ext.Net.BroadcastMessage('CCEE_LoadModVars', Ext.Json.Stringify(LastParameters))
-- end)

--rename me
Ext.RegisterNetListener('CCEE_MT', function (channel, payload, user)
    -- local data = Ext.Json.Parse(payload)
    -- UsedSkinUUID = data.UsedSkinUUID
    -- SkinMap = data.SkinMap
    -- MatData = data.MatData
    LoadMatVars()
end)




--TLPreviewDummy
Ext.RegisterNetListener('CCEE_LoadDollParameters',function (channel, payload, user)
    -- Helpers.Timer:OnTicks(1, function ()
    --     ApplyParametersToDolls()
    -- end)
    ApplyParametersToTLPreview()
end)


--Preset reload on mirror exit
Ext.RegisterNetListener('CCEE_CAC', function (channel, payload, user)
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
    DPrint('ClientPaperdoll|OnCreate')
    Helpers.Timer:OnTicks(5, function ()
        local owner = Paperdoll.GetDollOwner(entity)
        if owner then
            DPrint('Dummy/Doll owner: ' .. owner.DisplayName.Name:Get())
            ApplyParametersToDollsTest(entity, owner.Uuid.EntityUuid)
        end
    end)
end)

--Probably just sub to noesis Ext.UI.GetRoot():Child(1):Child(1):Child(24):Child(1).StartCharacterCreation
Ext.Entity.OnCreate("ClientEquipmentVisuals", function(entity, componentType, component)
    Helpers.Timer:OnTicks(10, function ()
    if _C().CCState and _C().CCState.HasDummy == true then
            DPrint('CEV|CC dummies')
            ApplyParametersToCCDummy(entity)
            table.insert(Globals.CC_Entities, entity)
        end
    end)
    --#region
    -- Helpers.Timer:OnTicks(40, function ()
    --     if entity:GetAllComponentNames(false)[2] == 'ecl::dummy::AnimationStateComponent' then
    --         DPrint('CEV|PM dummies')
    --         ApplyParametersToPMDummies()
    --     end
    -- end)
    --#endregion
end)







Ext.Entity.OnChange('ItemDye', function(entity) --EasyDie
    TempThingy()
    --DyeUpdates = Ext.System.ClientEquipmentVisuals.DyeUpdates
end)

Ext.Entity.OnChange('CCState', function (entityCC)
    CzechCCState(entityCC)
end)


Ext.Events.ResetCompleted:Subscribe(function()
    CzechCCState()
    LoadMatVars()
    StartPMSub()
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

-- Maybe this instead of ArmorState, Equiped, Uneqipped
Ext.Entity.OnSystemUpdate("ClientEquipmentVisuals", function()
    local UnloadRequests = Ext.System.ClientEquipmentVisuals.UnloadRequests
    for k,v in pairs(UnloadRequests) do
        -- DPrint('CEV | UnloadRequests')
        -- DDump(k)
        -- DDump(v)
        -- Utils:AntiSpam(500, function ()
        --     Ext.Net.PostMessageToServer('UpdateParameters', '')
        -- end)
    end
end)

---Fires on CC finish I think
Ext.Entity.OnSystemUpdate("ClientVisual", function()
    local ReloadVisuals = Ext.System.ClientVisual.ReloadVisuals
    for k,v in pairs(ReloadVisuals) do
        -- DPrint('Sys ClientVisual | ReloadVisuals')
        -- DDump(k)
        -- DDump(v)
    end
end)



Ext.Entity.OnSystemUpdate("ClientCharacterManager", function()
    local ReloadVisuals = Ext.System.ClientCharacterManager.ReloadVisuals
    for k,v in pairs(ReloadVisuals) do
        -- DPrint('Sys ClientCharacterManager | ReloadVisuals')
        -- DDump(k)
        -- DDump(v)
    end
end)


Ext.Entity.OnSystemUpdate("ClientVisualsVisibilityState", function()
    local UnloadVisuals = Ext.System.ClientVisualsVisibilityState.UnloadVisuals
    for k,v in pairs(UnloadVisuals) do
    end
end)

--bruh
--This shit also fires on hide/unhide T_T
--Wtf is this game
Ext.Entity.OnChange("Unsheath", function(entity)
    Utils:AntiSpam(300, function ()
            if ClientControl == true then --bruh x2
        return
    end
    local origins = Ext.Entity.GetAllEntitiesWithComponent('Origin')
    for bruh = 1, #origins do
        if entity == origins[bruh] then
            Helpers.Timer:OnTicks(30, function () --giga bruh
                Ext.Net.PostMessageToServer('CCEE_UpdateParametersSingle', entity.Uuid.EntityUuid)
            end)
            -- Helpers.Timer:OnTicks(84, function () --giga bruh x2
            --     Ext.Net.PostMessageToServer('CCEE_UpdateParametersSingle', entity.Uuid.EntityUuid)
            -- end)
        end
    end
    end)
end)