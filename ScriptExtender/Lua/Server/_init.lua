Ext.Require("Server/ServerListeners.lua")
Ext.Require("Server/ServerHandlers.lua")
Ext.Require("Server/ServerRequests.lua")

Helpers.ModVars:Register("CCEE_AM", ModuleUUID, nil, {
    Client = false,
    SyncToClient = false,
    SyncOnTick = false,
    SyncOnWrite = false,
})


Helpers.ModVars:Register("CCEE_MP", ModuleUUID, nil, {
    Client = false,
    SyncToClient = false,
    SyncOnTick = false,
    SyncOnWrite = false,
})


Helpers.ModVars:Register("CCEE_VARS", ModuleUUID, nil, {
    Client = false,
    SyncToClient = false,
    SyncOnTick = false,
    SyncOnWrite = false,
})
