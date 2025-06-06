Ext.Require("Shared/LibLib/Style.lua")
Ext.Require("Shared/LibLib/Helpers.lua")
Ext.Require("Shared/LibLib/ImGui/_init.lua")


Helpers.UserVars:Register('CCEE_Last', {
    Server = true,
    Client = true,
    SyncToClient = true,
    SyncToServer = true,
    SyncOnTick = true,
    SyncOnWrite = true,
})

-- Ext.Vars.RegisterUserVariable("NRD_Whatever", {
--     Server = true,
--     Client = true, 
--     SyncToClient = true,
--     SyncToServer = true,
--     WriteableOnServer = true,
--     WriteableOnClient = true,
-- })