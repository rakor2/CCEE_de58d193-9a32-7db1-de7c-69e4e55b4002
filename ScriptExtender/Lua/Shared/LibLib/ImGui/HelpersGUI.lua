HellpersGUI = {}

---Destroy elements
---@param child parent
function HellpersGUI:ClearChildChildren(child)
    for i = #child.Children, 1, -1 do
        local elements = child.Children[i]
        elements:Destroy()
    end
end


---Split text by lines (runs on vibes)
---
---In:
---
---Technology has transformed every aspect of modern life. From smartphones to AI, innovations emerge daily, reshaping how we work and communicate. The internet connects billions worldwide, breaking geographical barriers. Smart devices automate homes, while electric vehicles revolutionize transportation.
---
---Out:
---
---Technology has transformed every aspect of
---modern life. From smartphones to AI,
---innovations emerge daily, reshaping how we
---work and communicate. The internet
---connects billions worldwide, breaking
---geographical barriers. Smart devices
---automate homes, while electric vehicles
---revolutionize transportation.
---
---@param text string
---@param lineWidth integer
---@return string
function HellpersGUI:TextSplit(text, lineWidth)

    lineWidth = lineWidth or 50
    
    if not text or text == "" then
        return ""
    end
    
    local result = ""
    local currentLine = ""
    local currentLength = 0
    

    for word in text:gmatch("%S+") do

        if currentLength + #word + (currentLength > 0 and 1 or 0) <= lineWidth then

            if currentLength > 0 then
                currentLine = currentLine .. " "
                currentLength = currentLength + 1
            end
            
            currentLine = currentLine .. word
            currentLength = currentLength + #word
        else

            if result ~= "" then
                result = result .. "\n"
            end
            result = result .. currentLine
            currentLine = word
            currentLength = #word
        end
    end
    
    if currentLine ~= "" then
        if result ~= "" then
            result = result .. "\n"
        end
        result = result .. currentLine
    end
    
    return result
end