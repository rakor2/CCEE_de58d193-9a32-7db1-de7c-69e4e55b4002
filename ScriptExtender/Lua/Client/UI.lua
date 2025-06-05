



------------------------------------
--[[
TODO:
REMOVE SOME SELFS
PERHAPS FIX TAGS AND SCALING
]]
------------------------------------



UI = {}
Window = {}

local OPENONRESETQUESTIONMARK = true


function UI:Init()
    self.MCM = Window:CCEEMCM()
    self.Window = Window:CCEEWindow()
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



    local picker = parent:AddColorPicker('Melanin color')
    picker.OnChange = function()
        ApplyParameters('head', 'MelaninColor', 'Vector3', picker.Color)
        ApplyParameters('body', 'MelaninColor', 'Vector3', picker.Color)
    end

    local slider = parent:AddSliderInt('tatindex', 1,0, tattooCount)
    slider.OnChange = function()
        ApplyParameters('head', 'TattooIndex', 'Scalar', slider.Value[1])
    end


    local picker2 = parent:AddColorPicker('xd2')
    picker2.OnChange = function()
        ApplyParameters('head', 'TattooColorB', 'Vector3', picker2.Color)
    end

    local slider2 = parent:AddSlider('tatint', 1,0,1)
    slider2.OnChange = function()
        ApplyParameters('head', 'TattooIntensity', 'Vector4', slider2.Value[1])
    end


    function ModVarsTest()
        
    end

end

UI:Init()
