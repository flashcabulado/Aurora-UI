local Theme = require(script.Parent.Theme)
local Utils = require(script.Parent.Utils)
local Window = require(script.Parent.Components.Window)
local Notification = require(script.Parent.Components.Notification)

local Core = {}
Core.__index = Core

function Core.new()
    local self = setmetatable({}, Core)
    self.Windows = {}
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AuroraUI"
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = Utils.GetPlayerGui()
    self.NotificationHolder = Instance.new("Frame")
    self.NotificationHolder.Name = "Notifications"
    self.NotificationHolder.BackgroundTransparency = 1
    self.NotificationHolder.Size = UDim2.fromScale(1, 1)
    self.NotificationHolder.ZIndex = 100
    self.NotificationHolder.Parent = self.ScreenGui
    return self
end

function Core:SetTheme(theme)
    return Theme.Set(theme)
end

function Core:GetTheme()
    return Theme.Get()
end

function Core:CreateWindow(options)
    if options and options.Theme then
        Theme.Set(options.Theme)
    end
    local window = Window.new(self, options or {})
    table.insert(self.Windows, window)
    return window
end

function Core:Notify(options)
    return Notification.new(self, options or {})
end

function Core:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return Core
