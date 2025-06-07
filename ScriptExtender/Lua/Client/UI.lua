UI = {}
Window = {}
Skin = {}
Tattoo = {}
Tests = {}


local OPENONRESETQUESTIONMARK = true


function UI:Init()
    self.MCM = Window:CCEEMCM()
    cceeWindow = Window:CCEEWindow()
    -- self.SkinColor =  Skin:Color()
    -- self.TattooParams = Tattoo:Parameters()
    -- self.Tests = Tests:Tests()
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

    local cceeWindow = Ext.IMGUI.NewWindow("CCEE")
    cceeWindow.Open = OPENONRESETQUESTIONMARK
    cceeWindow.Closeable = true
    cceeWindow.AlwaysAutoResize = false
    cceeWindow:SetSize({643, 700})
    -- self.Window.HorizontalScrollbar = true
    -- self.Window.AlwaysVerticalScrollbar = true
    -- self.Window.NoDecoration = true


    StyleV2:RegisterWindow(cceeWindow)

    ApplyStyle(cceeWindow, 1)

    parent = cceeWindow

    MCM.SetKeybindingCallback('ccee_toggle_window', function()
        cceeWindow.Open = not cceeWindow.Open
    end)


    function Skin:Color()

        local skinColorCollapse = parent:AddCollapsingHeader('Skin color')
        
        local picker = skinColorCollapse:AddColorPicker('Melanin color')
        picker.OnChange = function()
            for _, part in ipairs({'Head', 'Body', 'Genital', 'Tail', 'Horns'}) do
                ApplyParameters(part, 'MelaninColor', 'Vector3', picker.Color)
            end
        end


        local picker = skinColorCollapse:AddColorPicker('Melanin color')
        picker.OnChange = function()
            for _, part in ipairs({'Head', 'Body', 'Genital', 'Tail', 'Horns'}) do
                ApplyParameters(part, 'MelaninColor', 'Vector3', picker.Color)
            end
        end

    end


    function Tattoo:Parameters()

        local fTatsColorCollapse = parent:AddCollapsingHeader('Face tattoo')

        local slider = fTatsColorCollapse:AddSliderInt('Index', 1,0, tattooCount)
        slider.OnChange = function()
            ApplyParameters('Head', 'TattooIndex', 'Scalar', slider.Value[1])
        end


        local picker2 = fTatsColorCollapse:AddColorPicker('Color')
        picker2.OnChange = function()
            ApplyParameters('Head', 'TattooColorB', 'Vector3', picker2.Color)
        end
        
        local slider2 = fTatsColorCollapse:AddSlider('Intensity', 1,0,1)
        slider2.OnChange = function()
            ApplyParameters('Head', 'TattooIntensity', 'Vector', slider2.Value[1])
        end

        local picker3 = fTatsColorCollapse:AddColorPicker('Color2')
        picker3.OnChange = function()
            ApplyParameters('wpn', 'Glow_Color', 'Vector3', picker2.Color)
        end

    end


    function Tests:Tests()


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

            local testParamsHead = testParams:AddTree('Head')
            local treeTestParams4 = testParamsHead:AddTree('Scalar')
            local treeTestParams5 = testParamsHead:AddTree('Vec3')
            local treeTestParams6 = testParamsHead:AddTree('Vec')
    

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

            local testParamsGenital = testParams:AddTree('Genital')
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

            local testParamsTail = testParams:AddTree('Tail')
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

            local testParamsHorns = testParams:AddTree('Horns')
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

    local forceBtn = parent:AddButton('Force load')
    forceBtn.OnClick = function ()
        Ext.Net.PostMessageToServer('ForceLoad', '')

        testParams:Destroy()

    end



end

UI:Init()
