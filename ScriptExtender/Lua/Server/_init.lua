Ext.Require('Server/1_ServerHandlers2.lua')
Ext.Require('Server/2_ServerListeners2.lua')
Ext.Require('Server/3_ServerRequests2.lua')



Helpers.ModVars:Register('CCEE_AM2', ModuleUUID, nil, {
    Client = false,
    SyncToClient = false,
    SyncOnTick = false,
    SyncOnWrite = false,
})



Helpers.ModVars:Register('CCEE_MP2', ModuleUUID, nil, {
    Client = false,
    SyncToClient = false,
    SyncOnTick = false,
    SyncOnWrite = false,
})



Helpers.ModVars:Register('CCEE_VARS2', ModuleUUID, nil, {
    Client = false,
    SyncToClient = false,
    SyncOnTick = false,
    SyncOnWrite = false,
})



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
