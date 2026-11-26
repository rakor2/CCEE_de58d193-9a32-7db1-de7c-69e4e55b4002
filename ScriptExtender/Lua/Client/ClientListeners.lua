---@diagnostic disable: param-type-mismatch


--LevelGameplayStarted
Ext.RegisterNetListener('CCEE_WhenLevelGameplayStarted', function (channel, payload, user)
    _GLL.States.firstCC = false
    -- E.firstCC.Checked = false
    _GLL.AllParameters.MatPresetParameters = Ext.Json.Parse(payload).MatPresetVars
    _GLL.AllParameters.ActiveMatParameters = Ext.Json.Parse(payload).ActiveMatVars
    _GLL.AllParameters.CCEEModStuff = Ext.Json.Parse(payload).CCEEModVars
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
    --_GLL.MatVars = Ext.Json.Parse(payload).MatVars
    _GLL.AllParameters.MatPresetParameters = Ext.Json.Parse(payload).MatPresetVars
end)

Ext.RegisterNetListener('CCEE_BroadcastActiveMatVars', function (channel, payload, user)
    --_GLL.MatVars = Ext.Json.Parse(payload).MatVars
    _GLL.AllParameters.ActiveMatParameters = Ext.Json.Parse(payload).ActiveMatVars
end)




Ext.RegisterNetListener('CCEE_SendSingleActiveMatVarsToUser', function (channel, payload, user)
    local xd = Ext.Json.Parse(payload)
    Utils:EnsureTable(_GLL.AllParameters, 'ActiveMatParameters', xd.entityUuid, xd.attachment, xd.parameterType)[xd.parameterName] = xd.value
    Utils:AntiSpam(1000, function ()
        -- DPrint('CCEE_SendSingleActiveMatVarsToUser')
        Apply_CharacterActiveMaterialParameters(xd.entityUuid)
        -- DDump(_GLL.AllParameters.ActiveMatParameters)
    end)
end)


Ext.RegisterNetListener('CCEE_SendSingleMatPresetVarsToUser', function (channel, payload, user)
    local xd = Ext.Json.Parse(payload)
    Utils:EnsureTable(_GLL.AllParameters, 'MatPresetParameters', xd.entityUuid, xd.materialGuid, xd.parameterType)[xd.parameterName] = xd.value
    Utils:AntiSpam(1000, function ()
        -- DPrint('CCEE_SendSingleMatPresetVarsToUser')
        Apply_CharacterMaterialPresetPararmeters(xd.entityUuid)
        DDump(_GLL.AllParameters.MatPresetParameters)
    end)
end)




Ext.RegisterNetListener('CCEE_BroadcastCCEEModVars', function (channel, payload, user)
    --_GLL.MatVars = Ext.Json.Parse(payload).MatVars
    _GLL.AllParameters.CCEEModStuff = Ext.Json.Parse(payload).CCEEModVars
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
        Ext.Net.PostMessageToServer('CCEE_SendMatPresetVars', Ext.Json.Stringify(_GLL.AllParameters.MatPresetParameters))
    end)
end)

Ext.RegisterNetListener('CCEE_ApplyMaterialPresetPararmetersAllCharacters', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        Apply_AllCharactersMaterialPresetPararmeters()
        Ext.Net.PostMessageToServer('CCEE_SendMatPresetVars', Ext.Json.Stringify(_GLL.AllParameters.MatPresetParameters))
    end)
end)

Ext.RegisterNetListener('CCEE_ApplyActiveMaterialParametersToCharacter', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
    -- _C().Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].Enabled = true
    -- _C().Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].ID = '67c3ace1-7ec1-6426-3ba9-91d4cf2f0e8e'
    --Ext.Resource.Get('6cf160fe-f568-9b7f-6ac9-0b9941b5952a', 'Material').Instance.Parameters.Texture2DParameters[2].ID = '67c3ace1-7ec1-6426-3ba9-91d4cf2f0e8e'
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        DDump(payload)
        Apply_CharacterActiveMaterialParameters(payload)
        Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(_GLL.AllParameters.ActiveMatParameters))
    end)
    pcall(function() FindE2() end)
end)

Ext.RegisterNetListener('CCEE_ApplyActiveMaterialParametersToAllCharacters', function (channel, payload, user)
    Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
    Helpers.Timer:OnTicks(APPLY_TICKS, function ()
        Apply_AllCharactersActiveMaterialParameters()
        Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(_GLL.AllParameters.ActiveMatParameters))
    end)
end)

--Preset reload on mirror exit
Ext.RegisterNetListener('CCEE_CAC', function (channel, payload, user)
    --setTexture('9216fcc5-1a18-c0f2-3d2f-3214d2477761', '67c3ace1-7ec1-6426-3ba9-91d4cf2f0e8e')
    RealodPreset()
end)



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
    pcall(function() FindE2() end)
end)



--Paperdoll
--TBD: make a check for transparent doll
Ext.Entity.OnCreate("ClientPaperdoll", function(entity, componentType, component)
    Utils:AntiSpam(100, function ()
        -- DPrint('ClientPaperdoll|OnCreate')
    end)
    Helpers.Timer:OnTicks(5, function ()
        local owner = Paperdoll.GetDollOwner(entity)
        if owner and owner.Uuid then
            -- DPrint('Dummy/Doll owner: ' .. owner.DisplayName.Name:Get())
            Apply_DollsActiveMaterialParameters(entity, owner.Uuid.EntityUuid)
        end
        pcall(function() FindE2() end)
    end)
end)



--Probably just sub to noesis Ext.UI.GetRoot():Child(1):Child(1):Child(24):Child(1).StartCharacterCreation
Ext.Entity.OnCreate('ClientEquipmentVisuals', function(entity, componentType, component)
    local timer
    if _GLL.States.firstCC == true then
        timer = 10
    else
        timer = 40
    end
    Helpers.Timer:OnTicks(timer, function ()
    if (_C().CCState and _C().CCState.HasDummy == true) or _GLL.States.firstCC == true then
        Utils:AntiSpam(100, function ()
            -- DPrint('CEV|CC dummies')
        end)
            if _GLL.States.firstCC then
                Apply_FirstCCDummyVActiveMaterialsParameters(getFirsCCDummy())
            else
                Apply_CCDummyVActiveMaterialsParameters(entity)
                table.insert(_GLL.CC_Entities, entity)
            end
        end
    end)
    pcall(function()
        FindE2()
        SetActiveMaterialParameterValue(entity, 'NakedBody', 'IsTav', 'ScalarParameters', 1, nil)
    end)
end)



Ext.Events.ResetCompleted:Subscribe(function()
    Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
    Ext.Net.PostMessageToServer('CCEE_RequestCCEEModVars', '')
end)



Ext.Entity.OnChange('ItemDye', function(entity) --EasyDie
    Utils:AntiSpamOnTicks(10, function()
        -- DPrint('ItemDye')
        if entity.InventoryMember then
            local owner = entity.InventoryMember.Inventory.InventoryIsOwned.Owner
            getAllParameterNames(owner)
            Ext.Timer.WaitFor(50, function()
                Apply_CharacterActiveMaterialParameters(owner.Uuid.EntityUuid)
            end)
        end
    end)
end)

Ext.Entity.OnChange('CCState', function (entityCC)
    CzechCCState(entityCC)
end)



--bruh
--This shit fires from everything, because there are no internal checks if a character actually holds a gun
--Wtf is this game
-- Ext.Entity.OnChange("Unsheath", function(entity)
--     if _GLL.justReseted then return end
--     Utils:AntiSpam(300, function ()
--             if ClientControl == true then --bruh x2
--         return
--     end
--     local origins = Ext.Entity.GetAllEntitiesWithComponent('Origin')
--     for bruh = 1, #origins do
--         if entity == origins[bruh] then
--             Helpers.Timer:OnTicks(30, function () --giga bruh
--                 if entity.Uuid then
--                     Apply_CharacterActiveMaterialParameters(entity.Uuid.EntityUuid)
--                 end
--                     --Ext.Net.PostMessageToServer('CCEE_UpdateParametersSingle', entity.Uuid.EntityUuid)
--             end)
--             -- Helpers.Timer:OnTicks(84, function () --giga bruh x2
--             --     Ext.Net.PostMessageToServer('CCEE_UpdateParametersSingle', entity.Uuid.EntityUuid)
--             -- end)
--         end
--     end
--         pcall(function() FindE2() end)
--     end)
-- end)



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



local DEFAULT_DIFFUSION = '3428c9e0-de61-cc06-2476-4c56b84d473d'
local CCEE_DIFFUSION    = 'a8c42087-d32f-9cbe-6b0c-d566de6a082d'

--PM dummies
Ext.Entity.OnCreate('PhotoModeSession', function ()
    _GLL.inPhotoMode = true


    local Origins = Entity:GetOrigins()
    for _, origin in pairs(Origins) do
        if not origin.ShapeshiftReplicatedChanges
            and not origin.ShapeshiftReplicatedChanges.VisualChanged then
            for i = 1, 2 do
                local Attachments = origin.Visual
                    and origin.Visual.Visual
                    and origin.Visual.Visual.Attachments
                    and origin.Visual.Visual.Attachments[i]

                if Attachments and Attachments.Visual and Attachments.Visual.ObjectDescs and Attachments.Visual.ObjectDescs[1] then
                    Attachments.Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.DiffusionProfileUUID = DEFAULT_DIFFUSION
                end
             end
        end
    end

    Helpers.Timer:OnTicks(40, function ()
        if _C().HasDummy then
            Apply.entity = _C().HasDummy.Entity
            -- LoadParametersToAllDummies()

            Apply_PMDummiesActiveMaterialParameters()
            pcall(function()
                FindE2()
            end)
        end

        local Dummies = Dummy:GetAll()
        for _, dummy in pairs(Dummies) do
            for i = 1, 2 do
                local Attachments = dummy.Visual.Visual.Attachments[i]
                if Attachments then
                    Attachments.Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.DiffusionProfileUUID = CCEE_DIFFUSION
                end
            end
            SetActiveMaterialParameterValue(dummy, 'NakedBody', 'IsTav', 'ScalarParameters', 1, nil)
        end

    end)
end)



Ext.Entity.OnDestroy('PhotoModeSession', function()
    _GLL.inPhotoMode = false
    Apply.entity = _C()
    Apply_AllCharactersMaterialPresetPararmeters()
    Helpers.Timer:OnTicks(20, function ()
        Apply_AllCharactersActiveMaterialParameters()
        pcall(function() FindE2() end)
    end)
end)


-- Ext.Events.ResetCompleted:Subscribe(function()
--     Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
--     Ext.Net.PostMessageToServer('CCEE_RequestActiveMatVars', '')
--     _GLL.justReseted = true
--     Helpers.Timer:OnTicks(50, function ()
--         _GLL.justReseted = false
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
