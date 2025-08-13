---@diagnostic disable: param-type-mismatch


--LevelGameplayStarted
Ext.RegisterNetListener('CCEE_WhenLevelGameplayStarted', function (channel, payload, user)
    Globals.States.firstCC = false
    GlobalsIMGUI.firstCC.Checked = false
    Globals.AllParameters.MatPresetParameters = Ext.Json.Parse(payload).MatPresetVars
    Globals.AllParameters.ActiveMatParameters = Ext.Json.Parse(payload).ActiveMatVars
    Globals.AllParameters.CCEEModStuff = Ext.Json.Parse(payload).CCEEModVars

    -- Helpers.Timer:OnTicks(100, function ()
    --     StartPMSub()
    -- end)

    if _C() then
        CzechCCState(nil)
        getAllParameterNames(_C())
        Helpers.Timer:OnTicks(10, function ()
            ApplyMaterialPresetPararmetersToAllCharacters()
            Helpers.Timer:OnTicks(15, function ()
                ApplyActiveMaterialParametersToAllCharacters()
                Elements:UpdateElements(_C().Uuid.EntityUuid)
            end)
        end)
    end
    ApplyParametersToTLPreview() --in cases like the transponder cutscenes, when the cutscene starts right after gameplay started
end)



Ext.RegisterNetListener('CCEE_BroadcastMatPresetVars', function (channel, payload, user)
    --Globals.MatVars = Ext.Json.Parse(payload).MatVars
    Globals.AllParameters.MatPresetParameters = Ext.Json.Parse(payload).MatPresetVars
end)

Ext.RegisterNetListener('CCEE_BroadcastActiveMatVars', function (channel, payload, user)
    --Globals.MatVars = Ext.Json.Parse(payload).MatVars
    Globals.AllParameters.ActiveMatParameters = Ext.Json.Parse(payload).ActiveMatVars
end)




Ext.RegisterNetListener('CCEE_SendSingleActiveMatVarsToUser', function (channel, payload, user)
    local xd = Ext.Json.Parse(payload)
    SLOP:tableCheck(Globals.AllParameters, 'ActiveMatParameters', xd.entityUuid, xd.attachment, xd.parameterType)[xd.parameterName] = xd.value
    Utils:AntiSpam(1000, function ()
        DPrint('CCEE_SendSingleActiveMatVarsToUser')
        ApplyActiveMaterialParametersToCharacter(xd.entityUuid)
        DDump(Globals.AllParameters.ActiveMatParameters)
    end)
end)


Ext.RegisterNetListener('CCEE_SendSingleMatPresetVarsToUser', function (channel, payload, user)
    local xd = Ext.Json.Parse(payload)
    SLOP:tableCheck(Globals.AllParameters, 'MatPresetParameters', xd.entityUuid, xd.materialGuid, xd.parameterType)[xd.parameterName] = xd.value
    Utils:AntiSpam(1000, function ()
        DPrint('CCEE_SendSingleMatPresetVarsToUser')
        ApplyMaterialPresetPararmetersToCharacter(xd.entityUuid)
        DDump(Globals.AllParameters.MatPresetParameters)
    end)
end)




Ext.RegisterNetListener('CCEE_BroadcastCCEEModVars', function (channel, payload, user)
    --Globals.MatVars = Ext.Json.Parse(payload).MatVars
    Globals.AllParameters.CCEEModStuff = Ext.Json.Parse(payload).CCEEModVars
end)


-- Ext.RegisterNetListener('CCEE_UpdateParameters_OnlyVis', function (channel, payload, user)
--     DPrint('1')
--     local ActiveMatParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
--     Ext.Net.BroadcastMessage('CCEE_LoadModVars', Ext.Json.Stringify(ActiveMatParameters))
-- end)

--rename me
-- Ext.RegisterNetListener('CCEE_MP', function (channel, payload, user)
--     -- local data = Ext.Json.Parse(payload)
--     -- UsedSkinUUID = data.UsedSkinUUID
--     -- SkinMap = data.SkinMap
--     -- MatData = data.MatData
    
-- end)

Ext.RegisterNetListener('CCEE_ConfirmWorkaround', function (channel, payload, user)
    ConfirmWorkaround(_C())
end)


--TLPreviewDummy
Ext.RegisterNetListener('CCEE_LoadDollParameters',function (channel, payload, user)
    -- Helpers.Timer:OnTicks(1, function ()
    --     ApplyParametersToDolls()
    -- end)
    ApplyParametersToTLPreview()
end)

local APPLY_TICKS = 20
Ext.RegisterNetListener('CCEE_ApplyMaterialPresetPararmetersToCharacter', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        ApplyMaterialPresetPararmetersToCharacter(payload)
        Ext.Net.PostMessageToServer('CCEE_SendMatPresetVars', Ext.Json.Stringify(Globals.AllParameters.MatPresetParameters))
    end)
end)

Ext.RegisterNetListener('CCEE_ApplyMaterialPresetPararmetersAllCharacters', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        DPrint(payload)
        ApplyMaterialPresetPararmetersToAllCharacters()
        Ext.Net.PostMessageToServer('CCEE_SendMatPresetVars', Ext.Json.Stringify(Globals.AllParameters.MatPresetParameters))
    end)
end)

Ext.RegisterNetListener('CCEE_ApplyActiveMaterialParametersToCharacter', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        ApplyActiveMaterialParametersToCharacter(payload)
        Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(Globals.AllParameters.ActiveMatParameters))
    end)
end)

Ext.RegisterNetListener('CCEE_ApplyActiveMaterialParametersToAllCharacters', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        ApplyActiveMaterialParametersToAllCharacters()
        Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(Globals.AllParameters.ActiveMatParameters))
    end)
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
    Utils:AntiSpam(100, function ()
        DPrint('ClientPaperdoll|OnCreate')
    end)
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
    --Mods.Luas._DD(entity, '_First_CC', true)
    --Mods.Luas._DD(entity.ClientPaperdoll.Entity, '_First_CC2', true)
    --Mods.Luas._DD(entity.ClientPaperdoll.Entity.ClientCharacterIconRequest.field_190, '_First_CC3', true)
    --Mods.Luas._DD(entity.ClientPaperdoll.Entity.ClientCharacterIconRequest.field_190.ClientCCDefinitionState.Entity, '_First_CC4', true)
    --Globals.States.firstCCDummy = entity.ClientPaperdoll.Entity.ClientCharacterIconRequest.field_190.ClientCCDummyDefinition.Dummy
    --DPrint(Globals.States.firstCCDummy)
    local timer
    if Globals.States.firstCC == true then
        timer = 10
    else
        timer = 40
    end
    Helpers.Timer:OnTicks(timer, function ()
    if (_C().CCState and _C().CCState.HasDummy == true) or Globals.States.firstCC == true then
        Utils:AntiSpam(100, function ()
            DPrint('CEV|CC dummies')
        end)
            if Globals.States.firstCC then
                ApplyParametersToVisibleFirstCCDummy(getFirsCCDummy())
            else
                ApplyParametersToVisibleCCDummy(entity)
                table.insert(Globals.CC_Entities, entity)
            end
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

--PM dummies
Ext.Entity.OnCreate('PauseExcluded', function ()
    Helpers.Timer:OnTicks(40, function ()
        Utils:AntiSpam(100, function ()
            ApplyParametersToPMDummies()
        end)
    end)
end)


Ext.Events.ResetCompleted:Subscribe(function()
    Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
end)


Ext.Entity.OnChange('ItemDye', function(entity) --EasyDie
    --TempThingy()
    --DyeUpdates = Ext.System.ClientEquipmentVisuals.DyeUpdates
    Utils:AntiSpam(500, function ()
        DPrint('ItemDye')
        --Ext.Net.PostMessageToServer('CCEE_UpdateParameters_NotOnlyVis', '')
        getAllParameterNames(_C())
        ApplyActiveMaterialParametersToCharacter(entity.Uuid.EntityUuid)
    end)
end)

Ext.Entity.OnChange('CCState', function (entityCC)
    CzechCCState(entityCC)
end)


-- Ext.Events.ResetCompleted:Subscribe(function()
--     Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
--     Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
--     Globals.justReseted = true
--     Helpers.Timer:OnTicks(50, function ()
--         Globals.justReseted = false
--     end)
--     CzechCCState(nil)
--     StartPMSub()
--     ApplyActiveMaterialParametersToAllCharacters()
-- end)


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
    if Globals.justReseted then return end
    Utils:AntiSpam(300, function ()
            if ClientControl == true then --bruh x2
        return
    end
    local origins = Ext.Entity.GetAllEntitiesWithComponent('Origin')
    for bruh = 1, #origins do
        if entity == origins[bruh] then
            Helpers.Timer:OnTicks(30, function () --giga bruh
                if entity.Uuid then

                    ApplyActiveMaterialParametersToCharacter(entity.Uuid.EntityUuid)

                end
                    --Ext.Net.PostMessageToServer('CCEE_UpdateParametersSingle', entity.Uuid.EntityUuid)
            end)
            -- Helpers.Timer:OnTicks(84, function () --giga bruh x2
            --     Ext.Net.PostMessageToServer('CCEE_UpdateParametersSingle', entity.Uuid.EntityUuid)
            -- end)
        end
    end
    end)
end)


--Thx LL for investigation 
local function OnClientCharacterIconRender()
    local system = Ext.System.ClientCharacterIconRender
    local totalRequests = #system.IconRequests
    if totalRequests > 0 then
        for _,v in pairs(system.IconRequests) do
            local req = v.ClientCharacterIconRequest --[[@as EclCharacterIconRequestComponent]]
            --req.Trigger = 'Icon_Minthara' --'Icon_Origin_Astarion' --"Icon_SCL_HAV_HalsinPortal"
            --req.Template = "05047890-4138-40b5-9d8d-3ccb9d10e434"
            --req.Visual = "cc86c035-ec2b-1ab3-4d8d-5d39092c908c"

            if GlobalsIMGUI.iconVanity.Checked then
                req.ArmorSetState = "Vanity"
            else
                req.ArmorSetState = "Normal"
            end
        end
    end
end

Ext.Events.SessionLoaded:Subscribe(function (e)
    Ext.Entity.OnSystemUpdate("ClientCharacterIconRender", OnClientCharacterIconRender)
end)



Ext.Events.ResetCompleted:Subscribe(function()

end)