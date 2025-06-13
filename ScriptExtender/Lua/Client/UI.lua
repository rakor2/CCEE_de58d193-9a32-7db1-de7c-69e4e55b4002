
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
    GetAllParameterNames(_C())
end


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

    p = cceeWindow

    MCM.SetKeybindingCallback('ccee_toggle_window', function()
        cceeWindow.Open = not cceeWindow.Open
    end)


    -- MCM.SetKeybindingCallback('ccee_apply_pm_parameters', function()
    --     Helpers.Timer:OnTicks(2, function ()
    --         ApplyParametersToDummies()
    --     end)

    -- end)


    firstManToUseProgressBar = p:AddProgressBar()
    firstManToUseProgressBar.Visible = false

    firstManToUseProgressBarLable = p:AddText('Calculating quats')
    firstManToUseProgressBarLable.SameLine = true
    firstManToUseProgressBarLable.Visible = false

    function CCEE:CoolThings()

        local mainCollapse = p:AddCollapsingHeader('xd')
        -- local p = mainCollapse

        local STOPPPPP = mainCollapse:AddButton('Idle')
        STOPPPPP.OnClick = function()
            Ext.Net.PostMessageToServer('stop', '')
        end

        -- local iSwitchCharacter = mainCollapse:AddButton('I switched character')
        -- iSwitchCharacter.SameLine = true
        -- iSwitchCharacter.OnClick = function ()
        --     Elements:UpdateElements(_C().Uuid.EntityUuid)
        -- end

        local sepa = mainCollapse:AddSeparatorText('Savings loadings')

        local saveParams = mainCollapse:AddButton('Save')
        saveParams.OnClick = function ()
            SaveParamsToFile()
        end

        local tp3 = saveParams:Tooltip()
        tp3:AddText([[
        Saves all edited parameters for every character in the scene in local file
        AppData\Local\Larian Studios\Baldur's Gate 3\Script Extender\CCEE]])


        local loadParams = mainCollapse:AddButton('Load')
        loadParams.SameLine = true
        loadParams.OnClick = function ()
            LoadParamsFromFile()
        end

        local sepa = mainCollapse:AddSeparatorText('DO NOT missclick')


        local resetCharacter = mainCollapse:AddButton('Reset selected character')
        local tp = resetCharacter:Tooltip()
        tp:AddText([[
        Tats/Makes/Eyes don't visually reset, you need to save and load the game]])


        local resetTableBtn = mainCollapse:AddButton('Reset save data')
        resetTableBtn.SameLine = true
        resetTableBtn.OnClick = function ()

            lastParameters = {}
            lastParametersMV = {}
            dummies = {}
            -- Parameters = {}
            Helpers.ModVars:Get(ModuleUUID).CCEE = {}

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

        -- local resetSliders = mainCollapse:AddButton('Reset sliders and pickers')
        -- resetSliders.OnClick = function ()

            
        -- end

        local tp2 = resetTableBtn:Tooltip()
        tp2:AddText([[
        The mod stores data in game save file, this button resets the data]])

        resetCharacter.OnClick = function ()
            Ext.Net.PostMessageToServer('ResetCurrentCharacter', '')
            if _C().Uuid then
                local uuid = _C().Uuid.EntityUuid
                lastParameters[uuid] = nil
                lastParametersMV[uuid] = nil
                Ext.Net.PostMessageToServer('SendModVars', Ext.Json.Stringify(lastParameters))
            end
        end


        local sepa = mainCollapse:AddSeparatorText('Dev thingies')

        local dumpVars = mainCollapse:AddButton('Dump vars')
        dumpVars.OnClick = function ()
            Ext.Net.PostMessageToServer('dumpVars', '')
        end


        local forceLoad = mainCollapse:AddButton('Force load')
        forceLoad.SameLine = true
        forceLoad.OnClick = function ()
            Ext.Net.PostMessageToServer('UpdateParameters', '')
        end

        local tp3 = forceLoad:Tooltip()
        tp3:AddText([[
        Loads stored data from the save file for every character in scene
        Useful if visually parameters got reset]])



        local testsCheck = mainCollapse:AddCheckbox('All parameters (they do not save)')
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

            
        local sepa = p:AddSeparatorText('Main tabs')

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




    local parent
    ---ahh table
    local ahhTable = {

    
        ['Melanin'] = {

            {'picker', 'pickMelaninColor', 'Color', parent, {}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'MelaninColor', 'Vector3', var.Color)
                end end},
                
            {nil, 'slMelaninAmount', 'Amount', parent, {}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'MelaninAmount', 'Scalar', var.Value[1])
                end end},

            {nil, 'slMelaninRemoval', 'Removal amount', parent, {max = 100, log = true}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'MelaninRemovalAmount', 'Scalar', var.Value[1])
                end end},

            {nil, 'slMelaninDarkM', 'Dark multiplier', parent, {max = 100, log = true}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'MelaninDarkMultiplier', 'Scalar', var.Value[1])
                end end},

            {nil, 'slMelaninDarkT', 'Dark threshold', parent, {max = 1}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'MelaninDarkThreshold', 'Scalar', var.Value[1])
                end end},
        },

        ['Hemoglobin'] = {

            {'picker', 'pickHemoglobinColor', 'Color', parent, {}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'HemoglobinColor', 'Vector3', var.Color)
                end end},

            {nil, 'slHemoglobinAmount', 'Amount', parent, {max = 3}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'HemoglobinAmount', 'Scalar', var.Value[1])
                end end},
        },

        ['Yellowing'] = {
            {'picker', 'pickYellowingColor', 'Color', parent, {}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'YellowingColor', 'Vector3', var.Color)
                end end},
                
            {nil, 'slYellowingAmount', 'Amount', parent, {min = -300, max = 300, log = true}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'YellowingAmount', 'Scalar', var.Value[1])
                end end},
        },
        
        ['Vein'] = {
            {'picker', 'pickVeinColor', 'Color', parent, {}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'VeinColor', 'Vector3', var.Color)
                end end},

            {nil, 'slVeinAmount', 'Amount', parent, {max = 7}, function(var)
                for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
                    SaveAndApply(_C(), attachment, 'VeinAmount', 'Scalar', var.Value[1])
                end end},
        },

        ['Eyes makeup'] = {
            {'int', 'slIntMakeupIndex', 'Index', parent, {max = makeupCount}, function(var)
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
        
        ['Lips makeup'] = {
            {'picker', 'pickLipsColor', 'Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'Lips_Makeup_Color', 'Vector3', var.Color) end},
        
            {nil, 'slLipsInt', 'Intensity', parent, {max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'LipsMakeupIntensity', 'Scalar', var.Value[1]) end},
        
            {nil, 'slLipsMet', 'Metalness', parent, {max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'LipsMakeupMetalness', 'Scalar', var.Value[1]) end},
        
            {nil, 'slLipsRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'LipsMakeupRoughness', 'Scalar', var.Value[1]) end},
        },

        ['Tattoo'] = {

            {'int', 'slIntTattooIndex', 'Index', parent, {max = tattooCount}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooIndex', 'Scalar', var.Value[1]) end},
        
            {'picker', 'pickTattooColorR', 'Color R', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooColor', 'Vector3', var.Color) end},
        
            {'picker', 'pickTattooColorG', 'Color G', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooColorG', 'Vector3', var.Color) end},
        
            {'picker', 'pickTattooColorB', 'Color B', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooColorB', 'Vector3', var.Color) end},
        
            {nil, 'pickTattooIntR', 'Intensity R', parent, {min = -5, max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooIntensity', 'Vector_1', var.Value[1]) end},
        
            {nil, 'pickTattooIntG', 'Intensity G', parent, {min = -5, max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooIntensity', 'Vector_2', var.Value[1]) end},
        
            {nil, 'pickTattooIntB', 'Intensity B', parent, {min = -5, max = 5}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooIntensity', 'Vector_3', var.Value[1]) end},
        
            {nil, 'slTattooMet', 'Metalness', parent, {min = 0, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooMetalness', 'Scalar', var.Value[1]) end},
        
            {nil, 'slTattooRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooRoughnessOffset', 'Scalar', var.Value[1]) end},
        
            {nil, 'slTattooCurve', 'Curvature influence', parent, {min = 0, max = 100}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooCurvatureInfluence', 'Scalar', var.Value[1]) end},
        },
        
        ['Age'] = {
        
            {nil, 'slAgeInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Age_Weight', 'Scalar', var.Value[1]) end},
        },
        
        ['Scars'] = {
        
            {'int', 'slIntScarIndex', 'Index', parent, {max = scarCount}, function(var)
                SaveAndApply(_C(), 'Head', 'ScarIndex', 'Scalar', var.Value[1]) end},
        
            {nil, 'slIntScarIndex', 'Intensity', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'Scar_Weight', 'Scalar', var.Value[1]) end},
        },
        
        ['Scales'] = {
        
            {'int', 'slIntScaleIndex', 'Index', parent, {max = 31}, function(var)
                SaveAndApply(_C(), 'Head', 'CustomIndex', 'Scalar', var) end},
        
            {'picker', 'pickScaleColor', 'Color', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'CustomColor', 'Vector3', var) end},
        
            {nil, 'pickScaleInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
                SaveAndApply(_C(), 'Head', 'CustomIntensity', 'Scalar', var.Value[1]) end},
        },

        
        ['Eyes'] = {
            {'int', 'slEyesHet', 'Heterochromia', parent, {max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'Heterochromia', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slEyesBR', 'Blindness R', parent, {max = 3}, function(var)
                SaveAndApply(_C(), 'Head', 'Blindness', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slEyesBL', 'Blindness L', parent, {max = 3}, function(var)
                SaveAndApply(_C(), 'Head', 'Blindness_L', 'Scalar', var.Value[1])
            end},
            
            {'picker', 'pickEyesC', 'Iris color 1', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_IrisColour', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesCL', 'Iris color 1 L', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_IrisColour_L', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesC2', 'Iris color 2', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_IrisSecondaryColour', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesC2L', 'Iris color 2 L', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_IrisSecondaryColour_L', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesSC', 'Sclera color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_ScleraColour', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickEyesSCL', 'Sclera color L', parent, {float = true, noAlpha = true}, function(var)
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

        ['Body tattoos'] = {
            {'int', 'slBTatI', 'Index', parent, {max = tattooCount}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'BodyTattooIndex', 'Scalar', var.Value[1])
            end},
            
            {'picker', 'pickBTatCR', 'Color R', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'BodyTattooColor', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickBTatCG', 'Color G', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'BodyTattooColorG', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickBTatCB', 'Color B', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'BodyTattooColorB', 'Vector3', var.Color)
            end},
            
            {nil, 'slBTatIntR', 'Intensity R', parent, {min = -5, max = 5}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'BodyTattooIntensity', 'Vector_1', var.Value[1])
            end},
            
            {nil, 'slBTatIntG', 'Intensity G', parent, {min = -5, max = 5}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'BodyTattooIntensity', 'Vector_2', var.Value[1])
            end},
            
            {nil, 'slBTatIntB', 'Intensity B', parent, {min = -5, max = 5}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'BodyTattooIntensity', 'Vector_3', var.Value[1])
            end},
            
            {nil, 'slBTatMet', 'Metalness', parent, {max = 1}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'TattooMetalness', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slBTatR', 'Roughness', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'TattooRoughnessOffset', 'Scalar', var.Value[1])
            end},
              
            {nil, 'slBTatCurve', 'Curvature influence', parent, {max = 100}, function(var)
                SaveAndApply(_C(), 'NakedBody', 'TattooCurvatureInfluence', 'Scalar', var.Value[1])
            end}
        },



        ['Scalp'] = {
            {nil, 'slScalpMinValue', 'Scalp Min Value', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_MinValue', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slHornMaskWeight', 'Horn Mask Weight', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'HaHeadir', 'Scalp_HornMaskWeight', 'Scalar', var.Value[1])
            end},
            
            {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_Graying_Intensity', 'Scalar', var.Value[1])
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
            
            {'picker', 'pickHairScalpColor', 'Hair Scalp Color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Hair_Scalp_Color', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickGrayingColor', 'Graying Color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Hair_Scalp_Graying_Color', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickHueShiftWeight', 'Hue Shift Weight', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Scalp_HueShiftColorWeight', 'Vector3', var.Color)
            end},
            
            {'picker', 'pickBeardScalpColor', 'Beard Scalp Color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Beard_Scalp_Color', 'Vector3', var.Color)
            end}
        },

        ['Hair'] = {
            {'picker', 'pickHairColor', 'Hair Color', parent, {float = true, noAlpha = true}, function(var)
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
        
        ['Graying'] = {
            {'picker', 'pickHairGrayingColor', 'Hair Graying Color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Hair', 'Hair_Graying_Color', 'Vector3', var.Color)
            end},
        
            {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1.2}, function(var)
                SaveAndApply(_C(), 'Hair', 'Graying_Intensity', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slGrayingSeed', 'Graying Seed', parent, {min = -10, max = 10, log = true}, function(var)
                SaveAndApply(_C(), 'Hair', 'Graying_Seed', 'Scalar', var.Value[1])
            end}
        },
        
        ['Highlights'] = {
            {'picker', 'pickHighlightColor', 'Highlight Color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Hair', 'Highlight_Color', 'Vector3', var.Color)
            end},
        
            {nil, 'slHighlightFalloff', 'Highlight Falloff', parent, {min = -1, log = true}, function(var)
                SaveAndApply(_C(), 'Hair', 'Highlight_Falloff', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slHighlightIntensity', 'Highlight Intensity', parent, {log = true}, function(var)
                SaveAndApply(_C(), 'Hair', 'Highlight_Intensity', 'Scalar', var.Value[1])
            end}
        },


        ['Horns'] = {
            {'picker', 'pickHornsColor', 'Color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Horns', 'NonSkinColor', 'Vector3', var.Color)
            end},
        
            {'picker', 'pickHornsTipColor', 'Tip color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Horns', 'NonSkinTipColor', 'Vector3', var.Color)
            end},
        
            {nil, 'slHornReflectance', 'Reflectance', parent, {}, function(var)
                SaveAndApply(_C(), 'Horns', 'Reflectance', 'Scalar', var.Value[1])
            end},
        
            {nil, 'slHornIntensity', 'Glow? intensity', parent, {log = true}, function(var)
                SaveAndApply(_C(), 'Horns', 'Intensity', 'Scalar', var.Value[1])
            end}
        },


        ['GlowBody'] = {


            {'picker', 'pickBodyGlowColor', 'Color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Body', 'GlowColor', 'Vector3', var.Color)
            end},


            {nil, 'slBodyGlowMult', 'Multiplier', parent, {max = 5}, function(var)
                SaveAndApply(_C(), 'Body', 'GlowMultiplier', 'Scalar', var.Value[1])
            end},
        },

        ['GlowEyes'] = {

            {nil, 'slEyesGlowBright', 'Brightness', parent, {min = -200, max = 200}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowBrightness', 'Scalar', var.Value[1])
            end},


            {nil, 'slEyesGlowBrightL', 'Brightness L', parent, {min = -200, max = 200}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowBrightness_L', 'Scalar', var.Value[1])
            end},


            {nil, 'slEyesGlowBrightPup', 'Brightness pupil', parent, {min = -100, max = 100, log = true}, function(var)
                SaveAndApply(_C(), 'Head', 'GlowBrightnessPupil', 'Scalar', var.Value[1])
            end},

            
            {'picker', 'slEyesGlowColor', 'Color', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_GlowColour', 'Vector3', var.Color)
            end},

            {'picker', 'slEyesGlowColorL', 'Color L', parent, {float = true, noAlpha = true}, function(var)
                SaveAndApply(_C(), 'Head', 'Eyes_GlowColour_L', 'Vector3', var.Color)
            end},
        },

    }
        


                    
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


    function Elements:PopulateTab(tbl, collapse, treeName)
        local tree = collapse:AddTree(treeName)    
        tree.IDContext = Ext.Math.Random(1,100000)
        for _, v in ipairs(tbl) do
            v[4] = tree
            self:CreateElements(table.unpack(v))
            v[4] = parent
        end
    end


    function CCEE:Skin()
    
        local skinColorCollapse = p:AddCollapsingHeader('Skin')
        local parent =skinColorCollapse

        Elements:PopulateTab(ahhTable['Melanin'], parent, 'Melanin')

        Elements:PopulateTab(ahhTable['Hemoglobin'], parent, 'Hemoglobin')

        Elements:PopulateTab(ahhTable['Yellowing'], parent, 'Yellowing')

        Elements:PopulateTab(ahhTable['Vein'], parent, 'Vein')

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


        local sepa1333 = hairCollapse:AddSeparatorText('')

    end


    function CCEE:Glow()

        local glowCollapse = p:AddCollapsingHeader('Glow')

        local parent = glowCollapse
        
        Elements:PopulateTab(ahhTable['GlowBody'], parent, 'Body')

        Elements:PopulateTab(ahhTable['GlowEyes'], parent, 'Eyes')

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
                    local testSlider = treeTestParams:AddSliderInt(v, 0, -100, 100)
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
                    local testSlider = treeTestParams4:AddSliderInt(v, 0, -100, 100)
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
                            ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
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
                    local testSlider = treeTestParamsGenital_5821:AddSliderInt(v, 0, -100, 100)
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        for _, part in ipairs({'Private Parts'}) do
                            ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
                        end
                    end
                end
            end
        
            function TestAllGenitalVec3Parameters()
                for _,v in ipairs(Parameters['Private Parts'].Scalar)do
                    local testPicker = treeTestParamsGenital_1293:AddColorEdit(v)
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        for _, part in ipairs({'Private Parts'}) do
                            ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
                        end
                    end
                end
            end
        
            function TestAllGenitalVecParameter()
                for _,v in ipairs(Parameters['Private Parts'].Scalar) do
                    local testSlider2 = treeTestParamsGenital_7640:AddSlider(v)
                    testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider2.OnChange = function()
                        for _, part in ipairs({'Private Parts'}) do
                            ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
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
                    local testSlider = treeTestParamsTail_8732:AddSliderInt(v, 0, -100, 100)
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
                            ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
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
                    local testSlider = treeTestParamsHorns_4472:AddSliderInt(v, 0, -100, 100)
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
                            ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
                        end
                    end
                end
            end
        
            TestAllHornsScalarParameters()
            TestAllHornsVec3Parameters()
            TestAllHornsVecParameter()
            end
        end

        Tests:Body()
        Tests:Head()  
        Tests:Genital()
        Tests:Tail()
        Tests:Horns()



    end

---temp abomination 
function Elements:UpdateElements(uuid)
    

    



    if lastParameters[uuid] then
        
        local character = lastParameters[uuid]
        DPrint(uuid)

        self['pickMelaninColor'].Color = getValue(character, "NakedBody", "Vector3", "MelaninColor")
        self['slMelaninAmount'].Value = getValue(character, "NakedBody", "Scalar", "MelaninAmount")
        self['slMelaninRemoval'].Value = getValue(character, "NakedBody", "Scalar", "MelaninRemovalAmount")
        self['slMelaninDarkM'].Value = getValue(character, "NakedBody", "Scalar", "MelaninDarkMultiplier")
        self['slMelaninDarkT'].Value = getValue(character, "NakedBody", "Scalar", "MelaninDarkThreshold")
    
        self['pickHemoglobinColor'].Color = getValue(character, "NakedBody", "Vector3", "HemoglobinColor")
        self['slHemoglobinAmount'].Value = getValue(character, "NakedBody", "Scalar", "HemoglobinAmount")
        self['pickYellowingColor'].Color = getValue(character, "NakedBody", "Vector3", "YellowingColor")
        self['slYellowingAmount'].Value = getValue(character, "NakedBody", "Scalar", "YellowingAmount")
        self['pickVeinColor'].Color = getValue(character, "NakedBody", "Vector3", "VeinColor")
        self['slVeinAmount'].Value = getValue(character, "NakedBody", "Scalar", "VeinAmount")
    
        self['slIntMakeupIndex'].Value = getValue(character, "Head", "Scalar", "MakeUpIndex")
        self['pickMakeupColor'].Color = getValue(character, "Head", "Vector3", "MakeupColor")
        self['slMakeupInt'].Value = getValue(character, "Head", "Scalar", "MakeupIntensity")
        self['slMakeupMet'].Value = getValue(character, "Head", "Scalar", "LipsMakeupMetalness")
        self['slMakeupRough'].Value = getValue(character, "Head", "Scalar", "MakeupRoughness")
    
        self['pickLipsColor'].Color = getValue(character, "Head", "Vector3", "Lips_Makeup_Color")
        self['slLipsInt'].Value = getValue(character, "Head", "Scalar", "LipsMakeupIntensity")
        self['slLipsMet'].Value = getValue(character, "Head", "Scalar", "LipsMakeupMetalness")
        self['slLipsRough'].Value = getValue(character, "Head", "Scalar", "LipsMakeupRoughness")
    
        self['slIntTattooIndex'].Value = getValue(character, "Head", "Scalar", "TattooIndex")
        self['pickTattooColorR'].Color = getValue(character, "Head", "Vector3", "TattooColor")
        self['pickTattooColorG'].Color = getValue(character, "Head", "Vector3", "TattooColorG")
        self['pickTattooColorB'].Color = getValue(character, "Head", "Vector3", "TattooColorB")
    
        local tattooIntensity =
        (getValue(character, "Head", "Vector_1", "TattooIntensity")[1] ~= 0 and getValue(character, "Head", "Vector_1", "TattooIntensity")[1]) or
        (getValue(character, "Head", "Vector_2", "TattooIntensity")[1] ~= 0 and getValue(character, "Head", "Vector_2", "TattooIntensity")[1]) or
        getValue(character, "Head", "Vector_3", "TattooIntensity")[1] or 0
    
        self['pickTattooIntR'].Value = {tattooIntensity, 0, 0, 0}
        self['pickTattooIntG'].Value = {tattooIntensity, 0, 0, 0}
        self['pickTattooIntB'].Value = {tattooIntensity, 0, 0, 0}
        
        self['slTattooMet'].Value = getValue(character, "Head", "Scalar", "TattooMetalness")
        self['slTattooRough'].Value = getValue(character, "Head", "Scalar", "TattooRoughnessOffset")
        self['slTattooCurve'].Value = getValue(character, "Head", "Scalar", "TattooCurvatureInfluence")
    
        self['slAgeInt'].Value = getValue(character, "Head", "Scalar", "Age_Weight")
        self['slIntScarIndex'].Value = getValue(character, "Head", "Scalar", "ScarIndex")
    
        self['slEyesHet'].Value = getValue(character, "Head", "Scalar", "Heterochromia")
        self['slEyesBR'].Value = getValue(character, "Head", "Scalar", "Blindness")
        self['slEyesBL'].Value = getValue(character, "Head", "Scalar", "Blindness_L")
        self['pickEyesC'].Color = getValue(character, "Head", "Vector3", "Eyes_IrisColour")
        self['pickEyesCL'].Color = getValue(character, "Head", "Vector3", "Eyes_IrisColour_L")
        self['pickEyesC2'].Color = getValue(character, "Head", "Vector3", "Eyes_IrisSecondaryColour")
        self['pickEyesC2L'].Color = getValue(character, "Head", "Vector3", "Eyes_IrisSecondaryColour_L")
        self['pickEyesSC'].Color = getValue(character, "Head", "Vector3", "Eyes_ScleraColour")
        self['pickEyesSCL'].Color = getValue(character, "Head", "Vector3", "Eyes_ScleraColour_L")
        self['slEyesCI'].Value = getValue(character, "Head", "Scalar", "SecondaryColourIntensity")
        self['slEyesCIL'].Value = getValue(character, "Head", "Scalar", "SecondaryColourIntensity_L")
        self['slEyesEdge'].Value = getValue(character, "Head", "Scalar", "IrisEdgeStrength")
        self['slEyesEdgeL'].Value = getValue(character, "Head", "Scalar", "IrisEdgeStrength_L")
        self['slEyesRed'].Value = getValue(character, "Head", "Scalar", "Redness")
        self['slEyesRedL'].Value = getValue(character, "Head", "Scalar", "Redness_L")
    
        self['slBTatI'].Value = getValue(character, "NakedBody", "Scalar", "AdditionalTattooIntensity")
        self['pickBTatCR'].Color = getValue(character, "NakedBody", "Vector3", "BodyTattooColor")
        self['pickBTatCG'].Color = getValue(character, "NakedBody", "Vector3", "BodyTattooColorG")
        self['pickBTatCB'].Color = getValue(character, "NakedBody", "Vector3", "BodyTattooColorB")

        local bodyTattooIntensity =
        (getValue(character, "NakedBody", "Vector_1", "BodyTattooIntensity")[1] ~= 0 and getValue(character, "NakedBody", "Vector_1", "BodyTattooIntensity")[1]) or
        (getValue(character, "NakedBody", "Vector_2", "BodyTattooIntensity")[1] ~= 0 and getValue(character, "NakedBody", "Vector_2", "BodyTattooIntensity")[1]) or
        getValue(character, "NakedBody", "Vector_3", "BodyTattooIntensity")[1] or 0
    
        self['slBTatIntR'].Value = {bodyTattooIntensity, 0, 0, 0}
        self['slBTatIntG'].Value = {bodyTattooIntensity, 0, 0, 0}
        self['slBTatIntB'].Value = {bodyTattooIntensity, 0, 0, 0}
        

        self['slBTatMet'].Value = getValue(character, "NakedBody", "Scalar", "TattooMetalness")
        self['slBTatR'].Value = getValue(character, "NakedBody", "Scalar", "TattooRoughnessOffset")
        self['slBTatCurve'].Value = getValue(character, "NakedBody", "Scalar", "TattooCurvatureInfluence")
    
        self['slScalpMinValue'].Value = getValue(character, "Head", "Scalar", "Scalp_MinValue")
        self['slHornMaskWeight'].Value = getValue(character, "Head", "Scalar", "Scalp_HornMaskWeight")
        self['slGrayingIntensity'].Value = getValue(character, "Head", "Scalar", "Scalp_Graying_Intensity")
        self['slColorTransitionMid'].Value = getValue(character, "Head", "Scalar", "Scalp_ColorTransitionMidPoint")
        self['slColorTransitionSoft'].Value = getValue(character, "Head", "Scalar", "Scalp_ColorTransitionSoftness")
        self['slDepthColorExponent'].Value = getValue(character, "Head", "Scalar", "Scalp_DepthColorExponent")
        self['slDepthColorIntensity'].Value = getValue(character, "Head", "Scalar", "Scalp_DepthColorIntensity")
        self['slIDContrast'].Value = getValue(character, "Head", "Scalar", "Scalp_IDContrast")
        self['slColorDepthContrast'].Value = getValue(character, "Head", "Scalar", "Scalp_ColorDepthContrast")
        self['slScalpRoughness'].Value = getValue(character, "Head", "Scalar", "Scalp_Roughness")
        self['slRoughnessContrast'].Value = getValue(character, "Head", "Scalar", "Scalp_RoughnessContrast")
        self['slScalpScatter'].Value = getValue(character, "Head", "Scalar", "Scalp_Scatter")
        self['pickHairScalpColor'].Color = getValue(character, "Head", "Vector3", "Hair_Scalp_Color")
        self['pickGrayingColor'].Color = getValue(character, "Head", "Vector3", "Hair_Scalp_Graying_Color")
        self['pickHueShiftWeight'].Color = getValue(character, "Head", "Vector3", "Hair_Scalp_HueShift_Weight")

        self['pickHairColor'].Color = getValue(character, "Hair", "Vector3", "Hair_Color")
        self['slSharedNoiseTiling'].Value = getValue(character, "Hair", "Scalar", "SharedNoiseTiling")
        self['slHairFrizz'].Value = getValue(character, "Hair", "Scalar", "HairFrizz")
        self['slHairSoupleness'].Value = getValue(character, "Hair", "Scalar", "HairSoupleness")
        self['slMaxWindMovement'].Value = getValue(character, "Hair", "Scalar", "MaxWindMovementAmount")
        self['slSoftenTipsAlpha'].Value = getValue(character, "Hair", "Scalar", "SoftenTipsAlpha")
        self['slBaseColorVar'].Value = getValue(character, "Hair", "Scalar", "BaseColorVar")
        self['slRootTransitionMid'].Value = getValue(character, "Hair", "Scalar", "RootTransitionMidPoint")
        self['slRootTransitionSoft'].Value = getValue(character, "Hair", "Scalar", "RootTransitionSoftness")
        self['slDepthColorExponent'].Value = getValue(character, "Hair", "Scalar", "DepthColorExponent")
        self['slDepthColorIntensity'].Value = getValue(character, "Hair", "Scalar", "DepthColorIntensity")
        self['slColorDepthContrast'].Value = getValue(character, "Hair", "Scalar", "ColorDepthContrast")
        self['slDreadNoiseBaseColor'].Value = getValue(character, "Hair", "Scalar", "DreadNoiseBaseColor")

        self['pickHairGrayingColor'].Color = getValue(character, "Hair", "Vector3", "Hair_Graying_Color")
        self['slGrayingIntensity'].Value = getValue(character, "Hair", "Scalar", "Graying_Intensity")
        self['slGrayingSeed'].Value = getValue(character, "Hair", "Scalar", "Graying_Seed")

        self['pickHighlightColor'].Color = getValue(character, "Hair", "Vector3", "Highlight_Color")
        self['slHighlightFalloff'].Value = getValue(character, "Hair", "Scalar", "Highlight_Falloff")
        self['slHighlightIntensity'].Value = getValue(character, "Hair", "Scalar", "Highlight_Intensity")

        self['pickHornsColor'].Color = getValue(character, "Horns", "Vector3", "NonSkinColor")
        self['pickHornsTipColor'].Color = getValue(character, "Horns", "Vector3", "NonSkinTipColor")
        self['slHornReflectance'].Value = getValue(character, "Horns", "Scalar", "Reflectance")
        self['slHornIntensity'].Value = getValue(character, "Horns", "Scalar", "Intensity")

        pcikEyeLC.Color = getValue(character, "Head", "Vector3", "Eyelashes_Color")
        pickEyeBC.Color = getValue(character, "Head", "Vector3", "Eyebrow_Color")

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

