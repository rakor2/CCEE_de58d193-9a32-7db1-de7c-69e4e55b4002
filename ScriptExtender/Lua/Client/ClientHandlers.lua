
Parameters = Parameters or {}
lastParameters = lastParameters or {}
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

    for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail', 'Horns'}) do
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


--make it as a one thingy
function ApplyParameters(entity, attachment, parameterName, parameterType, value)

    if entity.Uuid then

        entityUuid = entity.Uuid.EntityUuid
    else

        entityUuid = tostring(entity.ClientEquipmentVisuals.Entity)

    end

    lastParameters[entityUuid] = lastParameters[entityUuid] or {}
    lastParameters[entityUuid][attachment] = lastParameters[entityUuid] [attachment] or {}
    lastParameters[entityUuid][attachment][parameterType]  = lastParameters[entityUuid] [attachment][parameterType] or {}

    local visuals = FindAttachment(entity, attachment)
    if visuals then
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

        for _, desc in pairs(visuals.ObjectDescs) do
            local am = desc.Renderable.ActiveMaterial   
            -- local ap = desc.Renderable.ActiveMaterial.Material
            -- local am1 = desc.Renderable.AppliedMaterials[1]
            local am1m = desc.Renderable.AppliedMaterials[1].Material
            -- DDump(desc.Renderable.AppliedMaterials[1].Material.Parameters.Vector3Parameters)

            if am ~= nil and am.Material ~= nil then
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

                if parameterType == 'Scalar' then
                    if am.Material.Parameters.ScalarParameters then
                        for _, scalarParam in pairs(am.Material.Parameters.ScalarParameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetScalar(parameterName, value)
                                -- ap:SetScalar(parameterName, value)
                                -- am1:SetScalar(parameterName, value)
                                -- am1m:SetScalar(parameterName, value)
                                lastParameters[entityUuid][attachment][parameterType][parameterName] = value
                            end
                        end
                    end

                elseif parameterType == 'Vector3' then
                    if am.Material.Parameters.Vector3Parameters then
                        for _, scalarParam in pairs(am.Material.Parameters.Vector3Parameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetVector3(parameterName, {value[1], value[2], value[3]})
                                -- ap:SetVector3(parameterName, {value[1], value[2], value[3]})
                                -- am1:SetVector3(parameterName, {value[1], value[2], value[3]})
                                am1m:SetVector3(parameterName, {value[1], value[2], value[3]})
                                lastParameters[entityUuid][attachment][parameterType][parameterName] = value
                            end
                        end
                    end

                elseif parameterType == 'Vector' then
                    if am.Material.Parameters.VectorParameters then
                        for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                            if scalarParam.ParameterName == parameterName then
                                local defValue = am.Material.Parameters.VectorParameters[1].Value

                                if parameterName == 'BodyTattooIntensity' then
                                    am:SetVector4(parameterName, {value, defValue[2] , defValue[3], defValue[4]})
                                    lastParameters[entityUuid][attachment][parameterType][parameterName]  = value
                                else
                                    am:SetVector4(parameterName, {defValue[1], defValue[2] , value, defValue[4]}) --for body tats 1st value, for head 3rd
                                    lastParameters[entityUuid][attachment][parameterType][parameterName]  = value
                                end

                            end
                        end
                    end
                end
            end
        end
    end

    Ext.Net.PostMessageToServer('SendModVars', Ext.Json.Stringify(lastParameters))

    
end

function ApplyDummyParameters(entity, attachment, parameterName, parameterType, value)
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
                                am:SetScalar(parameterName, value)
                                -- ap:SetScalar(parameterName, value)
                                -- am1:SetScalar(parameterName, value)
                                -- am1m:SetScalar(parameterName, value)

                            end
                        end
                    end

                elseif parameterType == 'Vector3' then
                    if am.Material.Parameters.Vector3Parameters then
                        for _, scalarParam in pairs(am.Material.Parameters.Vector3Parameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetVector3(parameterName, {value[1], value[2], value[3]})
                                -- ap:SetVector3(parameterName, {value[1], value[2], value[3]})
                                -- am1:SetVector3(parameterName, {value[1], value[2], value[3]})
                                am1m:SetVector3(parameterName, {value[1], value[2], value[3]})
                            end
                        end
                    end

                elseif parameterType == 'Vector' then
                    if am.Material.Parameters.VectorParameters then
                        for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                            if scalarParam.ParameterName == parameterName then
                                local defValue = am.Material.Parameters.VectorParameters[1].Value

                                if parameterName == 'BodyTattooIntensity' then
                                    am:SetVector4(parameterName, {value, defValue[2] , defValue[3], defValue[4]})

                                else
                                    am:SetVector4(parameterName, {defValue[1], defValue[2] , value, defValue[4]}) --for body tats 1st value, for head 3rd

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


    
end



Ext.RegisterNetListener('LoadModVars', function (channel, payload, user)

    local data = Ext.Json.Parse(payload)
    lastParametersMV = data.lastParameters
    ticksToWait = data.ticksToWait

    
    DPrint('Waiting ' ..  ticksToWait .. '  ticks before applying parameters')

    firstManToUseProgressBar.Visible = true
    firstManToUseProgressBarLable.Visible = true

    local ticksPassedBar = 0
    barID = Ext.Events.Tick:Subscribe(function()
        ticksPassedBar = ticksPassedBar + 1
        firstManToUseProgressBar.Value = ticksPassedBar/ticksToWait
    end)


    Helpers.Timer:OnTicks(ticksToWait, function()

        DPrint('Boom')

        Helpers.Timer:OnTicks(1, function()

            GetAllParameterNames(_C())
    
            Helpers.Timer:OnTicks(1, function()


                function LoadParameters()
    
                    -- DDump(lastParametersMV)

                    Helpers.Timer:OnTicks(1, function()

                        Ext.Events.Tick:Unsubscribe(barID)
                        firstManToUseProgressBar.Visible = false
                        firstManToUseProgressBarLable.Visible = false

                        for uuid, attachments in pairs(lastParametersMV) do
                            local entity = Ext.Entity.Get(uuid)
                            for attachment, parameterTypes in pairs(attachments) do
                                for parameterType, parameterNames in pairs(parameterTypes) do
                                    for parameterName, value in pairs(parameterNames) do
                                        -- DPrint('Applying' .. ' ' ..  parameterName .. ' to: ' .. entity.Uuid.EntityUuid)
                                        -- DDump(value)
                                        -- DPrint('-----------------------------------------------------------------------')
                                        ApplyParameters(entity, attachment, parameterName, parameterType, value)
                                    end
                                end
                            end
                        end
                    end)
                end
    
                LoadParameters()

            end)
        end)
    end)
end)



function CountTattoes()
    tattooCount = 0
    local kavtCount = 0
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
end
CountTattoes()



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


--they call it junk

function MatchCharacterAndPMDummy(originUuid)
    local originEnt = Ext.Entity.Get(originUuid)
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

function ApplyParametersToDummies()
    GetPMDummies()
        for uuid, attachments in pairs(lastParameters) do
            local entity = MatchCharacterAndPMDummy(uuid)
            -- DPrint(entity)
            for attachment, parameterTypes in pairs(attachments) do
                for parameterType, parameterNames in pairs(parameterTypes) do
                    for parameterName, value in pairs(parameterNames) do
                        ApplyDummyParameters(entity, attachment, parameterName, parameterType, value)
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
                    ApplyDummyParameters(entity, attachment, parameterName, parameterType, value)
                end
            end
        end
    end
end


-- Ext.Events.OnComponentCreated:Subscribe("eoc::photo_mode::SessionComponent",function ()
--     DPrint('PM')
-- end)


-- fuck it, for PM
-- Ext.Entity.OnCreate("ClientEquipmentVisuals", function(entity, _, component)
--     Helpers.Timer:OnTicks(5, function ()
--         ApplyParametersToDummies()
--     end)
-- end)

-- Ext.Events.Tick:Subscribe(function ()
--     if pcal
--     Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.UpdateTransformOffset ~= nil then
--         DPrint('xd')
--     else
--         return
--     end
-- end)