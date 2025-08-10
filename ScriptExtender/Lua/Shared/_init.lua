Ext.Require("Shared/LibLib/_init.lua")
Ext.Require("Shared/SharedHandlers.lua")
Ext.Require("Shared/Tables.lua")
Ext.Require("Shared/Paperdolls.lua")
-- DPrint(Helpers.Dice:Roll(1,10))


Helpers.ModVars:Register("CCEE_AM", ModuleUUID, nil, {
    SyncToClient = false,
    SyncOnTick = false,
    SyncOnWrite = true,
})


Helpers.ModVars:Register("CCEE_MP", ModuleUUID, nil, {
    SyncToClient = false,
    SyncOnTick = false,
    SyncOnWrite = true,
})

Helpers.ModVars:Register("CCEE_VARS", ModuleUUID, nil, {
    SyncToClient = false,
    SyncOnTick = false,
    SyncOnWrite = true,
})


