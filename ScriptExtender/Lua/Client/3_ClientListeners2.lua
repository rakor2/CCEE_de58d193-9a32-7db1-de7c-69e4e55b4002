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

