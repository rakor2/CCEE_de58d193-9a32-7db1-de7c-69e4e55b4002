-- function testS()
--     _C().Vars.NRD_Whatever = 333
--     DPrint(_C().Vars.NRD_Whatever)
-- end

-- Ext.RegisterConsoleCommand('tS', testS)


---@param ticks integer # Ticks to wait befor applying parameters 
---@param entity EntityHandle
---@param singleEntity boolean # Apply parameters to single character or all characters
function UpdateParameters(ticks, entity, singleEntity, onlyVis)
    -- DDump(Helpers.ModVars.Get(ModuleUUID).CCEE)
    local uuid
    if entity ~= nil then
        uuid = entity.Uuid.EntityUuid
    else
        uuid = ''
    end
    local payload = {
        single = singleEntity,
        entityUuid = uuid,
        TICKS_TO_WAIT = ticks,
        lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE,
        matParameters = Helpers.ModVars.Get(ModuleUUID).CCEE_MT
    }

    DPrint('UpdateParameters')

    if onlyVis == true then
        Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
    else
        if Helpers.ModVars.Get(ModuleUUID).CCEE then 
            Ext.Net.BroadcastMessage('LoadMatVars', Ext.Json.Stringify(payload))
            Helpers.Timer:OnTicks(15, function ()
                Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
            end)
        end
    end

end

-- eventID = Ext.Events.Tick:Subscribe(function()
--     Ext.Entity.OnChange("DisplayName", function(entity)
--         DPrint('123')
--     end)
-- end)
