local function attachmentFound(entity, attachmentIndex, attachment)
    if not entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource then return end

    if  entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource.SkeletonSlot:lower():find(attachment:lower()) then return true end
    if  entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource.Slot == attachment                            then return true end
    if  entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource.Template:lower():find(attachment:lower()) and
        entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource.Slot ~= 'Private Parts'                       then return true end

end



---@param entity EntityHandle
---@param attachment VisualAttachment | string
---@return Visual[]
function FindAttachment2(entity, attachment) ---TBD: Change fn name
    if entity and entity.Visual and entity.Visual.Visual then
            for attachmentIndex = 1, #entity.Visual.Visual.Attachments do

                if  attachment == 'Tail' or
                    attachment == 'Head' or
                    attachment == 'Private Parts' or
                    attachment == 'Wings'
                then
                    if attachmentFound(entity, attachmentIndex, attachment) then
                        local Visuals = entity.Visual.Visual.Attachments[attachmentIndex].Visual
                        return {Visuals}
                    end

                elseif attachment == 'Hair' then
                    local HairVisuals = {}
                    for attachmentIndex = 1, #entity.Visual.Visual.Attachments do
                        --Searching all possible hair attachments due to some mods add additional hair things as jaw, etc
                        if attachmentFound(entity, attachmentIndex, attachment) then
                            local Visuals = entity.Visual.Visual.Attachments[attachmentIndex].Visual
                            return {Visuals}
                        end
                    end


                elseif attachment == 'Piercing' then
                    local PiercingVisuals = {}
                    for q = 1, #entity.Visual.Visual.Attachments[2].Visual.Attachments do
                        if  entity.Visual.Visual.Attachments[2].Visual.Attachments[q].Visual.VisualResource and
                            entity.Visual.Visual.Attachments[2].Visual.Attachments[q].Visual.VisualResource.Slot:lower():find(attachment:lower())
                        then
                            for _,v in pairs(entity.Visual.Visual.Attachments[attachmentIndex].Visual.Attachments) do
                                local Visuals = v.Visual
                                return {Visuals}
                            end
                        end
                    end


                elseif attachment == 'NakedBody' then
                    local BodyVisuals = {}
                    for attachmentIndex = 1, #entity.Visual.Visual.Attachments do
                        if entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource then

                        --Searching for the body attachment throught object's name to support regular body attachment and dummy body attachment for outfits
                        --Yes, body attachment is always 1, but I need to support dummy one also
                        for _, Objects in pairs(entity.Visual.Visual.Attachments[attachmentIndex].Visual.VisualResource.Objects) do
                            if Objects.ObjectID:lower():find('body') then
                                local Visuals = entity.Visual.Visual.Attachments[attachmentIndex].Visual
                                return {Visuals}
                            end
                        end
                    end
                end

                else
                --Other attachments. Also sucks up outfit's parameters, since it is an attachment
                if attachmentFound(entity, attachmentIndex, attachment) then
                    local Visuals = entity.Visual.Visual.Attachments[attachmentIndex].Visual
                    return {Visuals}
                end
            end
        end
    end
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
    return Parameters2
end