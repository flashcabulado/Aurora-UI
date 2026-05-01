local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AuroraUI = {
	Version = "5.1.0",
	Theme = {},
	Windows = {},
	Flags = {},
	Controls = {}
}

local Themes = {
	Dark = {
		Background        = Color3.fromRGB(18, 20, 26),
		Surface           = Color3.fromRGB(26, 29, 38),
		SurfaceSoft       = Color3.fromRGB(34, 38, 50),
		Sidebar           = Color3.fromRGB(22, 25, 33),
		Card              = Color3.fromRGB(34, 38, 50),
		CardHover         = Color3.fromRGB(44, 49, 64),
		Accent            = Color3.fromRGB(127, 92, 255),
		AccentSecond      = Color3.fromRGB(65, 190, 255),
		Text              = Color3.fromRGB(240, 244, 255),
		Muted             = Color3.fromRGB(140, 152, 178),
		Minimize          = Color3.fromRGB(255, 190, 60),
		Close             = Color3.fromRGB(255, 90, 100),
		Success           = Color3.fromRGB(60, 210, 140),
		Warning           = Color3.fromRGB(255, 190, 60),
		Error             = Color3.fromRGB(255, 90, 100),
		ScrollBar         = Color3.fromRGB(80, 90, 120),
	},
	Light = {
		Background        = Color3.fromRGB(240, 242, 248),
		Surface           = Color3.fromRGB(255, 255, 255),
		SurfaceSoft       = Color3.fromRGB(228, 232, 242),
		Sidebar           = Color3.fromRGB(232, 235, 245),
		Card              = Color3.fromRGB(248, 249, 253),
		CardHover         = Color3.fromRGB(220, 224, 238),
		Accent            = Color3.fromRGB(100, 65, 230),
		AccentSecond      = Color3.fromRGB(30, 160, 240),
		Text              = Color3.fromRGB(22, 24, 34),
		Muted             = Color3.fromRGB(100, 110, 140),
		Minimize          = Color3.fromRGB(240, 170, 30),
		Close             = Color3.fromRGB(230, 60, 75),
		Success           = Color3.fromRGB(30, 180, 110),
		Warning           = Color3.fromRGB(240, 170, 30),
		Error             = Color3.fromRGB(230, 60, 75),
		ScrollBar         = Color3.fromRGB(160, 170, 200),
	},
	Midnight = {
		Background        = Color3.fromRGB(8, 10, 20),
		Surface           = Color3.fromRGB(14, 17, 30),
		SurfaceSoft       = Color3.fromRGB(20, 25, 42),
		Sidebar           = Color3.fromRGB(10, 13, 24),
		Card              = Color3.fromRGB(20, 25, 42),
		CardHover         = Color3.fromRGB(28, 35, 58),
		Accent            = Color3.fromRGB(80, 120, 255),
		AccentSecond      = Color3.fromRGB(160, 80, 255),
		Text              = Color3.fromRGB(220, 228, 255),
		Muted             = Color3.fromRGB(100, 115, 165),
		Minimize          = Color3.fromRGB(255, 200, 60),
		Close             = Color3.fromRGB(255, 80, 110),
		Success           = Color3.fromRGB(50, 200, 140),
		Warning           = Color3.fromRGB(255, 200, 60),
		Error             = Color3.fromRGB(255, 80, 110),
		ScrollBar         = Color3.fromRGB(60, 75, 130),
	},
	Sakura = {
		Background        = Color3.fromRGB(30, 18, 24),
		Surface           = Color3.fromRGB(44, 26, 34),
		SurfaceSoft       = Color3.fromRGB(58, 34, 46),
		Sidebar           = Color3.fromRGB(36, 20, 28),
		Card              = Color3.fromRGB(52, 30, 42),
		CardHover         = Color3.fromRGB(68, 40, 54),
		Accent            = Color3.fromRGB(240, 100, 150),
		AccentSecond      = Color3.fromRGB(200, 140, 200),
		Text              = Color3.fromRGB(255, 230, 240),
		Muted             = Color3.fromRGB(180, 130, 155),
		Minimize          = Color3.fromRGB(255, 200, 80),
		Close             = Color3.fromRGB(255, 80, 100),
		Success           = Color3.fromRGB(100, 220, 160),
		Warning           = Color3.fromRGB(255, 200, 80),
		Error             = Color3.fromRGB(255, 80, 100),
		ScrollBar         = Color3.fromRGB(140, 80, 110),
	},
	Forest = {
		Background        = Color3.fromRGB(14, 22, 18),
		Surface           = Color3.fromRGB(20, 32, 24),
		SurfaceSoft       = Color3.fromRGB(28, 44, 34),
		Sidebar           = Color3.fromRGB(16, 26, 20),
		Card              = Color3.fromRGB(28, 44, 34),
		CardHover         = Color3.fromRGB(36, 58, 44),
		Accent            = Color3.fromRGB(60, 200, 120),
		AccentSecond      = Color3.fromRGB(120, 220, 80),
		Text              = Color3.fromRGB(210, 240, 220),
		Muted             = Color3.fromRGB(110, 160, 130),
		Minimize          = Color3.fromRGB(240, 200, 60),
		Close             = Color3.fromRGB(220, 70, 80),
		Success           = Color3.fromRGB(60, 200, 120),
		Warning           = Color3.fromRGB(240, 200, 60),
		Error             = Color3.fromRGB(220, 70, 80),
		ScrollBar         = Color3.fromRGB(60, 110, 80),
	},
}

AuroraUI.Themes = Themes

local function applyTheme(name)
	local t = Themes[name] or Themes.Dark
	for k, v in pairs(t) do
		AuroraUI.Theme[k] = v
	end
end

applyTheme("Dark")

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
	local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local function corner(parent, radius)
	return new("UICorner", {Parent = parent, CornerRadius = UDim.new(0, radius or 12)})
end

local function pad(parent, l, r, t, b)
	return new("UIPadding", {
		Parent = parent,
		PaddingLeft   = UDim.new(0, l or 0),
		PaddingRight  = UDim.new(0, r or l or 0),
		PaddingTop    = UDim.new(0, t or l or 0),
		PaddingBottom = UDim.new(0, b or t or l or 0)
	})
end

local function list(parent, gap, fillDir, align)
	return new("UIListLayout", {
		Parent = parent,
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = fillDir or Enum.FillDirection.Vertical,
		VerticalAlignment = align or Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, gap or 8)
	})
end

local function gradient(parent, a, b, rot)
	return new("UIGradient", {
		Parent = parent,
		Rotation = rot or 0,
		Color = ColorSequence.new(a or AuroraUI.Theme.Accent, b or AuroraUI.Theme.AccentSecond)
	})
end

local function label(parent, text, size, color, font, xAlign)
	local lblSize = size and (size + 4) or 18
	return new("TextLabel", {
		Parent = parent,
		BackgroundTransparency = 1,
		Text = text or "",
		Font = font or Enum.Font.GothamMedium,
		TextSize = size or 14,
		TextColor3 = color or AuroraUI.Theme.Text,
		TextXAlignment = xAlign or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = true,
		Size = UDim2.new(1, 0, 0, lblSize),
	})
end

local function btn(parent, text)
	return new("TextButton", {
		Parent = parent,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = AuroraUI.Theme.Card,
		Text = text or "",
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = AuroraUI.Theme.Text,
	})
end

local function iconImage(parent, icon, size)
	if typeof(icon) == "number" then icon = "rbxassetid://" .. tostring(icon) end
	if typeof(icon) ~= "string" or not icon:find("rbxassetid://") then return nil end
	return new("ImageLabel", {
		Parent = parent,
		BackgroundTransparency = 1,
		Image = icon,
		ImageColor3 = AuroraUI.Theme.Muted,
		Size = UDim2.fromOffset(size or 16, size or 16),
		ScaleType = Enum.ScaleType.Fit,
	})
end

local function hover(obj, normal, over)
	obj.MouseEnter:Connect(function()
		if obj:GetAttribute("Selected") then return end
		tween(obj, 0.12, {BackgroundColor3 = over or AuroraUI.Theme.CardHover})
	end)
	obj.MouseLeave:Connect(function()
		if obj:GetAttribute("Selected") then return end
		tween(obj, 0.12, {BackgroundColor3 = normal or AuroraUI.Theme.Card})
	end)
end

local function makeItemRow(parent)
	local row = btn(parent, "")
	row.Size = UDim2.new(1, 0, 0, 64)
	row.BackgroundColor3 = AuroraUI.Theme.Card
	corner(row, 12)

	local inner = new("Frame", {
		Parent = row,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	})
	pad(inner, 14, 14, 0, 0)

	local leftBlock = new("Frame", {
		Parent = inner,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -120, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
	})
	local lLayout = new("UIListLayout", {
		Parent = leftBlock,
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 2),
	})

	local right = new("Frame", {
		Parent = inner,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(110, 40),
	})

	return row, leftBlock, right
end

local Window = {}
Window.__index = Window
local Tab = {}
Tab.__index = Tab
local Section = {}
Section.__index = Section

function AuroraUI:SetTheme(themeNameOrTable)
	if typeof(themeNameOrTable) == "string" then
		applyTheme(themeNameOrTable)
	elseif typeof(themeNameOrTable) == "table" then
		for k, v in pairs(themeNameOrTable) do
			if self.Theme[k] ~= nil then
				self.Theme[k] = hexToColor3(v)
			end
		end
	end
end

function AuroraUI:SetFlag(flag, value)
	if not flag then return end
	self.Flags[flag] = value
	local control = self.Controls[flag]
	if control and control.Set then
		control:Set(value, true)
	end
end

function AuroraUI:GetFlag(flag)
	return self.Flags[flag]
end

function AuroraUI:RegisterControl(flag, control)
	if not flag then return end
	self.Controls[flag] = control
end

function AuroraUI:SaveConfig(name)
	name = name or "AuroraUI_Config"
	local data = HttpService:JSONEncode(self.Flags)
	if writefile then
		writefile(name .. ".json", data)
		return true, data
	end
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
	for flag, value in pairs(decoded) do
		self:SetFlag(flag, value)
	end
	return true
end

function AuroraUI:Notify(o)
	o = merge({Title = "AuroraUI", Content = "Notificação", Duration = 3}, o)
	local gui = self.Gui or new("ScreenGui", {
		Parent = PlayerGui,
		Name = "AuroraUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})
	self.Gui = gui

	local holder = gui:FindFirstChild("Notifications") or new("Frame", {
		Parent = gui,
		Name = "Notifications",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -16, 0, 16),
		Size = UDim2.fromOffset(320, 520),
	})
	if not holder:FindFirstChildOfClass("UIListLayout") then list(holder, 10) end

	local card = new("Frame", {
		Parent = holder,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 80),
		ClipsDescendants = true,
	})
	corner(card, 14)
	pad(card, 14, 14, 10, 10)

	local scale = new("UIScale", {Parent = card, Scale = 0.9})

	local titleLbl = label(card, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamBold)
	titleLbl.Size = UDim2.new(1, 0, 0, 20)
	titleLbl.Position = UDim2.fromOffset(0, 0)

	local bodyLbl = label(card, o.Content, 12, AuroraUI.Theme.Muted)
	bodyLbl.Size = UDim2.new(1, 0, 0, 32)
	bodyLbl.Position = UDim2.fromOffset(0, 24)

	local bar = new("Frame", {
		Parent = card,
		BorderSizePixel = 0,
		BackgroundColor3 = AuroraUI.Theme.Accent,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 3),
	})
	corner(bar, 3)
	gradient(bar, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)

	tween(scale, 0.18, {Scale = 1})
	tween(bar, o.Duration, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)

	task.delay(o.Duration, function()
		if card.Parent then
			tween(scale, 0.14, {Scale = 0.88})
			local out = tween(card, 0.14, {BackgroundTransparency = 1})
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
	tween(self.Scale, 0.14, {Scale = self.TargetScale * 0.96})
	local t = tween(self.Main, 0.14, {GroupTransparency = 1})
	t.Completed:Connect(function()
		if not self.Visible then self.Main.Visible = false end
	end)
end

function Window:Minimize()
	self:Hide()
	task.delay(0.14, function()
		self.OpenButton.Visible = true
		tween(self.OpenScale, 0.18, {Scale = 1})
	end)
end

function Window:AskClose()
	if self.CloseDialog and self.CloseDialog.Parent then
		self.CloseDialog.Visible = true
		return
	end

	local dialog = new("Frame", {
		Parent = self.Gui,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(290, 148),
		ZIndex = 20,
	})
	self.CloseDialog = dialog
	corner(dialog, 18)
	pad(dialog, 18, 18, 18, 18)

	local s = new("UIScale", {Parent = dialog, Scale = 0.88})

	local dlgTitle = label(dialog, "Fechar menu?", 16, AuroraUI.Theme.Text, Enum.Font.GothamBold)
	dlgTitle.Size = UDim2.new(1, 0, 0, 22)
	dlgTitle.Position = UDim2.fromOffset(0, 0)

	local dlgDesc = label(dialog, "Deseja esconder a interface agora?", 13, AuroraUI.Theme.Muted)
	dlgDesc.Position = UDim2.fromOffset(0, 28)
	dlgDesc.Size = UDim2.new(1, 0, 0, 34)

	local noBtn = btn(dialog, "Cancelar")
	noBtn.Position = UDim2.new(0, 0, 1, -38)
	noBtn.Size = UDim2.new(0.48, 0, 0, 36)
	noBtn.BackgroundColor3 = AuroraUI.Theme.Card
	noBtn.TextSize = 13
	corner(noBtn, 10)

	local yesBtn = btn(dialog, "Fechar")
	yesBtn.Position = UDim2.new(0.52, 0, 1, -38)
	yesBtn.Size = UDim2.new(0.48, 0, 0, 36)
	yesBtn.BackgroundColor3 = AuroraUI.Theme.Close
	yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	yesBtn.TextSize = 13
	corner(yesBtn, 10)

	tween(s, 0.16, {Scale = 1})

	noBtn.MouseButton1Click:Connect(function() dialog.Visible = false end)
	yesBtn.MouseButton1Click:Connect(function() dialog.Visible = false self:Hide() end)
end

function Window:Destroy()
	if self.Gui then self.Gui:Destroy() end
end

function Window:SelectTab(tab)
	for _, item in ipairs(self.Tabs) do
		local selected = item == tab
		item.Button:SetAttribute("Selected", selected)
		item.Page.Visible = selected
		if selected then
			tween(item.Button, 0.16, {BackgroundColor3 = AuroraUI.Theme.Accent})
			item.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			if item.Icon then item.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255) end
		else
			tween(item.Button, 0.16, {BackgroundColor3 = AuroraUI.Theme.Card})
			item.Button.TextColor3 = AuroraUI.Theme.Text
			if item.Icon then item.Icon.ImageColor3 = AuroraUI.Theme.Muted end
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
			Parent = self.Sidebar,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20),
			AutomaticSize = Enum.AutomaticSize.Y,
		})
		list(group, 6)

		local groupLbl = label(group, string.upper(o.Group), 10, AuroraUI.Theme.Muted, Enum.Font.GothamBold)
		groupLbl.Size = UDim2.new(1, 0, 0, 14)

		self.Groups[o.Group] = group
	end

	local b = btn(group, o.Name)
	b.Size = UDim2.new(1, 0, 0, 38)
	b.BackgroundColor3 = AuroraUI.Theme.Card
	b.TextSize = 13
	b.TextXAlignment = Enum.TextXAlignment.Center
	corner(b, 10)

	local icon = iconImage(b, o.Icon, 15)
	if icon then
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 11, 0.5, 0)
		b.Text = "    " .. o.Name
	end

	hover(b, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)

	local page = new("ScrollingFrame", {
		Parent = self.Pages,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = false,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = AuroraUI.Theme.ScrollBar,
	})
	pad(page, 2, 6, 4, 8)
	list(page, 8)

	tab.Button = b
	tab.Page = page
	tab.Icon = icon

	b.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
	table.insert(self.Tabs, tab)
	if not self.ActiveTab then self:SelectTab(tab) end

	return tab
end

function Tab:CreateSection(o)
	o = merge({Title = "Section", Description = "", Collapsible = true, DefaultOpen = true}, o)
	local section = setmetatable({Tab = self, Options = o, Open = o.DefaultOpen ~= false}, Section)

	local outer = new("Frame", {
		Parent = self.Page,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ClipsDescendants = true,
	})
	corner(outer, 14)

	local headerHeight = (o.Description ~= "" and o.Description ~= nil) and 62 or 46

	local header = btn(outer, "")
	header.BackgroundTransparency = 1
	header.Size = UDim2.new(1, 0, 0, headerHeight)
	header.Text = ""
	pad(header, 14, 14, 10, 10)

	local titleLbl = label(header, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamBold)
	titleLbl.Size = UDim2.new(1, -36, 0, 18)
	titleLbl.Position = UDim2.fromOffset(0, 0)
	titleLbl.TextYAlignment = Enum.TextYAlignment.Top

	if o.Description ~= "" and o.Description ~= nil then
		local descLbl = label(header, o.Description, 12, AuroraUI.Theme.Muted)
		descLbl.Size = UDim2.new(1, -36, 0, 16)
		descLbl.Position = UDim2.fromOffset(0, 22)
		descLbl.TextYAlignment = Enum.TextYAlignment.Top
	end

	local arrowLbl = label(header, "▾", 14, AuroraUI.Theme.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	arrowLbl.AnchorPoint = Vector2.new(1, 0.5)
	arrowLbl.Position = UDim2.new(1, 0, 0.5, 0)
	arrowLbl.Size = UDim2.fromOffset(24, 24)
	if not section.Open then arrowLbl.Text = "▸" end

	local arrowScale = new("UIScale", {Parent = arrowLbl, Scale = 1})

	local container = new("Frame", {
		Parent = outer,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = section.Open,
	})
	pad(container, 10, 10, 2, 10)
	list(container, 7)

	local divider = new("Frame", {
		Parent = outer,
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -28, 0, 1),
		Position = UDim2.new(0, 14, 0, headerHeight),
		Visible = section.Open,
	})

	section.Outer = outer
	section.Container = container
	section.Divider = divider

	header.MouseButton1Click:Connect(function()
		if o.Collapsible == false then return end
		section.Open = not section.Open

		tween(arrowScale, 0.08, {Scale = 0.7})
		task.delay(0.08, function()
			if arrowScale.Parent then
				arrowLbl.Text = section.Open and "▾" or "▸"
				tween(arrowScale, 0.12, {Scale = 1})
			end
		end)

		divider.Visible = section.Open
		if section.Open then
			container.Visible = true
		else
			task.delay(0.1, function()
				if not section.Open then container.Visible = false end
			end)
		end
	end)

	table.insert(self.Sections, section)
	return section
end

function Section:CreateButton(o)
	o = merge({Title = "Button", Description = "", Action = "Executar", Callback = function() end}, o)

	local row, leftBlock, right = makeItemRow(self.Container)
	hover(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)

	local titleLbl = label(leftBlock, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	titleLbl.Size = UDim2.new(1, 0, 0, 18)

	if o.Description ~= "" and o.Description ~= nil then
		local descLbl = label(leftBlock, o.Description, 12, AuroraUI.Theme.Muted)
		descLbl.Size = UDim2.new(1, 0, 0, 15)
	end

	local actionLbl = label(right, o.Action, 12, AuroraUI.Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	actionLbl.Size = UDim2.new(1, 0, 1, 0)

	row.MouseButton1Click:Connect(function()
		tween(row, 0.06, {Size = UDim2.new(1, -4, 0, 62)})
		task.delay(0.06, function()
			if row.Parent then tween(row, 0.1, {Size = UDim2.new(1, 0, 0, 64)}) end
		end)
		task.spawn(o.Callback)
	end)

	return row
end

function Section:CreateToggle(o)
	o = merge({Title = "Toggle", Description = "", Default = false, Flag = nil, Callback = function() end}, o)
	local state = AuroraUI.Flags[o.Flag] ~= nil and AuroraUI.Flags[o.Flag] or o.Default == true

	local row, leftBlock, right = makeItemRow(self.Container)
	hover(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)

	local titleLbl = label(leftBlock, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	titleLbl.Size = UDim2.new(1, 0, 0, 18)

	if o.Description ~= "" and o.Description ~= nil then
		local descLbl = label(leftBlock, o.Description, 12, AuroraUI.Theme.Muted)
		descLbl.Size = UDim2.new(1, 0, 0, 15)
	end

	local trackFrame = new("Frame", {
		Parent = right,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(46, 24),
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
	})
	if state then trackFrame.BackgroundColor3 = AuroraUI.Theme.Accent end
	corner(trackFrame, 24)

	local thumbStartPos = state and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3)
	local thumb = new("Frame", {
		Parent = trackFrame,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.fromOffset(18, 18),
		Position = thumbStartPos,
	})
	corner(thumb, 18)

	local control = {}
	function control:Set(v, silent)
		state = v == true
		if o.Flag then AuroraUI.Flags[o.Flag] = state end
		do local c = state and AuroraUI.Theme.Accent or AuroraUI.Theme.SurfaceSoft
		tween(trackFrame, 0.15, {BackgroundColor3 = c}) end
		do local p = state and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3)
		tween(thumb, 0.15, {Position = p}) end
		if not silent then task.spawn(o.Callback, state) end
	end
	function control:Get() return state end
	control.Instance = row

	if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = state end
	row.MouseButton1Click:Connect(function() control:Set(not state) end)

	return control
end

function Section:CreateSlider(o)
	o = merge({Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Increment = 1, Flag = nil, Callback = function() end}, o)
	local value = tonumber(AuroraUI.Flags[o.Flag]) or math.clamp(o.Default, o.Min, o.Max)

	local row = new("Frame", {
		Parent = self.Container,
		BackgroundColor3 = AuroraUI.Theme.Card,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 80),
	})
	corner(row, 12)
	pad(row, 14, 14, 10, 12)

	local topRow = new("Frame", {
		Parent = row,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 36),
	})

	local titleLbl = label(topRow, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	titleLbl.Size = UDim2.new(1, -60, 0, 18)
	titleLbl.Position = UDim2.fromOffset(0, 0)

	if o.Description ~= "" and o.Description ~= nil then
		local descLbl = label(topRow, o.Description, 12, AuroraUI.Theme.Muted)
		descLbl.Size = UDim2.new(1, -60, 0, 15)
		descLbl.Position = UDim2.fromOffset(0, 20)
	end

	local valueLbl = label(topRow, tostring(value), 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	valueLbl.AnchorPoint = Vector2.new(1, 0)
	valueLbl.Position = UDim2.new(1, 0, 0, 0)
	valueLbl.Size = UDim2.fromOffset(54, 18)

	local trackHolder = new("Frame", {
		Parent = row,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 20),
	})

	local track = new("Frame", {
		Parent = trackHolder,
		BorderSizePixel = 0,
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 6),
	})
	corner(track, 6)

	local fill = new("Frame", {
		Parent = track,
		BorderSizePixel = 0,
		BackgroundColor3 = AuroraUI.Theme.Accent,
		Size = UDim2.new((value - o.Min) / math.max(o.Max - o.Min, 1), 0, 1, 0),
	})
	corner(fill, 6)
	gradient(fill, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)

	local thumbBtn = new("Frame", {
		Parent = track,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new((value - o.Min) / math.max(o.Max - o.Min, 1), 0, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		ZIndex = 2,
	})
	corner(thumbBtn, 16)

	local thumbInner = new("Frame", {
		Parent = thumbBtn,
		BorderSizePixel = 0,
		BackgroundColor3 = AuroraUI.Theme.Accent,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(8, 8),
	})
	corner(thumbInner, 8)

	local control = {}
	function control:Set(v, silent)
		value = math.clamp(tonumber(v) or o.Min, o.Min, o.Max)
		value = math.floor(value / o.Increment + 0.5) * o.Increment
		local alpha = (value - o.Min) / math.max(o.Max - o.Min, 1)
		valueLbl.Text = tostring(value)
		if o.Flag then AuroraUI.Flags[o.Flag] = value end
		tween(fill, 0.07, {Size = UDim2.new(alpha, 0, 1, 0)})
		tween(thumbBtn, 0.07, {Position = UDim2.new(alpha, 0, 0.5, 0)})
		if not silent then task.spawn(o.Callback, value) end
	end
	function control:Get() return value end
	control.Instance = row

	if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = value end

	local dragging = false
	local function setFromX(x)
		local alpha = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		control:Set(o.Min + (o.Max - o.Min) * alpha)
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(input.Position.X)
		end
	end)
	thumbBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			setFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	return control
end

function Section:CreateDropdown(o)
	o = merge({Title = "Dropdown", Description = "", Options = {}, Default = nil, Flag = nil, Callback = function() end}, o)
	local selected = AuroraUI.Flags[o.Flag] or o.Default or o.Options[1] or "None"

	local row, leftBlock, right = makeItemRow(self.Container)
	hover(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)

	local titleLbl = label(leftBlock, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	titleLbl.Size = UDim2.new(1, 0, 0, 18)

	if o.Description ~= "" and o.Description ~= nil then
		local descLbl = label(leftBlock, o.Description, 12, AuroraUI.Theme.Muted)
		descLbl.Size = UDim2.new(1, 0, 0, 15)
	end

	local valueLbl = label(right, tostring(selected), 12, AuroraUI.Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	valueLbl.AnchorPoint = Vector2.new(1, 0.5)
	valueLbl.Position = UDim2.new(1, 0, 0.5, 0)
	valueLbl.Size = UDim2.new(1, 0, 0, 18)

	local menu = new("Frame", {
		Parent = self.Container,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel = 0,
		Visible = false,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 0),
	})
	corner(menu, 12)
	pad(menu, 8, 8, 6, 6)
	list(menu, 4)

	local control = {}
	function control:Set(v, silent)
		selected = v
		valueLbl.Text = tostring(v)
		if o.Flag then AuroraUI.Flags[o.Flag] = selected end
		if not silent then task.spawn(o.Callback, selected) end
	end
	function control:Get() return selected end
	control.Instance = row

	if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = selected end

	local menuItemHeight = 34
	local menuHeight = #o.Options * (menuItemHeight + 4) + 12

	for _, opt in ipairs(o.Options) do
		local ob = btn(menu, tostring(opt))
		ob.Size = UDim2.new(1, 0, 0, menuItemHeight)
		ob.BackgroundColor3 = AuroraUI.Theme.Card
		ob.TextSize = 13
		ob.TextXAlignment = Enum.TextXAlignment.Left
		pad(ob, 10)
		corner(ob, 8)
		hover(ob, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
		ob.MouseButton1Click:Connect(function()
			control:Set(opt)
			tween(menu, 0.14, {Size = UDim2.new(1, 0, 0, 0)})
			task.delay(0.14, function() menu.Visible = false end)
		end)
	end

	row.MouseButton1Click:Connect(function()
		local opening = not menu.Visible
		menu.Visible = true
		do local sz = opening and menuHeight or 0
		tween(menu, 0.16, {Size = UDim2.new(1, 0, 0, sz)}) end
		if not opening then
			task.delay(0.16, function() menu.Visible = false end)
		end
	end)

	return control
end

function Section:CreateKeybind(o)
	o = merge({Title = "Keybind", Description = "", Default = Enum.KeyCode.F, Flag = nil, Callback = function() end}, o)
	local keyName = AuroraUI.Flags[o.Flag] or o.Default.Name
	local key = Enum.KeyCode[keyName] or o.Default
	local listening = false

	local row, leftBlock, right = makeItemRow(self.Container)
	hover(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)

	local titleLbl = label(leftBlock, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	titleLbl.Size = UDim2.new(1, 0, 0, 18)

	if o.Description ~= "" and o.Description ~= nil then
		local descLbl = label(leftBlock, o.Description, 12, AuroraUI.Theme.Muted)
		descLbl.Size = UDim2.new(1, 0, 0, 15)
	end

	local keyLbl = label(right, key.Name, 12, AuroraUI.Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	keyLbl.AnchorPoint = Vector2.new(1, 0.5)
	keyLbl.Position = UDim2.new(1, 0, 0.5, 0)
	keyLbl.Size = UDim2.new(1, 0, 0, 18)

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

	row.MouseButton1Click:Connect(function()
		listening = true
		keyLbl.Text = "..."
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
			control:Set(input.KeyCode)
			listening = false
			return
		end
		if not listening and input.KeyCode == key then
			task.spawn(o.Callback, key)
		end
	end)

	return control
end

function Section:CreateTextBox(o)
	o = merge({Title = "TextBox", Description = "", Placeholder = "Digite aqui...", Default = "", Flag = nil, Callback = function() end}, o)
	local value = AuroraUI.Flags[o.Flag] or o.Default

	local row = new("Frame", {
		Parent = self.Container,
		BackgroundColor3 = AuroraUI.Theme.Card,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 88),
	})
	corner(row, 12)
	pad(row, 14, 14, 10, 10)

	local titleLbl = label(row, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
	titleLbl.Size = UDim2.new(1, 0, 0, 18)
	titleLbl.Position = UDim2.fromOffset(0, 0)

	if o.Description ~= "" and o.Description ~= nil then
		local descLbl = label(row, o.Description, 12, AuroraUI.Theme.Muted)
		descLbl.Size = UDim2.new(1, 0, 0, 14)
		descLbl.Position = UDim2.fromOffset(0, 20)
	end

	local box = new("TextBox", {
		Parent = row,
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 28),
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = AuroraUI.Theme.Text,
		PlaceholderText = o.Placeholder,
		PlaceholderColor3 = AuroraUI.Theme.Muted,
		Text = tostring(value),
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
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

	return control
end

function Section:CreateSeparator(title)
	local wrap = new("Frame", {
		Parent = self.Container,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
	})
	local line = new("Frame", {
		Parent = wrap,
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(1, 0, 0, 1),
	})
	if title and title ~= "" then
		local lbl = label(wrap, title, 11, AuroraUI.Theme.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
		lbl.AnchorPoint = Vector2.new(0.5, 0.5)
		lbl.Position = UDim2.fromScale(0.5, 0.5)
		lbl.Size = UDim2.fromOffset(100, 18)
		lbl.BackgroundColor3 = AuroraUI.Theme.Surface
		lbl.BackgroundTransparency = 0
	end
	return wrap
end

function AuroraUI:CreateWindow(o)
	o = merge({
		Title       = "Aurora UI",
		Subtitle    = "Interface Premium",
		Footer      = "AuroraUI • v5.1.0",
		Theme       = "Dark",
		Size        = UDim2.fromOffset(640, 440),
		Position    = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ToggleKey   = Enum.KeyCode.RightShift,
		MobileScale = 0.8,
		Draggable   = true,
	}, o)

	applyTheme(o.Theme)

	local gui = self.Gui or new("ScreenGui", {
		Parent = PlayerGui,
		Name = "AuroraUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	self.Gui = gui

	local isMobile = UserInputService.TouchEnabled
	local targetScale = isMobile and o.MobileScale or 1

	local main = new("CanvasGroup", {
		Parent = gui,
		AnchorPoint = o.AnchorPoint,
		Position = o.Position,
		Size = o.Size,
		BackgroundColor3 = AuroraUI.Theme.Background,
		ClipsDescendants = true,
		BorderSizePixel = 0,
		GroupTransparency = 0,
	})
	corner(main, 20)

	local scale = new("UIScale", {Parent = main, Scale = targetScale * 0.94})

	local header = new("Frame", {
		Parent = main,
		BackgroundColor3 = AuroraUI.Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 76),
	})

	local accentLine = new("Frame", {
		Parent = header,
		BorderSizePixel = 0,
		BackgroundColor3 = AuroraUI.Theme.Accent,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 20, 1, 0),
		Size = UDim2.new(0, 120, 0, 2),
	})
	corner(accentLine, 2)
	gradient(accentLine, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)

	local titleLbl = label(header, o.Title, 20, AuroraUI.Theme.Text, Enum.Font.GothamBold)
	titleLbl.Position = UDim2.fromOffset(20, 12)
	titleLbl.Size = UDim2.new(1, -130, 0, 26)

	local subLbl = label(header, o.Subtitle, 12, AuroraUI.Theme.Muted)
	subLbl.Position = UDim2.fromOffset(20, 42)
	subLbl.Size = UDim2.new(1, -130, 0, 18)

	local minBtn = btn(header, "")
	minBtn.AnchorPoint = Vector2.new(1, 0)
	minBtn.Position = UDim2.new(1, -52, 0, 22)
	minBtn.Size = UDim2.fromOffset(14, 14)
	minBtn.BackgroundColor3 = AuroraUI.Theme.Minimize
	corner(minBtn, 14)

	local closeBtn = btn(header, "")
	closeBtn.AnchorPoint = Vector2.new(1, 0)
	closeBtn.Position = UDim2.new(1, -26, 0, 22)
	closeBtn.Size = UDim2.fromOffset(14, 14)
	closeBtn.BackgroundColor3 = AuroraUI.Theme.Close
	corner(closeBtn, 14)

	local body = new("Frame", {
		Parent = main,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 76),
		Size = UDim2.new(1, 0, 1, -100),
	})

	local sidebar = new("ScrollingFrame", {
		Parent = body,
		BackgroundColor3 = AuroraUI.Theme.Sidebar,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 162, 1, 0),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 0,
	})
	pad(sidebar, 10, 10, 12, 12)
	list(sidebar, 8)

	local dividerV = new("Frame", {
		Parent = body,
		BackgroundColor3 = AuroraUI.Theme.SurfaceSoft,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(162, 0),
		Size = UDim2.new(0, 1, 1, 0),
	})

	local pages = new("Frame", {
		Parent = body,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(174, 0),
		Size = UDim2.new(1, -186, 1, 0),
	})

	local footerLbl = label(main, o.Footer, 11, AuroraUI.Theme.Muted)
	footerLbl.AnchorPoint = Vector2.new(0, 1)
	footerLbl.Position = UDim2.new(0, 18, 1, -6)
	footerLbl.Size = UDim2.new(1, -36, 0, 18)

	local openBtn = btn(gui, "Abrir Menu")
	openBtn.Visible = false
	openBtn.AnchorPoint = Vector2.new(0.5, 0)
	openBtn.Position = UDim2.new(0.5, 0, 0, 14)
	openBtn.Size = UDim2.fromOffset(160, 40)
	openBtn.BackgroundColor3 = AuroraUI.Theme.Surface
	openBtn.TextSize = 13
	openBtn.TextColor3 = AuroraUI.Theme.Text
	corner(openBtn, 20)

	local openScale = new("UIScale", {Parent = openBtn, Scale = 0.84})

	local w = setmetatable({
		Gui        = gui,
		Main       = main,
		Scale      = scale,
		TargetScale = targetScale,
		OpenButton = openBtn,
		OpenScale  = openScale,
		Sidebar    = sidebar,
		Pages      = pages,
		Options    = o,
		Tabs       = {},
		Groups     = {},
		Visible    = true,
	}, Window)

	minBtn.MouseButton1Click:Connect(function() w:Minimize() end)
	closeBtn.MouseButton1Click:Connect(function() w:AskClose() end)
	openBtn.MouseButton1Click:Connect(function() w:Show() end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == o.ToggleKey then
			if w.Main.Visible then w:Hide() else w:Show() end
		end
	end)

	if o.Draggable then
		local dragging = false
		local dragStart, startPos

		header.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = main.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end

	tween(scale, 0.2, {Scale = targetScale})
	table.insert(self.Windows, w)
	return w
end

return AuroraUI
