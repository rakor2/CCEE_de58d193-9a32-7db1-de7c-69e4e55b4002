Ext.Entity.OnCreate('ClientControl', function (entity)
    if not windowIsOpened() then return DPrint('CCEE window in closed. Nothing happened x)') end

    Imgui.ClearChildren(E.grpCat)
    Imgui.ClearChildren(E.grpDiffusion)

    Utils:AntiSpam(500, function ()
        Helpers.Timer:OnTicks(10, function ()
            GetParametersAndBuildControls(entity)
        end)
    end)

end)




Ext.Events.ResetCompleted:Subscribe(function()
    Imgui.ClearChildren(E.grpCat)
    Imgui.ClearChildren(E.grpDiffusion)

    GetParametersAndBuildControls()
end)



Ext.Entity.OnCreate('ClientControl', function()
    if _GLL.States.inGameplay then --- Because clientcontrol fires before gameplay, makes sense :mhm:
        ReCreateUI()
    end
end)



Ext.Entity.OnChange('ItemDye', function()
    if _GLL.States.inGameplay then --- Because clientcontrol fires before gameplay, makes sense :mhm:
        Utils:AntiSpam(4, function()
            Dye.UpdateWidgets()
        end)

    end
end)



-- Ext.Entity.OnSystemUpdate('ClientEquipmentVisuals', function()
--     local sys = Ext.System.ClientEquipmentVisuals
--     for _, v in pairs(sys.DestroyVisuals) do
--         _DS(v:GetAllComponents())
--     end
-- end)



function xdddd(entity)
    -- local dummy = GetCCDummy(entity) and GetCCDummy(entity).ClientCCDummyDefinition.Dummy
    -- CopyVisibilityStateToDummy(dummy)
    -- OnTicks(5, function()
    --     Dye.RestoreParameters(entity.Uuid.EntityUuid)
    -- end)
end



Ext.Entity.OnCreate('ClientEquipmentVisuals', function()
    OnTicks(35, function ()
        -- xdddd(_C())
    end)
end)



Ext.Entity.OnChange('CCState', function(e)
    OnTicks(50, function()
        -- xdddd(e)
        -- OnTicks(105, function()
        --     Dye.RestoreParameters(_C().Uuid.EntityUuid)
        -- end)
    end)
end)


-- _D(Mods.Slots.GetCCDummy(_C()).ClientCCDummyDefinition.Dummy.Visual.Visual.Attachments[1].Visual:SetWorldScale{0,0,0})
-- _D(Mods.Slots.GetCCDummy(_C()).ClientCCDefinitionState.Entity.Visual.Visual.Attachments[1].Visual:SetWorldScale{0,0,0})




Ext.Entity.OnCreate('PhotoModeSession', function()
    _GLL.States.inPhotoMode = true
    OnTicks(35, function()
        -- LoadParametersToDummy(_C().Uuid.EntityUuid)
        -- LoadParametersToAllDummies()
        -- OnTicks(5, function()
        -- end)
    end)
end)



Ext.Entity.OnCreate('TimelineActorData', function(e)
    if e and e.ClientCharacter
        and e.ClientCharacter.HasDialog
        and e.Origin
    then
        -- local dummy = Characters:GetTLPreviewDummy(e)
        -- CopyVisibilityStateToDummies()

        OnTicks(5, function()
            -- Dye.RestoreParameters(e.Uuid.EntityUuid)
        end)
    end
end)



Ext.Entity.OnDestroy('PhotoModeSession', function()
    _GLL.States.inPhotoMode = false

    Helpers.Timer:OnTicks(35, function()

        OnTicks(5, function()
        end)

    end)
end)



function RunSubscribtions()
    Ext.Entity.OnSystemUpdate('ClientCharacterManager', function()

        local sys = Ext.System.ClientCharacterManager
        for entity, v in pairs(sys.RefreshEquipmentSlot) do
            if not entity.ClientPaperdoll then
                -- DPrint('ClientCharacterManager')
                -- RestoreItemsToSlots(entity)
                -- Utils:AntiSpam(300, function()
                --     BustUpdateObjects(entity.Uuid.EntityUuid)
                --     Ext.Timer.WaitFor(Settings.autoUpdDelay[1] * 10, function()
                --         Dye.RestoreParameters(entity.Uuid.EntityUuid)
                --     end)
                -- end)
            end
        end
    end)



    Ext.Entity.OnSystemUpdate('ClientEquipmentVisuals', function()
        local sys = Ext.System.ClientEquipmentVisuals
        -- if _GLL.States.inPhotoMode and E.checkShowCamp.Checked then
        if _GLL.States.inPhotoMode then
            for _, v in pairs(sys.UnloadRequests) do
                -- local dummy = v.Parent
                -- OnTicks(1, function()
                -- -- DPrint('ClientEquipmentVisuals')
                --     RestoreItemsToSlots(dummy)
                --     CopyVisibilityStateToDummy(dummy)
                --     OnTicks(7, function()
                --         Dye.RestoreParameters(Dummy:Owner(dummy).Uuid.EntityUuid, dummy)
                --     end)
                -- end)
            end
        end
    end)
end



if Mods.AahzEasyDye then
    Ext.RegisterNetListener('ED_DelayedSync', function()
        Ext.Timer.WaitFor(500, function()
            -- if Dye and Dye.RestoreParameters then
            --     Dye.RestoreParameters(_C().Uuid.EntityUuid)
            -- end
        end)
    end)
end