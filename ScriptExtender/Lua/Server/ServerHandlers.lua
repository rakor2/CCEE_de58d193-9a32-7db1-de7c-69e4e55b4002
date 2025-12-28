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
    return 0
end


local xd = {
    'bc372dfb-3a0a-4fc4-a23d-068a12699d78',
    'e3cee464-637e-4a20-ab90-1a90c6d06a43',
    'a0561348-f2f5-447b-9dd0-a2d80b79c892',
    '6ad28264-d419-4fbb-a514-062386f8d923',
    'e542c845-b1e0-4349-9f5e-649d0da52c0e',
    '7beb0d54-9ee7-44fd-adec-c96dc989bb42',
    '68e23b81-d09b-4c63-ad3c-08958d329a68',
    '685eb026-02d2-41f4-9de9-b2dd51de40e5',
    'c5bce236-33db-4662-b9e0-89d20c16c933',
    'c19c608e-f8d3-45a4-9bb6-a6548ac1e8e3',
    'dffbbc9f-8877-4af6-a1f6-095f3b41214c',
    'dcb67f1d-359a-4fc4-bc14-b588cb50aa08',
    '9e9a513c-bc63-4374-a835-169f269c4dfc',
    'a0741c4c-2e20-4ab4-876e-f23769b5c7a8',
    '398b523a-632f-4b74-97f7-9217f83d7d28',
    'f7b1d2a1-942d-477c-b3b8-bb5fa827a94f',
    'fb4c729b-41df-49de-86df-72de6d34a45d',
    '4d2aa967-5c18-47ac-8d0b-dc5f151acfb0',
    'e3c9c5b9-ce5a-4ffd-8944-79b348a22366',
    '0f91955f-28ef-4c99-a22a-b9c2f67f3ad1',
    '73d8cbd9-27fd-4991-972c-1977a995f69a',
    'a08fcb9d-5aa7-465c-ab49-d5b986541e95',
    '3dafa009-ccf3-458f-bd7b-edfd9c1e13db',
    '8318ba69-21c0-44a7-a0ce-29b4f67bc0c5',
    '74f27f58-c75f-4d1c-ba24-cd6048812ce8',
    '18e9fee7-649a-4af7-8974-ad431904842f',
    '97cb8647-c150-4c4f-ad01-b46d87f3f601',
    '97d8ceee-eacc-4057-9028-a112fd9d35b4',
    '398061cf-da56-45bc-909d-e42a3a6b8821',
    'e9ebc83f-d7f5-459f-8aff-b0d200e5ff49',
    'f400e525-718b-4d02-97ba-6702029f458b',
    '5617af94-c374-4231-bf63-ec2d3bcd5e86',
    '52b42c60-dd58-405e-a73f-afe5fa07ae74',
    '598ccc29-2c27-4a64-aa5e-2a36d60f992b',
    '09170204-4976-473c-89bc-393efe7859ae',
    '190da457-8b3b-4dd5-9e5d-23ac3424d581',
    '39dc6983-8d92-4b52-9f88-9fb9e43f85e6',
    '8d76f43f-82c9-4b10-acc5-18a13a54cd64',
    '98c63cda-62a0-4852-b459-75196dd4e654',
    'b5c0a60f-59ca-4640-b06b-538d48f12a4f',
    '94f8315c-452a-4310-a49c-e0767b03a552',
    'a91d04c8-0987-4318-bcf9-e33bf796793a',
    '58e6b206-4cfc-41f3-af7e-25358a30cf7f',
}

function presetHasCCEESkin(presetUuid)
    for _, uuid in pairs(xd) do
        -- DPrint(uuid)
        if presetUuid == uuid then
            return true
        end
    end
end

-- eventID = Ext.Events.Tick:Subscribe(function()
--     Ext.Entity.OnChange( DisplayName , function(entity)
--         DPrint('123')
--     end)
-- end)
