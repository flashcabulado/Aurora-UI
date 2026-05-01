local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AuroraUI = {
	Version = "5.2.0",
	Theme = {},
	Windows = {},
	Flags = {},
	Controls = {},
	_themeListeners = {},
}

local Themes = {
	Dark = {
		Background   = Color3.fromRGB(18, 20, 26),
		Surface      = Color3.fromRGB(26, 29, 38),
		SurfaceSoft  = Color3.fromRGB(34, 38, 50),
		Sidebar      = Color3.fromRGB(16, 18, 24),
		Card         = Color3.fromRGB(32, 36, 48),
		CardHover    = Color3.fromRGB(42, 47, 62),
		Accent       = Color3.fromRGB(120, 86, 248),
		AccentSecond = Color3.fromRGB(60, 185, 255),
		Text         = Color3.fromRGB(238, 242, 255),
		Muted        = Color3.fromRGB(130, 142, 170),
		Minimize     = Color3.fromRGB(255, 190, 60),
		Close        = Color3.fromRGB(255, 85, 95),
		Success      = Color3.fromRGB(55, 210, 135),
		Warning      = Color3.fromRGB(255, 190, 60),
		Error        = Color3.fromRGB(255, 85, 95),
		ScrollBar    = Color3.fromRGB(70, 80, 110),
		Overlay      = Color3.fromRGB(0, 0, 0),
	},
	Light = {
		Background   = Color3.fromRGB(238, 241, 248),
		Surface      = Color3.fromRGB(255, 255, 255),
		SurfaceSoft  = Color3.fromRGB(225, 229, 242),
		Sidebar      = Color3.fromRGB(228, 232, 244),
		Card         = Color3.fromRGB(246, 248, 254),
		CardHover    = Color3.fromRGB(215, 220, 238),
		Accent       = Color3.fromRGB(95, 60, 225),
		AccentSecond = Color3.fromRGB(25, 155, 240),
		Text         = Color3.fromRGB(20, 22, 32),
		Muted        = Color3.fromRGB(95, 106, 138),
		Minimize     = Color3.fromRGB(240, 170, 30),
		Close        = Color3.fromRGB(228, 55, 70),
		Success      = Color3.fromRGB(28, 178, 108),
		Warning      = Color3.fromRGB(240, 170, 30),
		Error        = Color3.fromRGB(228, 55, 70),
		ScrollBar    = Color3.fromRGB(155, 165, 195),
		Overlay      = Color3.fromRGB(0, 0, 0),
	},
	Midnight = {
		Background   = Color3.fromRGB(6, 8, 18),
		Surface      = Color3.fromRGB(12, 15, 28),
		SurfaceSoft  = Color3.fromRGB(18, 22, 40),
		Sidebar      = Color3.fromRGB(8, 11, 22),
		Card         = Color3.fromRGB(18, 22, 40),
		CardHover    = Color3.fromRGB(26, 32, 55),
		Accent       = Color3.fromRGB(75, 115, 255),
		AccentSecond = Color3.fromRGB(155, 75, 255),
		Text         = Color3.fromRGB(215, 224, 255),
		Muted        = Color3.fromRGB(92, 108, 158),
		Minimize     = Color3.fromRGB(255, 200, 60),
		Close        = Color3.fromRGB(255, 75, 105),
		Success      = Color3.fromRGB(45, 195, 135),
		Warning      = Color3.fromRGB(255, 200, 60),
		Error        = Color3.fromRGB(255, 75, 105),
		ScrollBar    = Color3.fromRGB(55, 70, 125),
		Overlay      = Color3.fromRGB(0, 0, 0),
	},
	Sakura = {
		Background   = Color3.fromRGB(28, 16, 22),
		Surface      = Color3.fromRGB(42, 24, 32),
		SurfaceSoft  = Color3.fromRGB(55, 32, 44),
		Sidebar      = Color3.fromRGB(22, 14, 18),
		Card         = Color3.fromRGB(50, 28, 40),
		CardHover    = Color3.fromRGB(65, 38, 52),
		Accent       = Color3.fromRGB(238, 95, 145),
		AccentSecond = Color3.fromRGB(195, 135, 198),
		Text         = Color3.fromRGB(255, 228, 238),
		Muted        = Color3.fromRGB(175, 125, 150),
		Minimize     = Color3.fromRGB(255, 200, 80),
		Close        = Color3.fromRGB(255, 78, 98),
		Success      = Color3.fromRGB(95, 218, 158),
		Warning      = Color3.fromRGB(255, 200, 80),
		Error        = Color3.fromRGB(255, 78, 98),
		ScrollBar    = Color3.fromRGB(135, 75, 105),
		Overlay      = Color3.fromRGB(0, 0, 0),
	},
	Forest = {
		Background   = Color3.fromRGB(12, 20, 16),
		Surface      = Color3.fromRGB(18, 30, 22),
		SurfaceSoft  = Color3.fromRGB(25, 42, 30),
		Sidebar      = Color3.fromRGB(10, 18, 13),
		Card         = Color3.fromRGB(25, 42, 30),
		CardHover    = Color3.fromRGB(33, 56, 40),
		Accent       = Color3.fromRGB(55, 198, 115),
		AccentSecond = Color3.fromRGB(115, 218, 75),
		Text         = Color3.fromRGB(208, 238, 218),
		Muted        = Color3.fromRGB(105, 155, 125),
		Minimize     = Color3.fromRGB(238, 198, 58),
		Close        = Color3.fromRGB(218, 68, 78),
		Success      = Color3.fromRGB(55, 198, 115),
		Warning      = Color3.fromRGB(238, 198, 58),
		Error        = Color3.fromRGB(218, 68, 78),
		ScrollBar    = Color3.fromRGB(55, 105, 75),
		Overlay      = Color3.fromRGB(0, 0, 0),
	},
}

AuroraUI.Themes = Themes

local function applyTheme(name)
	local t = Themes[name] or Themes.Dark
	for k, v in pairs(t) do
		AuroraUI.Theme[k] = v
	end
	for _, fn in ipairs(AuroraUI._themeListeners) do
		pcall(fn, AuroraUI.Theme)
	end
end

applyTheme("Dark")

local function onThemeChange(fn)
	table.insert(AuroraUI._themeListeners, fn)
end

local function hexToColor3(value)
	if typeof(value) == "Color3" then return value end
	if typeof(value) ~= "string" then return value end
	local h = value:gsub("#", "")
	if #h ~= 6 then return value end
	local r = tonumber(h:sub(1, 2), 16)
	local g = tonumber(h:sub(3, 4), 16)
	local b = tonumber(h:sub(5, 6), 16)
	if not r or not g or not b then return value end
	return Color3.fromRGB(r, g, b)
end

local function merge(a, b)
	local c = {}
	for k, v in pairs(a or {}) do c[k] = v end
	for k, v in pairs(b or {}) do c[k] = v end
	return c
end

local function new(className, props)
	local obj = Instance.new(className)
	for k, v in pairs(props or {}) do obj[k] = v end
	return obj
end

local function tween(obj, time, props, style, direction)
	local info = TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local function corner(parent, radius)
	return new("UICorner", {Parent = parent, CornerRadius = UDim.new(0, radius or 12)})
end

local function pad(parent, l, r, t, b)
	return new("UIPadding", {
		Parent        = parent,
		PaddingLeft   = UDim.new(0, l or 0),
		PaddingRight  = UDim.new(0, r or l or 0),
		PaddingTop    = UDim.new(0, t or l or 0),
		PaddingBottom = UDim.new(0, b or t or l or 0),
	})
end

local function list(parent, gap, fillDir, hAlign, vAlign)
	return new("UIListLayout", {
		Parent            = parent,
		SortOrder         = Enum.SortOrder.LayoutOrder,
		FillDirection     = fillDir or Enum.FillDirection.Vertical,
		HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Center,
		VerticalAlignment = vAlign or Enum.VerticalAlignment.Top,
		Padding           = UDim.new(0, gap or 8),
	})
end

local function gradient(parent, a, b, rot)
	return new("UIGradient", {
		Parent   = parent,
		Rotation = rot or 0,
		Color    = ColorSequence.new(a or AuroraUI.Theme.Accent, b or AuroraUI.Theme.AccentSecond),
	})
end

local function lbl(parent, text, size, color, font, xAlign)
	local s = size or 15
	return new("TextLabel", {
		Parent                 = parent,
		BackgroundTransparency = 1,
		Text                   = text or "",
		Font                   = font or Enum.Font.GothamMedium,
		TextSize               = s,
		TextColor3             = color or AuroraUI.Theme.Text,
		TextXAlignment         = xAlign or Enum.TextXAlignment.Left,
		TextYAlignment         = Enum.TextYAlignment.Center,
		TextWrapped            = true,
		Size                   = UDim2.new(1, 0, 0, s + 4),
	})
end

local function btn(parent, text)
	return new("TextButton", {
		Parent           = parent,
		AutoButtonColor  = false,
		BorderSizePixel  = 0,
		BackgroundColor3 = AuroraUI.Theme.Card,
		Text             = text or "",
		Font             = Enum.Font.GothamMedium,
		TextSize         = 15,
		TextColor3       = AuroraUI.Theme.Text,
	})
end

local function mkIcon(parent, icon, sz)
	local isId = typeof(icon) == "number"
	local isStr = typeof(icon) == "string"
	if isId then icon = "rbxassetid://" .. tostring(icon) end
	if not isId and not (isStr and icon:find("rbxassetid://")) then return nil end
	return new("ImageLabel", {
		Parent                 = parent,
		BackgroundTransparency = 1,
		Image                  = icon,
		ImageColor3            = AuroraUI.Theme.Muted,
		Size                   = UDim2.fromOffset(sz or 16, sz or 16),
		ScaleType              = Enum.ScaleType.Fit,
	})
end

local function hoverFx(obj, normal, over)
	obj.MouseEnter:Connect(function()
		if obj:GetAttribute("Selected") then return end
		tween(obj, 0.11, {BackgroundColor3 = over or AuroraUI.Theme.CardHover})
	end)
	obj.MouseLeave:Connect(function()
		if obj:GetAttribute("Selected") then return end
		tween(obj, 0.11, {BackgroundColor3 = normal or AuroraUI.Theme.Card})
	end)
end

local function makeRow(parent)
	local row = btn(parent, "")
	row.Size             = UDim2.new(1, 0, 0, 66)
	row.BackgroundColor3 = AuroraUI.Theme.Card
	corner(row, 12)

	local inner = new("Frame", {
		Parent                 = row,
		BackgroundTransparency = 1,
		Size                   = UDim2.new(1, 0, 1, 0),
	})
	pad(inner, 14, 14, 0, 0)

	local leftBlock = new("Frame", {
		Parent                 = inner,
		BackgroundTransparency = 1,
		Size                   = UDim2.new(1, -122, 1, 0),
	})
	new("UIListLayout", {
		Parent              = leftBlock,
		SortOrder           = Enum.SortOrder.LayoutOrder,
		FillDirection       = Enum.FillDirection.Vertical,
		VerticalAlignment   = Enum.VerticalAlignment.Center,
		Padding             = UDim.new(0, 3),
	})

	local right = new("Frame", {
		Parent                 = inner,
		BackgroundTransparency = 1,
		AnchorPoint            = Vector2.new(1, 0.5),
		Position               = UDim2.new(1, 0, 0.5, 0),
		Size                   = UDim2.fromOffset(112, 44),
	})

	return row, leftBlock, right
end

local function rowTitle(leftBlock, title, desc, iconId)
	local iconOff = 0
	if iconId then
		local ic = mkIcon(leftBlock, iconId, 15)
		if ic then
			ic.AnchorPoint = Vector2.new(0, 0.5)
			iconOff = 20
		end
	end
	local t = lbl(leftBlock, title, 15, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	t.Size = UDim2.new(1, -iconOff, 0, 19)
	if desc and desc ~= "" then
		local d = lbl(leftBlock, desc, 12, AuroraUI.Theme.Muted)
		d.Size = UDim2.new(1, 0, 0, 15)
	end
	return t
end

local Window  = {}; Window.__index  = Window
local Tab     = {}; Tab.__index     = Tab
local Section = {}; Section.__index = Section

function AuroraUI:SetTheme(nameOrTable)
	if typeof(nameOrTable) == "string" then
		applyTheme(nameOrTable)
	elseif typeof(nameOrTable) == "table" then
		for k, v in pairs(nameOrTable) do
			if self.Theme[k] ~= nil then
				self.Theme[k] = hexToColor3(v)
			end
		end
		for _, fn in ipairs(self._themeListeners) do pcall(fn, self.Theme) end
	end
end

function AuroraUI:SetFlag(flag, value)
	if not flag then return end
	self.Flags[flag] = value
	local ctrl = self.Controls[flag]
	if ctrl and ctrl.Set then ctrl:Set(value, true) end
end

function AuroraUI:GetFlag(flag) return self.Flags[flag] end

function AuroraUI:RegisterControl(flag, ctrl)
	if flag then self.Controls[flag] = ctrl end
end

function AuroraUI:SaveConfig(name)
	name = name or "AuroraUI_Config"
	local data = HttpService:JSONEncode(self.Flags)
	if writefile then writefile(name .. ".json", data) return true, data end
	self.LastConfig = data
	return false, data
end

function AuroraUI:LoadConfig(name)
	name = name or "AuroraUI_Config"
	local data
	if readfile and isfile and isfile(name .. ".json") then
		data = readfile(name .. ".json")
	else
		data = self.LastConfig
	end
	if not data then return false end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(data) end)
	if not ok or typeof(decoded) ~= "table" then return false end
	for flag, value in pairs(decoded) do self:SetFlag(flag, value) end
	return true
end

function AuroraUI:ListConfigs()
	if not listfiles then return {} end
	local all = listfiles("") or {}
	local configs = {}
	for _, f in ipairs(all) do
		if f:match("%.json$") then
			local name = f:gsub("%.json$", "")
			table.insert(configs, name)
		end
	end
	return configs
end

function AuroraUI:Notify(o)
	o = merge({Title = "AuroraUI", Content = "Notificacao", Duration = 3}, o)
	local gui = self.Gui or new("ScreenGui", {
		Parent           = PlayerGui,
		Name             = "AuroraUI",
		ResetOnSpawn     = false,
		IgnoreGuiInset   = true,
		ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
	})
	self.Gui = gui

	local holder = gui:FindFirstChild("Notifications")
	if not holder then
		holder = new("Frame", {
			Parent                 = gui,
			Name                   = "Notifications",
			BackgroundTransparency = 1,
			AnchorPoint            = Vector2.new(1, 0),
			Position               = UDim2.new(1, -16, 0, 16),
			Size                   = UDim2.fromOffset(310, 560),
		})
		list(holder, 10)
	end

	local card = new("Frame", {
		Parent           = holder,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel  = 0,
		Size             = UDim2.new(1, 0, 0, 76),
		ClipsDescendants = true,
	})
	corner(card, 13)
	pad(card, 14, 14, 10, 10)

	local sc = new("UIScale", {Parent = card, Scale = 0.88})

	local tl = lbl(card, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamBold)
	tl.Size     = UDim2.new(1, 0, 0, 18)
	tl.Position = UDim2.fromOffset(0, 0)

	local bl = lbl(card, o.Content, 12, AuroraUI.Theme.Muted)
	bl.Size     = UDim2.new(1, 0, 0, 30)
	bl.Position = UDim2.fromOffset(0, 22)

	local bar = new("Frame", {
		Parent           = card,
		BorderSizePixel  = 0,
		BackgroundColor3 = AuroraUI.Theme.Accent,
		AnchorPoint      = Vector2.new(0, 1),
		Position         = UDim2.new(0, 0, 1, 0),
		Size             = UDim2.new(1, 0, 0, 3),
	})
	corner(bar, 3)
	gradient(bar, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)

	tween(sc, 0.16, {Scale = 1})
	tween(bar, o.Duration, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)

	task.delay(o.Duration, function()
		if card.Parent then
			tween(sc, 0.13, {Scale = 0.86})
			local out = tween(card, 0.13, {BackgroundTransparency = 1})
			out.Completed:Wait()
			card:Destroy()
		end
	end)
end

function Window:Show()
	self.Visible = true
	self.Main.Visible = true
	self.OpenButton.Visible = false
	tween(self.Scale, 0.2, {Scale = self.TargetScale})
	tween(self.Main, 0.2, {GroupTransparency = 0})
end

function Window:Hide()
	self.Visible = false
	tween(self.Scale, 0.13, {Scale = self.TargetScale * 0.96})
	local t = tween(self.Main, 0.13, {GroupTransparency = 1})
	t.Completed:Connect(function()
		if not self.Visible then self.Main.Visible = false end
	end)
end

function Window:Minimize()
	self:Hide()
	task.delay(0.13, function()
		self.OpenButton.Visible = true
		tween(self.OpenScale, 0.18, {Scale = 1})
	end)
end

function Window:AskClose()
	if self.CloseDialog and self.CloseDialog.Parent then
		self.CloseDialog.Visible = true
		return
	end

	local overlay = new("Frame", {
		Parent                 = self.Gui,
		BackgroundColor3       = AuroraUI.Theme.Overlay,
		BackgroundTransparency = 0.5,
		BorderSizePixel        = 0,
		Size                   = UDim2.fromScale(1, 1),
		ZIndex                 = 18,
	})

	local dialog = new("Frame", {
		Parent           = self.Gui,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel  = 0,
		AnchorPoint      = Vector2.new(0.5, 0.5),
		Position         = UDim2.fromScale(0.5, 0.5),
		Size             = UDim2.fromOffset(300, 158),
		ZIndex           = 20,
	})
	self.CloseDialog = dialog
	self.CloseOverlay = overlay
	corner(dialog, 18)
	pad(dialog, 20, 20, 20, 20)

	local sc = new("UIScale", {Parent = dialog, Scale = 0.86})

	local dlgT = lbl(dialog, "Fechar menu?", 17, AuroraUI.Theme.Text, Enum.Font.GothamBold)
	dlgT.Size     = UDim2.new(1, 0, 0, 22)
	dlgT.Position = UDim2.fromOffset(0, 0)

	local dlgD = lbl(dialog, "Deseja esconder a interface agora?", 13, AuroraUI.Theme.Muted)
	dlgD.Position = UDim2.fromOffset(0, 28)
	dlgD.Size     = UDim2.new(1, 0, 0, 36)

	local noBtn = btn(dialog, "Cancelar")
	noBtn.Position       = UDim2.new(0, 0, 1, -40)
	noBtn.Size           = UDim2.new(0.48, 0, 0, 38)
	noBtn.BackgroundColor3 = AuroraUI.Theme.Card
	noBtn.TextSize       = 14
	noBtn.ZIndex         = 21
	corner(noBtn, 12)

	local yesBtn = btn(dialog, "Fechar")
	yesBtn.Position       = UDim2.new(0.52, 0, 1, -40)
	yesBtn.Size           = UDim2.new(0.48, 0, 0, 38)
	yesBtn.BackgroundColor3 = AuroraUI.Theme.Close
	yesBtn.TextColor3     = Color3.fromRGB(255, 255, 255)
	yesBtn.TextSize       = 14
	yesBtn.ZIndex         = 21
	corner(yesBtn, 12)

	tween(sc, 0.16, {Scale = 1})

	local function closeDialog()
		tween(sc, 0.12, {Scale = 0.88})
		task.delay(0.12, function()
			if dialog.Parent then dialog:Destroy() end
			if overlay.Parent then overlay:Destroy() end
			self.CloseDialog  = nil
			self.CloseOverlay = nil
		end)
	end

	overlay.MouseButton1Click:Connect(closeDialog)
	noBtn.MouseButton1Click:Connect(closeDialog)
	yesBtn.MouseButton1Click:Connect(function()
		closeDialog()
		task.delay(0.1, function() self:Hide() end)
	end)
end

function Window:Destroy()
	if self.Gui then self.Gui:Destroy() end
end

function Window:SelectTab(tab)
	for _, item in ipairs(self.Tabs) do
		local sel = item == tab
		item.Button:SetAttribute("Selected", sel)
		item.Page.Visible = sel
		if sel then
			tween(item.Button, 0.16, {BackgroundColor3 = AuroraUI.Theme.Accent})
			item.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			if item.IconImg then item.IconImg.ImageColor3 = Color3.fromRGB(255, 255, 255) end
			if item.Dot then item.Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255) end
		else
			tween(item.Button, 0.16, {BackgroundColor3 = AuroraUI.Theme.Card})
			item.Button.TextColor3 = AuroraUI.Theme.Text
			if item.IconImg then item.IconImg.ImageColor3 = AuroraUI.Theme.Muted end
			if item.Dot then item.Dot.BackgroundColor3 = AuroraUI.Theme.Muted end
		end
	end
	self.ActiveTab = tab
end

function Window:CreateTab(o)
	o = merge({Name = "Tab", Icon = nil, Group = "General"}, o)
	local tab = setmetatable({Window = self, Options = o, Sections = {}}, Tab)

	local group = self.Groups[o.Group]
	if not group then
		group = new("Frame", {
			Parent                 = self.Sidebar,
			BackgroundTransparency = 1,
			Size                   = UDim2.new(1, 0, 0, 0),
			AutomaticSize          = Enum.AutomaticSize.Y,
		})
		list(group, 5)
		local gLbl = lbl(group, string.upper(o.Group), 10, AuroraUI.Theme.Muted, Enum.Font.GothamBold)
		gLbl.Size = UDim2.new(1, 0, 0, 13)
		self.Groups[o.Group] = group

		onThemeChange(function(th)
			gLbl.TextColor3 = th.Muted
		end)
	end

	local b = btn(group, "")
	b.Size             = UDim2.new(1, 0, 0, 40)
	b.BackgroundColor3 = AuroraUI.Theme.Card
	b.Text             = ""
	corner(b, 10)

	local bInner = new("Frame", {
		Parent                 = b,
		BackgroundTransparency = 1,
		Size                   = UDim2.new(1, 0, 1, 0),
	})
	pad(bInner, 10, 10, 0, 0)

	local bList = new("UIListLayout", {
		Parent              = bInner,
		FillDirection       = Enum.FillDirection.Horizontal,
		VerticalAlignment   = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder           = Enum.SortOrder.LayoutOrder,
		Padding             = UDim.new(0, 7),
	})

	local dot = new("Frame", {
		Parent           = bInner,
		BackgroundColor3 = AuroraUI.Theme.Muted,
		BorderSizePixel  = 0,
		Size             = UDim2.fromOffset(5, 5),
		LayoutOrder      = 0,
	})
	corner(dot, 5)

	local iconImg = mkIcon(bInner, o.Icon, 14)
	if iconImg then
		iconImg.LayoutOrder = 1
		iconImg.ImageColor3 = AuroraUI.Theme.Muted
	end

	local bLbl = lbl(bInner, o.Name, 13, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	bLbl.Size        = UDim2.new(1, 0, 0, 17)
	bLbl.LayoutOrder = 2

	hoverFx(b, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)

	local page = new("ScrollingFrame", {
		Parent                 = self.Pages,
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
		Size                   = UDim2.new(1, 0, 1, 0),
		Visible                = false,
		CanvasSize             = UDim2.new(),
		AutomaticCanvasSize    = Enum.AutomaticSize.Y,
		ScrollBarThickness     = 3,
		ScrollBarImageColor3   = AuroraUI.Theme.ScrollBar,
		ScrollingDirection     = Enum.ScrollingDirection.Y,
		ElasticBehavior        = Enum.ElasticBehavior.Never,
	})
	pad(page, 2, 6, 4, 10)
	list(page, 9)

	tab.Button   = b
	tab.Page     = page
	tab.IconImg  = iconImg
	tab.Dot      = dot

	b.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
	table.insert(self.Tabs, tab)
	if not self.ActiveTab then self:SelectTab(tab) end

	onThemeChange(function(th)
		if not b:GetAttribute("Selected") then
			b.BackgroundColor3  = th.Card
			b.TextColor3        = th.Text
			dot.BackgroundColor3 = th.Muted
			if iconImg then iconImg.ImageColor3 = th.Muted end
		else
			b.BackgroundColor3  = th.Accent
			if iconImg then iconImg.ImageColor3 = Color3.fromRGB(255, 255, 255) end
		end
		page.ScrollBarImageColor3 = th.ScrollBar
	end)

	return tab
end

function Tab:CreateSection(o)
	o = merge({Title = "Section", Description = "", Collapsible = true, DefaultOpen = true}, o)
	local section = setmetatable({Tab = self, Options = o, Open = o.DefaultOpen ~= false}, Section)

	local outer = new("Frame", {
		Parent           = self.Page,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel  = 0,
		Size             = UDim2.new(1, 0, 0, 0),
		AutomaticSize    = Enum.AutomaticSize.Y,
		ClipsDescendants = true,
	})
	corner(outer, 14)

	local hasDesc = o.Description ~= "" and o.Description ~= nil
	local headerH = hasDesc and 60 or 46

	local header = btn(outer, "")
	header.BackgroundTransparency = 1
	header.Size  = UDim2.new(1, 0, 0, headerH)
	header.Text  = ""
	header.ZIndex = 2
	pad(header, 14, 14, 10, 10)

	local hInner = new("Frame", {
		Parent                 = header,
		BackgroundTransparency = 1,
		Size                   = UDim2.new(1, 0, 1, 0),
	})
	new("UIListLayout", {
		Parent            = hInner,
		SortOrder         = Enum.SortOrder.LayoutOrder,
		FillDirection     = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding           = UDim.new(0, 2),
	})

	local secTitle = lbl(hInner, o.Title, 15, AuroraUI.Theme.Text, Enum.Font.GothamBold)
	secTitle.Size = UDim2.new(1, -30, 0, 19)

	if hasDesc then
		local secDesc = lbl(hInner, o.Description, 12, AuroraUI.Theme.Muted)
		secDesc.Size = UDim2.new(1, -30, 0, 15)
		onThemeChange(function(th) secDesc.TextColor3 = th.Muted end)
	end

	local arrowLbl = lbl(header, "v", 13, AuroraUI.Theme.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	arrowLbl.AnchorPoint = Vector2.new(1, 0.5)
	arrowLbl.Position    = UDim2.new(1, -2, 0.5, 0)
	arrowLbl.Size        = UDim2.fromOffset(22, 22)
	if not section.Open then arrowLbl.Text = ">" end

	local arrowSc = new("UIScale", {Parent = arrowLbl, Scale = 1})

	local divLine = new("Frame", {
		Parent           = outer,
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
		BorderSizePixel  = 0,
		Position         = UDim2.new(0, 14, 0, headerH),
		Size             = UDim2.new(1, -28, 0, 1),
		Visible          = section.Open,
	})

	local spacerTop = new("Frame", {
		Parent                 = outer,
		BackgroundTransparency = 1,
		Size                   = UDim2.new(1, 0, 0, 6),
		Position               = UDim2.new(0, 0, 0, headerH + 1),
		Visible                = section.Open,
	})

	local container = new("Frame", {
		Parent                 = outer,
		BackgroundTransparency = 1,
		Position               = UDim2.new(0, 0, 0, headerH + 7),
		Size                   = UDim2.new(1, 0, 0, 0),
		AutomaticSize          = Enum.AutomaticSize.Y,
		Visible                = section.Open,
	})
	pad(container, 10, 10, 0, 0)
	list(container, 7)

	local spacerBot = new("Frame", {
		Parent                 = outer,
		BackgroundTransparency = 1,
		Size                   = UDim2.new(1, 0, 0, 0),
		AutomaticSize          = Enum.AutomaticSize.Y,
	})

	section.Outer     = outer
	section.Container = container

	onThemeChange(function(th)
		outer.BackgroundColor3  = th.Surface
		divLine.BackgroundColor3 = th.SurfaceSoft
		secTitle.TextColor3     = th.Text
		arrowLbl.TextColor3     = th.Muted
	end)

	header.MouseButton1Click:Connect(function()
		if o.Collapsible == false then return end
		section.Open = not section.Open

		tween(arrowSc, 0.08, {Scale = 0.7})
		task.delay(0.08, function()
			if arrowSc.Parent then
				arrowLbl.Text = section.Open and "v" or ">"
				tween(arrowSc, 0.12, {Scale = 1})
			end
		end)

		divLine.Visible   = section.Open
		spacerTop.Visible = section.Open

		if section.Open then
			container.Visible = true
		else
			task.delay(0.08, function()
				if not section.Open then container.Visible = false end
			end)
		end
	end)

	table.insert(self.Sections, section)
	return section
end

function Section:CreateButton(o)
	o = merge({Title = "Button", Description = "", Action = "Executar", Icon = nil, Callback = function() end}, o)

	local row, leftBlock, right = makeRow(self.Container)
	hoverFx(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
	rowTitle(leftBlock, o.Title, o.Description, o.Icon)

	local actLbl = lbl(right, o.Action, 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	actLbl.Size        = UDim2.new(1, 0, 1, 0)
	actLbl.AnchorPoint = Vector2.new(1, 0.5)
	actLbl.Position    = UDim2.new(1, 0, 0.5, 0)

	onThemeChange(function(th)
		row.BackgroundColor3 = th.Card
		actLbl.TextColor3    = th.Accent
	end)

	row.MouseButton1Click:Connect(function()
		tween(row, 0.06, {Size = UDim2.new(1, -4, 0, 64)})
		task.delay(0.06, function()
			if row.Parent then tween(row, 0.1, {Size = UDim2.new(1, 0, 0, 66)}) end
		end)
		task.spawn(o.Callback)
	end)

	return row
end

function Section:CreateToggle(o)
	o = merge({Title = "Toggle", Description = "", Default = false, Icon = nil, Flag = nil, Callback = function() end}, o)
	local initState = false
	if AuroraUI.Flags[o.Flag] ~= nil then
		initState = AuroraUI.Flags[o.Flag]
	elseif o.Default == true then
		initState = true
	end
	local state = initState

	local row, leftBlock, right = makeRow(self.Container)
	hoverFx(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
	rowTitle(leftBlock, o.Title, o.Description, o.Icon)

	local track = new("Frame", {
		Parent           = right,
		BorderSizePixel  = 0,
		AnchorPoint      = Vector2.new(1, 0.5),
		Position         = UDim2.new(1, 0, 0.5, 0),
		Size             = UDim2.fromOffset(48, 26),
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
	})
	corner(track, 26)
	if state then track.BackgroundColor3 = AuroraUI.Theme.Accent end

	local thumbPos = state and UDim2.fromOffset(26, 4) or UDim2.fromOffset(4, 4)
	local thumb = new("Frame", {
		Parent           = track,
		BorderSizePixel  = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size             = UDim2.fromOffset(18, 18),
		Position         = thumbPos,
	})
	corner(thumb, 18)

	local control = {}
	function control:Set(v, silent)
		state = v == true
		if o.Flag then AuroraUI.Flags[o.Flag] = state end
		local bg = state and AuroraUI.Theme.Accent or AuroraUI.Theme.SurfaceSoft
		local pos = state and UDim2.fromOffset(26, 4) or UDim2.fromOffset(4, 4)
		tween(track, 0.15, {BackgroundColor3 = bg})
		tween(thumb, 0.15, {Position = pos})
		if not silent then task.spawn(o.Callback, state) end
	end
	function control:Get() return state end
	control.Instance = row

	if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = state end

	onThemeChange(function(th)
		row.BackgroundColor3 = th.Card
		if not state then track.BackgroundColor3 = th.SurfaceSoft
		else track.BackgroundColor3 = th.Accent end
	end)

	row.MouseButton1Click:Connect(function() control:Set(not state) end)
	return control
end

function Section:CreateSlider(o)
	o = merge({Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Increment = 1, Icon = nil, Flag = nil, Callback = function() end}, o)
	local value = tonumber(AuroraUI.Flags[o.Flag]) or math.clamp(o.Default, o.Min, o.Max)

	local row = new("Frame", {
		Parent           = self.Container,
		BackgroundColor3 = AuroraUI.Theme.Card,
		BorderSizePixel  = 0,
		Size             = UDim2.new(1, 0, 0, 84),
	})
	corner(row, 12)
	pad(row, 14, 14, 10, 14)

	local topRow = new("Frame", {
		Parent                 = row,
		BackgroundTransparency = 1,
		Size                   = UDim2.new(1, 0, 0, 40),
	})

	local leftTop = new("Frame", {
		Parent                 = topRow,
		BackgroundTransparency = 1,
		Size                   = UDim2.new(1, -58, 1, 0),
	})
	new("UIListLayout", {
		Parent            = leftTop,
		SortOrder         = Enum.SortOrder.LayoutOrder,
		FillDirection     = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding           = UDim.new(0, 3),
	})

	local iconOff = 0
	if o.Icon then
		local ic = mkIcon(leftTop, o.Icon, 14)
		if ic then iconOff = 20 end
	end

	local sTitle = lbl(leftTop, o.Title, 15, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	sTitle.Size = UDim2.new(1, -iconOff, 0, 19)

	if o.Description and o.Description ~= "" then
		local sDesc = lbl(leftTop, o.Description, 12, AuroraUI.Theme.Muted)
		sDesc.Size = UDim2.new(1, 0, 0, 15)
		onThemeChange(function(th) sDesc.TextColor3 = th.Muted end)
	end

	local valLbl = lbl(topRow, tostring(value), 14, AuroraUI.Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	valLbl.AnchorPoint = Vector2.new(1, 0.5)
	valLbl.Position    = UDim2.new(1, 0, 0.5, 0)
	valLbl.Size        = UDim2.fromOffset(52, 20)

	local trackWrap = new("Frame", {
		Parent                 = row,
		BackgroundTransparency = 1,
		AnchorPoint            = Vector2.new(0, 1),
		Position               = UDim2.new(0, 0, 1, 0),
		Size                   = UDim2.new(1, 0, 0, 18),
	})

	local track = new("Frame", {
		Parent           = trackWrap,
		BorderSizePixel  = 0,
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
		AnchorPoint      = Vector2.new(0, 0.5),
		Position         = UDim2.new(0, 0, 0.5, 0),
		Size             = UDim2.new(1, 0, 0, 5),
	})
	corner(track, 5)

	local range = math.max(o.Max - o.Min, 1)
	local alpha0 = (value - o.Min) / range

	local fill = new("Frame", {
		Parent           = track,
		BorderSizePixel  = 0,
		BackgroundColor3 = AuroraUI.Theme.Accent,
		Size             = UDim2.new(alpha0, 0, 1, 0),
	})
	corner(fill, 5)
	gradient(fill, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)

	local thumb = new("Frame", {
		Parent           = track,
		BorderSizePixel  = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AnchorPoint      = Vector2.new(0.5, 0.5),
		Position         = UDim2.new(alpha0, 0, 0.5, 0),
		Size             = UDim2.fromOffset(14, 14),
		ZIndex           = 2,
	})
	corner(thumb, 14)

	local thumbDot = new("Frame", {
		Parent           = thumb,
		BorderSizePixel  = 0,
		BackgroundColor3 = AuroraUI.Theme.Accent,
		AnchorPoint      = Vector2.new(0.5, 0.5),
		Position         = UDim2.fromScale(0.5, 0.5),
		Size             = UDim2.fromOffset(6, 6),
	})
	corner(thumbDot, 6)

	local control = {}
	function control:Set(v, silent)
		value = math.clamp(tonumber(v) or o.Min, o.Min, o.Max)
		value = math.floor(value / o.Increment + 0.5) * o.Increment
		local a = (value - o.Min) / range
		valLbl.Text = tostring(value)
		if o.Flag then AuroraUI.Flags[o.Flag] = value end
		tween(fill,  0.07, {Size     = UDim2.new(a, 0, 1, 0)})
		tween(thumb, 0.07, {Position = UDim2.new(a, 0, 0.5, 0)})
		if not silent then task.spawn(o.Callback, value) end
	end
	function control:Get() return value end
	control.Instance = row

	if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = value end

	onThemeChange(function(th)
		row.BackgroundColor3   = th.Card
		track.BackgroundColor3 = th.SurfaceSoft
		fill.BackgroundColor3  = th.Accent
		thumbDot.BackgroundColor3 = th.Accent
		valLbl.TextColor3      = th.Accent
		sTitle.TextColor3      = th.Text
	end)

	local dragging = false
	local function setFromX(x)
		local a2 = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		control:Set(o.Min + (o.Max - o.Min) * a2)
	end

	track.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true; setFromX(inp.Position.X)
		end
	end)
	thumb.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			setFromX(inp.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	return control
end

function Section:CreateDropdown(o)
	o = merge({Title = "Dropdown", Description = "", Options = {}, Default = nil, Icon = nil, Flag = nil, Callback = function() end}, o)
	local selected = AuroraUI.Flags[o.Flag] or o.Default or o.Options[1] or "Nenhum"

	local row, leftBlock, right = makeRow(self.Container)
	hoverFx(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
	rowTitle(leftBlock, o.Title, o.Description, o.Icon)

	local valLbl = lbl(right, tostring(selected), 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	valLbl.AnchorPoint = Vector2.new(1, 0.5)
	valLbl.Position    = UDim2.new(1, 0, 0.5, 0)
	valLbl.Size        = UDim2.new(1, 0, 0, 18)

	local menuItemH = 36
	local menuTotalH = #o.Options * (menuItemH + 5) + 14

	local menu = new("Frame", {
		Parent           = self.Container,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel  = 0,
		Visible          = false,
		ClipsDescendants = true,
		Size             = UDim2.new(1, 0, 0, 0),
	})
	corner(menu, 12)
	pad(menu, 8, 8, 7, 7)
	list(menu, 5)

	local control = {}
	function control:Set(v, silent)
		selected = v
		valLbl.Text = tostring(v)
		if o.Flag then AuroraUI.Flags[o.Flag] = selected end
		if not silent then task.spawn(o.Callback, selected) end
	end
	function control:Get() return selected end
	control.Instance = row

	if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = selected end

	for _, opt in ipairs(o.Options) do
		local ob = btn(menu, tostring(opt))
		ob.Size             = UDim2.new(1, 0, 0, menuItemH)
		ob.BackgroundColor3 = AuroraUI.Theme.Card
		ob.TextSize         = 14
		ob.TextXAlignment   = Enum.TextXAlignment.Left
		pad(ob, 12)
		corner(ob, 9)
		hoverFx(ob, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
		ob.MouseButton1Click:Connect(function()
			control:Set(opt)
			tween(menu, 0.14, {Size = UDim2.new(1, 0, 0, 0)})
			task.delay(0.14, function() menu.Visible = false end)
		end)
		onThemeChange(function(th)
			if not ob:GetAttribute("Selected") then ob.BackgroundColor3 = th.Card end
			ob.TextColor3 = th.Text
		end)
	end

	local isOpen = false
	row.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			menu.Visible = true
			tween(menu, 0.16, {Size = UDim2.new(1, 0, 0, menuTotalH)})
		else
			tween(menu, 0.14, {Size = UDim2.new(1, 0, 0, 0)})
			task.delay(0.14, function() menu.Visible = false end)
		end
	end)

	onThemeChange(function(th)
		row.BackgroundColor3  = th.Card
		menu.BackgroundColor3 = th.Surface
		valLbl.TextColor3     = th.Accent
	end)

	return control
end

function Section:CreateConfigDropdown(o)
	o = merge({Title = "Carregar Config", Description = "Selecione um arquivo salvo", Flag = nil, Callback = function() end}, o)

	local configs = AuroraUI:ListConfigs()
	if #configs == 0 then configs = {"(nenhuma)"} end

	local selected = configs[1]

	local row, leftBlock, right = makeRow(self.Container)
	hoverFx(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
	rowTitle(leftBlock, o.Title, o.Description, nil)

	local valLbl = lbl(right, selected, 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	valLbl.AnchorPoint = Vector2.new(1, 0.5)
	valLbl.Position    = UDim2.new(1, 0, 0.5, 0)
	valLbl.Size        = UDim2.new(1, 0, 0, 18)

	local menuItemH = 36
	local menuTotalH = #configs * (menuItemH + 5) + 14

	local menu = new("Frame", {
		Parent           = self.Container,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel  = 0,
		Visible          = false,
		ClipsDescendants = true,
		Size             = UDim2.new(1, 0, 0, 0),
	})
	corner(menu, 12)
	pad(menu, 8, 8, 7, 7)
	list(menu, 5)

	local function rebuildOptions()
		for _, c in ipairs(menu:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		configs = AuroraUI:ListConfigs()
		if #configs == 0 then configs = {"(nenhuma)"} end
		menuTotalH = #configs * (menuItemH + 5) + 14
		for _, opt in ipairs(configs) do
			local ob = btn(menu, tostring(opt))
			ob.Size             = UDim2.new(1, 0, 0, menuItemH)
			ob.BackgroundColor3 = AuroraUI.Theme.Card
			ob.TextSize         = 14
			ob.TextXAlignment   = Enum.TextXAlignment.Left
			pad(ob, 12)
			corner(ob, 9)
			hoverFx(ob, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
			ob.MouseButton1Click:Connect(function()
				selected = opt
				valLbl.Text = opt
				tween(menu, 0.14, {Size = UDim2.new(1, 0, 0, 0)})
				task.delay(0.14, function() menu.Visible = false end)
				if opt ~= "(nenhuma)" then
					local ok = AuroraUI:LoadConfig(opt)
					task.spawn(o.Callback, opt, ok)
				end
			end)
		end
	end

	rebuildOptions()

	local isOpen = false
	row.MouseButton1Click:Connect(function()
		rebuildOptions()
		isOpen = not isOpen
		if isOpen then
			menu.Visible = true
			tween(menu, 0.16, {Size = UDim2.new(1, 0, 0, menuTotalH)})
		else
			tween(menu, 0.14, {Size = UDim2.new(1, 0, 0, 0)})
			task.delay(0.14, function() menu.Visible = false end)
		end
	end)

	return {Get = function() return selected end, Instance = row}
end

function Section:CreateKeybind(o)
	o = merge({Title = "Keybind", Description = "", Default = Enum.KeyCode.F, Icon = nil, Flag = nil, Callback = function() end}, o)
	local keyName = AuroraUI.Flags[o.Flag] or o.Default.Name
	local key = Enum.KeyCode[keyName] or o.Default
	local listening = false

	local row, leftBlock, right = makeRow(self.Container)
	hoverFx(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
	rowTitle(leftBlock, o.Title, o.Description, o.Icon)

	local keyLbl = lbl(right, key.Name, 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	keyLbl.AnchorPoint = Vector2.new(1, 0.5)
	keyLbl.Position    = UDim2.new(1, 0, 0.5, 0)
	keyLbl.Size        = UDim2.new(1, 0, 0, 18)

	local control = {}
	function control:Set(v, silent)
		if typeof(v) == "EnumItem" then key = v elseif Enum.KeyCode[v] then key = Enum.KeyCode[v] end
		keyLbl.Text = key.Name
		if o.Flag then AuroraUI.Flags[o.Flag] = key.Name end
		if not silent then task.spawn(o.Callback, key) end
	end
	function control:Get() return key end
	control.Instance = row

	if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = key.Name end

	onThemeChange(function(th)
		row.BackgroundColor3 = th.Card
		keyLbl.TextColor3    = th.Accent
	end)

	row.MouseButton1Click:Connect(function() listening = true keyLbl.Text = "..." end)

	UserInputService.InputBegan:Connect(function(inp, gp)
		if gp then return end
		if listening and inp.KeyCode ~= Enum.KeyCode.Unknown then
			control:Set(inp.KeyCode)
			listening = false
			return
		end
		if not listening and inp.KeyCode == key then task.spawn(o.Callback, key) end
	end)

	return control
end

function Section:CreateTextBox(o)
	o = merge({Title = "TextBox", Description = "", Placeholder = "Digite aqui...", Default = "", Icon = nil, Flag = nil, Callback = function() end}, o)
	local value = AuroraUI.Flags[o.Flag] or o.Default

	local row = new("Frame", {
		Parent           = self.Container,
		BackgroundColor3 = AuroraUI.Theme.Card,
		BorderSizePixel  = 0,
		Size             = UDim2.new(1, 0, 0, 90),
	})
	corner(row, 12)
	pad(row, 14, 14, 10, 10)

	local iconOff = 0
	if o.Icon then
		local ic = mkIcon(row, o.Icon, 14)
		if ic then
			ic.Position = UDim2.fromOffset(0, 2)
			iconOff = 20
		end
	end

	local tTitle = lbl(row, o.Title, 15, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	tTitle.Size     = UDim2.new(1, -iconOff, 0, 19)
	tTitle.Position = UDim2.fromOffset(iconOff, 0)

	if o.Description and o.Description ~= "" then
		local tDesc = lbl(row, o.Description, 12, AuroraUI.Theme.Muted)
		tDesc.Size     = UDim2.new(1, 0, 0, 15)
		tDesc.Position = UDim2.fromOffset(0, 21)
		onThemeChange(function(th) tDesc.TextColor3 = th.Muted end)
	end

	local box = new("TextBox", {
		Parent               = row,
		BackgroundColor3     = AuroraUI.Theme.SurfaceSoft,
		BorderSizePixel      = 0,
		AnchorPoint          = Vector2.new(0, 1),
		Position             = UDim2.new(0, 0, 1, 0),
		Size                 = UDim2.new(1, 0, 0, 29),
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 13,
		TextColor3           = AuroraUI.Theme.Text,
		PlaceholderText      = o.Placeholder,
		PlaceholderColor3    = AuroraUI.Theme.Muted,
		Text                 = tostring(value),
		ClearTextOnFocus     = false,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})
	corner(box, 8)
	pad(box, 10)

	local control = {}
	function control:Set(v, silent)
		value = tostring(v or "")
		box.Text = value
		if o.Flag then AuroraUI.Flags[o.Flag] = value end
		if not silent then task.spawn(o.Callback, value) end
	end
	function control:Get() return box.Text end
	control.Instance = row

	if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = value end
	box.FocusLost:Connect(function() control:Set(box.Text) end)

	onThemeChange(function(th)
		row.BackgroundColor3 = th.Card
		box.BackgroundColor3 = th.SurfaceSoft
		box.TextColor3       = th.Text
		box.PlaceholderColor3 = th.Muted
		tTitle.TextColor3    = th.Text
	end)

	return control
end

function Section:CreateSeparator(title)
	local wrap = new("Frame", {
		Parent                 = self.Container,
		BackgroundTransparency = 1,
		Size                   = UDim2.new(1, 0, 0, 20),
	})
	local line = new("Frame", {
		Parent           = wrap,
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
		BorderSizePixel  = 0,
		AnchorPoint      = Vector2.new(0, 0.5),
		Position         = UDim2.fromScale(0, 0.5),
		Size             = UDim2.new(1, 0, 0, 1),
	})
	onThemeChange(function(th) line.BackgroundColor3 = th.SurfaceSoft end)

	if title and title ~= "" then
		local bg = new("Frame", {
			Parent           = wrap,
			BackgroundColor3 = AuroraUI.Theme.Surface,
			BorderSizePixel  = 0,
			AnchorPoint      = Vector2.new(0.5, 0.5),
			Position         = UDim2.fromScale(0.5, 0.5),
			Size             = UDim2.fromOffset(90, 18),
		})
		local tl = lbl(bg, title, 11, AuroraUI.Theme.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
		tl.Size = UDim2.new(1, 0, 1, 0)
		onThemeChange(function(th)
			bg.BackgroundColor3 = th.Surface
			tl.TextColor3       = th.Muted
		end)
	end
	return wrap
end

function AuroraUI:CreateWindow(o)
	o = merge({
		Title       = "Aurora UI",
		Subtitle    = "Interface",
		Footer      = "AuroraUI v5.2.0",
		Theme       = "Dark",
		Size        = UDim2.fromOffset(660, 460),
		Position    = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ToggleKey   = Enum.KeyCode.RightShift,
		MobileScale = 0.78,
		Draggable   = true,
		ShowProfile = false,
		Anonymous   = false,
	}, o)

	applyTheme(o.Theme)

	local gui = self.Gui or new("ScreenGui", {
		Parent         = PlayerGui,
		Name           = "AuroraUI",
		ResetOnSpawn   = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	self.Gui = gui

	local isMobile  = UserInputService.TouchEnabled
	local tgtScale  = isMobile and o.MobileScale or 1

	local main = new("CanvasGroup", {
		Parent             = gui,
		AnchorPoint        = o.AnchorPoint,
		Position           = o.Position,
		Size               = o.Size,
		BackgroundColor3   = AuroraUI.Theme.Background,
		ClipsDescendants   = true,
		BorderSizePixel    = 0,
		GroupTransparency  = 0,
	})
	corner(main, 20)

	local mainScale = new("UIScale", {Parent = main, Scale = tgtScale * 0.93})

	local header = new("Frame", {
		Parent           = main,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel  = 0,
		Size             = UDim2.new(1, 0, 0, 78),
	})

	local accentBar = new("Frame", {
		Parent           = header,
		BorderSizePixel  = 0,
		BackgroundColor3 = AuroraUI.Theme.Accent,
		AnchorPoint      = Vector2.new(0, 1),
		Position         = UDim2.new(0, 20, 1, 0),
		Size             = UDim2.new(0, 110, 0, 2),
	})
	corner(accentBar, 2)
	gradient(accentBar, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)

	local titleLbl = lbl(header, o.Title, 21, AuroraUI.Theme.Text, Enum.Font.GothamBold)
	titleLbl.Position = UDim2.fromOffset(20, 12)
	titleLbl.Size     = UDim2.new(1, -132, 0, 26)

	local subLbl = lbl(header, o.Subtitle, 13, AuroraUI.Theme.Muted)
	subLbl.Position = UDim2.fromOffset(20, 42)
	subLbl.Size     = UDim2.new(1, -132, 0, 18)

	local minBtn = btn(header, "")
	minBtn.AnchorPoint      = Vector2.new(1, 0)
	minBtn.Position         = UDim2.new(1, -52, 0, 22)
	minBtn.Size             = UDim2.fromOffset(14, 14)
	minBtn.BackgroundColor3 = AuroraUI.Theme.Minimize
	corner(minBtn, 14)

	local closeBtn = btn(header, "")
	closeBtn.AnchorPoint      = Vector2.new(1, 0)
	closeBtn.Position         = UDim2.new(1, -26, 0, 22)
	closeBtn.Size             = UDim2.fromOffset(14, 14)
	closeBtn.BackgroundColor3 = AuroraUI.Theme.Close
	corner(closeBtn, 14)

	local body = new("Frame", {
		Parent                 = main,
		BackgroundTransparency = 1,
		Position               = UDim2.fromOffset(0, 78),
		Size                   = UDim2.new(1, 0, 1, -106),
	})

	local sidebar = new("ScrollingFrame", {
		Parent               = body,
		BackgroundColor3     = AuroraUI.Theme.Sidebar,
		BackgroundTransparency = 0,
		BorderSizePixel      = 0,
		Size                 = UDim2.new(0, 166, 1, 0),
		CanvasSize           = UDim2.new(),
		AutomaticCanvasSize  = Enum.AutomaticSize.Y,
		ScrollBarThickness   = 0,
		ScrollingDirection   = Enum.ScrollingDirection.Y,
		ElasticBehavior      = Enum.ElasticBehavior.Never,
	})
	pad(sidebar, 10, 10, 13, 13)
	list(sidebar, 7)

	local divV = new("Frame", {
		Parent           = body,
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
		BorderSizePixel  = 0,
		Position         = UDim2.fromOffset(166, 0),
		Size             = UDim2.new(0, 1, 1, 0),
	})

	local pages = new("Frame", {
		Parent                 = body,
		BackgroundTransparency = 1,
		Position               = UDim2.fromOffset(178, 0),
		Size                   = UDim2.new(1, -190, 1, 0),
	})

	-- Footer
	local footerFrame = new("Frame", {
		Parent                 = main,
		BackgroundTransparency = 1,
		AnchorPoint            = Vector2.new(0.5, 1),
		Position               = UDim2.new(0.5, 0, 1, -2),
		Size                   = UDim2.new(1, 0, 0, 24),
	})

	if o.ShowProfile then
		local dispName, dispId = "Anonymous", "ID: xxxxxxx"
		local avatarId = 0
		if not o.Anonymous then
			local ok1, uid = pcall(function() return Player.UserId end)
			local ok2, name = pcall(function() return Player.DisplayName end)
			if ok1 then dispId   = "ID: " .. tostring(uid) end
			if ok2 then dispName = name end
			pcall(function()
				local thumb = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
				avatarId = thumb
			end)
		end

		local profileWrap = new("Frame", {
			Parent                 = footerFrame,
			BackgroundTransparency = 1,
			AnchorPoint            = Vector2.new(0.5, 1),
			Position               = UDim2.fromScale(0.5, 1),
			Size                   = UDim2.fromOffset(180, 24),
		})
		new("UIListLayout", {
			Parent              = profileWrap,
			FillDirection       = Enum.FillDirection.Horizontal,
			VerticalAlignment   = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder           = Enum.SortOrder.LayoutOrder,
			Padding             = UDim.new(0, 7),
		})

		local avatar = new("ImageLabel", {
			Parent                 = profileWrap,
			BackgroundColor3       = AuroraUI.Theme.SurfaceSoft,
			BorderSizePixel        = 0,
			Image                  = typeof(avatarId) == "string" and avatarId or "",
			Size                   = UDim2.fromOffset(18, 18),
			ScaleType              = Enum.ScaleType.Crop,
			LayoutOrder            = 0,
		})
		corner(avatar, 18)

		local textWrap = new("Frame", {
			Parent                 = profileWrap,
			BackgroundTransparency = 1,
			Size                   = UDim2.fromOffset(140, 24),
			LayoutOrder            = 1,
		})
		new("UIListLayout", {
			Parent            = textWrap,
			FillDirection     = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Padding           = UDim.new(0, 1),
		})

		local nameLbl = lbl(textWrap, dispName, 12, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
		nameLbl.Size = UDim2.new(1, 0, 0, 14)

		local idLbl = lbl(textWrap, dispId, 10, AuroraUI.Theme.Muted)
		idLbl.Size = UDim2.new(1, 0, 0, 12)

		onThemeChange(function(th)
			nameLbl.TextColor3 = th.Text
			idLbl.TextColor3   = th.Muted
			avatar.BackgroundColor3 = th.SurfaceSoft
		end)
	else
		local footerLbl = lbl(footerFrame, o.Footer, 11, AuroraUI.Theme.Muted, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
		footerLbl.AnchorPoint = Vector2.new(0.5, 1)
		footerLbl.Position    = UDim2.fromScale(0.5, 1)
		footerLbl.Size        = UDim2.new(0.8, 0, 0, 16)
		onThemeChange(function(th) footerLbl.TextColor3 = th.Muted end)
	end

	-- Open button
	local openBtn = btn(gui, "  Abrir Menu")
	openBtn.Visible          = false
	openBtn.AnchorPoint      = Vector2.new(0.5, 0)
	openBtn.Position         = UDim2.new(0.5, 0, 0, 14)
	openBtn.Size             = UDim2.fromOffset(170, 44)
	openBtn.BackgroundColor3 = AuroraUI.Theme.Surface
	openBtn.TextSize         = 15
	openBtn.TextColor3       = AuroraUI.Theme.Text
	openBtn.Font             = Enum.Font.GothamSemibold
	corner(openBtn, 22)

	local openScale = new("UIScale", {Parent = openBtn, Scale = 0.82})

	onThemeChange(function(th)
		main.BackgroundColor3   = th.Background
		header.BackgroundColor3 = th.Surface
		sidebar.BackgroundColor3 = th.Sidebar
		divV.BackgroundColor3   = th.SurfaceSoft
		titleLbl.TextColor3     = th.Text
		subLbl.TextColor3       = th.Muted
		minBtn.BackgroundColor3 = th.Minimize
		closeBtn.BackgroundColor3 = th.Close
		accentBar.BackgroundColor3 = th.Accent
		openBtn.BackgroundColor3 = th.Surface
		openBtn.TextColor3       = th.Text
	end)

	local w = setmetatable({
		Gui        = gui,
		Main       = main,
		Scale      = mainScale,
		TargetScale = tgtScale,
		OpenButton = openBtn,
		OpenScale  = openScale,
		Sidebar    = sidebar,
		Pages      = pages,
		Options    = o,
		Tabs       = {},
		Groups     = {},
		Visible    = true,
	}, Window)

	minBtn.MouseButton1Click:Connect(function()   w:Minimize() end)
	closeBtn.MouseButton1Click:Connect(function() w:AskClose() end)
	openBtn.MouseButton1Click:Connect(function()  w:Show() end)

	UserInputService.InputBegan:Connect(function(inp, gp)
		if gp then return end
		if inp.KeyCode == o.ToggleKey then
			if w.Main.Visible then w:Hide() else w:Show() end
		end
	end)

	if o.Draggable then
		local dragging, dragStart, startPos = false, nil, nil
		header.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				dragging  = true
				dragStart = inp.Position
				startPos  = main.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(inp)
			if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
				local d = inp.Position - dragStart
				main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end)
		UserInputService.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end

	tween(mainScale, 0.2, {Scale = tgtScale})
	table.insert(self.Windows, w)
	return w
end

return AuroraUI
