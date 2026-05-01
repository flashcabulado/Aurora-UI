local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Button = require(script.Parent.Button)
local Toggle = require(script.Parent.Toggle)
local Slider = require(script.Parent.Slider)
local Dropdown = require(script.Parent.Dropdown)
local Keybind = require(script.Parent.Keybind)
local TextBox = require(script.Parent.TextBox)
local Separator = require(script.Parent.Separator)

local Section = {}
Section.__index = Section

function Section.new(tab, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Section)
    self.Tab = tab
    self.Options = options or {}
    self.Frame = Utils.New("Frame", {Name = "Section", Size = UDim2.new(1, 0, 0, 100), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = tab.Content}, {Utils.List(Enum.FillDirection.Vertical, 8)})
    self.Header = Utils.New("Frame", {Name = "Header", Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Parent = self.Frame})
    Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, -4, 0, 24), Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, Text = self.Options.Title or "Section", Parent = self.Header})
    Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(2, 26), Size = UDim2.new(1, -4, 0, 18), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Subtext, Text = self.Options.Description or "", Parent = self.Header})
    self.Container = Utils.New("Frame", {Name = "Container", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = self.Frame}, {Utils.List(Enum.FillDirection.Vertical, 8)})
    return self
end

function Section:CreateButton(options)
    return Button.new(self, options)
end

function Section:CreateToggle(options)
    return Toggle.new(self, options)
end

function Section:CreateSlider(options)
    return Slider.new(self, options)
end

function Section:CreateDropdown(options)
    return Dropdown.new(self, options)
end

function Section:CreateKeybind(options)
    return Keybind.new(self, options)
end

function Section:CreateTextBox(options)
    return TextBox.new(self, options)
end

function Section:CreateSeparator(options)
    return Separator.new(self, options)
end

return Section
