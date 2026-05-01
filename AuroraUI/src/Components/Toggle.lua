local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(section, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Toggle)
    self.Options = options or {}
    self.Value = self.Options.Default == true
    self.Frame = Utils.New("TextButton", {Name = "Toggle", AutoButtonColor = false, Text = "", Size = UDim2.new(1, 0, 0, 62), BackgroundColor3 = theme.Card, BackgroundTransparency = 0.08, ZIndex = 20, Parent = section.Container}, {Utils.Corner(16), Utils.Stroke(theme.Border, 0.9, 1)})
    local title = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 10), Size = UDim2.new(1, -90, 0, 22), Font = Enum.Font.GothamSemibold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, Text = self.Options.Title or "Toggle", ZIndex = 22, Parent = self.Frame})
    local desc = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 33), Size = UDim2.new(1, -90, 0, 18), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Subtext, Text = self.Options.Description or "", ZIndex = 22, Parent = self.Frame})
    local track = Utils.New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(50, 28), BackgroundColor3 = self.Value and theme.Accent or theme.Surface, BackgroundTransparency = 0, ZIndex = 22, Parent = self.Frame}, {Utils.Corner(999)})
    local knob = Utils.New("Frame", {Position = self.Value and UDim2.fromOffset(24, 3) or UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(22, 22), BackgroundColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 23, Parent = track}, {Utils.Corner(999)})
    function self:Set(value)
        self.Value = value == true
        Animation.Tween(track, Animation.Presets.Smooth, {BackgroundColor3 = self.Value and theme.Accent or theme.Surface})
        Animation.Tween(knob, Animation.Presets.Spring, {Position = self.Value and UDim2.fromOffset(24, 3) or UDim2.fromOffset(3, 3)})
        Utils.SafeCallback(self.Options.Callback, self.Value)
    end
    self.Frame.MouseButton1Click:Connect(function()
        Animation.Press(self.Frame)
        self:Set(not self.Value)
    end)
    return self
end

return Toggle
