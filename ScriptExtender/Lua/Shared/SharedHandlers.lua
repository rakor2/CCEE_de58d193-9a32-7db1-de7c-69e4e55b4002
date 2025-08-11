function getCharacterCreationAppearance(entity)
    local savedAppearance = {}
    local CCA = entity.CharacterCreationAppearance
    if CCA then
        savedAppearance.AdditionalChoices = {}
        for i = 1, #CCA.AdditionalChoices do
            savedAppearance.AdditionalChoices[i] = CCA.AdditionalChoices[i]
        end
        savedAppearance.Elements = {}
        for i = 1, #CCA.Elements do
            savedAppearance.Elements[i] = {
                Color = CCA.Elements[i].Color,
                ColorIntensity = CCA.Elements[i].ColorIntensity,
                GlossyTint = CCA.Elements[i].GlossyTint,
                Material = CCA.Elements[i].Material,
                MetallicTint = CCA.Elements[i].MetallicTint
            }
        end
        savedAppearance.EyeColor = CCA.EyeColor
        savedAppearance.HairColor = CCA.HairColor
        savedAppearance.SecondEyeColor = CCA.SecondEyeColor
        savedAppearance.SkinColor = CCA.SkinColor
        savedAppearance.Visuals = {}
        for i = 1, #CCA.Visuals do
            savedAppearance.Visuals[i] = CCA.Visuals[i]
        end
    end
    return savedAppearance
end

function getDummyAppearance(entity)
    DPrint('1')
    local savedAppearance = {}
    local dummyCCA = entity.ClientCCDummyDefinition
    if dummyCCA and dummyCCA.Visual then
        local vis = dummyCCA.Visual
        savedAppearance.AdditionalChoices = {}
        for i = 1, #vis.AdditionalChoices do
            savedAppearance.AdditionalChoices[i] = vis.AdditionalChoices[i]
        end
        savedAppearance.Elements = {}
        for i = 1, #vis.Elements do
            savedAppearance.Elements[i] = {
                Color = vis.Elements[i].Color,
                ColorIntensity = vis.Elements[i].ColorIntensity,
                GlossyTint = vis.Elements[i].GlossyTint,
                Material = vis.Elements[i].Material,
                MetallicTint = vis.Elements[i].MetallicTint
            }
        end
        savedAppearance.EyeColor = vis.EyeColor
        savedAppearance.HairColor = vis.HairColor
        savedAppearance.SecondEyeColor = vis.SecondEyeColor
        savedAppearance.SkinColor = vis.SkinColor
        savedAppearance.Visuals = {}
        for i = 1, #vis.Visuals do
            savedAppearance.Visuals[i] = vis.Visuals[i]
        end
    end
    DPrint('4')
    DDump(savedAppearance)
    return savedAppearance
end

function getCharacterCreationAppearance2(entity)
    local savedAppearance = {}
    local CCA = entity.CharacterCreationAppearance
    if CCA then
        savedAppearance.AdditionalChoices = {}
        for i = 1, #CCA.AdditionalChoices do
            savedAppearance.AdditionalChoices[i] = CCA.AdditionalChoices[i]
        end
        savedAppearance.Elements = {}
        for i = 1, #CCA.Elements do
            savedAppearance.Elements[i] = {
                Color = CCA.Elements[i].Color,
                ColorIntensity = CCA.Elements[i].ColorIntensity,
                GlossyTint = CCA.Elements[i].GlossyTint,
                Material = CCA.Elements[i].Material,
                MetallicTint = CCA.Elements[i].MetallicTint
            }
        end
        savedAppearance.EyeColor = CCA.EyeColor
        savedAppearance.HairColor = CCA.HairColor
        savedAppearance.SecondEyeColor = CCA.SecondEyeColor
        savedAppearance.Visuals = {}
        for i = 1, #CCA.Visuals do
            savedAppearance.Visuals[i] = CCA.Visuals[i]
        end
    end
    return savedAppearance
end

function applyCharacterCreationAppearance(charEntity, savedAppearance)
    local CCA = charEntity.CharacterCreationAppearance
    for i = 1, #savedAppearance.AdditionalChoices do
        CCA.AdditionalChoices[i] = savedAppearance.AdditionalChoices[i]
    end
    for i = 1, #savedAppearance.Elements do
        CCA.Elements[i].Color = savedAppearance.Elements[i].Color
        CCA.Elements[i].ColorIntensity = savedAppearance.Elements[i].ColorIntensity
        CCA.Elements[i].GlossyTint = savedAppearance.Elements[i].GlossyTint
        CCA.Elements[i].Material = savedAppearance.Elements[i].Material
        CCA.Elements[i].MetallicTint = savedAppearance.Elements[i].MetallicTint
    end
    CCA.EyeColor = savedAppearance.EyeColor
    CCA.HairColor = savedAppearance.HairColor
    CCA.SecondEyeColor = savedAppearance.SecondEyeColor
    CCA.SkinColor = savedAppearance.SkinColor
    for i = 1, #savedAppearance.Visuals do
        CCA.Visuals[i] = savedAppearance.Visuals[i]
    end
end


---@param entity EntityHandle
---@param element CharacterCreationAppearanceElemetns
---@return number #index of tattoo element
function getElementIndex(entity, element)
    local Elements
    if entity.CharacterCreationAppearance then
        Elements = entity.CharacterCreationAppearance.Elements
    elseif entity.ClientCCChangeAppearanceDefinition then
        Elements = entity.ClientCCChangeAppearanceDefinition.Definition.Visual.Elements
    end
    if Elements then
        for i = 1, #Elements do
            if Elements[i] and Elements[i].Material then
                if Elements[i].Material ~= "00000000-0000-0000-0000-000000000000" then
                    local materialData = Ext.StaticData.Get(Elements[i].Material, 'CharacterCreationAppearanceMaterial')
                    if materialData and materialData.Name:lower():find(element:lower()) then
                        return i
                    end
                end
            end
        end
    end
end