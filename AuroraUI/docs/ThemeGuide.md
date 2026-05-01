# Theme Guide

AuroraUI usa um sistema de tema centralizado. Você pode usar presets ou passar uma tabela customizada.

## Presets

```lua
AuroraUI:SetTheme("Dark")
AuroraUI:SetTheme("Ocean")
AuroraUI:SetTheme("Rose")
```

## Tema customizado

```lua
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
```

## Gradientes

Gradientes são aplicados em banner, pills, fills e elementos ativos. O efeito principal usa `Accent` e `AccentSecondary`.

## Textura noise

A textura noise é aplicada por `Effects/Textures.lua`. Se quiser desligar por janela, use:

```lua
Noise = false
```

## Sombras

A sombra usa imagem slice interna do Roblox. Para desligar:

```lua
Shadow = false
```

## Estilo iOS

Para manter o visual iPhone-like, use:

- cantos arredondados grandes
- pouco contraste agressivo
- transparência leve
- gradientes suaves
- sombras macias
- animações rápidas e suaves
