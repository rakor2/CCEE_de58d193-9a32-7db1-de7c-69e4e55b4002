---@diagnostic disable: param-type-mismatch


--LevelGameplayStarted
Ext.RegisterNetListener('CCEE_WhenLevelGameplayStarted', function (channel, payload, user)
    Globals.States.firstCC = false
    E.firstCC.Checked = false
    Globals.AllParameters.MatPresetParameters = Ext.Json.Parse(payload).MatPresetVars
    Globals.AllParameters.ActiveMatParameters = Ext.Json.Parse(payload).ActiveMatVars
    Globals.AllParameters.CCEEModStuff = Ext.Json.Parse(payload).CCEEModVars
    -- Helpers.Timer:OnTicks(100, function ()
    --     StartPMSub()
    -- end)
    if _C() then
        getAllParameterNames(_C())
        CzechCCState(nil)
        Helpers.Timer:OnTicks(10, function ()
            Apply_AllCharactersMaterialPresetPararmeters()
            Helpers.Timer:OnTicks(15, function ()
                Apply_AllCharactersActiveMaterialParameters()
                Elements:UpdateElements(_C().Uuid.EntityUuid)
            end)
        end)
    end
    Apply_TLPreviwDummiesActiveMaterialsParameters() --in cases like the transponder cutscene, when the cutscene starts right after gameplay started
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
        Apply_CharacterActiveMaterialParameters(xd.entityUuid)
        DDump(Globals.AllParameters.ActiveMatParameters)
    end)
end)


Ext.RegisterNetListener('CCEE_SendSingleMatPresetVarsToUser', function (channel, payload, user)
    local xd = Ext.Json.Parse(payload)
    SLOP:tableCheck(Globals.AllParameters, 'MatPresetParameters', xd.entityUuid, xd.materialGuid, xd.parameterType)[xd.parameterName] = xd.value
    Utils:AntiSpam(1000, function ()
        DPrint('CCEE_SendSingleMatPresetVarsToUser')
        Apply_CharacterMaterialPresetPararmeters(xd.entityUuid)
        DDump(Globals.AllParameters.MatPresetParameters)
    end)
end)




Ext.RegisterNetListener('CCEE_BroadcastCCEEModVars', function (channel, payload, user)
    --Globals.MatVars = Ext.Json.Parse(payload).MatVars
    Globals.AllParameters.CCEEModStuff = Ext.Json.Parse(payload).CCEEModVars
end)


Ext.RegisterNetListener('CCEE_ConfirmWorkaround', function (channel, payload, user)
    ConfirmWorkaround(_C())
end)


--TLPreviewDummy
Ext.RegisterNetListener('CCEE_LoadDollParameters',function (channel, payload, user)
    Apply_TLPreviwDummiesActiveMaterialsParameters()
end)

local APPLY_TICKS = 20
Ext.RegisterNetListener('CCEE_ApplyMaterialPresetPararmetersToCharacter', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        Apply_CharacterMaterialPresetPararmeters(payload)
        Ext.Net.PostMessageToServer('CCEE_SendMatPresetVars', Ext.Json.Stringify(Globals.AllParameters.MatPresetParameters))
    end)
end)

Ext.RegisterNetListener('CCEE_ApplyMaterialPresetPararmetersAllCharacters', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        Apply_AllCharactersMaterialPresetPararmeters()
        Ext.Net.PostMessageToServer('CCEE_SendMatPresetVars', Ext.Json.Stringify(Globals.AllParameters.MatPresetParameters))
    end)
end)

Ext.RegisterNetListener('CCEE_ApplyActiveMaterialParametersToCharacter', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
    -- _C().Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].Enabled = true
    -- _C().Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].ID = '67c3ace1-7ec1-6426-3ba9-91d4cf2f0e8e'
    --Ext.Resource.Get('6cf160fe-f568-9b7f-6ac9-0b9941b5952a', 'Material').Instance.Parameters.Texture2DParameters[2].ID = '67c3ace1-7ec1-6426-3ba9-91d4cf2f0e8e'
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()


        Apply_CharacterActiveMaterialParameters(payload)

        Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(Globals.AllParameters.ActiveMatParameters))
    end)
end)

Ext.RegisterNetListener('CCEE_ApplyActiveMaterialParametersToAllCharacters', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        Apply_AllCharactersActiveMaterialParameters()
        Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(Globals.AllParameters.ActiveMatParameters))
    end)
end)

--Preset reload on mirror exit
Ext.RegisterNetListener('CCEE_CAC', function (channel, payload, user)
    --setTexture('9216fcc5-1a18-c0f2-3d2f-3214d2477761', '67c3ace1-7ec1-6426-3ba9-91d4cf2f0e8e')
    RealodPreset()
end)



--Client Control
Ext.Entity.OnCreate('ClientControl', function(entity, ct, c)
    Apply.entity = entity
    getAllParameterNames(Apply.entity)
    if E.checkTests.Checked then
        sepate:Destroy()
        testParams2:Destroy()
        CCEE:Tests()
    end
    ClientControl = true
    Elements:UpdateElements(entity.Uuid.EntityUuid)
    Helpers.Timer:OnTicks(5, function ()
        ClientControl = false
    end)
end)

--Paperdoll
--TBD: make a check for transparent doll
Ext.Entity.OnCreate("ClientPaperdoll", function(entity, componentType, component)
    Utils:AntiSpam(100, function ()
        DPrint('ClientPaperdoll|OnCreate')
    end)
    Helpers.Timer:OnTicks(5, function ()
        local owner = Paperdoll.GetDollOwner(entity)
        if owner then
            DPrint('Dummy/Doll owner: ' .. owner.DisplayName.Name:Get())
            Apply_DollsActiveMaterialParameters(entity, owner.Uuid.EntityUuid)
        end
    end)
end)

--Probably just sub to noesis Ext.UI.GetRoot():Child(1):Child(1):Child(24):Child(1).StartCharacterCreation
Ext.Entity.OnCreate('ClientEquipmentVisuals', function(entity, componentType, component)
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
                Apply_FirstCCDummyVActiveMaterialsParameters(getFirsCCDummy())
            else
                Apply_CCDummyVActiveMaterialsParameters(entity)
                table.insert(Globals.CC_Entities, entity)
            end
        end
    end)
end)

--PM dummies
Ext.Entity.OnCreate('PhotoModeSession', function ()
    Helpers.Timer:OnTicks(40, function ()
        Utils:AntiSpam(100, function ()
            Apply_PMDummiesActiveMaterialParameters()
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
        Apply_CharacterActiveMaterialParameters(entity.Uuid.EntityUuid)
    end)
end)

Ext.Entity.OnChange('CCState', function (entityCC)
    CzechCCState(entityCC)
end)




--bruh
--This shit fires from everything, because there are no internal checks if a character actually holds a gun
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
                    Apply_CharacterActiveMaterialParameters(entity.Uuid.EntityUuid)
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
            if E.iconVanity.Checked then
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


-- Ext.Events.ResetCompleted:Subscribe(function()
--     Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
--     Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
--     Globals.justReseted = true
--     Helpers.Timer:OnTicks(50, function ()
--         Globals.justReseted = false
--     end)
--     CzechCCState(nil)
--     StartPMSub()
--     Apply_CharacterAllActiveMaterialParametersTo()
-- end)


--Systems

-- Ext.Entity.OnSystemUpdate("ClientEquipmentVisuals", function()

--     local visuals = Ext.System.ClientEquipmentVisuals.DyeUpdates
--     for k, entity in pairs(visuals) do
--         DPrint('DyeUpdates')
--         DPrint(entity)
--     end

-- end)



-- Ext.Entity.OnSystemUpdate("ClientCh=racterManager", function()

--     local visuals = Ext.System.ClientVisualsVisibilityState.UnloadVisuals
--     for entity, v in pairs(visuals) do
--         DPrint('1')
--         DDump(v)
--         -- DPrint('ClientCharacterManager')
--         DPrint(entity)
--     end

-- end)

-- Maybe this instead of ArmorState, Equiped, Uneqipped
-- Ext.Entity.OnSystemUpdate("ClientEquipmentVisuals", function()
--     local UnloadRequests = Ext.System.ClientEquipmentVisuals.UnloadRequests
--     for k,v in pairs(UnloadRequests) do
--         -- DPrint('CEV | UnloadRequests')
--         -- DDump(k)
--         -- DDump(v)
--         -- Utils:AntiSpam(500, function ()
--         --     Ext.Net.PostMessageToServer('UpdateParameters', '')
--         -- end)
--     end
-- end)

---Fires on CC finish I think
-- Ext.Entity.OnSystemUpdate("ClientVisual", function()
--     local ReloadVisuals = Ext.System.ClientVisual.ReloadVisuals
--     for k,v in pairs(ReloadVisuals) do
--         -- DPrint('Sys ClientVisual | ReloadVisuals')
--         -- DDump(k)
--         -- DDump(v)
--     end
-- end)



-- Ext.Entity.OnSystemUpdate("ClientCharacterManager", function()
--     local ReloadVisuals = Ext.System.ClientCharacterManager.ReloadVisuals
--     for k,v in pairs(ReloadVisuals) do
--         -- DPrint('Sys ClientCharacterManager | ReloadVisuals')
--         -- DDump(k)
--         -- DDump(v)
--     end
-- end)


-- Ext.Entity.OnSystemUpdate("ClientVisualsVisibilityState", function()
--     local UnloadVisuals = Ext.System.ClientVisualsVisibilityState.UnloadVisuals
--     for k,v in pairs(UnloadVisuals) do
--     end
-- end)






-- Channels.xd:SetHandler(function (data, user)
--     DPrint('Hello from client')
--     DDump(data)
-- end)



-- Channels.xd:SetRequestHandler(function (data, user)
--     DPrint('Hello from SetRequestHandler client ')
--     DDump(data)
--     return true
-- end)



-- function NetTestClient()
--     local payload = {1,2}
--     Channels.xd:SendToServer(payload)
--     Channels.xd:RequestToServer(payload, function (data)
--         DDump(data.RequestData)
--     end)
-- end

