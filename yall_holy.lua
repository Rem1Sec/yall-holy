local ok, lib = pcall(function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

local GAME_NAME = "game name"
local _gameNameSetters = {}
local function saname(s)
	s = tostring(s or ""):gsub("[^%w%s%-%_\128-\255]", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	local low = string.lower(s)
	if low == "" or low == "game name" or low == "place name" then return nil end
	return s
end
local GAME_DIR = saname(game.Name) or saname(game.PlaceName) or ("place-" .. tostring(game.PlaceId or 0))
task.spawn(function()
	local ok, info = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	end)
	if ok and info and type(info.Name) == "string" and info.Name ~= "" then
		GAME_NAME = info.Name
		for _, fn in ipairs(_gameNameSetters) do pcall(fn, GAME_NAME) end
	end
end)
local THEME = {
	accent = Color3.fromRGB(255, 255, 255),
	accent2 = Color3.fromRGB(255, 255, 255),
	bg = Color3.fromRGB(6, 6, 8),
	dim = Color3.fromRGB(122, 122, 134),
	glow = Color3.fromRGB(150, 152, 175),
	head = Color3.fromRGB(15, 15, 18),
	line = Color3.fromRGB(52, 52, 64),
	panel = Color3.fromRGB(11, 11, 14),
	side = Color3.fromRGB(12, 12, 15),
	text = Color3.fromRGB(240, 240, 245),
}
local ICONS = {
	activity = 137527339160230, banknote = 113703117675594, bell = 84691420588185,
	book = 74111869099427, bot = 70979486241131, box = 117371753006597,
	boxes = 95055252135506, brain = 116902501990569, bug = 75649814233484,
	car = 91451724283877, ["car-front"] = 79993076477613, check = 86817768619372,
	["chevron-down"] = 71457658246709, ["chevron-right"] = 101007429951147,
	["chevron-up"] = 98648581502859, ["circle-dot"] = 122878673716704,
	["clipboard-paste"] = 79192963603923, clock = 136533241128438, code = 75851496262862,
	cog = 123222732420633, coins = 117341212186115, compass = 73836660434977,
	copy = 116378866141355, crosshair = 83752373575368, crown = 92253403464658,
	database = 99154172590159, dices = 116678154854810, ellipsis = 101330725759187,
	eye = 127234874352422, ["eye-off"] = 85207295981701, ["file-text"] = 92774566080911,
	fish = 114555142566431, flame = 125012650497883, folder = 77937190465422,
	footprints = 80792036653047, ["gamepad-2"] = 99293705721130, gauge = 128279962545721,
	ghost = 132705178126217, globe = 125685532120024, hand = 83088528355903,
	heart = 88525382655929, home = 109841253338329, image = 114022611279795,
	info = 120620848266512, key = 83474888140571, keyboard = 121978468376124,
	layers = 114499998778667, link = 86131768436965, list = 101699539545687,
	lock = 119765975153029, ["log-out"] = 140299936053191, map = 131325044235094,
	["map-pin"] = 137091405832737, minus = 95070996149109, monitor = 70520152532392,
	["mouse-pointer"] = 113428527051320, move = 77028714324861, package = 106101842173393,
	palette = 127369887384101, ["person-standing"] = 101118444346965,
	pickaxe = 111300940329486, pipette = 104047428948587, plus = 101123124881873,
	power = 89331085993646, radar = 132868138496209, ["refresh-cw"] = 106497040962250,
	rocket = 109537053598807, save = 122894934359450, ["scan-eye"] = 109514269737059,
	search = 72296609649861, send = 94849431195865, settings = 106205298246017,
	["settings-2"] = 109485777305919, shield = 106509993556171,
	["shield-check"] = 71867984579031, shirt = 128162112866809,
	["shopping-cart"] = 79435149356304, skull = 101060850237115,
	["sliders-horizontal"] = 125396339381135, sparkles = 105634041692696,
	star = 72669221096319, ["swatch-book"] = 70990631477660, sword = 121406454377051,
	swords = 99199363807265, target = 121091323240554, terminal = 102379915564176,
	["toggle-right"] = 129483325318573, ["trash-2"] = 126010725826757,
	user = 114567720540659, users = 85332511060401, ["users-round"] = 103880524805720,
	video = 99411215690870, ["volume-2"] = 129861259578431,
	["wand-sparkles"] = 115623066336607, wifi = 104941258142372, wrench = 85345725497834,
	x = 116396312853810, zap = 109718589733073,
}
local function icon(v)
	if type(v) == "number" then return "rbxassetid://" .. v end
	if type(v) ~= "string" or v == "" then return "" end
	local id = ICONS[string.lower(v)]
	if id then return "rbxassetid://" .. id end
	if v:find("rbx") or v:find("http") then return v end
	return ""
end
local lib = {
	ver = "1",
	alive = true,
	theme = THEME,
	themename = "Pearl",
	gradient = false,
	gradientangle = 0,
	_themegrads = {},
	_themeswatches = {},
	_themeeditors = {},
	themes = {
		{ name = "Pearl", accent = Color3.fromRGB(255, 255, 255) },
		{ name = "Violet", accent = Color3.fromRGB(170, 119, 255) },
		{ name = "Ocean", accent = Color3.fromRGB(80, 156, 255) },
		{ name = "Rose", accent = Color3.fromRGB(255, 91, 158) },
		{ name = "Mint", accent = Color3.fromRGB(82, 224, 159) },
		{ name = "Amber", accent = Color3.fromRGB(255, 190, 83) },
		{ name = "Ruby", accent = Color3.fromRGB(245, 78, 103) },
		{ name = "Ice", accent = Color3.fromRGB(83, 220, 240) },
		{ name = "Twilight", accent = Color3.fromRGB(161, 105, 255), accent2 = Color3.fromRGB(79, 179, 255) },
		{ name = "Sunset", accent = Color3.fromRGB(255, 90, 149), accent2 = Color3.fromRGB(255, 185, 78) },
		{ name = "Aurora", accent = Color3.fromRGB(72, 203, 255), accent2 = Color3.fromRGB(92, 244, 154) },
		{ name = "Candy", accent = Color3.fromRGB(251, 113, 207), accent2 = Color3.fromRGB(170, 122, 255) },
	},
	themecolors = {
		{ key = "accent", name = "Accent" }, { key = "accent2", name = "Gradient Color" },
		{ key = "bg", name = "Background" }, { key = "side", name = "Sidebar" },
		{ key = "panel", name = "Panels" }, { key = "head", name = "Headers" },
		{ key = "line", name = "Borders" }, { key = "glow", name = "Glow" },
	},
	icons = ICONS,
	flags = {},
	keybinds = {},
	unloadhooks = {},
	conns = {},
	wins = {},
	dir = "yall holy",
	game = GAME_DIR,
	autocfg = "config",
	autosave = true,
	sound = false,
	tone = "Click",
	tonelist = { "Click", "Bubble", "Soft" },
	notices = true,
	noticecap = 5,
	hotkeys = true,
	watermark = true,
	hidenames = false,
	title = "menu",
	logo = "",
	scale = 1,
	mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
	opener = false,
}
-- game.Name can be a stub ("Ugc"); the real place name arrives async and the folder is only fixed until it is first used
_gameNameSetters[#_gameNameSetters + 1] = function(nm)
	if lib._gamedir == nil then lib.game = saname(nm) or lib.game end
end
local TONEMUL = { Click = 1, Bubble = 0.82, Soft = 1.2 }
local function conn(sig, fn)
	local c = sig:Connect(fn)
	lib.conns[#lib.conns + 1] = c
	return c
end
local function safe(fn, ...)
	if type(fn) ~= "function" then return end
	local ok, err = pcall(fn, ...)
	if not ok then warn("[ui] callback error: " .. tostring(err)) end
end
local bound, reapply = {}, {}
local function themed(inst, prop, key)
	bound[#bound + 1] = { inst, prop, key }
	inst[prop] = THEME[key]
	-- UIGradient tints images/text too (and the whole canvas on a CanvasGroup), so only plain frames get the theme gradient
	if prop == "BackgroundColor3" and (key == "accent" or key == "bg" or key == "side") and (inst:IsA("Frame") or inst:IsA("ScrollingFrame")) then
		local g = Instance.new("UIGradient")
		g.Name = "ThemeGradient"
		g:SetAttribute("ThemeKey", key)
		g:SetAttribute("BaseRotation", 0)
		g.Color = ColorSequence.new(THEME[key], lib.gradient and (key == "accent" and THEME.accent2 or THEME[key]:Lerp(THEME.accent2, 0.035)) or THEME[key])
		g.Rotation = lib.gradient and lib.gradientangle or 0
		g.Parent = inst
		inst[prop] = Color3.new(1, 1, 1)
		lib._themegrads[#lib._themegrads + 1] = g
	end
	return inst
end
local function mk(class, props, parent)
	local i = Instance.new(class)
	if class == "TextBox" then
		i.TextTruncate = Enum.TextTruncate.None
		i.TextWrapped = false
		i.ClipsDescendants = true
	end
	local b
	if props then
		b = props.bind
		for k, v in pairs(props) do
			if k ~= "bind" then i[k] = v end
		end
	end
	if b then
		for p, k in pairs(b) do themed(i, p, k) end
	end
	if parent then i.Parent = parent end
	return i
end
local function corner(p, r)
	return mk("UICorner", { CornerRadius = (r == "full") and UDim.new(1, 0) or UDim.new(0, r) }, p)
end
local function stroke(p, key, tr, th)
	return mk("UIStroke", {
		Transparency = tr or 0.5, Thickness = th or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border, bind = { Color = key or "line" },
	}, p)
end
local function ns(pts)
	local k = {}
	for i, p in ipairs(pts) do k[i] = NumberSequenceKeypoint.new(p[1], p[2]) end
	return NumberSequence.new(k)
end
local function grad(p, rot, pts)
	local g = p:FindFirstChild("ThemeGradient")
	if g then
		g:SetAttribute("BaseRotation", rot)
		g.Rotation = rot + (lib.gradient and lib.gradientangle or 0)
		g.Transparency = ns(pts)
		return g
	end
	return mk("UIGradient", { Rotation = rot, Transparency = ns(pts) }, p)
end
local function pad(p, l, r, t, b)
	return mk("UIPadding", {
		PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or l or 0),
		PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or t or 0),
	}, p)
end
local function vlist(p, gap)
	return mk("UIListLayout", { Padding = UDim.new(0, gap or 0), SortOrder = Enum.SortOrder.LayoutOrder }, p)
end
local function shadow(p, oy, tr, blur, spread, z)
	local ok, s = pcall(function()
		local sh = Instance.new("UIShadow")
		sh.Offset = UDim2.fromOffset(0, oy)
		sh.Transparency = tr
		sh.BlurRadius = UDim.new(0, blur)
		sh.Color = Color3.new(0, 0, 0)
		sh.Spread = UDim2.fromOffset(spread, spread)
		sh.Parent = p
		return sh
	end)
	if ok then return s end
	return nil
end
local function softshadow(parent, grow, tr, oy)
	local ok, s = pcall(function()
		return mk("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, oy or 6), Size = UDim2.new(1, grow, 1, grow),
			BackgroundTransparency = 1, Image = "rbxassetid://5554236805", ImageColor3 = Color3.new(0, 0, 0),
			ImageTransparency = tr or 0.5, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(23, 23, 277, 277),
			SliceScale = 1, ZIndex = 0, BorderSizePixel = 0,
		}, parent)
	end)
	if ok then return s end
	return nil
end
local function lbl(parent, p)
	local d = {
		BackgroundTransparency = 1, BorderSizePixel = 0, Font = Enum.Font.GothamBold,
		TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.text,
		ZIndex = 6, TextTruncate = Enum.TextTruncate.AtEnd,
	}
	for k, v in pairs(p or {}) do d[k] = v end
	return mk("TextLabel", d, parent)
end
local function img(parent, p)
	local d = { BackgroundTransparency = 1, BorderSizePixel = 0, ScaleType = Enum.ScaleType.Fit, ZIndex = 6, ImageColor3 = THEME.dim }
	for k, v in pairs(p or {}) do d[k] = v end
	return mk("ImageLabel", d, parent)
end
local EASE = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local FAST = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local NOW = TweenInfo.new(0)
local function tw(inst, props, info)
	local t = TweenService:Create(inst, info or EASE, props)
	t:Play()
	return t
end
local function tsize(txt, size, font, w)
	return TextService:GetTextSize(tostring(txt), size, font, Vector2.new(w or 9e9, 9e9))
end
function lib:recolor(key, color, silent)
	if THEME[key] == nil or typeof(color) ~= "Color3" then return end
	THEME[key] = color
	for i = #bound, 1, -1 do
		local b = bound[i]
		if b[1].Parent == nil then
			table.remove(bound, i)
		elseif b[3] == key then
			b[1][b[2]] = b[2] == "BackgroundColor3" and b[1]:FindFirstChild("ThemeGradient") and Color3.new(1, 1, 1) or color
		end
	end
	if not silent then
		self.themename = "Custom"
		self:_refreshtheme()
		self:markdirty()
	end
end
function lib:_refreshtheme()
	for i = #self._themegrads, 1, -1 do
		local g = self._themegrads[i]
		if not g.Parent then
			table.remove(self._themegrads, i)
		else
			local key = g:GetAttribute("ThemeKey")
			local color = THEME[key]
			local finish = self.gradient and (key == "accent" and THEME.accent2 or color:Lerp(THEME.accent2, 0.035)) or color
			g.Color = ColorSequence.new(color, finish)
			g.Rotation = g:GetAttribute("BaseRotation") + (self.gradient and self.gradientangle or 0)
		end
	end
	for i = #self._themeswatches, 1, -1 do
		local s = self._themeswatches[i]
		if not s.stroke.Parent then table.remove(self._themeswatches, i)
		else s.stroke.Transparency = self.themename == s.name and 0.15 or 1 end
	end
	for i = #self._themeeditors, 1, -1 do
		local e = self._themeeditors[i]
		if not e.parent.Parent then
			table.remove(self._themeeditors, i)
		else
			e.preset:set(self.themename, true)
			e.gradient:set(self.gradient, true)
			e.angle:set(self.gradientangle, true)
			for key, control in pairs(e.colors) do control:set(THEME[key], true) end
		end
	end
	for _, fn in ipairs(reapply) do pcall(fn) end
end
function lib:settheme(name)
	local preset
	for _, p in ipairs(self.themes) do if p.name == name then preset = p; break end end
	if not preset then return false end
	local tint = preset.name == "Pearl" and 0 or 1
	local colors = {
		accent = preset.accent, accent2 = preset.accent2 or preset.accent,
		bg = Color3.fromRGB(6, 6, 8):Lerp(preset.accent, 0.02 * tint),
		side = Color3.fromRGB(12, 12, 15):Lerp(preset.accent, 0.025 * tint),
		panel = Color3.fromRGB(11, 11, 14):Lerp(preset.accent, 0.025 * tint),
		head = Color3.fromRGB(15, 15, 18):Lerp(preset.accent, 0.035 * tint),
		line = Color3.fromRGB(52, 52, 64):Lerp(preset.accent, 0.45 * tint),
		glow = Color3.fromRGB(150, 152, 175):Lerp(preset.accent, 0.8 * tint),
	}
	self.themename, self.gradient, self.gradientangle = preset.name, preset.accent2 ~= nil, 0
	for key, color in pairs(colors) do self:recolor(key, color, true) end
	self:_refreshtheme()
	self:markdirty()
	return true
end
function lib:setgradient(enabled, angle)
	self.gradient = enabled and true or false
	if angle ~= nil then self.gradientangle = math.clamp(angle, 0, 360) end
	self:_refreshtheme()
	self:markdirty()
end
function lib:_getthemeconfig()
	local colors = {}
	for _, c in ipairs(self.themecolors) do colors[c.key] = "#" .. THEME[c.key]:ToHex() end
	return { name = self.themename, gradient = self.gradient, angle = self.gradientangle, colors = colors }
end
function lib:_loadthemeconfig(cfg)
	if type(cfg) ~= "table" then return end
	if type(cfg.colors) == "table" then
		for _, c in ipairs(self.themecolors) do
			local hex = cfg.colors[c.key]
			if type(hex) == "string" and hex:match("^#?%x%x%x%x%x%x$") then self:recolor(c.key, Color3.fromHex(hex), true) end
		end
	end
	if type(cfg.gradient) == "boolean" then self.gradient = cfg.gradient end
	if type(cfg.angle) == "number" and cfg.angle >= 0 and cfg.angle <= 360 then self.gradientangle = cfg.angle end
	self.themename = "Custom"
	for _, p in ipairs(self.themes) do if p.name == cfg.name then self.themename = p.name; break end end
	self:_refreshtheme()
end
function lib:_themebar(parent)
	local pitch, dsize = 16, 12
	local width = #self.themes * pitch
	local bar = mk("CanvasGroup", { Name = "ThemePresets", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -46, 0.5, 0), Size = UDim2.fromOffset(width, 18), BackgroundTransparency = 1, ZIndex = 8 }, parent)
	for i, p in ipairs(self.themes) do
		local dot = mk("TextButton", { Name = p.name, Text = "", AutoButtonColor = false, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, (i - 1) * pitch + pitch / 2, 0.5, 0), Size = UDim2.fromOffset(dsize, dsize), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 9 }, bar)
		corner(dot, "full")
		mk("UIGradient", { Color = ColorSequence.new(p.accent, p.accent2 or p.accent), Rotation = 45 }, dot)
		local st = mk("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 1.5, Transparency = self.themename == p.name and 0.15 or 1 }, dot)
		self._themeswatches[#self._themeswatches + 1] = { stroke = st, name = p.name }
		dot.MouseEnter:Connect(function() tw(st, { Transparency = 0.15 }, FAST) end)
		dot.MouseLeave:Connect(function() tw(st, { Transparency = self.themename == p.name and 0.15 or 1 }, FAST) end)
		dot.MouseButton1Click:Connect(function() self:chime("click"); self:settheme(p.name) end)
	end
	return bar, width
end
local EMBEDDED_LOGO = "iVBORw0KGgoAAAANSUhEUgAAANwAAABkCAYAAADtw16ZAAB1PElEQVR4nM2925Mc13kneG55qWt3A+gGARAQCJmQRFgc2xxZ1sUyZdF2zIzljd1Zxv45Ip/2YV/2dRzzvA/WxEZMeCZ2Zy17aFmybuZYlgRKIkUSJEDcGkB3V1VW3s5l43cyT+bJrKpGg6Q8cxCNqsrKysxz+c53/330L/7iL/j169fp+fPnaZZl7Ny5c4wQwmezkJ4/H9I8z1kQBJTUbWtri4RhyJZLTicTQuZzQqQ8MGfOnFFKKZOmKZNybAg5dD8hQgj7+yzL9GRSmkePCCmKwuAvjmMthFCLxcJcv35dX7t2Da+G9Nqrr766cuy/ZzOmfZxXXnnF9u/atWv2dXd3l6ZpyheLBdva2mKj0YhhXDAOSSLoqVOccl79YXyFEAzv8duyLHUURVprbZbLJR2PxyRNU4qxVWpoyITYQR8Oh/Z7nIvv3LNIKQ3+Dg6EiuO5zrLMJEliRqORPjg4MFevXjX7+/v2fIwznhnP++abb9IXXniBvPPOO/TOnTF99llC7t27Rx89ekSFEPrcuXNmd3dX47f43UeZj2984xv01VdftcPY+8qtM/Nxz5ObI9defPFFtr+/z8bjMR0MBnQ+nzOsf6z5NB3Vc5VQrHc0vJ9Op8TNE8Ye4+zGnvMlJXZyCMnzXDPGlJRSPnz4UGPsv/Wtb5mXXnpJ03/37/5dEIYhT5JEjEYXxNNbhuvRiFNKRRAETGvN4zhuHjQIAlyMliVnOFyWJRYL/lSWZQTnKqW0O78oGKU0p8YYQymVOIbFlOe5KopCh2FYFEVRhmGo0jQ1N2/e1Ds7O/b3PuG98sor9j2lnXH7Z29YLP7z+MTmFi7G8/z585wxzJsIhsOhMMYIpQLOecnceEopMb5iwAespJQGgcEEKixwSik1oTG0oJQxxjB+RVGg/50BkFIqzAnGHuOKsad0KKWcF0qpMggClSQJxlnt7+9rEA1+54gOz+wvvCiK7OILw5DeupUyQh4SEPXBwQHuobBBYn78uXkS4vtGPX793/rHP47NFdfDHPmE5jbEg4MDdvHiReY2RKWUnavJZGLnCesb52EjdOscx/I8p4Rg7jJ7PcwJXrH+8ZrnOQjRYP6wvtM0LaIoKg8ODhRer1+/rsRisRBbW58UV66cjRljMQuCcBhvBXFMQ9wc3MxNMl6VYjJmXKmhAlFi8YSEkAjfj0YjPINhjIG4iZSEDodGGzPSWhdac65JWWJhYOLyLMuKJSHpMBFLOqJyPp+rixcvkps3b5Lbt29j97Udw+Ri4DCA6GNvzaHTv3YqxH39yetPpCO2nZ0djJkAkQkhQq3DmHMzYCyKBgMRaM04IZIIERulNOdcB4wxHijFOI+U1kZTKi3RYgz5kIOI7ISCGAgRIDJCqXJzUmLjGg6H2AhlloFgg7ws9RIbsZmZQmyJ4ujoCMRFJpOJmc9fMFeuvG6vef/+ffb0008zEBk22CRJ2HA4BIGLc+dCRsg5LCLMS/HzxcJkd+5gwaLPK5vi/yjtG+2muCJ5YHO5evUqK4qCj8djPhwOQWxBEASRECKmlIaURhhWSCCca84VswQJxmMZByGhgQiCb/GiNReYs5jHajgcltg0B4OBHI/H+Ww2k1EU5YSQxXQ6Lei///f/fhIEQbh76dIg0sFoMgmHQTDYCkMGDoebhrhoRe1aUMok55aoBNWUSWZCZkzADNOaakEIizQ1JZ4A61RrXRpjpDFGS2OULkslCcmJlHgILJZ5WZaP0jTNpJTlnTtaKnVbgQ37Iow/oE/I7fzfPhFh9ndjv/mTCELLsovs3LkFu3LlSpjneYRxi+N4SAoy4oNowBgdBAEbYHLxRwjH3IGTCcaM0BqSG8VBK45U3RNWwqCUckJwiFCtNSWEaWPQL2OoNgV+Yxg2apVrXRZlWWZlSR5qnS+Koki1Hi+1PizjR7GaT+Y+l2OTyQS7oxiWQz5n8wCMFsSOhZdlmVgul0UYhmY+n6dSyqQoCsyrWjc36zhTLT6ucLFfl6qw7h6YK3C1nZ0dfAdCC4LgdDAeaxHHscgyM4wiCCIBmEfIOQ+MMQEmBK/GmBA0CQbDMRPK8p5CU12SQlHCSVjPjVRKZWVa6kIXkPiWWZZleW7n4fDGjRupCE6dCnfjeHsi4nNC8FOj0eRyHMcXg0CMOGcRZWxACbODEkVEGAJiI5wSOiCE8tAYQSlhWMt4HkrxmSqtieEcBEc0IVRporUxJsMfIySRUt2VsrhdluWtojA8jpeJUmohxGxJyIgSsiv39/exoKHX2YHrE56Tzx9DeCfWC/zFUXO0tef1d8ydnR2+uzvgUu5xbG7T6RSsfiSE2BHD6EIQiEtxHF/hnJ2ilA6NISBAOyKUEixuSghllBJhKMGIKexVlDKCsdUa42u0wVAa9JcoZeyZ+CU2LonJNsYcKBUdKaUOldI3lQrfklJijEulRjohMdkZC6ur4/mDACIutzu8ilQ4FdNYKT4gxIyCQEywZ2xvnx6laXqfc3770aNHMgxDcDgQGsbB7gLHtf+exHbt2jX68ssvk9dee43euXMH0hgYBxhJsLPDQyGimHM+3d0dnKGUnuOcPxME0VOU0oGhJmCEMUOJYMRuhKJeargHpqw0hkgSgacQTSk2Pl0oZaQMpY5VmYVh+EAw8SgMw1uHh3d/ATuHOBUEsdZ68swzn/i3p0+fehkXpoyOKKHCLQbspvWaxsKob1gvZGNfDWWQPIlbRK7V0iiIsVrEtS4HsSg5ODj8tmDiNcZyTUhwaEwQTKeQhSPsCmQ32ZX7pCI67KYYQF+8XCG86o6b5oM+4aStXQy+HoBr7u7uwiAS5Hkk9vYYlzIcUhpOBgN+Ooqi81qTf7G1tfVn0+n42Q+jf/rGmfZY+3h4DwZHCMUBbYgpKaFcyvIXt2/f+z8IkTNjTDIYDFQQSFaWBqKQU/55EARYSCGlNAqCYByy8BQR5LzW+uxTT+39fhyHn3nnnXf+T0oH2d7eXnJ4eGhFKYiUMLZhM3Qbob9hbRhT8usxfmFdWcmnM0dof/7nf2452+c+9zmIy4HTqTnn0WAw2AqC4JIQ4qIQwRd2dnb+VAgxrUedYkTrUcZUm+ZGIAlseG3ThBJVT5b90hhTEkJSaFh37tz5v+7evftWHMeBKHhBd8e70fzw6OenTp0qB4P4AnZMQrCrErupEqIZXuy2yBiOGU0gxVScz94OX2p8XR3AebX4Y+xXxm7TliCwPEIRjnZ2tr9ycHA4U0bNowiDkOuiCCAacVjvyGWSJTd25cHBm2ZnZ8feyxHd+mGvVmCtcX4YS1ZzrG/V8hs4G27w9NNPW+6ABTuZhIExUTgakcFgEEyDILjAGLuyvb31B+Px6FmiicQY1BtU1ep3Vi+1e1nvRtUMeB8aW1Q1lpVgQTDK7ihjZCClXMxms9cIJxnncTCdxgJGMRhOoBrAmlYUD/loNOJ4dsbYgHM+xMYfivATUusXdnYmX5pOJs9nefYgjoeXmGE3iqJ4AOUcxq87d+5YA9hJGojMEd036tePi/Ccbu2mzic2zNN4PIbIbI0iURSFQkzCKKKhEIOtKIqeDkX4G0EUYFP8kyAItiAp1Lu2fT5WLWjYHWC8qqegGnHdfg9lDhsXPrt+Qcyczmazm0dH80dbW1vx/v5+wnjBoUdkpS4/uHv37v+dZ/nMXkBBH9QUOryqtlECxUEpRZVRFAtHKw0dg+Ecrapzqz8rz1oOQAyIVUMJZ8oYEC7WFq6hwjAcb29v/3EUxf9yMAg/MRwOdweDwc5oNJpCLJtMJvGzzwbB1atX+ZUrV1i90O2gHkcQ1eNabtoQE1Qe/1j/ezSfa/oN93N/u9crMdIRmx6Pxfb2NnbL8WQSnBoOp3thGH6SMfH5ra3t/3U8Hr0AIxGkjppOqPtX75K0EQNM7w8bWUWgGMf2HOgL9k/bv5aINZdSzWez+X+RUr89jKIsiljJCmatkLC0geC0PgrieAc7/SCO4+3hcHh2NBpdCcPBc0zwPzx1euffTqeT57FrQ38MA7HHw3Ac0Sg4deoUdCDrPvr617/emYNN4+faqz0iA/Edpyd/GO6PhnUCCQSuGRDb3t6eNWDFcRzv7MTjwWCwt7U1vBIE8fNBGP3J1tb2/xIEgfVrQWOqxt9Ua1xrqnRloHJrH+K8FekrGsBfZbKEMg35Ev8RwpfL5bt3797/D5Sym4QEMHrBVK1kURQLrfWRUuW7Dx8dvLa7e/prgQhGGhqY3Xi7m3Kno8fZCN13lgu77bzezClFZ1QUhae2trb+p9nR0RhfCyEKGOFgioWbAB2GHwoeBmfWdibtvmj5pBNzktY3jpBrtkf88PAwOH36dDDWWkTDYURpOA4CcjaOxVOU8k+Nx6N/NRoNn9FKWwNIM0beWHVETLenNnsrdg1/YOsvO4cMZHW7POA6kFLm8/ni+0rpX3FOH2mt53Ecy9SkEONhALMW5yiKsCNHWvNJEPDTQkRPEaIuC8F/bzKZ/EEYBhOttGQcOrm1okRKq3gZkiDUIR8MBtZvCJ/durFeJzo7Ynv1Y+Rs66zFzqcMsz/nXIDY4GmBCBkEwTCO41OMBU9Tyi5FUfjF6XT81SAQVqyyG597Ol8vwqC7Ndxd7xT8zDI9Su1sYQ/nnImiKI4ePnz0/zJG3qFUPxgwUSyF0DBtScYYTPSwFn6Q5/mPDo9mfydxHFr7Gl3GH1DcpeEilZTb/h07YpX0pzWRcRSeGY3HX+M8eD6KhmfiWGxVHGMyGo1Gw/FT4yhN0xBcBdzFDS75NTef2CaTiTXVw6oFKxeITQgRERKNKnGMbMXx8Clj6MXxePiiJTYYMjBCDRG5vq8fnMr7U4uLFT+rVAfT/Z0TcyotA/o1hbFGLhbJj7XWbxFG7lJK71MaQocwURTZDQ5EaY0GOoAYCcPImSiKzhKingrD+Hem08nXwlCA2BSrjQOEVL5TxhjEMJFqLeAAzrIzznm+luh+He0blht2pZK+a+batWvwIXLOz8M1E87n8wEWURRFo+FweCoIgqfDkF8eDuPPbW1NvoLhaIjNH/dNLvlGw7fzArmjWe2wbMElXZZlfnBw8D0t1btlWT7IMnk4y2cSDnGR5zlMmfC7pmVZ3glDSbI0y47oUbC9vf1ibRxZ5WP18XZDbtXLzmn2uSA/1R8csWIq7cmaKW3UaDQ8Y4z5cjJf3I+i6H34SeBAtL69RWSm56fw7ENvKm7dutVYL7/5zW92dLqTcLx+e5y+BmKbz+fWmR2GYbCzE4ZCjKzfMopEjIkkhHySEPKb0+nkD4fDwfPW0mhIZUnyOVclRHb0NreAnIZmXzvczt9xDUQW93iWs8EUvVgkP9Ja/QMh9F1q9PuGkAVjqqh84SoAV0OQAvxJLGSDQA9OC8EvGiWfGY3Gvx/H8ZcQ76IgP3lbBMRexqjCcgLNDjln0orC75ErV67YxQaL5Uk5nd+ejNtBV8Mztfpan9hee+01hgiS8+fPB4wtg+l0B3rUOIqiKaV0JwzDpxjjz0VR/NXxZPw7gvNIG+hHGx60sZX0OFtlOGkZizMfVlLGcjab/1WZlz8upPogTdPbZZk+kjIosZ7haZdwQCulEhjfkiS5o7V8N02X35/N5j9p9tn+ruIR2LoNwZ1ecT2rQR3DASvxcjQaPjscj/6YMfHpOI4vCBFtCSFGwyGD+TZaLpfwCQpYBkEEvk7nrrTJOe0+u7/jprbR12qzP4it2Nnhp0+fFltbW4EQWyCygbXqheEZxtglSsUnJ5Pxvx6Nhs/D7whdtpk1b4C6emWX23WHpyJK3+RbfdFc1hFbsVgkPzBG/zdK6duGkRuMsX1CwmXlKggMYzHM2nC+Txlj21qz00Kwc1qr5waj4f88Ho/+gFHKoX2A2FhnZvD0zHLdELbMmooQLjafz48lmI+L0xk7Zuu/84MOPv/5z9OjoyNY/cMwDOHIHoDYhBBn4zj+RBiGz0RR/OXpdPoFzliIjX6tQuTWK63u29y7v/lZymANGUB3m88X387z4sfKgNgW95RSjxaLRWLMMofBSdhYr8uXyyhJMijVYMdpmsbj4fjmcpn8kHMWTqeTayAIp3/Vd7Ou15YPm1UTvdUr68/uvXtWt0PUz28NCIbo4Wj4W8YYBWdhEOglYxGsYiWiHc6cOSOhO+HK8/kcjtvGieubp48juk3H+yIq/Devv/66NXQUxQ4PD0yQhyLc2xtFUsoB/GlxHG8JEX7CGOPEyKtW8a6lw2q43PZX7Yq+hFgf3dDcuFXndKyYIDZeeboXiyXEyDcMJR8Yre8YrQ8VIZkQRBZFCHq1agEc8ZyTiTFsRAXbIVp/ZjQe/dlwED+LucUDw9hlrZ71bRrCYzZ8iRLSxtRevnwZ8YiQMI63HJ+A0z1pzKpr/qaI6BGYAE6fPh1C1A/DcEACMgp4sC2EeIrz4FIUxV8Yj4e/xzmDGQtjY8mltfJirHsbnHtjpZJ2/2znojIDgvsfHc2uL5fLn0tZPsqybD/L9MMsSxNClrnWDGJmKRDREc/neqEU4r1yIcRCShkss+Lt8TiWSbI8EpyT4Wh4rTEAdG7YyEnVEqtpry9g2q74up8/EfZtpY/ATj0aDX/HGL1USktEXyhFWBhKu3DgeEWDMeXpp5+WEC9r0cYS3YcJN+qbksE9X3/9dcSF1pZFaa1cURQNy7Ich6NRzAhcmPwyIfQ3x+Pxi8Ph4LNYuBVZVPJyJd47ccSaJb059MTrNc0RrH3vrwFjbOwe1IDFYvm6VOU/cibepUTfKLV+EARBkudGKpWTMBzbWFdj8ljrYJsxs0cpf4oZ8unxZPLHYRhetPoLdud2I11RIKgBi+MG4UvYlBG4vr+/jzHCgiePM2J9GKIzj+GOPrFBt3dGLEdsYRhOBInPhCHcXObTYRh8bTwe/hakAnAiRhksvK343rIM/0NDXQ0p9iQOxq0bgM1m89eXi+QH2qh3i6J4N0mSu8aUR/O5TsuSZffv3y8QiyoQNRCGIZyZ5Xg8xk4I0/HMmNKkqTFhOKDz2eL7hNLd4XCwZ4kO+2AzHu22W730LWurg+gGv5mIenUxyuCvwzOw0Xj8eWPIUVGUJORG83Col0Vp8IyI0p7NZggWRQS7uX//vtnb22uCch0BbSK8TQYXR2yEvEDu3/9/2Pb2dm1n2A6EkDFESGPENLZGkvAspebyYDD849Fo+CmMS1cAbDl4FYXVGh+bYav07prb96yQNTfsCTx2bDRithbJD6WUP+Oc3dBa3tJaP6SUWmILAmy74G4lE0IPKA0R4QIdeZcQ+vnxePxHYVj5nFyUkHu0/sBYVbPWNKsjIdna0jSKniZP0qq5Jo/1j24itH5cJIw1tVvCBoDv7e3BUhLV1shRGIbbQcAvUkoux4P498aj8e8IwQ3cXVb8g2PF63Dnrv0Nx6lDLYNw84ajPEmWbyTJ8vuakJtSyvcype4YYw7TlKaEJDnn0Eh2JLJhBIKEz58/j7gvs729jUhnu4sFKtBkBOuUQqjWZD5fbFNKvzoYxKeseNn1FlQ06A3WOr2u06H6JLvRN95qy54ZBoUzFo1Gwy9rvVDw2sOoM+BGFwWyUZQG4Q0GA/gQcTWFIFyf6HqTc+x26XRBNJi6x+Mp3d7+TcbY7WA6nQZ5nkZCbA+FoFPO+Q58Nsaoi+Px1pcGg+hT1XhYCaW7nrxl2pko+94JCr4BZc2Sb5Vkw2glRiZJ8sOylP/EOb9jpL4jtXlkOE2x8ggpEB8OYw0zhsdhyE5TSs9qTU4zxn97PB7+seBiCqumlagc4YMj+7pJ+wAYUxi/7VFkNOQIJrNZQvMm1eckzXR2nCdr4Jzf/OY3mdPXvv71r5Of/nTOL18mCNUKgyCIobMJMRjGMYfedg7umcEg/t3xePS76BvEyMbGbx/DE/f98V7T+i4cbIcwQC0Wyfvz+eIHWuv7Uhb38jx/kM5mcxiy8nxWLJdLMDL1rW8dmJdeumYE8s9wG3AKN3jgIMFOoKIy0oQsCecDqFjlbLFIGGN/EkXh2UoU8WXE9mGa56o75XfIMUf7PxZddZJddNDY68aMNkg7gRP8pfl8IQ0hcwicLiUCqS3YJPCsOzs75MKFC/AnNhfwF4JPeH3xEa8VVyONCLmzs+TDIeFSTuEchgI+jCKxTWlwJgjo08aQTw2H4xfjOP4sXJ02Wq0mNpgXbERJZcBudx6nr/bmtI1pqEfH5wL+6FLClFFlkix/XJbqTc75XUX0+4yZB0SrhJtIapNbfxvcBEKIISF8xzBzjmj9SREGXxwNBr8L8z4xGukGcPD6C6i76FrBxXqnIPlggUnpfBLtuPlj3Rcr3WfHoV6p35/Umtzzs5E6I8OmEP32+YIvo0k4RHKgMSPGorEQfFuI6Cxj9DNxHP2r8WT8m/U2CJ9yfS0oLpWmWm12jrNu4L59/1ulQ8PWcSNJkr8mWt6wMcHL4pYm+ijLaKp1nkdRVCRJIpHa9NJLVUoTw3/4w6DBAIFk0DRNSyllkec5/Diz5bJ8VBTFTS3VT2az2d8hwh9Br6v7QWskqCw9XWKrn7V6Xaebuo5Xi9Xu5lEUjieT0ZeoYBcZY09FIjqNeDdYL5FOgbg4pFjMZjP+/vshBdH4Fky/bSI2/AYc0gUiTyYSaUvI0YiKgg4HYjDhnG+HoThDKb84GAz/aDIZPV9FjnpisZ3Gmticgt2hLkdhXSpsf48f0pUBgcQByyfEyLKUP6bU3JVS7WtjHiLxjTFWEFIiYM6a7iFWEULA2Z4iylwIguil8Wj0ZaQfYCND4F1HiGweZdXHVX2yeool5iAImxN8x/dxftF1RqxXHmMp3nQOiA1WariNzN4e3B2x0FgCw9EwDLYHg+A85+zKcDj8ynQ6/iwWaU1dnmlE+RL/WqbWyh8tsVkjAuaDM55l+b3ZYvFtrc37hTQ3six7L5PZvcPDwwWlWYZcOHIDhqtC+fmDzW7liA4JoCC6++I+8tNkkiS5lGmiMnVQlvKWlOVPjo5mf18UZYodr7M/12vJKZduafVHreJuHtE1jvNGLsbk2gmuiC46Nx6N/ogQ8wwP+dkwDOEumMJjwDlHRmA0nU7F9vYDmziJzGXshOuIDq1/HISK5EtYI6t0jO1oa2sLYU/T8TjY5jE/DR8OpeYTg0H84mQy+gzEyCoOuzIDNq0OK3PDgrhR3yXgKUXdCB6M1+qAYUCw8VAYSJSSr+Nxtda3rGM7V0utuU2DsgZqJgXyhQkh24yw88bI3xgMon89Gg1+hxlrAq9Eqspp29EzHcGveulJSYhRRiLoB9F5Gd6YBw9CxCmuHV/f9XIcJ3vlBETXTbGx4X12Uwz3wqAoingyCQcmsJkZW8EgOEcI+/RoNHhpNBp8AdsdorndkmtH1TECz0DSMfX31LhGcrGcnhd5kSwWi7/VUr8jC2S8ZB9UIqWcKaWWi8UiXywW5ZvFmwoqm98Pe3k/ns3lDlUZsYPg6aejEBEf0OPCMJzGQfwUC8RvhFH0ezvbW/9KCD6wiqi/emru5ndIu928M4zOstldeGvEUysvJ8nynTTN/qPW5qdKFfBxPMyyDAbWZZaJJIrK9ODgQJ45c0YDvgEip/MV1Ry8uaLjbNV3IzaZPGQgWq019IGhMQhA5ttRxE9zHp4nzDw3iGJYI38TIXO+ldEPK95oXetZwlb6vP4XiEGFpfinUqq/o9S8qxTZ17p8SIhYcF7lGVYbE/LqdEyp2GaMnjPGfH40HPxhFEcX4IS3fsGefau9UasoepY4O+Z5lt+ezRf/0Uj1vVzmv8yy7OFspo+EyNLhcChns5n2dbknsRC/0hM1NxlJnN6GmFo42cqyxAZrrcZIgYqi6EwYhhco5Z8dDOI/mU6nn7LpTP2g8Iahd3wza+hujSu8FiOLolzM57PvlqV6vSzzt8uyfD9NUwR1H820XrDlMrt9+/bGnEHW9/jjS7BApHOMx2mZ53kxn8+TPM8Py7J8mBbpHa3N27LMv3d0dPQPyD5mvHY7tStoRRdZx+m8M1r2XouUnS+qIFI4xq9EUfgHjJnLQkQXYMCI43g8FMPRcBiFiKhAxvXsFzNEhDTiZV+EdMfaJMyHwB1BoKtNNoSYMhjwLc450EfAKeAwhZ8NxFbngLW9aWP41zTfcVrLmKubTm8QqsUOMVInyfIflVI/IozcNIbdplTvc86PtLbpH2CxTCka8MhG+5+llHySUvqF0Wj4b0Bs1sIEg0c9Q1Y4bIxt1b92uFdnqJqNymBiTAX9MLZRr4R88MEHKyL6k7RXNvhL/fcVsU1sbCT0NqSPgdigW9fWyJ0wjM8zJp4Zj0df3tqafoohNr4n6rcdqonNSSLe3LhTuzaj+n9uo0gyEJuU8idKlW8Xhb4hU/kAYZFpmi7zhw+R/FteuXJF+jG/fmukIX+H8cVL2CeGw2Ge53mGrN88z4+Wy/m+1vpmnuc/mM3mPwaQisWB6AnFVX/rqWwS6PzutDpE5+g6LgGiI5bofisM468SYq4IIc4zxrZoRMfDIR0yxiKa0IicJwF0Op/ofEJ7553YHsf3k8lVy9mgr8HKhdhNrRmQY84Iwc8Zai4NBsOvjAbxc06MXHk0fwI7E9sOiB8A4LbPRqWrf+8pVlaMTJLlP0FnY4y+r7S+bYw8oJQCOkEHgfVdImMhFIKPmaZPSa2vcM6/PBoNvo6g8E6MYH1DSzq1tdSfha6fqatEUsoDTYmAdInosOWSWQAd8mtu12q98IUXqs+XLl2C6M+jKMJ8wSo5CXl4jhDzqdFo+IfDoQ2asDnPjaR0zFP6PKFerKvEVgWGU6OUmc8TcLYfaa1/VZblu2WZ7uc6hxiZILEbtg8EYxzH8W0Oj7vvNzw2X59ouR2cnJcuXZK1eT5xgClxHP+4KMpyPl9k0+nkd+FHQ/rCip/NRVzW/qZWeOktRP9hfCHa7cjKIOKdjEaDL8LHjHsjHc0Ydd8YiUQ0FkyDJMsEk4eUzGYx2duLzWw2JWfOZA0j+q3fstnOCAPinCeB1gNLcNvb2wOlFHxW5xgTn2CMPBuGg69AjLRBn5DjHT/rzUxnVJ1ssmKAaDl/d7LdwrC5g7BGysViCenhJ4yxG4qQt6lm+4QqZMzXwemUac1iSskOY+ScoeR8IMIvjQZxFbbUtyL3n3adUc5XWtqDEM1sALOdWJhjsoX95sKFC+bHPy7o7u7xIV4nba+swYnBJgnjDHBXsiyz4FZwBgohgJNwhnL+yeFo+KeT8egz2jRiJFthW71NphrznqzpvvAkAIyh3fzmyT8URfG3hNA381zdy+f5I8XUUVEUSxhGwJhg+9jE2VYIDnMDiB7iER1cBvUFADaDzsPUqXWiTblDqV4WwXBIRllGfsgY35lOx5+mmjYhYL5fx4U0NTJ1T5Xse/Lt554T3flSOOXI7/r8HFadolRccC61kXDeQ28b6sjIIVWUzvRspsxwKM1otFtDzSlr4n70KGCTiUbqBgLvLMGVZTlhLDgTcnpOGnIhjge/jwiSesHZXL/2aVr7Q3/x+jrCqpjSIwOnC2IIIAtZP1v6AynlT5kVI8nbqijuwQ8Jz0k1RNDXWMQY2VaEfIIYcjEMxAuDOPqSFTGxG/UUwyoJuOVklYv+eH2zbpoxKpEKaYww4HKA7gNMHETK557bNVlmg7s/No53rWfxdMaZKIoshONoNEK6zZCxYAc+tslk/BliU9Rq0bd1Sjdj3KosXe9btcY82cvb7B12VpIsf5IV2T9SSt5TSn5gTDmnhCIiCzg88LUht9NCPQ4Gg+a26/TZluA85d2JRrXfykbmp2kKWLvy4cOHNvs6yAjRMQmzTN9FKk2WZd9hjHJkNzeOcXfd6uIdJ4F735F3/DXgLe3GXA5rEUJyjNZC8GA0Gn15oeapRqgfNRkiMCgNdRxrhVg1OhxafEf8IdgW6FanT5+2IsLW1lJE5SCQMWA6wkhKOo2F2CWCXNDGXBoOhl8ZDKLPUmOQf1vNirchWueU42AdRbTvB+gZSLwu1YPui5FmsVz+UEn1OmPkISHkPUr1fYiRFWcLEF6F6BfomltEk4uEkatxHP9eFMXXrMBo3ZnNrtWMaaV4+qas9fTRNzSA0KjNPYbuWgK5zyyzzOI2EnIZYczWAe7pcb8WUTMMgReZsjNnzmBTAsENOGdnB4P4s+iuDYBqIkG6EeG+Ct01NawxRzaNWbyZJEl+mabpPzBibslC38/K7CjVOmVCpfOHc7jPOhCEjwsEWJvv5nE5a2F57bXXrBEF0QnORweEqOVSHxWFuSOlfNcY9cM0Tf/Dcpn+rOMu6Oh13u5uDSsumahjwvPHqm1dP5flBEiUHI5Hf0QpfSEIgk9wHj41GIjTjLExHcU2wBiJloPBwEL5gSvAwiWlBBzagIzJUAkxNUbsRhG7RAPxaWPo78Tx4OvDYfx53M5m9na8whuaizBvHtfTWX26XGuXsPOgFovk71Upf8gYe98Y85ZS6i5TLKmi/gUWvOVuxpgxpXTXcPrJ4XD4J4NB/FtgRLXBqc3Q6mxa68isIzo2z20fuQnDs1n6hhmgtXFLt6PRqAFEzTIbOLGRO33UvMU4jilC7OI4Rqid9eozhgguHjNmw9UQzN7dAFuZsLe2emPgjZEveTFaifZpmh6lafZzwfh7pSLvSCIRPjfTaTp/+BDcbaeMosjiqR4cXDEvvvhixw7S7wuMk62s6zV/R3bGFGdEybIMCFHlw4e64LyER/0oz/P7y2V+X0uFMJf/mqbZByC6KiqkXW3Vx3YwXEcd7/NNDB2N1//Y/g6p7SqOo8loNPyi1uZTQcDOMsbOcB7tcC6nMYuRdDhITToYDAbReDyOjTH4A1zdiNJoEmi+I6h5KuD8aUP1M1EUQme7Bgex87P1I0bsiy+jNCJLg57Qznv9Z/u4JmLBI7bvyKL8AWP0PaU0fG33CCFHmdK51gIiXaUZWoJjAD88N4jiPxlE0TMEOBxVALg3ie3MruiXzqBTYayscuaabqvuQTQ3gIizPmRA5rUn3iBxvJqA6qc4kY+Y9Pv+++/bz3Wki81a51wLZqC/shEh1BKcG/22Dy4lrP5bCcFYtWC6722kECNQP5aUkgea6DtK6Yda64QuaQ5mM5noIopmCqBKCCm8enWO0DPyONeIL1J2ZKHujtGIl2Cb9PDwEB2XR0fDIgim6WRCjoTgomSlEJH41Xy2+C5j9KtRFO3aYGdfp3ObsBOxm3yVnthVc4ZKkvRkI2d8qEcYnC6Oo22t9ZfTdLngHNBvECMjxBOGRpl8SIbKwAdqxbIQ2BSBEDoipJiEId8VXDytjL4SRvEXh3H0aWf65xbwqBdj2Bh9mpFqrKzVXtI89HrbTy9cC6+IxZOy/CFh/K7W+gNjNMTJhZQs10LJkBAjJQucv00IMyCanhWCP4VglxonprOWOq6I3jrrhPn4O3z9sE14mu0umDwRmmpkiSNhGTu/NV4hRSdJkibEy4mWH2c2/qVLl2ygOhoIDvK0tc4GDBtnWJkHVhXmNpVmNdqpOmfVUOLmxwuyB89IQWiESOBylrNiBpBXhXCt6XQK3c2cxA/pXG8Wa2+TWOmIzoP1xgtYJ7lx4wawI4rJhNM0nbIgAEa+AcByEUVUwHdHGfujMAieXpfW0+THuc46Vc3bXT3JwJFZA1/WnFJjowyHg8vGkK+nafr9gPN/0ESHipAEAEnI0+TwEkswGcWCgAmAOGlNEFGOfLbPhEH0L4dxdNk3rlZLrmMNWT9cHR2uF/G/ZlxZ5Q1jymgEIn9HSvUDwtgHRKvbWvNHhOgFYyzlXBWsCsUixpS8LAMahhoA6MC1jCuBoU7UWrE69kQpL9J93UO16VOeJbb6AkgbilILGAWigyvCXuHOnTsWb99vzh+3Lpa13/qLs8/d/O8chysKygYDBGbTEBAtNp3Ny7tc1xzRdYiv3RdXBqXh7hR4lNinke6kCiSQAuodUAngbD6xndTh3zGarH1Yj9M56yVuAFMoctPgGCdktgiCkS4WpCgjklMqeBgSOjuaxdPp9OthGIxX0noskVWL12dwfVuJO1breq3Y1IhB1b5UEV18AZwOxQoQZ6k1mRNOkwojkBMWaMotBKMBanTMA3LGGHIlDOPfHgyiZyDaOYnauQCaO3j6wNrV0xhQegTqE6ObXVah9C6X6WtZkf8wYsEtLfWt0tADSm3IXCY5L8KCWQAgpxMHAS4vOKU6oJRh7jpRZf59/Xnr01z7vL5YVb1hAEDsdAFqh0WDdiFkhJAhIBcJCnyAw7lWQ1E0BpTHGRCuHZO4iuZ8pfgDwbniGpTaRFhI6BgDvs4G0DDyOuppTchab39a3YmciQESD2MMPm2EO6IuxrEc3K870YeRcAR3YutSTXQWW/7NN98kV69etaIE0mWW5VJDcYNeS2mAt+F8ttje2p78geACBoyK6HqtK6K1tttqCHphcOuSGWtjoCFGjUeDs3Ojv1CW5XlC6LJyFDMJpkIN0lEMdkdBuRVJtoJAnIvjEMldVdR/fW23y1fE1t0/2/duMknnSZvJXbVJGEaYhV6bz5MflWX5PcHYHU31B4abh6YsE8Z4kSQowsEk8EWUDUguaRAE2DWoUAh1JULDO9KXw33DQLMG63D/WndriM/vjCe268aaTj2xCmMDVGEFXA4ZRYVO07ZijwuRg0uGfMh2zeNum86BsaaAJYyiDgMYLQuMC2X16KVyKbUD0xFAmsNOnHKKtv+dheiv5Wqm4eQ3RWEt3k/Sp3WYLT6H63fUbNLnfKKbTCZk/tM50Wc1sgvoaCQYQAaKwka5q1KWZjZLyq3p6GuciSFwM6oueUpNX2nvqkztITegtR7VKkrN9m0lweFweElp9TSsTW4mbISIM15U0au2VdBxVYbhWsCf4/Yhf+F6D1hbN1bOhkgEBIYkWb4ui+J7jNNbStE7nBtEkCzga4PYwnmoQqC3wMRqn9GaxE3MY0oCDT7NXVYT/us45Htikxsv993xwldPv6t+qw01OaMsZ1FUyDQt4ziGZc5+D+6DuFWf8J7EJ3dtjbjpx7n6zUKA2IENKv2cYNNBJml39foiZmc6e+vYB2byU3CwVqCjIgRYVxE1toBDX7cEB1/HxY9LP1ovkqxZZf0F5C6IwUVUNEryHB4eShSSyPM8SVMgFcmbWsv3iiL9p6PZ/PtSS1vqqlbIVlqz19gUleqT/b+XsbLygF4YD/Yg3CISIQsCgWBXvLJQBCzkAQu4YGEQUCE4DUMLj1KnQvG1vL6+rGclbY404UB9g5cfrtUlNusPRKbF3zPB3kHkP+fmUVmW86IoEs55yjnPw1BBZ6igeLGtwvYdjKXmcA8wjcIp9qJ1nJmvc61EU3imUv+RmglYI6F3bHpVrQNbjkUYA73FPg85pvXjV5+k7a9ZwOfOnbPEVo0tUoSsSC6qTqyG2vWbSxSrDF41x9u0oFbEUvRcWt9mvWHauoZvvPEG+TDtsTqcv0nUsBxNc45xOMIR/gXQ0YODA7ojdgjZrpJElVIfVBVKbHLkZDqdfA7WPwgkrU+uC7/oy9/uSJuw2hshN95dvQMhZsRVdPItT/ZAddziorQbiWcoaFwY/YHwsrU709wq5R2C9RgekrGTJP1+WarvUGpuS6Le1yU7oiFLKY2XnEuL6mS85huFtE5dVR2Ixw6Er/VX9LBl/Kf2+ZrPkduoC3/g6wFrNv/qwrayiEFIH5IESVNQ0v95XWATxUJM3+jxOMLa7RlbcA3H5dg+o3M2h4GmlvCFhvBkDCkrcaUrJDUHmtHx+t8srr6ppF2QThyt5sBubpbecKxGGjAo/3Vc24ThstHx3Wtuu+tsJ84xXg+Y9dHt7OyURBLEXJaz2QzR0/tFUbxtjHojy/K/WSws9oNL7m4cgc4RXrkMmoNeqJe/FVffNcaWnpBur+LYTEOP9fU9rrS+p14SZsPV2mt01vQacbdPbDbw1frZFt8ry+I7lNJ3KKVvMcRGErkspFyW5cISG7gaJIVHjySqZzZ/NXS2eyhgyAPJzIL/9Dla1xDgXnyts0ZGXxsg7nWoWXRVTzknCFi2xQlTkVrk5UePHtlXVyEX4iVeQSi+SNjP0HAE5v/Zg4QAEMouCfd7e+2zVeXd+rM2plCUiiWlDGAP3k7qNm+/v90xqXxya8aqhrpw9S8qPCwMry0XhkwBW5BxsVis9IM8QXNugZM3JIaaxovW4XQAJLp//z5M8HQ4HyIZNEPFSEoLsGIex3yMGDz4LyeT8e9W8lL1BI0e4lsvfbm8HbL6pSLGRp9r5DiPMDc4gtcRx3opyVOUfP3A7QMeXa4pxuHpbOkP8rz8gRDivbJUNxnTyNRewho5LHhRiq1CyiOI4/DxkC09NgdV9VrCjo7qIoBVQ549yjTUqa1VfRWfP9fj14l5scPUzbGvNdsut+6A5NRvDSmoMUV1Hcqw6BxcOkLlfC5Xlsg67zaf0CaP4Xo+oYF46/qE9OFDRqfTynpTNcR0Qkay926qZ7ST1U5OvZL8GWz77Ztua/3eH0cnf0KyqKrSDijnBX348GHTjw06HEoyf2iRcrV5kfC+jw5GFFQvvXjxolwubTFqQsgMcG3W/FeW+Y0giMhiAVMyjSeT4fOolQDwW4ui5He2FRQ6Y1nLh+2qaGwuFQ5Rs/h8+uuOt7eg6knpqwH+db2fNb9oA47XV73pipHfK8v8OyjoIGVxk3P2qChgjWQZ7MwkIKUsU0tsly9fVg8ePCCKKDKts+5mW1vMVNY/J2ZqWxKQ2PpkttURzb3bd5+7HYuK6ze+KboBJKe5hCkJYxbdi7FIDAbCOr5935jfccftQHyO433wQUAvXCit7uPOw3c4jnDMCx6hut/7IuvZs/C/2bK+NThStelA2na/c5ISXBore2eHzXU9co2w468Vj17hMy2VNpgqlBqunuksgoCayz8J8vcmgltd7b0uVHXj1lsuIeOm6W0ymZy3XA8ZBvVpd6tBBdEtDOYKSMUgukZG9O7cLnKH8+g/3spI2oH2d6iGONp9zV9IzYux87YGztrvcOfOnvK5ZmxcL5Jk+cMyz79HOb2hqbnJDHtUltQSG6IWyjIo7dIsSwVkJ8D9OdMzXlHpZguV/qqdH/4fG0RcR8JALFcrm0RPnKp3l5ViIj3I09bQ63Y1J7HbkyDF2sIedsFTCgCADP4xdnh4SLa3t+2wQ8R01zt16pRGhgmCnK9e3TV37jwkp0+fbqYHCxdBEwjRnpGHKOLSGUxbDpZzeurUKQO7AGMTlMAQ1ohrXQK0pJQAn6zZLp205KMO+qjkHWOBgyFsutwet68MaxzYlVaqsGei+g2gGQlB1B0hL+6/aL5JqnCuE4Ii2aqOm9q61dS56IqZtSNeXtH37v2j+uxnP2uRtWrxCgG2j5hhgYhEiPhBQslkNBw+sy5Z0snVa6wXXcVpZQdb95NqN19vX3NhZC4laB1rXOVma/TiZu4WyfK7RVH8NxHw21KSe0YXM2lMQohZFkWJMr6SUqmKolRlOdEPHhiyvV1lNriL4T3qjfkiZQWpwOtSuJ6V2dNV62rEbQ+88en3ro7dacN3nAzW9A01BVB2mgDj0kKfVsxHWLMuNoXlcgnsQmsoqcOv7GaMwAjoXuBsMKzpuiYCzgXH2NmpONjBwQ6ZTKrjHc65TUg+z1FznAYBIAJje01Ed1ojRlVxxE6srcHs/Ile/ZTuLHqiZM/w5QHItS4FlK6y8esGzk/EVlqjCSJMkHXy2vw1Svark31XwAZ7iTnOLbCprVzKv7i7YQXT8A5wRbBrQ/6Vt2/fRpYBCoYsiqx4UJblryg1P5svln+dZfltiwJmwxoaXNKTmXN6T9X/ib+xr4oavbznWvepSHzNzTvEtiKGYnashLJIlt+TsvivnNM3q0yK8mFZkkWe59Db0qokl5RFMQSb06gffOpURWguZw9/LrUI6Njwe5UltYGU9WPXttZNHfb2rjXjU6VWtkapTWNtE6gtDRCkBA3Kkozj2IzgckXGdRAEU0C+D4dDFDicaq2nUsoJvhuNRhMpBN6PlVITfAcw3SiK7F9dm2EynaqJlLI5jnM55yM+5yNKhwhrGS6XGhne8E7GmsE9yeGYtnEWPry+b+/yx6OVTDzxybdcr64N0DLMCrmUVWBplmV2frCB9DE5Twr792F0ON9GV2kDddED0ssYdzodgj2zLCshXo7HY85i7FasFFJCMY5mswVQMr4Wx3Wws5fZ4t50HZZrZO6Vh/QyEGrG5aGC+SO73inYu1YzcauEZh8PuC5WZ1suv4/MYM7p21prlI06goFEa5YNh0NAVFgRcjKZ6CBA9MLEwNKPZe24m9vp0cDhjo6OkDRrEG1iMUODQGLenSWk5WL9wXDGpz5rb0tAN6lzXtynHz9TPYMt5jKgVOyEoUaJ6mEco7Z4PTs2qpoySSQZDodW7C1JaYQYEI7cRVg44thGINmImbIGA6svAEORMYEFscWl8BnnFUVBhIB+h88SIi3SrEaE8DEhioPb2kA5by7WRa82kTb+4vX63qwxfyVUuDzgbgWK+TrpCyI0yn+5VpfA7q2pjVvhsSLlSVpHDlmHxnT16lWIGlbXwGKJoihLkoSPSESUUIdCiPcp1Vvz+RyBsX8YhgEi/12ws43F0ptiJDYQW9W9jmOvObMF/KxETCd8+EaUzmXWed2796/CtZQmi2Xy7bIofkQ4+6Aoiruc80MQW1EUCMvIikIU+/ulGo1KDaIDd3OX8okMre/jqjxz0OGw3mEawNCsl/q7fjffPNDytz63d6Jl8xtjsIHgpgiS3iaEbwlhSmOsKR64Kll1QVRUVZwIxQMa8ApkVRlmQk2ATWsE8I4VNxrKFww+rBJJkcpqp1Zzw1VhgX+RpmgL2ENEtYRXNQROi5AQbNU6FJRHynp61RQZFxZtyYHxVh1YU1bPi07yfB5VwGRPM3ebMrYzhgK+xIrA0B2drlkD0p5UBmvahyW4NaLlZn0OrPe5554DNgXi0gBKlMXxkqAQvTHmfhiGv0RHZrPZYDqdogKnjbuEiFY5CizAjuksyR6f7bc+xHjrtvPCfqys34fToY/PCPZkfcvfqWHJApgX5beF4LfKsrwNEy1EaCxOreOU89wWc4jjQhdFJS76hFb2LHUOCqLtD3qEDR4uuEhorWDOa7vZsCevR/UYVcunb0zpdrnDID07FKUEOJeXbVK1RvUdgiJzpTFIPUd6lEbUfmDje6jh0PVsoDihBWH4SESFos5tFSRCkEiLWEV7V1hjNOHEBIYjI0FoDWAkUoCjE8IAfYFOcyGsy5YjDlYSGRHCThFCn8ZJbl59VaRVertLZf3u2Qta8PQQ9LF2endWGRjJa6+99iQEZ8/9qByuuVAtWWwiOkSO609/+tPq3XeXtCgObPydq8qJOcHOZQwdomLl1tb084j2x6JzrByE1zWMdsMk2hSMNXqcj7Lr+ak6sB7OcuVxhJX6Gu3NbOOEW9/hYrH8aZYXPxCCvS2lBEjrzBiTIXA6y7KMMZpnWa6KYkvv7EhrYIACvo7Y0JIkQQiVvUuAFIGmHyUDnInWMmQMK7L6WeMK6YlN1aE1XLumpP5m1exLbYlojDf8O89QSs5QSueUoiKqnQqbrYBIq/o9dh6tESSOgGJDloRyJM4OCSVVZwhsG7SA4bW2/Lk65/WTMAF7CaUE4jKmHFQXuW0OthgbtE1BeAZlXcd4gMYN5K/GTmdXhqA7sY1EvlrfAQH4CJJGljmluc1WQGoaYohd87E1NxjSmiZOIJydpK381hcr0cDlJpM3tVIX5WSyB11OwwkuhOBalwGl6h7KwkpZDmezBRzjv8eRtwZpAjHsdSS/L2M7inAZ2c5A3AqJvrhY74Je91f0ws7ZXT2mPad1M4PYANKaZcWPOac3EcamtX5UY5DksGMDhhycDWI1kBLgLPYv6YgNG5AfCLy+IdvaJs8wY5lD9Xx1YKUn3df97m1+bZUe73xPlOxoCHU/R8PhaT+pyjqHrfhW/7KTcNWJIAMPq4qQ13On69/1EkDs3UA3CJN+HJxF5UaEAgbrLfCNbK2D1THzpOjVXO81el79iuomeE7XWWooDDWB1nkVbHt8RNdjychPz/mwjT4uf651DCJjfIBoFPtpPp8jb20ZRYyZIqSSW/dBIWXxaLFIyul0/CKi+GxCVnVdV0euvbXTwzzVrJ7o5px1YD/ruPGqnLyxzzZHbblcPszz/A0e8PdUWb4XBAE+z3LO8zJNJUCCEe42Go1QZRZ6W8f565pLa+mntzgnsL2hQUEV+IAQ2sRKSoFHuP5ZN+UDNIUrNqgAzeDUqeiQpzRAuzwOChNM7es2kP1AVth46kghfy1zFz3kjBPMD2TsDK61TWNvbb9wPA8WC8ip1b3qaCTrhSfWvOY9dpNE2yAyrh+JNtnW5zOVcUl3jSq1OMnh/sBz6PvyPmwSnU2zazQ5nnd9HCLlsa1XScVWQNnd3VX3p/cJf8hhuaSnT5+mNhR9oRWNhIzjaInFuZgnu+Pp6DcdQVli6+v/XqsXRkdZMesMLp5s6Fvm2s15lbu5iUQhCLeAlNIFo/QR0fo2Y+zBYlEmYUiXLMtKxk6pJLmrkIYPrgYx8bh8MT+lxYVA1dEa9vhgYExZGl1oLSNuJAIu6ufCQqgkb79ewwZDU4MH2gGtbcfFRYDZyJ/aXgyMBXe9ZlwqNOzmEr0s8fYaq7yMNOc0z6rtPfpjbhPxVJUO29zLyaa9z85Q0uiktYpgveFrdXwXceM9ntuXq7oW9go2L44o3A/Z+Qjq0HDGf/DBB6sXXXObDxu8/NgLPS5S2omXDtV5b7anj46OsFKQRVvM5yotaTkHunBZ5vdQlSQviu8li/TnVtVDpUm369mbuPfgf9V7TAHAaNsHqcqf2YH1iou4HrQuqJ6FxclJnTVZL7ouZ8AySZHHBog+zqX1r+V5LofDwnI2EBsIxxHbulyxdcTmNxhYlsulDdxF7inhNnIfBicKf0K1EdXP10jE3QXV9v9xTpA2QMDvsx/03YAqdX/mjfuG98S3SHX1Zyhm/d9Z3KKVh63nu7aWVNXHm0423Kk95BG4r6/3RMtW+bJBA3aYKmuwxc3BHGiMPyztv/rVr04s8PUPfGxWyiepkFKLmBoY7PC1zGac7ewkdD4fkTFqjAqhpETJ3BAO30Mo0ZPJ+LcIQpm8ndGKFdjpvDvYndaewyAREdhdKk2inpCViPg1e4ef4Oo63AnyrV8oAYKZBSdqaw7YyHYbhqXU2yZJqhrkPmHhtSGs11+Hyau5j/sOBDoajRgKqyDTuYpFLVkQEM4VA3hdCayR2tBaP5PH4nqbnsObXBWynAGpYyhYO5eNiOiL8O1luv47X2LbtFpo+9oYffxz6zp7lY3fXbedb1+u6xjTOvqbp9Z27lEZxTr4UM3zV/KOlZ0rpDCfXG17kkKUfnvSSJMT38RN4CYPPIgOboJbt26pNL0N0bKUcoYaBslsNjvKc3M/y7JfEaJ/nKbpXy8WyU0LYMMZJxWQDZRY+7ryh3/Ulguv4pBQzLiuI9jJzlmzbtb2xXG4Okeujd6jCmsQ0eTWCQ1Wl6asDV+60Ohmfc7WEN/VqxvH9PLly/a7CqjK6ROEwYyugdPi0ti9mVlHUK1atM624I3A2r2nLX7hxMZKll0zTr3f+zTQud2m1r+mJ/qvtOY6yI519LC6ma5sMZ6Is3I7b3Oo1RfE0Fk3H8qbI1NiNpt9GHtHc+WPy0p5bOtbLP3mUJ1RxRTsWqmJGg6VyXNJwlCQotA0jtkwSZK/opR+LgjEWcC2oYoKaZmWzWmtKu0BMteape0qtSl3tsoa5ah6ofuWyw0Bll112mcjHTQeIEYBesReAIhS4EaPHj1CsLG1PK4jNteOgyJAmspbb71lxwRMtKp/CUK2Gc+VWaOpz+3Ixt/G16/4fmtjL6tP61ZCH7KhsX10IeXqNd6i8VRMt70+XRNjVr043JWunt21Knt4LL70t5Yzuqv2jjWE6KSV9of2netT+ytW+f6NJkEVEYOGWoKLRVVf4Zi2lqaeVKR8IqLcbAnrthqTXRfFjtraukeiYqrohBRZJtIoih6WpUVNShaL+Y8opVuEsAm8v3VBeBBbYMU7YySjHMSI6qWIwUPW4hYxZFsEwTkxFrv+Bu1J+sdiffgLrCNmwpRtDByztCyhBhRsuSzpusgRNCDzVmChL5Pd3ddONJYoBQ2xGw0JoLVfzgLCNjh8HjBls3+sMYf3emX/78bYrHGF9H7TFJhvVnvdKpG1glztROj3jTamIb5OZkN/nXQwSVefYy239gwvXWKrf9OvF9dRGVaIFp8U5QS5Y1ZyAqw51in5CO3jcAt8aC7nIlGuXLlixcvdXezsO2Qpl5Qsx/TMmXCJQgkArWEsyoTQA0BcI9wIEGlC2Gm1aLww1FlrNVeCGxYZQyeUmjPEkLOG0rOMkRFjZLcKGutxtdo610vb7G5RPoU6CUxbsbUSFQSsiJtDs9AcMi8h3yT7+7au+so5faPJnTsos4usAeQUAqkOcZeQj2FRqKyN6HcVt9LyuQ5z8/Wp5tgGYvQMSR29tTnau+7aj47o6ObUIXPMZtA883oBed1vW0jANdd1golHbJsXvPd7G96GzVRzrTXKZGmyj12wPeWkQcvuwishKx9324Tt0BetENgM8RIQA8guIGRRonRrWZZpkuhlWS5nMKBkWfZIynxfqWIfEOtSyjtFoYERcltSfUcbBvTie8aoe8bQe4SyfdQph8Rnu1vFPnYE9vVT1SZnrnOQ1+9tgCNiBJHRjkMQKV1z0SL99vLLL9sLvvbaaxvHxGU8n0MR3drxBVcQMPIqfRFZ3xXVtFvumt29Xrjd5+4+lm8LcjrbCqfr4PT3rZTNCNamqd6v142C2dBxe+31FUrX/qxR21bAp1ctpysnrLlga3TCk3DUVkBUDGIpgcFZbFV+1CeAVugYXJ7UaPKxN+cmQB066DsIAQPRwQ21WCywpRdSzlEXLStLDig51OQ6MMY80Dq4T2l8P8+T+1Sp+zJNH1ClUIr4rlLqjlLmtjFqnzAysxFAtZ7cwZxcOxde2orPM7pyKBqy1YHXaOG3a6OJTZy8f7/C+vCrsLr2zW9+035GObA+1JrT66D/wWgCcKY0TTmlNsvaBfzautsdRcgzFNj/O/EBHeynjcm1tqe+eb63QFsL5Ebrhjegj1mPdNPx/mw85qN/en8TPY7Q16E1N4aWehez+JQ2GtsaTnD4LDlLbtx4rJWyuctJdLhfmwGl5wSn/XjLSqy0MNeIRjHb29uI6LCxh1iIQG2SUtvkRIC6xDFKcqemKAKiVIKacbZoH+ejZRhaH7EghB9RQxMov2sIZm1rBsC96elu/gplTEhYTups6OYkcCaoXuBUJwFIdROI/qOvIFTE7EFuBpy4h0liiQ6xz31I+PbZqmxmb0HVkZErPXRfbzjun+HHcHWNNH5ay6oI2DVSEU++9cwVHR2y6kL3StWv1uc+rLo+NjSve916BM5Y4mr+NRsZ1pr9gEgTbKQH4QE9ezY1j7eZrG/rONzHTmzrNrvjZF8sOOTQIUpjNpshv7ccDAao/4aUEGCBIOUF7oN0Pp9nW1si3draStM0BbXlnJcQ81KlmOWMEPuqSPU1z9bbzhv68ifHodCtWY/W/1aFYnT6A86ECTo+NnJ98zniLhTb2kqCF2w0dSUbRAL4apP/VK0hzv/Odc6L5q4OeSZyrye0x/WafFVXmMW9bySCFhmtBRd3xNUeqxDUXC339trNHZtABe9XLfhKkzi7gsNiX6uHpycWYT1i7ZxjAwqqwBBANmktiqKA0Yr+xuap855mfRO96eiZBf75mgfEYrkddnpwBhDd+++/D+sQkKLscz39NJDJu1ZO4Gtk2dAYk9hEzbIUElyOUp4aA7hzgxoD9R16+k39vlUdau7RnOeqhnYBh1z4D3R7rblUqgSknc3WBqaHs1RuMv+vK3xRBXlXBHfnDqeolTGdWpOIjVipkx+Foca+wYJ2sY59mvPlmrW5qSs2ldVEW7f5dJ3aPffButXSSOFruPCGH3UEiTqSxDcJdqq4eKpkU8TaSzR189iVUlrraEdNcCe5QxaNqopSYowwLSx0f3PjDwYDSh7P4tbKU7/2WMoPS3wvvvhiUxhib2+vAQVFy7Js3RTryYSpIBjhe0YIAvZDLWHaBY6q5lVljt6kdqQsJzrZSKl6p2xwMTsLwpPVrD+w4oE5IWZizI7YMdgE/PhJX2TsP3i/8IUTKbGvzGb7xBhkheMebW22OmgNVcEtDkC1XlYTS8kGidjXUBu9paGNVaWpc2ydTLdWKl0zTeYEW7tZjT5ZqSnR/L5+ssai6mO5dODH3IVWHrqrE3odqKEqrTjBNIrXYD7JR2lsQ7edYPHE4tD6tjqqmxzhm/DmsXDd4oWYNpvNgJli3F8dr6gIeWTPh5MS0QE2FgTVQYkWK4rGKoDy2qdtxcya2vw4Im3xPuzMMxSRWlKKgOx1/fow0N9NLKXNHgDcODAZSUlNlXFtqC0z3PIotwA73GxVH6pe3bld8qt71r5zMC+b/hyKOizA1grsHXd/9THmkC96x5vv/et572uMLft9ff3VRevHUHqaoXdGfcTnbv6m2+OgduyNxUarUQhWchePW8cn0eEaKb/LiHtP/REJ0SEcHafHuR0fu73/Bysm/vDeN0a4gFJjdqwFg+aUkaB2ezCmaAVZXXdg3dbs7ZJ1WlZX4fd9OI18YrPSKsAxyRyEm8NUhMHEcWbHxfrWLXfMuQpcQ988kZRagRgxm8LC5ElDTVXosicqNpOzZifvnNT/qnlt+wlMxgoMsgoXr90TCC1zGJG8KpFYNatbwsqA41UsHSQyvGnO0ZWsVoWoVcerJJzqOOaq+lTd1Toc/W9szTbchxLKLFRl+/zrXFCdvaa32rqQgk4+rY9VMnqFnM2QGMstRN+gDt074ebZF+IRrfCh2xoTwoYTu/iVGyuL9BsW4qaOOT3HYdD/xm+0qizobV7O+TAYIpWpDnk2svm+t4vVB+vV6lngunJW7wf2XCwIQzj8opihiOb5HLBxSDla6cu6/uHVERte4TLY33/RTCav2zsitAvB0FXucWid61EEvdGmCXrP3dND12oQ/Z29G1nS0W8q0iLLZT5XSgJ5uaprUKH/wHJjyyB7SRjUz+AGrJB3XFdVVii+t2Z2m9nRjqrNGrFvtEHanGXVtSQpkS1jo9Gr/QDHsG6BtRINBvEOYxSFPapu90pztXlvXfbdt2e2Adm1hayKpLMJv5RqrpTdRKg+dYqQunLQEzZ79Scp5uHP2hPep9sex4adm8A/dpwO5DcgFzsceoD0BASgL3ajtrZEG/HuAHsbUcx99N77OtwqsdXCv9Wu4Yuz+2FgtGZxbFNpTrKROK4HIutzuPr5cZ7l5Nj1Uf4zCENnpUQIexVLVT9So+dUS69x4brcL19pbayC3uw20SE1ASMXrSzKeSnVHWohW8khqrMabTJDqMX1r0LMKknJGG2XKTCAMC41DjuATSpJVxthuVO7HbjAC3hWSpt5Q0log18NlU1oTZU2YJ8SDBGwDZTTp4gml1Fu2jd4NHic9PjwNnf6akhXt/BJhU1JKOINAAQLuEJYoJ31+AlbhUXxmJM+lN7R3MFsDvE6SS3odSKY81Xhs0tlcVUyCTlDZjPAFQQqilhJiFSMYZ6JtCCLbh32J6NXD7pLaD1ncLdPFsKuKLRULC9QaAo4krcInqTLjfvWyE2bRxVnWWFmVGLlDtH6wGgdaikrQBsUZaykLbuTVPATWCzrnNrrtsu1zuuOwaD6n5I5IP+oIe8Yau4QwhZSmxxiLaWAvkA0hsU7AFtA8RG7+dg66xAvDGp06pAQ1HOjHAsCkqUxQOO01YCqbY9pVM0AIB0EVkU5LVAky35nIEVanofdJqLUTCihDwmjsB9eBeYIUNNs7Y3GMrridvUYeg8Sz33p1Am3G1UbKv6wlVoLNPmI7b+blfKjFF73F2snt8wu0HtwJSBlBtUrIfVB9LHANyvWMa9+QScnzJ3jxLSmtFN1oIniMIZroqFV2R2wLEOt1MK6A+C4UEFwrB/O9cNxuXXnIGJlZ+egRu3KTBAMaot1W6215kpOlHPhWY9PPup83ZgD+xQ6U0rfZ4zc0kp/ICVJGNM5SiZbUBHFuGKKYygqGL+K4qWEcSe3cF3wYdlIHEWZ4TZ3EEVAlDH4qyy8QhBSKsowjkD4QoVVAJagFhwkWCltWlpsOB8JRSQRdEAYP6zxAy2peXtpM8k9DLNWqnGj4+8vqyBC8PyUhOjcmBK1vbHRfyQG5PxwH+kim1p/t31Si86m5nOGftgUIKgdIlhd+AFCOJzfDW5qE1nv01+tMPvSY/O+8dtUC9K7IZDtBWwEUhYUpZxmMw0fHBJQ7Ql+pMk6jvb4RMY7xHK44dCEVgWyYSawylSVLcHY/KiTFQt431LQyEqdaW9h4lrzeh3cUkP90bkkZG4MWSC8BzXIUXfYGlNgzLC2nOqOSJQNQ2IwBLBe4TP07LKkLCCo3guLq62drLLMGLgWXeB3Udhyv7pOb+JKDRiyMKpcR5ETcFBU0zR0WZUjtzkKHbuWn2TcYiat2VB7A2ah7ruDhTMLSoMS1D4ajWzo3qaZOkHY8IcoV/Uh27pMgZNyu8cZTvyG0kbb29ZIZkUdYNBA6RciWlq9Zp3xw37uFlVcSaZs1mFHCa8MMUqBw6FYIQN82v7+PkE41rp2nChZtZcR1mzfYeNAAQzocoCmRpOSmCCw4KexQ9NvrOj9oOSW261YIxtnsbfx95mdtZswa6krLH4L6nwTlSilF8WSFkoFNt8dVZL6VXQOD0uGOG5wsLIsAVNAq/oSlGYZo3FsmaHKsoRwXgV892oo2N8hospZQIFaHYYjbKBMG7pglJR2E2UceAg1Vn0lCbYFNet+9qJSegPl6XO+r45KeJQYK5Gag/mwQLAIvHAbau9C5HHN2VU/smzabyfJg1tHfH7rF+vrt8fVkkYYlFUPqsqhXWJz9rO1D2+1AS9IwnmB6u8bZF5c0yhYKauQq8JmfPupOQ6H3udmx3M1l8LTbbB8VhNu+yNhlKjhbqona9DMunpp3QHvpZWX22iadZa8Vm9FoRXGDApGAqYdtdwLxtJcqaPMmJmFAuScI2kvJ49IrtT9bDYrEH63fPDgQRbHcZplGXIbl3EWLwlZJkkSJgcHB1lRFNlsNsPqBY4nQvAgrmbIFOF8XkA6QbUhniFkjxda57YegwX2qWqUwRfafebO6PbGY93IN2Fd/njUHhJeG00q/2fVoKCfvHVW2a8lW2AdsR3nCjipPreukiaaH4XibEfYgFBEjxtrzKsc3ytczXv1oilWLFs+cI6XOtKCpVbVVYCwBT8cwsxQqqnu3VpOvKkgOzgcElXxzomitV+vFsvsSYDIQ1xLE9bu+zfafaWb5tLa3vptDa02olh1tEo81zIMQ1t+HOW1EHYHoCT8xXGMirfygX5QxvGFsrwQl3fvxqXW2h6HpHlwcFA+VA+RXVEQclAWRVHs7e3Zz/P5XLo/XK/Kg3yqXC6XFpRJxTCywDMS2hhHoCdWWO8oNtbNCW2Talf75X9em2zbOVTV9ba/CKpyVXDT3Kop7gTrtrfl/RoSUDcQ29rr+w98ErHRGUjcMSxAD6G4Om+XkMUBpVtbFSFIKongyFSFOlfJjZ0odytO+DJ/lblc9cU3mHhathPLjGHGUAAwA4cdop/9BpPU1ju7/sRj+NprNhu8MQbVJaBYWZbcw6r0QMy7Opy3zNasKae/9jla98etNFBXW4fvQwtZFNqgYAeskTAOvf322+bChQs26gfZHHhF3pjd+Ox/U6vHIjDh0qVLzeJwoLcXL15E1JCdR9c3iJ/Qg4GahXvs7ytz/ryCoQU5aWwwGDBFFBUVolClrwPArEm7ci6Srqq6qUzEKqR9G9qHIkZGGgODDzYaZHzDVfME02k2WSk/svFk3VOsI7ZNhPa4krSbvnelaeu603Q0Oqe1TqzHEiwAkyZEoFrDgIex0cNnXJcVbF+7ul91yG6A1Ye8El9dBZzOUPRLG21q1VhU+huKRXzpS1+yfXKpOXWwRkA0ESByi+OCfd7pL90qQxvGstXeWh2uJ1JWbnaHU2JLslfLFRZXSWazzCKTYVzTFOlRFXaLDwXozxWO7+3trRWlX3/dOvg3jg3yJAmBlTaCH0wtl1VoFYrk1blqdXPh217t97pD1Q262eqdsExngW5+aPXA6pMxhaa6dDlR4HA4jr5sUoXau/y63QKP0dscodU5bxtFw36m9LPPPmveeust6t5fv369OccnNnCCM2fOkDSdEa0pLF1aAZECQoe2pmM7lP2UYn/G+4A3brJaN3JnKIGKDfEOVWSsW90MQ1MeHgIsFIT+oYfyhRdeaN5LOdGMHQEY0cqPFoasLeBZOfONraJhy6K2RrtekmWDTd4v1riG2zVcvDIMobYKakAqBRVLG0A/TKel8bnWSfTrfY/onD/V+VIdwd6/P2UIHIKxKI5jq/YcHR3ZYpQIIJYSawR2FCtbWD22gid3lXJd1sAGrBoPb6WfROQ3SDDYbWzVH0GIzio/3I0bNzqZ/Rva2o3Edwv4Jzwxp+uHb/nfuXQbvMfg3r9/fwXaoU69scf8iGxkCmAXPIeMTtQsvnsXOWHY+ZobHgjBnO5WFwixlmJo8VHl10GEAuv2tO1uhyf09Do3Ea2jtDOFtvQv9BshkD6Tk6HJzSOlsHj0cRkBfijXcQt2NBqZ6VTpoyOlRWa0iWzNMgXNzq4tVF6wgCxVFdAO9HK/U04X9TvYtzPUVOhi8KvMcntP+NmM1pEejYTOMrgrpiTLrhlCXu/cEXN8Eq6+v8aIhHHa2yO6KKrN19XEA7x4rGKd5qmJY2oMqgHDl15n8LdidXdjNMfQQHd/Wa3VDj2EGhOUWgdFUUXRYBM4e/YsskGO61r/Fs1NfZi8dc/Rb2sJsq+39UXG/f19W4gd8Y4PHjyADM4RGnN4eNicByJxpnTI9NPp1BkOrIk9ihJydFRxMYRu1RZITK4ujo6Q8IZa01bMEyiVGYaIfrCftSZCKR3hqRGQ69JZuuigvQFYHfzmTG8nxBvNOdF5TihiHRfz3PoCHz58aN5/P6SXLpETttYdUPerCXyualwzb8oqi0FlmbSxJu0ufZyVrn5kuqZPPWNB5wJWj7FGSiWjCCK69mokdInNt8j2Ra5r9bpYF7q37hpo4CSQFsD90oAiJ7KKNwAYMrUFTdrreFds99T+Ltofhfqbptx0p3FDUeIbTVI4vj+KD26dSHkSYnusc7uuH0AdN4vjmE+nU/7ee++xs2fPwooHvwaDko0BrXFAGMC44GeFLwuigwNXxXWTBHiMbbfcceSdAdHKKdt5nnMhBMrjxsYI1DObEqKngM2rKrh4mPQ9emuMI71RqKSurojpvlFGGRTbAnpdXqEl2y8h8l66VC1Kt+P3uVzL3V7u0JsTt3ENbBxab1HOZ3w4RBVDHTPCxsYgeBcP1caFro2Wb60+ja6yDgxvFaHL6XIkM8bKkQV8AuCuqAKKBkMIdLOTummuH6/zrITuYRxwy9bNsiTGhPBDoqAJ6tOB81YVbzqd6SExt4e9T74i58nnnZNab2xVTHJA0vSQ3bt3z8JfdGmCfiiCOwmna205bZUc2hcfwdX29/f51tYW29vbE8slC3d2YlGWPIzjOEAeCzgRmNtgYDE7wsq4N7ChP0oxCfdWjRXi8EIoksJQ9wO3L0tiI+siO9yB9UwREnAjeCSlnArBtxkjW8aw04SYLR/uu49Y7HeshXirdSH3doV72C3W3tVaRINAgdLx+dlnn8UCa0z7jujWW2Vf6xCbs75Cf0mSRAyHRlA6DbRW2DSmhDGIAkOELPqIXc6q2jh+PUbcjY/vWg3WMbe6GxDNl0oZyE+ZlBKxkrYSUMtxq9b3NTriOg7Hhnhrps/1fA5/6xaMJwj1YuB0NkKFEGPDy/B9FxJq82p2ONXOgOKE5g61+SpvbayCLu5AhKp2GZoc+ahWSu/R1ltPTyJGYiEBZQpcDQQ1mUxwj2hvbxiXZRmPx8MIQK2c8wAWtzryHYMZunKzdTCsDIIYk2y9+zUyFjihRgwerGWMcVXF3lEuJeGGaTEIBMIfYobUb60nWrNtY/RFxngVDdyDSej7arqljNaMCrUZP9YSWVtBF1JK7PyouGF0HBtkLMzn87Wjf5wjv09sWZYFcRwjF4szVgampAMRiillZKKVRmVSm36GBWF3oy6xdPvoOLQnSreisw87UPkAcE/0Syk119rAV1aWZaA4z01ZbpsoAvLgemJb144L67v+GBGz8jTv2HcoqAE+OwhbC5jrY4Oc3PTf22CbDdMZlOrWf+MvDUJQaZbBlwgRWuvEAhaD2IC4hg31SdsmkXKdcrPC2bz8Nus7gikbpYWBnIWa3cPhMA7DaRyGeiSE2A7D8IwxZpsQNuWUx5xxoJuC6ODORQgPFGCkdeA9guARWhHaspoE3hCb6mGgw9fqky4RT6eJsNgTmkaE0CFSPIxC6CEdCUrPB1HwiSAIdhEP1xT/aLY4b3zriPtOhyt451ZkqezkNpfLGJuyAug+7LaW0x0eHhoJP02SbHTOrxO9+sQ2m0V8OiUiik6FUh6hCueYCDElnOwoZc4zxs7b1Jg696Wdra5V0hFUQ1xNBQsHQV6vWuoRm40NVXI+X7yWZdm7WpfzwhiUTbbVgCYToufz3MJIDAaDFePIBu5mnpTorl3LzFtvWbHaWqFdQRMY2BQhwtbW6Sa19Vpv46xjulczwevzvHGsK+dA3V+CqVcxlVTCZoBsEHLy1pGPfIJbI8Gv+27FGskAaIoFc/HiRZZl73BycD6Y7EwGQRBMYQsZDienhRCXhOAvjkbDF1CmFipKnW5h13OdzOhXX6g0KkoQ74oPsg74b/xSNSd0wMN1kiISGC3nwSTFQvC4rrJjNMq7u4HtGrM6O1y/xJEdeudBBYQAYyJN0xuLRQLodZSoymFQQBQGOHBR2czXujogYvbFS198cm6OwWDBw3AUaD0H2vSEc75HiD6rNT9FKfvUaDR41mZQt8/Vm19v8jYYRDpidS1rgbMppZbz+fy7abr8e2PU+1LKuzLPl8XDQokdIQ8ODmzWPYB7n0RPe2WDeLmO6DA+r78+sSBKaBiTPM9BbIQqiSiGiNKgjzPUHYGam/vQevWAeDJkD2aiXntV+CbJCikPGGNLxliK6JcPPvjAghbfvn37sfpo75GO9cNtvJhjbrVxxOJ3/OQnP2HPP/88Pc/P84P5QRCPy2gcnR4OBgwL5UwY8gtCBJ/f2pr+mygKpxutnr6e1JH6XL0p/2ebZPYm09eSCziPzZVqa1at9KWv0zSR5a2Q30j8CIpO0+ytJEm/DZeRlORISiCZ2Ji/PE1TDVdGH2ymn6bTJzrfSDIYDAKWphFEY3BpzvlpxthTxtDTlNJnx+PBNYjrMGAwylGr1x+s9ePSSQZYEZ98MTKbzRZ/k+fpO0qZ+2Va3i51OVNKZQfyoBwtR47Q7E197nYSo8hJAaQ8MCXjLNdwEdiThLWZQV22wffwQ6pKle62Krao3rrtgfoLbyTqGoNNeFi1odo6ArP5/F1j1EGapkmapgX8ukmSmKtXrwK4uKnsexJ08ZM4vleugoXoJ4+idhkQsj73uc+hlA+/a+6GZyZnojCcDOJJuBXx6Cyl5tNhGH5ua2v6R+B40AVsWku/LpnNwPfqvTnIpibsBnXfPKeRH6vrReZYIEErKdnwHJu32Froun1Z19WOldLZ2U07EVmWv79cJP8fofQ9rc0NQuQDVqpZQeNlUcwQ9weHe2fhbQKC9UPUUAsOxBZFkXj06FE0GAxiFkUTofUZwvkFQtgznLMXhsP4K0KIITYSrDrn4mgxOdbPZLPP131zi6x+rRZZKbPDo9l3yjK/rrV+IGVxqzTlDBigKDjpClm88cYbFi+zbyDx2xNg7nca1tW6jAq4iZBtXSBZJlCM85ALKBK2eRn8rezcIno5Ha8msGpW603USjDN7w2SgLC5zGaz76aL5U+VUvv4DCkmu5Np+OAg0cES/1GMJn2dbS2x+YMCYgOVY2BAbFEUhZPJJIrjeDQeR1MhxHnO+RUh2B9Np9OvBkEQgtfURhILT9MWT6z+Gv9Y8wS+3NcQQletXedGqo/6O08fYm2N4FXJ9k67bvVu+39FbNnNeZL8LSH6Ha3o22WZ3aGUHiqhFoLqIk0LG2ECAutzND9DvS9qQow8Oor51lYGfTbAWMIKCWKjVFymhp4lzHx+MIiwaSG72RJb5+nXQXf3B8ULT3GLDJXsUU+vLMvFbLb4rizkdaXVnSzL3stzfTfL5DLPkySKIrgFoK+R49pJCe2VNeKlr8P5RIexPDg4sCXAKlhOdEUjoo3bSqWeu2Yl19ErO90ZGIdd0orV9sdwNs5ms9eWy+XfIcM9y7KHiF6D4UTsCnWwf/AkG8nKuf2IDyc79c1cKw3EBtG6QoEWQViGltjiON4G0jdj7Okw5L+ztTX9UhgGIaAH/F7bCfclvP491um1PuE7iITe03pl2dvzPeLx6guuNidydqRIu+shF+vd+Tz5W07pDaXITar0A6DOZlmGFBNYy3WW7di4TUdsLlypLzr6xOaskTs7BYgMvrVBHMdjzuHSCPYYM+cYpf9iPBp/OQxDgQXRSWLzx+IxoXXNHubGrNrReZEXy9ls9u2yLH+miX6vLPW7ZVnekzI9LMvFIoqi/J135gqxjBCpoMO4QiQfhxj5Sk18uNam64HDVcVmK4ggGDAQU9TgqWAxVnt5d7N2XfbWWoPn4s0x6gfi+oez+c+Xy+ynWusPQGx5ni+kXBTQ3+bzOepeQM98XBzlE4uUHU3K7Zye3gbuxs+fDwVjUaB1FI/2hhMhBqejiJ8TQlwRIvzd6XT6khBirCD+IPpvxfTeu2Pvs68RO72qrkzpq7sbrI4el3PBuLVI0ccvdJKje76m/BPESA6dLX1rsVh+C/bpstQ3MlXcIiU90FpCmS5QUBLGktOnmU0W3SRG+sYRENtoNOLws00mk0ApFTE2iDkPR8bIU5yHF4zRnySEfm4yHf6BEALieMXZapG5T3edcHhn/GnGpWtfwCWA6FcUxYPZfPG3ZSl/Ygy5nWX5nSxLHmitZ8ulSfI8y5FekyS31a1bI/3Zz37WbiB+aN1HFSP7zS1miG3gqEj4rItc2hwh5AOiwCxMRu0SaLMFVqy1TaLHiuRi39Vi5HI2m38/z/Jfai1/AetsPs8XeZ5DpC6yLINrQMJYguKhrr366qub+ryWZVTY6d2TOmJl37kNNh+GVzl2W8b2IP7Ee3uTQRiGu3EMEVI8GwTRH25NJ38GV4BdJD1S6MCIu5vWd3Y4/rhvRw1u6XWDzXRDbz2woOo+G5Qcj2AbYmOML5cgtsV/IYT80hj1Cynzd4UxD7JMzlDjIEkSJF+WSZKon//8503kPK7jsDT7d2tN/zP4K4F3CO42YIyMOVdngiB4hjDzHGX09yeT0R/3ic3fYNpyu/2pXfPebSg2HM1y7Q9ms9l/klK+LmXxqzRdvFsU6d1EysM0TRecF9n+/j5iuuAOsDGVKLjiwrZ88/9HIbZXNkAnXn/5uuWm/eMWS4VZn7+1htWomZ0+dzahjijV2aFsuQ4ktB4cHH03y/K/U6r82XK5fG8+n+9nOtvPsgyJsjly+Xav7+pXXnlFu36vITY3GRuX5bpYSvd5nemF3bhxQ+zsPBuMRqMQin0QBDBbD4MgOAO9LYqi355MJr8PMRORANbsv4L12L/rRvnRM9l7Cpt/msPLqc9v77G+ovVK79ZENHnE9mayWPwNoeQODAha6ztlySBmpdTqbCkSL9XBwYE8c+aMXQCboLAdd9vfH7FPfpJTcLbRaBSUZRgwhmToaMA52zKMnZXSPMU5vzYej74oBI86OlsjFrU4+p1H71bp9YbT8yQyJsDJFovFf1ZK3SxLea8oirtFYQ6LIl/IJfaRJMNmkiSJvHLliv7BD35gd/a+KPVRCY2sed+eQAg5j2Ti3NaLGA6H9l42CELrwAjrXqrta57+3+hsbu3T1fGoxWnoArPZ/B+LIvuZlPpOlqX30zR9JKVcHB0dWYf/7u6uJNev6/1rIxdsbl59Ff1+9Um6a3xMkw0rfkWhZYTsitEoDbe2tkBkkzAMp1EU7VLKPxOI6PdrYhvVO3JTyb5rIbRrulrZPm/vnvD454chxV6mHdR+lvPats4w48RWQj3OlvwnrQ1Mw3fKsrxfFMUMpY8hXmDe83yklZopENtJquSAs00mD9lsFgP7BPpYOBjoiJDJkHO9wzl/mlJ6hQbi8+PR4KsYRxDb2tTkLghQs5TaDcodrselMtrVfcveS5Lk75RSN6Qsb6pc3iqXyUNUvUSJO0jEBwcHltguX74s//Iv/9JFVjyW2PwqOOubsc/SJ7BNPjqY4C9cuGAlh9lshoxvhHZplCwSerXKbPsgnsFkVdVwYmQym82/WxT5z5VSv0rT4v00XT5cLpcHlNIlOPtisSj39vbUaygy09FZ15npNj1F2/yAuBXe68Qvp7dB/BkOE3C3GAYScLU4Hj3DOf9MHEdfm26N/5hzMW7FnzpztsdkHZltJI4T9qVrNDlmva+VuhpkfddZqx9i11su03cWi+XfGKPe1Fr+Mk3Tm5TSg6IoFih/hQqtyzhWR0dLCzPw4x//+LFiJBqskdDboLPVYiTCs0acqx1COCJHLhNCvzQaDv4Eui9M/21JqnYcq5d1+2Tds6Z6VBvq5IgtXaY/m8/n/1lr/UulyttZlt0qssW9pZSzsAyhs2TALAGxQYysTf+NGLWJ2NpolcftlLTR350o2r9W/zOCpJGiU8E7QHBC7BEwR6sBYJvkGb+klekSG+JCj46O/j7L8u8rpd4py/KmMeX9siwfwA2CMRgMBsjwUn/5l3+5dgxO2Hrq1IYR+sY3vmENJNevX0e6O3/mmWf4IBsEYlcMdnZ2pnEcbw0Gg8tChM8MBoN/ORmP/lQEIkYauiO2flmjJqrIM564h9iwdDYg566XeDddZ+W8ZsurDAm1QcZxtl/N54vvMkZ+VRTFj3Ot7zGlFpCxiqJIEV1U+9ogSio4gX1i2yROTqdTNprN+MMwjCCOM8Ygio85j7aE4Gc555cEo18cjof/OoCEoI2yuAFui24GzxuFFZmy9jN5ohPOQUgbjHhJktxaLJZ/aYx5tyzz23me35ZSPlgulzAMwNdUPHz4UG5tbZWTycTqa4/lav3KOh8zJMeLL76I1C6+t7cHA0+8tbU1gUQVRdFnhsPhn02n068jDtclLPbD8HoqTO0CkcXR0eyNosi/q5R8I8/z/eVyeRMlrFFk8N69e8vd3d0c0TTXr19vnPyPMZSciHWITcSGVxAbVuXOzo5AbOTW01txGIbblNLdMBxgkXwmisKvTCajL3LOBxr51c1q7mYe21fqyTb2ET0x0H+6TfpJJ0jHJfg63c4ipDlLTzX6tS7nhqMj7tjLVH7AVoxc/nw+n3+LUvp+UZQIaTooUpVRWmZSxpnWgyKOUwuig/AmENt3v/tdG3nwOEj2Dz74wI4l0pOwTSvOhyHn25QSmP6fZYx8bTgefikIgsqp3XSwHZP2uese+zBk/fSaemg5IlG0xqL92WKx+CFR5M28zG7leX5PSvnIGDOvXRvF/j6Ru7tbch2xfTjx8fGNehnq/r0c0dXjaSEa0KAj16lbFvHALR7ng6sNXivNWmWrCJLZbHb07aLI31NKQXq5gbrx87LcpwflQocaFkn5k5/8xDz//PPaD1Ku9LaN/e1tdU8YafLGG9foSy8d2FAj7M427rGgk3Ac7kbR4BKl5GIYxl+ZTidftbls2ig7ei4f0t/5OoPg6f4do0cLgOA/cceU6xFve0mPmN0X7lj9viPHe/Tq1EgQW5Ikv5jNFt8yhrxNiLyR5+ohYyYRQqflkc4Mnxfz+aEqigj5YBrQAuBsILZNhTpcTiCMJUVRWCAg5AKi/sjWgE+EEGcrn6X4wng8+poQgtU6G6qbwpndEwG6OVztIPgROJ46a/3hhi3myevLRfIDTfTNoihuFEVxB/ponufJcrlMwzDMJ5OJTNP7ajLZ048jticJZfqwROe3K1euNF8COQuvcA3AkN2hgD6xtRzPglsC4u/oaPadLMv/XmtzkGXpTSnlnfl8PsuybGGOTJ7GaXnmzBmFED1njXX9f/XVx/b7sSc4t8BKb19GQiQh8H/YiieIcKAxHURRhByzM8Ph8PlTO9tfwGEbKe+CsBvHmXeTDjF4zVM/m7pm/h7hGzd6fysZNF4vGjgE/1x/SEyf2Ja/nM2Wf0UIeVcVUJzLB1Jm8+VyibLGSxnK7PDwUO7v71tiQ5Q8wptO2pAbOBwO8YdolTgI9FgpckZKfY5S/ruTyegPMY7VplU9ITKVVgX+VT9S4/X1a9GAXm2lJ0Jns9n1JFl831B6J03zO2ma3k2S5FGSJOhfCl3l6OhI3b9/X+3t7WnoK/+cxLbpuv373r592746G3BRKKOU7AZQrnk0EBvmuCzL7PDw6EdZlv6sLPNbWZbcTJLkfpIkR2VZJihVfSe7Ix8+fKhv3rypAV7kE9vH1e9jUbsQTQJIMoiTYTiGVXKqtf5EHA++trOz9SIXPAaxWbGlYuY1kE33qs3nvoxdH6+OVQumer8++6G18NRhYRvGABWq/OqZ3Wu0v60521uz2eKvtNa/KEsFPxRSbuaA807TNC+KAo7fElEW4/EYgcmASnM628bgXRem9M477wCpl96+fZvv7OyEg8FWHARkqpQ8G0UhArr/NAgCayBhtMJAtMHIrqBTkwxUjUkzfnW/2vdtPCABcJ/W5dHR/DtJkvw3Ss3bZZnfzbLlA4iR2EjQN+AGQA91/iz0y4lQ/1yEdhJO9/rrrxNg2iCKRy4WGinoYUhlFIXIgSoZso8pdVG4bQlmm/3ARCnLo8PDo7/OsvwXUpa/LMsSXH4mpZzPZrNkPp/n8/kcuJlw81hi6z/Xh2hrhdvHonYB7TeKIiSThmlaRmfPTr908eLTf+q+rwvv2YXcHPNvuQZqdh36rH/Mv1bn8V0f6gjv41qz868ZK/fbxWLxCyxKw8g7ssxvpCn8UWpBaQmTMCL/4aYpwdkgKEO08cFxjrNa1akmzWdwMKVQ9MIEwMwfjyefPn1653+D5AC7DVJ+1vffvV8zvhsactkQqpVl6fcJ0e8vlyn0FZi7URdgCWIDXMKDB1zFsV2b1vjTF6E+xIJ7rA7zYYgOYvuNGzcsJiQ2ppCEJdCYyzI8YnURyAqVvW3uPYxBjw4P/7bM8x9IKe+laXo7SZKDsiyRIZwaY0Bs8KPKixcvqv7cfgRiW9s2E9w3Cbn+3HVy8eJFi+egdVYaMypRync+n/8SbiVO+cCWDKpC8uskmiZ4CihZdUBXo2C0Woct5GrfW9YG8OK6gxWEd1V8yBFNY+iuC1kjls4V57AWxjaR1+bD4XNtR7ET6BQeGCMALEjLonj74PDo77XWtysDiXokZbak1CwhfmDnhOm4Irbn1O6urbraDM9x1jvfyoZICQCHIuQL/iOtMy0lK+J4MCyl/GVRlENG6cCC39ncP8D92q5DLrQQpzbnr1Jm2wju2j6A8+pbAXbAIhzPZsnPkmTxPcbI7eWyuFcU6QNkbufwIBtjORvamTNE3bx5oBGuBM728suIHmn75CbqCdpJDcVPRHQgAiR9oma6laiQdp6ZhRDRnbzI3+FKPGWD3TAWzSqkKC+VH81nbxRZ9k9Fod7NsmRWpuWRUmqxWCxSdsSszgYjWC1GfugYyX4XnojgYPZ8+eWX6UvnX7KOxiRJQGjLOI6Pfnn9F38ejaILo9HkqSiKdsIwHCBZD6lUVRo0EcYQwP0EyAGtRSLrATeUFhgSC/qCki+2iidqjNGyzi3F+YxS1DGngC7BgyPHsgrhqblpFU9HXXVMZIYLFKdEDThk6tY5qVU6FKWA224CygHdIKVcKlU+IIQdlGV+oDL1KJXqKEkOEmRvD4fDEubxCxculJM3J+Z18l2yu3t1I4TAcdEW2J1h8fr0pz9tK4guFmU2nUbJrVvv/wXn/LUgiM8HgdjmnA05F1E9Tm4zsjICY0BuwdUq1BZwyerqNpaXW3cnNahRPNfa7tpzrSV0tv0810dlaeMBs/nclIvFXfiWCojH0EUdsVWhWm1fPoII+bHInrQiOnBbh3lCzp9/QV24UJawqnLO9/N8+U/vvvvu/x6G8dOhCLcoNyG1+HkgPlNIqeeUqrkq1K1lvkSk0HyZL5Nq/lVxL7unzozPKGSx98XIx8RJfuh2XMa3bfBFwC8DBTsIggO8RzRCnqf3jaFDpUrEVRoUCqzT4IEBIbTGjg3iwcGqzKwxVFZ120BI2MCtDwwmXogI8N+hjpigWnNpq2dXnA3bVqX8Vs9UmYTt1q+EQOlblIOt4LiB3Vmlbiib6F0VDqSWECvoD0Tzq1LrElWzEQ+JCbDFJqCvgSggSsLJir6Tq4RcJS2xfZjQpnPnzllcRWDkA9trsSgp4MIBlGRM+ZAQNTRSDEpWCGCUVITGLT4bxkMpEtVYmxLlVqnB2ILQbIVJK1FolGrUNC+UKqVUGZXqIFMZrG8oqpEjvYaQCuMf3PDmzZsdYvP78s+hrz1pe/HFF/VPfpIqebeQfI/nCUlmaql0OAlBPHdLkSPDAsEEDPi7KD6CIAX4ThGArJQ6XCwWS32os2g3KhaLBfyo+u2331b9KJpfB6EdW1sAfjhY4aCsXrt2DSknYM9IUQCmBAo5lAEJsnBUBAhXQukegHDBCFEFcwMdVxLA2jHNuGYa34EQ7S6C4p2oI8vtkjGaaaaAbFLNNW0Ag3CSZiiMKcDybNNUS60BkWaBOWmZElvxucJAMUDltZzB3gEIQxVLQ5mnunZfqamkUjGVlmWZcs4RWZHBZDxIBioZJBCx1Gc/+1mkYxyb0fwkcYS3bt2C/wjFLwoUpAB3CcOwLAoalmm4EDHSKRngDZjT+VyNO2xg+A54jJQqi1RVeTwpBdwGRH6IrPajpKVSOiuKBRbiMssyq6/t7+9bQnP6GsbIj3r/H5HQXqlF83rcEYhh7h0cqCIrSpIRBBMs42WMvqfGiKMggGTlxoVKpdB3KoPApPP5HGFreUSi4saNGygYoh89emT9bN/85jfJc88992snNrQVw7Pv+H7jjTfozs4Oe+mll+jNmzct3uNweE7s7UWAuQNWiBgMBtbPVBFJjNjrGlkLehYgcjOgTm3Q8wMCoAD/CPQcvKIwht+qYyCaAlAAgLyGQmyReVHgD+oR/GLAvMD+4DAtpbQeGBvrWhSoYzZQlDJZFDNsItDTbJF4VxnGYXWcADv+WILz9Dh2/vx5mmUX2TOx5EfDI4HUpiAPAjVALOVABEFgC7bjZC0ERxRzVRgkJCH2bKt0Ycty9QuEce+hZ2LMsOmxkqmCFrKuWFPyBS/kyHp67aaJUC1n7u734xhi22B6+udp36jXogsvhLX3/PnzCCBA5AnWoYiiyGKfAgxOCIvyhtAtVKMtk0TbbAdU94EuAbM/DDAYxjfeeMM899xz1kh0Qn31oxuFNv3YJzogcWHhXL58mT148ADmbXb69GnwJ6SXWFEyyzh1cOvQ+/CK41JK+EAswQ2HQ1fsYqWAn3NqogHwivOs+R6GGhzPsswiL+MaDsYApmIcxzF336oudtVczQF8D3hqnIPQLMTmRctIH5ADBVMwsA59/0ufqI4Ltl3X/KBvROxURJex6fNTenp+GlyLJwlgBDU2sro+OcYO0nVbd8H1Fdbiapwz6vd9rucmVrEtrOH6BqdtWZbghDZhFEG/6GMNfNMLUzo2euK/O8GRVuKy69CNI+ATd3d3WW1FByKzRfSCZIDxRGbBbDazHB2iI8YGXM0DALLjcIL+++0jE9z/D2pB+mEZu+eLAAAAAElFTkSuQmCC"
local B64CH = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function b64decode(s)
	local out, buf, bits = {}, 0, 0
	for i = 1, #s do
		local c = s:byte(i)
		if c == 61 then break end
		local v = B64CH:find(string.char(c), 1, true)
		if v then
			buf = buf * 64 + (v - 1)
			bits = bits + 6
			if bits >= 8 then
				bits = bits - 8
				local byte = math.floor(buf / 2 ^ bits) % 256
				buf = buf % 2 ^ bits
				out[#out + 1] = string.char(byte)
			end
		end
	end
	return table.concat(out)
end
local function randname()
	local t = {}
	for i = 1, 12 do t[i] = string.char(math.random(97, 122)) end
	return table.concat(t)
end
local GUI_NAME = "yall_holy_ui"
local HOST = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")
do
	local okp, p = pcall(function() return HOST end)
	if okp and p then
		for _, c in ipairs(p:GetChildren()) do
			if c:IsA("ScreenGui") and c.Name == GUI_NAME then
				pcall(function() c:Destroy() end)
			end
		end
	end
end
local gui = mk("ScreenGui", {
	Name = GUI_NAME, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000,
})
pcall(function()
	if protect_gui then protect_gui(gui) end
end)
do
	local ok = pcall(function() gui.Parent = HOST end)
	if not ok or not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
end
lib.scr = gui
local sounds = {}
for _, n in ipairs({ "open", "click", "tick", "soft" }) do
	sounds[n] = mk("Sound", { SoundId = "rbxasset://sounds/electronicpingshort.wav", Volume = 0.34, Name = randname() }, gui)
end
local SOUNDSPEC = { open = { 0.8, 0.42 }, click = { 1.32, 0.3 }, tick = { 1.18, 0.22 }, soft = { 1.22, 0.26 } }
function lib:chime(kind)
	if not self.sound then return end
	local s, spec = sounds[kind or "click"], SOUNDSPEC[kind or "click"]
	if not s then return end
	s.PlaybackSpeed = spec[1] * (TONEMUL[self.tone] or 1)
	s.Volume = spec[2]
	s.TimePosition = 0
	s:Play()
end
local function mpos(input)
	local o = (gui and gui.AbsolutePosition) or Vector2.new(0, 0)
	if input and input.UserInputType == Enum.UserInputType.Touch then
		local p = input.Position or Vector2.new(0, 0)
		return Vector2.new(p.X, p.Y)
	end
	local m = UserInputService:GetMouseLocation()
	return Vector2.new(m.X + o.X, m.Y + o.Y)
end
local function inside(f, pos)
	if not f or not f.Parent then return false end
	local a, s = f.AbsolutePosition, f.AbsoluteSize
	return pos.X >= a.X and pos.X <= a.X + s.X and pos.Y >= a.Y and pos.Y <= a.Y + s.Y
end
local function insidepad(f, pos, pd)
	if not f or not f.Parent then return false end
	local a, s = f.AbsolutePosition, f.AbsoluteSize
	return pos.X >= a.X - pd and pos.X <= a.X + s.X + pd and pos.Y >= a.Y - pd and pos.Y <= a.Y + s.Y + pd
end
local function insideany(f, pos, pd)
	if not f or not f.Parent then return false end
	local x0, y0 = f.AbsolutePosition.X, f.AbsolutePosition.Y
	local x1, y1 = x0 + f.AbsoluteSize.X, y0 + f.AbsoluteSize.Y
	for _, d in ipairs(f:GetDescendants()) do
		if d:IsA("GuiObject") and d.Visible then
			local pp, vis = d, true
			while pp and pp ~= f do
				if pp:IsA("GuiObject") and not pp.Visible then vis = false break end
				pp = pp.Parent
			end
			if vis then
				local a, s = d.AbsolutePosition, d.AbsoluteSize
				if s.X > 2 and s.Y > 2 then
					if a.X < x0 then x0 = a.X end
					if a.Y < y0 then y0 = a.Y end
					if a.X + s.X > x1 then x1 = a.X + s.X end
					if a.Y + s.Y > y1 then y1 = a.Y + s.Y end
				end
			end
		end
	end
	return pos.X >= x0 - pd and pos.X <= x1 + pd and pos.Y >= y0 - pd and pos.Y <= y1 + pd
end
local stack = {}
local function closeto(n)
	while #stack > n do
		local e = table.remove(stack)
		pcall(e.close)
	end
end
local function openpop(frame, owner, closefn, alignleft, side, card)
	local keep = 0
	for i, e in ipairs(stack) do
		if owner:IsDescendantOf(e.frame) then keep = i end
	end
	closeto(keep)
	stack[#stack + 1] = { frame = frame, owner = owner, close = closefn, align = alignleft, side = side, card = card }
end
local function ispop(frame)
	for _, e in ipairs(stack) do if e.frame == frame then return true end end
	return false
end
local function closepop(frame)
	for i, e in ipairs(stack) do
		if e.frame == frame then closeto(i - 1) return end
	end
end
local function placepop(frame, owner, alignleft)
	local ap, as = owner.AbsolutePosition, owner.AbsoluteSize
	local off = gui.AbsolutePosition
	local cam = workspace.CurrentCamera
	local vs = (cam and cam.ViewportSize) or gui.AbsoluteSize
	local uis = frame:FindFirstChildOfClass("UIScale")
	local usc = (uis and uis.Scale > 0) and uis.Scale or 1
	local fw, fh = frame.AbsoluteSize.X / usc, frame.AbsoluteSize.Y / usc
	if fw < 8 then fw = 180 end
	if fh < 8 then fh = 60 end
	local ox, oy = ap.X - off.X, ap.Y - off.Y
	local x = alignleft and ox or (ox + as.X - fw)
	local w2 = lib.focus
	if w2 and w2.shell and w2.shell.Parent and w2.shell.Visible and (owner:IsDescendantOf(w2.shell) or w2.shell:IsDescendantOf(owner)) then
		local wa = w2.shell.AbsolutePosition - off
		local ww = w2.shell.AbsoluteSize.X
		x = math.clamp(x, wa.X + 6, math.max(wa.X + 6, wa.X + ww - fw - 6))
	end
	x = math.clamp(x, 0, math.max(0, vs.X - fw))
	local y = oy + as.Y + 4
	if y + fh > vs.Y then y = math.max(0, oy - fh - 4) end
	frame.Position = UDim2.fromOffset(math.round(x), math.round(y))
end
local function placepopside(frame, owner, side, card)
	local off = gui.AbsolutePosition
	local cam = workspace.CurrentCamera
	local vs = (cam and cam.ViewportSize) or gui.AbsoluteSize
	local uis = frame:FindFirstChildOfClass("UIScale")
	local usc = (uis and uis.Scale > 0) and uis.Scale or 1
	local fw, fh = frame.AbsoluteSize.X / usc, frame.AbsoluteSize.Y / usc
	if fw < 8 then fw = 180 end
	if fh < 8 then fh = 60 end
	local oa2, osz = owner.AbsolutePosition - off, owner.AbsoluteSize
	local x
	if side == "left" then
		x = oa2.X + osz.X + 12
	else
		x = oa2.X - fw - 12
	end
	local w2 = lib.focus
	if w2 and w2.shell and w2.shell.Parent and w2.shell.Visible and card and card:IsDescendantOf(w2.shell) then
		local wa = w2.shell.AbsolutePosition - off
		local ww = w2.shell.AbsoluteSize.X
		x = math.clamp(x, wa.X + 6, math.max(wa.X + 6, wa.X + ww - fw - 6))
	end
	x = math.clamp(x, 0, math.max(0, vs.X - fw))
	local y = owner.AbsolutePosition.Y - off.Y - 6
	if y + fh > vs.Y then y = math.max(0, vs.Y - fh - 6) end
	frame.Position = UDim2.fromOffset(math.round(x), math.round(y))
end
local function popup_frame(w)
	local f = mk("CanvasGroup", {
		Visible = false, GroupTransparency = 1, ZIndex = 300, BorderSizePixel = 0,
		Size = UDim2.fromOffset(w, 0), AutomaticSize = Enum.AutomaticSize.Y, bind = { BackgroundColor3 = "panel" },
	}, gui)
	corner(f, 8); stroke(f, "line", 0.35)
	mk("UIScale", { Scale = 0.94 }, f)
	return f
end
local hiding = {}
local POPIN = TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local POPOUT = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local function stagger(f)
	local i = 0
	for _, ch in ipairs(f:GetChildren()) do
		if ch:IsA("CanvasGroup") then
			i = i + 1
			local pd = ch:FindFirstChildOfClass("UIPadding")
			ch.GroupTransparency = 1
			if pd then pd.PaddingTop = UDim.new(0, 8) end
			task.delay(0.04 * i, function()
				if not ch.Parent then return end
				tw(ch, { GroupTransparency = 0 }, POPIN)
				if pd then tw(pd, { PaddingTop = UDim.new(0, 0) }, POPIN) end
			end)
		elseif ch:IsA("TextLabel") then
			i = i + 1
			local tt = ch:GetAttribute("tt0")
			if tt == nil then
				tt = ch.TextTransparency
				ch:SetAttribute("tt0", tt)
			end
			ch.TextTransparency = 1
			task.delay(0.04 * i, function()
				if ch.Parent then tw(ch, { TextTransparency = tt }, POPIN) end
			end)
		end
	end
end
local function popshow(f)
	hiding[f] = nil
	local sc = f:FindFirstChildOfClass("UIScale")
	local fresh = not f.Visible
	if fresh then
		f.GroupTransparency = 1
		if sc then sc.Scale = 0.94 end
	end
	f.Visible = true
	tw(f, { GroupTransparency = 0 }, POPIN)
	if sc then tw(sc, { Scale = 1 }, POPIN) end
	if fresh then stagger(f) end
end
local function pophide(f, destroy)
	local tag = (hiding[f] or 0) + 1
	hiding[f] = tag
	local sc = f:FindFirstChildOfClass("UIScale")
	tw(f, { GroupTransparency = 1 }, POPOUT)
	if sc then tw(sc, { Scale = 0.96 }, POPOUT) end
	task.delay(0.18, function()
		if hiding[f] == tag then
			hiding[f] = nil
			if destroy then f:Destroy() else f.Visible = false end
		end
	end)
end
local dragfn, dragend, listener
local smoothdrag
local function startdrag(fn, onend) dragfn = fn; dragend = onend end
conn(UserInputService.InputChanged, function(input)
	if dragfn and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		dragfn(mpos(input))
	end
end)
conn(UserInputService.InputEnded, function(input)
	local t = input.UserInputType
	if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
		dragfn = nil
		local e = dragend
		dragend = nil
		if e then pcall(e) end
	end
	if t == Enum.UserInputType.Keyboard then
		for _, el in ipairs(lib.keybinds) do
			if el.value == input.KeyCode and el.down then
				el.down = false
				if lib._hkpaint then lib._hkpaint() end
				if el.mode == "hold" then safe(el.callback, false) end
			end
		end
	end
end)
local modal, modalclose, modalbox, closemodal, modalshadow, modalscale
conn(UserInputService.InputBegan, function(input, gp)
	local t = input.UserInputType
	if modal then
		if t == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
			local c = modalclose
			modalclose = nil
			closemodal(true)
			if c then safe(c) end
		elseif t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
			if not (modalbox and modalbox.Parent and insidepad(modalbox, mpos(input), 10)) then
				local c = modalclose
				modalclose = nil
				closemodal(true)
				if c then safe(c) end
			end
		end
		return
	end
	if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
		local oc = mpos(input)
		local keep = 0
		for i, e in ipairs(stack) do
			if insideany(e.frame, oc, 6) or insidepad(e.owner, oc, 6) then keep = i end
		end
		closeto(keep)
	end
	if listener then
		local fn = listener
		if t == Enum.UserInputType.Keyboard then
			listener = nil
			fn(input.KeyCode)
		elseif t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
			listener = nil
			fn(nil, true)
		end
		return
	end
	if gp or t ~= Enum.UserInputType.Keyboard then return end
	for _, w in ipairs(lib.wins) do
		if w.bind and input.KeyCode == w.bind then w:toggle() end
	end
	for _, el in ipairs(lib.keybinds) do
		if el.value and el.value == input.KeyCode then
			el.down = true
			if lib._hkpaint then lib._hkpaint() end
			safe(el.callback, el.value)
		end
	end
end)
local function setlistener(fn)
	task.defer(function() listener = fn end)
end
conn(RunService.RenderStepped, function()
	for _, e in ipairs(stack) do
		if e.frame and e.frame.Parent and e.frame.Visible and e.owner and e.owner.Parent then
			if e.side then placepopside(e.frame, e.owner, e.side, e.card) else placepop(e.frame, e.owner, e.align) end
		end
	end
end)
local smoothers = {}
local function dragto(handle, target, onclick, smooth)
	handle.InputBegan:Connect(function(input)
		local ty = input.UserInputType
		if ty ~= Enum.UserInputType.MouseButton1 and ty ~= Enum.UserInputType.Touch then return end
		if #stack > 0 then return end
		local start = mpos(input)
		local p = target.Position
		local ox, oy, sx, sy = p.X.Offset, p.Y.Offset, p.X.Scale, p.Y.Scale
		local as = target.AbsoluteSize
		local baseX, baseY = target.AbsolutePosition.X, target.AbsolutePosition.Y
		local moved = false
		local lastX, lastY = ox, oy
		local function place(nx, ny)
			local cx, cy = nx, ny
			if smooth then
				local m = smoothers[target]
				if not m then m = { cx = cx, cy = cy } smoothers[target] = m end
				m.sx, m.sy = sx, sy
				m.gx, m.gy = cx, cy
				m.active = true
			else
				lastX, lastY = cx, cy
				target.Position = UDim2.new(sx, cx, sy, cy)
			end
		end
		startdrag(function(pos)
			local dx, dy = pos.X - start.X, pos.Y - start.Y
			if not moved and (math.abs(dx) + math.abs(dy)) > 3 then moved = true end
			if not moved then return end
			place(ox + dx, oy + dy)
		end, function()
			if not moved and onclick then onclick() end
		end)
	end)
end
local function fastdrag(handle, target, onclick) dragto(handle, target, onclick, true) end
smoothdrag = function(handle, target, onclick) dragto(handle, target, onclick, true) end
conn(RunService.RenderStepped, function(dt)
	for target, m in pairs(smoothers) do
		if not target.Parent then
			smoothers[target] = nil
		elseif m.active then
			local k = 1 - math.exp(-dt * 18)
			m.cx = m.cx + ((m.gx or m.cx) - m.cx) * k
			m.cy = m.cy + ((m.gy or m.cy) - m.cy) * k
			if math.abs((m.gx or 0) - m.cx) < 0.2 and math.abs((m.gy or 0) - m.cy) < 0.2 then
				m.cx, m.cy, m.active = m.gx or m.cx, m.gy or m.cy, false
			end
			target.Position = UDim2.new(m.sx, m.cx, m.sy, m.cy)
		end
	end
end)
local container
local function container_new(parent, ctx)
	local c = { parent = parent }
	local n = 0
	local function click() lib:chime("click") end
	local function row(h, name)
		n = n + 1
		local r
		if ctx.popup then
			r = mk("CanvasGroup", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, h), LayoutOrder = n, ZIndex = 5, GroupTransparency = parent.Visible and 0 or 1 }, parent)
			mk("UIPadding", { PaddingTop = UDim.new(0, 0) }, r)
		else
			r = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, h), LayoutOrder = n, ZIndex = 5 }, parent)
		end
		if ctx.pg then
			ctx.pg.elems[#ctx.pg.elems + 1] = { name = string.lower(name or ""), frame = r, card = ctx.card }
		end
		return r
	end
	local function done(cfg, el)
		if cfg.flag then
			local cb = el.callback
			if type(cb) == "function" and not el._wrapped then
				el.callback = function(...) lib:markdirty() return cb(...) end
			end
			local setter = el.set
			if type(setter) == "function" then
				el.set = function(self, ...) lib:markdirty() return setter(self, ...) end
				if el.setkey then el.setkey = el.set end
			end
			el._wrapped = true
			lib.flags[cfg.flag] = el; el.flag = cfg.flag
		end
		return el
	end
	local function attachbind(node, el, kind, name)
		el.bind = { key = nil, mode = "toggle" }
		local function fire(pressed)
			if el.bind.mode == "hold" then
				if kind == "toggle" then
					el:set(pressed and true or false)
				else
					safe(el.callback, pressed and true or false)
				end
			elseif kind == "toggle" then
				if pressed then el:set(not el:get()) end
			elseif pressed then
				safe(el.callback)
			end
		end
		el.callback = el.callback or function() end
		local hud = { value = nil, name = name or "bind", mode = el.bind.mode, callback = fire, down = false }
		function hud.setkey(k)
			el.bind.key = k
			hud.value = k
			if lib._hkrefresh then lib._hkrefresh() end
		end
		lib.keybinds[#lib.keybinds + 1] = hud
		el._hud = hud
		local pop = popup_frame(212)
		pad(pop, 14, 14, 14, 14); vlist(pop, 10)
		lbl(pop, { Text = tostring(name or "bind"), LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 18), TextSize = 13, ZIndex = 301 })
		local brow = mk("CanvasGroup", { LayoutOrder = 2, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), ZIndex = 301 }, pop)
		mk("UIPadding", { PaddingTop = UDim.new(0, 0) }, brow)
		local bx = mk("Frame", { Position = UDim2.fromOffset(0, 5), Size = UDim2.fromOffset(15, 15), ZIndex = 302, BorderSizePixel = 0, bind = { BackgroundColor3 = "head" } }, brow)
		corner(bx, 4); stroke(bx, "line", 0.2)
		local tick = img(bx, {
			Image = icon("check"), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(11, 11), ZIndex = 303, ImageColor3 = THEME.bg, ImageTransparency = 1,
		})
		lbl(brow, { Text = "bind", Position = UDim2.fromOffset(22, 6), Size = UDim2.fromOffset(30, 14), TextSize = 10, TextColor3 = THEME.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 302 })
		local keybox = mk("TextButton", {
			AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -26, 0, 2), Size = UDim2.fromOffset(88, 22), Text = "None",
			Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = THEME.text, ZIndex = 302, BorderSizePixel = 0, AutoButtonColor = false,
			bind = { BackgroundColor3 = "head" },
		}, brow)
		corner(keybox, 6); stroke(keybox, "line", 0.35)
		local del = mk("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(20, 20), Text = "",
			ZIndex = 302, BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false,
		}, brow)
		img(del, {
			Image = icon("trash-2"), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(13, 13), ZIndex = 303, ImageColor3 = THEME.dim, ImageTransparency = 0.3,
		})
		local bxhit = mk("TextButton", { Text = "", BackgroundTransparency = 1, Position = UDim2.fromOffset(-2, 0), Size = UDim2.fromOffset(22, 26), ZIndex = 304, AutoButtonColor = false }, brow)
		local function paintbox()
			local on = (kind == "toggle") and el:get() or false
			tw(bx, { BackgroundColor3 = on and THEME.accent or THEME.head }, NOW)
			tw(tick, { ImageTransparency = on and 0 or 1, ImageColor3 = THEME.bg }, NOW)
		end
		bxhit.MouseButton1Click:Connect(function()
			if kind == "toggle" then el:set(not el:get()) end
			paintbox()
			click()
		end)
		del.MouseButton1Click:Connect(function()
			listener = nil
			el.bind.key = nil
			hud.value = nil
			keybox.Text = "None"
			if lib._hkrefresh then lib._hkrefresh() end
			click()
		end)
		local mrow = mk("CanvasGroup", { LayoutOrder = 3, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), ZIndex = 301 }, pop)
		mk("UIPadding", { PaddingTop = UDim.new(0, 0) }, mrow)
		mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, mrow)
		local mbtns = {}
		for i, m in ipairs({ "toggle", "hold" }) do
			local b = mk("TextButton", {
				LayoutOrder = i, Size = UDim2.new(0.5, -3, 1, 0), Text = m, Font = Enum.Font.GothamBold, TextSize = 11,
				TextColor3 = THEME.dim, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 302,
				bind = { BackgroundColor3 = "side" },
			}, mrow)
			corner(b, 6)
			mbtns[m] = b
		end
		local function paintmode()
			for m, b in pairs(mbtns) do
				b.TextColor3 = (el.bind.mode == m) and THEME.text or THEME.dim
			end
			hud.mode = el.bind.mode
		end
		for m, b in pairs(mbtns) do
			b.MouseButton1Click:Connect(function()
				listener = nil
				el.bind.mode = m
				paintmode()
				click()
			end)
		end
		keybox.MouseButton1Click:Connect(function()
			keybox.Text = "press a key"
			setlistener(function(k, cancel)
				listener = nil
				if cancel then
					-- clicked away: keep whatever bind was there
					keybox.Text = el.bind.key and el.bind.key.Name or "None"
				elseif not k or k == Enum.KeyCode.Escape or k == Enum.KeyCode.Backspace then
					el.bind.key = nil
					hud.value = nil
					keybox.Text = "None"
				else
					el.bind.key = k
					hud.value = k
					keybox.Text = k.Name
				end
				if lib._hkrefresh then lib._hkrefresh() end
			end)
		end)
		node.MouseButton2Click:Connect(function()
			if ispop(pop) then closepop(pop) return end
			paintbox()
			paintmode()
			keybox.Text = el.bind.key and el.bind.key.Name or "None"
			popshow(pop)
			openpop(pop, node, function()
				local fn = listener
				listener = nil
				if fn then fn(nil, true) end
				pophide(pop)
			end, true, c.side, c.card)
			task.defer(placepopside, pop, node, c.side, c.card)
		end)
	end
	function c:toggle(cfg)
		cfg = cfg or {}
		local r = row(26, cfg.name)
		local box = mk("Frame", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 5, 0.5, 0), Size = UDim2.fromOffset(16, 16),
			ZIndex = 6, BorderSizePixel = 0, BackgroundTransparency = 1, bind = { BackgroundColor3 = "accent" },
		}, r)
		corner(box, 4)
		local bst = stroke(box, "line", 0.2)
		local tick = img(box, {
			Image = icon("check"), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(6, 6), ZIndex = 7, ImageTransparency = 1, bind = { ImageColor3 = "bg" },
		})
		local nm = lbl(r, {
			Text = cfg.name or "toggle", Position = UDim2.fromOffset(29, 0), TextSize = 13,
			Size = UDim2.new(1, cfg.options and -60 or -35, 1, 0), TextColor3 = THEME.dim, TextTransparency = 0.35,
		})
		local hit = mk("ImageButton", {
			Size = UDim2.fromScale(1, 1), ZIndex = 8, BackgroundTransparency = 1, ImageTransparency = 1,
			AutoButtonColor = false, Selectable = false,
		}, r)
		local el = { value = false, callback = cfg.callback }
		local hover = false
		local function paint(anim)
			local info = anim and EASE or NOW
			local on = el.value
			tw(box, { BackgroundTransparency = on and 0.05 or 1 }, info)
			tw(bst, { Transparency = on and 1 or 0.2 }, info)
			tw(tick, { Size = on and UDim2.fromOffset(12, 12) or UDim2.fromOffset(6, 6), ImageTransparency = on and 0 or 1 }, info)
			tw(nm, { TextColor3 = on and THEME.text or THEME.dim, TextTransparency = on and 0 or (hover and 0.15 or 0.35) }, info)
		end
		reapply[#reapply + 1] = function() paint(false) end
		function el:get() return el.value end
		function el:set(v, silent)
			v = v and true or false
			if v == el.value then return end
			el.value = v
			paint(true)
			if not silent then
				local ok, res = pcall(el.callback, v)
				if ok and res == false then el.value = not v; paint(true) end
			end
		end
		hit.MouseEnter:Connect(function() hover = true; if not el.value then paint(true) end end)
		hit.MouseLeave:Connect(function() hover = false; if not el.value then paint(true) end end)
		hit.MouseButton1Click:Connect(function() lib:chime("tick"); el:set(not el.value) end)
		attachbind(hit, el, "toggle", cfg.name or "toggle")
		if cfg.options then
			local gear = mk("ImageButton", {
				AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -5, 0.5, 0), Size = UDim2.fromOffset(21, 21),
				BackgroundTransparency = 1, Image = icon("ellipsis"), ImageColor3 = THEME.dim, ImageTransparency = 0.35,
				ScaleType = Enum.ScaleType.Fit, ZIndex = 10, AutoButtonColor = false, Selectable = false, bind = { BackgroundColor3 = "head" },
			}, r)
			corner(gear, 6)
			local holder = popup_frame(184)
			pad(holder, 12, 12, 12, 12); vlist(holder, 8)
			el.options = container_new(holder, { popup = true })
			el.options._owner = el
			gear.MouseEnter:Connect(function() tw(gear, { BackgroundTransparency = 0.4, ImageColor3 = THEME.text, ImageTransparency = 0 }) end)
			gear.MouseLeave:Connect(function() tw(gear, { BackgroundTransparency = 1, ImageColor3 = THEME.dim, ImageTransparency = 0.35 }) end)
			gear.MouseButton1Click:Connect(function()
				if ispop(holder) then closepop(holder) return end
				popshow(holder)
				openpop(holder, gear, function() pophide(holder) end, nil, c.side, c.card)
				task.defer(placepopside, holder, gear, c.side, c.card)
			end)
		end
		if cfg.default then
			el.value = true
			task.defer(safe, el.callback, true)
		end
		paint(false)
		return done(cfg, el)
	end
	function c:checkbox(cfg)
		cfg = cfg or {}
		cfg.name = cfg.name or "checkbox"
		return c:toggle(cfg)
	end
	function c:space(px)
		n = n + 1
		mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, tonumber(px) or 8), LayoutOrder = n, ZIndex = 5, BorderSizePixel = 0 }, parent)
	end
	function c:slider(cfg)
		cfg = cfg or {}
		local min, max = tonumber(cfg.min) or 0, tonumber(cfg.max) or 100
		local step = tonumber(cfg.step) or 1
		if step <= 0 then step = 1 end
		local dec = math.max(0, math.ceil(-math.log10(step) - 1e-9))
		local suffix = cfg.suffix or ""
		local r = row(32, cfg.name)
		lbl(r, { Text = cfg.name or "slider", Position = UDim2.fromOffset(5, 1), Size = UDim2.new(1, -74, 0, 16), TextSize = 13, TextColor3 = THEME.dim, TextTransparency = 0.35 })
		local vl = lbl(r, {
			AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -5, 0, 1), Size = UDim2.fromOffset(64, 16),
			TextXAlignment = Enum.TextXAlignment.Right, TextSize = 12, TextTransparency = 0.2,
		})
		local track = mk("Frame", {
			Position = UDim2.fromOffset(5, 22), Size = UDim2.new(1, -10, 0, 6), ZIndex = 6, BorderSizePixel = 0,
			BackgroundTransparency = 0.12, bind = { BackgroundColor3 = "head" },
		}, r)
		corner(track, "full")
		local fill = mk("Frame", { Size = UDim2.new(0, 6, 1, 0), ZIndex = 7, BorderSizePixel = 0, BackgroundTransparency = 0.1, bind = { BackgroundColor3 = "accent" } }, track)
		corner(fill, "full")
		local hit = mk("ImageButton", {
			Position = UDim2.fromOffset(0, 13), Size = UDim2.new(1, 0, 0, 19), ZIndex = 9, BackgroundTransparency = 1,
			ImageTransparency = 1, AutoButtonColor = false, Selectable = false,
		}, r)
		local el = { value = min, callback = cfg.callback, min = min, max = max, name = cfg.name }
		if c._owner then c._owner._bindslider = el end
		local function setv(v, silent, anim)
			v = math.clamp(math.floor((v - min) / step + 0.5) * step + min, min, max)
			v = tonumber(string.format("%." .. dec .. "f", v))
			local changed = v ~= el.value
			el.value = v
			vl.Text = string.format("%." .. dec .. "f", v) .. suffix
			local a = (max > min) and (v - min) / (max - min) or 0
			tw(fill, { Size = UDim2.new(a, 6 * (1 - a), 1, 0) }, anim and FAST or NOW)
			if changed then
				lib:markdirty()
				if not silent then safe(el.callback, v) end
			end
		end
		function el:get() return el.value end
		function el:set(v, silent) setv(tonumber(v) or min, silent, true) end
		hit.InputBegan:Connect(function(input)
			local t = input.UserInputType
			if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
				local function upd(pos)
					local a = math.clamp((pos.X - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
					setv(min + a * (max - min), false, true)
				end
				upd(mpos(input))
				startdrag(upd)
			end
		end)
		if cfg.default ~= nil then
			setv(tonumber(cfg.default) or min, true, false)
			task.defer(safe, el.callback, el.value)
		else
			setv(min, true, false)
		end
		return done(cfg, el)
	end
	function c:combo(cfg)
		cfg = cfg or {}
		local multi = cfg.multi and true or false
		local el = { list = cfg.list or {}, multi = multi, callback = cfg.callback }
		local r = row(26, cfg.name)
		local boxw = 0
		if not multi then
			local longest = 0
			for _, nme in ipairs(el.list) do longest = math.max(longest, tsize(nme, 11, Enum.Font.GothamMedium).X) end
			boxw = math.clamp(math.ceil(longest) + 40, 86, 150)
		end
		lbl(r, { Text = cfg.name or "dropdown", Position = UDim2.fromOffset(5, 0), Size = multi and UDim2.new(0.42, -8, 1, 0) or UDim2.new(1, -(boxw + 13), 1, 0), TextSize = 13, TextColor3 = THEME.dim, TextTransparency = 0.35 })
		local box = mk("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -5, 0.5, 0), Size = multi and UDim2.new(0.58, -5, 0, 21) or UDim2.new(0, boxw, 0, 21),
			Text = "", ZIndex = 6, BorderSizePixel = 0, AutoButtonColor = false, bind = { BackgroundColor3 = "head" },
		}, r)
		corner(box, 6)
		local bst = stroke(box, "line", 0.5)
		local vt = lbl(box, { Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -28, 1, 0), Font = Enum.Font.GothamMedium, TextSize = 11 })
		local chev = img(box, {
			AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0), Size = UDim2.fromOffset(12, 12),
			Image = icon("chevron-down"),
		})
		local sel = multi and {} or nil
		local function ordered(set)
			local out = {}
			for _, name in ipairs(el.list) do
				if set[name] then out[#out + 1] = name end
			end
			return out
		end
		local function txt()
			if multi then
				if #sel == 0 then return "none" end
				return table.concat(sel, ", ")
			end
			return sel ~= nil and tostring(sel) or "none"
		end
		local function refresh() vt.Text = txt() end
		function el:get()
			if multi then
				local o = {}
				for i, v in ipairs(sel) do o[i] = v end
				return o
			end
			return sel
		end
		function el:set(v, silent)
			if multi then
				local set = {}
				if type(v) == "table" then
					for _, x in ipairs(v) do set[x] = true end
				elseif v ~= nil then
					set[v] = true
				end
				sel = ordered(set)
			else
				if type(v) == "table" then v = v[1] end
				sel = v
			end
			refresh()
			if not silent then safe(el.callback, el:get()) end
		end
		function el:setlist(list)
			el.list = list or {}
			if multi then
				local set = {}
				for _, x in ipairs(sel) do set[x] = true end
				sel = ordered(set)
			elseif sel ~= nil and not table.find(el.list, sel) then
				sel = el.list[1]
			end
			refresh()
		end
		local pop
		local function build()
			if pop then pop:Destroy() end
			pop = popup_frame(math.max(130, box.AbsoluteSize.X))
			pad(pop, 4, 4, 4, 4)
			local h = math.min(#el.list * 23 + 8, 180)
			pop.AutomaticSize = Enum.AutomaticSize.None
			pop.Size = UDim2.fromOffset(math.max(130, box.AbsoluteSize.X), h)
			local sc = mk("ScrollingFrame", {
				BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 301, BorderSizePixel = 0,
				ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			}, pop)
			vlist(sc, 1)
			local function mark()
				for _, b in ipairs(sc:GetChildren()) do
					if b:IsA("TextButton") then
						local on
						if multi then on = table.find(sel, b.Name) ~= nil else on = sel == b.Name end
						tw(b, { TextColor3 = on and THEME.text or THEME.dim, BackgroundTransparency = on and 0.7 or 1 }, FAST)
					end
				end
			end
			for i, name in ipairs(el.list) do
				local b = mk("TextButton", {
					Name = tostring(name), LayoutOrder = i, Text = "   " .. tostring(name), Font = Enum.Font.GothamMedium, TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.dim, Size = UDim2.new(1, 0, 0, 22),
					BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 302, AutoButtonColor = false,
					bind = { BackgroundColor3 = "line" },
				}, sc)
				corner(b, 5)
				b.MouseEnter:Connect(function()
					local on
					if multi then on = table.find(sel, b.Name) ~= nil else on = sel == b.Name end
					if not on then tw(b, { TextColor3 = THEME.text }, FAST) end
				end)
				b.MouseLeave:Connect(mark)
				b.MouseButton1Click:Connect(function()
					lib:chime("tick")
					if multi then
						local set = {}
						for _, x in ipairs(sel) do set[x] = true end
						set[name] = not set[name] or nil
						el:set(ordered(set))
						mark()
					else
						el:set(name)
						mark()
					end
				end)
			end
			mark()
		end
		box.MouseButton1Click:Connect(function()
			if pop and ispop(pop) then closepop(pop) return end
			build()
			popshow(pop)
			tw(chev, { Rotation = 180 }, FAST)
			local mypop = pop
			openpop(pop, box, function() pophide(mypop, true); tw(chev, { Rotation = 0 }, FAST) end, true)
			task.defer(placepop, pop, box, true)
		end)
		box.MouseEnter:Connect(function() tw(bst, { Transparency = 0.25 }) end)
		box.MouseLeave:Connect(function() tw(bst, { Transparency = 0.5 }) end)
		if multi then
			el:set(cfg.default, true)
		else
			el:set(cfg.default ~= nil and cfg.default or el.list[1], true)
		end
		if cfg.default ~= nil then task.defer(safe, el.callback, el:get()) end
		return done(cfg, el)
	end
	function c:color(cfg)
		cfg = cfg or {}
		local key = cfg.key
		local r = row(22, cfg.name)
		lbl(r, { Text = cfg.name or "color", Size = UDim2.new(1, -40, 1, 0), TextColor3 = THEME.dim })
		local sw = mk("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(34, 18),
			Text = "", ZIndex = 6, BorderSizePixel = 0, AutoButtonColor = false,
		}, r)
		corner(sw, 5); stroke(sw, "line", 0.6)
		local el = { value = cfg.default or (key and THEME[key]) or Color3.new(1, 1, 1), callback = cfg.callback }
		local h, s, v = el.value:ToHSV()
		sw.BackgroundColor3 = el.value
		local pk
		local function apply(silent)
			el.value = Color3.fromHSV(h, s, v)
			sw.BackgroundColor3 = el.value
			if pk then pk.paint() end
			if key then lib:recolor(key, el.value) end
			if not silent then
				lib:markdirty()
				safe(el.callback, el.value)
			end
		end
		function el:get() return el.value end
		function el:set(c3, silent)
			if typeof(c3) ~= "Color3" then return end
			h, s, v = c3:ToHSV()
			apply(silent)
		end
		local function buildpicker()
			local f = popup_frame(176)
			f.AutomaticSize = Enum.AutomaticSize.None
			f.Size = UDim2.fromOffset(176, 170)
			local svf = mk("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(160, 100), ZIndex = 301, BorderSizePixel = 0, ClipsDescendants = true }, f)
			corner(svf, 4)
			local white = mk("Frame", { Size = UDim2.fromScale(1, 1), ZIndex = 302, BorderSizePixel = 0, BackgroundColor3 = Color3.new(1, 1, 1) }, svf)
			grad(white, 0, { { 0, 0 }, { 1, 1 } })
			local black = mk("Frame", { Size = UDim2.fromScale(1, 1), ZIndex = 303, BorderSizePixel = 0, BackgroundColor3 = Color3.new(0, 0, 0) }, svf)
			grad(black, 90, { { 0, 1 }, { 1, 0 } })
			local cur = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(8, 8), ZIndex = 305, BackgroundTransparency = 1, BorderSizePixel = 0 }, svf)
			corner(cur, "full")
			mk("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, cur)
			local hue = mk("Frame", { Position = UDim2.fromOffset(8, 116), Size = UDim2.fromOffset(160, 10), ZIndex = 301, BorderSizePixel = 0, BackgroundColor3 = Color3.new(1, 1, 1) }, f)
			corner(hue, 4)
			mk("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
				}),
			}, hue)
			local hcur = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(3, 14), ZIndex = 303, BorderSizePixel = 0, BackgroundColor3 = Color3.new(1, 1, 1) }, hue)
			corner(hcur, 2)
			local hex = mk("TextBox", {
				Position = UDim2.fromOffset(8, 136), Size = UDim2.fromOffset(160, 26), ZIndex = 301, BorderSizePixel = 0, Text = "",
				Font = Enum.Font.GothamMedium, TextSize = 12, ClearTextOnFocus = false, PlaceholderText = "#ffffff",
				bind = { BackgroundColor3 = "head", TextColor3 = "text", PlaceholderColor3 = "dim" },
			}, f)
			corner(hex, 6); stroke(hex, "line", 0.5)
			local p = {}
			function p.paint()
				svf.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				cur.Position = UDim2.fromScale(s, 1 - v)
				hcur.Position = UDim2.fromScale(h, 0.5)
				hex.Text = "#" .. el.value:ToHex()
			end
			svf.InputBegan:Connect(function(input)
				local t = input.UserInputType
				if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
					local function upd(pos)
						s = math.clamp((pos.X - svf.AbsolutePosition.X) / svf.AbsoluteSize.X, 0, 1)
						v = 1 - math.clamp((pos.Y - svf.AbsolutePosition.Y) / svf.AbsoluteSize.Y, 0, 1)
						apply()
					end
					upd(mpos(input)); startdrag(upd)
				end
			end)
			hue.InputBegan:Connect(function(input)
				local t = input.UserInputType
				if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
					local function upd(pos)
						h = math.clamp((pos.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 0.999)
						apply()
					end
					upd(mpos(input)); startdrag(upd)
				end
			end)
			hex.FocusLost:Connect(function()
				local ok, c3 = pcall(Color3.fromHex, hex.Text)
				if ok and c3 then el:set(c3) else p.paint() end
			end)
			p.frame = f
			return p
		end
		sw.MouseButton1Click:Connect(function()
			if not pk then pk = buildpicker() end
			if ispop(pk.frame) then closepop(pk.frame) return end
			pk.paint()
			popshow(pk.frame)
			openpop(pk.frame, sw, function() pophide(pk.frame) end)
			task.defer(placepop, pk.frame, sw)
		end)
		if cfg.default ~= nil or key then
			if key then lib:recolor(key, el.value) end
			if cfg.default ~= nil then task.defer(safe, el.callback, el.value) end
		end
		return done(cfg, el)
	end
	function c:themes()
		local names = {}
		for _, p in ipairs(lib.themes) do names[#names + 1] = p.name end
		names[#names + 1] = "Custom"
		local e = { parent = self.parent, colors = {} }
		e.preset = self:combo({
			name = "Theme", list = names,
			callback = function(nme) if nme ~= "Custom" then lib:settheme(nme) end end,
		})
		e.gradient = self:checkbox({
			name = "Gradient",
			callback = function(on) lib:setgradient(on) end,
		})
		e.angle = self:slider({
			name = "Gradient Angle", min = 0, max = 360, step = 1, suffix = "°",
			callback = function(a) lib:setgradient(lib.gradient, a) end,
		})
		for _, tc in ipairs(lib.themecolors) do
			local key = tc.key
			e.colors[key] = self:color({ name = tc.name, callback = function(col) lib:recolor(key, col) end })
		end
		lib._themeeditors[#lib._themeeditors + 1] = e
		lib:_refreshtheme()
		return e
	end
	local function tokey(x)
		if typeof(x) == "EnumItem" then return x end
		if type(x) == "string" and x ~= "" and x ~= "none" then
			local ok, k = pcall(function() return Enum.KeyCode[x] end)
			if ok then return k end
		end
		return nil
	end
	local KEYSHORT = {
		Insert = "Ins", Delete = "Del", LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift",
		LeftAlt = "LAlt", RightAlt = "RAlt", Backspace = "Bksp", Return = "Enter", CapsLock = "Caps", Escape = "Esc",
		PageUp = "PgUp", PageDown = "PgDn", Home = "Home", End = "End",
	}
	function c:keybind(cfg)
		cfg = cfg or {}
		local r = row(26, cfg.name)
		lbl(r, { Text = cfg.name or "keybind", Position = UDim2.fromOffset(5, 0), Size = UDim2.new(0.44, -8, 1, 0), TextSize = 13, TextColor3 = THEME.dim, TextTransparency = 0.35 })
		local box = mk("Frame", {
			AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -5, 0.5, 0), Size = UDim2.new(0.54, -5, 0, 21),
			ZIndex = 6, BorderSizePixel = 0, BackgroundTransparency = 0.12, bind = { BackgroundColor3 = "head" },
		}, r)
		corner(box, 6)
		local bst = stroke(box, "line", 0.62)
		img(box, { Image = icon("keyboard"), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 5, 0.5, 0), Size = UDim2.fromOffset(12, 12), ImageTransparency = 0.3, ZIndex = 7 })
		local sepl = mk("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 22, 0.5, 0), Size = UDim2.fromOffset(1, 13), ZIndex = 7,
			BorderSizePixel = 0, BackgroundTransparency = 0.35, bind = { BackgroundColor3 = "line" },
		}, box)
		grad(sepl, 90, { { 0, 0.85 }, { 0.5, 0 }, { 1, 0.85 } })
		local tx = lbl(box, { Position = UDim2.fromOffset(28, 0), Size = UDim2.new(1, -33, 1, 0), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 0.1, ZIndex = 7 })
		local ul = mk("Frame", {
			AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), ZIndex = 8,
			BorderSizePixel = 0, BackgroundTransparency = 1, bind = { BackgroundColor3 = "accent" },
		}, box)
		grad(ul, 0, { { 0, 1 }, { 0.5, 0 }, { 1, 1 } })
		local hit = mk("ImageButton", { Size = UDim2.fromScale(1, 1), ZIndex = 9, BackgroundTransparency = 1, ImageTransparency = 1, AutoButtonColor = false, Selectable = false }, r)
		local el = { value = tokey(cfg.default), callback = cfg.callback, name = cfg.name or "keybind" }
		local listening = false
		local function paint()
			if listening then
				tx.Text = "..."
			else
				tx.Text = el.value and (KEYSHORT[el.value.Name] or el.value.Name) or "none"
			end
			tw(tx, { TextTransparency = (el.value or listening) and 0.1 or 0.45 }, FAST)
			tw(ul, { BackgroundTransparency = listening and 0.35 or 1 }, FAST)
			tw(bst, { Transparency = listening and 0.3 or 0.62 }, FAST)
			if lib._hkrefresh then lib._hkrefresh() end
		end
		function el:get() return el.value end
		function el:set(k) el.value = tokey(k); paint(); safe(el.callback, el.value) end
		el.setkey = el.set
		hit.MouseButton1Click:Connect(function()
			listening = true
			paint()
			setlistener(function(k, cancel)
				listening = false
				if not cancel and k and k ~= Enum.KeyCode.Escape and k ~= Enum.KeyCode.Backspace then
					el.value = k
				else
					el.value = nil
				end
				paint()
				lib:markdirty()
				safe(el.callback, el.value)
			end)
		end)
		if cfg.hud ~= false then lib.keybinds[#lib.keybinds + 1] = el end
		paint()
		return done(cfg, el)
	end
	function c:button(cfg)
		cfg = cfg or {}
		local r = row(28, cfg.name)
		local b = mk("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -10, 0, 24),
			ZIndex = 6, BorderSizePixel = 0, BackgroundTransparency = 0.12, bind = { BackgroundColor3 = "head" },
		}, r)
		corner(b, 6)
		local st = stroke(b, "line", 0.62)
		local sheen = mk("Frame", { Size = UDim2.fromScale(1, 1), ZIndex = 6, BorderSizePixel = 0, BackgroundTransparency = 1, bind = { BackgroundColor3 = "accent" } }, b)
		corner(sheen, 6); grad(sheen, 0, { { 0, 0 }, { 0.55, 0.62 }, { 1, 1 } })
		local ic = icon(cfg.icon)
		local icl
		if ic ~= "" then
			icl = img(b, { Image = ic, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(13, 13), ImageTransparency = 0.25, ZIndex = 7 })
		end
		local tl = lbl(b, {
			Text = cfg.name or "Button", Position = UDim2.fromOffset(ic ~= "" and 27 or 9, 0), Size = UDim2.new(1, ic ~= "" and -36 or -18, 1, 0),
			TextSize = 13, TextColor3 = THEME.dim, TextTransparency = 0.25, ZIndex = 7,
		})
		local ul = mk("Frame", {
			AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), ZIndex = 8,
			BorderSizePixel = 0, BackgroundTransparency = 1, bind = { BackgroundColor3 = "accent" },
		}, b)
		grad(ul, 0, { { 0, 1 }, { 0.5, 0 }, { 1, 1 } })
		local hit = mk("ImageButton", { Size = UDim2.fromScale(1, 1), ZIndex = 9, BackgroundTransparency = 1, ImageTransparency = 1, AutoButtonColor = false, Selectable = false }, b)
		hit.MouseEnter:Connect(function()
			tw(st, { Transparency = 0.3 }); tw(sheen, { BackgroundTransparency = 0.85 })
			tw(tl, { TextColor3 = THEME.text, TextTransparency = 0 }); tw(ul, { BackgroundTransparency = 0.35 })
			if icl then tw(icl, { ImageColor3 = THEME.text, ImageTransparency = 0 }) end
		end)
		hit.MouseLeave:Connect(function()
			tw(st, { Transparency = 0.62 }); tw(sheen, { BackgroundTransparency = 1 })
			tw(tl, { TextColor3 = THEME.dim, TextTransparency = 0.25 }); tw(ul, { BackgroundTransparency = 1 })
			if icl then tw(icl, { ImageColor3 = THEME.dim, ImageTransparency = 0.25 }) end
		end)
		hit.MouseButton1Click:Connect(function()
			lib:chime("click")
			b.BackgroundColor3 = THEME.line
			tw(b, { BackgroundColor3 = THEME.head })
			safe(cfg.callback)
		end)
		local el = { __frame = r, text = tl, callback = cfg.callback, SetText = function(_, t) tl.Text = t end }
		attachbind(hit, el, "button", cfg.name or "button")
		return el
	end
	function c:label(cfg)
		cfg = cfg or {}
		local r = row(22, cfg.name)
		local t = lbl(r, {
			Text = tostring(cfg.name or ""), Position = UDim2.fromOffset(5, 0), Size = UDim2.new(1, -13, 1, 0),
			TextColor3 = THEME.dim, TextTransparency = 0.15, TextWrapped = cfg.wrap and true or false, TextSize = 12,
			TextTruncate = Enum.TextTruncate.None,
		})
		local function fit()
			if cfg.wrap then
				local hh = math.max(22, tsize(t.Text, 12, Enum.Font.GothamBold, math.max(20, r.AbsoluteSize.X - 13)).Y + 6)
				r.Size = UDim2.new(1, 0, 0, hh)
			end
		end
		if cfg.wrap then t.TextYAlignment = Enum.TextYAlignment.Top; r:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit) end
		local el = {}
		function el:get() return t.Text end
		function el:set(v) t.Text = tostring(v); fit() end
		task.defer(fit)
		return el
	end
	function c:input(cfg)
		cfg = cfg or {}
		local hasname = cfg.name ~= nil and cfg.name ~= ""
		local r = row(hasname and 50 or 28, cfg.name)
		if hasname then
			lbl(r, { Text = cfg.name, Position = UDim2.fromOffset(5, 0), Size = UDim2.new(1, -10, 0, 18), TextSize = 12, TextColor3 = THEME.dim, TextTransparency = 0.15 })
		end
		local tb = mk("TextBox", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 5, 1, hasname and 0 or -1), Size = UDim2.new(1, -10, 0, 26),
			Text = tostring(cfg.default or ""), PlaceholderText = cfg.placeholder or "", ClearTextOnFocus = cfg.clearonfocus and true or false,
			Font = Enum.Font.GothamBold, TextSize = 13, ZIndex = 6, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left,
			ClipsDescendants = true, bind = { BackgroundColor3 = "head", TextColor3 = "text", PlaceholderColor3 = "dim" },
		}, r)
		corner(tb, 6); pad(tb, 10, 10, 0, 0)
		local st = stroke(tb, "line", 0.6)
		tb.Focused:Connect(function() tw(st, { Transparency = 0.25 }) end)
		local el = { value = tb.Text, callback = cfg.callback, box = tb }
		tb.FocusLost:Connect(function()
			tw(st, { Transparency = 0.6 })
			el.value = tb.Text
			lib:markdirty()
			safe(el.callback, tb.Text)
		end)
		function el:get() return tb.Text end
		function el:set(v, silent) tb.Text = tostring(v or ""); el.value = tb.Text; if not silent then safe(el.callback, tb.Text) end end
		el.__frame = r
		return done(cfg, el)
	end
	function c:inputbutton(cfg)
		cfg = cfg or {}
		local bw = math.clamp(tonumber(cfg.buttonwidth) or 72, 24, 140)
		local hasname = cfg.name ~= nil and cfg.name ~= ""
		local r = row(hasname and 50 or 28, cfg.name)
		if hasname then
			lbl(r, { Text = cfg.name, Position = UDim2.fromOffset(5, 0), Size = UDim2.new(1, -10, 0, 18), TextSize = 12, TextColor3 = THEME.dim, TextTransparency = 0.15 })
		end
		local tb = mk("TextBox", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 5, 1, hasname and 0 or -1), 			Size = UDim2.new(1, -(bw + 16), 0, 28),
			Text = tostring(cfg.default or ""), PlaceholderText = cfg.placeholder or "", ClearTextOnFocus = cfg.clearonfocus and true or false,
			Font = Enum.Font.GothamMedium, TextSize = 12, ZIndex = 6, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left,
			bind = { BackgroundColor3 = "head", TextColor3 = "text", PlaceholderColor3 = "dim" },
		}, r)
		corner(tb, 6); pad(tb, 10, 10, 0, 0)
		local st = stroke(tb, "line", 0.5)
		tb.Focused:Connect(function() tw(st, { Transparency = 0.25 }) end)
		local b = mk("TextButton", {
			AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -5, 1, (hasname and 0 or -1) - 3), Size = UDim2.fromOffset(bw, 22),
			Text = tostring(cfg.button or "go"), Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 6,
			BorderSizePixel = 0, AutoButtonColor = false, bind = { BackgroundColor3 = "head", TextColor3 = "text" },
		}, r)
		corner(b, 6); stroke(b, "line", 0.5)
		local el = { value = tb.Text, callback = cfg.callback, box = tb, button = b }
		tb.FocusLost:Connect(function()
			tw(st, { Transparency = 0.5 })
			el.value = tb.Text
			lib:markdirty()
		end)
		b.MouseButton1Click:Connect(function()
			lib:chime("click")
			el.value = tb.Text
			lib:markdirty()
			safe(el.callback, tb.Text)
		end)
		function el:get() return tb.Text end
		function el:set(v, silent) tb.Text = tostring(v or ""); el.value = tb.Text; if not silent then safe(el.callback, tb.Text) end end
		el.__frame = r
		return done(cfg, el)
	end
	function c:iconrow(list)
		local r = row(28, "")
		local inner = mk("Frame", { Position = UDim2.fromOffset(5, 0), Size = UDim2.new(1, -10, 1, 0), BackgroundTransparency = 1, ZIndex = 5 }, r)
		local n = math.max(1, #list)
		local gap = 6
		mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, gap), SortOrder = Enum.SortOrder.LayoutOrder }, inner)
		for i, it in ipairs(list) do
			local b = mk("ImageButton", {
				LayoutOrder = i, Size = UDim2.new(1 / n, -(gap * (n - 1)) / n, 1, 0), ZIndex = 6, BorderSizePixel = 0,
				AutoButtonColor = false, Selectable = false, BackgroundTransparency = 0.12, ImageTransparency = 1, bind = { BackgroundColor3 = "head" },
			}, inner)
			corner(b, 6)
			local st = stroke(b, "line", 0.78)
			local ic = img(b, {
				Image = icon(it.icon), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(15, 15), ImageTransparency = 0.25, ZIndex = 7,
			})
			b.MouseEnter:Connect(function() tw(st, { Transparency = 0.45 }); tw(ic, { ImageColor3 = THEME.text, ImageTransparency = 0 }) end)
			b.MouseLeave:Connect(function() tw(st, { Transparency = 0.78 }); tw(ic, { ImageColor3 = THEME.dim, ImageTransparency = 0.25 }) end)
			b.MouseButton1Click:Connect(function()
				lib:chime("click")
				safe(it.callback, it)
			end)
		end
		return { __frame = r }
	end
	return c
end
container = container_new
local function glass(parent, p)
	local f = mk("Frame", {
		BackgroundTransparency = 0.16, ZIndex = 2, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
		bind = { BackgroundColor3 = "panel" },
	}, nil)
	for k, v in pairs(p or {}) do f[k] = v end
	f.Parent = parent
	corner(f, 8); stroke(f, "line", 0.45); shadow(f, 2, 0.6, 10, -2)
	local gl = mk("Frame", { BackgroundTransparency = 0.82, ZIndex = 2, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), bind = { BackgroundColor3 = "glow" } }, f)
	corner(gl, 8); grad(gl, 90, { { 0, 0.5 }, { 0.6, 0.82 }, { 1, 0.9 } })
	local hl = mk("Frame", {
		AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 0.7, Position = UDim2.new(0.5, 0, 0, 1), ZIndex = 3,
		BorderSizePixel = 0, Size = UDim2.new(1, -14, 0, 1), bind = { BackgroundColor3 = "glow" },
	}, f)
	grad(hl, 0, { { 0, 1 }, { 0.5, 0.1 }, { 1, 1 } })
	return f
end
local function pill_inner(f, auto)
	local inner = mk("Frame", {
		BackgroundTransparency = 1, ZIndex = 3, BorderSizePixel = 0,
		AutomaticSize = auto and Enum.AutomaticSize.X or Enum.AutomaticSize.None,
		Size = auto and UDim2.fromOffset(0, 30) or UDim2.fromScale(1, 1),
	}, f)
	return inner
end
local function vsep(parent, order)
	local h = mk("Frame", { LayoutOrder = order, BackgroundTransparency = 1, ZIndex = 4, BorderSizePixel = 0, Size = UDim2.fromOffset(14, 16) }, parent)
	local l = mk("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 0.62, Position = UDim2.fromScale(0.5, 0.5),
		ZIndex = 4, BorderSizePixel = 0, Size = UDim2.fromOffset(1, 16), bind = { BackgroundColor3 = "glow" },
	}, h)
	grad(l, 90, { { 0, 0.85 }, { 0.5, 0 }, { 1, 0.85 } })
end
local hkroot = mk("CanvasGroup", {
	AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0.5, 0), BorderSizePixel = 0,
	ZIndex = 900, AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), Visible = false, GroupTransparency = 1,
}, gui)
mk("UIListLayout", { Padding = UDim.new(0, 3), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Left, SortOrder = Enum.SortOrder.LayoutOrder }, hkroot)
pad(hkroot, 10, 10, 10, 10)
do
	local tw_ = tsize("hotkeys", 14, Enum.Font.GothamBold).X
	local hp = glass(hkroot, { LayoutOrder = 0, Size = UDim2.fromOffset(53 + math.ceil(tw_), 36) })
	fastdrag(hp, hkroot)
	local inner = mk("Frame", { BackgroundTransparency = 1, ZIndex = 3, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1) }, hp)
	pad(inner, 14, 14, 0, 0)
	mk("UIListLayout", {
		VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
	}, inner)
	img(inner, { Image = icon("keyboard"), LayoutOrder = 1, ZIndex = 4, Size = UDim2.fromOffset(17, 17) })
	lbl(inner, { Text = "hotkeys", LayoutOrder = 2, Font = Enum.Font.GothamMedium, TextSize = 14, ZIndex = 4, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 20), TextTruncate = Enum.TextTruncate.None })
end
local hkrows = {}
local hkListening = nil
function lib._hkpaint()
	for el, r in pairs(hkrows) do
		tw(r.name, { TextColor3 = el.down and THEME.accent or THEME.text }, FAST)
	end
end
local function hkchip(el, inner, order)
	local b = mk("TextLabel", {
		LayoutOrder = order, Text = "[" .. el.value.Name .. "]", Font = Enum.Font.GothamMedium, TextSize = 12,
		TextColor3 = THEME.dim, ZIndex = 4, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 20),
		TextTruncate = Enum.TextTruncate.None, BackgroundTransparency = 1,
	}, inner)
	return b
end
-- the whole pill is one click target: press it to rebind, Escape drops the bind
local function hklisten(el, chip)
	if hkListening then return end
	hkListening = el
	chip.Text = "[press a key]"
	setlistener(function(k, cancel)
		hkListening = nil
		if not cancel then
			if k == Enum.KeyCode.Escape or k == Enum.KeyCode.Backspace then
				if el.setkey then el.setkey(nil) else el.value = nil end
			elseif k then
				if el.setkey then el.setkey(k) else el:set(k) end
			end
		end
		if lib._hkrefresh then lib._hkrefresh() end
	end)
end
function lib._hkrefresh()
	for el, r in pairs(hkrows) do r.frame:Destroy(); hkrows[el] = nil end
	local count = 0
	for _, el in ipairs(lib.keybinds) do
		if el.value then
			count = count + 1
			local f = glass(hkroot, { LayoutOrder = count, Size = UDim2.fromOffset(0, 30), AutomaticSize = Enum.AutomaticSize.X })
			fastdrag(f, hkroot)
			local inner = pill_inner(f, true)
			pad(inner, 13, 13, 0, 0)
			mk("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, inner)
			local n = lbl(inner, { Text = el.name, LayoutOrder = 1, Font = Enum.Font.GothamMedium, TextSize = 13, ZIndex = 4, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 20), TextTruncate = Enum.TextTruncate.None })
			local chip = hkchip(el, inner, 2)
			local hit = mk("TextButton", {
				Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 6,
			}, f)
			hit.MouseButton1Click:Connect(function() hklisten(el, chip) end)
			fastdrag(hit, hkroot)
			hkrows[el] = { frame = f, name = n }
		end
	end
	local show = lib.hotkeys and count > 0
	hkroot.GroupTransparency = show and 0 or 1
	hkroot.Visible = show
end
function lib:sethotkeys(b) self.hotkeys = b and true or false; self._hkrefresh() end
local MASKPAD = 4
-- roblox has no per-label blur, so privacy is a plain dash line sized to the nick
local MASK_CH = "—"
local function masktext(parent, cfg)
	local text = tostring(cfg.Text or "")
	local font = cfg.Font or Enum.Font.GothamBold
	local tsize_ = cfg.TextSize or 13
	local h = cfg.H or 20
	local base = cfg.TextTransparency or 0
	local z = cfg.ZIndex or 6
	local colkey = cfg.ColorKey or "text"
	local fixed = cfg.Size ~= nil
	local function textw(s) return math.ceil(tsize(s, tsize_, font).X) end
	local dashw = math.max(1, textw(MASK_CH))
	local function maskstr(s)
		return string.rep(MASK_CH, math.max(1, math.floor(textw(s) / dashw)))
	end
	local w = textw(text)
	local box
	if fixed then
		local p, s = cfg.Position or UDim2.new(), cfg.Size
		box = mk("Frame", {
			BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = z,
			Position = UDim2.new(p.X.Scale, p.X.Offset - MASKPAD, p.Y.Scale, p.Y.Offset - MASKPAD),
			Size = UDim2.new(s.X.Scale, s.X.Offset + MASKPAD * 2, s.Y.Scale, s.Y.Offset + MASKPAD * 2),
		}, parent)
	else
		box = mk("Frame", {
			BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = z, LayoutOrder = cfg.LayoutOrder or 0,
			Size = UDim2.fromOffset(w + MASKPAD * 2, h + MASKPAD * 2),
		}, parent)
	end
	local function addlabel(name, txt, wt)
		return lbl(box, {
			Name = name, Text = txt, Font = font, TextSize = tsize_, TextColor3 = THEME[colkey],
			TextTransparency = base, ZIndex = z, TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.fromOffset(MASKPAD, MASKPAD),
			Size = fixed and UDim2.new(1, -MASKPAD * 2, 0, h) or UDim2.fromOffset(wt, h),
		})
	end
	local real = addlabel("NameReal", text, w)
	local mt0 = maskstr(text)
	local masked = addlabel("NameMask", mt0, textw(mt0))
	masked.Visible = false
	reapply[#reapply + 1] = function()
		if not real.Parent then return end
		real.TextColor3 = THEME[colkey]
		masked.TextColor3 = THEME[colkey]
	end
	local o = { box = box, real = real, masked = masked }
	function o:set(s)
		s = tostring(s)
		local wt = textw(s)
		local mt = maskstr(s)
		local mw = textw(mt)
		real.Text = s
		masked.Text = mt
		if not fixed then
			real.Size = UDim2.fromOffset(wt, h)
			masked.Size = UDim2.fromOffset(mw, h)
			box.Size = UDim2.fromOffset(math.max(wt, mw) + MASKPAD * 2, h + MASKPAD * 2)
		end
	end
	function o:mask(b)
		local on = b and true or false
		real.Visible = not on
		masked.Visible = on
	end
	return o
end
local namewatchers = {}
local function refreshnames()
	for _, fn in ipairs(namewatchers) do pcall(fn) end
end
function lib:setnameprivate(v)
	self.hidenames = (v == nil) and not self.hidenames or (v and true or false)
	refreshnames()
end
local wmroot = mk("CanvasGroup", {
	AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Position = UDim2.new(1, -8, 0, 8), BorderSizePixel = 0,
	ZIndex = 900, AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), Visible = false, GroupTransparency = 1,
}, gui)
mk("UIListLayout", {
	VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
}, wmroot)
pad(wmroot, 10, 10, 10, 10)
local wm_title
do
	local f = glass(wmroot, { LayoutOrder = 1, Size = UDim2.fromOffset(0, 30), AutomaticSize = Enum.AutomaticSize.X })
	fastdrag(f, wmroot, function() lib:togglemenus() end)
	local inner = pill_inner(f, true)
	pad(inner, 13, 13, 0, 0)
	mk("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, inner)
	img(inner, { Image = icon("code"), LayoutOrder = 1, ZIndex = 4, Size = UDim2.fromOffset(16, 16) })
	wm_title = lbl(inner, { Text = lib.title, LayoutOrder = 2, Font = Enum.Font.GothamMedium, TextSize = 14, TextTransparency = 0.05, ZIndex = 4, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 20), TextTruncate = Enum.TextTruncate.None })
end
local wm_fps, wm_ping, wm_time
do
	local f = glass(wmroot, { LayoutOrder = 2, Size = UDim2.fromOffset(0, 30), AutomaticSize = Enum.AutomaticSize.X })
	fastdrag(f, wmroot)
	local inner = pill_inner(f, true)
	pad(inner, 13, 13, 0, 0)
	mk("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, inner)
	local av = mk("ImageLabel", {
		LayoutOrder = 10, ScaleType = Enum.ScaleType.Crop, ImageTransparency = 0.02, BackgroundTransparency = 0.3, ZIndex = 4,
		BorderSizePixel = 0, Size = UDim2.fromOffset(22, 22), Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150",
		bind = { BackgroundColor3 = "bg" },
	}, inner)
	corner(av, "full"); stroke(av, "line", 0.35)
	local function t(order, text, w)
		return lbl(inner, { Text = text, LayoutOrder = order, Font = Enum.Font.GothamMedium, TextSize = 14, TextTransparency = 0.05, ZIndex = 4, Size = UDim2.fromOffset(w, 20), TextTruncate = Enum.TextTruncate.None })
	end
	local wm_name = masktext(inner, {
		LayoutOrder = 22, Text = LP.Name, Font = Enum.Font.GothamMedium, TextSize = 14,
		TextTransparency = 0.05, ZIndex = 4, H = 20, ColorKey = "text",
	})
	local function wmname()
		wm_name:set(LP.Name)
		wm_name:mask(lib.hidenames)
	end
	namewatchers[#namewatchers + 1] = wmname
	conn(LP:GetPropertyChangedSignal("Name"), wmname)
	vsep(inner, 30)
	img(inner, { Image = icon("gauge"), LayoutOrder = 31, ZIndex = 4, Size = UDim2.fromOffset(15, 15), ImageColor3 = THEME.text, ImageTransparency = 0.25 })
	wm_fps = t(32, "0", math.ceil(tsize("999", 14, Enum.Font.GothamBold).X))
	vsep(inner, 40)
	img(inner, { Image = icon("wifi"), LayoutOrder = 41, ZIndex = 4, Size = UDim2.fromOffset(15, 15), ImageColor3 = THEME.text, ImageTransparency = 0.25 })
	wm_ping = t(42, "0ms", math.ceil(tsize("999ms", 14, Enum.Font.GothamBold).X))
	vsep(inner, 50)
	img(inner, { Image = icon("clock"), LayoutOrder = 51, ZIndex = 4, Size = UDim2.fromOffset(15, 15), ImageColor3 = THEME.text, ImageTransparency = 0.25 })
	wm_time = t(52, "00:00", math.ceil(tsize("00:00", 14, Enum.Font.GothamBold).X))
end
do
	local acc, frames = 0, 0
	local goal, disp = { fps = 0, ping = 0 }, { fps = 0, ping = 0 }
	local lastf, lastp, timetxt = nil, nil, nil
	local function swaptime(t)
		if timetxt == nil then
			timetxt = t
			wm_time.Text = t
			return
		end
		timetxt = t
		tw(wm_time, { TextTransparency = 1 }, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
		task.delay(0.14, function()
			if not wm_time.Parent then return end
			wm_time.Text = t
			tw(wm_time, { TextTransparency = 0.05 }, TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		end)
	end
	conn(RunService.RenderStepped, function(dt)
		if not wmroot.Visible then return end
		acc = acc + dt; frames = frames + 1
		if acc >= 0.25 then
			goal.fps = math.floor(frames / acc + 0.5)
			acc, frames = 0, 0
			local ping = 0
			pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5) end)
			goal.ping = ping
			local t = os.date("%H:%M")
			if t ~= timetxt then swaptime(t) end
		end
		local k = 1 - math.exp(-dt * 8)
		disp.fps = disp.fps + (goal.fps - disp.fps) * k
		disp.ping = disp.ping + (goal.ping - disp.ping) * k
		local f, p = math.floor(disp.fps + 0.5), math.floor(disp.ping + 0.5)
		if f ~= lastf then lastf = f; wm_fps.Text = tostring(f) end
		if p ~= lastp then lastp = p; wm_ping.Text = p .. "ms" end
	end)
end
function lib:setwatermark(b)
	self.watermark = b and true or false
	wmroot.GroupTransparency = self.watermark and 0 or 1
	wmroot.Visible = self.watermark
end
function lib:retitle(t) self.title = tostring(t); wm_title.Text = self.title end
function lib:setsound(b) self.sound = b and true or false end
function lib:settone(n) if TONEMUL[n] then self.tone = n end end
function lib:setnotices(b) self.notices = b and true or false end
local nroot = mk("Frame", {
	Name = randname(), Position = UDim2.fromOffset(18, 110), BackgroundTransparency = 1, ZIndex = 400,
	AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.fromOffset(268, 0),
}, gui)
mk("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, nroot)
local nlist, nseq = {}, 0
function lib:notify(cfg)
	if not self.notices or not self.alive then return end
	cfg = cfg or {}
	local title, body = tostring(cfg.title or ""), tostring(cfg.text or "")
	local life = tonumber(cfg.life) or 5
	local ic = icon(cfg.icon or "info")
	local W = 268
	local tx = 14 + (ic ~= "" and 26 or 0)
	local avail = W - tx - 14
	local th = tsize(title, 13, Enum.Font.GothamBold, avail).Y
	local btxt = body ~= "" and body or " "
	local bh = tsize(btxt, 11, Enum.Font.GothamMedium, avail).Y
	local ah = type(cfg.callback) == "function" and 15 or 0
	local H = math.max(56, 24 + th + 3 + bh + ah)
	nseq = nseq + 1
	local holder = mk("Frame", { LayoutOrder = nseq, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), ZIndex = 400 }, nroot)
	local slide = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(W, H), Position = UDim2.fromOffset(-W - 40, 0), ZIndex = 400 }, holder)
	shadow(slide, 6, 0.5, 26, 6, 0)
	local f = glass(slide, { Size = UDim2.fromOffset(W, H), ZIndex = 401 })
	local inner = mk("Frame", { BackgroundTransparency = 1, ZIndex = 403, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1) }, f)
	if ic ~= "" then
		img(inner, { Image = ic, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), Size = UDim2.fromOffset(18, 18), ZIndex = 404, ImageColor3 = cfg.tone or THEME.text })
	end
	lbl(inner, { Text = title, Position = UDim2.fromOffset(tx, 12), Size = UDim2.fromOffset(avail, th), TextSize = 13, ZIndex = 404, TextWrapped = true, TextTruncate = Enum.TextTruncate.None })
	lbl(inner, { Text = btxt, Position = UDim2.fromOffset(tx, 15 + th), Size = UDim2.fromOffset(avail, bh), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = THEME.dim, ZIndex = 404, TextWrapped = true, TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top })
	local bar = mk("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 2), ZIndex = 405, BorderSizePixel = 0, BackgroundTransparency = 0.35, BackgroundColor3 = cfg.tone or THEME.accent }, f)
	local dead = false
	local entry = {}
	local function dismiss()
		if dead then return end
		dead = true
		for i, e in ipairs(nlist) do if e == entry then table.remove(nlist, i) break end end
		tw(slide, { Position = UDim2.fromOffset(-W - 40, 0) }, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
		task.delay(0.22, function()
			tw(holder, { Size = UDim2.new(1, 0, 0, 0) }, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
			task.delay(0.3, function() holder:Destroy() end)
		end)
	end
	entry.dismiss = dismiss
	if ah > 0 then
		local act = tostring(cfg.action or "click to run")
		local astr = "  " .. act
		lbl(inner, {
			Text = astr, Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = THEME.accent, ZIndex = 406,
			AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -12, 1, -6), Size = UDim2.fromOffset(tsize(astr, 10, Enum.Font.GothamBold).X, 13),
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		local hit = mk("TextButton", {
			Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 407,
		}, f)
		hit.MouseButton1Click:Connect(function()
			dismiss()
			safe(cfg.callback)
		end)
	end
	nlist[#nlist + 1] = entry
	tw(holder, { Size = UDim2.new(1, 0, 0, H + 8) }, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
	tw(slide, { Position = UDim2.fromOffset(0, 0) }, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	tw(bar, { Size = UDim2.new(0, 0, 0, 2) }, TweenInfo.new(life, Enum.EasingStyle.Linear))
	task.delay(life, dismiss)
	while #nlist > self.noticecap do nlist[1].dismiss() end
	self:chime("soft")
end
closemodal = function(animate)
	if not modal then return end
	local m, b, msh, bsc = modal, modalbox, modalshadow, modalscale
	modal, modalbox, modalshadow, modalscale = nil, nil, nil, nil
	if animate then
		local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		tw(m, { BackgroundTransparency = 1 }, info)
		if b and b.Parent then tw(b, { GroupTransparency = 1 }, info) end
		if msh then tw(msh, { Transparency = 1 }, info) end
		if bsc then tw(bsc, { Scale = 0.96 }, info) end
		task.delay(0.22, function() m:Destroy() end)
	else
		m:Destroy()
	end
end
local function openmodal(cfg, withinput)
	closemodal()
	cfg = cfg or {}
	local ov = mk("TextButton", { Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 500, BorderSizePixel = 0, bind = { BackgroundColor3 = "bg" } }, gui)
	modal = ov
	modalbox = nil
	local box = mk("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(340, 0),
		AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 501, BorderSizePixel = 0, GroupTransparency = 1,
		bind = { BackgroundColor3 = "panel" },
	}, ov)
	corner(box, 12); stroke(box, "line", 0.2)
	local msh = shadow(box, 8, 1, 40, 8, 0)
	modalshadow = msh
	local bscale = mk("UIScale", { Scale = 0.95 }, box)
	modalscale = bscale
	local function center()
		local w = lib.focus
		local a, s
		if w and w.shell and w.shell.Parent and w.shell.Visible then
			a, s = w.shell.AbsolutePosition, w.shell.AbsoluteSize
		else
			local vs = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or gui.AbsoluteSize
			a, s = Vector2.new(0, 0), vs
		end
		box.Position = UDim2.fromOffset(a.X + s.X / 2, a.Y + s.Y / 2)
	end
	pad(box, 20, 20, 18, 18); vlist(box, 12)
	local o = 0
	local function nxt() o = o + 1 return o end
	lbl(box, { Text = tostring(cfg.title or ""), LayoutOrder = nxt(), Size = UDim2.new(1, 0, 0, 20), TextSize = 15, ZIndex = 502 })
	if cfg.text and cfg.text ~= "" then
		local h = tsize(cfg.text, 12, Enum.Font.GothamMedium, 288).Y
		lbl(box, { Text = tostring(cfg.text), LayoutOrder = nxt(), Size = UDim2.new(1, 0, 0, h), Font = Enum.Font.GothamMedium, TextColor3 = THEME.dim, TextWrapped = true, TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 502 })
	end
	local tb
	if withinput then
		tb = mk("TextBox", {
			LayoutOrder = nxt(), Size = UDim2.new(1, 0, 0, 28), Text = tostring(cfg.default or ""), PlaceholderText = cfg.placeholder or "",
			ClearTextOnFocus = false, Font = Enum.Font.GothamMedium, TextSize = 12, ZIndex = 502, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left,
			bind = { BackgroundColor3 = "head", TextColor3 = "text", PlaceholderColor3 = "dim" },
		}, box)
		corner(tb, 6); pad(tb, 9, 9, 0, 0); stroke(tb, "line", 0.5)
		task.defer(function() tb:CaptureFocus() end)
	end
	local brow = mk("Frame", { LayoutOrder = nxt(), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), ZIndex = 502 }, box)
	mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, brow)
	local buttons = cfg.buttons
	if not buttons then
		buttons = withinput and { { name = cfg.cancel or "cancel" }, { name = cfg.confirm or "ok", primary = true } } or { { name = "ok", primary = true } }
	end
	for i, bcfg in ipairs(buttons) do
		local w = math.ceil(tsize(bcfg.name, 12, Enum.Font.GothamBold).X) + 34
		local bd = bcfg.danger == true
		local b = mk("TextButton", {
			LayoutOrder = i, Size = UDim2.fromOffset(w, 30), Text = bcfg.name, Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 503,
			BorderSizePixel = 0, AutoButtonColor = false,
			BackgroundColor3 = bd and Color3.fromRGB(168, 48, 48) or (bcfg.primary and THEME.accent or Color3.fromRGB(10, 10, 12)),
			TextColor3 = (bcfg.primary and not bd) and THEME.bg or THEME.text,
		}, brow)
		corner(b, 8)
		if not (bcfg.primary and not bd) then stroke(b, "line", 0.4) end
		b.MouseButton1Click:Connect(function()
			local val = tb and tb.Text
			closemodal(true)
			task.delay(0.2, function()
				if bcfg.callback then safe(bcfg.callback, val) end
				if bcfg.primary and cfg.callback then safe(cfg.callback, val) end
			end)
		end)
	end
	task.defer(center)
	task.delay(0.05, center)
	box:GetPropertyChangedSignal("AbsoluteSize"):Connect(center)
	local APPEAR = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	modalbox = box
	tw(ov, { BackgroundTransparency = 0.45 }, APPEAR)
	tw(box, { GroupTransparency = 0 }, APPEAR)
	tw(bscale, { Scale = 1 }, APPEAR)
	if msh then tw(msh, { Transparency = 0.35 }, APPEAR) end
end
function lib:popup(cfg) openmodal(cfg, false) end
function lib:ask(cfg) openmodal(cfg, true) end
function lib:confirm(cfg)
	cfg = cfg or {}
	cfg.danger = true
	modalclose = cfg.oncancel
	cfg.buttons = cfg.buttons or {
		{ name = cfg.cancel or "cancel" },
		{ name = cfg.confirm or "confirm", primary = true, danger = true },
	}
	openmodal(cfg, false)
end
function lib:closepopup() closemodal() end
function lib:closeask() closemodal() end
local function fsok(name)
	local ok, v = pcall(function() return rawget(_G, name) end)
	if ok and type(v) == "function" then return v end
	if getgenv then
		ok, v = pcall(function() return rawget(getgenv(), name) end)
		if ok and type(v) == "function" then return v end
	end
	return nil
end
local function ser(v)
	local t = typeof(v)
	if t == "Color3" then return { __c = { v.R, v.G, v.B } } end
	if t == "EnumItem" then return { __k = v.Name } end
	return v
end
local function des(v)
	if type(v) == "table" then
		if v.__c then return Color3.new(v.__c[1], v.__c[2], v.__c[3]) end
		if v.__k then return Enum.KeyCode[v.__k] end
	end
	return v
end
function lib:rootdir()
	local d = tostring(self.dir or "")
	if d == "" then d = "yall holy" end
	if self._wsp == nil then
		self._wsp = false
		local gw = fsok("getworkspace")
		if gw then
			local ok, p = pcall(gw)
			if ok then
				p = tostring(p or ""):gsub("[/\\]+$", "")
				if p ~= "" then self._wsp = p end
			end
		end
	end
	local r = self._wsp
	if not r or d:match("^%a:") or d:match("^[/\\]") then return d end
	return r .. "/" .. d
end
function lib:gamedir()
	if self._gamedir then return self._gamedir end
	if GAME_NAME == "game name" then
		local deadline = time() + 1.2
		pcall(function()
			while GAME_NAME == "game name" and time() < deadline do task.wait(0.1) end
		end)
	end
	local real = saname(GAME_NAME)
	if real then self.game = real end
	local base = self:rootdir()
	local dir = base .. "/" .. self.game
	local mf, isf = fsok("makefolder"), fsok("isfolder")
	if mf then
		pcall(function() if not isf or not isf(base) then mf(base) end end)
		pcall(function() if not isf or not isf(dir) then mf(dir) end end)
		if isf then
			pcall(function()
				if self._wsp and not isf(dir) then
					self._wsp = false
					base, dir = self.dir, self.dir .. "/" .. self.game
					if not isf(base) then mf(base) end
					if not isf(dir) then mf(dir) end
				end
			end)
		end
	end
	self._gamedir = dir
	return dir
end
local function subfolder(parent, name)
	local dir = parent .. "/" .. name
	local mf, isf = fsok("makefolder"), fsok("isfolder")
	if mf then pcall(function() if not isf or not isf(dir) then mf(dir) end end) end
	return dir
end
function lib:cfgdir()
	local dir = subfolder(self:gamedir(), "configs")
	self:migrateconfigs(dir)
	return dir
end
function lib:assetdir()
	return subfolder(self:gamedir(), "assets")
end
function lib:migrateconfigs(dst)
	if self._migrated then return end
	self._migrated = true
	local src = self:gamedir()
	local lf, isf, rf, wf, df = fsok("listfiles"), fsok("isfile"), fsok("readfile"), fsok("writefile"), fsok("delfile")
	if not (lf and rf and wf) then return end
	pcall(function()
		for _, p in ipairs(lf(src)) do
			local n = tostring(p):match("([^/\\]+)%.json$")
			if n and not isf(dst .. "/" .. n .. ".json") then
				local from = src .. "/" .. n .. ".json"
				local data = rf(from)
				if type(data) == "string" and #data > 0 and pcall(wf, dst .. "/" .. n .. ".json", data) and df then
					pcall(df, from)
				end
			end
		end
	end)
end
function lib:cfgfile(name)
	local n = tostring(name or ""):gsub('[/\\:*?"<>|%c]', ""):gsub("^%s+", ""):gsub("%s+$", "")
	if n == "" then return nil end
	local dst = self:cfgdir() .. "/" .. n .. ".json"
	local isf = fsok("isfile")
	if isf and not isf(dst) then
		local old = self:gamedir() .. "/" .. n .. ".json"
		if isf(old) then return old end
	end
	return dst
end
function lib:listconfigs()
	local out, seen = {}, {}
	local lf, isf = fsok("listfiles"), fsok("isfolder")
	if not lf then return out end
	for _, dir in ipairs({ self:cfgdir(), self:gamedir() }) do
		if isf and isf(dir) then
			for _, p in ipairs(lf(dir)) do
				local n = tostring(p):match("([^/\\]+)%.json$")
				if n and n ~= self.autocfg and not seen[n] then
					seen[n] = true
					out[#out + 1] = n
				end
			end
		end
	end
	table.sort(out)
	return out
end
function lib:getconfig()
	local data = { _theme = self:_getthemeconfig() }
	for flag, el in pairs(self.flags) do
		local ok, v = pcall(function() return el:get() end)
		if ok and v ~= nil then data[flag] = ser(v) end
	end
	return data
end
function lib:setconfig(data)
	for flag, v in pairs(data or {}) do
		local el = self.flags[flag]
		if el and el.set then pcall(function() el:set(des(v)) end) end
	end
	if data then self:_loadthemeconfig(data._theme) end
end
function lib:saveconfig(name)
	local wf = fsok("writefile")
	local path = self:cfgfile(name)
	if not wf or not path then return false end
	return pcall(function()
		local data, keys, lines = self:getconfig(), {}, {}
		for flag in pairs(data) do keys[#keys + 1] = flag end
		table.sort(keys)
		for _, flag in ipairs(keys) do
			lines[#lines + 1] = HttpService:JSONEncode(flag) .. ":" .. HttpService:JSONEncode(data[flag])
		end
		local json = "{" .. table.concat(lines, ",") .. "}"
		local out, depth, quoted, escaped, i = {}, 0, false, false, 1
		while i <= #json do
			local c = json:sub(i, i)
			if quoted then
				out[#out + 1] = c
				if escaped then
					escaped = false
				elseif c == "\\" then
					escaped = true
				elseif c == '"' then
					quoted = false
				end
			elseif c == '"' then
				quoted = true
				out[#out + 1] = c
			elseif c == "{" or c == "[" then
				out[#out + 1] = c
				local j = i + 1
				while json:sub(j, j):match("%s") do j = j + 1 end
				if json:sub(j, j) == (c == "{" and "}" or "]") then
					out[#out + 1] = json:sub(j, j)
					i = j
				else
					depth = depth + 1
					out[#out + 1] = "\n" .. string.rep("    ", depth)
				end
			elseif c == "}" or c == "]" then
				depth = depth - 1
				out[#out + 1] = "\n" .. string.rep("    ", depth) .. c
			elseif c == "," then
				out[#out + 1] = ",\n" .. string.rep("    ", depth)
			elseif c == ":" then
				out[#out + 1] = ": "
			elseif not c:match("%s") then
				out[#out + 1] = c
			end
			i = i + 1
		end
		wf(path, table.concat(out) .. "\n")
	end)
end
function lib:loadconfig(name)
	local rf, isfile = fsok("readfile"), fsok("isfile")
	local path = self:cfgfile(name)
	if not rf or not path then return false end
	if isfile and not isfile(path) then return false end
	local ok, data = pcall(function() return HttpService:JSONDecode(rf(path)) end)
	if not ok or type(data) ~= "table" then return false end
	self:setconfig(data)
	return true
end
function lib:deleteconfig(name)
	local df = fsok("delfile")
	local path = self:cfgfile(name)
	if df and path then return pcall(df, path) end
	return false
end
function lib:markdirty()
	if not self.autosave or not self.alive or not self._ready then return end
	self._dirty = true
	self._dirtyat = time()
end
function lib:flushconfig()
	if not self._dirty then return end
	self._dirty = false
	self:saveconfig(self.autocfg)
end
function lib:_autocfg()
	if self._started then return end
	self._started = true
	task.spawn(function()
		task.wait(0.4)
		if not self.alive then return end
		self:loadconfig(self.autocfg)
		self._ready = true
		self:saveconfig(self.autocfg)
	end)
end
task.spawn(function()
	while lib.alive do
		task.wait(0.25)
		if lib._dirty and (time() - lib._dirtyat) >= 0.6 then lib:flushconfig() end
	end
end)
pcall(function() game:BindToClose(function() lib:flushconfig() end) end)
local function place(pg, side, card)
	local target
	if side == "right" then
		target = pg.right
	elseif side == "full" then
		target = (pg.nl <= pg.nr) and pg.left or pg.right
	else
		target = pg.left
	end
	if target == pg.left then pg.nl = pg.nl + 1 else pg.nr = pg.nr + 1 end
	pg.colseq = pg.colseq + 1
	card.LayoutOrder = pg.colseq
	card.Parent = target
end
local function newcard(pg, cfg)
	local wrap = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 5, BorderSizePixel = 0 }, nil)
	local card = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 5, BorderSizePixel = 0, bind = { BackgroundColor3 = "panel" },
	}, wrap)
	corner(card, 7)
	mk("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(178, 178, 190)) }, card)
	shadow(card, 2, 0.45, 12, -1, -1)
	vlist(card, 0)
	local hh = cfg.headh or 32
	local content, chev
	local collapsed = false
	if cfg.title and not cfg.noheader then
		local head = mk("Frame", { LayoutOrder = 1, Size = UDim2.new(1, 0, 0, hh), ZIndex = 5, BorderSizePixel = 0, bind = { BackgroundColor3 = "head" } }, card)
		corner(head, 7)
		mk("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 8), ZIndex = 5, BorderSizePixel = 0, bind = { BackgroundColor3 = "head" } }, head)
		local ic = icon(cfg.icon)
		lbl(head, { Text = tostring(cfg.title), Position = UDim2.fromOffset(ic ~= "" and 30 or 10, 0), Size = UDim2.new(1, ic ~= "" and -40 or -38, 1, 0), TextSize = 13, ZIndex = 6 })
		if ic ~= "" then
			img(head, { Image = ic, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), Size = UDim2.fromOffset(13, 13), ImageTransparency = 0.25, ZIndex = 7 })
		end
		local ln = mk("Frame", { LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 2), ZIndex = 6, BorderSizePixel = 0, BackgroundTransparency = 0.45, bind = { BackgroundColor3 = "accent" } }, card)
		grad(ln, 0, { { 0, 1 }, { 0.12, 0.2 }, { 0.5, 0 }, { 0.88, 0.2 }, { 1, 1 } })
		if not cfg.nochev then
			chev = img(head, {
				Image = icon("chevron-down"), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -9, 0.5, 0), Size = UDim2.fromOffset(13, 13),
				ImageTransparency = 0.35, Rotation = 180, ScaleType = Enum.ScaleType.Stretch, ZIndex = 6,
			})
			local hb = mk("ImageButton", { Size = UDim2.fromScale(1, 1), ZIndex = 7, BackgroundTransparency = 1, ImageTransparency = 1, AutoButtonColor = false, Selectable = false }, head)
			hb.MouseButton1Click:Connect(function()
				collapsed = not collapsed
				lib:chime("tick")
				local info = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				local full = card.AbsoluteSize.Y
				wrap.ClipsDescendants = true
				if collapsed then
					wrap.AutomaticSize = Enum.AutomaticSize.None
					wrap.Size = UDim2.new(1, 0, 0, full)
					tw(wrap, { Size = UDim2.new(1, 0, 0, hh + 2) }, info)
				else
					tw(wrap, { Size = UDim2.new(1, 0, 0, full) }, info).Completed:Connect(function()
						if not collapsed then wrap.AutomaticSize = Enum.AutomaticSize.Y; wrap.ClipsDescendants = false end
					end)
				end
				tw(chev, { Rotation = collapsed and 0 or 180 }, info)
			end)
		end
	end
	content = mk("Frame", { LayoutOrder = 3, Size = UDim2.new(1, 0, 0, cfg.rawh or 0), AutomaticSize = cfg.rawh and Enum.AutomaticSize.None or Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 5 }, card)
	if not cfg.raw then
		if cfg.loose then pad(content, 10, 10, 9, 10); vlist(content, 8) else pad(content, 8, 8, 8, 8); vlist(content, cfg.gap or 6) end
	end
	place(pg, cfg.side, wrap)
	return wrap, content
end
local function sidekey(s)
	if s == "full" or s == 3 then return "full" end
	return (s == "right" or s == 2) and "right" or "left"
end
local function filterpage(pg, q)
	q = string.lower(q or "")
	local shown = {}
	for _, e in ipairs(pg.elems) do
		local title = e.card and pg.titles[e.card] or ""
		local show = q == "" or e.name:find(q, 1, true) ~= nil or title:find(q, 1, true) ~= nil
		e.frame.Visible = show
		if show and e.card then shown[e.card] = true end
	end
	for _, c in ipairs(pg.cards) do c.Visible = (q == "") or shown[c] == true end
end
local function buildpage(tab, win)
	local pg = { elems = {}, cards = {}, titles = {}, seq = 0, colseq = 0 }
	local f = mk("Frame", { Visible = false, ZIndex = 4, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, win.pages)
	pg.frame = f
	pg.cg = mk("CanvasGroup", { ZIndex = 5, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -34), BorderSizePixel = 0 }, f)
	local function column(x, xo)
		local s = mk("ScrollingFrame", {
			ZIndex = 5, BackgroundTransparency = 1, Position = UDim2.new(x, xo, 0, 0), Size = UDim2.new(0.5, -4, 1, 0),
			CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, BorderSizePixel = 0,
		}, pg.cg)
		vlist(s, 9)
		pad(s, 0, 0, 0, 4)
		return s
	end
	pg.left = column(0, 0)
	pg.right = column(0.5, 4)
	pg.scroll = pg.left
	pg.nl, pg.nr = 0, 0
	local hd = mk("Frame", { Position = UDim2.fromOffset(-16, -16), ZIndex = 6, BorderSizePixel = 0, Size = UDim2.new(1, 32, 0, 42), bind = { BackgroundColor3 = "bg" } }, f)
	local palette, palw = lib:_themebar(hd)
	smoothdrag(hd, win.shell)
	local hr = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 1, 0), ZIndex = 6, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16) }, hd)
	local gl = mk("Frame", { BackgroundTransparency = 0.9, ZIndex = 6, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), bind = { BackgroundColor3 = "glow" } }, hr)
	grad(gl, 90, { { 0, 1 }, { 0.5, 0.35 }, { 1, 1 } })
	local ln = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 7, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1), bind = { BackgroundColor3 = "line" } }, hr)
	grad(ln, 0, { { 0, 1 }, { 0.12, 0.25 }, { 0.88, 0.25 }, { 1, 1 } })
	local title = lbl(hd, { Text = GAME_NAME, TextTransparency = 0.3, TextColor3 = THEME.dim, Position = UDim2.fromOffset(17, 3), Size = UDim2.new(1, -(palw + 66), 1, -8), TextSize = 13, ZIndex = 7 })
	local tb = mk("TextBox", {
		Visible = false, TextTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), PlaceholderText = "search", BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 0, 27), ClipsDescendants = true, Text = "", ZIndex = 7, TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamBold, Position = UDim2.new(1, -44, 0.5, -1), TextSize = 14, ClearTextOnFocus = false,
		bind = { BackgroundColor3 = "head", TextColor3 = "text", PlaceholderColor3 = "dim" },
	}, hd)
	corner(tb, 8); pad(tb, 12, 12, 0, 0)
	local tst = stroke(tb, "line", 0.55)
	local uline = mk("Frame", { AnchorPoint = Vector2.new(0.5, 1), BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 1), ZIndex = 8, BorderSizePixel = 0, Size = UDim2.new(1, 6, 0, 1), bind = { BackgroundColor3 = "accent" } }, tb)
	grad(uline, 0, { { 0, 1 }, { 0.5, 0 }, { 1, 1 } })
	local sb = mk("ImageButton", {
		AutoButtonColor = false, Selectable = false, ImageColor3 = THEME.dim, ScaleType = Enum.ScaleType.Fit, ImageTransparency = 0.2,
		BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Image = icon("search"), Position = UDim2.new(1, -17, 0.5, 2),
		ZIndex = 8, BorderSizePixel = 0, Size = UDim2.fromOffset(22, 22), bind = { BackgroundColor3 = "head" },
	}, hd)
	corner(sb, 6)
	local function showtitle()
		local q = tb.Text
		if q ~= "" then
			title.Text = "search: " .. q
			tw(title, { TextTransparency = 0.3 })
		else
			title.Text = GAME_NAME
			tw(title, { TextTransparency = 0.3 })
		end
	end
	_gameNameSetters[#_gameNameSetters + 1] = function(nm)
		if tb.Text == "" and title.Parent then
			title.Text = nm
		end
	end
	local sopen, sclosedat = false, -1e9
	local function opensearch()
		if sopen then return end
		sopen = true
		tb.Visible = true
		sb.Image = icon("x")
		tw(palette, { GroupTransparency = 1 }, FAST)
		task.delay(0.14, function() if sopen and tb:IsFocused() then palette.Visible = false end end)
		tw(tb, { Size = UDim2.new(0.66, -44, 0, 27), TextTransparency = 0 })
		tw(tst, { Transparency = 0.35 })
		tw(uline, { BackgroundTransparency = 0.35 })
		tw(sb, { BackgroundTransparency = 0.45, ImageColor3 = THEME.text, ImageTransparency = 0 })
		tw(title, { TextTransparency = 1 })
		task.delay(0.12, function() if sopen then tb:CaptureFocus() end end)
	end
	local function closesearch()
		if not sopen then return end
		sopen = false
		sclosedat = os.clock()
		sb.Image = icon("search")
		tw(tb, { Size = UDim2.new(0, 0, 0, 27), TextTransparency = 1 })
		tw(tst, { Transparency = 0.55 })
		tw(uline, { BackgroundTransparency = 1 })
		tw(sb, { BackgroundTransparency = 1, ImageColor3 = THEME.dim, ImageTransparency = 0.2 })
		task.delay(0.28, function()
			if sopen or not palette.Parent then return end
			tb.Visible = false
			palette.Visible = true
			tw(palette, { GroupTransparency = 0 }, FAST)
		end)
		showtitle()
	end
	-- clicking the X drops the textbox focus first, and the click event right after would reopen it
	sb.MouseButton1Click:Connect(function()
		if sopen then closesearch()
		elseif os.clock() - sclosedat > 0.35 then opensearch() end
	end)
	sb.MouseEnter:Connect(function()
		if not sopen then tw(sb, { BackgroundTransparency = 0.45, ImageColor3 = THEME.text, ImageTransparency = 0 }) end
	end)
	sb.MouseLeave:Connect(function()
		if not sopen and not tb:IsFocused() then tw(sb, { BackgroundTransparency = 1, ImageColor3 = THEME.dim, ImageTransparency = 0.2 }) end
	end)
	tb:GetPropertyChangedSignal("Text"):Connect(function() filterpage(pg, tb.Text) end)
	tb.FocusLost:Connect(closesearch)
	return pg
end
local Tab = {}
Tab.__index = Tab
local function maketab(win, cfg, parent)
	cfg = cfg or {}
	local sub = parent ~= nil
	local list = sub and parent.kids or win.tabs
	win.tabn = win.tabn + 1
	local H = sub and 40 or 48
	local tip = tostring(cfg.tip or "")
	local ic = icon(cfg.icon)
	local holder = mk("Frame", { LayoutOrder = win.tabn, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, ZIndex = 7, AutomaticSize = Enum.AutomaticSize.Y }, list)
	vlist(holder, 2)
	local btn = mk("Frame", { LayoutOrder = 1, BackgroundTransparency = 0.06, ZIndex = 7, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, H), bind = { BackgroundColor3 = "side" } }, holder)
	corner(btn, 6)
	local bst = mk("UIStroke", { Transparency = 1, bind = { Color = "line" } }, btn)
	local hl = mk("Frame", { BackgroundTransparency = 1, ZIndex = 7, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), bind = { BackgroundColor3 = "panel" } }, btn)
	corner(hl, 6); grad(hl, 0, { { 0, 0 }, { 0.7, 0.25 }, { 1, 0.55 } })
	local bar = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0, 1, 0.5, 0), ZIndex = 8, BorderSizePixel = 0, Size = UDim2.new(0, 3, 0, 0), bind = { BackgroundColor3 = "accent" } }, btn)
	corner(bar, "full")
	local ico = img(btn, { ImageColor3 = THEME.dim, ImageTransparency = 0.35, AnchorPoint = Vector2.new(0, 0.5), Image = ic, Position = UDim2.new(0, 10, 0.5, 0), ZIndex = 8, Size = UDim2.fromOffset(sub and 16 or 20, sub and 16 or 20) })
	local nm = lbl(btn, { Text = tostring(cfg.name or "tab"), TextColor3 = THEME.dim, TextTransparency = 0.4, ZIndex = 8, TextSize = sub and 14 or 15 })
	local tl
	if tip ~= "" then
		nm.Position, nm.Size = UDim2.new(0, 36, 0, sub and 6 or 9), UDim2.new(1, -44, 0, sub and 16 or 18)
		tl = lbl(btn, { Text = tip, TextColor3 = THEME.dim, TextTransparency = 0.7, Position = UDim2.new(0, 36, 0, sub and 22 or 27), Size = UDim2.new(1, -44, 0, sub and 11 or 12), TextSize = sub and 9 or 10, ZIndex = 8 })
	else
		nm.Position, nm.Size = UDim2.new(0, 36, 0, 0), UDim2.new(1, -44, 1, 0)
	end
	local hit = mk("ImageButton", { AutoButtonColor = false, Selectable = false, ImageTransparency = 1, ZIndex = 9, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, btn)
	local kids = mk("Frame", { LayoutOrder = 2, Visible = false, ClipsDescendants = true, BackgroundTransparency = 1, ZIndex = 7, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0) }, holder)
	local kl = vlist(kids, 2)
	pad(kids, 10, 0, 0, 0)
	local tab = setmetatable({ win = win, parent = parent, name = tostring(cfg.name or "tab"), btn = btn, kids = kids, kidsn = 0, isopen = false, active = false }, Tab)
	tab._pg = buildpage(tab, win)
	tab.page = tab._pg.frame
	local hover = false
	function tab:paint(active)
		self.active = active
		if active then
			tw(hl, { BackgroundTransparency = 0.12 }); tw(bst, { Transparency = 0.72 })
			tw(bar, { BackgroundTransparency = 0.05, Size = UDim2.new(0, 3, 0, H - 18) })
			tw(ico, { ImageColor3 = THEME.text, ImageTransparency = 0 })
			tw(nm, { TextColor3 = THEME.text, TextTransparency = 0 })
			if tl then tw(tl, { TextTransparency = 0.4 }) end
		else
			tw(hl, { BackgroundTransparency = 1 }); tw(bst, { Transparency = 1 })
			tw(bar, { BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0, 0) })
			tw(ico, { ImageColor3 = THEME.dim, ImageTransparency = hover and 0.1 or 0.35 })
			tw(nm, { TextColor3 = THEME.dim, TextTransparency = hover and 0.15 or 0.4 })
			if tl then tw(tl, { TextTransparency = 0.7 }) end
		end
	end
	hit.MouseEnter:Connect(function()
		hover = true
		if not tab.active then tw(hl, { BackgroundTransparency = 0.6 }); tw(ico, { ImageTransparency = 0.1 }); tw(nm, { TextTransparency = 0.15 }) end
	end)
	hit.MouseLeave:Connect(function()
		hover = false
		if not tab.active then tw(hl, { BackgroundTransparency = 1 }); tw(ico, { ImageTransparency = 0.35 }); tw(nm, { TextTransparency = 0.4 }) end
	end)
	local function relayout()
		if tab.isopen then kids.Visible = true end
		local anim = tw(kids, { Size = UDim2.new(1, 0, 0, tab.isopen and kl.AbsoluteContentSize.Y or 0) })
		if not tab.isopen then
			anim.Completed:Connect(function()
				if not tab.isopen then kids.Visible = false end
			end)
		end
	end
	kl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if tab.isopen then relayout() end
	end)
	function tab:setopen(v)
		self.isopen = self.kidsn > 0 and v and true or false
		relayout()
	end
	function tab:select() win:select(self) end
	hit.MouseButton1Click:Connect(function()
		lib:chime("click")
		win:select(tab)
	end)
	tab:paint(false)
	if not win.cur and not sub then win:select(tab) end
	return tab
end
function Tab:sub(cfg)
	local s = maketab(self.win, cfg, self)
	self.kidsn = self.kidsn + 1
	if self.active then self:setopen(true) end
	return s
end
function Tab:section(cfg)
	cfg = cfg or {}
	local pg = self._pg
	local card, content = newcard(pg, { title = cfg.name or "SECTION", icon = cfg.icon, side = sidekey(cfg.side), gap = cfg.gap })
	pg.cards[#pg.cards + 1] = card
	pg.titles[card] = string.lower(tostring(cfg.name or ""))
	local c = container_new(content, { pg = pg, card = card })
	c.card = card
	c.side = sidekey(cfg.side)
	return c
end
function Tab:color(cfg)
	cfg = cfg or {}
	local pg = self._pg
	local card, content = newcard(pg, { noheader = true, side = sidekey(cfg.side) })
	pg.cards[#pg.cards + 1] = card
	pg.titles[card] = ""
	return container_new(content, { pg = pg, card = card }):color(cfg)
end
function Tab:clone(cfg)
	cfg = cfg or {}
	local pg = self._pg
	local height = tonumber(cfg.height) or 250
	local card, content = newcard(pg, { title = cfg.name or "Character", icon = "user", side = sidekey(cfg.side), loose = true })
	local vp = mk("ViewportFrame", { Size = UDim2.new(1, 0, 0, height - 50), BackgroundTransparency = 1, ZIndex = 6, BorderSizePixel = 0, Ambient = Color3.fromRGB(160, 160, 170), LightColor = Color3.new(1, 1, 1) }, content)
	local cam = mk("Camera", { FieldOfView = tonumber(cfg.fov) or 40 }, vp)
	vp.CurrentCamera = cam
	local obj = { viewport = vp, camera = cam, angle = 0 }
	local zoom = tonumber(cfg.zoom) or 7
	local center = Vector3.new()
	local function aim()
		local rad = obj.angle
		cam.CFrame = CFrame.new(center + Vector3.new(math.sin(rad) * zoom, 0.6, math.cos(rad) * zoom), center)
	end
	function obj:refresh()
		if obj.model then obj.model:Destroy(); obj.model = nil end
		local char = LP.Character
		if not char then return end
		local arch = char.Archivable
		char.Archivable = true
		local ok, m = pcall(function() return char:Clone() end)
		char.Archivable = arch
		if not ok or not m then return end
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("LuaSourceContainer") then d:Destroy() end
		end
		local hum = m:FindFirstChildOfClass("Humanoid")
		if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
		m.Parent = vp
		local cf, size = m:GetBoundingBox()
		center = cf.Position
		if not cfg.zoom then zoom = math.max(size.X, size.Y, size.Z) * 1.9 end
		obj.model = m
		aim()
		if cfg.callback then safe(cfg.callback, obj) end
	end
	vp.InputBegan:Connect(function(input)
		local t = input.UserInputType
		if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
			local last = mpos(input).X
			startdrag(function(pos) obj.angle = obj.angle - (pos.X - last) * 0.012; last = pos.X; aim() end)
		end
	end)
	conn(LP.CharacterAdded, function() task.wait(1); obj:refresh() end)
	task.defer(function() obj:refresh() end)
	return obj
end
local function thumb(kind, v)
	if v == nil then return "" end
	if type(v) == "string" and (v:find("rbx") or v:find("http")) then return v end
	local id = tonumber(v)
	if not id then return icon(v) end
	local k = ({ Asset = "Asset", Avatar = "AvatarHeadShot", Bundle = "BundleThumbnail", GamePass = "GamePass" })[kind] or "Asset"
	return "rbxthumb://type=" .. k .. "&id=" .. id .. "&w=150&h=150"
end
function Tab:gallery(cfg)
	cfg = cfg or {}
	local pg = self._pg
	local height = tonumber(cfg.height) or 250
	local card, content = newcard(pg, { title = cfg.name or "LIST", icon = cfg.icon or "list", side = sidekey(cfg.side), loose = true })
	local multi = cfg.multi and true or false
	local cell, gap = tonumber(cfg.cell) or 64, tonumber(cfg.gap) or 6
	local tools = mk("Frame", { LayoutOrder = 1, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), ZIndex = 6 }, content)
	local sbox
	if cfg.search ~= false then
		sbox = mk("TextBox", {
			Size = UDim2.new(1, -4, 1, 0), Text = "", PlaceholderText = "search", ClearTextOnFocus = false, Font = Enum.Font.GothamMedium,
			TextSize = 11, ZIndex = 7, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left,
			bind = { BackgroundColor3 = "head", TextColor3 = "text", PlaceholderColor3 = "dim" },
		}, tools)
		corner(sbox, 6); pad(sbox, 8, 8, 0, 0); stroke(sbox, "line", 0.5)
	end
	local btns = {}
	if cfg.tools ~= false then
		btns[#btns + 1] = { name = "all", fn = function(o) o:all() end }
		btns[#btns + 1] = { name = "clear", fn = function(o) o:clear() end }
	end
	if cfg.reset then btns[#btns + 1] = { name = "reset", fn = function(o) o:reset() end } end
	for _, b in ipairs(cfg.buttons or {}) do btns[#btns + 1] = { name = b.name or b.Name or "?", ext = b.callback or b.Callback } end
	local grid = mk("ScrollingFrame", {
		LayoutOrder = 3, Size = UDim2.new(1, 0, 0, math.max(60, height - 110)), BackgroundTransparency = 1, ZIndex = 6, BorderSizePixel = 0,
		ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, content)
	mk("UIGridLayout", { CellSize = UDim2.fromOffset(cell, cell), CellPadding = UDim2.fromOffset(gap, gap), SortOrder = Enum.SortOrder.LayoutOrder }, grid)
	local empty = lbl(grid, { Text = tostring(cfg.empty or "empty"), Size = UDim2.new(1, 0, 0, 30), TextColor3 = THEME.dim, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Center, Visible = false })
	local o = { data = {}, selected = {}, cells = {}, query = "", def = cfg.default, callback = cfg.callback }
	local function norm(it, i)
		if type(it) == "table" then
			local id = it.Id or it.id or it.Image or it.image or it.Asset or it.asset
			local val = it.Value
			if val == nil then val = it.value end
			if val == nil then val = it.Name or it.name or id or i end
			return { name = tostring(it.Name or it.name or it.Text or id or i), value = val, image = id, raw = it }
		end
		return { name = tostring(it), value = it, image = it, raw = it }
	end
	local function paintcells()
		for _, c in ipairs(o.cells) do
			local on = o.selected[c.item.value] == true
			tw(c.st, { Transparency = on and 0.1 or 0.55, Color = on and THEME.accent or THEME.line }, FAST)
		end
	end
	local function fire() safe(o.callback, o:get()) end
	local function rebuild()
		for _, c in ipairs(o.cells) do c.frame:Destroy() end
		o.cells = {}
		local items = {}
		if cfg.blank then items[1] = { name = tostring(cfg.blank), value = nil, blank = true } end
		for _, it in ipairs(o.data) do items[#items + 1] = it end
		local q = string.lower(o.query)
		local n = 0
		for i, item in ipairs(items) do
			if q == "" or string.lower(item.name):find(q, 1, true) then
				n = n + 1
				local fr = mk("TextButton", { LayoutOrder = i, Text = "", AutoButtonColor = false, ZIndex = 7, BorderSizePixel = 0, bind = { BackgroundColor3 = "head" } }, grid)
				corner(fr, 6)
				local st = mk("UIStroke", { Transparency = 0.55, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, bind = { Color = "line" } }, fr)
				if item.image ~= nil then
					img(fr, { Image = thumb(cfg.thumb or "Asset", item.image), Position = UDim2.fromOffset(4, 4), Size = UDim2.new(1, -8, 1, -20), ZIndex = 8, ImageColor3 = Color3.new(1, 1, 1) })
				end
				lbl(fr, { Text = item.name, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 3, 1, -2), Size = UDim2.new(1, -6, 0, 12), TextSize = 9, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8, TextColor3 = THEME.dim })
				local lastclick = 0
				fr.MouseButton1Click:Connect(function()
					lib:chime("tick")
					if item.blank then o.selected = {}
					elseif multi then o.selected[item.value] = not o.selected[item.value] or nil
					else o.selected = { [item.value] = true } end
					paintcells(); fire()
					if cfg.action and os.clock() - lastclick < 0.35 then safe(cfg.action, item.raw, item.value) end
					lastclick = os.clock()
				end)
				fr.MouseButton2Click:Connect(function()
					if type(cfg.context) ~= "table" then return end
					local pop = popup_frame(130)
					pad(pop, 4, 4, 4, 4); vlist(pop, 0)
					for k, ent in ipairs(cfg.context) do
						local b = mk("TextButton", { LayoutOrder = k, Size = UDim2.new(1, 0, 0, 22), Text = "  " .. tostring(ent.name or ent.Name or "?"), Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, ZIndex = 302, BorderSizePixel = 0, AutoButtonColor = false, bind = { TextColor3 = "text" } }, pop)
						b.MouseButton1Click:Connect(function()
							closepop(pop)
							safe(ent.callback or ent.Callback, item.raw, item.value)
						end)
					end
					pop.Visible = true
					openpop(pop, fr, function() pop:Destroy() end)
					task.defer(placepop, pop, fr, true)
				end)
				o.cells[#o.cells + 1] = { frame = fr, st = st, item = item }
			end
		end
		empty.Visible = n == 0
		paintcells()
	end
	function o:setdata(list)
		o.data = {}
		for i, it in ipairs(list or {}) do o.data[i] = norm(it, i) end
		rebuild()
	end
	o.setvalues = o.setdata
	function o:get()
		if multi then
			local out = {}
			for _, it in ipairs(o.data) do if o.selected[it.value] then out[#out + 1] = it.value end end
			return out
		end
		for _, it in ipairs(o.data) do if o.selected[it.value] then return it.value end end
		return nil
	end
	function o:set(v, silent)
		o.selected = {}
		if type(v) == "table" then
			for _, x in ipairs(v) do o.selected[x] = true end
		elseif v ~= nil then
			o.selected[v] = true
		end
		paintcells()
		if not silent then fire() end
	end
	function o:setdefault(v) o.def = v; o:set(v, true) end
	function o:reset() o:set(o.def, false) end
	function o:refresh() rebuild() end
	function o:clear() o.selected = {}; paintcells(); fire() end
	function o:all()
		if multi then
			o.selected = {}
			for _, it in ipairs(o.data) do o.selected[it.value] = true end
			paintcells(); fire()
		end
	end
	function o:search(q) o.query = tostring(q or ""); rebuild() end
	if sbox then sbox:GetPropertyChangedSignal("Text"):Connect(function() o:search(sbox.Text) end) end
	if #btns > 0 then
		local row = mk("Frame", { LayoutOrder = 2, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), ZIndex = 6 }, content)
		mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, row)
		for i, b in ipairs(btns) do
			local w = math.ceil(tsize(b.name, 11, Enum.Font.GothamBold).X) + 20
			local bt = mk("TextButton", { LayoutOrder = i, Size = UDim2.fromOffset(w, 22), Text = b.name, Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 7, BorderSizePixel = 0, AutoButtonColor = false, bind = { BackgroundColor3 = "head", TextColor3 = "text" } }, row)
			corner(bt, 6); stroke(bt, "line", 0.5)
			bt.MouseButton1Click:Connect(function()
				lib:chime("click")
				if b.fn then b.fn(o) else safe(b.ext, o) end
			end)
		end
	end
	o:setdata(cfg.list or {})
	if o.def ~= nil then o:set(o.def, true) end
	if cfg.flag then
		if type(o.callback) == "function" then
			local pcb = o.callback
			o.callback = function(...) lib:markdirty() return pcb(...) end
		end
		local pset = o.set
		o.set = function(self, ...) lib:markdirty() return pset(self, ...) end
		lib.flags[cfg.flag] = o; o.flag = cfg.flag
	end
	return o
end
function Tab:configs(cfg)
	cfg = cfg or {}
	local pg = self._pg
	local card, content = newcard(pg, { title = cfg.name or "Configs", icon = "save", headh = 28, nochev = true, raw = true, rawh = 236, side = sidekey(cfg.side) })
	pg.cards[#pg.cards + 1] = card
	pg.titles[card] = string.lower(tostring(cfg.name or "configs"))
	local chosen = ""
	local list = mk("ScrollingFrame", {
		Position = UDim2.fromOffset(10, 8), Size = UDim2.new(1, -20, 0, 128), ZIndex = 6, BorderSizePixel = 0, ScrollBarThickness = 0,
		CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 0.3, bind = { BackgroundColor3 = "bg" },
	}, content)
	corner(list, 6); stroke(list, "line", 0.74); vlist(list, 2); pad(list, 4, 4, 4, 4)
	local empty = lbl(content, {
		Text = tostring(cfg.empty or "no configs yet"), Position = UDim2.fromOffset(10, 8), Size = UDim2.new(1, -20, 0, 128), ZIndex = 7,
		TextColor3 = THEME.dim, TextTransparency = 0.5, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, Visible = false,
	})
	local tb = mk("TextBox", {
		Position = UDim2.fromOffset(10, 144), Size = UDim2.new(1, -20, 0, 26), ZIndex = 6, BorderSizePixel = 0, Text = "",
		PlaceholderText = "config name", ClearTextOnFocus = false, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
		ClipsDescendants = true, bind = { BackgroundColor3 = "head", TextColor3 = "text", PlaceholderColor3 = "dim" },
	}, content)
	corner(tb, 6); pad(tb, 10, 10, 0, 0)
	local tst = stroke(tb, "line", 0.6)
	tb.Focused:Connect(function() tw(tst, { Transparency = 0.25 }) end)
	tb.FocusLost:Connect(function() tw(tst, { Transparency = 0.6 }); chosen = tb.Text end)
	local status = lbl(content, { Position = UDim2.fromOffset(11, 212), Size = UDim2.new(1, -22, 0, 14), TextSize = 11, TextColor3 = THEME.dim, ZIndex = 6, Text = "" })
	local stok = 0
	local function say(t)
		stok = stok + 1
		local my = stok
		status.Text = t
		task.delay(4, function() if my == stok then status.Text = "" end end)
	end
	local paintrows = function() end
	local function refresh()
		local names = lib:listconfigs()
		for _, ch in ipairs(list:GetChildren()) do
			if ch:IsA("Frame") then ch:Destroy() end
		end
		local rowsOf = {}
		for i, n in ipairs(names) do
			local o = mk("Frame", { LayoutOrder = i, Size = UDim2.new(1, 0, 0, 21), BackgroundTransparency = 1, ZIndex = 6 }, list)
			local hl = mk("Frame", { Size = UDim2.fromScale(1, 1), ZIndex = 6, BorderSizePixel = 0, BackgroundTransparency = 1, bind = { BackgroundColor3 = "panel" } }, o)
			corner(hl, 5); grad(hl, 0, { { 0, 0 }, { 0.7, 0.25 }, { 1, 0.55 } })
			local tx = lbl(o, { Text = n, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -16, 1, 0), TextSize = 12, TextColor3 = THEME.dim, TextTransparency = 0.45, ZIndex = 7 })
			local hb = mk("ImageButton", { Size = UDim2.fromScale(1, 1), ZIndex = 8, BackgroundTransparency = 1, ImageTransparency = 1, AutoButtonColor = false, Selectable = false }, o)
			rowsOf[n] = { hl = hl, tx = tx }
			hb.MouseButton1Click:Connect(function()
				chosen = n; tb.Text = n
				paintrows()
			end)
		end
		paintrows = function()
			for n, o in pairs(rowsOf) do
				local on = tb.Text == n
				tw(o.hl, { BackgroundTransparency = on and 0.12 or 1 }, FAST)
				tw(o.tx, { TextColor3 = on and THEME.text or THEME.dim, TextTransparency = on and 0 or 0.45 }, FAST)
			end
		end
		paintrows()
		empty.Visible = #names == 0
	end
	local rowf = mk("Frame", { Position = UDim2.fromOffset(10, 178), Size = UDim2.new(1, -20, 0, 28), BackgroundTransparency = 1, ZIndex = 6 }, content)
	mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, rowf)
	local actions = {
		{ icon = "save", fn = function()
			local n = tb.Text ~= "" and tb.Text or chosen
			if n == "" then say("enter a name first") return end
			if lib:saveconfig(n) then say("saved: " .. n); lib:notify({ title = "saved", text = n, icon = "save" }) else say("save failed") end
			refresh()
		end },
		{ icon = "folder", fn = function()
			local n = tb.Text ~= "" and tb.Text or chosen
			if lib:loadconfig(n) then say("loaded: " .. n); lib:notify({ title = "loaded", text = n, icon = "check" }) else say("load failed") end
		end },
		{ icon = "file-text", fn = function() refresh(); say(#lib:listconfigs() .. " config(s)") end },
		{ icon = "trash-2", fn = function()
			local n = tb.Text ~= "" and tb.Text or chosen
			if n == "" then say("pick a config first") return end
			lib:confirm({
				title = "delete config", text = "delete '" .. n .. "'?", confirm = "delete", cancel = "cancel",
				callback = function() lib:deleteconfig(n); say("deleted: " .. n); refresh() end,
			})
		end },
	}
	for i, a in ipairs(actions) do
		local b = mk("ImageButton", {
			LayoutOrder = i, Size = UDim2.new(0.25, -4, 1, 0), ZIndex = 6, BorderSizePixel = 0, AutoButtonColor = false, Selectable = false,
			BackgroundTransparency = 0.12, ImageTransparency = 1, bind = { BackgroundColor3 = "head" },
		}, rowf)
		corner(b, 6)
		local st = stroke(b, "line", 0.78)
		local ic = img(b, { Image = icon(a.icon), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(15, 15), ImageTransparency = 0.25, ZIndex = 7 })
		b.MouseEnter:Connect(function() tw(st, { Transparency = 0.45 }); tw(ic, { ImageColor3 = THEME.text, ImageTransparency = 0 }) end)
		b.MouseLeave:Connect(function() tw(st, { Transparency = 0.78 }); tw(ic, { ImageColor3 = THEME.dim, ImageTransparency = 0.25 }) end)
		b.MouseButton1Click:Connect(function() lib:chime("click"); a.fn() end)
	end
	task.defer(refresh)
	return { refresh = refresh, list = list }
end
function lib:togglemenus()
	local any = false
	for _, w in ipairs(self.wins) do if w.open then any = true end end
	for _, w in ipairs(self.wins) do w:toggle(not any) end
end
local function pngstrip(data, tol, tol2)
	if type(data) ~= "string" or data:sub(1, 8) ~= "\137PNG\13\10\26\10" then return nil end
	local floor = math.floor
	local sbyte, schar, ssub, srep = string.byte, string.char, string.sub, string.rep
	local unpack = table.unpack or unpack
	local tconcat = table.concat
local function slowXor(a, b)
		local r, bit = 0, 1
		while a > 0 or b > 0 do
			local ab, bb = a % 2, b % 2
			if ab ~= bb then r = r + bit end
			a = (a - ab) / 2
			b = (b - bb) / 2
			bit = bit * 2
		end
		return r
	end
	local bxor = (bit32 and bit32.bxor) or slowXor
	local crcTable
	local function crc32(s)
		if not crcTable then
			crcTable = {}
			for i = 0, 255 do
				local c = i
				for _ = 1, 8 do
					if c % 2 == 1 then
						c = bxor(floor(c / 2), 3988292384)
					else
						c = floor(c / 2)
					end
				end
				crcTable[i] = c
			end
		end
		local crc = 4294967295
		for i = 1, #s do
			crc = bxor(crcTable[bxor(crc % 256, string.byte(s, i))], floor(crc / 256))
		end
		return bxor(crc, 4294967295)
	end
	local LBASE = {3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258}
	local LEXT = {0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0}
	local DBASE = {1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577}
	local DEXT = {0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13}
	local CLORDER = {16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15}
	local function inflate(data, startPos)
		local pos = startPos
		local buf, cnt = 0, 0
		local out, outn = {}, 0
		local function bits(n)
			if n == 0 then return 0 end
			while cnt < n do
				buf = buf + (string.byte(data, pos) or 0) * 2 ^ cnt
				pos = pos + 1
				cnt = cnt + 8
			end
			local v = buf % 2 ^ n
			buf = (buf - v) / 2 ^ n
			cnt = cnt - n
			return v
		end
		local function build(lengths, n)
			local count, symbol = {}, {}
			for i = 0, 15 do count[i] = 0 end
			for i = 0, n - 1 do
				local l = lengths[i] or 0
				count[l] = count[l] + 1
			end
			count[0] = 0
			local offs = {}
			offs[1] = 0
			for l = 1, 15 do offs[l + 1] = offs[l] + count[l] end
			for i = 0, n - 1 do
				local l = lengths[i] or 0
				if l ~= 0 then
					symbol[offs[l]] = i
					offs[l] = offs[l] + 1
				end
			end
			return { count = count, symbol = symbol }
		end
		local function decode(h)
			local code, first, index = 0, 0, 0
			for len = 1, 15 do
				code = code + bits(1)
				local c = h.count[len]
				if code - c < first then
					return h.symbol[index + (code - first)]
				end
				index = index + c
				first = (first + c) * 2
				code = code * 2
			end
			return nil
		end
		local fixedL, fixedD
		while true do
			local last = bits(1)
			local btype = bits(2)
			if btype == 0 then
				buf, cnt = 0, 0
				local len = (string.byte(data, pos) or 0) + (string.byte(data, pos + 1) or 0) * 256
				pos = pos + 4
				for _ = 1, len do
					outn = outn + 1
					out[outn] = string.byte(data, pos) or 0
					pos = pos + 1
				end
			elseif btype == 1 or btype == 2 then
				local lcodes, dcodes
				if btype == 1 then
					if not fixedL then
						local l = {}
						for i = 0, 143 do l[i] = 8 end
						for i = 144, 255 do l[i] = 9 end
						for i = 256, 279 do l[i] = 7 end
						for i = 280, 287 do l[i] = 8 end
						fixedL = build(l, 288)
						local d = {}
						for i = 0, 29 do d[i] = 5 end
						fixedD = build(d, 30)
					end
					lcodes, dcodes = fixedL, fixedD
				else
					local hlit = bits(5) + 257
					local hdist = bits(5) + 1
					local hclen = bits(4) + 4
					local cl = {}
					for i = 0, 18 do cl[i] = 0 end
					for i = 1, hclen do cl[CLORDER[i]] = bits(3) end
					local clh = build(cl, 19)
					local lens = {}
					local i = 0
					while i < hlit + hdist do
						local sym = decode(clh)
						if sym == nil then return nil end
						if sym < 16 then
							lens[i] = sym
							i = i + 1
						elseif sym == 16 then
							local prev = lens[i - 1] or 0
							for _ = 1, 3 + bits(2) do
								lens[i] = prev
								i = i + 1
							end
						elseif sym == 17 then
							for _ = 1, 3 + bits(3) do
								lens[i] = 0
								i = i + 1
							end
						else
							for _ = 1, 11 + bits(7) do
								lens[i] = 0
								i = i + 1
							end
						end
					end
					local ll, dl = {}, {}
					for j = 0, hlit - 1 do ll[j] = lens[j] or 0 end
					for j = 0, hdist - 1 do dl[j] = lens[hlit + j] or 0 end
					lcodes = build(ll, hlit)
					dcodes = build(dl, hdist)
				end
				while true do
					local sym = decode(lcodes)
					if sym == nil then return nil end
					if sym < 256 then
						outn = outn + 1
						out[outn] = sym
					elseif sym == 256 then
						break
					else
						sym = sym - 256
						if sym > 29 then return nil end
						local length = LBASE[sym] + bits(LEXT[sym])
						local dsym = decode(dcodes)
						if dsym == nil or dsym > 29 then return nil end
						local dist = DBASE[dsym + 1] + bits(DEXT[dsym + 1])
						local from = outn - dist
						if from < 0 then return nil end
						for k = 1, length do
							outn = outn + 1
							out[outn] = out[from + k]
						end
					end
				end
			else
				return nil
			end
			if last == 1 then break end
		end
		return out, outn
	end
	local function bytesToString(t, n)
		local parts, p = {}, 0
		local i = 1
		while i <= n do
			local j = i + 2047
			if j > n then j = n end
			p = p + 1
			parts[p] = string.char(unpack(t, i, j))
			i = j + 1
		end
		return table.concat(parts)
	end
	local function u32(v)
		return string.char(floor(v / 16777216) % 256, floor(v / 65536) % 256, floor(v / 256) % 256, v % 256)
	end
	local function pngChunk(typ, data)
		return u32(#data) .. typ .. data .. u32(crc32(typ .. data))
	end
	local pos, w, h, depth, ctype, inter = 9, nil, nil, nil, nil, nil
	local idat = {}
	while pos + 8 <= #data + 1 do
		local b1, b2, b3, b4 = sbyte(data, pos, pos + 3)
		local len = ((b1 * 256 + b2) * 256 + b3) * 256 + b4
		local typ = ssub(data, pos + 4, pos + 7)
		local body = ssub(data, pos + 8, pos + 7 + len)
		if typ == "IHDR" then
			w = ((sbyte(body, 1) * 256 + sbyte(body, 2)) * 256 + sbyte(body, 3)) * 256 + sbyte(body, 4)
			h = ((sbyte(body, 5) * 256 + sbyte(body, 6)) * 256 + sbyte(body, 7)) * 256 + sbyte(body, 8)
			depth, ctype, inter = sbyte(body, 9), sbyte(body, 10), sbyte(body, 13)
		elseif typ == "IDAT" then
			idat[#idat + 1] = body
		elseif typ == "IEND" then
			break
		end
		pos = pos + 12 + len
	end
	if not w or depth ~= 8 or inter ~= 0 then return nil end
	local chan = ({ [0] = 1, [2] = 3, [4] = 2, [6] = 4 })[ctype]
	if not chan then return nil end
	local z = tconcat(idat)
	if #z < 3 then return nil end
	local px = inflate(z, 3)
	if not px then return nil end
	local stride = w * chan
	if #px < h * (stride + 1) then return nil end
	local rows, prev, src = {}, nil, 1
	for y = 0, h - 1 do
		local filter = px[src]
		src = src + 1
		local row = {}
		for i = 1, stride do
			row[i] = px[src]
			src = src + 1
		end
		if filter == 1 then
			for i = chan + 1, stride do row[i] = (row[i] + row[i - chan]) % 256 end
		elseif filter == 2 then
			if prev then for i = 1, stride do row[i] = (row[i] + prev[i]) % 256 end end
		elseif filter == 3 then
			for i = 1, stride do
				local l = (i > chan) and row[i - chan] or 0
				local u = prev and prev[i] or 0
				row[i] = (row[i] + floor((l + u) / 2)) % 256
			end
		elseif filter == 4 then
			for i = 1, stride do
				local l = (i > chan) and row[i - chan] or 0
				local u = prev and prev[i] or 0
				local ul = (prev and i > chan) and prev[i - chan] or 0
				local p = l + u - ul
				local pa, pb, pc = math.abs(p - l), math.abs(p - u), math.abs(p - ul)
				local pr = ul
				if pa <= pb and pa <= pc then pr = l elseif pb <= pc then pr = u end
				row[i] = (row[i] + pr) % 256
			end
		elseif filter ~= 0 then
			return nil
		end
		rows[y] = row
		prev = row
	end
	local br, bgc, bb = 0, 0, 0
	for _, p in ipairs({ { 0, 0 }, { w - 1, 0 }, { 0, h - 1 }, { w - 1, h - 1 } }) do
		local row = rows[p[2]]
		local o = p[1] * chan + 1
		br, bgc, bb = br + row[o], bgc + row[o + 1], bb + row[o + 2]
	end
	br, bgc, bb = floor(br / 4 + 0.5), floor(bgc / 4 + 0.5), floor(bb / 4 + 0.5)
	local px2, pn = table.create(h * w * 4, 0), 0
	for y = 0, h - 1 do
		local row = rows[y]
		for x = 0, w - 1 do
			local o = x * chan + 1
			local r, g, b = row[o], row[o + 1], row[o + 2]
			local a = (chan == 4) and row[o + 3] or 255
			local d = math.max(math.abs(r - br), math.abs(g - bgc), math.abs(b - bb))
			if d <= tol then
				a = 0
			elseif d < tol2 then
				a = floor(a * (d - tol) / (tol2 - tol))
			end
			pn = pn + 1
			px2[pn], px2[pn + 1], px2[pn + 2], px2[pn + 3] = r, g, b, a
		end
	end
	local raw, rn = {}, 0
	for y = 0, h - 1 do
		rn = rn + 1
		raw[rn] = 0
		local base = y * w * 4
		for i = 1, w * 4 do
			rn = rn + 1
			raw[rn] = px2[base + i]
		end
	end
	local s1, s2 = 1, 0
	for i = 1, rn do
		s1 = (s1 + raw[i]) % 65521
		s2 = (s2 + s1) % 65521
	end
	local body = "\120\1"
	local off = 1
	while off <= rn do
		local last = (off + 65535 > rn) and 1 or 0
		local part = tconcat(raw, "\0", off, math.min(off + 65534, rn), off)
		local len = #part
		local nlen = 65535 - len
		body = body .. schar(last, len % 256, floor(len / 256), nlen % 256, floor(nlen / 256)) .. part
		off = off + len
	end
	body = body .. u32(s2 * 65536 + s1)
	return "\137PNG\13\10\26\10"
		.. pngChunk("IHDR", u32(w) .. u32(h) .. schar(8, 6, 0, 0, 0))
		.. pngChunk("IDAT", body)
		.. pngChunk("IEND", "")
end
local function httpget(url)
	local ok, res = pcall(function() return game:HttpGet(url) end)
	if ok and type(res) == "string" and #res > 0 then return res end
	local req = (syn and syn.request) or request or http_request or (http and http.request)
	if req then
		local ok2, r = pcall(req, { Url = url, Method = "GET" })
		if ok2 and type(r) == "table" and type(r.Body) == "string" and #r.Body > 0 then return r.Body end
	end
	return nil
end
local function localbytes(src)
	if type(src) ~= "string" or src:find("://") then return nil end
	local cands = { src }
	if not src:find("/") and not src:find("\\") then
		cands[#cands + 1] = lib:assetdir() .. "/" .. src
		cands[#cands + 1] = lib:gamedir() .. "/" .. src
		cands[#cands + 1] = lib:rootdir() .. "/" .. src
	end
	for _, p in ipairs(cands) do
		local ok, d = pcall(readfile, p)
		if ok and type(d) == "string" and #d > 0 then return d, p end
	end
	return nil
end
local function write_embedded()
	local wf = fsok("writefile")
	if not wf then return nil end
	local p = lib:assetdir() .. "/yall_holy_logo.png"
	pcall(wf, p, b64decode(EMBEDDED_LOGO))
	return p
end
local function resolveasset(src, wantnobg)
	local wf, isf = fsok("writefile"), fsok("isfile")
	local gca = fsok("getcustomasset") or fsok("getsynasset")
	if not (wf and gca) then return nil end
	if src == "yall_holy_logo2.png" then
		local lp = write_embedded()
		if lp then
			local ok, a = pcall(gca, lp)
			if ok and a then return a end
		end
	end
	local key = src:gsub("[^%w]", "_"):sub(-40)
	local dir = lib:assetdir()
	for _, ext in ipairs({ "png", "jpg", "jpeg" }) do
		local p = dir .. "/" .. key .. "." .. ext
		if isf and isf(p) then
			local ok, a = pcall(gca, p)
			if ok and a then return a end
		end
	end
	local data, fromlocal = localbytes(src)
	if not data then
		local direct = src
		local id = src:match("imgur%.com/a/([%w%-_]+)") or src:match("^imgur:([%w%-_]+)")
		if id then
			id = id:match("([^%-]+)$")
			local html = httpget("https://imgur.com/a/" .. id)
			direct = nil
			if html then
				local seen, cands = {}, {}
				for m in html:gmatch("(https?://i%.imgur%.com/[%w%-_/%.]+)") do
					m = m:gsub("%?.*$", "")
					local base = m:match("([%w%-_]+)%.%a+$")
					if base and not seen[base] then
						seen[base] = true
						cands[#cands + 1] = base
					end
				end
				local fallback
				for _, base in ipairs(cands) do
					for _, ext2 in ipairs({ "png", "jpg" }) do
						local cand = "https://i.imgur.com/" .. base .. "." .. ext2
						local body = httpget(cand)
						if body and #body > 0 then
							if body:sub(1, 8) == "\137PNG\13\10\26\10" then
								direct = cand
								data = body
								break
							elseif not fallback then
								fallback = cand
								fallback = fallback
							end
						end
					end
					if data then break end
				end
				if not data and fallback then
					direct = fallback
					data = httpget(direct)
				end
			end
		else
			data = httpget(direct)
		end
		if not data then return nil end
	end
	local ext = (data:sub(1, 8) == "\137PNG\13\10\26\10") and "png" or ((data:sub(1, 3) == "\255\216\255") and "jpg" or "png")
	if wantnobg and ext == "png" then
		local ok, clean = pcall(pngstrip, data, 26, 92)
		if ok and clean and #clean > 0 then data = clean end
	elseif wantnobg and ext == "jpg" then
		lib._bgwarn = true
	end
	local p = dir .. "/" .. key .. "." .. ext
	if not pcall(wf, p, data) then return nil end
	local ok, a = pcall(gca, p)
	if ok then return a end
	return nil
end
function lib:_loadlogo(win, src)
	if src == nil or src == "" then
		src = "yall_holy_logo2.png"
	end
	if type(src) == "number" then
		win.logo.Image = "rbxassetid://" .. src; win.logotext.Visible = false
		return
	end
	src = tostring(src)
	if src:find("^rbx") then
		win.logo.Image = src; win.logotext.Visible = false
		return
	end
	task.spawn(function()
		local asset = resolveasset(src, true)
		if asset and lib.alive and win.logo.Parent then
			win.logo.Image = asset
			win.logotext.Visible = false
		else
			warn("[ui] logo not loaded: " .. src .. " (use a direct image link, rbxassetid or put the file into workspace)")
		end
		if lib._bgwarn then
			lib._bgwarn = nil
			warn("[ui] this logo is a JPG - background cannot be cut. Save it as PNG with transparency and pass: lib:setlogo('logo.png')")
		end
	end)
end
function lib:setlogo(src)
	self.logo = src
	for _, w in ipairs(self.wins) do self:_loadlogo(w, src) end
end
local function buildnet(layer)
	local net = { dots = {}, lines = {}, ready = false }
	for i = 1, 13 do
		local sz = ({ 2, 3, 4 })[math.random(1, 3)]
		local d = mk("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 0.23 + math.random() * 0.22, Size = UDim2.fromOffset(sz, sz),
			ZIndex = 3, BorderSizePixel = 0, bind = { BackgroundColor3 = "glow" },
		}, layer)
		corner(d, "full")
		local ang = math.random() * math.pi * 2
		net.dots[i] = { f = d, x = 0, y = 0, vx = math.cos(ang) * (14 + math.random() * 22), vy = math.sin(ang) * (14 + math.random() * 22) }
	end
	for i = 1, 91 do
		net.lines[i] = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Visible = false, Size = UDim2.fromOffset(0, 1), ZIndex = 2, BorderSizePixel = 0, bind = { BackgroundColor3 = "glow" } }, layer)
	end
	function net.step(dt)
		local sz = layer.AbsoluteSize
		if sz.X < 10 then return end
		if not net.ready then
			for _, d in ipairs(net.dots) do d.x, d.y = math.random() * sz.X, math.random() * sz.Y end
			net.ready = true
		end
		for _, d in ipairs(net.dots) do
			d.x = d.x + d.vx * dt; d.y = d.y + d.vy * dt
			if d.x < 0 or d.x > sz.X then d.vx = -d.vx; d.x = math.clamp(d.x, 0, sz.X) end
			if d.y < 0 or d.y > sz.Y then d.vy = -d.vy; d.y = math.clamp(d.y, 0, sz.Y) end
			d.f.Position = UDim2.fromOffset(d.x, d.y)
		end
		local idx, maxd = 0, 130
		for i = 1, #net.dots - 1 do
			for j = i + 1, #net.dots do
				local a, b = net.dots[i], net.dots[j]
				local dx, dy = b.x - a.x, b.y - a.y
				local dist = math.sqrt(dx * dx + dy * dy)
				if dist < maxd and idx < #net.lines then
					idx = idx + 1
					local l = net.lines[idx]
					l.Visible = true
					l.Position = UDim2.fromOffset((a.x + b.x) / 2, (a.y + b.y) / 2)
					l.Size = UDim2.fromOffset(dist, 1)
					l.Rotation = math.deg(math.atan2(dy, dx))
					l.BackgroundTransparency = 0.55 + (dist / maxd) * 0.45
				end
			end
		end
		for i = idx + 1, #net.lines do net.lines[i].Visible = false end
	end
	return net
end
function lib:window(cfg)
	if not self.alive then return end
	cfg = cfg or {}
	local size = cfg.size
	if typeof(size) == "Vector2" then size = UDim2.fromOffset(size.X, size.Y) end
	local vs = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or gui.AbsoluteSize
	size = size or UDim2.fromOffset(
		math.min(680, math.max(528, vs.X - 48)),
		math.min(560, math.max(420, vs.Y - 48))
	)
	local side = tonumber(cfg.side) or math.max(153, math.min(196, math.floor(size.X.Offset * 0.27)))
	local radius = tonumber(cfg.radius) or 9
	local logo = cfg.logo or self.logo or ""
	if cfg.title then self:retitle(cfg.title) end
	local win = { open = true, tabn = 0, size = size, side = side, tabsList = {} }
	local shell = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Name = randname(), Active = true, Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, BorderSizePixel = 0, Size = size, Visible = false }, gui)
	local uiscale = mk("UIScale", { Scale = 0.96 * self.scale }, shell)
	win.shell = shell
	local sh = mk("Frame", { BackgroundTransparency = 1, ZIndex = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1) }, shell)
	corner(sh, radius)
	local shadows = { { shadow(sh, 0, 1, 16, 2, -1), 0.2 }, { shadow(sh, 0, 1, 38, 12, -2), 0.45 } }
	local function shadowshow(v, info)
		for _, s in ipairs(shadows) do
			if s[1] then
				if v then tw(s[1], { Transparency = s[2] }, info or EASE) else s[1].Transparency = 1 end
			end
		end
	end
	shell:GetPropertyChangedSignal("Visible"):Connect(function()
		for _, s in ipairs(shadows) do
			if s[1] then
				s[1].Enabled = shell.Visible
				if not shell.Visible then s[1].Transparency = 1 end
			end
		end
	end)
	local root = mk("CanvasGroup", { GroupTransparency = 1, Active = true, ClipsDescendants = true, ZIndex = 2, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), bind = { BackgroundColor3 = "bg" } }, shell)
	corner(root, radius)
	win.root = root
	local frame = mk("Frame", { BackgroundTransparency = 1, ZIndex = 20, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1) }, root)
	corner(frame, radius); stroke(frame, "line", 0.6)
	local base = mk("Frame", { Active = true, ZIndex = 0, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, root)
	smoothdrag(base, shell)
	local body = mk("Frame", { Position = UDim2.fromOffset(side, 0), ClipsDescendants = true, ZIndex = 1, BorderSizePixel = 0, Size = UDim2.new(1, -side, 1, 0), bind = { BackgroundColor3 = "bg" } }, root)
	corner(body, radius)
	mk("Frame", { ZIndex = 1, BorderSizePixel = 0, Size = UDim2.new(0, radius, 1, 0), bind = { BackgroundColor3 = "bg" } }, body)
	local netlayer = mk("Frame", { ClipsDescendants = true, BackgroundTransparency = 1, ZIndex = 2, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1) }, body)
	local net = buildnet(netlayer)
	win.net = net
	conn(RunService.RenderStepped, function(dt)
		if win.open and net.on ~= false and shell.Visible then net.step(math.min(dt, 0.1)) end
	end)
	win.pages = mk("Frame", { Position = UDim2.fromOffset(16, 16), ZIndex = 4, BackgroundTransparency = 1, Size = UDim2.new(1, -32, 1, -32) }, body)
	local sb = mk("Frame", { ClipsDescendants = true, ZIndex = 5, BorderSizePixel = 0, Size = UDim2.new(0, side, 1, 0), bind = { BackgroundColor3 = "side" } }, root)
	corner(sb, radius)
	mk("Frame", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), ZIndex = 5, BorderSizePixel = 0, Size = UDim2.new(0, radius, 1, 0), bind = { BackgroundColor3 = "side" } }, sb)
	smoothdrag(sb, shell)
	local sep = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, side, 0.5, 0), ZIndex = 8, BackgroundTransparency = 1, Size = UDim2.new(0, 16, 1, 0) }, root)
	local sepg = mk("Frame", { BackgroundTransparency = 0.9, ZIndex = 8, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), bind = { BackgroundColor3 = "glow" } }, sep)
	grad(sepg, 0, { { 0, 1 }, { 0.5, 0.35 }, { 1, 1 } })
	local sepl = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 9, BorderSizePixel = 0, Size = UDim2.new(0, 1, 1, 0), bind = { BackgroundColor3 = "line" } }, sep)
	grad(sepl, 90, { { 0, 1 }, { 0.12, 0.25 }, { 0.88, 0.25 }, { 1, 1 } })
	win.logo = img(sb, { AnchorPoint = Vector2.new(0.5, 0), Image = "", Position = UDim2.new(0.5, 0, 0, 14), ZIndex = 7, Size = UDim2.fromOffset(117, 117), bind = { ImageColor3 = "accent" } })
	win.logotext = lbl(sb, { Text = tostring(cfg.title or self.title), Position = UDim2.fromOffset(8, 14), Size = UDim2.new(1, -16, 0, 117), TextSize = 20, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 7, TextColor3 = THEME.text })
	self:_loadlogo(win, logo)
	if cfg.mascot then
		local m = mk("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromOffset(side * 0.5, 18), Size = UDim2.fromOffset(176, 176),
			BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 24, Image = "",
		}, shell)
		task.spawn(function()
			local ms = cfg.mascot
			local a
			if type(ms) == "number" then a = "rbxassetid://" .. ms
			elseif type(ms) == "string" and ms:find("^rbx") then a = ms
			else a = resolveasset(tostring(ms), false) end
			if a and lib.alive and m.Parent then m.Image = a end
		end)
	end
	local function hair(y, anchor, pos)
		local l = mk("Frame", { AnchorPoint = Vector2.new(0.5, anchor), BackgroundTransparency = 0.35, Position = pos, ZIndex = 7, BorderSizePixel = 0, Size = UDim2.new(1, -28, 0, 1), bind = { BackgroundColor3 = "line" } }, sb)
		grad(l, 0, { { 0, 1 }, { 0.5, 0.2 }, { 1, 1 } })
	end
	hair(140, 0, UDim2.new(0.5, 0, 0, 140))
	win.tabs = mk("ScrollingFrame", {
		Active = true, ScrollBarThickness = 0, BackgroundTransparency = 1, Position = UDim2.fromOffset(6, 154), CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 7, BorderSizePixel = 0, Size = UDim2.new(1, -12, 1, -222),
	}, sb)
	vlist(win.tabs, 3)
	hair(0, 1, UDim2.new(0.5, 0, 1, -60))
	local pc = mk("Frame", { AnchorPoint = Vector2.new(0.5, 1), BackgroundTransparency = 0.25, Position = UDim2.new(0.5, 0, 1, -8), ZIndex = 7, BorderSizePixel = 0, Size = UDim2.new(1, -12, 0, 44), bind = { BackgroundColor3 = "head" } }, sb)
	corner(pc, 8); stroke(pc, "line", 0.72)
	local av = mk("ImageLabel", { ScaleType = Enum.ScaleType.Crop, AnchorPoint = Vector2.new(0, 0.5), Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150", Position = UDim2.new(0, 6, 0.5, 0), ZIndex = 8, BorderSizePixel = 0, Size = UDim2.fromOffset(32, 32), bind = { BackgroundColor3 = "panel" } }, pc)
	corner(av, "full"); stroke(av, "line", 0.45)
	local dn = masktext(pc, {
		Text = LP.DisplayName, Position = UDim2.fromOffset(45, 6), Size = UDim2.new(1, -51, 0, 15),
		TextSize = 13, ZIndex = 8, H = 15, ColorKey = "text",
	})
	local un = masktext(pc, {
		Text = "@" .. LP.Name, Position = UDim2.fromOffset(45, 22), Size = UDim2.new(1, -51, 0, 13),
		TextSize = 11, TextTransparency = 0.3, ZIndex = 8, H = 13, ColorKey = "dim",
	})
	local function cardname()
		dn:set(LP.DisplayName)
		un:set("@" .. LP.Name)
		dn:mask(lib.hidenames)
		un:mask(lib.hidenames)
	end
	namewatchers[#namewatchers + 1] = cardname
	conn(LP:GetPropertyChangedSignal("DisplayName"), cardname)
	conn(LP:GetPropertyChangedSignal("Name"), cardname)
	local namehit = mk("ImageButton", {
		AutoButtonColor = false, Selectable = false, ImageTransparency = 1, BackgroundTransparency = 1,
		Position = UDim2.fromOffset(41, 0), Size = UDim2.new(1, -47, 1, 0), ZIndex = 9,
	}, pc)
	namehit.MouseButton1Click:Connect(function() lib:setnameprivate() end)
	function win:tab(c) local t = maketab(self, c, nil); self.tabsList[#self.tabsList + 1] = t; return t end
	function win:select(tab)
		lib.focus = self
		local path, node = {}, tab
		while node do
			path[node] = true
			if node.kidsn > 0 then node:setopen(true) end
			node = node.parent
		end
		local old = self.cur
		node = old
		while node do
			if node.isopen and not path[node] then node:setopen(false) end
			node = node.parent
		end
		if old == tab then return end
		if old then
			old:paint(false)
			local ocg = old._pg.cg
			tw(ocg, { GroupTransparency = 1 }, FAST)
			task.delay(0.13, function() if self.cur ~= old then old.page.Visible = false end end)
		end
		self.cur = tab
		tab.page.Visible = true
		local cg = tab._pg.cg
		if old then
			cg.GroupTransparency = 1
			cg.Position = UDim2.fromOffset(0, 46)
			tw(cg, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 34) }, TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		end
		tab:paint(true)
	end
	function win:toggle(v)
		if v == nil then v = not self.open end
		if v == self.open then return end
		self.open = v
		lib:chime("click")
		closeto(0)
		if v then
			lib.focus = self
			shell.Visible = true
			tw(root, { GroupTransparency = 0 }); tw(uiscale, { Scale = lib.scale })
			shadowshow(true, FAST)
		else
			closemodal()
			tw(root, { GroupTransparency = 1 }); tw(uiscale, { Scale = 0.96 * lib.scale })
			shadowshow(false)
			task.delay(0.26, function() if not self.open then shell.Visible = false end end)
		end
	end
	function win:render()
		lib:chime("open")
		self.open = true
		shell.Visible = true
		tw(root, { GroupTransparency = 0 }, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		tw(uiscale, { Scale = lib.scale }, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		shadowshow(true, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
	end
	function win:setbind(k)
		if typeof(k) == "EnumItem" then self.bind = k
		elseif type(k) == "string" then
			local ok, e = pcall(function() return Enum.KeyCode[k] end)
			self.bind = ok and e or nil
		else self.bind = nil end
	end
	function win:setlogo(v) lib:_loadlogo(win, v) end
	function win:setsize(s) self.size = s; tw(shell, { Size = s }, TweenInfo.new(0.18)) end
	win:setbind(cfg.bind or "LeftControl")
	self.wins[#self.wins + 1] = win
	self:_autocfg()
	task.defer(function()
		win:render()
		lib:setwatermark(lib.watermark)
		lib._hkrefresh()
	end)
	return win
end
local opener = mk("ImageButton", {
	AutoButtonColor = false, Selectable = false, ImageColor3 = Color3.new(1, 1, 1), ScaleType = Enum.ScaleType.Fit, Active = true,
	BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Image = "", Position = UDim2.new(1, -10, 0.5, 0), Visible = false,
	ZIndex = 950, BorderSizePixel = 0, Size = UDim2.fromOffset(54, 54),
}, gui)
fastdrag(opener, opener, function() lib:togglemenus() end)
function lib:openericon(id) opener.Image = tostring(id) end
function lib:setopener(b) self.opener = b and true or false; opener.Visible = self.opener end
if lib.mobile then lib:setopener(true) end
function lib:onunload(fn)
	if type(fn) == "function" then self.unloadhooks[#self.unloadhooks + 1] = fn end
end
function lib:unload()
	if not self.alive then return end
	self.alive = false
	self:flushconfig()
	self._ready = false
	for _, fn in ipairs(self.unloadhooks) do pcall(fn) end
	self.unloadhooks = {}
	closeto(0)
	for _, c in ipairs(self.conns) do pcall(function() c:Disconnect() end) end
	self.conns = {}
	pcall(function() gui:Destroy() end)
	for k in pairs(self.flags) do self.flags[k] = nil end
	for i = #self.keybinds, 1, -1 do self.keybinds[i] = nil end
	for i = #self.wins, 1, -1 do self.wins[i] = nil end
	for i = #bound, 1, -1 do bound[i] = nil end
	for i = #reapply, 1, -1 do reapply[i] = nil end
	for i = #self._themegrads, 1, -1 do self._themegrads[i] = nil end
	for i = #self._themeswatches, 1, -1 do self._themeswatches[i] = nil end
	for i = #self._themeeditors, 1, -1 do self._themeeditors[i] = nil end
	for k in pairs(hkrows) do hkrows[k] = nil end
	for i = #nlist, 1, -1 do nlist[i] = nil end
	dragfn, dragend, listener = nil, nil, nil
end
return lib
end)
if not ok then
	warn("[ui] LOAD ERROR: " .. tostring(lib))
	return
end
local ok2, err = xpcall(function()
	local win = lib:window({ bind = "LeftControl", title = "yall holy" })
	local t1 = win:tab({ name = "Tab 1", icon = "home", tip = "yall holy" })
	local c1 = t1:section({ name = "Controls", side = "left" })
	c1:button({ name = "Button", icon = "zap", callback = function()
		lib:notify({ title = "Button", text = "clicked", icon = "zap" })
	end })
	c1:slider({ name = "Slider", min = 0, max = 100, default = 50, step = 1, suffix = "%", flag = "slider" })
	c1:slider({ name = "Slider2", min = 0, max = 10, default = 3, step = 1, flag = "slider2" })
	c1:combo({ name = "Dropdown", list = { "Option 1", "Option 2", "Option 3" }, default = "Option 1", flag = "dropdown" })
	c1:combo({ name = "Dropdown2", list = { "Option 1", "Option 2", "Option 3" }, multi = true, flag = "dropdown2" })
	c1:color({ name = "Colour", default = Color3.fromRGB(128, 128, 255), flag = "outline" })
	local heavy = c1:toggle({
		name = "Checkbox", default = false, flag = "heavy",
		callback = function(v)
			if v then
				lib:confirm({
					title = "heavy feature", text = "this can cause lags / freezes. enable it?",
					confirm = "enable", cancel = "cancel",
					callback = function()
						local e = lib.flags.heavy
						if e and e.set then e:set(true, true) end
						lib:notify({ title = "heavy feature", text = "enabled — watch your fps", icon = "zap", life = 4 })
					end,
				})
				return false
			end
		end,
	})
	local cb1 = c1:checkbox({ name = "Checkbox1", options = true, flag = "checkbox1" })
	cb1.options:checkbox({ name = "Checkbox4" })
	cb1.options:slider({ name = "Slider4", min = 0, max = 10, default = 7, step = 1, flag = "slider4" })
	c1:button({
		name = "Danger Action", icon = "power",
		callback = function()
			lib:confirm({
				title = "danger action", text = "run the risky action? it may lag or crash the client.",
				confirm = "run", cancel = "cancel",
				callback = function()
					lib:notify({ title = "danger action", text = "executed", icon = "check", life = 4 })
				end,
			})
		end,
	})
	local c2 = t1:section({ name = "Inputs", side = "right" })
	c2:input({ name = "Text Input", placeholder = "type something...", flag = "textinput" })
	local in2 = c2:input({ name = "Text Input 2", placeholder = "type here, then press below...", flag = "textinput2" })
	c2:button({ name = "Run Input 2", callback = function()
		lib:notify({ title = "input 2", text = in2:get() })
	end })
	c2:inputbutton({ name = "Text Input 3", placeholder = "type here...", button = "Run", buttonwidth = 32, flag = "textinput3", callback = function(t)
		lib:notify({ title = "input 3", text = t })
	end })
	c2:input({ name = "Text Input 4", placeholder = "click clears this...", clearonfocus = true, flag = "textinput4" })
	local tg = c2:toggle({ name = "Toggle Option", default = true, options = true, flag = "toggle" })
	tg.options:combo({ name = "Dropdown1", list = { "Basic", "Advanced", "Custom" }, default = "Basic" })
	tg.options:checkbox({ name = "Checkbox2" })
	tg.options:checkbox({ name = "Checkbox3" })
	tg.options:slider({ name = "Slider3", min = 0, max = 10, default = 5, step = 1, flag = "strength" })
	do
		local tab = win:tab({ name = "Tab 2", icon = "eye", tip = "yall holy" })
		tab:sub({ name = "Sub-tab 1", icon = "eye" })
	end
	local tCfg = win:tab({ name = "config", icon = "settings", tip = "menu settings" })
	local Players = game:GetService("Players")
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")
	local LP = Players.LocalPlayer
	local function notify(title, text, icon, life)
		lib:notify({ title = title, text = text or "", icon = icon or "info", life = life or 4 })
	end
	local function rejoinServer()
		pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end)
	end
	local function serverHop()
		pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
	end
	local function joinSmallServer()
		task.spawn(function()
			local ok, servers = pcall(function()
				local reqFn = (request or http_request or (syn and syn.request) or (http and http.request))
				local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?limit=100"
				local body
				if reqFn then
					local r = reqFn({ Url = url, Method = "GET" })
					body = r.Body or r.body
				else
					body = HttpService:GetAsync(url)
				end
				return HttpService:JSONDecode(body).data
			end)
			if not ok or type(servers) ~= "table" then
				notify("Server", "could not fetch server list", "x")
				return
			end
			local best = nil
			for _, s in ipairs(servers) do
				if tostring(s.id or "") ~= tostring(game.JobId) and (tonumber(s.playing) or 0) < (tonumber(s.maxPlayers) or 50) then
					if not best or (tonumber(s.playing) or 0) < (tonumber(best.playing) or 0) then best = s end
				end
			end
			if best then
				pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, LP) end)
			else
				notify("Server", "no smaller server found", "info")
			end
		end)
	end
	local function copyJobId()
		local ok = pcall(function() setclipboard(tostring(game.JobId)) end)
		notify("Server", ok and ("copied: " .. tostring(game.JobId)) or "setclipboard unavailable", ok and "check" or "x", 6)
	end
	local function joinJobId(raw)
		raw = tostring(raw or "")
		local id = raw:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
		if not id then
			notify("Server", "paste the full Job ID (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)", "info", 6)
			return
		end
		if id == game.JobId then
			notify("Server", "you are already in this server", "info", 6)
			return
		end
		local place = tonumber(raw:match("placeId=(%d+)")) or game.PlaceId
		local conn
		conn = TeleportService.TeleportInitFailed:Connect(function(_, result, msg)
			if conn then conn:Disconnect() conn = nil end
			notify("Teleport failed", tostring(msg ~= "" and msg or result), "x", 8)
		end)
		task.delay(20, function()
			if conn then conn:Disconnect() conn = nil end
		end)
		notify("Server", "joining " .. id, "activity", 6)
		local ok, err = pcall(function() TeleportService:TeleportToPlaceInstance(place, id, LP) end)
		if not ok then
			if conn then conn:Disconnect() conn = nil end
			notify("Teleport failed", tostring(err), "x", 8)
		end
	end

	local ms = tCfg:section({ name = "Menu Settings", side = "right", gap = 12 })
	ms:keybind({
		name = "Menu Key", default = Enum.KeyCode.LeftControl, hud = false,
		callback = function(k) win:setbind(k) end,
	})
	ms:themes()

	ms:button({
		name = "Unload", icon = "power",
		callback = function()
			lib:confirm({
				title = "unload", text = "remove the menu and stop all features?",
				confirm = "unload", cancel = "cancel",
				callback = function() lib:unload() end,
			})
		end,
	})

	local soc = tCfg:section({ name = "Support / Socials", side = "right", gap = 2 })
	local function socialLink(title, link)
		local opened = (typeof(open_url) == "function" and pcall(open_url, link)) or false
		local copied = pcall(function() setclipboard(link) end)
		notify(title, opened and ("opening " .. link) or copied and ("copied: " .. link) or link,
			(opened or copied) and "check" or "x", 6)
	end
	soc:button({
		name = "Telegram", icon = "send",
		callback = function() socialLink("Telegram", "https://t.me/alawox") end,
	})
	soc:button({
		name = "Discord", icon = "users",
		callback = function() socialLink("Discord", "https://discord.gg/zGf3rJG27k") end,
	})

	tCfg:configs({ name = "Configs", side = "left" })
	local ssr = tCfg:section({ name = "Server", side = "left" })
	ssr:button({ name = "Rejoin", icon = "refresh-cw", callback = rejoinServer })
	ssr:button({ name = "Server hop", icon = "globe", callback = serverHop })
	ssr:button({ name = "Join small server", icon = "users", callback = joinSmallServer })
	ssr:button({ name = "Copy Job ID", icon = "copy", callback = copyJobId })
	local jobin = ssr:input({ name = "", placeholder = "enter job id..." })
	ssr:button({
		name = "Join by Job ID", icon = "activity",
		callback = function() joinJobId(jobin:get()) end,
	})
	lib:notify({ title = "yall holy", text = "LeftControl - open / close", icon = "check", life = 5 })
end, debug.traceback)
if not ok2 then warn("[ui] BUILD ERROR: " .. tostring(err)) end

