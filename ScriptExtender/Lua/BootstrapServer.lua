Ext.Require("_Libs/_InitLibs.lua")
Ext.Require("Shared/_init.lua")
Ext.Require("Server/_init.lua")

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    DPrint('xd')
    Ext.Net.BroadcastMessage("CCEE_LevelStarted","")
end)