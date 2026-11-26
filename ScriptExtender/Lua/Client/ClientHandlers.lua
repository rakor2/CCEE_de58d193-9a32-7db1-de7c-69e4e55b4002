CCEE = {}
Window = {}
Tests = {}
Elements = {}


Parameters = Parameters or {}


_GLL.AllParameters = {}
_GLL.AllParameters.ActiveMatParameters = {}
_GLL.AllParameters.MatPresetParameters = {}
_GLL.AllParameters.CCEEModStuff = {}



_GLL.AllParameters.CCEEModStuff = {}
_GLL.AllParameters.CCEEModStuff.SkinMap = {}
_GLL.AllParameters.CCEEModStuff.HairMap = {}
_GLL.AllParameters.CCEEModStuff.UsedSkinUUID = {}
_GLL.AllParameters.CCEEModStuff.UsedHairUUID = {}


_GLL.States = {}


_GLL.CC_Entities = {}


_GLL.States.FirstCCcharacters = _GLL.States.FirstCCcharacters or {}



---Counts all available tats, makes, scars
--tbd: pairs ipairs or some shit
function MoneyCounter(type)
    tattooCount = 0
    makeupCount = 0
    scarCount = 0
    customCount = 0
    -- local kavtCount = 0

        for _,v in ipairs(Ext.StaticData.GetAll('CharacterCreationAppearanceMaterial')) do
            local name = Ext.StaticData.Get(v, 'CharacterCreationAppearanceMaterial').Name
                if name:lower():find('tattoo') then
                    tattooCount = tattooCount + 1
                    -- if name:lower():find('kaz') then
                    --     kavtCount = kavtCount + 1
                    -- end
                    -- tattoes = tattooCount - kavtCount
            end
        end
        for _,v in ipairs(Ext.StaticData.GetAll('CharacterCreationAppearanceMaterial')) do
            local name = Ext.StaticData.Get(v, 'CharacterCreationAppearanceMaterial').Name
            if name:lower():find('make') then
                makeupCount = makeupCount + 1
            end
        end
        for _,v in ipairs(Ext.StaticData.GetAll('CharacterCreationAppearanceMaterial')) do
            local name = Ext.StaticData.Get(v, 'CharacterCreationAppearanceMaterial').Name
            if name:lower():find('scar') then
                scarCount = scarCount + 1
            end
        end
        for _,v in ipairs(Ext.StaticData.GetAll('CharacterCreationAppearanceMaterial')) do
            local name = Ext.StaticData.Get(v, 'CharacterCreationAppearanceMaterial').Name
            if name:lower():find('passive') then
                customCount = customCount + 1
            end
        end
        -- DPrint(customCount)
        -- DPrint(tattooCount)
end
MoneyCounter()



---Checks if character is in the mirror (for some reason the osi listeners don't return characters)
---and also does some bs
---@param entity EntityHandle
---@return EntityHandle #If user in the mirror returns visually seen СС dummy entity, if not - _C()
function CzechCCState(entity)

    -- DPrint('CzechCCState')
    Helpers.Timer:OnTicks(20, function ()
        if _C() and _C().CCState and _C().CCState.HasDummy == false then
            -- DPrint('Not in the mirror')
            _GLL.States.CCState = false
            _GLL.States.firstCC = false
            Apply.entity = _C()
            --DPrint('HasDummy = ' .. tostring(CCState))
            -- DPrint('Apply entity' .. ' - ' .. tostring(Apply.entity))
            Ext.Net.PostMessageToServer('CCEE_CCSate', Ext.Json.Stringify(_GLL.States.CCState))
            E.stateStatus.Label = 'Not in the mirror'
            return _C()



        --First CC

        elseif Ext.Entity.Get('e2badbf0-159a-4ef5-9e73-7bbeb3d1015a')
            or Ext.Entity.Get('aa772968-b5e0-4441-8d86-2d0506b4aab5')
            or Ext.Entity.Get('81c48711-d7cc-4a3d-9e49-665eb915c15c')
            or Ext.Entity.Get('6bff5419-5a9e-4839-acd4-cac4f6e41bd7') then
            -- DPrint('In the first CC')
            _GLL.States.CCState = true
            _GLL.States.firstCC = true
            -- DPrint('Waiting for the dummy to be created')
            Utils:SubUnsubToTick('sub', 'FirstCC', function ()
                if getFirsCCDummy() then
                    Apply.entity = getFirsCCDummy()
                    -- DPrint('Apply entity' .. ' - ' .. tostring(Apply.entity))
                    table.insert(_GLL.States.FirstCCcharacters, _C().Uuid.EntityUuid)
                    E.stateStatus.Label = 'In the first CC'
                    if Apply.entity then
                        Utils:SubUnsubToTick('unsub', 'FirstCC', nil)
                    end
                end
            end)
        else


        --Mirror

            -- DPrint('In the mirror')
            _GLL.States.CCState = true
            _GLL.States.firstCC = false
            local dummy = getCCDummy(_C())
            if dummy then
                Apply_CCDummyVActiveMaterialsParameters(entity) --V for visible
                ConfirmWorkaround(_C())
                _GLL.dummyEntity = dummy.ClientCCDummyDefinition.Dummy
                Apply.entity = dummy.ClientCCDummyDefinition.Dummy
                --DPrint('HasDummy = ' .. tostring(CCState))
                -- DPrint('Apply entity' .. ' - ' .. tostring(Apply.entity))
                Ext.Net.PostMessageToServer('CCEE_CCSate', Ext.Json.Stringify(_GLL.States.CCState))
                E.stateStatus.Label = 'In the mirror'
            end
            return _GLL.dummyEntity
        end
    end)
end


--Fires on mirror visuals
-- local entityXd = _C()
-- Ext.Entity.OnSystemUpdate("ClientCharacterManager", function()
--     local sys = Ext.System.ClientCharacterManager.ReloadVisuals[entityXd]
--     if sys == true then
--         DPrint('ReloadVisuals: ' .. tostring(sys))
--     end
-- end)


-- Ext.Entity.OnSystemUpdate("ClientEquipmentVisuals", function()
--     local sys = Ext.System.ClientEquipmentVisuals.UnloadRequests
--     for k, v in pairs(sys) do
--         DPrint('UnloadRequests')
--         DDump(v)
--         DPrint('-----------')
--     end
-- end)

-- Ext.Entity.OnSystemUpdate("ClientVisualsVisibilityState", function()
--     local sys = Ext.System.ClientCharacterManager.UpdateRepose
--     for k, v in pairs(sys) do
--         DPrint('UpdateRepose')
--         DDump(k)
--         DDump(v)
--         DPrint('-----------')
--     end
-- end)


---Invalid UUID non-clickable Confirm workaround
---It's just sets valid default UUIDs to CC dummy
---Don't know if the indecies? indexes? are static
function ConfirmWorkaround(entity)
    if _GLL.States.CCState == true then
        local dummy = getCCDummy(entity)
        if dummy then
            local DummyVisual = dummy.ClientCCChangeAppearanceDefinition.Definition.Visual
            local EntityCCA = entity.CharacterCreationAppearance

            --Hair Color
            if EntityCCA.HairColor == Utils.ZEROUUID then
                DummyVisual.HairColor = 'edbb0710-7162-487b-9553-062bece30c1f'
            else
                -- DPrint('HairColor: ' .. DummyVisual.HairColor)
            end

            --Face Tattoo
            if EntityCCA.Elements[1].Material == Utils.ZEROUUID then
                DummyVisual.Elements[1].Material = '00894ccc-31ee-4527-94d5-a408cccb3583'
            else
                -- DPrint('Face: ' .. DummyVisual.Elements[1].Material)
            end

            --Makeup
            if EntityCCA.Elements[2].Material == Utils.ZEROUUID then
                DummyVisual.Elements[2].Material = '503bb196-fee7-4e1b-8a58-c09f48bdc9d1'
            else
                -- DPrint('Makeup: ' .. DummyVisual.Elements[2].Material)
            end

            --Scales
            if EntityCCA.Elements[3].Material == Utils.ZEROUUID then
                DummyVisual.Elements[3].Material = 'f03b33ae-5d47-4cb5-80bc-ea06a3c55c96'
            else
                -- DPrint('Scales: ' .. DummyVisual.Elements[3].Material)
            end

            --Graying
            if EntityCCA.Elements[4].Material == Utils.ZEROUUID then
                DummyVisual.Elements[4].Material = 'dbf4ab14-44c2-4ef9-b8be-35d1dfdd1c0f'
            else
                -- DPrint('Graying: ' .. DummyVisual.Elements[4].Material)
            end

            --Highlights
            if EntityCCA.Elements[5].Material == Utils.ZEROUUID then
                DummyVisual.Elements[5].Material = '32f58f2c-525d-4b09-86ba-0c6cb0baca28'
            else
                -- DPrint('Highlights: ' .. DummyVisual.Elements[5].Material)
            end

            --Scar
            if EntityCCA.Elements[6].Material == Utils.ZEROUUID then
                DummyVisual.Elements[6].Material = '5c6acf4c-0438-48ab-9e04-4dee7e88f8f7'
            else
                -- DPrint('Scar: ' .. DummyVisual.Elements[6].Material)
            end

            --Lips makeup
            if EntityCCA.Elements[7].Material == Utils.ZEROUUID then
                DummyVisual.Elements[7].Material = '3c642923-f0ec-4df2-a918-8ac63d7b8d26'
            else
                -- DPrint('Face: ' .. DummyVisual.Elements[7].Material)
            end
        end
    end
end



local function UpdateCCDummySkin(skinColor)
    local dummy = getCCDummy(_C())
    if skinColor and dummy and dummy.ClientCCChangeAppearanceDefinition.Definition.Visual.SkinColor ~= skinColor then
        dummy.ClientCCChangeAppearanceDefinition.Definition.Visual.SkinColor = skinColor
        Ext.UI.GetRoot():Child(1):Child(1):Child(24):Child(1).StartCharacterCreation:Execute()
    end
end



---temp abomination (temp?)
---TBD: pairsofication
---@param entity EntityHandle
---@param attachment VisualAttachment | string
---@return Visual[]
function FindAttachment(entity, attachment)
    if entity and entity.Visual and entity.Visual.Visual then
        -- Helpers.Timer:OnTicks(50, function ()
            -- DPrint(attachment)
            for i = 1, #entity.Visual.Visual.Attachments do
                if entity.Visual.Visual.Attachments[i]
                    and entity.Visual.Visual.Attachments[i].Visual.VisualResource
                then
                    if attachment == 'Tail' then
                        if entity.Visual.Visual.Attachments[i].Visual.VisualResource.SkeletonSlot:lower():find(attachment:lower()) then
                            local taleVisuals = entity.Visual.Visual.Attachments[i].Visual
                            return taleVisuals
                        end
                    elseif attachment == 'Head' then
                        if entity.Visual.Visual.Attachments[i].Visual.VisualResource
                            and entity.Visual.Visual.Attachments[i].Visual.VisualResource
                            and entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot:lower():find(attachment:lower())
                            or entity.Visual.Visual.Attachments[i].Visual.VisualResource.Template:lower():find(attachment:lower())
                        then
                            local headVisuals = entity.Visual.Visual.Attachments[i].Visual
                            return headVisuals
                        end
                    elseif attachment == 'Piercing' then
                        local piercingVisuals = {}
                        for i = 1, #entity.Visual.Visual.Attachments do

                            local currentAttach = entity.Visual.Visual.Attachments[i]
                            if currentAttach.Visual and currentAttach.Visual.VisualResource and
                               currentAttach.Visual.VisualResource.Slot and
                               currentAttach.Visual.VisualResource.Slot:lower():find(attachment:lower()) then
                                table.insert(piercingVisuals, currentAttach.Visual)
                            end

                            if currentAttach.Visual and currentAttach.Visual.Attachments then
                                for j = 1, #currentAttach.Visual.Attachments do
                                    local subAttach = currentAttach.Visual.Attachments[j]
                                    if subAttach.Visual and subAttach.Visual.VisualResource and
                                       subAttach.Visual.VisualResource.Slot and
                                       subAttach.Visual.VisualResource.Slot:lower():find(attachment:lower()) then
                                        table.insert(piercingVisuals, subAttach.Visual)
                                    end
                                end
                            end
                        end

                        if #piercingVisuals > 0 then
                            return piercingVisuals
                        end
                    elseif attachment == 'NakedBody' then
                        local bodyVisuals = {}
                        for i = 1, #entity.Visual.Visual.Attachments do
                            if entity.Visual.Visual.Attachments[i].Visual.VisualResource then
                            for _, object in pairs(entity.Visual.Visual.Attachments[i].Visual.VisualResource.Objects) do
                                if object.ObjectID:lower():find('body') or
                                    object.MaterialID:find('1594b4da-6db1-471b-9a1a-c1ad4ecf721b', 1, true)
                                        or object.MaterialID:find('5e46e917-0c94-44ae-a41e-96428aa5ea32', 1, true)
                                then
                                    SwithVanillaDummyBodyMaterialToUtav(object.MaterialID, object)
                                    local visuals = entity.Visual.Visual.Attachments[i].Visual
                                    table.insert(bodyVisuals, visuals)
                                end
                            end
                        end
                    end
                        for i = 1, #entity.Visual.Visual.Attachments do
                            if entity.Visual.Visual.Attachments[i].Visual.VisualResource then
                                if entity.Visual.Visual.Attachments[i].Visual.VisualResource.Template:lower():find('body') then
                                    local visuals = entity.Visual.Visual.Attachments[i].Visual
                                    table.insert(bodyVisuals, visuals)
                                end
                            end
                        end
                        return bodyVisuals
                    elseif attachment == 'Hair' then
                        local hairVisuals = {}
                        for i = 1, #entity.Visual.Visual.Attachments do
                            if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot:lower():find(attachment:lower()) then
                                local visuals = entity.Visual.Visual.Attachments[i].Visual
                                table.insert(hairVisuals, visuals)
                            end
                        end
                        return hairVisuals
                    elseif  attachment == 'Wings' then
                        if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.SkeletonSlot:lower():find(attachment:lower()) then
                            local wingsVisuals = entity.Visual.Visual.Attachments[i].Visual
                            return wingsVisuals
                        end
                    else
                        if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot:lower():find(attachment:lower()) then
                            local visuals = entity.Visual.Visual.Attachments[i].Visual
                            return visuals
                        end
                    end
                end
            end
        -- end)
    end
end



---Gets entity's all available meterial parameters
---@param entity EntityHandle
function getAllParameterNames(entity)
    Parameters = {}
    local entity = entity or _C()
    for _, attachment in ipairs({'Hair', 'Head', 'NakedBody', 'Private Parts', 'Tail', 'Horns', 'Piercing', 'Wings', 'DragonbornChin','DragonbornJaw','DragonbornTop'}) do
        for _, parameterType in ipairs({'ScalarParameters', 'Vector3Parameters', 'VectorParameters', 'Vector2Parameters', 'Texture2DParameters'}) do
            local visualsTable = FindAttachment(entity, attachment)
            if visualsTable then
                if type(visualsTable) ~= "table" then
                    visualsTable = {visualsTable}
                end
                Parameters[attachment] = Parameters[attachment] or {}
                Parameters[attachment][parameterType] = Parameters[attachment][parameterType] or {}
                local function NameCheck(name)
                    for _, existingName in ipairs(Parameters[attachment][parameterType]) do
                        if existingName == name then
                            return true
                        end
                    end
                end
                for _, visuals in pairs(visualsTable) do
                    if visuals and visuals.ObjectDescs then
                        for od = 1, #visuals.ObjectDescs do
                            local am = visuals.ObjectDescs[od].Renderable.ActiveMaterial
                            if am ~= nil and am.Material ~= nil then
                                if parameterType == 'ScalarParameters' then
                                    if am.Material.Parameters.ScalarParameters then
                                        for _, sp in ipairs(am.Material.Parameters.ScalarParameters) do
                                            local pn = sp.ParameterName
                                            if not NameCheck(pn) then
                                                table.insert(Parameters[attachment][parameterType], pn)
                                            end
                                        end
                                    end
                                end
                                if parameterType == 'Vector3Parameters' then
                                    if am.Material.Parameters.Vector3Parameters then
                                        for _, v3p in ipairs(am.Material.Parameters.Vector3Parameters) do
                                            local pn = v3p.ParameterName
                                            if not NameCheck(pn) then
                                                table.insert(Parameters[attachment][parameterType], pn)
                                            end
                                        end
                                    end
                                end
                                if parameterType == 'VectorParameters' then
                                    if am.Material.Parameters.VectorParameters then
                                        for _, v in ipairs(am.Material.Parameters.VectorParameters) do
                                            local pn = v.ParameterName
                                            if not NameCheck(pn) then
                                                table.insert(Parameters[attachment][parameterType], pn)
                                            end
                                        end
                                    end
                                end
                                if parameterType == 'Vector2Parameters' then
                                    if am.Material.Parameters.Vector2Parameters then
                                        for _, v in ipairs(am.Material.Parameters.Vector2Parameters) do
                                            local pn = v.ParameterName
                                            if not NameCheck(pn) then
                                                table.insert(Parameters[attachment][parameterType], pn)
                                            end
                                        end
                                    end
                                end
                                if parameterType == 'Texture2DParameters' then
                                    if am.Material.Parameters.Texture2DParameters then
                                        for _, v in ipairs(am.Material.Parameters.Texture2DParameters) do
                                            local pn = v.ParameterName
                                            if not NameCheck(pn) then
                                                table.insert(Parameters[attachment][parameterType], pn)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return Parameters
end




--#region
-- ---Gets all available meterial parameters for all origin characters
-- ---Doesn't really work
-- function GetAllCurrentParameters()

--     local characters = Ext.Entity.GetAllEntitiesWithComponent("Origin")
--     for _, character in ipairs(characters) do

--         local uuid = character.Uuid.EntityUuid
--         currentParameters[uuid] = currentParameters[uuid] or {}

--         for _, attachment in ipairs({'Head', 'NakedBody', 'Genital', 'Tail', 'Horns', 'Hair'}) do
--             for _, parameterType in ipairs({'Scalar', 'Vector3', 'Vector'}) do
--                 local visuals = FindAttachment(character, attachment)

--                 if visuals then

--                     currentParameters[uuid][attachment] = currentParameters[uuid][attachment] or {}
--                     currentParameters[uuid][attachment][parameterType] = currentParameters[uuid][attachment][parameterType] or {}
--                     currentParameters[uuid][attachment][parameterType] = currentParameters[uuid][attachment][parameterType] or {}

--                     for od = 1, #visuals.ObjectDescs do

--                         local am = visuals.ObjectDescs[od].Renderable.ActiveMaterial

--                         if am ~= nil and am.Material ~= nil then
--                             if parameterType == 'Scalar' then
--                                 for _, sp in ipairs(am.Material.Parameters.ScalarParameters) do
--                                     local parameterName = sp.ParameterName
--                                     local pv = sp.Value
--                                     currentParameters[uuid][attachment][parameterType][parameterName] = currentParameters[uuid][attachment][parameterType][parameterName] or {}
--                                     table.insert(currentParameters[uuid][attachment][parameterType][parameterName], pv)
--                                 end
--                             end
--                             if parameterType == 'Vector3' then
--                                 for _, v3p in ipairs(am.Material.Parameters.Vector3Parameters) do
--                                     local parameterName = v3p.ParameterName
--                                     local pv = v3p.Value
--                                     currentParameters[uuid][attachment][parameterType][parameterName] = currentParameters[uuid][attachment][parameterType][parameterName] or {}
--                                     table.insert(currentParameters[uuid][attachment][parameterType][parameterName], pv)
--                                 end
--                             end
--                             if parameterType == 'Vector' then
--                                 for _, v in ipairs(am.Material.Parameters.VectorParameters) do
--                                     local parameterName = v.ParameterName
--                                     local pv = v.Value
--                                     currentParameters[uuid][attachment][parameterType][parameterName] = currentParameters[uuid][attachment][parameterType][parameterName] or {}
--                                     table.insert(currentParameters[uuid][attachment][parameterType][parameterName], pv)
--                                 end
--                             end
--                         end
--                     end
--                 end
--             end
--         end
--     end
--     -- DDump(currentParameters['dd0251c9-c9a6-9549-4c5e-09f45f8b9fcf'])
-- end
--#endregion


--#region
---Gets all PM dummies for currrent scene
-- function getPMDummies()
--     local Dummies = {}
--     local visual = Ext.Entity.GetAllEntitiesWithComponent("Visual")  --Ext.Entity.GetAllEntitiesWithComponent("ClientEquipmentVisuals")
--     for i = 1, #visual do
--         if visual[i].Visual and visual[i].Visual.Visual
--             and visual[i].Visual.Visual.VisualResource
--             and visual[i].Visual.Visual.VisualResource.Template == "EMPTY_VISUAL_TEMPLATE"
--             and visual[i]:GetAllComponentNames(false)[2] == "ecl::dummy::AnimationStateComponent"
--         then
--             table.insert(Dummies, visual[i])
--         end
--     end
--     return Dummies
-- end
--#endregion



---Gets different CC dummy, not the one you visually see in the mirror
function getCCDummy(entity)
    local ccDummy
    local ccDummies = Ext.Entity.GetAllEntitiesWithComponent('CCChangeAppearanceDefinition')
    for _, dummy in pairs(ccDummies) do
        if entity and dummy
            and entity.DisplayName
            and entity.DisplayName.Name
            and dummy.CCChangeAppearanceDefinition.Appearance.Name
            and dummy.CCChangeAppearanceDefinition.Appearance.Name == entity.DisplayName.Name:Get() then
            ccDummy = dummy
            return ccDummy
        end
    end
end



---Matches character and its photo mode dummy
---Workaround until photo mode is mapped
---@param charUuid Uuid
---@return EntityHandle
function getPMDummy(charUuid)
    local entity = Ext.Entity.Get(charUuid)
    --#region
    -- local Dummies = {}
    -- local visual = Ext.Entity.GetAllEntitiesWithComponent("Visual")  --Ext.Entity.GetAllEntitiesWithComponent("ClientEquipmentVisuals")
    -- for i = 1, #visual do
    --     if visual[i].Visual and visual[i].Visual.Visual
    --         and visual[i].Visual.Visual.VisualResource
    --         and visual[i].Visual.Visual.VisualResource.Template == "EMPTY_VISUAL_TEMPLATE"
    --         and hasPMDummyComponent(entity)
    --     then
    --         table.insert(Dummies, visual[i])
    --     end
    -- end
    -- for i = 1, #Dummies do
    --     if entity.Transform.Transform.Translate[1] == Dummies[i].Transform.Transform.Translate[1]
    --         and entity.Transform.Transform.Translate[2] == Dummies[i].Transform.Transform.Translate[2]
    --         and entity.Transform.Transform.Translate[3] == Dummies[i].Transform.Transform.Translate[3] then
    --         return Dummies:Get(charUuid) --Dummies[i]
    --     end
    -- end
    --#endregion
    return Dummy:Get(entity) ---TBD:
end



function getFirsCCDummy() --maybe idk, looks wonky; works for one client tho
    local entities = Ext.Entity.GetAllEntitiesWithComponent('ClientCCDummyDefinition')
    for i = 1, #entities do
        if entities[i].CCCharacterDefinition and entities[i].CCCharacterDefinition.Definition.Name then
            return entities[i].ClientCCDummyDefinition.Dummy
        end
    end
end



function getFirsCCThings()
    local entities = Ext.Entity.GetAllEntitiesWithComponent('ClientCCDummyDefinition')
    for i = 1, #entities do
        if entities[i].CCCharacterDefinition and entities[i].CCCharacterDefinition.Definition.Name then
            return entities[i]
        end
    end
end


---TBD: DELETE ME
--#region

---@param parameterName MaterialParameterName
---@param var ExtuiSliderScalar
---@param type string|nil -- 'mp' = MaterialPreset, nil = HandleActiveMaterialParameters
---@param attachments VisualAttachment
function Apply:Scalar(entity, parameterName, var, type, attachments, presetType)
    HandleMaterialPresetParameters(_C(), parameterName, 'ScalarParameters', var.Value[1], nil, presetType)
    for _, attachment in pairs(attachments) do
        HandleActiveMaterialParameters(entity, attachment, parameterName, 'ScalarParameters', var.Value[1])
    end
    -- if type == 'mp' then
    --     HandleMaterialPresetParameters(_C(), parameterName, 'ScalarParameters', var.Value[1], nil, presetType)
    --     if presetType == 'CharacterCreationSkinColor' then  --temporary
    --         for _, attachment in pairs({'Head', 'Hair', 'NakedBody', 'Private Parts', 'Tail'}) do --temporary
    --             HandleActiveMaterialParameters(entity, attachment, parameterName, 'ScalarParameters', var.Value[1])
    --         end
    --     end
    -- else
    --     HandleMaterialPresetParameters(_C(), parameterName, 'ScalarParameters', var.Value[1], nil, presetType)
    --     for _, attachment in pairs(attachments) do
    --         HandleActiveMaterialParameters(entity, attachment, parameterName, 'ScalarParameters', var.Value[1])
    --     end
    -- end
end

---@param parameterName MaterialParameterName
---@param var ExtuiColorEdit | ExtuiColorPicker
---@param type string|nil -- 'mp' = MaterialPreset, nil = HandleActiveMaterialParameters
---@param attachments VisualAttachment
function Apply:Vector3(entity, parameterName, var, type, attachments, presetType)
    HandleMaterialPresetParameters(_C(), parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]}, nil, presetType)
    for _, attachment in pairs(attachments) do
         HandleActiveMaterialParameters(entity, attachment, parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
    end

    -- if type == 'mp' then
    --     HandleMaterialPresetParameters(_C(), parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]}, nil, presetType)
    --     if presetType == 'CharacterCreationSkinColor' then --temporary
    --         for _, attachment in pairs({'Head', 'Hair', 'NakedBody', 'Private Parts', 'Tail'}) do --temporary
    --             HandleActiveMaterialParameters(entity, attachment, parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
    --         end
    --     end
    -- else
    --     HandleMaterialPresetParameters(_C(), parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]}, nil, presetType)
    --     for _, attachment in pairs(attachments) do
    --         HandleActiveMaterialParameters(entity, attachment, parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
    --     end
    -- end
end


---@param parameterName MaterialParameterName
---@param var ExtuiColorEdit
---@param type number -- 1 = Vecror{Value[1], 0,0,0}, 2 = Vecror{0,Value[1],0,0}, 3 = Vecror{0,0,Value[1],0}
---@param attachments VisualAttachment
function Apply:Vector(entity, parameterName, var, type, attachments, presetType)
    --#region
    -- if type == 1 then
    --     for _, attachment in pairs(attachments) do
    --         HandleActiveMaterialParameters(entity, attachment, parameterName, 'Vector_1Parameters', var.Value[1])
    --     end
    -- elseif type == 2 then
    --     for _, attachment in pairs(attachments) do
    --         HandleActiveMaterialParameters(entity, attachment, parameterName, 'Vector_2Parameters', var.Value[1])
    --     end
    -- elseif type == 3 then
    --     for _, attachment in pairs(attachments) do
    --         HandleActiveMaterialParameters(entity, attachment, parameterName, 'Vector_3Parameters', var.Value[1])
    --     end
    -- end
    --#endregion
    HandleMaterialPresetParameters(_C(), parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]}, nil, presetType)
    for _, attachment in pairs(attachments) do
        HandleActiveMaterialParameters(entity, attachment, parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]})
    end
    -- if type == 'mp' then
    --     HandleMaterialPresetParameters(_C(), parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]}, nil, presetType)
    --     if presetType == 'CharacterCreationSkinColor' then --temporary
    --         for _, attachment in pairs({'Head', 'Hair', 'NakedBody', 'Private Parts', 'Tail'}) do --temporary
    --             HandleActiveMaterialParameters(entity, attachment, parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]})
    --         end
    --     end
    -- else
    --     HandleMaterialPresetParameters(_C(), parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]}, nil, presetType)
    --     for _, attachment in pairs(attachments) do
    --         HandleActiveMaterialParameters(entity, attachment, parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]})
    --     end
    -- end
end
--#endregion



function HandleAllScalarMaterialParameters(entity, parameterName, var, attachments)
    HandleMaterialPresetParameters(_C(), parameterName, 'ScalarParameters', var.Value[1], nil, nil)
    for _, attachment in pairs(attachments) do
        HandleActiveMaterialParameters(entity, attachment, parameterName, 'ScalarParameters', var.Value[1])
    end
end



function HandleAllVector3MaterialParameters(entity, parameterName, var, attachments)
    HandleMaterialPresetParameters(_C(), parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]}, nil, nil)
    for _, attachment in pairs(attachments) do
        HandleActiveMaterialParameters(entity, attachment, parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
    end
end



function HandleAllVectorMaterialParameters(entity, parameterName, var, attachments)
    HandleMaterialPresetParameters(_C(), parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]}, nil, nil)
    for _, attachment in pairs(attachments) do
        HandleActiveMaterialParameters(entity, attachment, parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]})
    end
end




function HandleAllTex2DMaterialParameters(entity, parameterName, var, attachments, objectIndex)
    -- HandleMaterialPresetParameters(_C(), parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]}, nil, nil)
    for _, attachment in pairs(attachments) do
        -- HandleActiveMaterialParameters(entity, attachment, parameterName, 'Texture2DParameters', var)
        HandleActiveMaterialParameters(_C(), attachment, parameterName, 'Texture2DParameters', var, objectIndex)
    end
    -- end)
end

function HandleAllVTMaterialParameters(entity, parameterName, var, attachments)
    Utils:AntiSpam(10, function ()
        -- HandleMaterialPresetParameters(_C(), parameterName, 'Texture2DParameters', var, nil, nil)
    for _, attachment in pairs(attachments) do
        -- HandleActiveMaterialParameters(entity, attachment, parameterName, 'Texture2DParameters', var)
        HandleActiveMaterialParameters(_C(), attachment, parameterName, 'VirtualTextureParameters', var)
    end
    Helpers.Timer:OnTicks(10, function ()
        pcall(function () Ext.UI.GetRoot():Child(1):Child(1):Child(24):Child(1).StartCharacterCreation:Execute() end)
    end)
    end)
end



_GLL.Textures = {}
function getAllTextures(name, type)
    local i = 0
    _GLL.Textures = {}
    local textures = Ext.Resource.GetAll('Texture')
    for _, value in pairs(textures) do
        local texture = Ext.Resource.Get(value, 'Texture')
        if texture.Template:lower():find(name) and texture.Template:lower():find('hum') and texture.Template:lower():find(type) then
            i = i + 1
            _GLL.Textures[i] = texture.Guid
        end
    end
end
getAllTextures('head', '_nm')

-- _GLL.VirtualTextures = {}
-- function getAllVirtualTextures(name, bodyType, format)
--     local i = 0
--     _GLL.Textures = {}
--     local textures = Ext.Resource.GetAll('VirtualTexture')
--     for _, value in pairs(textures) do
--         local texture = Ext.Resource.Get(value, 'VirtualTexture')
--         if texture.Template:lower():find(name) then
--             if bodyType then
--                 if texture.Template:lower():find(bodyType) then
--                     i = i + 1
--                     _GLL.VirtualTextures[i] = texture.Guid
--                 end
--             else
--                 i = i + 1
--                 _GLL.VirtualTextures[i] = texture.Guid
--             end
--         end
--     end
-- end
-- getAllVirtualTextures('body')


---@param entity EntityHandle
---@return MaterialPreset
local function getMaterialPreset(entity, presetType, uuid)
    --if presetType == 'CharacterCreationSkinColor' then
        local uuid = AssignSkinToCharacter(entity) or uuid
        local matPresetUuid = Ext.StaticData.Get(uuid, 'CharacterCreationSkinColor').MaterialPresetUUID
        local mt = Ext.Resource.Get(matPresetUuid,'MaterialPreset')  --'2cac4615-e3ac-8b17-906b-7fb8b2775981'
        return mt
    -- elseif presetType == 'CharacterCreationHairColor' then
    --     local uuid = AssignHairToCharacter(entity) or uuid
    --     local matPresetUuid = Ext.StaticData.Get(uuid, presetType).MaterialPresetUUID
    --     local mt = Ext.Resource.Get(matPresetUuid,'MaterialPreset')
    --     return mt
    -- elseif presetType == 'CharacterCreationAppearanceMaterialTattoo' then
    --     local uuid = AssignTattooToCharacter(entity) or uuid --'45e0c89f-6301-bf90-309c-365892670294'
    --     local matPresetUuid = Ext.StaticData.Get(uuid, 'CharacterCreationAppearanceMaterial').MaterialPresetUUID
    --     local mt = Ext.Resource.Get(matPresetUuid,'MaterialPreset')
    --     return mt
    --end
end




function printAllElementNames(entity)
    entity = entity or _C()
    local Elements = entity.CharacterCreationAppearance.Elements
    for i = 1, #Elements do
        -- DPrint(' ' .. 'Name: ' .. Ext.StaticData.Get(entity.CharacterCreationAppearance.Elements[i].Material, 'CharacterCreationAppearanceMaterial').Name)
    end
end





---@param entity EntityHandle
---@param parameterType ParemeterTypes
---@param parameterName MaterialParameterName
---@param value number
--- - Scalar: number
--- - Vector3: number{3}
--- - Vector: number{4}
---@param materialPreset ResourceMaterialPresetResource
function SetMaterialPresetParameterValue(entity, parameterName, parameterType, value, materialPreset)
    if entity then
        -- DPrint('MaterialPreset')
        local entityUuid = entity.Uuid.EntityUuid
        for _, parameter in pairs(materialPreset.Presets[parameterType]) do
            if materialPreset.Presets[parameterType] then
                if parameter.Parameter == parameterName then
                    parameter.Value = value
                end
            end
        end
        -- Utils:AntiSpam(5, function ()
        --     Ext.Net.PostMessageToServer('CCEE_Replicate', Ext.Json.Stringify(entityUuid))
        -- end)
    end
end

function SaveMaterialPresetParameterChange(entity, parameterName, parameterType, value, materialPreset)
    if entity then
        local materialGuid = materialPreset.Guid
        local entityUuid = entity.Uuid.EntityUuid
        local matParams = Utils:EnsureTable(_GLL.AllParameters, 'MatPresetParameters', entityUuid, materialGuid, parameterType)
        --#region
        -- _GLL.AllParameters.MatPresetParameters[entityUuid] = _GLL.AllParameters.MatPresetParameters[entityUuid] or {}
        -- _GLL.AllParameters.MatPresetParameters[entityUuid][materialGuid] = _GLL.AllParameters.MatPresetParameters[entityUuid][materialGuid] or {}
        -- _GLL.AllParameters.MatPresetParameters[entityUuid][materialGuid][parameterType] = _GLL.AllParameters.MatPresetParameters[entityUuid][materialGuid][parameterType] or {}
        -- _GLL.AllParameters.MatPresetParameters[entityUuid][materialGuid][parameterType][parameterName] = _GLL.AllParameters.MatPresetParameters[entityUuid][materialGuid][parameterType][parameterName] or {}
        -- _GLL.AllParameters.MatPresetParameters[entityUuid][materialGuid][parameterType][parameterName] = value
        --#endregion
        matParams[parameterName] = value
        local data = {
            entityUuid = entityUuid,
            materialGuid = materialGuid,
            parameterType = parameterType,
            parameterName = parameterName,
            value = value
        }
        Ext.Net.PostMessageToServer('CCEE_SendSingleMatPresetVars', Ext.Json.Stringify(data))
        --Ext.Net.PostMessageToServer('CCEE_SendMatPresetVars', Ext.Json.Stringify(_GLL.AllParameters.MatPresetParameters))
    end
end


--#region Parameter tables for match_parameter

local TattooPrarmeters = {
    'TattooIndex',
    'TattooColor',
    'TattooColorG',
    'TattooColorB',
    'TattooIntensity',
}

local MakeupPrarmeters = {
    'MakeUpIndex',
    'MakeupColor',
    'MakeupIntensity',
    'EyesMakeupMetalness',
    'MakeupRoughness',
}

local LipsMakeupPrarmeters = {
    'Lips_Makeup_Color',
    'LipsMakeupIntensity',
    'LipsMakeupMetalness',
    'LipsMakeupRoughness',
}

local CutsomPrarmeters = {
    'CustomIndex',
    'CustomColor',
    'CustomIntensity',
}

local HairPrarmeters = {
    'Hair_Color',
    'Hair_Graying_Color',
    'Graying_Intensity',
    'Graying_Seed',
    'Highlight_Color',
    'Highlight_Falloff',
    'Highlight_Intensity',
    'Eyebrow_Color',
    'Eyelashes_Color',
    'Roughness',
    'RoughnessContrast',
    'Hair_Scalp_Color',
}

local HairGrayingPrarmeters = {
    'Hair_Graying_Color',
    'Graying_Intensity',
    'Graying_Seed',
}

local HairHightPrarmeters = {
    'Highlight_Color',
    'Highlight_Falloff',
    'Highlight_Intensity',
}

local ScarPrarmeters = {
    'ScarIndex',
    'Scar_Weight',
}

--#endregion

function HandleMaterialPresetParameters(entity, parameterName, parameterType, value, materialPreset, presetType)

    local function match_parameter(parameterName, tbl)
        for _, parameterMatch in pairs(tbl) do
            if parameterMatch == parameterName then
                return true
            end
        end
    end

    --temporary I guess

    if match_parameter(parameterName, TattooPrarmeters)
    and entity and entity.CharacterCreationAppearance and entity.CharacterCreationAppearance.Elements[1].Material ~= Utils.ZEROUUID then
        Ext.Net.PostMessageToServer('CCEE_SetTattooZero', _C().Uuid.EntityUuid)

    elseif match_parameter(parameterName, MakeupPrarmeters)
    and entity and entity.CharacterCreationAppearance and entity.CharacterCreationAppearance.Elements[2].Material ~= Utils.ZEROUUID then
        Ext.Net.PostMessageToServer('CCEE_SetMakeUpZero', _C().Uuid.EntityUuid)

    elseif match_parameter(parameterName, CutsomPrarmeters)
    and entity and entity.CharacterCreationAppearance and entity.CharacterCreationAppearance.Elements[3].Material ~= Utils.ZEROUUID then
        Ext.Net.PostMessageToServer('CCEE_SetScalesZero', _C().Uuid.EntityUuid)

    elseif match_parameter(parameterName, HairGrayingPrarmeters)
    and entity and entity.CharacterCreationAppearance and entity.CharacterCreationAppearance.Elements[4].Material ~= Utils.ZEROUUID then
        Ext.Net.PostMessageToServer('CCEE_SetGrayingZero', _C().Uuid.EntityUuid)

    elseif match_parameter(parameterName, HairHightPrarmeters)
    and entity and entity.CharacterCreationAppearance and entity.CharacterCreationAppearance.Elements[5].Material ~= Utils.ZEROUUID then
        Ext.Net.PostMessageToServer('CCEE_SetHighZero', _C().Uuid.EntityUuid)

    elseif match_parameter(parameterName, ScarPrarmeters)
    and entity and entity.CharacterCreationAppearance and entity.CharacterCreationAppearance.Elements[6].Material ~= Utils.ZEROUUID then
        Ext.Net.PostMessageToServer('CCEE_SetScarsZero', _C().Uuid.EntityUuid)

    elseif match_parameter(parameterName, LipsMakeupPrarmeters)
    and entity and entity.CharacterCreationAppearance and entity.CharacterCreationAppearance.Elements[7].Material ~= Utils.ZEROUUID then
        Ext.Net.PostMessageToServer('CCEE_SetLipsZero', _C().Uuid.EntityUuid)

    elseif match_parameter(parameterName, HairPrarmeters)
    and entity and entity.CharacterCreationAppearance and entity.CharacterCreationAppearance.HairColor ~= Utils.ZEROUUID then
        Ext.Net.PostMessageToServer('CCEE_SetHairZero', _C().Uuid.EntityUuid)
    end

    local materialPreset = getMaterialPreset(entity, presetType) or materialPreset

    if materialPreset then
        SetMaterialPresetParameterValue(entity, parameterName, parameterType, value, materialPreset)
        SaveMaterialPresetParameterChange(entity, parameterName, parameterType, value, materialPreset)
    end
end



---@param entity EntityHandle
---@param parameterType ParemeterTypes
---@param parameterName MaterialParameterName
---@param value number
--- Scalar: number
--- Vector3: number{3}
--- Vector: number{4}
function SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value, objectIndex)

    local visualsTable = FindAttachment(entity, attachment)

    local function IterateAndSetValue(path, parameterName, value)
        for _, parameter in pairs(path) do
            if parameter.ParameterName == parameterName then
                parameter.Value = value
            end
        end
    end

    local function TemporalGarbo(OD)
        local am = OD.Renderable.ActiveMaterial
        if am == nil or am.Material == nil then return end

        local params = am.Material.Parameters

        if parameterType == 'ScalarParameters' then
            if not params.ScalarParameters then return end
            local path = params.ScalarParameters
            for _, p in pairs(path) do
                if p.ParameterName == parameterName then
                    am:SetScalar(parameterName, value)
                    IterateAndSetValue(path, parameterName, value)
                end
            end

        elseif parameterType == 'Vector3Parameters' then
            if not params.Vector3Parameters then return end
            local path = params.Vector3Parameters
            local v = {value[1], value[2], value[3]}
            for _, p in pairs(path) do
                if p.ParameterName == parameterName then
                    am:SetVector3(parameterName, v)
                    IterateAndSetValue(path, parameterName, v)
                end
            end

        elseif parameterType == 'VectorParameters' then
            if not params.VectorParameters then return end
            local path = params.VectorParameters
            local v = {value[1], value[2], value[3], value[4]}
            for _, p in pairs(path) do
                if p.ParameterName == parameterName then
                    am:SetVector4(parameterName, v)
                    IterateAndSetValue(path, parameterName, v)
                end
            end

        elseif parameterType == 'Vector2Parameters' then
            if not params.Vector2Parameters then return end
            local path = params.Vector2Parameters
            local v = {value[1], value[2]}
            for _, p in pairs(path) do
                if p.ParameterName == parameterName then
                    am:SetVector2(parameterName, v)
                    IterateAndSetValue(path, parameterName, v)
                end
            end

        elseif parameterType == 'Texture2DParameters' then
            if not params.Texture2DParameters then return end
            for _, p in pairs(params.Texture2DParameters) do
                if p.ParameterName == parameterName then
                    if type(value) == 'table' then
                        value = value.value
                    end
                    am:SetTexture2D(parameterName, value)
                end
            end

        elseif parameterType == 'VirtualTextureParameters' then
            if not params.VirtualTextureParameters then return end
            for _, p in pairs(params.VirtualTextureParameters) do
                if p.ParameterName == parameterName then
                    am:SetVirtualTexture(parameterName, value)
                end
            end
        end
    end

    if not visualsTable then return end

    if type(visualsTable) ~= "table" then
        visualsTable = {visualsTable}
    end

    for _, visuals in pairs(visualsTable) do
        if objectIndex ~= nil then
            local OD = visuals.ObjectDescs[objectIndex]
            if OD then
                TemporalGarbo(OD)
            end
        else
            for _, OD in pairs(visuals.ObjectDescs) do
                TemporalGarbo(OD)
            end
        end
    end
end

-- _D(_C().Visual.Visual.Attachments[1].Visual.ObjectDescs[1].Renderable.ActiveMaterial:SetVirtualTexture('virtualtexture', 'fcfb0e8a-e167-01b5-b0c3-c8300cffdf23'))
-- _D(_C().Visual.Visual.Attachments[1].Visual.ObjectDescs[1].Renderable.ActiveMaterial:SetVirtualTexture('virtualtexture', '799138c9-9c03-4fb0-b541-207600cf9dc2'))


Ext.RegisterConsoleCommand('xdd', function (cmd, ...)
    HandleActiveMaterialParameters(Apply.entity, 'Head', 'normalmap', 'Texture2DParameters', '67c3ace1-7ec1-6426-3ba9-91d4cf2f0e8e')
end)

Ext.RegisterConsoleCommand('xdd2', function (cmd, ...)
    HandleActiveMaterialParameters(Apply.entity, 'Head', 'normalmap', 'Texture2DParameters', '9216fcc5-1a18-c0f2-3d2f-3214d2477761')
end)



---@param entity EntityHandle
---@param attachment VisualAttachment
---@param parameterType MyOwnParemeterTypes
---@param parameterName MaterialParameterName
---@param value number | -- for parameterType:
--- - Scalar: number
--- - Vector3: number{3}
--- - Vector: number{4}
function SaveActiveMaterialLastChanges(entity, attachment, parameterName, parameterType, value, objectIndex)
    if entity and entity.Uuid then
        local entityUuid = entity.Uuid.EntityUuid
        local lastParams = Utils:EnsureTable(_GLL.AllParameters, 'ActiveMatParameters', entityUuid, attachment, parameterType)
        local visualsTable = FindAttachment(entity, attachment)

        if visualsTable then
            if type(visualsTable) ~= "table" then
                visualsTable = {visualsTable}
            end

            local parameterFound = false

            for _, visuals in pairs(visualsTable) do
                if visuals and visuals.ObjectDescs and not parameterFound then

                    local descsToCheck = {}
                    if objectIndex ~= nil then
                        if visuals.ObjectDescs[objectIndex] then
                            descsToCheck = {[objectIndex] = visuals.ObjectDescs[objectIndex]}
                        end
                    else
                        descsToCheck = visuals.ObjectDescs
                    end

                    for _, desc in pairs(descsToCheck) do
                        if parameterFound then break end
                        local am = desc.Renderable.ActiveMaterial
                        if am ~= nil and am.Material ~= nil then
                            local paramList = am.Material.Parameters[parameterType]
                            if paramList then
                                for _, param in pairs(paramList) do
                                    if param.ParameterName == parameterName then
                                        if objectIndex ~= nil then
                                            lastParams[parameterName] = {
                                                value       = value,
                                                objectIndex = objectIndex
                                            }
                                        else
                                            lastParams[parameterName] = value
                                        end
                                        parameterFound = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        local Data = {
            entityUuid  = entityUuid,
            attachment  = attachment,
            parameterType = parameterType,
            parameterName = parameterName,
            value       = value,
            objectIndex = objectIndex
        }
        Ext.Net.PostMessageToServer('CCEE_SendSingleActiveMatVars', Ext.Json.Stringify(Data))
    end
end



function HandleActiveMaterialParameters(entity, attachment, parameterName, parameterType, value, objectIndex)
    if _GLL.States.CCState or _GLL.inPhotoMode then
        SaveActiveMaterialLastChanges(_C(), attachment, parameterName, parameterType, value, objectIndex)
        SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value, objectIndex)
    else
        SaveActiveMaterialLastChanges(entity, attachment, parameterName, parameterType, value, objectIndex)
        SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value, objectIndex)
    end
end



--LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
--Not in use
function SetAdditionalChoices(choice, value)
   local ac = _C().CharacterCreationAppearance.AdditionalChoices
    if choice == 'Vitiligo' then
        ac[1] = value
    elseif choice == 'Freckles' then
        ac[2] = value
    elseif choice == 'FrecklesWeight' then
        ac[4] = value
    elseif choice == 'Oldness' then
        ac[3] = value
   end
   Ext.Net.PostMessageToServer('CCEE_Replicate', Ext.Json.Stringify(_C().Uuid.EntityUuid))
end



---@param entity EntityHandle
---@return MaterialPreset
function getMaterialPreset2(cca)
    local skinUuid = cca.SkinColor
    local matPresetUuid = Ext.StaticData.Get(skinUuid, 'CharacterCreationSkinColor').MaterialPresetUUID
    local mt = Ext.Resource.Get(matPresetUuid,'MaterialPreset')  --'2cac4615-e3ac-8b17-906b-7fb8b2775981'
    return mt
end



function SaveSkinMaterialPresetParameters(entity)
    _GLL.SavedMaterialParameters = {}
    local cca = getCharacterCreationAppearance(entity)
    if cca then
        local MaterialPreset = getMaterialPreset2(cca)
        for parameterType, parameterParameters in pairs(MaterialPreset.Presets) do
            if parameterType == 'ScalarParameters' or parameterType == 'Vector3Parameters' or parameterType == 'VectorParameters' then
                for _, parameter in pairs(parameterParameters) do
                    Utils:EnsureTable(_GLL.SavedMaterialParameters, parameterType)[parameter.Parameter] = parameter.Value
                end
            end
        end
        --DDump(_GLL.SavedMaterialParameters)
    else
        DWarn('Can not get Skin MaterialPreset')
    end
end



function ApplySavedMaterialPresetParametersToCCEESkin(entity)
    local cca = getCharacterCreationAppearance(entity)
    local MaterialPreset = getMaterialPreset2(cca)
    for parameterType, parameterNames in pairs(_GLL.SavedMaterialParameters) do
        for parameterName, value in pairs(parameterNames) do
            if parameterType == 'ScalarParameters' or parameterType == 'Vector3Parameters' or parameterType == 'VectorParameters' then
                --temporary
                HandleMaterialPresetParameters(entity, parameterName, parameterType, value, MaterialPreset)
                for _, attachment in pairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    HandleActiveMaterialParameters(entity, attachment, parameterName, parameterType, value)
                end
            end
        end
    end
    _GLL.SavedMaterialParameters = nil
end



local function assignCharacterCreationAppearance(entity, typeTable, keyMapTable, keyUsedTable)
    _GLL.AllParameters.CCEEModStuff[keyMapTable] = _GLL.AllParameters.CCEEModStuff[keyMapTable] or {}
    local entity = Ext.Entity.Get(entity)
    if _GLL.AllParameters.CCEEModStuff[keyMapTable]
        and _GLL.AllParameters.CCEEModStuff[keyMapTable][entity.Uuid.EntityUuid] then
        Ext.Net.PostMessageToServer('CCEE_SendCCEEModVars', Ext.Json.Stringify(_GLL.AllParameters.CCEEModStuff))
        UpdateCCDummySkin(uuid)
        return _GLL.AllParameters.CCEEModStuff[keyMapTable][entity.Uuid.EntityUuid]
    end
    ---slopped
    local function isUuidUsedByOthers(uuid)
        for entityUuid, usedUuid in pairs(_GLL.AllParameters.CCEEModStuff[keyMapTable]) do
            if entityUuid ~= entity.Uuid.EntityUuid and usedUuid == uuid then
                return true
            end
        end
        return false
    end
    for i = 1, #typeTable do
        uuid = typeTable[i]
        local duplicateFound = false
        if keyMapTable == "SkinMap" then
            local allEntities = Ext.Entity.GetAllEntitiesWithComponent('Origin')
            for _, ent in pairs(allEntities) do
                if ent.Uuid.EntityUuid ~= entity.Uuid.EntityUuid
                    and ent.CharacterCreationAppearance
                    and ent.CharacterCreationAppearance.SkinColor == uuid then
                    duplicateFound = true
                    break
                end
            end
        end
        if not duplicateFound and not isUuidUsedByOthers(uuid) then
            _GLL.AllParameters.CCEEModStuff[keyMapTable][entity.Uuid.EntityUuid] = uuid
            local cc = {
                uuid = entity.Uuid.EntityUuid,
                ccUuid = uuid
            }
            Ext.Net.PostMessageToServer('CCEE_ApplySkin', Ext.Json.Stringify(cc))
            local data = {
                keyMapTable = keyMapTable,
                mapTable = _GLL.AllParameters.CCEEModStuff[keyMapTable],
            }
            Ext.Net.PostMessageToServer('CCEE_UsedMaterialsMap', Ext.Json.Stringify(data))
            Ext.Net.PostMessageToServer('CCEE_SendCCEEModVars', Ext.Json.Stringify(_GLL.AllParameters.CCEEModStuff))
            UpdateCCDummySkin(uuid)
            return uuid
        end
    end
end



---TBD: DELETE ME
---@param entity EntityHandle
function AssignSkinToCharacter(entity)
    return assignCharacterCreationAppearance(entity, CCSkinUuids, 'SkinMap', 'UsedSkinUUID')
end

---@param entity EntityHandle
function AssignHairToCharacter(entity)
    --#region
    -- _GLL.MatVars.UsedHairUUID = _GLL.MatVars.UsedHairUUID or {}
    -- _GLL.MatVars.HairMap = _GLL.MatVars.HairMap or {}
    -- local entity = Ext.Entity.Get(entity)
    -- if _GLL.MatVars.HairMap and _GLL.MatVars.HairMap[entity.Uuid.EntityUuid] then
    --     return _GLL.MatVars.HairMap[entity.Uuid.EntityUuid]
    -- end
    -- for i = 1, #CCHairUuids do
    --     local uuidH = CCHairUuids[i]
    --     if not _GLL.MatVars.UsedHairUUID[uuidH] then
    --         entity.CharacterCreationAppearance.HairColor = uuidH
    --         _GLL.MatVars.HairMap[entity.Uuid.EntityUuid] = uuidH
    --         _GLL.MatVars.UsedHairUUID[uuidH] = true
    --         local data = {
    --             HairMap = _GLL.MatVars.HairMap,
    --             UsedHairUUID = _GLL.MatVars.UsedHairUUID
    --         }
    --         local temp = {
    --             uuid = entity.Uuid.EntityUuid,
    --             hairUuid = _GLL.MatVars.HairMap[entity.Uuid.EntityUuid]
    --         }
    --         Ext.Net.PostMessageToServer('CCEE_UsedMatVars', Ext.Json.Stringify(data))
    --         Ext.Net.PostMessageToServer('CCEE_ApplyHair', Ext.Json.Stringify(temp))
    --         return uuidH
    --     end
    -- end
    --#endregion
    return assignCharacterCreationAppearance(entity, CCHairUuids, 'HairMap', 'UsedHairUUID')
end

---@param entity EntityHandle
function AssignTattooToCharacter(entity)
    return assignCharacterCreationAppearance(entity, CCTattooUuids, 'TattooMap', 'UsedTattooUUID')
end




--#region

local APPLY_DELAY = 4
function Apply_CharacterMaterialPresetPararmeters(charUuid)
    -- DPrint('Apply_CharacterMaterialPresetPararmeters')
    local timer = 0
    local entity = Ext.Entity.Get(charUuid)
    --local uuid = entity.Uuid.EntityUuid
    if entity and _GLL.AllParameters.MatPresetParameters and _GLL.AllParameters.MatPresetParameters[charUuid] then
    -- DPrint('Character: ' .. entity.DisplayName.Name:Get())
        for materialUuids, parameterTypes in pairs(_GLL.AllParameters.MatPresetParameters[charUuid]) do
            timer = timer + APPLY_DELAY
            Helpers.Timer:OnTicks(timer, function()
            for parameterType, parameterNames in pairs(parameterTypes) do
                for parameterName, value in pairs(parameterNames) do
                    local materialPreset = Ext.Resource.Get(materialUuids,'MaterialPreset')
                    --HandleMaterialPresetParameters(entity, parameterName, parameterType, value, materialPreset)
                    SetMaterialPresetParameterValue(entity, parameterName, parameterType, value, materialPreset)
                end
            end
            end)
        end
    end
end



---TBD:
function Apply_AllCharactersMaterialPresetPararmeters()
    -- DPrint('Apply_AllCharactersMaterialPresetPararmeters')
    local timer = 0
    if _GLL.AllParameters.MatPresetParameters then
        for uuid, _ in pairs(_GLL.AllParameters.MatPresetParameters) do
            timer = timer + APPLY_DELAY
            Helpers.Timer:OnTicks(timer, function ()
            local entity = Ext.Entity.Get(uuid)
                for materialUuids, parameterTypes in pairs(_GLL.AllParameters.MatPresetParameters[uuid]) do
                    for parameterType, parameterNames in pairs(parameterTypes) do
                        for parameterName, value in pairs(parameterNames) do
                            local materialPreset = Ext.Resource.Get(materialUuids,'MaterialPreset')
                            --HandleMaterialPresetParameters(entity, parameterName, parameterType, value, materialPreset)
                            SetMaterialPresetParameterValue(entity, parameterName, parameterType, value, materialPreset)
                        end
                    end
                end
            end)
        end
    end
end



function Apply_CharacterActiveMaterialParameters(charUuid)
    -- DPrint('Apply_CharacterActiveMaterialParameters')
    local timer = 0
    local entity = Ext.Entity.Get(charUuid)
    if entity and _GLL.AllParameters.ActiveMatParameters and _GLL.AllParameters.ActiveMatParameters[charUuid]
        and entity.ShapeshiftReplicatedChanges
        and not entity.ShapeshiftReplicatedChanges.VisualChanged
    then
        for attachment, parameterTypes in pairs(_GLL.AllParameters.ActiveMatParameters[charUuid]) do
            timer = timer + APPLY_DELAY
            OnTicks(timer, function()
                for parameterType, parameterNames in pairs(parameterTypes) do
                    for parameterName, entry in pairs(parameterNames) do
                        local value, objectIndex

                        if type(entry) == 'table' and entry.value ~= nil then
                            value       = entry.value
                            objectIndex = entry.objectIndex
                        else
                            value       = entry
                            objectIndex = nil
                        end

                        local targetEntity = (_GLL.States.CCState == true) and _GLL.dummyEntity or entity
                        -- DPrint(parameterName)
                        -- DDump(value)
                        SetActiveMaterialParameterValue(targetEntity, attachment, parameterName, parameterType, value, objectIndex)
                        SetActiveMaterialParameterValue(targetEntity, 'NakedBody', 'IsTav', 'ScalarParameters', 1, nil)
                    end
                end
            end)
        end
    end
    if _C() then
        Elements:UpdateElements(_C().Uuid.EntityUuid)
    end
end



function Apply_AllCharactersActiveMaterialParameters()
    -- DPrint('Apply_AllCharactersActiveMaterialParameters')
    local timer = 0
    if _GLL.AllParameters.ActiveMatParameters then
        timer = timer + APPLY_DELAY
        Helpers.Timer:OnTicks(timer, function ()
            for charUuid, _ in pairs(_GLL.AllParameters.ActiveMatParameters) do
                Apply_CharacterActiveMaterialParameters(charUuid)
                OnTicks(20, function()
                    SetActiveMaterialParameterValue(Ext.Entity.Get(charUuid), 'NakedBody', 'IsTav', 'ScalarParameters', 1, nil)
                end)
            end
        end)
    end
end



---Appplies the things to the PM dummies
function Apply_PMDummiesActiveMaterialParameters()
    -- DPrint('Apply_PMDummiesActiveMaterialParameters')
    if _GLL.AllParameters.ActiveMatParameters then
        for uuid, attachments in pairs(_GLL.AllParameters.ActiveMatParameters) do
            local entity = Dummy:Get(Ext.Entity.Get(uuid))
            if entity
                and entity.Dummy
                and entity.Dummy.Entity
                and entity.Dummy.Entity.ShapeshiftReplicatedChanges
                and not entity.Dummy.Entity.ShapeshiftReplicatedChanges.VisualChanged
             then
                for attachment, parameterTypes in pairs(attachments) do
                    for parameterType, parameterNames in pairs(parameterTypes) do
                        for parameterName, value in pairs(parameterNames) do
                            if parameterName == 'OrgasmGlowIntensity' then
                            end
                            SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
                        end
                    end
                end
            else
                -- DWarn('No dummy found for this uuid: %s', uuid)
            end
        end
    end
end



---Appplies the things to the paperdolls v2
function Apply_DollsActiveMaterialParameters(entity, uuid)
    -- DPrint('Apply_DollsActiveMaterialParameters')
    if _GLL.AllParameters.ActiveMatParameters then
        local attachments = _GLL.AllParameters.ActiveMatParameters[uuid]
        if attachments then
            for attachment, parameterTypes in pairs(attachments) do
                for parameterType, parameterNames in pairs(parameterTypes) do
                    for parameterName, value in pairs(parameterNames) do
                        SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
                    end
                end
            end
        end
    end
end



function Apply_CCDummyVActiveMaterialsParameters(entity) --V for visible
    if _GLL.States.CCState == true then
        Utils:AntiSpam(100, function ()
            -- DPrint('Apply_CCDummyVActiveMaterialsParameters')
        end)
        local tempEntity = _C()
        local entityDummy
        local CCDumies = Ext.Entity.GetAllEntitiesWithComponent("ClientCCDummyDefinition")
        if entity and tempEntity and _GLL.AllParameters.ActiveMatParameters and _GLL.AllParameters.ActiveMatParameters[tempEntity.Uuid.EntityUuid] then
            for _,dummy in pairs(CCDumies) do
                if dummy and dummy.CCChangeAppearanceDefinition then
                    if tempEntity and dummy
                        and tempEntity.DisplayName
                        and tempEntity.DisplayName.Name
                        and dummy.CCChangeAppearanceDefinition.Appearance.Name
                        and tempEntity.DisplayName.Name:Get() == dummy.CCChangeAppearanceDefinition.Appearance.Name
                    then
                        entityDummy = dummy.ClientCCDummyDefinition.Dummy
                        table.insert(_GLL.CC_Entities, entityDummy)
                        for _, v in pairs(_GLL.CC_Entities) do
                            for attachment, parameterTypes in pairs(_GLL.AllParameters.ActiveMatParameters[tempEntity.Uuid.EntityUuid]) do
                                for parameterType, parameterNames in pairs(parameterTypes) do
                                    for parameterName, value in pairs(parameterNames) do
                                        SetActiveMaterialParameterValue(v, attachment, parameterName, parameterType, value)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        --DDump(_GLL.CC_Entities)
        _GLL.CC_Entities = {}
    end
end



function Apply_FirstCCDummyVActiveMaterialsParameters(entity)
    if _GLL.States.firstCC and _GLL.AllParameters.ActiveMatParameters and _GLL.AllParameters.ActiveMatParameters[_C().Uuid.EntityUuid] then
        for attachment, parameterTypes in pairs(_GLL.AllParameters.ActiveMatParameters[_C().Uuid.EntityUuid]) do
            for parameterType, parameterNames in pairs(parameterTypes) do
                for parameterName, value in pairs(parameterNames) do
                    SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
                end
            end
        end
    end
end



function Apply_TLPreviwDummiesActiveMaterialsParameters()
    local entity = Ext.Entity.GetAllEntitiesWithComponent("TLPreviewDummy")
    for q = 1, #entity do
        if entity and entity[q] then
            local dummy = entity[q].TLPreviewDummy
            if dummy ~= nil and entity[q].ClientTimelineActorControl ~= nil then
                local actorLink = entity[q].ClientTimelineActorControl.Actor
                local owner
                for _, v in pairs(Ext.Entity.GetAllEntitiesWithComponent("Origin")) do
                    --- TBD: field_0 changed
                    if v.TimelineActorData ~= nil and v.TimelineActorData.Actor == actorLink then
                        owner = v
                        -- DPrint('Dummy/Doll owner: ' .. owner.DisplayName.Name:Get())
                        Helpers.Timer:OnTicks(2, function ()
                            Apply_DollsActiveMaterialParameters(entity[q], owner.Uuid.EntityUuid)
                        end)
                    end
                end
            end
        end
    end
end
--#endregion



-- local timer = nil
-- function TempThingy()
--     if timer then
--         Ext.Timer.Cancel(timer)
--     end
--     timer = Ext.Timer.WaitFor(500, function()
--         -- Ext.Net.PostMessageToServer('UpdateParameters', '')
--         Ext.Net.PostMessageToServer('CCEE_UpdateParameters_NotOnlyVis', '')
--         getAllParameterNames(_C())
--         timer = nil
--     end)
-- end



---Dumps all parameterName
---'ScalarParameters' , 'Vector3Parameters' , 'VectorParameters'
function DumpCurrentParameters(entity, parameterName, parameterType)
   for i = 1, #entity.Visual.Visual.Attachments do
       if entity.Visual.Visual.Attachments[i] and
       entity.Visual.Visual.Attachments[i].Visual.ObjectDescs then
           for j = 1, #entity.Visual.Visual.Attachments[i].Visual.ObjectDescs do
               if entity.Visual.Visual.Attachments[i].Visual.ObjectDescs[j] and
                  entity.Visual.Visual.Attachments[i].Visual.ObjectDescs[j].Renderable.ActiveMaterial.Material.Parameters[parameterType] then
                   for _, param in pairs(entity.Visual.Visual.Attachments[i].Visual.ObjectDescs[j].Renderable.ActiveMaterial.Material.Parameters[parameterType]) do
                       if param.ParameterName:find(parameterName) then
                           DPrint("Attachment: " .. i .. ", ObjectDesc: " .. j)
                       end
                   end
               end
           end
       end
   end
end




---tbd: unharcode presets json, make "if presetName == fileName then" as separate function
---@param fileName string
---@return boolean #if fileName exists in _PresetNames.json returns true
function RegisterPresetName(fileName)
    local Presets = {}
    local function insertName(fileName)
        table.insert(Presets, fileName)
        Ext.IO.SaveFile('CCEE/_PresetNames.json', Ext.Json.Stringify(Presets))
        ParsePresetNames()
        DPrint('Preset ' .. fileName .. ' registered')
    end
    if Ext.IO.LoadFile('CCEE/_PresetNames.json') then
        Presets = Ext.Json.Parse(Ext.IO.LoadFile('CCEE/_PresetNames.json'))
        for _, presetName in pairs(Presets) do
            if presetName == fileName then
                DPrint('Preset ' .. fileName .. ' already registered')
                return true
            end
        end
        insertName(fileName)
    else
        insertName(fileName)
    end
    E.presetsCombo.Options = _GLL.Presets
    return false
end



---tbd: make "if presetName == fileName then" as separate function
---@param fileName string | nil
---@return boolean #if fileName exists in _PresetNames.json returns true
function ParsePresetNames(fileName)
    local Presets = {}
    _GLL.Presets = {}
    if Ext.IO.LoadFile('CCEE/_PresetNames.json') then
        Presets = Ext.Json.Parse(Ext.IO.LoadFile('CCEE/_PresetNames.json'))
        for _, presetName in pairs(Presets) do
            table.insert(_GLL.Presets, presetName)
            if presetName == fileName then
                return true
            end
        end
    end
    if E.presetsCombo then
        E.presetsCombo.Options = _GLL.Presets
    end
    --DDump(_GLL.Presets)
    Presets = nil
    return false
end
ParsePresetNames()



local function presetsInfoLable(lable)
    E.info.Label = lable
    Helpers.Timer:OnTicks(200, function ()
        E.info.Label = ''
    end)
end



_GLL.States.firstCC = false
---@param fileName string
function SavePreset(fileName)
    E.firstCC.Checked = false
    DPrint('SavePreset')
    local uuid = _C().Uuid.EntityUuid
    local rippedMatParameters = {}
    local cca
    if _GLL.States.firstCC == false then
        cca = getCharacterCreationAppearance(_C())
    else
        cca = getDummyAppearance(getFirsCCThings())
    end
    _GLL.States.firstCC = false
    if _GLL.AllParameters.MatPresetParameters and _GLL.AllParameters.MatPresetParameters[uuid] then
        for _,v in pairs(_GLL.AllParameters.MatPresetParameters[uuid]) do
            rippedMatParameters = v
        end
    else
        rippedMatParameters = nil
    end

    if _GLL.AllParameters.ActiveMatParameters and _GLL.AllParameters.ActiveMatParameters[uuid] then
        CCEEParams = _GLL.AllParameters.ActiveMatParameters[uuid]
    else
        CCEEParams = nil
    end

    local DataSave = {
        {SkinMaterialParams = {rippedMatParameters or {}}},
        {CCEEParams = {CCEEParams or {}}},
        {DefaultCC = cca}
    }
    RegisterPresetName(fileName)
    Ext.IO.SaveFile('CCEE/' .. fileName .. '.json', Ext.Json.Stringify(DataSave))
    DataSave = nil
    presetsInfoLable(fileName .. ' saved')
end



---@param fileName string
function LoadPreset(fileName)
    local uuid = _C().Uuid.EntityUuid
    AssignSkinToCharacter(_C())
    local skinMatUuid
    local skinUuid
    local hairMatUuid
    local hairUuid
    DPrint('CCEE_LoadPreset')
    Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
    Helpers.Timer:OnTicks(10, function ()
        local json = Ext.IO.LoadFile(('CCEE/' .. fileName .. '.json'))
        if json then
            if not ParsePresetNames(fileName) then
                RegisterPresetName(fileName)
            end
            local dataLoad = Ext.Json.Parse(json)

            ---TBD:remove this
            if _GLL.AllParameters.CCEEModStuff.SkinMap and _GLL.AllParameters.CCEEModStuff.SkinMap[uuid] then
                skinMatUuid = Ext.StaticData.Get(_GLL.AllParameters.CCEEModStuff.SkinMap[uuid], 'CharacterCreationSkinColor').MaterialPresetUUID
            else
                if dataLoad[3] then
                    skinMatUuid = Ext.StaticData.Get(dataLoad[3].DefaultCC.SkinColor, 'CharacterCreationSkinColor').MaterialPresetUUID
                end
            end
            -- if dataLoad[3] then
            --     if dataLoad[3].DefaultCC.HairColor == Utils.ZEROUUID then
            --         hairMatUuid = dataLoad[3].DefaultCC.HairColor
            --     else
            --         hairMatUuid = Ext.StaticData.Get(dataLoad[3].DefaultCC.HairColor, 'CharacterCreationHairColor').MaterialPresetUUID
            --     end
            -- end
            if _GLL.AllParameters.CCEEModStuff.SkinMap and _GLL.AllParameters.CCEEModStuff.SkinMap[uuid] then
                skinUuid = _GLL.AllParameters.CCEEModStuff.SkinMap[uuid]
            else
                if dataLoad[3] then
                    skinUuid = dataLoad[3].DefaultCC.SkinColor
                end
            end
            -- if dataLoad[3] then
            --     hairUuid = dataLoad[3].DefaultCC.HairColor
            -- end
            local data = {
                dataLoad = dataLoad,
                uuid = uuid,
                skinMatUuid = skinMatUuid,
                skinUuid = skinUuid,
                --hairMatUuid = hairMatUuid,
                --hairUuid = hairUuid
            }

            -- DDump(data)

            Helpers.Timer:OnTicks(3, function ()
                Ext.Net.PostMessageToServer('CCEE_LoadPreset', Ext.Json.Stringify(data))
            end)
        else
            presetsInfoLable('No presets with name' .. fileName .. ' were found')
        end
        presetsInfoLable(fileName .. ' loaded')
    end)
    ParsePresetNames()
end



function RealodPreset()
    DPrint('RealodPreset')
    local uuid = _C().Uuid.EntityUuid
    Ext.Net.PostMessageToServer('CCEE_RequestMatPresetVars', '')
    Helpers.Timer:OnTicks(10, function ()
        DPrint(_C())
        local cca = getCharacterCreationAppearance(_C())
        --DDump(cca)
        Helpers.Timer:OnTicks(5, function ()
            local SkinMaterialParams
            local skinMatUuid
            local skinUuid
            if _GLL.AllParameters.ActiveMatParameters then
                if _GLL.AllParameters.CCEEModStuff
                    and _GLL.AllParameters.CCEEModStuff.SkinMap
                    and _GLL.AllParameters.CCEEModStuff.SkinMap[uuid]
                then
                    local skinPreset = Ext.StaticData.Get(_GLL.AllParameters.CCEEModStuff.SkinMap[uuid], 'CharacterCreationSkinColor').MaterialPresetUUID
                    SkinMaterialParams = {_GLL.AllParameters.MatPresetParameters[uuid][skinPreset]}

                    skinMatUuid = Ext.StaticData.Get(_GLL.AllParameters.CCEEModStuff.SkinMap[uuid], 'CharacterCreationSkinColor').MaterialPresetUUID
                    skinUuid = _GLL.AllParameters.CCEEModStuff.SkinMap[uuid]

                else
                    SkinMaterialParams = {}
                    skinMatUuid = nil
                    skinUuid = nil
                end
                local dataLoad = {
                    {SkinMaterialParams = SkinMaterialParams},
                    {CCEEParams = {_GLL.AllParameters.ActiveMatParameters[uuid]} or {}},
                    {DefaultCC = cca},
                }
                local data = {
                    dataLoad = dataLoad,
                    uuid = uuid,
                    skinMatUuid = skinMatUuid,
                    skinUuid = skinUuid
                }
                Helpers.Timer:OnTicks(5, function ()
                    Ext.Net.PostMessageToServer('CCEE_LoadPreset', Ext.Json.Stringify(data))
                    data = nil
                end)
            end
        end)
    end)
end
Ext.RegisterNetListener('CCEE_Reload_Lable', function (channel, payload, user)
    presetsInfoLable('Current character visuals reloaded')
end)


Ext.RegisterConsoleCommand('d', function ()
    DWarn('STUFF DAT -----------------')
    DDump(_GLL.AllParameters.CCEEModStuff)
    -- DWarn('SKIN MAP -----------------')
    -- DDump(_GLL.AllParameters.CCEEModStuff.SkinMap)
    -- DWarn('USED SKIN -----------------')
    -- DDump(_GLL.AllParameters.CCEEModStuff.UsedSkinUUID)
    -- DWarn('HAIR MAP -----------------')
    -- DDump(_GLL.AllParameters.CCEEModStuff.HairMap)
    -- DWarn('USED HAIR -----------------')
    -- DDump(_GLL.AllParameters.CCEEModStuff.UsedHairUUID)
    -- DWarn('MAT-----------------')
    -- DDump(_GLL.AllParameters.MatPresetParameters)
    -- DWarn('ACT-----------------')
    -- DDump(_GLL.AllParameters.ActiveMatParameters)
end)




-- function StartPMSub()
--     Utils:SubUnsubToTick('sub', 'PhotoMode', function ()
--         local success, _ = pcall(function()
--             return Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.DOFDistance
--         end)

--         if success then
--             if not _GLL.inPhotoMode then
--                 _GLL.inPhotoMode = true
--                 Helpers.Timer:OnTicks(40, function ()
--                     Apply_PMDummiesActiveMaterialParameters()
--                 end)
--             end
--         else
--             _GLL.inPhotoMode = false
--         end
--     end)
-- end




-- function getCharacterCreationAppearance(charEntity)
--     local savedAppearance = {}
--     local CCA = charEntity.CharacterCreationAppearance
--     if CCA then
--         savedAppearance.AdditionalChoices = {}
--         for i = 1, #CCA.AdditionalChoices do
--             savedAppearance.AdditionalChoices[i] = CCA.AdditionalChoices[i]
--         end
--         savedAppearance.Elements = {}
--         for i = 1, #CCA.Elements do
--             savedAppearance.Elements[i] = {
--                 Color = CCA.Elements[i].Color,
--                 ColorIntensity = CCA.Elements[i].ColorIntensity,
--                 GlossyTint = CCA.Elements[i].GlossyTint,
--                 Material = CCA.Elements[i].Material,
--                 MetallicTint = CCA.Elements[i].MetallicTint
--             }
--         end
--         savedAppearance.EyeColor = CCA.EyeColor
--         savedAppearance.HairColor = CCA.HairColor
--         savedAppearance.SecondEyeColor = CCA.SecondEyeColor
--         savedAppearance.SkinColor = CCA.SkinColor
--         savedAppearance.Visuals = {}
--         for i = 1, #CCA.Visuals do
--             savedAppearance.Visuals[i] = CCA.Visuals[i]
--         end
--     end
--     return savedAppearance
-- end




-- Presets = _Class:Create('Preset', 'LocalSettings', {
--     SaveImmediately = true,
--     FolderName = 'CCEE',
--     Data = {},
-- })






function setTexture(uuidOrig, uuidNew)
    DPrint('1--------------------')
    DDump(Ext.Resource.Get('9216fcc5-1a18-c0f2-3d2f-3214d2477761', 'Texture'))
    -- local textureOrig = Ext.Resource.Get(uuidOrig, 'Texture')
    -- local textureNew = Ext.Resource.Get(uuidNew, 'Texture')
    -- DPrint('2--------------------')
    -- DPrint(textureOrig.SourceFile)
    -- DPrint(textureNew.SourceFile)
    -- DPrint('3--------------------')
    -- textureOrig.SourceFile = textureNew.SourceFile
    _C().Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].ID = uuidNew
    pcall(function () Apply.entity.Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].ID = uuidNew end)

    DPrint(_C().Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].ID)
    DPrint('4--------------------')
    -- Helpers.Timer:OnTicks(50, function ()
    --     _C().Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].ID = uuidOrig
    --     Apply.entity.Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].ID = uuidOrig
    --     pcall(function () Ext.UI.GetRoot():Child(1):Child(1):Child(24):Child(1).StartCharacterCreation:Execute() end)
    --     DDump(Ext.Resource.Get('9216fcc5-1a18-c0f2-3d2f-3214d2477761', 'Texture'))
    --     DPrint('5--------------------')
    -- end)

    -- _C().Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].ID = Utils.ZEROUUID
    -- Apply.entity.Visual.Visual.Attachments[2].Visual.ObjectDescs[1].Renderable.ActiveMaterial.Material.Parameters.Texture2DParameters[2].ID = Utils.ZEROUUID
end




-- Ext.RegisterConsoleCommand('xd1', function (cmd, ...)
--     setTexture('9216fcc5-1a18-c0f2-3d2f-3214d2477761', '67c3ace1-7ec1-6426-3ba9-91d4cf2f0e8e')
-- end)

-- Ext.RegisterConsoleCommand('xd2', function (cmd, ...)
--     setTexture('9216fcc5-1a18-c0f2-3d2f-3214d2477761', '829caa74-e0e8-1bd7-4277-17e7c00a7f42')
-- end)

-- Ext.RegisterConsoleCommand('xd3', function (cmd, ...)
--     setTexture('9216fcc5-1a18-c0f2-3d2f-3214d2477761', '9216fcc5-1a18-c0f2-3d2f-3214d2477761')
-- end)


--[[
for _,v in ipairs(Ext.StaticData.GetAll('CharacterCreationAppearanceMaterial')) do
        _D(Ext.StaticData.Get(v, 'CharacterCreationAppearanceMaterial'))
end
]]--



function SwithVanillaDummyBodyMaterialToUtav(materialUuid, object)
    if object.MaterialID ~= '1594b4da-6db1-471b-9a1a-c1ad4ecf721b' then
        local Material = Ext.Resource.Get(materialUuid, 'Material')
        --- Can't check by uuid only because some people for NO REASON make a copy of vanilla body material OMEGALUL
        if Material and Material.SourceFile:find('Public/Shared/Assets/Materials/Characters/CHAR_Skin_Body.lsf', 1, true) then
            for k, v in pairs(Material.Texture2DParameters) do
                if v.ParameterName == 'TattooAtlas' then
                    if Ext.Mod.GetMod('4cb0fd40-7212-4fe9-8733-9a8dbc6637ae') then
                        v.Enabled = true
                        v.ID = '6cb6efac-f234-40f5-b8dc-0ccf62783ed4'
                    elseif Mods.STAV then
                        v.ID = ''
                    end
                end
            end
            return object
        end
    end
end



function FindE2()
    local Dummies = Ext.Entity.GetAllEntitiesWithComponent('Dummy')
    local Origins = Ext.Entity.GetAllEntitiesWithComponent('Origin')

    local function xd(Characters)
        for _, dummy in pairs(Characters) do
            if dummy and dummy.Visual and dummy.Visual.Visual then
                if dummy.Visual.Visual.Attachments
                    and dummy.Visual.Visual.Attachments[2]
                    and dummy.Visual.Visual.Attachments[2].Visual.VisualResource
                then
                    if dummy.Visual.Visual.Attachments[2].Visual.VisualResource.SourceFile:find('ELF_F_NKD_Head_A.GR2') then
                        for _, vis in pairs(dummy.Visual.Visual.Attachments) do
                            if vis.Visual.VisualResource then
                                for _, obj in pairs(vis.Visual.VisualResource.Objects) do
                                    if obj.MaterialID == '5e46e917-0c94-44ae-a41e-96428aa5ea32' or
                                       obj.MaterialID == '1594b4da-6db1-471b-9a1a-c1ad4ecf721b' or
                                       obj.MaterialID == '80567441-dafe-b6c6-4873-aa67bff518bc'
                                    then
                                        -- DPrint(vis.Visual.VisualResource.SourceFile)
                                        for _, od in pairs(vis.Visual.ObjectDescs) do
                                            if od.Renderable.ActiveMaterial.Material.Shaders[1]:find('CHAR_Skin_Body') then
                                                od.Renderable.ActiveMaterial:SetVirtualTexture('virtualtexture', 'f523e27f-d71f-49d4-b5b4-9259fbb192c8')
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    xd(Dummies)
    xd(Origins)

end
