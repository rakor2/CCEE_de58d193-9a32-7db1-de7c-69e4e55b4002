-- function testS()
--     _C().Vars.NRD_Whatever = 333
--     DPrint(_C().Vars.NRD_Whatever)
-- end

-- Ext.RegisterConsoleCommand('tS', testS)

Ext.Osiris.RegisterListener("Equipped", 2, "after", function(item, character)
    Ext.Net.BroadcastMessage('UpdateParameters','')
end)

Ext.Osiris.RegisterListener("Unequipped", 2, "after", function(item, character)
    Ext.Net.BroadcastMessage('UpdateParameters','')
end)

Ext.Entity.Subscribe("ArmorSetState", function(entity)
    Helpers.Timer:OnTicks(3, function()
        Ext.Net.BroadcastMessage('UpdateParameters','')
    end)
end)
