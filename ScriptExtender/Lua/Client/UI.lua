CCEE = {}
UI = {}
Window = {}
Skin = {}
Tattoo = {}
Tests = {}
Head = {}
Hair = {}
Body = {}
Elements = {}
Functions = {}

local OPENQUESTIONMARK = true


function UI:Init()
    Window:CCEEMCM()
    Window:CCEEWindow()
    CCEE:Skin()
    CCEE:Face()
    CCEE:Head()
    CCEE:Body()
    CCEE:Hair()
    GetAllParameterNames(_C())
end

--when mapped Gladge
-- Ext.Events.OnComponentCreated:Subscribe("eoc::photo_mode::SessionComponent",function ()
--     DPrint('PM')
-- end)








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


    MCM.SetKeybindingCallback('ccee_apply_pm_parameters', function()
        Helpers.Timer:OnTicks(2, function ()
            ApplyParametersToDummies()
        end)

    end)

    firstManToUseProgressBar = p:AddProgressBar()
    firstManToUseProgressBar.Visible = false

    firstManToUseProgressBarLable = p:AddText('Calculating quats')
    firstManToUseProgressBarLable.SameLine = true
    firstManToUseProgressBarLable.Visible = false

    local STOPPPPP = p:AddButton('Idle')
    STOPPPPP.OnClick = function()
        Ext.Net.PostMessageToServer('stop', '')
    end

    local dumpVars = p:AddButton('Dump vars')
    dumpVars.SameLine = true
    dumpVars.OnClick = function ()
        Ext.Net.PostMessageToServer('dumpVars', '')
    end

    local resetTableBtn = p:AddButton('Reset saved data')
    resetTableBtn.SameLine = true
    resetTableBtn.OnClick = function ()

        lastParameters = {}
        lastParametersMV = {}
        Helpers.ModVars:Get(ModuleUUID).CCEE = {}

    end

    local forceLoad = p:AddButton('Force load')
    forceLoad.OnClick = function ()
        Ext.Net.PostMessageToServer('UpdateParameters', '')
    end

    local testsCheck = p:AddCheckbox('All parameters')
    testsCheck.IDContext = 'adasd22'
    testsCheck.SameLine = true
    testsCheck.OnChange = function ()
        if testsCheck.Checked then
            CCEE:Tests()
        else
            testParams:Destroy()
        end
    end


    local saveParams = p:AddButton('Save')
    saveParams.OnClick = function ()
        SaveParamsToFile()
    end

    local loadParams = p:AddButton('Load')
    loadParams.SameLine = true
    loadParams.OnClick = function ()
        LoadParamsFromFile()
    end







    ---@param fn function # loooooooooooook it's colored! 
    function Elements:CreateElements(type, var, name, parent, options, fn)

        if type == 'int' then 
            var = parent:AddSliderInt(name, options.def or 0, options.min or 0, options.max or 1, 0)
            var.Logarithmic = options.log or false

        elseif type == 'picker' then

            var = parent:AddColorEdit(name)
            var.Float = true
            var.NoAlpha = true

        else
            var = parent:AddSlider(name, options.default or 0, options.min or 0, options.max or 1, 0)
            var.Logarithmic = options.log or false

        end

        var.IDContext = Ext.Math.Random(1,1000000)
        var.OnChange = function (var)
            fn(var)
        end
        

    end



    --just a test, probably gonna stick to SaveAndApply because there are repetitve parameters 
    function FunctionsGenerator()
        for attachment, paramTypes in pairs(Parameters) do
            -- DPrint(attachment)
            for parameterType, parameterNames in pairs(paramTypes) do
                if parameterType == 'Scalar' then
                    for _, parameterName in ipairs(parameterNames) do
                        Functions[parameterType] = Functions[parameterType] or {}
                        Functions[parameterType][parameterName] = Functions[parameterType][parameterName] or {}
    
                        table.insert(Functions[parameterType][parameterName], function(slider)
                            SaveAndApply(_C(), attachment, parameterName, parameterType, slider.Value[1])
                        end)
                    end
                    
                elseif parameterType == 'Vector3' then
                    for _, parameterName in ipairs(parameterNames) do
                        Functions[parameterType] = Functions[parameterType] or {}
                        Functions[parameterType][parameterName] = Functions[parameterType][parameterName] or {}
    
                        table.insert(Functions[parameterType][parameterName], function(slider)
                            SaveAndApply(_C(), attachment, parameterName, parameterType, slider.Color)
                        end)
                    end
                    
                elseif parameterType == 'Vector' then
                    for _, parameterName in ipairs(parameterNames) do
                        for i = 1, 4 do
                            local vectorType = 'Vector_' .. i
                            
                            Functions[vectorType] = Functions[vectorType] or {}
                            Functions[vectorType][parameterName] = Functions[vectorType][parameterName] or {}
    
                            table.insert(Functions[vectorType][parameterName], function(slider)
                                SaveAndApply(_C(), attachment, parameterName, vectorType, slider.Value[1])
                            end)
                        end
                    end   
                end
            end
            -- DPrint('Ended')
        end
    end

    function CallFunction(paramType, paramName, var)
        local funcs = Functions[paramType] and Functions[paramType][paramName]
        if funcs then
            for _, fn in ipairs(funcs) do
                fn(var)
            end
        end
    end




    function CCEE:Skin()
    
        local skinColorCollapse = p:AddCollapsingHeader('Skin')
        
        local treeMela = skinColorCollapse:AddTree('Melanin')
        local parent = treeMela

        local SkinMelanin = {

            {'picker', pickMelaninColor, 'Color', parent, {}, function(var)
                CallFunction('Vector3', 'MelaninColor', var) end},
                
            {nil, slMelaninAmount, 'Amount', parent, {}, function(var)
                CallFunction('Scalar', 'MelaninAmount', var) end},
                
            {nil, slMelaninRemoval, 'Removal amount', parent, {max = 100, log = true}, function(var)
                CallFunction('Scalar', 'MelaninRemovalAmount', var) end},
                
            {nil, slMelaninDarkM, 'Dark multiplier', parent, {max = 100, log = true}, function(var)
                CallFunction('Scalar', 'MelaninDarkMultiplier', var) end},
                
            {nil, slMelaninDarkT, 'Dark threshold', parent, {max = 1}, function(var)
                CallFunction('Scalar', 'MelaninDarkThreshold', var) end},
     
    
        }
        
        function Elements:GenerateSkinMelanin()
            for _, v in ipairs(SkinMelanin) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateSkinMelanin()

        local treeHem = skinColorCollapse:AddTree('Hemoglobin')
        local parent = treeHem

        local SkinHemoglobin = {

            {'picker', pickHemoglobinColor, 'Color', parent, {}, function(var)
                CallFunction('Vector3', 'HemoglobinColor', var) end},
                
            {nil, slHemoglobinAmount, 'Amount', parent, {max = 3}, function(var)
                CallFunction('Scalar', 'HemoglobinAmount', var) end},
        }
        
        function Elements:GenerateSkinHemoglobin()
            for _, v in ipairs(SkinHemoglobin) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateSkinHemoglobin()

        local treeYellow = skinColorCollapse:AddTree('Yellowing')
        local parent = treeYellow
        
        local SkinYellowing = {

            {'picker', pickYellowingColor, 'Color', parent, {}, function(var)
                CallFunction('Vector3', 'YellowingColor', var) end},
                
            {nil, slYellowingAmount, 'Amount', parent, {min = -300, max = 300, log = true}, function(var)
                CallFunction('Scalar', 'YellowingAmount', var) end},
        }
        
        function Elements:GenerateSkinYellowing()
            for _, v in ipairs(SkinYellowing) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateSkinYellowing()

        local treeVein = skinColorCollapse:AddTree('Vein')
        local parent = treeVein

        local SkinVein = {

            {'picker', pickVeinColor, 'Color', parent, {}, function(var)
                CallFunction('Vector3', 'VeinColor', var) end},
                
            {nil, slVeinAmount, 'Amount', parent, {max = 7}, function(var)
                CallFunction('Scalar', 'VeinAmount', var) end},
        }
        
        function Elements:GenerateSkinVein()
            for _, v in ipairs(SkinVein) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateSkinVein()

        local sepa1 = skinColorCollapse:AddSeparatorText('')

    end


    function CCEE:Face()

        local faceCollapse = p:AddCollapsingHeader('Face')
        local treeME = faceCollapse:AddTree('Eyes makeup')
        local parent = treeME

        local EyesMakeup = {

            {'int', slIntMakeupIndex, 'Index', parent, {max = makeupCount}, function(var)
                CallFunction('Scalar', 'MakeUpIndex', var) end},
                
            {'picker', pickMakeupColor, 'Color', parent, {}, function(var)
                CallFunction('Vector3', 'MakeupColor', var) end},

            {nil, slMakeupInt, 'Intensity', parent, {max = 5}, function(var)
                CallFunction('Scalar', 'MakeupIntensity', var) end},

            {nil, slMakeupMet, 'Metalness', parent, {max = 1}, function(var)
                CallFunction('Scalar', 'EyesMakeupMetalness', var) end},

            {nil, slMakeupRough, 'Roughness', parent, {min = -1, max = 1}, function(var)
                CallFunction('Scalar', 'MakeupRoughness', var) end},

        }
        
        function Elements:GenerateEyesMakeup()
            for _, v in ipairs(EyesMakeup) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateEyesMakeup()

        local treeLP = faceCollapse:AddTree('Lips makeup')
        local parent = treeLP

        local LipsMakeup = {
                
            {'picker', pickLipsColor, 'Color', parent, {}, function(var)
                CallFunction('Vector3', 'Lips_Makeup_Color', var) end},

            {nil, slLipsInt, 'Intensity', parent, {max = 5}, function(var)
                CallFunction('Scalar', 'LipsMakeupIntensity', var) end},

            {nil, slLipsMet, 'Metalness', parent, {max = 1}, function(var)
                CallFunction('Scalar', 'LipsMakeupMetalness', var) end},

            {nil, slLipsRough, 'Roughness', parent, {min = -1, max = 1}, function(var)
                CallFunction('Scalar', 'LipsMakeupRoughness', var) end},

        }
        
        function Elements:GenerateLipsMakeup()
            for _, v in ipairs(LipsMakeup) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateLipsMakeup()


        local treeTat = faceCollapse:AddTree('Tattoo')
        local parent = treeTat

        local Tattoo = {
                
            {'int', slIntTattooIndex, 'Index', parent, {max = tattooCount}, function(var)
                CallFunction('Scalar', 'TattooIndex', var) end},

            {'picker', pickTattooColorR, 'Color R', parent, {}, function(var)
                CallFunction('Vector3', 'TattooColor', var) end},

            {'picker', pickTattooColorG, 'Color G', parent, {}, function(var)
                CallFunction('Vector3', 'TattooColorG', var) end},

            {'picker', pickTattooColorB, 'Color B', parent, {}, function(var)
                CallFunction('Vector3', 'TattooColorB', var) end},

            {nil, pickTattooIntR, 'Intensity R', parent, {min = -5, max = 5}, function(var)
                CallFunction('Vector_1', 'TattooIntensity', var) end},

            {nil, pickTattooIntG, 'Intensity G', parent, {min = -5, max = 5}, function(var)
                CallFunction('Vector_2', 'TattooIntensity', var) end},

            {nil, pickTattooIntB, 'Intensity B', parent, {min = -5, max = 5}, function(var)
                CallFunction('Vector_3', 'TattooIntensity', var) end},

            {nil, slTattooMet, 'Metalness', parent, {}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooMetalness', 'Scalar', var.Value[1]) end},
               

            {nil, slTattooRough, 'Roughness', parent, {min = -1}, function(var)
                SaveAndApply(_C(), 'Head', 'TattooRoughnessOffset', 'Scalar', var.Value[1]) end},
                
            -- {nil, slTattooCurve, 'Curvature influence', parent, {max = 100}, function(var)
            --     CallFunction('Scalar', 'TattooCurvatureInfluence', var) end},

        }

        -- xd
        Helpers.Timer:OnTicks(1, function ()
            slTattooCurve = parent:AddSlider('Curvature influence', 0, 0, 100, 0)
            slTattooCurve.IDContext = 'fTatCurve'
            slTattooCurve.OnChange = function()
    
                SaveAndApply(_C(), 'Head', 'TattooCurvatureInfluence', 'Scalar', slTattooCurve.Value[1])
            end
        end)
        
        function Elements:GenerateTattoo()
            for _, v in ipairs(Tattoo) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateTattoo()

        local treeScar = faceCollapse:AddTree('Scars')
        local parent = treeScar

        local Scars = {
                
            {'int', slIntScarIndex, 'Index', parent, {max = scarCount}, function(var)
                CallFunction('Scalar', 'ScarIndex', var) end},

            {nil, slIntScarIndex, 'Index', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scar_Weight', var) end},


        }
        
        function Elements:GenerateScars()
            for _, v in ipairs(Scars) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateScars()


        
        local treeAge = faceCollapse:AddTree('Age')
        local parent = treeAge

        local Age = {
                
            {nil, slAgeInt, 'Intensity', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Age_Weight', var) end},
        }
        
        function Elements:GenerateAge()
            for _, v in ipairs(Age) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateAge()

        local treeScales = faceCollapse:AddTree('Scales')
        local parent = treeScales

        local Scales = {
                
            {'int', slIntScaleIndex, 'Index', parent, {max = 31}, function(var)
                CallFunction('Scalar', 'CustomIndex', var) end},

            {'picker', pickScaleColor, 'Color', parent, {}, function(var)
                CallFunction('Vector3', 'CustomColor', var) end},

            {nil, pickScaleInt, 'Intensity', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'CustomIntensity', var) end},

        }
        
        function Elements:GenerateScales()
            for _, v in ipairs(Scales) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateScales()

        local sepa1 = faceCollapse:AddSeparatorText('')

    end


    function CCEE:Head()

        local headCollapse = p:AddCollapsingHeader('Head')

        local treeEyes = headCollapse:AddTree('Eyes')
        local parent = treeEyes

        local Eyes = {

            {'int', slEyesHet, 'Heterochromia', parent, {max = 1}, function(var)
                CallFunction('Scalar', 'Heterochromia', var) end},
                
            {nil, slEyesBR, 'Blindness R', parent, {max = 3}, function(var)
                CallFunction('Scalar', 'Blindness', var) end},
                
            {nil, slEyesBL, 'Blindness L', parent, {max = 3}, function(var)
                CallFunction('Scalar', 'Blindness_L', var) end},
                
            {'picker', pickEyesC, 'Iris color 1', parent, {}, function(var)
                CallFunction('Vector3', 'Eyes_IrisColour', var) end},
                
            {'picker', pickEyesCL, 'Iris color 1 L', parent, {}, function(var)
                CallFunction('Vector3', 'Eyes_IrisColour_L', var) end},
                
            {'picker', pickEyesC2, 'Iris color 2', parent, {}, function(var)
                CallFunction('Vector3', 'Eyes_IrisSecondaryColour', var) end},
                
            {'picker', pickEyesC2L, 'Iris color 2 L', parent, {}, function(var)
                CallFunction('Vector3', 'Eyes_IrisSecondaryColour_L', var) end},
                
            {'picker', pickEyesSC, 'Sclera color', parent, {}, function(var)
                CallFunction('Vector3', 'Eyes_ScleraColour', var) end},
                
            {'picker', pickEyesSCL, 'Sclera color L', parent, {}, function(var)
                CallFunction('Vector3', 'Eyes_ScleraColour_L', var) end},

            {nil, slEyesCI, 'Iris color int', parent, {min = -100, max = 100, log = true}, function(var)
                CallFunction('Scalar', 'SecondaryColourIntensity', var) end},
                
            {nil, slEyesCIL, 'Iris color int L', parent, {min = -100, max = 100}, function(var)
                CallFunction('Scalar', 'SecondaryColourIntensity_L', var) end},
                
            {nil, slEyesEdge, 'IrisEdgeStrength', parent, {min = -100, max = 100, log = true}, function(var)
                CallFunction('Scalar', 'IrisEdgeStrength', var) end},
                
            {nil, slEyesEdgeL, 'IrisEdgeStrength L', parent, {min = -100, max = 100}, function(var)
                CallFunction('Scalar', 'IrisEdgeStrength_L', var) end},
                
            {nil, slEyesRed, 'Redness', parent, {max = 100, log = true}, function(var)
                CallFunction('Scalar', 'Redness', var) end},
                
            {nil, slEyesRedL, 'Redness L', parent, {max = 100}, function(var)
                CallFunction('Scalar', 'Redness_L', var) end}

        }
        
        function Elements:GenerateEyes()
            for _, v in ipairs(Eyes) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateEyes()

        local sepa1 = headCollapse:AddSeparatorText('')
    end


    function CCEE:Body()

        local bodyCollapse = p:AddCollapsingHeader('Body')
        local  bodyTatsTree = bodyCollapse:AddTree('Tattoo')
        bodyTatsTree.IDContext = 'adasdd'
        local parent = bodyTatsTree


        local BodyTattoos = {
            {'int', slBTatI, 'Index', parent, {max = tattooCount}, function(var)
                CallFunction('Scalar', 'BodyTattooIndex', var) end},
                
            {'picker', pickBTatCR, 'Color R', parent, {}, function(var)
                CallFunction('Vector3', 'BodyTattooColor', var) end},
                
            {'picker', pickBTatCG, 'Color G', parent, {}, function(var)
                CallFunction('Vector3', 'BodyTattooColorG', var) end},
                
            {'picker', pickBTatCB, 'Color B', parent, {}, function(var)
                CallFunction('Vector3', 'BodyTattooColorB', var) end},
                
            {nil, slBTatIntR, 'Intensity R', parent, {min = -5, max = 5}, function(var)
                CallFunction('Vector_1', 'BodyTattooIntensity', var) end},
                
            {nil, slBTatIntG, 'Intensity G', parent, {min = -5, max = 5}, function(var)
                CallFunction('Vector_2', 'BodyTattooIntensity', var) end},
                
            {nil, slBTatIntB, 'Intensity B', parent, {min = -5, max = 5}, function(var)
                CallFunction('Vector_3', 'BodyTattooIntensity', var) end},
                
            {nil, slBTatMet, 'Metalness', parent, {max = 1}, function(var)
                SaveAndApply(_C(), 'Body', 'TattooMetalness', 'Scalar', var.Value[1]) end},

            {nil, slBTatR, 'Roughness', parent, {min = -1, max = 1}, function(var)
                SaveAndApply(_C(), 'Body', 'TattooRoughnessOffset', 'Scalar', var.Value[1]) end},
              
            -- {nil, slBTatCurve, 'Curvature influence', parent, {max = 100}, function(var)
            --     CallFunction('Scalar', 'TattooCurvatureInfluence', var) end}
        }        

        -- xd 2

        Helpers.Timer:OnTicks(1, function ()
            slBTatCurve = parent:AddSlider('Curvature influence', 0, -1, 100, 0)
            slBTatCurve.IDContext = 'fTatCurve'
            slBTatCurve.OnChange = function()
    
                SaveAndApply(_C(), 'Body', 'TattooCurvatureInfluence', 'Scalar', slBTatCurve.Value[1])
            end
        end)

                
        function Elements:GenerateBTattoes()
            for _, v in ipairs(BodyTattoos) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateBTattoes()

        local sepa133 = bodyCollapse:AddSeparatorText('')

    end


    function CCEE:Hair()

        local hairCollapse = p:AddCollapsingHeader('Hair')

        local browTree = hairCollapse:AddTree('Eyebrow')

        pickEyeBC = browTree:AddColorEdit('Color')
        pickEyeBC.IDContext = 'eyeBC'
        pickEyeBC.Float = true
        pickEyeBC.NoAlpha = true
        pickEyeBC.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyebrow_Color', 'Vector3', pickEyeBC.Color)
        end

        local lashTree = hairCollapse:AddTree('Eyelashes')


        pcikEyeLC = lashTree:AddColorEdit('Color')
        pcikEyeLC.IDContext = 'eyeLC'
        pcikEyeLC.Float = true
        pcikEyeLC.NoAlpha = true
        pcikEyeLC.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyelashes_Color', 'Vector3', pcikEyeLC.Color)
        end


        local scalpTree = hairCollapse:AddTree('Scalp')
        local parent = scalpTree
        
        local HairScalp = {

            {nil, slScalpMinValue, 'Scalp Min Value', parent, {min = -1, max = 1}, function(var)
                CallFunction('Scalar', 'Scalp_MinValue', var) end},
            
            {nil, slHornMaskWeight, 'Horn Mask Weight', parent, {min = -1, max = 1}, function(var)
                CallFunction('Scalar', 'Scalp_HornMaskWeight', var) end},
            
            {nil, slGrayingIntensity, 'Graying Intensity', parent, {max = 1}, function(var)
                CallFunction('Scalar', 'Scalp_Graying_Intensity', var) end},
            
            {nil, slColorTransitionMid, 'Color Transition Mid', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scalp_ColorTransitionMidPoint', var) end},
            
            {nil, slColorTransitionSoft, 'Color Transition Soft', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scalp_ColorTransitionSoftness', var) end},
            
            {nil, slDepthColorExponent, 'Depth Color Exponent', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scalp_DepthColorExponent', var) end},
            
            {nil, slDepthColorIntensity, 'Depth Color Intensity', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scalp_DepthColorIntensity', var) end},
            
            {nil, slIDContrast, 'ID Contrast', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scalp_IDContrast', var) end},
            
            {nil, slColorDepthContrast, 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scalp_ColorDepthContrast', var) end},
            
            {nil, slScalpRoughness, 'Scalp Roughness', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scalp_Roughness', var) end},
            
            {nil, slRoughnessContrast, 'Roughness Contrast', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scalp_RoughnessContrast', var) end},
            
            {nil, slScalpScatter, 'Scalp Scatter', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'Scalp_Scatter', var) end},
            
            {'picker', pickHairScalpColor, 'Hair Scalp Color', parent, {}, function(var)
                CallFunction('Vector3', 'Hair_Scalp_Color', var) end},
            
            {'picker', pickGrayingColor, 'Graying Color', parent, {}, function(var)
                CallFunction('Vector3', 'Hair_Scalp_Graying_Color', var) end},
            
            {'picker', pickHueShiftWeight, 'Hue Shift Weight', parent, {}, function(var)
                CallFunction('Vector3', 'Scalp_HueShiftColorWeight', var) end},
            
            {'picker', pickBeardScalpColor, 'Beard Scalp Color', parent, {}, function(var)
                CallFunction('Vector3', 'Beard_Scalp_Color', var) end}
        }


        function Elements:GenerateHairScalp()
            for _, v in ipairs(HairScalp) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateHairScalp()


        local hairTree = hairCollapse:AddTree('Hair')
        hairTree.IDContext = 'adasdada'
        local parent = hairTree

        local Hair = {


            {'picker', pickHairColor, 'Hair Color', parent, {}, function(var)
                CallFunction('Vector3', 'Hair_Color', var) end},
                
            -- {'picker', pickBeardColor, 'Beard Color', parent, {}, function(var)
            --     CallFunction('Vector3', 'Beard_Color', var) end},

            {nil, slSharedNoiseTiling, 'Shared Noise Tiling', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'SharedNoiseTiling', var) end},
        
            {nil, slHairFrizz, 'Hair Frizz', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'HairFrizz', var) end},
        
            -- {nil, slPixelDepthOffsetRoot, 'Pixel Depth Offset Root', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'PixelDepthOffsetRoot', var) end},
        
            -- {nil, slPixelDepthOffset, 'Pixel Depth Offset', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'PixelDepthOffset', var) end},
        
            -- {nil, slDepthTransitionMidPoint, 'Depth Transition Mid', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DepthTransitionMidPoint', var) end},
        
            -- {nil, slDepthTransitionSoftness, 'Depth Transition Soft', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DepthTransitionSoftness', var) end},
        
            {nil, slHairSoupleness, 'Hair Soupleness', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'HairSoupleness', var) end},
        
            {nil, slMaxWindMovement, 'Max Wind Movement', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'MaxWindMovementAmount', var) end},
        
            {nil, slSoftenTipsAlpha, 'Soften Tips Alpha', parent, {}, function(var)
                CallFunction('Scalar', 'SoftenTipsAlpha', var) end},
        
            -- {nil, slBeardAlpha, 'Beard Alpha', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DontTouchMe_Beard_Alpha', var) end},
        
            {nil, slBaseColorVar, 'Base Color Var', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'BaseColorVar', var) end},
        
            -- {nil, slIsBeard, 'Is Beard', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DontTouchMe_isBeard', var) end},
        

        
            -- {nil, slBeardGrayingIntensity, 'Beard Graying Intensity', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'Beard_Graying_Intensity', var) end},

        

            {nil, slRootTransitionMid, 'Root Transition Mid', parent, {}, function(var)
                CallFunction('Scalar', 'RootTransitionMidPoint', var) end},
        
            {nil, slRootTransitionSoft, 'Root Transition Soft', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'RootTransitionSoftness', var) end},
        
            {nil, slDepthColorExponent, 'Depth Color Exponent', parent, {}, function(var)
                CallFunction('Scalar', 'DepthColorExponent', var) end},
        
            {nil, slDepthColorIntensity, 'Depth Color Intensity', parent, {}, function(var)
                CallFunction('Scalar', 'DepthColorIntensity', var) end},
        
            -- {nil, slIDContrast, 'ID Contrast', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'IDContrast', var) end},
        
            {nil, slColorDepthContrast, 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
                CallFunction('Scalar', 'ColorDepthContrast', var) end},
        
            {nil, slDreadNoiseBaseColor, 'Dread Noise Base Color', parent, {}, function(var)
                CallFunction('Scalar', 'DreadNoiseBaseColor', var) end},
        
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
        }


        function Elements:GenerateHair()
            for _, v in ipairs(Hair) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateHair()


        local grayingTree = hairCollapse:AddTree('Graying')
        local parent = grayingTree

        Graying = {

            {'picker', pickHairGrayingColor, 'Hair Graying Color', parent, {log = true}, function(var)
                CallFunction('Vector3', 'Hair_Graying_Color', var) end},


            {nil, slGrayingIntensity, 'Graying Intensity', parent, {max = 1.2}, function(var)
                CallFunction('Scalar', 'Graying_Intensity', var) end},


            {nil, slGrayingSeed, 'Graying Seed', parent, {min = -10, max = 10, log = true}, function(var)
                CallFunction('Scalar', 'Graying_Seed', var) end},



        }

        function Elements:GenerateGraying()
            for _, v in ipairs(Graying) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateGraying()


        local hightTree = hairCollapse:AddTree('Highlights')
        local parent = hightTree


        Highlights = {

            {'picker', pickHighlightColor, 'Highlight Color', parent, {log = true}, function(var)
                CallFunction('Vector3', 'Highlight_Color', var) end},

            {nil, slHighlightFalloff, 'Highlight Falloff', parent, {min = -1,log = true}, function(var)
                CallFunction('Scalar', 'Highlight_Falloff', var) end},
        
            {nil, slHighlightIntensity, 'Highlight Intensity', parent, {log = true}, function(var)
                CallFunction('Scalar', 'Highlight_Intensity', var) end},
        
        }

        function Elements:GenerateHighlights()
            for _, v in ipairs(Highlights) do
                self:CreateElements(table.unpack(v))
            end
        end

        Elements:GenerateHighlights()

        local sepa1333 = hairCollapse:AddSeparatorText('')

    end


    function CCEE:Tests()

        local parent = p
        testParams = parent:AddCollapsingHeader('All parameters')

        function Tests:Body()

            local testParamsBody = testParams:AddTree('Bodyd')
            local treeTestParams = testParamsBody:AddTree('Scalar')
            local treeTestParams2 = testParamsBody:AddTree('Vec3')
            local treeTestParams3 = testParamsBody:AddTree('Vec')
    
            function TestAllBodyScalarParameters()
                for _,v in ipairs(Parameters.Body.Scalar) do
                    local testSlider = treeTestParams:AddSliderInt(v, 0, -100, 100)
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        for _, part in ipairs({'Body'}) do
                            
                            ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
                        end
                    end
                end
            end
    
            function TestAllBodyVec3Parameters()
                for _,v in ipairs(Parameters.Body.Vector3) do
                    local testPicker = treeTestParams2:AddColorEdit(v)
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        for _, part in ipairs({'Body'}) do
                            ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
                        end
                    end
                end
            end
    
            function TestAllBodyVecParameter()
                for _,v in ipairs(Parameters.Body.Vector) do
                    local testSlider2 = treeTestParams3:AddSlider(v)
                    testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider2.OnChange = function()
                        for _, part in ipairs({'Body'}) do
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


end

UI:Init()

