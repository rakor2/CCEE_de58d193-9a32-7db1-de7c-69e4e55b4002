---@enum UNSPOKEN_ENUM
En_State = {
    only_index_and_path = true
}



_GLL.Parameters = {}
_GLL.ParameterTypeCache = {}
_GLL.StoredVisualPaths = {}



_GLL.SavedParameters = {}
_GLL.SavedParameters.ActiveMaterial = {}
_GLL.SavedParameters.MaterialPreset = {}


_GLL.CharacterSkinMap = {}


_GLL.selectedCharacter = nil


_GLL.AllParameters = {}
_GLL.AllParameters.ActiveMatParameters = {}
_GLL.AllParameters.MatPresetParameters = {}
_GLL.AllParameters.CCEEModStuff = {}



_GLL.AllParameters.CCEEModStuff = {}
_GLL.AllParameters.CCEEModStuff.SkinMap = {}
_GLL.AllParameters.CCEEModStuff.HairMap = {}
_GLL.AllParameters.CCEEModStuff.UsedSkinUUID = {}
_GLL.AllParameters.CCEEModStuff.UsedHairUUID = {}



function GetUnmatchedParameters()
    local UnmatchedParameters = {}
    local CategoryIndex = {}

    for catAttachment, categories in pairs(CategoriesLayout) do
        local mappedAttachment = AttachmentMap[catAttachment] or catAttachment
        CategoryIndex[mappedAttachment] = CategoryIndex[mappedAttachment] or {}

        for _, categoryParams in pairs(categories) do
            for _, paramName in pairs(categoryParams) do
                CategoryIndex[mappedAttachment][paramName] = true
            end
        end
    end

    for uuid, attachments in pairs(_GLL.Parameters) do
        for attachment, parameterTypes in pairs(attachments) do
            for parameterType, parameters in pairs(parameterTypes) do
                for parameterName, value in pairs(parameters) do
                    local isKnown = CategoryIndex[attachment] and
                        CategoryIndex[attachment][parameterName]

                    if not isKnown and uuid and attachment and parameterType and parameterName and value then
                        EnsureTable(UnmatchedParameters, uuid, attachment, parameterType, parameterName)
                        if UnmatchedParameters[uuid]
                            and UnmatchedParameters[uuid][attachment]
                            and UnmatchedParameters[uuid][attachment][parameterType]
                            and UnmatchedParameters[uuid][attachment][parameterType][parameterName]
                        then
                            UnmatchedParameters[uuid][attachment][parameterType][parameterName] = value
                        end
                    end
                end
            end
        end
    end
    -- cleanTable(UnmatchedParameters)
    return UnmatchedParameters
end



--- Sets initial value for the elements when rebuilding all parameter controls
function SetValueForElement(element, objectPaths, attachment, parameterName)
    local parameterType = Mat.GetParameterType(parameterName)

    if parameterType then
        -- DPrint('Name: %s', parameterName)
        -- DPrint('Type: %s', parameterType)
        local objectPath = objectPaths[1] or objectPaths
        local Visuals = objectPath:Resolve()
        local value = Material:GetCharacterParameterValue(Visuals, parameterType, parameterName)

        if not value then return end
            if     parameterType == PT.scl then element.Value = {value, 0, 0, 0}
            elseif parameterType == PT.v3  then element.Color = {value[1], value[2], value[3], 1}
            elseif parameterType == PT.v4  then element.Color = {value[1], value[2], value[3], value[4]}

        end
    end
end



function SaveParametersSingle(entity)
    local entity = entity or Ext.Entity.Get(_GLL.selectedCharacter) or _C()
    local uuid = entity.Uuid.EntityUuid

    _GLL.SavedParameters[uuid] = table.deepCopy(_GLL.Parameters[uuid])
    Utils:CleanTable(_GLL.SavedParameters)

    return _GLL.SavedParameters
end



function LoadFromParametersSingel(entity)
    DPrint('XD')
end



function LoadParametersSingle(entity)
    local timeStart = Ext.Timer.MonotonicTime()
    local entity = entity or Ext.Entity.Get(_GLL.selectedCharacter) or _C()
    local uuid = entity.Uuid.EntityUuid

    for attachment, ParameterTypes in pairs(_GLL.SavedParameters[uuid]) do
        for parameterType, ParameterNames in pairs(ParameterTypes) do
            for parameterName, value in pairs(ParameterNames) do
                ResolveAndSetValue(uuid, attachment, parameterType, parameterName, value)
            end
        end
    end

    local timeEnd = Ext.Timer.MonotonicTime()
    -- DPrint('LoadParametersSingle took: %s ms', timeEnd - timeStart)

    return _GLL.Parameters
end



function LoadParametersAll()
    local timeStart = Ext.Timer.MonotonicTime()

    for uuid, Attachments in pairs(_GLL.SavedParameters or _GLL.Parameters) do
        for attachment, ParameterTypes in pairs(Attachments) do
            for parameterType, ParameterNames in pairs(ParameterTypes) do
                for parameterName, value in pairs(ParameterNames) do
                    ResolveAndSetValue(uuid, attachment, parameterType, parameterName, value)
                end
            end
        end
    end

    local timeEnd = Ext.Timer.MonotonicTime()
    -- DPrint('LoadParametersAll took: %s ms', timeEnd - timeStart)

    return _GLL.Parameters
end



function LoadParametersToDummy(uuid)
    if not uuid then return end
    local timeStart = Ext.Timer.MonotonicTime()

    local entity = Ext.Entity.Get(uuid)

    if entity and entity.HasDummy then
        local dummy = Dummy:Get(entity)

        if _GLL.Parameters and _GLL.Parameters[uuid] then
            for attachment, ParameterTypes in pairs(_GLL.Parameters[uuid]) do
                for parameterType, ParameterNames in pairs(ParameterTypes) do
                    for parameterName, value in pairs(ParameterNames) do
                        -- DPrint(attachment)

                        ResolveAndSetValueToUuidless(dummy, uuid, attachment, parameterType, parameterName, value)
                    end
                end
            end
        end

        local timeEnd = Ext.Timer.MonotonicTime()
        -- DPrint('LoadParametersToDummy took: %s ms', timeEnd - timeStart)
    end
end



function LoadParametersToAllDummies()
    local Origins = Entity:GetOrigins()
    for _, origin in pairs(Origins) do
        LoadParametersToDummy(origin.Uuid.EntityUuid)
    end
end



function LoadParametersToPaperdoll(entity)
    DPrint('XD')
end



function LoadParametersToPreviewDummy(entity)
    DPrint('XD')
end



--- Resolves path and sets value for the parameter
function ResolveAndSetValue(uuid, attachment, parameterType, parameterName, value)
    local objectPaths = _GLL.StoredVisualPaths[uuid][attachment]
    if not objectPaths then return end

    for _, objectPath in ipairs(objectPaths) do
        if objectPath and objectPath.Resolve then
            local Visuals = objectPath:Resolve()

            -- DPrint('Type: %s, Name: %s', parameterType, parameterName)

            Material:SetCharacterParameterValue(Visuals, parameterType, parameterName, value)

            if _GLL.Parameters[uuid][attachment][parameterType] then

                -- DPrint(attachment)
                -- DPrint(parameterType)
                -- DPrint(parameterName)
                -- DPrint('--------------------')

                _GLL.Parameters[uuid][attachment][parameterType][parameterName] = value
            end

            -- DDump(_GLL.AllParameters.ActiveMatParameters[uuid][attachment][parameterType][parameterName])
            -- DPrint('Attachment: %s, Type: %s, Name: %s, Value: %s', attachment, parameterType, parameterName, value)

            --- Temporal garbo thing to make it work with current main ccee implementation
            -- if _GLL.AllParameters.ActiveMatParameters[uuid][attachment] and
            --    _GLL.AllParameters.ActiveMatParameters[uuid][attachment][parameterType]
            -- then
            --     _GLL.AllParameters.ActiveMatParameters[uuid][attachment][parameterType][parameterName] = value
            -- end

            --- TBD: temp
            -- local Data = {
            --     entityUuid = uuid,
            --     attachment = attachment,
            --     parameterType = parameterType,
            --     parameterName = parameterName,
            --     value = value
            -- }
            -- Ext.Net.PostMessageToServer('CCEE_SendSingleActiveMatVars', Ext.Json.Stringify(Data))
        end
    end
end



--- Trash
--- Re-resolving path for photo mode dummies due to how I implemented the thing in the first place.
--- Maybe refactor some other time
function ResolveAndSetValueToUuidless(entity, uuid, attachment, parameterType, parameterName, value)
    -- DPrint(entity)
    -- DPrint(_GLL.StoredVisualPaths[uuid])
    -- DPrint(_GLL.StoredVisualPaths[uuid][attachment])
    -- DPrint(_GLL.StoredVisualPaths[uuid][attachment])
    local objectPaths = _GLL.StoredVisualPaths[uuid][attachment]
    if objectPaths then
        -- DPrint('1')
        for _, objectPath in ipairs(objectPaths) do
            local Visuals = ObjectPath:New(entity, objectPath.Path):Resolve()
            if Visuals then
                Material:SetCharacterParameterValue(Visuals, parameterType, parameterName, value)

                if _GLL.Parameters[uuid][attachment][parameterType] then

                    -- DPrint(attachment)
                    -- DPrint(parameterType)
                    -- DPrint(parameterName)
                    -- DPrint('--------------------')

                    _GLL.Parameters[uuid][attachment][parameterType][parameterName] = value
                end

            end
        end
    end
end



--- Syncs elements values between ParametersToSync
function SyncElementValue(syncedAttachment, parameterName, elementName)
    local syncedElementName = syncedAttachment .. '_' .. parameterName

    if E[syncedElementName] then
        local isSlider = pcall(function()
            return E[syncedElementName].Value
        end)

        if isSlider then
            E[syncedElementName].Value = E[elementName].Value
        else
            E[syncedElementName].Color = E[elementName].Color
        end
    end
end



function SetValueWithSync(elementName, attachment, parameterType, parameterName, value)
    local entity = entity or Ext.Entity.Get(_GLL.selectedCharacter) or _C()
    local uuid = entity.Uuid.EntityUuid

    if ParametersToSync[parameterName] then
        for _, syncedAttachment in pairs(AllAttachments) do
            if _GLL.Parameters[uuid]
            and _GLL.Parameters[uuid][syncedAttachment]
            and _GLL.StoredVisualPaths[uuid][syncedAttachment] then

                ResolveAndSetValue(uuid, syncedAttachment, parameterType, parameterName, value)
                SyncElementValue(syncedAttachment, parameterName, elementName)
            end
        end
    else
        ResolveAndSetValue(uuid, attachment, parameterType, parameterName, value)
    end
end



function CreateElementForParameter(parent, widgetKey, attachment, parameterName)
    local max = 5
    local min = -max
    local cfg = ParametersConfig[parameterName] or {}
    local parameterType = Mat.GetParameterType(parameterName)

    if parameterType == PT.scl then
        if cfg.int then
            E[widgetKey] = parent:AddDragInt(parameterName, 0, min, max, 1)
        else
            E[widgetKey] = parent:AddDrag(parameterName, 0, min, max, 0.1)
        end
            UI:Config(E[widgetKey], {
                -- Logarithmic = cfg.log or false,
                OnChange = function(e)
                    local value = e.Value[1]
                    SetValueWithSync(widgetKey, attachment, parameterType, parameterName, value)
                end
            })
    end

    if parameterType == PT.v3 then
        E[widgetKey] = parent:AddColorEdit(parameterName)
            UI:Config(E[widgetKey], {
                NoAlpha = true,
                OnChange = function(e)
                    local value = { e.Color[1], e.Color[2], e.Color[3] }
                    SetValueWithSync(widgetKey, attachment, parameterType, parameterName, value)
                end
            })
    end

    if parameterType == PT.v4 then
        E[widgetKey] = parent:AddColorEdit(parameterName)
            UI:Config(E[widgetKey], {
                NoAlpha = false,
                OnChange = function(e)
                    local value = e.Color
                    SetValueWithSync(widgetKey, attachment, parameterType, parameterName, value)
                end
            })
    end
end



function StoreVisualPaths(entity)
    local uuid = entity.Uuid.EntityUuid

    for _, attachment in ipairs(AttachmentsOrder) do
        if _GLL.Parameters[uuid] and _GLL.Parameters[uuid][attachment] then
            local _, _, Paths = Att.FindAttachment(entity, attachment, En_State.only_index_and_path)

            Utils:EnsureTable(_GLL.StoredVisualPaths, uuid, attachment)
            for _, path in ipairs(Paths) do
                table.insert(_GLL.StoredVisualPaths[uuid][attachment], ObjectPath:New(entity, path))
            end
        end
    end
    return _GLL.StoredVisualPaths
end



function CreateControlsInSortedTrees()
    local timeStart = Ext.Timer.MonotonicTime()

    local p = E.grpCat
    local Trees = {}
    local CatTrees = {}
    local entity = entity or Ext.Entity.Get(_GLL.selectedCharacter) or _C()
    local uuid = entity.Uuid.EntityUuid

    for _, mainCategoryName in ipairs(AttachmentsOrderXD) do
        local attachment = AttachmentMap[mainCategoryName] or mainCategoryName
        local SubCategories = CategoriesLayout[mainCategoryName]
        local SubCatOrder = {}

        CatTrees[attachment] = p:AddCollapsingHeader(mainCategoryName) --- Main collapse
        CatTrees[attachment].IDContext = Ext.Math.Random(1, 10000)
        Trees[attachment] = Trees[attachment] or {}

        if SubCategories then
            for subCatName, _ in pairs(SubCategories) do
                table.insert(SubCatOrder, subCatName)
            end
            table.sort(SubCatOrder)

            for _, subCatName in ipairs(SubCatOrder) do
                if not Trees[attachment][subCatName] then
                    local tree = CatTrees[attachment]:AddTree(subCatName) --- Tree
                    tree.IDContext = Ext.Math.Random(1, 1000)
                    Trees[attachment][subCatName] = tree
                    tree:AddSeparator()
                end

                local parentTree = Trees[attachment][subCatName]
                parentTree.IDContext = Ext.Math.Random(1, 1000)

                for _, parameterName in ipairs(SubCategories[subCatName]) do
                    local widgetName = attachment .. '_' .. parameterName

                    -- DPrint(parameterName)
                    -- DPrint(attachment)

                    --- Populating trees with the imjui widgets HERE
                    --- Populating trees with the imjui widgets HERE
                    --- Populating trees with the imjui widgets HERE
                    CreateElementForParameter(parentTree, widgetName, attachment, parameterName)

                    if widgetName and E[widgetName]
                        and _GLL.StoredVisualPaths
                        and _GLL.StoredVisualPaths[uuid]
                        and _GLL.StoredVisualPaths[uuid][attachment]
                    then
                        -- DPrint(attachment)
                        -- DDump(_GLL.StoredVisualPaths[uuid][attachment])
                        SetValueForElement(E[widgetName], _GLL.StoredVisualPaths[uuid][attachment], attachment, parameterName)
                    end
                end
                parentTree:AddSeparator()
            end
        end
        CatTrees[attachment]:AddSeparator()
    end

    CatTrees['Unsorted'] = p:AddCollapsingHeader('Unsorted')
    CreateControlsInUnsortedTree(CatTrees['Unsorted'])
    CreateDiffusionProfileControls(E.grpDiffusion)


    --- I hate cats atp
    local timeEnd = Ext.Timer.MonotonicTime()
    -- DPrint('CreateControlsInSortedTrees took: %s ms', timeEnd - timeStart)
end



function CreateControlsInUnsortedTree(parent)
    local timeStart = Ext.Timer.MonotonicTime()

    local UnsortedTrees = {}
    local UnsortedParameters = GetUnmatchedParameters()
    local entity = entity or Ext.Entity.Get(_GLL.selectedCharacter) or _C()
    local uuid = entity.Uuid.EntityUuid
    local Attachments = UnsortedParameters[uuid]

    if Attachments then
        for attachment, ParameterTypes in pairs(Attachments) do
            local catTree = parent:AddTree(attachment)
            UnsortedTrees[attachment] = UnsortedTrees[attachment] or {}

            for parameterType, parameterNames in pairs(ParameterTypes) do
                if not UnsortedTrees[attachment][parameterType] then
                    local tree = catTree:AddTree(parameterType)
                    tree.IDContext = Ext.Math.Random(1, 10000)
                    UnsortedTrees[attachment][parameterType] = tree
                end

                local parentTree = UnsortedTrees[attachment][parameterType]

                for parameterName, _ in pairs(parameterNames) do
                    local elementName = attachment .. '_' .. parameterName

                    CreateElementForParameter(parentTree, elementName, attachment, parameterName)
                    SetValueForElement(E[elementName], _GLL.StoredVisualPaths[uuid][attachment], attachment, parameterName)
                end
            end
        end
    end

    local timeEnd = Ext.Timer.MonotonicTime()
    -- DPrint('CreateControlsInUnsortedTree took: %s ms', timeEnd - timeStart)
end



--- Basically the main UI thing
function GetParametersAndBuildControls(entity)
    local timeStart = Ext.Timer.MonotonicTime()

    if entity then
        StoreVisualPaths(entity)
        Mat.GetParametersSingleCharacter(entity)
    else
        local Origins = Entity:GetOrigins()

        for _, entity in pairs(Origins) do
            Mat.GetParametersSingleCharacter(entity)
            StoreVisualPaths(entity)
        end
    end

    --- I'd really like to track what to rebuild and what to not rebuild, and just change paths, but holy shit, I don't care. 20ms it is.
    --- Too complicated, and I don't really see how to, and I don't want to full slop. Maybe one day
    CreateControlsInSortedTrees()
    local timeEnd = Ext.Timer.MonotonicTime()
    -- DPrint('GetParametersAndBuildControls took: %s ms', timeEnd - timeStart)
end



function GetSkinColors(uuid)
    local SkinColor = {}
    local uuid = uuid or '685eb026-02d2-41f4-9de9-b2dd51de40e5'
    local Skin = Ext.StaticData.Get(uuid, 'CharacterCreationSkinColor')
    local SkinPreset = Ext.Resource.Get(Skin.MaterialPresetUUID, 'MaterialPreset')
    local UIColor = Skin.UIColor

    for parameterType, Parameters in pairs(SkinPreset.Presets) do
        if parameterType == PT.scl or  parameterType == PT.v3 or parameterType == PT.v4 then
            for _, Parameter in pairs(Parameters) do
                Utils:EnsureTable(SkinColor, parameterType, Parameter.Parameter)
                SkinColor[parameterType][Parameter.Parameter] = Parameter.Value
            end
        end
    end
    return SkinColor
end



function CreateDiffusionProfileControls(parent)
    E.collpaseDiffusion = parent:AddCollapsingHeader('Diffusion profile')
    local p = E.collpaseDiffusion
    local Profile = Ext.Resource.Get('a8c42087-d32f-9cbe-6b0c-d566de6a082d', 'DiffusionProfile')

    local function SetDiffusionProfile()
        for i = 1, 2 do
            local ObjectDescs = Apply.entity.Visual.Visual.Attachments[i].Visual.ObjectDescs[1]
            ObjectDescs.Renderable.ActiveMaterial.Material.DiffusionProfileUUID = 'a8c42087-d32f-9cbe-6b0c-d566de6a082d'
        end
    end

    for k, v in pairs(Profile) do
        if type(v) ~= 'string'
            and type(v) ~= 'boolean'
            and k ~= 'RefCount'
            and k ~= 'State'
        then
            if type(v) == 'number' then
                E[k] = p:AddDrag(k, v, 0, 100)
                    UI:Config(E[k], {
                        Value = {v, 0,0,0},
                        OnChange = function(e)
                            SetDiffusionProfile()
                            Ext.Resource.Get('a8c42087-d32f-9cbe-6b0c-d566de6a082d', 'DiffusionProfile')[k] = e.Value[1]
                        end
                    })

            elseif type(v) == 'table' or 'userdata' then
                E[k] = p:AddColorEdit(k)
                    UI:Config(E[k], {
                        Color = {v[1], v[2], v[3], 1},
                        OnChange = function(e)
                            SetDiffusionProfile()
                            Ext.Resource.Get('a8c42087-d32f-9cbe-6b0c-d566de6a082d', 'DiffusionProfile')[k] = {e.Color[1], e.Color[2], e.Color[3]}
                        end
                    })
            end
        end
    end
end




function LoadPreset2(uuid, presetName)
    local entity = _C()
    local uuid = uuid or entity.Uuid.EntityUuid
    local presetName = presetName or 'se/E2_Short_Hair'
    local Preset = Ext.IO.LoadFile('CCEE/' .. presetName .. '.json')
    if Preset then
        Preset = Ext.Json.Parse(Preset)
        DDump(Preset[2]['CCEEParams'])
        _GLL.SavedParameters[uuid] = {}
        -- _GLL.Parameters[uuid] = {}

        _GLL.SavedParameters[uuid] = Preset[2]['CCEEParams']
        -- _GLL.Parameters[uuid] = Preset[2]['CCEEParams']
    end


    StoreVisualPaths(entity)
    LoadParametersSingle(entity)

end