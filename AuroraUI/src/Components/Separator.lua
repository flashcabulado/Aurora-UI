local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)

local Separator = {}
Separator.__index = Separator

function Separator.new(section, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Separator)
    self.Frame = Utils.New("Frame", {Name = "Separator", Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Parent = section.Container})
    Utils.New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -6, 0, 1), BackgroundColor3 = theme.Border, BackgroundTransparency = 0.9, Parent = self.Frame})
    return self
end

return Separator
