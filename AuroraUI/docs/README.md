# AuroraUI

AuroraUI é uma UI Library local para Roblox criada em Lua/Luau, com visual moderno, premium, inspirado em iOS, glassmorphism, VisionOS, Control Center e interfaces de app mobile.

Ela inclui janela animada, sidebar com groups, tabs, sections, botão, toggle, slider, dropdown, keybind, textbox, notificações, tema customizável, textura noise, sombra, gradiente, botão flutuante de reabertura e suporte a PC/mobile.

## Instalação

1. Extraia o `.zip`.
2. Coloque a pasta `AuroraUI` em `ReplicatedStorage`.
3. Coloque `examples/Example.client.lua` em `StarterPlayerScripts` para testar.
4. Abra o jogo no Roblox Studio.
5. Pressione `RightShift` para abrir/fechar e `M` para minimizar.

## Uso básico

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuroraUI = require(ReplicatedStorage:WaitForChild("AuroraUI"):WaitForChild("src"):WaitForChild("Init"))

local Window = AuroraUI:CreateWindow({
    Title = "Aurora UI",
    Subtitle = "Premium Roblox Interface",
    Footer = "AuroraUI • v1.0.0"
})

local Tab = Window:CreateTab({Name = "Main", Icon = "Home", Group = "General"})
local Section = Tab:CreateSection({Title = "Player", Description = "Local player settings"})

Section:CreateButton({
    Title = "Click Me",
    Description = "Runs a callback",
    Callback = function()
        print("Clicked")
    end
})
```

## Componentes

- Window
- Groups
- Tabs
- Sections
- Button
- Toggle
- Slider
- Dropdown
- Keybind
- TextBox
- Separator
- Notification
- Theme Manager

## Hotkeys

Por padrão:

- `RightShift`: abre ou fecha a janela
- `M`: minimiza a janela

Você pode trocar em `CreateWindow` usando `ToggleKey` e `MinimizeKey`.

## Thumbnail e banner

Use asset ids do Roblox:

```lua
Thumbnail = "rbxassetid://123456789",
Banner = "rbxassetid://987654321"
```

## Groups

Groups organizam tabs na sidebar:

```lua
Window:CreateTab({Name = "Main", Icon = "Home", Group = "General"})
Window:CreateTab({Name = "Theme", Icon = "Palette", Group = "Design"})
```

## Notificações

```lua
AuroraUI:Notify({
    Title = "AuroraUI",
    Content = "Loaded successfully",
    Duration = 4,
    Type = "Success"
})
```

Tipos aceitos: `Info`, `Success`, `Warning`, `Error`.
