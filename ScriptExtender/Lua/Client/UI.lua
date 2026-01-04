---@diagnostic disable: param-type-mismatch

local OPENQUESTIONMARK = true
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
    if ViewportSize[1] <= 1920 and ViewportSize[2] <= 1080 then
        cceeWindow:SetSize({DefaultSize[1]/1.333, DefaultSize[2]/1.333})
    else
        cceeWindow:SetSize(DefaultSize)
    end

    StyleV2:RegisterWindow(cceeWindow)

    ApplyStyle(cceeWindow, 1)

    -- p = cceeWindow

    MCM.SetKeybindingCallback('ccee_toggle_window', function()
        cceeWindow.Open = not cceeWindow.Open
    end)

    MCM.SetKeybindingCallback('ccee_enter_mirror', function()
        Ext.Net.PostMessageToServer('CCEE_Mirror', _C().Uuid.EntityUuid)
    end)


    -- MCM.SetKeybindingCallback('ccee_apply_pm_parameters', function()
    --     Helpers.Timer:OnTicks(2, function ()
    --         ApplyParametersToDummies()
    --     end)

    -- end)


    local bar2 = cceeWindow:AddTabBar('Tabs2')
    local bar = cceeWindow:AddTabBar('Tabs')



    E.devTab2 = bar2:AddTabItem('Main2')
    MainTab(E.devTab2)
    E.sepaMain2 = bar2:AddSeparator()




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
            if _C().Uuid and Globals.AllParameters.ActiveMatParameters and Globals.AllParameters.ActiveMatParameters[uuid] ~= nil and Globals.AllParameters.MatPresetParameters[uuid] ~= nil then
                local uuid = _C().Uuid.EntityUuid
                Globals.AllParameters.ActiveMatParameters[uuid] = nil
                Globals.AllParameters.MatPresetParameters[uuid] = nil
                --lastParametersMV[uuid] = nil
                Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(Globals.AllParameters.ActiveMatParameters))
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
            --ahhTable.Melanin:Vector3(Apply.entity, 'MelaninColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Melanin:Vector3(Apply.entity, 'MelaninColor', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllVector3MaterialParameters(Apply.entity, 'MelaninColor', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

        {nil, 'slMelaninAmount', 'Amount', parent, {}, function(var)
            --ahhTable.Melanin:Scalar(Apply.entity, 'MelaninAmount', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Melanin:Scalar(Apply.entity, 'MelaninAmount', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'MelaninAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},


        {nil, 'slMelaninRemoval', 'Removal amount', parent, {max = 100, log = true}, function(var)
            --ahhTable.Melanin:Scalar(Apply.entity, 'MelaninRemovalAmount', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Melanin:Scalar(Apply.entity, 'MelaninRemovalAmount', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'MelaninRemovalAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},


        {nil, 'slMelaninDarkM', 'Dark multiplier', parent, {max = 100, log = true}, function(var)
            --ahhTable.Melanin:Scalar(Apply.entity, 'MelaninDarkMultiplier', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Melanin:Scalar(Apply.entity, 'MelaninDarkMultiplier', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'MelaninDarkMultiplier', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

        {nil, 'slMelaninDarkT', 'Dark threshold', parent, {max = 1}, function(var)
            --ahhTable.Melanin:Scalar(Apply.entity, 'MelaninDarkThreshold', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Melanin:Scalar(Apply.entity, 'MelaninDarkThreshold', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'MelaninDarkThreshold', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},
    },

    Hemoglobin = {

        {'picker', 'pickHemoglobinColor', 'Color', parent, {}, function(var)
            --ahhTable.Hemoglobin:Vector3(Apply.entity, 'HemoglobinColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Hemoglobin:Vector3(Apply.entity, 'HemoglobinColor', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllVector3MaterialParameters(Apply.entity, 'HemoglobinColor', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

        {nil, 'slHemoglobinAmount', 'Amount', parent, {max = 3}, function(var)
            --ahhTable.Hemoglobin:Scalar(Apply.entity, 'HemoglobinAmount', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Hemoglobin:Scalar(Apply.entity, 'HemoglobinAmount', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'HemoglobinAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},
    },

    Yellowing = {
        {'picker', 'pickYellowingColor', 'Color', parent, {}, function(var)
            -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
            --     --HandleActiveMaterialParameters(Apply.entity, attachment, 'YellowingColor', 'Vector3', var.Color)
            -- end
            --MaterialPreset(Apply.entity, 'YellowingColor', 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
            --ahhTable.Yellowing:Vector3(Apply.entity, 'YellowingColor', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            ----ahhTable.Yellowing:Vector3(Apply.entity, 'YellowingColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'YellowingColor', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

        {nil, 'slYellowingAmount', 'Amount', parent, {min = -300, max = 300, log = true}, function(var)
            --ahhTable.Yellowing:Scalar(Apply.entity, 'YellowingAmount', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Yellowing:Scalar(Apply.entity, 'YellowingAmount', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'YellowingAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},
    },

    Vein = {
        {'picker', 'pickVeinColor', 'Color', parent, {}, function(var)
            --ahhTable.Vein:Vector3(Apply.entity, 'VeinColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Vein:Vector3(Apply.entity, 'VeinColor', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllVector3MaterialParameters(Apply.entity, 'VeinColor', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},

        {nil, 'slVeinAmount', 'Amount', parent, {max = 7}, function(var)
            --ahhTable.Vein:Scalar(Apply.entity, 'VeinAmount', var, 'mp', nil, 'CharacterCreationSkinColor')
            --ahhTable.Vein:Scalar(Apply.entity, 'VeinAmount', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'VeinAmount', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            end},
    },

    NonSkinBody = {
        {'picker', 'pickNonSkinColor', 'NonSkinColor', parent, {}, function(var)
            --ahhTable.NonSkin:Vector3(Apply.entity, 'NonSkinColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'NakedBody', 'Private Parts', 'Tail'})
        end},

        {nil, 'slNonSkinWeight', 'NonSkin_Weight', parent, {max = 2}, function(var)
            --ahhTable.NonSkinBody:Scalar(Apply.entity, 'NonSkin_Weight', var, nil, {'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.NonSkin:Scalar(Apply.entity, 'NonSkin_Weight', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkin_Weight', var, {'NakedBody', 'Private Parts', 'Tail'})
        end},

        {nil, 'slNonSkinMetalness', 'NonSkinMetalness', parent, {max = 1}, function(var)
            --ahhTable.NonSkinBody:Scalar(Apply.entity, 'NonSkinMetalness', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.NonSkin:Scalar(Apply.entity, 'NonSkinMetalness', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkinMetalness', var, {'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Freckles = {
        {nil, 'slFreckles', 'Freckles', parent, {max = 1.3}, function(var)
            --ahhTable.Freckles:Scalar(Apply.entity, 'Freckles', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Freckles:Scalar(Apply.entity, 'Freckles', var, 'mp', nil, 'CharacterCreationSkinColor')
            --SetAdditionalChoices('Freckles', var.Value[1]) --LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
            HandleAllScalarMaterialParameters(Apply.entity, 'Freckles', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},

        {nil, 'slFrecklesWeight', 'FrecklesWeight', parent, {max = 7}, function(var)
            --ahhTable.Freckles:Scalar(Apply.entity, 'FrecklesWeight', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Freckles:Scalar(Apply.entity, 'FrecklesWeight', var, 'mp', nil, 'CharacterCreationSkinColor')
            --SetAdditionalChoices('FrecklesWeight', var.Value[1]) --LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
            HandleAllScalarMaterialParameters(Apply.entity, 'FrecklesWeight', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Vitiligo = {
        {nil, 'slVitiligo', 'Vitiligo', parent, {max = 1}, function(var)
            --ahhTable.Vitiligo:Scalar(Apply.entity, 'Vitiligo', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Vitiligo:Scalar(Apply.entity, 'Vitiligo', var, 'mp', nil, 'CharacterCreationSkinColor')
            --SetAdditionalChoices('Vitiligo', var.Value[1]) --LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
            HandleAllScalarMaterialParameters(Apply.entity, 'Vitiligo', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},

        {nil, 'slVitiligoWeight', 'VitiligoWeight', parent, {max = 1}, function(var)
            --ahhTable.Vitiligo:Scalar(Apply.entity, 'VitiligoWeight', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Vitiligo:Scalar(Apply.entity, 'VitiligoWeight', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'VitiligoWeight', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Sweat = {
        {nil, 'slSweat', 'Sweat (smh)', parent, {max = 2}, function(var)
            --ahhTable.Sweat:Scalar(Apply.entity, 'Sweat', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Sweat:Scalar(Apply.entity, 'Sweat', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'Sweat', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Blood = {
        {nil, 'slBlood', 'Blood', parent, {max = 2}, function(var)
            --ahhTable.Sweat:Scalar(Apply.entity, 'Blood', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Blood:Scalar(Apply.entity, 'Blood', var, 'mp', nil, 'CharacterCreationSkinColor'
            HandleAllScalarMaterialParameters(Apply.entity, 'Blood', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },

    Dirt_body = {
        {nil, 'slDirt', 'Dirt', parent, {max = 2}, function(var)
            --ahhTable.Sweat:Scalar(Apply.entity, 'Dirt', var, nil, {'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Blood:Scalar(Apply.entity, 'Blood', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'Dirt', var, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
        end},
    },


    Eyes_makeup = {
        {'int', 'slIntMakeupIndex', 'Index', parent, {max = 31}, function(var)
            --ahhTable.Eyes_makeup:Scalar(Apply.entity, 'MakeUpIndex', var, nil, {'Head'})
            --ahhTable.Eyes_makeup:Scalar(Apply.entity, 'MakeUpIndex', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'MakeUpIndex', var, {'Head'})
        end},

        {'picker', 'pickMakeupColor', 'Color', parent, {}, function(var)
            --ahhTable.Eyes_makeup:Vector3(Apply.entity, 'MakeupColor', var, nil, {'Head'})
            --ahhTable.Eyes_makeup:Vector3(Apply.entity, 'MakeupColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'MakeupColor', var, {'Head'})
        end},

        {nil, 'slMakeupInt', 'Intensity', parent, {max = 5}, function(var)
            --ahhTable.Eyes_makeup:Scalar(Apply.entity, 'MakeupIntensity', var, nil, {'Head'})
            --ahhTable.Eyes_makeup:Scalar(Apply.entity, 'MakeupIntensity', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'MakeupIntensity', var, {'Head'})
        end},

        {nil, 'slMakeupMet', 'Metalness', parent, {max = 1}, function(var)
            --ahhTable.Eyes_makeup:Scalar(Apply.entity, 'EyesMakeupMetalness', var, nil, {'Head'})
            --ahhTable.Eyes_makeup:Scalar(Apply.entity, 'EyesMakeupMetalness', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'EyesMakeupMetalness', var, {'Head'})
        end},

        {nil, 'slMakeupRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
            --ahhTable.Eyes_makeup:Scalar(Apply.entity, 'MakeupRoughness', var, nil, {'Head'})
            --ahhTable.Eyes_makeup:Scalar(Apply.entity, 'MakeupRoughness', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'MakeupRoughness', var, {'Head'})
        end},
    },

    Lips_makeup = {
        {'picker', 'pickLipsColor', 'Color', parent, {}, function(var)
            --ahhTable.Lips_makeup:Vector3(Apply.entity, 'Lips_Makeup_Color', var, nil, {'Head'})
            --ahhTable.Lips_makeup:Vector3(Apply.entity, 'Lips_Makeup_Color', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'Lips_Makeup_Color', var, {'Head'})
        end},

        {nil, 'slLipsInt', 'LipsMakeupIntensity', parent, {max = 5}, function(var)
            --ahhTable.Lips_makeup:Scalar(Apply.entity, 'LipsMakeupIntensity', var, nil, {'Head'})
            --ahhTable.Lips_makeup:Scalar(Apply.entity, 'LipsMakeupIntensity', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'LipsMakeupIntensity', var, {'Head'})
        end},

        {nil, 'slLipsMet', 'Metalness', parent, {max = 1}, function(var)
            --ahhTable.Lips_makeup:Scalar(Apply.entity, 'LipsMakeupMetalness', var, nil, {'Head'})
            --ahhTable.Lips_makeup:Scalar(Apply.entity, 'LipsMakeupMetalness', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'LipsMakeupMetalness', var, {'Head'})
        end},

        {nil, 'slLipsRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
            --ahhTable.Lips_makeup:Scalar(Apply.entity, 'LipsMakeupRoughness', var, nil, {'Head'})
            --ahhTable.Lips_makeup:Scalar(Apply.entity, 'LipsMakeupRoughness', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'LipsMakeupRoughness', var, {'Head'})
        end},
    },

    Tattoo = {
        {'int', 'slIntTattooIndex', 'Index', parent, {max = 31}, function(var)
            --ahhTable.Tattoo:Scalar(Apply.entity, 'TattooIndex', var, nil, {'Head'})
            --ahhTable.Tattoo:Scalar(Apply.entity, 'TattooIndex', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooIndex', var, {'Head'})
        end},

        {'picker', 'pickTattooColorR', 'Color R', parent, {}, function(var)
            --ahhTable.Tattoo:Vector3(Apply.entity, 'TattooColor', var, nil, {'Head'})
            --ahhTable.Tattoo:Vector3(Apply.entity, 'TattooColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'TattooColor', var, {'Head'})
        end},

        {'picker', 'pickTattooColorG', 'Color G', parent, {}, function(var)
            --ahhTable.Tattoo:Vector3(Apply.entity, 'TattooColorG', var, nil, {'Head'})
            --ahhTable.Tattoo:Vector3(Apply.entity, 'TattooColorG', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'TattooColorG', var, {'Head'})
        end},

        {'picker', 'pickTattooColorB', 'Color B', parent, {}, function(var)
            --ahhTable.Tattoo:Vector3(Apply.entity, 'TattooColorB', var, nil, {'Head'})
            --ahhTable.Tattoo:Vector3(Apply.entity, 'TattooColorB', var, 'mp', nil, 'CharacterCreationSkinColor')
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
            --ahhTable.Tattoo:Vector(Apply.entity, 'TattooIntensity', var, nil, {'Head'})
            --ahhTable.Tattoo:Vector(Apply.entity, 'TattooIntensity', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVectorMaterialParameters(Apply.entity, 'TattooIntensity', var, {'Head'})
        end},




        {nil, 'slAddHeadTatInt', 'Head AdditionalTattooIntensity', parent, {max = 2}, function(var)
            --ahhTable.Tattoo:Scalar(Apply.entity, 'AdditionalTattooIntensity', var, nil, {'Head'})
            --ahhTable.Tattoo:Scalar(Apply.entity, 'AdditionalTattooIntensity', var, 'mp', nil, 'CharacterCreationSkinColor') --idk
            HandleAllScalarMaterialParameters(Apply.entity, 'AdditionalTattooIntensity', var, {'Head'})
        end},

        {'picker', 'pickAddHeadColor', 'Head AdditionalTattooColor', parent, {}, function(var)
            --ahhTable.Tattoo:Vector3(Apply.entity, 'AdditionalTattooColorB', var, nil, {'Head'})
            --ahhTable.Tattoo:Vector3(Apply.entity, 'AdditionalTattooColorB', var, 'mp', nil, 'CharacterCreationSkinColor')--idk
            HandleAllVector3MaterialParameters(Apply.entity, 'AdditionalTattooColorB', var, {'Head'})
        end},

        -- {nil, 'pickTattooIntR', 'Intensity R', parent, {min = -5, max = 5}, function(var)
        --     -- HandleActiveMaterialParameters(Apply.entity, 'Head', 'TattooIntensity', 'Vector_1Parameters', var.Value[1])
        --     --ahhTable.Tattoo:Vector3(Apply.entity, 'TattooIntensity', var, 'mp_1', nil, 'CharacterCreationSkinColor')
        --     Elements['pickTattooIntG'].Value = {0,0,0,0}
        --     Elements['pickTattooIntB'].Value = {0,0,0,0}

        --     end},


        -- {nil, 'pickTattooIntG', 'Intensity G', parent, {min = -5, max = 5}, function(var)
        --     HandleActiveMaterialParameters(Apply.entity, 'Head', 'TattooIntensity', 'Vector_2Parameters', var.Value[1])
        --     Elements['pickTattooIntR'].Value = {0,0,0,0}
        --     Elements['pickTattooIntB'].Value = {0,0,0,0}
        --     end},

        -- {nil, 'pickTattooIntB', 'Intensity B', parent, {min = -5, max = 5}, function(var)
        --     HandleActiveMaterialParameters(Apply.entity, 'Head', 'TattooIntensity', 'Vector_3Parameters', var.Value[1])
        --     Elements['pickTattooIntR'].Value = {0,0,0,0}
        --     Elements['pickTattooIntG'].Value = {0,0,0,0}
        --     end},

        {nil, 'slTattooMet', 'Metalness', parent, {min = 0, max = 1}, function(var)
            --ahhTable.Tattoo:Scalar(Apply.entity, 'TattooMetalness', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooMetalness', var, {'Head'})
        end},

        {nil, 'slTattooRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
            --ahhTable.Tattoo:Scalar(Apply.entity, 'TattooRoughnessOffset', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooRoughnessOffset', var, {'Head'})
        end},

        {nil, 'slTattooCurve', 'Curvature influence', parent, {min = 0, max = 100}, function(var)
            --ahhTable.Tattoo:Scalar(Apply.entity, 'TattooCurvatureInfluence', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooCurvatureInfluence', var, {'Head'})
        end},
    },

    Age = {
        {nil, 'slAgeInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Age:Scalar(Apply.entity, 'Age_Weight', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Age_Weight', var, {'Head'})
        end},
    },

    Scars = {
        {'int', 'slIntScarIndex', 'Index', parent, {max = 24}, function(var)
            --ahhTable.Scars:Scalar(Apply.entity, 'ScarIndex', var, nil, {'Head'})
            --ahhTable.Scars:Scalar(Apply.entity, 'ScarIndex', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'ScarIndex', var, {'Head'})
        end},

        {nil, 'slScarWeight', 'Intensity', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scars:Scalar(Apply.entity, 'Scar_Weight', var, nil, {'Head'})
            --ahhTable.Scars:Scalar(Apply.entity, 'Scar_Weight', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'Scar_Weight', var, {'Head'})
        end},
    },

    Scales = {
        {'int', 'slIntScaleIndex', 'Index', parent, {max = 31}, function(var)
            --ahhTable.Scales:Scalar(Apply.entity, 'CustomIndex', var, nil, {'Head'})
            --ahhTable.Scales:Scalar(Apply.entity, 'CustomIndex', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'CustomIndex', var, {'Head'})
        end},

        {'picker', 'pickScaleColor', 'Color', parent, {}, function(var)
            --ahhTable.Scales:Vector3(Apply.entity, 'CustomColor', var, nil, {'Head'})
            --ahhTable.Scales:Vector3(Apply.entity, 'CustomColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'CustomColor', var, {'Head'})
        end},

        {nil, 'slScaleInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scales:Scalar(Apply.entity, 'CustomIntensity', var, nil, {'Head'})
            --ahhTable.Scales:Scalar(Apply.entity, 'CustomIntensity', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'CustomIntensity', var, {'Head'})
        end},
    },

    Eyes = {
        {'int', 'slEyesHet', 'Heterochromia', parent, {max = 1}, function(var)
            --ahhTable.Eyes:Scalar(Apply.entity, 'Heterochromia', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Heterochromia', var, {'Head'})
        end},

        {nil, 'slEyesBR', 'Blindness R', parent, {max = 3}, function(var)
            --ahhTable.Eyes:Scalar(Apply.entity, 'Blindness', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Blindness', var, {'Head'})
        end},

        {nil, 'slEyesBL', 'Blindness L', parent, {max = 3}, function(var)
            --ahhTable.Eyes:Scalar(Apply.entity, 'Blindness_L', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Blindness_L', var, {'Head'})
        end},

        {'picker', 'pickEyesC', 'Iris color 1', parent, {}, function(var)
            --ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_IrisColour', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_IrisColour', var, {'Head'})
        end},

        {'picker', 'pickEyesCL', 'Iris color 1 L', parent, {}, function(var)
            --ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_IrisColour_L', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_IrisColour_L', var, {'Head'})
        end},

        {'picker', 'pickEyesC2', 'Iris color 2', parent, {}, function(var)
            --ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_IrisSecondaryColour', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_IrisSecondaryColour', var, {'Head'})
        end},

        {'picker', 'pickEyesC2L', 'Iris color 2 L', parent, {}, function(var)
            --ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_IrisSecondaryColour_L', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_IrisSecondaryColour_L', var, {'Head'})
        end},

        {'picker', 'pickEyesSC', 'Sclera color', parent, {}, function(var)
            --ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_ScleraColour', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_ScleraColour', var, {'Head'})
        end},

        {'picker', 'pickEyesSCL', 'Sclera color L', parent, {}, function(var)
            --ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_ScleraColour_L', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_ScleraColour_L', var, {'Head'})
        end},

        {nil, 'slEyesCI', 'Iris color int', parent, {min = -100, max = 100, log = true}, function(var)
            --ahhTable.Eyes:Scalar(Apply.entity, 'SecondaryColourIntensity', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'SecondaryColourIntensity', var, {'Head'})
        end},

        {nil, 'slEyesCIL', 'Iris color int L', parent, {min = -100, max = 100}, function(var)
            --ahhTable.Eyes:Scalar(Apply.entity, 'SecondaryColourIntensity_L', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'SecondaryColourIntensity_L', var, {'Head'})
        end},

        {nil, 'slEyesEdge', 'IrisEdgeStrength', parent, {min = -100, max = 100, log = true}, function(var)
            --ahhTable.Eyes:Scalar(Apply.entity, 'IrisEdgeStrength', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'IrisEdgeStrength', var, {'Head'})
        end},

        {nil, 'slEyesEdgeL', 'IrisEdgeStrength L', parent, {min = -100, max = 100}, function(var)
            --ahhTable.Eyes:Scalar(Apply.entity, 'IrisEdgeStrength_L', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'IrisEdgeStrength_L', var, {'Head'})
        end},

        {nil, 'slEyesRed', 'Redness', parent, {max = 100, log = true}, function(var)
            --ahhTable.Eyes:Scalar(Apply.entity, 'Redness', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Redness', var, {'Head'})
        end},

        {nil, 'slEyesRedL', 'Redness L', parent, {max = 100}, function(var)
            --ahhTable.Eyes:Scalar(Apply.entity, 'Redness_L', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Redness_L', var, {'Head'})
        end},
    },

    NonSkinHead = {
        {'picker', 'pickHeadNonSkinColor', 'NonSkinColor', parent, {}, function(var)
            --ahhTable.NonSkin:Vector3(Apply.entity, 'NonSkinColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'Head'})
        end},

        {nil, 'slHeadNonSkinWeight', 'NonSkin_Weight', parent, {max = 2}, function(var)
            --ahhTable.NonSkinHead:Scalar(Apply.entity, 'NonSkin_Weight', var, nil, {'Head'})
            --ahhTable.NonSkin:Scalar(Apply.entity, 'NonSkin_Weight', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkin_Weight', var, {'Head'})
        end},

        {nil, 'slHeadNonSkinMetalness', 'NonSkinMetalness', parent, {max = 1}, function(var)
            --ahhTable.NonSkinHead:Scalar(Apply.entity, 'NonSkinMetalness', var, nil, {'Head'})
            --ahhTable.NonSkin:Scalar(Apply.entity, 'NonSkinMetalness', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkinMetalness', var, {'Head'})
        end},
    },


    Body_tattoos = {
        {'int', 'slBTatI', 'Index', parent, {max = 19}, function(var)
            -- --ahhTable.Body_tattoos:Scalar(Apply.entity, 'BodyTattooIndex', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Body_tattoos:Scalar(Apply.entity, 'BodyTattooIndex', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'BodyTattooIndex', var, {'NakedBody', 'Tail'})
        end},

        {'picker', 'pickBTatCR', 'Color R', parent, {}, function(var)
            -- --ahhTable.Body_tattoos:Vector3(Apply.entity, 'BodyTattooColor', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Body_tattoos:Vector3(Apply.entity, 'BodyTattooColor', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'BodyTattooColor', var, {'NakedBody', 'Tail'})
        end},

        {'picker', 'pickBTatCG', 'Color G', parent, {}, function(var)
            -- --ahhTable.Body_tattoos:Vector3(Apply.entity, 'BodyTattooColorG', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Body_tattoos:Vector3(Apply.entity, 'BodyTattooColorG', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'BodyTattooColorG', var, {'NakedBody', 'Tail'})
        end},

        {'picker', 'pickBTatCB', 'Color B', parent, {}, function(var)
            -- --ahhTable.Body_tattoos:Vector3(Apply.entity, 'BodyTattooColorB', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
            --ahhTable.Body_tattoos:Vector3(Apply.entity, 'BodyTattooColorB', var, 'mp', nil, 'CharacterCreationSkinColor')
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
            --ahhTable.Body_tattoos:Vector(Apply.entity, 'BodyTattooIntensity', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVectorMaterialParameters(Apply.entity, 'BodyTattooIntensity', var, {'NakedBody', 'Tail'})
        end},

        {'picker', 'pickAddBodyColor', 'Body AdditionalTattooColor', parent, {}, function(var)
            --ahhTable.Body_tattoos:Vector3(Apply.entity, 'AdditionalTattooColorB', var, nil, {'NakedBody'})
            --ahhTable.Body_tattoos:Vector3(Apply.entity, 'AdditionalTattooColorB', var, 'mp', nil, 'CharacterCreationSkinColor') --idk
            HandleAllVector3MaterialParameters(Apply.entity, 'AdditionalTattooColorB', var, {'NakedBody'})
        end},

        {nil, 'slAddBodyTatInt', 'Body AdditionalTattooIntensity', parent, {max = 2}, function(var)
            --ahhTable.Body_tattoos:Scalar(Apply.entity, 'AdditionalTattooIntensity', var, nil, {'NakedBody'})
            --ahhTable.Body_tattoos:Scalar(Apply.entity, 'AdditionalTattooIntensity', var, 'mp', nil, 'CharacterCreationSkinColor')--idk
            HandleAllScalarMaterialParameters(Apply.entity, 'AdditionalTattooIntensity', var, {'NakedBody'})
        end},



        -- {nil, 'slBTatIntR', 'Intensity R', parent, {min = -5, max = 5}, function(var)
        --     for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
        --         HandleActiveMaterialParameters(Apply.entity, attachment, 'BodyTattooIntensity', 'Vector_1Parameters', var.Value[1])
        --         -- HandleActiveMaterialParameters(Apply.entity, attachment, 'TattooIntensity', 'Vector_1Parameters', var.Value[1])
        --     end
        --     Elements['slBTatIntG'].Value = {0,0,0,0}
        --     Elements['slBTatIntB'].Value = {0,0,0,0}
        -- end},

        -- {nil, 'slBTatIntG', 'Intensity G', parent, {min = -5, max = 5}, function(var)
        --     for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
        --         HandleActiveMaterialParameters(Apply.entity, attachment, 'BodyTattooIntensity', 'Vector_2Parameters', var.Value[1])
        --     end


        --     -- MaterialPreset(Apply.entity, 'BodyTattooIntensity', 'Vector3Parameters', {var.Value[1],0,0,0})

        --     Elements['slBTatIntR'].Value = {0,0,0,0}
        --     Elements['slBTatIntB'].Value = {0,0,0,0}
        -- end},

        -- {nil, 'slBTatIntB', 'Intensity B', parent, {min = -5, max = 5}, function(var)
        --     for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
        --         HandleActiveMaterialParameters(Apply.entity, attachment, 'BodyTattooIntensity', 'Vector_3Parameters', var.Value[1])
        --     end
        --     Elements['slBTatIntR'].Value = {0,0,0,0}
        --     Elements['slBTatIntG'].Value = {0,0,0,0}
        -- end},

        {nil, 'slBTatMet', 'Metalness', parent, {max = 1}, function(var)
            --ahhTable.Body_tattoos:Scalar(Apply.entity, 'TattooMetalness', var, nil, {'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooMetalness', var, {'NakedBody', 'Tail'})
        end},

        {nil, 'slBTatR', 'Roughness', parent, {min = -1, max = 1}, function(var)
            --ahhTable.Body_tattoos:Scalar(Apply.entity, 'TattooRoughnessOffset', var, nil, {'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooRoughnessOffset', var, {'NakedBody', 'Tail'})
        end},

        {nil, 'slBTatCurve', 'Curvature influence', parent, {max = 100}, function(var)
            --ahhTable.Body_tattoos:Scalar(Apply.entity, 'TattooCurvatureInfluence', var, nil, {'NakedBody', 'Private Parts', 'Tail'})
            HandleAllScalarMaterialParameters(Apply.entity, 'TattooCurvatureInfluence', var, {'NakedBody', 'Tail'})
        end}
    },

    Private_parts = {
        {'int', 'slIntPPOpac', 'Toggle', parent, {def = 1}, function(var)
            --ahhTable.Private_parts:Scalar(Apply.entity, 'InvertOpacity', var, nil, {'Private parts'})
            HandleAllScalarMaterialParameters(Apply.entity, 'InvertOpacity', var, {'Private parts'})
        end},
    },

    Scalp = {
        {'picker', 'pickHairScalpColor', 'Hair Scalp Color', parent, {}, function(var)
            -- --ahhTable.Scalp:Vector3(Apply.entity, 'Hair_Scalp_Color', var, nil, {'Head'})
            --ahhTable.Scalp:Vector3(Apply.entity, 'Hair_Scalp_Color', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'Hair_Scalp_Color', var, {'Head'})
        end},

        {'picker', 'pickHueShiftWeight', 'Hue Shift Weight', parent, {}, function(var)
            -- --ahhTable.Scalp:Vector3(Apply.entity, 'Scalp_HueShiftColorWeight', var, nil, {'Head'})
            --ahhTable.Scalp:Vector3(Apply.entity, 'Scalp_HueShiftColorWeight', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'Scalp_HueShiftColorWeight', var, {'Head'})
        end},

        {'picker', 'pickBeardScalpColor', 'Beard Scalp Color', parent, {}, function(var)
            --ahhTable.Scalp:Vector3(Apply.entity, 'Beard_Scalp_Color', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Scalp_Color', var, {'Head'})
        end},

        {nil, 'slScalpMinValue', 'Scalp Min Value', parent, {min = -1, max = 1}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_MinValue', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_MinValue', var, {'Head'})
        end},

        {nil, 'slHornMaskWeight', 'Horn Mask Weight', parent, {min = -1, max = 1}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_HornMaskWeight', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_HornMaskWeight', var, {'Head'})
        end},

        {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_Graying_Intensity', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_Graying_Intensity', var, {'Head'})
        end},

        {'picker', 'pickGrayingColor', 'Graying Color', parent, {}, function(var)
            --ahhTable.Scalp:Vector3(Apply.entity, 'Hair_Scalp_Graying_Color', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Hair_Scalp_Graying_Color', var, {'Head'})
        end},

        {nil, 'slColorTransitionMid', 'Color Transition Mid', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_ColorTransitionMidPoint', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_ColorTransitionMidPoint', var, {'Head'})
        end},

        {nil, 'slColorTransitionSoft', 'Color Transition Soft', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_ColorTransitionSoftness', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_ColorTransitionSoftness', var, {'Head'})
        end},

        {nil, 'slDepthColorExponent', 'Depth Color Exponent', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_DepthColorExponent', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_DepthColorExponent', var, {'Head'})
        end},

        {nil, 'slDepthColorIntensity', 'Depth Color Intensity', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_DepthColorIntensity', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_DepthColorIntensity', var, {'Head'})
        end},

        {nil, 'slIDContrast', 'ID Contrast', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_IDContrast', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_IDContrast', var, {'Head'})
        end},

        {nil, 'slColorDepthContrast', 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_ColorDepthContrast', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_ColorDepthContrast', var, {'Head'})
        end},

        {nil, 'slScalpRoughness', 'Scalp Roughness', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_Roughness', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_Roughness', var, {'Head'})
        end},

        {nil, 'slRoughnessContrast', 'Roughness Contrast', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_RoughnessContrast', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_RoughnessContrast', var, {'Head'})
        end},

        {nil, 'slScalpScatter', 'Scalp Scatter', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_Scatter', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Scalp_Scatter', var, {'Head'})
        end},
    },


    Hair = {
        {'picker', 'pickHairColor', 'Hair Color', parent, {}, function(var)
            -- --ahhTable.Hair:Vector3(Apply.entity, 'Hair_Color', var, nil, {'Hair'})
            --ahhTable.Hair:Vector3(Apply.entity, 'Hair_Color', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'Hair_Color', var, {'Hair'})
        end},

        {'picker', 'pickHairGrayingColor', 'Hair Graying Color', parent, {}, function(var)
            --ahhTable.Graying:Vector3(Apply.entity, 'Hair_Graying_Color', var, nil, {'Hair'})
            --ahhTable.Graying:Vector3(Apply.entity, 'Hair_Graying_Color', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'Hair_Graying_Color', var, {'Hair'})
        end},

        {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1.2}, function(var)
            --ahhTable.Graying:Scalar(Apply.entity, 'Graying_Intensity', var, nil, {'Hair'})
            --ahhTable.Graying:Scalar(Apply.entity, 'Graying_Intensity', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'Graying_Intensity', var, {'Hair'})
        end},

        {nil, 'slGrayingSeed', 'Graying Seed', parent, {min = -10, max = 10, log = true}, function(var)
            --ahhTable.Graying:Scalar(Apply.entity, 'Graying_Seed', var, nil, {'Hair'})
            --ahhTable.Graying:Scalar(Apply.entity, 'Graying_Seed', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'Graying_Seed', var, {'Hair'})
        end},

        {'picker', 'pickHighlightColor', 'Highlight Color', parent, {}, function(var)
            --ahhTable.Highlights:Vector3(Apply.entity, 'Highlight_Color', var, nil, {'Hair'})
            --ahhTable.Hair:Vector3(Apply.entity, 'Highlight_Color', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'Highlight_Color', var, {'Hair'})
        end},

        {nil, 'slHighlightFalloff', 'Highlight Falloff', parent, {min = -1, log = true}, function(var)
            --ahhTable.Highlights:Scalar(Apply.entity, 'Highlight_Falloff', var, nil, {'Hair'})
            --ahhTable.Hair:Scalar(Apply.entity, 'Highlight_Falloff', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'Highlight_Falloff', var, {'Hair'})
        end},

        {nil, 'slHighlightIntensity', 'Highlight Intensity', parent, {max = 3, log = true}, function(var)
            --ahhTable.Highlights:Scalar(Apply.entity, 'Highlight_Intensity', var, nil, {'Hair'})
            --ahhTable.Hair:Scalar(Apply.entity, 'Highlight_Intensity', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'Highlight_Intensity', var, {'Hair'})
        end},

        {nil, 'slHairDirt', 'Dirt', parent, {max = 2}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'Dirt', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Dirt', var, {'Hair'})
        end},

        {'picker', 'slHairDirtColor', 'Dirt color', parent, {max = 2}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'Dirt', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'DirtColor', var, {'Hair'})
        end},

        {nil, 'slHairBlood', 'Blood', parent, {max = 2}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'Dirt', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Blood', var, {'Hair'})
        end},


        {'picker', 'slHairBloodColor', 'Blood color', parent, {max = 2}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'Dirt', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Blood_Color', var, {'Hair'})
        end},


        {nil, 'slHairRoughness', 'Roughness', parent, {min = -1, max = 1}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'Roughness', var, nil, {'Hair'})
            --ahhTable.Hair:Scalar(Apply.entity, 'Roughness', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllScalarMaterialParameters(Apply.entity, 'Roughness', var, {'Hair'})
        end},

        {nil, 'slRootTransitionMid', 'Root Transition Mid', parent, {}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'RootTransitionMidPoint', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'RootTransitionMidPoint', var, {'Hair'})
        end},

        {nil, 'slRootTransitionSoft', 'Root Transition Soft', parent, {min = -2, max = 2}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'RootTransitionSoftness', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'RootTransitionSoftness', var, {'Hair'})
        end},

        {nil, 'slDepthColorExponent', 'Depth Color Exponent', parent, {}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'DepthColorExponent', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'DepthColorExponent', var, {'Hair'})
        end},

        {nil, 'slDepthColorIntensity', 'Depth Color Intensity', parent, {}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'DepthColorIntensity', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'DepthColorIntensity', var, {'Hair'})
        end},

        {nil, 'slColorDepthContrast', 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'ColorDepthContrast', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'ColorDepthContrast', var, {'Hair'})
        end},



        {nil, 'slHairRoughness', 'Roughness contrast', parent, {min = -1, max = 1}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'RoughnessContrast', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'RoughnessContrast', var, {'Hair'})
        end},


        {nil, 'slHairFrizz', 'Hair Frizz', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'HairFrizz', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'HairFrizz', var, {'Hair'})
        end},

        {nil, 'slHairSoupleness', 'Hair Soupleness', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'HairSoupleness', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'HairSoupleness', var, {'Hair'})
        end},

        {nil, 'slMaxWindMovement', 'Max Wind Movement', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'MaxWindMovementAmount', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'MaxWindMovementAmount', var, {'Hair'})
        end},

        {nil, 'slSoftenTipsAlpha', 'Soften Tips Alpha', parent, {}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'SoftenTipsAlpha', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'SoftenTipsAlpha', var, {'Hair'})
        end},

        {nil, 'slBacklit', 'Backlit', parent, {}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'HairBacklit', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'HairBacklit', var, {'Hair'})
        end},


        {nil, 'slDreadNoiseBaseColor', 'Dread Noise Base Color', parent, {}, function(var)
            --ahhTable.Hair:Scalar(Apply.entity, 'DreadNoiseBaseColor', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'DreadNoiseBaseColor', var, {'Hair'})
        end},

        {'picker', 'pickHairAcc1', 'Accs NonSkinColor', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'NonSkinColor', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc2', 'Accs NonSkinTipColor', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'NonSkinTipColor', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinTipColor', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc3', 'Accs SkinApproxColor', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'SkinApproxColor', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'SkinApproxColor', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc4', 'Accs Cloth_Primary', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Cloth_Primary', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Cloth_Primary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc5', 'Accs Cloth_Secondary', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Cloth_Secondary', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Cloth_Secondary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc6', 'Accs Cloth_Tertiary', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Cloth_Tertiary', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Cloth_Tertiary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc7', 'Accs Accent_Color', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Accent_Color', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Accent_Color', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc8', 'Accs Leather_Primary', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Leather_Primary', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Leather_Primary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc9', 'Accs Leather_Secondary', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Leather_Secondary', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Leather_Secondary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc10', 'Accs Leather_Tertiary', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Leather_Tertiary', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Leather_Tertiary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc11', 'Accs Custom_1', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Custom_1', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Custom_1', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc12', 'Accs Custom_2', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Custom_2', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Custom_2', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc13', 'Accs Metal_Primary', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Metal_Primary', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Metal_Primary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc14', 'Accs Metal_Secondary', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Metal_Secondary', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Metal_Secondary', var, {'Hair'})
        end},
        {'picker', 'pickHairAcc15', 'Accs Metal_Tertiary', parent, {}, function(var)
            --ahhTable.Hair:Vector3(Apply.entity, 'Metal_Tertiary', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Metal_Tertiary', var, {'Hair'})
        end},
    },


    Beard = {
        {'int', 'slIntBeardIndex', 'BeardIndex', parent, {min = -1, max = 100}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'BeardIndex', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardIndex', var, {'Head'})
        end},

        {'picker', 'pickBeardColor', 'Beard Color', parent, {}, function(var)
            --ahhTable.Beard:Vector3(Apply.entity, 'Beard_Color', var, nil, {'Hair'})
            --ahhTable.Beard:Vector3(Apply.entity, 'Beard_Color', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Color', var, {'Hair'})
        end},

        {'picker', 'pickBeardScalpColor', 'Beard Scalp Color', parent, {}, function(var)
            --ahhTable.Beard:Vector3(Apply.entity, 'Beard_Scalp_Color', var, nil, {'Hair'})
            --ahhTable.Beard:Vector3(Apply.entity, 'Beard_Scalp_Color', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Scalp_Color', var, {'Hair'})
        end},

        {'picker', 'pickBeardGrayingColor', 'Beard Graying Color', parent, {}, function(var)
            --ahhTable.Beard:Vector3(Apply.entity, 'Beard_Graying_Color', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Graying_Color', var, {'Hair'})
        end},

        {nil, 'slBeardGrayingInt', 'Beard Graying Intensity', parent, {min = -100, max = 100}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'Beard_Graying_Intensity', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Beard_Graying_Intensity', var, {'Hair'})
        end},

        {'picker', 'pickBeardHighlightColor', 'Beard Highlight Color', parent, {}, function(var)
            --ahhTable.Beard:Vector3(Apply.entity, 'Beard_Highlight_Color', var, nil, {'Hair'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Beard_Highlight_Color', var, {'Hair'})
        end},

        {nil, 'slBeardMinValue', 'Beard Min Value', parent, {min = -10, max = 10}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'BeardMinValue', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardMinValue', var, {'Head'})
        end},

        {nil, 'slBeardInt', 'Beard Intesity', parent, {min = -100, max = 100}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'BeardIntesity', var, nil, {'Hair'})
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardIntesity', var, {'Hair'})
        end},

        {nil, 'slBeardDesat', 'Beard Desaturation', parent, {min = -100, max = 100}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'BeardDesaturation', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardDesaturation', var, {'Head'})
        end},

        {nil, 'slBeardDarken', 'Beard Darken', parent, {min = -100, max = 100}, function(var)
            --ahhTable.Beard:Scalar(Apply.entity, 'BeardDarken', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'BeardDarken', var, {'Head'})
        end},


    },

    BodyHair = {
        {'picker', 'pickBodyHairC', 'Body Hair Color', parent, {}, function(var)
            -- --ahhTable.BodyHair:Vector3(Apply.entity, 'Body_Hair_Color', var, nil, {'NakedBody', 'Private Parts'})
            --ahhTable.BodyHair:Vector3(Apply.entity, 'Body_Hair_Color', var, 'mp', nil, 'CharacterCreationSkinColor')
            HandleAllVector3MaterialParameters(Apply.entity, 'Body_Hair_Color', var, {'NakedBody', 'Private Parts'})
        end},
    },


    Horns = {
        {'picker', 'pickHornsColor', 'Color', parent, {}, function(var)
            --ahhTable.Horns:Vector3(Apply.entity, 'NonSkinColor', var, nil, {'Horns'})
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'Horns'})
        end},

        {'picker', 'pickHeadNSColor', 'Head Thing Color', parent, {}, function(var)
            --ahhTable.Horns:Vector3(Apply.entity, 'NonSkinColor', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinColor', var, {'Head'})
        end},

        {nil, 'slHornsNonSkinWeight', 'NonSkin_Weight', parent, {max = 2}, function(var)
            --ahhTable.NonSkin:Scalar(Apply.entity, 'NonSkin_Weight', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkin_Weight', var, {'Head'})
        end},

        {nil, 'slHornsNonSkinMetalness', 'NonSkinMetalness', parent, {max = 2}, function(var)
            --ahhTable.NonSkin:Scalar(Apply.entity, 'NonSkinMetalness', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'NonSkinMetalness', var, {'Head'})
        end},

        {'picker', 'pickHornsTipColor', 'Tip Color', parent, {}, function(var)
            --ahhTable.Horns:Vector3(Apply.entity, 'NonSkinTipColor', var, nil, {'Horns'})
            HandleAllVector3MaterialParameters(Apply.entity, 'NonSkinTipColor', var, {'Horns'})
        end},

        {nil, 'slHornReflectance', 'Reflectance', parent, {}, function(var)
            --ahhTable.Horns:Scalar(Apply.entity, 'Reflectance', var, nil, {'Horns'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Reflectance', var, {'Horns'})
        end},

        {'int', 'slHornGlow', 'Toggle Glow', parent, {}, function(var)
            --ahhTable.Horns:Scalar(Apply.entity, 'Use_BlackBody', var, nil, {'Horns'})
            --ahhTable.Horns:Scalar(Apply.entity, 'Colour_BlackBody', var, nil, {'Horns'})
            --ahhTable.Horns:Scalar(Apply.entity, 'Use_ColorRamp', var, nil, {'Horns'})
            for _, parameter in pairs({'Use_BlackBody','Colour_BlackBody','Use_ColorRamp'}) do
                HandleAllScalarMaterialParameters(Apply.entity, parameter, var, {'Horns'})
            end
        end},

        {'picker', 'slHornBlackBody_Colour', 'Glow Color', parent, {}, function(var)
            --ahhTable.Horns:Vector3(Apply.entity, 'BlackBody_Colour', var, nil, {'Horns'})
            HandleAllVector3MaterialParameters(Apply.entity, 'BlackBody_Colour', var, {'Horns'})
        end},

        {nil, 'slHornIntensity', 'Glow Intensity', parent, {max = 200, log = true}, function(var)
            --ahhTable.Horns:Scalar(Apply.entity, 'Intensity', var, nil, {'Horns'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Intensity', var, {'Horns'})
        end},

        {nil, 'slHornBlackbody_PreRamp_Power', 'Also Glow Intensity', parent, {}, function(var)
            --ahhTable.Horns:Scalar(Apply.entity, 'Blackbody_PreRamp_Power', var, nil, {'Horns'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Blackbody_PreRamp_Power', var, {'Horns'})
        end},

        {nil, 'slHornEmissive_Mult', 'Emissive Mult', parent, {min = -100, max = 100, log = true}, function(var)
            --ahhTable.Horns:Scalar(Apply.entity, 'Emissive_Mult', var, nil, {'Horns'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Emissive_Mult', var, {'Horns'})
        end},

        {'int', 'slHornUse_HeartBeat', 'Use HeartBeat', parent, {}, function(var)
            --ahhTable.Horns:Scalar(Apply.entity, 'Use_HeartBeat', var, nil, {'Horns'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Use_HeartBeat', var, {'Horns'})
        end},

        {nil, 'slHornLength', 'Length', parent, {min = -100, max = 100, log = true}, function(var)
            --ahhTable.Horns:Scalar(Apply.entity, 'Length', var, nil, {'Horns'})
            HandleAllScalarMaterialParameters(Apply.entity, 'Length', var, {'Horns'})
        end},

        {nil, 'slHornamplitude', 'Amplitude', parent, {min = -100, max = 100, log = true}, function(var)
            --ahhTable.Horns:Scalar(Apply.entity, 'amplitude', var, nil, {'Horns'})
            HandleAllScalarMaterialParameters(Apply.entity, 'amplitude', var, {'Horns'})
        end},

        {nil, 'slHornBPM', 'BPM', parent, {min = -100, max = 100, log = true}, function(var)
            --ahhTable.Horns:Scalar(Apply.entity, 'BPM', var, nil, {'Horns'})
            HandleAllScalarMaterialParameters(Apply.entity, 'BPM', var, {'Horns'})
        end},
    },


    GlowHead = {
        {'picker', 'pickHeadGlowColor', 'Color', parent, {}, function(var)
            --ahhTable.GlowHead:Vector3(Apply.entity, 'GlowColor', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'GlowColor', var, {'Head'})
        end},

        {nil, 'slHeadGlowMult', 'Multiplier', parent, {max = 5}, function(var)
            --ahhTable.GlowHead:Scalar(Apply.entity, 'GlowMultiplier', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowMultiplier', var, {'Head'})
        end},

        {nil, 'slHeadAnimdSpeed', 'Animation speed', parent, {max = 10}, function(var)
            --ahhTable.GlowHead:Scalar(Apply.entity, 'AnimationSpeed', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'AnimationSpeed', var, {'Head'})
        end},
    },

    GlowBody = {
        {'picker', 'pickBodyGlowColor', 'Color', parent, {}, function(var)
            --ahhTable.GlowBody:Vector3(Apply.entity, 'GlowColor', var, nil, {'NakedBody'})
            HandleAllVector3MaterialParameters(Apply.entity, 'GlowColor', var, {'NakedBody'})
        end},

        {nil, 'slBodyGlowMult', 'Multiplier', parent, {max = 5}, function(var)
            --ahhTable.GlowBody:Scalar(Apply.entity, 'GlowMultiplier', var, nil, {'NakedBody'})
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowMultiplier', var, {'NakedBody'})
        end},

        {nil, 'slBodyAnimdSpeed', 'Animation speed', parent, {max = 10}, function(var)
            --ahhTable.GlowBody:Scalar(Apply.entity, 'AnimationSpeed', var, nil, {'NakedBody'})
            HandleAllScalarMaterialParameters(Apply.entity, 'AnimationSpeed', var, {'NakedBody'})
        end},
    },

    GlowEyes = {
        {nil, 'slEyesGlowBright', 'Brightness', parent, {min = -200, max = 200}, function(var)
            --ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightness', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowBrightness', var, {'Head'})
        end},

        {nil, 'slEyesGlowBrightL', 'Brightness L', parent, {min = -200, max = 200}, function(var)
            --ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightness_L', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowBrightness_L', var, {'Head'})
        end},

        {nil, 'slEyesGlowBrightPup', 'Brightness pupil', parent, {min = -100, max = 100, log = true}, function(var)
            --ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightnessPupil', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'GlowBrightnessPupil', var, {'Head'})
        end},

        {nil, 'slEyesFxMasking', 'Fx masking', parent, {min = -100, max = 100, log = true}, function(var)
            --ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightnessPupil', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'FxMasking', var, {'Head'})
        end},

        {nil, 'slEyesFxMaskingL', 'Fx masking L', parent, {min = -100, max = 100, log = true}, function(var)
            --ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightnessPupil', var, nil, {'Head'})
            HandleAllScalarMaterialParameters(Apply.entity, 'FxMasking_L', var, {'Head'})
        end},

        {'picker', 'slEyesGlowColor', 'Color', parent, {}, function(var)
            --ahhTable.GlowEyes:Vector3(Apply.entity, 'Eyes_GlowColour', var, nil, {'Head'})
            HandleAllVector3MaterialParameters(Apply.entity, 'Eyes_GlowColour', var, {'Head'})
        end},

        {'picker', 'slEyesGlowColorL', 'Color L', parent, {}, function(var)
            --ahhTable.GlowEyes:Vector3(Apply.entity, 'Eyes_GlowColour_L', var, nil, {'Head'})
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


    pcikEyeLC = lashTree:AddColorEdit('Color')
    pcikEyeLC.IDContext = 'eyeLC'
    pcikEyeLC.Float = true
    pcikEyeLC.NoAlpha = true
    pcikEyeLC.OnChange = function()
        -- HandleActiveMaterialParameters(_C(), 'Head', 'Eyelashes_Color', 'Vector3Parameters', pcikEyeLC.Color)
        --ahhTable.Hair:Vector3(Apply.entity, 'Eyelashes_Color', pcikEyeLC, 'mp', nil, 'CharacterCreationSkinColor')
        HandleAllVector3MaterialParameters(Apply.entity, 'Eyelashes_Color', pcikEyeLC, {'Head'})
    end

    local browTree = hairCollapse:AddTree('Eyebrow')

    pickEyeBC = browTree:AddColorEdit('Color')
    pickEyeBC.IDContext = 'eyeBC'
    pickEyeBC.Float = true
    pickEyeBC.NoAlpha = true
    pickEyeBC.OnChange = function()
        -- HandleActiveMaterialParameters(_C(), 'Head', 'Eyebrow_Color', 'Vector3Parameters', pickEyeBC.Color)
        --ahhTable.Hair:Vector3(Apply.entity, 'Eyebrow_Color', pickEyeBC, 'mp', nil, 'CharacterCreationSkinColor')
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

    Elements:PopulateTab(ahhTable['GlowBody'], parent, 'Body')

    Elements:PopulateTab(ahhTable['GlowEyes'], parent, 'Eyes')


end

function CCEE:Unsorted()

    local unsotredCollapse = p:AddCollapsingHeader('Unsorted')
    local parent = unsotredCollapse


    -- local slTextNM = p:AddSliderInt('NM', 0,0, #Globals.Textures, 0)
    -- slTextNM.Value = {0,0,0,0}
    -- slTextNM.OnChange = function ()
    --     local guid = Globals.Textures[slTextNM.Value[1]]
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
    --     local guid = Globals.Textures[slTextNM.Value[1]]
    --     DPrint(Ext.Resource.Get(guid, 'Texture').Template)
    --     HandleAllTex2DMaterialParameters(Apply.entity, 'normalmap', guid, {'Head'})
    -- end

    -- local prevTextNM = p:AddButton('>')
    -- prevTextNM.SameLine = true
    -- prevTextNM.IDContext = 'plkwefmasdfawsefe;oekfnm'
    -- prevTextNM.OnClick = function ()
    --     slTextNM.Value = {slTextNM.Value[1]+1, 0,0,0}
    --     local guid = Globals.Textures[slTextNM.Value[1]]
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
    E.presetsCombo.Options = Globals.Presets or {}
    E.presetsCombo.SelectedIndex = 0
    E.presetsCombo.OnChange = function ()
        DPrint(E.presetsCombo.Options[E.presetsCombo.SelectedIndex + 1])
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
            for _, uuid in pairs(Globals.States.FirstCCcharacters) do
                Globals.AllParameters.ActiveMatParameters[uuid] = nil
                Globals.AllParameters.MatPresetParameters[uuid] = nil
                Globals.AllParameters.CCEEModStuff.SkinMap[uuid] = nil
            end
            Helpers.Timer:OnTicks(5, function ()
                Ext.Net.PostMessageToServer('CCEE_SendActiveMatVars', Ext.Json.Stringify(Globals.AllParameters.ActiveMatParameters))
                Ext.Net.PostMessageToServer('CCEE_SendMatPresetVars', Ext.Json.Stringify(Globals.AllParameters.MatPresetParameters))
                Ext.Net.PostMessageToServer('CCEE_SendCCEEModVars', Ext.Json.Stringify(Globals.AllParameters.CCEEModStuff))
                Globals.States.FirstCCcharacters = {}
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
        Globals.AllParameters = {}
        Globals.CC_Entities = {}
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
        E.presetsCombo.Options = Globals.Presets or {}
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
            Globals.States.CCState = true
            Globals.States.firstCC = true
            Apply.entity = getFirsCCDummy()
            table.insert(Globals.States.FirstCCcharacters, _C().Uuid.EntityUuid)
            DDump(Globals.States.FirstCCcharacters)
        else
            Globals.States.firstCC = false
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
        for attachment,_ in pairs(Parameters) do
            Tree[attachment] = testParams2:AddTree(attachment .. '##3123')
            Tree1[attachment] = Tree[attachment]:AddTree('Scalar##3123')
            Tree2[attachment] = Tree[attachment]:AddTree('Vec3##3123')
            Tree3[attachment] = Tree[attachment]:AddTree('Vec##3123')

            local max = 10
            local min = -max
            function TestAllScalarParameters()
                for _,v in ipairs(Parameters[attachment].ScalarParameters) do
                    local testSlider = Tree1[attachment]:AddSlider(v, 0, min, max, 0.1)
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
            TestAllScalarParameters()
            TestAllVec3Parameters()
            TestAllVecParameter()
       end
    end
    Tests:All()
    --#region
    -- function Tests:Body()

    --     local testParamsBody = testParams:AddTree('Bodyd')
    --     local treeTestParams = testParamsBody:AddTree('Scalar')
    --     local treeTestParams2 = testParamsBody:AddTree('Vec3')
    --     local treeTestParams3 = testParamsBody:AddTree('Vec')

    --     function TestAllBodyScalarParameters()
    --         for _,v in ipairs(Parameters.NakedBody.ScalarParameters) do
    --             local testSlider = treeTestParams:AddSlider(v, 0, -100, 100)
    --             testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider.OnChange = function()
    --                 for _, part in ipairs({'NakedBody'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'ScalarParameters', testSlider.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllBodyVec3Parameters()
    --         for _,v in ipairs(Parameters.NakedBody.Vector3Parameters) do
    --             local testPicker = treeTestParams2:AddColorEdit(v)
    --             testPicker.NoAlpha = true
    --             testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --             testPicker.OnChange = function()
    --                 for _, part in ipairs({'NakedBody'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector3Parameters', testPicker.Color)
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllBodyVecParameter()
    --         for _,v in ipairs(Parameters.NakedBody.VectorParameters) do
    --             local testSlider2 = treeTestParams3:AddSlider(v)
    --             testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider2.OnChange = function()
    --                 for _, part in ipairs({'NakedBody'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector_2Parameters', testSlider2.Value[1])
    --                 end
    --             end
    --         end
    --     end


    --     TestAllBodyScalarParameters()
    --     TestAllBodyVec3Parameters()
    --     TestAllBodyVecParameter()

    -- end

    -- function Tests:Head()

    --     local testParamsHead = testParams:AddTree('Headd')
    --     local treeTestParams4 = testParamsHead:AddTree('Scalard')
    --     local treeTestParams5 = testParamsHead:AddTree('Vec3d')
    --     local treeTestParams6 = testParamsHead:AddTree('Vecd')


    --     function TestAllHeadScalarParameters()
    --         for _,v in ipairs(Parameters.Head.ScalarParameters) do
    --             local testSlider = treeTestParams4:AddSlider(v, 0, -100, 100)
    --             testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider.OnChange = function()
    --                 for _, part in ipairs({'Head'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'ScalarParameters', testSlider.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllHeadVec3Parameters()
    --         for _,v in ipairs(Parameters.Head.Vector3Parameters) do
    --             local testPicker = treeTestParams5:AddColorEdit(v)
    --             testPicker.NoAlpha = true
    --             testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --             testPicker.OnChange = function()
    --                 for _, part in ipairs({'Head'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector3Parameters', testPicker.Color)
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllHeadVecParameter()
    --         for _,v in ipairs(Parameters.Head.VectorParameters) do
    --             local testSlider2 = treeTestParams6:AddSlider(v)
    --             testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider2.OnChange = function()
    --                 for _, part in ipairs({'Head'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'VectorParameters', testSlider2.Value[1])
    --                 end
    --             end
    --         end
    --     end


    --     TestAllHeadScalarParameters()
    --     TestAllHeadVec3Parameters()
    --     TestAllHeadVecParameter()

    -- end

    -- function Tests:Genital()

    --     local testParamsGenital = testParams:AddTree('Genitald')
    --     local treeTestParamsGenital_5821 = testParamsGenital:AddTree('Scalar')
    --     local treeTestParamsGenital_1293 = testParamsGenital:AddTree('Vec3')
    --     local treeTestParamsGenital_7640 = testParamsGenital:AddTree('Vec')

    --     if Parameters['Private Parts'] then
    --     function TestAllGenitalScalarParameters()
    --         for _,v in ipairs(Parameters['Private Parts'].ScalarParameters) do
    --             local testSlider = treeTestParamsGenital_5821:AddSlider(v, 0, -100, 100)
    --             testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider.OnChange = function()
    --                 for _, part in ipairs({'Private Parts'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'ScalarParameters', testSlider.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllGenitalVec3Parameters()
    --         for _,v in ipairs(Parameters['Private Parts'].Vector3Parameters)do
    --             local testPicker = treeTestParamsGenital_1293:AddColorEdit(v .. Ext.Math.Random(1, 10000))
    --             testPicker.NoAlpha = true
    --             testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --             testPicker.OnChange = function()
    --                 for _, part in ipairs({'Private Parts'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector3Parameters', testPicker.Color)
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllGenitalVecParameter()
    --         for _,v in ipairs(Parameters['Private Parts'].VectorParameters) do
    --             local testSlider2 = treeTestParamsGenital_7640:AddSlider(v)
    --             testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider2.OnChange = function()
    --                 for _, part in ipairs({'Private Parts'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector_1Parameters', testSlider2.Value[1])
    --                 end
    --             end
    --         end
    --     end
    --     TestAllGenitalScalarParameters()
    --     TestAllGenitalVec3Parameters()
    --     TestAllGenitalVecParameter()
    -- end
    -- end

    -- function Tests:Tail()
    --     local testParamsTail = testParams:AddTree('Taild')
    --     local treeTestParamsTail_8732 = testParamsTail:AddTree('Scalar')
    --     local treeTestParamsTail_3281 = testParamsTail:AddTree('Vec3')
    --     local treeTestParamsTail_9017 = testParamsTail:AddTree('Vec')

    --     if Parameters.Tail then

    --     function TestAllTailScalarParameters()
    --         for _,v in ipairs(Parameters.Tail.ScalarParameters) do
    --             local testSlider = treeTestParamsTail_8732:AddSlider(v, 0, -100, 100)
    --             testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider.OnChange = function()
    --                 for _, part in ipairs({'Tail'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'ScalarParameters', testSlider.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllTailVec3Parameters()
    --         for _,v in ipairs(Parameters.Tail.Vector3Parameters) do
    --             local testPicker = treeTestParamsTail_3281:AddColorEdit(v)
    --             testPicker.NoAlpha = true
    --             testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --             testPicker.OnChange = function()
    --                 for _, part in ipairs({'Tail'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector3Parameters', testPicker.Color)
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllTailVecParameter()
    --         for _,v in ipairs(Parameters.Tail.VectorParameters) do
    --             local testSlider2 = treeTestParamsTail_9017:AddSlider(v)
    --             testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider2.OnChange = function()
    --                 for _, part in ipairs({'Tail'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'VectorParameters', testSlider2.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     TestAllTailScalarParameters()
    --     TestAllTailVec3Parameters()
    --     TestAllTailVecParameter()
    --     end
    -- end

    -- function Tests:Horns()

    --     local testParamsHorns = testParams:AddTree('Hornsd')
    --     local treeTestParamsHorns_4472 = testParamsHorns:AddTree('Scalar')
    --     local treeTestParamsHorns_9823 = testParamsHorns:AddTree('Vec3')
    --     local treeTestParamsHorns_3106 = testParamsHorns:AddTree('Vec')

    --     if Parameters.Horns then

    --     function TestAllHornsScalarParameters()
    --         for _,v in ipairs(Parameters.Horns.ScalarParameters) do
    --             local testSlider = treeTestParamsHorns_4472:AddSlider(v, 0, -100, 100)
    --             testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider.OnChange = function()
    --                 for _, part in ipairs({'Horns'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'ScalarParameters', testSlider.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllHornsVec3Parameters()
    --         for _,v in ipairs(Parameters.Horns.Vector3Parameters) do
    --             local testPicker = treeTestParamsHorns_9823:AddColorEdit(v)
    --             testPicker.NoAlpha = true
    --             testPicker.Float = true
    --             testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --             testPicker.OnChange = function()
    --                 for _, part in ipairs({'Horns'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector3Parameters', testPicker.Color)
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllHornsVecParameter()
    --         for _,v in ipairs(Parameters.Horns.VectorParameters) do
    --             local testSlider2 = treeTestParamsHorns_3106:AddSlider(v)
    --             testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider2.OnChange = function()
    --                 for _, part in ipairs({'Horns'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'VectorParameters', testSlider2.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     TestAllHornsScalarParameters()
    --     TestAllHornsVec3Parameters()
    --     TestAllHornsVecParameter()
    --     end
    -- end

    -- function Tests:Nails()

    --     local testParamsNails = testParams:AddTree('Nailsd')
    --     local treeTestParamsNails_4472 = testParamsNails:AddTree('Scalar')
    --     local treeTestParamsNails_9823 = testParamsNails:AddTree('Vec3')
    --     local treeTestParamsNails_3106 = testParamsNails:AddTree('Vec')

    --     if Parameters.DragonbornTop then

    --     function TestAllNailsScalarParameters()
    --         for _,v in ipairs(Parameters.DragonbornTop.ScalarParameters) do
    --             local testSlider = treeTestParamsNails_4472:AddSlider(v, 0, -100, 100)
    --             testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider.OnChange = function()
    --                 for _, part in ipairs({'DragonbornTop'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'ScalarParameters', testSlider.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllNailsVec3Parameters()
    --         for _,v in ipairs(Parameters.DragonbornTop.Vector3Parameters) do
    --             local testPicker = treeTestParamsNails_9823:AddColorEdit(v)
    --             testPicker.NoAlpha = true
    --             testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --             testPicker.OnChange = function()
    --                 for _, part in ipairs({'DragonbornTop'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector3Parameters', testPicker.Color)
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllNailsVecParameter()
    --         for _,v in ipairs(Parameters.DragonbornTop.VectorParameters) do
    --             local testSlider2 = treeTestParamsNails_3106:AddSlider(v)
    --             testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider2.OnChange = function()
    --                 for _, part in ipairs({'DragonbornTop'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'VectorParameters', testSlider2.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     TestAllNailsScalarParameters()
    --     TestAllNailsVec3Parameters()
    --     TestAllNailsVecParameter()

    --     end


    -- end

    -- function Tests:Hair()

    --     local testParamsHair = testParams:AddTree('Haird')
    --     local treeTestParams = testParamsHair:AddTree('Scalar')
    --     local treeTestParams2 = testParamsHair:AddTree('Vec3')
    --     local treeTestParams3 = testParamsHair:AddTree('Vec')
    --     local treeTestParams4 = testParamsHair:AddTree('2D')

    --     function TestAllHairScalarParameters()
    --         for _,v in ipairs(Parameters.Hair.ScalarParameters) do
    --             local testSlider = treeTestParams:AddSlider(v, 0, -100, 100)
    --             testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider.OnChange = function()
    --                 for _, part in ipairs({'Hair'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'ScalarParameters', testSlider.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllHairVec3Parameters()
    --         for _,v in ipairs(Parameters.Hair.Vector3Parameters) do
    --             local testPicker = treeTestParams2:AddColorEdit(v)
    --             testPicker.NoAlpha = true
    --             testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --             testPicker.OnChange = function()
    --                 for _, part in ipairs({'Hair'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector3Parameters', testPicker.Color)
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllHairVecParameter()
    --         for _,v in ipairs(Parameters.Hair.VectorParameters) do
    --             local testSlider2 = treeTestParams3:AddSlider(v)
    --             testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider2.OnChange = function()
    --                 for _, part in ipairs({'Hair'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'VectorParameters', testSlider2.Value[1])
    --                 end
    --             end
    --         end
    --     end


    --     function TestAllHair2DParameters()
    --         for _,v in ipairs(Parameters.Hair.Texture2DParameters) do
    --             local testCheckbox = treeTestParams4:AddCheckbox(v)
    --             testCheckbox.IDContext = v .. Ext.Math.Random(1,10000)
    --             testCheckbox.OnChange = function()
    --                 for _, part in ipairs({'Hair'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Texture2DParameters', testCheckbox.Checked)
    --                 end
    --             end
    --         end
    --     end


    --     TestAllHairScalarParameters()
    --     TestAllHairVec3Parameters()
    --     TestAllHairVecParameter()
    --     TestAllHair2DParameters()

    -- end

    -- function Tests:Piercing()

    --     local testParamsPiercing = testParams:AddTree('Piercingd')
    --     local treeTestParamsPiercing_4472 = testParamsPiercing:AddTree('Scalar')
    --     local treeTestParamsPiercing_9823 = testParamsPiercing:AddTree('Vec3')
    --     local treeTestParamsPiercing_3106 = testParamsPiercing:AddTree('Vec')

    --     if Parameters.DragonbornTop then

    --     function TestAllPiercingScalarParameters()
    --         for _,v in ipairs(Parameters.DragonbornTop.ScalarParameters) do
    --             local testSlider = treeTestParamsPiercing_4472:AddSlider(v, 0, -100, 100)
    --             testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider.OnChange = function()
    --                 for _, part in ipairs({'DragonbornTop'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'ScalarParameters', testSlider.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllPiercingVec3Parameters()
    --         for _,v in ipairs(Parameters.DragonbornTop.Vector3Parameters) do
    --             local testPicker = treeTestParamsPiercing_9823:AddColorEdit(v)
    --             testPicker.NoAlpha = true
    --             testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --             testPicker.OnChange = function()
    --                 for _, part in ipairs({'DragonbornTop'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector3Parameters', testPicker.Color)
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllPiercingVecParameter()
    --         for _,v in ipairs(Parameters.DragonbornTop.VectorParameters) do
    --             local testSlider2 = treeTestParamsPiercing_3106:AddSlider(v)
    --             testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider2.OnChange = function()
    --                 for _, part in ipairs({'DragonbornTop'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'VectorParameters', testSlider2.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     TestAllPiercingScalarParameters()
    --     TestAllPiercingVec3Parameters()
    --     TestAllPiercingVecParameter()

    --     end


    -- end

    -- function Tests:Wings()
    --     local testParamsWings = testParams:AddTree('Wingsd')
    --     local treeTestParamsWings_8732 = testParamsWings:AddTree('Scalar')
    --     local treeTestParamsWings_3281 = testParamsWings:AddTree('Vec3')
    --     local treeTestParamsWings_9017 = testParamsWings:AddTree('Vec')

    --     if Parameters.Wings then


    --     function TestAllWingsScalarParameters()
    --         for _,v in ipairs(Parameters.Wings.ScalarParameters) do
    --             local testSlider = treeTestParamsWings_8732:AddSlider(v, 0, -100, 100)
    --             testSlider.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider.OnChange = function()
    --                 for _, part in ipairs({'Wings'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'ScalarParameters', testSlider.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllWingsVec3Parameters()
    --         for _,v in ipairs(Parameters.Wings.Vector3Parameters) do
    --             local testPicker = treeTestParamsWings_3281:AddColorEdit(v)
    --             testPicker.NoAlpha = true
    --             testPicker.IDContext = v .. Ext.Math.Random(1,10000)
    --             testPicker.OnChange = function()
    --                 for _, part in ipairs({'Wings'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'Vector3Parameters', testPicker.Color)
    --                 end
    --             end
    --         end
    --     end

    --     function TestAllWingsVecParameter()
    --         for _,v in ipairs(Parameters.Wings.VectorParameters) do
    --             local testSlider2 = treeTestParamsWings_9017:AddSlider(v)
    --             testSlider2.IDContext = v .. Ext.Math.Random(1,10000)
    --             testSlider2.OnChange = function()
    --                 for _, part in ipairs({'Wings'}) do
    --                     SetActiveMaterialParameterValue(_C(), part, v, 'VectorParameters', testSlider2.Value[1])
    --                 end
    --             end
    --         end
    --     end

    --     TestAllWingsScalarParameters()
    --     TestAllWingsVec3Parameters()
    --     TestAllWingsVecParameter()
    --     end
    -- end

    -- Tests:Body()
    -- Tests:Head()
    -- Tests:Genital()
    -- Tests:Tail()
    -- Tests:Wings()
    -- Tests:Horns()
    -- Tests:Nails()
    -- Tests:Hair()
    -- Tests:Piercing()
    --#endregion
end




---temp abomination
---
---seems like I have to keep it
function Elements:UpdateElements(charUuid)
    DPrint('Elements:UpdateElements')
    if Globals.AllParameters.ActiveMatParameters and Globals.AllParameters.ActiveMatParameters[charUuid] then
        local character = Globals.AllParameters.ActiveMatParameters[charUuid]
        local character2 = Globals.AllParameters.MatPresetParameters[charUuid]
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

        self['slIntPPOpac'].Value = SLOP:getValue(character, "Private parts", "ScalarParameters", "InvertOpacity")
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



--#region ahhTable
--     local parent
--     ahhTable = {

--         Melanin = {

--             {'picker', 'pickMelaninColor', 'Color', parent, {}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     HandleActiveMaterialParameters(_C(), attachment, 'MelaninColor', 'Vector3', var.Color)

--                 -- end
--                 -- MaterialPreset(_C(), 'MelaninColor', 'Vector3Parameters',  {var.Color[1],var.Color[2],var.Color[3]})

--                 ahhTable.Melanin:Vector3(Apply.entity, 'MelaninColor', var, 'mp', nil)

--                 end},

--             {nil, 'slMelaninAmount', 'Amount', parent, {}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     HandleActiveMaterialParameters(_C(), attachment, 'MelaninAmount', 'Scalar', var.Value[1])
--                 -- end
--                 -- MaterialPreset(_C(), 'MelaninAmount', 'ScalarParameters', var.Value[1])

--                 ahhTable.Melanin:Scalar(Apply.entity, 'MelaninAmount', var, 'mp', nil)

--                 end},


--             {nil, 'slMelaninRemoval', 'Removal amount', parent, {max = 100, log = true}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     HandleActiveMaterialParameters(_C(), attachment, 'MelaninRemovalAmount', 'Scalar', var.Value[1])
--                 -- end
--                 -- MaterialPreset(_C(), 'MelaninRemovalAmount', 'ScalarParameters', var.Value[1])

--                 ahhTable.Melanin:Scalar(Apply.entity, 'MelaninRemovalAmount', var, 'mp', nil)

--                 end},


--             {nil, 'slMelaninDarkM', 'Dark multiplier', parent, {max = 100, log = true}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     HandleActiveMaterialParameters(_C(), attachment, 'MelaninDarkMultiplier', 'Scalar', var.Value[1])
--                 -- end

--                 --MaterialPreset(_C(), 'MelaninDarkMultiplier', 'ScalarParameters', var.Value[1])

--                 ahhTable.Melanin:Scalar(Apply.entity, 'MelaninDarkMultiplier', var, 'mp', nil)

--                 end},

--             {nil, 'slMelaninDarkT', 'Dark threshold', parent, {max = 1}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     HandleActiveMaterialParameters(_C(), attachment, 'MelaninDarkThreshold', 'Scalar', var.Value[1])
--                 -- end
--                 -- MaterialPreset(_C(), 'MelaninDarkThreshold', 'ScalarParameters', var.Value[1])

--                 ahhTable.Melanin:Scalar(Apply.entity, 'MelaninDarkThreshold', var, 'mp', nil)

--                 end},
--         },

--         Hemoglobin = {

--             {'picker', 'pickHemoglobinColor', 'Color', parent, {}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     HandleActiveMaterialParameters(Apply.entity, attachment, 'HemoglobinColor', 'Vector3', var.Color)
--                 -- end
--                 -- MaterialPreset(Apply.entity, 'HemoglobinColor', 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
--                 ahhTable.Hemoglobin:Vector3(Apply.entity, 'HemoglobinColor', var, 'mp', nil)
--                 end},

--             {nil, 'slHemoglobinAmount', 'Amount', parent, {max = 3}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     HandleActiveMaterialParameters(Apply.entity, attachment, 'HemoglobinAmount', 'Scalar', var.Value[1])
--                 -- end
--                 -- MaterialPreset(Apply.entity, 'HemoglobinAmount', 'ScalarParameters', var.Value[1])
--                 ahhTable.Hemoglobin:Scalar(Apply.entity, 'HemoglobinAmount', var, 'mp', nil)
--                 end},
--         },

--         Yellowing = {
--             {'picker', 'pickYellowingColor', 'Color', parent, {}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     --HandleActiveMaterialParameters(Apply.entity, attachment, 'YellowingColor', 'Vector3', var.Color)
--                 -- end
--                 --MaterialPreset(Apply.entity, 'YellowingColor', 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
--                 ahhTable.Yellowing:Vector3(Apply.entity, 'YellowingColor', var, 'mp', nil)
--                 end},

--             {nil, 'slYellowingAmount', 'Amount', parent, {min = -300, max = 300, log = true}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     --HandleActiveMaterialParameters(Apply.entity, attachment, 'YellowingAmount', 'Scalar', var.Value[1])
--                 -- end
--                 --MaterialPreset(Apply.entity, 'YellowingAmount', 'ScalarParameters', var.Value[1])
--                 ahhTable.Yellowing:Scalar(Apply.entity, 'YellowingAmount', var, 'mp', nil)
--                 end},
--         },

--         Vein = {
--             {'picker', 'pickVeinColor', 'Color', parent, {}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     --HandleActiveMaterialParameters(Apply.entity, attachment, 'VeinColor', 'Vector3', var.Color)
--                 -- end
--                 --MaterialPreset(Apply.entity, 'VeinColor', 'Vector3Parameters', {var.Color[1],var.Color[2],var.Color[3]})
--                 ahhTable.Vein:Vector3(Apply.entity, 'VeinColor', var, 'mp', nil)
--                 end},

--             {nil, 'slVeinAmount', 'Amount', parent, {max = 7}, function(var)
--                 -- for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                 --     --HandleActiveMaterialParameters(Apply.entity, attachment, 'VeinAmount', 'Scalar', var.Value[1])
--                 -- end
--                 --MaterialPreset(Apply.entity, 'VeinAmount', 'ScalarParameters', var.Value[1])
--                 ahhTable.Vein:Scalar(Apply.entity, 'VeinAmount', var, 'mp', nil)
--                 end},
--         },

--         UnsortedB = {

--             {nil, 'slNonSkinWeight', 'NonSkin_Weight', parent, {max = 7}, function(var)
--                     ahhTable.UnsortedB:Scalar(Apply.entity, 'NonSkin_Weight', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {'picker', 'pickNonSkinColor', 'NonSkinColor', parent, {}, function(var)
--                 ahhTable.UnsortedB:Vector3(Apply.entity, 'NonSkinColor', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slNonSkinMetalness', 'NonSkinMetalness', parent, {max = 7}, function(var)
--                 ahhTable.UnsortedB:Scalar(Apply.entity, 'NonSkinMetalness', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--              end},

--              {nil, 'slFreckles', 'Freckles', parent, {max = 7}, function(var)
--                 ahhTable.UnsortedB:Scalar(Apply.entity, 'Freckles', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slFrecklesWeight', 'FrecklesWeight', parent, {max = 7}, function(var)
--                 ahhTable.UnsortedB:Scalar(Apply.entity, 'FrecklesWeight', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slVitiligo', 'Vitiligo', parent, {max = 7}, function(var)
--                 ahhTable.UnsortedB:Scalar(Apply.entity, 'Vitiligo', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slVitiligoWeight', 'VitiligoWeight', parent, {max = 7}, function(var)
--                 ahhTable.UnsortedB:Scalar(Apply.entity, 'VitiligoWeight', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slSweat', 'Sweat (smh)', parent, {max = 2}, function(var)
--                 ahhTable.UnsortedB:Scalar(Apply.entity, 'Sweat', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slBlood', 'Blood', parent, {max = 2}, function(var)
--                 ahhTable.UnsortedB:Scalar(Apply.entity, 'Blood', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slAddBodyTatInt', 'Body AdditionalTattooIntensity', parent, {max = 2}, function(var)
--                 ahhTable.UnsortedB:Scalar(Apply.entity, 'AdditionalTattooIntensity', var, nil, {'NakedBody'})
--             end},

--             {'picker', 'pickAddBodyColor', 'Body AdditionalTattooColor', parent, {}, function(var)
--                 ahhTable.UnsortedB:Vector3(Apply.entity, 'AdditionalTattooColorB', var, nil, {'NakedBody'})
--             end},

--             {nil, 'slAddHeadTatInt', 'Head AdditionalTattooIntensity', parent, {max = 2}, function(var)
--                 ahhTable.UnsortedB:Scalar(Apply.entity, 'AdditionalTattooIntensity', var, nil, {'Head'})
--             end},

--             {'picker', 'pickAddHeadColor', 'Head AdditionalTattooColor', parent, {}, function(var)
--                 ahhTable.UnsortedB:Vector3(Apply.entity, 'AdditionalTattooColorB', var, nil, {'Head'})
--             end},

--         },

--         Eyes_makeup = {
--             {'int', 'slIntMakeupIndex', 'Index', parent, {max = 31}, function(var)
--                 ahhTable.Eyes_makeup:Scalar(Apply.entity, 'MakeUpIndex', var, nil, {'Head'})
--             end},

--             {'picker', 'pickMakeupColor', 'Color', parent, {}, function(var)
--                 ahhTable.Eyes_makeup:Vector3(Apply.entity, 'MakeupColor', var, nil, {'Head'})
--             end},

--             {nil, 'slMakeupInt', 'Intensity', parent, {max = 5}, function(var)
--                 ahhTable.Eyes_makeup:Scalar(Apply.entity, 'MakeupIntensity', var, nil, {'Head'})
--             end},

--             {nil, 'slMakeupMet', 'Metalness', parent, {max = 1}, function(var)
--                 ahhTable.Eyes_makeup:Scalar(Apply.entity, 'EyesMakeupMetalness', var, nil, {'Head'})
--             end},

--             {nil, 'slMakeupRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
--                 ahhTable.Eyes_makeup:Scalar(Apply.entity, 'MakeupRoughness', var, nil, {'Head'})
--             end},
--         },

--         Lips_makeup = {
--             {'picker', 'pickLipsColor', 'Color', parent, {}, function(var)
--                 ahhTable.Lips_makeup:Vector3(Apply.entity, 'Lips_Makeup_Color', var, nil, {'Head'})
--             end},

--             {nil, 'slLipsInt', 'Intensity', parent, {max = 5}, function(var)
--                 ahhTable.Lips_makeup:Scalar(Apply.entity, 'LipsMakeupIntensity', var, nil, {'Head'})
--             end},

--             {nil, 'slLipsMet', 'Metalness', parent, {max = 1}, function(var)
--                 ahhTable.Lips_makeup:Scalar(Apply.entity, 'LipsMakeupMetalness', var, nil, {'Head'})
--             end},

--             {nil, 'slLipsRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
--                 ahhTable.Lips_makeup:Scalar(Apply.entity, 'LipsMakeupRoughness', var, nil, {'Head'})
--             end},
--         },

--         Tattoo = {
--             {'int', 'slIntTattooIndex', 'Index', parent, {max = 31}, function(var)
--                 ahhTable.Tattoo:Scalar(Apply.entity, 'TattooIndex', var, nil, {'Head'})
--             end},

--             {'picker', 'pickTattooColorR', 'Color R', parent, {}, function(var)
--                 ahhTable.Tattoo:Vector3(Apply.entity, 'TattooColor', var, nil, {'Head'})
--             end},

--             {'picker', 'pickTattooColorG', 'Color G', parent, {}, function(var)
--                 ahhTable.Tattoo:Vector3(Apply.entity, 'TattooColorG', var, nil, {'Head'})
--             end},

--             {'picker', 'pickTattooColorB', 'Color B', parent, {}, function(var)
--                 ahhTable.Tattoo:Vector3(Apply.entity, 'TattooColorB', var, nil, {'Head'})
--             end},


--             {nil, 'pickTattooIntR', 'Intensity R', parent, {min = -5, max = 5}, function(var)
--                 HandleActiveMaterialParameters(Apply.entity, 'Head', 'TattooIntensity', 'Vector_1Parameters', var.Value[1])
--                 Elements['pickTattooIntG'].Value = {0,0,0,0}
--                 Elements['pickTattooIntB'].Value = {0,0,0,0}
--                 end},


--             {nil, 'pickTattooIntG', 'Intensity G', parent, {min = -5, max = 5}, function(var)
--                 HandleActiveMaterialParameters(Apply.entity, 'Head', 'TattooIntensity', 'Vector_2Parameters', var.Value[1])
--                 Elements['pickTattooIntR'].Value = {0,0,0,0}
--                 Elements['pickTattooIntB'].Value = {0,0,0,0}
--                 end},

--             {nil, 'pickTattooIntB', 'Intensity B', parent, {min = -5, max = 5}, function(var)
--                 HandleActiveMaterialParameters(Apply.entity, 'Head', 'TattooIntensity', 'Vector_3Parameters', var.Value[1])
--                 Elements['pickTattooIntR'].Value = {0,0,0,0}
--                 Elements['pickTattooIntG'].Value = {0,0,0,0}
--                 end},

--             {nil, 'slTattooMet', 'Metalness', parent, {min = 0, max = 1}, function(var)
--                 ahhTable.Tattoo:Scalar(Apply.entity, 'TattooMetalness', var, nil, {'Head'})
--             end},

--             {nil, 'slTattooRough', 'Roughness', parent, {min = -1, max = 1}, function(var)
--                 ahhTable.Tattoo:Scalar(Apply.entity, 'TattooRoughnessOffset', var, nil, {'Head'})
--             end},

--             {nil, 'slTattooCurve', 'Curvature influence', parent, {min = 0, max = 100}, function(var)
--                 ahhTable.Tattoo:Scalar(Apply.entity, 'TattooCurvatureInfluence', var, nil, {'Head'})
--             end},
--         },

--         Age = {
--             {nil, 'slAgeInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Age:Scalar(Apply.entity, 'Age_Weight', var, nil, {'Head'})
--             end},
--         },

--         Scars = {
--             {'int', 'slIntScarIndex', 'Index', parent, {max = 24}, function(var)
--                 ahhTable.Scars:Scalar(Apply.entity, 'ScarIndex', var, nil, {'Head'})
--             end},

--             {nil, 'slScarWeight', 'Intensity', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scars:Scalar(Apply.entity, 'Scar_Weight', var, nil, {'Head'})
--             end},
--         },

--         Scales = {
--             {'int', 'slIntScaleIndex', 'Index', parent, {max = 31}, function(var)
--                 ahhTable.Scales:Scalar(Apply.entity, 'CustomIndex', var, nil, {'Head'})
--             end},

--             {'picker', 'pickScaleColor', 'Color', parent, {}, function(var)
--                 ahhTable.Scales:Vector3(Apply.entity, 'CustomColor', var, nil, {'Head'})
--             end},

--             {nil, 'slScaleInt', 'Intensity', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scales:Scalar(Apply.entity, 'CustomIntensity', var, nil, {'Head'})
--             end},
--         },


--         Eyes = {
--             {'int', 'slEyesHet', 'Heterochromia', parent, {max = 1}, function(var)
--                 ahhTable.Eyes:Scalar(Apply.entity, 'Heterochromia', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesBR', 'Blindness R', parent, {max = 3}, function(var)
--                 ahhTable.Eyes:Scalar(Apply.entity, 'Blindness', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesBL', 'Blindness L', parent, {max = 3}, function(var)
--                 ahhTable.Eyes:Scalar(Apply.entity, 'Blindness_L', var, nil, {'Head'})
--             end},

--             {'picker', 'pickEyesC', 'Iris color 1', parent, {}, function(var)
--                 ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_IrisColour', var, nil, {'Head'})
--             end},

--             {'picker', 'pickEyesCL', 'Iris color 1 L', parent, {}, function(var)
--                 ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_IrisColour_L', var, nil, {'Head'})
--             end},

--             {'picker', 'pickEyesC2', 'Iris color 2', parent, {}, function(var)
--                 ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_IrisSecondaryColour', var, nil, {'Head'})
--             end},

--             {'picker', 'pickEyesC2L', 'Iris color 2 L', parent, {}, function(var)
--                 ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_IrisSecondaryColour_L', var, nil, {'Head'})
--             end},

--             {'picker', 'pickEyesSC', 'Sclera color', parent, {}, function(var)
--                 ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_ScleraColour', var, nil, {'Head'})
--             end},

--             {'picker', 'pickEyesSCL', 'Sclera color L', parent, {}, function(var)
--                 ahhTable.Eyes:Vector3(Apply.entity, 'Eyes_ScleraColour_L', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesCI', 'Iris color int', parent, {min = -100, max = 100, log = true}, function(var)
--                 ahhTable.Eyes:Scalar(Apply.entity, 'SecondaryColourIntensity', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesCIL', 'Iris color int L', parent, {min = -100, max = 100}, function(var)
--                 ahhTable.Eyes:Scalar(Apply.entity, 'SecondaryColourIntensity_L', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesEdge', 'IrisEdgeStrength', parent, {min = -100, max = 100, log = true}, function(var)
--                 ahhTable.Eyes:Scalar(Apply.entity, 'IrisEdgeStrength', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesEdgeL', 'IrisEdgeStrength L', parent, {min = -100, max = 100}, function(var)
--                 ahhTable.Eyes:Scalar(Apply.entity, 'IrisEdgeStrength_L', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesRed', 'Redness', parent, {max = 100, log = true}, function(var)
--                 ahhTable.Eyes:Scalar(Apply.entity, 'Redness', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesRedL', 'Redness L', parent, {max = 100}, function(var)
--                 ahhTable.Eyes:Scalar(Apply.entity, 'Redness_L', var, nil, {'Head'})
--             end},
--         },


--         Body_tattoos = {
--             {'int', 'slBTatI', 'Index', parent, {max = 19}, function(var)
--                 ahhTable.Body_tattoos:Scalar(Apply.entity, 'BodyTattooIndex', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {'picker', 'pickBTatCR', 'Color R', parent, {}, function(var)
--                 ahhTable.Body_tattoos:Vector3(Apply.entity, 'BodyTattooColor', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {'picker', 'pickBTatCG', 'Color G', parent, {}, function(var)
--                 ahhTable.Body_tattoos:Vector3(Apply.entity, 'BodyTattooColorG', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {'picker', 'pickBTatCB', 'Color B', parent, {}, function(var)
--                 ahhTable.Body_tattoos:Vector3(Apply.entity, 'BodyTattooColorB', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slBTatIntR', 'Intensity R', parent, {min = -5, max = 5}, function(var)
--                 for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                     HandleActiveMaterialParameters(Apply.entity, attachment, 'BodyTattooIntensity', 'Vector_1Parameters', var.Value[1])
--                     -- HandleActiveMaterialParameters(Apply.entity, attachment, 'TattooIntensity', 'Vector_1Parameters', var.Value[1])
--                 end
--                 Elements['slBTatIntG'].Value = {0,0,0,0}
--                 Elements['slBTatIntB'].Value = {0,0,0,0}
--             end},

--             {nil, 'slBTatIntG', 'Intensity G', parent, {min = -5, max = 5}, function(var)
--                 for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                     HandleActiveMaterialParameters(Apply.entity, attachment, 'BodyTattooIntensity', 'Vector_2Parameters', var.Value[1])
--                 end


--                 -- MaterialPreset(Apply.entity, 'BodyTattooIntensity', 'Vector3Parameters', {var.Value[1],0,0,0})

--                 Elements['slBTatIntR'].Value = {0,0,0,0}
--                 Elements['slBTatIntB'].Value = {0,0,0,0}
--             end},

--             {nil, 'slBTatIntB', 'Intensity B', parent, {min = -5, max = 5}, function(var)
--                 for _, attachment in ipairs({'Head', 'NakedBody', 'Private Parts', 'Tail'}) do
--                     HandleActiveMaterialParameters(Apply.entity, attachment, 'BodyTattooIntensity', 'Vector_3Parameters', var.Value[1])
--                 end
--                 Elements['slBTatIntR'].Value = {0,0,0,0}
--                 Elements['slBTatIntG'].Value = {0,0,0,0}
--             end},

--             {nil, 'slBTatMet', 'Metalness', parent, {max = 1}, function(var)
--                 ahhTable.Body_tattoos:Scalar(Apply.entity, 'TattooMetalness', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slBTatR', 'Roughness', parent, {min = -1, max = 1}, function(var)
--                 ahhTable.Body_tattoos:Scalar(Apply.entity, 'TattooRoughnessOffset', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end},

--             {nil, 'slBTatCurve', 'Curvature influence', parent, {max = 100}, function(var)
--                 ahhTable.Body_tattoos:Scalar(Apply.entity, 'TattooCurvatureInfluence', var, nil, {'Head', 'NakedBody', 'Private Parts', 'Tail'})
--             end}
--         },

--         Private_parts = {
--             {'int', 'slIntPPOpac', 'Toggle', parent, {def = 1}, function(var)
--                 ahhTable.Private_parts:Scalar(Apply.entity, 'InvertOpacity', var, nil, {'Private parts'})
--             end},
--         },

--         Scalp = {
--             {'picker', 'pickHairScalpColor', 'Hair Scalp Color', parent, {}, function(var)
--                 ahhTable.Scalp:Vector3(Apply.entity, 'Hair_Scalp_Color', var, nil, {'Head'})
--             end},

--             {'picker', 'pickHueShiftWeight', 'Hue Shift Weight', parent, {}, function(var)
--                 ahhTable.Scalp:Vector3(Apply.entity, 'Scalp_HueShiftColorWeight', var, nil, {'Head'})
--             end},

--             {'picker', 'pickBeardScalpColor', 'Beard Scalp Color', parent, {}, function(var)
--                 ahhTable.Scalp:Vector3(Apply.entity, 'Beard_Scalp_Color', var, nil, {'Head'})
--             end},

--             {nil, 'slScalpMinValue', 'Scalp Min Value', parent, {min = -1, max = 1}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_MinValue', var, nil, {'Head'})
--             end},

--             {nil, 'slHornMaskWeight', 'Horn Mask Weight', parent, {min = -1, max = 1}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_HornMaskWeight', var, nil, {'Head'})
--             end},

--             {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_Graying_Intensity', var, nil, {'Head'})
--             end},

--             {'picker', 'pickGrayingColor', 'Graying Color', parent, {}, function(var)
--                 ahhTable.Scalp:Vector3(Apply.entity, 'Hair_Scalp_Graying_Color', var, nil, {'Head'})
--             end},

--             {nil, 'slColorTransitionMid', 'Color Transition Mid', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_ColorTransitionMidPoint', var, nil, {'Head'})
--             end},

--             {nil, 'slColorTransitionSoft', 'Color Transition Soft', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_ColorTransitionSoftness', var, nil, {'Head'})
--             end},

--             {nil, 'slDepthColorExponent', 'Depth Color Exponent', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_DepthColorExponent', var, nil, {'Head'})
--             end},

--             {nil, 'slDepthColorIntensity', 'Depth Color Intensity', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_DepthColorIntensity', var, nil, {'Head'})
--             end},

--             {nil, 'slIDContrast', 'ID Contrast', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_IDContrast', var, nil, {'Head'})
--             end},

--             {nil, 'slColorDepthContrast', 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_ColorDepthContrast', var, nil, {'Head'})
--             end},

--             {nil, 'slScalpRoughness', 'Scalp Roughness', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_Roughness', var, nil, {'Head'})
--             end},

--             {nil, 'slRoughnessContrast', 'Roughness Contrast', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_RoughnessContrast', var, nil, {'Head'})
--             end},

--             {nil, 'slScalpScatter', 'Scalp Scatter', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Scalp:Scalar(Apply.entity, 'Scalp_Scatter', var, nil, {'Head'})
--             end},
--         },


--         Hair = {
--             {'picker', 'pickHairColor', 'Hair Color', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Hair_Color', var, nil, {'Hair'})
--             end},

--             {nil, 'slRootTransitionMid', 'Root Transition Mid', parent, {}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'RootTransitionMidPoint', var, nil, {'Hair'})
--             end},

--             {nil, 'slRootTransitionSoft', 'Root Transition Soft', parent, {min = -2, max = 2}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'RootTransitionSoftness', var, nil, {'Hair'})
--             end},

--             {nil, 'slDepthColorExponent', 'Depth Color Exponent', parent, {}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'DepthColorExponent', var, nil, {'Hair'})
--             end},

--             {nil, 'slDepthColorIntensity', 'Depth Color Intensity', parent, {}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'DepthColorIntensity', var, nil, {'Hair'})
--             end},

--             {nil, 'slColorDepthContrast', 'Color Depth Contrast', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'ColorDepthContrast', var, nil, {'Hair'})
--             end},

--             {nil, 'slHairRoughness', 'Roughness', parent, {min = -1, max = 1}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'Roughness', var, nil, {'Hair'})
--             end},

--             {nil, 'slHairRoughness', 'Roughness contrast', parent, {min = -1, max = 1}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'RoughnessContrast', var, nil, {'Hair'})
--             end},


--             {nil, 'slHairFrizz', 'Hair Frizz', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'HairFrizz', var, nil, {'Hair'})
--             end},

--             {nil, 'slHairSoupleness', 'Hair Soupleness', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'HairSoupleness', var, nil, {'Hair'})
--             end},

--             {nil, 'slMaxWindMovement', 'Max Wind Movement', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'MaxWindMovementAmount', var, nil, {'Hair'})
--             end},

--             {nil, 'slSoftenTipsAlpha', 'Soften Tips Alpha', parent, {}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'SoftenTipsAlpha', var, nil, {'Hair'})
--             end},

--             {nil, 'slBacklit', 'Backlit', parent, {}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'HairBacklit', var, nil, {'Hair'})
--             end},


--             {nil, 'slDreadNoiseBaseColor', 'Dread Noise Base Color', parent, {}, function(var)
--                 ahhTable.Hair:Scalar(Apply.entity, 'DreadNoiseBaseColor', var, nil, {'Hair'})
--             end},

--             {'picker', 'pickHairAcc1', 'Accs Color 1', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'NonSkinColor', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc2', 'Accs Color 2', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'NonSkinTipColor', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc3', 'Accs Color 3', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'SkinApproxColor', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc4', 'Accs Color 4', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Cloth_Primary', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc5', 'Accs Color 5', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Cloth_Secondary', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc6', 'Accs Color 6', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Cloth_Tertiary', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc7', 'Accs Color 7', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Accent_Color', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc8', 'Accs Color 8', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Leather_Primary', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc9', 'Accs Color 9', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Leather_Secondary', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc10', 'Accs Color 10', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Leather_Tertiary', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc11', 'Accs Color 11', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Custom_1', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc12', 'Accs Color 12', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Custom_2', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc13', 'Accs Color 13', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Metal_Primary', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc14', 'Accs Color 14', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Metal_Secondary', var, nil, {'Hair'})
--             end},
--             {'picker', 'pickHairAcc15', 'Accs Color 15', parent, {}, function(var)
--                 ahhTable.Hair:Vector3(Apply.entity, 'Metal_Tertiary', var, nil, {'Hair'})
--             end},
--         },

--         Graying = {
--             {'picker', 'pickHairGrayingColor', 'Hair Graying Color', parent, {}, function(var)
--                 ahhTable.Graying:Vector3(Apply.entity, 'Hair_Graying_Color', var, nil, {'Hair'})
--             end},

--             {nil, 'slGrayingIntensity', 'Graying Intensity', parent, {max = 1.2}, function(var)
--                 ahhTable.Graying:Scalar(Apply.entity, 'Graying_Intensity', var, nil, {'Hair'})
--             end},

--             {nil, 'slGrayingSeed', 'Graying Seed', parent, {min = -10, max = 10, log = true}, function(var)
--                 ahhTable.Graying:Scalar(Apply.entity, 'Graying_Seed', var, nil, {'Hair'})
--             end},
--         },


--         Highlights = {
--             {'picker', 'pickHighlightColor', 'Highlight Color', parent, {}, function(var)
--                 ahhTable.Highlights:Vector3(Apply.entity, 'Highlight_Color', var, nil, {'Hair'})
--             end},

--             {nil, 'slHighlightFalloff', 'Highlight Falloff', parent, {min = -1, log = true}, function(var)
--                 ahhTable.Highlights:Scalar(Apply.entity, 'Highlight_Falloff', var, nil, {'Hair'})
--             end},

--             {nil, 'slHighlightIntensity', 'Highlight Intensity', parent, {max = 3, log = true}, function(var)
--                 ahhTable.Highlights:Scalar(Apply.entity, 'Highlight_Intensity', var, nil, {'Hair'})
--             end},
--         },

--         Beard = {
--             {'int', 'slIntBeardIndex', 'BeardIndex', parent, {min = -1, max = 100}, function(var)
--                 ahhTable.Beard:Scalar(Apply.entity, 'BeardIndex', var, nil, {'Head'})
--             end},

--             {'picker', 'pickBeardScalpColor', 'Beard Scalp Color', parent, {}, function(var)
--                 ahhTable.Beard:Vector3(Apply.entity, 'Beard_Scalp_Color', var, nil, {'Hair'})
--             end},

--             {'picker', 'pickBeardColor', 'Beard Color', parent, {}, function(var)
--                 ahhTable.Beard:Vector3(Apply.entity, 'Beard_Color', var, nil, {'Hair'})
--             end},

--             {'picker', 'pickBeardGrayingColor', 'Beard Graying Color', parent, {}, function(var)
--                 ahhTable.Beard:Vector3(Apply.entity, 'Beard_Graying_Color', var, nil, {'Hair'})
--             end},

--             {'picker', 'pickBeardHighlightColor', 'Beard Highlight Color', parent, {}, function(var)
--                 ahhTable.Beard:Vector3(Apply.entity, 'Beard_Highlight_Color', var, nil, {'Hair'})
--             end},

--             {nil, 'slBeardMinValue', 'Beard Min Value', parent, {min = -10, max = 10}, function(var)
--                 ahhTable.Beard:Scalar(Apply.entity, 'BeardMinValue', var, nil, {'Head'})
--             end},

--             {nil, 'slBeardInt', 'Beard Intesity', parent, {min = -100, max = 100}, function(var)
--                 ahhTable.Beard:Scalar(Apply.entity, 'BeardIntesity', var, nil, {'Hair'})
--             end},

--             {nil, 'slBeardDesat', 'Beard Desaturation', parent, {min = -100, max = 100}, function(var)
--                 ahhTable.Beard:Scalar(Apply.entity, 'BeardDesaturation', var, nil, {'Head'})
--             end},

--             {nil, 'slBeardDarken', 'Beard Darken', parent, {min = -100, max = 100}, function(var)
--                 ahhTable.Beard:Scalar(Apply.entity, 'BeardDarken', var, nil, {'Head'})
--             end},

--             {nil, 'slBeardGrayingInt', 'Beard Graying Intensity', parent, {min = -100, max = 100}, function(var)
--                 ahhTable.Beard:Scalar(Apply.entity, 'Beard_Graying_Intensity', var, nil, {'Hair'})
--             end},
--         },

--         BodyHair = {
--             {'picker', 'pickBodyHairC', 'Body Hair Color', parent, {}, function(var)
--                 ahhTable.BodyHair:Vector3(Apply.entity, 'Body_Hair_Color', var, nil, {'NakedBody', 'Private Parts'})
--             end},
--         },

--         Horns = {
--             {'picker', 'pickHornsColor', 'Color', parent, {}, function(var)
--                 ahhTable.Horns:Vector3(Apply.entity, 'NonSkinColor', var, nil, {'Horns'})
--             end},

--             {'picker', 'pickHeadNSColor', 'Head Thing Color', parent, {}, function(var)
--                 ahhTable.Horns:Vector3(Apply.entity, 'NonSkinColor', var, nil, {'Head'})
--             end},

--             {'picker', 'pickHornsTipColor', 'Tip Color', parent, {}, function(var)
--                 ahhTable.Horns:Vector3(Apply.entity, 'NonSkinTipColor', var, nil, {'Horns'})
--             end},

--             {nil, 'slHornReflectance', 'Reflectance', parent, {}, function(var)
--                 ahhTable.Horns:Scalar(Apply.entity, 'Reflectance', var, nil, {'Horns'})
--             end},

--             {'int', 'slHornGlow', 'Toggle Glow', parent, {}, function(var)
--                 ahhTable.Horns:Scalar(Apply.entity, 'Use_BlackBody', var, nil, {'Horns'})
--                 ahhTable.Horns:Scalar(Apply.entity, 'Colour_BlackBody', var, nil, {'Horns'})
--                 ahhTable.Horns:Scalar(Apply.entity, 'Use_ColorRamp', var, nil, {'Horns'})
--             end},

--             {'picker', 'slHornBlackBody_Colour', 'Glow Color', parent, {}, function(var)
--                 ahhTable.Horns:Vector3(Apply.entity, 'BlackBody_Colour', var, nil, {'Horns'})
--             end},

--             {nil, 'slHornIntensity', 'Glow Intensity', parent, {max = 200, log = true}, function(var)
--                 ahhTable.Horns:Scalar(Apply.entity, 'Intensity', var, nil, {'Horns'})
--             end},

--             {nil, 'slHornBlackbody_PreRamp_Power', 'Also Glow Intensity', parent, {}, function(var)
--                 ahhTable.Horns:Scalar(Apply.entity, 'Blackbody_PreRamp_Power', var, nil, {'Horns'})
--             end},

--             {nil, 'slHornEmissive_Mult', 'Emissive Mult', parent, {min = -100, max = 100, log = true}, function(var)
--                 ahhTable.Horns:Scalar(Apply.entity, 'Emissive_Mult', var, nil, {'Horns'})
--             end},

--             {'int', 'slHornUse_HeartBeat', 'Use HeartBeat', parent, {}, function(var)
--                 ahhTable.Horns:Scalar(Apply.entity, 'Use_HeartBeat', var, nil, {'Horns'})
--             end},

--             {nil, 'slHornLength', 'Length', parent, {min = -100, max = 100, log = true}, function(var)
--                 ahhTable.Horns:Scalar(Apply.entity, 'Length', var, nil, {'Horns'})
--             end},

--             {nil, 'slHornamplitude', 'Amplitude', parent, {min = -100, max = 100, log = true}, function(var)
--                 ahhTable.Horns:Scalar(Apply.entity, 'amplitude', var, nil, {'Horns'})
--             end},

--             {nil, 'slHornBPM', 'BPM', parent, {min = -100, max = 100, log = true}, function(var)
--                 ahhTable.Horns:Scalar(Apply.entity, 'BPM', var, nil, {'Horns'})
--             end},
--         },


--         GlowHead = {
--             {'picker', 'pickHeadGlowColor', 'Color', parent, {}, function(var)
--                 ahhTable.GlowHead:Vector3(Apply.entity, 'GlowColor', var, nil, {'Head'})
--             end},

--             {nil, 'slHeadGlowMult', 'Multiplier', parent, {max = 5}, function(var)
--                 ahhTable.GlowHead:Scalar(Apply.entity, 'GlowMultiplier', var, nil, {'Head'})
--             end},

--             {nil, 'slHeadAnimdSpeed', 'Animation speed', parent, {max = 10}, function(var)
--                 ahhTable.GlowHead:Scalar(Apply.entity, 'AnimationSpeed', var, nil, {'Head'})
--             end},
--         },

--         GlowBody = {
--             {'picker', 'pickBodyGlowColor', 'Color', parent, {}, function(var)
--                 ahhTable.GlowBody:Vector3(Apply.entity, 'GlowColor', var, nil, {'NakedBody'})
--             end},

--             {nil, 'slBodyGlowMult', 'Multiplier', parent, {max = 5}, function(var)
--                 ahhTable.GlowBody:Scalar(Apply.entity, 'GlowMultiplier', var, nil, {'NakedBody'})
--             end},

--             {nil, 'slBodyAnimdSpeed', 'Animation speed', parent, {max = 10}, function(var)
--                 ahhTable.GlowBody:Scalar(Apply.entity, 'AnimationSpeed', var, nil, {'NakedBody'})
--             end},
--         },

--         GlowEyes = {
--             {nil, 'slEyesGlowBright', 'Brightness', parent, {min = -200, max = 200}, function(var)
--                 ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightness', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesGlowBrightL', 'Brightness L', parent, {min = -200, max = 200}, function(var)
--                 ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightness_L', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesGlowBrightPup', 'Brightness pupil', parent, {min = -100, max = 100, log = true}, function(var)
--                 ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightnessPupil', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesFxMasking', 'Fx masking', parent, {min = -100, max = 100, log = true}, function(var)
--                 ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightnessPupil', var, nil, {'Head'})
--             end},

--             {nil, 'slEyesFxMaskingL', 'Fx masking L', parent, {min = -100, max = 100, log = true}, function(var)
--                 ahhTable.GlowEyes:Scalar(Apply.entity, 'GlowBrightnessPupil', var, nil, {'Head'})
--             end},

--             {'picker', 'slEyesGlowColor', 'Color', parent, {}, function(var)
--                 ahhTable.GlowEyes:Vector3(Apply.entity, 'Eyes_GlowColour', var, nil, {'Head'})
--             end},

--             {'picker', 'slEyesGlowColorL', 'Color L', parent, {}, function(var)
--                 ahhTable.GlowEyes:Vector3(Apply.entity, 'Eyes_GlowColour_L', var, nil, {'Head'})
--             end},
--         }

--     }
--#endregion

--#region usless

            -- {'picker', pickBeardColor, 'Beard Color', parent, {}, function(var)
            --     CallFunction('Vector3', 'Beard_Color', var) end},


             -- {nil, slPixelDepthOffsetRoot, 'Pixel Depth Offset Root', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'PixelDepthOffsetRoot', var) end},

            -- {nil, slPixelDepthOffset, 'Pixel Depth Offset', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'PixelDepthOffset', var) end},

            -- {nil, slDepthTransitionMidPoint, 'Depth Transition Mid', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DepthTransitionMidPoint', var) end},

            -- {nil, slDepthTransitionSoftness, 'Depth Transition Soft', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DepthTransitionSoftness', var) end},

            -- {nil, slBeardAlpha, 'Beard Alpha', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'DontTouchMe_Beard_Alpha', var) end},


            -- {nil, slIsBeard, 'Is Beard', parent, {min = -10, max = 10}, function(var)
        --     CallFunction('Scalar', 'DontTouchMe_isBeard', var) end},

            -- {nil, slBeardGrayingIntensity, 'Beard Graying Intensity', parent, {min = -10, max = 10}, function(var)
            --     CallFunction('Scalar', 'Beard_Graying_Intensity', var) end},

            -- {nil, slIDContrast, 'ID Contrast', parent, {min = -10, max = 10}, function(var)
        --     CallFunction('Scalar', 'IDContrast', var) end},

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
--#endregion


