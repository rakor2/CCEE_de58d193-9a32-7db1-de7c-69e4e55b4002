-- function testS()
--     _C().Vars.NRD_Whatever = 333
--     DPrint(_C().Vars.NRD_Whatever)
-- end

-- Ext.RegisterConsoleCommand('tS', testS)

---@param ticks integer # Ticks to wait befor applying parameters 
---@param entity EntityHandle
---@param singleEntity boolean # Apply parameters to single character or all characters
---@param onlyVis boolean 
function UpdateParameters(ticks, entity, singleEntity, onlyVis, print)
    -- DDump(Helpers.ModVars.Get(ModuleUUID).CCEE_AM)
    local uuid
    if entity ~= nil then
        uuid = entity.Uuid.EntityUuid
    else
        uuid = ''
    end
    local payload = {
        single = singleEntity,
        entityUuid = uuid,
        TICKS_TO_WAIT = ticks,
        ActiveMatParameters = Helpers.ModVars.Get(ModuleUUID).CCEE_AM,
        MatPresetParameters = Helpers.ModVars.Get(ModuleUUID).CCEE_MP
    }
    if onlyVis == true then
        Ext.Net.BroadcastMessage('CCEE_LoadModVars', Ext.Json.Stringify(payload))
    else
        Ext.Net.BroadcastMessage('CCEE_LoadMatVars', Ext.Json.Stringify(payload))
        Helpers.Timer:OnTicks(15, function ()
            Ext.Net.BroadcastMessage('CCEE_LoadModVars', Ext.Json.Stringify(payload))
        end)
    end
end


function UpdateParameters(ticks, entity, singleEntity, onlyVis, print)
    -- DDump(Helpers.ModVars.Get(ModuleUUID).CCEE_AM)
    local uuid
    if entity ~= nil then
        uuid = entity.Uuid.EntityUuid
    else
        uuid = ''
    end
    local payload = {
        single = singleEntity,
        entityUuid = uuid,
        TICKS_TO_WAIT = ticks,
        ActiveMatParameters = Helpers.ModVars.Get(ModuleUUID).CCEE_AM,
        MatPresetParameters = Helpers.ModVars.Get(ModuleUUID).CCEE_MP
    }
    if onlyVis == true then
        Ext.Net.BroadcastMessage('CCEE_LoadModVars', Ext.Json.Stringify(payload))
    else
        Ext.Net.BroadcastMessage('CCEE_LoadMatVars', Ext.Json.Stringify(payload))
        Helpers.Timer:OnTicks(15, function ()
            Ext.Net.BroadcastMessage('CCEE_LoadModVars', Ext.Json.Stringify(payload))
        end)
    end
end

--bc372dfb-3a0a-4fc4-a23d-068a12699d78

function setElementsToZero(entity)
    entity = entity or _C()
    local cca = entity.CharacterCreationAppearance
    Globals.backupCca = getCharacterCreationAppearance2(entity)
    for i = 1, #cca.Elements do
        cca.Elements[i].Material = Utils.ZEROUUID
        cca.Elements[i].Color = Utils.ZEROUUID
        cca.Elements[i].ColorIntensity = 0
        cca.Elements[i].GlossyTint = 0
        cca.Elements[i].MetallicTint = 0
    end
    
    --cca.EyeColor = Utils.ZEROUUID
    --cca.SecondEyeColor = Utils.ZEROUUID
    cca.HairColor = Utils.ZEROUUID
    entity:Replicate('CharacterCreationAppearance')
end


function restoreElements(entity)
    entity = entity or _C()
    entity.CharacterCreationAppearance = Globals.backupCca
    Helpers.Timer:OnTicks(5, function ()
        entity:Replicate('CharacterCreationAppearance')
    end)
end


function reSkin(entity)
    local map = Helpers.ModVars.Get(ModuleUUID).CCEE_VARS.SkinMap
    for k,v in pairs(map) do
        if k == entity.Uuid.EntityUuid then
            entity.CharacterCreationAppearance.SkinColor = v
            entity:Replicate('CharacterCreationAppearance')
        end
    end
end

-- eventID = Ext.Events.Tick:Subscribe(function()
--     Ext.Entity.OnChange( DisplayName , function(entity)
--         DPrint('123')
--     end)
-- end)
