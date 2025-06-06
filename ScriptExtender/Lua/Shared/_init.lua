Ext.Require("Shared/LibLib/_init.lua")
Ext.Require("Shared/Tables.lua")

Helpers.UserVars:Register('CCEE_Last', {
    Server = true,
    Client = true,
    SyncToClient = true,
    SyncToServer = true,
    SyncOnTick = true,
    SyncOnWrite = true,
})

-- DPrint(Helpers.Dice:Roll(1,10))