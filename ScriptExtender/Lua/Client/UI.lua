
local OPENQUESTIONMARK = false


function UI:Init()
    Window:CCEEMCM()
    Window:CCEEWindow()
    CCEE:CoolThings()
    CCEE:Skin()
    CCEE:Face()
    CCEE:Head()
    CCEE:Body()
    CCEE:Hair()
    CCEE:Glow()
    CCEE:PresetsTab()
    CCEE:Reset()
    CCEE:Dev()
end


Apply = {}


function Window:CCEEMCM()
    local function CreateCCEEMCMTab(tab)
        local openButton = tab:AddButton("Open")
        openButton.OnClick = function()
            cceeWindow.Open = not cceeWindow.Open
        end
    end
    Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "CCEE", CreateCCEEMCMTab)
end



function Window:CCEEWindow()

    cceeWindow = Ext.IMGUI.NewWindow("CCEE")
    cceeWindow.Open = OPENQUESTIONMARK
    cceeWindow.Closeable = true
    cceeWindow.AlwaysAutoResize = false
    cceeWindow:SetSize({643, 700})


    StyleV2:RegisterWindow(cceeWindow)

    ApplyStyle(cceeWindow, 1)

    -- p = cceeWindow

    MCM.SetKeybindingCallback('ccee_toggle_window', function()
        cceeWindow.Open = not cceeWindow.Open
    end)


    -- MCM.SetKeybindingCallback('ccee_apply_pm_parameters', function()
    --     Helpers.Timer:OnTicks(2, function ()
    --         ApplyParametersToDummies()
    --     end)

    -- end)


    local bar = cceeWindow:AddTabBar('Tabs')

    local mainTab = bar:AddTabItem('Main')

    local presetsTab = bar:AddTabItem('Presets')
    
    local resetTab = bar:AddTabItem('Reset')

    local devTab = bar:AddTabItem('Dev')

    p = mainTab



    -- firstManToUseProgressBar = p:AddProgressBar()
    -- firstManToUseProgressBar.Visible = false

    -- firstManToUseProgressBar:SetColor('PlotHistogram', {1.00, 0.7, 0.7, 1.00})

    -- firstManToUseProgressBarLable = p:AddText('Calculating quats')
    -- firstManToUseProgressBarLable.SameLine = true
    -- firstManToUseProgressBarLable.Visible = false

    function CCEE:CoolThings()


        local STOPPPPP = p:AddButton('Idle')
        STOPPPPP.OnClick = function()
            Ext.Net.PostMessageToServer('stop', '')
        end

        -- local pmButton = p:AddButton('If parameters did not ')

        -- local iSwitchCharacter = mainCollapse:AddButton('I switched character')
        -- iSwitchCharacter.SameLine = true
        -- iSwitchCharacter.OnClick = function ()
        --     Elements:UpdateElements(_C().Uuid.EntityUuid)
        -- end

        local resetCharacter = p:AddButton('Reset character')
        resetCharacter.SameLine = true
        resetCharacter.OnClick = function ()

            confirmResetChar.Visible = true
            resetCharacter.Visible = false

            confirmTimer = Ext.Timer.WaitFor(1000, function()
                confirmResetChar.Visible = false
                resetCharacter.Visible = true
            end)

        end

        local tp103 = resetCharacter:Tooltip()
        tp103:AddText([[
        Resets MOD'S parameters (THE ones in THE WINDOW) for current character]])


        confirmResetChar = p:AddButton('Confirm')

        confirmResetChar:SetColor("Button", {0.55, 0.0, 0.0, 1.00})
        confirmResetChar:SetColor("ButtonHovered", {0.35, 0.0, 0.0, 1.0})
        confirmResetChar:SetColor("ButtonActive", {0.25, 0.0, 0.0, 1.0})
        confirmResetChar.Size = {159,35}

        confirmResetChar.SameLine = true
        confirmResetChar.Visible = false
        confirmResetChar.OnClick = function ()

            Ext.Timer.Cancel(confirmTimer)

            Ext.Net.PostMessageToServer('ResetCurrentCharacter', '')
            if _C().Uuid then
                local uuid = _C().Uuid.EntityUuid
                lastParameters[uuid] = nil
                lastParametersMV[uuid] = nil
                Ext.Net.PostMessageToServer('SendModVars', Ext.Json.Stringify(lastParameters))
            end

            resetCharacter.Visible = true
            confirmResetChar.Visible = false

        end

        local backupPM = p:AddButton('PM backup')
        backupPM.SameLine = true
        backupPM.OnClick = function ()
            ApplyParametersToDummies()
        end

        local tp5 = backupPM:Tooltip()
        tp5:AddText([[
        If parameters didn't apply to PM characters]])

        local forceLoad = p:AddButton('Force load')
        forceLoad.SameLine = true
        forceLoad.OnClick = function ()
            Ext.Net.PostMessageToServer('UpdateParameters', '')
        end

        local tp3 = forceLoad:Tooltip()
        tp3:AddText([[
        Loads stored data from the save file for every character in scene
        Useful if visually MOD'S parameters (THE ones in THE WINDOW) got reset]])

        local sepa = p:AddSeparatorText('')
    end


    ---@param fn function # loooooooooooook it's colored! 
    function Elements:CreateElements(type, var, name, parent, options, fn)
        if type == 'int' then 
            self[var] = parent:AddSliderInt(name, options.def or 0, options.min or 0, options.max or 1, 0)
            self[var].Logarithmic = options.log or false
        elseif type == 'picker' then
            self[var] = parent:AddColorEdit(name)
            self[var].Float = true
            self[var].NoAlpha = true
        else
            self[var] = parent:AddSlider(name, options.default or 0, options.min or 0, options.max or 1, 0)
            self[var].Logarithmic = options.log or false
        end
        self[var].IDContext = Ext.Math.Random(1,1000000)
        self[var].OnChange = function (e)
            fn(e)
        end
    end



    ---@param parameterName MaterialParameterName
    ---@param var ExtuiSliderScalar
    ---@param type string|nil -- 'mp' = MaterialPreset, nil = SaveAndApply
    ---@param attachments VisualAttachment
    function Apply:Scalar(parameterName, var, type, attachments)
        if type == 'mp' then
            MaterialPreset(_C(), parameterName, 'ScalarParameters', var.Value[1])
        else
            for _, attachment in pairs(attachments) do
                SaveAndApply(_C(), attachment, parameterName, 'ScalarParameters', var.Value[1])
            end
        end
    end


    ---@param parameterName MaterialParameterName
    ---@param var ExtuiColorEdit | ExtuiColorPicker
    ---@param type string|nil -- 'mp' = MaterialPreset, nil = SaveAndApply
    ---@param attachments VisualAttachment
    function Apply:Vector3(parameterName, var, type, attachments)
        if type == 'mp' then
            MaterialPreset(_C(), parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
        else
            for _, attachment in pairs(attachments) do
                SaveAndApply(_C(), attachment, parameterName, 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
            end
        end
    end


    ---@param parameterName MaterialParameterName
    ---@param var ExtuiSliderScalar
    ---@param type number -- 1 = Vecror{Value[1], 0,0,0}, 2 = Vecror{0,Value[1],0,0}, 3 = Vecror{0,0,Value[1],0}
    ---@param attachments VisualAttachment
    function Apply:Vector(parameterName, var, type, attachments)
        if type == 1 then
            for _, attachment in pairs(attachments) do
                SaveAndApply(_C(), attachment, parameterName, 'Vector_1Parameters', var.Value[1])
            end
        elseif type == 2 then
            for _, attachment in pairs(attachments) do
                SaveAndApply(_C(), attachment, parameterName, 'Vector_2Parameters', var.Value[1])
            end
        elseif type == 3 then
            for _, attachment in pairs(attachments) do
                SaveAndApply(_C(), attachment, parameterName, 'Vector_3Parameters', var.Value[1])
            end
        end
    end


    ---@param table table
    function Elements:CreateMetatables(table)
        for parameterGroup, _ in pairs(table) do
            setmetatable(table[parameterGroup], {__index = Apply})
        end
    end

    ---@param table table | --aahTable
    ---@param collapse ExtuiCollapsingHeader
    ---@param treeName string
    function Elements:PopulateTab(table, collapse, treeName)
        local tree = collapse:AddTree(treeName)    
        tree.IDContext = Ext.Math.Random(1,100000)
        for _, v in ipairs(table) do
            v[4] = tree
            self:CreateElements(table.unpack(v))
            v[4] = parent
        end
    end


    ---ahh table
    local parent
    ahhTable = {

        Melanin = {

            {'picker', 'pickMelaninColor', 'Color', parent, {}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'MelaninColor', 'Vector3', var.Color)

                -- end 
                -- MaterialPreset(_C(), 'MelaninColor', 'Vector3Parameters',  {var.Color[1],var.Color[2],var.Color[3]})

                ahhTable.Melanin:Vector3('MelaninColor', var, 'mp', nil)

                end},
                
            {nil, 'slMelaninAmount', 'Amount', parent, {}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'MelaninAmount', 'Scalar', var.Value[1])
                -- end 
                -- MaterialPreset(_C(), 'MelaninAmount', 'ScalarParameters', var.Value[1])

                ahhTable.Melanin:Scalar('MelaninAmount', var, 'mp', nil)

                end},


            {nil, 'slMelaninRemoval', 'Removal amount', parent, {max = 100, log = true}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'MelaninRemovalAmount', 'Scalar', var.Value[1])
                -- end 
                -- MaterialPreset(_C(), 'MelaninRemovalAmount', 'ScalarParameters', var.Value[1])

                ahhTable.Melanin:Scalar('MelaninRemovalAmount', var, 'mp', nil)

                end},


            {nil, 'slMelaninDarkM', 'Dark multiplier', parent, {max = 100, log = true}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'MelaninDarkMultiplier', 'Scalar', var.Value[1])
                -- end 

                --MaterialPreset(_C(), 'MelaninDarkMultiplier', 'ScalarParameters', var.Value[1])
                
                ahhTable.Melanin:Scalar('MelaninDarkMultiplier', var, 'mp', nil)

                end},

            {nil, 'slMelaninDarkT', 'Dark threshold', parent, {max = 1}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'MelaninDarkThreshold', 'Scalar', var.Value[1])
                -- end
                -- MaterialPreset(_C(), 'MelaninDarkThreshold', 'ScalarParameters', var.Value[1])

                ahhTable.Melanin:Scalar('MelaninDarkThreshold', var, 'mp', nil)

                end},
        },

        Hemoglobin = {

            {'picker', 'pickHemoglobinColor', 'Color', parent, {}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'HemoglobinColor', 'Vector3', var.Color)
                -- end 
                MaterialPreset(_C(), 'HemoglobinColor', 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
                end},

            {nil, 'slHemoglobinAmount', 'Amount', parent, {max = 3}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'HemoglobinAmount', 'Scalar', var.Value[1])
                -- end 
                MaterialPreset(_C(), 'HemoglobinAmount', 'ScalarParameters', var.Value[1])
                end},
        },

        Yellowing = {
            {'picker', 'pickYellowingColor', 'Color', parent, {}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'YellowingColor', 'Vector3', var.Color)
                -- end 
                MaterialPreset(_C(), 'YellowingColor', 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
                end},
                
            {nil, 'slYellowingAmount', 'Amount', parent, {min = -300, max = 300, log = true}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'YellowingAmount', 'Scalar', var.Value[1])
                -- end 
                MaterialPreset(_C(), 'YellowingAmount', 'ScalarParameters', var.Value[1])
                end},
        },
        
        Vein = {
            {'picker', 'pickVeinColor', 'Color', parent, {}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'VeinColor', 'Vector3', var.Color)
                -- end 
                MaterialPreset(_C(), 'VeinColor', 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
                end},

            {nil, 'slVeinAmount', 'Amount', parent, {max = 7}, function(var)
                -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                --     SaveAndApply(_C(), attachment, 'VeinAmount', 'Scalar', var.Value[1])
                -- end 
                MaterialPreset(_C(), 'VeinAmount', 'ScalarParameters', var.Value[1])
                end},
        },

        UnsortedB = {
            {'picker', 'pickNonSkinColor', 'NonSkinColor', parent, {}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'NonSkinColor', 'Vector3', var.Color)
                end end},

            {nil, 'slNonSkinWeight', 'NonSkin_Weight', parent, {max = 7}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'NonSkin_Weight', 'Scalar', var.Value[1])
                end end},

            {nil, 'slNonSkinMetalness', 'NonSkinMetalness', parent, {max = 7}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'NonSkinMetalness', 'Scalar', var.Value[1])
                end end},

            {nil, 'slFreckles', 'Freckles', parent, {max = 7}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'Freckles', 'Scalar', var.Value[1])
                end end},

            {nil, 'slFrecklesWeight', 'FrecklesWeight', parent, {max = 7}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'FrecklesWeight', 'Scalar', var.Value[1])
                end end},

                
            {nil, 'slVitiligo', 'Vitiligo', parent, {max = 7}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'Vitiligo', 'Scalar', var.Value[1])
                end end},

            {nil, 'slVitiligoWeight', 'VitiligoWeight', parent, {max = 7}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'VitiligoWeight', 'Scalar', var.Value[1])
                end end},

            {nil, 'slSweat', 'Sweat (smh)', parent, {max = 2}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'Sweat', 'Scalar', var.Value[1])
                end end},

            {nil, 'slBlood', 'Blood', parent, {max = 2}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'Blood', 'Scalar', var.Value[1])
                end end},
        },

        Eyes_makeup = {
            {'int', 'slIntMakeupIndex', 'Index', parent, {max = 31}, function(var) --makeupCount
                SaveAndApply(_C(), 'Head', 'MakeUpIndex', 'Scalar', var.Value[1]) end},
        
            {'picker', 'pickMakeupColor', 'Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'MakeupColor', 'Vector3', var.Color) end},
        
            {nil, 'slMakeupInt', 'Intensity', parent, {max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'MakeupIntensity', 'Scalar', var.Value[1]) end},
        
            {nil, 'slMakeupMet', 'Metalness', parent, {max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'EyesMakeupMetalness', 'Scalar', var.Value[1]) end},
        
            {nil, 'slMakeupRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'MakeupRoughness', 'Scalar', var.Value[1]) end},
        },
        
        Lips_makeup = {
            {'picker', 'pickLipsColor', 'Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Lips_Makeup_Color', 'Vector3', var.Color) end},
        
            {nil, 'slLipsInt', 'Intensity', parent, {max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'LipsMakeupIntensity', 'Scalar', var.Value[1]) end},
        
            {nil, 'slLipsMet', 'Metalness', parent, {max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'LipsMakeupMetalness', 'Scalar', var.Value[1]) end},
        
            {nil, 'slLipsRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'LipsMakeupRoughness', 'Scalar', var.Value[1]) end},
        },

        Tattoo = {

            {'int', 'slIntTattooIndex', 'Index', parent, {max = 31}, function(var) --tattooCount
                SaveAndApply(_C(), 'Head', 'TattooIndex', 'Scalar', var.Value[1]) end},
        
            {'picker', 'pickTattooColorR', 'Color R', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooColor', 'Vector3', var.Color) end},
        
            {'picker', 'pickTattooColorG', 'Color G', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooColorG', 'Vector3', var.Color) end},
        
            {'picker', 'pickTattooColorB', 'Color B', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooColorB', 'Vector3', var.Color) end},
        
            {nil, 'pickTattooIntR', 'Intensity R', parent, {min = -5, max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooIntensity', 'Vector_1', var.Value[1]) 
                Elements['pickTattooIntG'].Value = {0,0,0,0}
                Elements['pickTattooIntB'].Value = {0,0,0,0}
                end},
                
        
            {nil, 'pickTattooIntG', 'Intensity G', parent, {min = -5, max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooIntensity', 'Vector_2', var.Value[1]) 
                Elements['pickTattooIntR'].Value = {0,0,0,0}
                Elements['pickTattooIntB'].Value = {0,0,0,0}
                end},
        
            {nil, 'pickTattooIntB', 'Intensity B', parent, {min = -5, max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooIntensity', 'Vector_3', var.Value[1]) 
                Elements['pickTattooIntR'].Value = {0,0,0,0}
                Elements['pickTattooIntG'].Value = {0,0,0,0}
                end},
        
            {nil, 'slTattooMet', 'Metalness', parent, {min = 0, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooMetalness', 'Scalar', var.Value[1]) end},
        
            {nil, 'slTattooRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooRoughnessOffset', 'Scalar', var.Value[1]) end},
        
            {nil, 'slTattooCurve', 'Curvature influence', parent, {min = 0, max = 100}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooCurvatureInfluence', 'Scalar', var.Value[1]) end},
        },
        
        Age = {
        
            {nil, 'slAgeInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Age_Weight', 'Scalar', var.Value[1]) end},
        },
        
        Scars = {
        
            {'int', 'slIntScarIndex', 'Index', parent, {max = 24}, function(var) --scarCount
                SaveAndApply(_C(), 'Head', 'ScarIndex', 'Scalar', var.Value[1]) end},
        
            {nil, 'slScarWeight', 'Intensity', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scar_Weight', 'Scalar', var.Value[1]) end},
        },
        
        Scales = {
        
            {'int', 'slIntScaleIndex', 'Index', parent, {max = 31}, function(var)
                SaveAndApply(_C(), 'Head', 'CustomIndex', 'Scalar', var.Value[1]) end},
        
            {'picker', 'pickScaleColor', 'Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'CustomColor', 'Vector3', var.Color) end},
        
            {nil, 'slScaleInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'CustomIntensity', 'Scalar', var.Value[1]) end},
        },

        
        Eyes = {
            {'int', 'slEyesHet', 'Heterochromia', parent, {max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'Heterochromia', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slEyesBR', 'Blindness R', parent, {max = 3}, function(var)
                SaveAndApply(_C(), 'Head', 'Blindness', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slEyesBL', 'Blindness L', parent, {max = 3}, function(var)
                SaveAndApply(_C(), 'Head', 'Blindness_L', 'Scalar', var.Value[1])
            end},
            
            {'picker', 'pickEyesC', 'Iris color 1', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_IrisColour', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesCL', 'Iris color 1 L', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_IrisColour_L', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesC2', 'Iris color 2', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_IrisSecondaryColour', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesC2L', 'Iris color 2 L', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_IrisSecondaryColour_L', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesSC', 'Sclera color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_ScleraColour', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesSCL', 'Sclera color L', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_ScleraColour_L', 'Vector3', var.Color)
            end},
        
            {nil, 'slEyesCI', 'Iris color int', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Head', 'SecondaryColourIntensity', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slEyesCIL', 'Iris color int L', parent, {min = -100, max = 100}, function(var)
                SaveAndApply(_C(), 'Head', 'SecondaryColourIntensity_L', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slEyesEdge', 'IrisEdgeStrength', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Head', 'IrisEdgeStrength', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slEyesEdgeL', 'IrisEdgeStrength L', parent, {min = -100, max = 100}, function(var)
                SaveAndApply(_C(), 'Head', 'IrisEdgeStrength_L', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slEyesRed', 'Redness', parent, {max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Redness', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slEyesRedL', 'Redness L', parent, {max = 100}, function(var)
                SaveAndApply(_C(), 'Head', 'Redness_L', 'Scalar', var.Value[1])
            end}
        },

        Body_tattoos = {
            {'int', 'slBTatI', 'Index', parent, {max = tattooCount}, function(var)
            for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'BodyTattooIndex', 'Scalar', var.Value[1])
            end

            -- MaterialPreset(_C(), 'BodyTattooIndex', 'ScalarParameters', var.Value[1])

            end},
            
            {'picker', 'pickBTatCR', 'Color R', parent, {}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    -- DPrint(attachment)
                    SaveAndApply(_C(), attachment, 'BodyTattooColor', 'Vector3', var.Color);
                end

                -- MaterialPreset(_C(), 'BodyTattooColor', 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})

            end},
            
            {'picker', 'pickBTatCG', 'Color G', parent, {}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'BodyTattooColorG', 'Vector3', var.Color)
                end
            end},
            
            {'picker', 'pickBTatCB', 'Color B', parent, {}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'BodyTattooColorB', 'Vector3', var.Color)
                end
            end},
            
            {nil, 'slBTatIntR', 'Intensity R', parent, {min = -5, max = 5}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'BodyTattooIntensity', 'Vector_1', var.Value[1])
                    -- SaveAndApply(_C(), attachment, 'TattooIntensity', 'Vector_1', var.Value[1])
                end
                Elements['slBTatIntG'].Value = {0,0,0,0}
                Elements['slBTatIntB'].Value = {0,0,0,0}
            end},
            
            {nil, 'slBTatIntG', 'Intensity G', parent, {min = -5, max = 5}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'BodyTattooIntensity', 'Vector_2', var.Value[1])
                end

                
                -- MaterialPreset(_C(), 'BodyTattooIntensity', 'Vector3Parameters', {var.Value[1],0,0,0})

                Elements['slBTatIntR'].Value = {0,0,0,0}
                Elements['slBTatIntB'].Value = {0,0,0,0}
            end},
            
            {nil, 'slBTatIntB', 'Intensity B', parent, {min = -5, max = 5}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'BodyTattooIntensity', 'Vector_3', var.Value[1])
                end
                Elements['slBTatIntR'].Value = {0,0,0,0}
                Elements['slBTatIntG'].Value = {0,0,0,0}
            end},
            
            {nil, 'slBTatMet', 'Metalness', parent, {max = 1}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'TattooMetalness', 'Scalar', var.Value[1])
                end
            end},
        
            {nil, 'slBTatR', 'Roughness', parent, {min = -1, max = 1}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'TattooRoughnessOffset', 'Scalar', var.Value[1])
                end
            end},
              
            {nil, 'slBTatCurve', 'Curvature influence', parent, {max = 100}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'TattooCurvatureInfluence', 'Scalar', var.Value[1])
                end
            end}
        },

        Private_parts = {             
            {'int', 'slIntPPOpac', 'Toggle', parent, {def = 1}, function(var)
                SaveAndApply(_C(), 'Private parts', 'InvertOpacity', 'Scalar', var.Value[1])
            end},
        },


        Scalp = {             
            {'picker', 'pickHairScalpColor', 'Hair Scalp Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Hair_Scalp_Color', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickHueShiftWeight', 'Hue Shift Weight', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_HueShiftColorWeight', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickBeardScalpColor', 'Beard Scalp Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Beard_Scalp_Color', 'Vector3', var.Color)
            end},

            {nil, 'slScalpMinValue', 'Scalp Min Value', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_MinValue', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slHornMaskWeight', 'Horn Mask Weight', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_HornMaskWeight', 'Scalar', var.Value[1])
            end},

            {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_Graying_Intensity', 'Scalar', var.Value[1])
            end},
            
            {'picker', 'pickGrayingColor', 'Graying Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Hair_Scalp_Graying_Color', 'Vector3', var.Color)
            end},   
            
            {nil, 'slColorTransitionMid', 'Color Transition Mid', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_ColorTransitionMidPoint', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slColorTransitionSoft', 'Color Transition Soft', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_ColorTransitionSoftness', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slDepthColorExponent', 'Depth Color Exponent', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_DepthColorExponent', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slDepthColorIntensity', 'Depth Color Intensity', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_DepthColorIntensity', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slIDContrast', 'ID Contrast', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_IDContrast', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slColorDepthContrast', 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_ColorDepthContrast', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slScalpRoughness', 'Scalp Roughness', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_Roughness', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slRoughnessContrast', 'Roughness Contrast', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_RoughnessContrast', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slScalpScatter', 'Scalp Scatter', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_Scatter', 'Scalar', var.Value[1])
            end},

        },

        Hair = {
            {'picker', 'pickHairColor', 'Hair Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'Hair_Color', 'Vector3', var.Color)
            end},
        
            {nil, 'slSharedNoiseTiling', 'Shared Noise Tiling', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Hair', 'SharedNoiseTiling', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slHairFrizz', 'Hair Frizz', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Hair', 'HairFrizz', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slHairSoupleness', 'Hair Soupleness', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Hair', 'HairSoupleness', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slMaxWindMovement', 'Max Wind Movement', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Hair', 'MaxWindMovementAmount', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slSoftenTipsAlpha', 'Soften Tips Alpha', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'SoftenTipsAlpha', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slBaseColorVar', 'Base Color Var', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Hair', 'BaseColorVar', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slRootTransitionMid', 'Root Transition Mid', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'RootTransitionMidPoint', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slRootTransitionSoft', 'Root Transition Soft', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Hair', 'RootTransitionSoftness', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slDepthColorExponent', 'Depth Color Exponent', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'DepthColorExponent', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slDepthColorIntensity', 'Depth Color Intensity', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'DepthColorIntensity', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slColorDepthContrast', 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Hair', 'ColorDepthContrast', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slDreadNoiseBaseColor', 'Dread Noise Base Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'DreadNoiseBaseColor', 'Scalar', var.Value[1])
            end}
        },
        
        Graying = {
            {'picker', 'pickHairGrayingColor', 'Hair Graying Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'Hair_Graying_Color', 'Vector3', var.Color)
            end},
        
            {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1.2}, function(var)
                SaveAndApply(_C(), 'Hair', 'Graying_Intensity', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slGrayingSeed', 'Graying Seed', parent, {min = -10, max = 10, log = true}, function(var)
                SaveAndApply(_C(), 'Hair', 'Graying_Seed', 'Scalar', var.Value[1])
            end}
        },
        
        Highlights = {
            {'picker', 'pickHighlightColor', 'Highlight Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'Highlight_Color', 'Vector3', var.Color)
            end},
        
            {nil, 'slHighlightFalloff', 'Highlight Falloff', parent, {min = -1, log = true}, function(var)
                SaveAndApply(_C(), 'Hair', 'Highlight_Falloff', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slHighlightIntensity', 'Highlight Intensity', parent, {log = true}, function(var)
                SaveAndApply(_C(), 'Hair', 'Highlight_Intensity', 'Scalar', var.Value[1])
            end}
        },

        Beard = {
            {'int', 'slIntBeardIndex', 'BeardIndex', parent, {min = -1, max = 100}, function(var)
                SaveAndApply(_C(), 'Head', 'BeardIndex', 'Scalar', var.Value[1])
            end},

            {'picker', 'pickBeardScalpColor', 'Beard_Scalp_Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'Beard_Scalp_Color', 'Vector3', var.Color)
            end},

            {'picker', 'pickBeardColor', 'Beard_Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'Beard_Color', 'Vector3', var.Color)
            end},

            {'picker', 'pickBeardGrayingColor', 'Beard_Graying_Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'Beard_Graying_Color', 'Vector3', var.Color)
            end},

            {'picker', 'pickBeardHighlightColor', 'Beard_Highlight_Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Hair', 'Beard_Highlight_Color', 'Vector3', var.Color)
            end},
        
            {nil, 'slBeardMinValue', 'BeardMinValue', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'BeardMinValue', 'Scalar', var.Value[1])
            end},

            {nil, 'slBeardInt', 'BeardIntesity', parent, {min = -100, max = 100}, function(var)
                SaveAndApply(_C(), 'Hair', 'BeardIntesity', 'Scalar', var.Value[1])
            end},

            {nil, 'slBeardDesat', 'BeardDesaturation', parent, {min = -100, max = 100}, function(var)
                SaveAndApply(_C(), 'Head', 'BeardDesaturation', 'Scalar', var.Value[1])
            end},

            {nil, 'slBeardDarken', 'BeardDarken', parent, {min = -100, max = 100}, function(var)
                SaveAndApply(_C(), 'Head', 'BeardDarken', 'Scalar', var.Value[1])
            end},

            {nil, 'slBeardGrayingInt', 'Beard_Graying_Intensity', parent, {min = -100, max = 100}, function(var)
                SaveAndApply(_C(), 'Hair', 'Beard_Graying_Intensity', 'Scalar', var.Value[1])
            end},
        },


        BodyHair = {
            {'picker', 'pickBodyHairC', 'Color', parent, {}, function(var)
                for _, attachment in ipairs({'NakedBody', 'Private Parts'}) do
                SaveAndApply(_C(), attachment, 'Body_Hair_Color', 'Vector3', var.Color)
                end
            end},
        },


        Horns = {
            {'picker', 'pickHornsColor', 'Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Horns', 'NonSkinColor', 'Vector3', var.Color)
            end},
        
            {'picker', 'pickHornsTipColor', 'Tip color', parent, {}, function(var)
                SaveAndApply(_C(), 'Horns', 'NonSkinTipColor', 'Vector3', var.Color)
            end},

            {nil, 'slHornReflectance', 'Reflectance', parent, {}, function(var)
                SaveAndApply(_C(), 'Horns', 'Reflectance', 'Scalar', var.Value[1])
            end},

            {'int', 'slHornGlow', 'Toggle glow ', parent, {}, function(var)
                SaveAndApply(_C(), 'Horns', 'Use_BlackBody', 'Scalar', var.Value[1])
                SaveAndApply(_C(), 'Horns', 'Colour_BlackBody', 'Scalar', var.Value[1])
                SaveAndApply(_C(), 'Horns', 'Use_ColorRamp', 'Scalar', 1 - var.Value[1])
            end},

            -- {'int', 'slHornColour_BlackBody', 'Use glow 2', parent, {}, function(var)
            --     SaveAndApply(_C(), 'Horns', 'Colour_BlackBody', 'Scalar', var.Value[1])
            -- end},

            -- {'int', 'slHornUse_ColorRamp', 'Use_ColorRamp', parent, {def = 1}, function(var)
            --     SaveAndApply(_C(), 'Horns', 'Use_ColorRamp', 'Scalar', var.Value[1])
            -- end},

            {'picker', 'slHornBlackBody_Colour', 'Glow color', parent, {}, function(var)
                    SaveAndApply(_C(), 'Horns', 'BlackBody_Colour', 'Vector3', var.Color)
            end},

            {nil, 'slHornIntensity', 'Glow intensity', parent, {max = 200, log = true}, function(var)
                SaveAndApply(_C(), 'Horns', 'Intensity', 'Scalar', var.Value[1])
            end},

            
            {nil, 'slHornBlackbody_PreRamp_Power', 'Also glow int', parent, {}, function(var)
                SaveAndApply(_C(), 'Horns', 'Blackbody_PreRamp_Power', 'Scalar', var.Value[1])
            end},

            -- {nil, 'slHornamp2', 'amp2', parent, {min = -100, max = 100, log = true}, function(var)
            --     SaveAndApply(_C(), 'Horns', 'amp2', 'Scalar', var.Value[1])
            -- end},

            {nil, 'slHornEmissive_Mult', 'Emissive_Mult', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Horns', 'Emissive_Mult', 'Scalar', var.Value[1])
            end},

            {'int', 'slHornUse_HeartBeat', 'Use_HeartBeat', parent, {}, function(var)
                SaveAndApply(_C(), 'Horns', 'Use_HeartBeat', 'Scalar', var.Value[1])
            end},

            {nil, 'slHornLength', 'Length', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Horns', 'Length', 'Scalar', var.Value[1])
            end},

            {nil, 'slHornamplitude', 'Amplitude', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Horns', 'amplitude', 'Scalar', var.Value[1])
            end},

            {nil, 'slHornBPM', 'BPM', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Horns', 'BPM', 'Scalar', var.Value[1])
            end},

            -- {nil, 'slHornContrast', 'Contrast', parent, {min = -100, max = 100, log = true}, function(var)
            --     SaveAndApply(_C(), 'Horns', 'Contrast', 'Scalar', var.Value[1])
            -- end},

            -- {nil, 'slHornPreRampIntensity', 'PreRampIntensity', parent, {min = -100, max = 100, log = true}, function(var)
            --     SaveAndApply(_C(), 'Horns', 'PreRampIntensity', 'Scalar', var.Value[1])
            -- end},

            -- {nil, 'slHornPostRampIntensity', 'PostRampIntensity', parent, {min = -100, max = 100, log = true}, function(var)
            --     SaveAndApply(_C(), 'Horns', 'PostRampIntensity', 'Scalar', var.Value[1])
            -- end},


        },

        GlowHead = {


            {'picker', 'pickHeadGlowColor', 'Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowColor', 'Vector3', var.Color)
            end},


            {nil, 'slHeadGlowMult', 'Multiplier', parent, {max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowMultiplier', 'Scalar', var.Value[1])
            end},

            {nil, 'slHeadAnimdSpeed', 'Animation speed', parent, {max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'AnimationSpeed', 'Scalar', var.Value[1])
            end},
        },


        GlowBody = {


            {'picker', 'pickBodyGlowColor', 'Color', parent, {}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'GlowColor', 'Vector3', var.Color)
            end},


            {nil, 'slBodyGlowMult', 'Multiplier', parent, {max = 5}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'GlowMultiplier', 'Scalar', var.Value[1])
            end},

            {nil, 'slBodyAnimdSpeed', 'Animation speed', parent, {max = 10}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'AnimationSpeed', 'Scalar', var.Value[1])
            end},
        },

        GlowEyes = {

            {nil, 'slEyesGlowBright', 'Brightness', parent, {min = -200, max = 200}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowBrightness', 'Scalar', var.Value[1])
            end},


            {nil, 'slEyesGlowBrightL', 'Brightness L', parent, {min = -200, max = 200}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowBrightness_L', 'Scalar', var.Value[1])
            end},


            {nil, 'slEyesGlowBrightPup', 'Brightness pupil', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowBrightnessPupil', 'Scalar', var.Value[1])
            end},


            {nil, 'slEyesFxMasking', 'Fx masking', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowBrightnessPupil', 'Scalar', var.Value[1])
            end},

            {nil, 'slEyesFxMaskingL', 'Fx masking L', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowBrightnessPupil', 'Scalar', var.Value[1])
            end},

            

            
            {'picker', 'slEyesGlowColor', 'Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_GlowColour', 'Vector3', var.Color)
            end},

            {'picker', 'slEyesGlowColorL', 'Color L', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_GlowColour_L', 'Vector3', var.Color)
            end},
        },

    }


    Elements:CreateMetatables(ahhTable)


    function CCEE:Skin()
    
        local skinColorCollapse = p:AddCollapsingHeader('Skin')
        local parent =skinColorCollapse

        Elements:PopulateTab(ahhTable['Melanin'], parent, 'Melanin')

        Elements:PopulateTab(ahhTable['Hemoglobin'], parent, 'Hemoglobin')

        Elements:PopulateTab(ahhTable['Yellowing'], parent, 'Yellowing')

        Elements:PopulateTab(ahhTable['Vein'], parent, 'Vein')


        Elements:PopulateTab(ahhTable['UnsortedB'], parent, 'UnsortedB')


        local sepa = skinColorCollapse:AddSeparatorText('')

    end


    function CCEE:Face()

        local faceCollapse = p:AddCollapsingHeader('Face')
        local parent = faceCollapse

        Elements:PopulateTab(ahhTable['Eyes makeup'], parent, 'Eyes makeup')

        Elements:PopulateTab(ahhTable['Lips makeup'], parent, 'Lips makeup')

        Elements:PopulateTab(ahhTable['Tattoo'], parent, 'Tattoo')

        Elements:PopulateTab(ahhTable['Scars'], parent, 'Scars')

        Elements:PopulateTab(ahhTable['Age'], parent, 'Age')

        Elements:PopulateTab(ahhTable['Scales'], parent, 'Scales')

        local sepa1 = faceCollapse:AddSeparatorText('')

    end


    function CCEE:Head()

        local headCollapse = p:AddCollapsingHeader('Head')
        local parent = headCollapse

        Elements:PopulateTab(ahhTable['Eyes'], parent, 'Eyes')


        Elements:PopulateTab(ahhTable['Horns'], parent, 'Horns')


        -- local treeTeeth = headCollapse:AddTree('Teeth')

        local sepa1 = headCollapse:AddSeparatorText('')
    end


    function CCEE:Body()

        local bodyCollapse = p:AddCollapsingHeader('Body')
        local parent = bodyCollapse

        Elements:PopulateTab(ahhTable['Body tattoos'], parent, 'Tattoes')

        Elements:PopulateTab(ahhTable['Private parts'], parent, 'Private parts')

        local sepa133 = bodyCollapse:AddSeparatorText('')

    end


    function CCEE:Hair()

        local hairCollapse = p:AddCollapsingHeader('Hair')
        local parent = hairCollapse

        local lashTree = hairCollapse:AddTree('Lashes')


        pcikEyeLC = lashTree:AddColorEdit('Color')
        pcikEyeLC.IDContext = 'eyeLC'
        pcikEyeLC.Float = true
        pcikEyeLC.NoAlpha = true
        pcikEyeLC.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyelashes_Color', 'Vector3', pcikEyeLC.Color)
        end

        local browTree = hairCollapse:AddTree('Eyebrow')

        pickEyeBC = browTree:AddColorEdit('Color')
        pickEyeBC.IDContext = 'eyeBC'
        pickEyeBC.Float = true
        pickEyeBC.NoAlpha = true
        pickEyeBC.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyebrow_Color', 'Vector3', pickEyeBC.Color)
        end

        Elements:PopulateTab(ahhTable['Scalp'], parent, 'Scalp')

        Elements:PopulateTab(ahhTable['Hair'], parent, 'Hair')

        Elements:PopulateTab(ahhTable['Graying'], parent, 'Graying')

        Elements:PopulateTab(ahhTable['Highlights'], parent, 'Highlights')

        Elements:PopulateTab(ahhTable['Beard'], parent, 'Beard')

        Elements:PopulateTab(ahhTable['BodyHair'], parent, 'Body hair')




        local sepa1333 = hairCollapse:AddSeparatorText('')

    end


    function CCEE:Glow()

        local glowCollapse = p:AddCollapsingHeader('Glow')

        local parent = glowCollapse

        local textGlow = parent:AddBulletText('Only works if texture has glow')
        textGlow:SetColor('Text',  {1.00, 0.75, 0.75, 1.00})

        Elements:PopulateTab(ahhTable['GlowHead'], parent, 'Head')
        
        Elements:PopulateTab(ahhTable['GlowBody'], parent, 'Body')

        Elements:PopulateTab(ahhTable['GlowEyes'], parent, 'Eyes')


    end


    function CCEE:PresetsTab()

        -- local sepa = pT:AddSeparatorText('Savings loadings')

        -- local saveParams = pT:AddButton('Save')
        -- saveParams.OnClick = function ()
        --     SaveParamsToFile()
        -- end

        -- local tp3 = saveParams:Tooltip()
        -- tp3:AddText([[
        -- Saves all edited parameters for every character in the scene in local file
        -- AppData\Local\Larian Studios\Baldur's Gate 3\Script Extender\CCEE]])


        -- local loadParams = pT:AddButton('Load')
        -- loadParams.SameLine = true
        -- loadParams.OnClick = function ()
        --     LoadParamsFromFile()
        -- end

        -- local sepapT1 = pT:AddSeparatorText('Presets')

        local sepapT2 = presetsTab:AddSeparatorText('Save')
        local presetNameLoad = presetsTab:AddInputText('Preset name')
        presetNameLoad.IDContext = 'presetNameLoad'

        local savePreset = presetsTab:AddButton('Save')
        savePreset.IDContext = 'savePreset'
        savePreset.OnClick = function ()
            SavePreset(presetNameLoad.Text)
            presetNameLoad.Text = ''
        end

        local sepapT2 = presetsTab:AddSeparatorText('Load')
        local presetLoadName = presetsTab:AddInputText('Preset name')
        presetLoadName.IDContext = 'presetLoadName'

        local loadPreset = presetsTab:AddButton('Load')
        loadPreset.IDContext = 'loadPreset'
        loadPreset.OnClick = function ()
            LoadPreset(presetLoadName.Text)
            presetLoadName.Text = ''
        end


        local loadPreset2 = presetsTab:AddButton('ReLoad')
        loadPreset2.SameLine = true
        loadPreset2.IDContext = 'loadPrese2'
        loadPreset2.OnClick = function ()
            LoadPreset2(presetLoadName.Text)
            presetLoadName.Text = ''
        end
        

        local tp6 = loadPreset2:Tooltip()
        tp6:AddText([[
        If you changed/added an attachment (hair, horns, dick hair, etc) in the Mirror,
        load your preset using this button, so the added attachment doesn't get overridden.
        And after saving it, you can use Load]])


    end

    function CCEE:Reset()

        local resetTableBtn = resetTab:AddButton('Reset save data')
        resetTableBtn.OnClick = function ()

            lastParameters = {}
            lastParametersMV = {}
            dummies = {}
            -- Parameters = {}

            Ext.Net.PostMessageToServer('ResetAllData', '')

            for _, element in pairs(Elements) do
                local s, _ = pcall(function() return element.Value end)
                if s then
                    element.Value = {0, 0, 0, 0}
                else
                    local s2, _ = pcall(function() return element.Color end)
                    if s2 then
                        element.Color = {0, 0, 0, 0}
                    end
                end
            end

        end

        local tp2 = resetTableBtn:Tooltip()
        tp2:AddText([[
        The mod stores data in game save file, this button resets the data]])



    end

    function CCEE:Dev()


        local dumpVars = devTab:AddButton('Dump vars')
        dumpVars.OnClick = function ()
            Ext.Net.PostMessageToServer('dumpVars', '')
        end




        local testsCheck = devTab:AddCheckbox('All parameters (they do not save)')
            testsCheck.IDContext = 'adasd22'
            testsCheck.SameLine = true
            testsCheck.OnChange = function ()
                if testsCheck.Checked then
                    CCEE:Tests()
                else
                    sepate:Destroy()
                    testParams:Destroy()
                end
            end

    end

    function CCEE:Tests()
        sepate = p:AddSeparatorText('Not main tabs')
        local parent = p
        testParams = parent:AddCollapsingHeader('All parameters')

        function Tests:Body()

            local testParamsBody = testParams:AddTree('Bodyd')
            local treeTestParams = testParamsBody:AddTree('Scalar')
            local treeTestParams2 = testParamsBody:AddTree('Vec3')
            local treeTestParams3 = testParamsBody:AddTree('Vec')
    
            function TestAllBodyScalarParameters()
                for _,v in ipairs(Parameters.NakedBody.Scalar) do
                    local testSlider = treeTestParams:AddSlider(v, 0, -100, 100)
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        for _, part in ipairs({'NakedBody'}) do
                            ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
                        end
                    end
                end
            end
    
            function TestAllBodyVec3Parameters()
                for _,v in ipairs(Parameters.NakedBody.Vector3) do
                    local testPicker = treeTestParams2:AddColorEdit(v)
                    testPicker.NoAlpha = true
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        for _, part in ipairs({'NakedBody'}) do
                            ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
                        end
                    end
                end
            end
    
            function TestAllBodyVecParameter()
                for _,v in ipairs(Parameters.NakedBody.Vector) do
                    local testSlider2 = treeTestParams3:AddSlider(v)
                    testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider2.OnChange = function()
                        for _, part in ipairs({'NakedBody'}) do
                            ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
                        end
                    end
                end
            end
    

            TestAllBodyScalarParameters()
            TestAllBodyVec3Parameters()
            TestAllBodyVecParameter()
    
        end
       
        function Tests:Head()

            local testParamsHead = testParams:AddTree('Headd')
            local treeTestParams4 = testParamsHead:AddTree('Scalard')
            local treeTestParams5 = testParamsHead:AddTree('Vec3d')
            local treeTestParams6 = testParamsHead:AddTree('Vecd')
    

            function TestAllHeadScalarParameters()
                for _,v in ipairs(Parameters.Head.Scalar) do
                    local testSlider = treeTestParams4:AddSlider(v, 0, -100, 100)
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        for _, part in ipairs({'Head'}) do
                            ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
                        end
                    end
                end
            end
    
            function TestAllHeadVec3Parameters()
                for _,v in ipairs(Parameters.Head.Vector3) do
                    local testPicker = treeTestParams5:AddColorEdit(v)
                    testPicker.NoAlpha = true
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        for _, part in ipairs({'Head'}) do
                            ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
                        end
                    end
                end
            end
    
            function TestAllHeadVecParameter()
                for _,v in ipairs(Parameters.Head.Vector) do
                    local testSlider2 = treeTestParams6:AddSlider(v)
                    testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider2.OnChange = function()
                        for _, part in ipairs({'Head'}) do
                            ApplyParameters(_C(), part, v, 'Vector_1', testSlider2.Value[1])
                        end
                    end
                end
            end


            TestAllHeadScalarParameters()
            TestAllHeadVec3Parameters()
            TestAllHeadVecParameter()

        end

        function Tests:Genital()

            local testParamsGenital = testParams:AddTree('Genitald')
            local treeTestParamsGenital_5821 = testParamsGenital:AddTree('Scalar')
            local treeTestParamsGenital_1293 = testParamsGenital:AddTree('Vec3')
            local treeTestParamsGenital_7640 = testParamsGenital:AddTree('Vec')
            
            if Parameters['Private Parts'] then 
            function TestAllGenitalScalarParameters()
                for _,v in ipairs(Parameters['Private Parts'].Scalar) do
                    local testSlider = treeTestParamsGenital_5821:AddSlider(v, 0, -100, 100)
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        for _, part in ipairs({'Private Parts'}) do
                            ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
                        end
                    end
                end
            end
        
            function TestAllGenitalVec3Parameters()
                for _,v in ipairs(Parameters['Private Parts'].Vector3)do
                    local testPicker = treeTestParamsGenital_1293:AddColorEdit(v .. Ext.Math.Random(1, 10000))
                    testPicker.NoAlpha = true
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        for _, part in ipairs({'Private Parts'}) do
                            ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
                        end
                    end
                end
            end
        
            function TestAllGenitalVecParameter()
                for _,v in ipairs(Parameters['Private Parts'].Vector) do
                    local testSlider2 = treeTestParamsGenital_7640:AddSlider(v)
                    testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider2.OnChange = function()
                        for _, part in ipairs({'Private Parts'}) do
                            ApplyParameters(_C(), part, v, 'Vector_1', testSlider2.Value[1])
                        end
                    end
                end
            end
        
            TestAllGenitalScalarParameters()
            TestAllGenitalVec3Parameters()
            TestAllGenitalVecParameter()
        end
        end

        function Tests:Tail()
            local testParamsTail = testParams:AddTree('Taild')
            local treeTestParamsTail_8732 = testParamsTail:AddTree('Scalar')
            local treeTestParamsTail_3281 = testParamsTail:AddTree('Vec3')
            local treeTestParamsTail_9017 = testParamsTail:AddTree('Vec')
        
            if Parameters.Tail then

            function TestAllTailScalarParameters()
                for _,v in ipairs(Parameters.Tail.Scalar) do
                    local testSlider = treeTestParamsTail_8732:AddSlider(v, 0, -100, 100)
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        for _, part in ipairs({'Tail'}) do
                            ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
                        end
                    end
                end
            end
        
            function TestAllTailVec3Parameters()
                for _,v in ipairs(Parameters.Tail.Vector3) do
                    local testPicker = treeTestParamsTail_3281:AddColorEdit(v)
                    testPicker.NoAlpha = true
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        for _, part in ipairs({'Tail'}) do
                            ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
                        end
                    end
                end
            end
        
            function TestAllTailVecParameter()
                for _,v in ipairs(Parameters.Tail.Vector) do
                    local testSlider2 = treeTestParamsTail_9017:AddSlider(v)
                    testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider2.OnChange = function()
                        for _, part in ipairs({'Tail'}) do
                            ApplyParameters(_C(), part, v, 'Vector_1', testSlider2.Value[1])
                        end
                    end
                end
            end
        
            TestAllTailScalarParameters()
            TestAllTailVec3Parameters()
            TestAllTailVecParameter()
            end
        end

        function Tests:Horns()

            local testParamsHorns = testParams:AddTree('Hornsd')
            local treeTestParamsHorns_4472 = testParamsHorns:AddTree('Scalar')
            local treeTestParamsHorns_9823 = testParamsHorns:AddTree('Vec3')
            local treeTestParamsHorns_3106 = testParamsHorns:AddTree('Vec')
            
            if Parameters.Horns then

            function TestAllHornsScalarParameters()
                for _,v in ipairs(Parameters.Horns.Scalar) do
                    local testSlider = treeTestParamsHorns_4472:AddSlider(v, 0, -100, 100)
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        for _, part in ipairs({'Horns'}) do
                            ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
                        end
                    end
                end
            end
        
            function TestAllHornsVec3Parameters()
                for _,v in ipairs(Parameters.Horns.Vector3) do
                    local testPicker = treeTestParamsHorns_9823:AddColorEdit(v)
                    testPicker.NoAlpha = true
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        for _, part in ipairs({'Horns'}) do
                            ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
                        end
                    end
                end
            end
        
            function TestAllHornsVecParameter()
                for _,v in ipairs(Parameters.Horns.Vector) do
                    local testSlider2 = treeTestParamsHorns_3106:AddSlider(v)
                    testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider2.OnChange = function()
                        for _, part in ipairs({'Horns'}) do
                            ApplyParameters(_C(), part, v, 'Vector_1', testSlider2.Value[1])
                        end
                    end
                end
            end
        
            TestAllHornsScalarParameters()
            TestAllHornsVec3Parameters()
            TestAllHornsVecParameter()
            end
        end

        function Tests:Nails()

            local testParamsNails = testParams:AddTree('Nailsd')
            local treeTestParamsNails_4472 = testParamsNails:AddTree('Scalar')
            local treeTestParamsNails_9823 = testParamsNails:AddTree('Vec3')
            local treeTestParamsNails_3106 = testParamsNails:AddTree('Vec')
            
            if Parameters.DragonbornTop then

            function TestAllNailsScalarParameters()
                for _,v in ipairs(Parameters.DragonbornTop.Scalar) do
                    local testSlider = treeTestParamsNails_4472:AddSlider(v, 0, -100, 100)
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        for _, part in ipairs({'DragonbornTop'}) do
                            ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
                        end
                    end
                end
            end
        
            function TestAllNailsVec3Parameters()
                for _,v in ipairs(Parameters.DragonbornTop.Vector3) do
                    local testPicker = treeTestParamsNails_9823:AddColorEdit(v)
                    testPicker.NoAlpha = true
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        for _, part in ipairs({'DragonbornTop'}) do
                            ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
                        end
                    end
                end
            end
        
            function TestAllNailsVecParameter()
                for _,v in ipairs(Parameters.DragonbornTop.Vector) do
                    local testSlider2 = treeTestParamsNails_3106:AddSlider(v)
                    testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider2.OnChange = function()
                        for _, part in ipairs({'DragonbornTop'}) do
                            ApplyParameters(_C(), part, v, 'Vector_1', testSlider2.Value[1])
                        end
                    end
                end
            end
        
            TestAllNailsScalarParameters()
            TestAllNailsVec3Parameters()
            TestAllNailsVecParameter()

            end
        end

        Tests:Body()
        Tests:Head()  
        Tests:Genital()
        Tests:Tail()
        Tests:Horns()
        Tests:Nails()



    end





---temp abomination 
function Elements:UpdateElements(uuid)
    

    if lastParameters[uuid] then
        
        local character = lastParameters[uuid]
        -- DPrint(uuid)


        -- self['pickMelaninColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3", "MelaninColor")
        -- self['slMelaninAmount'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "MelaninAmount")
        -- self['slMelaninRemoval'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "MelaninRemovalAmount")
        -- self['slMelaninDarkM'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "MelaninDarkMultiplier")
        -- self['slMelaninDarkT'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "MelaninDarkThreshold")
    
        -- self['pickHemoglobinColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3", "HemoglobinColor")
        -- self['slHemoglobinAmount'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "HemoglobinAmount")
        -- self['pickYellowingColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3", "YellowingColor")
        -- self['slYellowingAmount'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "YellowingAmount")
        -- self['pickVeinColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3", "VeinColor")
        -- self['slVeinAmount'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "VeinAmount")
    
        self['slIntMakeupIndex'].Value = SLOP:getValue(character, "Head", "Scalar", "MakeUpIndex")
        self['pickMakeupColor'].Color = SLOP:getValue(character, "Head", "Vector3", "MakeupColor")
        self['slMakeupInt'].Value = SLOP:getValue(character, "Head", "Scalar", "MakeupIntensity")
        self['slMakeupMet'].Value = SLOP:getValue(character, "Head", "Scalar", "LipsMakeupMetalness")
        self['slMakeupRough'].Value = SLOP:getValue(character, "Head", "Scalar", "MakeupRoughness")
    
        self['pickLipsColor'].Color = SLOP:getValue(character, "Head", "Vector3", "Lips_Makeup_Color")
        self['slLipsInt'].Value = SLOP:getValue(character, "Head", "Scalar", "LipsMakeupIntensity")
        self['slLipsMet'].Value = SLOP:getValue(character, "Head", "Scalar", "LipsMakeupMetalness")
        self['slLipsRough'].Value = SLOP:getValue(character, "Head", "Scalar", "LipsMakeupRoughness")
    
        self['slIntTattooIndex'].Value = SLOP:getValue(character, "Head", "Scalar", "TattooIndex")
        self['pickTattooColorR'].Color = SLOP:getValue(character, "Head", "Vector3", "TattooColor")
        self['pickTattooColorG'].Color = SLOP:getValue(character, "Head", "Vector3", "TattooColorG")
        self['pickTattooColorB'].Color = SLOP:getValue(character, "Head", "Vector3", "TattooColorB")
    
        local tattooIntensity =
        (SLOP:getValue(character, "Head", "Vector_1", "TattooIntensity")[1] ~= 0 and SLOP:getValue(character, "Head", "Vector_1", "TattooIntensity")[1]) or
        (SLOP:getValue(character, "Head", "Vector_2", "TattooIntensity")[1] ~= 0 and SLOP:getValue(character, "Head", "Vector_2", "TattooIntensity")[1]) or
        SLOP:getValue(character, "Head", "Vector_3", "TattooIntensity")[1] or 0
    
        self['pickTattooIntR'].Value = {tattooIntensity, 0, 0, 0}
        self['pickTattooIntG'].Value = {tattooIntensity, 0, 0, 0}
        self['pickTattooIntB'].Value = {tattooIntensity, 0, 0, 0}
        
        self['slTattooMet'].Value = SLOP:getValue(character, "Head", "Scalar", "TattooMetalness")
        self['slTattooRough'].Value = SLOP:getValue(character, "Head", "Scalar", "TattooRoughnessOffset")
        self['slTattooCurve'].Value = SLOP:getValue(character, "Head", "Scalar", "TattooCurvatureInfluence")
    
        self['slAgeInt'].Value = SLOP:getValue(character, "Head", "Scalar", "Age_Weight")
        self['slIntScarIndex'].Value = SLOP:getValue(character, "Head", "Scalar", "ScarIndex")
    
        self['slEyesHet'].Value = SLOP:getValue(character, "Head", "Scalar", "Heterochromia")
        self['slEyesBR'].Value = SLOP:getValue(character, "Head", "Scalar", "Blindness")
        self['slEyesBL'].Value = SLOP:getValue(character, "Head", "Scalar", "Blindness_L")
        self['pickEyesC'].Color = SLOP:getValue(character, "Head", "Vector3", "Eyes_IrisColour")
        self['pickEyesCL'].Color = SLOP:getValue(character, "Head", "Vector3", "Eyes_IrisColour_L")
        self['pickEyesC2'].Color = SLOP:getValue(character, "Head", "Vector3", "Eyes_IrisSecondaryColour")
        self['pickEyesC2L'].Color = SLOP:getValue(character, "Head", "Vector3", "Eyes_IrisSecondaryColour_L")
        self['pickEyesSC'].Color = SLOP:getValue(character, "Head", "Vector3", "Eyes_ScleraColour")
        self['pickEyesSCL'].Color = SLOP:getValue(character, "Head", "Vector3", "Eyes_ScleraColour_L")
        self['slEyesCI'].Value = SLOP:getValue(character, "Head", "Scalar", "SecondaryColourIntensity")
        self['slEyesCIL'].Value = SLOP:getValue(character, "Head", "Scalar", "SecondaryColourIntensity_L")
        self['slEyesEdge'].Value = SLOP:getValue(character, "Head", "Scalar", "IrisEdgeStrength")
        self['slEyesEdgeL'].Value = SLOP:getValue(character, "Head", "Scalar", "IrisEdgeStrength_L")
        self['slEyesRed'].Value = SLOP:getValue(character, "Head", "Scalar", "Redness")
        self['slEyesRedL'].Value = SLOP:getValue(character, "Head", "Scalar", "Redness_L")
    
        self['slBTatI'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "BodyTattooIndex")
        self['pickBTatCR'].Color = SLOP:getValue(character, "NakedBody", "Vector3", "BodyTattooColor")
        self['pickBTatCG'].Color = SLOP:getValue(character, "NakedBody", "Vector3", "BodyTattooColorG")
        self['pickBTatCB'].Color = SLOP:getValue(character, "NakedBody", "Vector3", "BodyTattooColorB")

        local bodyTattooIntensity =
        (SLOP:getValue(character, "NakedBody", "Vector_1", "BodyTattooIntensity")[1] ~= 0 and SLOP:getValue(character, "NakedBody", "Vector_1", "BodyTattooIntensity")[1]) or
        (SLOP:getValue(character, "NakedBody", "Vector_2", "BodyTattooIntensity")[1] ~= 0 and SLOP:getValue(character, "NakedBody", "Vector_2", "BodyTattooIntensity")[1]) or
        SLOP:getValue(character, "NakedBody", "Vector_3", "BodyTattooIntensity")[1] or 0
    
        self['slBTatIntR'].Value = {bodyTattooIntensity, 0, 0, 0}
        self['slBTatIntG'].Value = {bodyTattooIntensity, 0, 0, 0}
        self['slBTatIntB'].Value = {bodyTattooIntensity, 0, 0, 0}
        

        self['slBTatMet'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "TattooMetalness")
        self['slBTatR'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "TattooRoughnessOffset")
        self['slBTatCurve'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "TattooCurvatureInfluence")
    
        self['slScalpMinValue'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_MinValue")
        self['slHornMaskWeight'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_HornMaskWeight")
        self['slGrayingIntensity'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_Graying_Intensity")
        self['slColorTransitionMid'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_ColorTransitionMidPoint")
        self['slColorTransitionSoft'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_ColorTransitionSoftness")
        self['slDepthColorExponent'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_DepthColorExponent")
        self['slDepthColorIntensity'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_DepthColorIntensity")
        self['slIDContrast'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_IDContrast")
        self['slColorDepthContrast'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_ColorDepthContrast")
        self['slScalpRoughness'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_Roughness")
        self['slRoughnessContrast'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_RoughnessContrast")
        self['slScalpScatter'].Value = SLOP:getValue(character, "Head", "Scalar", "Scalp_Scatter")
        self['pickHairScalpColor'].Color = SLOP:getValue(character, "Head", "Vector3", "Hair_Scalp_Color")
        self['pickGrayingColor'].Color = SLOP:getValue(character, "Head", "Vector3", "Hair_Scalp_Graying_Color")
        self['pickHueShiftWeight'].Color = SLOP:getValue(character, "Head", "Vector3", "Hair_Scalp_HueShift_Weight")

        self['pickHairColor'].Color = SLOP:getValue(character, "Hair", "Vector3", "Hair_Color")
        self['slSharedNoiseTiling'].Value = SLOP:getValue(character, "Hair", "Scalar", "SharedNoiseTiling")
        self['slHairFrizz'].Value = SLOP:getValue(character, "Hair", "Scalar", "HairFrizz")
        self['slHairSoupleness'].Value = SLOP:getValue(character, "Hair", "Scalar", "HairSoupleness")
        self['slMaxWindMovement'].Value = SLOP:getValue(character, "Hair", "Scalar", "MaxWindMovementAmount")
        self['slSoftenTipsAlpha'].Value = SLOP:getValue(character, "Hair", "Scalar", "SoftenTipsAlpha")
        self['slBaseColorVar'].Value = SLOP:getValue(character, "Hair", "Scalar", "BaseColorVar")
        self['slRootTransitionMid'].Value = SLOP:getValue(character, "Hair", "Scalar", "RootTransitionMidPoint")
        self['slRootTransitionSoft'].Value = SLOP:getValue(character, "Hair", "Scalar", "RootTransitionSoftness")
        self['slDepthColorExponent'].Value = SLOP:getValue(character, "Hair", "Scalar", "DepthColorExponent")
        self['slDepthColorIntensity'].Value = SLOP:getValue(character, "Hair", "Scalar", "DepthColorIntensity")
        self['slColorDepthContrast'].Value = SLOP:getValue(character, "Hair", "Scalar", "ColorDepthContrast")
        self['slDreadNoiseBaseColor'].Value = SLOP:getValue(character, "Hair", "Scalar", "DreadNoiseBaseColor")

        self['pickHairGrayingColor'].Color = SLOP:getValue(character, "Hair", "Vector3", "Hair_Graying_Color")
        self['slGrayingIntensity'].Value = SLOP:getValue(character, "Hair", "Scalar", "Graying_Intensity")
        self['slGrayingSeed'].Value = SLOP:getValue(character, "Hair", "Scalar", "Graying_Seed")

        self['pickHighlightColor'].Color = SLOP:getValue(character, "Hair", "Vector3", "Highlight_Color")
        self['slHighlightFalloff'].Value = SLOP:getValue(character, "Hair", "Scalar", "Highlight_Falloff")
        self['slHighlightIntensity'].Value = SLOP:getValue(character, "Hair", "Scalar", "Highlight_Intensity")

        self['pickHornsColor'].Color = SLOP:getValue(character, "Horns", "Vector3", "NonSkinColor")
        self['pickHornsTipColor'].Color = SLOP:getValue(character, "Horns", "Vector3", "NonSkinTipColor")
        self['slHornReflectance'].Value = SLOP:getValue(character, "Horns", "Scalar", "Reflectance")
        self['slHornIntensity'].Value = SLOP:getValue(character, "Horns", "Scalar", "Intensity")
        self['slHornGlow'].Value = SLOP:getValue(character, "Horns", "Scalar", "Use_BlackBody")
        -- self['slHornColour_BlackBody'].Value = SLOP:getValue(character, "Horns", "Scalar", "Colour_BlackBody")
        -- self['slHornUse_ColorRamp'].Value = SLOP:getValue(character, "Horns", "Scalar", "Use_ColorRamp")
        self['slHornBlackBody_Colour'].Color = SLOP:getValue(character, "Horns", "Vector3", "BlackBody_Colour")
        self['slHornLength'].Value = SLOP:getValue(character, "Horns", "Scalar", "Length")
        self['slHornamplitude'].Value = SLOP:getValue(character, "Horns", "Scalar", "amplitude")
        self['slHornBPM'].Value = SLOP:getValue(character, "Horns", "Scalar", "BPM")
        -- self['slHornamp2'].Value = SLOP:getValue(character, "Horns", "Scalar", "amp2")
        self['slHornUse_HeartBeat'].Value = SLOP:getValue(character, "Horns", "Scalar", "Use_HeartBeat")
        self['slHornBlackbody_PreRamp_Power'].Value = SLOP:getValue(character, "Horns", "Scalar", "Blackbody_PreRamp_Power")
        self['slHornEmissive_Mult'].Value = SLOP:getValue(character, "Horns", "Scalar", "Emissive_Mult")
        -- self['slHornContrast'].Value = SLOP:getValue(character, "Horns", "Scalar", "Contrast")
        -- self['slHornPreRampIntensity'].Value = SLOP:getValue(character, "Horns", "Scalar", "PreRampIntensity")
        -- self['slHornPostRampIntensity'].Value = SLOP:getValue(character, "Horns", "Scalar", "PostRampIntensity")


        pcikEyeLC.Color = SLOP:getValue(character, "Head", "Vector3", "Eyelashes_Color")
        pickEyeBC.Color = SLOP:getValue(character, "Head", "Vector3", "Eyebrow_Color")

        self['pickNonSkinColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3", "NonSkinColor")
        self['slNonSkinWeight'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "NonSkin_Weight")
        self['slNonSkinMetalness'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "NonSkinMetalness")
        self['slFreckles'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "Freckles")
        self['slFrecklesWeight'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "FrecklesWeight")
        self['slVitiligo'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "Vitiligo")
        self['slVitiligoWeight'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "VitiligoWeight")
        self['slSweat'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "Sweat")
        self['slBlood'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "Blood")

        self['slIntScaleIndex'].Value = SLOP:getValue(character, "Head", "Scalar", "CustomIndex")
        self['pickScaleColor'].Color = SLOP:getValue(character, "Head", "Vector3", "CustomColor")
        self['slScaleInt'].Value = SLOP:getValue(character, "Head", "Scalar", "CustomIntensity")

        self['slScarWeight'].Value = SLOP:getValue(character, "Head", "Scalar", "Scar_Weight")

        self['slIntBeardIndex'].Value = SLOP:getValue(character, "Head", "Scalar", "BeardIndex")
        self['pickBeardScalpColor'].Color = SLOP:getValue(character, "Hair", "Vector3", "Beard_Scalp_Color")
        self['pickBeardColor'].Color = SLOP:getValue(character, "Hair", "Vector3", "Beard_Color")
        self['pickBeardGrayingColor'].Color = SLOP:getValue(character, "Hair", "Vector3", "Beard_Graying_Color")
        self['pickBeardHighlightColor'].Color = SLOP:getValue(character, "Hair", "Vector3", "Beard_Highlight_Color")
        self['slBeardMinValue'].Value = SLOP:getValue(character, "Head", "Scalar", "BeardMinValue")
        self['slBeardInt'].Value = SLOP:getValue(character, "Head", "Scalar", "BeardIntesity")
        self['slBeardDesat'].Value = SLOP:getValue(character, "Head", "Scalar", "BeardDesaturation")
        self['slBeardDarken'].Value = SLOP:getValue(character, "Head", "Scalar", "BeardDarken")
        self['slBeardGrayingInt'].Value = SLOP:getValue(character, "Head", "Scalar", "Beard_Graying_Intensity")

        self['pickHeadGlowColor'].Color = SLOP:getValue(character, "Head", "Vector3", "GlowColor")
        self['slHeadGlowMult'].Value = SLOP:getValue(character, "Head", "Scalar", "GlowMultiplier")
        self['slHeadAnimdSpeed'].Value = SLOP:getValue(character, "Head", "Scalar", "AnimationSpeed")

        self['pickBodyGlowColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3", "GlowColor")
        self['slBodyGlowMult'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "GlowMultiplier")
        self['slBodyAnimdSpeed'].Value = SLOP:getValue(character, "NakedBody", "Scalar", "AnimationSpeed")

        self['slEyesGlowBright'].Value = SLOP:getValue(character, "Head", "Scalar", "GlowBrightness")
        self['slEyesGlowBrightL'].Value = SLOP:getValue(character, "Head", "Scalar", "GlowBrightness_L")
        self['slEyesGlowBrightPup'].Value = SLOP:getValue(character, "Head", "Scalar", "GlowBrightnessPupil")
        self['slEyesFxMasking'].Value = SLOP:getValue(character, "Head", "Scalar", "FxMasking")
        self['slEyesFxMaskingL'].Value = SLOP:getValue(character, "Head", "Scalar", "FxMasking_L")
        self['slEyesGlowColor'].Color = SLOP:getValue(character, "Head", "Vector3", "Eyes_GlowColour")
        self['slEyesGlowColorL'].Color = SLOP:getValue(character, "Head", "Vector3", "Eyes_GlowColour_L")

        self['pickBodyHairC'].Color = SLOP:getValue(character, "Body", "Vector3", "Body_Hair_Color")

        self['slIntPPOpac'].Value = SLOP:getValue(character, "Private parts", "Scalar", "InvertOpacity")

    else

        for _, v in pairs(self) do
            if pcall(function() return v.Color end) then
                v.Color = {0,0,0,0}
            elseif pcall(function() return v.Value end) then
                v.Value = {0,0,0,0}
            end
        end
    end
end

    


end

UI:Init()

           
            -- {'picker', pickBeardColor, 'Beard Color', parent, {}, function(var)
            --     CallFunction('Vector3', 'Beard_Color', var) end},


             -- {nil, slPixelDepthOffsetRoot, 'Pixel Depth Offset Root', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'PixelDepthOffsetRoot', var) end},
        
            -- {nil, slPixelDepthOffset, 'Pixel Depth Offset', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'PixelDepthOffset', var) end},
        
            -- {nil, slDepthTransitionMidPoint, 'Depth Transition Mid', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DepthTransitionMidPoint', var) end},
        
            -- {nil, slDepthTransitionSoftness, 'Depth Transition Soft', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DepthTransitionSoftness', var) end},

            -- {nil, slBeardAlpha, 'Beard Alpha', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DontTouchMe_Beard_Alpha', var) end},


            -- {nil, slIsBeard, 'Is Beard', parent, {min = -10, max = 10}, function(var)
        --     CallFunction('Scalar', 'DontTouchMe_isBeard', var) end},
    
            -- {nil, slBeardGrayingIntensity, 'Beard Graying Intensity', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'Beard_Graying_Intensity', var) end},

            -- {nil, slIDContrast, 'ID Contrast', parent, {min = -10, max = 10}, function(var)
        --     CallFunction('Scalar', 'IDContrast', var) end},

            -- {nil, slDirtWetness, 'Dirt Wetness', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'Dirt_Wetness', var) end},
        
            -- {nil, slBlood, 'Blood', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'Blood', var) end},
        
            -- {nil, slDirt, 'Dirt', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'Dirt', var) end},

        
            -- {'picker', pickBeardGrayingColor, 'Beard Graying Color', parent, {}, function(var)
        --     CallFunction('Vector3', 'Beard_Graying_Color', var) end},
            

                
            -- {'picker', pickBeardHighlightColor, 'Beard Highlight Color', parent, {}, function(var)
            --     CallFunction('Vector3', 'Beard_Highlight_Color', var) end},
                
            -- {'picker', pickHueShiftWeight, 'Hue Shift Weight', parent, {}, function(var)
            --     CallFunction('Vector3', 'HueShiftColorWeight', var) end},
                
            -- {'picker', pickDirtColor, 'Dirt Color', parent, {}, function(var)
            --     CallFunction('Vector3', 'DirtColor', var) end},
                
            -- {'picker', pickBloodColor, 'Blood Color', parent, {}, function(var)
            --     CallFunction('Vector3', 'Blood_Color', var) end}
