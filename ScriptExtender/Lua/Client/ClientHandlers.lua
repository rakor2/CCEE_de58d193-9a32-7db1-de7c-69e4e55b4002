
CCEE = {}
UI = {}
Window = {}
Tests = {}
Elements = {}
Functions = {}


TICKS_BEFORE_GAPM = 0
TICKS_BEFORE_LOADING = 0
TICKS_BEFORE_APPLYING = 2

Parameters = Parameters or {}
lastParameters = lastParameters or {}
currentParameters = currentParameters or {}

---No longer needed
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


-- function FunctionsGenerator()
--     for attachment, paramTypes in pairs(Parameters) do
--         -- DPrint(attachment)
--         for parameterType, parameterNames in pairs(paramTypes) do
--             if parameterType == 'Scalar' then
--                 for _, parameterName in ipairs(parameterNames) do
--                     Functions[parameterType] = Functions[parameterType] or {}
--                     Functions[parameterType][parameterName] = Functions[parameterType][parameterName] or {}

--                     table.insert(Functions[parameterType][parameterName], function(slider)
--                         SaveAndApply(_C(), attachment, parameterName, parameterType, slider.Value[1])
--                     end)
--                 end
                
--             elseif parameterType == 'Vector3' then
--                 for _, parameterName in ipairs(parameterNames) do
--                     Functions[parameterType] = Functions[parameterType] or {}
--                     Functions[parameterType][parameterName] = Functions[parameterType][parameterName] or {}

--                     table.insert(Functions[parameterType][parameterName], function(slider)
--                         SaveAndApply(_C(), attachment, parameterName, parameterType, slider.Color)
--                     end)
--                 end
                
--             elseif parameterType == 'Vector' then
--                 for _, parameterName in ipairs(parameterNames) do
--                     for i = 1, 4 do
--                         local vectorType = 'Vector_' .. i
                        
--                         Functions[vectorType] = Functions[vectorType] or {}
--                         Functions[vectorType][parameterName] = Functions[vectorType][parameterName] or {}

--                         table.insert(Functions[vectorType][parameterName], function(slider)
--                             SaveAndApply(_C(), attachment, parameterName, vectorType, slider.Value[1])
--                         end)
--                     end
--                 end   
--             end
--         end
--         -- DPrint('Ended')
--     end
-- end

-- --just a test, probably gonna stick to SaveAndApply because there are repetitve parameters. To lazy rn Deadge
-- function CallFunction(paramType, paramName, var)
--     local funcs = Functions[paramType] and Functions[paramType][paramName]
--     if funcs then
--         for _, fn in ipairs(funcs) do
--             fn(var)
--         end
--     end
-- end


---temp abomination (temp?)
---@param entity EntityHandle
---@param attachment VisualAttachment
---@return 
function FindAttachment(entity, attachment)

    -- Ext.IO.SaveFile("Visuals_test.json", Ext.DumpExport(entity.Visual))
    if entity and entity.Visual.Visual then
        -- Helpers.Timer:OnTicks(50, function ()
            -- DPrint(attachment)
            for i = 1, #entity.Visual.Visual.Attachments do
                if attachment == 'Tail' then
                    if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.SkeletonSlot:lower():find(attachment:lower()) then
                        local visuals = entity.Visual.Visual.Attachments[i].Visual
                        -- DPrint('--------------------------------')
                        -- DPrint(entity.Visual.Visual.Attachments[i].Visual.VisualResource.SkeletonSlot)
                        return visuals

                    end

                elseif attachment == 'Head' then
                    if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot:lower():find(attachment:lower()) or
                    entity.Visual.Visual.Attachments[i].Visual.VisualResource.Template:lower():find(attachment:lower()) then
                        local visuals = entity.Visual.Visual.Attachments[i].Visual
                        -- DPrint('--------------------------------')
                        -- DPrint(entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot)
                        return visuals
                    end

                --whoever uses custom body as attachment gotta [REDACTED]. Hooooooooooly Im so mad
                elseif attachment == 'NakedBody' then
                    local foundVisuals = {}
                    for i = 1, #entity.Visual.Visual.Attachments do
                        if entity.Visual.Visual.Attachments[i].Visual.VisualResource then 
                        for _, objects in pairs(entity.Visual.Visual.Attachments[i].Visual.VisualResource.Objects) do
                            if objects.ObjectID:lower():find('body') then
                                -- DDump(objects.ObjectID)
                                local visuals = entity.Visual.Visual.Attachments[i].Visual
                                table.insert(foundVisuals, visuals)
                            end 
                        end
                    end
                end
                    for i = 1, #entity.Visual.Visual.Attachments do
                        if entity.Visual.Visual.Attachments[i].Visual.VisualResource then
                            if entity.Visual.Visual.Attachments[i].Visual.VisualResource.Template:lower():find('body') then
                                local visuals = entity.Visual.Visual.Attachments[i].Visual
                                -- DDump(visuals.VisualResource.Template)
                                -- DDump(customBody)
                                table.insert(foundVisuals, visuals)
                            -- elseif entity.Visual.Visual.Attachments[i].Visual.ObjectDescs[1].Renderable.ActiveMaterial.MaterialName == '80567441-dafe-b6c6-4873-aa67bff518bc' then  --default
                            --     local visuals = entity.Visual.Visual.Attachments[i].Visual
                            --     table.insert(foundVisuals, visuals)
                            end
                        end
                    end
                    return foundVisuals
                else
                    if entity.Visual.Visual.Attachments[i].Visual.VisualResource and entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot:lower():find(attachment:lower()) then
                        local visuals = entity.Visual.Visual.Attachments[i].Visual
                        -- DPrint('--------------------------------')
                        -- DPrint(entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot)
                        return visuals
                    end
                end
                -- DPrint(entity.Visual.Visual.Attachments[i].Visual.VisualResource.Slot)
            end
        -- end)
    end
end

---Gets all available meterial parameters for the entity
---@param entity EntityHandle
function GetAllParameterNames(entity)
    Parameters = {}
    local entity = entity or _C()

    for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail', 'Horns', 'Hair', 'DragonbornChin','DragonbornJaw','DragonbornTop'}) do
        for _, parameterType in ipairs({'Scalar', 'Vector3', 'Vector'}) do

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
                                if parameterType == 'Scalar' then
                                    if am.Material.Parameters.ScalarParameters then
                                        for _, sp in ipairs(am.Material.Parameters.ScalarParameters) do
                                            local pn = sp.ParameterName
                                            if not NameCheck(pn) then
                                                table.insert(Parameters[attachment][parameterType], pn)
                                            end
                                        end
                                    end
                                end
                                
                                if parameterType == 'Vector3' then
                                    if am.Material.Parameters.Vector3Parameters then
                                        for _, v3p in ipairs(am.Material.Parameters.Vector3Parameters) do
                                            local pn = v3p.ParameterName
                                            if not NameCheck(pn) then
                                                table.insert(Parameters[attachment][parameterType], pn)
                                            end
                                        end
                                    end
                                end
                                
                                if parameterType == 'Vector' then
                                    if am.Material.Parameters.VectorParameters then
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
            end
        end
    end
    -- DDump(Parameters)
end

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

---Matches character and its photo mode dummy
---Workaround until photo mode is mapped
---@param charUuid uuid
---@return EntityHandle
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


---Gets all PM dummies for currrent scene
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
            -- for ent, _ in pairs(dummies) do
            --     DPrint(Helpers.Format.GetEntityName(ent))
            -- end
        end
    end
end





--messy mess, no judge ^_^

function SaveAndApply(entity, attachment, parameterName, parameterType, value)
        SaveLastChanges(entity, attachment, parameterName, parameterType, value)
        ApplyParameters(entity, attachment, parameterName, parameterType, value)
end

--tbd: unhardcode the table
---Appplies the things to the entity
---@param entity EntityHandle
---@param attachment VisualAttachment
---@param parameterType MyOwnParemeterTypes
---@param parameterName MaterialParameterName
---@param value number | -- for parameterType:
--- - Scalar: number
--- - Vector3: number{3}
--- - Vector_1..4: number{4} (bs)
function SaveLastChanges(entity, attachment, parameterName, parameterType, value)
    if entity.Uuid then
        local entityUuid = entity.Uuid.EntityUuid

        lastParameters[entityUuid] = lastParameters[entityUuid] or {}
        lastParameters[entityUuid][attachment] = lastParameters[entityUuid][attachment] or {}
        lastParameters[entityUuid][attachment][parameterType] = lastParameters[entityUuid][attachment][parameterType] or {}

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
                        local am1m = desc.Renderable.AppliedMaterials[1] and desc.Renderable.AppliedMaterials[1].Material

                        if am ~= nil and am.Material ~= nil then

                            if parameterType == 'Scalar' then
                                if am.Material.Parameters.ScalarParameters then
                                    for _, scalarParam in pairs(am.Material.Parameters.ScalarParameters) do
                                        if scalarParam.ParameterName == parameterName then
                                            lastParameters[entityUuid][attachment][parameterType][parameterName] = value
                                            parameterFound = true
                                            break
                                        end
                                    end
                                end

                            elseif parameterType == 'Vector3' then
                                if am.Material.Parameters.Vector3Parameters then
                                    for _, scalarParam in pairs(am.Material.Parameters.Vector3Parameters) do
                                        if scalarParam.ParameterName == parameterName then
                                            lastParameters[entityUuid][attachment][parameterType][parameterName] = value
                                            parameterFound = true
                                            break
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
                                            parameterFound = true
                                            break
                                        end
                                    end
                                end

                            elseif parameterType == 'Vector_2' then
                                if am.Material.Parameters.VectorParameters then
                                    for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                        if scalarParam.ParameterName == parameterName then
                                            lastParameters[entityUuid][attachment]["Vector_1"] = nil
                                            lastParameters[entityUuid][attachment]["Vector_2"] = {[parameterName] = value}
                                            lastParameters[entityUuid][attachment]["Vector_3"] = nil
                                            lastParameters[entityUuid][attachment]["Vector_4"] = nil
                                            parameterFound = true
                                            break
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
                                            parameterFound = true
                                            break
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

    Ext.Net.PostMessageToServer('SendModVars', Ext.Json.Stringify(lastParameters))
    -- DDump(lastParameters)
end




---Appplies the things to the entity
---@param entity EntityHandle
---@param attachment VisualAttachment
---@param parameterType MyOwnParemeterTypes
---@param parameterName MaterialParameterName
---@param value number | -- for parameterType:
--- - Scalar: number
--- - Vector3: number{3}
--- - Vector_1..4: number{4} (bs)
function ApplyParameters(entity, attachment, parameterName, parameterType, value)
    -- DPrint(entity)

    local visualsTable = FindAttachment(entity, attachment)
    
    if visualsTable then
        if type(visualsTable) ~= "table" then
            visualsTable = {visualsTable}
        end
        
        for _, visuals in pairs(visualsTable) do
            
            for _, desc in pairs(visuals.ObjectDescs) do
                -- DPrint(desc.LOD)
                local am = desc.Renderable.ActiveMaterial
                local am1 = desc.Renderable.AppliedMaterials[1]
                local amp = desc.Renderable.ActiveMaterial.Material.Parent
                local am1p = desc.Renderable.AppliedMaterials[1].Material.Parent

                if am ~= nil and am.Material ~= nil then

                    if parameterType == 'Scalar' then
                        if am.Material.Parameters.ScalarParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.ScalarParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    am:SetScalar(parameterName, value)
                                    -- am1:SetScalar(parameterName, value)
                                    -- amp:SetScalar(parameterName, value)
                                    -- am.Material:SetScalar(parameterName, value)
                                    -- am1.Material:SetScalar(parameterName, value)
                                    -- am1p:SetScalar(parameterName, value)
                                end
                            end
                        end

                    elseif parameterType == 'Vector3' then
                        if am.Material.Parameters.Vector3Parameters then
                            for _, scalarParam in pairs(am.Material.Parameters.Vector3Parameters) do
                                if scalarParam.ParameterName == parameterName then
                                    am:SetVector3(parameterName, {value[1], value[2], value[3]})
                                    -- am1:SetVector3(parameterName, {value[1], value[2], value[3]})
                                    -- amp:SetVector3(parameterName, {value[1], value[2], value[3]})
                                    -- am1p:SetVector3(parameterName, {value[1], value[2], value[3]})
                                    -- am.Material:SetVector3(parameterName, {value[1], value[2], value[3]})
                                    -- am1.Material:SetVector3(parameterName, {value[1], value[2], value[3]})
                                end
                            end
                        end

                    elseif parameterType == 'Vector_1' then
                        if am.Material.Parameters.VectorParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    am:SetVector4(parameterName, {value, 0, 0, 0})
                                    -- am1:SetVector4(parameterName, {value, 0, 0, 0})
                                    -- amp:SetVector4(parameterName, {value, 0, 0, 0})
                                    -- am1p:SetVector4(parameterName, {value, 0, 0, 0})
                                    -- am.Material:SetVector4(parameterName, {value, 0, 0, 0})
                                    -- am1.Material:SetVector4(parameterName, {value, 0, 0, 0})
                                end
                            end
                        end

                    elseif parameterType == 'Vector_2' then
                        if am.Material.Parameters.VectorParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    am:SetVector4(parameterName, {0, value, 0, 0}) 
                                    -- am1:SetVector4(parameterName, {0, value, 0, 0}) 
                                    -- amp:SetVector4(parameterName, {0, value, 0, 0}) 
                                    -- am1p:SetVector4(parameterName, {0, value, 0, 0}) 
                                    -- am.Material:SetVector4(parameterName, {0, value, 0, 0}) 
                                    -- am1.Material:SetVector4(parameterName, {0, value, 0, 0}) 
                                end
                            end
                        end

                    elseif parameterType == 'Vector_3' then
                        if am.Material.Parameters.VectorParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    am:SetVector4(parameterName, {0, 0, value, 0}) 
                                    -- am1:SetVector4(parameterName, {0, 0, value, 0}) 
                                    -- amp:SetVector4(parameterName, {0, 0, value, 0}) 
                                    -- am1p:SetVector4(parameterName, {0, 0, value, 0}) 
                                    -- am.Material:SetVector4(parameterName, {0, 0, value, 0}) 
                                    -- am1.Material:SetVector4(parameterName, {0, 0, value, 0}) 
                                end
                            end
                        end

                    elseif parameterType == 'Vector_4' then
                        if am.Material.Parameters.VectorParameters then
                            for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                                if scalarParam.ParameterName == parameterName then
                                    am:SetVector4(parameterName, {0, 0, 0, value}) 
                                    -- am1:SetVector4(parameterName, {0, 0, 0, value}) 
                                    -- amp:SetVector4(parameterName, {0, 0, 0, value}) 
                                    -- am1p:SetVector4(parameterName, {0, 0, 0, value}) 
                                    -- am.Material:SetVector4(parameterName, {0, 0, 0, value}) 
                                    -- am1.Material:SetVector4(parameterName, {0, 0, 0, value}) 
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


---Appplies the things to the PM dummies
function ApplyParametersToDummies()
    -- DPrint('ApplyParametersToDummies')
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


---Appplies the things to the paperdolls
function ApplyParametersToDolls()
    DPrint('ApplyParametersToDolls')
    for uuid, attachments in pairs(lastParameters) do
        -- DPrint(uuid)
        -- DDump(attachments)
        local owner = Ext.Entity.Get(uuid)
        local entity = Paperdoll.GetOwnersDoll(owner)

        DPrint('Owner: ' .. owner.DisplayName.Name:Get())
        -- DPrint(entity)

        for attachment, parameterTypes in pairs(attachments) do
            for parameterType, parameterNames in pairs(parameterTypes) do
                for parameterName, value in pairs(parameterNames) do
                    ApplyParameters(entity, attachment, parameterName, parameterType, value)
                end
            end
        end
    end
end


---Appplies the things to the paperdolls v2
function ApplyParametersToDollsTest(entity, uuid)
    DPrint('ApplyParametersToDollsTest')
    -- DPrint('ApplyParametersToDolls')
    local attachments = lastParameters[uuid]
        -- DPrint(Helpers.Format.GetEntityName(entity))
    if attachments then 
        for attachment, parameterTypes in pairs(attachments) do
            for parameterType, parameterNames in pairs(parameterTypes) do
                for parameterName, value in pairs(parameterNames) do
                    ApplyParameters(entity, attachment, parameterName, parameterType, value)
                end
            end
        end
    end
end






-- function SaveParamsToFile()

--     local data = lastParameters
--     SafeSaveToFile('CCEE', data)
--     -- local name = LocalSettings.FileName
--     -- LocalSettings.FileName = "CCEE"
--     -- LocalSettings:AddOrChange('CCEE', data)
--     -- LocalSettings:SaveToFile()
--     -- LocalSettings.FileName = name




-- end

-- function LoadParamsFromFile()

--     Ext.Net.PostMessageToServer('LoadLocalSettings', '')

-- end

-- function PMKeybind()
--     KeybindingManager:Bind({
--         ScanCode = tostring(GetKeybind(1,320)):upper(),
--         Callback = function()
    
--             Helpers.Timer:OnTicks(50, function ()
--             --no double calls on my watch
--             local s, _ = pcall(function()
--                 return Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.DOFStrength
--             end)
    
--                 if s then
--                     Helpers.Timer:OnTicks(13, function ()
--                         ApplyParametersToDummies()
--                     end)
--                 end
    
--             end)
    
--         end,
--     })
-- end





---Main thingy
Ext.RegisterNetListener('LoadModVars', function (channel, payload, user)

    DPrint('LoadModVars')
    -- DPrint(user)
    GetAllParameterNames(_C())
    -- PMKeybind()


    
    local data = Ext.Json.Parse(payload)

    lastParametersMV = data.lastParameters
    lastParameters = data.lastParameters
    -- DDump(lastParametersMV)
    -- DPrint('123')
    -- DDump(lastParameters)
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

    
            Helpers.Timer:OnTicks(TICKS_BEFORE_LOADING, function()

                --tbd: UNITE the functions L u L 
                function LoadParametersSingle()
                    -- DPrint('-----------------------------------------------------------------------')
                    DPrint('SINGLE')
                    local uuid = data.entityUuid
                    -- DDump(lastParametersMV)

                    Helpers.Timer:OnTicks(TICKS_BEFORE_APPLYING, function()

                        Ext.Events.Tick:Unsubscribe(barID)
                        firstManToUseProgressBar.Visible = false
                        firstManToUseProgressBarLable.Visible = false
                        local entity = Ext.Entity.Get(uuid)
                        if entity and lastParametersMV[uuid] then
                        DPrint('Char: ' .. entity.DisplayName.Name:Get())
                        -- if lastParametersMV[uuid] then
                            for attachment, parameterTypes in pairs(lastParametersMV[uuid]) do
                                for parameterType, parameterNames in pairs(parameterTypes) do
                                    for parameterName, value in pairs(parameterNames) do
        
                                        Helpers.Timer:OnTicks(4, function ()
                                            -- DPrint('Applying' .. ' ' ..  parameterName)
                                            -- DDump(value)
                                            -- DPrint('-----------------------------------------------------------------------')

                                            ApplyParameters(entity, attachment, parameterName, parameterType, value)
                                        end)
        
                                    end
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
                    DPrint('EVERYONE')
                    -- DDump(lastParametersMV)

                    Helpers.Timer:OnTicks(TICKS_BEFORE_APPLYING, function()

                        Ext.Events.Tick:Unsubscribe(barID)
                        firstManToUseProgressBar.Visible = false
                        firstManToUseProgressBarLable.Visible = false
                        
                        for uuid, attachments in pairs(lastParametersMV) do
                            local entity = Ext.Entity.Get(uuid)
                            if entity and entity.DisplayName then
                                DPrint('Char: ' .. entity.DisplayName.Name:Get()) ---entity.Uuid.EntityUuid
                                for attachment, parameterTypes in pairs(attachments) do
                                    for parameterType, parameterNames in pairs(parameterTypes) do
                                        for parameterName, value in pairs(parameterNames) do

                                            Helpers.Timer:OnTicks(5, function ()
                                                -- DPrint('Applying' .. ' ' ..  parameterName)
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
    

    timer = Ext.Timer.WaitFor(30, function()
        Ext.Net.PostMessageToServer('UpdateParameters', '')
        GetAllParameterNames(_C())
        
        Helpers.Timer:OnTicks(50, function ()

        end)
        
        -- PMKeybind()
        
        timer = nil

    end)
end


Ext.Events.ResetCompleted:Subscribe(function()
    TempThingy()
    Elements:UpdateElements(_C().Uuid.EntityUuid)
end)



--- Dumps all parameterName
--- 'ScalarParameters' , 'Vector3Parameters' , 'VectorParameters'
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
                           DDump(param)
                       end
                   end
               end
           end
       end
   end
end


---@param entity EntityHandle
function GetCharacterCreationAppearance(entity)

    local cca = {}
    local ccaArray = entity.CharacterCreationAppearance.Visuals

    for i = 1, #ccaArray do
        cca[i] = ccaArray[i]
    end
    
    DDump(cca)

    return cca
end



---@param fileName string
function SavePreset(fileName)
    DPrint('savePreset')
    local uuid = _C().Uuid.EntityUuid
    local cca = GetCharacterCreationAppearance(_C())
    local dataSave = {
        lastParameters[uuid] or {},
        cca,
    }
    Ext.IO.SaveFile('CCEE/' .. fileName .. '.json', Ext.Json.Stringify(dataSave))
    dataSave = nil
end


---@param fileName string
function LoadPreset(fileName)
    local uuidedData = {}
    local json = Ext.IO.LoadFile(('CCEE/' .. fileName .. '.json'))
    local dataLoad = Ext.Json.Parse(json)

    local uuid = _C().Uuid.EntityUuid

    uuidedData[uuid] = dataLoad

    Helpers.Timer:OnTicks(3, function ()
        Ext.Net.PostMessageToServer('LoadPreset', Ext.Json.Stringify(uuidedData))
    end)
end



---temporary
---@param fileName string
function LoadPreset2(fileName)
    local uuidedData = {}
    local json = Ext.IO.LoadFile(('CCEE/' .. fileName .. '.json'))
    local dataLoad = Ext.Json.Parse(json)

    local uuid = _C().Uuid.EntityUuid

    uuidedData[uuid] = dataLoad

    Helpers.Timer:OnTicks(3, function ()
        Ext.Net.PostMessageToServer('LoadPreset2', Ext.Json.Stringify(uuidedData))
    end)
end