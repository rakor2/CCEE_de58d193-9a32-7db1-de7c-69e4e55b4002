Button = {}


---@param parent any
---@param name string
---@param fn function
---@field SameLine boolean
---@field IDcontext string
function Button:AddButton(parent, name, options, fn)
    parent = parent
    name = name or ""
    options = options or {} 
    options.SameLine = options.SameLine ~= nil and options.SameLine or false
    options.IDContext = options.IDContext  ~= nil and options.IDContext
    local button = parent:AddButton(name)
    button.IDContext = options.IDContext
    button.SameLine = button.SameLine
    button.OnClick = function ()
        fn()
    end
end




-- local button = parent:AddButton("Button Text")
-- button.IDContext = "UniqueButtonID"
-- button.SameLine = false
-- button.OnClick = function()
--     -- Button click code here
-- end
