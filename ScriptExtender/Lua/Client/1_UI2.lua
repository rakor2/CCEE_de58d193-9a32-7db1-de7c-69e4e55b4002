function MainWindow()
    mw = Ext.IMGUI.NewWindow('CCEE')
        UI:Config(mw, {
            Font = 'Font',
            Open = true,
            Closeable = true,
            -- AlwaysAutoResize = true,
            Scaling = 'Scaled',
            Visible = true,

            OnClose = function()
                mw.Open = false
            end
        })

    local ViewportSize = Ext.IMGUI.GetViewportSize()
    mw:SetPos({ViewportSize[1] / 6, ViewportSize[2] / 10})
    if ViewportSize[1] <= 1920 and ViewportSize[2] <= 1080 then
        mw:SetSize({571, 750})
        WIDTH = 41
        HEIGHT = 167
    else
        mw:SetSize({766, 1000})
        WIDTH = 39
        HEIGHT = 141
    end

    ApplyStyle(mw, StyleSettings.selectedStyle)

    local tabBarMain  = mw:AddTabBar('Main')

    local tabMain     = tabBarMain:AddTabItem('Main')

    MainTab(tabMain)
end




function MainTab(p)
    -- local winColors = Ext.IMGUI.NewWindow("Colors")
    -- winColors.Open = false
    -- winColors.Closeable = true
    -- winColors.AlwaysAutoResize = false
    -- winColors.Scaling = 'Scaled'

    -- ApplyStyle(winColors, 1)

    -- local barColors = winColors:AddTabBar('Bar1')
    -- local itmSkinColors = barColors:AddTabItem('Skin colors')
    -- local pc = winColors

    -- local btnTest = pc:AddButton('xd')

    -- function BuildColorTable(resourceType, parent)
    --     local SkinColor = {}
    --     local x = resourceType

    --     for k, v in pairs(Ext.StaticData.GetAll(x)) do
    --         local color = Ext.StaticData.Get(v, x).Color
    --         local name  = Ext.StaticData.Get(v, x).DisplayName:Get()

    --         table.insert(SkinColor, {[name] = color})

    --     end

    --     local tableId = 1
    --     local tableSize = 5
    --     local tbl = parent:AddTable(tableId, tableSize)
    --     local imageRow
    --     local descRow
    --     local count = 0

    --     for _, item in ipairs(SkinColor) do
    --         if count % tableSize == 0 then
    --             descRow = tbl:AddRow()
    --             imageRow = tbl:AddRow()
    --         end

    --         descRow:AddCell():AddText('')
    --         local cell = imageRow:AddCell()
    --         local imgbtn = cell:AddButton('xasda')
    --     end
    -- end



    E.btnTest = p:AddButton('Hi!')
        UI:Config(E.btnTest, {
            OnClick = function (e)
                DPrint('Hi!')

                Imgui.ClearChildren(E.grpCat)
                Imgui.ClearChildren(E.grpDiffusion)
                GetParametersAndBuildControls()
            end
        })



    -- E.btnTest2 = p:AddButton('Bye!')
    -- E.btnTest2.SameLine = true
    -- E.btnTest2.OnClick = function (e)
    --     DPrint('Bye!')

    --     Imgui.ClearChildren(E.grpCat)
    --     Imgui.ClearChildren(E.grpDiffusion)
    --     GetParametersAndBuildControls()
    -- end



    E.btnParams = p:AddButton('Dump Parameters')
        UI:Config(E.btnParams, {
            OnClick = function(e)
                DDump(_GLL.Parameters)
            end
        })



    E.btnParamsSingle = p:AddButton('Dump Single')
        UI:Config(E.btnParamsSingle, {
            SameLine = true,
            OnClick = function(e)
                local uuid = _C().Uuid.EntityUuid
                DDump(_GLL.Parameters[uuid])
            end
        })



    E.btnParamsSingleBody = p:AddButton('Dump Body')
        UI:Config(E.btnParamsSingleBody, {
            SameLine = true,
            OnClick = function(e)
                local uuid = _C().Uuid.EntityUuid
                DDump(_GLL.Parameters[uuid].NakedBody)
            end
        })



    E.btnDumpSaved = p:AddButton('Dump Saved')
        UI:Config(E.btnDumpSaved, {
            OnClick = function(e)
                DDump(_GLL.SavedParameters)
            end
        })



    E.btnDumpSavedSi = p:AddButton('Dump Saved Single')
        UI:Config(E.btnDumpSavedSi, {
            SameLine = true,
            OnClick = function(e)
                local uuid = _C().Uuid.EntityUuid
                DDump(_GLL.SavedParameters[uuid])
            end
        })



    E.btnDumpSavedBod = p:AddButton('Dump Saved BOduy')
        UI:Config(E.btnDumpSavedBod, {
            SameLine = true,
            OnClick = function(e)
                local uuid = _C().Uuid.EntityUuid
                DDump(_GLL.SavedParameters[uuid].NakedBody)
            end
        })



    E.btnDumpPaths = p:AddButton('Dump Paths')
        UI:Config(E.btnDumpPaths, {
            OnClick = function(e)
                DDump(_GLL.StoredVisualPaths)
            end
        })



    E.btnSaveParams = p:AddButton('Save Params')
        UI:Config(E.btnSaveParams, {
            OnClick = function(e)
                local entity = _C()
                DDump(SaveParametersSingle(entity))
            end
        })



    E.btnSaveParams = p:AddButton('Load Params')
        UI:Config(E.btnSaveParams, {
            SameLine = true,
            OnClick = function(e)
                local entity = _C()
                LoadParametersSingle(entity)
            end
        })


    E.grpCat = p:AddGroup('Categories')
    E.grpDiffusion = p:AddGroup('Diffusion')


    -- E.testParams2 = p:AddCollapsingHeader('All parameters')
end

-- MCM.InsertModMenuTab('CCEE',  CCEEMCM, ModuleUUID)
-- MainWindow()