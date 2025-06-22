Paperdoll = {}

---@param entity EntityHandle
---@return Guid|nil
local function GetItemTemplate(entity)
    if entity.GameObjectVisual ~= nil then
        return entity.GameObjectVisual.RootTemplateId
    end
end

---@param entity EntityHandle
---@return ItemSlot|nil
local function GetItemSlot(entity)
    if entity.Equipable ~= nil then
        return entity.Equipable.Slot
    end
end

--- Jank.
---@param entity EntityHandle
---@return boolean
local function EntityIsPaperDoll(entity)
    --return entity.ClientEquipmentVisuals ~= nil and Helpers.Loca:GetDisplayName(entity) == nil
    return Helpers.Loca:GetDisplayName(entity) == nil
end

---@param doll EntityHandle
---@return EntityHandle|nil
function Paperdoll.GetDollOwner(doll)
    local slotTemplates = {}
    if doll.ClientEquipmentVisuals then 
        for _, entry in pairs(doll.ClientEquipmentVisuals.Equipment) do
            if entry.Item ~= nil then
                local slot = GetItemSlot(entry.Item)
                local template = GetItemTemplate(entry.Item)
                if slot and template then
                    slotTemplates[slot] = template
                end
            end
        end
    end

    for _, character in pairs(Ext.Entity.GetAllEntitiesWithComponent("ClientEquipmentVisuals")) do
        if not EntityIsPaperDoll(character) then
            local isDollOwner = true -- assume this is the owner
            -- go through character's equipment and check the item's slot template for a mismatch
            for _, item in pairs(character.ClientEquipmentVisuals.Equipment) do
                if item.Item ~= nil then
                    local slot = GetItemSlot(item.Item)
                    local template = GetItemTemplate(item.Item)
                    if slot and template and slotTemplates[slot] ~= template then
                        isDollOwner = false -- mismatch, this is not the matching entity
                        break
                    end
                end
            end
            
            if isDollOwner then
                return character
            end
        end
    end
end

---@param owner EntityHandle
---@return EntityHandle
function Paperdoll.GetOwnersDoll(owner)
    local slotTemplates = {}
    for _, entry in pairs(owner.ClientEquipmentVisuals.Equipment) do
        if entry.Item ~= nil then
            local slot = GetItemSlot(entry.Item)
            local template = GetItemTemplate(entry.Item)
            if slot and template then
                slotTemplates[slot] = template
            end
        end
    end

    for _, character in pairs(Ext.Entity.GetAllEntitiesWithComponent("ClientEquipmentVisuals")) do
        if EntityIsPaperDoll(character) then
            local isOwnersDoll = true
            for _,item in pairs(character.ClientEquipmentVisuals.Equipment) do
                if item.Item ~= nil then
                    local slot = GetItemSlot(item.Item)
                    local template = GetItemTemplate(item.Item)
                    if slot and template and slotTemplates[slot] ~= template then
                        isOwnersDoll = false
                        break
                    end
                end
            end

            if isOwnersDoll then
                return character
            end
        end
    end
end

---@return {Doll:EntityHandle, Owner:EntityHandle, OwnerName:string}[]
function Paperdoll.GetAllDollOwners()
    local dolls = {}
    for _, entity in pairs(Ext.Entity.GetAllEntitiesWithComponent("ClientEquipmentVisuals")) do
        if EntityIsPaperDoll(entity) then
            local owner = Paperdoll.GetDollOwner(entity)
            if owner ~= nil then
                table.insert(dolls, {
                    Doll = entity,
                    Owner = owner,
                    OwnerName = Helpers.Loca:GetDisplayName(owner)
                })
            end
        end
    end

    return dolls
end