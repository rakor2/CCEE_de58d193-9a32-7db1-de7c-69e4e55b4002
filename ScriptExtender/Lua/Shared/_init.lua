Ext.Require("Shared/LibLib/_init.lua")
Ext.Require("Shared/Tables.lua")


-- DPrint(Helpers.Dice:Roll(1,10))


-- Helpers.ModVars:Register("CCEE", ModuleUUID, {}, { -don't know what to put instead of {} to make it work L O L 
--     SyncToClient = false,
--     SyncOnTick = false,
--     SyncOnWrite = true,
-- })


Ext.Vars.RegisterModVariable(ModuleUUID, "CCEE", {
    Server = true, Client = false, SyncToClient = false
})