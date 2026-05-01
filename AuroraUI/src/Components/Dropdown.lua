local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(section, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Dropdown)
    self.Options = options or {}
    self.Open = false
    self.Value = self.Options.Default or (self.Options.Options and self.Options.Options[1]) or ""
    self.Frame = Utils.New("Frame", {Name = "Dropdown", Size = UDim2.new(1, 0, 0, 64), BackgroundColor3 = theme.Card, BackgroundTransparency = 0.08, ClipsDescendants = true, ZIndex = 20, Parent = section.Container}, {Utils.Corner(16), Utils.Stroke(theme.Border, 0.9, 1)})
    local title = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -120, 0, 22), Font = Enum.Font.GothamSemibold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, Text = self.Options.Title or "Dropdown", ZIndex = 22, Parent = self.Frame})
    local desc = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 31), Size = UDim2.new(1, -120, 0, 18), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Subtext, Text = self.Options.Description or "", ZIndex = 22, Parent = self.Frame})
    local trigger = Utils.New("TextButton", {AutoButtonColor = false, Text = self.Value .. " ⌄", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0, 32), Size = UDim2.fromOffset(116, 34), Font = Enum.Font.GothamSemibold, TextSize = 12, TextColor3 = theme.Text, BackgroundColor3 = theme.Surface, ZIndex = 23, Parent = self.Frame}, {Utils.Corner(12), Utils.Stroke(theme.Border, 0.88, 1)})
    local list = Utils.New("Frame", {Position = UDim2.fromOffset(12, 62), Size = UDim2.new(1, -24, 0, 0), BackgroundTransparency = 1, ZIndex = 24, Parent = self.Frame}, {Utils.List(Enum.FillDirection.Vertical, 6)})
    local function rebuild()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        for _, option in ipairs(self.Options.Options or {}) do
            local item = Utils.New("TextButton", {AutoButtonColor = false, Text = tostring(option), Size = UDim2.new(1, 0, 0, 34), Font = Enum.Font.GothamSemibold, TextSize = 12, TextColor3 = theme.Text, BackgroundColor3 = theme.Surface, BackgroundTransparency = option == self.Value and 0.1 or 0.35, ZIndex = 25, Parent = list}, {Utils.Corner(12)})
            item.MouseButton1Click:Connect(function()
                self.Value = option
                trigger.Text = tostring(option) .. " ⌄"
                self:SetOpen(false)
                Utils.SafeCallback(self.Options.Callback, option)
            end)
        end
    end
    function self:SetOpen(value)
        self.Open = value
        local count = #(self.Options.Options or {})
        local height = self.Open and (70 + count * 40) or 64
        Animation.Tween(self.Frame, Animation.Presets.Soft, {Size = UDim2.new(1, 0, 0, height)})
        Animation.Tween(list, Animation.Presets.Smooth, {Size = UDim2.new(1, -24, 0, self.Open and count * 40 or 0)})
        trigger.Text = tostring(self.Value) .. (self.Open and " ⌃" or " ⌄")
    end
    trigger.MouseButton1Click:Connect(function()
        self:SetOpen(not self.Open)
    end)
    rebuild()
    return self
end

return Dropdown
