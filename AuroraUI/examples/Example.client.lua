local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuroraUI = require(ReplicatedStorage:WaitForChild("AuroraUI"):WaitForChild("src"):WaitForChild("Init"))

AuroraUI:SetTheme({
    Background = Color3.fromRGB(12, 14, 20),
    Surface = Color3.fromRGB(20, 24, 34),
    Card = Color3.fromRGB(28, 34, 46),
    Accent = Color3.fromRGB(124, 92, 255),
    AccentSecondary = Color3.fromRGB(0, 212, 255),
    Text = Color3.fromRGB(245, 247, 250),
    Subtext = Color3.fromRGB(150, 160, 175),
    Border = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(52, 211, 153),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(248, 113, 113)
})

local Window = AuroraUI:CreateWindow({
    Title = "Aurora UI",
    Subtitle = "Premium Roblox Interface",
    Footer = "AuroraUI • v1.0.0",
    Thumbnail = "rbxassetid://0",
    Banner = "rbxassetid://0",
    Size = UDim2.fromOffset(620, 430),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    ToggleKey = Enum.KeyCode.RightShift,
    MinimizeKey = Enum.KeyCode.M,
    Theme = "Dark",
    Acrylic = true,
    Noise = true,
    Shadow = true,
    Blur = true,
    MobileScale = 0.85,
    Draggable = true,
    Closable = true,
    Minimizable = true
})

local Main = Window:CreateTab({Name = "Main", Icon = "Home", Group = "General"})
local Player = Window:CreateTab({Name = "Player", Icon = "Player", Group = "General"})
local Visuals = Window:CreateTab({Name = "Visuals", Icon = "Palette", Group = "Design"})
local Settings = Window:CreateTab({Name = "Settings", Icon = "Settings", Group = "System"})

local MainSection = Main:CreateSection({Title = "Actions", Description = "Buttons, toggles and basic actions"})
MainSection:CreateButton({Title = "Click Me", Description = "Runs a callback", Icon = "Sparkles", Callback = function() print("Clicked") end})
MainSection:CreateToggle({Title = "Enable Feature", Description = "Turns something on or off", Default = false, Callback = function(Value) print(Value) end})
MainSection:CreateDropdown({Title = "Select Mode", Description = "Choose one option", Options = {"Legit", "Balanced", "Fast"}, Default = "Balanced", Callback = function(Value) print(Value) end})

local PlayerSection = Player:CreateSection({Title = "Player", Description = "Local player settings"})
PlayerSection:CreateSlider({Title = "WalkSpeed", Description = "Adjust local walkspeed", Min = 16, Max = 100, Default = 16, Increment = 1, Callback = function(Value) print(Value) end})
PlayerSection:CreateKeybind({Title = "Action Key", Description = "Set a custom key", Default = Enum.KeyCode.F, Callback = function() print("Pressed") end})
PlayerSection:CreateTextBox({Title = "Username", Description = "Type something", Placeholder = "Enter text...", Callback = function(Text) print(Text) end})

local VisualSection = Visuals:CreateSection({Title = "Theme", Description = "Change the visual preset"})
VisualSection:CreateButton({Title = "Ocean Theme", Description = "Apply a blue glass preset", Icon = "Palette", Callback = function() AuroraUI:SetTheme("Ocean") AuroraUI:Notify({Title = "Theme", Content = "Ocean preset selected", Duration = 3, Type = "Success"}) end})
VisualSection:CreateButton({Title = "Rose Theme", Description = "Apply a pink glass preset", Icon = "Palette", Callback = function() AuroraUI:SetTheme("Rose") AuroraUI:Notify({Title = "Theme", Content = "Rose preset selected", Duration = 3, Type = "Success"}) end})

local SystemSection = Settings:CreateSection({Title = "Window", Description = "Visibility and behavior"})
SystemSection:CreateButton({Title = "Minimize", Description = "Turn the window into a floating pill", Icon = "Sparkles", Callback = function() Window:Minimize() end})
SystemSection:CreateButton({Title = "Hide", Description = "Hide and use the pill to reopen", Icon = "Shield", Callback = function() Window:Hide() end})

AuroraUI:Notify({Title = "AuroraUI", Content = "Interface loaded successfully", Duration = 4, Type = "Success"})
