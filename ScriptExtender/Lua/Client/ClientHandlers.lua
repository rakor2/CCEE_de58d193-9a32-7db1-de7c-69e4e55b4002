-- function testS()
--     _C().Vars.NRD_Whatever = 123
--     DPrint(_C().Vars.NRD_Whatever)
-- end

-- Ext.RegisterConsoleCommand('tC', testS)

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



function FindAttachment(attachment)
    for i = 1, #_C().Visual.Visual.Attachments do
        if _C().Visual.Visual.Attachments[i].Visual.VisualResource and _C().Visual.Visual.Attachments[i].Visual.VisualResource.Template:lower():find(attachment) then
            local visuals = _C().Visual.Visual.Attachments[i].Visual
            return visuals
        end
    end
end


lastParameters = {}

function ApplyParameters(attachment, parameterName, parameterType, value)
    local visuals = FindAttachment(attachment)

    for _, desc in pairs(visuals.ObjectDescs) do
        local am = desc.Renderable.ActiveMaterial
        if am ~= nil and am.Material ~= nil then

            if parameterType == 'Scalar' then
                if am.Material.Parameters.ScalarParameters then
                    for _, scalarParam in pairs(am.Material.Parameters.ScalarParameters) do
                        if scalarParam.ParameterName == parameterName then
                            am:SetScalar(parameterName, value)
                            lastParameters[parameterName] = value
                        end
                    end
                end

            elseif parameterType == 'Vector3' then
                if am.Material.Parameters.Vector3Parameters then
                    for _, scalarParam in pairs(am.Material.Parameters.Vector3Parameters) do
                        if scalarParam.ParameterName == parameterName then
                            am:SetVector3(parameterName, {value[1], value[2], value[3]})
                            lastParameters[parameterName] = value
                        end
                    end
                end

            elseif parameterType == 'Vector4' then
                if am.Material.Parameters.VectorParameters then
                    for _, scalarParam in pairs(am.Material.Parameters.VectorParameters) do
                        if scalarParam.ParameterName == parameterName then
                            local defValue = am.Material.Parameters.VectorParameters[1].Value
                            am:SetVector4(parameterName, {defValue[1], defValue[2] , value, defValue[4]})
                            lastParameters[parameterName] = value
                        end
                    end
                end
            end
        end
    end
    DDump(lastParameters)
    Helpers.UserVars:Set(_C(), 'CCEE_Current', lastParameters)
end