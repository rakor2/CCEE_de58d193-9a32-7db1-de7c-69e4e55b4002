-- function testS()
--     _C().Vars.NRD_Whatever = 333
--     DPrint(_C().Vars.NRD_Whatever)
-- end

-- Ext.RegisterConsoleCommand('tS', testS)



-- function ForceLoad(TICKS_TO_WAIT, entity)


--     DPrint(entity)

--     local payload = {
--         ArmorUpdate = 1,
--         entityUuid = entity.Uuid.EntityUuid,
--         TICKS_TO_WAIT = TICKS_TO_WAIT,
--         lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
--     }

--     if Helpers.ModVars.Get(ModuleUUID).CCEE then 
--         Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
--     end
    
-- end


---@param ticks integer # Ticks to wait befor applying parameters 
---@param entity EntityHandle
---@param single boolean # Apply parameters to the entity or all entities in ModVars
function UpdateParameters(ticks, entity, single)

    -- DDump(Helpers.ModVars.Get(ModuleUUID).CCEE)

    local uuid

    if entity ~= nil then
        uuid = entity.Uuid.EntityUuid
    else
        uuid = 0
    end

    local payload = {
        single = single,
        entityUuid = uuid,
        TICKS_TO_WAIT = ticks,
        lastParameters = Helpers.ModVars.Get(ModuleUUID).CCEE
    }
    
    DPrint('UpdateParameters')
    if Helpers.ModVars.Get(ModuleUUID).CCEE then 
        Ext.Net.BroadcastMessage('LoadModVars', Ext.Json.Stringify(payload))
    end

end

-- eventID = Ext.Events.Tick:Subscribe(function()
--     Ext.Entity.OnChange("DisplayName", function(entity)
--         DPrint('123')
--     end)
-- end)
