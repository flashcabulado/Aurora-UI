local Theme = {}

Theme.Current = {
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
}

Theme.Presets = {
    Dark = Theme.Current,
    Ocean = {
        Background = Color3.fromRGB(8, 16, 24),
        Surface = Color3.fromRGB(13, 28, 42),
        Card = Color3.fromRGB(20, 42, 58),
        Accent = Color3.fromRGB(0, 170, 255),
        AccentSecondary = Color3.fromRGB(80, 255, 220),
        Text = Color3.fromRGB(244, 250, 255),
        Subtext = Color3.fromRGB(145, 172, 190),
        Border = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(52, 211, 153),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(248, 113, 113)
    },
    Rose = {
        Background = Color3.fromRGB(20, 12, 18),
        Surface = Color3.fromRGB(34, 20, 30),
        Card = Color3.fromRGB(48, 28, 42),
        Accent = Color3.fromRGB(255, 85, 170),
        AccentSecondary = Color3.fromRGB(255, 180, 120),
        Text = Color3.fromRGB(255, 246, 250),
        Subtext = Color3.fromRGB(190, 150, 170),
        Border = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(52, 211, 153),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(248, 113, 113)
    }
}

function Theme.Merge(base, incoming)
    local result = {}
    for key, value in pairs(base) do
        result[key] = value
    end
    if incoming then
        for key, value in pairs(incoming) do
            result[key] = value
        end
    end
    return result
end

function Theme.Set(theme)
    if typeof(theme) == "string" and Theme.Presets[theme] then
        Theme.Current = Theme.Merge(Theme.Presets.Dark, Theme.Presets[theme])
    elseif typeof(theme) == "table" then
        Theme.Current = Theme.Merge(Theme.Current, theme)
    end
    return Theme.Current
end

function Theme.Get()
    return Theme.Current
end

return Theme
