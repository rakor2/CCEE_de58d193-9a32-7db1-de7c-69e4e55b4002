StyleV2 = {
    Windows = {},
}


USER_FRIENDLY_MODE = 1


function StyleV2:UserFriendlyMode()
    self.ItemSpacingSlider.Visible = false
end

---Register window
---@param window
function StyleV2:RegisterWindow(window)
    table.insert(self.Windows, window)
end

function SaveStyle()
    local xd = xd
end

function LoadStyle()
    local xd = xd
end




function StyleV2:StyleV2Window()

    modName = Ext.Mod.GetMod(ModuleUUID).Info.Name
    randomID = Ext.Math.Random(1, 100000000) --just in case if there's no modName or whatever
    noInputs = true
    
    self.SettingsWindow = Ext.IMGUI.NewWindow(modName .. " " .. "StyleV2" .. "##" .. randomID)
    self.SettingsWindow.Open = false
    self.SettingsWindow.Closeable = true
    self.SettingsWindow.AlwaysAutoResize = true

    self.settingChildWindow = self.SettingsWindow:AddChildWindow("History")
    self.settingChildWindow.Size = {800, 800}


    -- StyleV2:RegisterWindow(self.SettingsWindow) --uncomment to apply parameters to this window



    local styleParent = self.settingChildWindow

    Ext.IMGUI.LoadFont("Font", "Mods/Walls_67558a78-0c92-d046-9ccd-36a482bc4b0c/GUI/QuadraatOffcPro.ttf", 35.0)


    local colorConfigs = {
        {property = "Text", label = "Text Color", default = {1.00, 1.00, 1.00, 1.00}},
        {property = "TextDisabled", label = "Text Disabled Color", default = {0.50, 0.50, 0.50, 1.00}},
        {property = "WindowBg", label = "Window Background", default = {0.08, 0.08, 0.08, 1.00}},
        {property = "ChildBg", label = "Child Background", default = {0.14, 0.14, 0.14, 1.00}},
        {property = "PopupBg", label = "Popup Background", default = {0.08, 0.08, 0.08, 1.00}},
        {property = "Border", label = "Border Color", default = {0.43, 0.43, 0.50, 0.50}},
        {property = "BorderShadow", label = "Border Shadow", default = {0.00, 0.00, 0.00, 0.00}},
        {property = "FrameBg", label = "Frame Background", default = {0.16, 0.29, 0.48, 0.54}},
        {property = "FrameBgHovered", label = "Frame Hovered", default = {0.26, 0.59, 0.98, 0.40}},
        {property = "FrameBgActive", label = "Frame Active", default = {0.26, 0.59, 0.98, 0.67}},
        {property = "TitleBg", label = "Title Background", default = {0.04, 0.04, 0.04, 1.00}},
        {property = "TitleBgActive", label = "Title Background Active", default = {0.16, 0.29, 0.48, 1.00}},
        {property = "TitleBgCollapsed", label = "Title Bg Collapsed", default = {0.00, 0.00, 0.00, 0.51}},
        {property = "MenuBarBg", label = "Menu Bar Bg", default = {0.14, 0.14, 0.14, 1.00}},
        {property = "ScrollbarBg", label = "Scrollbar Bg", default = {0.02, 0.02, 0.02, 0.53}},
        {property = "ScrollbarGrab", label = "Scrollbar Grab", default = {0.31, 0.31, 0.31, 1.00}},
        {property = "ScrollbarGrabHovered", label = "Scrollbar Grab Hovered", default = {0.41, 0.41, 0.41, 1.00}},
        {property = "ScrollbarGrabActive", label = "Scrollbar Grab Active", default = {0.51, 0.51, 0.51, 1.00}},
        {property = "CheckMark", label = "Check Mark", default = {0.26, 0.59, 0.98, 1.00}},
        {property = "SliderGrab", label = "Slider Grab", default = {0.24, 0.52, 0.88, 1.00}},
        {property = "SliderGrabActive", label = "Slider Grab Active", default = {0.26, 0.59, 0.98, 1.00}},
        {property = "Button", label = "Button", default = {0.26, 0.59, 0.98, 0.40}},
        {property = "ButtonHovered", label = "Button Hovered", default = {0.26, 0.59, 0.98, 1.00}},
        {property = "ButtonActive", label = "Button Active", default = {0.06, 0.53, 0.98, 1.00}},
        {property = "Header", label = "Header", default = {0.26, 0.59, 0.98, 0.31}},
        {property = "HeaderHovered", label = "Header Hovered", default = {0.26, 0.59, 0.98, 0.80}},
        {property = "HeaderActive", label = "Header Active", default = {0.26, 0.59, 0.98, 1.00}},
        {property = "Separator", label = "Separator", default = {0.43, 0.43, 0.50, 0.50}},
        {property = "SeparatorHovered", label = "Separator Hovered", default = {0.10, 0.40, 0.75, 0.78}},
        {property = "SeparatorActive", label = "Separator Active", default = {0.10, 0.40, 0.75, 1.00}},
        {property = "ResizeGrip", label = "Resize Grip", default = {0.26, 0.59, 0.98, 0.20}},
        {property = "ResizeGripHovered", label = "Resize Grip Hovered", default = {0.26, 0.59, 0.98, 0.67}},
        {property = "ResizeGripActive", label = "Resize Grip Active", default = {0.26, 0.59, 0.98, 0.95}},
        {property = "Tab", label = "Tab", default = {0.18, 0.35, 0.58, 0.86}},
        {property = "TabHovered", label = "Tab Hovered", default = {0.26, 0.59, 0.98, 0.80}},
        {property = "TabActive", label = "Tab Active", default = {0.20, 0.41, 0.68, 1.00}},
        {property = "TabUnfocused", label = "Tab Unfocused", default = {0.07, 0.10, 0.15, 0.97}},
        {property = "TabUnfocusedActive", label = "Tab Unfocused Active", default = {0.14, 0.26, 0.42, 1.00}},
        {property = "TableBorderStrong", label = "Table Border Strong", default = {0.31, 0.31, 0.35, 1.00}},
        {property = "TableBorderLight", label = "Table Border Light", default = {0.23, 0.23, 0.25, 1.00}},
        {property = "TableRowBg", label = "Table Row Bg", default = {0.00, 0.00, 0.00, 0.00}},
        {property = "TableRowBgAlt", label = "Table Row Bg Alt", default = {1.00, 1.00, 1.00, 0.06}},
        {property = "TextSelectedBg", label = "Text Selected Bg", default = {0.26, 0.59, 0.98, 0.35}},
        {property = "DragDropTarget", label = "Drag Drop Target", default = {1.00, 1.00, 0.00, 0.90}},
        {property = "NavHighlight", label = "Nav Highlight", default = {0.26, 0.59, 0.98, 1.00}},
        {property = "NavWindowingHighlight", label = "Nav Windowing Highlight", default = {1.00, 1.00, 1.00, 0.70}},
        {property = "NavWindowingDimBg", label = "Nav Windowing Dim Bg", default = {0.80, 0.80, 0.80, 0.20}},
        {property = "ModalWindowDimBg", label = "Modal Window Dim Bg", default = {0.80, 0.80, 0.80, 0.35}},
    }
    
    local sliderConfiguration = {

        {property = "ItemSpacing", label = "Item Spacing"},
        {property = "ItemInnerSpacing", label = "Item Inner Spacing"},
        {property = "IndentSpacing", label = "Indent Spacing"},
        {sepa = 1},
        {property = "WindowPadding", label = "Window Padding"},
        {property = "FramePadding", label = "Frame Padding"},
        {property = "CellPadding", label = "Cell Padding"},
        {property = "SeparatorTextPadding", label = "Separator Text Padding"},
        {sepa = 1},
        {property = "ScrollbarSize", label = "Scrollbar Size", comp = 1},
        {property = "WindowMinSize", label = "Window Min Size"},
        {property = "GrabMinSize", label = "Grab Min Size"},
        {sepa = 1},
        {property = "WindowTitleAlign", label = "Window Title Align", max = 1},
        {property = "ButtonTextAlign", label = "Button Text Align", max = 1},
        {property = "SeparatorTextAlign", label = "Separator Text Align", max = 1},
        {property = "SelectableTextAlign", label = "Selectable Text Align", max = 1},
        {sepa = 1},
        {property = "FrameRounding", label = "Frame Rounding"},
        {property = "WindowRounding", label = "Window Rounding"},
        {property = "ChildRounding", label = "Child Rounding"},
        {property = "PopupRounding", label = "Popup Rounding"},
        {property = "ScrollbarRounding", label = "Scrollbar Rounding"},
        {property = "GrabRounding", label = "Grab Rounding"},
        {property = "TabRounding", label = "Tab Rounding"},
        {sepa = 1},
        {property = "Alpha", label = "Alpha", max = 1, comp = 1},
        {property = "DisabledAlpha", label = "Disabled Alpha"},
        {sepa = 1},
        {property = "WindowBorderSize", label = "Window Border Size", max = 5, comp = 1},
        {property = "FrameBorderSize", label = "Frame Border Size", max = 5, comp = 1},
        {property = "TabBarBorderSize", label = "Tab Bar Border Size", max = 5,comp = 1},
        {property = "ChildBorderSize", label = "Child Border Size", max = 5,comp = 1},
        {property = "PopupBorderSize", label = "Popup Border Size", max = 5, comp = 1},
        {property = "SeparatorTextBorderSize", label = "Separator Text Border Size", max = 5, comp = 1},


    }
    

    function StyleV2:CreateSlider(sliderConfiguration)
        for _, parameters in ipairs (sliderConfiguration) do

            if parameters.sepa == 1 then
                separator = styleParent:AddSeparator("")
            else
                
            end

            if parameters.max == nil then
                parameters.max = 20
            end

            if parameters.property ~= nil then

                slider = styleParent:AddSlider(parameters.label, 0, 0, parameters.max)

                if parameters.comp == nil then
                    slider.Components = 2
                end

                slider.IDContext = parameters.property .. "_ID_" .. tostring(Ext.Math.Random(1, 1000000000))

                -- DPrint(slider.IDContext)

                slider.OnChange = function (slider)
                    local value1 = slider.Value[1]
                    local value2 = slider.Value[2]
 
                    for _, window in ipairs(self.Windows) do
                        window:SetStyle(parameters.property, value1, value2)

                    end
                end
            end
        end
    end
    
    -- Ext.IMGUI.EnableDemo(true)

    StyleV2:CreateSlider(sliderConfiguration)

    -- function StyleV2:SliderFunction(property, slider)

    -- end


    -- for _,v in ipairs (sliderConfigs) do
    --     if v.components == nil then
    --         v.components = 1
    --     end
    --     StyleV2:CreateSlider(v.arg, v.parent, v.label, v.idcontext, v.max_value, v.components, function (slider)
    --         StyleV2:SliderFunction(v.property, slider)
    --     end)

    -- end



        
    -- function StyleV2:ColorEdit(colorEdit)
    --     for _, window in ipairs(self.Windows) do
    --         window:SetColor("Text", colorEdit.Color)
    --     end
    -- end

    
    -- function StyleV2:CreateColorEdit(colorEdit, parent, label, idcontext, color, components, fn)
    --     colorEdit = parent:AddColorEdit(label)
    --     colorEdit.Components = components
    --     colorEdit.IDContext = idcontext
    --     colorEdit.Color = color
    --     colorEdit.OnChange = fn
    -- end

    -- self.ColorTabUnfocusedActive = styleParent:AddColorEdit("Tab Unfocused Active")
    -- self.ColorTabUnfocusedActive.Color = {0.14, 0.26, 0.42, 1.00}
    -- self.ColorTabUnfocusedActive.IDContext = "TabUnfocusedActiveColorStyleV2"
    -- self.ColorTabUnfocusedActive.NoInputs = noInputs
    -- self.ColorTabUnfocusedActive.OnChange = function()
    --     StyleV2:TabUnfocusedActiveColor(self.ColorTabUnfocusedActive)
    -- end


    -- self.ItemSpacingSlider = styleParent:AddSlider("Item Spacing", 0, 0, 20)
    -- self.ItemSpacingSlider.Components = 2
    -- self.ItemSpacingSlider.IDContext = "ItemSpacingStyleV2"
    -- self.ItemSpacingSlider.OnChange = function()
    --     StyleV2:ItemSpacing(self.ItemSpacingSlider)
    -- end

    -- function StyleV2:ItemSpacing(slider)
    --     local valueX = slider.Value[1]
    --     local valueY = slider.Value[2]
    --     for _, window in ipairs(self.Windows) do
    --         window:SetStyle("ItemSpacing", valueX, valueY)
    --     end
    -- end

end



function StyleV2:TextDisabledColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TextDisabled", colorEdit.Color)
    end
end


function StyleV2:WindowBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("WindowBg", colorEdit.Color)
    end
end


function StyleV2:ChildBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ChildBg", colorEdit.Color)
    end
end


function StyleV2:PopupBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("PopupBg", colorEdit.Color)
    end
end


function StyleV2:BorderColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("Border", colorEdit.Color)
    end
end


function StyleV2:BorderShadowColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("BorderShadow", colorEdit.Color)
    end
end


function StyleV2:FrameBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("FrameBg", colorEdit.Color)
    end
end


function StyleV2:FrameBgHoveredColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("FrameBgHovered", colorEdit.Color)
    end
end


function StyleV2:FrameBgActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("FrameBgActive", colorEdit.Color)
    end
end


function StyleV2:TitleBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TitleBg", colorEdit.Color)
    end
end


function StyleV2:TitleBgActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TitleBgActive", colorEdit.Color)
    end
end


function StyleV2:TitleBgCollapsedColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TitleBgCollapsed", colorEdit.Color)
    end
end


function StyleV2:MenuBarBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("MenuBarBg", colorEdit.Color)
    end
end


function StyleV2:ScrollbarBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ScrollbarBg", colorEdit.Color)
    end
end


function StyleV2:ScrollbarGrabColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ScrollbarGrab", colorEdit.Color)
    end
end


function StyleV2:ScrollbarGrabHoveredColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ScrollbarGrabHovered", colorEdit.Color)
    end
end


function StyleV2:ScrollbarGrabActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ScrollbarGrabActive", colorEdit.Color)
    end
end


function StyleV2:CheckMarkColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("CheckMark", colorEdit.Color)
    end
end


function StyleV2:SliderGrabColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("SliderGrab", colorEdit.Color)
    end
end


function StyleV2:SliderGrabActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("SliderGrabActive", colorEdit.Color)
    end
end


function StyleV2:ButtonColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("Button", colorEdit.Color)
    end
end


function StyleV2:ButtonHoveredColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ButtonHovered", colorEdit.Color)
    end
end


function StyleV2:ButtonActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ButtonActive", colorEdit.Color)
    end
end


function StyleV2:HeaderColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("Header", colorEdit.Color)
    end
end


function StyleV2:HeaderHoveredColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("HeaderHovered", colorEdit.Color)
    end
end


function StyleV2:HeaderActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("HeaderActive", colorEdit.Color)
    end
end


function StyleV2:SeparatorColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("Separator", colorEdit.Color)
    end
end


function StyleV2:SeparatorHoveredColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("SeparatorHovered", colorEdit.Color)
    end
end


function StyleV2:SeparatorActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("SeparatorActive", colorEdit.Color)
    end
end


function StyleV2:ResizeGripColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ResizeGrip", colorEdit.Color)
    end
end


function StyleV2:ResizeGripHoveredColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ResizeGripHovered", colorEdit.Color)
    end
end


function StyleV2:ResizeGripActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ResizeGripActive", colorEdit.Color)
    end
end


function StyleV2:TabColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("Tab", colorEdit.Color)
    end
end


function StyleV2:TabHoveredColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TabHovered", colorEdit.Color)
    end
end


function StyleV2:TabActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TabActive", colorEdit.Color)
    end
end


function StyleV2:TabUnfocusedColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TabUnfocused", colorEdit.Color)
    end
end


function StyleV2:TabUnfocusedActiveColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TabUnfocusedActive", colorEdit.Color)
    end
end


function StyleV2:TableBorderStrongColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TableBorderStrong", colorEdit.Color)
    end
end


function StyleV2:TableBorderLightColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TableBorderLight", colorEdit.Color)
    end
end


function StyleV2:TableRowBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TableRowBg", colorEdit.Color)
    end
end


function StyleV2:TableRowBgAltColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TableRowBgAlt", colorEdit.Color)
    end
end


function StyleV2:TextSelectedBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("TextSelectedBg", colorEdit.Color)
    end
end


function StyleV2:DragDropTargetColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("DragDropTarget", colorEdit.Color)
    end
end


function StyleV2:NavHighlightColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("NavHighlight", colorEdit.Color)
    end
end


function StyleV2:NavWindowingHighlightColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("NavWindowingHighlight", colorEdit.Color)
    end
end


function StyleV2:NavWindowingDimBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("NavWindowingDimBg", colorEdit.Color)
    end
end


function StyleV2:ModalWindowDimBgColor(colorEdit)
    for _, window in ipairs(self.Windows) do
        window:SetColor("ModalWindowDimBg", colorEdit.Color)
    end
end


if Ext.IMGUI then
    StyleV2:StyleV2Window()
end