function getCharacterCreationAppearance(entity)
    local SavedAppearance = {}
    local CCA = entity.CharacterCreationAppearance
    if CCA then
        SavedAppearance.AdditionalChoices = {}
        for i = 1, #CCA.AdditionalChoices do
            SavedAppearance.AdditionalChoices[i] = CCA.AdditionalChoices[i]
        end
        SavedAppearance.Elements = {}
        for i = 1, #CCA.Elements do
            SavedAppearance.Elements[i] = {
                Color = CCA.Elements[i].Color,
                ColorIntensity = CCA.Elements[i].ColorIntensity,
                GlossyTint = CCA.Elements[i].GlossyTint,
                Material = CCA.Elements[i].Material,
                MetallicTint = CCA.Elements[i].MetallicTint
            }
        end
        SavedAppearance.EyeColor = CCA.EyeColor
        SavedAppearance.HairColor = CCA.HairColor
        SavedAppearance.SecondEyeColor = CCA.SecondEyeColor
        SavedAppearance.SkinColor = CCA.SkinColor
        SavedAppearance.Visuals = {}
        for i = 1, #CCA.Visuals do
            SavedAppearance.Visuals[i] = CCA.Visuals[i]
        end
    end
    return SavedAppearance
end

function getDummyAppearance(entity)
    local SavedAppearance = {}
    local dummyCCA = entity.ClientCCDummyDefinition
    if dummyCCA and dummyCCA.Visual then
        local vis = dummyCCA.Visual
        SavedAppearance.AdditionalChoices = {}
        for i = 1, #vis.AdditionalChoices do
            SavedAppearance.AdditionalChoices[i] = vis.AdditionalChoices[i]
        end
        SavedAppearance.Elements = {}
        for i = 1, #vis.Elements do
            SavedAppearance.Elements[i] = {
                Color = vis.Elements[i].Color,
                ColorIntensity = vis.Elements[i].ColorIntensity,
                GlossyTint = vis.Elements[i].GlossyTint,
                Material = vis.Elements[i].Material,
                MetallicTint = vis.Elements[i].MetallicTint
            }
        end
        SavedAppearance.EyeColor = vis.EyeColor
        SavedAppearance.HairColor = vis.HairColor
        SavedAppearance.SecondEyeColor = vis.SecondEyeColor
        SavedAppearance.SkinColor = vis.SkinColor
        SavedAppearance.Visuals = {}
        for i = 1, #vis.Visuals do
            SavedAppearance.Visuals[i] = vis.Visuals[i]
        end
    end
    DPrint('4')
    DDump(SavedAppearance)
    return SavedAppearance
end

function getCharacterCreationAppearance2(entity)
    local SavedAppearance = {}
    local CCA = entity.CharacterCreationAppearance
    if CCA then
        SavedAppearance.AdditionalChoices = {}
        for i = 1, #CCA.AdditionalChoices do
            SavedAppearance.AdditionalChoices[i] = CCA.AdditionalChoices[i]
        end
        SavedAppearance.Elements = {}
        for i = 1, #CCA.Elements do
            SavedAppearance.Elements[i] = {
                Color = CCA.Elements[i].Color,
                ColorIntensity = CCA.Elements[i].ColorIntensity,
                GlossyTint = CCA.Elements[i].GlossyTint,
                Material = CCA.Elements[i].Material,
                MetallicTint = CCA.Elements[i].MetallicTint
            }
        end
        SavedAppearance.EyeColor = CCA.EyeColor
        SavedAppearance.HairColor = CCA.HairColor
        SavedAppearance.SecondEyeColor = CCA.SecondEyeColor
        SavedAppearance.Visuals = {}
        for i = 1, #CCA.Visuals do
            SavedAppearance.Visuals[i] = CCA.Visuals[i]
        end
    end
    return SavedAppearance
end

function applyCharacterCreationAppearance(charEntity, SavedAppearance)
    local CCA = charEntity.CharacterCreationAppearance
    for i = 1, #SavedAppearance.AdditionalChoices do
        CCA.AdditionalChoices[i] = SavedAppearance.AdditionalChoices[i]
    end
    for i = 1, #SavedAppearance.Elements do
        CCA.Elements[i].Color = SavedAppearance.Elements[i].Color
        CCA.Elements[i].ColorIntensity = SavedAppearance.Elements[i].ColorIntensity
        CCA.Elements[i].GlossyTint = SavedAppearance.Elements[i].GlossyTint
        CCA.Elements[i].Material = SavedAppearance.Elements[i].Material
        CCA.Elements[i].MetallicTint = SavedAppearance.Elements[i].MetallicTint
    end
    CCA.EyeColor = SavedAppearance.EyeColor
    CCA.HairColor = SavedAppearance.HairColor
    CCA.SecondEyeColor = SavedAppearance.SecondEyeColor
    CCA.SkinColor = SavedAppearance.SkinColor
    for i = 1, #SavedAppearance.Visuals do
        CCA.Visuals[i] = SavedAppearance.Visuals[i]
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

