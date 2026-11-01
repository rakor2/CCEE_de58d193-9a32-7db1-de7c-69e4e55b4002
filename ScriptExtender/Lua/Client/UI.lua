---@diagnostic disable: param-type-mismatch

OPENQUESTIONMARK = true
IMGUI:AntiStupiditySystem()

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
    CCEE:Unsorted()
    CCEE:PresetsTab()
    CCEE:SettingsTab()
    CCEE:Reset()
    CCEE:Dev()
end





local cceeWindow

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
    local ViewportSize = Ext.IMGUI.GetViewportSize()
    local DefaultSize = {700, 1000}

    cceeWindow = Ext.IMGUI.NewWindow("CCEE")
    cceeWindow.Open = OPENQUESTIONMARK
    cceeWindow.Closeable = true
    cceeWindow.AlwaysAutoResize = false
    cceeWindow.Scaling = 'Scaled'
    cceeWindow:SetPos({ViewportSize[1] / 6, ViewportSize[2] / 10})

    -- if ViewportSize[1] <= 1920 and ViewportSize[2] <= 1080 then
    --     cceeWindow:SetSize({DefaultSize[1]/1.333, DefaultSize[2]/1.333})
    -- else
    --     cceeWindow:SetSize(DefaultSize)
    -- end

    -- StyleV2:RegisterWindow(cceeWindow)

    ApplyStyle(cceeWindow, 1)

    -- p = cceeWindow

    MCM.SetKeybindingCallback('ccee_toggle_window', function()
        cceeWindow.Open = not cceeWindow.Open
    end)

    MCM.SetKeybindingCallback('ccee_enter_mirror', function()
        Ext.Net.PostMessageToServer('CCEE_Mirror', _C().Uuid.EntityUuid)
    end)


    function windowIsOpened()
        return cceeWindow.Open
    end

    -- MCM.SetKeybindingCallback('ccee_apply_pm_parameters', function()
    --     Helpers.Timer:OnTicks(2, function ()
    --         ApplyParametersToDummies()
    --     end)

    -- end)


    local bar2 = cceeWindow:AddTabBar('Tabs2')
    local bar = cceeWindow:AddTabBar('Tabs')



    E.devTab2 = bar2:AddTabItem('Main2')
    MainTab(E.devTab2)

    E.grpCat = E.devTab2:AddGroup('Categories')
    E.sepaMain2 = bar2:AddSeparator()


    E.grpDiffusion = E.devTab2:AddGroup('Diffusion')




    local mainTab = bar:AddTabItem('Main')

    local presetsTab = bar:AddTabItem('Presets')

    local settingsTab = bar:AddTabItem('Settings')

    local resetTab = bar:AddTabItem('Reset')

    local devTab = bar:AddTabItem('Dev')



    local p = mainTab


    function CCEE:CoolThings()

        local STOPPPPP = p:AddButton('Idle')
        STOPPPPP.OnClick = function()
            Ext.Net.PostMessageToServer('CCEE_Stop', '')
        end
        local tp101233 = STOPPPPP:Tooltip()
        tp101233:AddText([[
        Hide/unhide to quit]])



        local resetCharacter = p:AddButton('Reset character')
        resetCharacter.SameLine = true
        resetCharacter.OnClick = function ()

            confirmResetChar.Visible = true
            resetCharacter.Visible = false

            confirmTimer = Ext.Timer.WaitFor(1000, function()
                confirmResetChar.Visible = false
                resetCharacter.Visible = true
            end)

        end
        local tp103 = resetCharacter:Tooltip()
        tp103:AddText([[
        Resets MOD'S parameters (THE ones in THE WINDOW) for current character]])


        confirmResetChar = p:AddButton('Confirm')
        confirmResetChar:SetColor("Button", {0.55, 0.0, 0.0, 1.00})
        confirmResetChar:SetColor("ButtonHovered", {0.35, 0.0, 0.0, 1.0})
        confirmResetChar:SetColor("ButtonActive", {0.25, 0.0, 0.0, 1.0})
        confirmResetChar.SameLine = true
        confirmResetChar.Size = {159,35}
        confirmResetChar.SameLine = false
        confirmResetChar.Visible = false
        confirmResetChar.OnClick = function ()
            Ext.Timer.Cancel(confirmTimer)
            ConfirmWorkaround(_C())
            Ext.Net.PostMessageToServer('CCEE_ResetCurrentCharacter', _C().Uuid.EntityUuid)
            if _C().Uuid and _GLL.AllParameters.ActiveMatParameters and _GLL.AllParameters.ActiveMatParameters[uuid] ~= nil and _GLL.AllParameters.MatPresetParameters[uuid] ~= nil then
                local uuid = _C().Uuid.EntityUuid
                _GLL.AllParameters.ActiveMatParameters[uuid] = nil
                _GLL.AllParameters.MatPresetParameters[uuid] = nil
                --lastParametersMV[uuid] = nil
                Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(_GLL.AllParameters.ActiveMatParameters))
            end
            resetCharacter.Visible = true
            confirmResetChar.Visible = false
        end


        local backupPM = p:AddButton('Force dummies')
        backupPM.SameLine = true
        backupPM.OnClick = function ()
            Apply_PMDummiesActiveMaterialParameters()
            Apply_CCDummyVActiveMaterialsParameters()
            Apply_TLPreviwDummiesActiveMaterialsParameters()
            pcall(function() FindE2() end)

        end
        local tp10 = backupPM:Tooltip()
        tp10:AddText([[
        Loads stored data from the save file for every character in PM/CC/Cutscene
        Useful if visually MOD'S parameters (THE ones in THE WINDOW) got reset]])


        -- local tp5 = backupPM:Tooltip()
        -- tp5:AddText([[
        -- If parameters didn't apply to PM characters]])

        local forceLoad = p:AddButton('Force characters')
        forceLoad.SameLine = true
        forceLoad.OnClick = function ()
            --Ext.Net.PostMessageToServer('CCEE_UpdateParameters_OnlyVis', '')
            Apply_AllCharactersMaterialPresetPararmeters()
            Helpers.Timer:OnTicks(20, function ()
                Apply_AllCharactersActiveMaterialParameters()
                pcall(function()
                    FindE2()
                end)
            end)
        end
        local tp3 = forceLoad:Tooltip()
        tp3:AddText([[
        Loads stored data from the save file for every character in the scene
        Useful if visually MOD'S parameters (THE ones in THE WINDOW) got reset]])



        local btnTransferParams = p:AddButton('Transfer skin color')
        btnTransferParams.OnClick = function ()
            local entity = _C()
            SaveSkinMaterialPresetParameters(entity)
            AssignSkinToCharacter(entity)
            ApplySavedMaterialPresetParametersToCCEESkin(entity)
            E.textSkinPreset.Label = 'Transfered' --TBD: make an actual safety check
            Elements:UpdateElements(_C())
            Helpers.Timer:OnTicks(40, function ()
                E.textSkinPreset.Label = ''
            end)
        end
        local tp155 = btnTransferParams:Tooltip()
        tp155:AddText([[
        If you haven't touched any mod parameters, this button will transfer your current skin color (preset) to CCEE skin preset
        Do not click it, if your character already has CCEE skin preset]])


        E.checkTests = p:AddCheckbox('All parameters')
        E.checkTests.IDContext = 'adasd22'
        E.checkTests.OnChange = function ()
            if E.checkTests.Checked then
                CCEE:Tests()
            else
                sepate:Destroy()
                testParams2:Destroy()
            end
        end


        testsSave = p:AddCheckbox('Save All parameters')
        testsSave.SameLine = true

        E.textSkinPreset = p:AddText('Current skin UUID')
        E.textSkinPreset.SameLine = true
        E.textSkinPreset.Label = '' --skin material preset uuid


        local sepa = p:AddSeparatorText('')
    end


    ---@param fn function # loooooooooooook it's colored!
    function Elements:CreateElements(type, var, name, parent, options, fn)
        if type == 'int' then
            self[var] = parent:AddSliderInt(name, options.def or 0, options.min or 0, options.max or 1, 0)
            self[var].Logarithmic = options.log or false
        elseif type == 'picker' then
            self[var] = parent:AddColorEdit(name)
            self[var].Float = true
            self[var].NoAlpha = false
        elseif type == 'inp' then
            self[var] = parent:AddInputText(name)
        else
            self[var] = parent:AddSlider(name, options.default or 0, options.min or 0, options.max or 1, 0)
            self[var].Logarithmic = options.log or false
        end
        self[var].IDContext = Ext.Math.Random(1,1000000)
        self[var].OnChange = function (e)
            fn(e)
        end
    end





    ---@param tbl table | --aahTable
    ---@param collapse ExtuiCollapsingHeader
    ---@param treeName string
    function Elements:PopulateTab(tbl, collapse, treeName)
        local tree = collapse:AddTree(treeName)
        tree.IDContext = Ext.Math.Random(1,100000)
        for _, v in ipairs(tbl) do
            v[4] = tree
            self:CreateElements(table.unpack(v))
            v[4] = parent
        end
        return tree
    end


    ---@param table table
    function Elements:CreateMetatables(table)
        for parameterGroup, _ in pairs(table) do
            setmetatable(table[parameterGroup], {__index = Apply})
        end
    end









--#region ahhTable
local parent
local oldColorHT = {0,0,0,0}
local oldColorBT = {0,0,0,0}
ahhTable = {

    Melanin = {

        {'picker', 'pickMelaninColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'MelaninColor', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

            {nil, 'slMelaninAmount', 'Amount', parent, {}, function(var)
                HandleAllScalarMaterialParameters(Apply.entity, 'MelaninAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},


        {nil, 'slMelaninRemoval', 'Removal amount', parent, {max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'MelaninRemovalAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},


        {nil, 'slMelaninDarkM', 'Dark multiplier', parent, {max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'MelaninDarkMultiplier', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

        {nil, 'slMelaninDarkT', 'Dark threshold', parent, {max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'MelaninDarkThreshold', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},
    },

    Hemoglobin = {

        {'picker', 'pickHemoglobinColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'HemoglobinColor', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

        {nil, 'slHemoglobinAmount', 'Amount', parent, {max = 3}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'HemoglobinAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},
    },

    Yellowing = {
        {'picker', 'pickYellowingColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'YellowingColor', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

        {nil, 'slYellowingAmount', 'Amount', parent, {min = -300, max = 300, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'YellowingAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},
    },

    Vein = {
        {'picker', 'pickVeinColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'VeinColor', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

        {nil, 'slVeinAmount', 'Amount', parent, {max = 7}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'VeinAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},
    },

    NonSkinBody = {
        {'picker', 'pickNonSkinColor', 'NonSkinColor', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'NakedBody', 'Private Parts', 'Tail'})
        end},

        {nil, 'slNonSkinWeight', 'NonSkin_Weight', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkin_Weight', var, {'NakedBody', 'Private Parts', 'Tail'})
        end},

        {nil, 'slNonSkinMetalness', 'NonSkinMetalness', parent, {max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkinMetalness', var, {'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Freckles = {
        {nil, 'slFreckles', 'Freckles', parent, {max = 1.3}, function(var)
            --SetAdditiownalChoices('Freckles', var.Value[1]) --LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
            HandleAllScalarMaterialParameters(Apply.entity, 'Freckles', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},

        {nil, 'slFrecklesWeight', 'FrecklesWeight', parent, {max = 7}, function(var)
            --SetAdditionalChoices('FrecklesWeight', var.Value[1]) --LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
            HandleAllScalarMaterialParameters(Apply.entity, 'FrecklesWeight', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Vitiligo = {
        {nil, 'slVitiligo', 'Vitiligo', parent, {max = 1}, function(var)
            --SetAdditionalChoices('Vitiligo', var.Value[1]) --LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
            HandleAllScalarMaterialParameters(Apply.entity, 'Vitiligo', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},

        {nil, 'slVitiligoWeight', 'VitiligoWeight', parent, {max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'VitiligoWeight', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Sweat = {
        {nil, 'slSweat', 'Sweat (smh)', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Sweat', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Blood = {
        {nil, 'slBlood', 'Blood', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Blood', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Dirt_body = {
        {nil, 'slDirt', 'Dirt', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Dirt', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },


    Eyes_makeup = {
        {'int', 'slIntMakeupIndex', 'Index', parent, {max = 31}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'MakeUpIndex', var, {'Head'})
        end},

        {'picker', 'pickMakeupColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'MakeupColor', var, {'Head'})
        end},

        {nil, 'slMakeupInt', 'Intensity', parent, {max = 5}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'MakeupIntensity', var, {'Head'})
        end},

        {nil, 'slMakeupMet', 'Metalness', parent, {max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'EyesMakeupMetalness', var, {'Head'})
        end},

        {nil, 'slMakeupRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'MakeupRoughness', var, {'Head'})
        end},
    },

    Lips_makeup = {
        {'picker', 'pickLipsColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Lips_Makeup_Color', var, {'Head'})
        end},

        {nil, 'slLipsInt', 'LipsMakeupIntensity', parent, {max = 5}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'LipsMakeupIntensity', var, {'Head'})
        end},

        {nil, 'slLipsMet', 'Metalness', parent, {max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'LipsMakeupMetalness', var, {'Head'})
        end},

        {nil, 'slLipsRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'LipsMakeupRoughness', var, {'Head'})
        end},
    },

    Tattoo = {
        {'int', 'slIntTattooIndex', 'Index', parent, {max = 31}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooIndex', var, {'Head'})
        end},

        {'picker', 'pickTattooColorR', 'Color R', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'TattooColor', var, {'Head'})
        end},

        {'picker', 'pickTattooColorG', 'Color G', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'TattooColorG', var, {'Head'})
        end},

        {'picker', 'pickTattooColorB', 'Color B', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'TattooColorB', var, {'Head'})
        end},


        {'picker', 'pickTattooIntR', 'Intensity', parent, {}, function(var)
            if E.unlockTats.Checked then
            else
                local colorHT = Elements['pickTattooIntR'].Color
                if colorHT[1] ~= oldColorHT[1] then
                    colorHT[2] = 0
                    colorHT[3] = 0
                    colorHT[4] = 0
                elseif colorHT[2] ~= oldColorHT[2] then
                    colorHT[1] = 0
                    colorHT[3] = 0
                    colorHT[4] = 0

                elseif colorHT[3] ~= oldColorHT[3] then
                    colorHT[1] = 0
                    colorHT[2] = 0
                    colorHT[4] = 0

                elseif colorHT[4] ~= oldColorHT[4] then
                    colorHT[1] = 0
                    colorHT[2] = 0
                    colorHT[3] = 0
                end
                oldColorHT[1] = colorHT[1]
                oldColorHT[2] = colorHT[2]
                oldColorHT[3] = colorHT[3]
                oldColorHT[4] = colorHT[4]
                Elements['pickTattooIntR'].Color = colorHT
            end
            HandleAllVectorMaterialParameters(Apply.entity, 'TattooIntensity', var, {'Head'})
        end},




        {nil, 'slAddHeadTatInt', 'Head AdditionalTattooIntensity', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'AdditionalTattooIntensity', var, {'Head'})
        end},

        {'picker', 'pickAddHeadColor', 'Head AdditionalTattooColor', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'AdditionalTattooColorB', var, {'Head'})
        end},

        {nil, 'slTattooMet', 'Metalness', parent, {min = 0, max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooMetalness', var, {'Head'})
        end},

        {nil, 'slTattooRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooRoughnessOffset', var, {'Head'})
        end},

        {nil, 'slTattooCurve', 'Curvature influence', parent, {min = 0, max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooCurvatureInfluence', var, {'Head'})
        end},
    },

    Age = {
        {nil, 'slAgeInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Age_Weight', var, {'Head'})
        end},
    },

    Scars = {
        {'int', 'slIntScarIndex', 'Index', parent, {max = 24}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'ScarIndex', var, {'Head'})
        end},

        {nil, 'slScarWeight', 'Intensity', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scar_Weight', var, {'Head'})
        end},
    },

    Scales = {
        {'int', 'slIntScaleIndex', 'Index', parent, {max = 31}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'CustomIndex', var, {'Head'})
        end},

        {'picker', 'pickScaleColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'CustomColor', var, {'Head'})
        end},

        {nil, 'slScaleInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'CustomIntensity', var, {'Head'})
        end},
    },

    Eyes = {
        {'int', 'slEyesHet', 'Heterochromia', parent, {max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Heterochromia', var, {'Head'})
        end},

        {nil, 'slEyesBR', 'Blindness R', parent, {max = 3}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Blindness', var, {'Head'})
        end},

        {nil, 'slEyesBL', 'Blindness L', parent, {max = 3}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Blindness_L', var, {'Head'})
        end},

        {'picker', 'pickEyesC', 'Iris color 1', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_IrisColour', var, {'Head'})
        end},

        {'picker', 'pickEyesCL', 'Iris color 1 L', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_IrisColour_L', var, {'Head'})
        end},

        {'picker', 'pickEyesC2', 'Iris color 2', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_IrisSecondaryColour', var, {'Head'})
        end},

        {'picker', 'pickEyesC2L', 'Iris color 2 L', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_IrisSecondaryColour_L', var, {'Head'})
        end},

        {'picker', 'pickEyesSC', 'Sclera color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_ScleraColour', var, {'Head'})
        end},

        {'picker', 'pickEyesSCL', 'Sclera color L', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_ScleraColour_L', var, {'Head'})
        end},

        {nil, 'slEyesCI', 'Iris color int', parent, {min = -100, max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'SecondaryColourIntensity', var, {'Head'})
        end},

        {nil, 'slEyesCIL', 'Iris color int L', parent, {min = -100, max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'SecondaryColourIntensity_L', var, {'Head'})
        end},

        {nil, 'slEyesEdge', 'IrisEdgeStrength', parent, {min = -100, max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'IrisEdgeStrength', var, {'Head'})
        end},

        {nil, 'slEyesEdgeL', 'IrisEdgeStrength L', parent, {min = -100, max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'IrisEdgeStrength_L', var, {'Head'})
        end},

        {nil, 'slEyesRed', 'Redness', parent, {max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Redness', var, {'Head'})
        end},

        {nil, 'slEyesRedL', 'Redness L', parent, {max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Redness_L', var, {'Head'})
        end},
    },

    NonSkinHead = {
        {'picker', 'pickHeadNonSkinColor', 'NonSkinColor', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'Head'})
        end},

        {nil, 'slHeadNonSkinWeight', 'NonSkin_Weight', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkin_Weight', var, {'Head'})
        end},

        {nil, 'slHeadNonSkinMetalness', 'NonSkinMetalness', parent, {max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkinMetalness', var, {'Head'})
        end},
    },


    Body_tattoos = {
        {'int', 'slBTatI', 'Index', parent, {max = 19}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'BodyTattooIndex', var, {'NakedBody', 'Tail'})
        end},

        {'picker', 'pickBTatCR', 'Color R', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'BodyTattooColor', var, {'NakedBody', 'Tail'})
        end},

        {'picker', 'pickBTatCG', 'Color G', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'BodyTattooColorG', var, {'NakedBody', 'Tail'})
        end},

        {'picker', 'pickBTatCB', 'Color B', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'BodyTattooColorB', var, {'NakedBody', 'Tail'})
        end},


        {'picker', 'slBTatIntR', 'Intensity', parent, {}, function(var)
            if E.unlockTats.Checked then
            else
                local colorBT = Elements['slBTatIntR'].Color
                if colorBT[1] ~= oldColorBT[1] then
                    colorBT[2] = 0
                    colorBT[3] = 0
                    colorBT[4] = 0
                elseif colorBT[2] ~= oldColorBT[2] then
                    colorBT[1] = 0
                    colorBT[3] = 0
                    colorBT[4] = 0
                elseif colorBT[3] ~= oldColorBT[3] then
                    colorBT[1] = 0
                    colorBT[2] = 0
                    colorBT[4] = 0
                elseif colorBT[4] ~= oldColorBT[4] then
                    colorBT[1] = 0
                    colorBT[2] = 0
                    colorBT[3] = 0
                end
                oldColorBT[1] = colorBT[1]
                oldColorBT[2] = colorBT[2]
                oldColorBT[3] = colorBT[3]
                oldColorBT[4] = colorBT[4]
                Elements['slBTatIntR'].Color = colorBT
            end
            HandleAllVectorMaterialParameters(Apply.entity, 'BodyTattooIntensity', var, {'NakedBody', 'Tail'})
        end},

        {'picker', 'pickAddBodyColor', 'Body AdditionalTattooColor', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'AdditionalTattooColorB', var, {'NakedBody'})
        end},

        {nil, 'slAddBodyTatInt', 'Body AdditionalTattooIntensity', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'AdditionalTattooIntensity', var, {'NakedBody'})
        end},

        {nil, 'slBTatMet', 'Metalness', parent, {max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooMetalness', var, {'NakedBody', 'Tail'})
        end},

        {nil, 'slBTatR', 'Roughness', parent, {min = -1, max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooRoughnessOffset', var, {'NakedBody', 'Tail'})
        end},

        {nil, 'slBTatCurve', 'Curvature influence', parent, {max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooCurvatureInfluence', var, {'NakedBody', 'Tail'})
        end}
    },

    Private_parts = {
        {'int', 'slIntPPOpac', 'Toggle', parent, {def = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'InvertOpacity', var, {'Private Parts'})
        end},
    },

    Scalp = {
        {'picker', 'pickHairScalpColor', 'Hair Scalp Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Hair_Scalp_Color', var, {'Head'})
        end},

        {'picker', 'pickHueShiftWeight', 'Hue Shift Weight', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Scalp_HueShiftColorWeight', var, {'Head'})
        end},

        {'picker', 'pickBeardScalpColor', 'Beard Scalp Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Scalp_Color', var, {'Head'})
        end},

        {nil, 'slScalpMinValue', 'Scalp Min Value', parent, {min = -1, max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_MinValue', var, {'Head'})
        end},

        {nil, 'slHornMaskWeight', 'Horn Mask Weight', parent, {min = -1, max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_HornMaskWeight', var, {'Head'})
        end},

        {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_Graying_Intensity', var, {'Head'})
        end},

        {'picker', 'pickGrayingColor', 'Graying Color', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Hair_Scalp_Graying_Color', var, {'Head'})
        end},

        {nil, 'slColorTransitionMid', 'Color Transition Mid', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_ColorTransitionMidPoint', var, {'Head'})
        end},

        {nil, 'slColorTransitionSoft', 'Color Transition Soft', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_ColorTransitionSoftness', var, {'Head'})
        end},

        {nil, 'slDepthColorExponent', 'Depth Color Exponent', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_DepthColorExponent', var, {'Head'})
        end},

        {nil, 'slDepthColorIntensity', 'Depth Color Intensity', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_DepthColorIntensity', var, {'Head'})
        end},

        {nil, 'slIDContrast', 'ID Contrast', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_IDContrast', var, {'Head'})
        end},

        {nil, 'slColorDepthContrast', 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_ColorDepthContrast', var, {'Head'})
        end},

        {nil, 'slScalpRoughness', 'Scalp Roughness', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_Roughness', var, {'Head'})
        end},

        {nil, 'slRoughnessContrast', 'Roughness Contrast', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_RoughnessContrast', var, {'Head'})
        end},

        {nil, 'slScalpScatter', 'Scalp Scatter', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_Scatter', var, {'Head'})
        end},
    },


    Hair = {
        {'picker', 'pickHairColor', 'Hair Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Hair_Color', var, {'Hair'})
        end},

        {'picker', 'pickHairGrayingColor', 'Hair Graying Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Hair_Graying_Color', var, {'Hair'})
        end},

        {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1.2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Graying_Intensity', var, {'Hair'})
        end},

        {nil, 'slGrayingSeed', 'Graying Seed', parent, {min = -10, max = 10, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Graying_Seed', var, {'Hair'})
        end},

        {'picker', 'pickHighlightColor', 'Highlight Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Highlight_Color', var, {'Hair'})
        end},

        {nil, 'slHighlightFalloff', 'Highlight Falloff', parent, {min = -1, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Highlight_Falloff', var, {'Hair'})
        end},

        {nil, 'slHighlightIntensity', 'Highlight Intensity', parent, {max = 3, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Highlight_Intensity', var, {'Hair'})
        end},

        {nil, 'slHairDirt', 'Dirt', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Dirt', var, {'Hair'})
        end},

        {'picker', 'slHairDirtColor', 'Dirt color', parent, {max = 2}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'DirtColor', var, {'Hair'})
        end},

        {nil, 'slHairBlood', 'Blood', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Blood', var, {'Hair'})
        end},


        {'picker', 'slHairBloodColor', 'Blood color', parent, {max = 2}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Blood_Color', var, {'Hair'})
        end},


        {nil, 'slHairRoughness', 'Roughness', parent, {min = -1, max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Roughness', var, {'Hair'})
        end},

        {nil, 'slRootTransitionMid', 'Root Transition Mid', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'RootTransitionMidPoint', var, {'Hair'})
        end},

        {nil, 'slRootTransitionSoft', 'Root Transition Soft', parent, {min = -2, max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'RootTransitionSoftness', var, {'Hair'})
        end},

        {nil, 'slDepthColorExponent', 'Depth Color Exponent', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'DepthColorExponent', var, {'Hair'})
        end},

        {nil, 'slDepthColorIntensity', 'Depth Color Intensity', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'DepthColorIntensity', var, {'Hair'})
        end},

        {nil, 'slColorDepthContrast', 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'ColorDepthContrast', var, {'Hair'})
        end},



        {nil, 'slHairRoughness', 'Roughness contrast', parent, {min = -1, max = 1}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'RoughnessContrast', var, {'Hair'})
        end},


        {nil, 'slHairFrizz', 'Hair Frizz', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'HairFrizz', var, {'Hair'})
        end},

        {nil, 'slHairSoupleness', 'Hair Soupleness', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'HairSoupleness', var, {'Hair'})
        end},

        {nil, 'slMaxWindMovement', 'Max Wind Movement', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'MaxWindMovementAmount', var, {'Hair'})
        end},

        {nil, 'slSoftenTipsAlpha', 'Soften Tips Alpha', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'SoftenTipsAlpha', var, {'Hair'})
        end},

        {nil, 'slBacklit', 'Backlit', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'HairBacklit', var, {'Hair'})
        end},


        {nil, 'slScatter', 'Scatter', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Scatter', var, {'Hair'})
        end},


        {nil, 'slDreadNoiseBaseColor', 'Dread Noise Base Color', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'DreadNoiseBaseColor', var, {'Hair'})
        end},

        {'picker', 'pickHairAcc1', 'Accs NonSkinColor', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc2', 'Accs NonSkinTipColor', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinTipColor', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc3', 'Accs SkinApproxColor', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'SkinApproxColor', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc4', 'Accs Cloth_Primary', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Cloth_Primary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc5', 'Accs Cloth_Secondary', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Cloth_Secondary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc6', 'Accs Cloth_Tertiary', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Cloth_Tertiary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc7', 'Accs Accent_Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Accent_Color', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc8', 'Accs Leather_Primary', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Leather_Primary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc9', 'Accs Leather_Secondary', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Leather_Secondary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc10', 'Accs Leather_Tertiary', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Leather_Tertiary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc11', 'Accs Custom_1', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Custom_1', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc12', 'Accs Custom_2', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Custom_2', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc13', 'Accs Metal_Primary', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Metal_Primary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc14', 'Accs Metal_Secondary', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Metal_Secondary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc15', 'Accs Metal_Tertiary', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Metal_Tertiary', var, {'Hair'})
        end},
    },


    Beard = {
        {'int', 'slIntBeardIndex', 'BeardIndex', parent, {min = -1, max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardIndex', var, {'Head'})
        end},

        {'picker', 'pickBeardColor', 'Beard Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Color', var, {'Hair'})
        end},

        {'picker', 'pickBeardScalpColor', 'Beard Scalp Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Scalp_Color', var, {'Hair'})
        end},

        {'picker', 'pickBeardGrayingColor', 'Beard Graying Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Graying_Color', var, {'Hair'})
        end},

        {nil, 'slBeardGrayingInt', 'Beard Graying Intensity', parent, {min = -100, max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Beard_Graying_Intensity', var, {'Hair'})
        end},

        {'picker', 'pickBeardHighlightColor', 'Beard Highlight Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Highlight_Color', var, {'Hair'})
        end},

        {nil, 'slBeardMinValue', 'Beard Min Value', parent, {min = -10, max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardMinValue', var, {'Head'})
        end},

        {nil, 'slBeardInt', 'Beard Intesity', parent, {min = -100, max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardIntesity', var, {'Hair'})
        end},

        {nil, 'slBeardDesat', 'Beard Desaturation', parent, {min = -100, max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardDesaturation', var, {'Head'})
        end},

        {nil, 'slBeardDarken', 'Beard Darken', parent, {min = -100, max = 100}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardDarken', var, {'Head'})
        end},


    },

    BodyHair = {
        {'picker', 'pickBodyHairC', 'Body Hair Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Body_Hair_Color', var, {'NakedBody', 'Private Parts'})
        end},
    },


    Horns = {
        {'picker', 'pickHornsColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'Horns'})
        end},

        {'picker', 'pickHeadNSColor', 'Head Thing Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'Head'})
        end},

        {nil, 'slHornsNonSkinWeight', 'NonSkin_Weight', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkin_Weight', var, {'Head'})
        end},

        {nil, 'slHornsNonSkinMetalness', 'NonSkinMetalness', parent, {max = 2}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkinMetalness', var, {'Head'})
        end},

        {'picker', 'pickHornsTipColor', 'Tip Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinTipColor', var, {'Horns'})
        end},

        {nil, 'slHornReflectance', 'Reflectance', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Reflectance', var, {'Horns'})
        end},

        {'int', 'slHornGlow', 'Toggle Glow', parent, {}, function(var)
            for _, parameter in pairs({'Use_BlackBody','Colour_BlackBody','Use_ColorRamp'}) do
                HandleAllScalarMaterialParameters(Apply.entity, parameter, var, {'Horns'})
            end
        end},

        {'picker', 'slHornBlackBody_Colour', 'Glow Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'BlackBody_Colour', var, {'Horns'})
        end},

        {nil, 'slHornIntensity', 'Glow Intensity', parent, {max = 200, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Intensity', var, {'Horns'})
        end},

        {nil, 'slHornBlackbody_PreRamp_Power', 'Also Glow Intensity', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Blackbody_PreRamp_Power', var, {'Horns'})
        end},

        {nil, 'slHornEmissive_Mult', 'Emissive Mult', parent, {min = -100, max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Emissive_Mult', var, {'Horns'})
        end},

        {'int', 'slHornUse_HeartBeat', 'Use HeartBeat', parent, {}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Use_HeartBeat', var, {'Horns'})
        end},

        {nil, 'slHornLength', 'Length', parent, {min = -100, max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'Length', var, {'Horns'})
        end},

        {nil, 'slHornamplitude', 'Amplitude', parent, {min = -100, max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'amplitude', var, {'Horns'})
        end},

        {nil, 'slHornBPM', 'BPM', parent, {min = -100, max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'BPM', var, {'Horns'})
        end},
    },


    GlowHead = {
        {'picker', 'pickHeadGlowColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'GlowColor', var, {'Head'})
        end},

        {nil, 'slHeadGlowMult', 'Multiplier', parent, {max = 5}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowMultiplier', var, {'Head'})
        end},

        {nil, 'slHeadAnimdSpeed', 'Animation speed', parent, {max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'AnimationSpeed', var, {'Head'})
        end},
    },

    GlowBody = {
        {'picker', 'pickBodyGlowColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'GlowColor', var, {'NakedBody'})
        end},

        {nil, 'slBodyGlowMult', 'Multiplier', parent, {max = 5}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowMultiplier', var, {'NakedBody'})
        end},

        {nil, 'slBodyAnimdSpeed', 'Animation speed', parent, {max = 10}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'AnimationSpeed', var, {'NakedBody'})
        end},

    },

    GlowEyes = {
        {nil, 'slEyesGlowBright', 'Brightness', parent, {min = -200, max = 200}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowBrightness', var, {'Head'})
        end},

        {nil, 'slEyesGlowBrightL', 'Brightness L', parent, {min = -200, max = 200}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowBrightness_L', var, {'Head'})
        end},

        {nil, 'slEyesGlowBrightPup', 'Brightness pupil', parent, {min = -100, max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowBrightnessPupil', var, {'Head'})
        end},

        {nil, 'slEyesFxMasking', 'Fx masking', parent, {min = -100, max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'FxMasking', var, {'Head'})
        end},

        {nil, 'slEyesFxMaskingL', 'Fx masking L', parent, {min = -100, max = 100, log = true}, function(var)
            HandleAllScalarMaterialParameters(Apply.entity, 'FxMasking_L', var, {'Head'})
        end},

        {'picker', 'slEyesGlowColor', 'Color', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_GlowColour', var, {'Head'})
        end},

        {'picker', 'slEyesGlowColorL', 'Color L', parent, {}, function(var)
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_GlowColour_L', var, {'Head'})
        end},
    },

        UnsortedB = {
    },
}
--#endregion


Elements:CreateMetatables(ahhTable)


function CCEE:Skin()

    local skinColorCollapse = p:AddCollapsingHeader('Skin')
    local parent = skinColorCollapse

    Elements:PopulateTab(ahhTable.Melanin, parent, 'Melanin')

    Elements:PopulateTab(ahhTable['Hemoglobin'], parent, 'Hemoglobin')

    Elements:PopulateTab(ahhTable['Yellowing'], parent, 'Yellowing')

    Elements:PopulateTab(ahhTable['Vein'], parent, 'Vein')

    Elements:PopulateTab(ahhTable['Freckles'], parent, 'Freckles')

    Elements:PopulateTab(ahhTable['Vitiligo'], parent, 'Vitiligo')

    Elements:PopulateTab(ahhTable.NonSkinBody, parent, 'NonSkin')

    Elements:PopulateTab(ahhTable['Sweat'], parent, 'Sweat')

    Elements:PopulateTab(ahhTable['Blood'], parent, 'Blood')

    Elements:PopulateTab(ahhTable.Dirt_body, parent, 'Dirt')

    local sepa = skinColorCollapse:AddSeparatorText('')

end


function CCEE:Face()

    local faceCollapse = p:AddCollapsingHeader('Face')
    local parent = faceCollapse

    Elements:PopulateTab(ahhTable.Eyes_makeup, parent, 'Eyes makeup')

    Elements:PopulateTab(ahhTable.Lips_makeup, parent, 'Lips makeup')

    Elements:PopulateTab(ahhTable['Tattoo'], parent, 'Tattoo')

    Elements:PopulateTab(ahhTable['Scars'], parent, 'Scars')

    Elements:PopulateTab(ahhTable['Age'], parent, 'Age')

    Elements:PopulateTab(ahhTable['Scales'], parent, 'Scales')

    local sepa1 = faceCollapse:AddSeparatorText('')

end


function CCEE:Head()

    local headCollapse = p:AddCollapsingHeader('Head')
    local parent = headCollapse

    Elements:PopulateTab(ahhTable.NonSkinHead, parent, 'NonSkin')

    Elements:PopulateTab(ahhTable['Eyes'], parent, 'Eyes')


    Elements:PopulateTab(ahhTable['Horns'], parent, 'Horns')


    -- local treeTeeth = headCollapse:AddTree('Teeth')

    local sepa1 = headCollapse:AddSeparatorText('')
end

function CCEE:Body()

    local bodyCollapse = p:AddCollapsingHeader('Body')
    local parent = bodyCollapse

    Elements:PopulateTab(ahhTable.Body_tattoos, parent, 'Tattoes')

    Elements:PopulateTab(ahhTable.Private_parts, parent, 'Private parts')

    local sepa133 = bodyCollapse:AddSeparatorText('')

end

function CCEE:Hair()

    local hairCollapse = p:AddCollapsingHeader('Hair')
    local parent = hairCollapse

    local lashTree = hairCollapse:AddTree('Lashes')

    slLashesIndex = lashTree:AddSliderInt('LashesIndex', 1, 1, 8)
    slLashesIndex.IDContext = 'LashesIndex'
    slLashesIndex.OnChange = function(e)
        HandleAllTex2DMaterialParameters(Apply.entity, 'ID_Depth_Root_Alpha_MSKA', Lashes[e.Value[1]], {'Head'}, 6)
    end


    pcikEyeLC = lashTree:AddColorEdit('Color')
    pcikEyeLC.IDContext = 'eyeLC'
    pcikEyeLC.Float = true
    pcikEyeLC.NoAlpha = true
    pcikEyeLC.OnChange = function()
        -- HandleActiveMaterialParameters(_C(), 'Head', 'Eyelashes_Color', 'Vector3Parameters', pcikEyeLC.Color)
        HandleAllVector3MaterialParameters(Apply.entity, 'Eyelashes_Color', pcikEyeLC, {'Head'})
    end

    local browTree = hairCollapse:AddTree('Eyebrow')

    pickEyeBC = browTree:AddColorEdit('Color')
    pickEyeBC.IDContext = 'eyeBC'
    pickEyeBC.Float = true
    pickEyeBC.NoAlpha = true
    pickEyeBC.OnChange = function()
        -- HandleActiveMaterialParameters(_C(), 'Head', 'Eyebrow_Color', 'Vector3Parameters', pickEyeBC.Color)
        HandleAllVector3MaterialParameters(Apply.entity, 'Eyebrow_Color', pickEyeBC, {'Head'})
    end

    Elements:PopulateTab(ahhTable['Scalp'], parent, 'Scalp')

    Elements:PopulateTab(ahhTable['Hair'], parent, 'Hair')

    Elements:PopulateTab(ahhTable['Beard'], parent, 'Beard')

    Elements:PopulateTab(ahhTable['BodyHair'], parent, 'Body hair')


    local sepa1333 = hairCollapse:AddSeparatorText('')

end

function CCEE:Glow()

    local glowCollapse = p:AddCollapsingHeader('Glow')

    local parent = glowCollapse

    local textGlow = parent:AddBulletText('Only works if glow parameters are available in the current eye preset')
    textGlow:SetColor('Text',  {1.00, 0.75, 0.75, 1.00})

    Elements:PopulateTab(ahhTable['GlowHead'], parent, 'Head')

    local BodyTree = Elements:PopulateTab(ahhTable['GlowBody'], parent, 'Body')


    slGlowMap = BodyTree:AddSliderInt('GlowMapIndex')
    slGlowMap.IDContext = 'GlowMapIndex'
    slGlowMap.OnChange = function(e)
        local def = '947e30dc-fec9-417f-bc4a-a228be6bf565'
        local ext = 'abdc5e70-1969-6227-130c-c3e8282bbd04'
        local var = e.Value[1] == 1 and ext or def
        HandleAllTex2DMaterialParameters(Apply.entity, 'Glowmap', var, {'NakedBody'})
    end

    Elements:PopulateTab(ahhTable['GlowEyes'], parent, 'Eyes')

end

function CCEE:Unsorted()

    local unsotredCollapse = p:AddCollapsingHeader('Unsorted')
    local parent = unsotredCollapse


    -- local slTextNM = p:AddSliderInt('NM', 0,0, #_GLL.Textures, 0)
    -- slTextNM.Value = {0,0,0,0}
    -- slTextNM.OnChange = function ()
    --     local guid = _GLL.Textures[slTextNM.Value[1]]
    --     HandleAllTex2DMaterialParameters(Apply.entity, 'normalmap', guid, {'Head', 'NakedBody'})
    -- end

    -- local slTextNM = p:AddSliderInt('VT Body', 0,0, #BodyVirtualTextures, 0)
    -- slTextNM.Value = {0,0,0,0}
    -- slTextNM.OnChange = function ()
    --     local guid = BodyVirtualTextures[slTextNM.Value[1]]
    --     HandleAllVTMaterialParameters(Apply.entity, 'virtualtexture', guid, {'NakedBody'})
    -- end


    -- local nextTextNM = p:AddButton('<')
    -- nextTextNM.IDContext = 'plkwefma;oekfnm'
    -- nextTextNM.OnClick = function ()
    --     slTextNM.Value = {slTextNM.Value[1]-1, 0,0,0}
    --     local guid = _GLL.Textures[slTextNM.Value[1]]
    --     DPrint(Ext.Resource.Get(guid, 'Texture').Template)
    --     HandleAllTex2DMaterialParameters(Apply.entity, 'normalmap', guid, {'Head'})
    -- end

    -- local prevTextNM = p:AddButton('>')
    -- prevTextNM.SameLine = true
    -- prevTextNM.IDContext = 'plkwefmasdfawsefe;oekfnm'
    -- prevTextNM.OnClick = function ()
    --     slTextNM.Value = {slTextNM.Value[1]+1, 0,0,0}
    --     local guid = _GLL.Textures[slTextNM.Value[1]]
    --     DPrint(Ext.Resource.Get(guid, 'Texture').Template)
    --     HandleAllTex2DMaterialParameters(Apply.entity, 'normalmap', guid, {'Head'})
    -- end

    --Elements:PopulateTab(ahhTable['UnsortedB'], parent, 'UnsortedB')

    local trollXDImSoFunnyICant = parent:AddButton('Delete all game files')
    trollXDImSoFunnyICant.OnClick = function ()
        Imgui.Jiggle(trollXDImSoFunnyICant, 10)
        Imgui.BorderPulse(trollXDImSoFunnyICant, 10)
    end
    local sepa = unsotredCollapse:AddSeparatorText('')

end

function CCEE:PresetsTab()

    -- local sepa = pT:AddSeparatorText('Savings loadings')

    -- local saveParams = pT:AddButton('Save')
    -- saveParams.OnClick = function ()
    --     SaveParamsToFile()
    -- end

    -- local tp3 = saveParams:Tooltip()
    -- tp3:AddText([[
    -- Saves all edited parameters for every character in the scene in local file
    -- AppData\Local\Larian Studios\Baldur's Gate 3\Script Extender\CCEE]])


    -- local loadParams = pT:AddButton('Load')
    -- loadParams.SameLine = true
    -- loadParams.OnClick = function ()
    --     LoadParamsFromFile()
    -- end

    -- local sepapT1 = pT:AddSeparatorText('Presets')




    --local sepapT2 = presetsTab:AddSeparatorText('Save')
    local presetNameLoad = presetsTab:AddInputText('')
    presetNameLoad.IDContext = 'presetNameLoad'

    local savePreset = presetsTab:AddButton('Save')
    savePreset.SameLine = false
    savePreset.IDContext = 'savePreset'
    savePreset.OnClick = function ()
        SavePreset(presetNameLoad.Text)
        presetNameLoad.Text = ''
    end


    local sepapT2 = presetsTab:AddSeparatorText('')


    local presetLoadName = presetsTab:AddInputText('')
    presetLoadName.IDContext = 'presetLoadName'


    E.presetsCombo = presetsTab:AddCombo('')
    E.presetsCombo.Options = _GLL.Presets or {}
    E.presetsCombo.SelectedIndex = 0
    E.presetsCombo.OnChange = function ()
        -- DPrint(E.presetsCombo.Options[E.presetsCombo.SelectedIndex + 1])
    end

    local loadPreset = presetsTab:AddButton('Load')
    loadPreset.SameLine = false
    loadPreset.IDContext = 'CCEE_LoadPreset'
    loadPreset.OnClick = function ()
        local name = (presetLoadName.Text ~= '' and presetLoadName.Text) or E.presetsCombo.Options[E.presetsCombo.SelectedIndex + 1]
        if name then
            LoadPreset(name)
        end
        presetLoadName.Text = ''
    end

    -- local updatePreset = presetsTab:AddButton('Update selected')
    -- updatePreset.SameLine = true
    -- updatePreset.IDContext = 'savePreset'
    -- updatePreset.OnClick = function ()
    --     SavePreset(E.presetsCombo.Options[E.presetsCombo.SelectedIndex + 1])
    -- end


    local updatePreset = presetsTab:AddButton('Update selected')
    updatePreset.SameLine = true
    updatePreset.IDContext = 'savePreset'
    updatePreset.OnClick = function ()

        confirmUpdatePreset.Visible = true
        updatePreset.Visible = false

        updateTimer = Ext.Timer.WaitFor(1000, function()
            confirmUpdatePreset.Visible = false
            updatePreset.Visible = true
        end)

    end


    confirmUpdatePreset = presetsTab:AddButton('Confirm')

    confirmUpdatePreset:SetColor("Button", {0.55, 0.0, 0.0, 1.00})
    confirmUpdatePreset:SetColor("ButtonHovered", {0.35, 0.0, 0.0, 1.0})
    confirmUpdatePreset:SetColor("ButtonActive", {0.25, 0.0, 0.0, 1.0})
    confirmUpdatePreset.Size = {164,35}

    confirmUpdatePreset.SameLine = true
    confirmUpdatePreset.Visible = false
    confirmUpdatePreset.OnClick = function ()
        Ext.Timer.Cancel(updateTimer)
        SavePreset(E.presetsCombo.Options[E.presetsCombo.SelectedIndex + 1])
        updatePreset.Visible = true
        confirmUpdatePreset.Visible = false
    end


    local loadPreset2 = presetsTab:AddButton('Reload current')
    loadPreset2.SameLine = true
    loadPreset2.IDContext = 'loadPrese2'
    loadPreset2.OnClick = function ()
        RealodPreset()
        presetLoadName.Text = ''
    end


    -- local tp6 = loadPreset2:Tooltip()
    -- tp6:AddText([[]])

    local sepa = presetsTab:AddSeparatorText('DO NOT MISSCLICK')

    local loadPresetFirstCC = presetsTab:AddButton('Load after first CC')
    loadPresetFirstCC.IDContext = 'loadPresetFirstCC'
    loadPresetFirstCC.OnClick = function ()
        local name = (presetLoadName.Text ~= '' and presetLoadName.Text) or E.presetsCombo.Options[E.presetsCombo.SelectedIndex + 1]
        if name then
            for _, uuid in pairs(_GLL.States.FirstCCcharacters) do
                _GLL.AllParameters.ActiveMatParameters[uuid] = nil
                _GLL.AllParameters.MatPresetParameters[uuid] = nil
                _GLL.AllParameters.CCEEModStuff.SkinMap[uuid] = nil
            end
            Helpers.Timer:OnTicks(5, function ()
                Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(_GLL.AllParameters.ActiveMatParameters))
                Ext.Net.PostMessageToServer('CCEE_SendMatPresetVars', Ext.Json.Stringify(_GLL.AllParameters.MatPresetParameters))
                Ext.Net.PostMessageToServer('CCEE_SendCCEEModVars', Ext.Json.Stringify(_GLL.AllParameters.CCEEModStuff))
                _GLL.States.FirstCCcharacters = {}
                Helpers.Timer:OnTicks(5, function ()
                    LoadPreset(name)
                end)
            end)
        end
        presetLoadName.Text = ''
    end

    E.info = presetsTab:AddText('')

    local tp7 = loadPresetFirstCC:Tooltip()
    tp7:AddText([[YOU CLICK THIS BUTTON ONLY AFTER FIRST CHARACTER CREATION AND NEVER AGAIN]])

end

function CCEE:SettingsTab()
    E.unlockTats = settingsTab:AddCheckbox('Unlock tattoo and make up sliders')

    E.iconVanity = settingsTab:AddCheckbox('Use camp clothes in portrait')

    -- local sepa = settingsTab:AddSeparator()
    -- local text = settingsTab:AddText('Delay before re-applying parameters')
    -- E.applyDelay = settingsTab:AddSliderInt('ms', 1000, 0, 1000, 0)
    -- E.applyDelay.OnChange = function ()
    --     --Ext.Net.PostMessageToServer('CCEE_Apply_Delay', E.applyDelay.Value[1])
    -- end
end

function CCEE:Reset()

    local resetTableBtn = resetTab:AddButton('Delete data')
    resetTableBtn.OnClick = function ()
        dummies = {}
        Parameters = Parameters or {}
        _GLL.AllParameters = {}
        _GLL.CC_Entities = {}
        -- Parameters = {}

        Ext.Net.PostMessageToServer('CCEE_ResetAllData', '')

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

    local tp2 = resetTableBtn:Tooltip()
    tp2:AddText([[
    The mod stores some data in game save file, this button deletes the data]])


    local resetPresetss = resetTab:AddButton('Purge presets list')
    resetPresetss.OnClick = function ()
        local Presets = {}
        Ext.IO.SaveFile('CCEE/_PresetNames.json', Ext.Json.Stringify(Presets))
        E.presetsCombo.Options = _GLL.Presets or {}
    end

end

function CCEE:Dev()

    local dumpVars = devTab:AddButton('Dump vars')
    dumpVars.OnClick = function ()
        Ext.Net.PostMessageToServer('CCEE_dumpVars', '')
    end

    local resetBtn = devTab:AddButton('Reload SE')
    resetBtn.SameLine = true
    resetBtn.OnClick = function ()
        Ext.Debug.Reset()
    end
    local tp4 = resetBtn:Tooltip()
    tp4:AddText([[
    Hit the buttone if something went wrong]])


    local openMirror = devTab:AddButton('Mirror')
    openMirror.SameLine = true
    openMirror.OnClick = function ()
        Ext.Net.PostMessageToServer('CCEE_Mirror', _C().Uuid.EntityUuid)
    end


    E.firstCC = devTab:AddCheckbox([[I'm in THE first character creation]])
    E.firstCC.OnChange = function ()
        if E.firstCC.Checked then
            _GLL.States.CCState = true
            _GLL.States.firstCC = true
            Apply.entity = getFirsCCDummy()
            table.insert(_GLL.States.FirstCCcharacters, _C().Uuid.EntityUuid)
            DDump(_GLL.States.FirstCCcharacters)
        else
            _GLL.States.firstCC = false
        end
    end


    -- local zeroBtn = devTab:AddButton('Zero')
    -- zeroBtn.OnClick = function ()
    --     Ext.Net.PostMessageToServer('CCEE_setElementsToZero', '')
    -- end


    local status = ''
    E.stateStatus = devTab:AddText('')
    E.stateStatus.Label = status



end

function CCEE:Tests()
    sepate = p:AddSeparatorText('')
    local parent = p
    testParams2 = parent:AddCollapsingHeader('All parameters')
    local x = testParams2:AddBulletText([[Check the save checkbox to be able to save the parameters
Do not edit parameters that already exist in the block above]]);
    x:SetColor('Text',  {1.00, 0.75, 0.75, 1.00})
    function Tests:All()
        Tree = Tree or {}
        Tree1 = Tree1 or {}
        Tree2 = Tree2 or {}
        Tree3 = Tree3 or {}
        Tree4 = Tree4 or {}
        for attachment,_ in pairs(Parameters) do
            Tree[attachment] = testParams2:AddTree(attachment .. '##3123')
            Tree1[attachment] = Tree[attachment]:AddTree('Scalar##3123')
            Tree2[attachment] = Tree[attachment]:AddTree('Vec3##3123')
            Tree3[attachment] = Tree[attachment]:AddTree('Vec##3123')
            Tree4[attachment] = Tree[attachment]:AddTree('Vec2##3123')

            local max = 10
            local min = -max
            function TestAllScalarParameters()
                for _,v in ipairs(Parameters[attachment].ScalarParameters) do
                    local testSlider = Tree1[attachment]:AddDrag(v, 0, min, max, 0.1)
                    testSlider.Logarithmic = false
                    testSlider.IDContext = v .. Ext.Math.Random(1,10000)
                    testSlider.OnChange = function()
                        if testsSave.Checked then
                            --HandleActiveMaterialParameters(Apply.entity, part, v, 'ScalarParameters', testSlider.Value[1])
                            HandleAllScalarMaterialParameters(Apply.entity, v, testSlider, {attachment})
                        else
                            SetActiveMaterialParameterValue(Apply.entity, attachment, v, 'ScalarParameters', testSlider.Value[1])
                        end
                    end
                end
            end
            function TestAllVec3Parameters()
                for _,v in ipairs(Parameters[attachment].Vector3Parameters) do
                    local testPicker = Tree2[attachment]:AddColorEdit(v)
                    testPicker.NoAlpha = true
                    testPicker.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker.OnChange = function()
                        if testsSave.Checked then
                            --HandleActiveMaterialParameters(Apply.entity, part, v, 'Vector3Parameters', testPicker.Color)
                            HandleAllVector3MaterialParameters(Apply.entity, v, testPicker, {attachment})
                        else
                            SetActiveMaterialParameterValue(Apply.entity, attachment, v, 'Vector3Parameters', testPicker.Color)
                        end
                    end
                end
            end
            function TestAllVecParameter()
                for _,v in ipairs(Parameters[attachment].VectorParameters) do
                    local testPicker2 = Tree3[attachment]:AddColorEdit(v)
                    testPicker2.NoAlpha = false
                    testPicker2.IDContext = v .. Ext.Math.Random(1,10000)
                    testPicker2.OnChange = function()
                        if testsSave.Checked then
                            --HandleActiveMaterialParameters(Apply.entity, part, v, 'VectorParameters', testPicker2.Color)
                            HandleAllVectorMaterialParameters(Apply.entity, v, testPicker2, {attachment})
                        else
                            SetActiveMaterialParameterValue(Apply.entity, attachment, v, 'VectorParameters', testPicker2.Color)
                        end
                    end
                end
            end
            function TestAllVec2Parameter()
                if Parameters[attachment].Vector2Parameters then
                    for _,v in ipairs(Parameters[attachment].Vector2Parameters) do
                        local testPicker3 = Tree4[attachment]:AddDrag(v)
                        testPicker3.Components = 2
                        testPicker3.IDContext = v .. Ext.Math.Random(1,10000)
                        testPicker3.OnChange = function(e)
                            if testsSave.Checked then
                                --HandleActiveMaterialParameters(Apply.entity, part, v, 'VectorParameters', testPicker3.Color)
                                HandleAllVectorMaterialParameters(Apply.entity, v, testPicker3, {attachment})
                            else
                                SetActiveMaterialParameterValue(Apply.entity, attachment, v, 'Vector2Parameters', e.Value)
                            end
                        end
                    end
                end
            end
            TestAllScalarParameters()
            TestAllVec3Parameters()
            TestAllVecParameter()
            TestAllVec2Parameter()
       end
    end
    Tests:All()
end



---temp abomination
---
---seems like I have to keep it
function Elements:UpdateElements(charUuid)
    -- DPrint('Elements:UpdateElements')
    if _GLL.AllParameters.ActiveMatParameters and _GLL.AllParameters.ActiveMatParameters[charUuid] then
        local character = _GLL.AllParameters.ActiveMatParameters[charUuid]
        local character2 = _GLL.AllParameters.MatPresetParameters[charUuid]
        --local skinMat = Ext.StaticData.Get(Ext.Entity.Get(charUuid).CharacterCreationAppearance.SkinColor, 'CharacterCreationSkinColor').MaterialPresetUUID
        --local hairMat = Ext.StaticData.Get(Ext.Entity.Get(charUuid).CharacterCreationAppearance.HairColor, 'CharacterCreationHairColor').MaterialPresetUUID


        --ADD UNSORTED BEE

        self['pickMelaninColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3Parameters", "MelaninColor")
        self['slMelaninAmount'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "MelaninAmount")
        self['slMelaninRemoval'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "MelaninRemovalAmount")
        self['slMelaninDarkM'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "MelaninDarkMultiplier")
        self['slMelaninDarkT'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "MelaninDarkThreshold")

        self['pickHemoglobinColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3Parameters", "HemoglobinColor")
        self['slHemoglobinAmount'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "HemoglobinAmount")
        self['pickYellowingColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3Parameters", "YellowingColor")
        self['slYellowingAmount'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "YellowingAmount")
        self['pickVeinColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3Parameters", "VeinColor")
        self['slVeinAmount'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "VeinAmount")

        self['slIntMakeupIndex'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "MakeUpIndex")
        self['pickMakeupColor'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "MakeupColor")
        self['slMakeupInt'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "MakeupIntensity")
        self['slMakeupMet'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "LipsMakeupMetalness")
        self['slMakeupRough'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "MakeupRoughness")

        self['pickLipsColor'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Lips_Makeup_Color")
        self['slLipsInt'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "LipsMakeupIntensity")
        self['slLipsMet'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "LipsMakeupMetalness")
        self['slLipsRough'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "LipsMakeupRoughness")

        self['slIntTattooIndex'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "TattooIndex")
        self['pickTattooColorR'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "TattooColor")
        self['pickTattooColorG'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "TattooColorG")
        self['pickTattooColorB'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "TattooColorB")
        self['pickTattooIntR'].Color = SLOP:getValue(character, "NakedBody", "VectorParameters", "TattooIntensity")

        -- local tattooIntensity = SLOP:getValue(character, "Head", "Vector_1Parameters", "TattooIntensity")[1] or
        --                         SLOP:getValue(character, "Head", "Vector_2Parameters", "TattooIntensity")[1] or
        --                         SLOP:getValue(character, "Head", "Vector_3Parameters", "TattooIntensity")[1] or 0

        -- self['pickTattooIntR'].Value = {tattooIntensity, 0, 0, 0}
        -- self['pickTattooIntG'].Value = {tattooIntensity, 0, 0, 0}
        -- self['pickTattooIntB'].Value = {tattooIntensity, 0, 0, 0}

        self['slTattooMet'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "TattooMetalness")
        self['slTattooRough'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "TattooRoughnessOffset")
        self['slTattooCurve'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "TattooCurvatureInfluence")

        self['slAgeInt'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Age_Weight")
        self['slIntScarIndex'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "ScarIndex")

        self['slEyesHet'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Heterochromia")
        self['slEyesBR'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Blindness")
        self['slEyesBL'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Blindness_L")
        self['pickEyesC'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyes_IrisColour")
        self['pickEyesCL'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyes_IrisColour_L")
        self['pickEyesC2'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyes_IrisSecondaryColour")
        self['pickEyesC2L'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyes_IrisSecondaryColour_L")
        self['pickEyesSC'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyes_ScleraColour")
        self['pickEyesSCL'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyes_ScleraColour_L")
        self['slEyesCI'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "SecondaryColourIntensity")
        self['slEyesCIL'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "SecondaryColourIntensity_L")
        self['slEyesEdge'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "IrisEdgeStrength")
        self['slEyesEdgeL'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "IrisEdgeStrength_L")
        self['slEyesRed'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Redness")
        self['slEyesRedL'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Redness_L")


        self['slBTatI'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "BodyTattooIndex")
        self['pickBTatCR'].Color = SLOP:getValue(character, "NakedBody", "Vector3Parameters", "BodyTattooColor")
        self['pickBTatCG'].Color = SLOP:getValue(character, "NakedBody", "Vector3Parameters", "BodyTattooColorG")
        self['pickBTatCB'].Color = SLOP:getValue(character, "NakedBody", "Vector3Parameters", "BodyTattooColorB")
        self['slBTatIntR'].Color = SLOP:getValue(character, "NakedBody", "VectorParameters", "BodyTattooIntensity")

        -- local bodyTattooIntensity = SLOP:getValue(character, "NakedBody", "Vector_1Parameters", "BodyTattooIntensity")[1] or
        --                             SLOP:getValue(character, "NakedBody", "Vector_2Parameters", "BodyTattooIntensity")[1] or
        --                             SLOP:getValue(character, "NakedBody", "Vector_3Parameters", "BodyTattooIntensity")[1] or 0

        -- self['slBTatIntR'].Value = {bodyTattooIntensity, 0, 0, 0}
        -- self['slBTatIntG'].Value = {bodyTattooIntensity, 0, 0, 0}
        -- self['slBTatIntB'].Value = {bodyTattooIntensity, 0, 0, 0}

        self['slBTatMet'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "TattooMetalness")
        self['slBTatR'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "TattooRoughnessOffset")
        self['slBTatCurve'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "TattooCurvatureInfluence")

        --ADDITIONAL

        self['slScalpMinValue'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_MinValue")
        self['slHornMaskWeight'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_HornMaskWeight")
        self['slGrayingIntensity'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_Graying_Intensity")
        self['slColorTransitionMid'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_ColorTransitionMidPoint")
        self['slColorTransitionSoft'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_ColorTransitionSoftness")
        self['slDepthColorExponent'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_DepthColorExponent")
        self['slDepthColorIntensity'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_DepthColorIntensity")
        self['slIDContrast'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_IDContrast")
        self['slColorDepthContrast'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_ColorDepthContrast")
        self['slScalpRoughness'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_Roughness")
        self['slRoughnessContrast'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_RoughnessContrast")
        self['slScalpScatter'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scalp_Scatter")
        self['pickHairScalpColor'].Color = SLOP:getValue(character, "Hair", "Vector3Parameters", "Hair_Scalp_Color")
        self['pickGrayingColor'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Hair_Scalp_Graying_Color")
        self['pickHueShiftWeight'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Scalp_HueShiftColorWeight")

        self['pickHairColor'].Color = SLOP:getValue(character, "Hair", "Vector3Parameters", "Hair_Color")
        -- self['slSharedNoiseTiling'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "SharedNoiseTiling")
        self['slHairFrizz'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "HairFrizz")
        self['slHairSoupleness'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "HairSoupleness")
        self['slMaxWindMovement'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "MaxWindMovementAmount")
        self['slSoftenTipsAlpha'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "SoftenTipsAlpha")
        -- self['slBaseColorVar'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "BaseColorVar")
        self['slRootTransitionMid'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "RootTransitionMidPoint")
        self['slRootTransitionSoft'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "RootTransitionSoftness")
        self['slDepthColorExponent'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "DepthColorExponent")
        self['slDepthColorIntensity'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "DepthColorIntensity")
        self['slColorDepthContrast'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "ColorDepthContrast")
        self['slDreadNoiseBaseColor'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "DreadNoiseBaseColor")

        self['pickHairGrayingColor'].Color = SLOP:getValue(character, "Hair", "Vector3Parameters", "Hair_Graying_Color")
        self['slGrayingIntensity'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "Graying_Intensity")
        self['slGrayingSeed'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "Graying_Seed")

        self['pickHighlightColor'].Color = SLOP:getValue(character, "Hair", "Vector3Parameters", "Highlight_Color")
        self['slHighlightFalloff'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "Highlight_Falloff")
        self['slHighlightIntensity'].Value = SLOP:getValue(character, "Hair", "ScalarParameters", "Highlight_Intensity")

        self['pickHornsColor'].Color = SLOP:getValue(character, "Horns", "Vector3Parameters", "NonSkinColor")
        --self['pickHornsColor'].Color = SLOP:getValue(character, "Horns", "Vector3Parameters", "NonSkinColor") NON SKIN WEIGHT
        self['pickHornsTipColor'].Color = SLOP:getValue(character, "Horns", "Vector3Parameters", "NonSkinTipColor")
        self['slHornReflectance'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Reflectance")
        self['slHornIntensity'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Intensity")
        self['slHornGlow'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Use_BlackBody")
        -- self['slHornColour_BlackBody'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Colour_BlackBody")
        -- self['slHornUse_ColorRamp'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Use_ColorRamp")
        self['slHornBlackBody_Colour'].Color = SLOP:getValue(character, "Horns", "Vector3Parameters", "BlackBody_Colour")
        self['slHornLength'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Length")
        self['slHornamplitude'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "amplitude")
        self['slHornBPM'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "BPM")
        -- self['slHornamp2'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "amp2")
        self['slHornUse_HeartBeat'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Use_HeartBeat")
        self['slHornBlackbody_PreRamp_Power'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Blackbody_PreRamp_Power")
        self['slHornEmissive_Mult'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Emissive_Mult")
        -- self['slHornContrast'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "Contrast")
        -- self['slHornPreRampIntensity'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "PreRampIntensity")
        -- self['slHornPostRampIntensity'].Value = SLOP:getValue(character, "Horns", "ScalarParameters", "PostRampIntensity")

        pcikEyeLC.Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyelashes_Color")
        pickEyeBC.Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyebrow_Color")

        self['pickNonSkinColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3Parameters", "NonSkinColor")
        self['slNonSkinWeight'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "NonSkin_Weight")
        self['slNonSkinMetalness'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "NonSkinMetalness")
        self['slFreckles'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "Freckles")
        self['slFrecklesWeight'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "FrecklesWeight")
        self['slVitiligo'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "Vitiligo")
        self['slVitiligoWeight'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "VitiligoWeight")
        self['slSweat'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "Sweat")
        self['slBlood'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "Blood")

        self['slIntScaleIndex'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "CustomIndex")
        self['pickScaleColor'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "CustomColor")
        self['slScaleInt'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "CustomIntensity")

        self['slIntScarIndex'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "ScarIndex")
        self['slScarWeight'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Scar_Weight")

        -- self['slIntBeardIndex'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "BeardIndex")
        -- self['pickBeardScalpColor'].Color = SLOP:getValue(character, "Hair", "Vector3Parameters", "Beard_Scalp_Color")
        -- self['pickBeardColor'].Color = SLOP:getValue(character, "Hair", "Vector3Parameters", "Beard_Color")
        -- self['pickBeardGrayingColor'].Color = SLOP:getValue(character, "Hair", "Vector3Parameters", "Beard_Graying_Color")
        -- self['pickBeardHighlightColor'].Color = SLOP:getValue(character, "Hair", "Vector3Parameters", "Beard_Highlight_Color")
        -- self['slBeardMinValue'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "BeardMinValue")
        -- self['slBeardInt'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "BeardIntesity")
        -- self['slBeardDesat'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "BeardDesaturation")
        -- self['slBeardDarken'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "BeardDarken")
        -- self['slBeardGrayingInt'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "Beard_Graying_Intensity")

        self['pickHeadGlowColor'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "GlowColor")
        self['slHeadGlowMult'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "GlowMultiplier")
        self['slHeadAnimdSpeed'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "AnimationSpeed")

        self['pickBodyGlowColor'].Color = SLOP:getValue(character, "NakedBody", "Vector3Parameters", "GlowColor")
        self['slBodyGlowMult'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "GlowMultiplier")
        self['slBodyAnimdSpeed'].Value = SLOP:getValue(character, "NakedBody", "ScalarParameters", "AnimationSpeed")

        self['slEyesGlowBright'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "GlowBrightness")
        self['slEyesGlowBrightL'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "GlowBrightness_L")
        self['slEyesGlowBrightPup'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "GlowBrightnessPupil")
        self['slEyesFxMasking'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "FxMasking")
        self['slEyesFxMaskingL'].Value = SLOP:getValue(character, "Head", "ScalarParameters", "FxMasking_L")
        self['slEyesGlowColor'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyes_GlowColour")
        self['slEyesGlowColorL'].Color = SLOP:getValue(character, "Head", "Vector3Parameters", "Eyes_GlowColour_L")

        self['pickBodyHairC'].Color = SLOP:getValue(character, "Body", "Vector3Parameters", "Body_Hair_Color")

        self['slIntPPOpac'].Value = SLOP:getValue(character, "Private Parts", "ScalarParameters", "InvertOpacity")
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
