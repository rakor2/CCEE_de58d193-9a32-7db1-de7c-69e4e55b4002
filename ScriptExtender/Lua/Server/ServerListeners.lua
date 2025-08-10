---@diagnostic disable: param-type-mismatch

TICKS_TO_WAIT = 2
TICKS_TO_LOAD = 10

Globals.applyDelay = 1000

--Only sp for now
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)

    DPrint('LevelGameplayStarted')

    Helpers.ModVars.Get(ModuleUUID).CCEE_AM = Helpers.ModVars.Get(ModuleUUID).CCEE_AM or {}
    Helpers.ModVars.Get(ModuleUUID).CCEE_MP = Helpers.ModVars.Get(ModuleUUID).CCEE_MP or {}
    Helpers.ModVars.Get(ModuleUUID).CCEE_VARS = Helpers.ModVars.Get(ModuleUUID).CCEE_VARS or {}

    --Ext.Net.BroadcastMessage('CCEE_MP', Ext.Json.Stringify(Helpers.ModVars.Get(ModuleUUID).CCEE_MP))

    local data = {
        MatPresetVars = Helpers.ModVars.Get(ModuleUUID).CCEE_MP,
        ActiveMatVars = Helpers.ModVars.Get(ModuleUUID).CCEE_AM,
        CCEEModVars = Helpers.ModVars.Get(ModuleUUID).CCEE_VARS,
    }

    Ext.Net.BroadcastMessage('CCEE_WhenLevelGameplayStarted', Ext.Json.Stringify(data))

    --UpdateParameters(3, nil, false, false)
    DPrint('beep')
end)

Ext.Osiris.RegisterListener('SavegameLoadStarted', 0, "after", function ()
    DPrint('SavegameLoadStarted')
end)

Ext.Osiris.RegisterListener('SavegameLoaded', 0, "after", function ()
    DPrint('SavegameLoaded')
end)


Ext.Events.ResetCompleted:Subscribe(function()
    DPrint('ResetCompleted')
    local data = {
        MatPresetVars = Helpers.ModVars.Get(ModuleUUID).CCEE_MP,
        ActiveMatVars = Helpers.ModVars.Get(ModuleUUID).CCEE_AM,
        CCEEModVars = Helpers.ModVars.Get(ModuleUUID).CCEE_VARS,
    }
    Ext.Net.BroadcastMessage('CCEE_WhenLevelGameplayStarted', Ext.Json.Stringify(data))
end)


Ext.RegisterNetListener('CCEE_ResetAllData', function (channel, payload, user)
    Helpers.ModVars:Get(ModuleUUID).CCEE_AM = {}
    Helpers.ModVars:Get(ModuleUUID).CCEE_MP = {}
    Helpers.ModVars:Get(ModuleUUID).CCEE_VARS = {}
end)


Ext.RegisterNetListener('CCEE_RequestMatPresetVars', function (channel, payload, user)
    if Ext.IsServer() then
        local data = {
            MatPresetVars = Helpers.ModVars.Get(ModuleUUID).CCEE_MP
        }
        Ext.Net.PostMessageToUser(user, 'CCEE_BroadcastMatPresetVars', Ext.Json.Stringify(data))
    end
end)

Ext.RegisterNetListener('CCEE_RequestActiveMatVars', function (channel, payload, user)
    if Ext.IsServer() then
        local data = {
            ActiveMatVars = Helpers.ModVars.Get(ModuleUUID).CCEE_AM
        }
        Ext.Net.PostMessageToUser(user, 'CCEE_BroadcastActiveMatVars', Ext.Json.Stringify(data))
    end
end)


Ext.RegisterNetListener('CCEE_SendActiveMatVars', function (channel, payload, user)
    local ActiveMatParameters = Ext.Json.Parse(payload)
    Helpers.ModVars.Get(ModuleUUID).CCEE_AM = ActiveMatParameters
end)


Ext.RegisterNetListener('CCEE_SendMatPresetVars', function (channel, payload, user)
    local MatPresetParameters = Ext.Json.Parse(payload)
    Helpers.ModVars.Get(ModuleUUID).CCEE_MP = MatPresetParameters
end)


Ext.RegisterNetListener('CCEE_SendCCEEModVars', function (channel, payload, user)
    local CCEEModStuff = Ext.Json.Parse(payload)
    Helpers.ModVars.Get(ModuleUUID).CCEE_VARS = CCEEModStuff
end)


function WatchingMrForsenRn()
    Ext.Net.BroadcastMessage('ForceMatData', Ext.Json.Stringify(Helpers.ModVars.Get(ModuleUUID).CCEE_MP))
end

Ext.RegisterConsoleCommand('f', WatchingMrForsenRn)

Ext.RegisterNetListener('CCEE_UsedMaterialsMap', function (channel, payload, user)
    local data = Ext.Json.Parse(payload)
    if data.usedTable then
        Helpers.ModVars.Get(ModuleUUID).CCEE_VARS[data.keyUsedTable] = data.usedTable
        Helpers.ModVars.Get(ModuleUUID).CCEE_VARS[data.keyMapTable] = data.mapTable
    end
    -- if data.UsedHairUUID then
    --     Helpers.ModVars.Get(ModuleUUID).CCEE_MP['UsedHairUUID'] = data.UsedHairUUID
    --     Helpers.ModVars.Get(ModuleUUID).CCEE_MP['HairMap'] = data.HairMap
    -- end
    --local vars = Helpers.ModVars.Get(ModuleUUID).CCEE_VARS
    --Helpers.ModVars.Get(ModuleUUID).CCEE_VARS = vars
end)

--#region Apply CharacterCreationAppearance and do some other things

Ext.RegisterNetListener('CCEE_ApplySkin', function (channel, payload, user)
    --DPrint('CCEE_ApplySkin')
    local data = Ext.Json.Parse(payload)
    Ext.Entity.Get(data.uuid).CharacterCreationAppearance.SkinColor = data.ccUuid
    Ext.Entity.Get(data.uuid):Replicate('CharacterCreationAppearance')
end)


Ext.RegisterNetListener('CCEE_ApplyHair', function (channel, payload, user)
    --DPrint('CCEE_ApplyHair')
    local data = Ext.Json.Parse(payload)
    Ext.Entity.Get(data.uuid).CharacterCreationAppearance.HairColor = data.ccUuid
    Ext.Entity.Get(data.uuid):Replicate('CharacterCreationAppearance')
end)

Ext.RegisterNetListener('CCEE_SetHairZero', function (channel, payload, user)
    --DPrint('CCEE_SetHairZero')
    local entity = Ext.Entity.Get(payload)
    entity.CharacterCreationAppearance.HairColor = Utils.ZEROUUID
    entity:Replicate('CharacterCreationAppearance')
end)


Ext.RegisterNetListener('CCEE_ApplyTattoo', function (channel, payload, user)
    --DPrint('CCEE_ApplyTattoo')
    local data = Ext.Json.Parse(payload)
    Ext.Entity.Get(data.uuid).CharacterCreationAppearance.Elements[data.index].Material = data.ccUuid
    Ext.Entity.Get(data.uuid):Replicate('CharacterCreationAppearance')
end)

Ext.RegisterNetListener('CCEE_SetTattooZero', function (channel, payload, user)
    --DPrint('CCEE_SetTattooZero')
    local entity = Ext.Entity.Get(payload)
    entity.CharacterCreationAppearance.Elements[1].Material = Utils.ZEROUUID
    entity:Replicate('CharacterCreationAppearance')
end)


Ext.RegisterNetListener('CCEE_ApplyMakeUp', function (channel, payload, user)
    --DPrint('CCEE_ApplyMakeUp')
    local data = Ext.Json.Parse(payload)
    Ext.Entity.Get(data.uuid).CharacterCreationAppearance.Elements[2].Material = data.ccUuid
    Ext.Entity.Get(data.uuid):Replicate('CharacterCreationAppearance')
end)

Ext.RegisterNetListener('CCEE_SetMakeUpZero', function (channel, payload, user)
    --DPrint('CCEE_SetMakeUpZero')
    local entity = Ext.Entity.Get(payload)
    entity.CharacterCreationAppearance.Elements[2].Material = Utils.ZEROUUID
    entity:Replicate('CharacterCreationAppearance')
end)


Ext.RegisterNetListener('CCEE_ApplyScales', function (channel, payload, user)
    --DPrint('CCEE_ApplyScales')
    local data = Ext.Json.Parse(payload)
    Ext.Entity.Get(data.uuid).CharacterCreationAppearance.Elements[3].Material = data.ccUuid
    Ext.Entity.Get(data.uuid):Replicate('CharacterCreationAppearance')
end)


Ext.RegisterNetListener('CCEE_SetScalesZero', function (channel, payload, user)
    --DPrint('CCEE_SetScalesZero')
    local entity = Ext.Entity.Get(payload)
    entity.CharacterCreationAppearance.Elements[3].Material = Utils.ZEROUUID
    entity:Replicate('CharacterCreationAppearance')
end)


Ext.RegisterNetListener('CCEE_ApplyScars', function (channel, payload, user)
    --DPrint('CCEE_ApplyScars')
    local data = Ext.Json.Parse(payload)
    Ext.Entity.Get(data.uuid).CharacterCreationAppearance.Elements[6].Material = data.ccUuid
    Ext.Entity.Get(data.uuid):Replicate('CharacterCreationAppearance')
end)

Ext.RegisterNetListener('CCEE_SetScarsZero', function (channel, payload, user)
    --DPrint('CCEE_SetScarsZero')
    local entity = Ext.Entity.Get(payload)
    entity.CharacterCreationAppearance.Elements[6].Material = Utils.ZEROUUID
    entity:Replicate('CharacterCreationAppearance')
end)

--#endregion



Ext.RegisterNetListener('CCEE_UpdateParameters_OnlyVis', function (channel, payload, user)
    DPrint('CCEE_UpdateParameters_OnlyVis')
    --UpdateParameters(4, nil, false, true)
end)

Ext.RegisterNetListener('CCEE_UpdateParameters_NotOnlyVis', function (channel, payload, user) --farts second time
    DPrint('CCEE_UpdateParameters_NotOnlyVis')
    --UpdateParameters(4, nil, false, false)
end)


Ext.RegisterNetListener('CCEE_UpdateParametersSingle', function (channel, payload, user)
    DPrint('CCEE_UpdateParametersSingle')
    local entity = Ext.Entity.Get(payload)
    --UpdateParameters(30, entity, true, true)

end)

Ext.RegisterNetListener('CCEE_Apply_Delay', function (channel, payload, user)
    Globals.applyDelay = payload
end)

Ext.RegisterNetListener('CCEE_CCSate', function (channel, payload, user)
    DPrint('CCState = ' .. tostring(Ext.Json.Parse(payload)) .. ' for user: ' .. user)
end)

Ext.RegisterNetListener('CCEE_Replicate', function (channel, payload, user)
    DPrint('CCEE_Replicate')
    local entityDummy
    local entity = Ext.Json.Parse(payload)
    local CCdumies = Ext.Entity.GetAllEntitiesWithComponent("ClientCCDummyDefinition")
    Ext.Entity.Get(entity):Replicate('GameObjectVisual')
    for _,dummy in pairs(CCdumies) do
        if dummy and dummy.CCChangeAppearanceDefinition then
            if entity.DisplayName.Name:Get() == dummy.CCChangeAppearanceDefinition.Appearance.Name then
                entityDummy = dummy.ClientCCDummyDefinition.Dummy
                entityDummy:Replicate('GameObjectVisual')
            end
        end
    end
    Utils:AntiSpam(Globals.applyDelay, function ()
        UpdateParameters(4, Ext.Entity.Get(entity), true, true)
    end)
    Ext.Net.PostMessageToUser(user, 'CCEE_ConfirmWorkaround', '')
end)



Ext.RegisterNetListener('CCEE_Replicate_CCA', function (channel, payload, user)
    local entity = Ext.Json.Parse(payload)
    Ext.Entity.Get(entity):Replicate('CharacterCreationAppearance')
end)


Ext.Osiris.RegisterListener("Equipped", 2, "after", function(item, character)
    DPrint('Equipped')
    --UpdateParameters(38, Ext.Entity.Get(character), true, true)
    --local entity = Ext.Entity.Get(character)
    --Ext.Net.PostMessageToUser(entity.UserReservedFor.UserID, 'CCEE_ApplyActiveMaterialParametersToCharacter', entity.Uuid.EntityUuid)
end)


Ext.Osiris.RegisterListener("Unequipped", 2, "after", function(item, character)
    DPrint('Unequipped')
    --UpdateParameters(38, Ext.Entity.Get(character), true, true)
    local entity = Ext.Entity.Get(character)
    --Ext.Net.PostMessageToUser(entity.UserReservedFor.UserID, 'CCEE_ApplyActiveMaterialParametersToCharacter', entity.Uuid.EntityUuid)
end)


Ext.Entity.Subscribe("ArmorSetState", function(entity)
    DPrint('ArmorSetState')
    --UpdateParameters(40, Ext.Entity.Get(entity), true, true)
    --Ext.Net.PostMessageToUser(entity.UserReservedFor.UserID, 'CCEE_ApplyActiveMaterialParametersToCharacter', entity.Uuid.EntityUuid)
end)

Ext.Osiris.RegisterListener("CombatStarted", 1, "after", function(combatGuid)
    DPrint('CombatStarted')
    --UpdateParameters(2, nil, false, true)
end)

-- Ext.Osiris.RegisterListener("CombatEnded", 1, "after", function(combatGuid)
--     DPrint('CombatEnded')
--     -- Ext.Net.BroadcastMessage('LoadParameters', '')
--     UpdateParameters(2, nil, false)
-- end)

Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceId)
    DPrint('DialogStarted')
    Ext.Net.BroadcastMessage('CCEE_LoadDollParameters', '')
end)





Ext.RegisterNetListener('CCEE_Mirror', function (channel, payload, user)
    Osi.StartChangeAppearance()
end)




Ext.RegisterNetListener('CCEE_Stop', function (channel, payload, user)
    Osi.PlayLoopingAnimation(_C().Uuid.EntityUuid, "", '', "", "", "", "", "")
end)


Ext.RegisterNetListener('CCEE_dumpVars', function (channel, payload, user)
    DDump(Helpers.ModVars.Get(ModuleUUID))
end)


Ext.RegisterNetListener('CCEE_ResetCurrentCharacter', function (channel, payload, user)
    _C():Replicate('GameObjectVisual')
    _C():Replicate('CharacterCreationAppearance')
end)

Ext.RegisterNetListener('CCEE_setElementsToZero', function (channel, payload, user)
    setElementsToZero(_C())
end)



Ext.RegisterNetListener('CCEE_LoadPreset', function (channel, payload, user)
    local SkinMaterialParams
    local CCEEParams
    local DefaultCC
    local data = Ext.Json.Parse(payload)
    local entity = Ext.Entity.Get(data.uuid)

    -- DDump(data.dataLoad[1])
    SkinMaterialParams = data.dataLoad[1].SkinMaterialParams
    CCEEParams = data.dataLoad[2].CCEEParams
    DefaultCC = data.dataLoad[3].DefaultCC

        -- DDump(data.dataLoad)

        -- DDump(CCEEParams)

    Helpers.ModVars.Get(ModuleUUID).CCEE_AM[data.uuid] = CCEEParams[1]
    --local vars = Helpers.ModVars.Get(ModuleUUID).CCEE_AM
    --Helpers.ModVars.Get(ModuleUUID).CCEE_AM = vars


    if data.skinUuid and Helpers.ModVars.Get(ModuleUUID).CCEE_MP then
        entity.CharacterCreationAppearance.SkinColor = data.skinUuid
        Helpers.ModVars.Get(ModuleUUID).CCEE_MP[data.uuid][data.skinMatUuid] = SkinMaterialParams[1]
        --local varsMT = Helpers.ModVars.Get(ModuleUUID).CCEE_MP
        --Helpers.ModVars.Get(ModuleUUID).CCEE_MP = varsMT
    end


    Helpers.Timer:OnTicks(1, function ()
        for _, v in pairs(entity.CharacterCreationAppearance.Visuals) do
            Osi.RemoveCustomVisualOvirride(data.uuid, v)
            -- DPrint('RemoveCustomVisualOvirride')
        end
    end)
    Helpers.Timer:OnTicks(4, function ()
        if DefaultCC then
            for _, visUuid in pairs(DefaultCC.Visuals) do
                if visUuid then
                    Osi.AddCustomVisualOverride(data.uuid, visUuid)
                    -- DPrint('AddCustomVisualOverride')
                    -- DDump(visUuid)
                end
            end
            Helpers.Timer:OnTicks(8, function ()
                applyCharacterCreationAppearance(entity, data.dataLoad[3].DefaultCC)
            end)
            Helpers.Timer:OnTicks(12, function ()
                entity:Replicate('GameObjectVisual')
                entity:Replicate('CharacterCreationAppearance')
            end)
            Helpers.Timer:OnTicks(14, function ()
                Ext.Net.PostMessageToUser(entity.UserReservedFor.UserID, 'CCEE_ApplyMaterialPresetPararmetersToCharacter', entity.Uuid.EntityUuid)
                Helpers.Timer:OnTicks(16, function ()
                    Ext.Net.PostMessageToUser(entity.UserReservedFor.UserID, 'CCEE_ApplyActiveMaterialParametersToCharacter', entity.Uuid.EntityUuid)
                end)
            end)
        end
    end)
end)


Ext.Osiris.RegisterListener("ChangeAppearanceCompleted", 1, "after", function(character)
    DPrint('ChangeAppearanceCompleted')
    local entity = Ext.Entity.Get(character)
    entity.CharacterCreationAppearance.HairColor = Utils.ZEROUUID
    entity.CharacterCreationAppearance.Elements[4].Material = Utils.ZEROUUID
    entity.CharacterCreationAppearance.Elements[5].Material = Utils.ZEROUUID
    entity:Replicate('CharacterCreationAppearance')
    Ext.Net.PostMessageToUser(entity.UserReservedFor.UserID, 'CCEE_CAC', '')
end)

Ext.RegisterNetListener('CCEE_inCC', function (channel, payload, user)
    -- local entity = Ext.Entity.Get(Ext.Json.Parse(payload))
    -- DPrint(entity)
    -- entity.CharacterCreationAppearance.HairColor = '00000000-0000-0000-0000-000000000000'
    -- entity:Replicate('CharacterCreationAppearance')
    --edbb0710-7162-487b-9553-062bece30c1f
end)


-- Ext.Entity.OnChange('CCState', function (entityCC)
--     DPrint(entityCC)
--     entityCC.CharacterCreationAppearance.HairColor = 'edbb0710-7162-487b-9553-062bece30c1f'
--     entityCC:Replicate('CharacterCreationAppearance')
-- end)

Ext.RegisterNetListener('CCEE_ApplyCCA', function (channel, payload, user)
    local data = Ext.Json.Parse(payload)
    applyCharacterCreationAppearance(data.charEntity, data.savedAppearance)
end)

Ext.Osiris.RegisterListener("CharacterCreationStarted", 0, "after", function()
    DPrint('CharacterCreationStarted')
end)

Ext.Osiris.RegisterListener("CharacterCreationFinished", 0, "after", function()
    DPrint('CharacterCreationFinished')
end)


-- Ext.Osiris.RegisterListener("CharacterCreationStarted", 1, "after", function(character)
--     DPrint('CharacterCreationStarted')
--     DPrint(character)
-- end)




Ext.Entity.OnSystemUpdate("ServerInventoryEquipment", function()
    local Equipment = Ext.System.ServerInventoryEquipment.Equipment
    for k,v in pairs(Equipment) do
        -- DPrint('Sys ServerInventoryEquipment | Equipment')
        -- DDump(k)
        -- DDump(v)
    end
end)




--[[
Ch = {}
c = Ext.Template.GetAllRootTemplates()
for k, v in pairs(c) do
    if v.TemplateType == 'character' then
        if v.Race == '959e884c-d96c-4f09-91ea-e94a5835bf71' then
            table.insert(Ch, v)
            _P(v.Name)
        end
    end
end
]]--

