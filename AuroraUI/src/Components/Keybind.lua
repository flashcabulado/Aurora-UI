local UserInputService = game:GetService("UserInputService")
local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(section, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Keybind)
    self.Options = options or {}
    self.Key = self.Options.Default or Enum.KeyCode.F
    self.Listening = false
    self.Frame = Utils.New("TextButton", {Name = "Keybind", AutoButtonColor = false, Text = "", Size = UDim2.new(1, 0, 0, 62), BackgroundColor3 = theme.Card, BackgroundTransparency = 0.08, ZIndex = 20, Parent = section.Container}, {Utils.Corner(16), Utils.Stroke(theme.Border, 0.9, 1)})
    local title = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 10), Size = UDim2.new(1, -118, 0, 22), Font = Enum.Font.GothamSemibold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, Text = self.Options.Title or "Keybind", ZIndex = 22, Parent = self.Frame})
    local desc = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 33), Size = UDim2.new(1, -118, 0, 18), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Subtext, Text = self.Options.Description or "", ZIndex = 22, Parent = self.Frame})
    local keyButton = Utils.New("TextButton", {AutoButtonColor = false, Text = self.Key.Name, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(92, 34), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = theme.Text, BackgroundColor3 = theme.Surface, ZIndex = 23, Parent = self.Frame}, {Utils.Corner(12), Utils.Stroke(theme.Border, 0.88, 1)})
    keyButton.MouseButton1Click:Connect(function()
        self.Listening = true
        keyButton.Text = "Press..."
        Animation.Tween(keyButton, Animation.Presets.Smooth, {BackgroundColor3 = theme.Accent})
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if self.Listening then
                self.Key = input.KeyCode
                self.Listening = false
                keyButton.Text = self.Key.Name
                Animation.Tween(keyButton, Animation.Presets.Smooth, {BackgroundColor3 = theme.Surface})
                return
            end
            if input.KeyCode == self.Key then
                Utils.SafeCallback(self.Options.Callback)
            end
        end
    end)
    return self
end

return Keybind
