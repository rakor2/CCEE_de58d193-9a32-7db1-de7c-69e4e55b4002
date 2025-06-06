



------------------------------------
--[[
TODO:
REMOVE SOME SELFS
PERHAPS FIX TAGS AND SCALING
]]
------------------------------------



UI = {}
Window = {}
Skin = {}
Tattoo = {}
Tests = {}


local OPENONRESETQUESTIONMARK = true


function UI:Init()
    self.MCM = Window:CCEEMCM()
    self.Window = Window:CCEEWindow()
    self.SkinColor =  Skin:Color()
    self.TattooParams = Tattoo:Parameters()
    self.Tests = Tests:Tests()
end




function Window:CCEEMCM()

    local function CreateCCEEMCMTab(tab)

        local openButton = tab:AddButton("Open")
        openButton.OnClick = function()

            self.Window.Open = not self.Window.Open

        end
    end
    
    Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "CCEE", CreateCCEEMCMTab)

end



function Window:CCEEWindow()

    self.Window = Ext.IMGUI.NewWindow("CCEE")
    self.Window.Open = OPENONRESETQUESTIONMARK
    self.Window.Closeable = true
    self.Window.AlwaysAutoResize = false
    self.Window:SetSize({643, 700})
    -- self.Window.HorizontalScrollbar = true
    -- self.Window.AlwaysVerticalScrollbar = true
    -- self.Window.NoDecoration = true


    StyleV2:RegisterWindow(self.Window)

    ApplyStyle(self.Window, 1)

    parent = self.Window

    MCM.SetKeybindingCallback('ccee_toggle_window', function()
        self.Window.Open = not self.Window.Open
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


    end

    function Tests:Tests()

        local testParams = parent:AddCollapsingHeader('Tests')

        function Body()

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
                            ApplyParameters(part, v, 'Scalar', testSlider.Value[1])
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
                            ApplyParameters(part, v, 'Vector3', testPicker.Color)
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
                            ApplyParameters(part, v, 'Vector', testSlider2.Value[1])
                        end
                    end
                end
            end
    

            TestAllBodyScalarParameters()
            TestAllBodyVec3Parameters()
            TestAllBodyVecParameter()
    
        end

       
        function Head()

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
                            ApplyParameters(part, v, 'Scalar', testSlider.Value[1])
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
                            ApplyParameters(part, v, 'Vector3', testPicker.Color)
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
                            ApplyParameters(part, v, 'Vector', testSlider2.Value[1])
                        end
                    end
                end
            end


            TestAllHeadScalarParameters()
            TestAllHeadVec3Parameters()
            TestAllHeadVecParameter()

        end

    
        function Genital()
        end


        function Tail()
        end


        function Horns()
            
        end



        Body()
        Head()
        Genital()
        Tail()
        Horns()

    end
   

end

UI:Init()
