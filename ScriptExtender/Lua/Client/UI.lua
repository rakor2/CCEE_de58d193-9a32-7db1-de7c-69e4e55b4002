UI = {}
Window = {}
Skin = {}
Tattoo = {}
Tests = {}
Head = {}
Hair = {}

local OPENQUESTIONMARK = false


function UI:Init()
    Window:CCEEMCM()
    Window:CCEEWindow()
    GetAllParameterNames(_C())
    Skin:Color()
    Head:Face()
    Head:Head()
    -- Tests:Tests()
end


function GetPMKeybind()
    for _, pmBind in pairs(Ext.Input.GetInputManager().InputScheme.RawToBinding) do
        for i = 1, 2 do
            if pmBind.Bindings[i] and pmBind.Bindings[i].BindingIndex == 1 and pmBind.Bindings[i].InputIndex == 320 then
                local hotkey = pmBind.Bindings[i].Binding.InputId
                return hotkey
            end
        end
    end
end

KeybindingManager:Bind({
    ScanCode = tostring(GetPMKeybind()):upper(),
    Callback = function()
        Helpers.Timer:OnTicks(35, function ()
            ApplyParametersToDummies()
        end)
     end,
})



--temp thingy
function UI:Init2()
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


    local resetTableBtn = p:AddButton('Reset modvars')
    resetTableBtn.SameLine = true
    resetTableBtn.OnClick = function ()
        Helpers.ModVars:Get(ModuleUUID).CCEE = {}
    end

    local updateParamTable = p:AddButton('Update params')
    updateParamTable.SameLine = true
    updateParamTable.OnClick = function ()
        GetAllParameterNames(_C())
    end


    local applyDummy = p:AddButton('asdasd')
    applyDummy.OnClick = function ()
        ApplyParametersToDummies()
    end

    function Skin:Color()

        local skinColorCollapse = p:AddCollapsingHeader('Skin')
        
        local sepa1 = skinColorCollapse:AddSeparatorText('Melanin')

        local pickerMelaninC = skinColorCollapse:AddColorEdit('Color')
        pickerMelaninC.Float = true
        pickerMelaninC.NoAlpha = true
        pickerMelaninC.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'MelaninColor', 'Vector3', pickerMelaninC.Color)
            end
        end

        local sliderMelaninA = skinColorCollapse:AddSlider('Amount')
        sliderMelaninA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'MelaninAmount', 'Scalar', sliderMelaninA.Value[1])
            end
        end


        local sliderMelaninRA = skinColorCollapse:AddSlider('Removal amount', 0, 0, 100, 1)
        sliderMelaninRA.Logarithmic = true
        sliderMelaninRA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'MelaninRemovalAmount', 'Scalar', sliderMelaninRA.Value[1])
            end
        end

        
        local sliderMelaninDM = skinColorCollapse:AddSlider('Dark multiplier', 0, 0, 100, 1)
        sliderMelaninDM.Logarithmic = true
        sliderMelaninDM.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'MelaninDarkMultiplier', 'Scalar', sliderMelaninDM.Value[1])
            end
        end

        local sliderMelaninDT = skinColorCollapse:AddSlider('Dark threshold', 0, 0, 1, 0)
        sliderMelaninDT.Logarithmic = true
        sliderMelaninDT.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'MelaninDarkThreshold', 'Scalar', sliderMelaninDT.Value[1])
            end
        end


        local sepa2 = skinColorCollapse:AddSeparatorText('Hemoglobin')


        local pickerHemoglobinnC = skinColorCollapse:AddColorEdit('Color')
        pickerHemoglobinnC.IDContext = 'pickerHemoglobinnCasdasd'
        pickerHemoglobinnC.Float = true
        pickerHemoglobinnC.NoAlpha = true
        pickerHemoglobinnC.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'HemoglobinColor', 'Vector3', pickerHemoglobinnC.Color)
            end
        end


        local sliderHemoglobinnA = skinColorCollapse:AddSlider('Amount', 0, 0, 3, 0)
        sliderHemoglobinnA.IDContext = 'sliderHemoglobinnAasdasd'
        sliderHemoglobinnA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'HemoglobinAmount', 'Scalar', sliderHemoglobinnA.Value[1])
            end
        end

        local sepa3 = skinColorCollapse:AddSeparatorText('Yellowing')


        local pickerYellowingC = skinColorCollapse:AddColorEdit('Color')
        pickerYellowingC.IDContext = 'yellllCasdasd'
        pickerYellowingC.Float = true
        pickerYellowingC.NoAlpha = true
        pickerYellowingC.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'YellowingColor', 'Vector3', pickerYellowingC.Color)
            end
        end


        local pickerYellowingA = skinColorCollapse:AddSlider('Amount', 0, -300, 300, 0)
        pickerYellowingA.IDContext = 'yellAasdasd'
        pickerYellowingA.Logarithmic = true
        pickerYellowingA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'YellowingAmount', 'Scalar', pickerYellowingA.Value[1])
            end
        end

        
        local sepa4 = skinColorCollapse:AddSeparatorText('Vein')


        local pickerVeinC = skinColorCollapse:AddColorEdit('Color')
        pickerVeinC.IDContext = 'VeinCasdasd'
        pickerVeinC.Float = true
        pickerVeinC.NoAlpha = true
        pickerVeinC.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'VeinColor', 'Vector3', pickerVeinC.Color)
            end
        end


        local pickerVeinA = skinColorCollapse:AddSlider('Amount', 0, 0, 7, 0)
        pickerVeinA.IDContext = 'yveveAasdasd'
        pickerVeinA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                ApplyParameters(_C(), attachment, 'VeinAmount', 'Scalar', pickerVeinA.Value[1])
            end
        end

    end

    function Head:Face()

        local faceCollapse = p:AddCollapsingHeader('Face')

        local sepa6 = faceCollapse:AddSeparatorText('Eyes makeup')

        local makeupInd = faceCollapse:AddSliderInt('Index', 0, 0, 80, 0)
        makeupInd.IDContext = 'makeupIntasdasdasd'
        makeupInd.OnChange = function()

            ApplyParameters(_C(), 'Head', 'MakeUpIndex', 'Scalar', makeupInd.Value[1])

        end

        local makeupC = faceCollapse:AddColorEdit('Color')
        makeupC.IDContext = 'makeupCasd'
        makeupC.Float = true
        makeupC.NoAlpha = true
        makeupC.OnChange = function()
            ApplyParameters(_C(), 'Head', 'MakeupColor', 'Vector3', makeupC.Color)
        end



        local makeupInt = faceCollapse:AddSlider('Intensity', 0, 0, 5, 0)
        makeupInt.IDContext = 'makeupIntasdasdasd'
        makeupInt.OnChange = function()

            ApplyParameters(_C(), 'Head', 'MakeupIntensity', 'Scalar', makeupInt.Value[1])

        end

        local makeupM = faceCollapse:AddSlider('Metalness', 0, 0, 1, 0)
        makeupM.IDContext = 'makeupMad2q3123'
        makeupM.OnChange = function()

            ApplyParameters(_C(), 'Head', 'EyesMakeupMetalness', 'Scalar', makeupM.Value[1])

        end

        local makeupR = faceCollapse:AddSlider('Roughness', 0, -1, 1, 0)
        makeupR.IDContext = 'makeupRasdasd'
        makeupR.OnChange = function()

            ApplyParameters(_C(), 'Head', 'MakeupRoughness', 'Scalar', makeupR.Value[1])

        end

        local sepa7 = faceCollapse:AddSeparatorText('Lips makeup')

        local makeupLC = faceCollapse:AddColorEdit('Color')
        makeupLC.IDContext = 'makeupLCadasd'
        makeupLC.Float = true
        makeupLC.NoAlpha = true
        makeupLC.OnChange = function()
            ApplyParameters(_C(), 'Head', 'Lips_Makeup_Color', 'Vector3', makeupLC.Color)
        end


        local makeupLInt = faceCollapse:AddSlider('Intensity', 0, 0, 5, 0)
        makeupLInt.IDContext = 'makeupLInt2133123'
        makeupLInt.OnChange = function()

            ApplyParameters(_C(), 'Head', 'LipsMakeupIntensity', 'Scalar', makeupLInt.Value[1])

        end

        local makeupLM = faceCollapse:AddSlider('Metalness', 0, 0, 1, 0)
        makeupLM.IDContext = 'makeupLM123sfasdf'
        makeupLM.OnChange = function()

            ApplyParameters(_C(), 'Head', 'LipsMakeupMetalness', 'Scalar', makeupLM.Value[1])

        end

        local makeupLR = faceCollapse:AddSlider('Roughness', 0, -1, 1, 0)
        makeupLR.IDContext = 'makeupLRasd'
        makeupLR.OnChange = function()

            ApplyParameters(_C(), 'Head', 'LipsMakeupRoughness', 'Scalar', makeupLR.Value[1])

        end


        local sepa8 = faceCollapse:AddSeparatorText('Tattoo')

        
        local fTatM = faceCollapse:AddSliderInt('Index', 0, 0, tattooCount, 0)
        fTatM.IDContext = 'fTatM1233444'
        fTatM.OnChange = function()

            ApplyParameters(_C(), 'Head', 'TattooIndex', 'Scalar', fTatM.Value[1])

        end

        local fTatC = faceCollapse:AddColorEdit('Color')
        fTatC.IDContext = 'fTatC123123'
        fTatC.Float = true
        fTatC.NoAlpha = true
        fTatC.OnChange = function()
            ApplyParameters(_C(), 'Head', 'TattooColorB', 'Vector3', fTatC.Color)
        end


        local fTatInt = faceCollapse:AddSlider('Intensity', 0, -5, 5, 0)
        fTatInt.IDContext = 'fTatInta213'
        fTatInt.OnChange = function()

            ApplyParameters(_C(), 'Head', 'TattooIntensity', 'Vector', fTatInt.Value[1])

        end


        local fTatCurve = faceCollapse:AddSlider('Curvature influence', 0, 0, 100, 0)
        fTatCurve.IDContext = 'fTatCurveasdas'
        fTatCurve.OnChange = function()

            ApplyParameters(_C(), 'Head', 'TattooCurvatureInfluence', 'Scalar', fTatCurve.Value[1])

        end




    end

    function Head:Head()
        

        local headCollapse = p:AddCollapsingHeader('Head')

        local sepa8 = headCollapse:AddSeparatorText('Eyes')

        

        local eyesHet = headCollapse:AddSliderInt('Heterochromia', 0, 0, 1, 0)
        eyesHet.IDContext = 'eyesHetasds'
        eyesHet.Disabled = true
        eyesHet.OnChange = function()

            ApplyParameters(_C(), 'Head', 'Heterochromia', 'Scalar', makeupInd.Value[1])

        end


        local eyesBR = headCollapse:AddSlider('Blindness R', 0, 0, 3, 0)
        eyesBR.IDContext = 'eyesHetasds'
        eyesBR.OnChange = function()

            ApplyParameters(_C(), 'Head', 'Blindness', 'Scalar', eyesBR.Value[1])

        end

        local eyesBL = headCollapse:AddSlider('Blindness L', 0, 0, 3, 0)
        eyesBL.IDContext = 'eyesHetasds'
        eyesBL.OnChange = function()

            ApplyParameters(_C(), 'Head', 'Blindness_L', 'Scalar', eyesBL.Value[1])

        end

        local eyesC = headCollapse:AddColorEdit('Iris color 1')
        eyesC.IDContext = 'eyesCasfbfdgftyu7yi9'
        eyesC.Float = true
        eyesC.NoAlpha = true
        eyesC.OnChange = function()
            ApplyParameters(_C(), 'Head', 'Eyes_IrisColour', 'Vector3', eyesC.Color)
        end

        local eyesCL = headCollapse:AddColorEdit('Iris color 1 L')
        eyesCL.IDContext = 'eyesCL123123'
        eyesCL.Float = true
        eyesCL.NoAlpha = true
        eyesCL.OnChange = function()
            ApplyParameters(_C(), 'Head', 'Eyes_IrisColour_L', 'Vector3', eyesCL.Color)
        end

        local eyesC2 = headCollapse:AddColorEdit('Iris color 2')
        eyesC2.IDContext = 'eyesC2asdfsdfwer'
        eyesC2.Float = true
        eyesC2.NoAlpha = true
        eyesC2.OnChange = function()
            ApplyParameters(_C(), 'Head', 'Eyes_IrisSecondaryColour', 'Vector3', eyesC2.Color)
        end

        local eyesC2L = headCollapse:AddColorEdit('Iris color 2 L')
        eyesC2L.IDContext = 'eyesC2Lsdfsdfwefwrwe'
        eyesC2L.Float = true
        eyesC2L.NoAlpha = true
        eyesC2L.OnChange = function()
            ApplyParameters(_C(), 'Head', 'Eyes_IrisSecondaryColour_L', 'Vector3', eyesC2L.Color)
        end

        local eyesSC = headCollapse:AddColorEdit('Sclera color')
        eyesSC.IDContext = 'eyesSC1231235erdfg'
        eyesSC.Float = true
        eyesSC.NoAlpha = true
        eyesSC.OnChange = function()
            ApplyParameters(_C(), 'Head', 'Eyes_ScleraColour', 'Vector3', eyesSC.Color)
        end

        local eyesSC = headCollapse:AddColorEdit('Sclera color L')
        eyesSC.IDContext = 'eyesCR'
        eyesSC.Float = true
        eyesSC.NoAlpha = true
        eyesSC.OnChange = function()
            ApplyParameters(_C(), 'Head', 'Eyes_ScleraColour_L', 'Vector3', eyesSC.Color)
        end



        local eyesCI = headCollapse:AddSlider('Iris color int', 0, -100, 100, 0)
        eyesCI.IDContext = 'eyes2CRasadasd'
        eyesCI.Logarithmic = true
        eyesCI.OnChange = function()
            ApplyParameters(_C(), 'Head', 'SecondaryColourIntensity', 'Scalar', eyesCI.Value[1])
        end


        local eyesCIL = headCollapse:AddSlider('Iris color int L', 0, -100, 100, 0)
        eyesCIL.IDContext = 'eyes2CLa123'
        eyesCIL.OnChange = function()
            ApplyParameters(_C(), 'Head', 'SecondaryColourIntensity_L', 'Scalar', eyesCIL.Value[1])
        end
        

        -- local eyes2CL = headCollapse:AddSlider('Iris color int L', 0, -100, 100, 0)
        -- eyes2CL.IDContext = 'eyes2CLa123'
        -- eyes2CL.OnChange = function()
        --     ApplyParameters(_C(), 'Head', 'SecondaryColourIntensity_L', 'Scalar', eyes2CL.Value[1])
        -- end
        

    end



end

UI:Init()



    -- function Tests:Tests()


    --     testParams = parent:AddCollapsingHeader('Tests')

    --     function Tests:Body()

    --         local testParamsBody = testParams:AddTree('Body')
    --         local treeTestParams = testParamsBody:AddTree('Scalar')
    --         local treeTestParams2 = testParamsBody:AddTree('Vec3')
    --         local treeTestParams3 = testParamsBody:AddTree('Vec')
    
    --         function TestAllBodyScalarParameters()
    --             for _,v in ipairs(Parameters.Body.Scalar) do
    --                 local testSlider = treeTestParams:AddSliderInt(v, 0, -100, 100)
    --                 testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider.OnChange = function()
    --                     for _, part in ipairs({'Body'}) do
                            
    --                         ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
    --                     end
    --                 end
    --             end
    --         end
    
    --         function TestAllBodyVec3Parameters()
    --             for _,v in ipairs(Parameters.Body.Vector3) do
    --                 local testPicker = treeTestParams2:AddColorEdit(v)
    --                 testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testPicker.OnChange = function()
    --                     for _, part in ipairs({'Body'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
    --                     end
    --                 end
    --             end
    --         end
    
    --         function TestAllBodyVecParameter()
    --             for _,v in ipairs(Parameters.Body.Vector) do
    --                 local testSlider2 = treeTestParams3:AddSlider(v)
    --                 testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider2.OnChange = function()
    --                     for _, part in ipairs({'Body'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
    --                     end
    --                 end
    --             end
    --         end
    

    --         TestAllBodyScalarParameters()
    --         TestAllBodyVec3Parameters()
    --         TestAllBodyVecParameter()
    
    --     end
       
    --     function Tests:Head()

    --         local testParamsHead = testParams:AddTree('Head')
    --         local treeTestParams4 = testParamsHead:AddTree('Scalar')
    --         local treeTestParams5 = testParamsHead:AddTree('Vec3')
    --         local treeTestParams6 = testParamsHead:AddTree('Vec')
    

    --         function TestAllHeadScalarParameters()
    --             for _,v in ipairs(Parameters.Head.Scalar) do
    --                 local testSlider = treeTestParams4:AddSliderInt(v, 0, -100, 100)
    --                 testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider.OnChange = function()
    --                     for _, part in ipairs({'Head'}) do
    --                         ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
    --                     end
    --                 end
    --             end
    --         end
    
    --         function TestAllHeadVec3Parameters()
    --             for _,v in ipairs(Parameters.Head.Vector3) do
    --                 local testPicker = treeTestParams5:AddColorEdit(v)
    --                 testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testPicker.OnChange = function()
    --                     for _, part in ipairs({'Head'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
    --                     end
    --                 end
    --             end
    --         end
    
    --         function TestAllHeadVecParameter()
    --             for _,v in ipairs(Parameters.Head.Vector) do
    --                 local testSlider2 = treeTestParams6:AddSlider(v)
    --                 testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider2.OnChange = function()
    --                     for _, part in ipairs({'Head'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
    --                     end
    --                 end
    --             end
    --         end


    --         TestAllHeadScalarParameters()
    --         TestAllHeadVec3Parameters()
    --         TestAllHeadVecParameter()

    --     end

    --     function Tests:Genital()

    --         local testParamsGenital = testParams:AddTree('Genital')
    --         local treeTestParamsGenital_5821 = testParamsGenital:AddTree('Scalar')
    --         local treeTestParamsGenital_1293 = testParamsGenital:AddTree('Vec3')
    --         local treeTestParamsGenital_7640 = testParamsGenital:AddTree('Vec')
        
    --         function TestAllGenitalScalarParameters()
    --             for _,v in ipairs(Parameters.Genital.Scalar) do
    --                 local testSlider = treeTestParamsGenital_5821:AddSliderInt(v, 0, -100, 100)
    --                 testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider.OnChange = function()
    --                     for _, part in ipairs({'Genital'}) do
    --                         ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
    --                     end
    --                 end
    --             end
    --         end
        
    --         function TestAllGenitalVec3Parameters()
    --             for _,v in ipairs(Parameters.Genital.Vector3) do
    --                 local testPicker = treeTestParamsGenital_1293:AddColorEdit(v)
    --                 testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testPicker.OnChange = function()
    --                     for _, part in ipairs({'Genital'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
    --                     end
    --                 end
    --             end
    --         end
        
    --         function TestAllGenitalVecParameter()
    --             for _,v in ipairs(Parameters.Genital.Vector) do
    --                 local testSlider2 = treeTestParamsGenital_7640:AddSlider(v)
    --                 testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider2.OnChange = function()
    --                     for _, part in ipairs({'Genital'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
    --                     end
    --                 end
    --             end
    --         end
        
    --         TestAllGenitalScalarParameters()
    --         TestAllGenitalVec3Parameters()
    --         TestAllGenitalVecParameter()
        
    --     end

    --     function Tests:Tail()

    --         local testParamsTail = testParams:AddTree('Tail')
    --         local treeTestParamsTail_8732 = testParamsTail:AddTree('Scalar')
    --         local treeTestParamsTail_3281 = testParamsTail:AddTree('Vec3')
    --         local treeTestParamsTail_9017 = testParamsTail:AddTree('Vec')
        
    --         if Parameters.Tail then

    --         function TestAllTailScalarParameters()
    --             for _,v in ipairs(Parameters.Tail.Scalar) do
    --                 local testSlider = treeTestParamsTail_8732:AddSliderInt(v, 0, -100, 100)
    --                 testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider.OnChange = function()
    --                     for _, part in ipairs({'Tail'}) do
    --                         ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
    --                     end
    --                 end
    --             end
    --         end
        
    --         function TestAllTailVec3Parameters()
    --             for _,v in ipairs(Parameters.Tail.Vector3) do
    --                 local testPicker = treeTestParamsTail_3281:AddColorEdit(v)
    --                 testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testPicker.OnChange = function()
    --                     for _, part in ipairs({'Tail'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
    --                     end
    --                 end
    --             end
    --         end
        
    --         function TestAllTailVecParameter()
    --             for _,v in ipairs(Parameters.Tail.Vector) do
    --                 local testSlider2 = treeTestParamsTail_9017:AddSlider(v)
    --                 testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider2.OnChange = function()
    --                     for _, part in ipairs({'Tail'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
    --                     end
    --                 end
    --             end
    --         end
        
    --         TestAllTailScalarParameters()
    --         TestAllTailVec3Parameters()
    --         TestAllTailVecParameter()
    --         end
    --     end

    --     function Tests:Horns()

    --         local testParamsHorns = testParams:AddTree('Horns')
    --         local treeTestParamsHorns_4472 = testParamsHorns:AddTree('Scalar')
    --         local treeTestParamsHorns_9823 = testParamsHorns:AddTree('Vec3')
    --         local treeTestParamsHorns_3106 = testParamsHorns:AddTree('Vec')
            
    --         if Parameters.Horns then

    --         function TestAllHornsScalarParameters()
    --             for _,v in ipairs(Parameters.Horns.Scalar) do
    --                 local testSlider = treeTestParamsHorns_4472:AddSliderInt(v, 0, -100, 100)
    --                 testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider.OnChange = function()
    --                     for _, part in ipairs({'Horns'}) do
    --                         ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
    --                     end
    --                 end
    --             end
    --         end
        
    --         function TestAllHornsVec3Parameters()
    --             for _,v in ipairs(Parameters.Horns.Vector3) do
    --                 local testPicker = treeTestParamsHorns_9823:AddColorEdit(v)
    --                 testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testPicker.OnChange = function()
    --                     for _, part in ipairs({'Horns'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
    --                     end
    --                 end
    --             end
    --         end
        
    --         function TestAllHornsVecParameter()
    --             for _,v in ipairs(Parameters.Horns.Vector) do
    --                 local testSlider2 = treeTestParamsHorns_3106:AddSlider(v)
    --                 testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --                 testSlider2.OnChange = function()
    --                     for _, part in ipairs({'Horns'}) do
    --                         ApplyParameters(_C(), part, v, 'Vector', testSlider2.Value[1])
    --                     end
    --                 end
    --             end
    --         end
        
    --         TestAllHornsScalarParameters()
    --         TestAllHornsVec3Parameters()
    --         TestAllHornsVecParameter()
    --         end
    --     end

    --     Tests:Body()
    --     Tests:Head()  
    --     Tests:Genital()
    --     Tests:Tail()
    --     Tests:Horns()



    -- end

    -- local forceBtn = parent:AddButton('Force load')
    -- forceBtn.OnClick = function ()
    --     Ext.Net.PostMessageToServer('ForceLoad', '')

    --     testParams:Destroy()

    -- end
