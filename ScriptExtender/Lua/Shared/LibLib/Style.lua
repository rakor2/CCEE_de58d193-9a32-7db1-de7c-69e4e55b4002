-- local styleCombo = mt2:AddCombo("Style")
-- styleCombo.IDContext = "StyleSwitchCombo"
-- styleCombo.Options = StyleNames
-- styleCombo.SelectedIndex = StyleSettings.selectedStyle - 1

-- styleCombo.OnChange = function(widget)
--     StyleSettings.selectedStyle = widget.SelectedIndex + 1
--     ApplyStyle(mw, StyleSettings.selectedStyle)
--     Settings.Save()
-- end

-- ApplyStyle(mw, StyleSettings.selectedStyle)


Styles = {}

Style = {}


function ApplyStyle(window, styleNum)
    if not Styles[styleNum] then
        for i = 1, #StyleDefinitions do
            local funcName = StyleDefinitions[i].funcName
            local windowName = "MainWindow" .. (funcName == "Main" and "" or funcName:sub(5))
            
            Styles[i] = {
                func = Style[windowName][funcName]
            }
        end
    end
    
    if Styles[styleNum] then 
        Styles[styleNum].func(window) 
    end
end



StyleDefinitions = {
    {
        name = "Maleenka Pink",
        funcName = "Main"
    },
    {
        name = "ImGui Blue",
        funcName = "Main2"
    },
}


StyleNames = {}
for i, style in ipairs(StyleDefinitions) do
    StyleNames[i] = style.name
end


styleSettings = {
    selectedStyle = nil
}


-- Ext.IMGUI.LoadFont("Font", "Mods/LighterLightyLights_6aa50183-bce4-576e-749f-3a2c60233b09/GUI/QuadraatOffcPro.ttf", 35.0)

-- Ext.IMGUI.EnableDemo(true)


-- function Style.fakeSelectableMaleenka()
--     Style.fakeSelectable = {
--         default = function (button)
--             button:SetColor("Button", {0.08, 0.08, 0.08, 1.0})  
--             button:SetColor("ButtonHovered", {0.25, 0.25, 0.25, 1.0})
--             button:SetColor("ButtonActive", {0.78, 0.55, 0.53, 1.0})
--         end
--     }
-- end

-- function Style.fakeSelectableImGui()
--     Style.fakeSelectable = {
--         default = function (button)
--             button:SetColor("Button", {0.08, 0.08, 0.08, 1.0})
--             button:SetColor("ButtonHovered", {0.26, 0.59, 0.98, 1.00})
--             button:SetColor("ButtonActive", {0.06, 0.53, 0.98, 1.00})
--         end
--     }
-- end


function Style.ApplyCommonStyles(mainWindow)

    -- Ext.IMGUI.SetScale(1.5)
    mainWindow.Font = "Font"

    mainWindow:SetStyle("ButtonTextAlign", 0.5, 0.5)
    mainWindow:SetStyle("FramePadding", 6, 2)
    mainWindow:SetStyle("ItemSpacing", 7, 5)
    mainWindow:SetStyle("ItemInnerSpacing", 7, 3)
    mainWindow:SetStyle("WindowPadding", 3, 7)
    mainWindow:SetStyle("WindowBorderSize", 0)
    mainWindow:SetStyle("ScrollbarSize", 15)
    mainWindow:SetStyle("FrameRounding", 2)
    mainWindow:SetStyle("WindowTitleAlign", 0.5)
    mainWindow:SetStyle("SeparatorTextBorderSize", 2)
    mainWindow:SetStyle("SeparatorTextPadding", 0, 1)
    mainWindow:SetStyle("SeparatorTextAlign", 0.022, 0.5)
    mainWindow:SetStyle("DisabledAlpha", 0.1)
    mainWindow:SetStyle("WindowRounding", 2)
    mainWindow:SetStyle("ChildRounding", 2)
    mainWindow:SetStyle("PopupRounding", 2)
    mainWindow:SetStyle("ScrollbarRounding", 2)
    mainWindow:SetStyle("GrabRounding", 2)
    mainWindow:SetStyle("TabRounding", 2)

end




Style.MainWindow = {
    Main = function(mainWindow)

        mainWindow:SetColor("Text", {0.94, 0.94, 0.94, 1.00})
        mainWindow:SetColor("TextDisabled", {0.60, 0.60, 0.60, 1.00})
        mainWindow:SetColor("WindowBg", {0.08, 0.08, 0.08, 1.00})
        mainWindow:SetColor("ChildBg", {0.11, 0.11, 0.11, 1.00})
        mainWindow:SetColor("PopupBg", {0.1, 0.1, 0.1, 1.00})
        mainWindow:SetColor("Border", {0.07, 0.07, 0.07, 1.00})
        mainWindow:SetColor("BorderShadow", {0.07, 0.07, 0.07, 1.00})
        mainWindow:SetColor("FrameBg", {0.15, 0.15, 0.15, 1.00})
        mainWindow:SetColor("FrameBgHovered", {0.27, 0.27, 0.27, 0.92})
        mainWindow:SetColor("FrameBgActive", {0.39, 0.39, 0.39, 0.90})
        mainWindow:SetColor("TitleBg", {0.12, 0.12, 0.12, 1.00})
        mainWindow:SetColor("TitleBgActive", {0.09, 0.09, 0.09, 1.00})
        mainWindow:SetColor("TitleBgCollapsed", {0.05, 0.05, 0.05, 1.00})
        mainWindow:SetColor("MenuBarBg", {0.07, 0.07, 0.07, 1.00})
        mainWindow:SetColor("ScrollbarBg", {0.23, 0.23, 0.23, 0.00})
        mainWindow:SetColor("ScrollbarGrab", {0.23, 0.23, 0.23, 1.00})
        mainWindow:SetColor("ScrollbarGrabHovered", {0.58, 0.58, 0.58, 1.00})
        mainWindow:SetColor("ScrollbarGrabActive", {0.58, 0.58, 0.58, 1.00})
        mainWindow:SetColor("CheckMark", {0.94, 0.94, 0.94, 1.00})
        mainWindow:SetColor("SliderGrab", {0.2, 0.2, 0.2, 1.00})
        mainWindow:SetColor("SliderGrabActive", {0.15, 0.15, 0.15, 1.00})
        mainWindow:SetColor("Button", {0.15, 0.15, 0.15, 1.00})
        mainWindow:SetColor("ButtonHovered", {0.25, 0.25, 0.25, 1.00})
        mainWindow:SetColor("ButtonActive", {0.34, 0.34, 0.34, 1.00})
        mainWindow:SetColor("Header", {0.08, 0.08, 0.08, 1.00})
        mainWindow:SetColor("HeaderHovered", {0.2, 0.2, 0.2, 1.00})
        mainWindow:SetColor("HeaderActive", {0.08, 0.08, 0.08, 1.00})
        mainWindow:SetColor("Separator", {1.00, 0.61, 0.61, 1.00})
        mainWindow:SetColor("SeparatorHovered", {1.00, 0.61, 0.61, 1.00})
        mainWindow:SetColor("SeparatorActive", {1.00, 0.64, 0.64, 0.78})
        mainWindow:SetColor("ResizeGrip", {0.13, 0.13, 0.13, 1.00})
        mainWindow:SetColor("ResizeGripHovered", {0.87, 0.53, 0.53, 1.00})
        mainWindow:SetColor("ResizeGripActive", {0.72, 0.44, 0.44, 1.00})
        mainWindow:SetColor("Tab", {0.15, 0.15, 0.15, 1.00})
        mainWindow:SetColor("TabHovered", {0.25, 0.25, 0.25, 1.00})
        mainWindow:SetColor("TabActive", {0.34, 0.34, 0.34, 1.00})

        Style.ApplyCommonStyles(mainWindow)

        -- Style.fakeSelectableMaleenka()

    end
}


Style.MainWindow2 = {
    Main2 = function(mainWindow)

        mainWindow:SetColor("Text", {1.00, 1.00, 1.00, 1.00})
        mainWindow:SetColor("TextDisabled", {0.50, 0.50, 0.50, 1.00})
        mainWindow:SetColor("WindowBg", {0.08, 0.08, 0.08, 1})
        mainWindow:SetColor("ChildBg", {0.14, 0.14, 0.14, 1})
        mainWindow:SetColor("PopupBg", {0.08, 0.08, 0.08, 1})
        mainWindow:SetColor("Border", {0.43, 0.43, 0.50, 0.50})
        mainWindow:SetColor("BorderShadow", {0.00, 0.00, 0.00, 0.00})
        mainWindow:SetColor("FrameBg", {0.16, 0.29, 0.48, 0.54})
        mainWindow:SetColor("FrameBgHovered", {0.26, 0.59, 0.98, 0.40})
        mainWindow:SetColor("FrameBgActive", {0.26, 0.59, 0.98, 0.67})
        mainWindow:SetColor("TitleBg", {0.04, 0.04, 0.04, 1.00})
        mainWindow:SetColor("TitleBgActive", {0.16, 0.29, 0.48, 1.00})
        mainWindow:SetColor("TitleBgCollapsed", {0.00, 0.00, 0.00, 0.51})
        mainWindow:SetColor("MenuBarBg", {0.14, 0.14, 0.14, 1.00})
        mainWindow:SetColor("ScrollbarBg", {0.02, 0.02, 0.02, 0.53})
        mainWindow:SetColor("ScrollbarGrab", {0.31, 0.31, 0.31, 1.00})
        mainWindow:SetColor("ScrollbarGrabHovered", {0.41, 0.41, 0.41, 1.00})
        mainWindow:SetColor("ScrollbarGrabActive", {0.51, 0.51, 0.51, 1.00})
        mainWindow:SetColor("CheckMark", {0.26, 0.59, 0.98, 1.00})
        mainWindow:SetColor("SliderGrab", {0.24, 0.52, 0.88, 1.00})
        mainWindow:SetColor("SliderGrabActive", {0.26, 0.59, 0.98, 1.00})
        mainWindow:SetColor("Button", {0.26, 0.59, 0.98, 0.40})
        mainWindow:SetColor("ButtonHovered", {0.26, 0.59, 0.98, 1.00})
        mainWindow:SetColor("ButtonActive", {0.06, 0.53, 0.98, 1.00})
        mainWindow:SetColor("Header", {0.26, 0.59, 0.98, 0.31})
        mainWindow:SetColor("HeaderHovered", {0.26, 0.59, 0.98, 0.80})
        mainWindow:SetColor("HeaderActive", {0.26, 0.59, 0.98, 1.00})
        mainWindow:SetColor("Separator", {0.43, 0.43, 0.50, 0.50})
        mainWindow:SetColor("SeparatorHovered", {0.10, 0.40, 0.75, 0.78})
        mainWindow:SetColor("SeparatorActive", {0.10, 0.40, 0.75, 1.00})
        mainWindow:SetColor("ResizeGrip", {0.26, 0.59, 0.98, 0.20})
        mainWindow:SetColor("ResizeGripHovered", {0.26, 0.59, 0.98, 0.67})
        mainWindow:SetColor("ResizeGripActive", {0.26, 0.59, 0.98, 0.95})
        mainWindow:SetColor("Tab", {0.18, 0.35, 0.58, 0.86})
        mainWindow:SetColor("TabHovered", {0.26, 0.59, 0.98, 0.80})
        mainWindow:SetColor("TabActive", {0.20, 0.41, 0.68, 1.00})
        mainWindow:SetColor("TabUnfocused", {0.07, 0.10, 0.15, 0.97})
        mainWindow:SetColor("TabUnfocusedActive", {0.14, 0.26, 0.42, 1.00})
        
        Style.ApplyCommonStyles(mainWindow)
        
        mainWindow:SetStyle("WindowRounding", 0)
        mainWindow:SetStyle("ChildRounding", 0)
        mainWindow:SetStyle("FrameRounding", 0)
        mainWindow:SetStyle("PopupRounding", 0)
        mainWindow:SetStyle("ScrollbarRounding", 0)
        mainWindow:SetStyle("GrabRounding", 0)
        mainWindow:SetStyle("TabRounding", 0)
        mainWindow:SetStyle("ButtonTextAlign", 0.5, 0.5)

        -- Style.fakeSelectableImGui()

    end
}


return Style