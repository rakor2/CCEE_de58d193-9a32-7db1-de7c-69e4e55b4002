---AahzLib
---Ext.OnNextTick, but variable ticks
---@param ticks integer
---@param fn function
function TickTimer(ticks, fn)
    local ticksPassed = 0
    local eventID
    eventID = Ext.Events.Tick:Subscribe(function()
        ticksPassed = ticksPassed + 1
        if ticksPassed >= ticks then
            fn()
            Ext.Events.Tick:Unsubscribe(eventID)
        end
    end)
end






---LibLib

Hellpers = {}


--Extracts name from a template, S_Player_ShadowHeart_3ed74f06-3c60-42dc-83f6-f034cb47c679 will return Player ShadowHeart
--Osi.DisplayName or whatever is bad, becasuse for some templates (most of them) it returns simple names like Elf or Goblin
---@param templateName string
---@return string
function ExtractDisplayName(templateName)
    if not templateName or templateName == "" then
        return "Unknown"
    end
    
    templateName = templateName:gsub("_%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$", "")

    local prefixes = {"S_", "GLO_", "BASE_", "GOB_", "LOW_", "CINE_", "FOR_", "WYR_", "PUZ_", "CAMP_", "CAMP_",
    "GUS_", "QUEST_", "ORIGIN_", "UNI_", "TEST_", "LOOT_", "TUT_", "WLD_", "INTRO_", "UND_", "EPI_", "TEMP_",
    "MOO_", "END_", "CAMP_", "CAMP_", "TWN_", "PLA_", "COL_", "SCL_"}
    for _, prefix in ipairs(prefixes) do
        if templateName:sub(1, #prefix) == prefix then
            templateName = templateName:sub(#prefix + 1)
        end
    end
    
    for _, prefix in ipairs(prefixes) do
        if templateName:sub(1, #prefix) == prefix then
            templateName = templateName:sub(#prefix + 1)
        end
    end

    templateName = templateName:gsub("_", " ")
    
    return templateName
end


--Shorts UUIDs
---@param uuid string
---@param howmuchleft integer
---@return ShortUuid string
function UUIDShortner(uuid, howmuchleft)
    if type(uuid) ~= "string" then
        return "?"
    end
    
    return string.sub(uuid, 1, howmuchleft)
end




--Gets templates by type
---@param type string
---@return string
function GetTemplates(type)
    templatesCache = {}
    if templatesCache[type] then
        return templatesCache[type]
    end

    local templates = Ext.Template.GetAllRootTemplates()
    
    local vanillaTemplates = {}
    for _, templateData in pairs(templates) do
        if templateData.TemplateType == type then
            table.insert(vanillaTemplates, templateData)
        end
    end
    
    templatesCache[type] = vanillaTemplates
    return vanillaTemplates
end



function Hellpers:GetUserID()
    local userID = _C().UserReservedFor.UserID
    return userID
end



function Hellpers:GetCameraData()
    local cameras = Ext.Entity.GetAllEntitiesWithComponent("Camera")
    for _, cameraEntity in ipairs(cameras) do
        local cameraComp = cameraEntity:GetAllComponents()
        if cameraComp and cameraComp.Camera.Active == true and cameraComp.GameCameraBehavior then
                
                local cameraPos = cameraComp.GameCameraBehavior.field_150
                local targetPos = cameraComp.GameCameraBehavior.TargetDestination

            return {x = cameraPos[1], y = cameraPos[2], z = cameraPos[3]},
                   {x = targetPos[1], y = targetPos[2], z = targetPos[3]}
        end
    end
end


function Hellpers:CameraLookAt()
    local cameras = Ext.Entity.GetAllEntitiesWithComponent("Camera")
    for _, cameraEntity in ipairs(cameras) do
        local cameraComp = cameraEntity:GetAllComponents().Camera 
        if cameraComp and cameraComp.Active == true then
            _D(cameraEntity.Camera.Controller.LookAt)
            _D(cameraEntity.Transform)
        end
    end
end


function Hellpers:CameraPos()
    local cameras = Ext.Entity.GetAllEntitiesWithComponent("Camera")
    for _, cameraEntity in ipairs(cameras) do
        local cameraComp = cameraEntity:GetAllComponents().Camera 
        if cameraComp and cameraComp.Active == true then
            _D(cameraEntity.Transform)
        end
    end
end


function Hellpers:GetHostPositionClient()
    local pos = _C().Transform.Transform.Translate
    if pos and pos[1] and pos[2] and pos[3] then
        return {x = pos[1], y = pos[2], z = pos[3]}
    end
    return nil
end

function Hellpers:GetHostPositionServer()
    local x, y, z = Osi.GetPosition(GetHostCharacter())
    return {
        x = x,
        y = y,
        z = z
    }
end


function  Hellpers:GetPositionUUID(UUID)
    local x, y, z = Osi.GetPosition(UUID)
    return {
        x = x,
        y = y,
        z = z
    }
end


function  Hellpers:GetRotationUUID(UUID)
    local rx, ry, rz = Osi.GetRotation(UUID)
    return {
        x = rx or 0,
        y = ry or 0,
        z = rz or 0
    }
end