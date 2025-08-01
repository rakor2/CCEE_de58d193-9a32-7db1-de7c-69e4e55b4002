
--[[
PARAMETERS IN SKIN MATERIAL PRESET:
HemoglobinColor
HemoglobinAmount
MelaninColor
MelaninAmount
MelaninDarkThreshold
MelaninDarkMultiplier
MelaninRemovalAmount
VeinColor
VeinAmount
YellowingColor
YellowingAmount
BodyTattooIndex
BodyTattooIntensity
BodyTattooColor
BodyTattooColorG
BodyTattooColorB
TattooIndex
TattooColor
TattooColorG
TattooColorB
TattooIntensity
MakeUpIndex
MakeupIntensity
MakeupColor
MakeupRoughness
LipsMakeupIntensity
Lips_Makeup_Color
LipsMakeupRoughness
CustomIndex
CustomIntensity
CustomColor
Body_Hair_Color
TattooCurvatureInfluence
Hair_Color
Hair_Scalp_Color
Scalp_HueShiftColorWeight
Hair_Color
Beard_Scalp_Color
Beard_Color
Body_Hair_Color
Eyelashes_Color
Eyebrow_Color
]]


CCEE = {}
UI = {}
Window = {}
Tests = {}
Elements = {}



Parameters = Parameters or {}

Globals.AllParameters = {}
Globals.AllParameters.LastParameters = {}
Globals.AllParameters.MatParameters = {}

Globals.MatVars = {}
Globals.MatVars.MatData = {}
Globals.MatVars.SkinMap = {}
Globals.MatVars.HairMap = {}
Globals.MatVars.UsedSkinUUID = {}
Globals.MatVars.UsedHairUUID = {}

Globals.CC_Entities = {}


TICKS_BEFORE_GAPM = 0
TICKS_BEFORE_LOADING = 0
TICKS_BEFORE_APPLYING = 2



---@param type integer # 1 - keyborad / 0 - controller
---@param bindingIndex integer
---@return string
function GetKeybind(type, bindingIndex) 
    for _, bind in pairs(Ext.Input.GetInputManager().InputScheme.RawToBinding) do
        for i = 1, 2 do
            if bind.Bindings[i] and bind.Bindings[i].BindingIndex == type and bind.Bindings[i].InputIndex == bindingIndex then 
                local keybind = bind.Bindings[i].Binding.InputId
                return keybind
            end
        end
    end
end

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


---Checks if character is in the mirror (for some reason the osi listeners doesn't return characters) and also does some bs
---@param entity EntityHandle
---@return EntityHandle #If user in the mirror returns dummy entity, if not - _C()
function CzechCCState(entity)
    DPrint('CzechCCState')
    Helpers.Timer:OnTicks(20, function ()
        if _C() and _C().CCState and _C().CCState.HasDummy == false then
            CCState = false
            Apply.entity = _C()
            DPrint('HasDummy = ' .. tostring(CCState))
            DPrint('Apply entity' .. ' - ' .. tostring(Apply.entity))
            return _C()
        else
            local ccDummies = Ext.Entity.GetAllEntitiesWithComponent('CCChangeAppearanceDefinition')
            for _, dummy in pairs(ccDummies) do
                local entity = _C()
                if dummy.CCChangeAppearanceDefinition.Appearance.Name == entity.DisplayName.Name:Get() then
                    ApplyParametersToCCDummy(entity)
                    Globals.dummyVisuals = dummy.ClientCCDummyDefinition
                    Globals.dummyEntity = dummy.ClientCCDummyDefinition.Dummy
                    CCState = true
                    Apply.entity = Globals.dummyEntity
                    --Invalid UUID non-clickable Confirm workaround
                    --It's just sets valid default UUIDs to CC dummy
                    --Don't know if the indecies? indexes? are static
                    local Visual = dummy.ClientCCChangeAppearanceDefinition.Definition.Visual
                    Visual.HairColor = 'edbb0710-7162-487b-9553-062bece30c1f'
                    Visual.Elements[1].Material = '00894ccc-31ee-4527-94d5-a408cccb3583' --Face Tattoo
                    Visual.Elements[2].Material = '503bb196-fee7-4e1b-8a58-c09f48bdc9d1' --MakeUp 
                    Visual.Elements[3].Material = 'f03b33ae-5d47-4cb5-80bc-ea06a3c55c96' --Scales
                    Visual.Elements[4].Material = 'dbf4ab14-44c2-4ef9-b8be-35d1dfdd1c0f' --Graying 
                    Visual.Elements[5].Material = '32f58f2c-525d-4b09-86ba-0c6cb0baca28' --Highlights
                    Visual.Elements[6].Material = '5c6acf4c-0438-48ab-9e04-4dee7e88f8f7' --Scar
                    DPrint('HasDummy = ' .. tostring(CCState))
                    DPrint('Apply entity' .. ' - ' .. tostring(Apply.entity))
                    return Globals.dummyEntity
                end
            end
        end
    end)
end



---temp abomination (temp?)
---@param entity EntityHandle
---@param attachment VisualAttachment | string
---@return Visual[]
function FindAttachment(entity, attachment)
    if entity and entity.Visual and entity.Visual.Visual then
        -- Helpers.Timer:OnTicks(50, function ()
            -- DPrint(attachment)
            for i = 1, #entity.Visual.Visual.Attachments do
                if attachment == 'Tail' then
                    if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.SkeletonSlot:lower():find(attachment:lower()) then
                        local taleVisuals = entity.Visual.Visual.Attachments[i].Visual
                        return taleVisuals
                    end
                elseif attachment == 'Head' then
                    if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot:lower():find(attachment:lower()) or
                    entity.Visual.Visual.Attachments[i].Visual.VisualResource.Template:lower():find(attachment:lower()) then
                        local headVisuals = entity.Visual.Visual.Attachments[i].Visual
                        return headVisuals
                    end
                elseif attachment == 'Piercing' then
                    local piercingVisuals = {}
                    for q = 1, #entity.Visual.Visual.Attachments[2].Visual.Attachments do
                        if entity.Visual.Visual.Attachments[2].Visual.Attachments[q].Visual.VisualResource and entity.Visual.Visual.Attachments[2].Visual.Attachments[q].Visual.VisualResource.Slot:lower():find(attachment:lower()) then
                            for _,v in pairs(entity.Visual.Visual.Attachments[i].Visual.Attachments) do
                                local visuals = v.Visual
                                table.insert(piercingVisuals, visuals)
                                return piercingVisuals
                            end
                        end
                    end
                elseif attachment == 'NakedBody' then
                    local bodyVisuals = {}
                    for i = 1, #entity.Visual.Visual.Attachments do
                        if entity.Visual.Visual.Attachments[i].Visual.VisualResource then 
                        for _, objects in pairs(entity.Visual.Visual.Attachments[i].Visual.VisualResource.Objects) do
                            if objects.ObjectID:lower():find('body') then
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
        -- end)
    end
end

---Gets entity's all available meterial parameters
---@param entity EntityHandle
function getAllParameterNames(entity)
    Parameters = {}
    local entity = entity or _C()
    for _, attachment in ipairs({'Hair', 'Head', 'NakedBody', 'Private Parts', 'Tail', 'Horns', 'Piercing', 'Wings', 'DragonbornChin','DragonbornJaw','DragonbornTop'}) do
        for _, parameterType in ipairs({'ScalarParameters', 'Vector3Parameters', 'VectorParameters'}) do
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



---Gets all PM dummies for currrent scene
function getPMDummies()
    local Dummies = {}
    local visual = Ext.Entity.GetAllEntitiesWithComponent("Visual")  --Ext.Entity.GetAllEntitiesWithComponent("ClientEquipmentVisuals")
    for i = 1, #visual do
        if visual[i].Visual and visual[i].Visual.Visual
            and visual[i].Visual.Visual.VisualResource
            and visual[i].Visual.Visual.VisualResource.Template == "EMPTY_VISUAL_TEMPLATE"
            and visual[i]:GetAllComponentNames(false)[2] == "ecl::dummy::AnimationStateComponent"
        then
            table.insert(Dummies, visual[i])
        end
    end
    return Dummies
end

---Matches character and its photo mode dummy
---Workaround until photo mode is mapped
---@param charUuid Uuid
---@return EntityHandle
function MatchCharacterAndPMDummy(charUuid)
    local Dummies = getPMDummies()
    local originEnt = Ext.Entity.Get(charUuid)
    for i = 1, #Dummies do
        if originEnt.Transform.Transform.Translate[1] == Dummies[i].Transform.Transform.Translate[1]
            and originEnt.Transform.Transform.Translate[2] == Dummies[i].Transform.Transform.Translate[2] 
            and originEnt.Transform.Transform.Translate[3] == Dummies[i].Transform.Transform.Translate[3] then
            -- DPrint(originEnt)
            return Dummies[i]
        end
    end
end



---@param parameterName MaterialParameterName
---@param var ExtuiSliderScalar
---@param type string|nil -- 'mp' = MaterialPreset, nil = HandleActiveMaterialParameters
---@param attachments VisualAttachment
function Apply:Scalar(entity, parameterName, var, type, attachments, presetType)
    if type == 'mp' then
        HandleMaterialPresetParameters(_C(), parameterName, 'ScalarParameters', var.Value[1], nil, presetType)
        if presetType == 'CharacterCreationSkinColor' then  --temporary
            for _, attachment in pairs({'Head', 'Hair', 'NakedBody', 'Private Parts', 'Tail'}) do --temporary
                HandleActiveMaterialParameters(entity, attachment, parameterName, 'ScalarParameters', var.Value[1])
            end
        end
    else
        for _, attachment in pairs(attachments) do
            HandleActiveMaterialParameters(entity, attachment, parameterName, 'ScalarParameters', var.Value[1])
        end
    end
end


---@param parameterName MaterialParameterName
---@param var ExtuiColorEdit | ExtuiColorPicker
---@param type string|nil -- 'mp' = MaterialPreset, nil = HandleActiveMaterialParameters
---@param attachments VisualAttachment
function Apply:Vector3(entity, parameterName, var, type, attachments, presetType)
    if type == 'mp' then
        HandleMaterialPresetParameters(_C(), parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]}, nil, presetType)
        if presetType == 'CharacterCreationSkinColor' then --temporary
            for _, attachment in pairs({'Head', 'Hair', 'NakedBody', 'Private Parts', 'Tail'}) do --temporary
                HandleActiveMaterialParameters(entity, attachment, parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
            end
        end
    else
        for _, attachment in pairs(attachments) do
            HandleActiveMaterialParameters(entity, attachment, parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
        end
    end
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
    if type == 'mp' then
        HandleMaterialPresetParameters(_C(), parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]}, nil, presetType)
        if presetType == 'CharacterCreationSkinColor' then --temporary
            for _, attachment in pairs({'Head', 'Hair', 'NakedBody', 'Private Parts', 'Tail'}) do --temporary
                HandleActiveMaterialParameters(entity, attachment, parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]})
            end
        end
    else
        for _, attachment in pairs(attachments) do
            HandleActiveMaterialParameters(entity, attachment, parameterName, 'VectorParameters', {var.Color[1],var.Color[2],var.Color[3],var.Color[4]})
        end
    end
end




---@param entity EntityHandle
---@return MaterialPreset
local function getMaterialPreset(entity, presetType, uuid)
    if presetType == 'CharacterCreationSkinColor' then
        local uuid = AssignSkinToCharacter(entity) or uuid
        local matPresetUuid = Ext.StaticData.Get(uuid, presetType).MaterialPresetUUID
        local mt = Ext.Resource.Get(matPresetUuid,'MaterialPreset')  --'2cac4615-e3ac-8b17-906b-7fb8b2775981'
        return mt
    elseif presetType == 'CharacterCreationHairColor' then
        local uuid = AssignHairToCharacter(entity) or uuid
        local matPresetUuid = Ext.StaticData.Get(uuid, presetType).MaterialPresetUUID
        local mt = Ext.Resource.Get(matPresetUuid,'MaterialPreset')
        return mt
    elseif presetType == 'CharacterCreationAppearanceMaterialTattoo' then
        local uuid = AssignTattooToCharacter(entity) or uuid --'45e0c89f-6301-bf90-309c-365892670294'
        local matPresetUuid = Ext.StaticData.Get(uuid, 'CharacterCreationAppearanceMaterial').MaterialPresetUUID
        local mt = Ext.Resource.Get(matPresetUuid,'MaterialPreset')
        return mt
    end
end




function printAllElementNames(entity)
    entity = entity or _C()
    local Elements = entity.CharacterCreationAppearance.Elements
    for i = 1, #Elements do
        DPrint(' ' .. 'Name: ' .. Ext.StaticData.Get(entity.CharacterCreationAppearance.Elements[i].Material, 'CharacterCreationAppearanceMaterial').Name)
    end
end



--messy mess, no judge ^_^


---@param entity EntityHandle
---@param parameterType ParemeterTypes
---@param parameterName MaterialParameterName
---@param value number
--- - Scalar: number
--- - Vector3: number{3}
--- - Vector: number{4}
---@param materialPreset ResourceMaterialPresetResource
function SetMaterialPresetParameterValue(entity, parameterName, parameterType, value, materialPreset)
    local entityUuid = entity.Uuid.EntityUuid
    for _, parameter in pairs(materialPreset.Presets[parameterType]) do
        if parameter.Parameter == parameterName then
            parameter.Value = value
        end
    end
    Ext.Net.PostMessageToServer('CCEE_Replicate', Ext.Json.Stringify(entityUuid))
end


function SaveMaterialPresetParameterChange(entity, parameterName, parameterType, value, materialPreset)
    local materialGuid = materialPreset.Guid
    local entityUuid = entity.Uuid.EntityUuid
    local matParams = SLOP:tableCheck(Globals.AllParameters, 'MatParameters', entityUuid, materialGuid, parameterType)
    --#region
    -- Globals.AllParameters.MatParameters[entityUuid] = Globals.AllParameters.MatParameters[entityUuid] or {}
    -- Globals.AllParameters.MatParameters[entityUuid][materialGuid] = Globals.AllParameters.MatParameters[entityUuid][materialGuid] or {}
    -- Globals.AllParameters.MatParameters[entityUuid][materialGuid][parameterType] = Globals.AllParameters.MatParameters[entityUuid][materialGuid][parameterType] or {}
    -- Globals.AllParameters.MatParameters[entityUuid][materialGuid][parameterType][parameterName] = Globals.AllParameters.MatParameters[entityUuid][materialGuid][parameterType][parameterName] or {}
    -- Globals.AllParameters.MatParameters[entityUuid][materialGuid][parameterType][parameterName] = value
    --#endregion
    matParams[parameterName] = value
    Ext.Net.PostMessageToServer('CCEE_SendMatVars', Ext.Json.Stringify(Globals.AllParameters.MatParameters))
end


function HandleMaterialPresetParameters(entity, parameterName, parameterType, value, materialPreset, presetType)
    --temporary
    if parameterName:lower():find('tattoo') then
        Ext.Net.PostMessageToServer('CCEE_SetTattooZero', _C().Uuid.EntityUuid)
    elseif parameterName == 'Hair_Color' then
        Ext.Net.PostMessageToServer('CCEE_SetHairZero', _C().Uuid.EntityUuid)
    elseif parameterName:lower():find('make') then
        Ext.Net.PostMessageToServer('CCEE_SetMakeUpZero', _C().Uuid.EntityUuid)
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
--- - Scalar: number
--- - Vector3: number{3}
--- - Vector: number{4}
function SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
    local visualsTable = FindAttachment(entity, attachment)
    if visualsTable then
        if type(visualsTable) ~= "table" then
            visualsTable = {visualsTable}
        end
        for _, visuals in pairs(visualsTable) do
            for descNumber, desc in pairs(visuals.ObjectDescs) do
                local am = desc.Renderable.ActiveMaterial
                if am ~= nil and am.Material ~= nil then
                    if parameterType == 'ScalarParameters' then
                        if am.Material.Parameters.ScalarParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.ScalarParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    am:SetScalar(parameterName, value)
                                end
                            end
                        end
                    elseif parameterType == 'Vector3Parameters' then
                        if am.Material.Parameters.Vector3Parameters then
                            for _, vec3Param in pairs(am.Material.Parameters.Vector3Parameters) do
                                if vec3Param.ParameterName == parameterName then
                                    am:SetVector3(parameterName, {value[1], value[2], value[3]})
                                end
                            end
                        end
                    elseif parameterType == 'VectorParameters' then
                        if am.Material.Parameters.VectorParameters then
                            for _, vec4Param in pairs(am.Material.Parameters.VectorParameters) do
                                if vec4Param.ParameterName == parameterName then
                                    am:SetVector4(parameterName, {value[1], value[2], value[3], value[4]}) 
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


---@param entity EntityHandle
---@param attachment VisualAttachment
---@param parameterType MyOwnParemeterTypes
---@param parameterName MaterialParameterName
---@param value number | -- for parameterType:
--- - Scalar: number
--- - Vector3: number{3}
--- - Vector: number{4}
function SaveActiveMaterialLastChanges(entity, attachment, parameterName, parameterType, value)
    if entity and entity.Uuid then
        local entityUuid = entity.Uuid.EntityUuid
        --#region
        -- Globals.AllParameters.LastParameters[entityUuid] = Globals.AllParameters.LastParameters[entityUuid] or {}
        -- Globals.AllParameters.LastParameters[entityUuid][attachment] = Globals.AllParameters.LastParameters[entityUuid][attachment] or {}
        -- Globals.AllParameters.LastParameters[entityUuid][attachment][parameterType] = Globals.AllParameters.LastParameters[entityUuid][attachment][parameterType] or {}
        --#endregion
        local lastParams = SLOP:tableCheck(Globals.AllParameters, 'LastParameters', entityUuid, attachment, parameterType)
        local visualsTable = FindAttachment(entity, attachment)
        if visualsTable then
            if type(visualsTable) ~= "table" then
                visualsTable = {visualsTable}
            end
            local parameterFound = false
            for _, visuals in pairs(visualsTable) do
                if visuals and visuals.ObjectDescs and not parameterFound then
                    for _, desc in pairs(visuals.ObjectDescs) do
                        if parameterFound then break end
                        local am = desc.Renderable.ActiveMaterial   
                        if am ~= nil and am.Material ~= nil then
                            if parameterType == 'ScalarParameters' then
                                if am.Material.Parameters.ScalarParameters then
                                    for _, scalarParam in pairs(am.Material.Parameters.ScalarParameters) do
                                        if scalarParam.ParameterName == parameterName then
                                            lastParams[parameterName] = value
                                            parameterFound = true
                                            break
                                        end
                                    end
                                end
                            elseif parameterType == 'Vector3Parameters' then
                                if am.Material.Parameters.Vector3Parameters then
                                    for _, scalarParam in pairs(am.Material.Parameters.Vector3Parameters) do
                                        if scalarParam.ParameterName == parameterName then
                                            lastParams[parameterName] = value
                                            parameterFound = true
                                            break
                                        end
                                    end
                                end
                            elseif parameterType == 'VectorParameters' then
                                if am.Material.Parameters.VectorParameters then
                                    for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                        if scalarParam.ParameterName == parameterName then
                                            lastParams[parameterName] = value
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
        end
    end
    Ext.Net.PostMessageToServer('CCEE_SendModVars', Ext.Json.Stringify(Globals.AllParameters.LastParameters))
    -- DDump(LastParameters)
end


function HandleActiveMaterialParameters(entity, attachment, parameterName, parameterType, value)
    if CCState == true then
        SaveActiveMaterialLastChanges(_C(), attachment, parameterName, parameterType, value)
        SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
    else
        SaveActiveMaterialLastChanges(entity, attachment, parameterName, parameterType, value)
        SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
    end
end

--LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
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


function LoadMatVars()
    if Globals.MatVars.MatData then
        for charUuid, matUuids in pairs(Globals.MatVars.MatData) do
            for matUuid, parameterTypes in pairs(matUuids) do
                for parameterType, parameterNames in pairs(parameterTypes) do
                    for parameterName, value in pairs(parameterNames) do
                        local mt = Ext.Resource.Get(matUuid,'MaterialPreset')
                        for _, parameter in pairs(mt.Presets[parameterType]) do
                            if parameter.Parameter:find(parameterName) then
                                parameter.Value = value
                            end
                        end
                    end
                end
            end
            local entity = Ext.Entity.Get(charUuid)
            Helpers.Timer:OnTicks(30, function ()
                Ext.Entity.Get(charUuid).CharacterCreationAppearance.SkinColor = AssignSkinToCharacter(entity)
                Ext.Entity.Get(charUuid).CharacterCreationAppearance.HairColor = AssignHairToCharacter(entity)
                Helpers.Timer:OnTicks(5, function ()
                    Ext.Net.PostMessageToServer('CCEE_Replicate', Ext.Json.Stringify(charUuid))
                end)
            end)
        end
    end
end




local function assignCharacterCreationAppearance(entity, typeTable, keyMapTable, keyUsedTable)
    Globals.MatVars[keyUsedTable] = Globals.MatVars[keyUsedTable] or {}
    Globals.MatVars[keyMapTable] = Globals.MatVars[keyMapTable] or {}
    local entity = Ext.Entity.Get(entity)
    if Globals.MatVars[keyMapTable] and Globals.MatVars[keyMapTable][entity.Uuid.EntityUuid] then
        return Globals.MatVars[keyMapTable][entity.Uuid.EntityUuid]
    end
    for i = 1, #typeTable do
        local uuid = typeTable[i]
        if not Globals.MatVars[keyUsedTable][uuid] then
            Globals.MatVars[keyMapTable][entity.Uuid.EntityUuid] = uuid
            Globals.MatVars[keyUsedTable][uuid] = true
            local data = {
                keyMapTable = keyMapTable,
                keyUsedTable = keyUsedTable,
                mapTable = Globals.MatVars[keyMapTable],
                usedTable = Globals.MatVars[keyUsedTable],
            }
            local cc = {
                uuid = entity.Uuid.EntityUuid,
                ccUuid = Globals.MatVars[keyMapTable][entity.Uuid.EntityUuid]
            }
            if keyMapTable == 'HairMap' then
                Ext.Net.PostMessageToServer('CCEE_ApplyHair', Ext.Json.Stringify(cc))
            elseif keyMapTable == 'SkinMap' then
                Ext.Net.PostMessageToServer('CCEE_ApplySkin', Ext.Json.Stringify(cc))
            elseif keyMapTable == 'TattooMap' then
                cc.index = getElementIndex(entity, 'Tattoo')
                Ext.Net.PostMessageToServer('CCEE_ApplyTattoo', Ext.Json.Stringify(cc))
            else
                --EyeColor
            end
            Ext.Net.PostMessageToServer('CCEE_UsedMatVars', Ext.Json.Stringify(data))
            return uuid
        end
    end
end



---@param entity EntityHandle
function AssignSkinToCharacter(entity)
    --#region
    -- Globals.MatVars.UsedSkinUUID = Globals.MatVars.UsedSkinUUID or {}
    -- Globals.MatVars.SkinMap = Globals.MatVars.SkinMap or {}
    -- local entity = Ext.Entity.Get(entity)
    -- if Globals.MatVars.SkinMap and Globals.MatVars.SkinMap[entity.Uuid.EntityUuid] then
    --     return Globals.MatVars.SkinMap[entity.Uuid.EntityUuid]
    -- end
    -- for i = 1, #CCSkinUuids do
    --     local uuidS = CCSkinUuids[i]
    --     if not Globals.MatVars.UsedSkinUUID[uuidS] then
    --         entity.CharacterCreationAppearance.SkinColor = uuidS
    --         Globals.MatVars.SkinMap[entity.Uuid.EntityUuid] = uuidS
    --         Globals.MatVars.UsedSkinUUID[uuidS] = true --I might even don't need this, since if the skin is mapped to a character then it's in use PonderingCat
    --         local data = {
    --             SkinMap = Globals.MatVars.SkinMap,
    --             UsedSkinUUID = Globals.MatVars.UsedSkinUUID
    --         }
    --         local temp = {
    --             uuid = entity.Uuid.EntityUuid,
    --             skinUuid = Globals.MatVars.SkinMap[entity.Uuid.EntityUuid]
    --         }
    --         Ext.Net.PostMessageToServer('CCEE_UsedMatVars', Ext.Json.Stringify(data))
    --         Ext.Net.PostMessageToServer('CCEE_ApplySkin', Ext.Json.Stringify(temp))
    --         return uuidS
    --     end
    -- end
    --#endregion
    return assignCharacterCreationAppearance(entity, CCSkinUuids, 'SkinMap', 'UsedSkinUUID')
end

---@param entity EntityHandle
function AssignHairToCharacter(entity)
    --#region
    -- Globals.MatVars.UsedHairUUID = Globals.MatVars.UsedHairUUID or {}
    -- Globals.MatVars.HairMap = Globals.MatVars.HairMap or {}
    -- local entity = Ext.Entity.Get(entity)
    -- if Globals.MatVars.HairMap and Globals.MatVars.HairMap[entity.Uuid.EntityUuid] then
    --     return Globals.MatVars.HairMap[entity.Uuid.EntityUuid]
    -- end
    -- for i = 1, #CCHairUuids do
    --     local uuidH = CCHairUuids[i]
    --     if not Globals.MatVars.UsedHairUUID[uuidH] then
    --         entity.CharacterCreationAppearance.HairColor = uuidH
    --         Globals.MatVars.HairMap[entity.Uuid.EntityUuid] = uuidH
    --         Globals.MatVars.UsedHairUUID[uuidH] = true
    --         local data = {
    --             HairMap = Globals.MatVars.HairMap,
    --             UsedHairUUID = Globals.MatVars.UsedHairUUID
    --         }
    --         local temp = {
    --             uuid = entity.Uuid.EntityUuid,
    --             hairUuid = Globals.MatVars.HairMap[entity.Uuid.EntityUuid]
    --         }
    --         Ext.Net.PostMessageToServer('CCEE_UsedMatVars', Ext.Json.Stringify(data))
    --         Ext.Net.PostMessageToServer('CCEE_ApplyHair', Ext.Json.Stringify(temp))
    --         return uuidH
    --     end
    -- end
    --#endregion
    return assignCharacterCreationAppearance(entity, CCHairUuids, 'HairMap', 'UsedHairUUID')
end


function AssignTattooToCharacter(entity)
    return assignCharacterCreationAppearance(entity, CCTattooUuids, 'TattooMap', 'UsedTattooUUID')
end



Ext.RegisterNetListener('CCEE_LoadMatVars', function (channel, payload, user)
    DPrint('CCEE_LoadMatVars')
    local data = Ext.Json.Parse(payload)
    if data.MatParameters['MatData'] then
        Globals.AllParameters.MatParameters = data.MatParameters['MatData']
        if data.single == true then
            DPrint('LoadMatVars Single')
            local entity = Ext.Entity.Get(data.entityUuid)
            local uuid = entity.Uuid.EntityUuid
            for materialUuids, parameterTypes in pairs(Globals.AllParameters.MatParameters[uuid]) do
                for parameterType, parameterNames in pairs(parameterTypes) do
                    for parameterName, value in pairs(parameterNames) do
                        Helpers.Timer:OnTicks(4, function ()
                            local materialPreset = Ext.Resource.Get(materialUuids,'MaterialPreset')
                            HandleMaterialPresetParameters(entity, parameterName, parameterType, value, materialPreset)
                        end)
                    end
                end
            end
        else
            DPrint('LoadMatVars All')
            local LoadMatVars_timer = 0
            for uuid, _ in pairs(Globals.AllParameters.MatParameters) do
                LoadMatVars_timer = LoadMatVars_timer + 10
                Helpers.Timer:OnTicks(LoadMatVars_timer, function ()
                local entity = Ext.Entity.Get(uuid)
                    for materialUuids, parameterTypes in pairs(Globals.AllParameters.MatParameters[uuid]) do
                        for parameterType, parameterNames in pairs(parameterTypes) do
                            for parameterName, value in pairs(parameterNames) do
                                Helpers.Timer:OnTicks(4, function ()
                                    local materialPreset = Ext.Resource.Get(materialUuids,'MaterialPreset')
                                    HandleMaterialPresetParameters(entity, parameterName, parameterType, value, materialPreset)
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end
end)


--#region
--tbd: combine into one function, perhaps elseif, perhaps learn something new
---Appplies the things to the PM dummies
function ApplyParametersToPMDummies()
    DPrint('ApplyParametersToPMDummies')
    for uuid, attachments in pairs(Globals.AllParameters.LastParameters) do
        local entity = MatchCharacterAndPMDummy(uuid)
        for attachment, parameterTypes in pairs(attachments) do
            for parameterType, parameterNames in pairs(parameterTypes) do
                for parameterName, value in pairs(parameterNames) do
                    SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
                end
            end
        end
    end
end

---Appplies the things to the paperdolls v2
function ApplyParametersToDollsTest(entity, uuid)
    DPrint('ApplyParametersToDollsTest')
    local attachments = Globals.AllParameters.LastParameters[uuid]
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


function ApplyParametersToCCDummy(entity)
    DPrint('ApplyParametersToCCDummy')
    local tempEntity = _C()
    local entityDummy
    local CC_Dumies = Ext.Entity.GetAllEntitiesWithComponent("ClientCCDummyDefinition")
    if entity and Globals.AllParameters.LastParameters[tempEntity.Uuid.EntityUuid] then
        for _,dummy in pairs(CC_Dumies) do
            if dummy and dummy.CCChangeAppearanceDefinition then
                if tempEntity.DisplayName.Name:Get() == dummy.CCChangeAppearanceDefinition.Appearance.Name then
                    entityDummy = dummy.ClientCCDummyDefinition.Dummy
                    table.insert(Globals.CC_Entities, entityDummy)
                    for _, v in pairs(Globals.CC_Entities) do
                        for attachment, parameterTypes in pairs(Globals.AllParameters.LastParameters[tempEntity.Uuid.EntityUuid]) do
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
    Globals.CC_Entities = {}
end


function ApplyParametersToTLPreview()
    local entity = Ext.Entity.GetAllEntitiesWithComponent("TLPreviewDummy")
    for q = 1, #entity do
        if entity and entity[q] then
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
    end
end
--#endregion


---Main thingy
Ext.RegisterNetListener('CCEE_LoadModVars', function (channel, payload, user)
    DPrint('CCEE_LoadModVars')
    getAllParameterNames(_C())
    local data = Ext.Json.Parse(payload)
    lastParametersMV = data.LastParameters
    Globals.AllParameters.LastParameters = data.LastParameters
    local TICKS_TO_WAIT = data.TICKS_TO_WAIT
    DPrint('Waiting ' ..  TICKS_TO_WAIT .. ' ticks before applying parameters')
    Helpers.Timer:OnTicks(TICKS_TO_WAIT, function()
        Helpers.Timer:OnTicks(TICKS_BEFORE_GAPM, function()
            Helpers.Timer:OnTicks(TICKS_BEFORE_LOADING, function()
                --tbd: UNITE the functions L u L 
                function LoadParametersSingle()
                    DPrint('SINGLE')
                    local uuid = data.entityUuid
                    Helpers.Timer:OnTicks(TICKS_BEFORE_APPLYING, function()
                        local entity = Ext.Entity.Get(uuid)
                        if entity and lastParametersMV[uuid] then
                        DPrint('Char: ' .. entity.DisplayName.Name:Get())
                            for attachment, parameterTypes in pairs(lastParametersMV[uuid]) do
                                for parameterType, parameterNames in pairs(parameterTypes) do
                                    for parameterName, value in pairs(parameterNames) do
                                        Helpers.Timer:OnTicks(4, function ()
                                            if CCState == true then
                                                local entity = Globals.dummyEntity
                                                SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
                                            else
                                                SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                end
                function LoadParameters()
                    DPrint('ALL')
                    Helpers.Timer:OnTicks(TICKS_BEFORE_APPLYING, function()
                        if lastParametersMV then 
                            local LoadModVars_timer = 0
                            for uuid, attachments in pairs(lastParametersMV) do
                                LoadModVars_timer = LoadModVars_timer + 10
                                Helpers.Timer:OnTicks(LoadModVars_timer, function ()
                                    local entity = Ext.Entity.Get(uuid)
                                    if entity and entity.DisplayName then
                                        DPrint('Char: ' .. entity.DisplayName.Name:Get()) ---entity.Uuid.EntityUuid
                                        for attachment, parameterTypes in pairs(attachments) do
                                            for parameterType, parameterNames in pairs(parameterTypes) do
                                                for parameterName, value in pairs(parameterNames) do
                                                    Helpers.Timer:OnTicks(5, function ()
                                                        SetActiveMaterialParameterValue(entity, attachment, parameterName, parameterType, value)
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end)
                end
                if data.single == true then
                    LoadParametersSingle()
                else
                    LoadParameters()
                end
            end)
        end)
    end)
    if _C() then 
        Elements:UpdateElements(_C().Uuid.EntityUuid)
    end
end)



local timer = nil
function TempThingy()
    if timer then
        Ext.Timer.Cancel(timer)
    end
    timer = Ext.Timer.WaitFor(500, function()
        -- Ext.Net.PostMessageToServer('UpdateParameters', '')
        Ext.Net.PostMessageToServer('CCEE_UpdateParameters_NotOnlyVis', '')
        getAllParameterNames(_C())
        timer = nil
    end)
end


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
    GlobalsIMGUI.presetsCombo.Options = Globals.Presets
    return false
end

---tbd: make "if presetName == fileName then" as separate function
---@param fileName string | nil
---@return boolean #if fileName exists in _PresetNames.json returns true
function ParsePresetNames(fileName)
    local Presets = {}
    Globals.Presets = {}
    if Ext.IO.LoadFile('CCEE/_PresetNames.json') then
        Presets = Ext.Json.Parse(Ext.IO.LoadFile('CCEE/_PresetNames.json'))
        for _, presetName in pairs(Presets) do
            table.insert(Globals.Presets, presetName)
            if presetName == fileName then
                return true
            end
        end
    end
    if GlobalsIMGUI.presetsCombo then
        GlobalsIMGUI.presetsCombo.Options = Globals.Presets
    end
    --DDump(Globals.Presets)
    Presets = nil
    return false
end
ParsePresetNames()


---@param fileName string
function SavePreset(fileName)
    DPrint('SavePreset')
    local uuid = _C().Uuid.EntityUuid
    local cca = getCharacterCreationAppearance(_C())
    local rippedMatParameters = {}
    if Globals.AllParameters.MatParameters[uuid] then
        for _,v in pairs(Globals.AllParameters.MatParameters[uuid]) do
            rippedMatParameters = v
        end
    else
        rippedMatParameters = nil
    end

    if Globals.AllParameters.LastParameters[uuid] then
        CCEEParams = Globals.AllParameters.LastParameters[uuid]
    else
        CCEEParams = nil
    end

    local dataSave = {
        {SkinMaterialParams = {rippedMatParameters or {}}},
        {CCEEParams = {CCEEParams or {}}},
        {DefaultCC = cca}
    }
    -- Presets.FileName = fileName
    -- Presets:AddOrChange('Preset', dataSave)
    -- Presets:SaveToFile()
    -- Presets.Data = {}
    RegisterPresetName(fileName)
    Ext.IO.SaveFile('CCEE/' .. fileName .. '.json', Ext.Json.Stringify(dataSave))
    dataSave = nil
end


---@param fileName string
function LoadPreset(fileName)
    local skinMatUuid
    local skinUuid
    local hairMatUuid
    DPrint('CCEE_LoadPreset')
    Ext.Net.PostMessageToServer('CCEE_RequestMatVars', '')
    Helpers.Timer:OnTicks(10, function ()
        local json = Ext.IO.LoadFile(('CCEE/' .. fileName .. '.json'))
        if json then
            if not ParsePresetNames(fileName) then
                RegisterPresetName(fileName)
            end
            local dataLoad = Ext.Json.Parse(json)
            local uuid = _C().Uuid.EntityUuid


            if Globals.MatVars.SkinMap and Globals.MatVars.SkinMap[_C().Uuid.EntityUuid] then
                skinMatUuid = Ext.StaticData.Get(Globals.MatVars.SkinMap[_C().Uuid.EntityUuid], 'CharacterCreationSkinColor').MaterialPresetUUID
            else
                if dataLoad[3] then
                    skinMatUuid = Ext.StaticData.Get(dataLoad[3].DefaultCC.SkinColor, 'CharacterCreationSkinColor').MaterialPresetUUID
                end
            end
            if dataLoad[3] then
                if dataLoad[3].DefaultCC.HairColor == Utils.ZEROUUID then
                    hairMatUuid = dataLoad[3].DefaultCC.HairColor
                else
                    hairMatUuid = Ext.StaticData.Get(dataLoad[3].DefaultCC.HairColor, 'CharacterCreationHairColor').MaterialPresetUUID
                end
            end

            --p8/Elen_G_3
            --sa/E_China


            if Globals.MatVars.SkinMap and Globals.MatVars.SkinMap[uuid] then
                skinUuid = Globals.MatVars.SkinMap[uuid]
            else
                if dataLoad[3] then
                    skinUuid = dataLoad[3].DefaultCC.SkinColor
                end
            end
            if dataLoad[3] then
                skinUuid = dataLoad[3].DefaultCC.HairColor
            end

            local data = {
                dataLoad = dataLoad,
                uuid = uuid,
                skinMatUuid = skinMatUuid,
                skinUuid = skinUuid,
                hairMatUuid = hairMatUuid,
                hairUuid = skinUuid
            }
            Helpers.Timer:OnTicks(3, function ()
                Ext.Net.PostMessageToServer('CCEE_LoadPreset', Ext.Json.Stringify(data))
            end)
        else
            GlobalsIMGUI.invalidName.Label = 'No presets with name' .. fileName .. ' were found'
            Helpers.Timer:OnTicks(100, function ()
                GlobalsIMGUI.invalidName.Label = ''
            end)
        end
    end)
    ParsePresetNames()
end



function RealodPreset()
    DPrint('RealodPreset')
    Ext.Net.PostMessageToServer('CCEE_RequestMatVars', '')
    Helpers.Timer:OnTicks(10, function ()
        local uuid = _C().Uuid.EntityUuid
        DPrint(_C())
        local cca = getCharacterCreationAppearance(_C())
        Helpers.Timer:OnTicks(5, function ()
            local SkinMaterialParams
            local skinMatUuid
            local skinUuid
            if Globals.MatVars.SkinMap then
                SkinMaterialParams = {Globals.AllParameters.MatParameters[uuid][Ext.StaticData.Get(Globals.MatVars.SkinMap[_C().Uuid.EntityUuid], 'CharacterCreationSkinColor').MaterialPresetUUID]}
                skinMatUuid = Ext.StaticData.Get(Globals.MatVars.SkinMap[_C().Uuid.EntityUuid], 'CharacterCreationSkinColor').MaterialPresetUUID
                skinUuid = Globals.MatVars.SkinMap[uuid]
            else
                SkinMaterialParams = {}
                skinMatUuid = nil
                skinUuid = nil
            end
            local dataLoad = {
                {SkinMaterialParams = SkinMaterialParams},
                {CCEEParams = {Globals.AllParameters.LastParameters[uuid]} or {}},
                {DefaultCC = cca},
            }
            local data = {
                dataLoad = dataLoad,
                uuid = uuid,
                skinMatUuid = skinMatUuid,
                skinUuid = skinUuid
            }
            Helpers.Timer:OnTicks(3, function ()
                Ext.Net.PostMessageToServer('CCEE_LoadPreset', Ext.Json.Stringify(data))
                data = {}
            end)
        end)
    end)
end

Ext.RegisterConsoleCommand('d', function ()
    DWarn('MAT DAT -----------------')
    DDump(Globals.MatVars.MatData)
    DWarn('SKIN MAP -----------------')
    DDump(Globals.MatVars.SkinMap)
    DWarn('USED SKIN -----------------')
    DDump(Globals.MatVars.UsedSkinUUID)
    DWarn('HAIR MAP -----------------')
    DDump(Globals.MatVars.HairMap)
    DWarn('USED HAIR -----------------')
    DDump(Globals.MatVars.UsedHairUUID)
end)


function StartPMSub()
    Utils:SubUnsubToTick('sub', 'PhotoMode', function ()
        local success, result = pcall(function()
            return Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext
        end)
            if success and result then
            if not Globals.inPhotoMode then
                Globals.inPhotoMode = true
                Helpers.Timer:OnTicks(40, function ()
                    ApplyParametersToPMDummies()
                end)
            end
        else
            Globals.inPhotoMode = false
        end
    end)
end


