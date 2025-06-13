UI = {}
Window = {}
Skin = {}
Tattoo = {}
Tests = {}
Head = {}
Hair = {}
Body = {}

local OPENQUESTIONMARK = true


function UI:Init()
    Window:CCEEMCM()
    Window:CCEEWindow()
    GetAllParameterNames(_C())
    Skin:Color()
    Head:Face()
    Head:Head()
    Body:Body()
    Hair:Hair()
    Tests:Tests()
end

--THIS when mapped Gladge
-- Ext.Events.OnComponentCreated:Subscribe("eoc::photo_mode::SessionComponent",function ()
--     DPrint('PM')
-- end)


function GetKeybind(type, index) --BindingIndex = 1 - keyborad / BindingIndex = 0 - controller
    for _, bind in pairs(Ext.Input.GetInputManager().InputScheme.RawToBinding) do
        for i = 1, 2 do
            if bind.Bindings[i] and bind.Bindings[i].BindingIndex == type and bind.Bindings[i].InputIndex == index then 
                local keybind = bind.Bindings[i].Binding.InputId
                return keybind
            end
        end
    end
end

KeybindingManager:Bind({
    ScanCode = tostring(GetKeybind(1,320)):upper(),
    Callback = function()

        Helpers.Timer:OnTicks(30, function ()
        --no double calls on my watch
        local s, _ = pcall(function()
            return Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.DOFStrength
        end)

            if s then
                ApplyParametersToDummies()
            end

        end)

     end,
})




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


    local resetTableBtn = p:AddButton('Reset all saved data')
    resetTableBtn.SameLine = true
    resetTableBtn.OnClick = function ()
        Helpers.ModVars:Get(ModuleUUID).CCEE = {}
    end

    local updateParamTable = p:AddButton('Update params')
    updateParamTable.SameLine = true
    updateParamTable.OnClick = function ()
        GetAllParameterNames(_C())
    end


    local applyDummy = p:AddButton('Apply in PM (just in case)')
    applyDummy.OnClick = function ()
        ApplyParametersToDummies()
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


    function Skin:Color()

        local skinColorCollapse = p:AddCollapsingHeader('Skin')
        
        local sepa1 = skinColorCollapse:AddSeparatorText('Melanin')

        pickerMelaninC = skinColorCollapse:AddColorEdit('Color')
        pickerMelaninC.Float = true
        pickerMelaninC.NoAlpha = true
        pickerMelaninC.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'MelaninColor', 'Vector3', pickerMelaninC.Color)
            end
        end

        sliderMelaninA = skinColorCollapse:AddSlider('Amount')
        sliderMelaninA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'MelaninAmount', 'Scalar', sliderMelaninA.Value[1])
            end
        end


        sliderMelaninRA = skinColorCollapse:AddSlider('Removal amount', 0, 0, 100, 1)
        sliderMelaninRA.Logarithmic = true
        sliderMelaninRA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'MelaninRemovalAmount', 'Scalar', sliderMelaninRA.Value[1])
            end
        end

        
        sliderMelaninDM = skinColorCollapse:AddSlider('Dark multiplier', 0, 0, 100, 1)
        sliderMelaninDM.Logarithmic = true
        sliderMelaninDM.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'MelaninDarkMultiplier', 'Scalar', sliderMelaninDM.Value[1])
            end
        end

        sliderMelaninDT = skinColorCollapse:AddSlider('Dark threshold', 0, 0, 1, 0)
        sliderMelaninDT.Logarithmic = true
        sliderMelaninDT.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'MelaninDarkThreshold', 'Scalar', sliderMelaninDT.Value[1])
            end
        end


        local sepa2 = skinColorCollapse:AddSeparatorText('Hemoglobin')


        pickerHemoglobinnC = skinColorCollapse:AddColorEdit('Color')
        pickerHemoglobinnC.IDContext = 'pickerHemoglobinnCasdasd'
        pickerHemoglobinnC.Float = true
        pickerHemoglobinnC.NoAlpha = true
        pickerHemoglobinnC.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'HemoglobinColor', 'Vector3', pickerHemoglobinnC.Color)
            end
        end


        sliderHemoglobinnA = skinColorCollapse:AddSlider('Amount', 0, 0, 3, 0)
        sliderHemoglobinnA.IDContext = 'sliderHemoglobinnAasdasd'
        sliderHemoglobinnA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'HemoglobinAmount', 'Scalar', sliderHemoglobinnA.Value[1])
            end
        end

        local sepa3 = skinColorCollapse:AddSeparatorText('Yellowing')


        pickerYellowingC = skinColorCollapse:AddColorEdit('Color')
        pickerYellowingC.IDContext = 'yellllCasdasd'
        pickerYellowingC.Float = true
        pickerYellowingC.NoAlpha = true
        pickerYellowingC.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'YellowingColor', 'Vector3', pickerYellowingC.Color)
            end
        end


        pickerYellowingA = skinColorCollapse:AddSlider('Amount', 0, -300, 300, 0)
        pickerYellowingA.IDContext = 'yellAasdasd'
        pickerYellowingA.Logarithmic = true
        pickerYellowingA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'YellowingAmount', 'Scalar', pickerYellowingA.Value[1])
            end
        end

        
        local sepa4 = skinColorCollapse:AddSeparatorText('Vein')


        pickerVeinC = skinColorCollapse:AddColorEdit('Color')
        pickerVeinC.IDContext = 'VeinCasdasd'
        pickerVeinC.Float = true
        pickerVeinC.NoAlpha = true
        pickerVeinC.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'VeinColor', 'Vector3', pickerVeinC.Color)
            end
        end


        slVeinA = skinColorCollapse:AddSlider('Amount', 0, 0, 7, 0)
        slVeinA.IDContext = 'yveveAasdasd'
        slVeinA.OnChange = function()
            for _, attachment in ipairs({'Head', 'Body', 'Genital', 'Tail'}) do
                SaveAndApply(_C(), attachment, 'VeinAmount', 'Scalar', slVeinA.Value[1])
            end
        end

    end

    function Head:Face()

        local faceCollapse = p:AddCollapsingHeader('Face')

        local sepa6 = faceCollapse:AddSeparatorText('Eyes makeup')

        slMakeupInd = faceCollapse:AddSliderInt('Index', 0, 0, makeupCount, 0)
        slMakeupInd.IDContext = 'makeupIntasdasdasd'
        slMakeupInd.OnChange = function()

            SaveAndApply(_C(), 'Head', 'MakeUpIndex', 'Scalar', slMakeupInd.Value[1])

        end

        pickMakeupC = faceCollapse:AddColorEdit('Color')
        pickMakeupC.IDContext = 'makeupCasd'
        pickMakeupC.Float = true
        pickMakeupC.NoAlpha = true
        pickMakeupC.OnChange = function()
            SaveAndApply(_C(), 'Head', 'MakeupColor', 'Vector3', pickMakeupC.Color)
        end



        slMakeupInt = faceCollapse:AddSlider('Intensity', 0, 0, 5, 0)
        slMakeupInt.IDContext = 'makeupIntasdasdasd'
        slMakeupInt.OnChange = function()

            SaveAndApply(_C(), 'Head', 'MakeupIntensity', 'Scalar', slMakeupInt.Value[1])

        end

        slMakeupM = faceCollapse:AddSlider('Metalness', 0, 0, 1, 0)
        slMakeupM.IDContext = 'makeupMad2q3123'
        slMakeupM.OnChange = function()

            SaveAndApply(_C(), 'Head', 'EyesMakeupMetalness', 'Scalar', slMakeupM.Value[1])

        end

        slMakeupR = faceCollapse:AddSlider('Roughness', 0, -1, 1, 0)
        slMakeupR.IDContext = 'makeupRasdasd'
        slMakeupR.OnChange = function()

            SaveAndApply(_C(), 'Head', 'MakeupRoughness', 'Scalar', slMakeupR.Value[1])

        end

        local sepa7 = faceCollapse:AddSeparatorText('Lips makeup')

        pickMakeupLC = faceCollapse:AddColorEdit('Color')
        pickMakeupLC.IDContext = 'makeupLCadasd'
        pickMakeupLC.Float = true
        pickMakeupLC.NoAlpha = true
        pickMakeupLC.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Lips_Makeup_Color', 'Vector3', pickMakeupLC.Color)
        end


        slMakeupLInt = faceCollapse:AddSlider('Intensity', 0, 0, 5, 0)
        slMakeupLInt.IDContext = 'makeupLInt2133123'
        slMakeupLInt.OnChange = function()

            SaveAndApply(_C(), 'Head', 'LipsMakeupIntensity', 'Scalar', slMakeupLInt.Value[1])

        end

        slMakeupLM = faceCollapse:AddSlider('Metalness', 0, 0, 1, 0)
        slMakeupLM.IDContext = 'makeupLM123sfasdf'
        slMakeupLM.OnChange = function()

            SaveAndApply(_C(), 'Head', 'LipsMakeupMetalness', 'Scalar', slMakeupLM.Value[1])

        end

        slMakeupLR = faceCollapse:AddSlider('Roughness', 0, -1, 1, 0)
        slMakeupLR.IDContext = 'makeupLRasd'
        slMakeupLR.OnChange = function()

            SaveAndApply(_C(), 'Head', 'LipsMakeupRoughness', 'Scalar', slMakeupLR.Value[1])

        end


        local sepa8 = faceCollapse:AddSeparatorText('Tattoo')

        
        slFTatM = faceCollapse:AddSliderInt('Index', 0, 0, tattooCount, 0)
        slFTatM.IDContext = 'fTatM1233444'
        slFTatM.OnChange = function()

            SaveAndApply(_C(), 'Head', 'TattooIndex', 'Scalar', slFTatM.Value[1])

        end

        pcikFTatCR = faceCollapse:AddColorEdit('Color R')
        pcikFTatCR.IDContext = 'fTatCr123123'
        pcikFTatCR.Float = true
        pcikFTatCR.NoAlpha = true
        pcikFTatCR.OnChange = function()
            SaveAndApply(_C(), 'Head', 'TattooColor', 'Vector3', pcikFTatCR.Color)
        end

        pickFTatCG = faceCollapse:AddColorEdit('Color G')
        pickFTatCG.IDContext = 'fTatCg123123'
        pickFTatCG.Float = true
        pickFTatCG.NoAlpha = true
        pickFTatCG.OnChange = function()
            SaveAndApply(_C(), 'Head', 'TattooColorG', 'Vector3', pickFTatCG.Color)
        end

        pickFTatCB = faceCollapse:AddColorEdit('Color B')
        pickFTatCB.IDContext = 'fTatCb123123'
        pickFTatCB.Float = true
        pickFTatCB.NoAlpha = true
        pickFTatCB.OnChange = function()
            SaveAndApply(_C(), 'Head', 'TattooColorB', 'Vector3', pickFTatCB.Color)
        end


        slFTatIntR = faceCollapse:AddSlider('Intensity R', 0, -5, 5, 0)
        slFTatIntR.IDContext = 'fTatInta213'
        slFTatIntR.OnChange = function()

            SaveAndApply(_C(), 'Head', 'TattooIntensity', 'Vector_1', slFTatIntR.Value[1])

        end


        slFTatIntG = faceCollapse:AddSlider('Intensity G', 0, -5, 5, 0)
        slFTatIntG.IDContext = 'fTatInta213'
        slFTatIntG.OnChange = function()

            SaveAndApply(_C(), 'Head', 'TattooIntensity', 'Vector_2', slFTatIntG.Value[1])

        end

        slFTatIntB = faceCollapse:AddSlider('Intensity B', 0, -5, 5, 0)
        slFTatIntB.IDContext = 'fTatInta213'
        slFTatIntB.OnChange = function()

            SaveAndApply(_C(), 'Head', 'TattooIntensity', 'Vector_3', slFTatIntB.Value[1])

        end

        slFTatMet = faceCollapse:AddSlider('Metalness', 0, 0, 1, 0)
        slFTatMet.IDContext = 'fTatMet'
        slFTatMet.OnChange = function()

            SaveAndApply(_C(), 'Head', 'TattooMetalness', 'Scalar', slFTatMet.Value[1])

        end

        slFTatR = faceCollapse:AddSlider('Roughness', 0, -1, 1, 0)
        slFTatR.IDContext = 'fTatRfas'
        slFTatR.OnChange = function()

            SaveAndApply(_C(), 'Head', 'TattooRoughnessOffset', 'Scalar', slFTatR.Value[1])

        end


        slFTatCurve = faceCollapse:AddSlider('Curvature influence', 0, 0, 100, 0)
        slFTatCurve.IDContext = 'fTatCurveasdas'
        slFTatCurve.OnChange = function()

            SaveAndApply(_C(), 'Head', 'TattooCurvatureInfluence', 'Scalar', slFTatCurve.Value[1])

        end

        local sepa9 = faceCollapse:AddSeparatorText('Scars')

        slFScar = faceCollapse:AddSliderInt('Index', 0, 0, scarCount, 0)
        slFScar.IDContext = 'fScar'
        slFScar.OnChange = function()

            SaveAndApply(_C(), 'Head', 'ScarIndex', 'Scalar', slFScar.Value[1])

        end

        slFScarW = faceCollapse:AddSlider('Intensity', 0, -10, 10, 0)
        slFScarW.IDContext = 'fScarW'
        slFScarW.OnChange = function()

            SaveAndApply(_C(), 'Head', 'Scar_Weight', 'Scalar', slFScarW.Value[1])

        end

        
        local sepa10 = faceCollapse:AddSeparatorText('Age')

        slFAgeW = faceCollapse:AddSlider('Intensity', 0, -10, 10, 0)
        slFAgeW.IDContext = 'fAgeW'
        slFAgeW.Logarithmic = true
        slFAgeW.OnChange = function()

            SaveAndApply(_C(), 'Head', 'Age_Weight', 'Scalar', slFAgeW.Value[1])

        end

                
        local sepa11 = faceCollapse:AddSeparatorText('Scales')

        slFScaleI = faceCollapse:AddSliderInt('Index', 0, 0, 31, 0)
        slFScaleI.IDContext = 'fCustI'
        slFScaleI.OnChange = function()

            SaveAndApply(_C(), 'Head', 'CustomIndex', 'Scalar', slFScaleI.Value[1])

        end

        pickFScaleC = faceCollapse:AddColorEdit('Color')
        pickFScaleC.IDContext = 'fTatCg123123'
        pickFScaleC.Float = true
        pickFScaleC.NoAlpha = true
        pickFScaleC.OnChange = function()
            SaveAndApply(_C(), 'Head', 'CustomColor', 'Vector3', pickFScaleC.Color)
        end

        slFScaleInt = faceCollapse:AddSlider('Intensity', 0, -10, 10, 0)
        slFScaleInt.IDContext = 'fScaleInt'
        slFScaleInt.OnChange = function()

            SaveAndApply(_C(), 'Head', 'CustomIntensity', 'Scalar', slFScaleInt.Value[1])

        end


    end

    function Head:Head()
        

        local headCollapse = p:AddCollapsingHeader('Head')

        local sepa8 = headCollapse:AddSeparatorText('Eyes')

        --[[
            Vecr3
                AddedColor - tearline
        ]]
        
        slEyesHet = headCollapse:AddSliderInt('Heterochromia', 0, 0, 1, 0)
        slEyesHet.IDContext = 'eyesHetasds'
        slEyesHet.Disabled = false
        slEyesHet.OnChange = function()

            SaveAndApply(_C(), 'Head', 'Heterochromia', 'Scalar', slEyesHet.Value[1])

        end


        slEyesBR = headCollapse:AddSlider('Blindness R', 0, 0, 3, 0)
        slEyesBR.IDContext = 'eyesHetasds'
        slEyesBR.OnChange = function()

            SaveAndApply(_C(), 'Head', 'Blindness', 'Scalar', slEyesBR.Value[1])

        end

        slEyesBL = headCollapse:AddSlider('Blindness L', 0, 0, 3, 0)
        slEyesBL.IDContext = 'eyesHetasds'
        slEyesBL.OnChange = function()

            SaveAndApply(_C(), 'Head', 'Blindness_L', 'Scalar', slEyesBL.Value[1])

        end

        pickEyesC = headCollapse:AddColorEdit('Iris color 1')
        pickEyesC.IDContext = 'eyesCasfbfdgftyu7yi9'
        pickEyesC.Float = true
        pickEyesC.NoAlpha = true
        pickEyesC.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyes_IrisColour', 'Vector3', pickEyesC.Color)
        end

        pickEyesCL = headCollapse:AddColorEdit('Iris color 1 L')
        pickEyesCL.IDContext = 'eyesCL123123'
        pickEyesCL.Float = true
        pickEyesCL.NoAlpha = true
        pickEyesCL.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyes_IrisColour_L', 'Vector3', pickEyesCL.Color)
        end

        pickEyesC2 = headCollapse:AddColorEdit('Iris color 2')
        pickEyesC2.IDContext = 'eyesC2asdfsdfwer'
        pickEyesC2.Float = true
        pickEyesC2.NoAlpha = true
        pickEyesC2.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyes_IrisSecondaryColour', 'Vector3', pickEyesC2.Color)
        end

        pickEyesC2L = headCollapse:AddColorEdit('Iris color 2 L')
        pickEyesC2L.IDContext = 'eyesC2Lsdfsdfwefwrwe'
        pickEyesC2L.Float = true
        pickEyesC2L.NoAlpha = true
        pickEyesC2L.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyes_IrisSecondaryColour_L', 'Vector3', pickEyesC2L.Color)
        end

        pickEyesSC = headCollapse:AddColorEdit('Sclera color')
        pickEyesSC.IDContext = 'eyesSC1231235erdfg'
        pickEyesSC.Float = true
        pickEyesSC.NoAlpha = true
        pickEyesSC.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyes_ScleraColour', 'Vector3', pickEyesSC.Color)
        end

        pickEyesSCL = headCollapse:AddColorEdit('Sclera color L')
        pickEyesSCL.IDContext = 'eyesCR'
        pickEyesSCL.Float = true
        pickEyesSCL.NoAlpha = true
        pickEyesSCL.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Eyes_ScleraColour_L', 'Vector3', pickEyesSCL.Color)
        end



        slEyesCI = headCollapse:AddSlider('Iris color int', 0, -100, 100, 0)
        slEyesCI.IDContext = 'eyes2CRasadasd'
        slEyesCI.Logarithmic = true
        slEyesCI.OnChange = function()
            SaveAndApply(_C(), 'Head', 'SecondaryColourIntensity', 'Scalar', slEyesCI.Value[1])
        end


        slEyesCIL = headCollapse:AddSlider('Iris color int L', 0, -100, 100, 0)
        slEyesCIL.IDContext = 'eyes2CLa123'
        slEyesCIL.OnChange = function()
            SaveAndApply(_C(), 'Head', 'SecondaryColourIntensity_L', 'Scalar', slEyesCIL.Value[1])
        end


        slEyesEdge = headCollapse:AddSlider('IrisEdgeStrength', 0, -100, 100, 0)
        slEyesEdge.IDContext = 'eyesEdge'
        slEyesEdge.Logarithmic = true
        slEyesEdge.OnChange = function()
            SaveAndApply(_C(), 'Head', 'IrisEdgeStrength', 'Scalar', slEyesEdge.Value[1])
        end


        slEyesEdgeL = headCollapse:AddSlider('IrisEdgeStrength L', 0, -100, 100, 0)
        slEyesEdgeL.IDContext = 'eyesEdgeL'
        slEyesEdgeL.OnChange = function()
            SaveAndApply(_C(), 'Head', 'IrisEdgeStrength_L', 'Scalar', slEyesEdgeL.Value[1])
        end



        slEyesRed = headCollapse:AddSlider('Redness', 0, 0, 100, 0)
        slEyesRed.IDContext = 'eyesRed'
        slEyesRed.Logarithmic = true
        slEyesRed.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Redness', 'Scalar', slEyesRed.Value[1])
        end


        slEyesRedL = headCollapse:AddSlider('Redness L', 0, 0, 100, 0)
        slEyesRedL.IDContext = 'eyesRedL'
        slEyesRedL.OnChange = function()
            SaveAndApply(_C(), 'Head', 'Redness_L', 'Scalar', slEyesRedL.Value[1])
        end
        

        -- local eyes2CL = headCollapse:AddSlider('Iris color int L', 0, -100, 100, 0)
        -- eyes2CL.IDContext = 'eyes2CLa123'
        -- eyes2CL.OnChange = function()
        --     ApplyParameters(_C(), 'Head', 'SecondaryColourIntensity_L', 'Scalar', eyes2CL.Value[1])
        -- end
        

    end

    function Body:Body()

        local bodyCollapse = p:AddCollapsingHeader('Body')

        local sepa14 = bodyCollapse:AddSeparatorText('Tattoo')

        
        slBTatI = bodyCollapse:AddSliderInt('Index', 0, 0, tattooCount, 0)
        slBTatI.IDContext = 'slBTatI'
        slBTatI.OnChange = function()

            SaveAndApply(_C(), 'Body', 'BodyTattooIndex', 'Scalar', slBTatI.Value[1])

        end

        pickBTatCR = bodyCollapse:AddColorEdit('Color R')
        pickBTatCR.IDContext = 'bTatCR'
        pickBTatCR.Float = true
        pickBTatCR.NoAlpha = true
        pickBTatCR.OnChange = function()
            SaveAndApply(_C(), 'Body', 'BodyTattooColor', 'Vector3', pickBTatCR.Color)
        end

        pickBTatCG = bodyCollapse:AddColorEdit('Color G')
        pickBTatCG.IDContext = 'bTatCG'
        pickBTatCG.Float = true
        pickBTatCG.NoAlpha = true
        pickBTatCG.OnChange = function()
            SaveAndApply(_C(), 'Body', 'BodyTattooColorG', 'Vector3', pickBTatCG.Color)
        end

        pickBTatCB = bodyCollapse:AddColorEdit('Color B')
        pickBTatCB.IDContext = 'bTatCB'
        pickBTatCB.Float = true
        pickBTatCB.NoAlpha = true
        pickBTatCB.OnChange = function()
            SaveAndApply(_C(), 'Body', 'BodyTattooColorB', 'Vector3', pickBTatCB.Color)
        end


        slBTatIntR = bodyCollapse:AddSlider('Intensity R', 0, -5, 5, 0)
        slBTatIntR.IDContext = 'bTatIntR'
        slBTatIntR.OnChange = function()

            SaveAndApply(_C(), 'Body', 'BodyTattooIntensity', 'Vector_1', slBTatIntR.Value[1])

        end


        slBTatIntG = bodyCollapse:AddSlider('Intensity G', 0, -5, 5, 0)
        slBTatIntG.IDContext = 'bTatIntG'
        slBTatIntG.OnChange = function()

            SaveAndApply(_C(), 'Body', 'BodyTattooIntensity', 'Vector_2', slBTatIntG.Value[1])

        end

        slBTatIntB = bodyCollapse:AddSlider('Intensity B', 0, -5, 5, 0)
        slBTatIntB.IDContext = 'bTatIntB'
        slBTatIntB.OnChange = function()

            SaveAndApply(_C(), 'Body', 'BodyTattooIntensity', 'Vector_3', slBTatIntB.Value[1])

        end

        slBTatMet = bodyCollapse:AddSlider('Metalness', 0, 0, 1, 0)
        slBTatMet.IDContext = 'bTatMet'
        slBTatMet.OnChange = function()

            SaveAndApply(_C(), 'Body', 'TattooMetalness', 'Scalar', slBTatMet.Value[1])

        end

        slBTatR = bodyCollapse:AddSlider('Roughness', 0, -1, 1, 0)
        slBTatR.IDContext = 'bTatR'
        slBTatR.OnChange = function()

            SaveAndApply(_C(), 'Body', 'TattooRoughnessOffset', 'Scalar', slBTatR.Value[1])

        end


        slBTatCurve = bodyCollapse:AddSlider('Curvature influence', 0, 0, 100, 0)
        slBTatCurve.IDContext = 'fTatCurve'
        slBTatCurve.OnChange = function()

            SaveAndApply(_C(), 'Body', 'TattooCurvatureInfluence', 'Scalar', slBTatCurve.Value[1])

        end
    end

    function Hair:Hair()

        --[[
            Scalar
                "Scalp_MinValue",
                "Scalp_HornMaskWeight",
                "Scalp_Graying_Intensity",
                "Scalp_ColorTransitionMidPoint",
                "Scalp_ColorTransitionSoftness",
                "Scalp_DepthColorExponent",
                "Scalp_DepthColorIntensity",
                "Scalp_IDContrast",
                "Scalp_ColorDepthContrast",
                "Scalp_Roughness",
                "Scalp_RoughnessContrast",
                "Scalp_Scatter",

            Vec3
                "Hair_Scalp_Color",
                "Hair_Scalp_Graying_Color",
                "Scalp_HueShiftColorWeight",
                "Beard_Scalp_Color"
        ]]

        local hairCollapse = p:AddCollapsingHeader('Hair')

        local sepa12 = hairCollapse:AddSeparatorText('Eyebrow')


        pickEyeBC = hairCollapse:AddColorEdit('Color')
        pickEyeBC.IDContext = 'eyeBC'
        pickEyeBC.Float = true
        pickEyeBC.NoAlpha = true
        pickEyeBC.OnChange = function()

            SaveAndApply(_C(), 'Head', 'Eyebrow_Color', 'Vector3', pickEyeBC.Color)

        end

        local sepa13 = hairCollapse:AddSeparatorText('Eyelashes')

        pcikEyeLC = hairCollapse:AddColorEdit('Color')
        pcikEyeLC.IDContext = 'eyeLC'
        pcikEyeLC.Float = true
        pcikEyeLC.NoAlpha = true
        pcikEyeLC.OnChange = function()

            SaveAndApply(_C(), 'Head', 'Eyelashes_Color', 'Vector3', pcikEyeLC.Color)

        end


    end

    function Tests:Tests()

        local parent = p

        testParams = parent:AddCollapsingHeader('Tests')

        function Tests:Body()

            local testParamsBody = testParams:AddTree('Body')
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
                for _,v in ipairs(Parameters.Genital.Scalar) do
                    local testSlider = treeTestParamsGenital_5821:AddSliderInt(v, 0, -100, 100)
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        for _, part in ipairs({'Genital'}) do
                            ApplyParameters(_C(), part, v, 'Scalar', testSlider.Value[1])
                        end
                    end
                end
            end
        
            function TestAllGenitalVec3Parameters()
                for _,v in ipairs(Parameters.Genital.Vector3) do
                    local testPicker = treeTestParamsGenital_1293:AddColorEdit(v)
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        for _, part in ipairs({'Genital'}) do
                            ApplyParameters(_C(), part, v, 'Vector3', testPicker.Color)
                        end
                    end
                end
            end
        
            function TestAllGenitalVecParameter()
                for _,v in ipairs(Parameters.Genital.Vector) do
                    local testSlider2 = treeTestParamsGenital_7640:AddSlider(v)
                    testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider2.OnChange = function()
                        for _, part in ipairs({'Genital'}) do
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



   

    -- local forceBtn = parent:AddButton('Force load')
    -- forceBtn.OnClick = function ()
    --     Ext.Net.PostMessageToServer('ForceLoad', '')

    --     testParams:Destroy()

    -- end
