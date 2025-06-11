
TICKS_BEFORE_GAPM = 0
TICKS_BEFORE_LOADING = 0
TICKS_BEFORE_APPLYING = 1

Parameters = Parameters or {}
lastParameters = lastParameters or {}
currentParameters = currentParameters or {}



---@param type integer # 1 - keyborad / 0 - controller
---@param bindingIndex integer 
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


--tbd: pairs ipairs or some shit 
function MoneyCounter()
    tattooCount = 0
    makeupCount = 0
    scarCount = 0
    -- customCount = 0 
    -- local kavtCount = 0

        for _,v in ipairs(Ext.StaticData.GetAll('CharacterCreationAppearanceMaterial')) do
            local name = Ext.Loca.GetTranslatedString(Ext.StaticData.Get(v, 'CharacterCreationAppearanceMaterial').DisplayName.Handle.Handle)
            if name:lower():find('tattoo') then
                tattooCount = tattooCount + 1
                -- if name:lower():find('kaz') then
                --     kavtCount = kavtCount + 1
                -- end
                -- tattoes = tattooCount - kavtCount
            end
        end

        for _,v in ipairs(Ext.StaticData.GetAll('CharacterCreationAppearanceMaterial')) do
            local name = Ext.Loca.GetTranslatedString(Ext.StaticData.Get(v, 'CharacterCreationAppearanceMaterial').DisplayName.Handle.Handle)
            if name:lower():find('make') then
                makeupCount = makeupCount + 1
            end
        end

        for _,v in ipairs(Ext.StaticData.GetAll('CharacterCreationAppearanceMaterial')) do
            local name = Ext.Loca.GetTranslatedString(Ext.StaticData.Get(v, 'CharacterCreationAppearanceMaterial').DisplayName.Handle.Handle)
            if name:lower():find('scar') then
                scarCount = scarCount + 1
            end
        end

        -- for _,v in ipairs(Ext.StaticData.GetAll('CharacterCreationAppearanceMaterial')) do
        --     local name = Ext.Loca.GetTranslatedString(Ext.StaticData.Get(v, 'CharacterCreationAppearanceMaterial').DisplayName.Handle.Handle)
        --     if name:lower():find('custom') then
        --         customCount = customCount + 1
        --     end
        -- end

        -- DPrint(customCount)
end
MoneyCounter()



function FindAttachment(entity, attachment)
    if entity then
        for i = 1, #entity.Visual.Visual.Attachments do
            if attachment == 'Tail' then
                if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.SkeletonSlot:lower():find(attachment:lower()) then
                    local visuals = entity.Visual.Visual.Attachments[i].Visual
                    return visuals
                end
            else
                if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot:lower():find(attachment:lower()) then
                    local visuals = entity.Visual.Visual.Attachments[i].Visual
                    return visuals
                end
            end
        end
    end
end


function GetAllParameterNames(entity)

    Parameters = {}

    local entity = entity or _C()

    for _, attachment in ipairs({'Head', 'Body', 'Private Parts', 'Tail', 'Horns', 'Hair'}) do
        for _, parameterType in ipairs({'Scalar', 'Vector3', 'Vector'}) do
            local visuals = FindAttachment(entity, attachment)

            if visuals then
        
                Parameters[attachment] = Parameters[attachment] or {}
                Parameters[attachment][parameterType] = Parameters[attachment][parameterType] or {}
        
                local function NameCheck(name)
                    for _, existingName in ipairs(Parameters[attachment][parameterType]) do
                        if existingName == name then
                            return true
                        end
                    end
                end
        
                for od = 1, #visuals.ObjectDescs do
        
                    local am = visuals.ObjectDescs[od].Renderable.ActiveMaterial
        
                    if am ~= nil and am.Material ~= nil then
                        if parameterType == 'Scalar' then
                            for _, sp in ipairs(am.Material.Parameters.ScalarParameters) do
                                local pn = sp.ParameterName
                                if not NameCheck(pn) then
                                    table.insert(Parameters[attachment][parameterType], pn)
                                end
                            end
                        end
                        if parameterType == 'Vector3' then
                            for _, v3p in ipairs(am.Material.Parameters.Vector3Parameters) do
                                local pn = v3p.ParameterName
                                if not NameCheck(pn) then
                                    table.insert(Parameters[attachment][parameterType], pn)
                                end
                            end
                        end
                        if parameterType == 'Vector' then
                            for _, v in ipairs(am.Material.Parameters.VectorParameters) do
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
    -- DDump(Parameters)
end


function GetAllCurrentParameters()




    local characters = Ext.Entity.GetAllEntitiesWithComponent("Origin")
    for _, character in ipairs(characters) do

        local uuid = character.Uuid.EntityUuid
        currentParameters[uuid] = currentParameters[uuid] or {}

        for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail', 'Horns', 'Hair'}) do
            for _, parameterType in ipairs({'Scalar', 'Vector3', 'Vector'}) do
                local visuals = FindAttachment(character, attachment)

                if visuals then
            
                    currentParameters[uuid][attachment] = currentParameters[uuid][attachment] or {}
                    currentParameters[uuid][attachment][parameterType] = currentParameters[uuid][attachment][parameterType] or {}
                    currentParameters[uuid][attachment][parameterType] = currentParameters[uuid][attachment][parameterType] or {}

                    for od = 1, #visuals.ObjectDescs do
            
                        local am = visuals.ObjectDescs[od].Renderable.ActiveMaterial
            
                        if am ~= nil and am.Material ~= nil then
                            if parameterType == 'Scalar' then
                                for _, sp in ipairs(am.Material.Parameters.ScalarParameters) do
                                    local parameterName = sp.ParameterName
                                    local pv = sp.Value
                                    currentParameters[uuid][attachment][parameterType][parameterName] = currentParameters[uuid][attachment][parameterType][parameterName] or {}
                                    table.insert(currentParameters[uuid][attachment][parameterType][parameterName], pv)
                                end
                            end
                            if parameterType == 'Vector3' then
                                for _, v3p in ipairs(am.Material.Parameters.Vector3Parameters) do
                                    local parameterName = v3p.ParameterName
                                    local pv = v3p.Value
                                    currentParameters[uuid][attachment][parameterType][parameterName] = currentParameters[uuid][attachment][parameterType][parameterName] or {}
                                    table.insert(currentParameters[uuid][attachment][parameterType][parameterName], pv)
                                end
                            end
                            if parameterType == 'Vector' then
                                for _, v in ipairs(am.Material.Parameters.VectorParameters) do
                                    local parameterName = v.ParameterName
                                    local pv = v.Value
                                    currentParameters[uuid][attachment][parameterType][parameterName] = currentParameters[uuid][attachment][parameterType][parameterName] or {}
                                    table.insert(currentParameters[uuid][attachment][parameterType][parameterName], pv)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    DDump(currentParameters['dd0251c9-c9a6-9549-4c5e-09f45f8b9fcf'])
end


--they call it junk or jank
function MatchCharacterAndPMDummy(charUuid)
    local originEnt = Ext.Entity.Get(charUuid)
    for i = 1, #dummies do
        if originEnt.Transform.Transform.Translate[1] == dummies[i].Transform.Transform.Translate[1]
            and originEnt.Transform.Transform.Translate[2] == dummies[i].Transform.Transform.Translate[2] 
            and originEnt.Transform.Transform.Translate[3] == dummies[i].Transform.Transform.Translate[3] then
            -- DPrint(originEnt)
            -- DPrint(dummies[i])
            return dummies[i]
        end
    end
end


function GetPMDummies()
    dummies = {}
    local visual = Ext.Entity.GetAllEntitiesWithComponent("ClientEquipmentVisuals")
    for i = 1, #visual do
        if visual[i].Visual and visual[i].Visual.Visual
            and visual[i].Visual.Visual.VisualResource
            and visual[i].Visual.Visual.VisualResource.Template == "EMPTY_VISUAL_TEMPLATE"
            and visual[i]:GetAllComponentNames(false)[2] == "ecl::dummy::AnimationStateComponent"
        then
            table.insert(dummies, visual[i])
        end
    end
end





--messy mess, no judge ^_^

function SaveAndApply(entity, attachment, parameterName, parameterType, value)
    SaveLastChanges(entity, attachment, parameterName, parameterType, value)
    ApplyParameters(entity, attachment, parameterName, parameterType, value)
end


--to make it work in MP I need to separate Ext.Net.PostMessageToServer('SendModVars', Ext.Json.Stringify(lastParameters)) for each if 
function SaveLastChanges(entity, attachment, parameterName, parameterType, value)
    if entity.Uuid then

        local entityUuid = entity.Uuid.EntityUuid


        lastParameters[entityUuid] = lastParameters[entityUuid] or {}
        lastParameters[entityUuid][attachment] = lastParameters[entityUuid] [attachment] or {}
        lastParameters[entityUuid][attachment][parameterType] = lastParameters[entityUuid] [attachment][parameterType] or {}

        local visuals = FindAttachment(entity, attachment)
        if visuals then

            for _, desc in pairs(visuals.ObjectDescs) do
                local am = desc.Renderable.ActiveMaterial   
                -- local ap = desc.Renderable.ActiveMaterial.Material
                -- local am1 = desc.Renderable.AppliedMaterials[1]
                local am1m = desc.Renderable.AppliedMaterials[1].Material
                -- DDump(desc.Renderable.AppliedMaterials[1].Material.Parameters.Vector3Parameters)

                if am ~= nil and am.Material ~= nil then

                    if parameterType == 'Scalar' then
                        if am.Material.Parameters.ScalarParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.ScalarParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    lastParameters[entityUuid][attachment][parameterType][parameterName] = value
                                end
                            end
                        end

                    elseif parameterType == 'Vector3' then
                        if am.Material.Parameters.Vector3Parameters then
                            for _, scalarParam in pairs(am.Material.Parameters.Vector3Parameters) do
                                if scalarParam.ParameterName == parameterName then
                                    lastParameters[entityUuid][attachment][parameterType][parameterName] = value
                                end
                            end
                        end

                    elseif parameterType == 'Vector_1' then
                        if am.Material.Parameters.VectorParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    lastParameters[entityUuid][attachment]["Vector_1"] = {[parameterName] = value}
                                    lastParameters[entityUuid][attachment]["Vector_2"] = nil
                                    lastParameters[entityUuid][attachment]["Vector_3"] = nil
                                    lastParameters[entityUuid][attachment]["Vector_4"] = nil
                                end
                            end
                        end

                    elseif parameterType == 'Vector_2' then
                        if am.Material.Parameters.VectorParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    lastParameters[entityUuid][attachment]["Vector_1"] =  nil
                                    lastParameters[entityUuid][attachment]["Vector_2"] = {[parameterName] = value}
                                    lastParameters[entityUuid][attachment]["Vector_3"] = nil
                                    lastParameters[entityUuid][attachment]["Vector_4"] = nil
                                end
                            end
                        end

                    elseif parameterType == 'Vector_3' then
                        if am.Material.Parameters.VectorParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    lastParameters[entityUuid][attachment]["Vector_1"] = nil
                                    lastParameters[entityUuid][attachment]["Vector_2"] = nil
                                    lastParameters[entityUuid][attachment]["Vector_3"] = {[parameterName] = value}
                                    lastParameters[entityUuid][attachment]["Vector_4"] = nil
                                end
                            end
                        end

                    elseif parameterType == 'Vector_4' then
                        if am.Material.Parameters.VectorParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    lastParameters[entityUuid][attachment]["Vector_1"] = nil
                                    lastParameters[entityUuid][attachment]["Vector_2"] = nil
                                    lastParameters[entityUuid][attachment]["Vector_3"] = nil
                                    lastParameters[entityUuid][attachment]["Vector_4"] = {[parameterName] = value}
                                end
                            end
                        end

                    end
                end
            end
        end
    end


    Ext.Net.PostMessageToServer('SendModVars', Ext.Json.Stringify(lastParameters))
    -- DDump(lastParameters)
end

function ApplyParameters(entity, attachment, parameterName, parameterType, value)


    local visuals = FindAttachment(entity, attachment)
    if visuals then

        for _, desc in pairs(visuals.ObjectDescs) do
            local am = desc.Renderable.ActiveMaterial
            -- local ap = desc.Renderable.ActiveMaterial.Material
            -- local am1 = desc.Renderable.AppliedMaterials[1]
            local am1m = desc.Renderable.AppliedMaterials[1]
            -- DDump(desc.Renderable.AppliedMaterials[1].Material.Parameters.Vector3Parameters)

            if am ~= nil and am.Material ~= nil then

                if parameterType == 'Scalar' then
                    if am.Material.Parameters.ScalarParameters then
                        for _, scalarParam in pairs(am.Material.Parameters.ScalarParameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetScalar(parameterName, value)
                                am.Material:SetScalar(parameterName, value)
                                am1m.Material:SetScalar(parameterName, value)
                            end
                        end
                    end

                elseif parameterType == 'Vector3' then
                    if am.Material.Parameters.Vector3Parameters then
                        for _, scalarParam in pairs(am.Material.Parameters.Vector3Parameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetVector3(parameterName, {value[1], value[2], value[3]})
                                am.Material:SetVector3(parameterName, {value[1], value[2], value[3]})
                                am1m.Material:SetVector3(parameterName, {value[1], value[2], value[3]})
                            end
                        end
                    end
                    --1 body, 3 head
                elseif parameterType == 'Vector_1' then
                    if am.Material.Parameters.VectorParameters then
                        for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetVector4(parameterName, {value, 0, 0, 0})
                                am.Material:SetVector4(parameterName, {value, 0, 0, 0})
                            end
                        end
                    end

                elseif parameterType == 'Vector_2' then
                    if am.Material.Parameters.VectorParameters then
                        for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetVector4(parameterName, {0, value,0, 0}) 
                                am.Material:SetVector4(parameterName, {0, value,0, 0}) 
                            end
                        end
                    end

                elseif parameterType == 'Vector_3' then
                    if am.Material.Parameters.VectorParameters then
                        for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetVector4(parameterName, {0, 0, value, 0}) 
                                am.Material:SetVector4(parameterName, {0, 0, value, 0}) 
                            end
                        end
                    end

                elseif parameterType == 'Vector_4' then
                    if am.Material.Parameters.VectorParameters then
                        for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetVector4(parameterName, {0, 0, 0, value}) 
                                am.Material:SetVector4(parameterName, {0, 0, 0, value}) 
                            end
                        end
                    end

                end
            end
        end
    end
end







function ApplyParametersToDummies()
    GetPMDummies()
    for uuid, attachments in pairs(lastParameters) do
        local entity = MatchCharacterAndPMDummy(uuid)
        -- DPrint(entity)
        for attachment, parameterTypes in pairs(attachments) do
            for parameterType, parameterNames in pairs(parameterTypes) do
                for parameterName, value in pairs(parameterNames) do
                    -- DPrint(parameterName)
                    -- DPrint(parameterType)
                    -- DDump(value)
                    ApplyParameters(entity, attachment, parameterName, parameterType, value)
                end
            end
        end
    end
end


function ApplyParametersToDolls()
    for uuid, attachments in pairs(lastParameters) do
        local owner = Ext.Entity.Get(uuid)
        local entity = Paperdoll.GetOwnersDoll(owner)
        for attachment, parameterTypes in pairs(attachments) do
            for parameterType, parameterNames in pairs(parameterTypes) do
                for parameterName, value in pairs(parameterNames) do
                    ApplyParameters(entity, attachment, parameterName, parameterType, value)
                end
            end
        end
    end
end




function SaveParamsToFile()

    local data = lastParameters

    local name = LocalSettings.FileName
    LocalSettings.FileName = "CCEE"
    LocalSettings:AddOrChange('CCEE', data)
    LocalSettings:SaveToFile()
    LocalSettings.FileName = name

end

function LoadParamsFromFile()

    Ext.Net.PostMessageToServer('LoadLocalSettings', '')

end



Ext.Events.ResetCompleted:Subscribe(function()

    Ext.Net.PostMessageToServer('UpdateParameters', '')

    GetAllParameterNames(_C())
    Helpers.Timer:OnTicks(5, function ()
        -- DPrint('FunctionsGenerator')
        FunctionsGenerator()
    end)
end)



Ext.RegisterNetListener('LoadModVars', function (channel, payload, user)

    -- DPrint(user)

    GetAllParameterNames(_C())

    Helpers.Timer:OnTicks(5, function ()
        FunctionsGenerator()
    end)

    local data = Ext.Json.Parse(payload)

    lastParametersMV = data.lastParameters
    lastParameters = data.lastParameters
    local TICKS_TO_WAIT = data.TICKS_TO_WAIT
    
    --LoadElementsValues()
    
    DPrint('Waiting ' ..  TICKS_TO_WAIT .. ' ticks before applying parameters')

    firstManToUseProgressBar.Visible = true
    firstManToUseProgressBarLable.Visible = true

    local ticksPassedBar = 0
    barID = Ext.Events.Tick:Subscribe(function()
        ticksPassedBar = ticksPassedBar + 1
        firstManToUseProgressBar.Value = ticksPassedBar/TICKS_TO_WAIT
    end)


    Helpers.Timer:OnTicks(TICKS_TO_WAIT, function()

        -- DPrint('Boom')

        Helpers.Timer:OnTicks(TICKS_BEFORE_GAPM, function()

            GetAllParameterNames(_C())
    
            Helpers.Timer:OnTicks(TICKS_BEFORE_LOADING, function()

                --tbd: UNITE the functions L u L 
                function LoadParametersSingle()
                    -- DPrint('-----------------------------------------------------------------------')
                    -- DPrint('SINGLE')
                    local uuid = data.entityUuid
                    -- DDump(lastParametersMV)

                    Helpers.Timer:OnTicks(TICKS_BEFORE_APPLYING, function()

                        Ext.Events.Tick:Unsubscribe(barID)
                        firstManToUseProgressBar.Visible = false
                        firstManToUseProgressBarLable.Visible = false
                        local entity = Ext.Entity.Get(uuid)
                        -- if lastParametersMV[uuid] then
                            for attachment, parameterTypes in pairs(lastParametersMV[uuid]) do
                                for parameterType, parameterNames in pairs(parameterTypes) do
                                    for parameterName, value in pairs(parameterNames) do
        
                                        Helpers.Timer:OnTicks(4, function ()
                                            -- DPrint('Applying' .. ' ' ..  parameterName .. ' to: ' .. entity.Uuid.EntityUuid)
                                            -- DDump(value)
                                            -- DPrint('-----------------------------------------------------------------------')

                                            ApplyParameters(entity, attachment, parameterName, parameterType, value)
                                        end)
        
                                    end
                                end
                            end
                        -- end
                        -- DPrint('-----------------------------------------------------------------------')
                        -- DPrint(entity.Uuid.EntityUuid)
                        -- DPrint('-----------------------------------------------------------------------')
                    end)
                end

                function LoadParameters()

                    -- DPrint('-----------------------------------------------------------------------')
                    -- DPrint('EVERYONE')
                    -- DDump(lastParametersMV)

                    Helpers.Timer:OnTicks(TICKS_BEFORE_APPLYING, function()

                        Ext.Events.Tick:Unsubscribe(barID)
                        firstManToUseProgressBar.Visible = false
                        firstManToUseProgressBarLable.Visible = false

                        for uuid, attachments in pairs(lastParametersMV) do
                            local entity = Ext.Entity.Get(uuid)
                            for attachment, parameterTypes in pairs(attachments) do
                                for parameterType, parameterNames in pairs(parameterTypes) do
                                    for parameterName, value in pairs(parameterNames) do

                                        Helpers.Timer:OnTicks(5, function ()
                                            -- DPrint('Applying' .. ' ' ..  parameterName .. ' to: ' .. entity.Uuid.EntityUuid)
                                            -- DDump(value)
                                            -- DPrint('-----------------------------------------------------------------------')

                                            ApplyParameters(entity, attachment, parameterName, parameterType, value)
                                        end)

                                    end
                                end
                            end
                            -- DPrint('-----------------------------------------------------------------------')
                            -- DPrint(entity.Uuid.EntityUuid)
                            -- DPrint('-----------------------------------------------------------------------')
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
end)