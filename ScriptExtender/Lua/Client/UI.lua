



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


    function FindAttachment(attachment)
        for i = 1, #_C().Visual.Visual.Attachments do
            if _C().Visual.Visual.Attachments[i].Visual.VisualResource and _C().Visual.Visual.Attachments[i].Visual.VisualResource.Template:lower():find(attachment) then
                local visuals = _C().Visual.Visual.Attachments[i].Visual
                return visuals
            end
        end
    end


    function Vector3Value(visuals, type, value)

        for _,desc in pairs(visuals.ObjectDescs) do
            local am = desc.Renderable.ActiveMaterial
            if am ~= nil and am.Material ~= nil then
                for _, param in pairs(am.Material.Parameters.Vector3Parameters) do
                        am:SetVector3(type, {value[1], value[2], value[3]})
                end
             end
        end

    end

    function ScalarValue(visuals, type, value)

        for _,desc in pairs(visuals.ObjectDescs) do
            local am = desc.Renderable.ActiveMaterial
            if am ~= nil and am.Material ~= nil then
                for _, param in pairs(am.Material.Parameters.ScalarParameters) do
                        am:SetScalar(type, value)
                end
             end
        end

    end

    
    function Vector4Value(visuals, type, value)

        for _,desc in pairs(visuals.ObjectDescs) do
            local am = desc.Renderable.ActiveMaterial
            if am ~= nil and am.Material ~= nil then
                for _, param in pairs(am.Material.Parameters.VectorParameters) do
                    local defValue = am.Material.Parameters.VectorParameters[1].Value
                    DDump(am.Material.Parameters.VectorParameters[1].Value)
                        am:SetVector4(type, {defValue[1], defValue[2] , value, defValue[4]})
                end
             end
        end

    end



    local picker = parent:AddColorPicker('xd')
    picker.OnChange = function ()
        Vector3Value(FindAttachment('head'), 'MelaninColor', picker.Color)
    end

    local slider = parent:AddSliderInt('tatindex', 1,0,300)
    slider.OnChange = function ()
        ScalarValue(FindAttachment('head'), 'TattooIndex', slider.Value[1])
    end


    local picker2 = parent:AddColorPicker('xd2')
    picker2.OnChange = function ()
        Vector3Value(FindAttachment('head'), 'TattooColorB', picker2.Color)
    end

    local slider2 = parent:AddSlider('tatint', 1,0,1)
    slider2.OnChange = function ()
        ScalarValue(FindAttachment('head'), 'AdditionalTattooIntensity', slider2.Value[1])
        Vector4Value(FindAttachment('head'), 'TattooIntensity', slider2.Value[1])
    end


    function ModVarsTest()
        
    end

end

UI:Init()
