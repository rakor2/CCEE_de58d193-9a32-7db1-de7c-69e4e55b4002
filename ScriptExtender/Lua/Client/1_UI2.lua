function MainTab(p)

    Globals.StoredVisualPaths = {}


    E.btnTest = p:AddButton('Hi!')
    UI:Config(E.btnTest, {
        OnClick = function (e)
            DPrint('Hi!')
            BuildAllParametersTable(_C())
            Helpers.Timer:OnTicks(30, function ()
                CreateElementsForParameters()
            end)
        end
    })



    E.btnTest2 = p:AddButton('Bye!')
    E.btnTest2.SameLine = true
    E.btnTest2.OnClick = function (e)
        DPrint('Bye!')
        Imgui.ClearChildren(E.testParams2)
        BuildAllParametersTable(_C())
        CreateElementsForParameters()
    end


    local parent = p
    E.testParams2 = parent:AddCollapsingHeader('All parameters')



    local ParametersToIgnore = {
        IsTav = true,
        StrandDirectionVariation = true,
        DontTouchMe_Beard_Alpha = true,
        DontTouchMe_isBeard = true,
        HackParamNeverChange = true,
        InvertOpacity = true,
        isGenitals = true,
        doBodyHide = true,
    }


    --- Parameters to sync between different attachments
    local ParametersToSync = {
        Blood = true,
        Blood_Sharpness = true,
        Bruises = true,
        Bruises_Sharpness = true,
        CLEA_Makeup_Roughness = true,
        CLEA_Makeup_Weight = true,
        DetailNormalTiling = true,
        Dirt = true,
        Dirt_Sharpness = true,
        Dirt_Wetness = true,
        Freckles = true,
        FrecklesWeight = true,
        HemoglobinAmount = true,
        IllithidColorWeight = true,
        MelaninAmount = true,
        MelaninDarkMultiplier = true,
        MelaninDarkThreshold = true,
        MelaninRemovalAmount = true,
        Sweat = true,
        Sweat_Sharpness = true,
        TMP_BODY_ROUGH = true,
        VeinAmount = true,
        Vitiligo = true,
        VitiligoWeight = true,
        YellowingAmount = true,
        Blood_Color = true,
        CLEA_Makeup_Color = true,
        DirtColor = true,
        GlowColor = true,
        HemoglobinColor = true,
        IllithidVeinColor = true,
        MelaninColor = true,
        NonSkinColor = true,
        VeinColor = true,
        YellowingColor = true,
    }


    --- Just configurations for sliders
    local ParametersConfig = {
        ['Blood'] = {min = -10, max = 10, log = false},
        ['BodyTattooIndex'] = {int = true, min = 0, max = 31}
    }



    local AttachmentsOrder = {
        'Hair',
        'Head',
        'DragonbornTop',
        'DragonbornChin',
        'DragonbornJaw',
        'NakedBody',
        'Private Parts',
        'Tail',
        'Horns',
        'Piercing',
        'Wings',
    }


    local GropedParameters = {
        'Melanin',
        'Hemoglobin',
        'Vein',
        'Yellowimg',
    }

    --- Sets initial value for the elements when rebuilding the whole section
    local function setValue(element, objectPaths, parameterType, parameterName)
        Helpers.Timer:OnTicks(10, function ()

            local objectPath = objectPaths[1] or objectPaths
            local Visuals = objectPath:Resolve()
            local value = Material:GetCharacterParameterValue(Visuals, parameterType, parameterName)

            if not value then return end

            if parameterType == 'ScalarParameters' then
                element.Value = {value, 0, 0, 0}

            elseif parameterType == 'Vector3Parameters' then
                element.Color = {value[1], value[2], value[3], 0}

            elseif parameterType == 'VectorParameters' then
                element.Color = {value[1], value[2], value[3], value[4]}
            end
        end)
    end



    --- Resolves path and sets value for the parameter
    local function resolveAndSetValue(attachment, parameterType, parameterName, value)
        local objectPaths = Globals.StoredVisualPaths[attachment]
        if not objectPaths then return end

        for _, objectPath in ipairs(objectPaths) do
            if objectPath and objectPath.Resolve then
                local Visuals = objectPath:Resolve()
                Material:SetCharacterParameterValue(Visuals, parameterType, parameterName, value)
            end
        end
    end



    --- Syncs element values between synced attachments
    local function syncElementValue(syncedAttachment, parameterName, elementName)
        if E[syncedAttachment .. '_' .. parameterName] then

            local isSlider = pcall(function (...)
                return E[syncedAttachment .. '_' .. parameterName].Value
            end)

            if isSlider then
                E[syncedAttachment .. '_' .. parameterName].Value = E[elementName].Value
            else
                E[syncedAttachment .. '_' .. parameterName].Color = E[elementName].Color
            end
        end
    end


    --- abstractionizm
    local function notEnoughAbstractions(elementName, attachment, parameterType, parameterName, value)
        if ParametersToSync[parameterName] then
            for _, syncedAttachment in pairs(AllAttachments) do
                if Parameters2[syncedAttachment] and Globals.StoredVisualPaths[syncedAttachment] then
                    resolveAndSetValue(syncedAttachment, parameterType, parameterName, value)
                    syncElementValue(syncedAttachment, parameterName, elementName)
                end
            end
        else
            resolveAndSetValue(attachment, parameterType, parameterName, value)
        end
    end



    function CreateElementsForParameters()
        local entity = _C()
        local max = 5
        local min = -max

        local Tree = Tree or {}
        local Tree1 = Tree1 or {}
        local Tree2 = Tree2 or {}
        local Tree3 = Tree3 or {}


        for _, attachment in ipairs(AttachmentsOrder) do
            if Parameters2[attachment] then
                local onlyIndexPath = true
                local _, _, Paths = FindAttachment2(entity, attachment, onlyIndexPath)

                Globals.StoredVisualPaths[attachment] = {}

                for _, path in ipairs(Paths) do
                    table.insert(Globals.StoredVisualPaths[attachment], ObjectPath:New(entity, path))
                end

                Tree[attachment] = E.testParams2:AddTree(attachment .. '##3123')
                Tree1[attachment] = Tree[attachment]:AddTree('Scalar##3123')
                Tree2[attachment] = Tree[attachment]:AddTree('Vec3##3123')
                Tree3[attachment] = Tree[attachment]:AddTree('Vec##3123')

                TestTree = {}
                TestTree1 = {}
                TestTree2 = {}
                TestTree3 = {}


                -- for xd, ff in pairs(GropedParameters) do
                --     if not TestTree[attachment] then
                --         TestTree[attachment] = Tree[attachment]:AddTree(ff)
                --     end
                -- end
                function CreateElementForParameters(parameterType)
                    for _, parameterName in ipairs(Parameters2[attachment][parameterType]) do
                        if not ParametersToIgnore[parameterName] then

                            local cfg = ParametersConfig[parameterName] or {}
                            local elementName = attachment .. '_' .. parameterName

                            -- for el, ty in pairs({TestTree[attachment], TestTree1[attachment], TestTree2[attachment], TestTree3[attachment]}) do
                            --     if parameterName:lower():find(tostring(ty.Label):lower()) then

                            --         if parameterType == 'ScalarParameters' then

                            --             if cfg.int then
                            --                 E[elementName] = ty:AddSliderInt(parameterName, 0, cfg.min or min, cfg.max or max, 1)
                            --             else
                            --                 E[elementName] = ty:AddSlider(parameterName, 0, cfg.min or min, cfg.max or max, 0.1)
                            --             end
                            --             UI:Config(E[elementName], {
                            --                 Logarithmic = cfg.log or false,
                            --                 IDContext = attachment .. '_' .. parameterName,
                            --                 OnChange = function(e)
                            --                     local value = e.Value[1]
                            --                     notEnoughAbstractions(elementName, attachment, parameterType, parameterName, value)
                            --                 end
                            --             })

                            --             setValue(E[elementName], Globals.StoredVisualPaths[attachment], parameterType, parameterName)
                            --         end



                            --         if parameterType == 'Vector3Parameters' then
                            --             E[elementName] = ty:AddColorEdit(parameterName)
                            --             UI:Config(E[elementName], {
                            --                 NoAlpha = true,
                            --                 IDContext = attachment .. '_' .. parameterName,
                            --                 OnChange = function(e)
                            --                     local value = {e.Color[1], e.Color[2], e.Color[3]}
                            --                     notEnoughAbstractions(elementName, attachment, parameterType, parameterName, value)
                            --                 end
                            --             })

                            --             setValue(E[elementName], Globals.StoredVisualPaths[attachment], parameterType, parameterName)
                            --         end


                            --         if parameterType == 'VectorParameters' then
                            --             E[elementName] = ty:AddColorEdit(parameterName)
                            --             UI:Config(E[elementName], {
                            --                 NoAlpha = false,
                            --                 IDContext = attachment .. '_' .. parameterName,
                            --                 OnChange = function(e)
                            --                     local value = e.Color
                            --                     notEnoughAbstractions(elementName, attachment, parameterType, parameterName, value)
                            --                 end
                            --             })

                            --             setValue(E[elementName], Globals.StoredVisualPaths[attachment], parameterType, parameterName)
                            --         end
                            --     end
                            -- end






                            if parameterType == 'ScalarParameters' then
                                if cfg.int then
                                    E[elementName] = Tree1[attachment]:AddSliderInt(parameterName, 0, cfg.min or min, cfg.max or max, 1)
                                else
                                    E[elementName] = Tree1[attachment]:AddSlider(parameterName, 0, cfg.min or min, cfg.max or max, 0.1)
                                end
                                UI:Config(E[elementName], {
                                    Logarithmic = cfg.log or false,
                                    IDContext = attachment .. '_' .. parameterName,
                                    OnChange = function(e)
                                        local value = e.Value[1]
                                        notEnoughAbstractions(elementName, attachment, parameterType, parameterName, value)
                                    end
                                })

                                setValue(E[elementName], Globals.StoredVisualPaths[attachment], parameterType, parameterName)
                            end



                            if parameterType == 'Vector3Parameters' then
                                E[elementName] = Tree2[attachment]:AddColorEdit(parameterName)
                                UI:Config(E[elementName], {
                                    NoAlpha = true,
                                    IDContext = attachment .. '_' .. parameterName,
                                    OnChange = function(e)
                                        local value = {e.Color[1], e.Color[2], e.Color[3]}
                                        notEnoughAbstractions(elementName, attachment, parameterType, parameterName, value)
                                    end
                                })

                                setValue(E[elementName], Globals.StoredVisualPaths[attachment], parameterType, parameterName)
                            end



                            if parameterType == 'VectorParameters' then
                                E[elementName] = Tree3[attachment]:AddColorEdit(parameterName)
                                UI:Config(E[elementName], {
                                    NoAlpha = false,
                                    IDContext = attachment .. '_' .. parameterName,
                                    OnChange = function(e)
                                        local value = e.Color
                                        notEnoughAbstractions(elementName, attachment, parameterType, parameterName, value)
                                    end
                                })

                                setValue(E[elementName], Globals.StoredVisualPaths[attachment], parameterType, parameterName)
                            end
                        end
                    end
                end

                for _, parameterType in pairs(AllParameterTypes) do
                    CreateElementForParameters(parameterType)
                end
            end
        end
    end
end
