Ext.Require("Client/ClientHandlers.lua")
Ext.Require("Client/ClientListeners.lua")
Ext.Require("Client/ClientRequests.lua")
Ext.Require("Client/UI.lua")


Test = {}


function Test:CharVis()
    local allCharVis = Ext.Resource.GetAll('CharacterVisual')
    -- for k,v in pairs(allCharVis) do
    --    DPrint(k)
    --     DDump()
    -- end

    for i = 1, 1 do
        DDump(Ext.Resource.Get(allCharVis[i],'CharacterVisual'))
    end
end








