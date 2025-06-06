

function FindAttachment(attachment)
    for i = 1, #_C().Visual.Visual.Attachments do
        if _C().Visual.Visual.Attachments[i].Visual.VisualResource and _C().Visual.Visual.Attachments[i].Visual.VisualResource.Template:lower():find(attachment:lower()) then
            local visuals = _C().Visual.Visual.Attachments[i].Visual
            return visuals
        end
    end
end


Parameters = Parameters or {}

function GetParameterNames(attachment, parameterType)
    
    local visuals = FindAttachment(attachment)

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

function PopulateWithParamNames()
    for _, part in ipairs({'Head', 'Body', 'Genital', 'Tail', 'Horns'}) do
        for _, paramType in ipairs({'Scalar', 'Vector3', 'Vector'}) do
            GetParameterNames(part, paramType)
        end
    end
    
end

-- DDump(Parameters)

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


lastParameters = lastParameters or {}


function ApplyParameters(attachment, parameterName, parameterType, value)
    local visuals = FindAttachment(attachment)

    lastParameters[attachment] = lastParameters[attachment] or {}
    lastParameters[attachment][parameterType]  = lastParameters[attachment][parameterType] or {}

    if visuals then

        for _, desc in pairs(visuals.ObjectDescs) do
            local am = desc.Renderable.ActiveMaterial
            if am ~= nil and am.Material ~= nil then

                if parameterType == 'Scalar' then
                    if am.Material.Parameters.ScalarParameters then
                        for _, scalarParam in pairs(am.Material.Parameters.ScalarParameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetScalar(parameterName, value)
                                lastParameters[attachment][parameterType][parameterName] = value
                            end
                        end
                    end

                elseif parameterType == 'Vector3' then
                    if am.Material.Parameters.Vector3Parameters then
                        for _, scalarParam in pairs(am.Material.Parameters.Vector3Parameters) do
                            if scalarParam.ParameterName == parameterName then
                                am:SetVector3(parameterName, {value[1], value[2], value[3]})
                                lastParameters[attachment][parameterType][parameterName] = value
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
                                    lastParameters[attachment][parameterType][parameterName]  = value
                                else
                                    am:SetVector4(parameterName, {defValue[1], defValue[2] , value, defValue[4]}) --for body tats 1st value, for head 3rd
                                    lastParameters[attachment][parameterType][parameterName]  = value
                                end

                            end
                        end
                    end
                end
            end
        end
    end
    -- DDump(lastParameters)
    Helpers.UserVars:Set(_C(), 'CCEE_Last', lastParameters)
end



function LoadParameters()

    Helpers.Timer:OnTicks(100, function()

        local userVars = Mods.CCEE.Helpers.UserVars:Get(_C(), 'CCEE_Last')
        if userVars then
            for attachment, parameters in pairs(userVars) do
                for parameterType, parametersAll in pairs(parameters) do
                    for parameterName, value in pairs(parametersAll) do
                        ApplyParameters(attachment, parameterName, parameterType, value)
                    end
                end
            end
        end

    end)

end

