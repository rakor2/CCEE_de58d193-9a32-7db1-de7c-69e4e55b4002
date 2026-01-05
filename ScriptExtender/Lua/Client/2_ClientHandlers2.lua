local function attachmentFound(entity, attachmentIndex, attachment)
    if not entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource then return end

    if  entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource.SkeletonSlot:lower():find(attachment:lower()) then return true end
    if  entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource.Slot == attachment                            then return true end
    if  entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource.Template:lower():find(attachment:lower()) and
        entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource.Slot ~= 'Private Parts'                       then return true end

end


function FindAttachment2(entity, attachment, onlyIndexPath)

    local Visuals  = {}
    local Indices  = {}
    local Paths    = {}

    local Attachments = entity.Visual.Visual.Attachments

    if attachment == 'Hair' then
        for i = 1, #Attachments do
            if attachmentFound(entity, i, attachment) then
                local path = {'Visual', 'Visual', 'Attachments', i, 'Visual'}

                table.insert(Indices, i)
                table.insert(Paths, path)

                if not onlyIndexPath then
                    table.insert(Visuals, Attachments[i].Visual)
                end
            end
        end

    elseif attachment == 'Piercing' then
        local xd = Attachments[2]
        if xd and xd.Visual and xd.Visual.Attachments then
            for q = 1, #xd.Visual.Attachments do
                local poggers = xd.Visual.Attachments[q]
                if poggers.Visual and
                   poggers.Visual.VisualResource and
                   poggers.Visual.VisualResource.Slot and
                   poggers.Visual.VisualResource.Slot:lower():find('piercing') then

                    local path = {'Visual', 'Visual', 'Attachments', 2, 'Visual', 'Attachments', q, 'Visual'}

                    table.insert(Indices, q)
                    table.insert(Paths, path)

                    if not onlyIndexPath then
                        table.insert(Visuals, poggers.Visual)
                    end
                end
            end
        end

    elseif attachment == 'NakedBody' then
        for i = 1, #Attachments do
            local Visual = Attachments[i].Visual
            if Visual and Visual.VisualResource then
                for _, object in pairs(Visual.VisualResource.Objects or {}) do

                    --Searching for the body attachment throught object's name to support regular body attachment and dummy body attachment for outfits
                    --Yes, body attachment is always 1, but I need to support dummy one also

                    if object.ObjectID and object.ObjectID:lower():find('body') then

                        local path = {'Visual', 'Visual', 'Attachments', i, 'Visual'}

                        table.insert(Indices, i)
                        table.insert(Paths, path)

                        if not onlyIndexPath then
                            table.insert(Visuals, Visual)
                        end

                        break
                    end
                end
            end
        end

    else
        for i = 1, #Attachments do
            if attachmentFound(entity, i, attachment) then
                local path = {'Visual', 'Visual', 'Attachments', i, 'Visual'}

                table.insert(Indices, i)
                table.insert(Paths, path)

                if not onlyIndexPath then
                    table.insert(Visuals, Attachments[i].Visual)
                end
            end
        end
    end

    return Visuals, Indices, Paths
end



local function nameCheck(name, attachment, parameterType)
    for _, existingName in ipairs(Parameters2[attachment][parameterType]) do
        if existingName == name then
            return true
        end
    end
end



local function insertParameter(ActiveMaterial, attachment, parameterType)
    if not parameterType then return end
    if not ActiveMaterial.Material.Parameters[parameterType] then return end

    for _, sp in ipairs(ActiveMaterial.Material.Parameters[parameterType]) do
        local parameterName = sp.ParameterName
        if not nameCheck(parameterName, attachment, parameterType) then
            table.insert(Parameters2[attachment][parameterType], parameterName)
        end
    end

end



---Gets entity's (character's) all available meterial parameters
---@param entity EntityHandle
function BuildAllParametersTable(entity)

    Parameters2 = {}
    local entity = entity or _C()

    for _, attachment in ipairs(AllAttachments) do
        for _, parameterType in ipairs(AllParameterTypes) do

            local Visuals = FindAttachment2(entity, attachment)

            if Visuals then

                Parameters2[attachment] = Parameters2[attachment] or {}
                Parameters2[attachment][parameterType] = Parameters2[attachment][parameterType] or {}

                for _, visuals in pairs(Visuals) do
                    if visuals and visuals.ObjectDescs then
                        for od = 1, #visuals.ObjectDescs do
                            local ActiveMaterial = visuals.ObjectDescs[od].Renderable.ActiveMaterial
                            if ActiveMaterial and ActiveMaterial.Material then
                                insertParameter(ActiveMaterial, attachment, parameterType)
                            end
                        end
                    end
                end
            end
        end
    end

    for attachment, types in pairs(Parameters2) do
        for parameterType, parameterName in pairs(types) do
            table.sort(parameterName)
        end
    end

    --sloppy toppy xd
    for attachment, data in pairs(Parameters2) do
        local keep = false
        for _, list in pairs(data) do
            if #list > 0 then
                keep = true
                break
            end
        end
        if not keep then
            Parameters2[attachment] = nil
        end
    end

    -- _DD(Parameters2, 'ccee_parameters2')
    return Parameters2
end