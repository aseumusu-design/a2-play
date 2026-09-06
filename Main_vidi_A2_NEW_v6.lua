-- =====================================================
-- UI LIBRARY A2 NEW (embedded, no key system)
-- =====================================================
getgenv().MODERNV2_AUTO_WINDOW = false

local __KysHub_A2_Library = (function()
-- [ModernV2] | [Modified By Team Luaplat] | [Version : 0.2.5 - Stable Bubble Glow]
-- Intro removed by request.

-- Standalone-safe bootstrap:
-- Some executors expose getgenv but not getfenv, and some do not expose
-- LPH_NO_VIRTUALIZE at all. Neither should prevent the UI from loading.
local __ModernV2Env;
if type(getgenv) == "function" then
	__ModernV2Env = getgenv();
elseif type(getfenv) == "function" then
	__ModernV2Env = getfenv(0);
else
	__ModernV2Env = _G;
end;

local LPH_NO_VIRTUALIZE = (type(__ModernV2Env.LPH_NO_VIRTUALIZE) == "function" and __ModernV2Env.LPH_NO_VIRTUALIZE) or function(f)
	return f;
end;
__ModernV2Env.LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE;

getgenv = getgenv or function()
	return __ModernV2Env;
end;
cloneref = cloneref or function(i) return i end;
gethui = gethui or get_hidden_gui;
getcustomasset = getcustomasset or getsynasset;

local LOAD_ENV = LPH_NO_VIRTUALIZE(function()
	if game:GetService('RunService'):IsStudio() then
		local BaseWorkspace = game:GetService("ReplicatedFirst"):FindFirstChild('PRI_WORKSPACE') or Instance.new('Folder',game:GetService("ReplicatedFirst"));

		BaseWorkspace.Name = 'PRI\0.'..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)));

		local __get_path_c = function(path)
			return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
		end;

		local __get_path = function(path)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				block = block[v];
			end;

			return block;
		end;

		getgenv().readfile = function(path)
			local path : StringValue = __get_path(path);

			return path.Value;
		end;

		getgenv().isfile = function(path)
			local success , message = pcall(function()
				return __get_path(path);
			end);

			if success and not message:IsA("Folder") then
				return true;
			end;

			return false;
		end;

		getgenv().isfolder = function(path)
			local success , message = pcall(function()
				return __get_path(path);
			end);

			if success and message:IsA("Folder") then
				return true;
			end;

			return false;
		end;

		getgenv().writefile = function(path,content)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if not item then
					local c = Instance.new('StringValue',block);

					c.Name = tostring(v);
					c.Value = content;
				else
					if item:IsA('StringValue') and tostring(item) == v then
						item.Name = tostring(v);
						item.Value = content;
					end;

					block = item;
				end;
			end;
		end;

		getgenv().listfiles = function(path)
			local fold = __get_path(path);
			local pa = {};

			for i,v in next , fold:GetChildren() do
				if v:IsA('StringValue') then
					table.insert(pa,path..'/'..tostring(v));
				end;
			end;

			return pa;
		end;

		getgenv().makefolder = function(path)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if not item then
					local c = Instance.new('Folder',block);

					c.Name = tostring(v);
				else
					block = item;
				end;
			end;
		end;

		getgenv().delfile = function(path)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if item and item:IsA('StringValue') then
					item:Destroy();
				else
					block = item;
				end;
			end;
		end;
	end;
end)

LOAD_ENV();

writefile = writefile or getgenv().writefile;
makefolder = makefolder or getgenv().makefolder;
readfile = readfile or getgenv().readfile;
delfolder = delfolder or getgenv().delfolder;
delfile = delfile or getgenv().delfile;
listfiles = listfiles or getgenv().listfiles;
isfolder = isfolder or getgenv().isfolder;
isfile = isfile or getgenv().isfile;

-- File APIs are optional in a few lightweight executors. The UI should
-- still load; config saving simply becomes a no-op in that case.
writefile = writefile or function() end;
makefolder = makefolder or function() end;
readfile = readfile or function() return nil end;
delfolder = delfolder or function() end;
delfile = delfile or function() end;
listfiles = listfiles or function() return {} end;
isfolder = isfolder or function() return false end;
isfile = isfile or function() return false end;

local ModernV2 = {};

ModernV2.BuiltInRegular = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Regular,Enum.FontStyle.Normal);
ModernV2.BuiltInBold = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Bold,Enum.FontStyle.Normal);
ModernV2.GlobalSignals = {};
ModernV2.UnloadEnabled = false;

local cloneref: cloneref = cloneref or function(f) return f end;
local TweenService: TweenService = cloneref(game:GetService('TweenService'));
local UserInputService: UserInputService = cloneref(game:GetService('UserInputService'));
local TextService: TextService = cloneref(game:GetService('TextService'));
local RunService: RunService = cloneref(game:GetService('RunService'));
local Players: Players = cloneref(game:GetService('Players'));
local HttpService: HttpService = cloneref(game:GetService('HttpService'));
local LocalPlayer: Player = Players.LocalPlayer or Players.PlayerAdded:Wait();
local CoreGui: PlayerGui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or cloneref(game:FindFirstChild('CoreGui')) or cloneref(LocalPlayer.PlayerGui);
local Mouse: Mouse = LocalPlayer:GetMouse();
local CurrentCamera: Camera = cloneref(workspace.CurrentCamera);
local ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end;
local GlobalWindow = Instance.new('ScreenGui');
local ManualTween = TweenInfo.new(0.1);
local SlowyTween = TweenInfo.new(0.175);
local FastTween = TweenInfo.new(0.05);
local VSlowTween = TweenInfo.new(0.5,Enum.EasingStyle.Quint);
local Encryption = {};

ModernV2.UserProfile = Players:GetUserThumbnailAsync(LocalPlayer.UserId , Enum.ThumbnailType.HeadShot , Enum.ThumbnailSize.Size150x150)
ModernV2.RandomString = LPH_NO_VIRTUALIZE(function()
	return string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4));
end);

ProtectGui(GlobalWindow);

GlobalWindow.Name = ModernV2.RandomString();
GlobalWindow.IgnoreGuiInset = true;
GlobalWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global;
GlobalWindow.ResetOnSpawn = false;
GlobalWindow.Parent = CoreGui;

ModernV2.Scales = {
	Small = UDim2.fromOffset(540,380),
	Compact = UDim2.fromOffset(600,380),
	Mobile = UDim2.fromOffset(640,385),
	Default = UDim2.fromOffset(640 , 480),
	Large = UDim2.fromOffset(800 , 600)
};

ModernV2.IconColor = Color3.fromRGB(255, 255, 255);
ModernV2.ScreenGui = GlobalWindow;
ModernV2.Flags = {};
ModernV2.PendingFlagValues = {};
ModernV2.AccentColor = Color3.fromRGB(78, 127, 252);
ModernV2.MainColor = Color3.fromRGB(8, 8, 13);
ModernV2.RegisiteryColor = {};
ModernV2.NameRegisitry = {};
ModernV2.SectionOwners = {};
ModernV2.IsMosueOverOtherFrame = false;
ModernV2.TextGradientEnabled = true;
ModernV2.TextGradientAnimationTime = 0;
ModernV2.TextGradientAccumulator = 0;
ModernV2.TextGradientLabels = {};
ModernV2.TextGradientObjects = {};
ModernV2.GlobalLogo = "rbxassetid://126710436488213";
ModernV2.ImageColorMapping = "rbxassetid://4155801252";
ModernV2.IconBase = "https://raw.githubusercontent.com/nhfudzfsrzggt/brigida/refs/heads/main/";
ModernV2.Icons = {};
ModernV2.IconScale = 0.82;
ModernV2.Font = nil;
ModernV2.FontFace = nil;
ModernV2.IconAliases = {
	["lucide:table-of-contents"] = "list-bulleted",
	["lucide:toggle-right"] = "two-switches-horizontal",
	["lucide:mouse"] = "mouse-button-left",
	["lucide:chevrons-left-right-ellipsis"] = "dual-arrows-horizontal",
	["lucide:list-collapse"] = "list-bulleted",
	["lucide:palette"] = "paint-brush",
	["lucide:sliders-horizontal"] = "three-sliders-horizontal",
	["lucide:keyboard"] = "key",
	["lucide:layout-grid"] = "grid",
	["lucide:bell"] = "bell",
	["lucide:message-circle"] = "speech-bubble-round",
	["lucide:circle-info"] = "circle-i",
	["lucide:check"] = "check",
	["lucide:circle-alert"] = "triangle-exclamation",
	["lucide:house"] = "house",
};
ModernV2.IconLibraryLoaded = false;
ModernV2.IconLibraryLoading = false;
ModernV2.IconSystem = nil;

function ModernV2:NormalizeIconId(iconId)
	if not iconId or iconId == "" then
		return "";
	end;

	iconId = tostring(iconId);

	if string.match(iconId, "^%d+$") then
		return "rbxassetid://" .. iconId;
	end;

	if string.find(iconId, "rbxassetid://", 1, true)
	or string.find(iconId, "rbxasset://", 1, true)
	or string.match(iconId, "^https?://") then
		return iconId;
	end;

	return iconId;
end;

-- ── Icon System ──────────────────────────────────────────────────
-- Supports:
--   "123456"          -> rbxassetid://123456
--   "lucide:search"   -> icon id from external lucide library
--   "solar:user"      -> icon id from external solar library
--   "https://..."     -> direct image URL
function ModernV2:LoadIconLibrary()
	if ModernV2.IconLibraryLoaded then
		return ModernV2.Icons;
	end;

	if ModernV2.IconLibraryLoading then
		repeat task.wait() until not ModernV2.IconLibraryLoading;
		return ModernV2.Icons;
	end;

	ModernV2.IconLibraryLoading = true;

	local function Load(path)
		local success, result = pcall(function()
			return loadstring(game:HttpGet(ModernV2.IconBase .. path))();
		end);

		if success and typeof(result) == "table" then
			return result;
		end;

		return {};
	end;

	local defaultIcons = Load("src/elements/icon/basic.lua");
	local lucideIcons = Load("src/elements/icon/lucide.lua");
	local solarIcons = Load("src/elements/icon/solar.lua");

	for name, id in pairs(defaultIcons) do
		ModernV2.Icons[name] = ModernV2:NormalizeIconId(id);
	end;

	for name, id in pairs(lucideIcons) do
		ModernV2.Icons["lucide:" .. name] = ModernV2:NormalizeIconId(id);
	end;

	for name, id in pairs(solarIcons) do
		ModernV2.Icons["solar:" .. name] = ModernV2:NormalizeIconId(id);
	end;

	ModernV2.IconLibraryLoaded = true;
	ModernV2.IconLibraryLoading = false;
	ModernV2.IconSystem = {
		Icons = ModernV2.Icons,
		getIconId = function(iconName)
			return ModernV2:GetIconId(iconName);
		end,
	};

	return ModernV2.Icons;
end;

function ModernV2:GetIconId(iconName)
	if not iconName or iconName == "" then
		return "";
	end;

	iconName = tostring(iconName);

	local DirectIcon = ModernV2:NormalizeIconId(iconName);
	if DirectIcon ~= iconName
	or string.find(DirectIcon, "rbxassetid://", 1, true)
	or string.find(DirectIcon, "rbxasset://", 1, true)
	or string.match(DirectIcon, "^https?://") then
		return DirectIcon;
	end;

	if not ModernV2.IconLibraryLoaded then
		ModernV2:LoadIconLibrary();
	end;

	if ModernV2.Icons[iconName] then
		return ModernV2:NormalizeIconId(ModernV2.Icons[iconName]);
	end;

	return "";
end;

function ModernV2:IsWebmIcon(iconName)
	if not iconName or iconName == "" then
		return false;
	end;

	iconName = string.lower(tostring(iconName));

	return string.sub(iconName, 1, 5) == "webm:"
		or string.match(iconName, "%.webm$") ~= nil
		or string.match(iconName, "%.webm%?") ~= nil
		or string.match(iconName, "%.webm#") ~= nil;
end;

function ModernV2:NormalizeVideoIcon(iconName)
	iconName = tostring(iconName or "");

	if string.sub(string.lower(iconName), 1, 5) == "webm:" then
		iconName = string.sub(iconName, 6);
	end;

	return ModernV2:NormalizeIconId(iconName);
end;

function ModernV2:ClearIconVideo(IconObject)
	local VideoIcon = IconObject and IconObject:FindFirstChild("ModernIconVideo");

	if VideoIcon then
		pcall(function()
			VideoIcon:Pause();
		end);

		VideoIcon.Visible = false;
		VideoIcon.Video = "";
	end;
end;

function ModernV2:ApplyIconVideo(IconObject, IconSource)
	if not IconObject then
		return nil;
	end;

	local VideoIcon = IconObject:FindFirstChild("ModernIconVideo");

	if not VideoIcon then
		VideoIcon = Instance.new("VideoFrame");
		VideoIcon.Name = "ModernIconVideo";
		VideoIcon.Parent = IconObject;
		VideoIcon.AnchorPoint = Vector2.new(0.5, 0.5);
		VideoIcon.BackgroundTransparency = 1;
		VideoIcon.BorderSizePixel = 0;
		VideoIcon.Position = UDim2.fromScale(0.5, 0.5);
		VideoIcon.Size = UDim2.fromScale(1, 1);
		VideoIcon.ZIndex = IconObject.ZIndex + 1;
		VideoIcon.Volume = ModernV2.IconVideoVolume or 0;
		VideoIcon.Visible = true;

		ModernV2:AddSignal(VideoIcon.Ended:Connect(function()
			VideoIcon.TimePosition = 0;
			VideoIcon:Play();
		end));
	end;

	if not IconObject:GetAttribute("ModernIconVideoBound") then
		IconObject:SetAttribute("ModernIconVideoBound", true);

		ModernV2:AddSignal(IconObject:GetPropertyChangedSignal("ZIndex"):Connect(function()
			local ChildVideo = IconObject:FindFirstChild("ModernIconVideo");
			if ChildVideo then
				ChildVideo.ZIndex = IconObject.ZIndex + 1;
			end;
		end));

		if IconObject:IsA("ImageLabel") or IconObject:IsA("ImageButton") then
			ModernV2:AddSignal(IconObject:GetPropertyChangedSignal("ImageTransparency"):Connect(function()
				local ChildVideo = IconObject:FindFirstChild("ModernIconVideo");
				if ChildVideo then
					ChildVideo.Visible = IconObject.ImageTransparency < 0.99;
				end;
			end));
		end;
	end;

	VideoIcon.Video = ModernV2:NormalizeVideoIcon(IconSource);
	VideoIcon.Volume = ModernV2.IconVideoVolume or 0;
	VideoIcon.Visible = true;
	VideoIcon:SetAttribute("_isWebm", true);

	pcall(function()
		VideoIcon:Play();
	end);

	return VideoIcon;
end;

ModernV2.IconSystem = {
	Icons = ModernV2.Icons,
	getIconId = function(iconName)
		return ModernV2:GetIconId(iconName);
	end,
};

task.spawn(function()
	pcall(function()
		ModernV2:LoadIconLibrary();
	end);
end);

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                   THEME SYSTEM (AddTheme)                       │
-- └─────────────────────────────────────────────────────────────────┘

ModernV2.Themes = {};
ModernV2.ThemeCallbacks = {};   -- list of callbacks to update live UI

-- Register a theme update listener (internal use)
function ModernV2:OnThemeChanged(fn)
	table.insert(ModernV2.ThemeCallbacks, fn);
end;

-- Apply all registered theme callbacks
local function _ApplyTheme(theme)
	ModernV2.AccentColor  = theme.Accent      or ModernV2.AccentColor;
	ModernV2.MainColor    = theme.Background  or ModernV2.MainColor;
	ModernV2.IconColor    = theme.Icon        or ModernV2.IconColor;

	-- fire every live-update listener
	for _, fn in next, ModernV2.ThemeCallbacks do
		pcall(fn, theme);
	end;

	if ModernV2.SetTextGradientEnabled then
		ModernV2:SetTextGradientEnabled(ModernV2.TextGradientEnabled);
	end;
end;

--[[
	ModernV2:AddTheme({
		Name        = "Lumi Sakura",
		Accent      = Color3.fromRGB(255,120,180),
		Background  = Color3.fromRGB(35,20,30),
		Surface     = Color3.fromRGB(60,30,50),
		Outline     = Color3.fromRGB(255,160,200),
		Text        = Color3.fromRGB(255,220,235),
		Placeholder = Color3.fromRGB(200,140,170),
		Button      = Color3.fromRGB(255,140,190),
		Icon        = Color3.fromRGB(255,180,210),
	})
]]
function ModernV2:AddTheme(Config)
	Config = Config or {};
	Config.Name = Config.Name or "Custom Theme";

	-- defaults fall back to current values
	local theme = {
		Name        = Config.Name,
		Accent      = Config.Accent      or ModernV2.AccentColor,
		Background  = Config.Background  or ModernV2.MainColor,
		Surface     = Config.Surface     or Color3.fromRGB(20,22,27),
		Outline     = Config.Outline     or Color3.fromRGB(45,48,58),
		Text        = Config.Text        or Color3.fromRGB(255,255,255),
		Placeholder = Config.Placeholder or Color3.fromRGB(140,140,155),
		Button      = Config.Button      or ModernV2.AccentColor,
		Icon        = Config.Icon        or ModernV2.IconColor,
	};

	table.insert(ModernV2.Themes, theme);
	_ApplyTheme(theme);

	return theme;
end;

-- ┌─────────────────────────────────────────────────────────────────┐
-- │               MENU ICON (CreateMenuIcon)                        │
-- │  • Always center-left of screen                                 │
-- │  • Round-square shape with UICorner                             │
-- │  • Auto-scales with UI scale                                    │
-- │  • Supports rbxassetid, Lucide-style icon name, or image URL    │
-- │  • Cool show/hide animations                                    │
-- │  • Color / BG / Stroke all customisable                         │
-- │  • Cannot be dragged off screen (optional drag entirely)        │
-- └─────────────────────────────────────────────────────────────────┘

function ModernV2:CreateMenuIcon(Config)
	Config = Config or {};

	-- ── Defaults ──────────────────────────────────────────────────
	local iconSize       = Config.Size         or 48;
	local iconImage      = Config.Image        or "";          -- rbxassetid:// OR lucide name OR URL
	local iconScale      = tonumber(Config.IconScale or Config.Scale) or 1;
	local iconColor      = Config.IconColor    or Color3.fromRGB(255,255,255);
	local bgColor        = Config.BGColor      or Color3.fromRGB(20,22,27);
	local strokeColor    = Config.StrokeColor  or ModernV2.AccentColor;
	local strokeThick    = Config.StrokeThick  or 1.5;
	local draggable      = (Config.Draggable ~= false);       -- default true, but clamped
	local cornerRadius   = UDim.new(0, math.floor(iconSize * 0.28)); -- ~28 % → round-square

	-- ── Container ─────────────────────────────────────────────────
	local IconRoot = Instance.new("Frame");
	IconRoot.Name             = ModernV2.RandomString();
	IconRoot.Parent           = ModernV2.ScreenGui;
	-- center-left: X = 15px from left, Y = 50 % of screen
	IconRoot.AnchorPoint      = Vector2.new(0, 0.5);
	IconRoot.BackgroundColor3 = bgColor;
	IconRoot.BackgroundTransparency = 1;   -- start invisible
	IconRoot.BorderSizePixel  = 0;
	IconRoot.Size             = UDim2.fromOffset(iconSize, iconSize);
	IconRoot.Position         = UDim2.new(0, 15, 0.5, 0);
	IconRoot.ZIndex           = 20;
	IconRoot.ClipsDescendants = false;

	local UICornerIcon = Instance.new("UICorner");
	UICornerIcon.CornerRadius = cornerRadius;
	UICornerIcon.Parent       = IconRoot;

	-- Stroke
	local UIStrokeIcon = Instance.new("UIStroke");
	UIStrokeIcon.Color       = strokeColor;
	UIStrokeIcon.Thickness   = strokeThick;
	UIStrokeIcon.Transparency = 1;
	UIStrokeIcon.Parent      = IconRoot;

	-- A stable outer blue ring. Only the black halo pulses, so the blue
	-- outline stays solid instead of blinking with the shadow animation.
	local UIStrokeGlow = Instance.new("UIStroke");
	UIStrokeGlow.Color       = strokeColor;
	UIStrokeGlow.Thickness   = math.max(strokeThick * 1.5, 2);
	UIStrokeGlow.Transparency = 1;
	UIStrokeGlow.Parent      = IconRoot;

	-- ── Icon display (TextLabel for built-in / ImageLabel for image) ──
	-- We keep both and show the relevant one.
	local IconLabel = Instance.new("TextLabel");
	IconLabel.Name                = ModernV2.RandomString();
	IconLabel.Parent              = IconRoot;
	IconLabel.AnchorPoint         = Vector2.new(0.5, 0.5);
	IconLabel.BackgroundTransparency = 1;
	IconLabel.BorderSizePixel     = 0;
	IconLabel.Position            = UDim2.fromScale(0.5, 0.5);
	IconLabel.Size                = UDim2.fromScale(0.65, 0.65);
	IconLabel.ZIndex              = 21;
	IconLabel.FontFace            = ModernV2.BuiltInBold;
	IconLabel.Text                = "";
	IconLabel.TextColor3          = iconColor;
	IconLabel.TextScaled          = true;
	IconLabel.TextTransparency    = 1;
	IconLabel.TextWrapped         = true;

	local IconImage = Instance.new("ImageLabel");
	IconImage.Name                = ModernV2.RandomString();
	IconImage.Parent              = IconRoot;
	IconImage.AnchorPoint         = Vector2.new(0.5, 0.5);
	IconImage.BackgroundTransparency = 1;
	IconImage.BorderSizePixel     = 0;
	IconImage.Position            = UDim2.fromScale(0.5, 0.5);
	IconImage.Size                = UDim2.fromScale(0.65, 0.65);
	IconImage.ZIndex              = 21;
	IconImage.ImageColor3         = iconColor;
	IconImage.ImageTransparency   = 1;
	IconImage.ScaleType           = Enum.ScaleType.Fit;
	IconImage:SetAttribute("ModernIconScaleValue", iconScale);

	local UICornerImg = Instance.new("UICorner");
	UICornerImg.CornerRadius = UDim.new(0.15, 0);
	UICornerImg.Parent       = IconImage;

	-- Separate halo layer so the black pulse never covers or flickers
	-- through the solid blue ring around the bubble.
	local IconHalo = Instance.new("Frame");
	IconHalo.Name = ModernV2.RandomString();
	IconHalo.Parent = IconRoot;
	IconHalo.AnchorPoint = Vector2.new(0.5, 0.5);
	IconHalo.BackgroundTransparency = 1;
	IconHalo.BorderSizePixel = 0;
	IconHalo.Position = UDim2.fromScale(0.5, 0.5);
	IconHalo.Size = UDim2.new(1, 10, 1, 10);
	IconHalo.ZIndex = 19;
	IconHalo.ClipsDescendants = false;

	local IconHaloCorner = Instance.new("UICorner");
	IconHaloCorner.CornerRadius = UDim.new(0, math.floor(iconSize * 0.28) + 5);
	IconHaloCorner.Parent = IconHalo;

	-- Strong blue ring with a dark, slowly pulsing halo behind the bubble.
	local IconShadow = ModernV2:CreateShadow(
		IconHalo,
		true,
		Color3.fromRGB(0, 0, 0),
		0.78,
		true,
		0.8
	);

	-- ── Internal state ────────────────────────────────────────────
	local MenuIconLib = {
		Root         = IconRoot,
		Visible      = false,
		_size        = iconSize,
		_draggable   = draggable,
	};

	-- ── Helpers ───────────────────────────────────────────────────
	local function _applyIcon(src)
		if not src or src == "" then
			IconLabel.Text           = "";
			IconImage.Image          = "";
			IconLabel.Visible        = false;
			IconImage.Visible        = true;
			return;
		end;

		ModernV2:SetIconMode(IconImage, src);
		IconImage.Visible = true;
		IconLabel.Visible = false;
	end;

	_applyIcon(iconImage);

	-- ── Show / Hide with smooth animations ───────────────────────
	local function _setIconVisible(val)
		MenuIconLib.Visible = val;
		local IconFallbackText = IconImage:FindFirstChild("ModernIconFallbackText");

		if val then
			-- Bounce-in from left
			IconRoot.Position = UDim2.new(0, -iconSize, 0.5, 0);
			ModernV2.PlayAnimate(IconRoot, VSlowTween, {
				BackgroundTransparency = 0,
				Position = UDim2.new(0, 15, 0.5, 0),
			});
			ModernV2.PlayAnimate(UIStrokeIcon, SlowyTween, {
				Transparency = 0.00,
			});
			ModernV2.PlayAnimate(UIStrokeGlow, SlowyTween, {
				Transparency = 0.48,
			});
			ModernV2.PlayAnimate(IconLabel, VSlowTween, {
				TextTransparency = 0,
			});
			ModernV2.PlayAnimate(IconImage, VSlowTween, {
				ImageTransparency = 0,
			});
			if IconFallbackText then
				ModernV2.PlayAnimate(IconFallbackText, VSlowTween, {
					TextTransparency = 0,
				});
			end;
			IconShadow:Render(true);
		else
			-- Slide out to the left
			ModernV2.PlayAnimate(IconRoot, VSlowTween, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, -iconSize - 10, 0.5, 0),
			});
			ModernV2.PlayAnimate(UIStrokeIcon, SlowyTween, {
				Transparency = 1,
			});
			ModernV2.PlayAnimate(UIStrokeGlow, SlowyTween, {
				Transparency = 1,
			});
			ModernV2.PlayAnimate(IconLabel, SlowyTween, {
				TextTransparency = 1,
			});
			ModernV2.PlayAnimate(IconImage, SlowyTween, {
				ImageTransparency = 1,
			});
			if IconFallbackText then
				ModernV2.PlayAnimate(IconFallbackText, SlowyTween, {
					TextTransparency = 1,
				});
			end;
			IconShadow:Render(false);
		end;
	end;

	-- ── Public API ────────────────────────────────────────────────

	--- Show or hide the icon
	function MenuIconLib:SetVisible(val)
		_setIconVisible(val);
	end;

	--- Change the icon image (rbxassetid, URL, or built-in name)
	function MenuIconLib:SetIcon(src)
		iconImage = src;
		_applyIcon(src);
	end;

	--- Change icon visual scale for padded image assets
	function MenuIconLib:SetIconScale(scale)
		iconScale = tonumber(scale) or iconScale;
		IconImage:SetAttribute("ModernIconScaleValue", iconScale);

		local IconScaleObject = IconImage:FindFirstChild("ModernIconScale");
		if IconScaleObject then
			IconScaleObject.Scale = iconScale;
		end;

		return MenuIconLib;
	end;

	--- Change icon tint colour
	function MenuIconLib:SetIconColor(c3)
		iconColor = c3;
		IconLabel.TextColor3  = c3;
		IconImage.ImageColor3 = c3;
	end;

	--- Change background colour
	function MenuIconLib:SetBGColor(c3)
		bgColor = c3;
		IconRoot.BackgroundColor3 = c3;
	end;

	--- Change stroke colour
	function MenuIconLib:SetStrokeColor(c3)
		strokeColor = c3;
		UIStrokeIcon.Color = c3;
		UIStrokeGlow.Color = c3;
	end;

	--- Change stroke thickness
	function MenuIconLib:SetStrokeThick(t)
		UIStrokeIcon.Thickness = t;
		UIStrokeGlow.Thickness = math.max(t * 1.5, 2);
	end;

	--- Resize the icon (also adjusts corner radius)
	function MenuIconLib:SetSize(sz)
		MenuIconLib._size = sz;
		IconRoot.Size = UDim2.fromOffset(sz, sz);
		UICornerIcon.CornerRadius = UDim.new(0, math.floor(sz * 0.28));
	end;

	--- Enable / disable drag
	function MenuIconLib:SetDraggable(enabled)
		MenuIconLib._draggable = enabled;
	end;

	--- React to window toggle (pass true = UI is now visible, false = hidden)
	function MenuIconLib:OnWindowToggle(windowVisible)
		-- pulse-scale animation when toggling
		local sz = MenuIconLib._size;
		if windowVisible then
			-- shrink slightly
			ModernV2.PlayAnimate(IconRoot, TweenInfo.new(0.1), {
				Size = UDim2.fromOffset(sz * 0.85, sz * 0.85),
			});
			task.delay(0.12, function()
				ModernV2.PlayAnimate(IconRoot, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = UDim2.fromOffset(sz, sz),
				});
			end);
		else
			-- expand slightly
			ModernV2.PlayAnimate(IconRoot, TweenInfo.new(0.1), {
				Size = UDim2.fromOffset(sz * 1.15, sz * 1.15),
			});
			task.delay(0.12, function()
				ModernV2.PlayAnimate(IconRoot, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = UDim2.fromOffset(sz, sz),
				});
			end);
		end;
	end;

	-- ── Optional drag (clamped to screen, never off edge) ─────────
	do
		local dragging = false;
		local dragStart, startPos;

		local function clampPosition(pos)
			local screenSize = ModernV2.ScreenGui.AbsoluteSize;
			local sz2 = MenuIconLib._size;
			local nx = math.clamp(pos.X.Offset, 0, screenSize.X - sz2);
			local ny = math.clamp(pos.Y.Scale * screenSize.Y + pos.Y.Offset, sz2/2, screenSize.Y - sz2/2);
			return UDim2.new(0, nx, 0, ny);
		end;

			-- Tap = toggle UI  |  Drag = move icon (if draggable)
			-- Uses movement threshold to distinguish a click from a drag.
			local dragging   = false;
			local dragStart, startPos;
			local DRAG_THRESHOLD = 6; -- pixels of movement before it counts as a drag

			ModernV2:AddSignal(IconRoot.InputBegan:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch then
					return;
				end;

				dragging  = false;
				dragStart = input.Position;
				startPos  = IconRoot.Position;

				local moved = false;
				local moveConn, endConn;

				moveConn = UserInputService.InputChanged:Connect(function(mv)
					if mv.UserInputType ~= Enum.UserInputType.MouseMovement
					and mv.UserInputType ~= Enum.UserInputType.Touch then return; end;

					local delta = mv.Position - dragStart;
					if delta.Magnitude > DRAG_THRESHOLD and MenuIconLib._draggable then
						moved    = true;
						dragging = true;
						local raw = UDim2.new(
							startPos.X.Scale, startPos.X.Offset + delta.X,
							startPos.Y.Scale, startPos.Y.Offset + delta.Y
						);
						IconRoot.Position = clampPosition(raw);
					end;
				end);

				endConn = input.Changed:Connect(function()
					if input.UserInputState ~= Enum.UserInputState.End then return; end;
					moveConn:Disconnect();
					endConn:Disconnect();
					dragging = false;

					-- Pure tap (no drag movement) → fire the real-time keybind
					if not moved then
						ModernV2:FireKeybind();
					end;
				end);
			end));
		end;

	-- ── Theme live-update ─────────────────────────────────────────
	ModernV2:OnThemeChanged(function(theme)
		if theme.Icon then
			MenuIconLib:SetIconColor(theme.Icon);
		end;
		if theme.Accent then
			MenuIconLib:SetStrokeColor(theme.Accent);
		end;
	end);

	-- ── Settings panel (built-in, opens on right-click / long press) ─
	-- Shows size slider + color pickers inline using the existing windows
	-- (lightweight stub; a full window.UserSettings section is the preferred path)

	-- Show by default (caller can call :SetVisible(false) to hide)
	_setIconVisible(true);

	return MenuIconLib;
end;

if getcustomasset then
	local link = "https://github.com/4lpaca-pin/ModernV2/blob/main/assets/%s?raw=true";
	local dir = 'NLAssets';

	if not isfolder(dir) then
		makefolder(dir);
	end;

	pcall(function()
		if not isfile(dir..'/'..'logo.png') then
			local byte = game:HttpGet(string.format(link,'logo.png'));

			writefile(dir..'/'..'logo.png' , byte);
			task.wait();
		end;

		if isfile(dir..'/'..'logo.png') then
			ModernV2.GlobalLogo = getcustomasset(dir..'/'..'logo.png')
		end;
	end);

	pcall(function()
		if not isfile(dir..'/'..'saturation_value_gradient.png') then
			local byte = game:HttpGet(string.format(link,'saturation_value_gradient.png'));

			writefile(dir..'/'..'saturation_value_gradient.png' , byte);
			task.wait();
		end;

		if isfile(dir..'/'..'saturation_value_gradient.png') then
			ModernV2.ImageColorMapping = getcustomasset(dir..'/'..'saturation_value_gradient.png')
		end;
	end);
end;

function ModernV2:AddSignal(RBXSignal)
	if ModernV2.UnloadEnabled then
		table.insert(ModernV2.GlobalSignals,RBXSignal);
	end;

	return RBXSignal;
end;

ModernV2:AddSignal(GlobalWindow.DescendantAdded:Connect(function(Object)
	task.defer(function()
		ModernV2:ApplyFont(Object);
	end);
end));

function ModernV2:AddQuery(ItemRoot: Frame , Name : string)
	local SectionOwner = nil;
	local Parent = ItemRoot;

	while Parent do
		if ModernV2.SectionOwners[Parent] then
			SectionOwner = ModernV2.SectionOwners[Parent];
			break;
		end;

		Parent = Parent.Parent;
	end;

	table.insert(ModernV2.NameRegisitry , {
		Root = ItemRoot,
		Idx = Name,
		Section = SectionOwner,
	});
end;

function ModernV2:RevealQueryItem(Query)
	if not Query or not Query.Root then
		return;
	end;

	if Query.Section and Query.Section.GetCollapsed and Query.Section:GetCollapsed() then
		Query.Section:SetCollapsed(false);
	end;

	task.defer(function()
		local Root = Query.Root;

		if not Root or not Root.Parent then
			return;
		end;

		local ScrollParent = Root.Parent;

		while ScrollParent and not ScrollParent:IsA("ScrollingFrame") do
			ScrollParent = ScrollParent.Parent;
		end;

		if not ScrollParent then
			return;
		end;

		local CanvasMaxY = math.max(0, ScrollParent.AbsoluteCanvasSize.Y - ScrollParent.AbsoluteSize.Y);
		local TargetY = Root.AbsolutePosition.Y - ScrollParent.AbsolutePosition.Y + ScrollParent.CanvasPosition.Y - 8;

		ScrollParent.CanvasPosition = Vector2.new(
			ScrollParent.CanvasPosition.X,
			math.clamp(TargetY, 0, CanvasMaxY)
		);
	end);
end;

function ModernV2:RegisterFlag(Flag, Object)
	if not Flag or not Object then
		return Object;
	end;

	Flag = tostring(Flag);
	ModernV2.Flags[Flag] = Object;

	if ModernV2.PendingFlagValues[Flag] ~= nil and Object.SetValue then
		local PendingValue = ModernV2.PendingFlagValues[Flag];
		ModernV2.PendingFlagValues[Flag] = nil;

		task.spawn(function()
			pcall(function()
				Object:SetValue(PendingValue);
			end);
		end);
	end;

	return Object;
end;

function ModernV2:ResolveConfigFlag(Config)
	if typeof(Config) ~= "table" then
		return nil;
	end;

	local Flag = Config.Flag or Config.Key or Config.ConfigKey;

	if Flag ~= nil then
		Flag = tostring(Flag);
		Config.Flag = Flag;
	end;

	return Flag;
end;

function ModernV2:AttachLockMethods(Object, Frame, Config)
	if not Object or not Frame then
		return Object;
	end;

	Config = Config or {};
	local LockObject = ModernV2:ApplyLock(Frame, Config.Locked == true, Config.TextLocked or Config.LockMessage or "Locked");
	Object.Lock = LockObject;

	function Object:SetLocked(state)
		LockObject:SetLocked(state);
		return Object;
	end;

	function Object:SetTextLocked(text)
		LockObject:SetTextLocked(text);
		return Object;
	end;

	function Object:GetLocked()
		return LockObject:GetLocked();
	end;

	return Object;
end;

function Encryption.new(data: string)
	local bytes = {};
	local encrypt_seed = ((#data + 3782) % 111) + 1;

	string.gsub(data , '.', LPH_NO_VIRTUALIZE(function(dt)
		table.insert(bytes , tostring(dt:byte() + encrypt_seed));
	end));

	local concatbyte = table.concat(bytes,'?');

	table.clear(bytes);

	return "{"..tostring(encrypt_seed + 72667).."}?"..concatbyte;
end;

function Encryption.reverse(data: string)
	local main_data = string.split(data,'?');
	local seed_str = main_data[1]:gsub('{',''):gsub('}','');
	local seed = tonumber(seed_str);

	local ks = {};
	local real_seed = seed - 72667;

	for i,v in next , main_data do
		if i > 1 then
			local fake_byte = tonumber(v);
			table.insert(ks , string.char(fake_byte - real_seed))	
		end;
	end;

	local data = table.concat(ks);

	table.clear(ks);

	return data;
end;

do
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

	ModernV2.Base64Encode = LPH_NO_VIRTUALIZE(function(data)
		return ((data:gsub('.', function(x) 
			local r,b='',x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end);

	ModernV2.Base64Decode = LPH_NO_VIRTUALIZE(function(data)
		data = string.gsub(data, '[^'..b..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r,f='',(b:find(x)-1)
			for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r;
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c=0
			for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
		end))
	end);
end;

-- ── FireKeybind ───────────────────────────────────────────────────
-- Simulates the UI keybind being pressed in real time.
-- Reads Window.Keybind at call time, so it always matches whatever
-- the user has set — even if they changed it via the keybind picker.
-- Called by Watermark bindable blocks and the MenuIcon click.
function ModernV2:FireKeybind()
	if ModernV2.ActiveWindow then
		ModernV2.ActiveWindow:ToggleInterface();
	end;
end;

ModernV2.LoadIcon = LPH_NO_VIRTUALIZE(function()
	ModernV2.RobloxIcon = {
		["3d-cube-arrow-left"] = "3d-cube-arrow-left",
		["amazon"] = "amazon",
		["arm-left"] = "arm-left",
		["arm-right"] = "arm-right",
		["arrow-curl-to-left"] = "arrow-curl-to-left",
		["arrow-curl-to-right"] = "arrow-curl-to-right",
		["arrow-down-to-line"] = "arrow-down-to-line",
		["arrow-large-down"] = "arrow-large-down",
		["arrow-large-left"] = "arrow-large-left",
		["arrow-large-right"] = "arrow-large-right",
		["arrow-large-up"] = "arrow-large-up",
		["arrow-right-from-portrait-rectangle"] = "arrow-right-from-portrait-rectangle",
		["arrow-right-to-portrait-rectangle"] = "arrow-right-to-portrait-rectangle",
		["arrow-rotate-down-dashed"] = "arrow-rotate-down-dashed",
		["arrow-rotate-right"] = "arrow-rotate-right",
		["arrow-rotate-right-dashed"] = "arrow-rotate-right-dashed",
		["arrow-small-down"] = "arrow-small-down",
		["arrow-small-left"] = "arrow-small-left",
		["arrow-small-right"] = "arrow-small-right",
		["arrow-small-up"] = "arrow-small-up",
		["arrow-spin-clockwise"] = "arrow-spin-clockwise",
		["arrow-spin-clockwise-10"] = "arrow-spin-clockwise-10",
		["arrow-spin-clockwise-15"] = "arrow-spin-clockwise-15",
		["arrow-spin-clockwise-30"] = "arrow-spin-clockwise-30",
		["arrow-spin-counter-clockwise-10"] = "arrow-spin-counter-clockwise-10",
		["arrow-spin-counter-clockwise-15"] = "arrow-spin-counter-clockwise-15",
		["arrow-spin-counter-clockwise-30"] = "arrow-spin-counter-clockwise-30",
		["arrow-thick-to-left"] = "arrow-thick-to-left",
		["arrow-thick-to-right"] = "arrow-thick-to-right",
		["arrow-up-from-landscape-rectangle"] = "arrow-up-from-landscape-rectangle",
		["arrow-up-right-from-square"] = "arrow-up-right-from-square",
		["arrow-wide-short-down"] = "arrow-wide-short-down",
		["arrow-wide-short-left"] = "arrow-wide-short-left",
		["arrow-wide-short-right"] = "arrow-wide-short-right",
		["arrow-wide-short-up"] = "arrow-wide-short-up",
		["arrows-small-directional"] = "arrows-small-directional",
		["audio-wave-dotted-line"] = "audio-wave-dotted-line",
		["backpack"] = "backpack",
		["beard"] = "beard",
		["bell"] = "bell",
		["bell-clock"] = "bell-clock",
		["bell-plus"] = "bell-plus",
		["bell-slash"] = "bell-slash",
		["belt"] = "belt",
		["binoculars"] = "binoculars",
		["book-closed"] = "book-closed",
		["bookmark"] = "bookmark",
		["bow-tie"] = "bow-tie",
		["building-store"] = "building-store",
		["bullet-flying"] = "bullet-flying",
		["butterfly-wings"] = "butterfly-wings",
		["calendar"] = "calendar",
		["calendar-plus"] = "calendar-plus",
		["calendar-star"] = "calendar-star",
		["camera-small"] = "camera-small",
		["caret-small-down"] = "caret-small-down",
		["caret-small-left"] = "caret-small-left",
		["caret-small-right"] = "caret-small-right",
		["caret-small-up"] = "caret-small-up",
		["chain-link"] = "chain-link",
		["chart-four-vertical-bars"] = "chart-four-vertical-bars",
		["chart-line"] = "chart-line",
		["chart-pie"] = "chart-pie",
		["chart-scatter-plot"] = "chart-scatter-plot",
		["chart-three-vertical-bars"] = "chart-three-vertical-bars",
		["check"] = "check",
		["check-large"] = "check-large",
		["check-small"] = "check-small",
		["chevron-large-down"] = "chevron-large-down",
		["chevron-large-down-to-line"] = "chevron-large-down-to-line",
		["chevron-large-left"] = "chevron-large-left",
		["chevron-large-left-to-line"] = "chevron-large-left-to-line",
		["chevron-large-right"] = "chevron-large-right",
		["chevron-large-right-to-line"] = "chevron-large-right-to-line",
		["chevron-large-up"] = "chevron-large-up",
		["chevron-large-up-to-line"] = "chevron-large-up-to-line",
		["chevron-small-down"] = "chevron-small-down",
		["chevron-small-down-to-line"] = "chevron-small-down-to-line",
		["chevron-small-left"] = "chevron-small-left",
		["chevron-small-left-to-line"] = "chevron-small-left-to-line",
		["chevron-small-right"] = "chevron-small-right",
		["chevron-small-right-to-line"] = "chevron-small-right-to-line",
		["chevron-small-up"] = "chevron-small-up",
		["chevron-small-up-to-line"] = "chevron-small-up-to-line",
		["circle-check"] = "circle-check",
		["circle-i"] = "circle-i",
		["circle-minus"] = "circle-minus",
		["circle-person"] = "circle-person",
		["circle-person-three-horizontal-bars-wrapping-right"] = "circle-person-three-horizontal-bars-wrapping-right",
		["circle-play"] = "circle-play",
		["circle-plus"] = "circle-plus",
		["circle-question"] = "circle-question",
		["circle-slash"] = "circle-slash",
		["circle-star"] = "circle-star",
		["circle-three-dots-horizontal"] = "circle-three-dots-horizontal",
		["circle-three-dots-vertical"] = "circle-three-dots-vertical",
		["circle-x"] = "circle-x",
		["clock"] = "clock",
		["clock-dashed"] = "clock-dashed",
		["clock-spin-reverse"] = "clock-spin-reverse",
		["clock-spin-reverse-dashed"] = "clock-spin-reverse-dashed",
		["clothes-hanger"] = "clothes-hanger",
		["cloud"] = "cloud",
		["cloud-arrow-down"] = "cloud-arrow-down",
		["code"] = "code",
		["compact-makeup-brush"] = "compact-makeup-brush",
		["compass"] = "compass",
		["controller-with-cog"] = "controller-with-cog",
		["crop"] = "crop",
		["crosshairs"] = "crosshairs",
		["crosshairs-slash"] = "crosshairs-slash",
		["cube-vertexes"] = "cube-vertexes",
		["curved-rectangle-megaphone"] = "curved-rectangle-megaphone",
		["diagonal-line-pattern"] = "diagonal-line-pattern",
		["diagonal-line-pattern-sticker"] = "diagonal-line-pattern-sticker",
		["diamond-simplified"] = "diamond-simplified",
		["discord"] = "discord",
		["disguise-nose-glasses"] = "disguise-nose-glasses",
		["document-circle-slash"] = "document-circle-slash",
		["document-list-heart"] = "document-list-heart",
		["door-open-arrow-to-bottom-right"] = "door-open-arrow-to-bottom-right",
		["dress"] = "dress",
		["dual-arrows-horizontal"] = "dual-arrows-horizontal",
		["dual-arrows-to-corners"] = "dual-arrows-to-corners",
		["dual-arrows-vertical"] = "dual-arrows-vertical",
		["envelope"] = "envelope",
		["eraser"] = "eraser",
		["eye"] = "eye",
		["eye-slash"] = "eye-slash",
		["eye-with-eyeliner"] = "eye-with-eyeliner",
		["eyebrows"] = "eyebrows",
		["eyelashes"] = "eyelashes",
		["face-winking"] = "face-winking",
		["facebook"] = "facebook",
		["file-box"] = "file-box",
		["fingerprint"] = "fingerprint",
		["flag"] = "flag",
		["flame"] = "flame",
		["folder"] = "folder",
		["fountain-pen-nib"] = "fountain-pen-nib",
		["four-bars-horizontal-center-aligned"] = "four-bars-horizontal-center-aligned",
		["four-bars-horizontal-chevron-left"] = "four-bars-horizontal-chevron-left",
		["four-bars-horizontal-chevron-right"] = "four-bars-horizontal-chevron-right",
		["four-bars-horizontal-justified-aligned"] = "four-bars-horizontal-justified-aligned",
		["four-bars-horizontal-left-aligned"] = "four-bars-horizontal-left-aligned",
		["four-bars-horizontal-right-aligned"] = "four-bars-horizontal-right-aligned",
		["frame-bubble-slash"] = "frame-bubble-slash",
		["frame-bubble-soundwave"] = "frame-bubble-soundwave",
		["frame-camera"] = "frame-camera",
		["frame-camera-center"] = "frame-camera-center",
		["frame-collapsed"] = "frame-collapsed",
		["frame-corners"] = "frame-corners",
		["frame-expanded"] = "frame-expanded",
		["frame-face"] = "frame-face",
		["frame-person-torso"] = "frame-person-torso",
		["frame-record"] = "frame-record",
		["frame-single-bar-horizontal"] = "frame-single-bar-horizontal",
		["frame-soundwave"] = "frame-soundwave",
		["frame-video-camera"] = "frame-video-camera",
		["gear"] = "gear",
		["generic-dpad"] = "generic-dpad",
		["gift-box"] = "gift-box",
		["gift-card"] = "gift-card",
		["glasses"] = "glasses",
		["globe-detailed"] = "globe-detailed",
		["globe-simplified"] = "globe-simplified",
		["globe-simplipfied-speech-bubble"] = "globe-simplipfied-speech-bubble",
		["grid"] = "grid",
		["guilded"] = "guilded",
		["hack-week"] = "hack-week",
		["hammer-code"] = "hammer-code",
		["hand-curved-arrow-left"] = "hand-curved-arrow-left",
		["hand-dual-arrows"] = "hand-dual-arrows",
		["hand-ellipse"] = "hand-ellipse",
		["hand-half-ellipse"] = "hand-half-ellipse",
		["hand-two-arrows-horizontal"] = "hand-two-arrows-horizontal",
		["hashtag"] = "hashtag",
		["hat-fedora"] = "hat-fedora",
		["hat-toque"] = "hat-toque",
		["head-blank"] = "head-blank",
		["head-blush"] = "head-blush",
		["head-female"] = "head-female",
		["head-freckles"] = "head-freckles",
		["head-lips"] = "head-lips",
		["head-male"] = "head-male",
		["headphones"] = "headphones",
		["headphones-arrow-up"] = "headphones-arrow-up",
		["headphones-arrow-up-lock"] = "headphones-arrow-up-lock",
		["headphones-slash"] = "headphones-slash",
		["headphones-x"] = "headphones-x",
		["headphones-x-lock"] = "headphones-x-lock",
		["heart"] = "heart",
		["house"] = "house",
		["image"] = "image",
		["image-stacked"] = "image-stacked",
		["instagram"] = "instagram",
		["jacket"] = "jacket",
		["key"] = "key",
		["key-alt"] = "key-alt",
		["key-apostrophe"] = "key-apostrophe",
		["key-arrow-down"] = "key-arrow-down",
		["key-arrow-right"] = "key-arrow-right",
		["key-arrow-up"] = "key-arrow-up",
		["key-asterisk"] = "key-asterisk",
		["key-backspace"] = "key-backspace",
		["key-caps-lock"] = "key-caps-lock",
		["key-caret"] = "key-caret",
		["key-comma"] = "key-comma",
		["key-command"] = "key-command",
		["key-control"] = "key-control",
		["key-grave-accent"] = "key-grave-accent",
		["key-period"] = "key-period",
		["key-return"] = "key-return",
		["key-shift"] = "key-shift",
		["key-space"] = "key-space",
		["key-tab"] = "key-tab",
		["language-characters"] = "language-characters",
		["leg-left"] = "leg-left",
		["leg-right"] = "leg-right",
		["lightning-bolt"] = "lightning-bolt",
		["linkedin"] = "linkedin",
		["lips"] = "lips",
		["lipstick"] = "lipstick",
		["list-bulleted"] = "list-bulleted",
		["location-pin"] = "location-pin",
		["location-pin-map"] = "location-pin-map",
		["lock-closed"] = "lock-closed",
		["lollipop"] = "lollipop",
		["magnifying-glass"] = "magnifying-glass",
		["magnifying-glass-minus"] = "magnifying-glass-minus",
		["magnifying-glass-plus"] = "magnifying-glass-plus",
		["mascara"] = "mascara",
		["megaphone"] = "megaphone",
		["memory-card"] = "memory-card",
		["messenger"] = "messenger",
		["microphone"] = "microphone",
		["microphone-slash"] = "microphone-slash",
		["microphone-text-box"] = "microphone-text-box",
		["microphone-triangle-exclamation"] = "microphone-triangle-exclamation",
		["minus"] = "minus",
		["minus-small"] = "minus-small",
		["mirror-standing"] = "mirror-standing",
		["moments"] = "moments",
		["moon"] = "moon",
		["mouse-button-left"] = "mouse-button-left",
		["mouse-button-right"] = "mouse-button-right",
		["mouse-scrollwheel"] = "mouse-scrollwheel",
		["music-note"] = "music-note",
		["nebula"] = "nebula",
		["necklace"] = "necklace",
		["nine-dots-grid"] = "nine-dots-grid",
		["ninja"] = "ninja",
		["nose"] = "nose",
		["page"] = "page",
		["paint-brush"] = "paint-brush",
		["paint-bucket"] = "paint-bucket",
		["pants"] = "pants",
		["pants-2d-text"] = "pants-2d-text",
		["paper-airplane"] = "paper-airplane",
		["parrot"] = "parrot",
		["pause-large"] = "pause-large",
		["pause-small"] = "pause-small",
		["pencil"] = "pencil",
		["pencil-square"] = "pencil-square",
		["person"] = "person",
		["person-arrow-from-bottom-right"] = "person-arrow-from-bottom-right",
		["person-check"] = "person-check",
		["person-circle-slash"] = "person-circle-slash",
		["person-climbing"] = "person-climbing",
		["person-clock"] = "person-clock",
		["person-falling"] = "person-falling",
		["person-graduate"] = "person-graduate",
		["person-jumping"] = "person-jumping",
		["person-magnifying-glass"] = "person-magnifying-glass",
		["person-photo-camera"] = "person-photo-camera",
		["person-play"] = "person-play",
		["person-play-clock"] = "person-play-clock",
		["person-plus"] = "person-plus",
		["person-racing"] = "person-racing",
		["person-running"] = "person-running",
		["person-standing"] = "person-standing",
		["person-standing-arrow-reverse"] = "person-standing-arrow-reverse",
		["person-standing-dual-arrows-vertical"] = "person-standing-dual-arrows-vertical",
		["person-standing-gear"] = "person-standing-gear",
		["person-swimming"] = "person-swimming",
		["person-teleport"] = "person-teleport",
		["person-trash-can"] = "person-trash-can",
		["person-walking"] = "person-walking",
		["person-with-smaller-person"] = "person-with-smaller-person",
		["phone"] = "phone",
		["phone-down"] = "phone-down",
		["phone-plus"] = "phone-plus",
		["phone-volume"] = "phone-volume",
		["phone-x"] = "phone-x",
		["photo-camera"] = "photo-camera",
		["photo-camera-face"] = "photo-camera-face",
		["photo-camera-slash"] = "photo-camera-slash",
		["picture-in-picture"] = "picture-in-picture",
		["pig"] = "pig",
		["pin"] = "pin",
		["pin-slash"] = "pin-slash",
		["play-large"] = "play-large",
		["play-small"] = "play-small",
		["plus-large"] = "plus-large",
		["plus-small"] = "plus-small",
		["premium"] = "premium",
		["ps-circle"] = "ps-circle",
		["ps-dpad-down"] = "ps-dpad-down",
		["ps-dpad-left"] = "ps-dpad-left",
		["ps-dpad-right"] = "ps-dpad-right",
		["ps-dpad-up"] = "ps-dpad-up",
		["ps-l1"] = "ps-l1",
		["ps-l2"] = "ps-l2",
		["ps-l3"] = "ps-l3",
		["ps-r1"] = "ps-r1",
		["ps-r2"] = "ps-r2",
		["ps-r3"] = "ps-r3",
		["ps-square"] = "ps-square",
		["ps-stick-left"] = "ps-stick-left",
		["ps-stick-right"] = "ps-stick-right",
		["ps-triagle"] = "ps-triagle",
		["ps-x"] = "ps-x",
		["ps4-options"] = "ps4-options",
		["ps4-share"] = "ps4-share",
		["ps4-touchpad"] = "ps4-touchpad",
		["ps5-options"] = "ps5-options",
		["ps5-share"] = "ps5-share",
		["ps5-touchpad"] = "ps5-touchpad",
		["pumpkin"] = "pumpkin",
		["purse"] = "purse",
		["rectangle-list"] = "rectangle-list",
		["rectangle-numbers-counting"] = "rectangle-numbers-counting",
		["rectangle-person-with-three-horizontal-lines"] = "rectangle-person-with-three-horizontal-lines",
		["robux"] = "robux",
		["rosette-seven-point"] = "rosette-seven-point",
		["rosette-ten-point"] = "rosette-ten-point",
		["seven-point-rosette"] = "seven-point-rosette",
		["shield-check"] = "shield-check",
		["shield-lock"] = "shield-lock",
		["shirt"] = "shirt",
		["shirt-2d-text"] = "shirt-2d-text",
		["shirt-pants"] = "shirt-pants",
		["shoe-left"] = "shoe-left",
		["shoe-right"] = "shoe-right",
		["shopping-basket"] = "shopping-basket",
		["shopping-basket-check"] = "shopping-basket-check",
		["shopping-cart"] = "shopping-cart",
		["shorts"] = "shorts",
		["sidebar"] = "sidebar",
		["signal-exclamation"] = "signal-exclamation",
		["six-dots-two-column-grid"] = "six-dots-two-column-grid",
		["skip-end-large"] = "skip-end-large",
		["skip-end-small"] = "skip-end-small",
		["skip-next-large"] = "skip-next-large",
		["skip-next-small"] = "skip-next-small",
		["skip-previous-large"] = "skip-previous-large",
		["skip-previous-small"] = "skip-previous-small",
		["skip-start-large"] = "skip-start-large",
		["skip-start-small"] = "skip-start-small",
		["smartphone-portrait"] = "smartphone-portrait",
		["speaker"] = "speaker",
		["speaker-slash"] = "speaker-slash",
		["speaker-triangle-exclamation"] = "speaker-triangle-exclamation",
		["speaker-x"] = "speaker-x",
		["speech-bubble-align-center"] = "speech-bubble-align-center",
		["speech-bubble-align-left"] = "speech-bubble-align-left",
		["speech-bubble-exclamation"] = "speech-bubble-exclamation",
		["speech-bubble-round"] = "speech-bubble-round",
		["square-bone"] = "square-bone",
		["square-books"] = "square-books",
		["square-check"] = "square-check",
		["square-code"] = "square-code",
		["square-dashed-person-standing"] = "square-dashed-person-standing",
		["square-dual-arrows-horizontal"] = "square-dual-arrows-horizontal",
		["square-dual-arrows-to-corner"] = "square-dual-arrows-to-corner",
		["square-face-sound"] = "square-face-sound",
		["square-face-waving-hand"] = "square-face-waving-hand",
		["square-face-winking"] = "square-face-winking",
		["square-minus"] = "square-minus",
		["square-person"] = "square-person",
		["squares-grid-plus"] = "squares-grid-plus",
		["squares-grid-qr"] = "squares-grid-qr",
		["stacked-squares-arrow-down-left"] = "stacked-squares-arrow-down-left",
		["stacked-squares-arrow-up-right"] = "stacked-squares-arrow-up-right",
		["stacked-squares-plus"] = "stacked-squares-plus",
		["star"] = "star",
		["stop-large"] = "stop-large",
		["stop-small"] = "stop-small",
		["studio"] = "studio",
		["sun"] = "sun",
		["sweater"] = "sweater",
		["sword"] = "sword",
		["tag-sparkle"] = "tag-sparkle",
		["teletype"] = "teletype",
		["tencent-qq"] = "tencent-qq",
		["text-b-bold"] = "text-b-bold",
		["text-box-microphone"] = "text-box-microphone",
		["text-h-subscript-1"] = "text-h-subscript-1",
		["text-h-subscript-2"] = "text-h-subscript-2",
		["text-h-subscript-3"] = "text-h-subscript-3",
		["text-i-italic"] = "text-i-italic",
		["text-s-strikethrough"] = "text-s-strikethrough",
		["text-u-underline"] = "text-u-underline",
		["text-uppercase-a-lowercase-a"] = "text-uppercase-a-lowercase-a",
		["text-x-subscript-2"] = "text-x-subscript-2",
		["text-x-superscript-2"] = "text-x-superscript-2",
		["three-bars-horizontal"] = "three-bars-horizontal",
		["three-bars-horizontal-chevron-left"] = "three-bars-horizontal-chevron-left",
		["three-bars-horizontal-narrowing"] = "three-bars-horizontal-narrowing",
		["three-bars-horizontal-triangles-vertical"] = "three-bars-horizontal-triangles-vertical",
		["three-bars-vertical-triangles-horizontal"] = "three-bars-vertical-triangles-horizontal",
		["three-chevrons-enlarging-down"] = "three-chevrons-enlarging-down",
		["three-chevrons-enlarging-up"] = "three-chevrons-enlarging-up",
		["three-dots-horizontal"] = "three-dots-horizontal",
		["three-dots-vertical"] = "three-dots-vertical",
		["three-horizontal-bars-wrapping-right"] = "three-horizontal-bars-wrapping-right",
		["three-people"] = "three-people",
		["three-ring-note"] = "three-ring-note",
		["three-sliders-horizontal"] = "three-sliders-horizontal",
		["three-stacked-squares-tilted"] = "three-stacked-squares-tilted",
		["thumb-down"] = "thumb-down",
		["thumb-up"] = "thumb-up",
		["tik-tok"] = "tik-tok",
		["tilt"] = "tilt",
		["torso"] = "torso",
		["trash-can"] = "trash-can",
		["triangle-exclamation"] = "triangle-exclamation",
		["trophy"] = "trophy",
		["tshirt"] = "tshirt",
		["tshirt-2d-text"] = "tshirt-2d-text",
		["tshirt-dual-arrows"] = "tshirt-dual-arrows",
		["twitch"] = "twitch",
		["twitter"] = "twitter",
		["two-arrows-down-and-up"] = "two-arrows-down-and-up",
		["two-arrows-from-center"] = "two-arrows-from-center",
		["two-arrows-left-right"] = "two-arrows-left-right",
		["two-arrows-loop-clockwise"] = "two-arrows-loop-clockwise",
		["two-arrows-loop-clockwise-1"] = "two-arrows-loop-clockwise-1",
		["two-arrows-loop-clockwise-infinity"] = "two-arrows-loop-clockwise-infinity",
		["two-arrows-spin-clockwise"] = "two-arrows-spin-clockwise",
		["two-arrows-spin-clockwise-plus"] = "two-arrows-spin-clockwise-plus",
		["two-arrows-switch-right"] = "two-arrows-switch-right",
		["two-arrows-to-center"] = "two-arrows-to-center",
		["two-folders"] = "two-folders",
		["two-location-pins-connecting-arrow"] = "two-location-pins-connecting-arrow",
		["two-makeup-brushes"] = "two-makeup-brushes",
		["two-people"] = "two-people",
		["two-people-speech-bubble"] = "two-people-speech-bubble",
		["two-stacked-squares"] = "two-stacked-squares",
		["two-switches-horizontal"] = "two-switches-horizontal",
		["verified-backplate"] = "verified-backplate",
		["verified-check"] = "verified-check",
		["verified-mono"] = "verified-mono",
		["video-camera"] = "video-camera",
		["video-camera-arrow-to-bottom-left"] = "video-camera-arrow-to-bottom-left",
		["video-camera-arrow-to-top-right"] = "video-camera-arrow-to-top-right",
		["video-camera-slash"] = "video-camera-slash",
		["video-camera-triangle-exclamation"] = "video-camera-triangle-exclamation",
		["video-camera-x"] = "video-camera-x",
		["wallet"] = "wallet",
		["we-chat"] = "we-chat",
		["whatsapp"] = "whatsapp",
		["x"] = "x",
		["x-small"] = "x-small",
		["xbox-a"] = "xbox-a",
		["xbox-a-pressed"] = "xbox-a-pressed",
		["xbox-a-unpressed"] = "xbox-a-unpressed",
		["xbox-b"] = "xbox-b",
		["xbox-dpad"] = "xbox-dpad",
		["xbox-dpad-down"] = "xbox-dpad-down",
		["xbox-dpad-left"] = "xbox-dpad-left",
		["xbox-dpad-right"] = "xbox-dpad-right",
		["xbox-dpad-up"] = "xbox-dpad-up",
		["xbox-lb"] = "xbox-lb",
		["xbox-lt"] = "xbox-lt",
		["xbox-menu"] = "xbox-menu",
		["xbox-rb"] = "xbox-rb",
		["xbox-rt"] = "xbox-rt",
		["xbox-stick-left"] = "xbox-stick-left",
		["xbox-stick-left-directional"] = "xbox-stick-left-directional",
		["xbox-stick-left-horizontal"] = "xbox-stick-left-horizontal",
		["xbox-stick-left-vertical"] = "xbox-stick-left-vertical",
		["xbox-stick-right"] = "xbox-stick-right",
		["xbox-stick-right-directional"] = "xbox-stick-right-directional",
		["xbox-stick-right-horizontal"] = "xbox-stick-right-horizontal",
		["xbox-stick-right-vertical"] = "xbox-stick-right-vertical",
		["xbox-view"] = "xbox-view",
		["xbox-x"] = "xbox-x",
		["xbox-y"] = "xbox-y",
		["xr-headset"] = "xr-headset",
		["youtube"] = "youtube"
	};
end);

ModernV2.IsMouseOverFrame = LPH_NO_VIRTUALIZE(function(self , Frame)
	if not Frame then
		return;
	end;

	if ModernV2.Global3DRenderMode then
		if Frame.GuiState == Enum.GuiState.Hover or Frame.GuiState == Enum.GuiState.Press then
			return true;
		end;

		return false;
	end;

	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end);

ModernV2.CreateSignal = LPH_NO_VIRTUALIZE(function(self , DefaultValue)
	local __cache = Instance.new('BindableEvent');
	local bind = {
		Value = DefaultValue,
		__event = __cache
	};

	function bind:GetValue()
		return bind.Value;
	end;

	function bind:SetValue(f)
		bind.Value = f;

		return __cache:Fire(f);
	end;

	function bind:Connect(f)
		local signal = __cache.Event:Connect(f);

		ModernV2:AddSignal(signal);

		return signal;
	end;

	return bind;
end);

function ModernV2:_ApplyTextGradient(Label)
	if not Label or not Label.Parent then
		return;
	end;

	local Gradient = Label:FindFirstChild("ModernTextGradient");

	if not ModernV2.TextGradientEnabled then
		if Gradient then
			Gradient:Destroy();
		end;

		return;
	end;

	if not Gradient then
		Gradient = Instance.new("UIGradient");
		Gradient.Name = "ModernTextGradient";
		Gradient.Parent = Label;
	end;

	local Accent = ModernV2.AccentColor or Color3.fromRGB(78, 127, 252);
	local SweepX = (((ModernV2.TextGradientAnimationTime or 0) * 0.9) % 2) - 1;

	Gradient.Rotation = 0;
	Gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Accent:Lerp(Color3.new(1, 1, 1), 0.2)),
		ColorSequenceKeypoint.new(0.55, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, Accent:Lerp(Color3.new(1, 1, 1), 0.35)),
	});
	Gradient.Offset = Vector2.new(SweepX, 0);

	for _,ExistingGradient in ipairs(ModernV2.TextGradientObjects) do
		if ExistingGradient == Gradient then
			return Gradient;
		end;
	end;

	table.insert(ModernV2.TextGradientObjects, Gradient);

	return Gradient;
end;

function ModernV2:AddTextGradient(Label)
	if not Label then
		return Label;
	end;

	for _,ExistingLabel in ipairs(ModernV2.TextGradientLabels) do
		if ExistingLabel == Label then
			ModernV2:_ApplyTextGradient(Label);
			return Label;
		end;
	end;

	table.insert(ModernV2.TextGradientLabels, Label);
	ModernV2:_ApplyTextGradient(Label);

	return Label;
end;

function ModernV2:SetTextGradientEnabled(Enabled)
	ModernV2.TextGradientEnabled = Enabled == true;

	if not ModernV2.TextGradientEnabled then
		ModernV2.TextGradientAccumulator = 0;
	end;

	table.clear(ModernV2.TextGradientObjects);

	for Index = #ModernV2.TextGradientLabels, 1, -1 do
		local Label = ModernV2.TextGradientLabels[Index];

		if Label and Label.Parent then
			ModernV2:_ApplyTextGradient(Label);
		else
			table.remove(ModernV2.TextGradientLabels, Index);
		end;
	end;
end;

function ModernV2:AnimateTextGradients(dt)
	if not ModernV2.TextGradientEnabled then
		return;
	end;

	ModernV2.TextGradientAccumulator = (ModernV2.TextGradientAccumulator or 0) + (dt or 0);

	if ModernV2.TextGradientAccumulator < (1 / 30) then
		return;
	end;

	local ResolvedDt = ModernV2.TextGradientAccumulator;
	ModernV2.TextGradientAccumulator = 0;
	ModernV2.TextGradientAnimationTime = (ModernV2.TextGradientAnimationTime or 0) + ResolvedDt;

	local SweepX = ((ModernV2.TextGradientAnimationTime * 0.9) % 2) - 1;
	local Offset = Vector2.new(SweepX, 0);

	for Index = #ModernV2.TextGradientObjects, 1, -1 do
		local Gradient = ModernV2.TextGradientObjects[Index];

		if Gradient and Gradient.Parent then
			Gradient.Rotation = 0;
			Gradient.Offset = Offset;
		else
			table.remove(ModernV2.TextGradientObjects, Index);
		end;
	end;
end;

ModernV2:AddSignal(RunService.RenderStepped:Connect(function(dt)
	ModernV2:AnimateTextGradients(dt);
end));

ModernV2.SetIconMode = LPH_NO_VIRTUALIZE(function(self , Label: TextLabel , Icon: string)
	Icon = tostring(Icon or "");
	local OriginalIcon = Icon;
	local FallbackIcon = ModernV2.IconAliases[OriginalIcon] or OriginalIcon;
	local IsVideoIcon = ModernV2:IsWebmIcon(OriginalIcon) or ModernV2:IsWebmIcon(FallbackIcon);
	local ResolvedIcon = ModernV2:GetIconId(OriginalIcon);

	if ResolvedIcon == "" and FallbackIcon ~= OriginalIcon then
		ResolvedIcon = ModernV2:GetIconId(FallbackIcon);
	end;

	if Label:IsA("ImageLabel") then
		if IsVideoIcon then
			Label.Image = "";
			Label.ImageTransparency = 1;
			Label.ScaleType = Enum.ScaleType.Fit;
			ModernV2:ApplyIconVideo(Label, OriginalIcon);

			local FallbackText = Label:FindFirstChild("ModernIconFallbackText");
			if FallbackText then
				FallbackText.Visible = false;
			end;

			return;
		end;

		ModernV2:ClearIconVideo(Label);
		Label.Image = ResolvedIcon;
		Label.ScaleType = Enum.ScaleType.Fit;

		local IconScale = Label:FindFirstChild("ModernIconScale");
		if not IconScale then
			IconScale = Instance.new("UIScale");
			IconScale.Name = "ModernIconScale";
			IconScale.Parent = Label;
		end;
		IconScale.Scale = tonumber(Label:GetAttribute("ModernIconScaleValue")) or ModernV2.IconScale or 0.82;

		local FallbackText = Label:FindFirstChild("ModernIconFallbackText");

		if ResolvedIcon ~= "" then
			if FallbackText then
				FallbackText.Visible = false;
			end;
		else
			Label.ImageTransparency = 1;

			if FallbackIcon ~= "" and not string.find(FallbackIcon, "lucide:", 1, true) and not string.find(FallbackIcon, "solar:", 1, true) then
				if not FallbackText then
					FallbackText = Instance.new("TextLabel");
					FallbackText.Name = "ModernIconFallbackText";
					FallbackText.Parent = Label;
					FallbackText.AnchorPoint = Vector2.new(0.5, 0.5);
					FallbackText.BackgroundTransparency = 1;
					FallbackText.BorderSizePixel = 0;
					FallbackText.Position = UDim2.fromScale(0.5, 0.5);
					FallbackText.Size = UDim2.fromScale(1, 1);
					FallbackText.ZIndex = Label.ZIndex + 1;
					FallbackText.TextScaled = true;
					FallbackText.TextWrapped = true;
					FallbackText:SetAttribute("ModernV2IconFont", true);

					ModernV2:AddSignal(Label:GetPropertyChangedSignal("ImageTransparency"):Connect(function()
						local ChildIcon = Label:FindFirstChild("ModernIconFallbackText");
						if ChildIcon then
							ChildIcon.TextTransparency = Label.ImageTransparency;
						end;
					end));

					ModernV2:AddSignal(Label:GetPropertyChangedSignal("ImageColor3"):Connect(function()
						local ChildIcon = Label:FindFirstChild("ModernIconFallbackText");
						if ChildIcon then
							ChildIcon.TextColor3 = Label.ImageColor3;
						end;
					end));

					ModernV2:AddSignal(Label:GetPropertyChangedSignal("ZIndex"):Connect(function()
						local ChildIcon = Label:FindFirstChild("ModernIconFallbackText");
						if ChildIcon then
							ChildIcon.ZIndex = Label.ZIndex + 1;
						end;
					end));
				end;

				local useBold = string.lower(string.sub(FallbackIcon , -5)) == '-bold';
				FallbackText.Text = useBold and FallbackIcon:sub(1,-6) or FallbackIcon;
				FallbackText.FontFace = useBold and ModernV2.BuiltInBold or ModernV2.BuiltInRegular;
				FallbackText.TextColor3 = Label.ImageColor3;
				FallbackText.TextTransparency = Label.ImageTransparency;
				FallbackText.Visible = true;
			elseif FallbackText then
				FallbackText.Visible = false;
			end;
		end;

		return;
	end;

	local IconImage = Label:FindFirstChild("ModernResolvedIcon");

	if IsVideoIcon then
		if not IconImage then
			IconImage = Instance.new("ImageLabel");
			IconImage.Name = "ModernResolvedIcon";
			IconImage.Parent = Label;
			IconImage.AnchorPoint = Vector2.new(0.5, 0.5);
			IconImage.BackgroundTransparency = 1;
			IconImage.BorderSizePixel = 0;
			IconImage.Position = UDim2.fromScale(0.5, 0.5);
			IconImage.Size = UDim2.fromScale(1, 1);
			IconImage.ScaleType = Enum.ScaleType.Fit;
			IconImage.ZIndex = Label.ZIndex;
		end;

		IconImage.Image = "";
		IconImage.ImageTransparency = 1;
		IconImage.Visible = true;
		ModernV2:ApplyIconVideo(IconImage, OriginalIcon);
		Label.Text = "";

		return;
	elseif IconImage then
		ModernV2:ClearIconVideo(IconImage);
	end;

	if ResolvedIcon ~= "" then
		if not IconImage then
			IconImage = Instance.new("ImageLabel");
			IconImage.Name = "ModernResolvedIcon";
			IconImage.Parent = Label;
			IconImage.AnchorPoint = Vector2.new(0.5, 0.5);
			IconImage.BackgroundTransparency = 1;
			IconImage.BorderSizePixel = 0;
			IconImage.Position = UDim2.fromScale(0.5, 0.5);
			IconImage.Size = UDim2.fromScale(1, 1);
			IconImage.ScaleType = Enum.ScaleType.Fit;
			IconImage.ZIndex = Label.ZIndex;

			ModernV2:AddSignal(Label:GetPropertyChangedSignal("TextTransparency"):Connect(function()
				local ChildIcon = Label:FindFirstChild("ModernResolvedIcon");
				if ChildIcon then
					ChildIcon.ImageTransparency = Label.TextTransparency;
				end;
			end));

			ModernV2:AddSignal(Label:GetPropertyChangedSignal("TextColor3"):Connect(function()
				local ChildIcon = Label:FindFirstChild("ModernResolvedIcon");
				if ChildIcon then
					ChildIcon.ImageColor3 = Label.TextColor3;
				end;
			end));

			ModernV2:AddSignal(Label:GetPropertyChangedSignal("ZIndex"):Connect(function()
				local ChildIcon = Label:FindFirstChild("ModernResolvedIcon");
				if ChildIcon then
					ChildIcon.ZIndex = Label.ZIndex;
				end;
			end));
		end;

		IconImage.Image = ResolvedIcon;
		IconImage.ImageColor3 = Label.TextColor3;
		IconImage.ImageTransparency = Label.TextTransparency;
		IconImage.Visible = true;
		Label.Text = "";

		return;
	end;

	if IconImage then
		IconImage.Visible = false;
		IconImage.Image = "";
	end;

	Icon = FallbackIcon;

	if string.find(Icon, "lucide:", 1, true) or string.find(Icon, "solar:", 1, true) then
		Label.Text = "";
		return;
	end;

	local useBold = string.lower(string.sub(Icon , -5)) == '-bold';

	if useBold then
		Label.Text = Icon:sub(1,-6);
		Label.FontFace = ModernV2.BuiltInBold;
	else
		Label.Text = Icon;
		Label.FontFace = ModernV2.BuiltInRegular;
	end;
	Label:SetAttribute("ModernV2IconFont", true);
end);

function ModernV2:GetIconFont(icon: string)
	local useBold = string.lower(string.sub(icon , -5)) == '-bold';

	if useBold then
		return ModernV2.BuiltInBold;
	end;

	return ModernV2.BuiltInRegular;
end;

function ModernV2:ResolveFontFace(FontConfig)
	if typeof(FontConfig) == "Font" then
		return FontConfig;
	end;

	if not FontConfig or FontConfig == "" then
		return nil;
	end;

	local FontSource = tostring(FontConfig);

	if string.match(FontSource, "^%d+$") then
		FontSource = "rbxassetid://" .. FontSource;
	elseif not string.find(FontSource, "rbxasset://", 1, true) and not string.find(FontSource, "rbxassetid://", 1, true) and not string.match(FontSource, "^https?://") then
		FontSource = "rbxasset://fonts/families/" .. FontSource .. ".json";
	end;

	local Success, ResolvedFont = pcall(function()
		return Font.new(FontSource,Enum.FontWeight.Regular,Enum.FontStyle.Normal);
	end);

	if Success then
		return ResolvedFont;
	end;
end;

function ModernV2:ApplyFont(Object)
	if not ModernV2.FontFace then
		return Object;
	end;

	if not Object or (not Object:IsA("TextLabel") and not Object:IsA("TextBox") and not Object:IsA("TextButton")) then
		return Object;
	end;

	if Object:GetAttribute("ModernV2IconFont") then
		return Object;
	end;

	Object.FontFace = ModernV2.FontFace;
	return Object;
end;

function ModernV2:SetFont(FontConfig)
	ModernV2.Font = FontConfig;
	ModernV2.FontFace = ModernV2:ResolveFontFace(FontConfig);

	if ModernV2.FontFace then
		for _, Object in next, ModernV2.ScreenGui:GetDescendants() do
			ModernV2:ApplyFont(Object);
		end;
	end;

	return ModernV2.FontFace;
end;

function ModernV2:MoreThanHalfY(Value: number)
	return (ModernV2.ScreenGui.AbsoluteSize.Y / 2) < Value
end;

ModernV2.IsStudio = RunService:IsStudio();
ModernV2.IsMobile = UserInputService.TouchEnabled;

ModernV2.CreateInput = LPH_NO_VIRTUALIZE(function(self , Frame , Callback)
	local Button = Instance.new('ImageButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.ImageTransparency = 1;
	Button.Image = "rbxasset://textuers/translateIcon.png";

	if Callback then
		local bth_signal = Button.MouseButton1Click:Connect(Callback);

		return Button , bth_signal;
	end;

	return Button;
end);

ModernV2.PlayAnimate = LPH_NO_VIRTUALIZE(function(Self , Info , Property)
	if Self and Self:IsA("ImageLabel") then
		local ImageProperty = {};

		for Key,Value in next , Property do
			if Key == "TextTransparency" then
				ImageProperty.ImageTransparency = Value;
			elseif Key == "TextColor3" then
				ImageProperty.ImageColor3 = Value;
			else
				ImageProperty[Key] = Value;
			end;
		end;

		Property = ImageProperty;
	end;

	local Tween = TweenService:Create(Self , Info or TweenInfo.new(0.25) , Property);

	Tween:Play();

	return Tween;
end);

ModernV2.Drag = LPH_NO_VIRTUALIZE(function(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;
	local Tween = TweenInfo.new(Speed);

	local updateInput = function(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		if ModernV2.Global3DRenderMode then
			ModernV2.PlayAnimate(MoveFrame,Tween,{
				Position = UDim2.fromScale(0.5,0.5)
			});
		else
			ModernV2.PlayAnimate(MoveFrame,Tween,{
				Position = position
			});
		end;
	end;

	ModernV2:AddSignal(InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true;
			dragStart = input.Position;
			startPos = MoveFrame.Position;

			local input_end;
			input_end = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false;

					input_end:Disconnect();
				end
			end)
		end
	end));

	ModernV2:AddSignal(UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end));
end);

ModernV2.Rounding = LPH_NO_VIRTUALIZE(function(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end);

ModernV2.ProcessParams = LPH_NO_VIRTUALIZE(function(self , Params , Fixed)
	Params = Params or {};

	local k = Params or {};

	for i,v in next , Fixed do
		if Params[i] == nil then
			k[i] = v;
		end;
	end;

	table.clear(Fixed);

	return k;
end);

function ModernV2:ApplyLock(Frame, isLocked, lockMessage)
	local LockFunc = {
		IsLocked = isLocked == true,
	};
	local Message = tostring(lockMessage or "Locked");
	local Destroyed = false;
	local Rebuilding = false;
	local LockOverlay;
	local LockLabel;
	local RefreshLockSize = function() end;

	pcall(function()
		Frame.ClipsDescendants = true;
	end);

	local function BuildOverlay()
		if Destroyed or not Frame or not Frame.Parent then
			return;
		end;

		if LockOverlay and LockOverlay.Parent then
			LockOverlay.Visible = LockFunc.IsLocked;
			return;
		end;

		LockOverlay = Instance.new("TextButton");
		LockOverlay.Name = "LockOverlay";
		LockOverlay.Text = "";
		LockOverlay.Size = UDim2.new(1, 0, 1, 0);
		LockOverlay.BackgroundColor3 = Color3.fromRGB(10, 8, 18);
		LockOverlay.BackgroundTransparency = 0.28;
		LockOverlay.BorderSizePixel = 0;
		LockOverlay.AutoButtonColor = false;
		LockOverlay.ClipsDescendants = false;
		LockOverlay.Visible = LockFunc.IsLocked;
		LockOverlay.ZIndex = (Frame.ZIndex or 1) + 50;
		LockOverlay.Parent = Frame;

		local UICorner = Instance.new("UICorner");
		UICorner.CornerRadius = UDim.new(0, 6);
		UICorner.Parent = LockOverlay;

		local Inner = Instance.new("Frame");
		Inner.Name = "LockInner";
		Inner.AnchorPoint = Vector2.new(0.5, 0.5);
		Inner.Position = UDim2.new(0.5, 0, 0.5, 0);
		Inner.Size = UDim2.new(0, 120, 0, 20);
		Inner.BackgroundTransparency = 1;
		Inner.ClipsDescendants = false;
		Inner.ZIndex = LockOverlay.ZIndex + 1;
		Inner.Parent = LockOverlay;

		local UIListLayout = Instance.new("UIListLayout");
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
		UIListLayout.Padding = UDim.new(0, 7);
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
		UIListLayout.Parent = Inner;

		local LockIcon = Instance.new("ImageLabel");
		LockIcon.Name = "LockIcon";
		LockIcon.Size = UDim2.new(0, 15, 0, 15);
		LockIcon.BackgroundTransparency = 1;
		LockIcon.ScaleType = Enum.ScaleType.Fit;
		LockIcon.Image = ModernV2:GetIconId("134724289526879");
		LockIcon.ImageColor3 = Color3.fromRGB(235, 235, 235);
		LockIcon.ImageTransparency = 0.05;
		LockIcon.LayoutOrder = 1;
		LockIcon.ZIndex = LockOverlay.ZIndex + 2;
		LockIcon.Parent = Inner;

		LockLabel = Instance.new("TextLabel");
		LockLabel.Name = "LockLabel";
		LockLabel.Size = UDim2.new(0, 200, 0, 20);
		LockLabel.BackgroundTransparency = 1;
		LockLabel.Font = Enum.Font.GothamBold;
		LockLabel.Text = Message;
		LockLabel.TextSize = 13;
		LockLabel.TextColor3 = Color3.fromRGB(235, 235, 235);
		LockLabel.TextTransparency = 0.05;
		LockLabel.TextXAlignment = Enum.TextXAlignment.Left;
		LockLabel.TextYAlignment = Enum.TextYAlignment.Center;
		LockLabel.TextTruncate = Enum.TextTruncate.None;
		LockLabel.TextWrapped = false;
		LockLabel.LayoutOrder = 2;
		LockLabel.ZIndex = LockOverlay.ZIndex + 2;
		LockLabel.Parent = Inner;

		RefreshLockSize = function()
			if not LockLabel or not LockLabel.Parent then
				return;
			end;

			local TextSize = TextService:GetTextSize(
				LockLabel.Text,
				LockLabel.TextSize,
				LockLabel.Font,
				Vector2.new(math.huge, 20)
			);
			local TextWidth = math.max(40, TextSize.X);
			LockLabel.Size = UDim2.new(0, TextWidth, 0, 20);
			Inner.Size = UDim2.new(0, 22 + TextWidth, 0, 20);
		end;

		RefreshLockSize();

		local FeedbackBusy = false;
		ModernV2:AddSignal(LockOverlay.MouseButton1Click:Connect(function()
			if FeedbackBusy or not LockOverlay.Parent then
				return;
			end;

			FeedbackBusy = true;
			ModernV2.PlayAnimate(LockOverlay, TweenInfo.new(0.08), {
				BackgroundTransparency = 0.18,
			});

			task.delay(0.12, function()
				if LockOverlay and LockOverlay.Parent then
					ModernV2.PlayAnimate(LockOverlay, TweenInfo.new(0.12), {
						BackgroundTransparency = 0.28,
					});
				end;

				FeedbackBusy = false;
			end);
		end));
	end;

	BuildOverlay();

	ModernV2:AddSignal(Frame.DescendantRemoving:Connect(function(desc)
		if desc == LockOverlay and LockFunc.IsLocked and not Destroyed then
			if Rebuilding then
				return;
			end;

			Rebuilding = true;
			task.defer(function()
				BuildOverlay();
				Rebuilding = false;
			end);
		end;
	end));

	ModernV2:AddSignal(Frame.AncestryChanged:Connect(function(_, newParent)
		if newParent == nil then
			Destroyed = true;
		end;
	end));

	function LockFunc:SetLocked(state)
		LockFunc.IsLocked = state == true;

		if LockFunc.IsLocked and (not LockOverlay or not LockOverlay.Parent) then
			BuildOverlay();
		end;

		if LockOverlay and LockOverlay.Parent then
			LockOverlay.Visible = LockFunc.IsLocked;
		end;

		return LockFunc;
	end;

	function LockFunc:SetTextLocked(text)
		Message = tostring(text or "Locked");

		if LockLabel and LockLabel.Parent then
			LockLabel.Text = Message;
			RefreshLockSize();
		end;

		return LockFunc;
	end;

	function LockFunc:SetMessage(text)
		return LockFunc:SetTextLocked(text);
	end;

	function LockFunc:GetLocked()
		return LockFunc.IsLocked;
	end;

	LockFunc:SetLocked(LockFunc.IsLocked);

	return LockFunc;
end;

-- Blur uses a temporary collision group and is rejected by some executors.
-- Keep the default reliable; callers can explicitly enable it if supported.
ModernV2.EnabledBlur = false;
ModernV2.BlurModuleParent = workspace.CurrentCamera;

ModernV2.GetCalculatePosition = LPH_NO_VIRTUALIZE(function(planePos, planeNormal, rayOrigin, rayDirection)
	local n = planeNormal;
	local d = rayDirection;
	local v = rayOrigin - planePos;

	local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a = -num / den;

	return rayOrigin + (a * rayDirection);
end);

ModernV2.CreateBlurModule = LPH_NO_VIRTUALIZE(function(self , Frame , Signal)
	if not ModernV2.EnabledBlur then
		return ModernV2:AddSignal(Instance.new('BindableEvent').Event:Connect(function() return "nl"; end));	
	end;

	local Part = Instance.new('Part',ModernV2.BlurModuleParent);
	local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
	local BlockMesh = Instance.new("BlockMesh");

	BlockMesh.Parent = Part;

	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	Part.CollisionGroup = ModernV2.RandomString();
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);

	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 0;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 1000;
	DepthOfField.NearIntensity = 1;
	DepthOfField.Name = ModernV2.RandomString();

	Part.Name = ModernV2.RandomString();

	local disconnect;

	local UpdateFunction = function()
		local IsWindowActive = Signal:GetValue();

		if IsWindowActive and not ModernV2.Global3DRenderMode then

			ModernV2.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 1
			})

			ModernV2.PlayAnimate(Part,TweenInfo.new(0.1),{
				Transparency = 0.97,
				Size = Vector3.new(1, 1, 1) * 0.01;
			})

			Part.Parent = ModernV2.BlurModuleParent;
		else
			ModernV2.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 0
			})

			ModernV2.PlayAnimate(Part,TweenInfo.new(0.1),{
				Size = Vector3.zero,
				Transparency = 1.5,
			})

			Part.Parent = nil;

			return false;
		end;

		if IsWindowActive then
			local corner0 = Frame.AbsolutePosition;
			local corner1 = corner0 + Frame.AbsoluteSize;

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = ModernV2.GetCalculatePosition(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = ModernV2.GetCalculatePosition(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;
		end;
	end;

	local rbxsignal = ModernV2:AddSignal(CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction))
	local loopThread = ModernV2:AddSignal(UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			pcall(UpdateFunction);
		end;
	end));

	local THREAD = task.spawn(function()
		while true do task.wait(0.1)
			pcall(UpdateFunction);
		end;
	end);

	disconnect = function()
		rbxsignal:Disconnect();
		loopThread:Disconnect();
		task.cancel(THREAD);
		Part:Destroy();
		DepthOfField:Destroy();
	end;

	Frame.Destroying:Connect(disconnect);

	return rbxsignal;
end);

local EmptyFunction = function() end;

function ModernV2:FireCallback(Callback, Context, ...)
	if type(Callback) ~= "function" then
		return true;
	end;

	local Args = table.pack(...);
	local Window = ModernV2.ActiveWindow;
	local Ok, Result = xpcall(function()
		return Callback(table.unpack(Args, 1, Args.n));
	end, (debug and debug.traceback) or tostring);

	if not Ok then
		warn(("[ModernV2] %s callback error: %s"):format(tostring(Context or "Unknown"), tostring(Result)));

		if Window and Window.NotifyOnCallbackError and Window.Notify then
			Window:Notify({
				Title = "Callback Error",
				Content = tostring(Result),
				Duration = 5,
				Icon = "lucide:triangle-alert",
			});
		end;
	end;

	return Ok, Result;
end;

-- ── CaseInsensitive ───────────────────────────────────────────────
-- Wraps any table so its methods can be called with any casing.
-- e.g. :AddButton(), :ADDBUTTON(), :adDbUtToN() all work.
-- Walks the raw table first (exact match), then falls back to a
-- lowercase scan so performance is fine for small method tables.
local function CaseInsensitive(t)
	return setmetatable(t, {
		__index = function(self, key)
			-- 1. exact key already present (fastest path, covers normal calls)
			local v = rawget(self, key);
			if v ~= nil then return v; end;

			-- 2. lowercase scan
			local lower = string.lower(tostring(key));
			for k, val in next, self do
				if string.lower(tostring(k)) == lower then
					return val;
				end;
			end;
		end;
	});
end;

function ModernV2:RollingEffect(parent)
	local UIGradient = Instance.new("UIGradient")

	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.4), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient.Parent = parent

	return UIGradient;
end;

function ModernV2:CreateShadow(parent , RollingEffect, ShadowColor, ShadowTransparency, Pulse, ThicknessScale)
	local Shadow = {};
	local shadowColor = ShadowColor or Color3.fromRGB(255, 255, 255);
	local shadowTransparency = tonumber(ShadowTransparency) or 0.900;
	local thicknessScale = tonumber(ThicknessScale) or 1;

	local UIShadowSafe85 = Instance.new("UIStroke")
	local UIShadowSafe65 = Instance.new("UIStroke")
	local UIShadowSafe50 = Instance.new("UIStroke")
	local UIShadowSafe45 = Instance.new("UIStroke")

	UIShadowSafe85.Thickness = 6.000 * thicknessScale
	UIShadowSafe85.Color = shadowColor
	UIShadowSafe85.Transparency = 1
	UIShadowSafe85.Parent = parent

	UIShadowSafe65.Thickness = 5.000 * thicknessScale
	UIShadowSafe65.Color = shadowColor
	UIShadowSafe65.Transparency = 1
	UIShadowSafe65.Parent = parent

	UIShadowSafe50.Thickness = 4.000 * thicknessScale
	UIShadowSafe50.Color = shadowColor
	UIShadowSafe50.Transparency = 1
	UIShadowSafe50.Parent = parent

	UIShadowSafe45.Thickness = 3.000 * thicknessScale
	UIShadowSafe45.Color = shadowColor
	UIShadowSafe45.Transparency = 1
	UIShadowSafe45.Parent = parent

	local RollingEffectThread;
	local PulseThread;
	local r1,r2,r3,r4;

	if RollingEffect then
		r1 = ModernV2:RollingEffect(UIShadowSafe85);
		r2 = ModernV2:RollingEffect(UIShadowSafe65);
		r3 = ModernV2:RollingEffect(UIShadowSafe50);
		r4 = ModernV2:RollingEffect(UIShadowSafe45);
	end;

	Shadow.Render = LPH_NO_VIRTUALIZE(function(self , value)
		if RollingEffectThread then
			task.cancel(RollingEffectThread);
			RollingEffectThread = nil;
		end;
		if PulseThread then
			task.cancel(PulseThread);
			PulseThread = nil;
		end;

		if value then
			ModernV2.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = shadowTransparency
			})

			ModernV2.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = shadowTransparency
			})

			ModernV2.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = shadowTransparency
			})

			ModernV2.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = shadowTransparency
			})

			if RollingEffect then
				RollingEffectThread = task.spawn(function()
					local level = 20;
					while true do task.wait(0.025)
						ModernV2.PlayAnimate(r1 , SlowyTween , {
							Rotation = r1.Rotation + level
						});

						ModernV2.PlayAnimate(r2 , SlowyTween , {
							Rotation = r2.Rotation + level
						});

						ModernV2.PlayAnimate(r3 , SlowyTween , {
							Rotation = r3.Rotation + level
						});

						ModernV2.PlayAnimate(r4 , SlowyTween , {
							Rotation = r4.Rotation + level
						});
					end;
				end);
			end;

			if Pulse then
				PulseThread = task.spawn(function()
					local pulseStrong = false;
					while true do
						task.wait(0.7);
						pulseStrong = not pulseStrong;
						local targetTransparency = pulseStrong
							and math.max(0, shadowTransparency - 0.20)
							or math.min(1, shadowTransparency + 0.08);

						ModernV2.PlayAnimate(UIShadowSafe85 , SlowyTween , {
							Transparency = targetTransparency
						});
						ModernV2.PlayAnimate(UIShadowSafe65 , SlowyTween , {
							Transparency = targetTransparency
						});
						ModernV2.PlayAnimate(UIShadowSafe50 , SlowyTween , {
							Transparency = targetTransparency
						});
						ModernV2.PlayAnimate(UIShadowSafe45 , SlowyTween , {
							Transparency = targetTransparency
						});
					end;
				end);
			end;
		else
			ModernV2.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = 1
			})
		end;
	end);

	return Shadow;
end;

function ModernV2:CreateOptionWindow(Frame: Frame , Zindex)
	Zindex = Zindex or 9;

	local Window = {
		Signal = ModernV2:CreateSignal(false),
	};

	local OptionHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIListLayout = Instance.new("UIListLayout")
	local UIStroke = Instance.new("UIStroke")
	local shadow = ModernV2:CreateShadow(OptionHandler);

	OptionHandler.Name = ModernV2.RandomString();
	OptionHandler.Parent = ModernV2.ScreenGui
	OptionHandler.AnchorPoint = Vector2.new(0, 0)
	OptionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	OptionHandler.BackgroundTransparency = 0.035
	OptionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OptionHandler.BorderSizePixel = 0
	OptionHandler.ClipsDescendants = true
	OptionHandler.Position = UDim2.new(255,255,255,255)
	OptionHandler.Size = UDim2.new(0, 220, 0, 75)
	OptionHandler.ZIndex = Zindex + 9

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = OptionHandler

	UIListLayout.Parent = OptionHandler
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = OptionHandler

	ModernV2:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
		ModernV2.PlayAnimate(OptionHandler , SlowyTween , {
			Size = UDim2.new(0, 220, 0, UIListLayout.AbsoluteContentSize.Y - 1)
		})
	end)));

	ModernV2:AddSignal(OptionHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if OptionHandler.BackgroundTransparency > 0.9 then
			OptionHandler.Visible = false;
			UIListLayout.Parent = nil;
			OptionHandler.Parent = nil;
		else
			OptionHandler.Visible = true;
			UIListLayout.Parent = OptionHandler

			if ModernV2.Global3DRenderMode then
				OptionHandler.Parent = ModernV2.GlobalSurfaceGui;
			else
				OptionHandler.Parent = ModernV2.ScreenGui;
			end;
		end
	end)));

	local FollowingThread;
	local SetPosition = LPH_NO_VIRTUALIZE(function()
		if ModernV2:MoreThanHalfY(Frame.AbsolutePosition.Y + 65) then
			OptionHandler.AnchorPoint = Vector2.new(0,1)
		else
			OptionHandler.AnchorPoint = Vector2.new(0,0)
		end;

		OptionHandler.Position = UDim2.fromOffset(Frame.AbsolutePosition.X + 18 , Frame.AbsolutePosition.Y + 65);
	end);

	Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if FollowingThread then
			task.cancel(FollowingThread);
			FollowingThread = nil;
		end;

		if value then
			SetPosition();

			ModernV2.PlayAnimate(OptionHandler , SlowyTween , {
				BackgroundTransparency = 0.035
			})

			ModernV2.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			})

			shadow:Render(true);

			if ModernV2.Global3DRenderMode then
				OptionHandler.Parent = ModernV2.GlobalSurfaceGui;
			else
				OptionHandler.Parent = ModernV2.ScreenGui;
			end;

			FollowingThread = task.spawn(function()
				while true do task.wait()
					SetPosition();
				end
			end)
		else
			ModernV2.PlayAnimate(OptionHandler , SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			shadow:Render(false);
		end;
	end);

	Window.SetRender(false);
	Window.Signal:Connect(Window.SetRender)

	local Payback = ModernV2:RegisiterItem(OptionHandler , Window.Signal);

	Payback.Winbdow = Window;
	Payback.Root = OptionHandler;
	Payback.Signal = Window.Signal;

	return Payback;
end;

function ModernV2:CreateColorPicker(HandleFrame: Frame)
	local ZIndex = HandleFrame.ZIndex;

	local ColorPickerLib = {};

	local ColorPickerHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local SaViMap = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local ColorZoneSelection = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorMap = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local ColorMapSelection = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local RGBLabel = Instance.new("TextLabel")
	local UICorner_6 = Instance.new("UICorner")
	local Shadow = ModernV2:CreateShadow(ColorPickerHandler);

	ColorPickerHandler.Name = ModernV2.RandomString();
	ColorPickerHandler.Parent = ModernV2.ScreenGui
	ColorPickerHandler.AnchorPoint = Vector2.new(0, 0)
	ColorPickerHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	ColorPickerHandler.BackgroundTransparency = 0.035
	ColorPickerHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickerHandler.BorderSizePixel = 0
	ColorPickerHandler.ClipsDescendants = true
	ColorPickerHandler.Position = UDim2.new(255, 0, 255, 20)
	ColorPickerHandler.Size = UDim2.new(0, 200, 0, 240)
	ColorPickerHandler.ZIndex = ZIndex + 125

	ModernV2:AddSignal(ColorPickerHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if ColorPickerHandler.BackgroundTransparency > 0.9 then
			ColorPickerHandler.Visible = false;
			ColorPickerHandler.Parent = nil
		else
			ColorPickerHandler.Visible = true;

			if ModernV2.Global3DRenderMode then
				ColorPickerHandler.Parent = ModernV2.GlobalSurfaceGui;
			else
				ColorPickerHandler.Parent = ModernV2.ScreenGui;
			end;
		end;
	end)));

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = ColorPickerHandler

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = ColorPickerHandler

	SaViMap.Name = ModernV2.RandomString();
	SaViMap.Parent = ColorPickerHandler
	SaViMap.AnchorPoint = Vector2.new(0.5, 0)
	SaViMap.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
	SaViMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaViMap.BorderSizePixel = 0
	SaViMap.Position = UDim2.new(0.5, 0, 0, 5)
	SaViMap.Size = UDim2.new(0, 185, 0, 185)
	SaViMap.ZIndex = ZIndex + 126
	SaViMap.Image = ModernV2.ImageColorMapping -- UNSAFE IMAGE

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = SaViMap

	ColorZoneSelection.Name = ModernV2.RandomString();
	ColorZoneSelection.Parent = SaViMap
	ColorZoneSelection.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorZoneSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorZoneSelection.BackgroundTransparency = 1.000
	ColorZoneSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorZoneSelection.BorderSizePixel = 0
	ColorZoneSelection.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorZoneSelection.Size = UDim2.new(0, 10, 0, 10)
	ColorZoneSelection.ZIndex = ZIndex + 127

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = ColorZoneSelection

	UIStroke_2.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_2.Parent = ColorZoneSelection

	ColorMap.Name = ModernV2.RandomString();
	ColorMap.Parent = ColorPickerHandler
	ColorMap.AnchorPoint = Vector2.new(0.5, 0)
	ColorMap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorMap.BorderSizePixel = 0
	ColorMap.Position = UDim2.new(0.5, 0, 0, 200)
	ColorMap.Size = UDim2.new(1, -15, 0, 10)
	ColorMap.ZIndex = ZIndex + 126

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Parent = ColorMap

	UICorner_4.CornerRadius = UDim.new(0, 3)
	UICorner_4.Parent = ColorMap

	ColorMapSelection.Name = ModernV2.RandomString();
	ColorMapSelection.Parent = ColorMap
	ColorMapSelection.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorMapSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorMapSelection.BackgroundTransparency = 1.000
	ColorMapSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorMapSelection.BorderSizePixel = 0
	ColorMapSelection.Position = UDim2.new(0, 0, 0.5, 0)
	ColorMapSelection.Size = UDim2.new(0, 5, 1, 0)
	ColorMapSelection.ZIndex = ZIndex + 126

	UIStroke_3.Thickness = 2.000
	UIStroke_3.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_3.Parent = ColorMapSelection

	UICorner_5.CornerRadius = UDim.new(0, 3)
	UICorner_5.Parent = ColorMapSelection

	RGBLabel.Name = ModernV2.RandomString();
	RGBLabel.Parent = ColorPickerHandler
	RGBLabel.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
	RGBLabel.BackgroundTransparency = 0.750
	RGBLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RGBLabel.BorderSizePixel = 0
	RGBLabel.Position = UDim2.new(0, 10, 0, 217)
	RGBLabel.Size = UDim2.new(1, -20, 0, 15)
	RGBLabel.ZIndex = ZIndex + 127
	RGBLabel.Font = Enum.Font.GothamBold
	RGBLabel.Text = "#FFFFFF"
	RGBLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	RGBLabel.TextSize = 12.000
	RGBLabel.TextTransparency = 0.400
	RGBLabel.TextXAlignment = Enum.TextXAlignment.Left

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = RGBLabel

	ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			ColorPickerHandler.Position = UDim2.new(0,HandleFrame.AbsolutePosition.X + 20 , 0 ,HandleFrame.AbsolutePosition.Y + 75);

			ModernV2.PlayAnimate(ColorPickerHandler,SlowyTween , {
				BackgroundTransparency = 0.035
			})

			ModernV2.PlayAnimate(UIStroke,SlowyTween , {
				Transparency = 0.650
			})

			ModernV2.PlayAnimate(SaViMap,SlowyTween , {
				BackgroundTransparency = 0,
				ImageTransparency = 0
			})

			ModernV2.PlayAnimate(UIStroke_2,SlowyTween , {
				Transparency = 0
			})

			ModernV2.PlayAnimate(ColorMap,SlowyTween , {
				BackgroundTransparency = 0
			})

			ModernV2.PlayAnimate(UIStroke_3,SlowyTween , {
				Transparency = 0
			})

			ModernV2.PlayAnimate(RGBLabel,SlowyTween , {
				BackgroundTransparency = 0.750,
				TextTransparency = 0.400
			})

			Shadow:Render(true)
		else
			ModernV2.PlayAnimate(ColorPickerHandler,SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(UIStroke,SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(SaViMap,SlowyTween , {
				BackgroundTransparency = 1,
				ImageTransparency = 1
			})

			ModernV2.PlayAnimate(UIStroke_2,SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(ColorMap,SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(UIStroke_3,SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(RGBLabel,SlowyTween , {
				BackgroundTransparency = 1,
				TextTransparency = 1
			})

			Shadow:Render(false)
		end;
	end);

	ColorPickerLib.SetRender(false);
	ColorPickerLib.Root = ColorPickerHandler;
	ColorPickerLib.H = 1;
	ColorPickerLib.S = 1;
	ColorPickerLib.V = 1;
	ColorPickerLib.Callback = EmptyFunction;

	function ColorPickerLib:Update()
		local RealColor = Color3.fromHSV(ColorPickerLib.H , ColorPickerLib.S , ColorPickerLib.V);

		ModernV2.PlayAnimate(ColorZoneSelection,ManualTween,{
			Position = UDim2.fromScale(ColorPickerLib.S , 1 - ColorPickerLib.V)
		});

		ModernV2.PlayAnimate(SaViMap,ManualTween,{
			BackgroundColor3 = Color3.fromHSV(ColorPickerLib.H , 1 , 1)
		});

		ModernV2.PlayAnimate(ColorMapSelection,ManualTween,{
			Position = UDim2.fromScale(ColorPickerLib.H,0.5)
		});

		RGBLabel.Text = "#"..RealColor:ToHex();

		ColorPickerLib.Callback(RealColor);
	end;

	function ColorPickerLib:SetValue(Color)
		if typeof(Color) == 'string' then
			Color = Color3.fromHex(Color);
		end;

		local H , S , V = Color:ToHSV();

		ColorPickerLib.H = H;
		ColorPickerLib.S = S;
		ColorPickerLib.V = V;

		ColorPickerLib:Update();
	end;

	ColorPickerLib.IsHold = false;

	ModernV2:AddSignal(ColorPickerHandler.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;
		end;
	end));

	ModernV2:AddSignal(ColorPickerHandler.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = false;
		end;
	end));

	ModernV2:AddSignal(ColorMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait()
				local ColorY = ColorMap.AbsolutePosition.X
				local ColorYM = ColorY + ColorMap.AbsoluteSize.X;
				local Value = math.clamp(Mouse.X, ColorY, ColorYM)
				local Code = ((Value - ColorY) / (ColorYM - ColorY));

				ColorPickerLib.H = Code;
				ColorPickerLib:Update();
			end;
		end;
	end)));

	ModernV2:AddSignal(SaViMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait();
				local PosX = SaViMap.AbsolutePosition.X;
				local ScaleX = PosX + SaViMap.AbsoluteSize.X;
				local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), SaViMap.AbsolutePosition.Y;
				local ScaleY = PosY + SaViMap.AbsoluteSize.Y;
				local Vals = math.clamp(Mouse.Y, PosY, ScaleY);

				ColorPickerLib.S = (Value - PosX) / (ScaleX - PosX);
				ColorPickerLib.V = (1 - ((Vals - PosY) / (ScaleY - PosY)));
				ColorPickerLib:Update();
			end
		end
	end)));

	return ColorPickerLib;
end;

ModernV2.KeyEnum = {
	One = '1',
	Two = '2',
	Three = '3',
	Four = '4',
	Five = '5',
	Six = '6',
	Seven = '7',
	Eight = '8',
	Nine = '9',
	Zero = '0',
	['Minus'] = "-",
	['Plus'] = "+",
	BackSlash = "\\",
	Slash = "/",
	Period = '.',
	Semicolon = ';',
	Colon = ":",
	LeftControl = "LCtrl",
	RightControl = "RCtrl",
	LeftShift = "LShift",
	RightShift = "RShift",
	Return = "Enter",
	LeftBracket = "[",
	RightBracket = "]",
	Quote = "'",
	Comma = ",",
	Equals = "=",
	LeftSuper = "Super",
	RightSuper = "Super",
	LeftAlt = "LAlt",
	RightAlt = "RAlt",
	Escape = "Esc",
};

ModernV2.EnumReverse = {};

for i,v in next , ModernV2.KeyEnum do
	ModernV2.EnumReverse[v] = i;
end;

function ModernV2:NormalizeKeybindValue(K)
	if K == nil then
		return "None";
	end;

	if typeof(K) == "EnumItem" then
		return K.Name;
	end;

	if typeof(K) == "table" and K.Name ~= nil then
		return tostring(K.Name);
	end;

	return tostring(K);
end;

function ModernV2:KeyCodeToStr(K: Enum.KeyCode)
	local KeyName = ModernV2:NormalizeKeybindValue(K);

	if ModernV2.KeyEnum[KeyName] then
		return ModernV2.KeyEnum[KeyName];
	end;

	return KeyName;
end;

function ModernV2:StrToKeyCode(str: string)
	str = ModernV2:NormalizeKeybindValue(str);

	if ModernV2.EnumReverse[str] then
		return Enum.KeyCode[ModernV2.EnumReverse[str]];
	end;

	return Enum.KeyCode[str] or Enum.KeyCode.Unknown;
end;

function ModernV2:RegisiterHandler(Handler: Frame , Signal)
	local handle = {};
	local ZINdex = Handler.ZIndex;

	function handle:AddToggle(Config)
		Config = ModernV2:ProcessParams(Config , {
			Name = nil,
			Default = false,
			Type = "Switch",
			Icon = "check",
			Flag = nil,
			Key = nil,
			ConfigKey = nil,
			Locked = false,
			TextLocked = "Locked",
			Callback = EmptyFunction,
		});
		ModernV2:ResolveConfigFlag(Config);

		local IsCheckbox = string.lower(tostring(Config.Type)) == "checkbox";
		local Toggle = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Circle = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local CheckboxIcon = Instance.new("ImageLabel")
		local UIStroke = Instance.new("UIStroke")

		Toggle.Name = ModernV2.RandomString();
		Toggle.Parent = Handler
		Toggle.BackgroundColor3 = Color3.fromRGB(10, 13, 21)
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.ClipsDescendants = true
		Toggle.Size = IsCheckbox and UDim2.new(0, 18, 0, 18) or UDim2.new(0, 30, 0, 18)
		Toggle.ZIndex = ZINdex + 13
		Toggle.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = IsCheckbox and UDim.new(0, 4) or UDim.new(1, 0)
		UICorner.Parent = Toggle

		UIStroke.Transparency = IsCheckbox and 0.650 or 1
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Toggle

		Circle.Name = ModernV2.RandomString();
		Circle.Parent = Toggle
		Circle.AnchorPoint = Vector2.new(0.5, 0.5)
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 0.500
		Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Circle.BorderSizePixel = 0
		Circle.Position = UDim2.new(0.300000012, 0, 0.5, 0)
		Circle.Size = IsCheckbox and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 16, 0, 16)
		Circle.Visible = not IsCheckbox
		Circle.ZIndex = ZINdex + 14

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = Circle

		CheckboxIcon.Name = ModernV2.RandomString();
		CheckboxIcon.Parent = Toggle
		CheckboxIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		CheckboxIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CheckboxIcon.BackgroundTransparency = 1.000
		CheckboxIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CheckboxIcon.BorderSizePixel = 0
		CheckboxIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		CheckboxIcon.Size = UDim2.new(1, -4, 1, -4)
		CheckboxIcon.Visible = IsCheckbox
		CheckboxIcon.ZIndex = ZINdex + 14
		CheckboxIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		CheckboxIcon.ImageTransparency = 1
		CheckboxIcon.ScaleType = Enum.ScaleType.Fit
		ModernV2:SetIconMode(CheckboxIcon, Config.Icon or "check")

		local ToggleLib = {
			Root = Toggle	
		};
		ModernV2:AttachLockMethods(ToggleLib, self.Root or Toggle, Config);

		ToggleLib.SetUI = LPH_NO_VIRTUALIZE(function(value)
			if IsCheckbox then
				if value then
					ModernV2.PlayAnimate(Toggle,SlowyTween,{
						BackgroundTransparency = 0,
						BackgroundColor3 = ModernV2.AccentColor
					})

					ModernV2.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 1
					})

					ModernV2.PlayAnimate(CheckboxIcon,SlowyTween,{
						TextTransparency = 0
					})
				else
					ModernV2.PlayAnimate(Toggle,SlowyTween,{
						BackgroundTransparency = 0,
						BackgroundColor3 = Color3.fromRGB(10, 13, 21)
					})

					ModernV2.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.650
					})

					ModernV2.PlayAnimate(CheckboxIcon,SlowyTween,{
						TextTransparency = 1
					})
				end;
			elseif value then
				ModernV2.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 0,
					BackgroundColor3 = ModernV2.AccentColor
				})

				ModernV2.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0,
					Position = UDim2.new(0.7, 0, 0.5, 0)
				})
			else
				ModernV2.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(10, 13, 21)
				})

				ModernV2.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.500,
					Position = UDim2.new(0.300000012, 0, 0.5, 0)
				})
			end;
		end);

		ToggleLib.SetVisible = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ToggleLib.SetUI(Config.Default);
			else
				ModernV2.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(10, 13, 21)
				})

				ModernV2.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.300000012, 0, 0.5, 0)
				})

				ModernV2.PlayAnimate(UIStroke,SlowyTween,{
					Transparency = 1
				})

				ModernV2.PlayAnimate(CheckboxIcon,SlowyTween,{
					TextTransparency = 1
				})
			end;
		end);

		ToggleLib.SetUI(Config.Default);
		ToggleLib.SetVisible(Signal:GetValue());

		ModernV2:CreateInput(Toggle , LPH_NO_VIRTUALIZE(function()
			Config.Default = not Config.Default;

			ToggleLib.SetUI(Config.Default);

			ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default)
		end))

		ToggleLib.Signal = Signal:Connect(ToggleLib.SetVisible);

		function ToggleLib:GetValue()
			return Config.Default;
		end;

		function ToggleLib:SetValue(v)
			Config.Default = v == true;

			if Signal:GetValue() then
				ToggleLib.SetUI(Config.Default);
			end;

			ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default)
			return ToggleLib;
		end;

		function ToggleLib:Toggle()
			ToggleLib:SetValue(not Config.Default);
			return ToggleLib;
		end;

		function ToggleLib:On()
			ToggleLib:SetValue(true);
			return ToggleLib;
		end;

		function ToggleLib:Off()
			ToggleLib:SetValue(false);
			return ToggleLib;
		end;

		function ToggleLib:SetCallback(fn)
			Config.Callback = fn or EmptyFunction;
			return ToggleLib;
		end;

		function ToggleLib:SetIcon(icon)
			Config.Icon = icon or Config.Icon;
			if IsCheckbox then
				ModernV2:SetIconMode(CheckboxIcon, Config.Icon);
			end;
			return ToggleLib;
		end;

		function ToggleLib:SetEnabled(value)
			Toggle.Visible = value ~= false;
			return ToggleLib;
		end;

		if Config.Flag then
			ModernV2:RegisterFlag(Config.Flag, ToggleLib);
		end;

		return CaseInsensitive(ToggleLib);
	end;

	function handle:AddSlider(Config)
		Config = ModernV2:ProcessParams(Config , {
			Name = nil,
			Default = 50,
			Min = 0,
			Max = 10,
			Type = "",
			Rounding = 0,
			Nums = {},
			Flag = nil,
			Key = nil,
			ConfigKey = nil,
			Locked = false,
			TextLocked = "Locked",
			Size = 125,
			Tooltip = false,
			Callback = EmptyFunction,
		});
		ModernV2:ResolveConfigFlag(Config);

		local SliderLib = {};

		SliderLib.GetSize = LPH_NO_VIRTUALIZE(function()
			return (Config.Default - Config.Min) / (Config.Max - Config.Min);
		end);

		local FullNumSize = TextService:GetTextSize(string.rep("0",(Config.Rounding + #tostring(Config.Max))+1)..tostring(Config.Type),10,Enum.Font.GothamMedium,Vector2.new(math.huge,math.huge));

		SliderLib.MaximumSize = FullNumSize.X;

		if Config.Nums then
			local nszie = 0;

			for i,ns in next , Config.Nums do
				local size = TextService:GetTextSize(string.rep("m",string.len(tostring(ns))),10,Enum.Font.GothamMedium,Vector2.new(math.huge,math.huge));

				if nszie < size.X then
					nszie = size.X;
				end
			end;

			if SliderLib.MaximumSize < nszie then
				SliderLib.MaximumSize = nszie;
			end;
		end;

		local Slider = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local ValueFrame = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ValueLabel = Instance.new("TextBox")
		local SlideMain = Instance.new("Frame")
		local SlideFrame = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local SlideMoving = Instance.new("Frame")
		local UICorner_4 = Instance.new("UICorner")
		local Frame = Instance.new("Frame")
		local UICorner_5 = Instance.new("UICorner")
		local boxSize = 2;
		local valueGap = 5;
		local TooltipEnabled = Config.Tooltip == true;
		local TooltipFrame;
		local TooltipCorner;
		local TooltipStroke;
		local TooltipLabel;

		Slider.Name = ModernV2.RandomString();
		Slider.Parent = Handler
		Slider.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Slider.BackgroundTransparency = 1.000
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.ClipsDescendants = false
		Slider.Size = UDim2.new(0, Config.Size, 0, 18)
		Slider.ZIndex = ZINdex + 13
		Slider.LayoutOrder = -(#Handler:GetChildren() + 5);
		ModernV2:AttachLockMethods(SliderLib, self.Root or Slider, Config);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Slider

		ValueFrame.Name = ModernV2.RandomString();
		ValueFrame.Parent = Slider
		ValueFrame.AnchorPoint = Vector2.new(1, 0)
		ValueFrame.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.ClipsDescendants = true
		ValueFrame.Position = UDim2.new(1, 0, 0, 0)
		ValueFrame.Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, 18)
		ValueFrame.ZIndex = ZINdex + 13

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = ValueFrame

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = ValueFrame

		ValueLabel.Name = ModernV2.RandomString();
		ValueLabel.Parent = ValueFrame
		ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueLabel.BorderSizePixel = 0
		ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueLabel.Size = UDim2.new(1, 0, 1, 0)
		ValueLabel.ZIndex = ZINdex + 14
		ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.TextSize = 10.000
		ValueLabel.ClearTextOnFocus = false;
		ValueLabel.TextTransparency = 0.350

		SlideMain.Name = ModernV2.RandomString();
		SlideMain.Parent = Slider
		SlideMain.AnchorPoint = Vector2.new(0, 0.5)
		SlideMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SlideMain.BackgroundTransparency = 1.000
		SlideMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideMain.BorderSizePixel = 0
		SlideMain.Position = UDim2.new(0, 0, 0.5, 0)
		SlideMain.Size = UDim2.new(1, -((SliderLib.MaximumSize + boxSize + valueGap)), 0, 18)
		SlideMain.ZIndex = ZINdex + 13

		SlideFrame.Name = ModernV2.RandomString();
		SlideFrame.Parent = SlideMain
		SlideFrame.AnchorPoint = Vector2.new(0, 0.5)
		SlideFrame.BackgroundColor3 = Color3.fromRGB(30, 29, 36)
		SlideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideFrame.BorderSizePixel = 0
		SlideFrame.Position = UDim2.new(0, 0, 0.5, 0)
		SlideFrame.Size = UDim2.new(1, 0, 0, 5)
		SlideFrame.ZIndex = ZINdex + 13

		UICorner_3.CornerRadius = UDim.new(1, 0)
		UICorner_3.Parent = SlideFrame

		SlideMoving.Name = ModernV2.RandomString();
		SlideMoving.Parent = SlideFrame
		SlideMoving.BackgroundColor3 = ModernV2.AccentColor
		SlideMoving.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideMoving.BorderSizePixel = 0
		SlideMoving.Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
		SlideMoving.ZIndex = ZINdex + 14

		UICorner_4.CornerRadius = UDim.new(1, 0)
		UICorner_4.Parent = SlideMoving

		Frame.Parent = SlideMoving
		Frame.AnchorPoint = Vector2.new(1, 0.5)
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(1, 5, 0.5, 0)
		Frame.Size = UDim2.new(0, 10, 0, 10)
		Frame.ZIndex = ZINdex + 15

		UICorner_5.CornerRadius = UDim.new(1, 0)
		UICorner_5.Parent = Frame

		local function EnsureSliderTooltip()
			if TooltipFrame then
				return;
			end;

			TooltipFrame = Instance.new("Frame");
			TooltipFrame.Name = ModernV2.RandomString();
			TooltipFrame.Parent = ModernV2.ScreenGui;
			TooltipFrame.AnchorPoint = Vector2.new(0.5, 1);
			TooltipFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27);
			TooltipFrame.BackgroundTransparency = 1;
			TooltipFrame.BorderSizePixel = 0;
			TooltipFrame.ClipsDescendants = true;
			TooltipFrame.Position = UDim2.fromOffset(0, 0);
			TooltipFrame.Size = UDim2.fromOffset(40, 22);
			TooltipFrame.Visible = false;
			TooltipFrame.ZIndex = ZINdex + 200;

			TooltipCorner = Instance.new("UICorner");
			TooltipCorner.CornerRadius = UDim.new(0, 5);
			TooltipCorner.Parent = TooltipFrame;

			TooltipStroke = Instance.new("UIStroke");
			TooltipStroke.Color = Color3.fromRGB(45, 48, 58);
			TooltipStroke.Transparency = 1;
			TooltipStroke.Parent = TooltipFrame;

			TooltipLabel = Instance.new("TextLabel");
			TooltipLabel.Name = ModernV2.RandomString();
			TooltipLabel.Parent = TooltipFrame;
			TooltipLabel.BackgroundTransparency = 1;
			TooltipLabel.BorderSizePixel = 0;
			TooltipLabel.Position = UDim2.fromOffset(6, 0);
			TooltipLabel.Size = UDim2.new(1, -12, 1, 0);
			TooltipLabel.ZIndex = TooltipFrame.ZIndex + 1;
			TooltipLabel.Font = Enum.Font.GothamMedium;
			TooltipLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
			TooltipLabel.TextSize = 11;
			TooltipLabel.TextTransparency = 1;
			TooltipLabel.TextXAlignment = Enum.TextXAlignment.Center;
		end;

		local function UpdateSliderTooltip()
			if not TooltipFrame or not TooltipLabel then
				return;
			end;

			TooltipLabel.Text = ValueLabel.Text;
			local TextSize = TextService:GetTextSize(TooltipLabel.Text, TooltipLabel.TextSize, TooltipLabel.Font, Vector2.new(math.huge, math.huge));
			TooltipFrame.Size = UDim2.fromOffset(math.max(34, TextSize.X + 14), 22);
			TooltipFrame.Position = UDim2.fromOffset(Frame.AbsolutePosition.X + (Frame.AbsoluteSize.X / 2), Frame.AbsolutePosition.Y - 2);
		end;

		local function SetSliderTooltipRender(value)
			if not TooltipEnabled or not value then
				if TooltipFrame then
					ModernV2.PlayAnimate(TooltipFrame, SlowyTween, {
						BackgroundTransparency = 1,
					});
					ModernV2.PlayAnimate(TooltipStroke, SlowyTween, {
						Transparency = 1,
					});
					ModernV2.PlayAnimate(TooltipLabel, SlowyTween, {
						TextTransparency = 1,
					});
					task.delay(0.18, function()
						if TooltipFrame and TooltipFrame.BackgroundTransparency > 0.95 then
							TooltipFrame.Visible = false;
						end;
					end);
				end;

				return;
			end;

			EnsureSliderTooltip();
			UpdateSliderTooltip();
			TooltipFrame.Visible = true;

			ModernV2.PlayAnimate(TooltipFrame, SlowyTween, {
				BackgroundTransparency = 0.075,
			});
			ModernV2.PlayAnimate(TooltipStroke, SlowyTween, {
				Transparency = 0.650,
			});
			ModernV2.PlayAnimate(TooltipLabel, SlowyTween, {
				TextTransparency = 0.200,
			});
		end;

		local LoadText = LPH_NO_VIRTUALIZE(function()
			if Config.Nums[Config.Default] then
				ValueLabel.Text = Config.Nums[Config.Default]

			else
				ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);

			end;

			UpdateSliderTooltip();
		end);

		ValueLabel.FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
			local OutVal = ModernV2:ParseInput(ValueLabel.Text , true);
			if OutVal then
				local rx = math.clamp(OutVal , Config.Min , Config.Max);
				local Value = ModernV2.Rounding(rx,Config.Rounding);

				if Value then
					Config.Default = Value;

					TweenService:Create(SlideMoving , ManualTween ,{
						Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
					}):Play();

					LoadText();

					ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default)
				else
					LoadText();
				end;

			else
				LoadText()
			end;
		end));

		SliderLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(ValueFrame,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, 18)
				});

				ModernV2.PlayAnimate(UIStroke,SlowyTween,{
					Transparency = 0.650
				});

				ModernV2.PlayAnimate(ValueLabel,SlowyTween,{
					TextTransparency = 0.350
				});

				ModernV2.PlayAnimate(SlideFrame,SlowyTween,{
					BackgroundTransparency = 0
				});

				ModernV2.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
				});

				ModernV2.PlayAnimate(Frame,SlowyTween,{
					BackgroundTransparency = 0
				});
			else
				SetSliderTooltipRender(false);

				ModernV2.PlayAnimate(ValueFrame,SlowyTween,{
					BackgroundTransparency = 1,
				});

				ModernV2.PlayAnimate(UIStroke,SlowyTween,{
					Transparency = 1
				});

				ModernV2.PlayAnimate(ValueLabel,SlowyTween,{
					TextTransparency = 1
				});

				ModernV2.PlayAnimate(SlideFrame,SlowyTween,{
					BackgroundTransparency = 1
				});

				ModernV2.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 1, 0)
				});

				ModernV2.PlayAnimate(Frame,SlowyTween,{
					BackgroundTransparency = 1
				});
			end;
		end);

		SliderLib.SetRender(Signal:GetValue());
		SliderLib.Signal = Signal:Connect(SliderLib.SetRender);

		local Update = function(Input)
			local SizeScale = math.clamp((((Input.Position.X) - SlideMain.AbsolutePosition.X) / SlideMain.AbsoluteSize.X), 0, 1);
			local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min;
			local Value = ModernV2.Rounding(Main,Config.Rounding);
			local PositionX = UDim2.fromScale(SizeScale, 1);
			local Size = ((Value - Config.Min) / (Config.Max - Config.Min)) + 0.02;

			Config.Default = Value;

			TweenService:Create(SlideMoving , ManualTween ,{
				Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
			}):Play();

			LoadText()


			ModernV2:FireCallback(Config.Callback, Config.Name, Value)
		end;

		local IsHold = false;

		do
			ModernV2:AddSignal(SlideMain.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
				SetSliderTooltipRender(true);
			end)));

			ModernV2:AddSignal(SlideMain.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
				if not IsHold then
					SetSliderTooltipRender(false);
				end;
			end)));

			SlideMain.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsHold = true
					Update(Input)
					SetSliderTooltipRender(true);
				end
			end))

			SlideMain.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if UserInputService.TouchEnabled then
						if not ModernV2:IsMouseOverFrame(SlideMain) then
							IsHold = false
						end;
					else
						IsHold = false
					end;

					if not IsHold and not ModernV2:IsMouseOverFrame(SlideMain) then
						SetSliderTooltipRender(false);
					end;
				end
			end))

			UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if IsHold then
					if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
						if UserInputService.TouchEnabled then
							if not ModernV2:IsMouseOverFrame(SlideMain) then
								IsHold = false
							else
								Update(Input)
								UpdateSliderTooltip();
							end;
						else
							Update(Input)
							UpdateSliderTooltip();
						end;
					end;
				end;
			end));
		end;

		function SliderLib:GetValue()
			return Config.Default;
		end;

		function SliderLib:SetValue(v)
			local NumericValue = tonumber(v);
			if not NumericValue then
				return SliderLib;
			end;

			Config.Default = ModernV2.Rounding(math.clamp(NumericValue, Config.Min, Config.Max),Config.Rounding);

			if Signal:GetValue() then
				ModernV2.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
				});
			end;

			LoadText()

			ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default);
			return SliderLib;
		end;

		function SliderLib:SetRange(min,max)
			Config.Min = tonumber(min) or Config.Min;
			Config.Max = tonumber(max) or Config.Max;

			if Config.Min > Config.Max then
				Config.Min, Config.Max = Config.Max, Config.Min;
			end;

			SliderLib:SetValue(Config.Default);
			return SliderLib;
		end;

		function SliderLib:SetMin(min)
			return SliderLib:SetRange(min,Config.Max);
		end;

		function SliderLib:SetMax(max)
			return SliderLib:SetRange(Config.Min,max);
		end;

		function SliderLib:SetCallback(fn)
			Config.Callback = fn or EmptyFunction;
			return SliderLib;
		end;

		function SliderLib:SetSuffix(suffix)
			Config.Type = tostring(suffix or "");
			LoadText();
			return SliderLib;
		end;

		function SliderLib:SetTooltip(value)
			TooltipEnabled = value == true;
			Config.Tooltip = TooltipEnabled;

			if not TooltipEnabled then
				SetSliderTooltipRender(false);
			end;

			return SliderLib;
		end;

		function SliderLib:SetEnabled(value)
			Slider.Visible = value ~= false;
			return SliderLib;
		end;

		if Config.Flag then
			ModernV2:RegisterFlag(Config.Flag, SliderLib);
		end;

		return CaseInsensitive(SliderLib);
	end;

	function handle:AddOption(GearIcon)
		local Option = Instance.new("Frame")
		local Icon = Instance.new("ImageLabel")
		local UICorner = Instance.new("UICorner")

		Option.Name = ModernV2.RandomString();
		Option.Parent = Handler
		Option.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
		Option.BackgroundTransparency = 1.000
		Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Option.BorderSizePixel = 0
		Option.ClipsDescendants = true
		Option.Size = UDim2.new(0, 20, 0, 18)
		Option.ZIndex = ZINdex + 13
		Option.LayoutOrder = -(#Handler:GetChildren() + 5);

		Icon.Name = ModernV2.RandomString();
		Icon.Parent = Option
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Icon.Size = UDim2.new(1, 0, 1, 0)
		Icon.ZIndex = ZINdex + 14
		ModernV2:SetIconMode(Icon, (GearIcon == 1 and 'gear') or (GearIcon == 2 and 'chevron-large-right') or "three-dots-horizontal");
		Icon.ImageColor3 = Color3.fromRGB(223, 223, 223)
		Icon.ImageTransparency = 0.400
		Icon.ScaleType = Enum.ScaleType.Fit

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Option

		local Window = ModernV2:CreateOptionWindow(Option , ZINdex + 13);
		local reciveSignal;

		Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.400
				})
			else
				ModernV2.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				})
			end;
		end);

		Window.SetRender(Signal:GetValue());
		Signal:Connect(Window.SetRender);

		local bthg = ModernV2:CreateInput(Option , LPH_NO_VIRTUALIZE(function()
			if reciveSignal then
				reciveSignal:Disconnect();
				reciveSignal = nil;	
			end;

			Window.Signal:SetValue(true);

			reciveSignal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not ModernV2:IsMouseOverFrame(Window.Root) and not ModernV2:IsMouseOverFrame(Option) then
						if reciveSignal then
							reciveSignal:Disconnect();
							reciveSignal = nil;	
						end;

						Window.Signal:SetValue(false);
					end
				end
			end)
		end));

		ModernV2:AddSignal(bthg.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(Option , SlowyTween , {
				BackgroundTransparency = 0.5
			})

			ModernV2.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.25
			})
		end)));

		ModernV2:AddSignal(bthg.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(Option , SlowyTween , {
				BackgroundTransparency = 1.000
			})

			ModernV2.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.400
			})
		end)));

		return CaseInsensitive(Window);
	end;

	function handle:AddColorPicker(Config)
		Config = ModernV2:ProcessParams(Config , {
			Name = nil,
			Default = Color3.fromRGB(255, 255, 255),
			Flag = nil,
			Key = nil,
			ConfigKey = nil,
			Locked = false,
			TextLocked = "Locked",
			Callback  = EmptyFunction,
		});
		ModernV2:ResolveConfigFlag(Config);

		if typeof(Config.Default) == 'string' then
			Config.Default = Color3.fromHex(Config.Default:gsub('#',''));
		end;

		local ColorPickerLib = {};
		local ColorPicker = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ImageLabel = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")

		ColorPicker.Name = ModernV2.RandomString();
		ColorPicker.Parent = Handler
		ColorPicker.BackgroundColor3 = Config.Default;
		ColorPicker.BackgroundTransparency = 0
		ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker.BorderSizePixel = 0
		ColorPicker.ClipsDescendants = true
		ColorPicker.Size = UDim2.new(0, 18, 0, 18)
		ColorPicker.ZIndex = ZINdex + 13
		ModernV2:AttachLockMethods(ColorPickerLib, self.Root or ColorPicker, Config);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = ColorPicker

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = ColorPicker

		ImageLabel.Parent = ColorPicker
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Size = UDim2.new(1, 0, 1, 0)
		ImageLabel.ZIndex = ZINdex + 11
		ImageLabel.Image = "rbxasset://textures/meshPartFallback.png"
		ImageLabel.ImageTransparency = 0.9
		ImageLabel.BackgroundTransparency = 1;
		ImageLabel.ScaleType = Enum.ScaleType.Crop

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = ImageLabel

		local BackendM = ModernV2:CreateColorPicker(ColorPicker);

		BackendM:SetValue(Config.Default)
		BackendM.Callback = function(color)
			ColorPicker.BackgroundColor3 = color;
			Config.Default = color;
			ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default);
		end;

		local signal;
		ModernV2:CreateInput(ColorPicker , LPH_NO_VIRTUALIZE(function()
			if signal then
				signal:Disconnect();
				signal = nil;
			end;

			BackendM.SetRender(true);

			signal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not ModernV2:IsMouseOverFrame(ColorPicker) and not ModernV2:IsMouseOverFrame(BackendM.Root) then
						if signal then
							signal:Disconnect();
							signal = nil;
						end;

						BackendM.SetRender(false);
					end;
				end;
			end)
		end));

		ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(ColorPicker , SlowyTween , {
					BackgroundTransparency = 0
				})

				ModernV2.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 0.650
				})

				ModernV2.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = 0.9
				})
			else
				ModernV2.PlayAnimate(ColorPicker , SlowyTween , {
					BackgroundTransparency = 1
				})

				ModernV2.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				})

				ModernV2.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = 1
				})
			end;
		end);

		ColorPickerLib.SetRender(Signal:GetValue());
		Signal:Connect(ColorPickerLib.SetRender);

		function ColorPickerLib:GetValue()
			return Config.Default;
		end;

		function ColorPickerLib:SetValue(v)
			Config.Default = v;
			BackendM:SetValue(Config.Default)
			return ColorPickerLib;
		end;

		function ColorPickerLib:GetHex()
			return Config.Default:ToHex();
		end;

		function ColorPickerLib:SetHex(hex)
			ColorPickerLib:SetValue(Color3.fromHex(tostring(hex):gsub("#","")));
			return ColorPickerLib;
		end;

		function ColorPickerLib:SetCallback(fn)
			Config.Callback = fn or EmptyFunction;
			BackendM.Callback = function(color)
				ColorPicker.BackgroundColor3 = color;
				Config.Default = color;
				ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default);
			end;
			return ColorPickerLib;
		end;

		function ColorPickerLib:SetEnabled(value)
			ColorPicker.Visible = value ~= false;
			return ColorPickerLib;
		end;

		if Config.Flag then
			ModernV2:RegisterFlag(Config.Flag, ColorPickerLib);
		end;

		return CaseInsensitive(ColorPickerLib);
	end;

	function handle:AddKeybind(Config)
		Config = ModernV2:ProcessParams(Config,{
			Name = nil,
			Default = nil,
			Mode = "Toggle",
			ModeFlag = nil,
			ChangedCallback = nil,
			ModeChangedCallback = nil,
			Blacklist = {},
			Callback = EmptyFunction,
			Flag = nil,
			Key = nil,
			ConfigKey = nil,
			Locked = false,
			TextLocked = "Locked",
		});
		ModernV2:ResolveConfigFlag(Config);
		Config.Default = ModernV2:NormalizeKeybindValue(Config.Default);
		Config.Mode = string.lower(tostring(Config.Mode or "Toggle")) == "hold" and "Hold" or "Toggle";
		Config.ChangedCallback = Config.ChangedCallback or Config.OnChanged or EmptyFunction;
		Config.ModeChangedCallback = Config.ModeChangedCallback or Config.OnModeChanged or EmptyFunction;
		local ModeFlag = Config.ModeFlag or Config.ModeKey or Config.ModeConfigKey;
		if ModeFlag ~= nil then
			Config.ModeFlag = tostring(ModeFlag);
		end;

		local KeybindLib = {};
		local ToggleState = false;
		local HoldState = false;

		local Keybind = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ValueLabel = Instance.new("TextLabel")

		Keybind.Name = ModernV2.RandomString();
		Keybind.Parent = Handler
		Keybind.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind.BorderSizePixel = 0
		Keybind.ClipsDescendants = true
		Keybind.Size = UDim2.new(0, 45, 0, 18)
		Keybind.ZIndex = ZINdex + 13
		ModernV2:AttachLockMethods(KeybindLib, self.Root or Keybind, Config);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Keybind

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Keybind

		ValueLabel.Name = ModernV2.RandomString();
		ValueLabel.Parent = Keybind
		ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueLabel.BorderSizePixel = 0
		ValueLabel.ClipsDescendants = true
		ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueLabel.Size = UDim2.new(1, 0, 1, 0)
		ValueLabel.ZIndex = ZINdex + 14
		ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.Text = ModernV2:KeyCodeToStr(Config.Default or "None")
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.TextSize = 10.000
		ValueLabel.TextTransparency = 0.500

		KeybindLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(Keybind,SlowyTween, {
					BackgroundTransparency = 0
				})

				ModernV2.PlayAnimate(UIStroke,SlowyTween, {
					Transparency = 0.650
				})

				ModernV2.PlayAnimate(ValueLabel,SlowyTween, {
					TextTransparency = 0.500
				})
			else
				ModernV2.PlayAnimate(Keybind,SlowyTween, {
					BackgroundTransparency = 1
				})

				ModernV2.PlayAnimate(UIStroke,SlowyTween, {
					Transparency = 1
				})

				ModernV2.PlayAnimate(ValueLabel,SlowyTween, {
					TextTransparency = 1
				})
			end;
		end);

		function KeybindLib:Update()
			local size = TextService:GetTextSize(ValueLabel.Text,ValueLabel.TextSize,ValueLabel.Font,Vector2.new(math.huge,math.huge));

			ModernV2.PlayAnimate(Keybind , SlowyTween , {
				Size = UDim2.new(0, size.X + 7, 0, 18)
			})
		end;

		local IsBlacklist = LPH_NO_VIRTUALIZE(function(v)
			return Config.Blacklist and (Config.Blacklist[v] or table.find(Config.Blacklist,v))
		end);

		KeybindLib:Update()

		KeybindLib.SetRender(Signal:GetValue());
		Signal:Connect(KeybindLib.SetRender);

		local IsBinding = false;
		local function FireAction(state)
			ModernV2:FireCallback(Config.Callback, Config.Name, state, Config.Default, Config.Mode);
		end;

		local function IsSameKey(Input)
			if not Config.Default or Config.Default == "None" then
				return false;
			end;

			if Config.Default == "M1B" then
				return Input.UserInputType == Enum.UserInputType.MouseButton1;
			elseif Config.Default == "M2B" then
				return Input.UserInputType == Enum.UserInputType.MouseButton2;
			end;

			local KeyCode = ModernV2:StrToKeyCode(Config.Default);
			return KeyCode and Input.KeyCode == KeyCode;
		end;

		ModernV2:CreateInput(Keybind , function()
			if IsBinding then
				return;
			end;

			IsBinding = true;

			ValueLabel.Text = "...";

			KeybindLib:Update();

			local Selected = nil;

			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown and not IsBlacklist(Key.KeyCode) and not IsBlacklist(Key.KeyCode.Name) then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 and not IsBlacklist(Enum.UserInputType.MouseButton1) and not IsBlacklist("M1B") then
						Selected = "M1B";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 and not IsBlacklist(Enum.UserInputType.MouseButton2) and not IsBlacklist("M2B") then
						Selected = "M2B";
					end;
				end;
			end;

			IsBinding = false;

			local KeyName = ModernV2:NormalizeKeybindValue(Selected);

			Config.Default = KeyName;

			ValueLabel.Text = ModernV2:KeyCodeToStr(KeyName);

			KeybindLib:Update();

			ModernV2:FireCallback(Config.ChangedCallback, Config.Name, KeyName);
			ModernV2:FireCallback(Config.Callback, Config.Name, KeyName, "Changed", Config.Mode);
		end)

		ModernV2:AddSignal(UserInputService.InputBegan:Connect(function(Input, IsTyping)
			if IsTyping or IsBinding or (KeybindLib.GetLocked and KeybindLib:GetLocked()) then
				return;
			end;

			if not IsSameKey(Input) then
				return;
			end;

			if Config.Mode == "Hold" then
				if not HoldState then
					HoldState = true;
					FireAction(true);
				end;
			else
				ToggleState = not ToggleState;
				FireAction(ToggleState);
			end;
		end))

		ModernV2:AddSignal(UserInputService.InputEnded:Connect(function(Input)
			if Config.Mode ~= "Hold" or not HoldState or not IsSameKey(Input) then
				return;
			end;

			HoldState = false;
			FireAction(false);
		end))

		function KeybindLib:GetValue()
			return Config.Default;
		end;

		function KeybindLib:SetValue(v)
			Config.Default = ModernV2:NormalizeKeybindValue(v);
			ValueLabel.Text = ModernV2:KeyCodeToStr(Config.Default);
			KeybindLib:Update();
			ModernV2:FireCallback(Config.ChangedCallback, Config.Name, Config.Default);
			ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default, "Changed", Config.Mode);
			return KeybindLib;
		end;

		function KeybindLib:SetMode(mode)
			local NextMode = string.lower(tostring(mode or "Toggle")) == "hold" and "Hold" or "Toggle";
			if Config.Mode == NextMode then
				return KeybindLib;
			end;

			if HoldState then
				HoldState = false;
				FireAction(false);
			end;

			Config.Mode = NextMode;
			ToggleState = false;
			ModernV2:FireCallback(Config.ModeChangedCallback, Config.Name, Config.Mode);
			return KeybindLib;
		end;

		function KeybindLib:GetMode()
			return Config.Mode;
		end;

		function KeybindLib:GetActionState()
			return Config.Mode == "Hold" and HoldState or ToggleState;
		end;

		function KeybindLib:SetCallback(fn)
			Config.Callback = fn or EmptyFunction;
			return KeybindLib;
		end;

		function KeybindLib:SetBlacklist(list)
			Config.Blacklist = list or {};
			return KeybindLib;
		end;

		function KeybindLib:GetKeyCode()
			return ModernV2:StrToKeyCode(Config.Default);
		end;

		function KeybindLib:SetEnabled(value)
			Keybind.Visible = value ~= false;
			return KeybindLib;
		end;

		if Config.Flag then
			ModernV2:RegisterFlag(Config.Flag, KeybindLib);
		end;

		if Config.ModeFlag then
			ModernV2:RegisterFlag(Config.ModeFlag, {
				GetValue = function()
					return KeybindLib:GetMode();
				end,
				SetValue = function(_, value)
					return KeybindLib:SetMode(value);
				end,
			});
		end;

		return CaseInsensitive(KeybindLib);
	end;

	function handle:AddTextInput(Config)
		Config = ModernV2:ProcessParams(Config , {
			Name = nil,
			Default = "",
			Placeholder = "Placeholder",
			Callback = print,
			Flag = nil,
			Key = nil,
			ConfigKey = nil,
			Locked = false,
			TextLocked = "Locked",
			Size = 100,
			Height = nil,
			Type = "TextInput",
			Numeric = false,
			FullWidth = false,
		});
		ModernV2:ResolveConfigFlag(Config);
		local IsTextarea = string.lower(tostring(Config.Type or "TextInput")) == "textarea";
		if IsTextarea then
			Config.Numeric = false;
		end;
		local InputHeight = Config.Height or (IsTextarea and 72 or 18);
		local GetInputSize = LPH_NO_VIRTUALIZE(function()
			if Config.FullWidth then
				return UDim2.new(1, 0, 0, InputHeight);
			end;

			return UDim2.new(0, Config.Size, 0, InputHeight);
		end);

		local TextBoxLib = {};

		local TextInput = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")

		TextInput.Name = ModernV2.RandomString();
		TextInput.Parent = Handler
		TextInput.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput.BorderSizePixel = 0
		TextInput.ClipsDescendants = true
		TextInput.Size = GetInputSize()
		TextInput.ZIndex = ZINdex + 13
		ModernV2:AttachLockMethods(TextBoxLib, self.Root or TextInput, Config);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = TextInput

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = TextInput

		TextBox.Parent = TextInput
		TextBox.AnchorPoint = IsTextarea and Vector2.new(0, 0) or Vector2.new(0, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = IsTextarea and UDim2.new(0, 6, 0, 5) or UDim2.new(0, 5, 0.5, 0)
		TextBox.Size = IsTextarea and UDim2.new(1, -12, 1, -10) or UDim2.new(1, -5, 0, 17)
		TextBox.ZIndex = ZINdex + 14
		TextBox.ClearTextOnFocus = false
		TextBox.Font = Enum.Font.GothamMedium
		TextBox.PlaceholderText = Config.Placeholder
		TextBox.Text = tostring(Config.Default)
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 11.000
		TextBox.TextTransparency = 0.350
		TextBox.TextXAlignment = Enum.TextXAlignment.Left
		TextBox.TextYAlignment = IsTextarea and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
		TextBox.TextWrapped = IsTextarea
		TextBox.MultiLine = IsTextarea

		TextBoxLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(TextInput , SlowyTween ,{
					BackgroundTransparency = 0
				})	

				ModernV2.PlayAnimate(UIStroke , SlowyTween ,{
					Transparency = 0.650
				})	

				ModernV2.PlayAnimate(TextBox , SlowyTween ,{
					TextTransparency = 0.350
				})	
			else
				ModernV2.PlayAnimate(TextInput , SlowyTween ,{
					BackgroundTransparency = 1
				})	

				ModernV2.PlayAnimate(UIStroke , SlowyTween ,{
					Transparency = 1
				})	

				ModernV2.PlayAnimate(TextBox , SlowyTween ,{
					TextTransparency = 1
				})
			end;
		end);

		ModernV2:AddSignal(TextBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
			local valout = ModernV2:ParseInput(TextBox.Text , Config.Numeric);

			if Config.Numeric then
				TextBox.Text = string.gsub(TextBox.Text , '[^0-9.]','')
			end;

			if valout then
				Config.Default = valout;
				ModernV2:FireCallback(Config.Callback, Config.Name, valout);
			end
		end)));

		TextBoxLib.SetRender(Signal:GetValue());
		Signal:Connect(TextBoxLib.SetRender);

		function TextBoxLib:GetValue()
			return Config.Default;
		end;

		function TextBoxLib:SetValue(v)
			Config.Default = v;
			TextBox.Text = tostring(v);
			ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default);
			return TextBoxLib;
		end;

		function TextBoxLib:Clear()
			TextBoxLib:SetValue("");
			return TextBoxLib;
		end;

		function TextBoxLib:SetPlaceholder(text)
			Config.Placeholder = tostring(text or "");
			TextBox.PlaceholderText = Config.Placeholder;
			return TextBoxLib;
		end;

		function TextBoxLib:SetNumeric(value)
			Config.Numeric = value == true;
			if Config.Numeric then
				Config.Type = "TextInput";
				TextBoxLib:SetType("TextInput");
			end;
			return TextBoxLib;
		end;

		function TextBoxLib:SetType(inputType)
			Config.Type = tostring(inputType or "TextInput");
			IsTextarea = string.lower(Config.Type) == "textarea";
			if IsTextarea then
				Config.Numeric = false;
			end;

			InputHeight = Config.Height or (IsTextarea and 72 or 18);
			TextInput.Size = GetInputSize();
			TextBox.AnchorPoint = IsTextarea and Vector2.new(0, 0) or Vector2.new(0, 0.5);
			TextBox.Position = IsTextarea and UDim2.new(0, 6, 0, 5) or UDim2.new(0, 5, 0.5, 0);
			TextBox.Size = IsTextarea and UDim2.new(1, -12, 1, -10) or UDim2.new(1, -5, 0, 17);
			TextBox.TextYAlignment = IsTextarea and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center;
			TextBox.TextWrapped = IsTextarea;
			TextBox.MultiLine = IsTextarea;
			return TextBoxLib;
		end;

		function TextBoxLib:SetHeight(height)
			Config.Height = tonumber(height) or Config.Height;
			InputHeight = Config.Height or (IsTextarea and 72 or 18);
			TextInput.Size = GetInputSize();
			return TextBoxLib;
		end;

		function TextBoxLib:SetCallback(fn)
			Config.Callback = fn or EmptyFunction;
			return TextBoxLib;
		end;

		function TextBoxLib:Focus()
			TextBox:CaptureFocus();
			return TextBoxLib;
		end;

		function TextBoxLib:SetEnabled(value)
			TextInput.Visible = value ~= false;
			return TextBoxLib;
		end;

		if Config.Flag then
			ModernV2:RegisterFlag(Config.Flag, TextBoxLib);
		end;

		return CaseInsensitive(TextBoxLib);
	end;

	-- Alias: :AddInput() → same as :AddTextInput()
	handle.AddInput = handle.AddTextInput;

	function handle:AddDropdown(Config)
		Config = ModernV2:ProcessParams(Config , {
			Name = nil,
			Default = nil,
			Values = {},
			Multi = false,
			Callback = EmptyFunction,
			AutoUpdate = false,
			Flag = nil,
			Key = nil,
			ConfigKey = nil,
			Locked = false,
			TextLocked = "Locked",
			Size = 100,
			Search = true,
			Position = "Dropdown",
			Placement = nil,
			DropdownPosition = nil,
			PopupPosition = nil,
			OptionsIcon = {},
			DisabledOptions = {},
			AllowNil = false,
			AutoSelectFirst = false,
			ValidateValue = true,
			RefreshInterval = nil,
			OptionsProvider = nil,
		})
		ModernV2:ResolveConfigFlag(Config);

		Config.Default = ModernV2.ProcessDropdown(Config.Default);
		Config.OptionsIcon = Config.OptionsIcon or Config.OptionIcons or Config.Icons or {};
		Config.DisabledOptions = Config.DisabledOptions or Config.Disabled or {};
		Config.AllowNil = Config.AllowNil == true;
		Config.AutoSelectFirst = Config.AutoSelectFirst == true;
		Config.ValidateValue = Config.ValidateValue ~= false;
		Config.DropdownPosition = Config.DropdownPosition or Config.PopupPosition or Config.Placement or Config.Position;

		local function NormalizeOptionMap(source)
			local Map = {};

			if typeof(source) == "string" or typeof(source) == "number" then
				Map[tostring(source)] = true;
				return Map;
			end;

			if typeof(source) ~= "table" then
				return Map;
			end;

			for key,value in next, source do
				if typeof(key) == "number" then
					Map[tostring(value)] = true;
				elseif value == true then
					Map[tostring(key)] = true;
				end;
			end;

			return Map;
		end;

		local function NormalizeIconMap(source)
			local Map = {};

			if typeof(source) ~= "table" then
				return Map;
			end;

			for key,value in next, source do
				if typeof(key) ~= "number" and value ~= nil then
					Map[tostring(key)] = value;
				elseif typeof(value) == "table" and value.Value and value.Icon then
					Map[tostring(value.Value)] = value.Icon;
				end;
			end;

			return Map;
		end;

		local DisabledMap = NormalizeOptionMap(Config.DisabledOptions);
		local IconMap = NormalizeIconMap(Config.OptionsIcon);
		local function GetFirstDropdownValue()
			for _,Value in next, Config.Values do
				return Value;
			end;
		end;

		local function HasDropdownValue(value)
			for _,Option in next, Config.Values do
				if Option == value then
					return true;
				end;
			end;

			return false;
		end;

		local function ResolveSingleDropdownValue(value)
			if value == nil then
				if Config.AutoSelectFirst then
					return GetFirstDropdownValue();
				end;

				return nil;
			end;

			if Config.ValidateValue and not HasDropdownValue(value) then
				if Config.AutoSelectFirst then
					return GetFirstDropdownValue();
				end;

				return nil;
			end;

			return value;
		end;

		local function ShouldFireDropdownCallback(value)
			return Config.Multi or value ~= nil or Config.AllowNil;
		end;

		local function ResolveMultiDropdownValue(value)
			local Processed = ModernV2.ProcessDropdown(value);

			if typeof(Processed) == "table" then
				return Processed;
			end;

			if Processed ~= nil then
				return {
					[Processed] = true,
				};
			end;

			return {};
		end;

		if Config.Multi then
			Config.Default = ResolveMultiDropdownValue(Config.Default);
		else
			Config.Default = ResolveSingleDropdownValue(Config.Default);
		end;

		local Dropdown = Instance.new("Frame")
		local DropdownIcon = Instance.new("ImageLabel")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local BasedLabel = Instance.new("TextLabel")

		Dropdown.Name = ModernV2.RandomString();
		Dropdown.Parent = Handler
		Dropdown.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.ClipsDescendants = true
		Dropdown.Size = UDim2.new(0, Config.Size, 0, 18)
		Dropdown.ZIndex = ZINdex + 13

		DropdownIcon.Name = ModernV2.RandomString();
		DropdownIcon.Parent = Dropdown
		DropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
		DropdownIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DropdownIcon.BackgroundTransparency = 1.000
		DropdownIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownIcon.BorderSizePixel = 0
		DropdownIcon.Position = UDim2.new(1, -2, 0.5, 0)
		DropdownIcon.Size = UDim2.new(0, 18, 0, 18)
		DropdownIcon.ZIndex = ZINdex + 14
		ModernV2:SetIconMode(DropdownIcon, "chevron-small-down")
		DropdownIcon.ImageColor3 = Color3.fromRGB(223, 223, 223)
		DropdownIcon.ImageTransparency = 0.250
		DropdownIcon.ScaleType = Enum.ScaleType.Fit

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Dropdown

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Dropdown

		BasedLabel.Name = ModernV2.RandomString();
		BasedLabel.Parent = Dropdown
		BasedLabel.AnchorPoint = Vector2.new(0, 0.5)
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.ClipsDescendants = true
		BasedLabel.Position = UDim2.new(0, 5, 0.5, 0)
		BasedLabel.Size = UDim2.new(1, -25, 0, 15)
		BasedLabel.ZIndex = ZINdex + 14
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = ModernV2.ParseDropdown(Config.Default);
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 12.000
		BasedLabel.TextTransparency = 0.5
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		do
			local UIGradient = Instance.new("UIGradient")

			UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.85, 0.23), NumberSequenceKeypoint.new(1.00, 1.00)}
			UIGradient.Parent = BasedLabel;
		end;

		ModernV2:AddSignal(Dropdown.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.200
			})
		end)));

		ModernV2:AddSignal(Dropdown.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.5
			})
		end)));

		local DropdownLib = {
			OpenSignal = ModernV2:CreateSignal(false),
			Signals = {},
			Refuse = {},
			Items = {},
		};
		ModernV2:AttachLockMethods(DropdownLib, self.Root or Dropdown, Config);

		DropdownLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(Dropdown , SlowyTween , {
					BackgroundTransparency = 0
				});

				ModernV2.PlayAnimate(DropdownIcon , SlowyTween , {
					TextTransparency = 0.250
				});

				ModernV2.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 0.650
				});

				ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.5
				});
			else
				ModernV2.PlayAnimate(Dropdown , SlowyTween , {
					BackgroundTransparency = 1
				});

				ModernV2.PlayAnimate(DropdownIcon , SlowyTween , {
					TextTransparency = 1
				});

				ModernV2.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				});

				ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				});
			end
		end);

		DropdownLib.SetRender(Signal:GetValue())
		Signal:Connect(DropdownLib.SetRender);
		DropdownLib.ExtentSize = 0;

		do
			local DropdownHandler = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local SearchInput = Instance.new("Frame")
			local SearchCorner = Instance.new("UICorner")
			local SearchStroke = Instance.new("UIStroke")
			local SearchIcon = Instance.new("ImageLabel")
			local SearchBox = Instance.new("TextBox")
			local DropdownScrollFrame = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")
			local Shadow = ModernV2:CreateShadow(DropdownHandler);

			DropdownHandler.Name = ModernV2.RandomString();
			DropdownHandler.Parent = ModernV2.ScreenGui;
			DropdownHandler.AnchorPoint = Vector2.new(0.5, 0)
			DropdownHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
			DropdownHandler.BackgroundTransparency = 0.5
			DropdownHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownHandler.BorderSizePixel = 0
			DropdownHandler.ClipsDescendants = true
			DropdownHandler.Position = UDim2.new(255,255,255,255)
			DropdownHandler.Size = UDim2.new(0, 125, 0, 50)
			DropdownHandler.ZIndex = ZINdex + 125
			DropdownLib.BlockRoot = DropdownHandler;

			ModernV2:AddSignal(DropdownHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
				if DropdownHandler.BackgroundTransparency > 0.9 then
					DropdownHandler.Visible = false;
					DropdownHandler.Parent = nil;
				else
					DropdownHandler.Visible = true;

					if ModernV2.Global3DRenderMode then
						DropdownHandler.Parent = ModernV2.GlobalSurfaceGui;
					else
						DropdownHandler.Parent = ModernV2.ScreenGui;
					end;
				end;
			end));

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = DropdownHandler

			UIStroke.Transparency = 0.650
			UIStroke.Color = Color3.fromRGB(45, 48, 58)
			UIStroke.Parent = DropdownHandler

			SearchInput.Name = ModernV2.RandomString();
			SearchInput.Parent = DropdownHandler
			SearchInput.AnchorPoint = Vector2.new(0.5, 0)
			SearchInput.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
			SearchInput.BackgroundTransparency = 0.250
			SearchInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SearchInput.BorderSizePixel = 0
			SearchInput.ClipsDescendants = true
			SearchInput.Position = UDim2.new(0.5, 0, 0, 5)
			SearchInput.Size = UDim2.new(1, -10, 0, 26)
			SearchInput.Visible = Config.Search == true
			SearchInput.ZIndex = ZINdex + 127

			SearchCorner.CornerRadius = UDim.new(0, 5)
			SearchCorner.Parent = SearchInput

			SearchStroke.Transparency = 0.650
			SearchStroke.Color = Color3.fromRGB(45, 48, 58)
			SearchStroke.Parent = SearchInput

			SearchIcon.Name = ModernV2.RandomString();
			SearchIcon.Parent = SearchInput
			SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
			SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SearchIcon.BackgroundTransparency = 1.000
			SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SearchIcon.BorderSizePixel = 0
			SearchIcon.Position = UDim2.new(0, 4, 0.5, 0)
			SearchIcon.Size = UDim2.new(0, 20, 0, 20)
			SearchIcon.ZIndex = ZINdex + 128
			ModernV2:SetIconMode(SearchIcon, "magnifying-glass")
			SearchIcon.ImageColor3 = Color3.fromRGB(223, 223, 223)
			SearchIcon.ImageTransparency = 0.450
			SearchIcon.ScaleType = Enum.ScaleType.Fit

			SearchBox.Name = ModernV2.RandomString();
			SearchBox.Parent = SearchInput
			SearchBox.AnchorPoint = Vector2.new(0, 0.5)
			SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SearchBox.BackgroundTransparency = 1.000
			SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SearchBox.BorderSizePixel = 0
			SearchBox.ClearTextOnFocus = false
			SearchBox.PlaceholderText = "Search"
			SearchBox.Position = UDim2.new(0, 26, 0.5, 0)
			SearchBox.Size = UDim2.new(1, -31, 0, 20)
			SearchBox.ZIndex = ZINdex + 128
			SearchBox.Font = Enum.Font.GothamMedium
			SearchBox.Text = ""
			SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			SearchBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 155)
			SearchBox.TextSize = 12.000
			SearchBox.TextTransparency = 0.250
			SearchBox.TextXAlignment = Enum.TextXAlignment.Left

			DropdownScrollFrame.Name = ModernV2.RandomString();
			DropdownScrollFrame.Parent = DropdownHandler
			DropdownScrollFrame.Active = true
			DropdownScrollFrame.AnchorPoint = Vector2.new(0.5, 0)
			DropdownScrollFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownScrollFrame.BackgroundTransparency = 1.000
			DropdownScrollFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownScrollFrame.BorderSizePixel = 0
			DropdownScrollFrame.Position = Config.Search and UDim2.new(0.5, 0, 0, 35) or UDim2.new(0.5, 0, 0, 2)
			DropdownScrollFrame.Size = Config.Search and UDim2.new(1, -5, 1, -38) or UDim2.new(1, -5, 1, -5)
			DropdownScrollFrame.ZIndex = ZINdex + 127
			DropdownScrollFrame.ScrollBarThickness = 0

			DropdownLib.RootItem = DropdownScrollFrame;

			UIListLayout.Parent = DropdownScrollFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local GetSearchOffset = LPH_NO_VIRTUALIZE(function()
				return (Config.Search == true and 35) or 5;
			end);

			local UpdateDropdownSize = LPH_NO_VIRTUALIZE(function()
				local ContentHeight = math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250);

				DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
				ModernV2.PlayAnimate(DropdownHandler , SlowyTween , {
					Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, ContentHeight + GetSearchOffset());
				})
			end);

			DropdownLib.ApplySearch = LPH_NO_VIRTUALIZE(function()
				local Query = string.lower(SearchBox.Text or "");

				for _,Item in next , DropdownLib.Items do
					if Item.Root then
						if Query == "" then
							Item.Root.Visible = true;
						else
							Item.Root.Visible = string.find(string.lower(Item.Text), Query, 1, true) ~= nil;
						end;
					end;
				end;

				UpdateDropdownSize();
			end);

			ModernV2:AddSignal(SearchBox:GetPropertyChangedSignal("Text"):Connect(LPH_NO_VIRTUALIZE(function()
				DropdownLib.ApplySearch();
			end)));

			ModernV2:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
				UpdateDropdownSize();
			end)));

			local GetDropdownWindowRoot = LPH_NO_VIRTUALIZE(function()
				local Current = Dropdown;

				while Current and Current.Parent do
					if Current.Parent == ModernV2.ScreenGui
					or (ModernV2.GlobalSurfaceGui and Current.Parent == ModernV2.GlobalSurfaceGui) then
						return Current;
					end;

					Current = Current.Parent;
				end;

				if ModernV2.ActiveWindow and ModernV2.ActiveWindow.Root then
					return ModernV2.ActiveWindow.Root;
				end;
			end);

			local SetPosition = LPH_NO_VIRTUALIZE(function()
				local Placement = string.lower(tostring(Config.DropdownPosition or "Dropdown"));

				if Placement == "center" or Placement == "middle" then
					local WindowRoot = GetDropdownWindowRoot();

					DropdownHandler.AnchorPoint = Vector2.new(0.5, 0.5);

					if WindowRoot and WindowRoot.Parent then
						DropdownHandler.Position = UDim2.fromOffset(
							WindowRoot.AbsolutePosition.X + (WindowRoot.AbsoluteSize.X / 2),
							WindowRoot.AbsolutePosition.Y + (WindowRoot.AbsoluteSize.Y / 2)
						);
					else
						DropdownHandler.Position = UDim2.fromOffset(
							ModernV2.ScreenGui.AbsoluteSize.X / 2,
							ModernV2.ScreenGui.AbsoluteSize.Y / 2
						);
					end;

					return;
				end;

				if ModernV2:MoreThanHalfY(Dropdown.AbsolutePosition.Y + 85) then
					DropdownHandler.AnchorPoint = Vector2.new(0.5,1)
				else
					DropdownHandler.AnchorPoint = Vector2.new(0.5,0)
				end;

				DropdownHandler.Position = UDim2.fromOffset(Dropdown.AbsolutePosition.X + (DropdownHandler.AbsoluteSize.X / 2), Dropdown.AbsolutePosition.Y + 85);

			end);

			DropdownLib.SetFrameRender = LPH_NO_VIRTUALIZE(function(value)
				DropdownLib.OpenSignal:SetValue(value);

				if value then
					Shadow:Render(true);

					if Config.Search then
						SearchBox.Text = "";
					end;

					DropdownHandler.Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250) + GetSearchOffset());

					SetPosition();

					ModernV2.PlayAnimate(DropdownHandler , SlowyTween , {
						BackgroundTransparency = 0.035
					})

					ModernV2.PlayAnimate(SearchInput , SlowyTween , {
						BackgroundTransparency = Config.Search and 0.250 or 1
					})

					ModernV2.PlayAnimate(SearchStroke , SlowyTween , {
						Transparency = Config.Search and 0.650 or 1
					})

					ModernV2.PlayAnimate(SearchIcon , SlowyTween , {
						TextTransparency = Config.Search and 0.450 or 1
					})

					ModernV2.PlayAnimate(SearchBox , SlowyTween , {
						TextTransparency = Config.Search and 0.250 or 1
					})

					if Config.AutoUpdate then
						DropdownLib:Generate();
					end;
				else

					ModernV2.PlayAnimate(DropdownHandler , SlowyTween , {
						BackgroundTransparency = 1
					})

					SearchBox:ReleaseFocus();

					ModernV2.PlayAnimate(SearchInput , SlowyTween , {
						BackgroundTransparency = 1
					})

					ModernV2.PlayAnimate(SearchStroke , SlowyTween , {
						Transparency = 1
					})

					ModernV2.PlayAnimate(SearchIcon , SlowyTween , {
						TextTransparency = 1
					})

					ModernV2.PlayAnimate(SearchBox , SlowyTween , {
						TextTransparency = 1
					})

					Shadow:Render(false);
				end;
			end);

			DropdownLib.SetFrameRender(false);
		end;

		local SecureSignal;
		ModernV2:CreateInput(Dropdown , LPH_NO_VIRTUALIZE(function()
			if SecureSignal then
				SecureSignal:Disconnect();
				SecureSignal = nil;
			end;

			DropdownLib.SetFrameRender(true);
			ModernV2.IsMosueOverOtherFrame = true;

			SecureSignal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not ModernV2:IsMouseOverFrame(DropdownLib.BlockRoot) and not ModernV2:IsMouseOverFrame(Dropdown) then
						if SecureSignal then
							SecureSignal:Disconnect();
							SecureSignal = nil;
						end;

						ModernV2.IsMosueOverOtherFrame = false;
						DropdownLib.SetFrameRender(false);
					end;
				end
			end)
		end))

		DropdownLib.IsMatch = LPH_NO_VIRTUALIZE(function(v1)
			if typeof(Config.Default) =='table' then
				if Config.Default[v1] == true then
					return true;
				end

				for _, Value in next, Config.Default do
					if Value == v1 then
						return true;
					end;
				end;
			end

			if Config.Default == v1 then
				return true;
			end;
		end);

		function DropdownLib:Generate()
			for i,v in next , DropdownLib.RootItem:GetChildren() do
				if v:IsA('Frame') then
					v:Destroy();
				end;
			end;

			for i,v in next , DropdownLib.Signals do
				v:Disconnect();
			end;

			table.clear(DropdownLib.Signals);
			table.clear(DropdownLib.Refuse);
			table.clear(DropdownLib.Items);
			DropdownLib.ExtentSize = 0;
			DisabledMap = NormalizeOptionMap(Config.DisabledOptions);
			IconMap = NormalizeIconMap(Config.OptionsIcon);

			local Lastone;
			for i,Value in next , Config.Values do
				local ItemFrame = Instance.new("Frame")
				local ItemLabel = Instance.new("TextLabel")
				local UICorner = Instance.new("UICorner")
				local OptionIcon = nil;
				local ValueKey = tostring(Value);
				local IsDisabled = DisabledMap[ValueKey] == true;
				local CustomIcon = IconMap[ValueKey];

				ItemFrame.Name = ModernV2.RandomString();
				ItemFrame.Parent = DropdownLib.RootItem
				ItemFrame.BackgroundColor3 = Color3.fromRGB(29, 31, 38)
				ItemFrame.BackgroundTransparency = 1.000
				ItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ItemFrame.BorderSizePixel = 0
				ItemFrame.Size = UDim2.new(1, 0, 0, 25)
				ItemFrame.ZIndex = ZINdex + 1258

				ItemLabel.Name = ModernV2.RandomString();
				ItemLabel.Parent = ItemFrame
				ItemLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ItemLabel.BackgroundTransparency = 1.000
				ItemLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ItemLabel.BorderSizePixel = 0
				ItemLabel.Position = UDim2.new(0, CustomIcon and (Config.Multi and 50 or 34) or 15, 0, 4)
				ItemLabel.Size = UDim2.new(0,1, 0, 15)
				ItemLabel.ZIndex = ZINdex + 1258
				ItemLabel.Font = Enum.Font.GothamMedium
				ItemLabel.Text = tostring(Value);
				ItemLabel.TextColor3 = IsDisabled and Color3.fromRGB(140, 140, 155) or Color3.fromRGB(255, 255, 255)
				ItemLabel.TextSize = 13.000
				ItemLabel.TextTransparency = IsDisabled and 0.600 or 0.200
				ItemLabel.TextXAlignment = Enum.TextXAlignment.Left

				UICorner.CornerRadius = UDim.new(0, 10)
				UICorner.Parent = ItemFrame

				if CustomIcon then
					OptionIcon = Instance.new("ImageLabel")
					OptionIcon.Parent = ItemFrame
					OptionIcon.AnchorPoint = Vector2.new(0, 0.5)
					OptionIcon.BackgroundTransparency = 1
					OptionIcon.BorderSizePixel = 0
					OptionIcon.Position = UDim2.new(0, Config.Multi and 29 or 13, 0.5, 0)
					OptionIcon.Size = UDim2.new(0, 15, 0, 15)
					OptionIcon.ZIndex = ZINdex + 1259
					ModernV2:SetIconMode(OptionIcon, CustomIcon)
					OptionIcon.ImageColor3 = IsDisabled and Color3.fromRGB(120, 120, 135) or Color3.fromRGB(223, 223, 223)
					OptionIcon.ImageTransparency = IsDisabled and 0.650 or 0.300
					OptionIcon.ScaleType = Enum.ScaleType.Fit
				end;

				local sizetext = TextService:GetTextSize(ItemLabel.Text , ItemLabel.TextSize,ItemLabel.Font,Vector2.new(math.huge,math.huge));

				DropdownLib.ExtentSize = math.max(DropdownLib.ExtentSize , sizetext.X + (CustomIcon and 20 or 0));
				table.insert(DropdownLib.Items , {
					Root = ItemFrame,
					Text = tostring(Value),
					Disabled = IsDisabled,
				});

				local MIcon , MarkItem = nil , nil;

				if Config.Multi then
					local Icon = Instance.new("ImageLabel")

					Icon.Parent = ItemFrame;
					Icon.AnchorPoint = Vector2.new(0, 0.5)
					Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Icon.BackgroundTransparency = 1.000
					Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Icon.BorderSizePixel = 0
					Icon.Position = UDim2.new(0, 5, 0.5, 0)
					Icon.Size = UDim2.new(0, 20, 0, 20)
					Icon.ZIndex = ZINdex + 1259
					ModernV2:SetIconMode(Icon, "check")
					Icon.ImageColor3 = Color3.fromRGB(223, 223, 223)
					Icon.ImageTransparency = 1
					Icon.ScaleType = Enum.ScaleType.Fit

					local VisiblewOfMult = LPH_NO_VIRTUALIZE(function()
						if DropdownLib.IsMatch(Value) then
							ModernV2.PlayAnimate(ItemLabel , VSlowTween , {
								TextTransparency = IsDisabled and 0.600 or 0.200,
								Position = UDim2.new(0, CustomIcon and 50 or 30, 0, 4)
							})

							ModernV2.PlayAnimate(Icon , SlowyTween , {
								TextTransparency = IsDisabled and 0.650 or 0.250
							})
							local FallbackText = Icon:FindFirstChild("ModernIconFallbackText");
							if FallbackText then
								FallbackText.TextTransparency = 0.250;
							end;

							Lastone = ItemLabel;
						else

							ModernV2.PlayAnimate(Icon , SlowyTween , {
								TextTransparency = 1
							})
							local FallbackText = Icon:FindFirstChild("ModernIconFallbackText");
							if FallbackText then
								FallbackText.TextTransparency = 1;
							end;

							ModernV2.PlayAnimate(ItemLabel , VSlowTween , {
								TextTransparency = IsDisabled and 0.650 or 0.5,
								Position = UDim2.new(0, CustomIcon and (Config.Multi and 50 or 34) or 15, 0, 4)
							})
						end;
					end);

					MIcon = Icon;
					MarkItem = VisiblewOfMult;
				else
					local DefaultVisible = LPH_NO_VIRTUALIZE(function()
						if DropdownLib.IsMatch(Value) then
							ModernV2.PlayAnimate(ItemLabel , SlowyTween , {
								TextTransparency = IsDisabled and 0.600 or 0.200
							})

							Lastone = ItemLabel;
						else
							ModernV2.PlayAnimate(ItemLabel , SlowyTween , {
								TextTransparency = IsDisabled and 0.650 or 0.5
							})
						end;
					end);

					MarkItem = DefaultVisible;
				end;

				MarkItem();

				table.insert(DropdownLib.Refuse , MarkItem)

				table.insert(DropdownLib.Signals,ItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					if IsDisabled then
						return;
					end;

					ModernV2.PlayAnimate(ItemFrame , SlowyTween , {
						BackgroundTransparency = 0.1
					})
				end)));

				table.insert(DropdownLib.Signals,ItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					ModernV2.PlayAnimate(ItemFrame , SlowyTween , {
						BackgroundTransparency = 1
					})
				end)));

				table.insert(DropdownLib.Signals , DropdownLib.OpenSignal:Connect(LPH_NO_VIRTUALIZE(function(val)
					if val then
						MarkItem();
						if OptionIcon then
							ModernV2.PlayAnimate(OptionIcon, SlowyTween, {
								TextTransparency = IsDisabled and 0.650 or 0.300
							})
						end;
					else
						ModernV2.PlayAnimate(ItemLabel , SlowyTween , {
							TextTransparency = 1
						})

						if OptionIcon then
							ModernV2.PlayAnimate(OptionIcon, SlowyTween, {
								TextTransparency = 1
							})
						end;

						if MIcon then
							ModernV2.PlayAnimate(MIcon , SlowyTween , {
								TextTransparency = 1
							})
							local FallbackText = MIcon:FindFirstChild("ModernIconFallbackText");
							if FallbackText then
								FallbackText.TextTransparency = 1;
							end;
						end;
					end;
				end)));

				if Config.Multi then
					local _,bth_signal = ModernV2:CreateInput(ItemFrame , LPH_NO_VIRTUALIZE(function()
						if IsDisabled then
							return;
						end;

						Config.Default[Value] = not Config.Default[Value];

						MarkItem();

						BasedLabel.Text = ModernV2.ParseDropdown(Config.Default);

						ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default);
					end));

					table.insert(DropdownLib.Signals , bth_signal);
				else
					local _,bth_signal = ModernV2:CreateInput(ItemFrame , LPH_NO_VIRTUALIZE(function()
						if IsDisabled then
							return;
						end;

						Config.Default = Value;

						for i,v in next , DropdownLib.Refuse do
							task.spawn(v);
						end;

						BasedLabel.Text = ModernV2.ParseDropdown(Config.Default);

						ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default);
					end));

					table.insert(DropdownLib.Signals , bth_signal);
				end;
			end;

			if DropdownLib.ApplySearch then
				DropdownLib.ApplySearch();
			end;
		end;

		DropdownLib:Generate();

		if type(Config.OptionsProvider) == "function" and tonumber(Config.RefreshInterval) then
			local Accumulator = 0;
			local Interval = math.max(tonumber(Config.RefreshInterval) or 1, 0.1);

			DropdownLib.RefreshSignal = ModernV2:AddSignal(RunService.RenderStepped:Connect(function(dt)
				if not Dropdown or not Dropdown.Parent then
					if DropdownLib.RefreshSignal then
						DropdownLib.RefreshSignal:Disconnect();
						DropdownLib.RefreshSignal = nil;
					end;
					return;
				end;

				Accumulator += dt or 0;

				if Accumulator < Interval then
					return;
				end;

				Accumulator = 0;

				local ok, values = pcall(Config.OptionsProvider);
				if ok and typeof(values) == "table" then
					Config.Values = values;
					if not Config.Multi then
						Config.Default = ResolveSingleDropdownValue(Config.Default);
						BasedLabel.Text = ModernV2.ParseDropdown(Config.Default);
					end;
					DropdownLib:Generate();
				end;
			end));
		end;

		function DropdownLib:GetValue()
			return Config.Default;
		end;

		function DropdownLib:SetValue(v)
			Config.Default = Config.Multi and ResolveMultiDropdownValue(v) or ResolveSingleDropdownValue(v);

			BasedLabel.Text = ModernV2.ParseDropdown(Config.Default);

			for i,v in next , DropdownLib.Refuse do
				task.spawn(v);
			end;

			if ShouldFireDropdownCallback(Config.Default) then
				ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default);
			end;

			return DropdownLib;
		end;

		function DropdownLib:SetValues(a)
			Config.Values = a or {};

			if not Config.Multi then
				Config.Default = ResolveSingleDropdownValue(Config.Default);
				BasedLabel.Text = ModernV2.ParseDropdown(Config.Default);
			end;

			if not Config.AutoUpdate then
				DropdownLib:Generate();
			end;
			return DropdownLib;
		end;

		function DropdownLib:SetDisabledOptions(disabledOptions)
			Config.DisabledOptions = disabledOptions or {};
			DisabledMap = NormalizeOptionMap(Config.DisabledOptions);
			DropdownLib:Generate();
			return DropdownLib;
		end;

		function DropdownLib:AddDisabledOptions(disabledOptions)
			local NewMap = NormalizeOptionMap(disabledOptions);

			for Option,_ in next, NewMap do
				DisabledMap[Option] = true;
			end;

			Config.DisabledOptions = DisabledMap;
			DropdownLib:Generate();
			return DropdownLib;
		end;

		function DropdownLib:RemoveDisabledOptions(enabledOptions)
			local RemoveMap = NormalizeOptionMap(enabledOptions);

			for Option,_ in next, RemoveMap do
				DisabledMap[Option] = nil;
			end;

			Config.DisabledOptions = DisabledMap;
			DropdownLib:Generate();
			return DropdownLib;
		end;

		function DropdownLib:SetOptionsIcon(icons)
			Config.OptionsIcon = icons or {};
			IconMap = NormalizeIconMap(Config.OptionsIcon);
			DropdownLib:Generate();
			return DropdownLib;
		end;

		function DropdownLib:AddOptionsIcon(option, icon)
			Config.OptionsIcon = Config.OptionsIcon or {};
			Config.OptionsIcon[tostring(option)] = icon;
			IconMap = NormalizeIconMap(Config.OptionsIcon);
			DropdownLib:Generate();
			return DropdownLib;
		end;

		function DropdownLib:AddValue(value)
			table.insert(Config.Values,value);
			DropdownLib:Generate();
			return DropdownLib;
		end;

		function DropdownLib:RemoveValue(value)
			for Index = #Config.Values, 1, -1 do
				if Config.Values[Index] == value then
					table.remove(Config.Values,Index);
				end;
			end;

			if typeof(Config.Default) == "table" then
				Config.Default[value] = nil;
			elseif Config.Default == value then
				Config.Default = nil;
			end;

			BasedLabel.Text = ModernV2.ParseDropdown(Config.Default);
			DropdownLib:Generate();
			return DropdownLib;
		end;

		function DropdownLib:Clear()
			Config.Default = Config.Multi and {} or nil;
			BasedLabel.Text = ModernV2.ParseDropdown(Config.Default);

			for _,Refresh in next, DropdownLib.Refuse do
				task.spawn(Refresh);
			end;

			if ShouldFireDropdownCallback(Config.Default) then
				ModernV2:FireCallback(Config.Callback, Config.Name, Config.Default);
			end;

			return DropdownLib;
		end;

		function DropdownLib:Select(value)
			if Config.Multi then
				Config.Default = ModernV2.ProcessDropdown(Config.Default);
				Config.Default[value] = true;
				DropdownLib:SetValue(Config.Default);
			else
				DropdownLib:SetValue(value);
			end;

			return DropdownLib;
		end;

		function DropdownLib:Unselect(value)
			if Config.Multi then
				Config.Default = ModernV2.ProcessDropdown(Config.Default);
				Config.Default[value] = nil;
				DropdownLib:SetValue(Config.Default);
			elseif Config.Default == value then
				DropdownLib:Clear();
			end;

			return DropdownLib;
		end;

		function DropdownLib:IsSelected(value)
			return DropdownLib.IsMatch(value) == true;
		end;

		function DropdownLib:SetCallback(fn)
			Config.Callback = fn or EmptyFunction;
			return DropdownLib;
		end;

		function DropdownLib:SetSearch(value)
			Config.Search = value == true;
			if DropdownLib.ApplySearch then
				DropdownLib.ApplySearch();
			end;
			return DropdownLib;
		end;

		function DropdownLib:Open()
			DropdownLib.SetFrameRender(true);
			return DropdownLib;
		end;

		function DropdownLib:Close()
			DropdownLib.SetFrameRender(false);
			return DropdownLib;
		end;

		function DropdownLib:SetEnabled(value)
			Dropdown.Visible = value ~= false;
			return DropdownLib;
		end;

		if Config.Flag then
			ModernV2:RegisterFlag(Config.Flag, DropdownLib);
		end;

		return CaseInsensitive(DropdownLib);
	end;

	return CaseInsensitive(handle);
end;

ModernV2.ProcessDropdown = LPH_NO_VIRTUALIZE(function(value)
	if typeof(value) == 'table' then
		local data = {};

		for i,v in next , value do
			if typeof(v) == 'boolean' and typeof(i) ~= 'number' then
				data[i] = v;
			else
				data[v] = true;
			end;
		end;

		return data;
	else
		return value;
	end;
end);

ModernV2.ParseDropdown = LPH_NO_VIRTUALIZE(function(value)
	if not value then return 'Select'; end;

	local Out;

	if typeof(value) == 'table' then
		if #value > 0 then
			local x = {};

			for i,v in next , value do
				table.insert(x , tostring(v))
			end;

			Out = table.concat(x,' , ');

			table.clear(x);
		else
			local x = {};

			for i,v in next , value do
				if v == true then
					table.insert(x , tostring(i));
				end			
			end;

			Out = table.concat(x,' , ');

			table.clear(x)

			if not Out:byte() then
				Out = 'Select';
			end
		end;
	else
		Out = tostring(value or 'Select');
	end;

	return Out;
end);

function ModernV2:ParseInput(Value , Numeric)
	if not Value then
		return (Numeric and nil) or "";	
	end;

	if Numeric then
		local out = string.gsub(tostring(Value), '[^0-9.%-]', '')

		if tonumber(out) then
			return tonumber(out);
		end;

		return nil;
	end;

	return Value;
end;

function ModernV2:CreateToolTips(Container: Frame , Name: string , Content: string)
	local Tooltips = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local TooltipName = Instance.new("TextLabel")
	local TooltipContent = Instance.new("TextLabel")
	local Shadow = ModernV2:CreateShadow(Tooltips);

	Tooltips.Name = ModernV2.RandomString();
	Tooltips.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	Tooltips.BackgroundTransparency = 0.075
	Tooltips.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Tooltips.BorderSizePixel = 0
	Tooltips.ClipsDescendants = true
	Tooltips.Position = UDim2.new(255,255,255,255)
	Tooltips.Size = UDim2.new(0,0,0,0)
	Tooltips.ZIndex = 130

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Tooltips

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = Tooltips

	TooltipName.Name = ModernV2.RandomString();
	TooltipName.Parent = Tooltips
	TooltipName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TooltipName.BackgroundTransparency = 1.000
	TooltipName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TooltipName.BorderSizePixel = 0
	TooltipName.Position = UDim2.new(0, 15, 0, 5)
	TooltipName.Size = UDim2.new(0, 1, 0, 20)
	TooltipName.ZIndex = 132
	TooltipName.Font = Enum.Font.GothamBold
	TooltipName.Text = Name
	TooltipName.TextColor3 = Color3.fromRGB(255, 255, 255)
	TooltipName.TextSize = 15.000
	TooltipName.TextXAlignment = Enum.TextXAlignment.Left

	TooltipContent.Name = ModernV2.RandomString();
	TooltipContent.Parent = Tooltips
	TooltipContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TooltipContent.BackgroundTransparency = 1.000
	TooltipContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TooltipContent.BorderSizePixel = 0
	TooltipContent.Position = UDim2.new(0, 15, 0, 30)
	TooltipContent.Size = UDim2.new(0, 1, 0, 15)
	TooltipContent.ZIndex = 132
	TooltipContent.Font = Enum.Font.GothamBold
	TooltipContent.Text = Content
	TooltipContent.TextColor3 = Color3.fromRGB(255, 255, 255)
	TooltipContent.TextSize = 12.000
	TooltipContent.TextTransparency = 0.650
	TooltipContent.TextXAlignment = Enum.TextXAlignment.Left
	TooltipContent.TextYAlignment = Enum.TextYAlignment.Top

	local ToolTip = {};

	ToolTip.Update = LPH_NO_VIRTUALIZE(function()
		local SizeName = TextService:GetTextSize(TooltipName.Text , TooltipName.TextSize , TooltipName.Font , Vector2.new(math.huge,math.huge));
		local SizeContent = TextService:GetTextSize(TooltipContent.Text , TooltipContent.TextSize , TooltipContent.Font , Vector2.new(math.huge,math.huge));

		local MaxX = math.max(SizeName.X , SizeContent.X) + 65;
		local MaxY = SizeName.Y + SizeContent.Y + 30;

		ModernV2.PlayAnimate(Tooltips,SlowyTween , {
			Size = UDim2.new(0,MaxX,0,MaxY)
		})
	end)

	ModernV2:AddSignal(Tooltips:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if Tooltips.BackgroundTransparency > 0.9 then
			Tooltips.Visible = false;
			Tooltips.Parent = nil;
		else
			Tooltips.Visible = true;

			if ModernV2.Global3DRenderMode then
				Tooltips.Parent = ModernV2.GlobalSurfaceGui;
			else
				Tooltips.Parent = ModernV2.ScreenGui;
			end;
		end
	end)));

	ToolTip.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			Tooltips.Position = UDim2.fromOffset(Container.AbsolutePosition.X + Container.AbsoluteSize.X , Container.AbsolutePosition.Y + (Container.AbsoluteSize.Y + 25));

			ModernV2.PlayAnimate(Tooltips , SlowyTween , {
				BackgroundTransparency = 0.075
			})

			ModernV2.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			})

			ModernV2.PlayAnimate(TooltipName , SlowyTween , {
				TextTransparency = 0
			})

			ModernV2.PlayAnimate(TooltipContent , SlowyTween , {
				TextTransparency = 0.650
			})

			ToolTip.Update();
			Shadow:Render(true);
		else
			ModernV2.PlayAnimate(Tooltips , SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(TooltipName , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(TooltipContent , SlowyTween , {
				TextTransparency = 1
			})

			Shadow:Render(false);
		end;
	end);

	ToolTip.SetRender(false);
	ToolTip.Update();

	local DelayThread;
	ModernV2:AddSignal(Container.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then
			task.cancel(DelayThread);
			DelayThread = nil;
		end;

		DelayThread = task.delay(1,ToolTip.SetRender,true);
	end)));

	ModernV2:AddSignal(Container.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then
			task.cancel(DelayThread);
			DelayThread = nil;
		end;

		ToolTip.SetRender(false);
		ToolTip.Update();
	end)))

	return ToolTip;
end;

function ModernV2:RegisiterItem(Frame: Frame , Signel)
	local idx = {};
	local LayerIndex = Frame.ZIndex;

	function idx:AddLabel(Name: string,Warp: boolean)
		local RichText = false;
		local AutoSize = false;
		local Stacked = false;

		if typeof(Name) == "table" then
			local Config = Name;
			Name = Config.Text or Config.Name or Config.Title or "Label";
			AutoSize = Config.AutomaticSize == true;
			Warp = Config.Wrap or Config.Warp or Config.Wrapped or AutoSize or Warp;
			RichText = Config.RichText;
		end;

		Name = tostring(Name or "Label");
		RichText = RichText == true;
		Warp = Warp == true;

		local BasedFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local BasedHandler = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local UICorner = Instance.new("UICorner")

		BasedFrame.Name = ModernV2.RandomString();
		BasedFrame.Parent = Frame
		BasedFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		BasedFrame.BackgroundTransparency = 1.000
		BasedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedFrame.BorderSizePixel = 0
		BasedFrame.Size = UDim2.new(1, 0, 0, 30)
		BasedFrame.ZIndex = LayerIndex + 8

		ModernV2:AddQuery(BasedFrame , Name);

		BasedLabel.Name = ModernV2.RandomString();
		BasedLabel.Parent = BasedFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.ClipsDescendants = true
		BasedLabel.Position = UDim2.new(0, 11, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = LayerIndex + 9
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.RichText = RichText
		BasedLabel.Text = Name
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.35
		BasedLabel.TextTruncate = Enum.TextTruncate.None
		BasedLabel.TextWrapped = Warp
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left
		BasedLabel.TextYAlignment = (Warp and Enum.TextYAlignment.Top) or Enum.TextYAlignment.Center
		ModernV2:AddTextGradient(BasedLabel);

		LineFrame.Name = ModernV2.RandomString();
		LineFrame.Parent = BasedFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		BasedHandler.Name = ModernV2.RandomString();
		BasedHandler.Parent = BasedFrame
		BasedHandler.AnchorPoint = Vector2.new(1, 0)
		BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedHandler.BackgroundTransparency = 1.000
		BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedHandler.BorderSizePixel = 0
		BasedHandler.Position = UDim2.new(1, -11, 0, 2)
		BasedHandler.Size = UDim2.new(1, -20, 0, 25)
		BasedHandler.ZIndex = LayerIndex + 12

		UIListLayout.Parent = BasedHandler
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 5)

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = BasedFrame

		local UpdateRowLayout = LPH_NO_VIRTUALIZE(function()
			task.defer(function()
				if not BasedFrame.Parent then
					return;
				end;

				local FrameWidth = BasedFrame.AbsoluteSize.X;

				if FrameWidth <= 0 then
					return;
				end;

				local ContentWidth = math.ceil(UIListLayout.AbsoluteContentSize.X);
				local MaxContentWidth = math.max(0, FrameWidth - 28);
				ContentWidth = math.clamp(ContentWidth, 0, MaxContentWidth);

				local HandlerHeight = math.max(25, UIListLayout.AbsoluteContentSize.Y);
				local LabelWidth = Stacked and math.max(0, FrameWidth - 22) or math.max(0, FrameWidth - ContentWidth - 28);
				local LabelTextSize = 13;
				local LabelHeight = 15;

				if Warp then
					BasedLabel.TextWrapped = true;
					BasedLabel.TextYAlignment = Enum.TextYAlignment.Top;
					if LabelWidth > 0 then
						LabelHeight = math.max(15, TextService:GetTextSize(
							BasedLabel.Text,
							LabelTextSize,
							BasedLabel.Font,
							Vector2.new(LabelWidth, math.huge)
						).Y);
					end;
				elseif LabelWidth > 0 then
					BasedLabel.TextWrapped = false;
					BasedLabel.TextYAlignment = Enum.TextYAlignment.Center;
					while LabelTextSize > 9 and TextService:GetTextSize(
						BasedLabel.Text,
						LabelTextSize,
						BasedLabel.Font,
						Vector2.new(math.huge, math.huge)
					).X > LabelWidth do
						LabelTextSize = LabelTextSize - 1;
					end;
				end;

				local TargetHeight = Stacked and math.max(30, LabelHeight + HandlerHeight + 18) or math.max(30, HandlerHeight + 5, LabelHeight + 13);

				BasedLabel.TextSize = LabelTextSize;
				BasedLabel.Size = UDim2.new(0, LabelWidth, 0, LabelHeight);
				if Stacked then
					BasedHandler.AnchorPoint = Vector2.new(0, 0);
					BasedHandler.Position = UDim2.new(0, 11, 0, LabelHeight + 11);
					BasedHandler.Size = UDim2.new(1, -22, 0, HandlerHeight);
				else
					BasedHandler.AnchorPoint = Vector2.new(1, 0);
					BasedHandler.Size = UDim2.new(0, ContentWidth, 0, 25);
					BasedHandler.Position = UDim2.new(1, -11, 0, math.max(2, math.floor((TargetHeight - 25) / 2)));
				end;
				BasedFrame.Size = UDim2.new(1, 0, 0, TargetHeight);
			end);
		end);

		ModernV2:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(UpdateRowLayout));
		ModernV2:AddSignal(BasedFrame:GetPropertyChangedSignal('AbsoluteSize'):Connect(UpdateRowLayout));
		UpdateRowLayout();

		local UpdateWarp = LPH_NO_VIRTUALIZE(function()
			UpdateRowLayout();
		end);

		if Warp then
			UpdateWarp();
		end;

		local handle = ModernV2:RegisiterHandler(BasedHandler , Signel);

		handle.Root = BasedFrame;

		handle.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(BasedFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.35
				})

				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				})
			else
				ModernV2.PlayAnimate(BasedFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				})

				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				})
			end;
		end);

		function handle:SetVisible(val)
			BasedFrame.Visible = val;
			return handle;
		end;

		ModernV2:AddSignal(BasedFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(BasedFrame , SlowyTween , {
				BackgroundTransparency = 0.35
			});

			ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.25
			})

		end)))

		ModernV2:AddSignal(BasedFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(BasedFrame , SlowyTween , {
				BackgroundTransparency = 1
			});

			ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.35
			})
		end)))

		function handle:SetText(t)
			local oldtxt = BasedLabel.Text;

			BasedLabel.Text = tostring(t or "");
			UpdateRowLayout();

			if Warp and oldtxt ~= BasedLabel.Text then
				UpdateWarp();
			end;

			return handle;
		end;

		function handle:GetText()
			return BasedLabel.Text;
		end;

		function handle:SetRichText(value)
			BasedLabel.RichText = value == true;
			UpdateRowLayout();
			return handle;
		end;

		function handle:GetRichText()
			return BasedLabel.RichText;
		end;

		function handle:SetWrapped(value)
			Warp = value == true;
			BasedLabel.TextWrapped = Warp;
			BasedLabel.TextYAlignment = (Warp and Enum.TextYAlignment.Top) or Enum.TextYAlignment.Center;
			UpdateRowLayout();
			return handle;
		end;

		function handle:SetAutomaticSize(value)
			AutoSize = value == true;
			return handle:SetWrapped(AutoSize);
		end;

		function handle:SetStacked(value)
			Stacked = value == true;
			UIListLayout.HorizontalAlignment = (Stacked and Enum.HorizontalAlignment.Left) or Enum.HorizontalAlignment.Right;
			UpdateRowLayout();
			return handle;
		end;

		function handle:GetStacked()
			return Stacked;
		end;

		function handle:ToolTip(Content: string)
			handle.ToolTip = ModernV2:CreateToolTips(BasedFrame , Name , Content);

			return handle;
		end;

		handle.SetRender(Signel:GetValue());
		Signel:Connect(handle.SetRender);

		return CaseInsensitive(handle);
	end;

	function idx:AddButton(Config)
		Config = ModernV2:ProcessParams(Config , {
			Icon = 'chevron-large-left',
			IconPosition = "Left",
			Name = "Button",
			Callback = EmptyFunction,
			ToolTip = nil,
			Locked = false,
			TextLocked = "Locked",
		});

		local Button = {};
		local ButtonFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Icon = Instance.new("ImageLabel")

		ModernV2:AddQuery(ButtonFrame , Config.Name);

		ButtonFrame.Name = ModernV2.RandomString();
		ButtonFrame.Parent = Frame
		ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		ButtonFrame.BackgroundTransparency = 1.000
		ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonFrame.BorderSizePixel = 0
		ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
		ButtonFrame.ZIndex = LayerIndex + 8
		ModernV2:AttachLockMethods(Button, ButtonFrame, Config);

		BasedLabel.Name = ModernV2.RandomString();
		BasedLabel.Parent = ButtonFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 35, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = LayerIndex + 9
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = Config.Name;
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.200
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left
		ModernV2:AddTextGradient(BasedLabel);

		LineFrame.Name = ModernV2.RandomString();
		LineFrame.Parent = ButtonFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ButtonFrame

		Icon.Name = ModernV2.RandomString();
		Icon.Parent = ButtonFrame
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 11, 0, 5)
		Icon.Size = UDim2.new(0, 18, 0, 18)
		Icon.ZIndex = LayerIndex + 9
		ModernV2:SetIconMode(Icon, Config.Icon)
		Icon.ImageColor3 = Color3.fromRGB(223, 223, 223)
		Icon.ImageTransparency = 0.250
		Icon.ScaleType = Enum.ScaleType.Fit

		local function ResolveIconPosition(value)
			value = string.lower(tostring(value or "left"));

			if value == "right" then
				return "Right";
			end;

			return "Left";
		end;

		local function UpdateButtonLayout()
			Config.IconPosition = ResolveIconPosition(Config.IconPosition);

			if Config.IconPosition == "Right" then
				Icon.AnchorPoint = Vector2.new(1, 0);
				Icon.Position = UDim2.new(1, -11, 0, 5);
				BasedLabel.Position = UDim2.new(0, 11, 0, 6);
				BasedLabel.Size = UDim2.new(1, -46, 0, 15);
			else
				Icon.AnchorPoint = Vector2.new(0, 0);
				Icon.Position = UDim2.new(0, 11, 0, 5);
				BasedLabel.Position = UDim2.new(0, 35, 0, 6);
				BasedLabel.Size = UDim2.new(1, -46, 0, 15);
			end;
		end;

		UpdateButtonLayout();

		function Button:SetText(t)
			BasedLabel.Text = t;
			return Button;
		end;

		function Button:SetIcon(t)
			Config.Icon = t or Config.Icon;
			ModernV2:SetIconMode(Icon, Config.Icon)
			return Button;
		end;

		function Button:SetIconPosition(position)
			Config.IconPosition = ResolveIconPosition(position);
			UpdateButtonLayout();
			return Button;
		end;

		function Button:GetIconPosition()
			return Config.IconPosition;
		end;

		function Button:SetCallback(fn)
			Config.Callback = fn or EmptyFunction;
			return Button;
		end;

		function Button:Fire(...)
			ModernV2:FireCallback(Config.Callback, Config.Name, ...);
			return Button;
		end;

		function Button:Click(...)
			return Button:Fire(...);
		end;

		function Button:SetVisible(value)
			ButtonFrame.Visible = value ~= false;
			return Button;
		end;

		function Button:SetIconColor(color)
			Icon.ImageColor3 = color or Icon.ImageColor3;
			return Button;
		end;

		function Button:SetTextColor(color)
			BasedLabel.TextColor3 = color or BasedLabel.TextColor3;
			return Button;
		end;

		local bth = ModernV2:CreateInput(ButtonFrame , LPH_NO_VIRTUALIZE(function()
			ModernV2:FireCallback(Config.Callback, Config.Name);
		end));

		ModernV2:AddSignal(bth.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(ButtonFrame , SlowyTween , {
				BackgroundTransparency = 0.35
			});
		end)))

		ModernV2:AddSignal(bth.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(ButtonFrame , SlowyTween , {
				BackgroundTransparency = 1
			});
		end)))

		Button.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(ButtonFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.200
				});

				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				});

				ModernV2.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.250
				});
			else
				ModernV2.PlayAnimate(ButtonFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				});

				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				ModernV2.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				});
			end;
		end);

		if Config.ToolTip then
			Button.ToolTip = ModernV2:CreateToolTips(ButtonFrame , Config.Name , Config.ToolTip);
		end;

		Button.SetRender(Signel:GetValue())
		Signel:Connect(Button.SetRender);

		return CaseInsensitive(Button);
	end;

	function idx:AddParagraph(Config)
		if typeof(Config) ~= "table" then
			Config = {
				Content = tostring(Config or ""),
			};
		end;

		Config = ModernV2:ProcessParams(Config , {
			Name = "Information",
			Content = "",
			RichText = true,
			Locked = false,
			TextLocked = "Locked",
		});

		local Paragraph = {};
		local ParagraphFrame = Instance.new("Frame")
		local NameLabel = Instance.new("TextLabel")
		local ContentLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")

		ModernV2:AddQuery(ParagraphFrame , Config.Name);

		ParagraphFrame.Name = ModernV2.RandomString();
		ParagraphFrame.Parent = Frame
		ParagraphFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		ParagraphFrame.BackgroundTransparency = 1.000
		ParagraphFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ParagraphFrame.BorderSizePixel = 0
		ParagraphFrame.ClipsDescendants = true
		ParagraphFrame.Size = UDim2.new(1, 0, 0, 58)
		ParagraphFrame.ZIndex = LayerIndex + 8
		ModernV2:AttachLockMethods(Paragraph, ParagraphFrame, Config);

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ParagraphFrame

		NameLabel.Name = ModernV2.RandomString();
		NameLabel.Parent = ParagraphFrame
		NameLabel.BackgroundTransparency = 1.000
		NameLabel.BorderSizePixel = 0
		NameLabel.Position = UDim2.new(0, 11, 0, 7)
		NameLabel.Size = UDim2.new(1, -22, 0, 16)
		NameLabel.ZIndex = LayerIndex + 9
		NameLabel.Font = Enum.Font.GothamMedium
		NameLabel.RichText = Config.RichText == true
		NameLabel.Text = tostring(Config.Name)
		NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		NameLabel.TextSize = 13.000
		NameLabel.TextTransparency = 0.200
		NameLabel.TextXAlignment = Enum.TextXAlignment.Left
		NameLabel.TextYAlignment = Enum.TextYAlignment.Top
		ModernV2:AddTextGradient(NameLabel);

		ContentLabel.Name = ModernV2.RandomString();
		ContentLabel.Parent = ParagraphFrame
		ContentLabel.BackgroundTransparency = 1.000
		ContentLabel.BorderSizePixel = 0
		ContentLabel.Position = UDim2.new(0, 11, 0, 26)
		ContentLabel.Size = UDim2.new(1, -22, 0, 20)
		ContentLabel.ZIndex = LayerIndex + 9
		ContentLabel.Font = Enum.Font.GothamMedium
		ContentLabel.RichText = Config.RichText == true
		ContentLabel.Text = tostring(Config.Content)
		ContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ContentLabel.TextSize = 12.000
		ContentLabel.TextTransparency = 0.500
		ContentLabel.TextWrapped = true
		ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
		ContentLabel.TextYAlignment = Enum.TextYAlignment.Top

		LineFrame.Name = ModernV2.RandomString();
		LineFrame.Parent = ParagraphFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		local function UpdateSize()
			local Width = math.max(120, ParagraphFrame.AbsoluteSize.X - 22);
			local ContentSize = TextService:GetTextSize(ContentLabel.Text,ContentLabel.TextSize,ContentLabel.Font,Vector2.new(Width,math.huge));
			local Height = math.max(58, ContentSize.Y + 38);

			ContentLabel.Size = UDim2.new(1, -22, 0, ContentSize.Y + 4);
			ModernV2.PlayAnimate(ParagraphFrame , SlowyTween , {
				Size = UDim2.new(1, 0, 0, Height)
			});
		end;

		task.defer(UpdateSize);
		ModernV2:AddSignal(ParagraphFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateSize));

		function Paragraph:SetName(name)
			Config.Name = tostring(name or "");
			NameLabel.Text = Config.Name;
			return Paragraph;
		end;

		function Paragraph:SetContent(content)
			Config.Content = tostring(content or "");
			ContentLabel.Text = Config.Content;
			UpdateSize();
			return Paragraph;
		end;

		function Paragraph:GetName()
			return Config.Name;
		end;

		function Paragraph:GetContent()
			return Config.Content;
		end;

		function Paragraph:SetRichText(value)
			Config.RichText = value == true;
			NameLabel.RichText = Config.RichText;
			ContentLabel.RichText = Config.RichText;
			return Paragraph;
		end;

		function Paragraph:GetRichText()
			return Config.RichText == true;
		end;

		function Paragraph:SetVisible(value)
			ParagraphFrame.Visible = value ~= false;
			return Paragraph;
		end;

		Paragraph.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(NameLabel , SlowyTween , {
					TextTransparency = 0.200
				});
				ModernV2.PlayAnimate(ContentLabel , SlowyTween , {
					TextTransparency = 0.500
				});
				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				});
			else
				ModernV2.PlayAnimate(NameLabel , SlowyTween , {
					TextTransparency = 1
				});
				ModernV2.PlayAnimate(ContentLabel , SlowyTween , {
					TextTransparency = 1
				});
				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				});
			end;
		end);

		Paragraph.SetRender(Signel:GetValue());
		Signel:Connect(Paragraph.SetRender);

		return CaseInsensitive(Paragraph);
	end;

	function idx:AddImage(Config)
		if typeof(Config) ~= "table" then
			Config = {
				Image = tostring(Config or ""),
			};
		end;

		Config = ModernV2:ProcessParams(Config , {
			Name = "Image",
			Image = "",
			Size = UDim2.new(1, -20, 0, 120),
			Height = nil,
			ScaleType = Enum.ScaleType.Fit,
			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 0,
			Corner = 6,
			Locked = false,
			TextLocked = "Locked",
		});

		local ImageLib = {};
		local ImageFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local ImageLabel = Instance.new("ImageLabel")
		local ImageCorner = Instance.new("UICorner")
		local LineFrame = Instance.new("Frame")

		if Config.Height then
			Config.Size = UDim2.new(1, -20, 0, tonumber(Config.Height) or 120);
		end;

		ModernV2:AddQuery(ImageFrame , Config.Name);

		ImageFrame.Name = ModernV2.RandomString();
		ImageFrame.Parent = Frame
		ImageFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		ImageFrame.BackgroundTransparency = 1.000
		ImageFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageFrame.BorderSizePixel = 0
		ImageFrame.ClipsDescendants = true
		ImageFrame.Size = UDim2.new(1, 0, 0, Config.Size.Y.Offset + 15)
		ImageFrame.ZIndex = LayerIndex + 8
		ModernV2:AttachLockMethods(ImageLib, ImageFrame, Config);

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ImageFrame

		ImageLabel.Name = ModernV2.RandomString();
		ImageLabel.Parent = ImageFrame
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.5, 0, 0, 7)
		ImageLabel.Size = Config.Size
		ImageLabel.ZIndex = LayerIndex + 9
		ImageLabel.ImageColor3 = Config.Color
		ImageLabel.ImageTransparency = Config.Transparency
		ImageLabel.ScaleType = Config.ScaleType
		ModernV2:SetIconMode(ImageLabel, Config.Image);
		ImageLabel.ScaleType = Config.ScaleType;
		ImageLabel.ImageColor3 = Config.Color;
		ImageLabel.ImageTransparency = Config.Transparency;
		local ImageScale = ImageLabel:FindFirstChild("ModernIconScale");
		if ImageScale then
			ImageScale.Scale = 1;
		end;

		ImageCorner.CornerRadius = UDim.new(0, Config.Corner)
		ImageCorner.Parent = ImageLabel

		LineFrame.Name = ModernV2.RandomString();
		LineFrame.Parent = ImageFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		local function UpdateSize()
			local Height = math.max(30, ImageLabel.Size.Y.Offset + 15);
			ImageFrame.Size = UDim2.new(1, 0, 0, Height);
		end;

		function ImageLib:SetImage(image)
			Config.Image = tostring(image or "");
			ModernV2:SetIconMode(ImageLabel, Config.Image);
			ImageLabel.ScaleType = Config.ScaleType;
			ImageLabel.ImageColor3 = Config.Color;
			ImageLabel.ImageTransparency = Config.Transparency;
			local ImageScale = ImageLabel:FindFirstChild("ModernIconScale");
			if ImageScale then
				ImageScale.Scale = 1;
			end;
			return ImageLib;
		end;

		function ImageLib:GetImage()
			return Config.Image;
		end;

		function ImageLib:SetSize(size)
			if typeof(size) == "UDim2" then
				Config.Size = size;
			elseif typeof(size) == "number" then
				Config.Size = UDim2.new(1, -20, 0, size);
			end;

			ImageLabel.Size = Config.Size;
			UpdateSize();
			return ImageLib;
		end;

		function ImageLib:SetHeight(height)
			return ImageLib:SetSize(tonumber(height) or ImageLabel.Size.Y.Offset);
		end;

		function ImageLib:SetScaleType(scaleType)
			Config.ScaleType = scaleType or Config.ScaleType;
			ImageLabel.ScaleType = Config.ScaleType;
			return ImageLib;
		end;

		function ImageLib:SetColor(color)
			Config.Color = color or Config.Color;
			ImageLabel.ImageColor3 = Config.Color;
			return ImageLib;
		end;

		function ImageLib:SetTransparency(value)
			Config.Transparency = tonumber(value) or Config.Transparency;
			ImageLabel.ImageTransparency = Config.Transparency;
			return ImageLib;
		end;

		function ImageLib:SetVisible(value)
			ImageFrame.Visible = value ~= false;
			return ImageLib;
		end;

		ImageLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = Config.Transparency
				});
				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				});
			else
				ModernV2.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = 1
				});
				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				});
			end;
		end);

		UpdateSize();
		ImageLib.SetRender(Signel:GetValue());
		Signel:Connect(ImageLib.SetRender);

		return CaseInsensitive(ImageLib);
	end;

	function idx:AddDivider(Config)
		if typeof(Config) ~= "table" then
			Config = {
				Text = tostring(Config or ""),
			};
		end;

		Config = ModernV2:ProcessParams(Config , {
			Text = "",
			Name = nil,
		});

		local Divider = {};
		local DividerFrame = Instance.new("Frame")
		local LeftLine = Instance.new("Frame")
		local RightLine = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")

		DividerFrame.Name = ModernV2.RandomString();
		DividerFrame.Parent = Frame
		DividerFrame.BackgroundTransparency = 1.000
		DividerFrame.BorderSizePixel = 0
		DividerFrame.Size = UDim2.new(1, 0, 0, 22)
		DividerFrame.ZIndex = LayerIndex + 8

		LeftLine.Name = ModernV2.RandomString();
		LeftLine.Parent = DividerFrame
		LeftLine.AnchorPoint = Vector2.new(0, 0.5)
		LeftLine.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LeftLine.BackgroundTransparency = 0.650
		LeftLine.BorderSizePixel = 0
		LeftLine.Position = UDim2.new(0, 10, 0.5, 0)
		LeftLine.Size = UDim2.new(0.5, -20, 0, 1)
		LeftLine.ZIndex = LayerIndex + 9

		TextLabel.Name = ModernV2.RandomString();
		TextLabel.Parent = DividerFrame
		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.fromScale(0.5, 0.5)
		TextLabel.Size = UDim2.new(0, 0, 0, 16)
		TextLabel.ZIndex = LayerIndex + 9
		TextLabel.Font = Enum.Font.GothamMedium
		TextLabel.Text = tostring(Config.Text or Config.Name or "")
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.TextSize = 11.000
		TextLabel.TextTransparency = 0.500

		RightLine.Name = ModernV2.RandomString();
		RightLine.Parent = DividerFrame
		RightLine.AnchorPoint = Vector2.new(1, 0.5)
		RightLine.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		RightLine.BackgroundTransparency = 0.650
		RightLine.BorderSizePixel = 0
		RightLine.Position = UDim2.new(1, -10, 0.5, 0)
		RightLine.Size = UDim2.new(0.5, -20, 0, 1)
		RightLine.ZIndex = LayerIndex + 9

		local function UpdateDivider()
			local Text = TextLabel.Text;

			if Text == "" then
				TextLabel.Visible = false;
				LeftLine.Size = UDim2.new(1, -20, 0, 1);
				RightLine.Visible = false;
				return;
			end;

			TextLabel.Visible = true;
			RightLine.Visible = true;

			local MaxTextWidth = math.max(40, DividerFrame.AbsoluteSize.X - 70);
			local TextWidth = math.min(TextService:GetTextSize(Text, TextLabel.TextSize, TextLabel.Font, Vector2.new(math.huge, math.huge)).X + 16, MaxTextWidth);
			TextLabel.Size = UDim2.new(0, TextWidth, 0, 16);
			LeftLine.Size = UDim2.new(0.5, -(TextWidth / 2) - 12, 0, 1);
			RightLine.Size = UDim2.new(0.5, -(TextWidth / 2) - 12, 0, 1);
		end;

		function Divider:SetText(text)
			Config.Text = tostring(text or "");
			TextLabel.Text = Config.Text;
			UpdateDivider();
			return Divider;
		end;

		function Divider:GetText()
			return TextLabel.Text;
		end;

		function Divider:SetVisible(value)
			DividerFrame.Visible = value ~= false;
			return Divider;
		end;

		Divider.SetRender = LPH_NO_VIRTUALIZE(function(value)
			ModernV2.PlayAnimate(LeftLine , SlowyTween , {
				BackgroundTransparency = value and 0.650 or 1
			});
			ModernV2.PlayAnimate(RightLine , SlowyTween , {
				BackgroundTransparency = value and 0.650 or 1
			});
			ModernV2.PlayAnimate(TextLabel , SlowyTween , {
				TextTransparency = value and 0.500 or 1
			});
		end);

		UpdateDivider();
		ModernV2:AddSignal(DividerFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateDivider));
		Divider.SetRender(Signel:GetValue());
		Signel:Connect(Divider.SetRender);

		return CaseInsensitive(Divider);
	end;

	function idx:AddSpacer(Size)
		local Spacer = {};
		local Height = 8;

		if typeof(Size) == "table" then
			Height = tonumber(Size.Size or Size.Height or Size[1]) or Height;
		else
			Height = tonumber(Size) or Height;
		end;

		local SpacerFrame = Instance.new("Frame")
		SpacerFrame.Name = ModernV2.RandomString();
		SpacerFrame.Parent = Frame
		SpacerFrame.BackgroundTransparency = 1.000
		SpacerFrame.BorderSizePixel = 0
		SpacerFrame.Size = UDim2.new(1, 0, 0, Height)
		SpacerFrame.ZIndex = LayerIndex + 8

		function Spacer:SetSize(size)
			Height = tonumber(size) or Height;
			SpacerFrame.Size = UDim2.new(1, 0, 0, Height);
			return Spacer;
		end;

		function Spacer:GetSize()
			return Height;
		end;

		function Spacer:SetVisible(value)
			SpacerFrame.Visible = value ~= false;
			return Spacer;
		end;

		Spacer.SetRender = LPH_NO_VIRTUALIZE(function(value)
			SpacerFrame.Visible = value == true;
		end);

		Spacer.SetRender(Signel:GetValue());
		Signel:Connect(Spacer.SetRender);

		return CaseInsensitive(Spacer);
	end;

	function idx:AddProgressBar(Config)
		if typeof(Config) ~= "table" then
			Config = {
				Value = tonumber(Config) or 0,
			};
		end;

		Config = ModernV2:ProcessParams(Config , {
			Name = "Progress",
			Value = 0,
			Max = 100,
			Type = "%",
			Locked = false,
			TextLocked = "Locked",
		});

		local Progress = {};
		local ProgressFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local ValueLabel = Instance.new("TextLabel")
		local BarBack = Instance.new("Frame")
		local BarBackCorner = Instance.new("UICorner")
		local BarFill = Instance.new("Frame")
		local BarFillCorner = Instance.new("UICorner")
		local LineFrame = Instance.new("Frame")

		ModernV2:AddQuery(ProgressFrame , Config.Name);

		ProgressFrame.Name = ModernV2.RandomString();
		ProgressFrame.Parent = Frame
		ProgressFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		ProgressFrame.BackgroundTransparency = 1.000
		ProgressFrame.BorderSizePixel = 0
		ProgressFrame.ClipsDescendants = true
		ProgressFrame.Size = UDim2.new(1, 0, 0, 45)
		ProgressFrame.ZIndex = LayerIndex + 8
		ModernV2:AttachLockMethods(Progress, ProgressFrame, Config);

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ProgressFrame

		Title.Name = ModernV2.RandomString();
		Title.Parent = ProgressFrame
		Title.BackgroundTransparency = 1.000
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0, 11, 0, 6)
		Title.Size = UDim2.new(1, -90, 0, 15)
		Title.ZIndex = LayerIndex + 9
		Title.Font = Enum.Font.GothamMedium
		Title.Text = tostring(Config.Name)
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 13.000
		Title.TextTransparency = 0.250
		Title.TextXAlignment = Enum.TextXAlignment.Left
		ModernV2:AddTextGradient(Title);

		ValueLabel.Name = ModernV2.RandomString();
		ValueLabel.Parent = ProgressFrame
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.BorderSizePixel = 0
		ValueLabel.Position = UDim2.new(1, -80, 0, 6)
		ValueLabel.Size = UDim2.new(0, 69, 0, 15)
		ValueLabel.ZIndex = LayerIndex + 9
		ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.TextSize = 12.000
		ValueLabel.TextTransparency = 0.500
		ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

		BarBack.Name = ModernV2.RandomString();
		BarBack.Parent = ProgressFrame
		BarBack.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		BarBack.BorderSizePixel = 0
		BarBack.Position = UDim2.new(0, 11, 0, 27)
		BarBack.Size = UDim2.new(1, -22, 0, 8)
		BarBack.ZIndex = LayerIndex + 9

		BarBackCorner.CornerRadius = UDim.new(1, 0)
		BarBackCorner.Parent = BarBack

		BarFill.Name = ModernV2.RandomString();
		BarFill.Parent = BarBack
		BarFill.BackgroundColor3 = ModernV2.AccentColor
		BarFill.BorderSizePixel = 0
		BarFill.Size = UDim2.fromScale(0, 1)
		BarFill.ZIndex = LayerIndex + 10

		BarFillCorner.CornerRadius = UDim.new(1, 0)
		BarFillCorner.Parent = BarFill

		LineFrame.Name = ModernV2.RandomString();
		LineFrame.Parent = ProgressFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		local function UpdateProgress()
			local MaxValue = math.max(tonumber(Config.Max) or 1, 0.0001);
			local Value = math.clamp(tonumber(Config.Value) or 0, 0, MaxValue);
			local Percent = Value / MaxValue;
			local DisplayValue = ModernV2.Rounding(Value, 2);
			local DisplayMax = ModernV2.Rounding(MaxValue, 2);

			if Config.Type == "%" then
				ValueLabel.Text = tostring(ModernV2.Rounding(Percent * 100, 0)).."%";
			else
				ValueLabel.Text = tostring(DisplayValue).."/"..tostring(DisplayMax)..tostring(Config.Type or "");
			end;

			ModernV2.PlayAnimate(BarFill , SlowyTween , {
				Size = UDim2.fromScale(Percent, 1),
				BackgroundColor3 = ModernV2.AccentColor
			});
		end;

		function Progress:SetValue(value)
			Config.Value = tonumber(value) or Config.Value;
			UpdateProgress();
			return Progress;
		end;

		function Progress:GetValue()
			return Config.Value;
		end;

		function Progress:SetMax(max)
			Config.Max = tonumber(max) or Config.Max;
			UpdateProgress();
			return Progress;
		end;

		function Progress:SetText(text)
			Config.Name = tostring(text or "");
			Title.Text = Config.Name;
			return Progress;
		end;

		function Progress:SetType(text)
			Config.Type = tostring(text or "");
			UpdateProgress();
			return Progress;
		end;

		function Progress:SetVisible(value)
			ProgressFrame.Visible = value ~= false;
			return Progress;
		end;

		Progress.SetRender = LPH_NO_VIRTUALIZE(function(value)
			ModernV2.PlayAnimate(Title , SlowyTween , { TextTransparency = value and 0.250 or 1 });
			ModernV2.PlayAnimate(ValueLabel , SlowyTween , { TextTransparency = value and 0.500 or 1 });
			ModernV2.PlayAnimate(BarBack , SlowyTween , { BackgroundTransparency = value and 0 or 1 });
			ModernV2.PlayAnimate(BarFill , SlowyTween , { BackgroundTransparency = value and 0 or 1 });
			ModernV2.PlayAnimate(LineFrame , SlowyTween , { BackgroundTransparency = value and 0.650 or 1 });
		end);

		UpdateProgress();
		Progress.SetRender(Signel:GetValue());
		Signel:Connect(Progress.SetRender);

		return CaseInsensitive(Progress);
	end;

	function idx:AddCodeBlock(Config)
		if typeof(Config) ~= "table" then
			Config = {
				Code = tostring(Config or ""),
			};
		end;

		Config = ModernV2:ProcessParams(Config , {
			Name = "Code",
			Code = "",
			RichText = false,
			Copy = true,
			CopyText = "Copy",
			Locked = false,
			TextLocked = "Locked",
		});

		local CodeBlock = {};
		local CodeFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local CodeLabel = Instance.new("TextLabel")
		local CodeCorner = Instance.new("UICorner")
		local CodePadding = Instance.new("UIPadding")
		local CopyButton = Instance.new("Frame")
		local CopyCorner = Instance.new("UICorner")
		local CopyStroke = Instance.new("UIStroke")
		local CopyIcon = Instance.new("ImageLabel")
		local LineFrame = Instance.new("Frame")

		ModernV2:AddQuery(CodeFrame , Config.Name);

		CodeFrame.Name = ModernV2.RandomString();
		CodeFrame.Parent = Frame
		CodeFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		CodeFrame.BackgroundTransparency = 1.000
		CodeFrame.BorderSizePixel = 0
		CodeFrame.ClipsDescendants = true
		CodeFrame.Size = UDim2.new(1, 0, 0, 60)
		CodeFrame.ZIndex = LayerIndex + 8
		ModernV2:AttachLockMethods(CodeBlock, CodeFrame, Config);

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = CodeFrame

		CodeLabel.Name = ModernV2.RandomString();
		CodeLabel.Parent = CodeFrame
		CodeLabel.BackgroundColor3 = Color3.fromRGB(18, 19, 25)
		CodeLabel.BackgroundTransparency = 0.150
		CodeLabel.BorderSizePixel = 0
		CodeLabel.Position = UDim2.new(0, 10, 0, 7)
		CodeLabel.Size = UDim2.new(1, -20, 0, 40)
		CodeLabel.ZIndex = LayerIndex + 9
		CodeLabel.Font = Enum.Font.Code
		CodeLabel.RichText = Config.RichText == true
		CodeLabel.Text = tostring(Config.Code)
		CodeLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
		CodeLabel.TextSize = 12.000
		CodeLabel.TextTransparency = 0.200
		CodeLabel.TextWrapped = true
		CodeLabel.TextXAlignment = Enum.TextXAlignment.Left
		CodeLabel.TextYAlignment = Enum.TextYAlignment.Top

		CodeCorner.CornerRadius = UDim.new(0, 5)
		CodeCorner.Parent = CodeLabel

		CodePadding.PaddingTop = UDim.new(0, 7)
		CodePadding.PaddingBottom = UDim.new(0, 7)
		CodePadding.PaddingLeft = UDim.new(0, 7)
		CodePadding.PaddingRight = UDim.new(0, Config.Copy ~= false and 35 or 7)
		CodePadding.Parent = CodeLabel

		CopyButton.Name = ModernV2.RandomString();
		CopyButton.Parent = CodeFrame
		CopyButton.AnchorPoint = Vector2.new(1, 0)
		CopyButton.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		CopyButton.BackgroundTransparency = Config.Copy ~= false and 0.100 or 1
		CopyButton.BorderSizePixel = 0
		CopyButton.ClipsDescendants = true
		CopyButton.Position = UDim2.new(1, -16, 0, 13)
		CopyButton.Size = UDim2.new(0, 24, 0, 24)
		CopyButton.Visible = Config.Copy ~= false
		CopyButton.ZIndex = LayerIndex + 12

		CopyCorner.CornerRadius = UDim.new(0, 5)
		CopyCorner.Parent = CopyButton

		CopyStroke.Transparency = 0.650
		CopyStroke.Color = Color3.fromRGB(45, 48, 58)
		CopyStroke.Parent = CopyButton

		CopyIcon.Name = ModernV2.RandomString();
		CopyIcon.Parent = CopyButton
		CopyIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		CopyIcon.BackgroundTransparency = 1
		CopyIcon.BorderSizePixel = 0
		CopyIcon.Position = UDim2.fromScale(0.5, 0.5)
		CopyIcon.Size = UDim2.new(0, 15, 0, 15)
		CopyIcon.ZIndex = LayerIndex + 13
		CopyIcon.ImageColor3 = Color3.fromRGB(223, 223, 223)
		CopyIcon.ImageTransparency = 0.250
		CopyIcon.ScaleType = Enum.ScaleType.Fit
		ModernV2:SetIconMode(CopyIcon, "lucide:copy")

		LineFrame.Name = ModernV2.RandomString();
		LineFrame.Parent = CodeFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		local function UpdateCodeSize()
			local Width = math.max(120, CodeFrame.AbsoluteSize.X - 32);
			local Size = TextService:GetTextSize(CodeLabel.Text,CodeLabel.TextSize,CodeLabel.Font,Vector2.new(Width,math.huge));
			local Height = math.max(40, Size.Y + 14);

			CodeLabel.Size = UDim2.new(1, -20, 0, Height);
			CodeFrame.Size = UDim2.new(1, 0, 0, Height + 15);
		end;

		local function GetClipboardWriter()
			return setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard) or nil;
		end;

		function CodeBlock:Copy()
			local Writer = GetClipboardWriter();

			if not Writer then
				ModernV2:SetIconMode(CopyIcon, "lucide:x")
				task.delay(0.85, function()
					if CopyIcon and CopyIcon.Parent then
						ModernV2:SetIconMode(CopyIcon, "lucide:copy")
					end;
				end)
				return false;
			end;

			local Success = pcall(function()
				Writer(Config.Code);
			end);

			ModernV2:SetIconMode(CopyIcon, Success and "lucide:check" or "lucide:x")
			task.delay(0.85, function()
				if CopyIcon and CopyIcon.Parent then
					ModernV2:SetIconMode(CopyIcon, "lucide:copy")
				end;
			end)

			return Success;
		end;

		function CodeBlock:SetCode(code)
			Config.Code = tostring(code or "");
			CodeLabel.Text = Config.Code;
			UpdateCodeSize();
			return CodeBlock;
		end;

		function CodeBlock:GetCode()
			return Config.Code;
		end;

		function CodeBlock:SetRichText(value)
			Config.RichText = value == true;
			CodeLabel.RichText = Config.RichText;
			return CodeBlock;
		end;

		function CodeBlock:SetVisible(value)
			CodeFrame.Visible = value ~= false;
			return CodeBlock;
		end;

		function CodeBlock:SetCopyEnabled(value)
			Config.Copy = value == true;
			CopyButton.Visible = Config.Copy;
			CodePadding.PaddingRight = UDim.new(0, Config.Copy and 35 or 7);
			return CodeBlock;
		end;

		local CopyInput = ModernV2:CreateInput(CopyButton, function()
			CodeBlock:Copy();
		end);

		ModernV2:AddSignal(CopyInput.MouseEnter:Connect(function()
			ModernV2.PlayAnimate(CopyButton, SlowyTween, {
				BackgroundTransparency = 0
			});
			ModernV2.PlayAnimate(CopyIcon, SlowyTween, {
				TextTransparency = 0
			});
		end));

		ModernV2:AddSignal(CopyInput.MouseLeave:Connect(function()
			ModernV2.PlayAnimate(CopyButton, SlowyTween, {
				BackgroundTransparency = 0.100
			});
			ModernV2.PlayAnimate(CopyIcon, SlowyTween, {
				TextTransparency = 0.250
			});
		end));

		CodeBlock.SetRender = LPH_NO_VIRTUALIZE(function(value)
			ModernV2.PlayAnimate(CodeLabel , SlowyTween , {
				BackgroundTransparency = value and 0.150 or 1,
				TextTransparency = value and 0.200 or 1
			});
			ModernV2.PlayAnimate(CopyButton , SlowyTween , {
				BackgroundTransparency = (value and Config.Copy) and 0.100 or 1
			});
			ModernV2.PlayAnimate(CopyStroke , SlowyTween , {
				Transparency = (value and Config.Copy) and 0.650 or 1
			});
			ModernV2.PlayAnimate(CopyIcon , SlowyTween , {
				TextTransparency = (value and Config.Copy) and 0.250 or 1
			});
			ModernV2.PlayAnimate(LineFrame , SlowyTween , {
				BackgroundTransparency = value and 0.650 or 1
			});
		end);

		task.defer(UpdateCodeSize);
		ModernV2:AddSignal(CodeFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateCodeSize));
		CodeBlock.SetRender(Signel:GetValue());
		Signel:Connect(CodeBlock.SetRender);

		return CaseInsensitive(CodeBlock);
	end;

	function idx:AddDependencyBox(Config)
		if typeof(Config) ~= "table" then
			Config = {
				Dependencies = Config and { Config } or {},
			};
		end;

		Config = ModernV2:ProcessParams(Config , {
			Name = "DependencyBox",
			Dependencies = {},
			Mode = "Visible",
			Locked = false,
			TextLocked = "Dependency required",
		});

		local DependencyBox = {};
		local DependencyFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local DependencyHandler = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local DependencySignal = ModernV2:CreateSignal(false);
		local IsRendered = Signel:GetValue() == true;
		local LastMatched;
		local CheckAccumulator = 0;

		local Mode = string.lower(tostring(Config.Mode or "Visible"));
		local LockMode = Mode == "locked" or Mode == "lock";

		local function ResolveDependencyObject(value)
			if typeof(value) == "string" then
				return ModernV2.Flags[value] or value;
			end;

			return value;
		end;

		local function GetDependencyValue(object)
			object = ResolveDependencyObject(object);

			if typeof(object) == "table" and object.GetValue then
				local success, result = pcall(function()
					return object:GetValue();
				end);

				if success then
					return result;
				end;
			end;

			return object;
		end;

		local function CompareDependency(actual, expected)
			if typeof(expected) == "function" then
				local success, result = pcall(expected, actual);
				return success and result == true;
			end;

			if expected == nil then
				return actual == true;
			end;

			if typeof(actual) == "table" then
				if typeof(expected) == "table" then
					for key,value in next, expected do
						if actual[key] ~= value and actual[value] ~= true then
							return false;
						end;
					end;

					return true;
				end;

				return actual[expected] == true or table.find(actual, expected) ~= nil;
			end;

			return actual == expected;
		end;

		local function DependencyMatches(dependency)
			if typeof(dependency) ~= "table" then
				return GetDependencyValue(dependency) == true;
			end;

			local Object = dependency.Object or dependency.Element or dependency[1] or dependency.Flag;
			local Expected = dependency.Value;

			if Expected == nil then
				Expected = dependency.Expected or dependency.Equals or dependency[2];
			end;

			return CompareDependency(GetDependencyValue(Object), Expected);
		end;

		local function DependenciesMatch()
			local Dependencies = Config.Dependencies or {};

			if #Dependencies <= 0 then
				return true;
			end;

			for _,Dependency in ipairs(Dependencies) do
				if not DependencyMatches(Dependency) then
					return false;
				end;
			end;

			return true;
		end;

		DependencyFrame.Name = ModernV2.RandomString();
		DependencyFrame.Parent = Frame
		DependencyFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		DependencyFrame.BackgroundTransparency = 0.500
		DependencyFrame.BorderSizePixel = 0
		DependencyFrame.ClipsDescendants = true
		DependencyFrame.Size = UDim2.new(1, 0, 0, 0)
		DependencyFrame.ZIndex = LayerIndex + 8
		ModernV2:AttachLockMethods(DependencyBox, DependencyFrame, {
			Locked = LockMode and not DependenciesMatch() or Config.Locked,
			TextLocked = Config.TextLocked,
		});

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = DependencyFrame

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = DependencyFrame

		DependencyHandler.Name = ModernV2.RandomString();
		DependencyHandler.Parent = DependencyFrame
		DependencyHandler.AnchorPoint = Vector2.new(0.5, 0)
		DependencyHandler.BackgroundTransparency = 1.000
		DependencyHandler.BorderSizePixel = 0
		DependencyHandler.ClipsDescendants = true
		DependencyHandler.Position = UDim2.new(0.5, 0, 0, 5)
		DependencyHandler.Size = UDim2.new(1, -10, 1, -10)
		DependencyHandler.ZIndex = LayerIndex + 9

		UIListLayout.Parent = DependencyHandler
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local Inner = ModernV2:RegisiterItem(DependencyHandler, DependencySignal);

		local function UpdateSize()
			local Matched = DependenciesMatch();
			local ShouldShow = IsRendered and (LockMode or Matched);
			local ContentHeight = UIListLayout.AbsoluteContentSize.Y;
			local TargetHeight = (ShouldShow and ContentHeight > 0) and (ContentHeight + 10) or 0;

			DependencyFrame.Visible = ShouldShow;
			DependencySignal:SetValue(IsRendered and (LockMode or Matched));
			DependencyBox:SetLocked(Config.Locked == true or (LockMode and not Matched));

			ModernV2.PlayAnimate(DependencyFrame, VSlowTween, {
				Size = UDim2.new(1, 0, 0, TargetHeight),
				BackgroundTransparency = ShouldShow and 0.500 or 1,
			});

			ModernV2.PlayAnimate(UIStroke, SlowyTween, {
				Transparency = ShouldShow and 0.650 or 1,
			});

			LastMatched = Matched;
		end;

		function DependencyBox:SetDependencies(dependencies)
			Config.Dependencies = dependencies or {};
			UpdateSize();
			return DependencyBox;
		end;

		function DependencyBox:GetDependencies()
			return Config.Dependencies;
		end;

		function DependencyBox:SetMode(mode)
			Config.Mode = tostring(mode or Config.Mode);
			Mode = string.lower(Config.Mode);
			LockMode = Mode == "locked" or Mode == "lock";
			UpdateSize();
			return DependencyBox;
		end;

		function DependencyBox:GetValue()
			return DependenciesMatch();
		end;

		function DependencyBox:SetVisible(value)
			IsRendered = value ~= false and Signel:GetValue() == true;
			UpdateSize();
			return DependencyBox;
		end;

		for key,value in next, Inner do
			if DependencyBox[key] == nil then
				DependencyBox[key] = value;
			end;
		end;

		ModernV2:AddSignal(UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize));

		Signel:Connect(function(value)
			IsRendered = value == true;
			UpdateSize();
		end);

		ModernV2:AddSignal(RunService.RenderStepped:Connect(function(dt)
			CheckAccumulator = CheckAccumulator + (dt or 0);

			if CheckAccumulator < 0.1 then
				return;
			end;

			CheckAccumulator = 0;

			local Matched = DependenciesMatch();
			if Matched ~= LastMatched then
				UpdateSize();
			end;
		end));

		UpdateSize();

		return CaseInsensitive(DependencyBox);
	end;

	function idx:AddDependencyGroupbox(Config)
		if typeof(Config) ~= "table" then
			Config = {
				Name = tostring(Config or "Dependency Groupbox"),
			};
		end;

		Config = ModernV2:ProcessParams(Config , {
			Name = "Dependency Groupbox",
			Dependencies = {},
			Mode = "Visible",
			Collapsible = false,
			Collapsed = false,
			Locked = false,
			TextLocked = "Dependency required",
		});

		local Groupbox = {};
		local GroupFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Title = Instance.new("TextLabel")
		local CollapseIcon = Instance.new("ImageLabel")
		local GroupHandler = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local GroupSignal = ModernV2:CreateSignal(false);
		local IsRendered = Signel:GetValue() == true;
		local LastMatched;
		local CheckAccumulator = 0;
		local HeaderHeight = 28;

		local Mode = string.lower(tostring(Config.Mode or "Visible"));
		local LockMode = Mode == "locked" or Mode == "lock";
		local Collapsible = Config.Collapsible == true;
		local Collapsed = Config.Collapsed == true;

		local function ResolveDependencyObject(value)
			if typeof(value) == "string" then
				return ModernV2.Flags[value] or value;
			end;

			return value;
		end;

		local function GetDependencyValue(object)
			object = ResolveDependencyObject(object);

			if typeof(object) == "table" and object.GetValue then
				local success, result = pcall(function()
					return object:GetValue();
				end);

				if success then
					return result;
				end;
			end;

			return object;
		end;

		local function CompareDependency(actual, expected)
			if typeof(expected) == "function" then
				local success, result = pcall(expected, actual);
				return success and result == true;
			end;

			if expected == nil then
				return actual == true;
			end;

			if typeof(actual) == "table" then
				if typeof(expected) == "table" then
					for key,value in next, expected do
						if actual[key] ~= value and actual[value] ~= true then
							return false;
						end;
					end;

					return true;
				end;

				return actual[expected] == true or table.find(actual, expected) ~= nil;
			end;

			return actual == expected;
		end;

		local function DependencyMatches(dependency)
			if typeof(dependency) ~= "table" then
				return GetDependencyValue(dependency) == true;
			end;

			local Object = dependency.Object or dependency.Element or dependency[1] or dependency.Flag;
			local Expected = dependency.Value;

			if Expected == nil then
				Expected = dependency.Expected or dependency.Equals or dependency[2];
			end;

			return CompareDependency(GetDependencyValue(Object), Expected);
		end;

		local function DependenciesMatch()
			local Dependencies = Config.Dependencies or {};

			if #Dependencies <= 0 then
				return true;
			end;

			for _,Dependency in ipairs(Dependencies) do
				if not DependencyMatches(Dependency) then
					return false;
				end;
			end;

			return true;
		end;

		GroupFrame.Name = ModernV2.RandomString();
		GroupFrame.Parent = Frame
		GroupFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		GroupFrame.BackgroundTransparency = 0.500
		GroupFrame.BorderSizePixel = 0
		GroupFrame.ClipsDescendants = true
		GroupFrame.Size = UDim2.new(1, 0, 0, 0)
		GroupFrame.ZIndex = LayerIndex + 8
		ModernV2:AttachLockMethods(Groupbox, GroupFrame, {
			Locked = Config.Locked == true or (LockMode and not DependenciesMatch()),
			TextLocked = Config.TextLocked,
		});

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = GroupFrame

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = GroupFrame

		Title.Name = ModernV2.RandomString();
		Title.Parent = GroupFrame
		Title.BackgroundTransparency = 1.000
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0, 11, 0, 7)
		Title.Size = UDim2.new(1, -45, 0, 16)
		Title.ZIndex = LayerIndex + 10
		Title.Font = Enum.Font.GothamMedium
		Title.Text = tostring(Config.Name)
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 13.000
		Title.TextTransparency = 0.200
		Title.TextXAlignment = Enum.TextXAlignment.Left
		ModernV2:AddTextGradient(Title);

		CollapseIcon.Name = ModernV2.RandomString();
		CollapseIcon.Parent = GroupFrame
		CollapseIcon.AnchorPoint = Vector2.new(1, 0)
		CollapseIcon.BackgroundTransparency = 1.000
		CollapseIcon.BorderSizePixel = 0
		CollapseIcon.Position = UDim2.new(1, -8, 0, 2)
		CollapseIcon.Size = UDim2.new(0, 22, 0, 22)
		CollapseIcon.Visible = Collapsible
		CollapseIcon.ZIndex = LayerIndex + 10
		ModernV2:SetIconMode(CollapseIcon, "chevron-small-down")
		CollapseIcon.ImageColor3 = Color3.fromRGB(223, 223, 223)
		CollapseIcon.ImageTransparency = 0.500
		CollapseIcon.ScaleType = Enum.ScaleType.Fit

		GroupHandler.Name = ModernV2.RandomString();
		GroupHandler.Parent = GroupFrame
		GroupHandler.AnchorPoint = Vector2.new(0.5, 0)
		GroupHandler.BackgroundTransparency = 1.000
		GroupHandler.BorderSizePixel = 0
		GroupHandler.ClipsDescendants = true
		GroupHandler.Position = UDim2.new(0.5, 0, 0, HeaderHeight)
		GroupHandler.Size = UDim2.new(1, -10, 1, -HeaderHeight - 5)
		GroupHandler.ZIndex = LayerIndex + 9

		UIListLayout.Parent = GroupHandler
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local Inner = ModernV2:RegisiterItem(GroupHandler, GroupSignal);

		local function UpdateSize()
			local Matched = DependenciesMatch();
			local ShouldShow = IsRendered and (LockMode or Matched);
			local ShowContent = ShouldShow and not Collapsed;
			local ContentHeight = UIListLayout.AbsoluteContentSize.Y;
			local TargetHeight = ShouldShow and HeaderHeight or 0;

			if ShowContent and ContentHeight > 0 then
				TargetHeight = ContentHeight + HeaderHeight + 5;
			end;

			GroupFrame.Visible = ShouldShow;
			GroupHandler.Visible = ShowContent;
			GroupSignal:SetValue(ShowContent);
			Groupbox:SetLocked(Config.Locked == true or (LockMode and not Matched));

			ModernV2.PlayAnimate(GroupFrame, VSlowTween, {
				Size = UDim2.new(1, 0, 0, TargetHeight),
				BackgroundTransparency = ShouldShow and 0.500 or 1,
			});

			ModernV2.PlayAnimate(UIStroke, SlowyTween, {
				Transparency = ShouldShow and 0.650 or 1,
			});

			ModernV2.PlayAnimate(Title, SlowyTween, {
				TextTransparency = ShouldShow and 0.200 or 1,
			});

			ModernV2.PlayAnimate(CollapseIcon, SlowyTween, {
				ImageTransparency = (ShouldShow and Collapsible) and 0.500 or 1,
				Rotation = Collapsed and -90 or 0,
			});

			LastMatched = Matched;
		end;

		function Groupbox:SetText(text)
			Config.Name = tostring(text or "");
			Title.Text = Config.Name;
			return Groupbox;
		end;

		function Groupbox:GetText()
			return Title.Text;
		end;

		function Groupbox:SetDependencies(dependencies)
			Config.Dependencies = dependencies or {};
			UpdateSize();
			return Groupbox;
		end;

		function Groupbox:GetDependencies()
			return Config.Dependencies;
		end;

		function Groupbox:SetMode(mode)
			Config.Mode = tostring(mode or Config.Mode);
			Mode = string.lower(Config.Mode);
			LockMode = Mode == "locked" or Mode == "lock";
			UpdateSize();
			return Groupbox;
		end;

		function Groupbox:GetValue()
			return DependenciesMatch();
		end;

		function Groupbox:SetCollapsed(value)
			Collapsed = value == true;
			Config.Collapsed = Collapsed;
			UpdateSize();
			return Groupbox;
		end;

		function Groupbox:ToggleCollapsed()
			return Groupbox:SetCollapsed(not Collapsed);
		end;

		function Groupbox:GetCollapsed()
			return Collapsed;
		end;

		function Groupbox:SetCollapsible(value)
			Collapsible = value == true;
			Config.Collapsible = Collapsible;
			CollapseIcon.Visible = Collapsible;

			if not Collapsible then
				Collapsed = false;
				Config.Collapsed = false;
			end;

			UpdateSize();
			return Groupbox;
		end;

		function Groupbox:SetVisible(value)
			IsRendered = value ~= false and Signel:GetValue() == true;
			UpdateSize();
			return Groupbox;
		end;

		for key,value in next, Inner do
			if Groupbox[key] == nil then
				Groupbox[key] = value;
			end;
		end;

		if Collapsible then
			local CollapseInput = ModernV2:CreateInput(GroupFrame, LPH_NO_VIRTUALIZE(function()
				Groupbox:ToggleCollapsed();
			end));
			CollapseInput.ZIndex = LayerIndex + 20;
			CollapseInput.Size = UDim2.new(1, 0, 0, HeaderHeight);
		end;

		ModernV2:AddSignal(UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize));

		Signel:Connect(function(value)
			IsRendered = value == true;
			UpdateSize();
		end);

		ModernV2:AddSignal(RunService.RenderStepped:Connect(function(dt)
			CheckAccumulator = CheckAccumulator + (dt or 0);

			if CheckAccumulator < 0.1 then
				return;
			end;

			CheckAccumulator = 0;

			local Matched = DependenciesMatch();
			if Matched ~= LastMatched then
				UpdateSize();
			end;
		end));

		UpdateSize();

		return CaseInsensitive(Groupbox);
	end;

	function idx:AddUserFrame(Name : string , Profile: string , Expires : string)
		local UserFrame = Instance.new("Frame")
		local UserLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local LogoImage = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local UserStatusLabel = Instance.new("TextLabel")

		UserFrame.Name = ModernV2.RandomString();
		UserFrame.Parent = Frame
		UserFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		UserFrame.BackgroundTransparency = 1.000
		UserFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserFrame.BorderSizePixel = 0
		UserFrame.Size = UDim2.new(1, 0, 0, 60)
		UserFrame.ZIndex = LayerIndex + 8

		UserLabel.Name = ModernV2.RandomString();
		UserLabel.Parent = UserFrame
		UserLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UserLabel.BackgroundTransparency = 1.000
		UserLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserLabel.BorderSizePixel = 0
		UserLabel.Position = UDim2.new(0, 65, 0, 10)
		UserLabel.Size = UDim2.new(1, -35, 0, 15)
		UserLabel.ZIndex = LayerIndex + 9
		UserLabel.Font = Enum.Font.GothamMedium
		UserLabel.Text = Name or 'User'
		UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		UserLabel.TextSize = 13.000
		UserLabel.TextTransparency = 0.200
		UserLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = ModernV2.RandomString();
		LineFrame.Parent = UserFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = UserFrame

		LogoImage.Name = ModernV2.RandomString();
		LogoImage.Parent = UserFrame
		LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogoImage.BackgroundTransparency = 1.000
		LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogoImage.BorderSizePixel = 0
		LogoImage.Position = UDim2.new(0, 10, 0, 5)
		LogoImage.Size = UDim2.new(0, 45, 0, 45)
		LogoImage.ZIndex = LayerIndex + 9
		LogoImage.Image = Profile or "rbxasset://textures/ui/clb_robux_20@3x.png";

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = LogoImage

		UserStatusLabel.Name = ModernV2.RandomString();
		UserStatusLabel.Parent = UserFrame
		UserStatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UserStatusLabel.BackgroundTransparency = 1.000
		UserStatusLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserStatusLabel.BorderSizePixel = 0
		UserStatusLabel.Position = UDim2.new(0, 65, 0, 25)
		UserStatusLabel.Size = UDim2.new(1, -35, 0, 15)
		UserStatusLabel.ZIndex = LayerIndex + 9
		UserStatusLabel.Font = Enum.Font.GothamMedium
		UserStatusLabel.Text = Expires or 'Never'
		UserStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		UserStatusLabel.TextSize = 13.000
		UserStatusLabel.TextTransparency = 0.200
		UserStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

		local UserFrameItem = {};

		UserFrameItem.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ModernV2.PlayAnimate(UserLabel,SlowyTween,{
					TextTransparency = 0.200
				})

				ModernV2.PlayAnimate(LineFrame,SlowyTween,{
					BackgroundTransparency = 0.650
				})

				ModernV2.PlayAnimate(LogoImage,SlowyTween,{
					ImageTransparency = 0
				})

				ModernV2.PlayAnimate(UserStatusLabel,SlowyTween,{
					TextTransparency = 0.200
				})
			else
				ModernV2.PlayAnimate(UserLabel,SlowyTween,{
					TextTransparency = 1
				})

				ModernV2.PlayAnimate(LineFrame,SlowyTween,{
					BackgroundTransparency = 1
				})

				ModernV2.PlayAnimate(LogoImage,SlowyTween,{
					ImageTransparency = 1
				})

				ModernV2.PlayAnimate(UserStatusLabel,SlowyTween,{
					TextTransparency = 1
				})
			end;
		end);

		UserFrameItem.SetRender(Signel:GetValue())
		Signel:Connect(UserFrameItem.SetRender);

		function UserFrameItem:SetUsername(name)
			UserLabel.Text = name or 'User'
		end;

		function UserFrameItem:SetProfile(Profile)
			LogoImage.Image = Profile or "rbxasset://textures/ui/clb_robux_20@3x.png";
		end;

		function UserFrameItem:SetExpires(Exp)
			UserStatusLabel.Text = Exp or 'Never';
		end;

		return CaseInsensitive(UserFrameItem);
	end;

	function idx:AddToggle(Config)
		if Config.Name then
			return self:AddLabel(Config.Name):AddToggle(Config)
		else
			error("Name is required for AddToggle in sections")
		end
	end

	function idx:AddSlider(Config)
		if Config.Name then
			return self:AddLabel(Config.Name):AddSlider(Config)
		else
			error("Name is required for AddSlider in sections")
		end
	end

	function idx:AddDropdown(Config)
		if Config.Name then
			return self:AddLabel(Config.Name):AddDropdown(Config)
		else
			error("Name is required for AddDropdown in sections")
		end
	end

	function idx:AddKeybind(Config)
		if Config.Name then
			return self:AddLabel(Config.Name):AddKeybind(Config)
		else
			error("Name is required for AddKeybind in sections")
		end
	end

	function idx:AddColorPicker(Config)
		if Config.Name then
			return self:AddLabel(Config.Name):AddColorPicker(Config)
		else
			error("Name is required for AddColorPicker in sections")
		end
	end

	function idx:AddTextInput(Config)
		if Config.Name then
			local IsTextarea = string.lower(tostring(Config.Type or "TextInput")) == "textarea";

			if IsTextarea then
				Config.FullWidth = Config.FullWidth ~= false;
				return self:AddLabel(Config.Name):SetStacked(true):AddTextInput(Config)
			end;

			return self:AddLabel(Config.Name):AddTextInput(Config)
		else
			error("Name is required for AddTextInput in sections")
		end
	end

	return CaseInsensitive(idx);
end;

function ModernV2:CreateWindow(Config)
	Config = Config or {};
	local ConfigSettings = (typeof(Config.Config) == "table" and Config.Config) or {};

	if Config.Title ~= nil and Config.Name == nil then
		Config.Name = Config.Title;
	end;

	if Config.Image ~= nil and Config.Logo == nil then
		local image = tostring(Config.Image);
		Config.Logo = (image:find("rbxassetid://",1,true) and image) or ("rbxassetid://"..image);
	end;

	if typeof(Config.Color) == "Color3" then
		ModernV2.AccentColor = Config.Color;
	end;

	if ConfigSettings.ConfigFolder ~= nil and Config.ConfigFolder == nil then
		Config.ConfigFolder = ConfigSettings.ConfigFolder;
	end;

	if ConfigSettings.TextGradient ~= nil and Config.TextGradient == nil then
		Config.TextGradient = ConfigSettings.TextGradient;
	end;

	if Config.Size == nil then
		Config.Size = ModernV2.IsMobile and ModernV2.Scales.Mobile or ModernV2.Scales.Large;
	end;

	Config = ModernV2:ProcessParams(Config , {
		Logo = ModernV2.GlobalLogo,
		Name = "ModernV2",
		Content = "Counter-Strike 2",
		Size = ModernV2.IsMobile and ModernV2.Scales.Mobile or ModernV2.Scales.Large,
		Font = nil,
		ConfigFolder = "ModernV2Configs",
		Uitransparent = nil,
		ShowUser = true,
		Search = true,
		ConfigEnabled = true,
		TextGradient = true,
		RunningText = false,
		NotifyOnCallbackError = false,
		Loadingscreen = false,
		Enable3DRenderer = false,
		Keybind = "RightControl"
	});

	ModernV2:SetTextGradientEnabled(Config.TextGradient);
	if Config.Font ~= nil then
		ModernV2:SetFont(Config.Font);
	end;

	Config.ConfigFolder = tostring(Config.ConfigFolder):gsub("[/\\]+$","");

	local Window = {
		Logo = Config.Logo,
		Name = Config.Name,
		Content = Config.Content,
		Size = Config.Size,
		ConfigFolder = Config.ConfigFolder,
		Font = Config.Font,
		Uitransparent = Config.Uitransparent,
		ShowUser = Config.ShowUser,
		SearchEnabled = Config.Search,
		ConfigEnabled = Config.ConfigEnabled and Config.Config ~= false,
		RunningText = Config.RunningText == true,
		ConfigAutoSaveFile = ConfigSettings.AutoSaveFile or "Default",
		ConfigAutoSave = ConfigSettings.AutoSave ~= false,
		ConfigAutoLoad = ConfigSettings.AutoLoad ~= false,
		ConfigOverwrite = ConfigSettings.Overwrite ~= false,
		ConfigEncrypted = ConfigSettings.Encrypted == true or string.lower(tostring(ConfigSettings.Format or "")) == "encoded",
		ConfigShowAutoSaveToggle = ConfigSettings.ShowAutoSaveToggle == true,
		ConfigSaveWindowState = ConfigSettings.SaveWindowState == true,
		Signal = ModernV2:CreateSignal(true),
		Tabs = {},
		CurrentTab = 1,
		NotifyOnCallbackError = Config.NotifyOnCallbackError == true,
		Loadingscreen = Config.Loadingscreen == true or Config.LoadingScreen == true or Config.Loading == true,
		OnDestroyCallbacks = {},
		Keybind = Config.Keybind,
		Enable3DRenderer = Config.Enable3DRenderer
	};

	if type(Config.OnDestroy) == "function" then
		table.insert(Window.OnDestroyCallbacks, Config.OnDestroy);
	end;

	ModernV2.GlobalLogo = Window.Logo;

	local Logging = ModernV2:CreateLogger();
	if not isfolder(Window.ConfigFolder) then
		makefolder(Window.ConfigFolder);
	end;

	local WindowFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local LeftMenuFrame = Instance.new("Frame")
	local HeadFrame = Instance.new("Frame")
	local LogoImage = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local WindowName = Instance.new("TextLabel")
	local WindowContent = Instance.new("TextLabel")
	local LineFrame = Instance.new("Frame")
	local LeftScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local BottomFrame = Instance.new("Frame")
	local AccountProfile = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local AccountName = Instance.new("TextLabel")
	local ExpireLabel = Instance.new("TextLabel")
	local LineFrame_2 = Instance.new("Frame")
	local UserSettingButton = Instance.new("ImageLabel")
	local RightMenuFrame = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UICorner_4 = Instance.new("UICorner")
	local RightHeader = Instance.new("Frame")
	local LineFrame_3 = Instance.new("Frame")
	local ConfigFrame = Instance.new("Frame")
	local UIStroke_2 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local ConfigIcon = Instance.new("ImageLabel")
	local LineFrame_4 = Instance.new("Frame")
	local ConfigName = Instance.new("TextLabel")
	local ConfigBthIcon = Instance.new("ImageLabel")
	local SearchFrame = Instance.new("Frame")
	local SearchIcon = Instance.new("ImageLabel")
	local SearchBox = Instance.new("TextBox")
	local CloseButton = Instance.new("ImageLabel")
	local TabContainer = Instance.new("Frame")

	WindowFrame.Name = ModernV2.RandomString();
	WindowFrame.Parent = ModernV2.ScreenGui;
	WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
	WindowFrame.BackgroundTransparency = Window.Uitransparent or 0.055
	WindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowFrame.BorderSizePixel = 0
	WindowFrame.ClipsDescendants = true
	WindowFrame.Position = UDim2.new(255, 0, 255, 0)
	WindowFrame.Size = Window.Size
	WindowFrame.Active = true;
	Window.Root = WindowFrame;

	if Window.Loadingscreen then
		local LoadingOverlay = Instance.new("Frame")
		local LoadingPanel = Instance.new("Frame")
		local LoadingCorner = Instance.new("UICorner")
		local LoadingStroke = Instance.new("UIStroke")
		local LoadingIcon = Instance.new("ImageLabel")
		local LoadingTitle = Instance.new("TextLabel")
		local LoadingContent = Instance.new("TextLabel")

		LoadingOverlay.Name = ModernV2.RandomString();
		LoadingOverlay.Parent = ModernV2.ScreenGui
		LoadingOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		LoadingOverlay.BackgroundTransparency = 1
		LoadingOverlay.BorderSizePixel = 0
		LoadingOverlay.Size = UDim2.fromScale(1, 1)
		LoadingOverlay.ZIndex = 250

		LoadingPanel.Name = ModernV2.RandomString();
		LoadingPanel.Parent = LoadingOverlay
		LoadingPanel.AnchorPoint = Vector2.new(0.5, 0.5)
		LoadingPanel.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		LoadingPanel.BackgroundTransparency = 1
		LoadingPanel.BorderSizePixel = 0
		LoadingPanel.Position = UDim2.fromScale(0.5, 0.5)
		LoadingPanel.Size = UDim2.fromOffset(260, 92)
		LoadingPanel.ZIndex = 251

		LoadingCorner.CornerRadius = UDim.new(0, 10)
		LoadingCorner.Parent = LoadingPanel

		LoadingStroke.Color = Color3.fromRGB(45, 48, 58)
		LoadingStroke.Transparency = 1
		LoadingStroke.Parent = LoadingPanel

		LoadingIcon.Name = ModernV2.RandomString();
		LoadingIcon.Parent = LoadingPanel
		LoadingIcon.BackgroundTransparency = 1
		LoadingIcon.BorderSizePixel = 0
		LoadingIcon.Position = UDim2.new(0, 18, 0.5, -17)
		LoadingIcon.Size = UDim2.fromOffset(34, 34)
		LoadingIcon.ZIndex = 252
		LoadingIcon.Image = Window.Logo
		LoadingIcon.ImageColor3 = ModernV2.IconColor
		LoadingIcon.ImageTransparency = 1

		LoadingTitle.Name = ModernV2.RandomString();
		LoadingTitle.Parent = LoadingPanel
		LoadingTitle.BackgroundTransparency = 1
		LoadingTitle.BorderSizePixel = 0
		LoadingTitle.Position = UDim2.new(0, 64, 0, 22)
		LoadingTitle.Size = UDim2.new(1, -82, 0, 20)
		LoadingTitle.ZIndex = 252
		LoadingTitle.Font = Enum.Font.GothamBold
		LoadingTitle.Text = tostring(Config.LoadingTitle or Window.Name)
		LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		LoadingTitle.TextSize = 15
		LoadingTitle.TextTransparency = 1
		LoadingTitle.TextXAlignment = Enum.TextXAlignment.Left
		ModernV2:AddTextGradient(LoadingTitle);

		LoadingContent.Name = ModernV2.RandomString();
		LoadingContent.Parent = LoadingPanel
		LoadingContent.BackgroundTransparency = 1
		LoadingContent.BorderSizePixel = 0
		LoadingContent.Position = UDim2.new(0, 64, 0, 45)
		LoadingContent.Size = UDim2.new(1, -82, 0, 18)
		LoadingContent.ZIndex = 252
		LoadingContent.Font = Enum.Font.GothamMedium
		LoadingContent.Text = tostring(Config.LoadingContent or "Loading...")
		LoadingContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		LoadingContent.TextSize = 12
		LoadingContent.TextTransparency = 1
		LoadingContent.TextXAlignment = Enum.TextXAlignment.Left

		ModernV2.PlayAnimate(LoadingOverlay, SlowyTween, { BackgroundTransparency = 0.250 })
		ModernV2.PlayAnimate(LoadingPanel, SlowyTween, { BackgroundTransparency = 0.035 })
		ModernV2.PlayAnimate(LoadingStroke, SlowyTween, { Transparency = 0.650 })
		ModernV2.PlayAnimate(LoadingIcon, SlowyTween, { ImageTransparency = 0 })
		ModernV2.PlayAnimate(LoadingTitle, SlowyTween, { TextTransparency = 0 })
		ModernV2.PlayAnimate(LoadingContent, SlowyTween, { TextTransparency = 0.350 })

		task.delay(tonumber(Config.LoadingDuration) or 1.15, function()
			if not LoadingOverlay.Parent then
				return;
			end;

			ModernV2.PlayAnimate(LoadingOverlay, SlowyTween, { BackgroundTransparency = 1 })
			ModernV2.PlayAnimate(LoadingPanel, SlowyTween, { BackgroundTransparency = 1 })
			ModernV2.PlayAnimate(LoadingStroke, SlowyTween, { Transparency = 1 })
			ModernV2.PlayAnimate(LoadingIcon, SlowyTween, { ImageTransparency = 1 })
			ModernV2.PlayAnimate(LoadingTitle, SlowyTween, { TextTransparency = 1 })
			ModernV2.PlayAnimate(LoadingContent, SlowyTween, { TextTransparency = 1 })

			task.delay(0.2, function()
				if LoadingOverlay.Parent then
					LoadingOverlay:Destroy();
				end;
			end);
		end);
	end;

	if not ModernV2.EnabledBlur then
		WindowFrame.BackgroundTransparency = Window.Uitransparent or 0.0255
	end;

	local renderParentWindow = LPH_NO_VIRTUALIZE(function()
		if Window.__3DRender then
			if WindowFrame.BackgroundTransparency > 0.9 then
				WindowFrame.Visible = false;
				WindowFrame.Parent = nil
			else
				WindowFrame.Visible = true;

				ModernV2.PlayAnimate(WindowFrame,VSlowTween , {
					Position = UDim2.fromScale(0.5,0.5);
				});

				WindowFrame.Parent = Window.SurfaceGui;
			end;
		else
			if WindowFrame.BackgroundTransparency > 0.9 then
				WindowFrame.Visible = false;
				WindowFrame.Parent = nil
			else
				WindowFrame.Visible = true;
				WindowFrame.Parent = ModernV2.ScreenGui


			end;
		end;
	end);

	ModernV2:AddSignal(WindowFrame:GetPropertyChangedSignal('BackgroundTransparency'):Connect(renderParentWindow))

	Window.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
		if value then
			ModernV2.PlayAnimate(WindowFrame , SlowyTween , {
				BackgroundTransparency = Window.Uitransparent or ((ModernV2.EnabledBlur and 0.055) or 0.0255),
				Size = Window.Size
			})

			ModernV2.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 0
			})

			ModernV2.PlayAnimate(WindowName , SlowyTween , {
				TextTransparency = 0
			})

			ModernV2.PlayAnimate(WindowContent , SlowyTween , {
				TextTransparency = 0.650
			})

			ModernV2.PlayAnimate(LineFrame , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			ModernV2.PlayAnimate(AccountProfile , SlowyTween , {
				ImageTransparency = 0
			})

			ModernV2.PlayAnimate(AccountName , SlowyTween , {
				TextTransparency = 0
			})

			ModernV2.PlayAnimate(ExpireLabel , SlowyTween , {
				TextTransparency = 0.650
			})

			ModernV2.PlayAnimate(LineFrame_2 , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			ModernV2.PlayAnimate(UserSettingButton , SlowyTween , {
				TextTransparency = 0.5
			})

			ModernV2.PlayAnimate(RightMenuFrame , SlowyTween , {
				BackgroundTransparency = 0.600
			})

			ModernV2.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			})

			ModernV2.PlayAnimate(LineFrame_3 , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			ModernV2.PlayAnimate(ConfigFrame , SlowyTween , {
				BackgroundTransparency = 0.750
			})

			ModernV2.PlayAnimate(UIStroke_2 , SlowyTween , {
				Transparency = 0.650
			})

			ModernV2.PlayAnimate(ConfigIcon , SlowyTween , {
				TextTransparency = 0.250
			})

			ModernV2.PlayAnimate(LineFrame_4 , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			ModernV2.PlayAnimate(ConfigName , SlowyTween , {
				TextTransparency = 0.350
			})

			ModernV2.PlayAnimate(ConfigBthIcon , SlowyTween , {
				TextTransparency = 0.250
			})

			ModernV2.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 0.250
			})

			ModernV2.PlayAnimate(SearchBox , SlowyTween , {
				TextTransparency = 0.350
			})

			ModernV2.PlayAnimate(CloseButton , SlowyTween , {
				TextTransparency = 0.450
			})

			Window.Shadow:Render(true);
		else

			ModernV2.PlayAnimate(WindowFrame , SlowyTween , {
				BackgroundTransparency = 1,
				Size = Window.Size + UDim2.fromOffset(-15,-15)
			})

			ModernV2.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 1
			})

			ModernV2.PlayAnimate(WindowName , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(WindowContent , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(LineFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(AccountProfile , SlowyTween , {
				ImageTransparency = 1
			})

			ModernV2.PlayAnimate(AccountName , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(ExpireLabel , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(LineFrame_2 , SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(UserSettingButton , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(RightMenuFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(LineFrame_3 , SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(ConfigFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(UIStroke_2 , SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(ConfigIcon , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(LineFrame_4 , SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(ConfigName , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(ConfigBthIcon , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(SearchBox , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(CloseButton , SlowyTween , {
				TextTransparency = 1
			})

			Window.Shadow:Render(false);
		end;
	end);

	Window.Shadow = ModernV2:CreateShadow(WindowFrame);
	Window.Shadow:Render(false);

	task.delay(0.25,function()
		WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		Window:SetRender(true);
		ModernV2:AddSignal(Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(...)
			Window:SetRender(...);
		end)))
	end)

	if ModernV2.EnabledBlur then
		ModernV2:CreateBlurModule(WindowFrame,Window.Signal);
	end;

	do
		local Frame = Instance.new("Frame")

		Frame.Parent = WindowFrame
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(1, 0, 0, 50)
		Frame.ZIndex = 7
		Frame.BackgroundTransparency = 1;

		ModernV2.Drag(Frame , WindowFrame , 0.15)
	end

	UICorner.Parent = WindowFrame

	LeftMenuFrame.Name = ModernV2.RandomString();
	LeftMenuFrame.Parent = WindowFrame
	LeftMenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LeftMenuFrame.BackgroundTransparency = 1.000
	LeftMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LeftMenuFrame.BorderSizePixel = 0
	LeftMenuFrame.Size = UDim2.new(0, 175, 1, 0)

	HeadFrame.Name = ModernV2.RandomString();
	HeadFrame.Parent = LeftMenuFrame
	HeadFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeadFrame.BackgroundTransparency = 1.000
	HeadFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeadFrame.BorderSizePixel = 0
	HeadFrame.ClipsDescendants = true
	HeadFrame.Size = UDim2.new(1, 0, 0, 50)
	HeadFrame.ZIndex = 7

	LogoImage.Name = ModernV2.RandomString();
	LogoImage.Parent = HeadFrame
	LogoImage.AnchorPoint = Vector2.new(0, 0.5)
	LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoImage.BackgroundTransparency = 1.000
	LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoImage.BorderSizePixel = 0
	LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
	LogoImage.Size = UDim2.new(0, 35, 0, 35)
	LogoImage.ZIndex = 7
	LogoImage.Image = Window.Logo
	LogoImage.ImageColor3 = ModernV2.IconColor

	UICorner_2.CornerRadius = UDim.new(0, 7)
	UICorner_2.Parent = LogoImage

	WindowName.Name = ModernV2.RandomString();
	WindowName.Parent = HeadFrame
	WindowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.BackgroundTransparency = 1.000
	WindowName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowName.BorderSizePixel = 0
	WindowName.Position = UDim2.new(0, 55, 0, 4)
	WindowName.Size = UDim2.new(1, -65, 0, 25)
	WindowName.ZIndex = 7
	WindowName.Font = Enum.Font.GothamBold
	WindowName.Text = Window.Name
	WindowName.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.TextSize = 18.000
	WindowName.TextXAlignment = Enum.TextXAlignment.Left
	ModernV2:AddTextGradient(WindowName);

	WindowContent.Name = ModernV2.RandomString();
	WindowContent.Parent = HeadFrame
	WindowContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowContent.BackgroundTransparency = 1.000
	WindowContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowContent.BorderSizePixel = 0
	WindowContent.Position = UDim2.new(0, 55, 0, 25)
	WindowContent.Size = UDim2.new(1, -65, 0, 15)
	WindowContent.ZIndex = 7
	WindowContent.Font = Enum.Font.GothamBold
	WindowContent.Text = Window.Content
	WindowContent.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowContent.TextSize = 9.000
	WindowContent.TextTransparency = 0.650
	WindowContent.TextXAlignment = Enum.TextXAlignment.Left
	WindowContent.TextTruncate = Enum.TextTruncate.None

	local function EnableHeaderAutoFit(Label, MaxTextSize, MinTextSize)
		MaxTextSize = MaxTextSize or Label.TextSize;
		MinTextSize = MinTextSize or 6;

		local function Refresh()
			task.defer(function()
				if not Label or not Label.Parent then
					return;
				end;

				local Width = math.max(1, Label.AbsoluteSize.X);
				local TextSize = MaxTextSize;

				while TextSize > MinTextSize and TextService:GetTextSize(
					Label.Text,
					TextSize,
					Label.Font,
					Vector2.new(math.huge, Label.AbsoluteSize.Y)
				).X > Width do
					TextSize = TextSize - 1;
				end;

				Label.TextSize = TextSize;
			end);
		end;

		ModernV2:AddSignal(Label:GetPropertyChangedSignal("Text"):Connect(Refresh));
		ModernV2:AddSignal(Label:GetPropertyChangedSignal("AbsoluteSize"):Connect(Refresh));
		Refresh();
	end;

	local function EnableHeaderRunningText(Label, Speed, Gap)
		Speed = Speed or 22;
		Gap = Gap or 45;

		local Clip = Instance.new("Frame");
		Clip.Name = ModernV2.RandomString();
		Clip.Parent = Label.Parent;
		Clip.BackgroundTransparency = 1;
		Clip.BorderSizePixel = 0;
		Clip.ClipsDescendants = true;
		Clip.Position = Label.Position;
		Clip.Size = Label.Size;
		Clip.ZIndex = Label.ZIndex;

		Label.Parent = Clip;
		Label.Position = UDim2.fromOffset(0, 0);
		Label.Size = UDim2.fromScale(1, 1);
		Label.TextTruncate = Enum.TextTruncate.None;

		local Clone = Label:Clone();
		Clone.Name = ModernV2.RandomString();
		Clone.Parent = Clip;
		Clone.Position = UDim2.fromOffset(0, 0);
		Clone.TextTruncate = Enum.TextTruncate.None;
		Clone.Visible = false;

		local TextWidth = 0;
		local ClipWidth = 0;
		local Overflow = false;
		local StartTick = tick();

		local function SyncClone()
			Clone.Text = Label.Text;
			Clone.TextColor3 = Label.TextColor3;
			Clone.TextTransparency = Label.TextTransparency;
			Clone.Font = Label.Font;
			Clone.FontFace = Label.FontFace;
			Clone.TextSize = Label.TextSize;
		end;

		local function Refresh()
			task.defer(function()
				if not Label.Parent or not Clip.Parent then
					return;
				end;

				SyncClone();
				TextWidth = math.ceil(TextService:GetTextSize(Label.Text, Label.TextSize, Label.Font, Vector2.new(math.huge, Clip.AbsoluteSize.Y)).X);
				ClipWidth = math.max(1, Clip.AbsoluteSize.X);
				Overflow = TextWidth > ClipWidth;

				if Overflow then
					Label.Size = UDim2.new(0, TextWidth, 1, 0);
					Clone.Size = UDim2.new(0, TextWidth, 1, 0);
					Clone.Visible = true;
					StartTick = tick();
				else
					Label.Position = UDim2.fromOffset(0, 0);
					Label.Size = UDim2.fromScale(1, 1);
					Clone.Visible = false;
				end;
			end);
		end;

		ModernV2:AddSignal(Label:GetPropertyChangedSignal("Text"):Connect(Refresh));
		ModernV2:AddSignal(Label:GetPropertyChangedSignal("TextSize"):Connect(Refresh));
		ModernV2:AddSignal(Label:GetPropertyChangedSignal("TextTransparency"):Connect(SyncClone));
		ModernV2:AddSignal(Label:GetPropertyChangedSignal("TextColor3"):Connect(SyncClone));
		ModernV2:AddSignal(Clip:GetPropertyChangedSignal("AbsoluteSize"):Connect(Refresh));
		ModernV2:AddSignal(RunService.RenderStepped:Connect(function()
			if not Label.Parent or not Clip.Parent then
				return;
			end;

			if not Overflow then
				return;
			end;

			local Cycle = TextWidth + Gap;
			local X = -(((tick() - StartTick) * Speed) % Cycle);
			Label.Position = UDim2.fromOffset(X, 0);
			Clone.Position = UDim2.fromOffset(X + Cycle, 0);
		end));

		Refresh();

		return Clip;
	end;

	EnableHeaderAutoFit(WindowContent, 9, 6);

	if Window.RunningText then
		EnableHeaderRunningText(WindowName, 24, 50);
	else
		WindowName.TextTruncate = Enum.TextTruncate.None;
	end;

	LineFrame.Name = ModernV2.RandomString();
	LineFrame.Parent = HeadFrame
	LineFrame.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame.BackgroundTransparency = 0.650
	LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame.BorderSizePixel = 0
	LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame.Size = UDim2.new(1, -10, 0, 1)
	LineFrame.ZIndex = 5

	LeftScrollingFrame.Name = ModernV2.RandomString();
	LeftScrollingFrame.Parent = LeftMenuFrame
	LeftScrollingFrame.Active = true
	LeftScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
	LeftScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LeftScrollingFrame.BackgroundTransparency = 1.000
	LeftScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LeftScrollingFrame.BorderSizePixel = 0
	LeftScrollingFrame.Position = UDim2.new(0.5, 0, 0, 60)
	LeftScrollingFrame.Size = UDim2.new(1, -10, 1, -115)
	LeftScrollingFrame.ZIndex = 7
	LeftScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = LeftScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	ModernV2:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
		LeftScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 1)
	end)))

	BottomFrame.Name = ModernV2.RandomString();
	BottomFrame.Parent = LeftMenuFrame
	BottomFrame.AnchorPoint = Vector2.new(0, 1)
	BottomFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BottomFrame.BackgroundTransparency = 1.000
	BottomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BottomFrame.BorderSizePixel = 0
	BottomFrame.Position = UDim2.new(0, 0, 1, 0)
	BottomFrame.Size = UDim2.new(1, 0, 0, 50)
	BottomFrame.ZIndex = 7

	AccountProfile.Name = ModernV2.RandomString();
	AccountProfile.Parent = BottomFrame
	AccountProfile.AnchorPoint = Vector2.new(0, 0.5)
	AccountProfile.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AccountProfile.BackgroundTransparency = 1.000
	AccountProfile.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AccountProfile.BorderSizePixel = 0
	AccountProfile.Position = UDim2.new(0, 10, 0.5, 0)
	AccountProfile.Size = UDim2.new(0, 35, 0, 35)
	AccountProfile.ZIndex = 7
	AccountProfile.Image = ModernV2.UserProfile or ""

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = AccountProfile

	AccountName.Name = ModernV2.RandomString();
	AccountName.Parent = BottomFrame
	AccountName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AccountName.BackgroundTransparency = 1.000
	AccountName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AccountName.BorderSizePixel = 0
	AccountName.Position = UDim2.new(0, 55, 0, 5)
	AccountName.Size = UDim2.new(0, 100, 0, 25)
	AccountName.ZIndex = 7
	AccountName.Font = Enum.Font.GothamBold
	AccountName.Text = ""
	AccountName.TextColor3 = Color3.fromRGB(255, 255, 255)
	AccountName.TextSize = 14.000
	AccountName.TextXAlignment = Enum.TextXAlignment.Left
	AccountName.TextTruncate = Enum.TextTruncate.SplitWord;

	ExpireLabel.Name = ModernV2.RandomString();
	ExpireLabel.Parent = BottomFrame
	ExpireLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ExpireLabel.BackgroundTransparency = 1.000
	ExpireLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExpireLabel.BorderSizePixel = 0
	ExpireLabel.Position = UDim2.new(0, 55, 0, 25)
	ExpireLabel.Size = UDim2.new(0, 200, 0, 15)
	ExpireLabel.ZIndex = 7
	ExpireLabel.Font = Enum.Font.GothamBold
	ExpireLabel.Text = "never"
	ExpireLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ExpireLabel.TextSize = 10.000
	ExpireLabel.TextTransparency = 0.650
	ExpireLabel.TextXAlignment = Enum.TextXAlignment.Left

	LineFrame_2.Name = ModernV2.RandomString();
	LineFrame_2.Parent = BottomFrame
	LineFrame_2.AnchorPoint = Vector2.new(0.5, 0)
	LineFrame_2.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_2.BackgroundTransparency = 0.650
	LineFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_2.BorderSizePixel = 0
	LineFrame_2.Position = UDim2.new(0.5, 0, 0, 0)
	LineFrame_2.Size = UDim2.new(1, -10, 0, 1)
	LineFrame_2.ZIndex = 5

	UserSettingButton.Name = ModernV2.RandomString();
	UserSettingButton.Parent = BottomFrame
	UserSettingButton.AnchorPoint = Vector2.new(1, 0.5)
	UserSettingButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserSettingButton.BackgroundTransparency = 1.000
	UserSettingButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserSettingButton.BorderSizePixel = 0
	UserSettingButton.Position = UDim2.new(1, -7, 0.5, 0)
	UserSettingButton.Size = UDim2.new(0, 25, 0, 25)
	UserSettingButton.ZIndex = 7
	ModernV2:SetIconMode(UserSettingButton, "chevron-large-right")
	UserSettingButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	UserSettingButton.ImageTransparency = 0.5
	UserSettingButton.ScaleType = Enum.ScaleType.Fit

	if not Window.ShowUser then
		AccountProfile.Image = "";
		AccountProfile.ImageTransparency = 1;
		AccountProfile.BackgroundColor3 = Color3.fromRGB(26, 28, 36);
		AccountProfile.BackgroundTransparency = 0.250;
		ModernV2:SetIconMode(AccountProfile, "gear");
		AccountProfile.ImageColor3 = ModernV2.AccentColor;
		AccountProfile.ImageTransparency = 0.050;

		AccountName.Text = "Settings";
		AccountName.Size = UDim2.new(0, 120, 0, 25);
		ExpireLabel.Text = "Customize menu";
		ExpireLabel.Size = UDim2.new(0, 120, 0, 15);
	end;

	ModernV2:AddSignal(BottomFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
		ModernV2.PlayAnimate(UserSettingButton,SlowyTween , {
			TextTransparency = 0.25
		})		
	end)))

	ModernV2:AddSignal(BottomFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
		ModernV2.PlayAnimate(UserSettingButton,SlowyTween , {
			TextTransparency = 0.5
		})		
	end)))

	RightMenuFrame.Name = ModernV2.RandomString();
	RightMenuFrame.Parent = WindowFrame
	RightMenuFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
	RightMenuFrame.BackgroundTransparency = 0.600
	RightMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RightMenuFrame.BorderSizePixel = 0
	RightMenuFrame.ClipsDescendants = true
	RightMenuFrame.Position = UDim2.new(0, 176, 0, 0)
	RightMenuFrame.Size = UDim2.new(1, -176, 1, 0)
	RightMenuFrame.ZIndex = 8

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = RightMenuFrame

	UICorner_4.CornerRadius = UDim.new(0, 13)
	UICorner_4.Parent = RightMenuFrame

	RightHeader.Name = ModernV2.RandomString();
	RightHeader.Parent = RightMenuFrame
	RightHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	RightHeader.BackgroundTransparency = 1.000
	RightHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RightHeader.BorderSizePixel = 0
	RightHeader.Size = UDim2.new(1, 0, 0, 50)
	RightHeader.ZIndex = 9

	LineFrame_3.Name = ModernV2.RandomString();
	LineFrame_3.Parent = RightHeader
	LineFrame_3.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame_3.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_3.BackgroundTransparency = 0.650
	LineFrame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_3.BorderSizePixel = 0
	LineFrame_3.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame_3.Size = UDim2.new(1, -10, 0, 1)
	LineFrame_3.ZIndex = 9

	ConfigFrame.Name = ModernV2.RandomString();
	ConfigFrame.Parent = RightHeader
	ConfigFrame.AnchorPoint = Vector2.new(0, 0.5)
	ConfigFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 22)
	ConfigFrame.BackgroundTransparency = 0.750
	ConfigFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigFrame.BorderSizePixel = 0
	ConfigFrame.Position = UDim2.new(0, 10, 0.5, 0)
	ConfigFrame.Size = UDim2.new(0, 115, 0, 30)
	ConfigFrame.ZIndex = 9

	UIStroke_2.Transparency = 0.650
	UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
	UIStroke_2.Parent = ConfigFrame

	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = ConfigFrame

	ConfigIcon.Name = ModernV2.RandomString();
	ConfigIcon.Parent = ConfigFrame
	ConfigIcon.AnchorPoint = Vector2.new(0, 0.5)
	ConfigIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigIcon.BackgroundTransparency = 1.000
	ConfigIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigIcon.BorderSizePixel = 0
	ConfigIcon.Position = UDim2.new(0, 2, 0.5, 0)
	ConfigIcon.Size = UDim2.new(0, 25, 0, 25)
	ConfigIcon.ZIndex = 9
	ModernV2:SetIconMode(ConfigIcon, "pencil-square")
	ConfigIcon.ImageColor3 = Color3.fromRGB(223, 223, 223)
	ConfigIcon.ImageTransparency = 0.250
	ConfigIcon.ScaleType = Enum.ScaleType.Fit

	LineFrame_4.Name = ModernV2.RandomString();
	LineFrame_4.Parent = ConfigFrame
	LineFrame_4.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_4.BackgroundTransparency = 0.650
	LineFrame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_4.BorderSizePixel = 0
	LineFrame_4.Position = UDim2.new(0, 30, 0, 0)
	LineFrame_4.Size = UDim2.new(0, 1, 1, 0)

	ConfigName.Name = ModernV2.RandomString();
	ConfigName.Parent = ConfigFrame
	ConfigName.AnchorPoint = Vector2.new(0, 0.5)
	ConfigName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigName.BackgroundTransparency = 1.000
	ConfigName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigName.BorderSizePixel = 0
	ConfigName.Position = UDim2.new(0, 40, 0.5, 0)
	ConfigName.Size = UDim2.new(1, -7, 0, 15)
	ConfigName.ZIndex = 9
	ConfigName.Font = Enum.Font.GothamMedium
	ConfigName.Text = "Default"
	ConfigName.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConfigName.TextSize = 12.000
	ConfigName.TextTransparency = 0.350
	ConfigName.TextXAlignment = Enum.TextXAlignment.Left

	ConfigBthIcon.Name = ModernV2.RandomString();
	ConfigBthIcon.Parent = ConfigFrame
	ConfigBthIcon.AnchorPoint = Vector2.new(1, 0.5)
	ConfigBthIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigBthIcon.BackgroundTransparency = 1.000
	ConfigBthIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigBthIcon.BorderSizePixel = 0
	ConfigBthIcon.Position = UDim2.new(1, -2, 0.5, 0)
	ConfigBthIcon.Size = UDim2.new(0, 25, 0, 25)
	ConfigBthIcon.ZIndex = 9
	ModernV2:SetIconMode(ConfigBthIcon, "chevron-small-down")
	ConfigBthIcon.ImageColor3 = Color3.fromRGB(223, 223, 223)
	ConfigBthIcon.ImageTransparency = 0.250
	ConfigBthIcon.ScaleType = Enum.ScaleType.Fit

	SearchFrame.Name = ModernV2.RandomString();
	SearchFrame.Parent = RightHeader
	SearchFrame.AnchorPoint = Vector2.new(1, 0.5)
	SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchFrame.BackgroundTransparency = 1.000
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.ClipsDescendants = true
	SearchFrame.Position = UDim2.new(1, -45, 0.5, 0)
	SearchFrame.Size = UDim2.new(0, 30, 0, 30)
	SearchFrame.ZIndex = 12

	SearchIcon.Name = ModernV2.RandomString();
	SearchIcon.Parent = SearchFrame
	SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
	SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchIcon.BackgroundTransparency = 1.000
	SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchIcon.BorderSizePixel = 0
	SearchIcon.Position = UDim2.new(0, 2, 0.5, 0)
	SearchIcon.Size = UDim2.new(0, 25, 0, 25)
	SearchIcon.ZIndex = 12
	ModernV2:SetIconMode(SearchIcon, "magnifying-glass")
	SearchIcon.ImageColor3 = Color3.fromRGB(223, 223, 223)
	SearchIcon.ImageTransparency = 0.45
	SearchIcon.ScaleType = Enum.ScaleType.Fit

	SearchBox.Name = ModernV2.RandomString();
	SearchBox.Parent = SearchFrame
	SearchBox.AnchorPoint = Vector2.new(0, 0.5)
	SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.BackgroundTransparency = 1.000
	SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchBox.BorderSizePixel = 0
	SearchBox.Position = UDim2.new(0, 35, 0.5, 0)
	SearchBox.Size = UDim2.new(1, -35, 0, 25)
	SearchBox.ZIndex = 12
	SearchBox.ClearTextOnFocus = false
	SearchBox.Font = Enum.Font.GothamMedium
	SearchBox.PlaceholderText = "Search"
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.TextSize = 13.000
	SearchBox.TextTransparency = 1
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	CloseButton.Name = ModernV2.RandomString();
	CloseButton.Parent = RightHeader
	CloseButton.AnchorPoint = Vector2.new(1, 0.5)
	CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.BackgroundTransparency = 1.000
	CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseButton.BorderSizePixel = 0
	CloseButton.Position = UDim2.new(1, -10, 0.5, 0)
	CloseButton.Size = UDim2.new(0, 30, 0, 30)
	CloseButton.ZIndex = 12
	ModernV2:SetIconMode(CloseButton, "x")
	CloseButton.ImageColor3 = Color3.fromRGB(223, 223, 223)
	CloseButton.ImageTransparency = 0.45
	CloseButton.ScaleType = Enum.ScaleType.Fit

	TabContainer.Name = ModernV2.RandomString();
	TabContainer.Parent = RightMenuFrame
	TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabContainer.BackgroundTransparency = 1.000
	TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabContainer.BorderSizePixel = 0
	TabContainer.ClipsDescendants = true
	TabContainer.Position = UDim2.new(0, 0, 0, 50)
	TabContainer.Size = UDim2.new(1, 0, 1, -50)
	TabContainer.ZIndex = 5

	if Window.SearchEnabled then
		Window.Searching = false;
		local Input = ModernV2:CreateInput(SearchIcon , LPH_NO_VIRTUALIZE(function()
			Window.Searching = not Window.Searching;

			if Window.Searching then
				ModernV2.PlayAnimate(SearchFrame , VSlowTween , {
					Size = UDim2.new(0, 220, 0, 30)
				})

				ModernV2.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.25
				})

				ModernV2.PlayAnimate(SearchBox , VSlowTween , {
					TextTransparency = 0.350
				})
			else
				ModernV2.PlayAnimate(SearchFrame , VSlowTween , {
					Size = UDim2.new(0, 30, 0, 30)
				})

				ModernV2.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.45
				})

				ModernV2.PlayAnimate(SearchBox , SlowyTween , {
					TextTransparency = 1
				})

				SearchBox.Text = "";
			end;
		end));	

		local wati_for_finish = tick();
		local last_thread;
		local max_time = 0.2;

		ModernV2:AddSignal(SearchBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
			if not SearchBox.Text:byte() then
				for i,v in next , ModernV2.NameRegisitry do
					v.Root.Visible = true;
				end;

				return;	
			end;

			wati_for_finish = tick();

			if last_thread then
				task.cancel(last_thread);
				last_thread = nil;
			end;

			last_thread = task.delay(max_time,function()
				if SearchBox.Text:byte() and (tick() - wati_for_finish) > max_time then
					local RevealedMatch = false;

					for i,v in next , ModernV2.NameRegisitry do
						if string.find(string.lower(v.Idx) , string.lower(SearchBox.Text), 1, true) then
							v.Root.Visible = true;

							if not RevealedMatch then
								RevealedMatch = true;
								ModernV2:RevealQueryItem(v);
							end;
						else
							v.Root.Visible = false;
						end;
					end;
				end;
			end);
		end)));

		ModernV2:AddSignal(Input.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 0.25
			})
		end)))

		ModernV2:AddSignal(Input.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Searching then
				ModernV2.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.25
				})
			else
				ModernV2.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.45
				})
			end;
		end)));
	else
		SearchFrame.Visible = false;
	end;

	do
		local Input = ModernV2:CreateInput(CloseButton , LPH_NO_VIRTUALIZE(function()
			Window:Dialog({
				Title = "Destroy Window?",
				Content = "Are you sure you want to destroy this window?",
				Buttons = {
					{
						Text = "Cancel",
						ReturnValue = false,
					},
					{
						Text = "Yes",
						Primary = true,
						ReturnValue = true,
					},
				},
				Callback = function(result)
					if result == true then
						Window:Destroy();
					end;
				end,
			});
		end));

		ModernV2:AddSignal(Input.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(CloseButton , SlowyTween , {
				TextTransparency = 0.150
			})
		end)))

		ModernV2:AddSignal(Input.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(CloseButton , SlowyTween , {
				TextTransparency = Window.Signal:GetValue() and 0.450 or 1
			})
		end)))
	end;

	if Window.Enable3DRenderer then
		local Part = Instance.new('Part');

		Part.Name = ModernV2.RandomString();
		Part.Anchored = true;
		Part.Transparency = 1;
		Part.CanCollide = false;
		Part.CanTouch = false;
		Part.AudioCanCollide = false;
		Part.CollisionGroup = ModernV2.RandomString();
		Part.CFrame = CFrame.new(0,0,0);
		Part.Size = Vector3.zero;

		local SurfaceGui = Instance.new("SurfaceGui")

		SurfaceGui.Parent = ModernV2.ScreenGui;
		SurfaceGui.Adornee = Part;
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		SurfaceGui.AlwaysOnTop = true
		SurfaceGui.LightInfluence = 1.000
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
		SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize;
		SurfaceGui.PixelsPerStud = 40;

		Window.SurfaceGui = SurfaceGui;
		ModernV2.GlobalSurfaceGui = SurfaceGui;

		local PerfectScale = Vector2.new(1920 , 1080 + 300)

		Window.Load3DBlock = LPH_NO_VIRTUALIZE(function()
			if not Window.Signal:GetValue() then
				local _,OnScreen = CurrentCamera:WorldToViewportPoint(Part.Position);

				if OnScreen then
					ModernV2.PlayAnimate(Part,VSlowTween , {
						CFrame = CurrentCamera.CFrame * CFrame.new(0,0,-15) * CFrame.Angles(0,math.rad(180),0);
					});
				end;

				return
			end;

			local Dimensions = 50;

			local XY_Incom = Vector2.new(PerfectScale.X + 5, PerfectScale.Y * 1.35) / (Dimensions / 2);
			local PerfectDistance = XY_Incom.Magnitude;
			local SizeIndicator = PerfectDistance / 1.35;

			Part.Parent = ModernV2.BlurModuleParent or workspace;

			ModernV2.PlayAnimate(Part,VSlowTween , {
				CFrame = (CurrentCamera.CFrame * CFrame.new(0,0,-25)) * CFrame.Angles(0,math.rad(180),0);
			});

			Part.Size = Vector3.new(PerfectScale.X / SizeIndicator,PerfectScale.Y / SizeIndicator,0);
		end);

		function Window:Set3DRender(val)
			Window.__3DRender = val;
			ModernV2.Global3DRenderMode = val;

			if val then
				Window.Load3DBlock();
			else


				Part.Parent = nil;
			end;

			renderParentWindow();
		end;
	end;

	function Window:AddTabLabel(Name: string)
		local TabLabel = Instance.new("TextLabel")

		TabLabel.Name = ModernV2.RandomString()
		TabLabel.Parent = LeftScrollingFrame
		TabLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabLabel.BackgroundTransparency = 1.000
		TabLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabLabel.BorderSizePixel = 0
		TabLabel.Size = UDim2.new(1, -7, 0, 15)
		TabLabel.ZIndex = 8
		TabLabel.Font = Enum.Font.GothamMedium
		TabLabel.Text = Name
		TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabLabel.TextSize = 11.000
		TabLabel.TextTransparency = 0.500
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left

		local SetRender = LPH_NO_VIRTUALIZE(function(val)
			if val then
				ModernV2.PlayAnimate(TabLabel , SlowyTween,{
					TextTransparency = 0.500
				})
			else
				ModernV2.PlayAnimate(TabLabel , SlowyTween,{
					TextTransparency = 1
				})
			end
		end)

		SetRender(Window.Signal:GetValue());

		return Window.Signal:Connect(SetRender);
	end;

	function Window:AddCategory(Config)
		if typeof(Config) ~= "table" then
			Config = {
				Name = tostring(Config or "Category"),
			};
		end;

		Config = ModernV2:ProcessParams(Config , {
			Name = "Category",
			Icon = "",
			Open = true,
		});

		local Category = {
			Tabs = {},
			Open = Config.Open ~= false,
		};

		local CategoryRoot = Instance.new("Frame")
		local CategoryLayout = Instance.new("UIListLayout")
		local Header = Instance.new("Frame")
		local HeaderCorner = Instance.new("UICorner")
		local HeaderStroke = Instance.new("UIStroke")
		local HeaderIcon = Instance.new("ImageLabel")
		local HeaderLabel = Instance.new("TextLabel")
		local ChevronIcon = Instance.new("ImageLabel")
		local TabsHolder = Instance.new("Frame")
		local TabsLayout = Instance.new("UIListLayout")

		CategoryRoot.Name = ModernV2.RandomString();
		CategoryRoot.Parent = LeftScrollingFrame
		CategoryRoot.BackgroundTransparency = 1
		CategoryRoot.BorderSizePixel = 0
		CategoryRoot.ClipsDescendants = true
		CategoryRoot.Size = UDim2.new(1, -1, 0, 30)
		CategoryRoot.ZIndex = 8

		CategoryLayout.Parent = CategoryRoot
		CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
		CategoryLayout.Padding = UDim.new(0, 5)

		Header.Name = ModernV2.RandomString();
		Header.Parent = CategoryRoot
		Header.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		Header.BackgroundTransparency = 0.250
		Header.BorderSizePixel = 0
		Header.ClipsDescendants = true
		Header.Size = UDim2.new(1, 0, 0, 30)
		Header.ZIndex = 8

		HeaderCorner.CornerRadius = UDim.new(0, 6)
		HeaderCorner.Parent = Header

		HeaderStroke.Color = Color3.fromRGB(45, 48, 58)
		HeaderStroke.Transparency = 0.700
		HeaderStroke.Parent = Header

		HeaderIcon.Name = ModernV2.RandomString();
		HeaderIcon.Parent = Header
		HeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
		HeaderIcon.BackgroundTransparency = 1
		HeaderIcon.BorderSizePixel = 0
		HeaderIcon.Position = UDim2.new(0, 8, 0.5, 0)
		HeaderIcon.Size = UDim2.new(0, 16, 0, 16)
		HeaderIcon.ZIndex = 9
		HeaderIcon.ImageColor3 = ModernV2.IconColor
		HeaderIcon.ScaleType = Enum.ScaleType.Fit
		ModernV2:SetIconMode(HeaderIcon, Config.Icon)
		HeaderIcon.Visible = tostring(Config.Icon or "") ~= ""

		HeaderLabel.Name = ModernV2.RandomString();
		HeaderLabel.Parent = Header
		HeaderLabel.AnchorPoint = Vector2.new(0, 0.5)
		HeaderLabel.BackgroundTransparency = 1
		HeaderLabel.BorderSizePixel = 0
		HeaderLabel.Position = HeaderIcon.Visible and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
		HeaderLabel.Size = HeaderIcon.Visible and UDim2.new(1, -58, 0, 16) or UDim2.new(1, -38, 0, 16)
		HeaderLabel.ZIndex = 9
		HeaderLabel.Font = Enum.Font.GothamMedium
		HeaderLabel.Text = Config.Name
		HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		HeaderLabel.TextSize = 12.000
		HeaderLabel.TextTransparency = 0.080
		HeaderLabel.TextTruncate = Enum.TextTruncate.AtEnd
		HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left

		ChevronIcon.Name = ModernV2.RandomString();
		ChevronIcon.Parent = Header
		ChevronIcon.AnchorPoint = Vector2.new(1, 0.5)
		ChevronIcon.BackgroundTransparency = 1
		ChevronIcon.BorderSizePixel = 0
		ChevronIcon.Position = UDim2.new(1, -7, 0.5, 0)
		ChevronIcon.Size = UDim2.new(0, 16, 0, 16)
		ChevronIcon.ZIndex = 9
		ChevronIcon.ImageColor3 = Color3.fromRGB(223, 223, 223)
		ChevronIcon.ImageTransparency = 0.350
		ChevronIcon.ScaleType = Enum.ScaleType.Fit
		ModernV2:SetIconMode(ChevronIcon, "chevron-small-down")

		TabsHolder.Name = ModernV2.RandomString();
		TabsHolder.Parent = CategoryRoot
		TabsHolder.BackgroundTransparency = 1
		TabsHolder.BorderSizePixel = 0
		TabsHolder.ClipsDescendants = true
		TabsHolder.Size = UDim2.new(1, 0, 0, 0)
		TabsHolder.ZIndex = 8

		TabsLayout.Parent = TabsHolder
		TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabsLayout.Padding = UDim.new(0, 5)

		local function UpdateSize()
			local tabsHeight = Category.Open and (TabsLayout.AbsoluteContentSize.Y + (#Category.Tabs > 0 and 1 or 0)) or 0;
			local rootHeight = 30 + (Category.Open and 5 or 0) + tabsHeight;

			if Category.Open then
				TabsHolder.Visible = true;
			end;

			ModernV2.PlayAnimate(TabsHolder, VSlowTween, {
				Size = UDim2.new(1, 0, 0, tabsHeight)
			});

			ModernV2.PlayAnimate(CategoryRoot, VSlowTween, {
				Size = UDim2.new(1, -1, 0, rootHeight)
			});

			ModernV2.PlayAnimate(ChevronIcon, SlowyTween, {
				Rotation = Category.Open and 0 or -90
			});

			if not Category.Open then
				task.delay(0.2, function()
					if not Category.Open then
						TabsHolder.Visible = false;
					end;
				end);
			end;
		end;

		function Category:SetOpen(value)
			Category.Open = value == true;
			UpdateSize();
			return Category;
		end;

		function Category:Toggle()
			return Category:SetOpen(not Category.Open);
		end;

		function Category:GetOpen()
			return Category.Open;
		end;

		function Category:SetName(name)
			Config.Name = tostring(name or "");
			HeaderLabel.Text = Config.Name;
			return Category;
		end;

		function Category:SetIcon(icon)
			Config.Icon = icon or "";
			ModernV2:SetIconMode(HeaderIcon, Config.Icon);
			HeaderIcon.Visible = tostring(Config.Icon or "") ~= "";
			HeaderLabel.Position = HeaderIcon.Visible and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 10, 0.5, 0);
			HeaderLabel.Size = HeaderIcon.Visible and UDim2.new(1, -58, 0, 16) or UDim2.new(1, -38, 0, 16);
			return Category;
		end;

		function Category:AddTab(TabConfig)
			local PreviousParent = Window.__NextTabParent;
			Window.__NextTabParent = TabsHolder;

			local Tab = Window:AddTab(TabConfig);

			Window.__NextTabParent = PreviousParent;
			table.insert(Category.Tabs, Tab);
			UpdateSize();

			return Tab;
		end;

		ModernV2:AddSignal(TabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize))

		local Input = ModernV2:CreateInput(Header, function()
			Category:Toggle();
		end);

		ModernV2:AddSignal(Input.MouseEnter:Connect(function()
			ModernV2.PlayAnimate(Header, SlowyTween, {
				BackgroundTransparency = 0.150
			})
		end))

		ModernV2:AddSignal(Input.MouseLeave:Connect(function()
			ModernV2.PlayAnimate(Header, SlowyTween, {
				BackgroundTransparency = 0.250
			})
		end))

		ModernV2:AddSignal(Window.Signal:Connect(function(value)
			if value then
				ModernV2.PlayAnimate(Header, SlowyTween, {
					BackgroundTransparency = 0.250
				})
				ModernV2.PlayAnimate(HeaderStroke, SlowyTween, {
					Transparency = 0.700
				})
				ModernV2.PlayAnimate(HeaderIcon, SlowyTween, {
					TextTransparency = 0.250
				})
				ModernV2.PlayAnimate(HeaderLabel, SlowyTween, {
					TextTransparency = 0.080
				})
				ModernV2.PlayAnimate(ChevronIcon, SlowyTween, {
					TextTransparency = 0.350
				})
			else
				ModernV2.PlayAnimate(Header, SlowyTween, {
					BackgroundTransparency = 1
				})
				ModernV2.PlayAnimate(HeaderStroke, SlowyTween, {
					Transparency = 1
				})
				ModernV2.PlayAnimate(HeaderIcon, SlowyTween, {
					TextTransparency = 1
				})
				ModernV2.PlayAnimate(HeaderLabel, SlowyTween, {
					TextTransparency = 1
				})
				ModernV2.PlayAnimate(ChevronIcon, SlowyTween, {
					TextTransparency = 1
				})
			end;
		end))

		UpdateSize();

		return CaseInsensitive(Category);
	end;

	function Window:CreateHomeTab(Config)
		Config = ModernV2:ProcessParams(Config or {}, {
			Name = "Dashboard",
			Title = nil,
			Icon = "lucide:layout-dashboard",
			Content = "",
			SectionName = nil,
			Type = "Double",
			AutoSetup = true,
			DiscordInvite = "",
			SupportedExecutors = {},
			UnsupportedExecutors = {},
			Changelog = {},
			Segments = nil,
			Locked = false,
			TextLocked = "Locked",
		});

		local Tab = Window:AddTab({
			Name = Config.Title or Config.Name,
			Icon = Config.Icon,
			Type = Config.Type,
			Locked = Config.Locked,
			TextLocked = Config.TextLocked,
		});

		if Config.AutoSetup ~= false then
			if not Tab.CustomRoot and Tab.Root then
				Tab.CustomRoot = Instance.new("Frame");
				Tab.CustomRoot.Name = ModernV2.RandomString();
				Tab.CustomRoot.Parent = Tab.Root;
				Tab.CustomRoot.BackgroundTransparency = 1;
				Tab.CustomRoot.BorderSizePixel = 0;
				Tab.CustomRoot.Position = UDim2.fromOffset(0, 0);
				Tab.CustomRoot.Size = UDim2.fromScale(1, 1);
				Tab.CustomRoot.ZIndex = 10;
			end;

			if not Tab.CustomRoot then
				return CaseInsensitive(Tab);
			end;

			local Player = LocalPlayer;
			local ExecutorName = "Roblox Studio";
			local PlaceName = "Unknown Place";
			local Region = "Unknown";
			local TimeFunction = RunService:IsRunning() and time or os.clock;
			local FrameTimes = {};
			local StartedAt = TimeFunction();
			local ActivePage = "Details";

			pcall(function()
				if identifyexecutor then
					ExecutorName = tostring(select(1, identifyexecutor()));
				end;
			end);

			pcall(function()
				PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name;
			end);

			pcall(function()
				Region = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(Player);
			end);

			local function SetText(Object, Text)
				if Object and Object.Parent then
					Object.Text = tostring(Text or "");
				end;
			end;

			local function AddCorner(Object, Radius)
				local Corner = Instance.new("UICorner");
				Corner.CornerRadius = UDim.new(0, Radius or 8);
				Corner.Parent = Object;
				return Corner;
			end;

			local function AddStroke(Object, Color, Transparency)
				local Stroke = Instance.new("UIStroke");
				Stroke.Color = Color or Color3.fromRGB(45, 48, 58);
				Stroke.Transparency = Transparency or 0.650;
				Stroke.Parent = Object;
				return Stroke;
			end;

			local function MakeText(Parent, Text, Size, Bold, Transparency)
				local Label = Instance.new("TextLabel");
				Label.Name = ModernV2.RandomString();
				Label.Parent = Parent;
				Label.BackgroundTransparency = 1;
				Label.BorderSizePixel = 0;
				Label.Font = Bold and Enum.Font.GothamBold or Enum.Font.GothamMedium;
				Label.Text = tostring(Text or "");
				Label.TextColor3 = Color3.fromRGB(255, 255, 255);
				Label.TextSize = Size or 12;
				Label.TextTransparency = Transparency or 0;
				Label.TextXAlignment = Enum.TextXAlignment.Left;
				Label.TextYAlignment = Enum.TextYAlignment.Center;
				Label.TextTruncate = Enum.TextTruncate.AtEnd;
				Label.ZIndex = 14;
				return Label;
			end;

			local function FitTextToWidth(Label, BaseSize, MinSize, Wrapped)
				BaseSize = BaseSize or Label.TextSize;
				MinSize = MinSize or 8;
				Label.TextSize = BaseSize;
				task.defer(function()
					if not Label or not Label.Parent then
						return;
					end;

					local Width = math.max(1, Label.AbsoluteSize.X);
					local Height = math.max(1, Label.AbsoluteSize.Y);
					local Size = BaseSize;
					while Size > MinSize do
						local Bounds = TextService:GetTextSize(Label.Text, Size, Label.Font, Wrapped and Vector2.new(Width, math.huge) or Vector2.new(math.huge, Height));
						if Bounds.X <= Width and (not Wrapped or Bounds.Y <= Height) then
							break;
						end;
						Size -= 1;
					end;
					Label.TextSize = Size;
				end);
			end;

			local function MakePanel(Parent, Size, Position)
				local Panel = Instance.new("Frame");
				Panel.Name = ModernV2.RandomString();
				Panel.Parent = Parent;
				Panel.BackgroundColor3 = Color3.fromRGB(13, 17, 22);
				Panel.BackgroundTransparency = 0.100;
				Panel.BorderSizePixel = 0;
				Panel.ClipsDescendants = true;
				Panel.Size = Size;
				Panel.Position = Position or UDim2.fromOffset(0, 0);
				Panel.ZIndex = 12;
				AddCorner(Panel, 8);
				AddStroke(Panel, Color3.fromRGB(45, 48, 58), 0.680);
				return Panel;
			end;

			local function MakeIcon(Parent, Icon, Size, Color)
				local Image = Instance.new("ImageLabel");
				Image.Name = ModernV2.RandomString();
				Image.Parent = Parent;
				Image.BackgroundTransparency = 1;
				Image.BorderSizePixel = 0;
				Image.Size = UDim2.fromOffset(Size or 18, Size or 18);
				Image.ScaleType = Enum.ScaleType.Fit;
				Image.ImageColor3 = Color or Color3.fromRGB(255, 255, 255);
				Image.ZIndex = 15;
				ModernV2:SetIconMode(Image, Icon or "");
				return Image;
			end;

			local function MakeButton(Parent, Text, Icon, Callback)
				local Button = MakePanel(Parent, UDim2.fromOffset(0, 34));
				Button.BackgroundTransparency = 0.250;
				Button.Size = UDim2.new(1, 0, 0, 34);

				local IconImage = MakeIcon(Button, Icon, 16, ModernV2.AccentColor);
				IconImage.Position = UDim2.new(0, 12, 0.5, -8);

				local Label = MakeText(Button, Text, 12, true, 0.050);
				Label.Position = UDim2.new(0, 36, 0, 0);
				Label.Size = UDim2.new(1, -44, 1, 0);

				local Input = ModernV2:CreateInput(Button, Callback or EmptyFunction);
				ModernV2:AddSignal(Input.MouseEnter:Connect(function()
					ModernV2.PlayAnimate(Button, SlowyTween, { BackgroundTransparency = 0.080 });
				end));
				ModernV2:AddSignal(Input.MouseLeave:Connect(function()
					ModernV2.PlayAnimate(Button, SlowyTween, { BackgroundTransparency = 0.250 });
				end));

				return Button;
			end;

			local function GetGreeting()
				local Hour = os.date("*t").hour;
				if Hour >= 4 and Hour < 12 then
					return "Good Morning";
				elseif Hour >= 12 and Hour < 19 then
					return "How's Your Day Going?";
				elseif Hour >= 19 and Hour <= 23 then
					return "Sweet Dreams";
				end;
				return "You should be asleep";
			end;

			local function GetElapsed()
				local Elapsed = math.max(0, TimeFunction() - StartedAt);
				if Elapsed < 60 then
					return tostring(math.floor(Elapsed)).."s";
				elseif Elapsed < 3600 then
					return tostring(math.floor(Elapsed / 60)).."m";
				end;
				return tostring(math.floor(Elapsed / 3600)).."h";
			end;

			local Root = Instance.new("Frame");
			Root.Name = ModernV2.RandomString();
			Root.Parent = Tab.CustomRoot;
			Root.BackgroundTransparency = 1;
			Root.BorderSizePixel = 0;
			Root.Size = UDim2.new(1, -12, 0, 450);
			Root.ZIndex = 11;
			Tab.HomeRoot = Root;

			local Profile = MakePanel(Root, UDim2.new(1, 0, 0, 74), UDim2.fromOffset(0, 4));
			local AvatarBox = MakePanel(Profile, UDim2.fromOffset(58, 58), UDim2.fromOffset(10, 8));
			AvatarBox.BackgroundTransparency = 0.200;

			local Avatar = Instance.new("ImageLabel");
			Avatar.Name = ModernV2.RandomString();
			Avatar.Parent = AvatarBox;
			Avatar.BackgroundTransparency = 1;
			Avatar.BorderSizePixel = 0;
			Avatar.Size = UDim2.fromScale(1, 1);
			Avatar.Image = ModernV2.UserProfile or "";
			Avatar.ZIndex = 15;
			AddCorner(Avatar, 8);

			local Welcome = MakeText(Profile, "Hello, "..tostring(Player.DisplayName), 18, true, 0);
			Welcome.Position = UDim2.new(0, 82, 0, 17);
			Welcome.Size = UDim2.new(1, -98, 0, 24);
			ModernV2:AddTextGradient(Welcome);

			local Username = MakeText(Profile, "@"..tostring(Player.Name), 12, false, 0.350);
			Username.Position = UDim2.new(0, 82, 0, 41);
			Username.Size = UDim2.new(1, -98, 0, 18);

			local Segments = MakePanel(Root, UDim2.new(1, 0, 0, 48), UDim2.fromOffset(0, 86));
			local SegmentLayout = Instance.new("UIListLayout");
			SegmentLayout.Parent = Segments;
			SegmentLayout.FillDirection = Enum.FillDirection.Horizontal;
			SegmentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
			SegmentLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
			SegmentLayout.SortOrder = Enum.SortOrder.LayoutOrder;
			SegmentLayout.Padding = UDim.new(0, 8);

			local ContentHolder = Instance.new("Frame");
			ContentHolder.Name = ModernV2.RandomString();
			ContentHolder.Parent = Root;
			ContentHolder.BackgroundTransparency = 1;
			ContentHolder.BorderSizePixel = 0;
			ContentHolder.Position = UDim2.fromOffset(0, 144);
			ContentHolder.Size = UDim2.new(1, 0, 1, -144);
			ContentHolder.ZIndex = 11;

			local DetailsPage = Instance.new("Frame");
			DetailsPage.Name = ModernV2.RandomString();
			DetailsPage.Parent = ContentHolder;
			DetailsPage.BackgroundTransparency = 1;
			DetailsPage.BorderSizePixel = 0;
			DetailsPage.Size = UDim2.fromScale(1, 1);
			DetailsPage.ZIndex = 11;

			local ScriptPage = Instance.new("Frame");
			ScriptPage.Name = ModernV2.RandomString();
			ScriptPage.Parent = ContentHolder;
			ScriptPage.BackgroundTransparency = 1;
			ScriptPage.BorderSizePixel = 0;
			ScriptPage.Size = UDim2.fromScale(1, 1);
			ScriptPage.Visible = false;
			ScriptPage.ZIndex = 11;

			local UiPage = Instance.new("Frame");
			UiPage.Name = ModernV2.RandomString();
			UiPage.Parent = ContentHolder;
			UiPage.BackgroundTransparency = 1;
			UiPage.BorderSizePixel = 0;
			UiPage.Size = UDim2.fromScale(1, 1);
			UiPage.Visible = false;
			UiPage.ZIndex = 11;

			local SegmentButtons = {};
			local SegmentCount = 0;
			local Pages = {
				Details = DetailsPage,
				Script = ScriptPage,
				UI = UiPage,
			};

			local function SelectPage(PageName)
				ActivePage = PageName;
				for Name,Page in next, Pages do
					Page.Visible = Name == PageName;
				end;
				for Name,Button in next, SegmentButtons do
					ModernV2.PlayAnimate(Button.Root, SlowyTween, {
						BackgroundTransparency = Name == PageName and 0.080 or 0.550
					});
					Button.Icon.ImageColor3 = Name == PageName and ModernV2.AccentColor or Color3.fromRGB(210, 210, 220);
					Button.Label.TextTransparency = Name == PageName and 0 or 0.250;
				end;
			end;

			local VisibleSegmentCount = 3;

			local function MakeSegment(Name, Text, Icon)
				local WidthScale = 1 / math.max(VisibleSegmentCount, 1);
				local Button = MakePanel(Segments, UDim2.new(WidthScale, -10, 0, 34));
				Button.BackgroundTransparency = 0.550;
				SegmentCount += 1;
				Button.LayoutOrder = SegmentCount;
				local Inner = Instance.new("Frame");
				local InnerLayout = Instance.new("UIListLayout");

				Inner.Name = ModernV2.RandomString();
				Inner.Parent = Button;
				Inner.AnchorPoint = Vector2.new(0.5, 0.5);
				Inner.BackgroundTransparency = 1;
				Inner.BorderSizePixel = 0;
				Inner.Position = UDim2.fromScale(0.5, 0.5);
				Inner.Size = UDim2.new(1, -18, 1, 0);
				Inner.ZIndex = 14;

				InnerLayout.Parent = Inner;
				InnerLayout.FillDirection = Enum.FillDirection.Horizontal;
				InnerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
				InnerLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
				InnerLayout.SortOrder = Enum.SortOrder.LayoutOrder;
				InnerLayout.Padding = UDim.new(0, 7);

				local IconImage = MakeIcon(Button, Icon, 17, Color3.fromRGB(210, 210, 220));
				IconImage.Parent = Inner;
				IconImage.LayoutOrder = 1;
				local Label = MakeText(Button, Text, 13, true, 0.250);
				Label.Parent = Inner;
				Label.LayoutOrder = 2;
				Label.Size = UDim2.new(0, math.max(24, TextService:GetTextSize(tostring(Text), 13, Enum.Font.GothamBold, Vector2.new(math.huge, math.huge)).X + 2), 0, 18);
				Label.TextXAlignment = Enum.TextXAlignment.Left;
				Label.TextTruncate = Enum.TextTruncate.None;
				SegmentButtons[Name] = {
					Root = Button,
					Icon = IconImage,
					Label = Label,
				};
				ModernV2:CreateInput(Button, function()
					SelectPage(Name);
				end);

				local function FitSegmentText()
					local AvailableWidth = math.max(20, Inner.AbsoluteSize.X - IconImage.AbsoluteSize.X - InnerLayout.Padding.Offset);
					local TextWidth = TextService:GetTextSize(Label.Text, Label.TextSize, Label.Font, Vector2.new(math.huge, math.huge)).X + 4;

					Label.Size = UDim2.new(0, math.min(TextWidth, AvailableWidth), 0, 18);
					Label.TextTruncate = TextWidth > AvailableWidth and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None;
				end;

				ModernV2:AddSignal(Inner:GetPropertyChangedSignal("AbsoluteSize"):Connect(FitSegmentText))
				task.defer(FitSegmentText);
			end;

			local SegmentConfig = typeof(Config.Segments) == "table" and Config.Segments or {};
			local DetailsSegment = SegmentConfig.Details or SegmentConfig[1] or {};
			local ScriptSegment = SegmentConfig.Script or SegmentConfig[2] or {};
			local UISegment = SegmentConfig.UI or SegmentConfig.Ui or SegmentConfig[3] or {};

			local ShowDetailsSegment = DetailsSegment.Show ~= false and Config.ShowDetailsSegment ~= false;
			local ShowScriptSegment = ScriptSegment.Show ~= false and Config.ShowScriptSegment ~= false;
			local ShowUISegment = UISegment.Show ~= false and Config.ShowUISegment ~= false;

			VisibleSegmentCount = (ShowDetailsSegment and 1 or 0) + (ShowScriptSegment and 1 or 0) + (ShowUISegment and 1 or 0);

			if VisibleSegmentCount <= 0 then
				ShowDetailsSegment = true;
				VisibleSegmentCount = 1;
			end;

			if ShowDetailsSegment then
				MakeSegment("Details", DetailsSegment.Text or DetailsSegment.Name or Config.DetailsText or "Details And Info", DetailsSegment.Icon or Config.DetailsIcon or "lucide:layout-grid");
			end;

			if ShowScriptSegment then
				MakeSegment("Script", ScriptSegment.Text or ScriptSegment.Name or Config.ScriptText or "Script Changelog", ScriptSegment.Icon or Config.ScriptIcon or "lucide:code-2");
			end;

			if ShowUISegment then
				MakeSegment("UI", UISegment.Text or UISegment.Name or Config.UIText or Config.UiText or "UI Changelog", UISegment.Icon or Config.UIIcon or Config.UiIcon or "lucide:file-text");
			end;

			local LeftColumn = Instance.new("Frame");
			LeftColumn.Name = ModernV2.RandomString();
			LeftColumn.Parent = DetailsPage;
			LeftColumn.BackgroundTransparency = 1;
			LeftColumn.BorderSizePixel = 0;
			LeftColumn.Size = UDim2.new(0.52, -5, 1, 0);
			LeftColumn.ZIndex = 11;

			local RightColumn = Instance.new("Frame");
			RightColumn.Name = ModernV2.RandomString();
			RightColumn.Parent = DetailsPage;
			RightColumn.BackgroundTransparency = 1;
			RightColumn.BorderSizePixel = 0;
			RightColumn.Position = UDim2.new(0.52, 5, 0, 0);
			RightColumn.Size = UDim2.new(0.48, -5, 1, 0);
			RightColumn.ZIndex = 11;

			local ServerCard = MakePanel(LeftColumn, UDim2.new(1, 0, 0, 154), UDim2.fromOffset(0, 0));
			local ServerTitle = MakeText(ServerCard, "Server", 15, true, 0);
			ServerTitle.Position = UDim2.fromOffset(16, 14);
			ServerTitle.Size = UDim2.new(1, -32, 0, 18);
			local ServerSub = MakeText(ServerCard, "Information on the session you're currently in", 10, false, 0.480);
			ServerSub.Position = UDim2.fromOffset(16, 32);
			ServerSub.Size = UDim2.new(1, -32, 0, 14);

			local StatLabels = {};
			local function MakeStat(Parent, Title, Value, X, Y, W)
				local Stat = MakePanel(Parent, UDim2.new(W, -6, 0, 42), UDim2.new(X, 3, 0, Y));
				Stat.BackgroundTransparency = 0.250;
				local T = MakeText(Stat, Title, 10, true, 0.130);
				T.Position = UDim2.fromOffset(10, 7);
				T.Size = UDim2.new(1, -20, 0, 13);
				local V = MakeText(Stat, Value, 10, false, 0.350);
				V.Position = UDim2.fromOffset(10, 21);
				V.Size = UDim2.new(1, -20, 0, 13);
				return V;
			end;

			StatLabels.Players = MakeStat(ServerCard, "Players", "0 playing", 0, 58, 0.5);
			StatLabels.Capacity = MakeStat(ServerCard, "Maximum Players", tostring(Players.MaxPlayers).." can join", 0.5, 58, 0.5);
			StatLabels.Latency = MakeStat(ServerCard, "Latency", "...", 0, 104, 0.33);
			StatLabels.Region = MakeStat(ServerCard, "Server Region", tostring(Region), 0.33, 104, 0.34);
			StatLabels.Runtime = MakeStat(ServerCard, "In server for", "0s", 0.67, 104, 0.33);

			local DiscordCard = MakePanel(LeftColumn, UDim2.new(1, 0, 0, 68), UDim2.fromOffset(0, 164));
			DiscordCard.BackgroundColor3 = ModernV2.AccentColor;
			DiscordCard.BackgroundTransparency = 0.180;
			local DiscordGradient = Instance.new("UIGradient");
			DiscordGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, ModernV2.AccentColor),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 17, 22)),
			});
			DiscordGradient.Parent = DiscordCard;
			local DiscordTitle = MakeText(DiscordCard, "Discord", 20, true, 0);
			DiscordTitle.Position = UDim2.fromOffset(18, 12);
			DiscordTitle.Size = UDim2.new(1, -36, 0, 25);
			local DiscordSub = MakeText(DiscordCard, tostring(Config.DiscordInvite or "") ~= "" and "Tap to copy Discord invite" or "No Discord invite configured", 12, false, 0.250);
			DiscordSub.Position = UDim2.fromOffset(18, 38);
			DiscordSub.Size = UDim2.new(1, -36, 0, 18);
			ModernV2:CreateInput(DiscordCard, function()
				if tostring(Config.DiscordInvite or "") == "" then
					return;
				end;
				local Link = "https://discord.gg/"..tostring(Config.DiscordInvite);
				if setclipboard then setclipboard(Link); elseif toclipboard then toclipboard(Link); elseif set_clipboard then set_clipboard(Link); end;
				Window:Notify({ Title = "Copied", Content = Link, Duration = 2, Icon = "lucide:check" });
			end);

			local ExecutorCard = MakePanel(RightColumn, UDim2.new(1, 0, 0, 92), UDim2.fromOffset(0, 0));
			local ExecutorStatus = "Unknown";
			local ExecutorColor = ModernV2.AccentColor;
			if table.find(Config.SupportedExecutors, ExecutorName) then
				ExecutorStatus = "Your executor seems to support this script.";
				ExecutorColor = Color3.fromRGB(45, 180, 115);
			elseif table.find(Config.UnsupportedExecutors, ExecutorName) then
				ExecutorStatus = "Your executor may not support this script.";
				ExecutorColor = Color3.fromRGB(220, 70, 70);
			end;
			ExecutorCard.BackgroundColor3 = ExecutorColor;
			ExecutorCard.BackgroundTransparency = 0.180;
			local ExecutorGradient = Instance.new("UIGradient");
			ExecutorGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, ExecutorColor),
				ColorSequenceKeypoint.new(0.58, Color3.fromRGB(13, 17, 22)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
			});
			ExecutorGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.080),
				NumberSequenceKeypoint.new(0.55, 0),
				NumberSequenceKeypoint.new(1, 0),
			});
			ExecutorGradient.Parent = ExecutorCard;
			local ExecutorTitle = MakeText(ExecutorCard, ExecutorName, 17, true, 0);
			ExecutorTitle.Position = UDim2.fromOffset(18, 18);
			ExecutorTitle.Size = UDim2.new(1, -36, 0, 22);
			local ExecutorSub = MakeText(ExecutorCard, ExecutorStatus, 12, false, 0.150);
			ExecutorSub.Position = UDim2.fromOffset(18, 43);
			ExecutorSub.Size = UDim2.new(1, -36, 0, 34);
			ExecutorSub.TextWrapped = true;
			ExecutorSub.TextTruncate = Enum.TextTruncate.None;
			ExecutorSub.TextYAlignment = Enum.TextYAlignment.Top;
			FitTextToWidth(ExecutorSub, 12, 8, true);

			local FriendsCard = MakePanel(RightColumn, UDim2.new(1, 0, 0, 166), UDim2.fromOffset(0, 102));
			local FriendsTitle = MakeText(FriendsCard, "Friends", 16, true, 0);
			FriendsTitle.Position = UDim2.fromOffset(16, 12);
			FriendsTitle.Size = UDim2.new(1, -32, 0, 20);
			local FriendsSub = MakeText(FriendsCard, "Find out what your friends are currently doing", 10, false, 0.480);
			FriendsSub.Position = UDim2.fromOffset(16, 32);
			FriendsSub.Size = UDim2.new(1, -32, 0, 14);
			local FriendLabels = {};
			FriendLabels.InServer = MakeStat(FriendsCard, "In Server", "...", 0, 58, 0.5);
			FriendLabels.Offline = MakeStat(FriendsCard, "Offline", "...", 0.5, 58, 0.5);
			FriendLabels.Online = MakeStat(FriendsCard, "Online", "...", 0, 104, 0.5);
			FriendLabels.All = MakeStat(FriendsCard, "All", "...", 0.5, 104, 0.5);

			local function FillChangelog(Page, Entries, EmptyText)
				local Holder = MakePanel(Page, UDim2.new(1, 0, 1, 0), UDim2.fromOffset(0, 0));
				local Layout = Instance.new("UIListLayout");
				Layout.Parent = Holder;
				Layout.SortOrder = Enum.SortOrder.LayoutOrder;
				Layout.Padding = UDim.new(0, 8);

				local Padding = Instance.new("UIPadding");
				Padding.Parent = Holder;
				Padding.PaddingTop = UDim.new(0, 12);
				Padding.PaddingLeft = UDim.new(0, 12);
				Padding.PaddingRight = UDim.new(0, 12);

				if typeof(Entries) ~= "table" or #Entries <= 0 then
					local Empty = MakeText(Holder, EmptyText, 13, false, 0.250);
					Empty.Size = UDim2.new(1, 0, 0, 26);
					return;
				end;

				for Index,Entry in ipairs(Entries) do
					local Item = MakePanel(Holder, UDim2.new(1, 0, 0, 64));
					Item.LayoutOrder = Index;
					local Title = MakeText(Item, tostring(Entry.Title or Entry.Name or ("Update "..Index)), 14, true, 0);
					Title.Position = UDim2.fromOffset(14, 10);
					Title.Size = UDim2.new(1, -28, 0, 18);
					local Desc = MakeText(Item, tostring(Entry.Description or Entry.Content or Entry.Date or ""), 11, false, 0.300);
					Desc.Position = UDim2.fromOffset(14, 31);
					Desc.Size = UDim2.new(1, -28, 0, 20);
				end;
			end;

			FillChangelog(ScriptPage, Config.ScriptChangelog or Config.Changelog, "No script changelog.");
			FillChangelog(UiPage, Config.UIChangelog or Config.UiChangelog, "No UI changelog.");

			local FriendCache = {
				All = "...",
				Online = "...",
				Offline = "...",
				InServer = "...",
				Cooldown = 0,
			};

			local function UpdateFriends()
				if FriendCache.Cooldown > 0 then
					FriendCache.Cooldown -= 1;
					return;
				end;

				FriendCache.Cooldown = 30;

				task.spawn(function()
					local OnlineFriends = 0;
					local TotalFriends = 0;
					local InServer = 0;

					pcall(function()
						OnlineFriends = #Player:GetFriendsOnline();
					end);

					pcall(function()
						local Pages = Players:GetFriendsAsync(Player.UserId);
						while true do
							for _,Data in ipairs(Pages:GetCurrentPage()) do
								TotalFriends += 1;
								if Players:FindFirstChild(Data.Username) then
									InServer += 1;
								end;
							end;
							if Pages.IsFinished then
								break;
							end;
							Pages:AdvanceToNextPageAsync();
						end;
					end);

					FriendCache.All = tostring(TotalFriends).." friends";
					FriendCache.Online = tostring(OnlineFriends).." friends";
					FriendCache.Offline = tostring(math.max(TotalFriends - OnlineFriends, 0)).." friends";
					FriendCache.InServer = InServer > 0 and tostring(InServer).." friends" or "no friends";
				end);
			end;

			local Accumulator = 0;
			local function UpdateHome(dt)
				local Now = TimeFunction();
				for Index = #FrameTimes, 1, -1 do
					if FrameTimes[Index] < Now - 1 then
						table.remove(FrameTimes, Index);
					end;
				end;
				table.insert(FrameTimes, Now);

				Accumulator += dt or 0;
				if Accumulator < 0.5 then
					return;
				end;
				Accumulator = 0;

				local Ping = "...";
				pcall(function()
					Ping = tostring(math.floor((Player:GetNetworkPing() * 1000) + 0.5)).."ms";
				end);

				SetText(Welcome, "Hello, "..tostring(Player.DisplayName));
				SetText(Username, GetGreeting().." | @"..tostring(Player.Name));
				SetText(StatLabels.Players, tostring(#Players:GetPlayers()).." playing");
				SetText(StatLabels.Capacity, tostring(Players.MaxPlayers).." can join");
				SetText(StatLabels.Latency, Ping);
				SetText(StatLabels.Runtime, GetElapsed());
				SetText(FriendLabels.InServer, FriendCache.InServer);
				SetText(FriendLabels.Offline, FriendCache.Offline);
				SetText(FriendLabels.Online, FriendCache.Online);
				SetText(FriendLabels.All, FriendCache.All);
				UpdateFriends();
			end;

			SelectPage("Details");

			local HomeSignal = ModernV2:AddSignal(RunService.RenderStepped:Connect(UpdateHome));
			table.insert(Window.OnDestroyCallbacks, function()
				if HomeSignal then
					HomeSignal:Disconnect();
				end;
			end);

			function Tab:GetHomeSection()
				return Tab.HomeRoot;
			end;

			return CaseInsensitive(Tab);
		end;

		local Section = Tab:AddSection({
			Name = Config.SectionName or Config.Title or Config.Name,
			Position = Config.AutoSetup ~= false and "Left" or "Center",
			Collapsible = Config.Collapsible == true,
			Box = Config.Box == true,
			Icon = Config.SectionIcon,
		});

		Tab.HomeSection = Section;

		if Config.AutoSetup ~= false then
			local Player = LocalPlayer;
			local ExecutorName = "Roblox Studio";
			local PlaceName = "Unknown Place";
			local Region = "Unknown";
			local TimeFunction = RunService:IsRunning() and time or os.clock;
			local FrameTimes = {};
			local StartedAt = TimeFunction();

			pcall(function()
				if identifyexecutor then
					ExecutorName = tostring(select(1, identifyexecutor()));
				end;
			end);

			pcall(function()
				PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name;
			end);

			pcall(function()
				Region = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(Player);
			end);

			local function GetGreeting()
				local Hour = os.date("*t").hour;

				if Hour >= 4 and Hour < 12 then
					return "Good Morning";
				elseif Hour >= 12 and Hour < 19 then
					return "How's Your Day Going?";
				elseif Hour >= 19 and Hour <= 23 then
					return "Sweet Dreams";
				end;

				return "You should be asleep";
			end;

			local function GetElapsed()
				local Elapsed = math.max(0, TimeFunction() - StartedAt);

				if Elapsed < 60 then
					return tostring(math.floor(Elapsed)).."s";
				elseif Elapsed < 3600 then
					return tostring(math.floor(Elapsed / 60)).."m";
				end;

				return tostring(math.floor(Elapsed / 3600)).."h";
			end;

			Section:AddParagraph({
				Name = "Welcome, "..tostring(Player.DisplayName),
				Content = tostring(Config.Content ~= "" and Config.Content or (GetGreeting().." | @"..Player.Name)),
			});

			local StatusSection = Tab:AddSection({
				Name = "Status",
				Position = "Right",
				Icon = "lucide:activity",
			});

			local ServerSection = Tab:AddSection({
				Name = "Server",
				Position = "Left",
				Icon = "lucide:server",
			});

			local PlayerLabel = StatusSection:AddLabel({
				Text = "Players: "..tostring(#Players:GetPlayers()).."/"..tostring(Players.MaxPlayers),
			});

			local RuntimeLabel = StatusSection:AddLabel({
				Text = "Runtime: 0s",
			});

			local PerformanceLabel = StatusSection:AddLabel({
				Text = "FPS: ... | Ping: ...",
			});

			local ExecutorStatus = "Unknown";

			if table.find(Config.SupportedExecutors, ExecutorName) then
				ExecutorStatus = "Supported";
			elseif table.find(Config.UnsupportedExecutors, ExecutorName) then
				ExecutorStatus = "Unsupported";
			end;

			StatusSection:AddParagraph({
				Name = ExecutorName,
				Content = "Executor: "..ExecutorStatus,
			});

			ServerSection:AddParagraph({
				Name = PlaceName,
				Content = "PlaceId: "..tostring(game.PlaceId).."\nJobId: "..tostring(game.JobId).."\nRegion: "..tostring(Region),
			});

			ServerSection:AddButton({
				Name = "Copy Join Script",
				Icon = "lucide:copy",
				Callback = function()
					local JoinScript = ('game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s", game:GetService("Players").LocalPlayer)'):format(tostring(game.PlaceId), tostring(game.JobId));

					if setclipboard then
						setclipboard(JoinScript);
					elseif toclipboard then
						toclipboard(JoinScript);
					elseif set_clipboard then
						set_clipboard(JoinScript);
					end;

					Window:Notify({
						Title = "Copied",
						Content = "Join script copied.",
						Duration = 2,
						Icon = "lucide:check",
					});
				end,
			});

			if tostring(Config.DiscordInvite or "") ~= "" then
				ServerSection:AddButton({
					Name = "Copy Discord",
					Icon = "lucide:message-circle",
					Callback = function()
						local Link = "https://discord.gg/"..tostring(Config.DiscordInvite);

						if setclipboard then
							setclipboard(Link);
						elseif toclipboard then
							toclipboard(Link);
						elseif set_clipboard then
							set_clipboard(Link);
						end;

						Window:Notify({
							Title = "Copied",
							Content = Link,
							Duration = 2,
							Icon = "lucide:check",
						});
					end,
				});
			end;

			if typeof(Config.Changelog) == "table" and #Config.Changelog > 0 then
				local ChangelogSection = Tab:AddSection({
					Name = "Changelog",
					Position = "Right",
					Icon = "lucide:list-checks",
					Collapsible = true,
				});

				for Index,Entry in ipairs(Config.Changelog) do
					if Index > 4 then
						break;
					end;

					if typeof(Entry) == "table" then
						ChangelogSection:AddParagraph({
							Name = tostring(Entry.Title or Entry.Name or ("Update "..Index)),
							Content = tostring(Entry.Date and (Entry.Date.."\n") or "")..tostring(Entry.Description or Entry.Content or ""),
						});
					else
						ChangelogSection:AddLabel({
							Text = tostring(Entry),
						});
					end;
				end;
			end;

			local Accumulator = 0;
			local function UpdateHome(dt)
				Accumulator = Accumulator + (dt or 0);
				local Now = TimeFunction();

				for Index = #FrameTimes, 1, -1 do
					if FrameTimes[Index] < Now - 1 then
						table.remove(FrameTimes, Index);
					end;
				end;

				table.insert(FrameTimes, Now);

				if Accumulator < 0.5 then
					return;
				end;

				Accumulator = 0;

				local Ping = "...";
				pcall(function()
					Ping = tostring(math.floor((Player:GetNetworkPing() * 1000) + 0.5)).."ms";
				end);

				if PlayerLabel.SetText then
					PlayerLabel:SetText("Players: "..tostring(#Players:GetPlayers()).."/"..tostring(Players.MaxPlayers));
				end;

				if RuntimeLabel.SetText then
					RuntimeLabel:SetText("Runtime: "..GetElapsed());
				end;

				if PerformanceLabel.SetText then
					PerformanceLabel:SetText("FPS: "..tostring(#FrameTimes).." | Ping: "..Ping);
				end;
			end;

			local HomeSignal = ModernV2:AddSignal(RunService.RenderStepped:Connect(UpdateHome));
			table.insert(Window.OnDestroyCallbacks, function()
				if HomeSignal then
					HomeSignal:Disconnect();
				end;
			end);
		elseif tostring(Config.Content or "") ~= "" then
			Section:AddParagraph({
				Name = Config.ParagraphName or Config.Title or Config.Name,
				Content = Config.Content,
			});
		end;

		if typeof(Config.Buttons) == "table" then
			for _,ButtonConfig in ipairs(Config.Buttons) do
				Section:AddButton(ButtonConfig);
			end;
		end;

		function Tab:GetHomeSection()
			return Section;
		end;

		return CaseInsensitive(Tab);
	end;

	function Window:AddTab(Config)
		Config = ModernV2:ProcessParams(Config , {
			Icon = "crosshairs",
			Name = "Tab",
			Type = "Double",
			Locked = false,
			TextLocked = "Locked",
		});

		local Tab = {
			Signal = ModernV2:CreateSignal(false);
		};

		local TabButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local TabIcon = Instance.new("ImageLabel")
		local TabContentLabel = Instance.new("TextLabel")

		Tab.Idx = TabButton;

		TabButton.Name = ModernV2.RandomString();
		TabButton.Parent = Window.__NextTabParent or LeftScrollingFrame
		TabButton.BackgroundColor3 = Color3.fromRGB(41, 45, 49)
		TabButton.BackgroundTransparency = 0.500
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.ClipsDescendants = true
		TabButton.Size = UDim2.new(1, -1, 0, 30)
		TabButton.ZIndex = 8
		ModernV2:AttachLockMethods(Tab, TabButton, Config);

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = TabButton

		TabIcon.Name = ModernV2.RandomString();
		TabIcon.Parent = TabButton
		TabIcon.AnchorPoint = Vector2.new(0, 0.5)
		TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabIcon.BorderSizePixel = 0
		TabIcon.Position = UDim2.new(0, 2, 0.5, 0)
		TabIcon.Size = UDim2.new(0, 25, 0, 25)
		TabIcon.ZIndex = 9
		ModernV2:SetIconMode(TabIcon, Config.Icon);
		TabIcon.ImageColor3 = ModernV2.AccentColor
		TabIcon.ScaleType = Enum.ScaleType.Fit

		TabContentLabel.Name = ModernV2.RandomString();
		TabContentLabel.Parent = TabButton
		TabContentLabel.AnchorPoint = Vector2.new(0, 0.5)
		TabContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabContentLabel.BackgroundTransparency = 1.000
		TabContentLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabContentLabel.BorderSizePixel = 0
		TabContentLabel.Position = UDim2.new(0, 30, 0.5, 0)
		TabContentLabel.Size = UDim2.new(1, -7, 0, 15)
		TabContentLabel.ZIndex = 9
		TabContentLabel.Font = Enum.Font.GothamMedium
		TabContentLabel.Text = Config.Name
		TabContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabContentLabel.TextSize = 12.000
		TabContentLabel.TextXAlignment = Enum.TextXAlignment.Left
		ModernV2:AddTextGradient(TabContentLabel);

		local TabFrame = Instance.new("Frame")
		local LeftScroll = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local RightScroll = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local CenterScroll = Instance.new("ScrollingFrame")
		local UIListLayout_3 = Instance.new("UIListLayout")
		local FlowScroll = Instance.new("ScrollingFrame")
		local UIListLayout_4 = Instance.new("UIListLayout")

		TabFrame.Name = ModernV2.RandomString();
		TabFrame.Parent = TabContainer
		TabFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabFrame.BackgroundTransparency = 1.000
		TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabFrame.BorderSizePixel = 0
		TabFrame.ClipsDescendants = true
		TabFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.Visible = true;

		LeftScroll.Name = ModernV2.RandomString();
		LeftScroll.Parent = TabFrame
		LeftScroll.Active = true
		LeftScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		LeftScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LeftScroll.BackgroundTransparency = 1.000
		LeftScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LeftScroll.BorderSizePixel = 0
		LeftScroll.ClipsDescendants = false
		LeftScroll.Position = UDim2.new(0.25, 0, 0.5, 0)
		LeftScroll.Size = UDim2.new(0.5, 0, 1, -5)
		LeftScroll.ScrollBarThickness = 0

		UIListLayout.Parent = LeftScroll
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		ModernV2:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			LeftScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 1)
		end)))

		RightScroll.Name = ModernV2.RandomString();
		RightScroll.Parent = TabFrame
		RightScroll.Active = true
		RightScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		RightScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		RightScroll.BackgroundTransparency = 1.000
		RightScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		RightScroll.BorderSizePixel = 0
		RightScroll.ClipsDescendants = false
		RightScroll.Position = UDim2.new(0.75, 0, 0.5, 0)
		RightScroll.Size = UDim2.new(0.5, 0, 1, -5)
		RightScroll.ScrollBarThickness = 0

		UIListLayout_2.Parent = RightScroll
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 5)

		CenterScroll.Name = ModernV2.RandomString();
		CenterScroll.Parent = TabFrame
		CenterScroll.Active = true
		CenterScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		CenterScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CenterScroll.BackgroundTransparency = 1.000
		CenterScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CenterScroll.BorderSizePixel = 0
		CenterScroll.ClipsDescendants = false
		CenterScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
		CenterScroll.Size = UDim2.new(1, 0, 1, -5)
		CenterScroll.ScrollBarThickness = 0
		CenterScroll.ZIndex = 6
		CenterScroll.Visible = false

		UIListLayout_3.Parent = CenterScroll
		UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.Padding = UDim.new(0, 5)

		local IsSingleTab = string.lower(tostring(Config.Type)) == "single";
		local UpdateTabColumnLayout;

		UpdateTabColumnLayout = LPH_NO_VIRTUALIZE(function()
			if not CenterScroll.Visible then
				CenterScroll.AnchorPoint = Vector2.new(0.5, 0.5)
				CenterScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
				CenterScroll.Size = UDim2.new(1, 0, 1, -5)

				LeftScroll.AnchorPoint = Vector2.new(0.5, 0.5)
				LeftScroll.Position = IsSingleTab and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
				LeftScroll.Size = IsSingleTab and UDim2.new(1, 0, 1, -5) or UDim2.new(0.5, 0, 1, -5)

				if RightScroll and RightScroll.Parent then
					RightScroll.AnchorPoint = Vector2.new(0.5, 0.5)
					RightScroll.Position = UDim2.new(0.75, 0, 0.5, 0)
					RightScroll.Size = UDim2.new(0.5, 0, 1, -5)
				end;

				return;
			end;

			local MaxCenterHeight = math.max(80, TabFrame.AbsoluteSize.Y * 0.45);
			local CenterHeight = math.clamp(UIListLayout_3.AbsoluteContentSize.Y + 1, 0, MaxCenterHeight);
			local ColumnOffset = CenterHeight + 5;

			CenterScroll.AnchorPoint = Vector2.new(0.5, 0)
			CenterScroll.Position = UDim2.new(0.5, 0, 0, 0)
			CenterScroll.Size = UDim2.new(1, 0, 0, CenterHeight)

			LeftScroll.AnchorPoint = Vector2.new(0.5, 0)
			LeftScroll.Position = IsSingleTab and UDim2.new(0.5, 0, 0, ColumnOffset) or UDim2.new(0.25, 0, 0, ColumnOffset)
			LeftScroll.Size = IsSingleTab and UDim2.new(1, 0, 1, -ColumnOffset - 5) or UDim2.new(0.5, 0, 1, -ColumnOffset - 5)

			if RightScroll and RightScroll.Parent then
				RightScroll.AnchorPoint = Vector2.new(0.5, 0)
				RightScroll.Position = UDim2.new(0.75, 0, 0, ColumnOffset)
				RightScroll.Size = UDim2.new(0.5, 0, 1, -ColumnOffset - 5)
			end;
		end);

		ModernV2:AddSignal(UIListLayout_3:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			CenterScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout_3.AbsoluteContentSize.Y + 1)
			UpdateTabColumnLayout();
		end)))

		ModernV2:AddSignal(TabFrame:GetPropertyChangedSignal('AbsoluteSize'):Connect(LPH_NO_VIRTUALIZE(function()
			UpdateTabColumnLayout();
		end)))

		FlowScroll.Name = ModernV2.RandomString();
		FlowScroll.Parent = TabFrame
		FlowScroll.Active = true
		FlowScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		FlowScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FlowScroll.BackgroundTransparency = 1.000
		FlowScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FlowScroll.BorderSizePixel = 0
		FlowScroll.ClipsDescendants = false
		FlowScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
		FlowScroll.Size = UDim2.new(1, 0, 1, -5)
		FlowScroll.ScrollBarThickness = 0
		FlowScroll.ZIndex = 7

		UIListLayout_4.Parent = FlowScroll
		UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_4.Padding = UDim.new(0, 5)

		Tab.Root = TabFrame;
		Tab.LeftScroll = LeftScroll;
		Tab.RightScroll = RightScroll;
		Tab.CenterScroll = CenterScroll;
		Tab.CustomRoot = FlowScroll;

		LeftScroll.Visible = false
		RightScroll.Visible = false
		CenterScroll.Visible = false

		ModernV2:AddSignal(UIListLayout_4:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			FlowScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout_4.AbsoluteContentSize.Y + 1)
		end)))

		local FlowOrder = 0;
		local PendingPairRow = nil;

		local function CreateFlowRow(kind)
			FlowOrder = FlowOrder + 1;

			local Row = Instance.new("Frame")
			local RowLayout = Instance.new("UIListLayout")

			Row.Name = ModernV2.RandomString();
			Row.Parent = FlowScroll
			Row.BackgroundTransparency = 1
			Row.BorderSizePixel = 0
			Row.ClipsDescendants = false
			Row.Size = UDim2.new(1, 0, 0, 0)
			Row.ZIndex = 8
			Row.LayoutOrder = FlowOrder

			RowLayout.Parent = Row
			RowLayout.FillDirection = Enum.FillDirection.Horizontal
			RowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			RowLayout.SortOrder = Enum.SortOrder.LayoutOrder
			RowLayout.Padding = UDim.new(0, 0)

			local LeftCell = Instance.new("Frame")
			local LeftLayout = Instance.new("UIListLayout")
			local RightCell = Instance.new("Frame")
			local RightLayout = Instance.new("UIListLayout")

			LeftCell.Name = ModernV2.RandomString();
			LeftCell.Parent = Row
			LeftCell.BackgroundTransparency = 1
			LeftCell.BorderSizePixel = 0
			LeftCell.ClipsDescendants = false
			LeftCell.LayoutOrder = 1
			LeftCell.Size = kind == "center" and UDim2.new(1, 0, 0, 0) or UDim2.new(0.5, 0, 0, 0)
			LeftCell.ZIndex = 8

			LeftLayout.Parent = LeftCell
			LeftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
			LeftLayout.Padding = UDim.new(0, 5)

			RightCell.Name = ModernV2.RandomString();
			RightCell.Parent = Row
			RightCell.BackgroundTransparency = 1
			RightCell.BorderSizePixel = 0
			RightCell.ClipsDescendants = false
			RightCell.LayoutOrder = 2
			RightCell.Size = UDim2.new(0.5, 0, 0, 0)
			RightCell.Visible = kind ~= "center"
			RightCell.ZIndex = 8

			RightLayout.Parent = RightCell
			RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
			RightLayout.Padding = UDim.new(0, 5)

			local function UpdateRowSize()
				local leftHeight = LeftLayout.AbsoluteContentSize.Y;
				local rightHeight = RightCell.Visible and RightLayout.AbsoluteContentSize.Y or 0;
				local height = math.max(leftHeight, rightHeight);

				Row.Size = UDim2.new(1, 0, 0, height);
				LeftCell.Size = UDim2.new(LeftCell.Size.X.Scale, 0, 0, height);
				RightCell.Size = UDim2.new(RightCell.Size.X.Scale, 0, 0, height);
				FlowScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout_4.AbsoluteContentSize.Y + 1);
			end;

			ModernV2:AddSignal(LeftLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(UpdateRowSize))
			ModernV2:AddSignal(RightLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(UpdateRowSize))

			return {
				Root = Row,
				Left = LeftCell,
				Right = RightCell,
				Kind = kind,
				HasLeft = false,
				HasRight = false,
				Update = UpdateRowSize,
			};
		end;

		local function ResolveFlowParent(Position)
			local PositionName = string.lower(tostring(Position or "left"));

			if PositionName == "center" then
				PendingPairRow = nil;
				return CreateFlowRow("center").Left;
			end;

			if IsSingleTab then
				PendingPairRow = nil;
				return CreateFlowRow("center").Left;
			end;

			if PositionName ~= "right" then
				PositionName = "left";
			end;

			if PendingPairRow and PendingPairRow.Kind == "pair" then
				if PositionName == "right" then
					PendingPairRow.HasRight = true;
					return PendingPairRow.Right;
				end;

				PendingPairRow.HasLeft = true;
				return PendingPairRow.Left;
			end;

			local NewRow = CreateFlowRow("pair");
			PendingPairRow = NewRow;

			if PositionName == "right" then
				NewRow.HasRight = true;
				return NewRow.Right;
			end;

			NewRow.HasLeft = true;
			return NewRow.Left;
		end;

		if IsSingleTab then
			UIListLayout_2:Destroy();
			RightScroll:Destroy();
			RightScroll = LeftScroll;
			UIListLayout_2 = UIListLayout;
			LeftScroll.Size = UDim2.new(1, 0, 1, -5);
			LeftScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
		else
			ModernV2:AddSignal(UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
				RightScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y + 1)
			end)))
		end;

		UpdateTabColumnLayout();

		ModernV2:AddSignal(TabIcon:GetPropertyChangedSignal('ImageTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if TabIcon.ImageTransparency > 0.4 then
				UIListLayout.Parent = nil;
				UIListLayout_2.Parent = nil;
				UIListLayout_3.Parent = nil;
				UIListLayout_4.Parent = nil;
				TabFrame.Visible = false;
				TabFrame.Parent = nil
			else
				UIListLayout.Parent = LeftScroll;
				UIListLayout_2.Parent = RightScroll;
				UIListLayout_3.Parent = CenterScroll;
				UIListLayout_4.Parent = FlowScroll;
				TabFrame.Visible = true;
				TabFrame.Parent = TabContainer;
			end;
		end)));

		Tab.SetValue = LPH_NO_VIRTUALIZE(function(value)
			if value and Tab.GetLocked and Tab:GetLocked() then
				value = false;
			end;

			Tab.Signal:SetValue(value);

			if value then
				ModernV2.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.500
				})

				ModernV2.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 0,
					TextColor3 = ModernV2.AccentColor
				})

				ModernV2.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 0
				})
			else
				ModernV2.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})

				ModernV2.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 0.5,
					TextColor3 = Color3.fromRGB(252, 252, 252)
				})

				ModernV2.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 0.5
				})
			end;
		end);

		local BaseTabSetLocked = Tab.SetLocked;
		function Tab:SetLocked(value)
			if BaseTabSetLocked then
				BaseTabSetLocked(Tab, value);
			end;

			if value == true and Window.Tabs[Window.CurrentTab] == Tab then
				Tab.SetValue(false);

				for Index,OtherTab in ipairs(Window.Tabs) do
					if OtherTab ~= Tab and (not OtherTab.GetLocked or not OtherTab:GetLocked()) then
						Window.CurrentTab = Index;
						OtherTab.SetValue(true);
						break;
					end;
				end;
			end;

			return Tab;
		end;

		function Tab:Select()
			if Tab.GetLocked and Tab:GetLocked() then
				return Tab;
			end;

			for i,v in next , Window.Tabs do
				if v == Tab then
					v.SetValue(true);
					Window.CurrentTab = i;
				else
					v.SetValue(false);
				end;
			end;

			return Tab;
		end;

		table.insert(Window.Tabs,Tab);

		if Window.Tabs[Window.CurrentTab] and Window.Tabs[Window.CurrentTab].GetLocked and Window.Tabs[Window.CurrentTab]:GetLocked() and (not Tab.GetLocked or not Tab:GetLocked()) then
			Window.CurrentTab = #Window.Tabs;
		end;

		if Window.Tabs[Window.CurrentTab] == Tab then
			Tab.SetValue(true)
		else
			Tab.SetValue(false);
		end;

		local over = ModernV2:CreateInput(TabButton,LPH_NO_VIRTUALIZE(function()
			if Tab.GetLocked and Tab:GetLocked() then
				return;
			end;

			for i,v in next , Window.Tabs do
				if v.Idx == TabButton then
					v.SetValue(true);
					Window.CurrentTab = i;
				else
					v.SetValue(false);
				end;
			end;
		end));

		ModernV2:AddSignal(over.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Tabs[Window.CurrentTab] == Tab then
				ModernV2.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.500
				})
			else
				ModernV2.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.8
				})
			end;
		end)))

		ModernV2:AddSignal(over.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Tabs[Window.CurrentTab] == Tab then
				ModernV2.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.500
				})
			else
				ModernV2.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})
			end;
		end)))

		Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
			if value then
				if Window.Tabs[Window.CurrentTab] == Tab then
					Tab.SetValue(true)
				else
					Tab.SetValue(false);
				end;
			else
				Tab.SetValue(false);

				ModernV2.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})

				ModernV2.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 1,
				})

				ModernV2.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 1
				})
			end;
		end));

		function Tab:AddSection(Config)
			Config = ModernV2:ProcessParams(Config , {
				Name = "SECTION",
				Position = 'left',
				Collapsible = false,
				Collapsed = false,
				Box = false,
				Icon = nil,
				IconColor = Color3.fromRGB(223, 223, 223),
				TextSize = 11,
				TextXAlignment = "Left",
				Locked = false,
				TextLocked = "Locked",
			});
			local SectionBoxed = Config.Collapsible == true and Config.Box == true;
			local function ResolveTextXAlignment(value)
				local Alignment = string.lower(tostring(value or "left"));

				if Alignment == "center" then
					return Enum.TextXAlignment.Center;
				elseif Alignment == "right" then
					return Enum.TextXAlignment.Right;
				end;

				return Enum.TextXAlignment.Left;
			end;
			local function GetSectionHeaderHeight()
				local TextHeight = (tonumber(Config.TextSize) or 11) + 9;
				local IconHeight = (Config.Icon and tostring(Config.Icon) ~= "") and 25 or 20;

				return math.max(20, TextHeight, IconHeight);
			end;

			local SectionFrame = Instance.new("Frame")
			local SectionIcon = Instance.new("ImageLabel")
			local SectionLabel = Instance.new("TextLabel")
			local SectionCollapseIcon = Instance.new("ImageLabel")
			local SectionHandler = Instance.new("Frame")
			local SectionHeaderSpacer = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")

			SectionFrame.Name = ModernV2.RandomString();
			local SectionPosition = string.lower(tostring(Config.Position));
			SectionFrame.Parent = ResolveFlowParent(SectionPosition)
			SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionFrame.BackgroundTransparency = 1.000
			SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionFrame.BorderSizePixel = 0
			SectionFrame.ClipsDescendants = true
			SectionFrame.Size = UDim2.new(1, -5, 0, 0)
			SectionFrame.ZIndex = 9

			SectionIcon.Name = ModernV2.RandomString();
			SectionIcon.Parent = SectionFrame
			SectionIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionIcon.BackgroundTransparency = 1.000
			SectionIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionIcon.BorderSizePixel = 0
			SectionIcon.Size = UDim2.new(0, 15, 0, 15)
			SectionIcon.ZIndex = 11
			SectionIcon.ImageColor3 = Config.IconColor
			SectionIcon.ImageTransparency = Config.Icon and 0.500 or 1
			SectionIcon.ScaleType = Enum.ScaleType.Fit
			if Config.Icon then
				ModernV2:SetIconMode(SectionIcon, Config.Icon);
			end;

			SectionLabel.Name = ModernV2.RandomString();
			SectionLabel.Parent = SectionFrame
			SectionLabel.AnchorPoint = Vector2.new(0, 0)
			SectionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionLabel.BackgroundTransparency = 1.000
			SectionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionLabel.BorderSizePixel = 0
			SectionLabel.Position = UDim2.new(0, 11, 0, 0)
			SectionLabel.Size = UDim2.new(1, -46, 0, 15)
			SectionLabel.ZIndex = 11
			SectionLabel.Font = Enum.Font.GothamMedium
			SectionLabel.Text = Config.Name
			SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionLabel.TextSize = tonumber(Config.TextSize) or 11
			SectionLabel.TextTransparency = 0.500
			SectionLabel.TextXAlignment = ResolveTextXAlignment(Config.TextXAlignment)
			ModernV2:AddTextGradient(SectionLabel);

			SectionCollapseIcon.Name = ModernV2.RandomString();
			SectionCollapseIcon.Parent = SectionFrame
			SectionCollapseIcon.AnchorPoint = Vector2.new(1, 0)
			SectionCollapseIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionCollapseIcon.BackgroundTransparency = 1.000
			SectionCollapseIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionCollapseIcon.BorderSizePixel = 0
			SectionCollapseIcon.Position = SectionBoxed and UDim2.new(1, -8, 0, 1) or UDim2.new(1, -8, 0, -4)
			SectionCollapseIcon.Size = UDim2.new(0, 24, 0, 24)
			SectionCollapseIcon.Visible = Config.Collapsible == true
			SectionCollapseIcon.ZIndex = 12
			ModernV2:SetIconMode(SectionCollapseIcon, "chevron-small-down")
			SectionCollapseIcon.ImageColor3 = Color3.fromRGB(223, 223, 223)
			SectionCollapseIcon.ImageTransparency = 0.500
			SectionCollapseIcon.ScaleType = Enum.ScaleType.Fit

			SectionHandler.Name = ModernV2.RandomString();
			SectionHandler.Parent = SectionFrame
			SectionHandler.AnchorPoint = Vector2.new(0.5, 0)
			SectionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
			SectionHandler.BackgroundTransparency = 0.500
			SectionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionHandler.BorderSizePixel = 0
			SectionHandler.ClipsDescendants = true
			SectionHandler.Position = SectionBoxed and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0.5, 0, 0, GetSectionHeaderHeight())
			SectionHandler.Size = SectionBoxed and UDim2.new(1, -10, 1, 0) or UDim2.new(1, -10, 1, -GetSectionHeaderHeight() - 1)
			SectionHandler.ZIndex = 9

			SectionHeaderSpacer.Name = ModernV2.RandomString();
			SectionHeaderSpacer.Parent = SectionHandler
			SectionHeaderSpacer.BackgroundTransparency = 1.000
			SectionHeaderSpacer.BorderSizePixel = 0
			SectionHeaderSpacer.LayoutOrder = -100000
			SectionHeaderSpacer.Size = UDim2.new(1, 0, 0, GetSectionHeaderHeight() + 4)
			SectionHeaderSpacer.Visible = SectionBoxed
			SectionHeaderSpacer.ZIndex = 9

			UIStroke.Transparency = 0.650
			UIStroke.Color = Color3.fromRGB(45, 48, 58)
			UIStroke.Parent = SectionHandler

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = SectionHandler

			UIListLayout.Parent = SectionHandler
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local CollapseInput;
			local function UpdateSectionHeaderLayout()
				local HasIcon = Config.Icon ~= nil and tostring(Config.Icon) ~= "";
				local HeaderHeight = GetSectionHeaderHeight();
				local TextSize = tonumber(Config.TextSize) or 11;
				local LabelHeight = math.max(15, TextSize + 4);
				local IconSize = math.clamp(TextSize + 2, 14, 20);
				local HeaderY = math.max(0, math.floor((HeaderHeight - LabelHeight) / 2));
				local IconY = math.max(0, math.floor((HeaderHeight - IconSize) / 2));
				local ChevronY = math.floor((HeaderHeight - 24) / 2);
				local IconX = 11;
				local LabelX = HasIcon and 32 or 11;
				local RightPadding = Config.Collapsible == true and 38 or 11;

				SectionIcon.Visible = HasIcon;
				SectionIcon.Position = UDim2.new(0, IconX, 0, IconY);
				SectionIcon.Size = UDim2.new(0, IconSize, 0, IconSize);
				SectionIcon.ImageColor3 = Config.IconColor;
				SectionIcon.ImageTransparency = HasIcon and 0.500 or 1;
				SectionLabel.TextSize = TextSize;
				SectionLabel.Position = UDim2.new(0, LabelX, 0, HeaderY);
				SectionLabel.Size = UDim2.new(1, -(LabelX + RightPadding), 0, LabelHeight);
				SectionLabel.TextXAlignment = ResolveTextXAlignment(Config.TextXAlignment);
				SectionCollapseIcon.Position = UDim2.new(1, -8, 0, ChevronY);
				SectionHeaderSpacer.Size = UDim2.new(1, 0, 0, GetSectionHeaderHeight() + 4);
				SectionHandler.Position = SectionBoxed and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0.5, 0, 0, GetSectionHeaderHeight());
				SectionHandler.Size = SectionBoxed and UDim2.new(1, -10, 1, 0) or UDim2.new(1, -10, 1, -GetSectionHeaderHeight() - 1);
				if CollapseInput then
					CollapseInput.Size = UDim2.new(1, 0, 0, GetSectionHeaderHeight());
				end;
			end;

			UpdateSectionHeaderLayout();

			local Section = ModernV2:RegisiterItem(SectionHandler , Tab.Signal);
			Section.Collapsible = Config.Collapsible == true;
			Section.Collapsed = Config.Collapsed == true;
			Section.Root = SectionFrame;
			ModernV2:AttachLockMethods(Section, SectionFrame, Config);
			ModernV2.SectionOwners[SectionHandler] = Section;

			local IsSectionRendered = Tab.Signal:GetValue();
			local function UpdateSectionSize()
				if not IsSectionRendered then
					SectionFrame.Size = UDim2.new(1, -5, 0, 0);
					return;
				end;

				local ContentHeight = UIListLayout.AbsoluteContentSize.Y;
				local HeaderHeight = GetSectionHeaderHeight();
				local HeaderSpacerHeight = SectionBoxed and (HeaderHeight + 4) or 0;
				local BoxPadding = 0;
				local RealContentHeight = math.max(0, ContentHeight - HeaderSpacerHeight);
				local TargetHeight = SectionBoxed and (HeaderSpacerHeight + BoxPadding) or HeaderHeight;

				if not Section.Collapsed and RealContentHeight > 1 then
					TargetHeight = SectionBoxed and (HeaderSpacerHeight + RealContentHeight + BoxPadding) or (ContentHeight + HeaderHeight - 0.5);
				end;

				ModernV2.PlayAnimate(SectionFrame , VSlowTween , {
					Size = UDim2.new(1, -5, 0, TargetHeight)
				})
			end;

			local function RenderCollapsedState()
				local ShowContent = IsSectionRendered and not Section.Collapsed;

				SectionHandler.Visible = SectionBoxed and IsSectionRendered or ShowContent;
				UIListLayout.Parent = SectionHandler;

				if Section.Collapsible then
					ModernV2.PlayAnimate(SectionCollapseIcon,SlowyTween,{
						Rotation = Section.Collapsed and -90 or 0,
						ImageTransparency = IsSectionRendered and 0.500 or 1
					})
				end;

				UpdateSectionSize();
			end;

			ModernV2:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(UpdateSectionSize)));

			function Section:SetCollapsed(value)
				if not Section.Collapsible then
					Section.Collapsible = true;
					Config.Collapsible = true;
					SectionCollapseIcon.Visible = true;
				end;

				Section.Collapsed = value == true;
				Config.Collapsed = Section.Collapsed;
				RenderCollapsedState();
				return Section;
			end;

			function Section:ToggleCollapsed()
				return Section:SetCollapsed(not Section.Collapsed);
			end;

			function Section:GetCollapsed()
				return Section.Collapsed;
			end;

			function Section:SetCollapsible(value)
				Section.Collapsible = value == true;
				Config.Collapsible = Section.Collapsible;
				SectionBoxed = Section.Collapsible and Config.Box == true;
				SectionCollapseIcon.Visible = Section.Collapsible;
				SectionHeaderSpacer.Visible = SectionBoxed;
				UpdateSectionHeaderLayout();

				if not Section.Collapsible then
					Section.Collapsed = false;
					Config.Collapsed = false;
				end;

				RenderCollapsedState();
				return Section;
			end;

			function Section:SetBox(value)
				Config.Box = value == true;
				SectionBoxed = Section.Collapsible and Config.Box == true;
				SectionHeaderSpacer.Visible = SectionBoxed;
				UpdateSectionHeaderLayout();
				RenderCollapsedState();
				return Section;
			end;

			function Section:GetBox()
				return SectionBoxed;
			end;

			function Section:SetIcon(icon)
				Config.Icon = icon;

				if Config.Icon and tostring(Config.Icon) ~= "" then
					ModernV2:SetIconMode(SectionIcon, Config.Icon);
				end;

				UpdateSectionHeaderLayout();
				RenderCollapsedState();
				return Section;
			end;

			function Section:SetIconColor(color)
				Config.IconColor = color or Config.IconColor;
				UpdateSectionHeaderLayout();
				return Section;
			end;

			function Section:SetTextSize(size)
				Config.TextSize = tonumber(size) or Config.TextSize;
				UpdateSectionHeaderLayout();
				RenderCollapsedState();
				return Section;
			end;

			function Section:SetTextXAlignment(alignment)
				Config.TextXAlignment = alignment or Config.TextXAlignment;
				UpdateSectionHeaderLayout();
				return Section;
			end;

			if Config.Collapsible then
				CollapseInput = ModernV2:CreateInput(SectionFrame , LPH_NO_VIRTUALIZE(function()
					Section:ToggleCollapsed();
				end));
				CollapseInput.ZIndex = 12;
				CollapseInput.Size = UDim2.new(1, 0, 0, GetSectionHeaderHeight());
			end;

			Section.SetRender = LPH_NO_VIRTUALIZE(function(value)
				IsSectionRendered = value == true;
				if value then
					ModernV2.PlayAnimate(SectionIcon,SlowyTween,{
						ImageTransparency = (Config.Icon and tostring(Config.Icon) ~= "") and 0.500 or 1
					})

					ModernV2.PlayAnimate(SectionLabel,SlowyTween,{
						TextTransparency = 0.500
					})

					ModernV2.PlayAnimate(SectionHandler,SlowyTween,{
						BackgroundTransparency = 0.500
					})

					ModernV2.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.650
					})
				else
					ModernV2.PlayAnimate(SectionIcon,SlowyTween,{
						ImageTransparency = 1
					})

					ModernV2.PlayAnimate(SectionLabel,SlowyTween,{
						TextTransparency = 1
					})

					ModernV2.PlayAnimate(SectionHandler,SlowyTween,{
						BackgroundTransparency = 1
					})

					ModernV2.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 1
					})
				end;

				RenderCollapsedState();
			end);

			Section.SetRender(Tab.Signal:GetValue());
			Tab.Signal:Connect(Section.SetRender);

			return CaseInsensitive(Section);
		end;

		function Tab:AddTabbox(Config)
			if typeof(Config) ~= "table" then
				Config = {
					Name = Config,
				};
			end;

			Config = ModernV2:ProcessParams(Config , {
				Name = "TABBOX",
				Position = 'left',
				Side = nil,
				Locked = false,
				TextLocked = "Locked",
			});

			local TabboxFrame = Instance.new("Frame")
			local TabboxLabel = Instance.new("TextLabel")
			local TabboxHolder = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local ButtonHolder = Instance.new("Frame")
			local ButtonLayout = Instance.new("UIListLayout")

			local Tabbox = {
				Tabs = {},
				ActiveTab = nil,
			};

			TabboxFrame.Name = ModernV2.RandomString();
			local TabboxPosition = (Config.Side == 1 and "left") or (Config.Side == 2 and "right") or string.lower(Config.Position);

			TabboxFrame.Parent = ResolveFlowParent(TabboxPosition)
			TabboxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabboxFrame.BackgroundTransparency = 1.000
			TabboxFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabboxFrame.BorderSizePixel = 0
			TabboxFrame.ClipsDescendants = true
			TabboxFrame.Size = UDim2.new(1, -5, 0, 55)
			TabboxFrame.ZIndex = 9
			ModernV2:AttachLockMethods(Tabbox, TabboxFrame, Config);

			TabboxLabel.Name = ModernV2.RandomString();
			TabboxLabel.Parent = TabboxFrame
			TabboxLabel.AnchorPoint = Vector2.new(0.5, 0)
			TabboxLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabboxLabel.BackgroundTransparency = 1.000
			TabboxLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabboxLabel.BorderSizePixel = 0
			TabboxLabel.Position = UDim2.new(0.5, 0, 0, 0)
			TabboxLabel.Size = UDim2.new(1, -35, 0, 15)
			TabboxLabel.ZIndex = 9
			TabboxLabel.Font = Enum.Font.GothamMedium
			TabboxLabel.Text = Config.Name
			TabboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabboxLabel.TextSize = 11.000
			TabboxLabel.TextTransparency = 0.500
			TabboxLabel.TextXAlignment = Enum.TextXAlignment.Left
			ModernV2:AddTextGradient(TabboxLabel);

			TabboxHolder.Name = ModernV2.RandomString();
			TabboxHolder.Parent = TabboxFrame
			TabboxHolder.AnchorPoint = Vector2.new(0.5, 0)
			TabboxHolder.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
			TabboxHolder.BackgroundTransparency = 0.500
			TabboxHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabboxHolder.BorderSizePixel = 0
			TabboxHolder.ClipsDescendants = true
			TabboxHolder.Position = UDim2.new(0.5, 0, 0, 20)
			TabboxHolder.Size = UDim2.new(1, -10, 1, -21)
			TabboxHolder.ZIndex = 9

			UIStroke.Transparency = 0.650
			UIStroke.Color = Color3.fromRGB(45, 48, 58)
			UIStroke.Parent = TabboxHolder

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = TabboxHolder

			ButtonHolder.Name = ModernV2.RandomString();
			ButtonHolder.Parent = TabboxHolder
			ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ButtonHolder.BackgroundTransparency = 1.000
			ButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ButtonHolder.BorderSizePixel = 0
			ButtonHolder.Position = UDim2.new(0, 5, 0, 5)
			ButtonHolder.Size = UDim2.new(1, -10, 0, 28)
			ButtonHolder.ZIndex = 10

			ButtonLayout.Parent = ButtonHolder
			ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
			ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ButtonLayout.Padding = UDim.new(0, 5)

			local UpdateSize = LPH_NO_VIRTUALIZE(function()
				local ActiveTab = Tabbox.ActiveTab;
				local height = 41;

				if ActiveTab and ActiveTab.Layout then
					height = ActiveTab.Layout.AbsoluteContentSize.Y + 41;
				end;

				if height <= 41 then
					height = 55;
				end;

				ModernV2.PlayAnimate(TabboxFrame , VSlowTween , {
					Size = UDim2.new(1, -5, 0, height + 19.5)
				})
			end);

			local UpdateParentRender = LPH_NO_VIRTUALIZE(function(value)
				if value then
					ModernV2.PlayAnimate(TabboxLabel,SlowyTween,{
						TextTransparency = 0.500
					})

					ModernV2.PlayAnimate(TabboxHolder,SlowyTween,{
						BackgroundTransparency = 0.500
					})

					ModernV2.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.650
					})
				else
					ModernV2.PlayAnimate(TabboxLabel,SlowyTween,{
						TextTransparency = 1
					})

					ModernV2.PlayAnimate(TabboxHolder,SlowyTween,{
						BackgroundTransparency = 1
					})

					ModernV2.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 1
					})
				end;

				for _,SubTab in ipairs(Tabbox.Tabs) do
					SubTab.Signal:SetValue(value and Tabbox.ActiveTab == SubTab);
					SubTab.Root.Visible = Tabbox.ActiveTab == SubTab;
					SubTab.RenderButton(value and Tabbox.ActiveTab == SubTab);
				end;
			end);

			function Tabbox:AddTab(Name , IconName)
				local TabConfig = {};

				if typeof(Name) == "table" then
					TabConfig = Name;
					IconName = TabConfig.Icon or TabConfig.IconName or IconName;
					Name = TabConfig.Name or TabConfig.Title or "Tab";
				end;

				local SubTab = {
					Name = Name or "Tab",
					Icon = IconName or "folder",
					Signal = ModernV2:CreateSignal(false),
				};

				TabConfig.Locked = TabConfig.Locked == true;
				TabConfig.TextLocked = TabConfig.TextLocked or "Locked";

				local Button = Instance.new("Frame")
				local ButtonCorner = Instance.new("UICorner")
				local ButtonStroke = Instance.new("UIStroke")
				local Icon = Instance.new("ImageLabel")
				local Label = Instance.new("TextLabel")
				local Container = Instance.new("Frame")
				local Layout = Instance.new("UIListLayout")

				Button.Name = ModernV2.RandomString();
				Button.Parent = ButtonHolder
				Button.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
				Button.BackgroundTransparency = 1.000
				Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Button.BorderSizePixel = 0
				Button.ClipsDescendants = true
				Button.Size = UDim2.new(0, 0, 1, 0)
				Button.ZIndex = 11
				ModernV2:AttachLockMethods(SubTab, Button, TabConfig);

				ButtonCorner.CornerRadius = UDim.new(0, 5)
				ButtonCorner.Parent = Button

				ButtonStroke.Transparency = 1
				ButtonStroke.Color = Color3.fromRGB(45, 48, 58)
				ButtonStroke.Parent = Button

				Icon.Name = ModernV2.RandomString();
				Icon.Parent = Button
				Icon.AnchorPoint = Vector2.new(0, 0.5)
				Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon.BackgroundTransparency = 1.000
				Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon.BorderSizePixel = 0
				Icon.Position = UDim2.new(0, 7, 0.5, 0)
				Icon.Size = UDim2.new(0, 18, 0, 18)
				Icon.ZIndex = 12
				ModernV2:SetIconMode(Icon, SubTab.Icon)
				Icon.ImageColor3 = Color3.fromRGB(223, 223, 223)
				Icon.ImageTransparency = 0.500
				Icon.ScaleType = Enum.ScaleType.Fit

				Label.Name = ModernV2.RandomString();
				Label.Parent = Button
				Label.AnchorPoint = Vector2.new(0, 0.5)
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BackgroundTransparency = 1.000
				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0, 29, 0.5, 0)
				Label.Size = UDim2.new(1, -34, 0, 15)
				Label.ZIndex = 12
				Label.Font = Enum.Font.GothamMedium
				Label.Text = SubTab.Name
				Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				Label.TextSize = 11.000
				Label.TextTransparency = 0.500
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.TextTruncate = Enum.TextTruncate.AtEnd
				ModernV2:AddTextGradient(Label);

				Container.Name = ModernV2.RandomString();
				Container.Parent = TabboxHolder
				Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Container.BackgroundTransparency = 1.000
				Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Container.BorderSizePixel = 0
				Container.ClipsDescendants = true
				Container.Position = UDim2.new(0, 5, 0, 36)
				Container.Size = UDim2.new(1, -10, 1, -39)
				Container.Visible = false
				Container.ZIndex = 10

				Layout.Parent = Container
				Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				Layout.SortOrder = Enum.SortOrder.LayoutOrder

				SubTab.Root = Container;
				SubTab.Layout = Layout;
				SubTab.Button = Button;

				local widthScale = 1 / math.max(#Tabbox.Tabs + 1,1);
				for _,ExistingTab in ipairs(Tabbox.Tabs) do
					ExistingTab.Button.Size = UDim2.new(widthScale, -4, 1, 0);
				end;
				Button.Size = UDim2.new(widthScale, -4, 1, 0);

				local RenderButton = LPH_NO_VIRTUALIZE(function(active)
					if active then
						ModernV2.PlayAnimate(Button,SlowyTween,{
							BackgroundTransparency = 0.150
						})

						ModernV2.PlayAnimate(ButtonStroke,SlowyTween,{
							Transparency = 0.650
						})

						ModernV2.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = 0,
							TextColor3 = ModernV2.AccentColor
						})

						ModernV2.PlayAnimate(Label,SlowyTween,{
							TextTransparency = 0
						})
					else
						ModernV2.PlayAnimate(Button,SlowyTween,{
							BackgroundTransparency = 1
						})

						ModernV2.PlayAnimate(ButtonStroke,SlowyTween,{
							Transparency = 1
						})

						ModernV2.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = Tab.Signal:GetValue() and 0.500 or 1,
							TextColor3 = Color3.fromRGB(223, 223, 223)
						})

						ModernV2.PlayAnimate(Label,SlowyTween,{
							TextTransparency = Tab.Signal:GetValue() and 0.500 or 1
						})
					end;
				end);

				function SubTab:Show()
					if Tabbox.GetLocked and Tabbox:GetLocked() then
						return SubTab;
					end;

					if SubTab.GetLocked and SubTab:GetLocked() then
						return SubTab;
					end;

					Tabbox.ActiveTab = SubTab;

					for _,Item in ipairs(Tabbox.Tabs) do
						local isActive = Item == SubTab and Tab.Signal:GetValue();

						Item.Root.Visible = Item == SubTab;
						Item.Signal:SetValue(isActive);
						Item.RenderButton(Item == SubTab and Tab.Signal:GetValue());
					end;

					UpdateSize();
				end;

				function SubTab:Hide()
					Container.Visible = false;
					SubTab.Signal:SetValue(false);
					RenderButton(false);
				end;

				SubTab.RenderButton = RenderButton;

				ModernV2:AddSignal(Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
					if Tabbox.ActiveTab == SubTab then
						UpdateSize();
					end;
				end)))

				local Input = ModernV2:CreateInput(Button , LPH_NO_VIRTUALIZE(function()
					if Tabbox.GetLocked and Tabbox:GetLocked() then
						return;
					end;

					if SubTab.GetLocked and SubTab:GetLocked() then
						return;
					end;

					SubTab:Show();
				end));

				ModernV2:AddSignal(Input.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					if Tabbox.ActiveTab ~= SubTab and Tab.Signal:GetValue() then
						ModernV2.PlayAnimate(Button,SlowyTween,{
							BackgroundTransparency = 0.650
						})
					end;
				end)))

				ModernV2:AddSignal(Input.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					if Tabbox.ActiveTab ~= SubTab then
						RenderButton(false);
					end;
				end)))

				local Handler = ModernV2:RegisiterItem(Container , SubTab.Signal);
				SubTab.Handler = Handler;

				function Handler:Select()
					if SubTab.GetLocked and SubTab:GetLocked() then
						return Handler;
					end;

					SubTab:Show();
					return Handler;
				end;

				function Handler:SetLocked(value)
					if SubTab.SetLocked then
						SubTab:SetLocked(value);
					end;

					if value == true and Tabbox.ActiveTab == SubTab then
						SubTab:Hide();

						for _,Item in ipairs(Tabbox.Tabs) do
							if Item ~= SubTab and (not Item.GetLocked or not Item:GetLocked()) then
								Item:Show();
								break;
							end;
						end;
					end;

					return Handler;
				end;

				function Handler:GetLocked()
					return SubTab.GetLocked and SubTab:GetLocked() or false;
				end;

				function Handler:SetTextLocked(text)
					if SubTab.SetTextLocked then
						SubTab:SetTextLocked(text);
					end;

					return Handler;
				end;

				function Handler:SetIcon(icon)
					SubTab.Icon = icon or SubTab.Icon;
					ModernV2:SetIconMode(Icon, SubTab.Icon);
					return Handler;
				end;

				function Handler:SetText(text)
					Tabbox.Tabs[SubTab.Name] = nil;
					SubTab.Name = text or SubTab.Name;
					Tabbox.Tabs[SubTab.Name] = SubTab;
					Label.Text = SubTab.Name;
					return Handler;
				end;

				table.insert(Tabbox.Tabs,SubTab);
				Tabbox.Tabs[SubTab.Name] = SubTab;

				if not Tabbox.ActiveTab then
					SubTab:Show();
				else
					SubTab:Hide();
				end;

				UpdateSize();

				return CaseInsensitive(Handler);
			end;

			function Tabbox:Select(Name)
				local SubTab = Tabbox.Tabs[Name];

				if SubTab then
					SubTab:Show();
				end;

				return Tabbox;
			end;

			function Tabbox:SetVisible(value)
				TabboxFrame.Visible = value;
			end;

			UpdateParentRender(Tab.Signal:GetValue());
			Tab.Signal:Connect(UpdateParentRender);
			UpdateSize();

			return CaseInsensitive(Tabbox);
		end;

		function Tab:AddLeftTabbox(Name)
			return Tab:AddTabbox({
				Name = Name,
				Position = "left",
			});
		end;

		function Tab:AddRightTabbox(Name)
			return Tab:AddTabbox({
				Name = Name,
				Position = "right",
			});
		end;

		function Tab:AddCenterTabbox(Name)
			return Tab:AddTabbox({
				Name = Name,
				Position = "center",
			});
		end;

		return CaseInsensitive(Tab);
	end;

	function Window:_InitConfig()
		local ConfigSignal = ModernV2:CreateSignal(false);
		local ConfigLib = {
			Signals = {},
		};

		local ConfigMenu = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local UIStroke = Instance.new("UIStroke")
		local InputFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local BasedHandler = Instance.new("Frame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local TextInput = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")
		local LoadConfig = Instance.new("Frame")
		local Icon = Instance.new("ImageLabel")
		local UICorner_3 = Instance.new("UICorner")
		local UICorner_4 = Instance.new("UICorner")

		local shadow = ModernV2:CreateShadow(ConfigMenu);

		ConfigLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ConfigMenu.Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 96)

				ModernV2.PlayAnimate(ConfigMenu , SlowyTween , {
					BackgroundTransparency = 0.035,
					Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 95)
				})	

				ModernV2.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 0.650
				})
				ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.200
				})	

				ModernV2.PlayAnimate(UIStroke_2 , SlowyTween , {
					Transparency = 0.65
				})	

				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				})	
				ModernV2.PlayAnimate(TextInput , SlowyTween , {
					BackgroundTransparency = 0
				})	
				ModernV2.PlayAnimate(TextBox , SlowyTween , {
					TextTransparency = 0.350
				})	
				ModernV2.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.350
				})	

				ModernV2.PlayAnimate(ConfigBthIcon , SlowyTween , {
					Rotation = 180
				})	

				shadow:Render(true)
			else
				ModernV2.PlayAnimate(ConfigBthIcon , SlowyTween , {
					Rotation = 0
				})

				ModernV2.PlayAnimate(ConfigMenu , SlowyTween , {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 96)
				})	

				ModernV2.PlayAnimate(UIStroke_2 , SlowyTween , {
					Transparency = 1
				})	

				ModernV2.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				})
				ModernV2.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				})	
				ModernV2.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				})	
				ModernV2.PlayAnimate(TextInput , SlowyTween , {
					BackgroundTransparency = 1
				})	
				ModernV2.PlayAnimate(TextBox , SlowyTween , {
					TextTransparency = 1
				})	
				ModernV2.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				})	

				shadow:Render(false)
			end;
		end);

		ModernV2:AddSignal(ConfigMenu:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if ConfigMenu.BackgroundTransparency > 0.9 then
				ConfigMenu.Visible = false;
				UIListLayout.Parent = nil;
				ConfigMenu.Parent = nil;
			else

				ConfigMenu.Visible = true;
				UIListLayout.Parent = ConfigMenu

				if ModernV2.Global3DRenderMode then
					ConfigMenu.Parent = ModernV2.GlobalSurfaceGui;
				else
					ConfigMenu.Parent = ModernV2.ScreenGui;
				end;
			end
		end)))

		ConfigMenu.Name = ModernV2.RandomString();
		ConfigMenu.Parent = ModernV2.ScreenGui;
		ConfigMenu.AnchorPoint = Vector2.new(0.5, 0)
		ConfigMenu.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		ConfigMenu.BackgroundTransparency = 0.035
		ConfigMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ConfigMenu.BorderSizePixel = 0
		ConfigMenu.ClipsDescendants = true
		ConfigMenu.Position = UDim2.new(255,255,255,255)
		ConfigMenu.Size = UDim2.new(0, 220,0, 110)
		ConfigMenu.ZIndex = 151

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ConfigMenu

		UIListLayout.Parent = ConfigMenu
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = ConfigMenu

		InputFrame.Name = ModernV2.RandomString();
		InputFrame.Parent = ConfigMenu
		InputFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		InputFrame.BackgroundTransparency = 1.000
		InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputFrame.BorderSizePixel = 0
		InputFrame.Size = UDim2.new(1, 0, 0, 30)
		InputFrame.ZIndex = 154

		BasedLabel.Name = ModernV2.RandomString();
		BasedLabel.Parent = InputFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 11, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = 154
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = "Config"
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.200
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = ModernV2.RandomString();
		LineFrame.Parent = InputFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = 154

		BasedHandler.Name = ModernV2.RandomString();
		BasedHandler.Parent = InputFrame
		BasedHandler.AnchorPoint = Vector2.new(1, 0)
		BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedHandler.BackgroundTransparency = 1.000
		BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedHandler.BorderSizePixel = 0
		BasedHandler.Position = UDim2.new(1, -11, 0, 2)
		BasedHandler.Size = UDim2.new(1, -20, 0, 25)
		BasedHandler.ZIndex = 154

		UIListLayout_2.Parent = BasedHandler
		UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout_2.Padding = UDim.new(0, 5)

		ModernV2:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			if #ConfigLib.Signals <= 0 then
				ModernV2.PlayAnimate(ConfigMenu , SlowyTween , {
					Size = UDim2.new(0, 220,0, UIListLayout.AbsoluteContentSize.Y + 0);
				})
			else
				ModernV2.PlayAnimate(ConfigMenu , SlowyTween , {
					Size = UDim2.new(0, 220,0, UIListLayout.AbsoluteContentSize.Y + 5);
				})
			end;

		end)));

		TextInput.Name = ModernV2.RandomString();
		TextInput.Parent = BasedHandler
		TextInput.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput.BorderSizePixel = 0
		TextInput.ClipsDescendants = true
		TextInput.Size = UDim2.new(0, 100, 0, 18)
		TextInput.ZIndex = 154

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = TextInput

		UIStroke_2.Transparency = 0.650
		UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
		UIStroke_2.Parent = TextInput

		TextBox.Parent = TextInput
		TextBox.AnchorPoint = Vector2.new(0, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0, 5, 0.5, 0)
		TextBox.Size = UDim2.new(1, -5, 0, 17)
		TextBox.ZIndex = 154
		TextBox.ClearTextOnFocus = false
		TextBox.Font = Enum.Font.GothamMedium
		TextBox.PlaceholderText = "Config Name ..."
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 11.000
		TextBox.TextTransparency = 0.350
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		LoadConfig.Name = ModernV2.RandomString();
		LoadConfig.Parent = BasedHandler
		LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
		LoadConfig.BackgroundTransparency = 1.000
		LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LoadConfig.BorderSizePixel = 0
		LoadConfig.ClipsDescendants = true
		LoadConfig.Size = UDim2.new(0, 20, 0, 18)
		LoadConfig.ZIndex = 153

		Icon.Name = ModernV2.RandomString();
		Icon.Parent = LoadConfig
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Icon.Size = UDim2.new(1, 0, 1, 0)
		Icon.ZIndex = 153
		ModernV2:SetIconMode(Icon, "plus-large")
		Icon.ImageColor3 = Color3.fromRGB(223, 223, 223)
		Icon.ImageTransparency = 0.350
		Icon.ScaleType = Enum.ScaleType.Fit

		UICorner_3.CornerRadius = UDim.new(0, 4)
		UICorner_3.Parent = LoadConfig

		UICorner_4.CornerRadius = UDim.new(0, 10)
		UICorner_4.Parent = InputFrame

		local OpenButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")

		OpenButton.Name = ModernV2.RandomString();
		OpenButton.Parent = ConfigFrame
		OpenButton.AnchorPoint = Vector2.new(0, 0.5)
		OpenButton.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		OpenButton.BackgroundTransparency = 1.000
		OpenButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OpenButton.BorderSizePixel = 0
		OpenButton.Position = UDim2.new(0, 31, 0.5, 0)
		OpenButton.Size = UDim2.new(1, -31, 1, 0)
		OpenButton.ZIndex = 10
		OpenButton.Font = Enum.Font.SourceSans
		OpenButton.Text = ""
		OpenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		OpenButton.TextSize = 14.000

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = OpenButton

		ConfigLib.SetRender(false);
		ConfigSignal:Connect(ConfigLib.SetRender);
		ConfigLib.UnsafeThread = nil;
		ConfigLib.SelectedConfig = Window.ConfigAutoSaveFile or "Default";
		ConfigName.Text = ConfigLib.SelectedConfig;

		local UpdateSize = LPH_NO_VIRTUALIZE(function()
			local size = TextService:GetTextSize(ConfigName.Text , ConfigName.TextSize,ConfigName.Font,Vector2.new(math.huge,math.huge));

			ModernV2.PlayAnimate(ConfigFrame,SlowyTween , {
				Size = UDim2.fromOffset(size.X + 75, 30)
			});
		end);

		UpdateSize();

		function ConfigLib:GetData(performance)
			local ikc = {};
			
			local cd = 0;
			-- Config hanya menyimpan element yang punya Flag/Key/ConfigKey.
			-- Flag dipakai sebagai key unik untuk save/load value.
			for Flag,v in next , ModernV2.Flags do
				if v and v.GetValue then
					local data = v:GetValue();

					if typeof(data) == 'Color3' then
						table.insert(ikc,{
							Idx = Flag,
							Value = data:ToHex(),
						});
					else
						table.insert(ikc,{
							Idx = Flag,
							Value = data
						});
					end;
				end;
				
				if performance then
					if cd % 35 == 1 then
						task.wait()
					end
				end;
				
				cd += 1;
			end;

			local JsonData = HttpService:JSONEncode(ikc);

			if Window.ConfigEncrypted then
				return ModernV2.Base64Encode(Encryption.new(JsonData));
			end;

			return JsonData;
		end;

		function ConfigLib:WriteConfig(ConfigNameStr, Overwrite, performance)
			ConfigNameStr = tostring(ConfigNameStr or ConfigLib.SelectedConfig or "Default");
			ConfigNameStr = string.sub(ConfigNameStr, 1, 24);

			if not ConfigNameStr:byte() or ConfigNameStr:find('/',1,true) or ConfigNameStr:find('\\',1,true) then
				Logging.new("folder","Invalid config name!",3.5);
				return false;
			end;

			if not isfolder(Window.ConfigFolder) then
				makefolder(Window.ConfigFolder);
			end;

			local path = Window.ConfigFolder..'/'..ConfigNameStr;
			local Exists = isfile(path);
			local ShouldOverwrite = Overwrite;

			if ShouldOverwrite == nil then
				ShouldOverwrite = Window.ConfigOverwrite;
			end;

			if Exists and not ShouldOverwrite then
				Logging.new("folder","Config "..tostring(ConfigNameStr).." already exists!",3.5);
				return false;
			end;

			writefile(path,ConfigLib:GetData(performance));

			ConfigLib.SelectedConfig = ConfigNameStr;
			ConfigName.Text = ConfigNameStr;
			UpdateSize();

			Logging.new("folder",(Exists and "Overwritten " or "Created ")..tostring(ConfigNameStr),3.5);
			return true;
		end;

		function ConfigLib:RewriteSelectedAsJson()
			local WasEncrypted = Window.ConfigEncrypted;
			Window.ConfigEncrypted = false;

			local Saved = ConfigLib:WriteConfig(ConfigLib.SelectedConfig or "Default", true);
			Window.ConfigEncrypted = WasEncrypted;

			return Saved;
		end;

		function ConfigLib:DecodeData(data)
			local success, decoded = pcall(function()
				return HttpService:JSONDecode(data);
			end);

			if success and typeof(decoded) == "table" then
				return decoded;
			end;

			success, decoded = pcall(function()
				return HttpService:JSONDecode(Encryption.reverse(ModernV2.Base64Decode(data)));
			end);

			if success and typeof(decoded) == "table" then
				return decoded;
			end;

			return {};
		end;

		function ConfigLib:LoadData(data)
			local coded = ConfigLib:DecodeData(data);

			for i,v in next , coded do
				if v.Idx then
					if ModernV2.Flags[v.Idx] then
						task.spawn(function()
							ModernV2.Flags[v.Idx]:SetValue(v.Value)
						end)
					else
						ModernV2.PendingFlagValues[v.Idx] = v.Value;
					end;
				end;
			end;
		end;

		function ConfigLib:RefreshConfig()
			if not isfolder(Window.ConfigFolder) then
				makefolder(Window.ConfigFolder);
			end;
			
			if not isfile(Window.ConfigFolder..'/'..ConfigLib.SelectedConfig) then
				writefile(Window.ConfigFolder..'/'..ConfigLib.SelectedConfig,ConfigLib:GetData());
			end;
			
			for i,v in next,ConfigMenu:GetChildren() do
				if v:GetAttribute('ConfigItem') then
					v:Destroy();
				end;
			end;

			for i,v in next , ConfigLib.Signals do
				v:Disconnect();
			end

			table.clear(ConfigLib.Signals);

			local ConfigList = {};
			for i,v in next , listfiles(Window.ConfigFolder) do

				local name = string.sub(v , #Window.ConfigFolder + 2);

				table.insert(ConfigList , name)
			end;

			for i,ConfigNameStr in next , ConfigList do
				local ConfigItemFrame = Instance.new("Frame")
				local BasedHandler = Instance.new("Frame")
				local UIListLayout = Instance.new("UIListLayout")
				local DeleteConfig = Instance.new("Frame")
				local Icon = Instance.new("ImageLabel")
				local UICorner = Instance.new("UICorner")
				local OverwriteConfig = Instance.new("Frame")
				local Icon_3 = Instance.new("ImageLabel")
				local UICorner_4 = Instance.new("UICorner")
				local LoadConfig = Instance.new("Frame")
				local Icon_2 = Instance.new("ImageLabel")
				local UICorner_2 = Instance.new("UICorner")
				local UICorner_3 = Instance.new("UICorner")
				local BasedLabel = Instance.new("TextLabel")
				local UIStroke = Instance.new("UIStroke")

				ConfigItemFrame.Name = ModernV2.RandomString();
				ConfigItemFrame.Parent = ConfigMenu
				ConfigItemFrame.BackgroundColor3 = Color3.fromRGB(21, 20, 27)
				ConfigItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ConfigItemFrame.BorderSizePixel = 0
				ConfigItemFrame.Size = UDim2.new(1, -10, 0, 30)
				ConfigItemFrame.ZIndex = 153
				ConfigItemFrame:SetAttribute('ConfigItem',true);

				BasedHandler.Name = ModernV2.RandomString();
				BasedHandler.Parent = ConfigItemFrame
				BasedHandler.AnchorPoint = Vector2.new(1, 0)
				BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BasedHandler.BackgroundTransparency = 1.000
				BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
				BasedHandler.BorderSizePixel = 0
				BasedHandler.Position = UDim2.new(1, -11, 0, 2)
				BasedHandler.Size = UDim2.new(1, -20, 0, 25)
				BasedHandler.ZIndex = 153

				UIListLayout.Parent = BasedHandler
				UIListLayout.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				UIListLayout.Padding = UDim.new(0, 5)

				DeleteConfig.Name = ModernV2.RandomString();
				DeleteConfig.Parent = BasedHandler
				DeleteConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
				DeleteConfig.BackgroundTransparency = 1.000
				DeleteConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DeleteConfig.BorderSizePixel = 0
				DeleteConfig.ClipsDescendants = true
				DeleteConfig.Size = UDim2.new(0, 20, 0, 18)
				DeleteConfig.ZIndex = 153

				Icon.Name = ModernV2.RandomString();
				Icon.Parent = DeleteConfig
				Icon.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon.BackgroundTransparency = 1.000
				Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon.BorderSizePixel = 0
				Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon.Size = UDim2.new(1, 0, 1, 0)
				Icon.ZIndex = 153
				ModernV2:SetIconMode(Icon, "trash-can")
				Icon.ImageColor3 = Color3.fromRGB(223, 223, 223)
				Icon.ImageTransparency = 0.400
				Icon.ScaleType = Enum.ScaleType.Fit

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = DeleteConfig

				OverwriteConfig.Name = ModernV2.RandomString();
				OverwriteConfig.Parent = BasedHandler
				OverwriteConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
				OverwriteConfig.BackgroundTransparency = 1.000
				OverwriteConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
				OverwriteConfig.BorderSizePixel = 0
				OverwriteConfig.ClipsDescendants = true
				OverwriteConfig.Size = UDim2.new(0, 20, 0, 18)
				OverwriteConfig.ZIndex = 153

				Icon_3.Name = ModernV2.RandomString();
				Icon_3.Parent = OverwriteConfig
				Icon_3.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon_3.BackgroundTransparency = 1.000
				Icon_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon_3.BorderSizePixel = 0
				Icon_3.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon_3.Size = UDim2.new(1, 0, 1, 0)
				Icon_3.ZIndex = 153
				ModernV2:SetIconMode(Icon_3, "pencil-square")
				Icon_3.ImageColor3 = Color3.fromRGB(223, 223, 223)
				Icon_3.ImageTransparency = 0.400
				Icon_3.ScaleType = Enum.ScaleType.Fit

				UICorner_4.CornerRadius = UDim.new(0, 4)
				UICorner_4.Parent = OverwriteConfig

				LoadConfig.Name = ModernV2.RandomString();
				LoadConfig.Parent = BasedHandler
				LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
				LoadConfig.BackgroundTransparency = 1.000
				LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
				LoadConfig.BorderSizePixel = 0
				LoadConfig.ClipsDescendants = true
				LoadConfig.Size = UDim2.new(0, 20, 0, 18)
				LoadConfig.ZIndex = 153

				Icon_2.Name = ModernV2.RandomString();
				Icon_2.Parent = LoadConfig
				Icon_2.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon_2.BackgroundTransparency = 1.000
				Icon_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon_2.BorderSizePixel = 0
				Icon_2.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon_2.Size = UDim2.new(1, 0, 1, 0)
				Icon_2.ZIndex = 153
				ModernV2:SetIconMode(Icon_2, "arrow-right-from-portrait-rectangle")
				Icon_2.ImageColor3 = Color3.fromRGB(223, 223, 223)
				Icon_2.ImageTransparency = 0.400
				Icon_2.ScaleType = Enum.ScaleType.Fit

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = LoadConfig

				UICorner_3.CornerRadius = UDim.new(0, 5)
				UICorner_3.Parent = ConfigItemFrame

				BasedLabel.Name = ModernV2.RandomString();
				BasedLabel.Parent = ConfigItemFrame
				BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BasedLabel.BackgroundTransparency = 1.000
				BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				BasedLabel.BorderSizePixel = 0
				BasedLabel.Position = UDim2.new(0, 11, 0, 7)
				BasedLabel.Size = UDim2.new(0, 1, 0, 15)
				BasedLabel.ZIndex = 153
				BasedLabel.Font = Enum.Font.GothamMedium
				BasedLabel.Text = ConfigNameStr
				BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				BasedLabel.TextSize = 13.000
				BasedLabel.TextTransparency = 0.200
				BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

				UIStroke.Transparency = 0.500
				UIStroke.Color = Color3.fromRGB(45, 48, 58)
				UIStroke.Parent = ConfigItemFrame

				local Render = LPH_NO_VIRTUALIZE(function(rst)
					if rst then
						ModernV2.PlayAnimate(ConfigItemFrame,SlowyTween,{
							BackgroundTransparency = 0
						})

						ModernV2.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = 0.400
						})

						ModernV2.PlayAnimate(Icon_3,SlowyTween,{
							TextTransparency = 0.400
						})

						ModernV2.PlayAnimate(Icon_2,SlowyTween,{
							TextTransparency = 0.400
						})

						ModernV2.PlayAnimate(BasedLabel,SlowyTween,{
							TextTransparency = 0.200
						})

						ModernV2.PlayAnimate(UIStroke,SlowyTween,{
							Transparency = 0.500
						})
					else
						ModernV2.PlayAnimate(ConfigItemFrame,SlowyTween,{
							BackgroundTransparency = 1
						})

						ModernV2.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = 1
						})

						ModernV2.PlayAnimate(Icon_3,SlowyTween,{
							TextTransparency = 1
						})

						ModernV2.PlayAnimate(Icon_2,SlowyTween,{
							TextTransparency = 1
						})

						ModernV2.PlayAnimate(BasedLabel,SlowyTween,{
							TextTransparency = 1
						})

						ModernV2.PlayAnimate(UIStroke,SlowyTween,{
							Transparency = 1
						})
					end;
				end)

				Render(ConfigSignal:GetValue());
				table.insert(ConfigLib.Signals , ConfigSignal:Connect(Render));

				table.insert(ConfigLib.Signals , ConfigItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					ModernV2.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.25
					})
				end)));

				table.insert(ConfigLib.Signals , ConfigItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					ModernV2.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.500
					})
				end)));

				local deleter,signal = ModernV2:CreateInput(DeleteConfig,function()
					if ConfigNameStr == "Default" then
						Logging.new("trash-can","You can't delete default config!",3.5)
						return;
					end;
					
					delfile(Window.ConfigFolder..'/'..ConfigNameStr);

					UpdateSize();

					ConfigLib:RefreshConfig();

					Logging.new("trash-can",'Deleted '..tostring(ConfigNameStr),3.5)
				end);

				local _,overwrite_signal = ModernV2:CreateInput(OverwriteConfig,function()
					if ConfigLib:WriteConfig(ConfigNameStr, true) then
						ConfigLib.SelectedConfig = ConfigNameStr;
						ConfigName.Text = ConfigNameStr;

						UpdateSize();
						ConfigLib:RefreshConfig();
					end;
				end);

				local _,load_signal = ModernV2:CreateInput(LoadConfig,function()
					local path = Window.ConfigFolder..'/'..ConfigNameStr;

					if isfile(path) then
						local data = readfile(path);

						ConfigLib:LoadData(data);

						ConfigLib.SelectedConfig = ConfigNameStr;
						ConfigName.Text = ConfigNameStr;

						UpdateSize();

						ConfigLib:RefreshConfig();

						Logging.new("folder",'Loaded '..tostring(ConfigNameStr),3.5)
					end
				end);

				table.insert(ConfigLib.Signals , signal);
				table.insert(ConfigLib.Signals , overwrite_signal);
				table.insert(ConfigLib.Signals , load_signal);

				table.insert(ConfigLib.Signals , deleter.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					ModernV2.PlayAnimate(Icon,SlowyTween,{
						TextTransparency = 0.2,
						TextColor3 = Color3.fromRGB(223, 125, 125)
					})
				end)))

				table.insert(ConfigLib.Signals , deleter.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					ModernV2.PlayAnimate(Icon,SlowyTween,{
						TextTransparency = 0.400,
						TextColor3 = Color3.fromRGB(223, 223, 223)
					})
				end)))

				table.insert(ConfigLib.Signals , OverwriteConfig.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					ModernV2.PlayAnimate(Icon_3,SlowyTween,{
						TextTransparency = 0.2,
						TextColor3 = ModernV2.AccentColor
					})
				end)))

				table.insert(ConfigLib.Signals , OverwriteConfig.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					ModernV2.PlayAnimate(Icon_3,SlowyTween,{
						TextTransparency = 0.400,
						TextColor3 = Color3.fromRGB(223, 223, 223)
					})
				end)))

				table.insert(ConfigLib.Signals , LoadConfig.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					ModernV2.PlayAnimate(Icon_2,SlowyTween,{
						TextTransparency = 0.2,
						TextColor3 = ModernV2.AccentColor
					})
				end)))

				table.insert(ConfigLib.Signals , LoadConfig.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					ModernV2.PlayAnimate(Icon_2,SlowyTween,{
						TextTransparency = 0.400,
						TextColor3 = Color3.fromRGB(223, 223, 223)
					})
				end)))
			end;

			table.clear(ConfigList);
		end;
		
		task.delay(1,function()
			local ConfigNameStr = ConfigLib.SelectedConfig or "Default";
			local path = Window.ConfigFolder..'/'..ConfigNameStr;

			if Window.ConfigAutoLoad then
				if isfile(path) then
					local data = readfile(path);

					ConfigLib:LoadData(data);

					ConfigLib.SelectedConfig = ConfigNameStr;
					ConfigName.Text = ConfigNameStr;

					UpdateSize();

					ConfigLib:RefreshConfig();

					Logging.new("folder","Loaded "..tostring(ConfigNameStr),3.5);
				end;
			end;

			if not Window.ConfigSaveWindowState and not Window.Destroyed then
				Window.Signal:SetValue(true);
				Window:SetRender(true);

				if Window._MenuIcon then
					Window._MenuIcon:OnWindowToggle(true);
				end;
			end;

			if Window.ConfigAutoSave then
				task.spawn(function()
					while true do task.wait(5.75);
						local selected = ConfigLib.SelectedConfig or ConfigNameStr;
						local selectedPath = Window.ConfigFolder..'/'..selected;

						if Window.ConfigAutoSave and isfile(selectedPath) then
							writefile(selectedPath,ConfigLib:GetData(true));
						end;
					end;
				end);
			end;
		end);

		local hover_write = ModernV2:CreateInput(ConfigIcon,function()
			if ConfigLib:WriteConfig(ConfigLib.SelectedConfig or "Default", true) then
				ConfigLib:RefreshConfig();
			end;
		end);

		ModernV2:AddSignal(hover_write.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(ConfigIcon,SlowyTween,{
				TextTransparency = 0.1
			})
		end)));

		ModernV2:AddSignal(hover_write.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(ConfigIcon,SlowyTween,{
				TextTransparency = 0.25
			})
		end)));


		local mv = ModernV2:CreateInput(LoadConfig , function()
			local cfg_name = TextBox.Text;

			if cfg_name and cfg_name:byte() and not cfg_name:find('/',1,true) and not cfg_name:find('\\',1,true) then
				cfg_name = string.sub(cfg_name , 1 , 24);

				if ConfigLib:WriteConfig(cfg_name, Window.ConfigOverwrite) then
					TextBox.Text = "";
					ConfigLib:RefreshConfig();
				end;
			end;
		end);

		ModernV2:AddSignal(mv.MouseEnter:Connect(function()
			ModernV2.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.1
			})
		end))

		ModernV2:AddSignal(mv.MouseLeave:Connect(function()
			ModernV2.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.35
			})
		end))

		ConfigLib:RefreshConfig();

		OpenButton.MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
			if ConfigLib.UnsafeThread then
				ConfigLib.UnsafeThread:Disconnect();
				ConfigLib.UnsafeThread = nil;
			end;

			ConfigSignal:SetValue(true);

			ConfigLib.UnsafeThread = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not ModernV2:IsMouseOverFrame(ConfigMenu) then
						if ConfigLib.UnsafeThread then
							ConfigLib.UnsafeThread:Disconnect();
							ConfigLib.UnsafeThread = nil;
						end;

						ConfigSignal:SetValue(false);
					end;
				end;
			end)
		end));

		return ConfigLib;
	end;

	if Window.ConfigEnabled then
		Window.ConfigManager = Window:_InitConfig();
	else
		ConfigFrame.Visible = false;
	end;

	local UserSettings = ModernV2:CreateOptionWindow(BottomFrame , BottomFrame.ZIndex + 13);
	local reciveSignal;
	ModernV2:CreateInput(BottomFrame , LPH_NO_VIRTUALIZE(function()
		if reciveSignal then
			reciveSignal:Disconnect();
			reciveSignal = nil;	
		end;

		UserSettings.Signal:SetValue(true);

		reciveSignal = UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if not ModernV2:IsMouseOverFrame(UserSettings.Root) and not ModernV2:IsMouseOverFrame(BottomFrame) and not ModernV2.IsMosueOverOtherFrame then
					if reciveSignal then
						reciveSignal:Disconnect();
						reciveSignal = nil;	
					end;

					UserSettings.Signal:SetValue(false);
				end
			end
		end);
	end))

	Window.UserSettings = UserSettings;

	if Window.ConfigEnabled and Window.ConfigShowAutoSaveToggle then
		UserSettings:AddLabel("Auto Save"):AddToggle({
			Default = Window.ConfigAutoSave,
			Callback = function(value)
				Window.ConfigAutoSave = value;
			end,
		});
	end;

			UserSettings:AddLabel("Menu Scale"):AddDropdown({
				Default = ModernV2.IsMobile and "Mobile" or "Large",
				Values = { "Large", "Default", "Mobile", "Small", "Compact" },
				Callback = function(value)
					if ModernV2.Scales[value] then
						Window:SetSize(ModernV2.Scales[value]);
						Logging.new("crop","Scale changed to "..tostring(value),5);
			end;
		end,
	});

	UserSettings:AddLabel("Text Gradient"):AddToggle({
		Default = ModernV2.TextGradientEnabled,
		Callback = function(value)
			ModernV2:SetTextGradientEnabled(value);
		end,
	});

	function Window:AddToggle(Config)
		Config = ModernV2:ProcessParams(Config , {
			Name = "Toggle",
			Default = false,
			Flag = nil,
			Callback = EmptyFunction,
		});

		return Window.UserSettings:AddLabel(Config.Name):AddToggle(Config);
	end;

	function Window:AddButton(Config)
		Config = ModernV2:ProcessParams(Config , {
			Name = "Button",
			Icon = "chevron-large-left",
			Callback = EmptyFunction,
			ToolTip = nil,
		});

		return Window.UserSettings:AddButton(Config);
	end;

	function Window:SetAccount(Config)
		Config = ModernV2:ProcessParams(Config , {
			Profile = ModernV2.UserProfile,
			Username = LocalPlayer.DisplayName,
			Expires = "Never",
		});

		if not Window.ShowUser then
			AccountProfile.Image = "";
			AccountProfile.ImageTransparency = 0.050;
			AccountProfile.BackgroundColor3 = Color3.fromRGB(26, 28, 36);
			AccountProfile.BackgroundTransparency = 0.250;
			ModernV2:SetIconMode(AccountProfile, "gear");
			AccountProfile.ImageColor3 = ModernV2.AccentColor;
			AccountName.Text = "Settings";
			ExpireLabel.Text = "Customize menu";
			Window.Username = "Settings";
			Window.Profile = "";
			Window.Expires = "Customize menu";

			if Window.UserSettings.UserFrame then
				Window.UserSettings.UserFrame:SetUsername(Window.Username);
				Window.UserSettings.UserFrame:SetProfile(Window.Profile);
				Window.UserSettings.UserFrame:SetExpires(Window.Expires);
			else
				Window.UserSettings.UserFrame = UserSettings:AddUserFrame(Window.Username , Window.Profile , Window.Expires);
			end;

			return;
		end;

		AccountName.Text = Config.Username;
		AccountProfile.Image = Config.Profile;
		ExpireLabel.Text = Config.Expires;

		Window.Username = Config.Username or Window.Username;
		Window.Profile = Config.Profile or Window.Profile;
		Window.Expires = Config.Expires or Window.Expires;

		if Window.UserSettings.UserFrame then
			Window.UserSettings.UserFrame:SetUsername(Window.Username);
			Window.UserSettings.UserFrame:SetProfile(Window.Profile);
			Window.UserSettings.UserFrame:SetExpires(Window.Expires);
		else
			Window.UserSettings.UserFrame = UserSettings:AddUserFrame(Window.Username , Window.Profile , Window.Expires);
		end;
	end;

	function Window:SetSize(newsize)
		Window.Size = newsize;

		if Window.Signal:GetValue() then
			ModernV2.PlayAnimate(WindowFrame , VSlowTween , {
				Size = Window.Size
			})
		end
	end;

	function Window:SetConfigOverwrite(value)
		Window.ConfigOverwrite = value == true;
		return Window;
	end;

	function Window:SaveConfig(ConfigNameStr, Overwrite)
		if not Window.ConfigManager or not Window.ConfigManager.WriteConfig then
			return false;
		end;

		return Window.ConfigManager:WriteConfig(ConfigNameStr or Window.ConfigManager.SelectedConfig or "Default", Overwrite);
	end;

	function Window:LoadConfig(ConfigNameStr)
		if not Window.ConfigManager then
			return false;
		end;

		ConfigNameStr = tostring(ConfigNameStr or Window.ConfigManager.SelectedConfig or "Default");
		local path = Window.ConfigFolder..'/'..ConfigNameStr;

		if not isfile(path) then
			return false;
		end;

		Window.ConfigManager:LoadData(readfile(path));
		Window.ConfigManager.SelectedConfig = ConfigNameStr;
		ConfigName.Text = ConfigNameStr;

		return true;
	end;

	function Window:RewriteConfigAsJson()
		if not Window.ConfigManager or not Window.ConfigManager.RewriteSelectedAsJson then
			return false;
		end;

		return Window.ConfigManager:RewriteSelectedAsJson();
	end;

	function Window:OnDestroy(fn)
		if type(fn) == "function" then
			table.insert(Window.OnDestroyCallbacks, fn);
		end;

		return Window;
	end;

	function Window:SafeCallback(fn, Context, ...)
		return ModernV2:FireCallback(fn, Context, ...);
	end;

	function Window:InputDialog(Config)
		Config = ModernV2:ProcessParams(Config , {
			Title = "Input",
			Content = "",
			Name = "Value",
			Placeholder = "",
			Default = "",
			Inputs = nil,
			ConfirmText = "Confirm",
			CancelText = "Cancel",
			Callback = EmptyFunction,
		});

		local Inputs = Config.Inputs;

		if typeof(Inputs) ~= "table" then
			Inputs = {
				{
					Name = Config.Name,
					Placeholder = Config.Placeholder,
					Default = Config.Default,
					Numeric = Config.Numeric,
				},
			};
		end;

		local Dialog = {
			Closed = false,
			Values = {},
			Boxes = {},
		};

		local Overlay = Instance.new("Frame")
		local Panel = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Title = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")
		local InputHolder = Instance.new("Frame")
		local InputLayout = Instance.new("UIListLayout")
		local ButtonHolder = Instance.new("Frame")
		local ButtonLayout = Instance.new("UIListLayout")
		local Shadow = ModernV2:CreateShadow(Panel);

		local PanelHeight = 148 + (#Inputs * 42);

		Overlay.Name = ModernV2.RandomString();
		Overlay.Parent = WindowFrame
		Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Overlay.BackgroundTransparency = 1
		Overlay.BorderSizePixel = 0
		Overlay.Size = UDim2.fromScale(1, 1)
		Overlay.ZIndex = 190
		Overlay.Active = true

		Panel.Name = ModernV2.RandomString();
		Panel.Parent = Overlay
		Panel.AnchorPoint = Vector2.new(0.5, 0.5)
		Panel.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		Panel.BackgroundTransparency = 1
		Panel.BorderSizePixel = 0
		Panel.ClipsDescendants = true
		Panel.Position = UDim2.fromScale(0.5, 0.5)
		Panel.Size = UDim2.new(0, 345, 0, PanelHeight - 15)
		Panel.ZIndex = 191

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = Panel

		UIStroke.Transparency = 1
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Panel

		Title.Name = ModernV2.RandomString();
		Title.Parent = Panel
		Title.BackgroundTransparency = 1
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0, 18, 0, 15)
		Title.Size = UDim2.new(1, -36, 0, 20)
		Title.ZIndex = 192
		Title.Font = Enum.Font.GothamBold
		Title.Text = Config.Title
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 15
		Title.TextTransparency = 1
		Title.TextXAlignment = Enum.TextXAlignment.Left
		ModernV2:AddTextGradient(Title);

		Content.Name = ModernV2.RandomString();
		Content.Parent = Panel
		Content.BackgroundTransparency = 1
		Content.BorderSizePixel = 0
		Content.Position = UDim2.new(0, 18, 0, 43)
		Content.Size = UDim2.new(1, -36, 0, Config.Content == "" and 0 or 34)
		Content.ZIndex = 192
		Content.Font = Enum.Font.GothamMedium
		Content.Text = Config.Content
		Content.TextColor3 = Color3.fromRGB(255, 255, 255)
		Content.TextSize = 13
		Content.TextTransparency = 1
		Content.TextWrapped = true
		Content.TextXAlignment = Enum.TextXAlignment.Left
		Content.TextYAlignment = Enum.TextYAlignment.Top

		InputHolder.Name = ModernV2.RandomString();
		InputHolder.Parent = Panel
		InputHolder.BackgroundTransparency = 1
		InputHolder.BorderSizePixel = 0
		InputHolder.Position = UDim2.new(0, 18, 0, Config.Content == "" and 48 or 82)
		InputHolder.Size = UDim2.new(1, -36, 0, #Inputs * 42)
		InputHolder.ZIndex = 192

		InputLayout.Parent = InputHolder
		InputLayout.SortOrder = Enum.SortOrder.LayoutOrder
		InputLayout.Padding = UDim.new(0, 8)

		local function ReadValues()
			local Values = {};

			for Index,Box in ipairs(Dialog.Boxes) do
				local InputConfig = Inputs[Index] or {};
				local Key = InputConfig.Flag or InputConfig.Key or InputConfig.Name or tostring(Index);
				Values[Key] = Box.Text;
			end;

			Dialog.Values = Values;

			if #Dialog.Boxes == 1 then
				return Dialog.Boxes[1].Text, Values;
			end;

			return Values;
		end;

		for Index,InputConfig in ipairs(Inputs) do
			if typeof(InputConfig) ~= "table" then
				InputConfig = {
					Name = tostring(InputConfig or "Value"),
				};
				Inputs[Index] = InputConfig;
			end;

			InputConfig = ModernV2:ProcessParams(InputConfig , {
				Name = "Value",
				Placeholder = "",
				Default = "",
				Numeric = false,
			});

			local Row = Instance.new("Frame")
			local Label = Instance.new("TextLabel")
			local BoxFrame = Instance.new("Frame")
			local BoxCorner = Instance.new("UICorner")
			local BoxStroke = Instance.new("UIStroke")
			local Box = Instance.new("TextBox")

			Row.Name = ModernV2.RandomString();
			Row.Parent = InputHolder
			Row.BackgroundTransparency = 1
			Row.BorderSizePixel = 0
			Row.Size = UDim2.new(1, 0, 0, 34)
			Row.ZIndex = 192
			Row.LayoutOrder = Index

			Label.Name = ModernV2.RandomString();
			Label.Parent = Row
			Label.BackgroundTransparency = 1
			Label.BorderSizePixel = 0
			Label.Position = UDim2.new(0, 0, 0, 0)
			Label.Size = UDim2.new(0.42, -6, 1, 0)
			Label.ZIndex = 193
			Label.Font = Enum.Font.GothamMedium
			Label.Text = tostring(InputConfig.Name)
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 12
			Label.TextTransparency = 1
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.TextTruncate = Enum.TextTruncate.AtEnd

			BoxFrame.Name = ModernV2.RandomString();
			BoxFrame.Parent = Row
			BoxFrame.AnchorPoint = Vector2.new(1, 0.5)
			BoxFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 22)
			BoxFrame.BackgroundTransparency = 1
			BoxFrame.BorderSizePixel = 0
			BoxFrame.Position = UDim2.new(1, 0, 0.5, 0)
			BoxFrame.Size = UDim2.new(0.58, 0, 0, 30)
			BoxFrame.ZIndex = 193

			BoxCorner.CornerRadius = UDim.new(0, 5)
			BoxCorner.Parent = BoxFrame

			BoxStroke.Color = Color3.fromRGB(45, 48, 58)
			BoxStroke.Transparency = 1
			BoxStroke.Parent = BoxFrame

			Box.Name = ModernV2.RandomString();
			Box.Parent = BoxFrame
			Box.BackgroundTransparency = 1
			Box.BorderSizePixel = 0
			Box.ClearTextOnFocus = false
			Box.Position = UDim2.new(0, 8, 0, 0)
			Box.Size = UDim2.new(1, -16, 1, 0)
			Box.ZIndex = 194
			Box.Font = Enum.Font.GothamMedium
			Box.Text = tostring(InputConfig.Default or "")
			Box.PlaceholderText = tostring(InputConfig.Placeholder or "")
			Box.TextColor3 = Color3.fromRGB(255, 255, 255)
			Box.PlaceholderColor3 = Color3.fromRGB(140, 140, 155)
			Box.TextSize = 12
			Box.TextTransparency = 1
			Box.TextXAlignment = Enum.TextXAlignment.Left

			if InputConfig.Numeric then
				ModernV2:AddSignal(Box:GetPropertyChangedSignal("Text"):Connect(function()
					Box.Text = Box.Text:gsub("[^%d%.%-]", "");
				end))
			end;

			table.insert(Dialog.Boxes, Box);

			ModernV2.PlayAnimate(Label, SlowyTween, { TextTransparency = 0.250 })
			ModernV2.PlayAnimate(BoxFrame, SlowyTween, { BackgroundTransparency = 0.150 })
			ModernV2.PlayAnimate(BoxStroke, SlowyTween, { Transparency = 0.700 })
			ModernV2.PlayAnimate(Box, SlowyTween, { TextTransparency = 0.150 })
		end;

		ButtonHolder.Name = ModernV2.RandomString();
		ButtonHolder.Parent = Panel
		ButtonHolder.AnchorPoint = Vector2.new(1, 1)
		ButtonHolder.BackgroundTransparency = 1
		ButtonHolder.BorderSizePixel = 0
		ButtonHolder.Position = UDim2.new(1, -14, 1, -14)
		ButtonHolder.Size = UDim2.new(1, -28, 0, 30)
		ButtonHolder.ZIndex = 192

		ButtonLayout.Parent = ButtonHolder
		ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
		ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ButtonLayout.Padding = UDim.new(0, 8)

		function Dialog:Close(Result)
			if Dialog.Closed then
				return Result;
			end;

			Dialog.Closed = true;

			ModernV2.PlayAnimate(Overlay, SlowyTween, { BackgroundTransparency = 1 })
			ModernV2.PlayAnimate(Panel, SlowyTween, { BackgroundTransparency = 1 })
			ModernV2.PlayAnimate(UIStroke, SlowyTween, { Transparency = 1 })
			ModernV2.PlayAnimate(Title, SlowyTween, { TextTransparency = 1 })
			ModernV2.PlayAnimate(Content, SlowyTween, { TextTransparency = 1 })
			Shadow:Render(false);

			task.delay(0.18, function()
				if Overlay.Parent then
					Overlay:Destroy();
				end;
			end);

			ModernV2:FireCallback(Config.Callback, Config.Title, Result, Dialog.Values);

			return Result;
		end;

		local function AddDialogButton(Text, Primary, Callback)
			local Button = Instance.new("Frame")
			local ButtonCorner = Instance.new("UICorner")
			local ButtonStroke = Instance.new("UIStroke")
			local ButtonLabel = Instance.new("TextLabel")

			Button.Name = ModernV2.RandomString();
			Button.Parent = ButtonHolder
			Button.BackgroundColor3 = Primary and ModernV2.AccentColor or Color3.fromRGB(26, 28, 36)
			Button.BackgroundTransparency = 1
			Button.BorderSizePixel = 0
			Button.ClipsDescendants = true
			Button.Size = UDim2.new(0, math.max(78, TextService:GetTextSize(tostring(Text), 12, Enum.Font.GothamMedium, Vector2.new(math.huge, math.huge)).X + 28), 0, 28)
			Button.ZIndex = 193

			ButtonCorner.CornerRadius = UDim.new(0, 5)
			ButtonCorner.Parent = Button

			ButtonStroke.Transparency = 1
			ButtonStroke.Color = Primary and ModernV2.AccentColor or Color3.fromRGB(45, 48, 58)
			ButtonStroke.Parent = Button

			ButtonLabel.Name = ModernV2.RandomString();
			ButtonLabel.Parent = Button
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.BorderSizePixel = 0
			ButtonLabel.Size = UDim2.fromScale(1, 1)
			ButtonLabel.ZIndex = 194
			ButtonLabel.Font = Enum.Font.GothamMedium
			ButtonLabel.Text = Text
			ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ButtonLabel.TextSize = 12
			ButtonLabel.TextTransparency = 1

			local Input = ModernV2:CreateInput(Button, Callback);

			ModernV2:AddSignal(Input.MouseEnter:Connect(function()
				ModernV2.PlayAnimate(Button, SlowyTween, { BackgroundTransparency = Primary and 0 or 0.100 })
			end))

			ModernV2:AddSignal(Input.MouseLeave:Connect(function()
				ModernV2.PlayAnimate(Button, SlowyTween, { BackgroundTransparency = Primary and 0.100 or 0.250 })
			end))

			ModernV2.PlayAnimate(Button, SlowyTween, { BackgroundTransparency = Primary and 0.100 or 0.250 })
			ModernV2.PlayAnimate(ButtonStroke, SlowyTween, { Transparency = Primary and 1 or 0.650 })
			ModernV2.PlayAnimate(ButtonLabel, SlowyTween, { TextTransparency = 0 })
		end;

		AddDialogButton(Config.CancelText, false, function()
			Dialog:Close(nil);
		end);

		AddDialogButton(Config.ConfirmText, true, function()
			Dialog:Close(ReadValues());
		end);

		ModernV2.PlayAnimate(Overlay, SlowyTween, { BackgroundTransparency = 0.350 })
		ModernV2.PlayAnimate(Panel, VSlowTween, { BackgroundTransparency = 0.035, Size = UDim2.new(0, 360, 0, PanelHeight) })
		ModernV2.PlayAnimate(UIStroke, SlowyTween, { Transparency = 0.650 })
		ModernV2.PlayAnimate(Title, SlowyTween, { TextTransparency = 0 })
		ModernV2.PlayAnimate(Content, SlowyTween, { TextTransparency = 0.250 })
		Shadow:Render(true);

		task.defer(function()
			if Dialog.Boxes[1] then
				Dialog.Boxes[1]:CaptureFocus();
			end;
		end);

		function Dialog:GetValue()
			return ReadValues();
		end;

		function Dialog:SetValue(Value, Key)
			if Key == nil and Dialog.Boxes[1] then
				Dialog.Boxes[1].Text = tostring(Value or "");
				return Dialog;
			end;

			for Index,InputConfig in ipairs(Inputs) do
				local Name = InputConfig.Flag or InputConfig.Key or InputConfig.Name or tostring(Index);
				if tostring(Name) == tostring(Key) and Dialog.Boxes[Index] then
					Dialog.Boxes[Index].Text = tostring(Value or "");
				end;
			end;

			return Dialog;
		end;

		return CaseInsensitive(Dialog);
	end;

	function Window:Dialog(Config)
		Config = ModernV2:ProcessParams(Config , {
			Title = "Dialog",
			Content = "",
			Icon = "lucide:message-square",
			Buttons = {},
			Callback = EmptyFunction,
		});

		local Dialog = {
			Closed = false,
		};

		local Overlay = Instance.new("Frame")
		local Panel = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local AccentBar = Instance.new("Frame")
		local AccentCorner = Instance.new("UICorner")
		local IconHolder = Instance.new("Frame")
		local IconCorner = Instance.new("UICorner")
		local IconStroke = Instance.new("UIStroke")
		local DialogIcon = Instance.new("ImageLabel")
		local Title = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")
		local Divider = Instance.new("Frame")
		local ButtonHolder = Instance.new("Frame")
		local ButtonLayout = Instance.new("UIListLayout")
		local ContentHeight = math.clamp(TextService:GetTextSize(tostring(Config.Content or ""), 13, Enum.Font.GothamMedium, Vector2.new(310, math.huge)).Y + 4, 38, 76);
		local PanelHeight = math.max(188, 132 + ContentHeight);
		local PanelClosedSize = UDim2.new(0, 365, 0, PanelHeight - 18);
		local PanelOpenSize = UDim2.new(0, 392, 0, PanelHeight);

		Overlay.Name = ModernV2.RandomString();
		Overlay.Parent = WindowFrame
		Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Overlay.BackgroundTransparency = 1
		Overlay.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Overlay.BorderSizePixel = 0
		Overlay.Size = UDim2.fromScale(1, 1)
		Overlay.ZIndex = 180
		Overlay.Active = true

		Panel.Name = ModernV2.RandomString();
		Panel.Parent = Overlay
		Panel.AnchorPoint = Vector2.new(0.5, 0.5)
		Panel.BackgroundColor3 = Color3.fromRGB(13, 17, 22)
		Panel.BackgroundTransparency = 1
		Panel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Panel.BorderSizePixel = 0
		Panel.ClipsDescendants = true
		Panel.Position = UDim2.fromScale(0.5, 0.5)
		Panel.Size = PanelClosedSize
		Panel.ZIndex = 181

		UICorner.CornerRadius = UDim.new(0, 12)
		UICorner.Parent = Panel

		UIStroke.Transparency = 1
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Panel

		local Shadow = ModernV2:CreateShadow(Panel);

		AccentBar.Name = ModernV2.RandomString();
		AccentBar.Parent = Panel
		AccentBar.BackgroundColor3 = ModernV2.AccentColor
		AccentBar.BackgroundTransparency = 1
		AccentBar.BorderSizePixel = 0
		AccentBar.Position = UDim2.fromOffset(0, 0)
		AccentBar.Size = UDim2.new(1, 0, 0, 3)
		AccentBar.ZIndex = 182

		AccentCorner.CornerRadius = UDim.new(0, 12)
		AccentCorner.Parent = AccentBar

		IconHolder.Name = ModernV2.RandomString();
		IconHolder.Parent = Panel
		IconHolder.BackgroundColor3 = ModernV2.AccentColor
		IconHolder.BackgroundTransparency = 1
		IconHolder.BorderSizePixel = 0
		IconHolder.Position = UDim2.fromOffset(18, 18)
		IconHolder.Size = UDim2.fromOffset(34, 34)
		IconHolder.ZIndex = 182

		IconCorner.CornerRadius = UDim.new(0, 8)
		IconCorner.Parent = IconHolder

		IconStroke.Color = ModernV2.AccentColor
		IconStroke.Transparency = 1
		IconStroke.Parent = IconHolder

		DialogIcon.Name = ModernV2.RandomString();
		DialogIcon.Parent = IconHolder
		DialogIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		DialogIcon.BackgroundTransparency = 1
		DialogIcon.BorderSizePixel = 0
		DialogIcon.Position = UDim2.fromScale(0.5, 0.5)
		DialogIcon.Size = UDim2.fromOffset(18, 18)
		DialogIcon.ZIndex = 183
		DialogIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		DialogIcon.ImageTransparency = 1
		ModernV2:SetIconMode(DialogIcon, Config.Icon)

		Title.Name = ModernV2.RandomString();
		Title.Parent = Panel
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1
		Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0, 64, 0, 18)
		Title.Size = UDim2.new(1, -82, 0, 21)
		Title.ZIndex = 183
		Title.Font = Enum.Font.GothamBold
		Title.Text = Config.Title
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 16
		Title.TextTransparency = 1
		Title.TextXAlignment = Enum.TextXAlignment.Left
		ModernV2:AddTextGradient(Title);

		Content.Name = ModernV2.RandomString();
		Content.Parent = Panel
		Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Content.BackgroundTransparency = 1
		Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Content.BorderSizePixel = 0
		Content.Position = UDim2.new(0, 64, 0, 43)
		Content.Size = UDim2.new(1, -82, 0, ContentHeight)
		Content.ZIndex = 183
		Content.Font = Enum.Font.GothamMedium
		Content.Text = Config.Content
		Content.TextColor3 = Color3.fromRGB(255, 255, 255)
		Content.TextSize = 13
		Content.TextTransparency = 1
		Content.TextWrapped = true
		Content.TextXAlignment = Enum.TextXAlignment.Left
		Content.TextYAlignment = Enum.TextYAlignment.Top

		Divider.Name = ModernV2.RandomString();
		Divider.Parent = Panel
		Divider.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		Divider.BackgroundTransparency = 1
		Divider.BorderSizePixel = 0
		Divider.Position = UDim2.new(0, 14, 1, -54)
		Divider.Size = UDim2.new(1, -28, 0, 1)
		Divider.ZIndex = 182

		ButtonHolder.Name = ModernV2.RandomString();
		ButtonHolder.Parent = Panel
		ButtonHolder.AnchorPoint = Vector2.new(1, 1)
		ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ButtonHolder.BackgroundTransparency = 1
		ButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonHolder.BorderSizePixel = 0
		ButtonHolder.Position = UDim2.new(1, -16, 1, -14)
		ButtonHolder.Size = UDim2.new(1, -32, 0, 32)
		ButtonHolder.ZIndex = 182

		ButtonLayout.Parent = ButtonHolder
		ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
		ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ButtonLayout.Padding = UDim.new(0, 8)

		function Dialog:Close(Result)
			if Dialog.Closed then
				return Result;
			end;

			Dialog.Closed = true;

			ModernV2.PlayAnimate(Overlay,SlowyTween,{
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(Panel,SlowyTween,{
				BackgroundTransparency = 1,
				Size = PanelClosedSize
			})

			ModernV2.PlayAnimate(UIStroke,SlowyTween,{
				Transparency = 1
			})

			ModernV2.PlayAnimate(AccentBar,SlowyTween,{
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(IconHolder,SlowyTween,{
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(IconStroke,SlowyTween,{
				Transparency = 1
			})

			ModernV2.PlayAnimate(DialogIcon,SlowyTween,{
				ImageTransparency = 1
			})

			ModernV2.PlayAnimate(Title,SlowyTween,{
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(Content,SlowyTween,{
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(Divider,SlowyTween,{
				BackgroundTransparency = 1
			})

			Shadow:Render(false);

			task.delay(0.18,function()
				Overlay:Destroy();
			end);

			ModernV2:FireCallback(Config.Callback, Config.Title, Result);

			return Result;
		end;

		if #Config.Buttons <= 0 then
			Config.Buttons = {
				{
					Text = "OK",
					Primary = true,
				},
			};
		end;

		for Index,ButtonConfig in ipairs(Config.Buttons) do
			ButtonConfig = ModernV2:ProcessParams(ButtonConfig , {
				Text = "Button",
				Primary = false,
				Callback = EmptyFunction,
			});

			local Button = Instance.new("Frame")
			local ButtonCorner = Instance.new("UICorner")
			local ButtonStroke = Instance.new("UIStroke")
			local ButtonLabel = Instance.new("TextLabel")

			Button.Name = ModernV2.RandomString();
			Button.Parent = ButtonHolder
			Button.BackgroundColor3 = ButtonConfig.Primary and ModernV2.AccentColor or Color3.fromRGB(26, 28, 36)
			Button.BackgroundTransparency = 1
			Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Button.BorderSizePixel = 0
			Button.ClipsDescendants = true
			Button.Size = UDim2.new(0, math.max(78, TextService:GetTextSize(tostring(ButtonConfig.Text), 12, Enum.Font.GothamBold, Vector2.new(math.huge, math.huge)).X + 32), 0, 32)
			Button.ZIndex = 183
			Button.LayoutOrder = Index

			ButtonCorner.CornerRadius = UDim.new(0, 7)
			ButtonCorner.Parent = Button

			ButtonStroke.Transparency = 1
			ButtonStroke.Color = ButtonConfig.Primary and ModernV2.AccentColor or Color3.fromRGB(45, 48, 58)
			ButtonStroke.Parent = Button

			ButtonLabel.Name = ModernV2.RandomString();
			ButtonLabel.Parent = Button
			ButtonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ButtonLabel.BorderSizePixel = 0
			ButtonLabel.Size = UDim2.fromScale(1, 1)
			ButtonLabel.ZIndex = 184
			ButtonLabel.Font = ButtonConfig.Primary and Enum.Font.GothamBold or Enum.Font.GothamMedium
			ButtonLabel.Text = ButtonConfig.Text
			ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ButtonLabel.TextSize = 12
			ButtonLabel.TextTransparency = 1

			local Input = ModernV2:CreateInput(Button , LPH_NO_VIRTUALIZE(function()
				local Result = ButtonConfig.ReturnValue;

				if Result == nil then
					Result = ButtonConfig.Text;
				end;

				ModernV2:FireCallback(ButtonConfig.Callback, ButtonConfig.Text, Result);
				Dialog:Close(Result);
			end));

			ModernV2:AddSignal(Input.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
				ModernV2.PlayAnimate(Button,SlowyTween,{
					BackgroundTransparency = ButtonConfig.Primary and 0 or 0.080
				})
			end)))

			ModernV2:AddSignal(Input.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
				ModernV2.PlayAnimate(Button,SlowyTween,{
					BackgroundTransparency = ButtonConfig.Primary and 0.100 or 0.250
				})
			end)))

			ModernV2.PlayAnimate(Button,SlowyTween,{
				BackgroundTransparency = ButtonConfig.Primary and 0.100 or 0.250
			})

			ModernV2.PlayAnimate(ButtonStroke,SlowyTween,{
				Transparency = ButtonConfig.Primary and 1 or 0.650
			})

			ModernV2.PlayAnimate(ButtonLabel,SlowyTween,{
				TextTransparency = 0
			})
		end;

		ModernV2.PlayAnimate(Overlay,SlowyTween,{
			BackgroundTransparency = 0.280
		})

		ModernV2.PlayAnimate(Panel,VSlowTween,{
			BackgroundTransparency = 0.025,
			Size = PanelOpenSize
		})

		ModernV2.PlayAnimate(UIStroke,SlowyTween,{
			Transparency = 0.650
		})

		ModernV2.PlayAnimate(AccentBar,SlowyTween,{
			BackgroundTransparency = 0
		})

		ModernV2.PlayAnimate(IconHolder,SlowyTween,{
			BackgroundTransparency = 0.820
		})

		ModernV2.PlayAnimate(IconStroke,SlowyTween,{
			Transparency = 0.350
		})

		ModernV2.PlayAnimate(DialogIcon,SlowyTween,{
			ImageTransparency = 0
		})

		ModernV2.PlayAnimate(Title,SlowyTween,{
			TextTransparency = 0
		})

		ModernV2.PlayAnimate(Content,SlowyTween,{
			TextTransparency = 0.250
		})

		ModernV2.PlayAnimate(Divider,SlowyTween,{
			BackgroundTransparency = 0.720
		})

		Shadow:Render(true);

		return CaseInsensitive(Dialog);
	end;

	function Window:ProgressDialog(Config)
		Config = ModernV2:ProcessParams(Config , {
			Title = "Progress",
			Content = "",
			Value = 0,
			Max = 100,
			Type = "%",
			Cancelable = false,
			CancelText = "Cancel",
			AutoClose = false,
			Callback = EmptyFunction,
		});

		local Dialog = {
			Closed = false,
		};

		local Overlay = Instance.new("Frame")
		local Panel = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Title = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")
		local ValueLabel = Instance.new("TextLabel")
		local BarBack = Instance.new("Frame")
		local BarBackCorner = Instance.new("UICorner")
		local BarFill = Instance.new("Frame")
		local BarFillCorner = Instance.new("UICorner")
		local CancelButton = Instance.new("Frame")
		local CancelCorner = Instance.new("UICorner")
		local CancelStroke = Instance.new("UIStroke")
		local CancelLabel = Instance.new("TextLabel")

		Overlay.Name = ModernV2.RandomString();
		Overlay.Parent = WindowFrame
		Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Overlay.BackgroundTransparency = 1
		Overlay.BorderSizePixel = 0
		Overlay.Size = UDim2.fromScale(1, 1)
		Overlay.ZIndex = 180
		Overlay.Active = true

		Panel.Name = ModernV2.RandomString();
		Panel.Parent = Overlay
		Panel.AnchorPoint = Vector2.new(0.5, 0.5)
		Panel.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		Panel.BackgroundTransparency = 1
		Panel.BorderSizePixel = 0
		Panel.ClipsDescendants = true
		Panel.Position = UDim2.fromScale(0.5, 0.5)
		Panel.Size = UDim2.new(0, 335, 0, Config.Cancelable and 150 or 125)
		Panel.ZIndex = 181

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = Panel

		UIStroke.Transparency = 1
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Panel

		local Shadow = ModernV2:CreateShadow(Panel);

		Title.Name = ModernV2.RandomString();
		Title.Parent = Panel
		Title.BackgroundTransparency = 1
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0, 18, 0, 15)
		Title.Size = UDim2.new(1, -36, 0, 20)
		Title.ZIndex = 182
		Title.Font = Enum.Font.GothamBold
		Title.Text = tostring(Config.Title)
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 15
		Title.TextTransparency = 1
		Title.TextXAlignment = Enum.TextXAlignment.Left
		ModernV2:AddTextGradient(Title);

		Content.Name = ModernV2.RandomString();
		Content.Parent = Panel
		Content.BackgroundTransparency = 1
		Content.BorderSizePixel = 0
		Content.Position = UDim2.new(0, 18, 0, 43)
		Content.Size = UDim2.new(1, -36, 0, 32)
		Content.ZIndex = 182
		Content.Font = Enum.Font.GothamMedium
		Content.Text = tostring(Config.Content)
		Content.TextColor3 = Color3.fromRGB(255, 255, 255)
		Content.TextSize = 13
		Content.TextTransparency = 1
		Content.TextWrapped = true
		Content.TextXAlignment = Enum.TextXAlignment.Left
		Content.TextYAlignment = Enum.TextYAlignment.Top

		ValueLabel.Name = ModernV2.RandomString();
		ValueLabel.Parent = Panel
		ValueLabel.BackgroundTransparency = 1
		ValueLabel.BorderSizePixel = 0
		ValueLabel.Position = UDim2.new(1, -88, 0, 80)
		ValueLabel.Size = UDim2.new(0, 70, 0, 16)
		ValueLabel.ZIndex = 182
		ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.TextSize = 12
		ValueLabel.TextTransparency = 1
		ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

		BarBack.Name = ModernV2.RandomString();
		BarBack.Parent = Panel
		BarBack.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		BarBack.BackgroundTransparency = 1
		BarBack.BorderSizePixel = 0
		BarBack.Position = UDim2.new(0, 18, 0, 84)
		BarBack.Size = UDim2.new(1, -112, 0, 9)
		BarBack.ZIndex = 182

		BarBackCorner.CornerRadius = UDim.new(1, 0)
		BarBackCorner.Parent = BarBack

		BarFill.Name = ModernV2.RandomString();
		BarFill.Parent = BarBack
		BarFill.BackgroundColor3 = ModernV2.AccentColor
		BarFill.BackgroundTransparency = 1
		BarFill.BorderSizePixel = 0
		BarFill.Size = UDim2.fromScale(0, 1)
		BarFill.ZIndex = 183

		BarFillCorner.CornerRadius = UDim.new(1, 0)
		BarFillCorner.Parent = BarFill

		CancelButton.Name = ModernV2.RandomString();
		CancelButton.Parent = Panel
		CancelButton.AnchorPoint = Vector2.new(1, 1)
		CancelButton.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		CancelButton.BackgroundTransparency = 1
		CancelButton.BorderSizePixel = 0
		CancelButton.ClipsDescendants = true
		CancelButton.Position = UDim2.new(1, -14, 1, -14)
		CancelButton.Size = UDim2.new(0, 86, 0, 28)
		CancelButton.Visible = Config.Cancelable == true
		CancelButton.ZIndex = 182

		CancelCorner.CornerRadius = UDim.new(0, 5)
		CancelCorner.Parent = CancelButton

		CancelStroke.Transparency = 1
		CancelStroke.Color = Color3.fromRGB(45, 48, 58)
		CancelStroke.Parent = CancelButton

		CancelLabel.Name = ModernV2.RandomString();
		CancelLabel.Parent = CancelButton
		CancelLabel.BackgroundTransparency = 1
		CancelLabel.BorderSizePixel = 0
		CancelLabel.Size = UDim2.fromScale(1, 1)
		CancelLabel.ZIndex = 183
		CancelLabel.Font = Enum.Font.GothamMedium
		CancelLabel.Text = tostring(Config.CancelText)
		CancelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		CancelLabel.TextSize = 12
		CancelLabel.TextTransparency = 1

		local function UpdateProgress()
			local MaxValue = math.max(tonumber(Config.Max) or 1, 0.0001);
			local Value = math.clamp(tonumber(Config.Value) or 0, 0, MaxValue);
			local Percent = Value / MaxValue;

			if Config.Type == "%" then
				ValueLabel.Text = tostring(ModernV2.Rounding(Percent * 100, 0)).."%";
			else
				ValueLabel.Text = tostring(ModernV2.Rounding(Value, 2)).."/"..tostring(ModernV2.Rounding(MaxValue, 2))..tostring(Config.Type or "");
			end;

			ModernV2.PlayAnimate(BarFill, SlowyTween, {
				Size = UDim2.fromScale(Percent, 1),
				BackgroundColor3 = ModernV2.AccentColor
			});
		end;

		function Dialog:Close(Result)
			if Dialog.Closed then
				return Result;
			end;

			Dialog.Closed = true;

			ModernV2.PlayAnimate(Overlay,SlowyTween,{ BackgroundTransparency = 1 })
			ModernV2.PlayAnimate(Panel,SlowyTween,{
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 335, 0, Config.Cancelable and 150 or 125)
			})
			ModernV2.PlayAnimate(UIStroke,SlowyTween,{ Transparency = 1 })
			ModernV2.PlayAnimate(Title,SlowyTween,{ TextTransparency = 1 })
			ModernV2.PlayAnimate(Content,SlowyTween,{ TextTransparency = 1 })
			ModernV2.PlayAnimate(ValueLabel,SlowyTween,{ TextTransparency = 1 })
			ModernV2.PlayAnimate(BarBack,SlowyTween,{ BackgroundTransparency = 1 })
			ModernV2.PlayAnimate(BarFill,SlowyTween,{ BackgroundTransparency = 1 })
			ModernV2.PlayAnimate(CancelButton,SlowyTween,{ BackgroundTransparency = 1 })
			ModernV2.PlayAnimate(CancelStroke,SlowyTween,{ Transparency = 1 })
			ModernV2.PlayAnimate(CancelLabel,SlowyTween,{ TextTransparency = 1 })
			Shadow:Render(false);

			task.delay(0.18,function()
				Overlay:Destroy();
			end);

			ModernV2:FireCallback(Config.Callback, Config.Title, Result);
			return Result;
		end;

		function Dialog:SetValue(value)
			Config.Value = tonumber(value) or Config.Value;
			UpdateProgress();

			if Config.AutoClose == true and (tonumber(Config.Value) or 0) >= (tonumber(Config.Max) or 100) then
				Dialog:Close(true);
			end;

			return Dialog;
		end;

		function Dialog:SetMax(max)
			Config.Max = tonumber(max) or Config.Max;
			UpdateProgress();
			return Dialog;
		end;

		function Dialog:SetContent(text)
			Config.Content = tostring(text or "");
			Content.Text = Config.Content;
			return Dialog;
		end;

		function Dialog:SetTitle(text)
			Config.Title = tostring(text or "");
			Title.Text = Config.Title;
			return Dialog;
		end;

		function Dialog:SetType(text)
			Config.Type = tostring(text or "");
			UpdateProgress();
			return Dialog;
		end;

		function Dialog:GetValue()
			return Config.Value;
		end;

		if Config.Cancelable then
			local Input = ModernV2:CreateInput(CancelButton , LPH_NO_VIRTUALIZE(function()
				Dialog:Close(false);
			end));

			ModernV2:AddSignal(Input.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
				ModernV2.PlayAnimate(CancelButton,SlowyTween,{ BackgroundTransparency = 0.100 })
			end)))

			ModernV2:AddSignal(Input.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
				ModernV2.PlayAnimate(CancelButton,SlowyTween,{ BackgroundTransparency = 0.250 })
			end)))
		end;

		UpdateProgress();

		ModernV2.PlayAnimate(Overlay,SlowyTween,{ BackgroundTransparency = 0.350 })
		ModernV2.PlayAnimate(Panel,VSlowTween,{
			BackgroundTransparency = 0.035,
			Size = UDim2.new(0, 350, 0, Config.Cancelable and 165 or 140)
		})
		ModernV2.PlayAnimate(UIStroke,SlowyTween,{ Transparency = 0.650 })
		ModernV2.PlayAnimate(Title,SlowyTween,{ TextTransparency = 0 })
		ModernV2.PlayAnimate(Content,SlowyTween,{ TextTransparency = 0.250 })
		ModernV2.PlayAnimate(ValueLabel,SlowyTween,{ TextTransparency = 0.500 })
		ModernV2.PlayAnimate(BarBack,SlowyTween,{ BackgroundTransparency = 0 })
		ModernV2.PlayAnimate(BarFill,SlowyTween,{ BackgroundTransparency = 0 })

		if Config.Cancelable then
			ModernV2.PlayAnimate(CancelButton,SlowyTween,{ BackgroundTransparency = 0.250 })
			ModernV2.PlayAnimate(CancelStroke,SlowyTween,{ Transparency = 0.650 })
			ModernV2.PlayAnimate(CancelLabel,SlowyTween,{ TextTransparency = 0 })
		end;

		Shadow:Render(true);

		return CaseInsensitive(Dialog);
	end;

	Window:SetAccount();

	ModernV2:AddSignal(UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(value,ISTYPING)
		if value.KeyCode == Window.Keybind or value.KeyCode.Name == Window.Keybind then
			if not ISTYPING then
				Window:ToggleInterface()
			end
		end;
	end)));

	function Window:ToggleInterface()
		if Window.Destroyed then
			return;
		end;

		Window.Signal:SetValue(not Window.Signal:GetValue());

		if Window.__3DRender then
			Window.Load3DBlock();
		end;
	end;

	function Window:SetFont(FontConfig)
		Window.Font = FontConfig;
		return ModernV2:SetFont(FontConfig);
	end;

	function Window:Destroy()
		if Window.Destroyed then
			return;
		end;

		Window.Destroyed = true;
		Window.Signal:SetValue(false);

		for _,Callback in ipairs(Window.OnDestroyCallbacks) do
			ModernV2:FireCallback(Callback, "OnDestroy", Window);
		end;

		if ModernV2.ActiveWindow == Window then
			ModernV2.ActiveWindow = nil;
		end;

		task.delay(0.2,function()
			if Window._MenuIcon and Window._MenuIcon.Root then
				Window._MenuIcon.Root:Destroy();
			end;

			if Window.SurfaceGui then
				Window.SurfaceGui:Destroy();
			end;

			WindowFrame:Destroy();
		end);
	end;

	-- Register this window as the active window so bindables can fire it
	ModernV2.ActiveWindow = Window;

	function Window:Watermark(Config)
		if typeof(Config) == "table" then
			local WatermarkLib = ModernV2.__WatermarkCache or Window:Watermark();

			return WatermarkLib:AddBlock(Config.Icon or Config.IconName or "", Config.Name or Config.Title or "Watermark");
		end;

		if ModernV2.__WatermarkCache then
			return ModernV2.__WatermarkCache;
		end;

		local Watermark_lb = {};
		local Watermark = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local Shadow = ModernV2:CreateShadow(Watermark);

		Watermark.Name = ModernV2.RandomString();
		Watermark.Parent = ModernV2.ScreenGui
		Watermark.AnchorPoint = Vector2.new(1, 0)
		Watermark.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
		Watermark.BackgroundTransparency = 0.200
		Watermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Watermark.BorderSizePixel = 0
		Watermark.ClipsDescendants = true
		Watermark.Active = true   -- required: allows child ImageButtons to receive clicks
		Watermark.Position = UDim2.new(1, -10, 0, 10)
		Watermark.Size = UDim2.new(0, 120, 0, 30)
		Watermark.ZIndex = 16

		UICorner.CornerRadius = UDim.new(0, 25)
		UICorner.Parent = Watermark

		UIListLayout.Parent = Watermark
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

		local empty_space = Instance.new('Frame');

		empty_space.Size = UDim2.fromOffset(15,0);
		empty_space.BackgroundTransparency = 1;
		empty_space.Parent = Watermark;
		empty_space.LayoutOrder = 5;

		Watermark:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if Watermark.BackgroundTransparency > 0.9 then
				Watermark.Visible = false;
				Watermark.Parent = nil;
			else
				Watermark.Parent = ModernV2.ScreenGui
				Watermark.Visible = true;
			end;
		end));

		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			ModernV2.PlayAnimate(Watermark , SlowyTween , {
				Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 5, 0, 30)
			})
		end));

		ModernV2.__WatermarkCache = Watermark_lb;

		Shadow:Render(true);

		Watermark_lb.Renders = {};
		Watermark_lb.Status = true;

		function Watermark_lb:SetRender(value)
			Watermark_lb.Status = value;

			if value then
				ModernV2.PlayAnimate(Watermark,SlowyTween , {
					BackgroundTransparency = 0.200
				})

				Shadow:Render(true);

				for i,v in next , Watermark_lb.Renders do
					pcall(v,true);
				end;
			else
				ModernV2.PlayAnimate(Watermark,SlowyTween , {
					BackgroundTransparency = 1
				})

				Shadow:Render(false);

				for i,v in next , Watermark_lb.Renders do
					pcall(v,false);
				end;
			end
		end;

		function Watermark_lb:AddBlock(IconStr , Name)
			local InnerBlock = {};

			local Frame = Instance.new("Frame")
			local Content = Instance.new("TextLabel")
			local Icon = Instance.new("ImageLabel")

			Frame.Parent = Watermark
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Active = true   -- required: allows child ImageButton to receive clicks
			Frame.Size = UDim2.new(0, 50, 0, 30)
			Frame.ZIndex = 17  -- must be >= Content/Icon ZIndex so CreateInput button (ZIndex+10=27) sits on top

			Content.Name = ModernV2.RandomString();
			Content.Parent = Frame
			Content.AnchorPoint = Vector2.new(0, 0.5)
			Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
			Content.BackgroundTransparency = 1.000
			Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Content.BorderSizePixel = 0
			Content.Position = UDim2.new(0, 35, 0.5, 0)
			Content.Size = UDim2.new(0, 1, 0, 25)
			Content.ZIndex = 17
			Content.Font = Enum.Font.GothamBold
			Content.Text = Name
			Content.TextColor3 = Color3.fromRGB(186, 186, 186)
			Content.TextSize = 15.000
			Content.TextTransparency = 0.200
			Content.TextXAlignment = Enum.TextXAlignment.Left
			ModernV2:AddTextGradient(Content);

			Icon.Name = ModernV2.RandomString();
			Icon.Parent = Frame
			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 10, 0.5, 0)
			Icon.Size = UDim2.new(0, 20, 0, 20)
			Icon.ZIndex = 17
			ModernV2:SetIconMode(Icon, IconStr)
			Icon.ImageColor3 = ModernV2.AccentColor
			Icon.ImageTransparency = 0.250
			Icon.ScaleType = Enum.ScaleType.Fit

			InnerBlock.Update = LPH_NO_VIRTUALIZE(function(value)
				local size = TextService:GetTextSize(Content.Text , Content.TextSize,Content.Font,Vector2.new(math.huge,math.huge))

				if InnerBlock.Visible then
					ModernV2.PlayAnimate(Frame,VSlowTween,{
						Size = UDim2.new(0, size.X + 35, 0, 30)
					})
				else
					ModernV2.PlayAnimate(Frame,VSlowTween,{
						Size = UDim2.new(0, 0, 0, 30)
					})
				end;
			end);

			InnerBlock.Visible = true;

			InnerBlock.Update();

			function InnerBlock:SetVisible(v)
				InnerBlock.Visible = v;

				if Watermark_lb.Status then
					InnerBlock.SetRender(v);
				end;

				InnerBlock.Update();
			end;

			InnerBlock.SetRender = LPH_NO_VIRTUALIZE(function(value)
				if value and InnerBlock.Visible then
					ModernV2.PlayAnimate(Content,SlowyTween , {
						TextTransparency = 0.200
					})

					ModernV2.PlayAnimate(Icon,SlowyTween , {
						TextTransparency = 0.250
					})
				else

					ModernV2.PlayAnimate(Content,SlowyTween , {
						TextTransparency = 1
					})

					ModernV2.PlayAnimate(Icon,SlowyTween , {
						TextTransparency = 1
					})
				end;
			end);

			table.insert(Watermark_lb.Renders,InnerBlock.SetRender);

			function InnerBlock:SetText(t)
				Content.Text = t;

				InnerBlock.Update();
			end;

			function InnerBlock:Input(func)
				-- If caller passes a function, use it.
				-- If nil, default to firing the real-time keybind toggle.
				local handler = func or function()
					ModernV2:FireKeybind();
				end;

				local btn, signal = ModernV2:CreateInput(Frame, handler);
				btn.Active = true;
				btn.ZIndex = Frame.ZIndex + 10;
				return signal;
			end;

			return CaseInsensitive(InnerBlock);
		end;

		return CaseInsensitive(Watermark_lb);
	end;

	Window:SetRender(false);

	-- ── Icon Settings (built-in UserSettings section) ─────────────
	-- Called automatically if a MenuIcon was created before this window.
	-- Adds: Icon Size slider, Draggable toggle, Icon Colour picker.
	function Window:_RegisterMenuIconSettings(MenuIcon)
		if not MenuIcon then return; end;

		Window.UserSettings:AddLabel('Icon Size'):AddSlider({
			Min      = 32,
			Max      = 96,
			Default  = MenuIcon._size,
			Rounding = 0,
			Type     = "px",
			Size     = 100,
			Callback = function(v)
				MenuIcon:SetSize(v);
			end,
		});

		Window.UserSettings:AddLabel('Icon Draggable'):AddToggle({
			Default  = MenuIcon._draggable,
			Callback = function(v)
				MenuIcon:SetDraggable(v);
			end,
		});
	end;

	-- Patch ToggleInterface to pulse the MenuIcon if one is registered
	local _orig_Toggle = Window.ToggleInterface;
	function Window:ToggleInterface()
		if Window.Destroyed then
			return;
		end;

		_orig_Toggle(self);
		if Window._MenuIcon then
			Window._MenuIcon:OnWindowToggle(Window.Signal:GetValue());
		end;
	end;

	-- Convenience: attach a MenuIcon to this window
	function Window:AttachMenuIcon(MenuIcon)
		Window._MenuIcon = MenuIcon;
		Window:_RegisterMenuIconSettings(MenuIcon);
	end;

	function Window:Notify(Config)
		return ModernV2.Notifier.new(Config);
	end;

	Window.Indicators = LPH_NO_VIRTUALIZE(function(Config)
		local Indicator = ModernV2.Indicators.new(Config);
		Indicator:SetRender(true);
		return Indicator;
	end);

	function Window:Indicator(Config)
		return Window.Indicators(Config);
	end;

	return CaseInsensitive(Window);
end;

function ModernV2:CreateNotification()
	if ModernV2.__Notification_Cache then
		return ModernV2.__Notification_Cache;
	end;

	local Notifier = {};
	local Notification = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notification.Name = ModernV2.RandomString();
	Notification.Parent = ModernV2.ScreenGui;
	Notification.AnchorPoint = Vector2.new(1, 0)
	Notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Notification.BackgroundTransparency = 1.000
	Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(1, -25, 0, 25)
	Notification.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Notification
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 0)

	ModernV2.__Notification_Cache = Notifier;

	function Notifier.new(Config)
		Config = Config or {};
		local CustomIcon = Config.Icon;

		Config = ModernV2:ProcessParams(Config , {
			Title = "Notification",
			Content = "Hello World!",
			Logo = ModernV2.GlobalLogo or "rbxasset://textures/ui/VerifiedBadgeNameIcon.png",
			Icon = CustomIcon,
			Duration = 5,
		});

		local IconSource = Config.Icon or Config.Logo;
		local IconId = ModernV2:GetIconId(IconSource);
		local IsImageIcon = IconId ~= "";

		if ModernV2.__WatermarkCache then
			ModernV2.PlayAnimate(Notification,SlowyTween , {
				Position = UDim2.new(1, -25, 0, 55)
			});
		end;

		local ContainerFrame = Instance.new("Frame")
		local NotifyFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogoImage = Instance.new("ImageLabel")
		local LogoIcon = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local NotifyName = Instance.new("TextLabel")
		local NotifyContent = Instance.new("TextLabel");
		local shadow = ModernV2:CreateShadow(NotifyFrame , true);

		ContainerFrame.Name = ModernV2.RandomString();
		ContainerFrame.Parent = Notification
		ContainerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ContainerFrame.BackgroundTransparency = 1.000
		ContainerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ContainerFrame.BorderSizePixel = 0
		ContainerFrame.Size = UDim2.new(0, 0, 0, 100)

		NotifyFrame.Name = ModernV2.RandomString();
		NotifyFrame.Parent = ContainerFrame
		NotifyFrame.AnchorPoint = Vector2.new(1, 0)
		NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		NotifyFrame.BackgroundTransparency = 0.075
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.ClipsDescendants = true
		NotifyFrame.Position = UDim2.new(0, 750, 0, 0)
		NotifyFrame.Size = UDim2.new(0, 220, 0, 55)
		NotifyFrame.ZIndex = 130

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = NotifyFrame

		-- Make the notification bubble border thicker and clearly visible.
		UIStroke.Thickness = 3.000
		UIStroke.Transparency = 0.100
		UIStroke.Color = ModernV2.AccentColor
		UIStroke.Parent = NotifyFrame

		LogoImage.Name = ModernV2.RandomString();
		LogoImage.Parent = NotifyFrame
		LogoImage.AnchorPoint = Vector2.new(0, 0.5)
		LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogoImage.BackgroundTransparency = 1.000
		LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogoImage.BorderSizePixel = 0
		LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
		LogoImage.Size = UDim2.new(0, 35, 0, 35)
		LogoImage.ZIndex = 131
		LogoImage.Image = IsImageIcon and IconId or ""
		LogoImage.ImageColor3 = ModernV2.IconColor;
		LogoImage.ImageTransparency = IsImageIcon and 0 or 1

		UICorner_2.CornerRadius = UDim.new(0, 7)
		UICorner_2.Parent = LogoImage

		LogoIcon.Name = ModernV2.RandomString();
		LogoIcon.Parent = NotifyFrame
		LogoIcon.AnchorPoint = Vector2.new(0, 0.5)
		LogoIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogoIcon.BackgroundTransparency = 1.000
		LogoIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogoIcon.BorderSizePixel = 0
		LogoIcon.Position = UDim2.new(0, 10, 0.5, 0)
		LogoIcon.Size = UDim2.new(0, 35, 0, 35)
		LogoIcon.ZIndex = 131
		ModernV2:SetIconMode(LogoIcon, IsImageIcon and "" or tostring(IconSource or "bell"))
		LogoIcon.ImageColor3 = ModernV2.IconColor
		LogoIcon.ImageTransparency = IsImageIcon and 1 or 0.150
		LogoIcon.ScaleType = Enum.ScaleType.Fit

		NotifyName.Name = ModernV2.RandomString();
		NotifyName.Parent = NotifyFrame
		NotifyName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyName.BackgroundTransparency = 1.000
		NotifyName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyName.BorderSizePixel = 0
		NotifyName.Position = UDim2.new(0, 50, 0, 7)
		NotifyName.Size = UDim2.new(0, 200, 0, 20)
		NotifyName.ZIndex = 132
		NotifyName.Font = Enum.Font.GothamBold
		NotifyName.Text = Config.Title
		NotifyName.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyName.TextSize = 17.000
		NotifyName.TextXAlignment = Enum.TextXAlignment.Left

		NotifyContent.Name = ModernV2.RandomString();
		NotifyContent.Parent = NotifyFrame
		NotifyContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.BackgroundTransparency = 1.000
		NotifyContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyContent.BorderSizePixel = 0
		NotifyContent.Position = UDim2.new(0, 50, 0, 28)
		NotifyContent.Size = UDim2.new(0, 200, 0, 15)
		NotifyContent.ZIndex = 132
		NotifyContent.Font = Enum.Font.GothamBold
		NotifyContent.Text = Config.Content
		NotifyContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.TextSize = 12.000
		NotifyContent.TextTransparency = 0.650
		NotifyContent.TextXAlignment = Enum.TextXAlignment.Left

		local Size1 = TextService:GetTextSize(NotifyName.Text,NotifyName.TextSize,NotifyName.Font,Vector2.new(math.huge,math.huge));
		local Size2 = TextService:GetTextSize(NotifyContent.Text,NotifyContent.TextSize,NotifyContent.Font,Vector2.new(math.huge,math.huge));

		local MainSize = math.max(Size1.X , Size2.X);

		NotifyFrame.Size = UDim2.new(0, MainSize + 65, 0, 55);

		shadow:Render(true)
		ModernV2.PlayAnimate(NotifyFrame , VSlowTween , {
			Position = UDim2.new(1, 0, 0, 0)
		})

		ContainerFrame.Size = UDim2.new(0, 0, 0, 65)

		task.delay(Config.Duration or 5 , LPH_NO_VIRTUALIZE(function()

			if ModernV2.__WatermarkCache then
				ModernV2.PlayAnimate(Notification,SlowyTween , {
					Position = UDim2.new(1, -25, 0, 55)
				});
			end;

			shadow:Render(false)

			ModernV2.PlayAnimate(NotifyFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			ModernV2.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			ModernV2.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 1
			})

			ModernV2.PlayAnimate(LogoIcon , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(NotifyName , SlowyTween , {
				TextTransparency = 1
			})

			ModernV2.PlayAnimate(NotifyContent , SlowyTween , {
				TextTransparency = 1
			})

			task.wait(0.125);

			ModernV2.PlayAnimate(ContainerFrame , SlowyTween , {
				Size = UDim2.new(0, 0, 0, 0)
			})

			task.wait(0.125);

			ContainerFrame:Destroy();
		end))
	end;

	return Notifier;
end;

function ModernV2:CreateLogger()
	if ModernV2.__LogSystem then
		return 	ModernV2.__LogSystem;
	end;

	local Logging = {};
	local Log = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Log.Name = ModernV2.RandomString();
	Log.Parent = ModernV2.ScreenGui
	Log.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Log.BackgroundTransparency = 1.000
	Log.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Log.BorderSizePixel = 0
	Log.Position = UDim2.new(0, 25, 0, 5 + math.abs(ModernV2.ScreenGui.AbsolutePosition.Y))
	Log.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Log
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 12)

	ModernV2.__LogSystem = Logging;

	function Logging.new(IconStr: string , Message: string , Duration: number)
		Duration = Duration or 3;
		Message = Message or "Log";
		IconStr = IconStr or "crosshairs";

		local LogFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogContent = Instance.new("TextLabel")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local Icon = Instance.new("ImageLabel")
		local Shadow = ModernV2:CreateShadow(LogFrame , true);

		LogFrame.Name = ModernV2.RandomString();
		LogFrame.Parent = Log
		LogFrame.AnchorPoint = Vector2.new(0.5, 0)
		LogFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		LogFrame.BackgroundTransparency =  1--0.075
		LogFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogFrame.BorderSizePixel = 0
		LogFrame.ClipsDescendants = true
		LogFrame.Position = UDim2.new(0,0,0,0)
		LogFrame.Size = UDim2.new(0, 0, 0, 20)
		LogFrame.ZIndex = 130

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = LogFrame

		UIStroke.Transparency = 1--0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = LogFrame

		LogContent.Name = ModernV2.RandomString();
		LogContent.Parent = LogFrame
		LogContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogContent.BackgroundTransparency = 1.000
		LogContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogContent.BorderSizePixel = 0
		LogContent.Position = UDim2.new(0, 25, 0, 2)
		LogContent.Size = UDim2.new(0, 200, 0, 15)
		LogContent.ZIndex = 132
		LogContent.Font = Enum.Font.GothamBold
		LogContent.Text = Message
		LogContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		LogContent.TextSize = 12.000
		LogContent.TextTransparency = 1--0.250
		LogContent.TextXAlignment = Enum.TextXAlignment.Left

		Line.Name = ModernV2.RandomString();
		Line.Parent = LogFrame
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = ModernV2.AccentColor
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BackgroundTransparency = 1 --0
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, -2, 0.5, 0)
		Line.Size = UDim2.new(0, 5, 1, 0)
		Line.ZIndex = 131

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = Line

		Icon.Name = ModernV2.RandomString();
		Icon.Parent = LogFrame
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 7, 0, 3)
		Icon.Size = UDim2.new(0, 15, 0, 15)
		Icon.ZIndex = 133
		ModernV2:SetIconMode(Icon, IconStr)
		Icon.ImageColor3 = Color3.fromRGB(223, 223, 223)
		Icon.ImageTransparency = 1--0.250
		Icon.ScaleType = Enum.ScaleType.Fit

		local size = TextService:GetTextSize(LogContent.Text,LogContent.TextSize,LogContent.Font,Vector2.new(math.huge,math.huge));

		ModernV2.PlayAnimate(LogFrame , SlowyTween , {
			Size = UDim2.new(0, size.X + 35, 0, 20),
			BackgroundTransparency =  0.075
		});

		task.delay(0.15,LPH_NO_VIRTUALIZE(function()
			Shadow:Render(true);

			ModernV2.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			});

			ModernV2.PlayAnimate(LogContent , SlowyTween , {
				TextTransparency = 0.25
			});

			ModernV2.PlayAnimate(Line , SlowyTween , {
				BackgroundTransparency = 0
			});

			ModernV2.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.25
			});

			task.wait(Duration + 0.1);

			Shadow:Render(false);

			ModernV2.PlayAnimate(LogFrame , SlowyTween , {
				BackgroundTransparency =  1
			});

			ModernV2.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			});

			ModernV2.PlayAnimate(LogContent , SlowyTween , {
				TextTransparency = 1
			});

			ModernV2.PlayAnimate(Line , SlowyTween , {
				BackgroundTransparency = 1
			});

			ModernV2.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 1
			});

			task.wait(0.25);

			LogFrame:Destroy();
		end))
	end;

	return CaseInsensitive(Logging)
end;

function ModernV2:CreateIndicator()
	local IndicatorFrame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	IndicatorFrame.Name = ModernV2.RandomString();
	IndicatorFrame.Parent = ModernV2.ScreenGui;
	IndicatorFrame.AnchorPoint = Vector2.new(0, 0.5)
	IndicatorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	IndicatorFrame.BackgroundTransparency = 1.000
	IndicatorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	IndicatorFrame.BorderSizePixel = 0
	IndicatorFrame.Position = UDim2.new(0, 15, 0.5, 0)
	IndicatorFrame.Size = UDim2.new(0, 100, 0, 100)
	IndicatorFrame.ZIndex = 15

	UIListLayout.Parent = IndicatorFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 10)

	local Indicators = {};

	Indicators.Color = {
		Red = Color3.fromRGB(255, 102, 105),
		Green = Color3.fromRGB(135, 255, 143),
		White = Color3.fromRGB(186, 186, 186),
	};

	Indicators.Root = IndicatorFrame;

	function Indicators.new(Config)
		Config = ModernV2:ProcessParams(Config , {
			Name = "Indicator",
			Icon = 'crosshairs',
			Color = 'Red',
		});

		local Indicator = {
			CurrentColor = Config.Color,	
			Visible = false,
		};

		local IndicatorItem = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIGradient = Instance.new("UIGradient")
		local Icon = Instance.new("ImageLabel")
		local Content = Instance.new("TextLabel")
		local Shadow = ModernV2:CreateShadow(IndicatorItem);

		IndicatorItem.Name = ModernV2.RandomString();
		IndicatorItem.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
		IndicatorItem.BackgroundTransparency = 1
		IndicatorItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
		IndicatorItem.BorderSizePixel = 0
		IndicatorItem.ClipsDescendants = true
		IndicatorItem.Size = UDim2.new(0, 85, 0, 40)
		IndicatorItem.ZIndex = 16
		IndicatorItem.Visible = false;

		IndicatorItem:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if IndicatorItem.BackgroundTransparency > 0.9 then
				IndicatorItem.Parent = nil;
				IndicatorItem.Visible = false;
			else
				IndicatorItem.Parent = IndicatorFrame;
				IndicatorItem.Visible = true;
			end;
		end))

		UICorner.CornerRadius = UDim.new(0, 25)
		UICorner.Parent = IndicatorItem

		Line.Name = ModernV2.RandomString();
		Line.Parent = IndicatorItem
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 2, 0.5, 0)
		Line.BackgroundTransparency = 1;
		Line.Size = UDim2.new(0, 3, 0.649999976, 0)
		Line.ZIndex = 17

		UICorner_2.CornerRadius = UDim.new(0, 25)
		UICorner_2.Parent = Line

		UIGradient.Rotation = 90
		UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
		UIGradient.Parent = Line

		Icon.Name = ModernV2.RandomString();
		Icon.Parent = IndicatorItem
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 10, 0.5, 0)
		Icon.Size = UDim2.new(0, 25, 0, 25)
		Icon.ZIndex = 17
		ModernV2:SetIconMode(Icon, Config.Icon)
		Icon.ImageColor3 = Color3.fromRGB(186, 186, 186)
		Icon.ImageTransparency = 1
		Icon.ScaleType = Enum.ScaleType.Fit

		Content.Name = ModernV2.RandomString();
		Content.Parent = IndicatorItem
		Content.AnchorPoint = Vector2.new(0, 0.5)
		Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Content.BackgroundTransparency = 1.000
		Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Content.BorderSizePixel = 0
		Content.Position = UDim2.new(0, 40, 0.5, 0)
		Content.Size = UDim2.new(1, -40, 0, 25)
		Content.ZIndex = 17
		Content.Font = Enum.Font.GothamBold
		Content.Text = Config.Name
		Content.TextColor3 = Color3.fromRGB(186, 186, 186)
		Content.TextSize = 20.000
		Content.TextTransparency = 1
		Content.TextXAlignment = Enum.TextXAlignment.Left

		Indicator.Update = LPH_NO_VIRTUALIZE(function()
			local text = TextService:GetTextSize(Content.Text,Content.TextSize , Content.Font , Vector2.new(math.huge,math.huge));

			ModernV2.PlayAnimate(IndicatorItem , SlowyTween , {
				Size = UDim2.new(0, text.X + 60, 0, 40);
			})
		end);

		Indicator.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
			Indicator.Visible = value;

			if value then
				ModernV2.PlayAnimate(IndicatorItem , SlowyTween , {
					BackgroundTransparency = 0.200
				});

				ModernV2.PlayAnimate(Line , SlowyTween , {
					BackgroundTransparency = 0,
					BackgroundColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				ModernV2.PlayAnimate(Icon , VSlowTween , {
					TextTransparency = 0.250,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				ModernV2.PlayAnimate(Content , VSlowTween , {
					TextTransparency = 0.2,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				Shadow:Render(true);
			else
				ModernV2.PlayAnimate(IndicatorItem , SlowyTween , {
					BackgroundTransparency = 1
				});

				ModernV2.PlayAnimate(Line , SlowyTween , {
					BackgroundTransparency = 1,
					BackgroundColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				ModernV2.PlayAnimate(Icon , VSlowTween , {
					TextTransparency = 1,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				ModernV2.PlayAnimate(Content , VSlowTween , {
					TextTransparency = 1,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				Shadow:Render(false);
			end;

			Indicator.Update();
		end);

		Indicator.Update();
		Indicator:SetRender(false);

		function Indicator:SetColor(new_color)
			Indicator.CurrentColor = new_color;

			if Indicator.Visible then
				Indicator:SetRender(true);
			end;
		end;

		function Indicator:SetText(name)
			Config.Name = name;

			Content.Text = Config.Name;

			Indicator.Update();
		end;

		return CaseInsensitive(Indicator);
	end;

	return CaseInsensitive(Indicators);
end;

ModernV2.Logging = ModernV2:CreateLogger();
ModernV2.Notifier = ModernV2:CreateNotification();
ModernV2.Indicators = ModernV2:CreateIndicator();

function ModernV2:Unload()
	if not ModernV2.UnloadEnabled then
		return;	
	end;

	ModernV2.ScreenGui:Destroy();

	for i,v in next , ModernV2.GlobalSignals do
		pcall(v.Disconnect,v)
	end;
end;

function ModernV2:Window(Config)
	return ModernV2:CreateWindow(Config);
end;

local ModernV2API = CaseInsensitive(ModernV2);

-- This file is also intended to be executable on its own. Set
-- getgenv().MODERNV2_AUTO_WINDOW = false before loading when the caller
-- only wants the library object and will create its own window.
local __AutoWindowEnabled = getgenv().MODERNV2_AUTO_WINDOW ~= false;
if __AutoWindowEnabled then
	task.spawn(function()
		local __ok, __result = pcall(function()
			local __window = ModernV2API:CreateWindow({
				Name = "A2",
				Content = "A2",
				Logo = "rbxassetid://126710436488213",
				ConfigEnabled = false,
				Search = true,
				Loadingscreen = false,
				TextGradient = true,
			});

			local __DiscordLink = "https://discord.gg/pbg6g79Hp";

			local __infoTab = __window:AddTab({
				Name = "Info",
				Icon = "circle-i",
				Type = "Single",
			});

			local __infoSection = __infoTab:AddSection({
				Name = "A2 Information",
				Position = "Center",
				Box = true,
			});

			__infoSection:AddImage({
				Name = "A2 Banner",
				Image = "117118608066997",
				Height = 150,
				ScaleType = Enum.ScaleType.Fit,
			});

			__infoSection:AddParagraph({
				Name = "Discord",
				Content = "Join Discord A2:\n" .. __DiscordLink,
			});

			__infoSection:AddButton({
				Name = "Copy Discord Link",
				Icon = "discord",
				Callback = function()
					local __Writer = setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard);
					if __Writer then
						pcall(function()
							__Writer(__DiscordLink);
						end);
					end;
				end,
			});

			local function __addMenuTab(__name, __icon)
				local __tab = __window:AddTab({
					Name = __name,
					Icon = __icon,
					Type = "Single",
				});

				local __section = __tab:AddSection({
					Name = __name,
					Position = "Center",
					Box = true,
				});

				__section:AddParagraph({
					Name = __name .. " Menu",
					Content = __name .. " menu siap digunakan.",
				});

				return __tab;
			end;

			__addMenuTab("Main", "house");
			__addMenuTab("Aim Bot", "crosshairs");
			__addMenuTab("Visual", "eye");
			__addMenuTab("Kiler", "sword");
			__addMenuTab("Teleport", "pin");
			__addMenuTab("Player", "person");
			__addMenuTab("Setingan", "gear");

			local __menuIcon = ModernV2API:CreateMenuIcon({
				Image = "126710436488213",
				Size = 48,
				IconScale = 0.76,
				StrokeColor = Color3.fromRGB(78, 127, 252),
				StrokeThick = 3.5,
				Draggable = true,
			});
			__window:AttachMenuIcon(__menuIcon);

			ModernV2API.Window = __window;
			ModernV2API.MenuIcon = __menuIcon;

			return __window;
		end);

		if not __ok then
			warn("[ModernV2] Auto window failed: " .. tostring(__result));
		end;
	end);
end;

return ModernV2API;
end)()


local LocalizationService = game:GetService("LocalizationService")
local StarterGui = game:GetService("StarterGui")

local locale = LocalizationService.RobloxLocaleId
local language = string.lower(string.sub(locale, 1, 2))

local messages = {
    id = "Server telah beroperasi cukup lama. Harap berhati-hati dan bersiap jika server perlu melakukan restart di kemudian waktu.",
    
    en = "This server has been running for a long time. Please be aware that it may restart later.",
    
    es = "Este servidor lleva mucho tiempo funcionando. Ten en cuenta que podría reiniciarse más adelante.",
    
    pt = "Este servidor está em funcionamento há bastante tempo. Esteja ciente de que ele poderá reiniciar mais tarde.",
    
    fr = "Ce serveur fonctionne depuis longtemps. Veuillez noter qu'il pourrait redémarrer plus tard.",
    
    de = "Dieser Server läuft bereits seit längerer Zeit. Bitte beachten Sie, dass er später neu gestartet werden könnte.",
    
    it = "Questo server è attivo da molto tempo. Tieni presente che potrebbe essere riavviato più tardi.",
    
    tr = "Bu sunucu uzun süredir çalışıyor. Daha sonra yeniden başlatılabileceğini lütfen unutmayın.",
    
    ru = "Этот сервер работает уже долгое время. Обратите внимание, что позже он может быть перезапущен.",
    
    uk = "Цей сервер працює вже тривалий час. Зверніть увагу, що пізніше його може бути перезапущено.",
    
    pl = "Ten serwer działa już od dłuższego czasu. Pamiętaj, że później może zostać zrestartowany.",
    
    nl = "Deze server draait al lange tijd. Houd er rekening mee dat de server later mogelijk opnieuw wordt gestart.",
    
    vi = "Máy chủ này đã hoạt động trong một thời gian dài. Xin lưu ý rằng máy chủ có thể khởi động lại sau đó.",
    
    th = "เซิร์ฟเวอร์นี้ทำงานมาเป็นเวลานาน โปรดทราบว่าเซิร์ฟเวอร์อาจรีสตาร์ทในภายหลัง",
    
    ko = "이 서버는 오랫동안 실행되고 있습니다. 나중에 서버가 재시작될 수 있으니 참고해주세요.",
    
    ja = "このサーバーは長時間稼働しています。後ほどサーバーが再起動する可能性がありますのでご注意ください。",
    
    zh = "此服务器已运行较长时间。请注意，服务器稍后可能会重新启动。",
    
    ar = "يعمل هذا الخادم منذ فترة طويلة. يرجى الانتباه إلى أنه قد تتم إعادة تشغيله لاحقًا.",
    
    hi = "यह सर्वर काफी समय से चल रहा है। कृपया ध्यान दें कि सर्वर बाद में रीस्टार्ट हो सकता है."
}

local text = messages[language] or messages.en

StarterGui:SetCore("SendNotification", {
    Title = "Server Warning",
    Text = text,
    Icon = "rbxassetid://122455528743115",
    Duration = 7
})

local function __KysHub_Init_Main__()
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local Teams             = game:GetService("Teams")
local GuiService        = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer       = Players.LocalPlayer
local Camera            = Workspace.CurrentCamera
local Character, Humanoid, Root

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local UI = {}

local ModernV2 = __KysHub_A2_Library
if not ModernV2 then warn("[KysHub] UI Library A2 NEW gagal dimuat") end

if isMobile then UI.Mobile = true end
print("[Universal] Platform:", isMobile and "MOBILE" or "PC")

-- =====================================================
local HttpService = game:GetService("HttpService")
local UIConfigPath = "KysHub_UI_Theme.json"
local KysUI_Solid = false
local KysUI_Color = "Red"

pcall(function()
    if isfile and readfile and isfile(UIConfigPath) then
        local data = HttpService:JSONDecode(readfile(UIConfigPath))
        KysUI_Solid = data.Solid
        KysUI_Color = data.Color or "Red"
    end
end)

if KysUI_Color == "Default" then
    KysUI_Color = "Red"
end

-- =====================================================

if ModernV2 then
    pcall(function()
        ModernV2:AddTheme({
            Name = "Lumi red",
            Accent = Color3.fromRGB(255, 0, 0),
            Outline = Color3.fromRGB(255, 0, 0),
            Text = Color3.fromRGB(255, 255, 255),
            PlaceholderText = Color3.fromRGB(200, 200, 200)
        })
    end)
end

local MenuIcon
if ModernV2 and ModernV2.CreateMenuIcon then
    MenuIcon = ModernV2:CreateMenuIcon({
        Image = "rbxassetid://126710436488213",
        Size = 48,
        IconColor = Color3.fromRGB(255, 255, 255),
        BGColor = Color3.fromRGB(20, 22, 27),
        StrokeColor = Color3.fromRGB(78, 127, 252),
        StrokeThick = 1.5,
        Draggable = true,
    })
end
local Window
if ModernV2 then
    -- =====================================
    -- MAIN SCRIPT
    -- =====================================
    Window = ModernV2:Window({
        Title = "A2",
        Content = "Violence District v1.5.7",
        Uitransparent = 0.15,
        Size = UDim2.fromOffset(500, 320),
        Color = Color3.fromRGB(78, 127, 252),
        Image = "126710436488213",
        ShowUser = true,
        Search = true,
        ConfigEnabled = true,
        NotifyOnCallbackError = false,
        Loadingscreen = false,
        Enable3DRenderer = false,
        Keybind = "RightControl",
        Config = {
            ConfigFolder = "KysHubViolenceDistrict",
            AutoSaveFile = "A2_vd",
            AutoSave = false,
            AutoLoad = false,
            Overwrite = true,
            Format = "JSON",
            ShowAutoSaveToggle = true,
            TextGradient = true,
        }
    })

    if MenuIcon and Window.AttachMenuIcon then
        Window:AttachMenuIcon(MenuIcon)
    end

    Window:SetAccount({
        Username = LocalPlayer.DisplayName,
        Profile = ModernV2.UserProfile,
        Expires = "A2OnTop",
    })

    Window:CreateHomeTab({
        Name = "Dashboard",
        Icon = "lucide:layout-dashboard",
        Content = "A2 Violence District Script",
        DiscordInvite = "pbg6g79Hp",
          SupportedExecutors = { "Delta", "Synapse X", "Krnl", "Codex", "Arceus X" },
          UnsupportedExecutors = { "Roblox Studio" },
          Segments = {
              Details = { Text = "Details", Icon = "lucide:grid-2x2" },
              Script = { Text = "Script Logs", Icon = "lucide:code" },
              UI = { Text = "UI Logs", Icon = "lucide:file-text", Show = true }
          },
        Changelog = {
            {
                Title = "A2 VD v1.5.7",
                Description = "Added Fake Perks (Flowstate, Quick Recovery, Perfect Landing, Adrenaline Rush) with stack support and shared cooldown (Premium Only). Added Copy Avatar feature with accurate skin/mesh restoration.",
            },
            {
                Title = "A2 VD v1.5.6",
                Description = "Improved Weather & Sky Theme particles and fixed Fullbright compatibility with active weather themes.",
            },
            {
                Title = "A2 VD v1.5.5",
                Description = "Improved Aimbot, Spear Aimbot, Silent Aim Spear, and added new Auto Dodge Spear feature.",
            },
            {
                Title = "A2 VD v1.5.4",
                Description = "Added Fake Parry, Fake Generator, Fake Attack, and fixed Infinite Skills backend.",
            },
        },
        UIChangelog = {
            {
                Title = "ModernV2 Framework",
                Date = "Latest",
                Description = "Added Lumi red Theme",
            },
        }
    })
end

-- =====================================================
-- PC CURSOR UNLOCK (ALT key toggle)
-- Hanya aktif di PC, tidak mengganggu mobile
-- =====================================================
if not isMobile then
    local _cursorOn = false
    local _cursorManual = false

    local function _setCursor(state)
        _cursorOn = state
        _cursorManual = true
        pcall(function()
            UserInputService.MouseIconEnabled = state
            UserInputService.MouseBehavior = state
                and Enum.MouseBehavior.Default
                or Enum.MouseBehavior.LockCenter
        end)

        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = not state
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        
        if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
            _setCursor(not _cursorOn)
        end
    end)

    task.spawn(function()
        while true do
            if _cursorManual then
                pcall(function()
                    if _cursorOn then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        UserInputService.MouseIconEnabled = true
                    else
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                        UserInputService.MouseIconEnabled = false
                    end
                end)
            end
            task.wait(0.1)
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if _cursorOn then _setCursor(true) end
    end)

    print("[VD] ALT Toggle Cursor Ready (PC only)")
end

-- =====================================================
-- SAFE DRAWING UTILS
-- =====================================================
local DrawingAvailable = (function()
    if isMobile then return false end  --
    local ok, result = pcall(function()
        return typeof(Drawing) == "table" and Drawing.new ~= nil
    end)
    return ok and result or false
end)()

function SafeDrawing(typ)
    if not DrawingAvailable then return nil end
    local ok, res = pcall(function() return Drawing.new(typ) end)
    return ok and res or nil
end

function SafeRemove(obj)
    if obj and obj.Remove then pcall(function() obj:Remove() end) end
end

local MobileESP = {}

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================
function clamp(v, min, max)
    return math.max(min, math.min(max, v))
end



-- =====================================================
-- CONFIG
-- =====================================================
getgenv().VD = getgenv().VD or {

    -- Generator / Healing
    AutoSkillcheck        = false,
    AutoSkillcheckMode    = "Normal",
    -- Visual / UI
    HideSkillUI           = false,
    Fullbright            = false,
    -- Movement
    Speed                 = false,
    SpeedValue            = 16,
    Jump                  = false,
    JumpValue             = 50,
    InfiniteJump          = false,
    Noclip                = false,
    Moonwalk              = false,
    MoonwalkButton        = false,
    MoonwalkButtonLocked  = false,
    MoonwalkZigzagSpeed   = 11,
    MoonwalkBoostPower    = 1.08,
    AimLock               = false,
    AimLockButton         = false,
    AimLockButtonLocked   = false,
    AimLockMaxDistance    = 50,
    InvisibleNotVisual    = false,
    InvisibleSpeed        = 5,
    AntiAFK               = false,
    BypassGate            = false,
    -- Internal
    Destroyed             = false,
    -- Auto features

    AUTO_LeaveGen         = false,
    AUTO_LeaveDist        = 18,
    AUTO_Attack           = false,
    AUTO_AttackRange      = 12,
    HITBOX_Enabled        = false,
    HITBOX_Size           = 15,
    TOF_SilentAim         = false,
    TOF_Laser             = true,
    TOF_WallCheck         = false,
    TOF_BlockKnocked      = true,
    TOF_TargetMode        = "Killer",
    TOF_Key               = "None",
    FLASH_SilentAim       = false,
    FLASH_Laser           = true,
    FLASH_TargetPart      = "Head",
    FLASH_Range           = 120,
    FLASH_Smooth          = 0.35,
    SURV_FleeKiller       = false,
    SURV_FleeDistance     = 40,
    SURV_SwiftVault        = false,  -- Auto Vault saat dekat window
    SURV_SwiftVaultV2       = false,  -- Custom vault speed
    SURV_SwiftVaultSpeed       = 13,
    SURV_AutoPallet       = false,  -- Auto Pallet Drop saat killer dekat
    SURV_AutoPalletDist   = 20,     -- Jarak killer (studs) untuk trigger pallet drop
    SURV_AutoParry        = false,
    SURV_ParryDistance    = 8,
    SURV_ShowParryCircle  = false,
    SURV_FakeParry        = false,
    SURV_FakeParryAnim    = "Enten",
    SURV_FakeGen          = false,
    SURV_AntiKnock        = false,
    -- Killer features
    KILLER_DestroyPallets = false,
    KILLER_NoPalletStun   = false,
    KILLER_AutoHook       = false,
    KILLER_AutoBreakGene  = false,
    KILLER_BlockVaults    = false,
    KILLER_BlockPallets   = false,
    KILLER_BlockPalletDrop = false,
    KILLER_BypassCooldown = false,
    KILLER_BypassLeap     = false,
    KILLER_AntiBlind      = false,
    KILLER_NoSlowdown     = false,
    KILLER_CustomMasked   = "Richard",
    -- Speed
    SPEED_Enabled         = false,
    SPEED_Value           = 32,
    SPEED_Method          = "Attribute",
    -- Visual extras
    NO_Fog                = false,
    NoCutscene            = false,
    CAM_FOVEnabled        = false,
    CAM_FOV               = 90,
    CAM_ThirdPerson       = false,
    CAM_ShiftLock         = false,
    CAM_InfinityZoom      = false,
    -- Config
    AntiFallDamage        = false,
    FLING_Enabled         = false,
    FLING_Strength        = 10000,
    -- Beat game
    BEAT_Survivor         = false,
    BEAT_Killer           = false,
    TP_Offset             = 3,
    VIS_KystKiller        = false,
    VIS_SpectatorCounter  = false,
    VIS_KillerPerks       = false,
    VIS_PredictMap        = false,
    VIS_HideSurvivorIcon  = false,
    VIS_ShowPingFPS       = false,
    VIS_ShowHookCounter   = false,
    VIS_WeatherTheme      = "Default",
    CROSS_Enabled         = false,
    CROSS_Style           = "Dot",
    CROSS_Size            = 3,
    CROSS_Thickness       = 4,
    CROSS_Gap             = 6,
    CROSS_PosX            = 0,
    CROSS_PosY            = 0,
    CROSS_Color           = Color3.fromRGB(255, 255, 255),

    ESP_ClosestHook       = false,    -- Aimbot
    AIM_Enabled           = false,

    AIM_UseRMB            = false,
    AIM_FOV               = 120,
    AIM_Smooth            = 0.3,
    AIM_TargetPart        = "Head",
    AIM_VisCheck          = false,
    AIM_ShowFOV           = false,
    AIM_Predict           = false,
    SURV_FirstPerson       = false,
    -- Spear aimbot
    SPEAR_Aimbot          = false,
    SPEAR_Gravity         = 50,
    SPEAR_Speed           = 100,
    -- Radar
    RADAR_Enabled         = false,
    RADAR_Size            = 150,
    RADAR_Range           = 250,
    RADAR_Transparency    = 0.2,
    RADAR_Circle          = false,
    RADAR_ShowKiller      = false,
    RADAR_ShowSurvivor    = false,
    RADAR_ShowGenerator   = false,
    RADAR_ShowPallet      = false,
    RADAR_ShowHook        = false,
    RADAR_ShowGate        = false,
    RADAR_ShowWindow      = false,
    RADAR_ShowZombie      = false,
    SURV_WarnKiller       = false,
    SURV_AutoDodgeSpear   = false
}

local VD = getgenv().VD

-- =====================================================
-- ADVANCED CROSSHAIR (GUI Fallback / Port)
-- =====================================================
local CrosshairGui = nil

function clearCrosshair()
    if CrosshairGui then
        pcall(function() CrosshairGui:Destroy() end)
        CrosshairGui = nil
    end
end

function VD_UpdateCrosshair()
    clearCrosshair()
    if not VD.CROSS_Enabled then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    local style = VD.CROSS_Style or "Dot"
    local size = tonumber(VD.CROSS_Size) or 3
    local gap = tonumber(VD.CROSS_Gap) or 6
    local thick = tonumber(VD.CROSS_Thickness) or 4
    local color = typeof(VD.CROSS_Color) == "Color3" and VD.CROSS_Color or Color3.fromRGB(255, 255, 255)
    
    local offsetX = tonumber(VD.CROSS_PosX) or 0
    local offsetY = tonumber(VD.CROSS_PosY) or 0

    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    local parent = (ok and core) and core or game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if not parent then return end

    CrosshairGui = Instance.new("ScreenGui")
    CrosshairGui.Name = "KYS_Crosshair"
    CrosshairGui.DisplayOrder = 999999
    CrosshairGui.IgnoreGuiInset = true
    CrosshairGui.Parent = parent

    local centerFrame = Instance.new("Frame")
    centerFrame.Name = "Center"
    centerFrame.BackgroundTransparency = 1
    centerFrame.Position = UDim2.new(0.5, offsetX, 0.5, offsetY)
    centerFrame.Size = UDim2.new(0,0,0,0)
    centerFrame.Parent = CrosshairGui

    if style == "Dot" then
        local dot = Instance.new("Frame")
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Size = UDim2.new(0, size * 2, 0, size * 2)
        dot.BackgroundColor3 = color
        dot.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = dot
        dot.Parent = centerFrame

    elseif style == "Plus" or style == "X" then
        local length = size * 3
        for i = 1, 4 do
            local line = Instance.new("Frame")
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.BackgroundColor3 = color
            line.BorderSizePixel = 0
            
            local angle = (i - 1) * 90
            if style == "X" then angle = angle + 45 end
            
            line.Rotation = angle
            line.Size = UDim2.new(0, length, 0, thick)
            
            local rad = math.rad(angle)
            local dirX = math.cos(rad)
            local dirY = math.sin(rad)
            
            local dist = gap + (length / 2)
            -- Snap values to avoid weird float sub-pixel rendering blur
            line.Position = UDim2.new(0, math.floor(dirX * dist + 0.5), 0, math.floor(dirY * dist + 0.5))
            line.Parent = centerFrame
        end

    elseif style == "Box" then
        local half = gap + size * 2
        
        local t = Instance.new("Frame")
        t.BackgroundColor3 = color; t.BorderSizePixel = 0; t.AnchorPoint = Vector2.new(0.5, 0.5)
        t.Size = UDim2.new(0, half * 2 + thick, 0, thick)
        t.Position = UDim2.new(0, 0, 0, -half)
        t.Parent = centerFrame

        local b = Instance.new("Frame")
        b.BackgroundColor3 = color; b.BorderSizePixel = 0; b.AnchorPoint = Vector2.new(0.5, 0.5)
        b.Size = UDim2.new(0, half * 2 + thick, 0, thick)
        b.Position = UDim2.new(0, 0, 0, half)
        b.Parent = centerFrame

        local l = Instance.new("Frame")
        l.BackgroundColor3 = color; l.BorderSizePixel = 0; l.AnchorPoint = Vector2.new(0.5, 0.5)
        l.Size = UDim2.new(0, thick, 0, half * 2 - thick)
        l.Position = UDim2.new(0, -half, 0, 0)
        l.Parent = centerFrame

        local r = Instance.new("Frame")
        r.BackgroundColor3 = color; r.BorderSizePixel = 0; r.AnchorPoint = Vector2.new(0.5, 0.5)
        r.Size = UDim2.new(0, thick, 0, half * 2 - thick)
        r.Position = UDim2.new(0, half, 0, 0)
        r.Parent = centerFrame
    end
end
getgenv().VD_UpdateCrosshair = VD_UpdateCrosshair

-- All runtime features are intentionally reset on every execute.
-- This prevents stale getgenv/config/UI state from enabling anything
-- before the user turns it on manually.
local VD_DefaultOffFlags = {
    "AutoSkillcheck",
    "HideSkillUI",
    "Fullbright",
    "Speed",
    "Jump",
    "InfiniteJump",
    "Noclip",
    "Moonwalk",
    "MoonwalkButton",
    "MoonwalkButtonLocked",
    "AimLock",
    "AimLockButton",
    "AimLockButtonLocked",
    "AimLockMaxDistance",
    "InvisibleNotVisual",
    "AntiAFK",
    "BypassGate",
    "AUTO_Attack",
    "HITBOX_Enabled",
    "TOF_SilentAim",
    "FLASH_SilentAim",
    "SURV_FleeKiller",
    "SURV_SwiftVault",
    "SURV_SwiftVaultV2",
    "SURV_AutoPallet",
    "SURV_AutoParry",
    "SURV_ShowParryCircle",
    "SURV_FakeParry",
    "SURV_FakeParryAnim",
    "SURV_FakeGen",
    "SURV_AntiKnock",
    "KILLER_DestroyPallets",
    "KILLER_NoPalletStun",
    "KILLER_AutoHook",
    "KILLER_AutoBreakGene",
    "KILLER_BlockVaults",
    "KILLER_BlockPallets",
    "KILLER_BlockPalletDrop",
    "KILLER_BypassCooldown",
    "KILLER_BypassLeap",
    "KILLER_BypassVeilCooldown",
    "KILLER_AntiBlind",
    "KILLER_NoSlowdown",
    "SPEED_Enabled",
    "NO_Fog",
    "NoCutscene",
    "VIS_KystKiller",
    "CAM_FOVEnabled",
    "CAM_ThirdPerson",
    "CAM_ShiftLock",
    "CAM_InfinityZoom",
    "AntiFallDamage",
    "FLING_Enabled",
    "BEAT_Survivor",
    "BEAT_Killer",
    "ESP_ClosestHook",
    "VIS_SpectatorCounter",
    "VIS_KillerPerks",
    "VIS_PredictMap",
    "VIS_HideSurvivorIcon",
    "VIS_ShowPingFPS",
    "VIS_ShowHookCounter",
    "CROSS_Enabled",
    "CROSS_Style",
    "CROSS_Size",
    "CROSS_Thickness",
    "CROSS_Gap",
    "CROSS_PosX",
    "CROSS_PosY",
    "CROSS_Color",
    "AIM_Enabled",

    "AIM_UseRMB",
    "AIM_VisCheck",
    "AIM_ShowFOV",
    "AIM_Predict",
    "SURV_FirstPerson",
    "SPEAR_Aimbot",
    "RADAR_Enabled",
    "RADAR_Circle",
    "RADAR_ShowKiller",
    "RADAR_ShowSurvivor",
    "RADAR_ShowGenerator",
    "RADAR_ShowPallet",
    "RADAR_ShowHook",
    "RADAR_ShowGate",
    "RADAR_ShowWindow",
    "RADAR_ShowZombie",
    "SURV_WarnKiller",
}

for _, flagName in ipairs(VD_DefaultOffFlags) do
    VD[flagName] = false
end

if VD.TOF_Laser == nil then VD.TOF_Laser = true end
if VD.TOF_WallCheck == nil then VD.TOF_WallCheck = false end
if VD.TOF_BlockKnocked == nil then VD.TOF_BlockKnocked = true end
if VD.TOF_TargetMode == nil then VD.TOF_TargetMode = "Killer" end
if VD.TOF_Key == nil then VD.TOF_Key = "None" end
if VD.FLASH_TargetPart == nil then VD.FLASH_TargetPart = "Head" end
if VD.FLASH_Laser == nil then VD.FLASH_Laser = true end
if VD.FLASH_Range == nil then VD.FLASH_Range = 120 end
if VD.FLASH_Smooth == nil then VD.FLASH_Smooth = 0.35 end

-- =====================================================
-- CONFIGURATION SYSTEM (Save & Load)
-- =====================================================
function GetSafeGuiParent()
    if gethui then return gethui() end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer:FindFirstChild("PlayerGui")
end


local VD_ChamsFolder = nil
function GetSafeChamsFolder()
    local pg = GetSafeGuiParent()
    if not pg then return workspace end
    if VD_ChamsFolder and VD_ChamsFolder.Parent then return VD_ChamsFolder end

    local f = pg:FindFirstChild("KYS_WorkspaceChams")
    if not f then
        f = Instance.new("Folder")
        f.Name = "KYS_WorkspaceChams"
        f.Parent = pg
    end
    VD_ChamsFolder = f
    return f
end

local ConfigFolderName = "KysHub_VD"
local HttpService = game:GetService("HttpService")

if makefolder and isfolder and not isfolder(ConfigFolderName) then
    makefolder(ConfigFolderName)
end

getgenv().CurrentConfigName = "Default"

function GetConfigList()
    local list = {}
    if listfiles and isfolder and isfolder(ConfigFolderName) then
        for _, file in pairs(listfiles(ConfigFolderName)) do
            if file:sub(-5) == ".json" then
                local filename = file:match("([^/\\]+)%.json$")
                if filename then
                    table.insert(list, filename)
                end
            end
        end
    end
    if #list == 0 then table.insert(list, "Default") end
    return list
end

function KYS_SaveConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" then name = "Default" end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if writefile then
            writefile(path, HttpService:JSONEncode(VD))
        end
    end)
end

local VD_To_Flag = {
    InfiniteJump = "Infinite Jump",
    KILLER_AntiBlind = "Anti Blind (Flashlight)",
    Fullbright = "Fullbright (lighting preset)",
    AIM_VisCheck = "Visibility Check",
    AutoSkillcheck = "Auto Skillcheck",
    AutoSkillcheckMode = "Skillcheck Mode",
    HideSkillUI = "Hide Skillcheck UI",
    SpeedValue = "Speed Value",
    AIM_Enabled = "Enable Aimbot",
    HITBOX_Size = "Hitbox Size",
    SURV_FleeKiller = "Flee Killer",
    SURV_FleeDistance = "Flee Distance",
    SURV_AutoVault      = "SwiftVault",
    SURV_FastVault      = "SwiftVaultV2",
    SURV_VaultSpeed     = "SwiftVaultSpeed",
    SURV_AutoPallet     = "Pallet Reflex",
    SURV_AutoPalletDist = "Pallet Trigger Range",
    SURV_AutoParry      = "Auto Parry",
    SURV_ParryDistance  = "Parry Distance Trigger",
    SURV_ShowParryCircle = "Show Parry Range Circle",
    SURV_FakeParry      = "Fake Parry (Press V)",
    SURV_FakeParryAnim  = "Fake Parry Animation",
    SURV_FakeGen        = "Fake Generator (Press B)",
    SURV_AntiKnock = "Anti Knock",
    KILLER_DestroyPallets = "Destroy Pallets",
    KILLER_AutoBreakGene  = "Auto Kick Generator",
    KILLER_BlockVaults    = "Block All Vaults",
    KILLER_BlockPallets   = "Auto Drop All Pallets",
    KILLER_BlockPalletDrop = "Break All Pallet",
    KILLER_BypassCooldown = "Infinite Abyssal Burst (Abyss)",
    KILLER_BypassLeap     = "Infinite Skill (Hidden)",
    KILLER_FakeAttack     = "Fake Attack (Counter Parry)",
    KILLER_BypassVeilCooldown = "Bypass Cooldown (Veil)",
    KILLER_CustomMasked = "Custom Masked",
    Speed = "Speed Hack",
    CAM_FOV = "Camera FOV",
    CAM_FOVEnabled = "Enable Camera FOV override",
    FLING_Strength = "Fling Strength",
    Noclip = "Noclip",
    Moonwalk = "Moonwalk",
    MoonwalkButton = "Moonwalk",
    MoonwalkButtonLocked = "Lock Moonwalk Button",
    MoonwalkZigzagSpeed = "Moonwalk Zigzag Speed",
    MoonwalkBoostPower = "Moonwalk Boost Power",
    AimLock = "Target Lock",
    AimLockButton = "Target Lock",
    AimLockButtonLocked = "Lock Target Lock Button",
    AimLockMaxDistance = "Target Lock Max Distance",
    BEAT_Killer = "Beat Killer (auto kill)",
    AIM_Predict = "Prediction",
    AIM_ShowFOV = "Show FOV Circle",
    KILLER_AutoHook = "Auto Hook",
    Jump = "Jump Hack",
    KILLER_NoSlowdown = "No Slowdown",
    SPEAR_Gravity = "Spear Gravity",
    AIM_UseRMB = "Use RMB to aim",
    CAM_ShiftLock = "Shift Lock (auto face camera)",
    Destroyed = "Solid UI Mode (No Transparency)",
    AUTO_AttackRange = "Attack Range",
    AIM_FOV = "FOV Size (aim radius on screen)",
    KILLER_NoPalletStun = "Remove Palletwrong (All)",
    CAM_ThirdPerson = "Third Person (Killer only)",
    CAM_InfinityZoom = "Infinity Zoom Out",
    AntiFallDamage = "Anti Fall Damage",
    InvisibleNotVisual = "Invisible Not Visual",
    InvisibleSpeed = "Invisible Speed",
    AntiAFK = "Anti AFK",
    BypassGate = "Bypass Gate",
    HITBOX_Enabled = "Hitbox Expand",
    TOF_SilentAim = "Silent Aim Twist Of Fate",
    TOF_Laser = "ToF Laser",
    TOF_WallCheck = "ToF Wall Check",
    TOF_BlockKnocked = "ToF Block When Knocked",
    TOF_TargetMode = "ToF Target Mode",
    TOF_Key = "Silent Aim Key",
    FLASH_SilentAim = "Silent Aim Flashlight",
    FLASH_Laser = "Flashlight Laser",
    FLASH_TargetPart = "Flashlight Target Part",
    FLASH_Range = "Flashlight Range",
    FLASH_Smooth = "Flashlight Smoothness",
    NO_Fog = "No Fog (remove fog/post effects)",
    NoCutscene = "No Cutscene",
    FLING_Enabled = "Enable Fling",
    AIM_Smooth = "Smoothness",
    SPEAR_Speed = "Spear Speed",
    SPEAR_Aimbot = "Spear Aimbot",
    SURV_FirstPerson = "First Person Camera (Survivor)",
    JumpValue = "Jump Power",
    AUTO_Attack = "Auto Attack",
    BEAT_Survivor = "Beat Survivor (auto exit)",
    SURV_WarnKiller = "Survivor Killer Warning",
    VIS_KystKiller = "Kyst Killer Display",
    VIS_SpectatorCounter = "Enable Spectator Counter",
    VIS_KillerPerks = "Killer Perks Display",
    VIS_PredictMap = "Predict Map",
    VIS_HideSurvivorIcon = "Hide Survivor Icon",
    VIS_ShowPingFPS = "Show Ping & FPS",
    VIS_ShowHookCounter = "Show Hook Counter",
}

function KYS_LoadConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" then name = "Default" end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if readfile and isfile and isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            for key, value in pairs(data) do
                VD[key] = value
                -- Sync to UI visual state if mapping exists
                local flagName = VD_To_Flag[key]
                if flagName and Window and Window.ConfigElements and Window.ConfigElements[flagName] then
                    pcall(function()
                        local elem = Window.ConfigElements[flagName]
                        if elem.Set then elem:Set(value) end
                    end)
                end
            end
            if getgenv().KYS_SyncLoadedFeatures then pcall(getgenv().KYS_SyncLoadedFeatures) end
        end
    end)
end

function KYS_DeleteConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" or name == "Default" then return end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if isfile and isfile(path) and delfile then
            delfile(path)
            print("[VD Config] Deleted:", name)
        end
    end)
end

-- Auto-load dimatikan: config hanya dimuat saat user memilih Load manual dari UI.

-- =====================================================
-- SAVE ORIGINAL LIGHTING
-- =====================================================
local originalLighting = {
    Brightness     = Lighting.Brightness,
    ClockTime      = Lighting.ClockTime,
    FogEnd         = Lighting.FogEnd,
    FogStart       = Lighting.FogStart,
    GlobalShadows  = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient
}
do
    local atm  = Lighting:FindFirstChildOfClass("Atmosphere")
    local blur = Lighting:FindFirstChildOfClass("BlurEffect")
    local cc   = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    local sr   = Lighting:FindFirstChildOfClass("SunRaysEffect")
    if atm then
        originalLighting.Atmosphere = {
            Density = atm.Density,
            Offset = atm.Offset,
            Glare = atm.Glare,
            Haze = atm
                .Haze
        }
    end
    if blur then originalLighting.Blur = { Size = blur.Size } end
    if cc then originalLighting.ColorCorrection = { Enabled = cc.Enabled } end
    if sr then originalLighting.SunRays = { Enabled = sr.Enabled } end
end

-- =====================================================
-- WEATHER ENGINE
-- =====================================================
getgenv().VD_CurrentSky = nil
getgenv().VD_ParticleAnchor = nil

local KYS_WeatherPresets = {
    ["Default"] = {},
    ["Christmas (Snow)"] = {
        Lighting = { FogColor = Color3.fromRGB(150, 180, 220), FogEnd = 200, ClockTime = 8, OutdoorAmbient = Color3.fromRGB(100, 120, 150) },
        Atmosphere = { Density = 0.5, Color = Color3.fromRGB(180, 200, 220), Decay = Color3.fromRGB(150, 180, 220), Haze = 5, Glare = 0 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)), Size = NumberSequence.new(1.5), Rate = 150, Speed = NumberRange.new(15, 25), Lifetime = NumberRange.new(4, 6), EmissionDirection = Enum.NormalId.Bottom, RotSpeed = NumberRange.new(-45, 45) }
    },
    ["Heavy Rain (Storm)"] = {
        Lighting = { FogColor = Color3.fromRGB(50, 50, 60), FogEnd = 150, OutdoorAmbient = Color3.fromRGB(40, 40, 50), Brightness = 0.2, ClockTime = 12 },
        CC = { TintColor = Color3.fromRGB(150, 150, 180), Contrast = 0.2, Saturation = -0.5 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(260, 1, 260), CameraOffset = Vector3.new(0, 38, -18), Squash = NumberSequence.new(16), Color = ColorSequence.new(Color3.fromRGB(235, 245, 255)), Size = NumberSequence.new(1.25), Rate = 2600, Speed = NumberRange.new(110, 145), Lifetime = NumberRange.new(0.85, 1.25), EmissionDirection = Enum.NormalId.Bottom, Transparency = NumberSequence.new(0), Acceleration = Vector3.new(-18, -75, 0), SpreadAngle = Vector2.new(3, 3), LightEmission = 1 }
    },
    ["Autumn (Musim Gugur)"] = {
        Lighting = { FogColor = Color3.fromRGB(200, 150, 80), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(180, 140, 70), ClockTime = 16.5 },
        CC = { TintColor = Color3.fromRGB(255, 220, 180), Contrast = 0.1, Saturation = 0.2 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(210, 1, 210), CameraOffset = Vector3.new(0, 28, -16), Squash = NumberSequence.new(3.2), Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 45)), ColorSequenceKeypoint.new(0.45, Color3.fromRGB(235, 95, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 45, 10)) }), Size = NumberSequence.new(2.05), Rate = 360, Speed = NumberRange.new(8, 15), Lifetime = NumberRange.new(6, 10), EmissionDirection = Enum.NormalId.Bottom, Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-220, 220), Transparency = NumberSequence.new(0), Acceleration = Vector3.new(18, -8, 6), SpreadAngle = Vector2.new(38, 38), LightEmission = 0.6 }
    },
    ["Cherry Blossom (Sakura)"] = {
        Lighting = { FogColor = Color3.fromRGB(255, 200, 220), FogEnd = 600, OutdoorAmbient = Color3.fromRGB(255, 180, 200), ClockTime = 9 },
        CC = { TintColor = Color3.fromRGB(255, 230, 240), Saturation = 0.3 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(160, 1, 160), CameraOffset = Vector3.new(0, 25, -18), Squash = NumberSequence.new(1.2), Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 235)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 165, 205)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 180)) }), Size = NumberSequence.new(1.25), Rate = 190, Speed = NumberRange.new(5, 10), Lifetime = NumberRange.new(7, 10), EmissionDirection = Enum.NormalId.Bottom, Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-170, 170), Transparency = NumberSequence.new(0), Acceleration = Vector3.new(14, -5, 5), SpreadAngle = Vector2.new(32, 32), LightEmission = 0.55 }
    },
    ["Sunset (Golden Hour)"] = {
        Lighting = { FogColor = Color3.fromRGB(255, 120, 50), FogEnd = 1200, OutdoorAmbient = Color3.fromRGB(200, 100, 50), ClockTime = 17.5, Brightness = 1.5 },
        CC = { TintColor = Color3.fromRGB(255, 200, 150), Contrast = 0.2, Saturation = 0.4 }
    },
    ["Blood Moon (Spooky)"] = {
        Lighting = { FogColor = Color3.fromRGB(150, 10, 10), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(80, 0, 0), ClockTime = 0, Brightness = 0.3 },
        CC = { TintColor = Color3.fromRGB(255, 50, 50), Contrast = 0.4, Saturation = 0.5 },
        Atmosphere = { Density = 0.35, Color = Color3.fromRGB(255, 0, 0), Decay = Color3.fromRGB(100, 0, 0), Haze = 5, Glare = 0 }
    },
    ["Toxic Wasteland"] = {
        Lighting = { FogColor = Color3.fromRGB(80, 150, 50), FogEnd = 250, OutdoorAmbient = Color3.fromRGB(50, 120, 40), ClockTime = 12, Brightness = 1 },
        CC = { TintColor = Color3.fromRGB(150, 255, 150), Contrast = 0.1, Saturation = 0.3 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", Color = ColorSequence.new(Color3.fromRGB(100, 255, 50)), Size = NumberSequence.new(0.8), Rate = 200, Speed = NumberRange.new(50, 60), Lifetime = NumberRange.new(2, 3), EmissionDirection = Enum.NormalId.Bottom, Transparency = NumberSequence.new(0.5) }
    },
    ["Vaporwave (Synthwave)"] = {
        Lighting = { FogColor = Color3.fromRGB(200, 50, 255), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(150, 0, 200), ClockTime = 20, Brightness = 1 },
        CC = { TintColor = Color3.fromRGB(255, 100, 255), Contrast = 0.3, Saturation = 0.5 }
    },
    ["Midnight (Pitch Black)"] = {
        Lighting = { FogColor = Color3.fromRGB(0, 0, 0), FogEnd = 100, OutdoorAmbient = Color3.fromRGB(0, 0, 0), Brightness = 0, ClockTime = 0 },
        CC = { TintColor = Color3.fromRGB(50, 50, 50), Contrast = 0.5, Saturation = -0.8 }
    }
}

function VD_ApplyWeather(themeName)
    local theme = KYS_WeatherPresets[themeName]
    if not theme then theme = KYS_WeatherPresets["Default"] end
    
    -- Cleanup old sky, cc, atm
    if getgenv().VD_CurrentSky and getgenv().VD_CurrentSky.Parent then getgenv().VD_CurrentSky:Destroy() end
    getgenv().VD_CurrentSky = nil
    
    if getgenv().VD_WeatherCC and getgenv().VD_WeatherCC.Parent then getgenv().VD_WeatherCC:Destroy() end
    getgenv().VD_WeatherCC = nil
    
    if getgenv().VD_WeatherAtmosphere and getgenv().VD_WeatherAtmosphere.Parent then getgenv().VD_WeatherAtmosphere:Destroy() end
    getgenv().VD_WeatherAtmosphere = nil
    
    -- Apply Atmosphere
    if theme.Atmosphere then
        local atm = Instance.new("Atmosphere")
        atm.Name = "VD_WeatherAtmosphere"
        for k, v in pairs(theme.Atmosphere) do pcall(function() atm[k] = v end) end
        atm.Parent = Lighting
        getgenv().VD_WeatherAtmosphere = atm
    end
    
    -- Apply ColorCorrection
    if theme.CC then
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "VD_WeatherCC"
        for k, v in pairs(theme.CC) do pcall(function() cc[k] = v end) end
        cc.Parent = Lighting
        getgenv().VD_WeatherCC = cc
    end
    
    -- Apply Lighting
    if theme.Lighting then
        for k, v in pairs(theme.Lighting) do
            pcall(function() Lighting[k] = v end)
        end
    else
        -- Restore original lighting if no specific lighting is set, but respect Fullbright & NoFog
        if not VD.Fullbright and not VD.NO_Fog then
            Lighting.Brightness = originalLighting.Brightness
            Lighting.ClockTime = originalLighting.ClockTime
            Lighting.FogEnd = originalLighting.FogEnd
            Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        end
    end
    
    -- Re-apply Fullbright & NoFog if they are on
    if VD.Fullbright then pcall(VD_SetFullbright, true) end
    if VD.NO_Fog then pcall(VD_SetNoFog, true) end

    -- Setup Particles
    if getgenv().VD_ParticleAnchor and getgenv().VD_ParticleAnchor.Parent then
        getgenv().VD_ParticleAnchor:Destroy()
    end
    getgenv().VD_ParticleAnchor = nil
    
    if theme.Particle then
        local anchor = Instance.new("Part")
        anchor.Name = "VD_WeatherAnchor"
        anchor.Transparency = 0.99 -- Almost invisible but guarantees rendering
        anchor.CanCollide = false
        anchor.Anchored = true
        anchor.Size = theme.Particle.AnchorSize or Vector3.new(120, 1, 120)
        anchor:SetAttribute("VD_CameraOffsetX", theme.Particle.CameraOffset and theme.Particle.CameraOffset.X or 0)
        anchor:SetAttribute("VD_CameraOffsetY", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Y or 30)
        anchor:SetAttribute("VD_CameraOffsetZ", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Z or 0)
        
        local pe = Instance.new("ParticleEmitter")
        pe.Name = "VD_WeatherEmitter"
        
        -- Default important settings for Weather Emitters
        pe.Enabled = true
        pe.EmissionDirection = Enum.NormalId.Bottom
        pe.LockedToPart = false
        pe.ZOffset = 2 -- Make it render over most things
        pe.LightEmission = 0.25
        pe.SpreadAngle = Vector2.new(10, 10)
        pcall(function() pe.Shape = Enum.ParticleEmitterShape.Box end)
        pcall(function() pe.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
        
        for k, v in pairs(theme.Particle) do
            if k ~= "AnchorSize" and k ~= "CameraOffset" then
                pcall(function() pe[k] = v end)
            end
        end
        
        pe.Parent = anchor
        if themeName == "Heavy Rain (Storm)" then
            local nearRain = Instance.new("ParticleEmitter")
            nearRain.Name = "VD_WeatherRainNearEmitter"
            nearRain.Enabled = true
            nearRain.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            nearRain.Color = ColorSequence.new(Color3.fromRGB(230, 240, 255))
            nearRain.Transparency = NumberSequence.new(0)
            nearRain.Size = NumberSequence.new(1.65)
            nearRain.Squash = NumberSequence.new(20)
            nearRain.Rate = 1800
            nearRain.Speed = NumberRange.new(70, 95)
            nearRain.Lifetime = NumberRange.new(0.75, 1.05)
            nearRain.EmissionDirection = Enum.NormalId.Bottom
            nearRain.Acceleration = Vector3.new(-24, -90, 0)
            nearRain.SpreadAngle = Vector2.new(2, 2)
            nearRain.LockedToPart = false
            nearRain.ZOffset = 6
            nearRain.LightEmission = 1
            pcall(function() nearRain.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() nearRain.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            nearRain.Parent = anchor

            local rainSheet = Instance.new("ParticleEmitter")
            rainSheet.Name = "VD_WeatherRainSheetEmitter"
            rainSheet.Enabled = true
            rainSheet.Texture = "rbxasset://textures/particles/smoke_main.dds"
            rainSheet.Color = ColorSequence.new(Color3.fromRGB(170, 195, 225))
            rainSheet.Transparency = NumberSequence.new(0.45)
            rainSheet.Size = NumberSequence.new(3.2)
            rainSheet.Squash = NumberSequence.new(7)
            rainSheet.Rate = 650
            rainSheet.Speed = NumberRange.new(45, 65)
            rainSheet.Lifetime = NumberRange.new(1.0, 1.5)
            rainSheet.EmissionDirection = Enum.NormalId.Bottom
            rainSheet.Acceleration = Vector3.new(-14, -55, 0)
            rainSheet.SpreadAngle = Vector2.new(8, 8)
            rainSheet.LockedToPart = false
            rainSheet.ZOffset = 3
            rainSheet.LightEmission = 0.35
            pcall(function() rainSheet.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() rainSheet.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            rainSheet.Parent = anchor
        elseif themeName == "Autumn (Musim Gugur)" then
            local bigLeaves = Instance.new("ParticleEmitter")
            bigLeaves.Name = "VD_WeatherAutumnBigLeavesEmitter"
            bigLeaves.Enabled = true
            bigLeaves.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            bigLeaves.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 205, 55)),
                ColorSequenceKeypoint.new(0.35, Color3.fromRGB(230, 95, 25)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(165, 65, 20)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 40, 8))
            })
            bigLeaves.Transparency = NumberSequence.new(0)
            bigLeaves.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2.4),
                NumberSequenceKeypoint.new(0.5, 3.1),
                NumberSequenceKeypoint.new(1, 1.8)
            })
            bigLeaves.Squash = NumberSequence.new(4.5)
            bigLeaves.Rate = 150
            bigLeaves.Speed = NumberRange.new(5, 10)
            bigLeaves.Lifetime = NumberRange.new(8, 12)
            bigLeaves.EmissionDirection = Enum.NormalId.Bottom
            bigLeaves.Rotation = NumberRange.new(0, 360)
            bigLeaves.RotSpeed = NumberRange.new(-280, 280)
            bigLeaves.Acceleration = Vector3.new(24, -5, 10)
            bigLeaves.SpreadAngle = Vector2.new(45, 45)
            bigLeaves.LockedToPart = false
            bigLeaves.ZOffset = 5
            bigLeaves.LightEmission = 0.65
            pcall(function() bigLeaves.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() bigLeaves.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            bigLeaves.Parent = anchor
        end
        anchor.Parent = workspace
        getgenv().VD_ParticleAnchor = anchor
        
        -- FORCE PRELOAD FOR MOBILE CLIENTS
        if theme.Particle.Texture then
            task.spawn(function()
                pcall(function()
                    game:GetService("ContentProvider"):PreloadAsync({pe})
                end)
            end)
        end
        
        -- Initial position
        pcall(VD_UpdateWeatherAnchor)
    end
end

function VD_UpdateWeatherAnchor()
    local anchor = getgenv().VD_ParticleAnchor
    if not anchor then return end
    
    -- Keep the emitter in Workspace; ParticleEmitters under CurrentCamera can be culled on some clients.
    if anchor.Parent ~= workspace then
        pcall(function() anchor.Parent = workspace end)
    end
    
    local camera = workspace.CurrentCamera
    if camera then
        local offset = Vector3.new(
            anchor:GetAttribute("VD_CameraOffsetX") or 0,
            anchor:GetAttribute("VD_CameraOffsetY") or 30,
            anchor:GetAttribute("VD_CameraOffsetZ") or 0
        )
        local worldPos = camera.CFrame.Position
            + camera.CFrame.RightVector * offset.X
            + Vector3.new(0, offset.Y, 0)
            + camera.CFrame.LookVector * math.abs(offset.Z)
        anchor.CFrame = CFrame.new(worldPos)
        return
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        local head = char.Head
        anchor.CFrame = CFrame.new(head.Position + Vector3.new(0, 30, 0))
    end
end

-- =====================================================
-- CHARACTER REFS
-- =====================================================
-- Character, Humanoid, and Root are declared at the top of __KysHub_Init_Main__

function updateChar(char)
    Character = char or LocalPlayer.Character
    if Character then
        task.spawn(function()
            Humanoid = Character:WaitForChild("Humanoid", 5)
            Root     = Character:WaitForChild("HumanoidRootPart", 5)
        end)
    else
        Humanoid, Root = nil, nil
    end
end
updateChar()
LocalPlayer.CharacterAdded:Connect(updateChar)
LocalPlayer.CharacterRemoving:Connect(function(char)
    if char == Character or char == LocalPlayer.Character then
        Character, Humanoid, Root = nil, nil, nil
    end
end)

-- =====================================================
-- HELPERS: TEAM / COLORS
-- =====================================================
local TeamColor  = Color3.fromRGB(0, 255, 0)
local EnemyColor = Color3.fromRGB(255, 0, 0)

function isTeammate(player)
    return LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team
end

function getPlayerColor(player)
    return isTeammate(player) and TeamColor or EnemyColor
end

-- =====================================================
-- CENTRALIZED METAMETHOD HOOK (__namecall)
-- =====================================================
local KYS_WorldReg
getgenv().KYS_oldNamecall = nil

function setupAntiFail()
    if getgenv().KYS_AntiFailHooked then return end
    getgenv().KYS_AntiFailHooked = true
    task.spawn(function()
        local ok, err = pcall(function()
            local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
            local Events  = ReplicatedStorage:WaitForChild("Events", 10)
            if not Remotes then
                warn("AntiFail: Remotes not found")
                return
            end
-- PENTING: Cache getgenv() sekali saja sebagai upvalue lokal.
-- Memanggil getgenv() di dalam __namecall hook bisa trigger namecall lagi
-- → infinite recursion → stack overflow → force close.
            local _genv = getgenv()

            _genv.KYS_oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()

                if VD.AntiFallDamage and method == "FireServer" then
                    local ok, name = pcall(function() return self.Name:lower() end)
                    if ok and (name:find("falldamage") or name:find("fall") or name:find("ragdollfall")) then
                        return
                    end
                end

                if VD.KILLER_InfFrenzy and method == "FireServer" then
                    local ok, name = pcall(function() return self.Name end)
                    if ok and (name == "Deactivatefromclient" or name == "PowerDoneDeactivating") then
                        return
                    end
                end

                if VD.KILLER_SilentAimFlask and method == "FireServer" then
                    local ok, name = pcall(function() return self.Name end)
                    if ok and name == "ThrowFlask" then
                        local args = {...}
                        local closest = nil
                        local minDst = math.huge
                        local lp = game:GetService("Players").LocalPlayer
                        local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
                        
                        if myPos then
                            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                    if not v.Character:GetAttribute("IsKiller") then
                                        local dst = (v.Character.HumanoidRootPart.Position - myPos).Magnitude
                                        if dst < minDst then
                                            minDst = dst
                                            closest = v
                                        end
                                    end
                                end
                            end
                        end
                        
                        if closest then
                            local targetPos = closest.Character.HumanoidRootPart.Position
                            -- args[1] = LookVector, args[2] = OriginPosition
                            if args[2] and typeof(args[2]) == "Vector3" then
                                args[1] = (targetPos - args[2]).Unit
                            end

                            setnamecallmethod(method)
                            return _genv.KYS_oldNamecall(self, unpack(args))
                        end
                    end
                end

                if method == "FireServer" and not checkcaller() then
                    local flashRemote = _genv.KYS_FlashlightActivateRemote
                    if flashRemote and self == flashRemote and _genv.KYS_SetFlashlightAimActive then
                        local args = { ... }
                        pcall(_genv.KYS_SetFlashlightAimActive, args[2] == true, args[1])
                    end
                end

                if _genv.KYS_oldNamecall then
                    return _genv.KYS_oldNamecall(self, ...)
                end
            end)

            print("AntiFail: hooked")
        end)
        if not ok then warn("AntiFail setup failed:", err) end
    end)
end
setupAntiFail()

-- =====================================================
-- FIRST PERSON CAMERA (Survivor)
-- =====================================================
getgenv().KYS_fpWasSet = false
getgenv().KYS_fpOriginal = nil

function RestoreFirstPersonCamera()
    if not getgenv().KYS_fpWasSet then return end
    getgenv().KYS_fpWasSet = false

    pcall(function()
        if getgenv().KYS_fpOriginal then
            LocalPlayer.CameraMode = getgenv().KYS_fpOriginal.CameraMode or Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = getgenv().KYS_fpOriginal.CameraMaxZoomDistance or 128
            LocalPlayer.CameraMinZoomDistance = getgenv().KYS_fpOriginal.CameraMinZoomDistance or 0.5
        else
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 128
        end
    end)

    local char = LocalPlayer.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then head.LocalTransparencyModifier = 0 end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") then
                local handle = obj:FindFirstChild("Handle")
                if handle then handle.LocalTransparencyModifier = 0 end
            end
        end
    end

    getgenv().KYS_fpOriginal = nil
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if VD.SURV_FirstPerson then
            local isSurvivor = LocalPlayer.Team and LocalPlayer.Team.Name == "Survivors"
            if isSurvivor then
                if not getgenv().KYS_fpWasSet then
                    getgenv().KYS_fpOriginal = {
                        CameraMode = LocalPlayer.CameraMode,
                        CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance,
                        CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance,
                    }
                end

                -- Paksa LockFirstPerson hanya saat toggle aktif agar game tidak bisa override
                if LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
                    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
                end
                if LocalPlayer.CameraMaxZoomDistance ~= 0 then
                    LocalPlayer.CameraMaxZoomDistance = 0
                end

                -- Sembunyikan kepala & aksesoris wajah agar tidak menghalangi pandangan
                -- (LocalTransparencyModifier hanya berlaku untuk kita sendiri, orang lain tetap melihat kepala kita)
                local char = LocalPlayer.Character
                if char then
                    local head = char:FindFirstChild("Head")
                    if head then
                        head.LocalTransparencyModifier = 1
                    end
                    -- Sembunyikan juga aksesoris yang menempel di kepala (hat, face, hair)
                    for _, obj in ipairs(char:GetChildren()) do
                        if obj:IsA("Accessory") then
                            local handle = obj:FindFirstChild("Handle")
                            if handle then
                                handle.LocalTransparencyModifier = 1
                            end
                        end
                    end
                end

                getgenv().KYS_fpWasSet = true
            elseif getgenv().KYS_fpWasSet then
                RestoreFirstPersonCamera()
            end
        elseif getgenv().KYS_fpWasSet then
            RestoreFirstPersonCamera()
        end
    end)
end)

-- =====================================================
-- VISUAL HIGHLIGHT ESP V2 (Player + World)
-- Stabil, anti double nametag, anti duplicate highlight, dan safe re-execute.
-- Kontrol ditambahkan ke tab Visual lewat getgenv().KYS_AddVisualESPControls.
-- =====================================================
do
    if getgenv().KYS_VD_VisualESP_Cleanup then
        pcall(getgenv().KYS_VD_VisualESP_Cleanup)
    end

    local LP = LocalPlayer
    local KYS_Dead = false
    local KYS_ControlsAdded = false

    local KYS_ESPState = {
        PlayerMasterESP = false,
        WorldMasterESP = false,
        ESPFillTransparency = 0.95,
        ESPOutlineTransparency = 0.3,
        ESPTextSize = 12,

        SurvivorESP = false,
        KillerESP = false,
        SpectatorESP = false,
        Nametags = false,
        DistanceESP = false,
        SurvivorItemsESP = false,

        SurvivorColor = Color3.fromRGB(0, 255, 0),
        KillerColor = Color3.fromRGB(255, 0, 0),
        SpectatorColor = Color3.fromRGB(255, 255, 255),

        GeneratorESP = false,
        HookESP = false,
        GateESP = false,
        WindowESP = false,
        PalletESP = false,
        SCPZombieESP = false,
        WorldNametags = false,
        WorldDistanceESP = false,

        GeneratorColor = Color3.fromRGB(0, 170, 255),
        HookColor = Color3.fromRGB(255, 0, 0),
        GateColor = Color3.fromRGB(255, 225, 0),
        WindowColor = Color3.fromRGB(255, 255, 255),
        PalletColor = Color3.fromRGB(255, 140, 0),
        SCPZombieColor = Color3.fromRGB(128, 0, 128),
    }

    getgenv().KYS_VD_VisualESP_State = KYS_ESPState

    KYS_WorldReg = {
        Generator = {},
        Hook = {},
        Gate = {},
        Window = {},
        Palletwrong = {},
        SCPZombie = {},
    }

    local KYS_MapAdd, KYS_MapRem = {}, {}
    local KYS_PlayerConns = {}
    local KYS_Connections = {}
    local KYS_PalletState = setmetatable({}, { __mode = "k" })
    local KYS_WindowState = setmetatable({}, { __mode = "k" })
    local KYS_InstanceIds = setmetatable({}, { __mode = "k" })
    local KYS_KystId = 0
    local KYS_PlayerLoopThread = nil
    local KYS_WorldLoopThread = nil
    local KYS_ESPFolder = nil

    local KYS_DisplayNames = {
        ["Motion Tracker"] = true,
        ["Gate"] = true,
        ["Flashlight"] = true,
        ["Bandage"] = true,
        ["Parrying Dagger"] = true,
        ["Adrenaline Shot"] = true,
        ["Twist of Fate"] = true,
        ["Shadow Clone"] = true,
        ["Holy Water"] = true,
        ["WaxBound Candle"] = true,
        ["Riot Shield"] = true,
        ["Emperor"] = true,
        ["AWP"] = true,
    }

    local function KYS_Alive(inst)
        if not inst then return false end
        local ok, parent = pcall(function() return inst.Parent end)
        return ok and parent ~= nil
    end

    local function KYS_Clamp(n, lo, hi)
        n = tonumber(n) or lo
        if n < lo then return lo end
        if n > hi then return hi end
        return n
    end

    local function KYS_PlayerKey(player)
        local id = player and player.UserId
        if id and id ~= 0 then return tostring(id) end
        return tostring(player and player.Name or "Unknown")
    end

    local function KYS_EspId(inst)
        if not inst then return "nil" end
        local id = KYS_InstanceIds[inst]
        if id then return id end
        KYS_KystId = KYS_KystId + 1
        id = tostring(KYS_KystId)
        KYS_InstanceIds[inst] = id
        return id
    end

    local function KYS_GetESPParent()
        local okCore, core = pcall(function() return game:GetService("CoreGui") end)
        if okCore and core then return core end
        if gethui then
            local okHui, hui = pcall(gethui)
            if okHui and hui then return hui end
        end
        local playerGui = LP and LP:FindFirstChildOfClass("PlayerGui")
        if playerGui then return playerGui end
        return Workspace
    end

    local function KYS_GetESPFolder()
        if KYS_ESPFolder and KYS_ESPFolder.Parent then
            return KYS_ESPFolder
        end

        local parent = KYS_GetESPParent()
        local old = parent:FindFirstChild("KysHub_VisualESP") or parent:FindFirstChild("ZiaanHub_ESP")
        if old then old:Destroy() end

        local folder = Instance.new("Folder")
        folder.Name = "KysHub_VisualESP"
        folder.Parent = parent
        KYS_ESPFolder = folder
        return folder
    end

    local function KYS_ClearPrefix(prefix, keepName)
        local folder = KYS_GetESPFolder()
        local keptExact = false
        for _, child in ipairs(folder:GetChildren()) do
            if child.Name:sub(1, #prefix) == prefix then
                if child.Name == keepName and not keptExact then
                    keptExact = true
                else
                    child:Destroy()
                end
            end
        end
    end

    local function KYS_SafeNotify(title, content, duration)
        pcall(function()
            if Window and Window.Notify then
                Window:Notify({
                    Title = title,
                    Content = content,
                    Duration = duration or 2,
                    Icon = "lucide:info",
                })
            end
        end)
    end

    local function KYS_ValidPart(part)
        return part and KYS_Alive(part) and part:IsA("BasePart")
    end

    local function KYS_FirstBasePart(inst)
        if not KYS_Alive(inst) then return nil end
        if inst:IsA("BasePart") then return inst end
        if inst:IsA("Model") then
            if inst.PrimaryPart and inst.PrimaryPart:IsA("BasePart") and KYS_Alive(inst.PrimaryPart) then
                return inst.PrimaryPart
            end
            local part = inst:FindFirstChildWhichIsA("BasePart", true)
            if KYS_ValidPart(part) then return part end
        end
        if inst:IsA("Tool") then
            local handle = inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")
            if KYS_ValidPart(handle) then return handle end
        end
        return nil
    end

    local function KYS_GetRole(player)
        local teamName = player.Team and player.Team.Name and player.Team.Name:lower() or ""
        if teamName:find("killer") then return "Killer" end
        if teamName:find("survivor") then return "Survivor" end
        if teamName:find("spect") then return "Spectator" end
        return "Survivor"
    end

    local function KYS_PlayerRoleEnabled(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerESP end
        if role == "Spectator" then return KYS_ESPState.SpectatorESP end
        return KYS_ESPState.SurvivorESP
    end

    local function KYS_PlayerColor(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerColor end
        if role == "Spectator" then return KYS_ESPState.SpectatorColor end
        return KYS_ESPState.SurvivorColor
    end

    getgenv().KYS_VD_VisualESP_HasPlayerText = function(player)
        if not player or player == LP then return false end
        return KYS_ESPState.PlayerMasterESP
            and KYS_PlayerRoleEnabled(player)
            and (KYS_ESPState.Nametags or KYS_ESPState.DistanceESP)
    end

    local function KYS_EnsureHighlight(name, adornee, color, isPlayer)
        if not (adornee and KYS_Alive(adornee)) then return nil end
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix(name, name)

        local hl = folder:FindFirstChild(name)
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = name
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = folder
        end

        hl.Adornee = adornee
        hl.FillColor = color
        hl.OutlineColor = color
        if isPlayer then
            hl.FillTransparency = KYS_ESPState.ESPFillTransparency
            hl.OutlineTransparency = KYS_ESPState.ESPOutlineTransparency
        else
            hl.FillTransparency = 0.98
            hl.OutlineTransparency = 0.5
        end
        hl.Enabled = true
        return hl
    end

    local function KYS_DestroyChild(name)
        local folder = KYS_GetESPFolder()
        local child = folder:FindFirstChild(name)
        if child then child:Destroy() end
    end

    local function KYS_ClearPlayerESP(player)
        if not player or player == LP then return end
        local key = KYS_PlayerKey(player)
        KYS_DestroyChild("KYS_PlayerHL_" .. key)
        KYS_DestroyChild("KYS_PlayerTag_" .. key)
        KYS_DestroyChild("KYS_PlayerItem_" .. key)
    end

    local function KYS_ClearAllPlayerESP()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                KYS_ClearPlayerESP(player)
            end
        end
    end

    local function KYS_GetSurvivorItem(player)
        local character = player.Character
        if not character then return nil end
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("Accessory") or obj:IsA("Model") then
                if KYS_DisplayNames[obj.Name] then
                    return obj.Name
                end
            end
        end
        return nil
    end

    local function KYS_GetItemImageId(itemName)
        local itemsFolder = ReplicatedStorage:FindFirstChild("Items")
        if not itemsFolder then return nil end
        local itemObj = itemsFolder:FindFirstChild(itemName)
        if not itemObj then return nil end

        if itemObj:IsA("Decal") or itemObj:IsA("Texture") then return itemObj.Texture end
        local texture = itemObj:FindFirstChildWhichIsA("Decal", true) or itemObj:FindFirstChildWhichIsA("Texture", true)
        if texture then return texture.Texture end
        local namedTexture = itemObj:FindFirstChild("Texture", true)
        if namedTexture and (namedTexture:IsA("Decal") or namedTexture:IsA("Texture")) then
            return namedTexture.Texture
        end
        return nil
    end

    local function KYS_SetBillboardLine(parent, index, count, data)
        local label = parent:FindFirstChild("Line" .. index)
        if not label then
            label = Instance.new("TextLabel")
            label.Name = "Line" .. index
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.Font = Enum.Font.Gotham
            label.TextStrokeTransparency = 0.65
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.Parent = parent
        end
        label.Size = UDim2.new(1, 0, 1 / count, 0)
        label.Position = UDim2.new(0, 0, (index - 1) / count, 0)
        label.TextSize = KYS_ESPState.ESPTextSize
        label.TextColor3 = data.Color
        label.Text = data.Text
    end

    local function KYS_PruneBillboardLines(parent, count)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextLabel") then
                local index = tonumber(child.Name:match("%d+"))
                if index and index > count then
                    child:Destroy()
                end
            end
        end
    end

    local function KYS_UpdatePlayerTag(player, character, head, color)
        local key = KYS_PlayerKey(player)
        local tagName = "KYS_PlayerTag_" .. key
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix("KYS_PlayerTag_" .. key, tagName)

        if not KYS_ValidPart(head) then
            KYS_DestroyChild(tagName)
            return
        end

        local lines = {}
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
        local distanceText = ""
        if KYS_ESPState.DistanceESP and root and targetRoot then
            distanceText = "[" .. tostring(math.floor((root.Position - targetRoot.Position).Magnitude)) .. "m]"
        end

        local nameText = KYS_ESPState.Nametags and player.Name or ""
        local mainLine = ""
        if nameText ~= "" and distanceText ~= "" then
            mainLine = nameText .. " " .. distanceText
        elseif nameText ~= "" then
            mainLine = nameText
        elseif distanceText ~= "" then
            mainLine = distanceText
        end

        if mainLine ~= "" then
            table.insert(lines, { Text = mainLine, Color = color })
        end

        if #lines == 0 then
            KYS_DestroyChild(tagName)
            return
        end

        local tag = folder:FindFirstChild(tagName)
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = tagName
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.MaxDistance = 0
            tag.Parent = folder
        end

        tag.Adornee = head
        tag.Enabled = true
        tag.Size = UDim2.new(0, 220, 0, #lines * 20)
        tag.StudsOffset = Vector3.new(0, 2.65, 0)

        for i, data in ipairs(lines) do
            KYS_SetBillboardLine(tag, i, #lines, data)
        end
        KYS_PruneBillboardLines(tag, #lines)
    end

    local function KYS_UpdatePlayerItemIcon(player, torso)
        local key = KYS_PlayerKey(player)
        local iconName = "KYS_PlayerItem_" .. key
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix("KYS_PlayerItem_" .. key, iconName)

        if not KYS_ValidPart(torso) then
            KYS_DestroyChild(iconName)
            return
        end

        local itemName = KYS_GetSurvivorItem(player)
        local imageId = itemName and KYS_GetItemImageId(itemName) or nil
        if not imageId then
            KYS_DestroyChild(iconName)
            return
        end

        local icon = folder:FindFirstChild(iconName)
        if not icon then
            icon = Instance.new("BillboardGui")
            icon.Name = iconName
            icon.AlwaysOnTop = true
            icon.LightInfluence = 0
            icon.MaxDistance = 0
            icon.Size = UDim2.fromOffset(20, 20)
            icon.StudsOffset = Vector3.new(0, 0, -1.6)
            icon.Parent = folder

            local image = Instance.new("ImageLabel")
            image.Name = "ImageLabel"
            image.BackgroundTransparency = 1
            image.Size = UDim2.fromScale(1, 1)
            image.Parent = icon
        end

        icon.Adornee = torso
        icon.Enabled = true
        local image = icon:FindFirstChild("ImageLabel")
        if image then image.Image = imageId end
    end

    local KYS_ApplyPlayerESP
    KYS_ApplyPlayerESP = function(player)
        if KYS_Dead or not player or player == LP then return end
        local character = player.Character
        if not (character and KYS_Alive(character)) then
            KYS_ClearPlayerESP(player)
            return
        end

        local key = KYS_PlayerKey(player)
        local enabled = KYS_ESPState.PlayerMasterESP and KYS_PlayerRoleEnabled(player)
        if not enabled then
            KYS_ClearPlayerESP(player)
            return
        end

        local color = KYS_PlayerColor(player)
        local head = character:FindFirstChild("Head")
        local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")

        KYS_EnsureHighlight("KYS_PlayerHL_" .. key, character, color, true)
        KYS_UpdatePlayerTag(player, character, head, color)

        if KYS_GetRole(player) == "Survivor" and KYS_ESPState.SurvivorItemsESP then
            KYS_UpdatePlayerItemIcon(player, torso)
        else
            KYS_DestroyChild("KYS_PlayerItem_" .. key)
        end
    end

    local function KYS_RefreshAllPlayers()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                pcall(KYS_ApplyPlayerESP, player)
            end
        end
    end

    local function KYS_StartPlayerLoop()
        if KYS_PlayerLoopThread then return end
        KYS_PlayerLoopThread = task.spawn(function()
            while not KYS_Dead and KYS_ESPState.PlayerMasterESP do
                KYS_RefreshAllPlayers()
                task.wait(0.25)
            end
            KYS_PlayerLoopThread = nil
        end)
    end

    local function KYS_WatchPlayer(player)
        if player == LP then return end
        if KYS_PlayerConns[player] then
            for _, conn in ipairs(KYS_PlayerConns[player]) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end

        KYS_PlayerConns[player] = {}
        table.insert(KYS_PlayerConns[player], player.CharacterAdded:Connect(function(char)
            KYS_ClearPlayerESP(player)
            task.delay(0.15, function()
                if not KYS_Dead then pcall(KYS_ApplyPlayerESP, player) end
            end)
        end))
        table.insert(KYS_PlayerConns[player], player.CharacterRemoving:Connect(function()
            KYS_ClearPlayerESP(player)
        end))
        table.insert(KYS_PlayerConns[player], player:GetPropertyChangedSignal("Team"):Connect(function()
            KYS_ClearPlayerESP(player)
            pcall(KYS_ApplyPlayerESP, player)
        end))

        if player.Character then
            pcall(KYS_ApplyPlayerESP, player)
        end
    end

    local function KYS_UnwatchPlayer(player)
        KYS_ClearPlayerESP(player)
        if KYS_PlayerConns[player] then
            for _, conn in ipairs(KYS_PlayerConns[player]) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end
        KYS_PlayerConns[player] = nil
    end

    local function KYS_PickWorldPart(model, cat)
        if not (model and KYS_Alive(model)) then return nil end
        if cat == "Generator" then
            local hitbox = model:FindFirstChild("HitBox", true) or model:FindFirstChild("GeneratorPoint", true)
            if KYS_ValidPart(hitbox) then return hitbox end
        elseif cat == "Palletwrong" then
            local candidates = {
                model:FindFirstChild("HumanoidRootPart", true),
                model:FindFirstChild("PrimaryPartPallet", true),
                model:FindFirstChild("Primary1", true),
                model:FindFirstChild("Primary2", true),
                model:FindFirstChild("PalletPoint", true),
                model:FindFirstChild("PalletPointSlide", true),
            }
            for _, part in ipairs(candidates) do
                if KYS_ValidPart(part) then return part end
            end
        elseif cat == "Window" then
            local vault = model:FindFirstChild("VaultPoint", true) or model:FindFirstChild("VaultTrigger", true)
            if KYS_ValidPart(vault) then return vault end
        elseif cat == "SCPZombie" then
            local root = model:FindFirstChild("HumanoidRootPart", true)
            if KYS_ValidPart(root) then return root end
            local torso = model:FindFirstChild("UpperTorso", true) or model:FindFirstChild("Torso", true)
            if KYS_ValidPart(torso) then return torso end
            return nil
        end
        return KYS_FirstBasePart(model)
    end

    local function KYS_GeneratorLabel(model)
        local pct = tonumber(model:GetAttribute("RepairProgress")) or 0
        if pct >= 0 and pct <= 1.001 then pct = pct * 100 end
        pct = KYS_Clamp(pct, 0, 100)

        local repairers = tonumber(model:GetAttribute("PlayersRepairingCount")) or 0
        local paused = model:GetAttribute("ProgressPaused") == true
        local kickcount = tonumber(model:GetAttribute("kickcount")) or 0
        local abyss50 = model:GetAttribute("Abyss50Triggered") == true

        local parts = { "Gen " .. tostring(math.floor(pct + 0.5)) .. "%" }
        if repairers > 0 then table.insert(parts, "(" .. repairers .. "p)") end
        if paused then table.insert(parts, "Pause") end
        if abyss50 then table.insert(parts, "Warn") end
        if kickcount > 0 then table.insert(parts, "K:" .. kickcount) end

        local hue = KYS_Clamp((pct / 100) * 0.33, 0, 0.33)
        return table.concat(parts, " "), Color3.fromHSV(hue, 1, 1)
    end

    local function KYS_HasBasePart(model)
        if not (model and KYS_Alive(model)) then return false end
        return model:FindFirstChildWhichIsA("BasePart", true) ~= nil
    end

    local function KYS_IsPalletGone(model)
        if not KYS_Alive(model) then return true end
        if not model:IsDescendantOf(Workspace) then return true end
        if KYS_PalletState[model] == "DEST" then return true end
        local ok, destroyed = pcall(function() return model:GetAttribute("Destroyed") end)
        if ok and destroyed == true then return true end
        return not KYS_HasBasePart(model)
    end

    local function KYS_WorldKey(cat, model)
        return "KYS_World_" .. cat .. "_" .. KYS_EspId(model)
    end

    local function KYS_ClearWorldVisual(cat, model)
        if not model then return end
        KYS_DestroyChild(KYS_WorldKey(cat, model) .. "_HL")
        KYS_DestroyChild(KYS_WorldKey(cat, model) .. "_Tag")
    end

    local function KYS_RemoveWorldEntry(cat, model)
        if not KYS_WorldReg[cat] or not KYS_WorldReg[cat][model] then return end
        KYS_ClearWorldVisual(cat, model)
        KYS_WorldReg[cat][model] = nil
    end

    local function KYS_EnsureWorldEntry(cat, model)
        if not KYS_Alive(model) or not KYS_WorldReg[cat] or KYS_WorldReg[cat][model] then return end
        if cat == "Palletwrong" and KYS_IsPalletGone(model) then return end
        local part = KYS_PickWorldPart(model, cat)
        if not KYS_ValidPart(part) then return end
        KYS_WorldReg[cat][model] = { part = part }
    end

    local function KYS_RegisterWorldDescendant(obj)
        if not KYS_Alive(obj) then return end
        local validCats = { Generator = true, Hook = true, Gate = true, Window = true, Palletwrong = true }

        if obj:IsA("Model") then
            if validCats[obj.Name] then
                KYS_EnsureWorldEntry(obj.Name, obj)
                return
            end
            local lower = obj.Name:lower()
            if lower:find("scp") or lower:find("zombie") then
                KYS_EnsureWorldEntry("SCPZombie", obj)
            end
            return
        end

        if obj:IsA("BasePart") then
            local parent = obj.Parent
            while parent and parent ~= Workspace do
                if parent:IsA("Model") then
                    if validCats[parent.Name] then
                        KYS_EnsureWorldEntry(parent.Name, parent)
                        return
                    end
                    local lower = parent.Name:lower()
                    if lower:find("scp") or lower:find("zombie") then
                        KYS_EnsureWorldEntry("SCPZombie", parent)
                        return
                    end
                end
                parent = parent.Parent
            end
        end
    end

    local function KYS_UnregisterWorldDescendant(obj)
        if not obj then return end
        local validCats = { Generator = true, Hook = true, Gate = true, Window = true, Palletwrong = true }

        if obj:IsA("Model") then
            if validCats[obj.Name] then
                KYS_RemoveWorldEntry(obj.Name, obj)
                return
            end
            local lower = obj.Name:lower()
            if lower:find("scp") or lower:find("zombie") then
                KYS_RemoveWorldEntry("SCPZombie", obj)
            end
            return
        end

        if obj:IsA("BasePart") then
            for cat, models in pairs(KYS_WorldReg) do
                for model, entry in pairs(models) do
                    if entry.part == obj then
                        KYS_RemoveWorldEntry(cat, model)
                    end
                end
            end
        end
    end

    local function KYS_AttachESPRoot(root)
        if not root or KYS_MapAdd[root] then return end
        KYS_MapAdd[root] = root.DescendantAdded:Connect(KYS_RegisterWorldDescendant)
        KYS_MapRem[root] = root.DescendantRemoving:Connect(KYS_UnregisterWorldDescendant)
        for _, descendant in ipairs(root:GetDescendants()) do
            KYS_RegisterWorldDescendant(descendant)
        end
    end

    local function KYS_RefreshESPRoots()
        for _, conn in pairs(KYS_MapAdd) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conn in pairs(KYS_MapRem) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        KYS_MapAdd, KYS_MapRem = {}, {}

        for cat, models in pairs(KYS_WorldReg) do
            for model in pairs(models) do
                KYS_ClearWorldVisual(cat, model)
            end
            KYS_WorldReg[cat] = {}
        end

        local map = Workspace:FindFirstChild("Map")
        local map1 = Workspace:FindFirstChild("Map1")
        if map then KYS_AttachESPRoot(map) end
        if map1 then KYS_AttachESPRoot(map1) end
    end

    local function KYS_LabelForPallet(model)
        local state = KYS_PalletState[model] or "UP"
        if state == "DOWN" then return "Pallet (down)" end
        if state == "DEST" then return "Pallet (destroyed)" end
        if state == "SLIDE" then return "Pallet (slide)" end
        return "Pallet"
    end

    local function KYS_LabelForWindow(model)
        local state = KYS_WindowState[model] or "READY"
        if state == "BUSY" then return "Window (busy)" end
        return "Window"
    end

    local function KYS_AnyWorldEnabled()
        return KYS_ESPState.WorldMasterESP and (
            KYS_ESPState.GeneratorESP or
            KYS_ESPState.HookESP or
            KYS_ESPState.GateESP or
            KYS_ESPState.WindowESP or
            KYS_ESPState.PalletESP or
            KYS_ESPState.SCPZombieESP
        )
    end

    local function KYS_WorldCategoryData(cat)
        if cat == "Generator" then return KYS_ESPState.GeneratorESP, KYS_ESPState.GeneratorColor end
        if cat == "Hook" then return KYS_ESPState.HookESP, KYS_ESPState.HookColor end
        if cat == "Gate" then return KYS_ESPState.GateESP, KYS_ESPState.GateColor end
        if cat == "Window" then return KYS_ESPState.WindowESP, KYS_ESPState.WindowColor end
        if cat == "Palletwrong" then return KYS_ESPState.PalletESP, KYS_ESPState.PalletColor end
        if cat == "SCPZombie" then return KYS_ESPState.SCPZombieESP, KYS_ESPState.SCPZombieColor end
        return false, Color3.new(1, 1, 1)
    end

    local function KYS_UpdateWorldTag(cat, model, part, color)
        local key = KYS_WorldKey(cat, model)
        local tagName = key .. "_Tag"
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix(tagName, tagName)

        if not KYS_ValidPart(part) then
            KYS_DestroyChild(tagName)
            return
        end

        local lines = {}
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local distanceText = ""
        if KYS_ESPState.WorldDistanceESP and root then
            distanceText = "[" .. tostring(math.floor((root.Position - part.Position).Magnitude)) .. "m]"
        end

        local nameText = ""
        local labelColor = color
        if KYS_ESPState.WorldNametags then
            if cat == "Generator" then
                local txt, genColor = KYS_GeneratorLabel(model)
                nameText = txt
                labelColor = genColor
            elseif cat == "Palletwrong" then
                nameText = KYS_LabelForPallet(model)
            elseif cat == "Window" then
                nameText = KYS_LabelForWindow(model)
            elseif cat == "SCPZombie" then
                nameText = model.Name
            else
                nameText = cat
            end
        end

        local mainLine = ""
        if nameText ~= "" and distanceText ~= "" then
            mainLine = nameText .. " " .. distanceText
        elseif nameText ~= "" then
            mainLine = nameText
        elseif distanceText ~= "" then
            mainLine = distanceText
        end

        if mainLine ~= "" then
            table.insert(lines, { Text = mainLine, Color = labelColor })
        end

        if #lines == 0 then
            KYS_DestroyChild(tagName)
            return
        end

        local tag = folder:FindFirstChild(tagName)
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = tagName
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.MaxDistance = 0
            tag.Parent = folder
        end

        tag.Adornee = part
        tag.Enabled = true
        tag.Size = UDim2.new(0, 220, 0, #lines * 20)
        tag.StudsOffset = Vector3.new(0, 2.5, 0)

        for i, data in ipairs(lines) do
            KYS_SetBillboardLine(tag, i, #lines, data)
        end
        KYS_PruneBillboardLines(tag, #lines)
    end

    local function KYS_ClearAllWorldESP()
        for cat, models in pairs(KYS_WorldReg) do
            for model in pairs(models) do
                KYS_ClearWorldVisual(cat, model)
            end
        end
    end

    local function KYS_StartWorldLoop()
        if KYS_WorldLoopThread then return end
        KYS_WorldLoopThread = task.spawn(function()
            while not KYS_Dead and KYS_AnyWorldEnabled() do
                for cat, models in pairs(KYS_WorldReg) do
                    local enabled, color = KYS_WorldCategoryData(cat)
                    if enabled and KYS_ESPState.WorldMasterESP then
                        local n = 0
                        for model, entry in pairs(models) do
                            if cat == "Palletwrong" and KYS_IsPalletGone(model) then
                                KYS_RemoveWorldEntry(cat, model)
                            elseif model and KYS_Alive(model) then
                                local part = entry.part
                                if not KYS_ValidPart(part) or (model:IsA("Model") and not part:IsDescendantOf(model)) then
                                    entry.part = KYS_PickWorldPart(model, cat)
                                    part = entry.part
                                end

                                if KYS_ValidPart(part) then
                                    local key = KYS_WorldKey(cat, model)
                                    KYS_EnsureHighlight(key .. "_HL", model, color, false)
                                    KYS_UpdateWorldTag(cat, model, part, color)
                                else
                                    KYS_RemoveWorldEntry(cat, model)
                                end
                            else
                                KYS_RemoveWorldEntry(cat, model)
                            end

                            n = n + 1
                            if n % 60 == 0 then task.wait() end
                        end
                    else
                        for model in pairs(models) do
                            KYS_ClearWorldVisual(cat, model)
                        end
                    end
                end
                task.wait(0.25)
            end
            KYS_WorldLoopThread = nil
        end)
    end

    local function KYS_Selected(selected, name)
        if type(selected) ~= "table" then return false end
        if selected[name] ~= nil then return selected[name] == true end
        for _, value in pairs(selected) do
            if value == name then return true end
        end
        return false
    end

    getgenv().KYS_AddVisualESPControls = function(VisualTabRef)
        if not VisualTabRef or KYS_ControlsAdded then return end
        KYS_ControlsAdded = true

        local settingsSection = VisualTabRef:AddSection({
            Position = "Center",
            Name = "Highlight ESP Settings",
            Icon = "solar:settings-bold",
            Box = true,
            BoxBorder = true,
            Opened = false,
        })

        settingsSection:AddSlider({
            Name = "ESP Fill Transparency",
            Flag = "KYS ESP Fill Transparency",
            Min = 0,
            Max = 1,
            Default = KYS_ESPState.ESPFillTransparency,
            Increment = 0.01,
            Callback = function(value)
                KYS_ESPState.ESPFillTransparency = value
                KYS_RefreshAllPlayers()
            end,
        })

        settingsSection:AddSlider({
            Name = "ESP Outline Transparency",
            Flag = "KYS ESP Outline Transparency",
            Min = 0,
            Max = 1,
            Default = KYS_ESPState.ESPOutlineTransparency,
            Increment = 0.01,
            Callback = function(value)
                KYS_ESPState.ESPOutlineTransparency = value
                KYS_RefreshAllPlayers()
            end,
        })

        settingsSection:AddSlider({
            Name = "ESP Text Size",
            Flag = "KYS ESP Text Size",
            Min = 8,
            Max = 22,
            Default = KYS_ESPState.ESPTextSize,
            Increment = 1,
            Callback = function(value)
                KYS_ESPState.ESPTextSize = value
                KYS_RefreshAllPlayers()
            end,
        })

        local playerSection = VisualTabRef:AddSection({
            Position = "Center",
            Name = "Player Highlight ESP",
            Icon = "solar:users-group-rounded-bold",
            Box = true,
            BoxBorder = true,
            Opened = false,
        })

        playerSection:AddToggle({
            Name = "Enable Player ESP",
            Flag = "KYS Enable Player ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.PlayerMasterESP = state
                if state then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddDropdown({
            Name = "Select Player ESP",
            Flag = "KYS Select Player ESP",
            Values = { "Survivor ESP", "Killer ESP", "Spectator ESP", "Survivor Items ESP" },
            Multi = true,
            AllowNone = true,
            Default = {},
            Callback = function(selected)
                KYS_ESPState.SurvivorESP = KYS_Selected(selected, "Survivor ESP")
                KYS_ESPState.KillerESP = KYS_Selected(selected, "Killer ESP")
                KYS_ESPState.SpectatorESP = KYS_Selected(selected, "Spectator ESP")
                KYS_ESPState.SurvivorItemsESP = KYS_Selected(selected, "Survivor Items ESP")

                if KYS_ESPState.PlayerMasterESP then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddToggle({
            Name = "Player Nametags",
            Flag = "KYS Player Nametags",
            Default = false,
            Callback = function(state)
                KYS_ESPState.Nametags = state
                if KYS_ESPState.PlayerMasterESP then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddToggle({
            Name = "Player Distance ESP",
            Flag = "KYS Player Distance ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.DistanceESP = state
                if KYS_ESPState.PlayerMasterESP then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddToggle({
            Name = "Survivor Killer Warning (!)",
            Flag = "Survivor Killer Warning",
            Default = false,
            Callback = function(state)
                VD.SURV_WarnKiller = state
            end,
        })

        pcall(function() playerSection:AddDivider({ Text = "Colors" }) end)
        playerSection:AddColorPicker({ Name = "Survivor Color", Flag = "KYS Survivor Color", Default = KYS_ESPState.SurvivorColor, Callback = function(color) KYS_ESPState.SurvivorColor = color; KYS_RefreshAllPlayers() end })
        playerSection:AddColorPicker({ Name = "Killer Color", Flag = "KYS Killer Color", Default = KYS_ESPState.KillerColor, Callback = function(color) KYS_ESPState.KillerColor = color; KYS_RefreshAllPlayers() end })
        playerSection:AddColorPicker({ Name = "Spectator Color", Flag = "KYS Spectator Color", Default = KYS_ESPState.SpectatorColor, Callback = function(color) KYS_ESPState.SpectatorColor = color; KYS_RefreshAllPlayers() end })

        local worldSection = VisualTabRef:AddSection({
            Position = "Center",
            Name = "World Highlight ESP",
            Icon = "solar:map-point-wave-bold",
            Box = true,
            BoxBorder = true,
            Opened = false,
        })

        worldSection:AddToggle({
            Name = "Enable World ESP",
            Flag = "KYS Enable World ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.WorldMasterESP = state
                if state then
                    KYS_RefreshESPRoots()
                    if KYS_AnyWorldEnabled() then KYS_StartWorldLoop() end
                else
                    KYS_ClearAllWorldESP()
                end
            end,
        })

        worldSection:AddDropdown({
            Name = "Select World Objects",
            Flag = "KYS Select World Objects",
            Values = { "Generators", "Hooks", "Gates", "Windows", "Pallets", "SCP / Zombie" },
            Multi = true,
            AllowNone = true,
            Default = {},
            Callback = function(selected)
                KYS_ESPState.GeneratorESP = KYS_Selected(selected, "Generators")
                KYS_ESPState.HookESP = KYS_Selected(selected, "Hooks")
                KYS_ESPState.GateESP = KYS_Selected(selected, "Gates")
                KYS_ESPState.WindowESP = KYS_Selected(selected, "Windows")
                KYS_ESPState.PalletESP = KYS_Selected(selected, "Pallets")
                KYS_ESPState.SCPZombieESP = KYS_Selected(selected, "SCP / Zombie")

                if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then
                    KYS_RefreshESPRoots()
                    KYS_StartWorldLoop()
                else
                    KYS_ClearAllWorldESP()
                end
            end,
        })

        worldSection:AddToggle({
            Name = "World Nametags",
            Flag = "KYS World Nametags",
            Default = false,
            Callback = function(state)
                KYS_ESPState.WorldNametags = state
                if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() else KYS_ClearAllWorldESP() end
            end,
        })

        worldSection:AddToggle({
            Name = "World Distance ESP",
            Flag = "KYS World Distance ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.WorldDistanceESP = state
                if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() else KYS_ClearAllWorldESP() end
            end,
        })

        pcall(function() worldSection:AddDivider({ Text = "Colors" }) end)
        worldSection:AddColorPicker({ Name = "Generator Color", Flag = "KYS Generator Color", Default = KYS_ESPState.GeneratorColor, Callback = function(color) KYS_ESPState.GeneratorColor = color end })
        worldSection:AddColorPicker({ Name = "Hook Color", Flag = "KYS Hook Color", Default = KYS_ESPState.HookColor, Callback = function(color) KYS_ESPState.HookColor = color end })
        worldSection:AddColorPicker({ Name = "Gate Color", Flag = "KYS Gate Color", Default = KYS_ESPState.GateColor, Callback = function(color) KYS_ESPState.GateColor = color end })
        worldSection:AddColorPicker({ Name = "Window Color", Flag = "KYS Window Color", Default = KYS_ESPState.WindowColor, Callback = function(color) KYS_ESPState.WindowColor = color end })
        worldSection:AddColorPicker({ Name = "Pallet Color", Flag = "KYS Pallet Color", Default = KYS_ESPState.PalletColor, Callback = function(color) KYS_ESPState.PalletColor = color end })
        worldSection:AddColorPicker({ Name = "SCP / Zombie Color", Flag = "KYS SCP Zombie Color", Default = KYS_ESPState.SCPZombieColor, Callback = function(color) KYS_ESPState.SCPZombieColor = color end })
    end

    for _, player in ipairs(Players:GetPlayers()) do
        KYS_WatchPlayer(player)
    end

    table.insert(KYS_Connections, Players.PlayerAdded:Connect(KYS_WatchPlayer))
    table.insert(KYS_Connections, Players.PlayerRemoving:Connect(KYS_UnwatchPlayer))
    table.insert(KYS_Connections, Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" or child.Name == "Map1" then
            KYS_AttachESPRoot(child)
            if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() end
        end
    end))
    table.insert(KYS_Connections, Workspace.ChildRemoved:Connect(function(child)
        if child.Name == "Map" or child.Name == "Map1" then
            KYS_RefreshESPRoots()
        end
    end))

    KYS_RefreshESPRoots()

    getgenv().KYS_VD_VisualESP_Cleanup = function()
        KYS_Dead = true
        KYS_ClearAllPlayerESP()
        KYS_ClearAllWorldESP()

        for _, conn in ipairs(KYS_Connections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conns in pairs(KYS_PlayerConns) do
            for _, conn in ipairs(conns) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end
        for _, conn in pairs(KYS_MapAdd) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conn in pairs(KYS_MapRem) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        if KYS_ESPFolder and KYS_ESPFolder.Parent then
            KYS_ESPFolder:Destroy()
        end
    end

    KYS_SafeNotify("Visual ESP", "Highlight ESP V2 loaded. Anti double nametag aktif.", 3)
end



-- =====================================================
-- FULLBRIGHT
-- =====================================================
task.spawn(function()
    while not VD.Destroyed do
        if VD.Fullbright then
            local weatherTheme = VD.VIS_WeatherTheme and KYS_WeatherPresets[VD.VIS_WeatherTheme]
            local keepWeatherLighting = VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" and weatherTheme and weatherTheme.Lighting
            if keepWeatherLighting then
                for k, v in pairs(weatherTheme.Lighting) do
                    pcall(function() Lighting[k] = v end)
                end
                Lighting.Brightness = math.max(Lighting.Brightness, 2)
                Lighting.GlobalShadows = false
                if VD.NO_Fog then
                    Lighting.FogStart = 0
                    Lighting.FogEnd = 100000
                end
            else
                Lighting.Brightness     = 2
                Lighting.ClockTime      = 14
                Lighting.GlobalShadows  = false
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                Lighting.FogStart       = 0
                Lighting.FogEnd         = 100000
            end
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") and v.Name ~= "VD_WeatherAtmosphere" then
                    v.Density = 0; v.Offset = 0; v.Glare = 0; v.Haze = 0
                end
                if v:IsA("BlurEffect") then v.Size = 0 end
                if v:IsA("ColorCorrectionEffect") and v.Name ~= "VD_WeatherCC" then v.Enabled = false end
                if v:IsA("SunRaysEffect") then v.Enabled = false end
            end
        else
            if VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" and KYS_WeatherPresets[VD.VIS_WeatherTheme] then
                local theme = KYS_WeatherPresets[VD.VIS_WeatherTheme]
                if theme.Lighting then
                    for k, v in pairs(theme.Lighting) do
                        pcall(function() Lighting[k] = v end)
                    end
                end
            else
                Lighting.Brightness     = originalLighting.Brightness
                Lighting.ClockTime      = originalLighting.ClockTime
                Lighting.FogEnd         = originalLighting.FogEnd
                Lighting.FogStart       = originalLighting.FogStart or 0
                Lighting.GlobalShadows  = originalLighting.GlobalShadows
                Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Atmosphere") and originalLighting.Atmosphere then
                        v.Density = originalLighting.Atmosphere.Density or 0.3
                        v.Offset  = originalLighting.Atmosphere.Offset or 0.25
                        v.Glare   = originalLighting.Atmosphere.Glare or 0
                        v.Haze    = originalLighting.Atmosphere.Haze or 0
                    end
                    if v:IsA("BlurEffect") and originalLighting.Blur then v.Size = originalLighting.Blur.Size or 0 end
                    if v:IsA("ColorCorrectionEffect") and originalLighting.ColorCorrection then
                        v.Enabled = originalLighting
                            .ColorCorrection.Enabled or false
                    end
                    if v:IsA("SunRaysEffect") and originalLighting.SunRays then
                        v.Enabled = originalLighting.SunRays.Enabled or
                            false
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- =====================================================-- =====================================================
-- MOVEMENT & NOCLIP
-- =====================================================
local originalCanCollide = {}

RunService.Stepped:Connect(function()
    if VD.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, descendant in ipairs(char:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    if originalCanCollide[descendant] == nil then
                        originalCanCollide[descendant] = descendant.CanCollide
                    end
                    descendant.CanCollide = false
                end
            end
        end
    end
end)

getgenv().VD_DisableNoclip = function()
    for part, canCollide in pairs(originalCanCollide) do
        if part and part.Parent then
            pcall(function() part.CanCollide = canCollide end)
        end
    end
    originalCanCollide = {}
end

LocalPlayer.CharacterRemoving:Connect(function(char)
    if char == LocalPlayer.Character then
        originalCanCollide = {}
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if myHum then
        if VD.Speed and myHum.WalkSpeed ~= VD.SpeedValue then myHum.WalkSpeed = VD.SpeedValue end
        if VD.Jump and myHum.JumpPower ~= VD.JumpValue then myHum.JumpPower = VD.JumpValue end
    end

end)

UserInputService.JumpRequest:Connect(function()
    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if VD.InfiniteJump and myHum then
        myHum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- =====================================================
-- HIDE SKILL CHECK UI
-- =====================================================
local cachedPlayerGui = LocalPlayer:WaitForChild("PlayerGui")
RunService.RenderStepped:Connect(function()
    if VD.HideSkillUI then
        if not cachedPlayerGui then cachedPlayerGui = LocalPlayer:FindFirstChild("PlayerGui") end
        local a = cachedPlayerGui and cachedPlayerGui:FindFirstChild("SkillCheckPromptGui")
        local b = cachedPlayerGui and cachedPlayerGui:FindFirstChild("SkillCheckPromptGui-con")
        if a and a.Enabled then a.Enabled = false end
        if b and b.Enabled then b.Enabled = false end
    end
end)

-- =====================================================
-- AUTO PARRY + AUTO SKILLCHECK (ported from survivor)
-- =====================================================
function VD_Notify(title, content, duration)
    pcall(function()
        if Window and Window.Notify then
            Window:Notify({
                Title = title,
                Content = content,
                Duration = duration or 2,
                Icon = "lucide:info",
            })
        end
    end)
end

-- =====================================================
-- SILENT AIM: TWIST OF FATE
-- =====================================================
(function()
local KYS_ToFState = {
    Connection = nil,
    LaserBeam = nil,
    TargetGui = nil,
    InputBegan = nil,
    InputEnded = nil,
    TouchInput = nil,
    IsAiming = false,
    SavedUIPos = UDim2.new(0.5, -120, 0, 110),
    SCPCache = {},
    SCPCacheTimer = 0,
}

local KYS_ToFKeyCodes = {
    None = nil,
    Q = Enum.KeyCode.Q,
    E = Enum.KeyCode.E,
    R = Enum.KeyCode.R,
    T = Enum.KeyCode.T,
    F = Enum.KeyCode.F,
    G = Enum.KeyCode.G,
    H = Enum.KeyCode.H,
    J = Enum.KeyCode.J,
    K = Enum.KeyCode.K,
    L = Enum.KeyCode.L,
    X = Enum.KeyCode.X,
    Z = Enum.KeyCode.Z,
}

local function KYS_ToFGetEvent()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local tof = items and items:FindFirstChild("Twist of Fate")
    local fire = tof and tof:FindFirstChild("Fire")
    if fire and fire:IsA("RemoteEvent") then
        return fire
    end
    return nil
end

local function KYS_ToFGetGunObject()
    local char = LocalPlayer.Character
    if not char then return nil end

    local baseToF = char:FindFirstChild("Twist of Fate", true)
    if not baseToF then return nil end

    local rightArm = baseToF:FindFirstChild("Right Arm")
    if rightArm then
        local gunPart = rightArm:FindFirstChild("gun")
        if gunPart then return gunPart end

        local emperorGun = rightArm:FindFirstChild("EmperorGun")
        if emperorGun then return emperorGun end
    end

    return baseToF
end

local function KYS_ToFIsTargetVisible(originPos, targetPos, targetCharacter)
    local direction = targetPos - originPos
    local distance = direction.Magnitude
    if distance < 0.1 then return true end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local excludeList = {}
    local localChar = LocalPlayer.Character
    if localChar then table.insert(excludeList, localChar) end
    if targetCharacter and targetCharacter ~= localChar then table.insert(excludeList, targetCharacter) end
    if KYS_ToFState.LaserBeam then table.insert(excludeList, KYS_ToFState.LaserBeam) end

    rayParams.FilterDescendantsInstances = excludeList

    local result = workspace:Raycast(originPos, direction.Unit * distance, rayParams)
    return result == nil
end

local function KYS_ToFGetSCPs()
    if tick() - KYS_ToFState.SCPCacheTimer < 0.5 then
        return KYS_ToFState.SCPCache
    end

    local newTargets = {}
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        for _, container in pairs(mapFolder:GetDescendants()) do
            if container:IsA("Model") then
                local attributes = container:GetAttributes()
                if container:GetAttribute("CorpseCreated0492") or next(attributes) ~= nil then
                    local root = container:FindFirstChild("HumanoidRootPart")
                    if root then table.insert(newTargets, root) end
                end
            end
        end
    end

    KYS_ToFState.SCPCache = newTargets
    KYS_ToFState.SCPCacheTimer = tick()
    return KYS_ToFState.SCPCache
end

local function KYS_ToFGetTargetPosition()
    local gunObj = KYS_ToFGetGunObject()
    local char = LocalPlayer.Character
    if not (gunObj and char) then return nil, nil, nil, nil end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil, nil, nil end

    local myPos = hrp.Position
    local originPos
    if char:GetAttribute("IsCarried") then
        originPos = hrp.Position + (hrp.CFrame.LookVector * 2)
    else
        pcall(function()
            originPos = gunObj:IsA("BasePart") and gunObj.Position
                or (gunObj:FindFirstChildOfClass("BasePart") and gunObj:FindFirstChildOfClass("BasePart").Position)
        end)
        originPos = originPos or Vector3.new(myPos.X, myPos.Y + 1.5, myPos.Z)
    end

    local function predictTarget(torso, targetCharacter)
        local targetPos = torso.Position
        if VD.TOF_WallCheck and not KYS_ToFIsTargetVisible(originPos, targetPos, targetCharacter) then
            return nil, nil, nil, nil
        end

        local targetVel = Vector3.new(0, 0, 0)
        local rootPart = targetCharacter and (targetCharacter:FindFirstChild("HumanoidRootPart") or torso)
        if rootPart then targetVel = rootPart.Velocity end

        local directionRaw = targetPos - originPos
        local distance = directionRaw.Magnitude
        if distance < 0.1 then return nil, nil, nil, nil end
        if distance < 5 then return directionRaw.Unit, gunObj, originPos, targetPos end

        local travelTime = distance / 400
        local predictedPos = targetPos + (targetVel * travelTime)
        for _ = 1, 2 do
            local newDist = (predictedPos - originPos).Magnitude
            travelTime = newDist / 400
            predictedPos = targetPos + (targetVel * travelTime)
        end

        local finalDirection = predictedPos - originPos
        if finalDirection.Magnitude < 0.1 then return nil, nil, nil, nil end

        return finalDirection.Unit, gunObj, originPos, predictedPos
    end

    local targetMode = VD.TOF_TargetMode or "Killer"
    if targetMode == "Killer" then
        local closestTorso, closestChar, shortestDist = nil, nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team and player.Team.Name == "Killer" and player.Character then
                local torso = player.Character:FindFirstChild("Torso")
                    or player.Character:FindFirstChild("UpperTorso")
                    or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local dist = (myPos - torso.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTorso = torso
                        closestChar = player.Character
                    end
                end
            end
        end
        if not closestTorso then return nil, nil, nil, nil end
        return predictTarget(closestTorso, closestChar)
    elseif targetMode == "Survivors" then
        local bestTorso, bestChar, bestDot = nil, nil, -math.huge
        local cam = workspace.CurrentCamera
        local camLook = cam.CFrame.LookVector

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                local torso = player.Character:FindFirstChild("Torso")
                    or player.Character:FindFirstChild("UpperTorso")
                    or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local dirToTarget = torso.Position - cam.CFrame.Position
                    if dirToTarget.Magnitude > 0.1 then
                        local dot = camLook:Dot(dirToTarget.Unit)
                        if dot > 0.5 and dot > bestDot then
                            bestDot = dot
                            bestTorso = torso
                            bestChar = player.Character
                        end
                    end
                end
            end
        end
        if not bestTorso then return nil, nil, nil, nil end
        return predictTarget(bestTorso, bestChar)
    elseif targetMode == "Zombie" then
        local bestPart, bestDot = nil, -math.huge
        local cam = workspace.CurrentCamera
        local camLook = cam.CFrame.LookVector

        for _, root in ipairs(KYS_ToFGetSCPs()) do
            if root and root.Parent then
                local dirToTarget = root.Position - cam.CFrame.Position
                if dirToTarget.Magnitude > 0.1 then
                    local dot = camLook:Dot(dirToTarget.Unit)
                    if dot > 0.5 and dot > bestDot then
                        bestDot = dot
                        bestPart = root
                    end
                end
            end
        end
        if not bestPart then return nil, nil, nil, nil end
        return predictTarget(bestPart, bestPart.Parent)
    end

    return nil, nil, nil, nil
end

local function KYS_ToFUpdateLaser(originPos, targetPos)
    if not KYS_ToFState.LaserBeam then
        local laser = Instance.new("Part")
        laser.Name = "ToFLaser"
        laser.Anchored = true
        laser.CanCollide = false
        laser.CanTouch = false
        laser.CastShadow = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(255, 50, 50)
        laser.Parent = workspace
        KYS_ToFState.LaserBeam = laser
    end

    local dist = (targetPos - originPos).Magnitude
    KYS_ToFState.LaserBeam.Size = Vector3.new(0.05, 0.05, dist)
    KYS_ToFState.LaserBeam.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
    KYS_ToFState.LaserBeam.Transparency = 0
end

local function KYS_ToFClearLaser()
    if KYS_ToFState.LaserBeam then
        pcall(function() KYS_ToFState.LaserBeam:Destroy() end)
        KYS_ToFState.LaserBeam = nil
    end
end

local AimConfig = {
    Pistol_BlockKnocked = true,
}

local function IsDowned(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local state = char:GetAttribute("State")
    return state == "Downed" or state == "Dead"
end

local function KYS_ToFGetMobileShootButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local survivorMob = playerGui and playerGui:FindFirstChild("Survivor-mob")
    local controls = survivorMob and survivorMob:FindFirstChild("Controls")
    local guiMob = controls and controls:FindFirstChild("Gui-mob")
    if not guiMob then return nil end

    local directNames = { "attack", "Attack", "shoot", "Shoot", "fire", "Fire" }
    for _, name in ipairs(directNames) do
        local btn = guiMob:FindFirstChild(name, true)
        if btn and btn:IsA("GuiObject") then return btn end
    end

    for _, obj in ipairs(guiMob:GetDescendants()) do
        if obj:IsA("GuiButton") and obj.Visible then
            return obj
        end
    end

    return guiMob:IsA("GuiObject") and guiMob or nil
end

local function KYS_ToFIsTouchOnShootButton(input)
    local shootButton = KYS_ToFGetMobileShootButton()
    if not (shootButton and shootButton.Visible) then return false end

    local pos = input.Position
    local absPos = shootButton.AbsolutePosition
    local absSize = shootButton.AbsoluteSize

    return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
        and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
end

local function KYS_ToFDoShoot()
    if not VD.TOF_SilentAim then return end

    AimConfig.Pistol_BlockKnocked = VD.TOF_BlockKnocked ~= false
    local char = LocalPlayer.Character
    if char then
        if AimConfig.Pistol_BlockKnocked and IsDowned(char) then
            return
        end
    end

    local targetDirection, gunObject, originPos, targetPos = KYS_ToFGetTargetPosition()
    if not (targetDirection and gunObject and targetPos and originPos) then return end

    local tofEvent = KYS_ToFGetEvent()
    if not tofEvent then return end

    local freshDirection = targetPos - originPos
    if freshDirection.Magnitude < 0.1 then return end

    pcall(function()
        tofEvent:FireServer(gunObject, freshDirection.Unit)
    end)
end

local KYS_ToFModeButtons = {}
local function KYS_ToFRefreshTargetButtons()
    local modes = {
        Killer = { Color3.fromRGB(180, 45, 45), Color3.fromRGB(255, 180, 180) },
        Survivors = { Color3.fromRGB(25, 80, 150), Color3.fromRGB(160, 210, 255) },
        Zombie = { Color3.fromRGB(120, 80, 10), Color3.fromRGB(255, 210, 100) },
    }

    for modeName, btn in pairs(KYS_ToFModeButtons) do
        if btn and btn.Parent then
            local active = modeName == (VD.TOF_TargetMode or "Killer")
            local colors = modes[modeName]
            btn.BackgroundColor3 = active and colors[1] or Color3.fromRGB(30, 32, 40)
            btn.TextColor3 = active and colors[2] or Color3.fromRGB(155, 160, 175)
        end
    end
end

local function KYS_ToFSetTargetMode(modeName, notify)
    if modeName ~= "Killer" and modeName ~= "Survivors" and modeName ~= "Zombie" then return end
    VD.TOF_TargetMode = modeName
    KYS_ToFRefreshTargetButtons()
    if notify then VD_Notify("Target Mode", modeName, 1) end
end

local function KYS_ToFCreateTargetSelectorUI()
    local parent = GetSafeGuiParent()
    if not parent then return end
    if KYS_ToFState.TargetGui and KYS_ToFState.TargetGui.Parent then return end

    local old = parent:FindFirstChild("ToFTargetSelector")
    if old then pcall(function() old:Destroy() end) end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ToFTargetSelector"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 180, 0, 126)
    frame.Position = KYS_ToFState.SavedUIPos
    frame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(96, 72, 160)
    stroke.Thickness = 1

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    header.BorderSizePixel = 0
    header.Parent = frame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 10)
    headerFix.Position = UDim2.new(0, 0, 1, -10)
    headerFix.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local headerDiv = Instance.new("Frame")
    headerDiv.Size = UDim2.new(1, 0, 0, 1)
    headerDiv.Position = UDim2.new(0, 0, 1, -1)
    headerDiv.BackgroundColor3 = Color3.fromRGB(48, 42, 72)
    headerDiv.BorderSizePixel = 0
    headerDiv.Parent = header

    local dragArea = Instance.new("Frame")
    dragArea.Size = UDim2.new(1, -34, 1, 0)
    dragArea.BackgroundTransparency = 1
    dragArea.Parent = header

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 28, 1, 0)
    minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(185, 190, 205)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 14
    minimizeBtn.Parent = header

    local headerLbl = Instance.new("TextLabel")
    headerLbl.Size = UDim2.new(1, -44, 1, 0)
    headerLbl.Position = UDim2.new(0, 10, 0, 0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.Text = "TOF TARGET MODE"
    headerLbl.TextColor3 = Color3.fromRGB(210, 215, 230)
    headerLbl.Font = Enum.Font.GothamBold
    headerLbl.TextSize = 10
    headerLbl.TextXAlignment = Enum.TextXAlignment.Left
    headerLbl.Parent = header

    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, -16, 0, 86)
    btnContainer.Position = UDim2.new(0, 8, 0, 34)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = frame

    local layout = Instance.new("UIListLayout", btnContainer)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        minimizeBtn.Text = isMinimized and "+" or "-"
        btnContainer.Visible = not isMinimized
        frame.Size = isMinimized and UDim2.new(0, 180, 0, 28) or UDim2.new(0, 180, 0, 126)
    end)

    local modes = {
        { Internal = "Killer", Display = "KILLER        K" },
        { Internal = "Survivors", Display = "SURVIVOR      J" },
        { Internal = "Zombie", Display = "ZOMBIE        L" },
    }

    KYS_ToFModeButtons = {}
    for i, mode in ipairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Text = mode.Display
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.LayoutOrder = i
        btn.Parent = btnContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(58, 62, 78)
        btnStroke.Thickness = 1

        btn.MouseButton1Click:Connect(function()
            KYS_ToFSetTargetMode(mode.Internal, false)
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                KYS_ToFSetTargetMode(mode.Internal, false)
            end
        end)

        KYS_ToFModeButtons[mode.Internal] = btn
    end
    KYS_ToFRefreshTargetButtons()

    local dragging = false
    local dragStart, startPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = frame.Position
            dragging = true
        end
    end)
    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            frame.Position = newPos
            KYS_ToFState.SavedUIPos = newPos
        end
    end)

    KYS_ToFState.TargetGui = gui
end

local function KYS_ToFDestroyTargetSelectorUI()
    if KYS_ToFState.TargetGui then
        pcall(function() KYS_ToFState.TargetGui:Destroy() end)
        KYS_ToFState.TargetGui = nil
    end
    KYS_ToFModeButtons = {}
end

local function KYS_ToFStartConnection()
    if KYS_ToFState.Connection then return end
    KYS_ToFState.Connection = RunService.Heartbeat:Connect(function()
        if not VD.TOF_SilentAim or not KYS_ToFState.IsAiming then
            if KYS_ToFState.LaserBeam then KYS_ToFState.LaserBeam.Transparency = 1 end
            return
        end

        local _, _, originPos, targetPos = KYS_ToFGetTargetPosition()
        if originPos and targetPos then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and not char:GetAttribute("IsCarried") then
                    hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
                end
            end)

            if VD.TOF_Laser then
                KYS_ToFUpdateLaser(originPos, targetPos)
            elseif KYS_ToFState.LaserBeam then
                KYS_ToFState.LaserBeam.Transparency = 1
            end
        elseif KYS_ToFState.LaserBeam then
            KYS_ToFState.LaserBeam.Transparency = 1
        end
    end)
end

local function KYS_ToFStopConnection()
    if KYS_ToFState.Connection then
        pcall(function() KYS_ToFState.Connection:Disconnect() end)
        KYS_ToFState.Connection = nil
    end
    KYS_ToFState.IsAiming = false
    KYS_ToFClearLaser()
end

local function KYS_ToFDisconnectInputs()
    if KYS_ToFState.InputBegan then pcall(function() KYS_ToFState.InputBegan:Disconnect() end) end
    if KYS_ToFState.InputEnded then pcall(function() KYS_ToFState.InputEnded:Disconnect() end) end
    KYS_ToFState.InputBegan = nil
    KYS_ToFState.InputEnded = nil
end

local KYS_SetToFSilentAim

local function KYS_ToFEnsureInputs()
    if not KYS_ToFState.InputBegan then
        KYS_ToFState.InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end

            local keyCode = KYS_ToFKeyCodes[VD.TOF_Key or "None"]
            if keyCode and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyCode then
                KYS_SetToFSilentAim(not VD.TOF_SilentAim)
                return
            end

            if not VD.TOF_SilentAim then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or (input.UserInputType == Enum.UserInputType.Touch and KYS_ToFIsTouchOnShootButton(input)) then
                KYS_ToFState.IsAiming = true
                if input.UserInputType == Enum.UserInputType.Touch then
                    KYS_ToFState.TouchInput = input
                end
                KYS_ToFDoShoot()
                return
            end

            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.K then
                    KYS_ToFSetTargetMode("Killer", true)
                elseif input.KeyCode == Enum.KeyCode.J then
                    KYS_ToFSetTargetMode("Survivors", true)
                elseif input.KeyCode == Enum.KeyCode.L then
                    KYS_ToFSetTargetMode("Zombie", true)
                end
            end
        end)
    end
    if not KYS_ToFState.InputEnded then
        KYS_ToFState.InputEnded = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or (input.UserInputType == Enum.UserInputType.Touch and input == KYS_ToFState.TouchInput) then
                KYS_ToFState.IsAiming = false
                if input == KYS_ToFState.TouchInput then KYS_ToFState.TouchInput = nil end
                if KYS_ToFState.LaserBeam then KYS_ToFState.LaserBeam.Transparency = 1 end
            end
        end)
    end
end

KYS_SetToFSilentAim = function(enabled)
    VD.TOF_SilentAim = enabled and true or false
    KYS_ToFEnsureInputs()
    if VD.TOF_SilentAim then
        KYS_ToFCreateTargetSelectorUI()
        KYS_ToFStartConnection()
    else
        KYS_ToFDestroyTargetSelectorUI()
        KYS_ToFStopConnection()
    end
end

KYS_ToFEnsureInputs()
getgenv().KYS_SetToFSilentAim = KYS_SetToFSilentAim
getgenv().KYS_ToFClearLaser = KYS_ToFClearLaser
getgenv().KYS_ToFSetTargetMode = KYS_ToFSetTargetMode
end)();

-- =====================================================
-- HIDE SURVIVOR ICON
-- =====================================================
(function()
local KYS_HideSurvivorIconState = {
    Connection = nil,
    Originals = {},
}

local KYS_HideSurvivorIconImage = "rbxassetid://80891639562743"
local KYS_HideSurvivorIconText = "NxH"

local function KYS_GetSurvivorSlots()
    local slots = {}
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return slots end

    for _, gui in ipairs(playerGui:GetChildren()) do
        if not (gui:IsA("ScreenGui") and gui.Name:match("%-mob$")) then
            continue
        end
        local frame = gui and gui:FindFirstChild("Frame")
        if frame then
            for i = 1, 5 do
                local survivorFrame = frame:FindFirstChild("Survivor" .. i)
                local imageLabel = survivorFrame and survivorFrame:FindFirstChild("ImageLabel")
                local textLabel = survivorFrame and survivorFrame:FindFirstChild("TextLabel")
                if (imageLabel and imageLabel:IsA("ImageLabel")) or (textLabel and textLabel:IsA("TextLabel")) then
                    table.insert(slots, {
                        ImageLabel = imageLabel,
                        TextLabel = textLabel,
                    })
                end
            end
        end
    end

    return slots
end

local function KYS_ApplyHideSurvivorIcon()
    for _, slot in ipairs(KYS_GetSurvivorSlots()) do
        local imageLabel = slot.ImageLabel
        if imageLabel and imageLabel:IsA("ImageLabel") then
            if not KYS_HideSurvivorIconState.Originals[imageLabel] then
                KYS_HideSurvivorIconState.Originals[imageLabel] = {
                    Image = imageLabel.Image,
                    ImageColor3 = imageLabel.ImageColor3,
                    ImageTransparency = imageLabel.ImageTransparency,
                    ImageRectOffset = imageLabel.ImageRectOffset,
                    ImageRectSize = imageLabel.ImageRectSize,
                    ScaleType = imageLabel.ScaleType,
                }
            end

            imageLabel.Image = KYS_HideSurvivorIconImage
            imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
            imageLabel.ImageTransparency = 0
            imageLabel.ImageRectOffset = Vector2.new(0, 0)
            imageLabel.ImageRectSize = Vector2.new(0, 0)
            imageLabel.ScaleType = Enum.ScaleType.Crop
        end

        local textLabel = slot.TextLabel
        if textLabel and textLabel:IsA("TextLabel") then
            if not KYS_HideSurvivorIconState.Originals[textLabel] then
                KYS_HideSurvivorIconState.Originals[textLabel] = {
                    Text = textLabel.Text,
                    TextColor3 = textLabel.TextColor3,
                    TextTransparency = textLabel.TextTransparency,
                }
            end

            textLabel.Text = KYS_HideSurvivorIconText
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextTransparency = 0
        end
    end
end

local function KYS_RestoreSurvivorIcons()
    for object, original in pairs(KYS_HideSurvivorIconState.Originals) do
        if object and object.Parent and original then
            pcall(function()
                if original.Image ~= nil and object:IsA("ImageLabel") then
                    object.Image = original.Image
                    object.ImageColor3 = original.ImageColor3
                    object.ImageTransparency = original.ImageTransparency
                    object.ImageRectOffset = original.ImageRectOffset
                    object.ImageRectSize = original.ImageRectSize
                    object.ScaleType = original.ScaleType
                end
                if original.Text ~= nil and object:IsA("TextLabel") then
                    object.Text = original.Text
                    object.TextColor3 = original.TextColor3
                    object.TextTransparency = original.TextTransparency
                end
            end)
        end
    end
    KYS_HideSurvivorIconState.Originals = {}
end

local function KYS_SetHideSurvivorIcon(enabled)
    VD.VIS_HideSurvivorIcon = enabled and true or false

    if VD.VIS_HideSurvivorIcon then
        KYS_ApplyHideSurvivorIcon()
        if not KYS_HideSurvivorIconState.Connection then
            KYS_HideSurvivorIconState.Connection = RunService.Heartbeat:Connect(function()
                if VD.VIS_HideSurvivorIcon then
                    KYS_ApplyHideSurvivorIcon()
                end
            end)
        end
    else
        if KYS_HideSurvivorIconState.Connection then
            pcall(function() KYS_HideSurvivorIconState.Connection:Disconnect() end)
            KYS_HideSurvivorIconState.Connection = nil
        end
        KYS_RestoreSurvivorIcons()
    end
end

getgenv().KYS_SetHideSurvivorIcon = KYS_SetHideSurvivorIcon
end)();

-- =====================================================
-- SHOW HOOK COUNTER (SURVIVOR & KILLER)
-- =====================================================
(function()
local KYS_HookCounterState = {
    Connection = nil,
}

local function KYS_UpdateHookCounter(enabled)
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name:match("%-mob$") then
            local frame = gui:FindFirstChild("Frame")
            if frame then
                for i = 1, 5 do
                    local survivorFrame = frame:FindFirstChild("Survivor" .. i)
                    local imageLabel = survivorFrame and survivorFrame:FindFirstChild("ImageLabel")
                    local textLabel = survivorFrame and survivorFrame:FindFirstChild("TextLabel")
                    
                    if imageLabel and textLabel then
                        -- Handle original Counter if exists
                        local counter = imageLabel:FindFirstChild("Counter")
                        if counter then
                            pcall(function()
                                if counter.Visible ~= enabled then
                                    counter.Visible = enabled
                                end
                            end)
                        end

                        -- Handle Custom Text Hook Counter
                        local labelName = "KYS_CustomHookCounter"
                        local customLabel = imageLabel:FindFirstChild(labelName)
                        
                        if enabled then
                            local playerName = textLabel.Text
                            local player = nil
                            for _, p in ipairs(game.Players:GetPlayers()) do
                                if p.Name == playerName or p.DisplayName == playerName then
                                    player = p
                                    break
                                end
                            end

                            local hookCount = 0
                            if player then
                                hookCount = player:GetAttribute("HookCount") or (player.Character and player.Character:GetAttribute("HookCount")) or 0
                            end

                            if not customLabel then
                                customLabel = Instance.new("TextLabel")
                                customLabel.Name = labelName
                                customLabel.Size = UDim2.new(1, 0, 0.35, 0)
                                customLabel.Position = UDim2.new(0, 0, 0.65, 0)
                                customLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                customLabel.BackgroundTransparency = 0.5
                                customLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                customLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                customLabel.TextStrokeTransparency = 0
                                customLabel.TextScaled = true
                                customLabel.Font = Enum.Font.SourceSansBold
                                customLabel.Parent = imageLabel
                            end

                            customLabel.Visible = true
                            if hookCount >= 3 then
                                customLabel.Text = "DEAD"
                                customLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
                            else
                                customLabel.Text = "Hooks: " .. tostring(hookCount)
                                if hookCount == 2 then
                                    customLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
                                elseif hookCount == 1 then
                                    customLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                                else
                                    customLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                end
                            end
                        else
                            if customLabel then
                                customLabel.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end
end

local function KYS_SetShowHookCounter(enabled)
    VD.VIS_ShowHookCounter = enabled and true or false

    if VD.VIS_ShowHookCounter then
        KYS_UpdateHookCounter(true)
        if not KYS_HookCounterState.Connection then
            KYS_HookCounterState.Connection = RunService.Heartbeat:Connect(function()
                if VD.VIS_ShowHookCounter then
                    KYS_UpdateHookCounter(true)
                end
            end)
        end
    else
        if KYS_HookCounterState.Connection then
            pcall(function() KYS_HookCounterState.Connection:Disconnect() end)
            KYS_HookCounterState.Connection = nil
        end
        KYS_UpdateHookCounter(false)
        -- Delete the custom label to keep GUI clean
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name:match("%-mob$") then
                    local frame = gui:FindFirstChild("Frame")
                    if frame then
                        for i = 1, 5 do
                            local survivorFrame = frame:FindFirstChild("Survivor" .. i)
                            local imageLabel = survivorFrame and survivorFrame:FindFirstChild("ImageLabel")
                            customLabel = imageLabel and imageLabel:FindFirstChild("KYS_CustomHookCounter")
                            if customLabel then
                                pcall(function() customLabel:Destroy() end)
                            end
                        end
                    end
                end
            end
        end
    end
end

getgenv().KYS_SetShowHookCounter = KYS_SetShowHookCounter
end)();

-- =====================================================
-- SHOW PING & FPS
-- =====================================================
(function()
local KYS_PingFPSState = {
    Gui = nil,
    Connection = nil,
    Frames = 0,
    LastUpdate = 0,
}

local function KYS_GetPingValue()
    local ok, value = pcall(function()
        local stats = game:GetService("Stats")
        local network = stats and stats:FindFirstChild("Network")
        local serverStats = network and network:FindFirstChild("ServerStatsItem")
        local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
        if dataPing and dataPing.GetValue then
            return math.floor(dataPing:GetValue() + 0.5)
        end
        if dataPing and dataPing.GetValueString then
            local raw = tostring(dataPing:GetValueString())
            return tonumber(raw:match("%d+"))
        end
    end)
    if ok and value then return value end
    return nil
end

local function KYS_CreatePingFPSGui()
    local parent = GetSafeGuiParent()
    if not parent then return nil end

    local old = parent:FindFirstChild("KYS_PingFPSGui")
    if old then pcall(function() old:Destroy() end) end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KYS_PingFPSGui"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.Parent = parent

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 118, 0, 44)
    frame.Position = UDim2.new(0, 12, 0, 120)
    frame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = sg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(96, 72, 160)
    stroke.Thickness = 1

    local label = Instance.new("TextLabel")
    label.Name = "PingFPSLabel"
    label.Size = UDim2.new(1, -12, 1, -8)
    label.Position = UDim2.new(0, 6, 0, 4)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(230, 235, 245)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Text = "PING: --ms\nFPS: --"
    label.Parent = frame

    return sg
end

local function KYS_SetShowPingFPS(enabled)
    VD.VIS_ShowPingFPS = enabled and true or false

    if VD.VIS_ShowPingFPS then
        KYS_PingFPSState.Gui = KYS_PingFPSState.Gui or KYS_CreatePingFPSGui()
        KYS_PingFPSState.Frames = 0
        KYS_PingFPSState.LastUpdate = tick()

        if not KYS_PingFPSState.Connection then
            KYS_PingFPSState.Connection = RunService.RenderStepped:Connect(function()
                if not VD.VIS_ShowPingFPS then return end

                KYS_PingFPSState.Frames = KYS_PingFPSState.Frames + 1
                local now = tick()
                if now - KYS_PingFPSState.LastUpdate < 0.5 then return end

                local fps = math.floor(KYS_PingFPSState.Frames / (now - KYS_PingFPSState.LastUpdate) + 0.5)
                local ping = KYS_GetPingValue()
                KYS_PingFPSState.Frames = 0
                KYS_PingFPSState.LastUpdate = now

                if not (KYS_PingFPSState.Gui and KYS_PingFPSState.Gui.Parent) then
                    KYS_PingFPSState.Gui = KYS_CreatePingFPSGui()
                end

                local label = KYS_PingFPSState.Gui and KYS_PingFPSState.Gui:FindFirstChild("PingFPSLabel", true)
                if label then
                    label.Text = ("PING: %sms\nFPS: %d"):format(ping and tostring(ping) or "--", fps)
                end
            end)
        end
    else
        if KYS_PingFPSState.Connection then
            pcall(function() KYS_PingFPSState.Connection:Disconnect() end)
            KYS_PingFPSState.Connection = nil
        end
        if KYS_PingFPSState.Gui then
            pcall(function() KYS_PingFPSState.Gui:Destroy() end)
            KYS_PingFPSState.Gui = nil
        end
    end
end

getgenv().KYS_SetShowPingFPS = KYS_SetShowPingFPS
end)();

-- =====================================================
-- SILENT AIM: FLASHLIGHT
-- =====================================================
(function()
local KYS_FlashlightAimState = {
    Connection = nil,
    LaserBeam = nil,
    FlashlightPart = nil,
    Active = false,
}

local function KYS_GetFlashlightActivateRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local flashlight = items and items:FindFirstChild("Flashlight")
    local activate = flashlight and flashlight:FindFirstChild("Activate")
    if activate and activate:IsA("RemoteEvent") then
        return activate
    end
    return nil
end

local function KYS_GetFlashlightTargetPart(char)
    if not char then return nil end
    local preferred = VD.FLASH_TargetPart or "Head"
    local part = char:FindFirstChild(preferred)
    if part and part:IsA("BasePart") then return part end
    return char:FindFirstChild("Head")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function KYS_IsAliveCharacter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local state = char:GetAttribute("State")
    return state ~= "Dead"
end

local function KYS_GetFlashlightTarget()
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    local maxRange = tonumber(VD.FLASH_Range) or 120
    local bestPart, bestScore = nil, math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and KYS_IsAliveCharacter(player.Character) then
            local isKiller = player.Team and player.Team.Name == "Killer"
            if isKiller then
                local part = KYS_GetFlashlightTargetPart(player.Character)
                if part then
                    local dist = (localRoot.Position - part.Position).Magnitude
                    if dist <= maxRange and dist < bestScore then
                        bestScore = dist
                        bestPart = part
                    end
                end
            end
        end
    end

    return bestPart
end

local function KYS_ClearFlashlightLaser()
    if KYS_FlashlightAimState.LaserBeam then
        pcall(function() KYS_FlashlightAimState.LaserBeam:Destroy() end)
        KYS_FlashlightAimState.LaserBeam = nil
    end
end

local function KYS_GetFlashlightOrigin(cam)
    local source = KYS_FlashlightAimState.FlashlightPart
    if typeof and typeof(source) == "Instance" then
        if source:IsA("BasePart") then
            return source.Position
        end
        local part = source:FindFirstChildWhichIsA("BasePart", true)
        if part then
            return part.Position
        end
    end

    local char = LocalPlayer.Character
    local hand = char and (
        char:FindFirstChild("RightHand")
        or char:FindFirstChild("Right Arm")
        or char:FindFirstChild("HumanoidRootPart")
    )
    if hand and hand:IsA("BasePart") then
        return hand.Position
    end

    return cam and cam.CFrame.Position or nil
end

local function KYS_UpdateFlashlightLaser(originPos, targetPos)
    if not KYS_FlashlightAimState.LaserBeam then
        local laser = Instance.new("Part")
        laser.Name = "FlashlightSilentAimLaser"
        laser.Anchored = true
        laser.CanCollide = false
        laser.CanTouch = false
        laser.CastShadow = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(80, 220, 255)
        laser.Transparency = 0
        laser.Parent = workspace
        KYS_FlashlightAimState.LaserBeam = laser
    end

    local dist = (targetPos - originPos).Magnitude
    if dist < 0.1 then return end

    local laser = KYS_FlashlightAimState.LaserBeam
    laser.Size = Vector3.new(0.16, 0.16, dist)
    laser.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
    laser.Transparency = 0
end

local function KYS_FlashlightAimStep()
    if false then
        if KYS_FlashlightAimState.LaserBeam then
            KYS_FlashlightAimState.LaserBeam.Transparency = 1
        end
        return
    end

    if not (VD.FLASH_SilentAim and KYS_FlashlightAimState.Active) then
        if KYS_FlashlightAimState.LaserBeam then
            KYS_FlashlightAimState.LaserBeam.Transparency = 1
        end
        return
    end

    local cam = workspace.CurrentCamera
    local targetPart = KYS_GetFlashlightTarget()
    if not (cam and targetPart) then
        if KYS_FlashlightAimState.LaserBeam then
            KYS_FlashlightAimState.LaserBeam.Transparency = 1
        end
        return
    end

    local targetPos = targetPart.Position
    local smooth = math.clamp(tonumber(VD.FLASH_Smooth) or 0.35, 0.05, 1)
    local originPos = KYS_GetFlashlightOrigin(cam)

    if VD.FLASH_Laser and originPos then
        KYS_UpdateFlashlightLaser(originPos, targetPos)
    elseif KYS_FlashlightAimState.LaserBeam then
        KYS_FlashlightAimState.LaserBeam.Transparency = 1
    end

    pcall(function()
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPos), smooth)
    end)

    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        end
    end)
end

local function KYS_StartFlashlightSilentAim()
    getgenv().KYS_FlashlightActivateRemote = KYS_GetFlashlightActivateRemote()
    if KYS_FlashlightAimState.Connection then return end
    KYS_FlashlightAimState.Connection = RunService.RenderStepped:Connect(KYS_FlashlightAimStep)
end

local function KYS_StopFlashlightSilentAim()
    KYS_FlashlightAimState.Active = false
    KYS_FlashlightAimState.FlashlightPart = nil
    KYS_ClearFlashlightLaser()
    if KYS_FlashlightAimState.Connection then
        pcall(function() KYS_FlashlightAimState.Connection:Disconnect() end)
        KYS_FlashlightAimState.Connection = nil
    end
end

local function KYS_SetFlashlightSilentAim(enabled)
    if enabled and false then
        VD.FLASH_SilentAim = false
        KYS_StopFlashlightSilentAim()
        return
    end

    VD.FLASH_SilentAim = enabled and true or false
    if VD.FLASH_SilentAim then
        KYS_StartFlashlightSilentAim()
    else
        KYS_StopFlashlightSilentAim()
    end
end

getgenv().KYS_SetFlashlightSilentAim = KYS_SetFlashlightSilentAim
getgenv().KYS_ClearFlashlightLaser = KYS_ClearFlashlightLaser
getgenv().KYS_SetFlashlightAimActive = function(active, flashlightPart)
    KYS_FlashlightAimState.Active = active and true or false
    if KYS_FlashlightAimState.Active and flashlightPart then
        KYS_FlashlightAimState.FlashlightPart = flashlightPart
    elseif not KYS_FlashlightAimState.Active then
        KYS_FlashlightAimState.FlashlightPart = nil
    end
    if not KYS_FlashlightAimState.Active and KYS_FlashlightAimState.LaserBeam then
        KYS_FlashlightAimState.LaserBeam.Transparency = 1
    end
end
getgenv().KYS_FlashlightActivateRemote = KYS_GetFlashlightActivateRemote()
end)();

local VD_Parry = {
    PreciseDistanceEnabled = true,
    MaxDistance = 14,
    CanParry = true,
    IsParrying = false,
    CooldownEndTime = 0,
    KillerAnimator = nil,
    KillerChar = nil,
    KillerPlayer = nil,
    Connections = {},
    FiredTracks = {},
    RenderConnection = nil,
    LastStatus = "Off",
}

local VD_ParryAnimation = Instance.new("Animation")
VD_ParryAnimation.AnimationId = "rbxassetid://109133187196613"

local VD_ParryRange = Instance.new("CylinderHandleAdornment")
VD_ParryRange.Name = "KYS_ParryRange"
VD_ParryRange.Radius = VD.SURV_ParryDistance or 8
VD_ParryRange.InnerRadius = math.max(0.1, (VD.SURV_ParryDistance or 8) - 0.15)
VD_ParryRange.Height = 0.01
VD_ParryRange.Color3 = Color3.fromRGB(128, 128, 128)
VD_ParryRange.AlwaysOnTop = false
VD_ParryRange.Adornee = Workspace:FindFirstChildOfClass("Terrain")
VD_ParryRange.Transparency = 1
VD_ParryRange.Parent = GetSafeGuiParent()

local VD_ATTACK_ANIMS = {
    ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true,
    ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://133963973694098"] = true,
    ["rbxassetid://117042998468241"] = true,
    ["rbxassetid://105374834496520"] = true,
    ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://78432063483146"] = true,
    ["rbxassetid://118907603246885"] = true,
    ["rbxassetid://138720291317243"] = true,
    ["rbxassetid://115244153053858"] = true,
    ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true,
    ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true,
}

function VD_UpdateParryRange()
    if not VD.SURV_ShowParryCircle or not VD.SURV_AutoParry then
        VD_ParryRange.Transparency = 1
        return
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        VD_ParryRange.Transparency = 1
        return
    end

    local currentMaxDist = VD_Parry.PreciseDistanceEnabled and (VD.SURV_ParryDistance or 8) or VD_Parry.MaxDistance
    VD_ParryRange.Transparency = 0.4
    VD_ParryRange.Radius = currentMaxDist
    VD_ParryRange.InnerRadius = math.max(0.1, currentMaxDist - 0.15)

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { char }
    params.FilterType = Enum.RaycastFilterType.Exclude

    local ray = Workspace:Raycast(root.Position, Vector3.new(0, -15, 0), params)
    local groundPos = ray and ray.Position or (root.Position - Vector3.new(0, 3, 0))
    VD_ParryRange.CFrame = CFrame.new(groundPos + Vector3.new(0, 0.05, 0)) * CFrame.Angles(math.pi / 2, 0, 0)
end

function VD_GetParryRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local dagger = items and items:FindFirstChild("Parrying Dagger")
    return dagger and dagger:FindFirstChild("parry")
end

function VD_RefreshLocalCombatCache()
    local char = LocalPlayer.Character
    Root = char and char:FindFirstChild("HumanoidRootPart") or Root
    Humanoid = char and char:FindFirstChildOfClass("Humanoid") or Humanoid
end

local State = { ParryCooldown = false, ParryCooldownThread = nil }
local Attached = {}
function IsKiller(p) return p.Team and p.Team.Name == "Killer" end
function IsDowned(char) local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return true end; local state = char:GetAttribute("State"); return state == "Downed" or state == "Dead" end
function TriggerCrouch()
    local startT = tick()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        -- Toggle crouch ON: replicate mobile SurvivorAnimationsController logic
        pcall(function() char:SetAttribute("Crouching", true) end)
        pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", true) end)
        pcall(function() ReplicatedStorage.Remotes.Chase.Runevent:FireServer(char, false) end)
        if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Landed) end) end
        
        -- Also fire the mobile crouch button signal for visual sync
        pcall(function()
            local survMob = LocalPlayer:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Survivor-mob")
            if survMob then
                local controls = survMob:FindFirstChild("Controls")
                if controls then
                    local crouchBtn = controls:FindFirstChild("crouch")
                    if crouchBtn then
                        firesignal(crouchBtn.MouseButton1Click)
                    end
                end
            end
        end)
        
        while tick() - startT < 1.2 do
            pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", true) end)
            task.wait(0.1)
        end
        
        -- Toggle crouch OFF
        pcall(function() char:SetAttribute("Crouching", false) end)
        pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", false) end)
        if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Landed) end) end
        
        -- Fire crouch button again to toggle OFF visually
        pcall(function()
            local survMob = LocalPlayer:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Survivor-mob")
            if survMob then
                local controls = survMob:FindFirstChild("Controls")
                if controls then
                    local crouchBtn = controls:FindFirstChild("crouch")
                    if crouchBtn then
                        firesignal(crouchBtn.MouseButton1Click)
                    end
                end
            end
        end)
    end)
end
function IsSafeToParry(char) return not IsDowned(char) end
local player = LocalPlayer
-- ==================== AUTO PARRY SENSOR ====================
function tapMobileParryButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local survivorMob = playerGui:FindFirstChild("Survivor-mob")
    local parryBtn = survivorMob
        and survivorMob:FindFirstChild("Controls")
        and survivorMob.Controls:FindFirstChild("Gui-mob")

    if parryBtn and parryBtn.Visible then
        if firesignal then
            pcall(function()
                firesignal(parryBtn.MouseButton1Down)
                task.wait(0.01)
                firesignal(parryBtn.MouseButton1Up)
            end)
        end
    else
        pcall(function()
            if mouse2click then
                mouse2click()
                return
            end
            if mouse2press and mouse2release then
                mouse2press()
                task.wait(0.01)
                mouse2release()
                return
            end
            if MouseButton2Click then
                MouseButton2Click()
                return
            end
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end
end

function ExecuteParry()
    if State.ParryCooldown then return end
    pcall(function()
        local parryRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Items"):FindFirstChild("Parrying Dagger"):FindFirstChild("parry")
        if parryRemote then
            for i = 1, 10 do parryRemote:FireServer() end
        end
        task.spawn(tapMobileParryButton)
    end)
end

function ListenToParryResult()
    task.spawn(function()
        local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
        local dagger = remotes and remotes:WaitForChild("Items", 5):WaitForChild("Parrying Dagger", 5)
        local parryResultRemote = dagger and dagger:WaitForChild("parryResult", 5)
        
        if parryResultRemote then
            parryResultRemote.OnClientEvent:Connect(function(arg1, arg2)
                local cdDur = tonumber(arg2) or ((arg1 == true) and 90 or 60)
                State.ParryCooldown = true
                if State.ParryCooldownThread then task.cancel(State.ParryCooldownThread) end
                State.ParryCooldownThread = task.delay(cdDur, function()
                    State.ParryCooldown = false
                end)
            end)
        end
    end)
end
ListenToParryResult()

function AttachParrySensor(kChar)
    if not kChar or Attached[kChar] then return end
    Attached[kChar] = true
    local humanoid = kChar:FindFirstChild("Humanoid")
    if not humanoid then
        humanoid = kChar:WaitForChild("Humanoid", 5)
        if not humanoid then return end
    end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = humanoid:WaitForChild("Animator", 5)
        if not animator then return end
    end

    humanoid.ChildAdded:Connect(function(child)
        if child:IsA("Animator") then
            Attached[kChar] = nil
            AttachParrySensor(kChar)
        end
    end)

    kChar.AncestryChanged:Connect(function(_, parent)
        if not parent then
            Attached[kChar] = nil
        end
    end)

    animator.AnimationPlayed:Connect(function(track)
        local animId = track.Animation and track.Animation.AnimationId or ""
        local id = animId:match("%d+")
        
        -- Auto Crouch untuk Abyssal S1
        if id == "80411309607666" and VD.AutoCrouch then
            local myChar = LocalPlayer.Character
            if IsDowned(myChar) then return end
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local kHRP = kChar:FindFirstChild("HumanoidRootPart")
            if myHRP and kHRP then
                local dist = (myHRP.Position - kHRP.Position).Magnitude
                if dist <= 40 then
                    TriggerCrouch()
                end
            end
            return 
        end
        
        local attackName = VD_ATTACK_ANIMS[animId]
        if not attackName then return end
        
        if not VD.SURV_AutoParry then return end
        if State.ParryCooldown then return end 
        if VD.Ignored_Skills_List and VD.Ignored_Skills_List[attackName] then return end

        local myChar = LocalPlayer.Character
        if IsDowned(myChar) or not IsSafeToParry(myChar) then return end
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local kHRP = kChar:FindFirstChild("HumanoidRootPart")
        if not myHRP or not kHRP then return end
        
        local delta = myHRP.Position - kHRP.Position
        local startDistance = delta.Magnitude

        if VD.SURV_ParryAggressive then
            local aggressiveRadius = 12
            local detectionRadius = VD.SURV_ParryDistance + 5
            if startDistance > detectionRadius then return end
            if startDistance <= aggressiveRadius then
                ExecuteParry()
            else
                local tracker
                local startTime = os.clock()
                tracker = RunService.Heartbeat:Connect(function()
                    if os.clock() - startTime >= 1.5 or State.ParryCooldown or not myHRP or not kHRP or IsDowned(myChar) then
                        if tracker then tracker:Disconnect() end
                        return
                    end
                    local currentDist = (myHRP.Position - kHRP.Position).Magnitude
                    if currentDist <= aggressiveRadius then
                        ExecuteParry()
                        if tracker then tracker:Disconnect() end
                    end
                end)
            end
        else
            if startDistance > VD.SURV_ParryDistance then return end
            local myPosFlat = Vector3.new(myHRP.Position.X, 0, myHRP.Position.Z)
            local kPosFlat = Vector3.new(kHRP.Position.X, 0, kHRP.Position.Z)
            local flatDelta = myPosFlat - kPosFlat
            if flatDelta.Magnitude > 0 then
                local flatDirection = flatDelta.Unit
                local kLookFlat = Vector3.new(kHRP.CFrame.LookVector.X, 0, kHRP.CFrame.LookVector.Z).Unit
                local isFacing = kLookFlat:Dot(flatDirection)
                if isFacing < 0.6 then return end
            end
            ExecuteParry()
        end
    end)
end

function TryAttach(p)
    if p ~= player and IsKiller(p) and p.Character then 
        AttachParrySensor(p.Character) 
    end
end

function SetupPlayer(p)
    if p == player then return end
    p.CharacterAdded:Connect(function() TryAttach(p) end)
    p:GetPropertyChangedSignal("Team"):Connect(function() TryAttach(p) end)
    if p.Character then TryAttach(p) end
end

-- Setup Parry Sensor
for _, p in pairs(Players:GetPlayers()) do 
    SetupPlayer(p) 
end
Players.PlayerAdded:Connect(SetupPlayer)

task.spawn(function()
    while true do 
        task.wait(5) 
        for _, p in pairs(Players:GetPlayers()) do 
            TryAttach(p) 
        end 
    end
end)


function VD_SetAutoParry(state)
    VD.SURV_AutoParry = state == true
    if VD.SURV_AutoParry then
        if not _G.VD_ParryRenderConnection then
            _G.VD_ParryRenderConnection = game:GetService('RunService').RenderStepped:Connect(function()
                if type(VD_UpdateParryRange) == 'function' then VD_UpdateParryRange() end
            end)
        end
    else
        if typeof(VD_ParryRange) == 'Instance' then VD_ParryRange.Transparency = 1 end
        if _G.VD_ParryRenderConnection then
            _G.VD_ParryRenderConnection:Disconnect()
            _G.VD_ParryRenderConnection = nil
        end
    end
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AutoSkill = {
    LastGoalRotation = nil,
    HasClickedThisGoal = false,
    LastLineRotation = nil,
    LastTick = nil,
    WasActive = false,
    PerfectLastGoalRotation = nil,
    PerfectHasClickedThisGoal = false,
    PerfectLastLineRotation = nil,
    PerfectLastTick = nil,
    PerfectWasActive = false,
    InstantLastTriggerTick = 0,
    InstantLastGoalRotation = 0,
    InstantLastGoalInstance = nil,
    InstantCurrentGoalID = 0,
    InstantHasClicked = false,
    InstantForcingRotation = false,
    InstantRotationConnection = nil,
}

function VD_PressSkill()
    if isMobile then
        local btn = PlayerGui:FindFirstChild("check", true)
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + (size.X / 2) + inset.X
            local y = pos.Y + (size.Y / 2) + inset.Y
            pcall(function() VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.Begin.Value, x, y) end)
            task.wait(0.01)
            pcall(function() VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.End.Value, x, y) end)
            pcall(function()
                if firesignal and btn.MouseButton1Click then
                    firesignal(btn.MouseButton1Click)
                end
            end)
        end
    else
        pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game) end)
        task.wait(0.01)
        pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
    end
end

function VD_GetSkillCheck()
    for _, guiName in ipairs({ "SkillCheckPromptGui", "SkillCheckPromptGui-con" }) do
        local gui = PlayerGui:FindFirstChild(guiName, true)
        if gui then
            local check = gui:FindFirstChild("Check", true)
            if check and check.Visible then
                local line = check:FindFirstChild("Line", true)
                local goal = check:FindFirstChild("Goal", true)
                if line and goal then return line, goal end
            end
        end
    end
end

function VD_AngularDelta(from, to)
    local d = to - from
    if d > 180 then d = d - 360 end
    if d < -180 then d = d + 360 end
    return d
end

function VD_CrossedZone(prevLr, lr, startPos, endPos)
    local function inZone(r)
        if startPos > endPos then
            return r >= startPos or r <= endPos
        end
        return r >= startPos and r <= endPos
    end
    if inZone(lr) then return true end
    if prevLr == nil then return false end
    local delta = VD_AngularDelta(prevLr, lr)
    local steps = math.abs(math.floor(delta))
    if steps < 2 then return false end
    local stepSize = delta / steps
    for i = 1, steps do
        if inZone((prevLr + stepSize * i) % 360) then return true end
    end
    return false
end

function VD_NormalSkillcheckUpdate()
    local line, goal = VD_GetSkillCheck()
    if not (line and goal) then
        AutoSkill.LastGoalRotation = nil
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastLineRotation = nil
        AutoSkill.LastTick = nil
        AutoSkill.WasActive = false
        return
    end

    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360
    local now = os.clock()
    if not AutoSkill.WasActive then
        AutoSkill.WasActive = true
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastGoalRotation = gr
        AutoSkill.LastLineRotation = lr
        AutoSkill.LastTick = now
        return
    end
    if AutoSkill.LastGoalRotation and math.abs(VD_AngularDelta(AutoSkill.LastGoalRotation, gr)) > 5 then
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastLineRotation = nil
        AutoSkill.LastTick = nil
    end
    AutoSkill.LastGoalRotation = gr
    if AutoSkill.HasClickedThisGoal then
        AutoSkill.LastLineRotation = lr
        AutoSkill.LastTick = now
        return
    end
    if AutoSkill.LastLineRotation and AutoSkill.LastTick then
        local dt = now - AutoSkill.LastTick
        if dt > 0 then
            local lineSpeed = VD_AngularDelta(AutoSkill.LastLineRotation, lr) / dt
            local predicted = (lr + lineSpeed * dt * 0) % 360
            if VD_CrossedZone(AutoSkill.LastLineRotation, predicted, (gr + 104) % 360, (gr + 109) % 360) then
                AutoSkill.HasClickedThisGoal = true
                task.spawn(function()
                    task.wait(0.03)
                    VD_PressSkill()
                end)
            end
        end
    end
    AutoSkill.LastLineRotation = lr
    AutoSkill.LastTick = now
end

function VD_PerfectSkillcheckUpdate()
    local line, goal = VD_GetSkillCheck()
    if not (line and goal) then
        AutoSkill.PerfectLastGoalRotation = nil
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastLineRotation = nil
        AutoSkill.PerfectLastTick = nil
        AutoSkill.PerfectWasActive = false
        return
    end

    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360
    local now = os.clock()
    if not AutoSkill.PerfectWasActive then
        AutoSkill.PerfectWasActive = true
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastGoalRotation = gr
        AutoSkill.PerfectLastLineRotation = lr
        AutoSkill.PerfectLastTick = now
        return
    end
    if AutoSkill.PerfectLastGoalRotation and math.abs(VD_AngularDelta(AutoSkill.PerfectLastGoalRotation, gr)) > 5 then
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastLineRotation = nil
        AutoSkill.PerfectLastTick = nil
    end
    AutoSkill.PerfectLastGoalRotation = gr
    if AutoSkill.PerfectHasClickedThisGoal then
        AutoSkill.PerfectLastLineRotation = lr
        AutoSkill.PerfectLastTick = now
        return
    end
    if AutoSkill.PerfectLastLineRotation and AutoSkill.PerfectLastTick then
        local dt = now - AutoSkill.PerfectLastTick
        if dt > 0 then
            local lineSpeed = VD_AngularDelta(AutoSkill.PerfectLastLineRotation, lr) / dt
            local predicted = (lr + lineSpeed * dt * 0) % 360
            if VD_CrossedZone(AutoSkill.PerfectLastLineRotation, predicted, (gr + 104) % 360, (gr + 108) % 360) then
                AutoSkill.PerfectHasClickedThisGoal = true
                VD_PressSkill()
            end
        end
    end
    AutoSkill.PerfectLastLineRotation = lr
    AutoSkill.PerfectLastTick = now
end

function VD_InstantSkillcheckUpdate()
    if AutoSkill.InstantHasClicked then return end

    -- Exact Fallens.lua logic: non-recursive FindFirstChild
    local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
    if not prompt then
        prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui-con")
    end
    if not prompt then return end

    local check = prompt:FindFirstChild("Check")
    if not check or not check.Visible then return end

    local line = check:FindFirstChild("Line")
    local goal = check:FindFirstChild("Goal")
    if not line or not goal then return end

    -- Exact Fallens.lua logic: raw rotation WITHOUT modulo
    line.Rotation = goal.Rotation + 109

    AutoSkill.InstantHasClicked = true
    task.spawn(function()
        VD_PressSkill()
        task.wait(0.2)
        AutoSkill.InstantHasClicked = false
    end)
end

RunService.RenderStepped:Connect(function()
    if not VD.AutoSkillcheck then return end
    if VD.AutoSkillcheckMode == "Perfect" then
        VD_PerfectSkillcheckUpdate()
    elseif VD.AutoSkillcheckMode == "Instant" then
        VD_InstantSkillcheckUpdate()
    else
        VD_NormalSkillcheckUpdate()
    end
end)

function VD_SetAutoSkillcheck(state)
    VD.AutoSkillcheck = state == true
    if not VD.AutoSkillcheck then
        if AutoSkill.InstantRotationConnection then
            AutoSkill.InstantRotationConnection:Disconnect()
            AutoSkill.InstantRotationConnection = nil
        end
        AutoSkill.InstantHasClicked = false
        AutoSkill.WasActive = false
        AutoSkill.PerfectWasActive = false
        VD_Notify("Auto Skillcheck", "Disabled", 2)
    else
        VD_Notify("Auto Skillcheck", "Enabled (" .. tostring(VD.AutoSkillcheckMode or "Normal") .. " Mode)", 2)
    end
end

-- =====================================================
-- INSTANT HEAL & AUTO HEAL ALL
-- =====================================================
InstantHealSelf = false
AutoHealAll = false
AutoSelfUnhook = false
AutoHealAllConnection = nil
InstantHealConnection = nil
AutoSelfUnhookConnection = nil

function doSelfHeal()
	local char = LocalPlayer.Character
	if not char then return end
	local skillCheckRemote = ReplicatedStorage.Remotes.Healing.SkillCheckResultEvent
	pcall(function() skillCheckRemote:FireServer("success", 100, char) end)
end

function doSelfHealTrue()
	local char = LocalPlayer.Character
	if not char then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	pcall(function() healRemote:FireServer(hrp, true) end)
end

function doSelfHealFalse()
	local char = LocalPlayer.Character
	if not char then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	pcall(function() healRemote:FireServer(hrp, false) end)
end

function doOthersHealSkillCheck(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local skillCheckRemote = ReplicatedStorage.Remotes.Healing.SkillCheckResultEvent
	pcall(function() skillCheckRemote:FireServer("success", 100, targetPlayer.Character) end)
end

function doOthersHealTrue(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	pcall(function() healRemote:FireServer(targetHRP, true) end)
end

function doOthersHealFalse(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	pcall(function() healRemote:FireServer(targetHRP, false) end)
end

function setInstantHealSelf(v)
    InstantHealSelf = v
    if v then
        local healActive = false
        if InstantHealConnection then InstantHealConnection:Disconnect() end
        InstantHealConnection = RunService.Heartbeat:Connect(function(dt)
            if not InstantHealSelf then return end
            local myChar = LocalPlayer.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myHum then return end
            
            if myHum.Health >= myHum.MaxHealth * 0.9 then 
                -- Auto stop heal when HP is full
                if healActive then
                    healActive = false
                    doSelfHealFalse()
                end
                return 
            end
            
            -- Check if game cancelled our heal (e.g. player moved)
            if healActive then
                local checkScript = myChar:FindFirstChild("CheckInterractable")
                if checkScript and not checkScript:GetAttribute("isHealing") then
                    -- Game cancelled our heal, reset so we can restart
                    healActive = false
                end
            end
            
            -- Start heal (or restart after being cancelled)
            if not healActive then
                healActive = true
                doSelfHealTrue()
            end
        end)
    else
        if InstantHealConnection then InstantHealConnection:Disconnect(); InstantHealConnection = nil end
        -- Send stop heal just in case
        pcall(doSelfHealFalse)
    end
end

function setAutoHealAll(v)
    AutoHealAll = v
    if v then
        local activeHeals = {} -- [player] = true if we're currently healing them
        if AutoHealAllConnection then AutoHealAllConnection:Disconnect() end
        AutoHealAllConnection = RunService.Heartbeat:Connect(function(dt)
            if not AutoHealAll then return end
            for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local hrp = player.Character:FindFirstChild("HumanoidRootPart")
					local hum = player.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 and hum.Health < hum.MaxHealth * 0.9 and hrp then
						-- Check if game cancelled our heal on this player (e.g. we or they moved)
						if activeHeals[player] then
							local myChar = LocalPlayer.Character
							local checkScript = myChar and myChar:FindFirstChild("CheckInterractable")
							if checkScript and not checkScript:GetAttribute("isHealing") then
								activeHeals[player] = nil
							end
						end
						-- Start healing this player if not already
						if not activeHeals[player] then
							activeHeals[player] = true
							doOthersHealTrue(player)
						end
					else
						-- Stop healing if HP is full or dead
						if activeHeals[player] then
							activeHeals[player] = nil
							doOthersHealFalse(player)
						end
					end
				else
					-- Player left or no character
					if activeHeals[player] then
						activeHeals[player] = nil
						pcall(function() doOthersHealFalse(player) end)
					end
				end
			end
        end)
    else
        if AutoHealAllConnection then AutoHealAllConnection:Disconnect(); AutoHealAllConnection = nil end
    end
end





-- =====================================================
-- GEN BOOST BYPASS
-- =====================================================
GenBypass = {
    Enabled     = false,
    Button      = nil,
    UI          = nil,
    Cache       = {},
    CacheTimer  = 0,
    Processed   = {},
    HotkeyCode  = Enum.KeyCode.G,
}

function GB_GetAllGenerators()
    local now = tick()
    if now - GenBypass.CacheTimer < 5 then return GenBypass.Cache end
    GenBypass.Cache = {}
    GenBypass.CacheTimer = now
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return GenBypass.Cache end
    pcall(function()
        for _, v in pairs(mapFolder:GetDescendants()) do
            if not v:IsA("Model") then continue end
            if v.Name ~= "Generator" then continue end
            local isReal = v:GetAttribute("RepairProgress") ~= nil
                or v:GetAttribute("kickcount") ~= nil
                or v:GetAttribute("ProgressRepair") ~= nil
            if isReal then table.insert(GenBypass.Cache, v) end
        end
    end)
    return GenBypass.Cache
end

function GB_GetPoints(genModel)
    local points = {}
    pcall(function()
        for _, obj in pairs(genModel:GetChildren()) do
            if obj.Name:find("GeneratorPoint") and obj:IsA("BasePart") then
                table.insert(points, obj)
            end
        end
    end)
    return points
end

function GB_WaitRepairing(point, timeout)
    local start = tick()
    while tick() - start < (timeout or 1) do
        if point:GetAttribute("IsRepairing") == true then return true end
        task.wait(0.05)
    end
    return false
end

function GB_DoRepair(targetPoint)
    local genModel = targetPoint.Parent
    if GenBypass.Processed[genModel] then return end
    GenBypass.Processed[genModel] = true

    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then GenBypass.Processed[genModel] = nil return end

    local RepairEvent = ReplicatedStorage:FindFirstChild("Remotes")
        and ReplicatedStorage.Remotes:FindFirstChild("Generator")
        and ReplicatedStorage.Remotes.Generator:FindFirstChild("RepairEvent")

    local originalCFrame = hrp.CFrame
    pcall(function()
        for _, point in pairs(GB_GetPoints(genModel)) do
            if point ~= targetPoint and point.Parent then
                hrp.Anchored = true
                hrp.CFrame = point.CFrame
                task.wait(0.15)
                pcall(function() if RepairEvent then RepairEvent:FireServer(point, true) end end)
                if not GB_WaitRepairing(point, 0.8) then
                    pcall(function() if RepairEvent then RepairEvent:FireServer(point, false) end end)
                    task.wait(0.1)
                    hrp.CFrame = point.CFrame
                    task.wait(0.15)
                    pcall(function() if RepairEvent then RepairEvent:FireServer(point, true) end end)
                    GB_WaitRepairing(point, 0.5)
                end
                hrp.Anchored = false
                task.wait(0.05)
            end
        end
    end)
    pcall(function()
        if hrp and hrp.Parent then
            hrp.Anchored = false
            hrp.CFrame = originalCFrame
        end
    end)
    task.wait(0.1)
    pcall(function() if RepairEvent then RepairEvent:FireServer(targetPoint, false) end end)
end

function GB_GetNearestPoint()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local bestPoint, bestDist = nil, math.huge
    for _, gen in pairs(GB_GetAllGenerators()) do
        for _, point in pairs(GB_GetPoints(gen)) do
            local d = (hrp.Position - point.Position).Magnitude
            if d < bestDist then bestDist = d; bestPoint = point end
        end
    end
    return bestPoint, bestDist
end

function GB_IsPromptVisible()
    local ok, frame = pcall(function()
        return LocalPlayer.PlayerGui.pcprompts.Frame.GeneratorRepair
    end)
    return ok and frame and frame.Visible
end

function GB_UpdateButton()
    if GenBypass.Button then
        GenBypass.Button.Visible = GenBypass.Enabled and isMobile
    end
end

function GB_CreateButton()
    local oldUI = LocalPlayer.PlayerGui:FindFirstChild("BypassGenUI")
    if oldUI then oldUI:Destroy() end

    GenBypass.UI = Instance.new("ScreenGui")
    GenBypass.UI.Name = "BypassGenUI"
    GenBypass.UI.ResetOnSpawn = false
    GenBypass.UI.IgnoreGuiInset = true
    GenBypass.UI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    GenBypass.Button = Instance.new("ImageButton")
    GenBypass.Button.Name = "BypassGenButton"
    GenBypass.Button.Size = UDim2.new(0, 60, 0, 60)
    GenBypass.Button.Position = UDim2.new(0.88, 0, 0.55, 0)
    GenBypass.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    GenBypass.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GenBypass.Button.BackgroundTransparency = 0.15
    GenBypass.Button.AutoButtonColor = true
    GenBypass.Button.Visible = false
    GenBypass.Button.ZIndex = 10
    GenBypass.Button.Parent = GenBypass.UI
    Instance.new("UICorner", GenBypass.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", GenBypass.Button)
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", GenBypass.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "BYPASS"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)
        
        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end
    
    applyShine(GenBypass.Button, Color3.fromRGB(20, 0, 30))
    applyShine(lbl, Color3.fromRGB(255, 0, 255))
    applyShine(s, Color3.fromRGB(255, 0, 255))

    GenBypass.Button.MouseButton1Click:Connect(function()
        if not GenBypass.Enabled then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        if bestPoint and bestDist <= 8 then GB_DoRepair(bestPoint) end
    end)
end

GB_CreateButton()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    GB_CreateButton()
    GB_UpdateButton()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if isMobile then return end
    if input.KeyCode == GenBypass.HotkeyCode and GenBypass.Enabled then
        if not GB_IsPromptVisible() then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        if not bestPoint or bestDist > 8 then return end
        if GenBypass.Processed[bestPoint.Parent] then return end
        GB_DoRepair(bestPoint)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not GenBypass.Enabled then return end
    if not GB_IsPromptVisible() then return end
    local bestPoint, bestDist = GB_GetNearestPoint()
    if not bestPoint or bestDist > 8 then return end
    if GenBypass.Processed[bestPoint.Parent] then return end
    GB_DoRepair(bestPoint)
end)

task.spawn(function()
    while true do
        task.wait(2)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for genModel in pairs(GenBypass.Processed) do
                if not genModel or not genModel.Parent then
                    GenBypass.Processed[genModel] = nil
                    continue
                end
                local nearAny = false
                for _, point in pairs(GB_GetPoints(genModel)) do
                    if point.Parent and (hrp.Position - point.Position).Magnitude <= 10 then
                        nearAny = true; break
                    end
                end
                if not nearAny then GenBypass.Processed[genModel] = nil end
            end
        end
    end
end)

function setGenBypass(v)
    GenBypass.Enabled = v
    GB_UpdateButton()
end

function setAutoCrouch(v) VD.AutoCrouch = v end

-- =====================================================
-- INF GRAB (MYERS)
-- =====================================================
MyersGrabData = {
    Enabled = false,
    UI = nil,
    Button = nil,
    DragLocked = false,
    Dragging = false,
    DragStart = nil,
    DragStartPos = nil,
    HotkeyCode = Enum.KeyCode.H,
}

function getMyersTarget()
    local char = LocalPlayer.Character
    if not char then return nil end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    local candidates = {}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                table.insert(candidates, {
                    player = player,
                    dist   = (hrp.Position - myHRP.Position).Magnitude,
                    health = hum.Health
                })
            end
        end
    end
    table.sort(candidates, function(a, b) return a.dist < b.dist end)
    for _, c in ipairs(candidates) do
        return c.player
    end
    return nil
end

function doMyersGrab()
    if not MyersGrabData.Enabled then return end
    local target = getMyersTarget()
    if not target or not target.Character then return end
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        ReplicatedStorage.Remotes.Killers.Stalker.grab:FireServer(target.Character)
    end)
end

function setupMyersGrabBtn()
    local oldUI = LocalPlayer.PlayerGui:FindFirstChild("MyersGrabUI")
    if oldUI then oldUI:Destroy() end

    MyersGrabData.UI = Instance.new("ScreenGui")
    MyersGrabData.UI.Name = "MyersGrabUI"
    MyersGrabData.UI.ResetOnSpawn = false
    MyersGrabData.UI.IgnoreGuiInset = true
    MyersGrabData.UI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    MyersGrabData.Button = Instance.new("ImageButton")
    MyersGrabData.Button.Name = "MyersGrabButton"
    MyersGrabData.Button.Size = UDim2.new(0, 60, 0, 60)
    MyersGrabData.Button.Position = UDim2.new(0.7, 0, 0.75, 0)
    MyersGrabData.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    MyersGrabData.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MyersGrabData.Button.BackgroundTransparency = 0.15
    MyersGrabData.Button.AutoButtonColor = true
    MyersGrabData.Button.Visible = false
    MyersGrabData.Button.ZIndex = 10
    MyersGrabData.Button.Parent = MyersGrabData.UI
    Instance.new("UICorner", MyersGrabData.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", MyersGrabData.Button)
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", MyersGrabData.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "GRAB"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)
        
        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end
    
    applyShine(MyersGrabData.Button, Color3.fromRGB(20, 0, 30))
    applyShine(lbl, Color3.fromRGB(255, 0, 255))
    applyShine(s, Color3.fromRGB(255, 0, 255))

    MyersGrabData.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if MyersGrabData.DragLocked then return end
            MyersGrabData.Dragging = true
            MyersGrabData.DragStart = input.Position
            MyersGrabData.DragStartPos = MyersGrabData.Button.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if MyersGrabData.Dragging and not MyersGrabData.DragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - MyersGrabData.DragStart
            MyersGrabData.Button.Position = UDim2.new(
                MyersGrabData.DragStartPos.X.Scale, MyersGrabData.DragStartPos.X.Offset + delta.X, 
                MyersGrabData.DragStartPos.Y.Scale, MyersGrabData.DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    MyersGrabData.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MyersGrabData.Dragging = false
        end
    end)

    MyersGrabData.Button.MouseButton1Click:Connect(doMyersGrab)
end

setupMyersGrabBtn()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    setupMyersGrabBtn()
    if MyersGrabData.Button then
        MyersGrabData.Button.Visible = MyersGrabData.Enabled
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == MyersGrabData.HotkeyCode and MyersGrabData.Enabled then
        doMyersGrab()
    end
end)

function setMyersGrab(v)
    MyersGrabData.Enabled = v
    if MyersGrabData.Button then
        MyersGrabData.Button.Visible = v
    end
end

function setMyersDragLocked(v)
    MyersGrabData.DragLocked = v
end

-- =====================================================
-- VEIL AIMBOT (PREDICTION)
-- =====================================================
VeilConfig = {
    Enabled              = false,
    ShowFOV              = true,
    ShowTargetLaser      = true,
    FOV                  = 150,
    SpearSpeed           = 165,
    Gravity              = workspace.Gravity * 0.5,
    MaxDist              = 200,
    AutoPredict          = false,
    TargetPart           = "Torso",
    HorizontalPredictFactor = 1.0,
}

VeilState = {
    chargingSpear    = false,
    touchInput       = nil,
    attackCooldown   = false,
    passiveCooldown  = false,
    remoteHooked     = false,
    lastPredictedPos = nil,
}

VeilVelocityCache = {}

VeilDraw = {
    FOVCircle = Drawing.new("Circle"),
    Highlight = Instance.new("Highlight"),
    Tracer    = Drawing.new("Circle"),
}

VeilDraw.FOVCircle.Color     = Color3.fromRGB(255, 0, 255)
VeilDraw.FOVCircle.Thickness = 1.5
VeilDraw.FOVCircle.Filled    = false
VeilDraw.FOVCircle.Visible   = false

VeilDraw.Highlight.Name                = "VD_VeilTarget"
VeilDraw.Highlight.FillColor           = Color3.fromRGB(255, 0, 0)
VeilDraw.Highlight.OutlineColor        = Color3.fromRGB(255, 255, 255)
VeilDraw.Highlight.FillTransparency    = 0.5
VeilDraw.Highlight.OutlineTransparency = 0

VeilDraw.Tracer.Thickness = 2
VeilDraw.Tracer.Radius    = 5
VeilDraw.Tracer.Color     = Color3.fromRGB(255, 0, 255)
VeilDraw.Tracer.Filled    = true
VeilDraw.Tracer.Visible   = false

function Veil_GetRealVelocity(part, playerName)
    if not part then return Vector3.zero end
    local currentPos = part.Position
    local currentTime = tick()
    if not VeilVelocityCache[playerName] then
        VeilVelocityCache[playerName] = {lastPos = currentPos, lastTime = currentTime, velocity = Vector3.zero}
        return Vector3.zero
    end
    local cache = VeilVelocityCache[playerName]
    local dt = currentTime - cache.lastTime
    if dt > 0.01 then
        local rawVelocity = (currentPos - cache.lastPos) / dt
        if rawVelocity.Magnitude < 100 then
            cache.velocity = cache.velocity:Lerp(rawVelocity, 0.4)
        end
    end
    cache.lastPos = currentPos
    cache.lastTime = currentTime
    return cache.velocity
end

function veil_getTargetPart(char)
    if VeilConfig.TargetPart == "Head" then
        return char:FindFirstChild("Head")
    elseif VeilConfig.TargetPart == "Root" then
        return char:FindFirstChild("HumanoidRootPart")
    else
        return char:FindFirstChild("Torso")
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("HumanoidRootPart")
    end
end

function veil_getClosestSurvivor()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local cam      = workspace.CurrentCamera
    local center   = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local bestDist = VeilConfig.FOV
    local bestTarget = nil

    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" and p.Character then
            local char = p.Character
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local part = veil_getTargetPart(char)
            if hum and hum.Health > 0 and part then
                local dist3D = (part.Position - myRoot.Position).Magnitude
                if dist3D <= VeilConfig.MaxDist then
                    local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist2D < bestDist then
                            bestDist   = dist2D
                            bestTarget = { Player = p, Part = part }
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

function veil_setupInterceptor()
    if VeilState.remoteHooked then return end
    task.spawn(function()
        pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                if not checkcaller() then
                    if string.lower(method) == "kick" then
                        return nil
                    end

                    if method == "GetAttribute" then
                        if args[1] == "LakeMist" and VD.KILLER_InfLakeMist then
                            local caller = getcallingscript()
                            if caller and caller.Name == "AwardLog" then return 0 end
                            return false
                        end
                        if args[1] == "Pursuit" and VD.KILLER_InfPursuit then
                            local caller = getcallingscript()
                            if caller and caller.Name == "AwardLog" then return 0 end
                            return false
                        end
                    end

                    if method == "GetAttributes" then
                        if VD.KILLER_InfLakeMist or VD.KILLER_InfPursuit then
                            local attrs = oldNamecall(self, ...)
                            if type(attrs) == "table" then
                                local caller = getcallingscript()
                                if caller and caller.Name == "AwardLog" then
                                    if VD.KILLER_InfLakeMist then attrs.LakeMist = 0 end
                                    if VD.KILLER_InfPursuit then attrs.Pursuit = 0 end
                                else
                                    if VD.KILLER_InfLakeMist then attrs.LakeMist = false end
                                    if VD.KILLER_InfPursuit then attrs.Pursuit = false end
                                end
                                return attrs
                            end
                        end
                    end

                    if method == "FireServer" then
                        if self.Name == "Spearthrow" and VeilConfig.Enabled then
                            return nil
                        end

                        if VD.KILLER_InfLakeMist and self.Name == "LakeMist" then
                            local a1 = args[1]
                            if a1 == false then
                                return nil
                            elseif a1 == true then
                                task.delay(0.2, function()
                                    pcall(function()
                                        local c = game:GetService("Players").LocalPlayer.Character
                                        if c and c:GetAttribute("action") == true then
                                            c:SetAttribute("action", false)
                                        end
                                    end)
                                end)
                            end
                        end

                        if VD.KILLER_InfPursuit and self.Name == "Pursuit" then
                            local a1 = args[1]
                            if a1 == false then
                                return nil
                            elseif a1 == true then
                                task.delay(0.2, function()
                                    pcall(function()
                                        local c = game:GetService("Players").LocalPlayer.Character
                                        if c and c:GetAttribute("action") == true then
                                            c:SetAttribute("action", false)
                                        end
                                    end)
                                end)
                            end
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
            VeilState.remoteHooked = true
        end)
    end)
end
veil_setupInterceptor()

function veil_fire()
    if VeilState.attackCooldown then return end
    VeilState.attackCooldown = true
    task.delay(2, function() VeilState.attackCooldown = false end)

    local myChar    = LocalPlayer.Character
    local startPart = myChar and (myChar:FindFirstChild("Head") or myChar:FindFirstChild("HumanoidRootPart"))
    if not startPart then return end

    local startPos   = startPart.Position
    local targetInfo = veil_getClosestSurvivor()
    local aimDir

    if targetInfo and targetInfo.Part then
        local targetPart = targetInfo.Part
        local targetPlayer = targetInfo.Player
        local targetPos = targetPart.Position

        local velocity = Veil_GetRealVelocity(targetPart, targetPlayer.Name)
        local horizontalVel = Vector3.new(velocity.X, 0, velocity.Z)
        local speed = horizontalVel.Magnitude

        local distance = (targetPos - startPos).Magnitude
        local timeToHit = distance / VeilConfig.SpearSpeed

        local horizontalPrediction = Vector3.zero
        if speed > 4 and VeilConfig.AutoPredict then
            local factor = VeilConfig.HorizontalPredictFactor
            horizontalPrediction = horizontalVel * timeToHit * factor
        end
        local predictedPos = targetPos + horizontalPrediction

        local autoGravity = math.max(0, distance - 8)
        local gravity = VeilConfig.AutoPredict and autoGravity or VeilConfig.Gravity
        local drop = 0.5 * gravity * (timeToHit ^ 2)
        local finalPos = predictedPos + Vector3.new(0, drop, 0)

        aimDir = (finalPos - startPos).Unit
        VeilState.lastPredictedPos = finalPos
    else
        aimDir = workspace.CurrentCamera.CFrame.LookVector
        VeilState.lastPredictedPos = nil
    end

    pcall(function()
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remotes then
            local killers = remotes:FindFirstChild("Killers")
            if killers then
                local veil = killers:FindFirstChild("Veil")
                if veil and veil:FindFirstChild("Spearthrow") then
                    veil.Spearthrow:FireServer(aimDir, VeilConfig.SpearSpeed, startPos)
                end
            end
        end
    end)

    VeilDraw.FOVCircle.Color = Color3.fromRGB(255, 0, 255)
    if not VeilState.passiveCooldown then
        VeilState.passiveCooldown = true
        task.delay(30, function()
            VeilDraw.FOVCircle.Color = Color3.fromRGB(255, 0, 255)
            VeilState.passiveCooldown = false
        end)
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    if gp and not isTouch then return end
    local char = LocalPlayer.Character
    local isSpearMode = char and char:GetAttribute("spearmode") == true
    if not VeilConfig.Enabled then return end
    if not isSpearMode then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        VeilState.chargingSpear = true
    elseif isTouch then
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            local slasher = pGui:FindFirstChild("Slasher-mob")
            if slasher then
                local ctrl = slasher:FindFirstChild("Controls")
                if ctrl then
                    local attackBtn = ctrl:FindFirstChild("attack")
                    if attackBtn and attackBtn.Visible then
                        local pos     = input.Position
                        local absPos  = attackBtn.AbsolutePosition
                        local absSize = attackBtn.AbsoluteSize
                        if pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
                        and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y then
                            VeilState.chargingSpear = true
                            VeilState.touchInput    = input
                        end
                    end
                end
            end
        end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gp)
    if VeilState.chargingSpear
    and (input == VeilState.touchInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
        VeilState.chargingSpear = false
        if VeilState.touchInput == input then VeilState.touchInput = nil end
        veil_fire()
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    local cam         = workspace.CurrentCamera
    local myChar      = LocalPlayer.Character
    local isSpearMode = myChar and myChar:GetAttribute("spearmode") == true

    if VeilConfig.Enabled and VeilConfig.ShowFOV and isSpearMode then
        VeilDraw.FOVCircle.Visible  = true
        VeilDraw.FOVCircle.Radius   = VeilConfig.FOV
        VeilDraw.FOVCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    else
        VeilDraw.FOVCircle.Visible = false
    end

    if VeilState.chargingSpear and VeilConfig.Enabled and isSpearMode then
        local target = veil_getClosestSurvivor()
        if target and target.Part and target.Part.Parent then
            VeilDraw.Highlight.Parent = target.Part.Parent
            
            if VeilConfig.ShowTargetLaser then
                if not getgenv().KYS_SpearLaserPart then
                    local laser = Instance.new("Part")
                    laser.Name = "SpearSilentAimLaser"
                    laser.Anchored = true
                    laser.CanCollide = false
                    laser.CanTouch = false
                    laser.CastShadow = false
                    laser.Material = Enum.Material.Neon
                    laser.Color = Color3.fromRGB(255, 50, 50)
                    laser.Transparency = 0
                    laser.Parent = workspace
                    getgenv().KYS_SpearLaserPart = laser
                end
                
                local originPart = myChar and (myChar:FindFirstChild("Head") or myChar:FindFirstChild("HumanoidRootPart"))
                if originPart then
                    local originPos = originPart.Position
                    local targetPos = target.Part.Position
                    local dist = (targetPos - originPos).Magnitude
                    if dist > 0.1 then
                        local laser = getgenv().KYS_SpearLaserPart
                        laser.Size = Vector3.new(0.16, 0.16, dist)
                        laser.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
                        laser.Transparency = 0.5
                    end
                end
            else
                if getgenv().KYS_SpearLaserPart then getgenv().KYS_SpearLaserPart.Transparency = 1 end
            end
        else
            VeilDraw.Highlight.Parent = nil
            if getgenv().KYS_SpearLaserPart then getgenv().KYS_SpearLaserPart.Transparency = 1 end
        end
    else
        VeilDraw.Highlight.Parent = nil
        if getgenv().KYS_SpearLaserPart then getgenv().KYS_SpearLaserPart.Transparency = 1 end
    end

    if VeilConfig.Enabled and isSpearMode and VeilState.lastPredictedPos then
        local screenPos, onScreen = cam:WorldToViewportPoint(VeilState.lastPredictedPos)
        local viewport = cam.ViewportSize
        local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

        if onScreen then
            VeilDraw.Tracer.Position = Vector2.new(screenPos.X, screenPos.Y)
        else
            local dx = screenPos.X - center.X
            local dy = screenPos.Y - center.Y
            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                VeilDraw.Tracer.Position = center
            else
                local angle = math.atan2(dy, dx)
                local maxX = viewport.X / 2 - 10
                local maxY = viewport.Y / 2 - 10
                local scaleX = maxX / math.abs(dx)
                local scaleY = maxY / math.abs(dy)
                local scale = math.min(scaleX, scaleY)
                local borderPos = Vector2.new(
                    center.X + dx * scale,
                    center.Y + dy * scale
                )
                VeilDraw.Tracer.Position = borderPos
            end
        end
        VeilDraw.Tracer.Visible = true
    else
        VeilDraw.Tracer.Visible = false
    end
end)

-- =====================================================
-- UI TABS
-- =====================================================
local Main, ESPTab, MapTab, FOVTab
local SurvivorTab, KillerTab, GeneratorTab, FlingTab, SettingsTab, ResetTab
local VisualTab, MainTab, AimTab, MappingTab, PlayerTab
local VisualFeatureTabs, MainFeatureTabs, MainKillerFeatureTabs, AimFeatureTabs, MappingFeatureTabs, PlayerFeatureTabs, PlayerMiscFeatureTabs
local KYS_MainInfoPanel = {
    Widgets = {},
    Texts = {},
}

function KYS_InfoPlainText(text)
    text = tostring(text or "")
    text = text:gsub("<br%s*/?>", "\n")
    text = text:gsub("<[^>]->", "")
    text = text:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&amp;", "&")
    return text
end

function KYS_UpdateInfoWidget(widget, text)
    if not widget then return end
    local title, content = tostring(text or ""):match("^(.-)\n(.*)$")
    title = title or tostring(text or "")
    content = content or ""
    pcall(function()
        if type(widget.Set) == "function" then
            pcall(function() widget:Set({ Name = title, Title = title, Content = content, Description = content, Text = content }) end)
            widget:Set(text)
        elseif type(widget.SetText) == "function" then
            widget:SetText(text)
        elseif type(widget.SetContent) == "function" then
            widget:SetContent(content)
        elseif type(widget.SetDescription) == "function" then
            widget:SetDescription(content)
        elseif type(widget.Update) == "function" then
            pcall(function() widget:Update({ Name = title, Title = title, Content = content, Description = content, Text = content }) end)
            widget:Update(text)
        elseif type(widget.SetValue) == "function" then
            widget:SetValue(text)
        end
    end)
    pcall(function()
        if widget.Text ~= nil then widget.Text = text end
        if widget.Name ~= nil and type(widget.Name) == "string" then widget.Name = title end
        if widget.TextLabel then widget.TextLabel.Text = content ~= "" and content or text end
        if widget.Label then widget.Label.Text = text end
        if widget.Title then widget.Title.Text = title end
        if widget.Content then widget.Content.Text = content ~= "" and content or text end
        if widget.Description then widget.Description.Text = content end
    end)
end

function KYS_SetMainInfoPanelText(key, title, text)
    local value = tostring(title or key) .. "\n" .. KYS_InfoPlainText(text)
    KYS_MainInfoPanel.Texts[key] = value
    KYS_UpdateInfoWidget(KYS_MainInfoPanel.Widgets[key], value)
end

function KYS_RegisterMainInfoWidget(key, widget)
    KYS_MainInfoPanel.Widgets[key] = widget
    if KYS_MainInfoPanel.Texts[key] then
        KYS_UpdateInfoWidget(widget, KYS_MainInfoPanel.Texts[key])
    end
end

function KYS_AddMainInfoLine(section, key, title, defaultText)
    local defaultValue = tostring(title) .. "\n" .. tostring(defaultText or "Off")
    KYS_MainInfoPanel.Texts[key] = KYS_MainInfoPanel.Texts[key] or defaultValue

    local ok, widget = pcall(function()
        if section.AddParagraph then
            return section:AddParagraph({
                Name = title,
                Title = title,
                Content = tostring(defaultText or "Off"),
                Description = tostring(defaultText or "Off"),
                Text = tostring(defaultText or "Off"),
            })
        end
    end)
    if ok and widget then return KYS_RegisterMainInfoWidget(key, widget) end

    ok, widget = pcall(function()
        if section.AddLabel then
            return section:AddLabel({
                Name = defaultValue,
                Text = defaultValue,
            })
        end
    end)
    if ok and widget then return KYS_RegisterMainInfoWidget(key, widget) end

    ok, widget = pcall(function()
        if section.AddButton then
            return section:AddButton({
                Name = defaultValue,
                Callback = function() end,
            })
        end
    end)
    if ok and widget then return KYS_RegisterMainInfoWidget(key, widget) end
end

if Window then

    local function makeModernAdapter(section)
        local adapter = {}
        setmetatable(adapter, {
            __index = function(t, k)
                if k == "AddSection" then
                    return function(self, cfg)
                        if cfg and cfg.Name then
                            pcall(function() section:AddDivider({ Text = cfg.Name }) end)
                        end
                        return adapter
                    end
                end
                if k == "AddSlider" then
                    return function(self, cfg)
                        if cfg and cfg.Name then
                            local modernCfg = {
                                Name = cfg.Name,
                                Flag = cfg.Flag or cfg.Name,
                                Min = cfg.Min or 0,
                                Max = cfg.Max or 100,
                                Default = cfg.Default or cfg.Min or 0,
                                Value = cfg.Default or cfg.Min or 0,
                                Increment = cfg.Increment or 1,
                            }
                            local isFloat = false
                            if modernCfg.Increment < 1 or (math.floor(modernCfg.Min) ~= modernCfg.Min) or (math.floor(modernCfg.Max) ~= modernCfg.Max) then
                                isFloat = true
                            end
                            if isFloat then
                                modernCfg.Rounding = 1
                                if modernCfg.Increment <= 0.01 then
                                    modernCfg.Rounding = 2
                                end
                            else
                                modernCfg.Rounding = 0
                            end
                            modernCfg.Callback = function(Value)
                                if cfg.Callback then
                                    pcall(function() cfg.Callback(Value) end)
                                end
                            end
                            pcall(function() section:AddSlider(modernCfg) end)
                        end
                        return adapter
                    end
                end

                if type(section[k]) == "function" then
                    return function(self, ...)
                        return section[k](section, ...)
                    end
                end
                return section[k]
            end
        })
        return adapter
    end

    local Tabs = {
        Visual = Window:AddTab({ Name = "Visual", Icon = "lucide:eye", Type = "Single" }),
        Main = Window:AddTab({ Name = "Main", Icon = "lucide:cpu", Type = "Single" }),
        Aim = Window:AddTab({ Name = "Aim", Icon = "lucide:crosshair", Type = "Single" }),
        Mapping = Window:AddTab({ Name = "Mapping", Icon = "lucide:map", Type = "Single" }),
        Player = Window:AddTab({ Name = "Player", Icon = "lucide:user", Type = "Single" }),
    }

    local function adaptTab(tab)
        local adapter = {}
        setmetatable(adapter, {
            __index = function(t, k)
                if k == "AddSection" then
                    return function(self, cfg)
                        if cfg and cfg.Name then
                            pcall(function() tab:AddDivider({ Text = cfg.Name }) end)
                        end
                        return makeModernAdapter(tab)
                    end
                end
                return tab[k]
            end
        })
        return adapter
    end

    local function addCenterFeatureTabbox(tab, name, entries)
        local tabbox = tab:AddCenterTabbox(name)
        local created = {}

        for _, entry in ipairs(entries) do
            created[entry.Key] = makeModernAdapter(tabbox:AddTab({
                Name = entry.Name,
                Icon = entry.Icon,
            }))
        end

        return created
    end

    VisualFeatureTabs = addCenterFeatureTabbox(Tabs.Visual, "Visual Features", {
        { Key = "ESP", Name = "ESP", Icon = "lucide:eye" },
        { Key = "Camera", Name = "Camera", Icon = "solar:camera-bold" },
        { Key = "Lighting", Name = "Lighting", Icon = "solar:sun-bold" },
    })

    MainFeatureTabs = addCenterFeatureTabbox(Tabs.Main, "Main Features", {
        { Key = "Survivor", Name = "Survivor", Icon = "solar:shield-bold" },
        { Key = "Escape", Name = "Escape", Icon = "solar:exit-bold" },
        { Key = "Automation", Name = "Automation", Icon = "solar:bolt-bold" },
    })

    MainKillerFeatureTabs = addCenterFeatureTabbox(Tabs.Main, "Killer & Utilities", {
        { Key = "Killer", Name = "Killer", Icon = "solar:danger-bold" },
        { Key = "Ability", Name = "Killer Ability", Icon = "solar:bolt-bold" },
        { Key = "Utilities", Name = "Utilities", Icon = "solar:settings-bold" },
    })

    AimFeatureTabs = addCenterFeatureTabbox(Tabs.Aim, "Aim Features", {
        { Key = "Aimbot", Name = "Aimbot", Icon = "solar:target-bold" },
        { Key = "Spear", Name = "Killer Aim", Icon = "lucide:sword" },
        { Key = "AutoAim", Name = "Survivor Aim", Icon = "solar:magic-stick-3-bold" },
    })

    MappingFeatureTabs = addCenterFeatureTabbox(Tabs.Mapping, "Mapping Features", {
        { Key = "Teleport", Name = "Teleport", Icon = "solar:map-point-bold" },
        { Key = "Radar", Name = "Radar", Icon = "solar:radar-bold" },
    })

    PlayerFeatureTabs = addCenterFeatureTabbox(Tabs.Player, "Player Features", {
        { Key = "Movement", Name = "Movement", Icon = "solar:running-round-bold" },
        { Key = "Fling", Name = "Fling", Icon = "solar:wind-bold" },
        { Key = "Emote", Name = "Emote [BETA]", Icon = "solar:music-note-bold" },
    })

    PlayerMiscFeatureTabs = addCenterFeatureTabbox(Tabs.Player, "Player Misc", {
        { Key = "Fun", Name = "Fun", Icon = "solar:gamepad-bold" },
        { Key = "Streamer", Name = "Streamer Mode", Icon = "solar:settings-bold" },
        { Key = "Avatar", Name = "Avatar Tools", Icon = "solar:users-group-rounded-bold" },
    })

    VisualTab = VisualFeatureTabs.ESP
    MainTab = adaptTab(Tabs.Main)
    AimTab = adaptTab(Tabs.Aim)
    MappingTab = MappingFeatureTabs.Teleport
    PlayerTab = adaptTab(Tabs.Player)

end

if Window then

do -- Player Tab
    local movSection = PlayerFeatureTabs.Movement:AddSection({
        Position = "Center",
        Name = "Movement",
        Icon      = "solar:running-round-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    movSection:AddToggle({
        Default = false,
        Name = "Auto Crouch BETA",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "Auto Crouch BETA",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur Auto Crouch BETA hanya untuk pengguna Key Premium!", 5)
                return
            end
            setAutoCrouch(v)
        end
    })

    movSection:AddToggle({
        Default = false,
        Name = "Speed Hack", Flag = "Speed Hack",
        Callback = function(v)
            VD.Speed = v
            if not v then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.WalkSpeed = 16 end) end
            end
        end
    })
    movSection:AddSlider({
        Name = "Speed Value", Flag = "Speed Value",
        Min = 16, Max = 200, Default = 16,
        Callback = function(v)
            VD.SpeedValue =
                v
        end
    })
    movSection:AddToggle({
        Default = false,
        Name = "Jump Hack", Flag = "Jump Hack",
        Callback = function(v)
            VD.Jump = v
            if not v then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.JumpPower = 0 end) end
            end
        end
    })
    movSection:AddSlider({
        Name = "Jump Power", Flag = "Jump Power",
        Min = 50, Max = 300, Default = 50,
        Callback = function(v)
            VD.JumpValue =
                v
        end
    })
    movSection:AddToggle({ Default = false, Name = "Infinite Jump", Flag = "Infinite Jump", Callback = function(v) VD.InfiniteJump = v end })
    movSection:AddToggle({ Default = false, Name = "Anti Fall Damage", Flag = "Anti Fall Damage", Callback = function(v) VD.AntiFallDamage = v end })
    movSection:AddToggle({ Default = false, Name = "Noclip", Flag = "Noclip", Callback = function(v) 
        VD.Noclip = v 
        if not v and getgenv().VD_DisableNoclip then pcall(getgenv().VD_DisableNoclip) end
    end })
    movSection:AddToggle({ Default = false, Name = "Moonwalk", Flag = "Moonwalk", Callback = function(v)
        if getgenv().VD_SetMoonwalkButtonVisible then
            getgenv().VD_SetMoonwalkButtonVisible(v)
        else
            VD.MoonwalkButton = v
        end
    end })
    movSection:AddToggle({ Default = false, Name = "Lock Moonwalk Button", Flag = "Lock Moonwalk Button", Callback = function(v)
        VD.MoonwalkButtonLocked = v and true or false
    end })
    movSection:AddSlider({
        Name = "Moonwalk Zigzag Speed", Flag = "Moonwalk Zigzag Speed",
        Min = 1, Max = 30, Default = 11,
        Callback = function(v)
            VD.MoonwalkZigzagSpeed = v
        end
    })
    movSection:AddSlider({
        Name = "Moonwalk Boost Power", Flag = "Moonwalk Boost Power",
        Min = 1, Max = 2, Default = 1.08, Increment = 0.01,
        Callback = function(v)
            VD.MoonwalkBoostPower = v
        end
    })
    movSection:AddToggle({ Default = false, Name = "Invisible Not Visual", Locked = false, TextLocked = "Premium Required", Flag = "Invisible Not Visual", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Invisible Not Visual hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.InvisibleNotVisual = v; if not v and VD_InvisibleNV.Active then pcall(VD_SetInvisibleNotVisual, false) end 
    end })
    movSection:AddSlider({
        Name = "Invisible Speed", Flag = "Invisible Speed",
        Min = 1, Max = 999, Default = 5,
        Callback = function(v)
            VD.InvisibleSpeed = v
        end
    })
    movSection:AddToggle({ Default = false, Name = "Anti AFK", Flag = "Anti AFK", Callback = function(v) VD.AntiAFK = v end })

    -- removed PlayerTab AddDivider
end

do -- ESP Tab
    -- Visual Highlight ESP baru masuk di sini.
    -- Drawing ESP PC lama tetap dipertahankan.
    pcall(function()
        if getgenv().KYS_AddVisualESPControls then
            getgenv().KYS_AddVisualESPControls(VisualTab)
        end
    end)

end

do -- Aim Tab
    local aimbotSection = AimFeatureTabs.Aimbot:AddSection({
        Position = "Center",
        Name = "Aimbot",
        Icon      = "solar:target-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    aimbotSection:AddToggle({ Default = false, Name = "Enable Aimbot", Flag = "Enable Aimbot", Callback = function(v) VD.AIM_Enabled = v end })

    aimbotSection:AddToggle({ Default = false, Name = "Use RMB to aim", Flag = "Use RMB to aim", Callback = function(v) VD.AIM_UseRMB = v end })
    aimbotSection:AddToggle({ Default = false, Name = "Show FOV Circle", Flag = "Show FOV Circle", Callback = function(v) VD.AIM_ShowFOV = v end })
    aimbotSection:AddSlider({
        Name = "FOV Size (aim radius on screen)", Flag = "FOV Size (aim radius on screen)",
        Min = 20, Max = 400, Default = 120,
        Callback = function(
            v)
            VD.AIM_FOV = v
        end
    })
    aimbotSection:AddSlider({
        Name = "Smoothness (Speed Aim)", Flag = "Smoothness",
        Min = 0.1, Max = 10, Default = 0.3, Increment = 0.05,
        Callback = function(v)
            VD.AIM_Smooth = v
        end
    })

    aimbotSection:AddToggle({ Default = false, Name = "Visibility Check", Flag = "Visibility Check", Callback = function(v) VD.AIM_VisCheck = v end })
    aimbotSection:AddToggle({ Default = false, Name = "Prediction", Flag = "Prediction", Callback = function(v) VD.AIM_Predict = v end })

    local crosshairSection = AimFeatureTabs.Aimbot:AddSection({
        Position = "Center",
        Name = "Advanced Crosshair",
        Icon      = "solar:target-broken",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    crosshairSection:AddToggle({ Default = false, Name = "Enable Crosshair", Flag = "CROSS_Enabled", Callback = function(v) VD.CROSS_Enabled = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddColorPicker({ Name = "Crosshair Color", Flag = "CROSS_Color", Default = VD.CROSS_Color or Color3.fromRGB(255, 255, 255), Callback = function(v) VD.CROSS_Color = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddDropdown({ Name = "Crosshair Style", Flag = "CROSS_Style", Default = "Dot", Values = { "Dot", "Plus", "X", "Box" }, Multi = false, Callback = function(v) VD.CROSS_Style = type(v) == "table" and v[1] or v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Crosshair Size", Flag = "CROSS_Size", Min = 1, Max = 100, Default = 3, Increment = 1, Callback = function(v) VD.CROSS_Size = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Crosshair Thickness", Flag = "CROSS_Thickness", Min = 1, Max = 20, Default = 4, Increment = 1, Callback = function(v) VD.CROSS_Thickness = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Crosshair Gap", Flag = "CROSS_Gap", Min = 0, Max = 50, Default = 6, Increment = 1, Callback = function(v) VD.CROSS_Gap = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Position X Offset", Flag = "CROSS_PosX", Min = -500, Max = 500, Default = 0, Increment = 1, Callback = function(v) VD.CROSS_PosX = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Position Y Offset", Flag = "CROSS_PosY", Min = -500, Max = 500, Default = 0, Increment = 1, Callback = function(v) VD.CROSS_PosY = v pcall(VD_UpdateCrosshair) end })

    local spearSection = AimFeatureTabs.Spear:AddSection({
        Position = "Center",
        Name = "Aimbot Spear (Veil)",
        Icon      = "lucide:sword",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    spearSection:AddToggle({ Default = false, Name = "Spear Aimbot", Flag = "Spear Aimbot", Callback = function(v) VD.SPEAR_Aimbot = v end })

    spearSection:AddSlider({
        Name = "Spear Gravity", Flag = "Spear Gravity",
        Min = 10, Max = 200, Default = 50,
        Callback = function(v)
            VD.SPEAR_Gravity =
                v
        end
    })
    spearSection:AddSlider({
        Name = "Spear Speed", Flag = "Spear Speed",
        Min = 50, Max = 300, Default = 100,
        Callback = function(v)
            VD.SPEAR_Speed =
                v
        end
    })
    spearSection:AddKeybind({
        Name = "Toggle Keybind (PC)", Flag = "Spear Keybind", Default = "None",
        Callback = function()
            if not VD.SPEAR_Aimbot or GetRole() ~= "Killer" then return end
            SpearBtnData.Active = not SpearBtnData.Active
            if SpearBtnData.Active then
                pcall(VD_Notify, "Spear Aimbot", "Spear Aimbot AKTIF!", 3)
            else
                pcall(VD_Notify, "Spear Aimbot", "Spear Aimbot NONAKTIF", 3)
            end
        end
    })

    spearSection:AddDivider({ Text = "Silent Aim (Veil)" })

    spearSection:AddToggle({ Default = false, Name = "Silent Aim Spear (Veil)", Locked = false, TextLocked = "Premium Required", Flag = "Silent Aim Spear (Veil)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Silent Aim Spear hanya untuk pengguna Key Premium!", 5)
            return
        end
        VeilConfig.Enabled = v
    end })
    spearSection:AddToggle({ Default = true, Name = "Show FOV Circle", Flag = "Show FOV Circle", Callback = function(v) VeilConfig.ShowFOV = v end })
    spearSection:AddToggle({ Default = true, Name = "Show Target Laser", Flag = "Show Target Laser", Callback = function(v) VeilConfig.ShowTargetLaser = v end })
    spearSection:AddSlider({ Name = "FOV Radius", Flag = "FOV Radius", Min = 50, Max = 500, Default = 150, Callback = function(v) VeilConfig.FOV = v end })
    spearSection:AddToggle({ Default = false, Name = "Auto Predict", Flag = "Auto Predict", Callback = function(v) VeilConfig.AutoPredict = v end })
    spearSection:AddSlider({ Name = "Spear Speed", Flag = "Spear Speed", Min = 50, Max = 300, Default = 165, Callback = function(v) VeilConfig.SpearSpeed = v end })
    spearSection:AddSlider({ Name = "Gravity", Flag = "Gravity", Min = 0, Max = 300, Default = math.floor(workspace.Gravity * 0.5), Callback = function(v) VeilConfig.Gravity = v end })
    spearSection:AddSlider({ Name = "Horizontal Vector", Flag = "Horizontal Vector", Min = 0, Max = 5, Default = 1.0, Decimals = 2, Callback = function(v) VeilConfig.HorizontalPredictFactor = v end })
    spearSection:AddDropdown({ Name = "Target Part", Flag = "Target Part", Values = {"Torso", "Head", "Root"}, Default = "Torso", Multi = false, Callback = function(v)
        if type(v) == "table" then v = v[1] end
        VeilConfig.TargetPart = v
    end })

    local flaskSection = AimFeatureTabs.Spear:AddSection({
        Position = "Center",
        Name = "Silent Aim Flask (Cure)",
        Icon      = "lucide:flask-conical",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    flaskSection:AddToggle({ Default = false, Name = "Silent Aim Flask (Cure)", Locked = false, TextLocked = "Premium Required", Flag = "Silent Aim Flask (Cure)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Silent Aim Flask (Cure) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_SilentAimFlask = v
    end })
    flaskSection:AddToggle({ Default = false, Name = "Flask Laser (Cure)", Locked = false, TextLocked = "Premium Required", Flag = "Flask Laser (Cure)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Flask Laser (Cure) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_FlaskLaser = v
        if v then
            pcall(KYS_StartCureFlaskLaser)
        else
            if getgenv().KYS_CureFlaskLaserThread then
                getgenv().KYS_CureFlaskLaserThread:Disconnect()
                getgenv().KYS_CureFlaskLaserThread = nil
            end
            if getgenv().KYS_CureFlaskLaserPart then
                pcall(function() getgenv().KYS_CureFlaskLaserPart:Destroy() end)
                getgenv().KYS_CureFlaskLaserPart = nil
            end
        end
    end })

    local tofSection = AimFeatureTabs.AutoAim:AddSection({
        Position = "Center",
        Name = "Silent Aim Twist Of Fate",
        Icon      = "solar:magic-stick-3-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    tofSection:AddToggle({
        Default = false,
        Name = "Silent Aim Twist Of Fate",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "Silent Aim Twist Of Fate",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur Silent Aim Twist Of Fate hanya untuk pengguna Key Premium!", 5)
                return
            end
            if getgenv().KYS_SetToFSilentAim then
                getgenv().KYS_SetToFSilentAim(v)
            end
        end
    })
    tofSection:AddToggle({
        Default = true,
        Name = "ToF Laser",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "ToF Laser",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur ToF Laser hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.TOF_Laser = v
            if not v and getgenv().KYS_ToFClearLaser then
                getgenv().KYS_ToFClearLaser()
            end
        end
    })
    tofSection:AddToggle({
        Default = false,
        Name = "ToF Wall Check",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "ToF Wall Check",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur ToF Wall Check hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.TOF_WallCheck = v
        end
    })
    tofSection:AddToggle({
        Default = true,
        Name = "ToF Block When Knocked",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "ToF Block When Knocked",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur ToF Block When Knocked hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.TOF_BlockKnocked = v
        end
    })
    tofSection:AddDropdown({
        Name = "ToF Target Mode",
        Flag = "ToF Target Mode",
        Values = { "Killer", "Survivors", "Zombie" },
        Default = VD.TOF_TargetMode or "Killer",
        Multi = false,
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            if getgenv().KYS_ToFSetTargetMode then
                getgenv().KYS_ToFSetTargetMode(v or "Killer", false)
            else
                VD.TOF_TargetMode = v or "Killer"
            end
        end
    })
    tofSection:AddDropdown({
        Name = "Silent Aim Key",
        Flag = "Silent Aim Key",
        Values = { "None", "Q", "E", "R", "T", "F", "G", "H", "J", "K", "L", "X", "Z" },
        Default = VD.TOF_Key or "None",
        Multi = false,
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            VD.TOF_Key = v or "None"
        end
    })

    local flashlightSection = AimFeatureTabs.AutoAim:AddSection({
        Position = "Center",
        Name = "Silent Aim Flashlight",
        Icon      = "lucide:flashlight",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    flashlightSection:AddToggle({
        Default = false,
        Name = "Silent Aim Flashlight",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "Silent Aim Flashlight",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur Silent Aim Flashlight hanya untuk pengguna Key Premium!", 5)
                return
            end
            if getgenv().KYS_SetFlashlightSilentAim then
                getgenv().KYS_SetFlashlightSilentAim(v)
            else
                VD.FLASH_SilentAim = v
            end
        end
    })
    flashlightSection:AddToggle({
        Default = true,
        Name = "Flashlight Laser",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "Flashlight Laser",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur Flashlight Laser hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.FLASH_Laser = v
            if not v and getgenv().KYS_ClearFlashlightLaser then
                getgenv().KYS_ClearFlashlightLaser()
            end
        end
    })
    flashlightSection:AddDropdown({
        Name = "Flashlight Target Part",
        Flag = "Flashlight Target Part",
        Values = { "Head", "HumanoidRootPart", "UpperTorso", "Torso" },
        Default = VD.FLASH_TargetPart or "Head",
        Multi = false,
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            VD.FLASH_TargetPart = v or "Head"
        end
    })
    flashlightSection:AddSlider({
        Name = "Flashlight Range",
        Flag = "Flashlight Range",
        Min = 20,
        Max = 250,
        Default = tonumber(VD.FLASH_Range) or 120,
        Callback = function(v)
            VD.FLASH_Range = tonumber(v) or 120
        end
    })
    flashlightSection:AddSlider({
        Name = "Flashlight Smoothness",
        Flag = "Flashlight Smoothness",
        Min = 0.05,
        Max = 1,
        Default = tonumber(VD.FLASH_Smooth) or 0.35,
        Decimals = 2,
        Callback = function(v)
            VD.FLASH_Smooth = tonumber(v) or 0.35
        end
    })

end

do -- FOV Tab
    local camSection = VisualFeatureTabs.Camera:AddSection({
        Position = "Center",
        Name = "Camera",
        Icon      = "solar:camera-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    camSection:AddToggle({ Default = false, Name = "Enable Camera FOV override", Flag = "Enable Camera FOV override", Callback = function(v) VD.CAM_FOVEnabled = v end })
    camSection:AddSlider({
        Name = "Camera FOV", Flag = "Camera FOV",
        Min = 30, Max = 140, Default = 90,
        Callback = function(v)
            VD.CAM_FOV =
                v
        end
    })
    camSection:AddToggle({ Default = false, Name = "Third Person (Killer only)", Flag = "Third Person (Killer only)", Callback = function(v) VD.CAM_ThirdPerson = v end })
    camSection:AddToggle({ Default = false, Name = "Shift Lock (auto face camera)", Flag = "Shift Lock (auto face camera)", Callback = function(v) VD.CAM_ShiftLock = v end })
    camSection:AddToggle({ Default = false, Name = "Infinity Zoom Out", Flag = "Infinity Zoom Out", Callback = function(v) 
        VD.CAM_InfinityZoom = v 
        LocalPlayer.CameraMaxZoomDistance = v and math.huge or 128 
        LocalPlayer.CameraMinZoomDistance = v and 0 or 0.5 
    end })
    camSection:AddToggle({ Default = false, Name = "No Cutscene", Flag = "No Cutscene", Callback = function(v) VD.NoCutscene = v end })

    -- removed FOVTab AddDivider

    local visualSection = VisualFeatureTabs.Lighting:AddSection({
        Position = "Center",
        Name = "Visual",
        Icon      = "solar:sun-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    visualSection:AddToggle({ Default = false, Name = "No Fog (remove fog/post effects)", Flag = "No Fog (remove fog/post effects)", Callback = function(v) VD.NO_Fog = v end })
    visualSection:AddToggle({ Default = false, Name = "Fullbright (lighting preset)", Flag = "Fullbright (lighting preset)", Callback = function(v)
        VD.Fullbright = v
        if VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" then
            pcall(VD_ApplyWeather, VD.VIS_WeatherTheme)
        end
    end })
    visualSection:AddDropdown({
        Name = "Weather & Sky Theme",
        Default = "Default",
        Values = {"Default", "Christmas (Snow)", "Heavy Rain (Storm)", "Autumn (Musim Gugur)", "Cherry Blossom (Sakura)", "Sunset (Golden Hour)", "Blood Moon (Spooky)", "Toxic Wasteland", "Vaporwave (Synthwave)", "Midnight (Pitch Black)"},
        Flag = "Weather & Sky Theme",
        Callback = function(v)
            VD.VIS_WeatherTheme = v
            pcall(VD_ApplyWeather, v)
        end
    })

    local infoPanelSection = VisualFeatureTabs.Lighting:AddSection({
        Position = "Center",
        Name = "Game Info Panel",
        Icon      = "lucide:panel-top",
        Box       = true,
        BoxBorder = true,
        Opened    = true,
    })

    KYS_AddMainInfoLine(infoPanelSection, "KystKiller", "Kyst Killer Display", "Off")
    KYS_AddMainInfoLine(infoPanelSection, "KillerPerks", "Spectate Killer Perks", "Off")
    KYS_AddMainInfoLine(infoPanelSection, "PredictMap", "Predict Map", "Off")

    visualSection:AddToggle({ Default = false, Name = "Kyst Killer Display", Flag = "Kyst Killer Display", Callback = function(v) 
        VD.VIS_KystKiller = v 
        if v then
            StartKystKiller()
        else
            StopKystKiller()
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Enable Spectator Counter", Flag = "Enable Spectator Counter", Callback = function(v)
        VD.VIS_SpectatorCounter = v
        if v then
            StartSpectatorCounter()
        else
            StopSpectatorCounter()
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Killer Perks Display", Flag = "Killer Perks Display", Callback = function(v)
        VD.VIS_KillerPerks = v
        if v then
            StartKillerPerksDisplay()
        else
            StopKillerPerksDisplay()
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Predict Map", Flag = "Predict Map", Callback = function(v)
        VD.VIS_PredictMap = v
        if v then
            StartPredictMap()
        else
            StopPredictMap()
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Hide Survivor Icon", Flag = "Hide Survivor Icon", Callback = function(v)
        if getgenv().KYS_SetHideSurvivorIcon then
            getgenv().KYS_SetHideSurvivorIcon(v)
        else
            VD.VIS_HideSurvivorIcon = v
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Show Ping & FPS", Flag = "Show Ping & FPS", Callback = function(v)
        if getgenv().KYS_SetShowPingFPS then
            getgenv().KYS_SetShowPingFPS(v)
        else
            VD.VIS_ShowPingFPS = v
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Show Hook Counter", Flag = "Show Hook Counter", Callback = function(v)
        if getgenv().KYS_SetShowHookCounter then
            getgenv().KYS_SetShowHookCounter(v)
        else
            VD.VIS_ShowHookCounter = v
        end
    end })
end

do -- Survivor Tab
    local combatSurv = MainFeatureTabs.Survivor:AddSection({
        Position = "Center",
        Name = "Survivor",
        Icon      = "solar:shield-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    combatSurv:AddToggle({ Default = false, Name = "Swift Vault", Flag = "SwiftVault", Callback = function(v) VD.SURV_AutoVault = v end })
    combatSurv:AddToggle({ Default = false, Name = "Swift Vault V2", Locked = false, TextLocked = "Premium Required", Flag = "SURV_SwiftVaultV2", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Swift Vault V2 hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.SURV_FastVault = v 
        if not v then
            local char = LocalPlayer.Character
            if char then char:SetAttribute("vaultspeed", 1) end
        end
    end })
    combatSurv:AddSlider({
        Name = "Vault Speed", Flag = "SURV_SwiftVaultSpeed",
        Min = 10, Max = 20, Default = 13, Increment = 1,
        Callback = function(v) VD.SURV_VaultSpeed = v end
    })
    combatSurv:AddToggle({ Default = false, Name = "Pallet Reflex", Flag = "Pallet Reflex", Callback = function(v) VD.SURV_AutoPallet = v end })
    combatSurv:AddSlider({
        Name = "Pallet Trigger Range (studs)", Flag = "Pallet Trigger Range",
        Min = 5, Max = 50, Default = 20, Increment = 0.1,
        Callback = function(v) VD.SURV_AutoPalletDist = v end
    })
    combatSurv:AddToggle({ Default = false, Name = "Anti Knock", Locked = false, TextLocked = "Premium Required", Flag = "Anti Knock", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Anti Knock hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.SURV_AntiKnock = v 
    end })
    combatSurv:AddToggle({ Default = false, Name = "Aura Heal (Self)", Flag = "Instant Heal (Self)", Callback = function(v) setInstantHealSelf(v) end })
    combatSurv:AddToggle({ Default = false, Name = "Auto Dodge Spear (Veil)", Locked = false, TextLocked = "Premium Required", Flag = "Auto Dodge Spear", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Auto Dodge Spear hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.SURV_AutoDodgeSpear = v
    end })
    combatSurv:AddToggle({ Default = false, Name = "Aura Heal All", Locked = false, TextLocked = "Premium Required", Flag = "Auto Heal All", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Aura Heal All hanya untuk pengguna Key Premium!", 5)
            return
        end
        setAutoHealAll(v)
    end })

    combatSurv:AddToggle({
        Default = false, Name = "First Person Camera (Survivor)", Flag = "First Person Camera (Survivor)", Callback = function(v)
        VD.SURV_FirstPerson = v
        if not v then
            pcall(RestoreFirstPersonCamera)
        end
    end })
    combatSurv:AddToggle({ Default = false, Name = "Auto Parry", Locked = false, TextLocked = "Premium Required", Flag = "Auto Parry", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Auto Parry hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD_SetAutoParry(v)
    end })
    combatSurv:AddToggle({ Default = false, Name = "Auto Parry Agresif", Flag = "Auto Parry Agresif", Callback = function(v) VD.SURV_ParryAggressive = v end })
    
    combatSurv:AddSlider({
        Name = "Parry Distance Trigger", Flag = "Parry Distance Trigger",
        Min = 2, Max = 25, Default = 8, Increment = 0.1,
        Callback = function(v)
            VD.SURV_ParryDistance = v
        end
    })
    combatSurv:AddToggle({
        Default = false, Name = "Show Parry Range Circle", Flag = "Show Parry Range Circle", Callback = function(v)
        VD.SURV_ShowParryCircle = v
        if VD_ParryRange then VD_ParryRange.Transparency = 1 end
    end })
    
    combatSurv:AddToggle({ Default = false, Name = "Fake Parry (Press V)", Flag = "Fake Parry (Press V)", Callback = function(v) 
        VD.SURV_FakeParry = v
        if FakeParryData.Button then FakeParryData.Button.Visible = v end
    end })
    
    combatSurv:AddDropdown({
        Name = "Fake Parry Animation",
        Values = {"Enten", "Stopwatch", "Fih", "BloodShield"},
        Default = "Enten",
        Multi = false,
        Flag = "Fake Parry Animation",
        Callback = function(v)
            VD.SURV_FakeParryAnim = v
        end
    })
    
    combatSurv:AddToggle({ Default = false, Name = "Undraggable Button (Fake Parry)", Locked = false, TextLocked = "Premium Required", Flag = "Undraggable Button (Fake Parry)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Undraggable Button hanya untuk pengguna Key Premium!", 5)
            return
        end
        FakeParryData.DragLocked = v
    end })
    
    combatSurv:AddToggle({ Default = false, Name = "Fake Generator (Press B)", Flag = "Fake Generator (Press B)", Callback = function(v) 
        VD.SURV_FakeGen = v
        if FakeGenData and FakeGenData.Button then FakeGenData.Button.Visible = v end
    end })

    combatSurv:AddToggle({ Default = false, Name = "Undraggable Button (Fake Gen)", Locked = false, TextLocked = "Premium Required", Flag = "Undraggable Button (Fake Gen)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Undraggable Button hanya untuk pengguna Key Premium!", 5)
            return
        end
        if FakeGenData then FakeGenData.DragLocked = v end
    end })

    -- removed SurvivorTab AddDivider
end

local FakeParryAnimations = {
    ["Enten"]       = "rbxassetid://127096285501517",
    ["Stopwatch"]   = "rbxassetid://81793464499285",
    ["Fih"]         = "rbxassetid://123307242865945",
    ["BloodShield"] = "rbxassetid://75939529748815",
}
getgenv().KYS_FakeParryTrack = nil

-- FAKE PARRY MOBILE UI DATA
FakeParryData = {
    UI = nil,
    Button = nil,
    DragLocked = false,
    Dragging = false,
    DragStart = nil,
    DragStartPos = nil
}

function setupFakeParryBtn()
    local player = game:GetService("Players").LocalPlayer
    local oldUI = player.PlayerGui:FindFirstChild("FakeParryUI")
    if oldUI then oldUI:Destroy() end

    FakeParryData.UI = Instance.new("ScreenGui")
    FakeParryData.UI.Name = "FakeParryUI"
    FakeParryData.UI.ResetOnSpawn = false
    FakeParryData.UI.IgnoreGuiInset = true
    FakeParryData.UI.Parent = player:WaitForChild("PlayerGui")

    FakeParryData.Button = Instance.new("ImageButton")
    FakeParryData.Button.Name = "FakeParryButton"
    FakeParryData.Button.Size = UDim2.new(0, 60, 0, 60)
    FakeParryData.Button.Position = UDim2.new(0.3, 0, 0.75, 0)
    FakeParryData.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    FakeParryData.Button.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
    FakeParryData.Button.BackgroundTransparency = 0.15
    FakeParryData.Button.AutoButtonColor = true
    if type(VD) == "table" then FakeParryData.Button.Visible = VD.SURV_FakeParry else FakeParryData.Button.Visible = false end
    FakeParryData.Button.ZIndex = 10
    FakeParryData.Button.Parent = FakeParryData.UI
    Instance.new("UICorner", FakeParryData.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", FakeParryData.Button)
    s.Color = Color3.fromRGB(150, 70, 255)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", FakeParryData.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "FAKE\nPARRY"
    lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    FakeParryData.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if FakeParryData.DragLocked then return end
            FakeParryData.Dragging = true
            FakeParryData.DragStart = input.Position
            FakeParryData.DragStartPos = FakeParryData.Button.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if FakeParryData.Dragging and not FakeParryData.DragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - FakeParryData.DragStart
            FakeParryData.Button.Position = UDim2.new(
                FakeParryData.DragStartPos.X.Scale, FakeParryData.DragStartPos.X.Offset + delta.X, 
                FakeParryData.DragStartPos.Y.Scale, FakeParryData.DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    FakeParryData.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            FakeParryData.Dragging = false
        end
    end)

    FakeParryData.Button.MouseButton1Click:Connect(VD_PlayFakeParry)
end

function VD_PlayFakeParry()
    if not VD.SURV_FakeParry then return end
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = humanoid
        end

        if getgenv().KYS_FakeParryTrack then
            pcall(function() getgenv().KYS_FakeParryTrack:Stop() end)
            getgenv().KYS_FakeParryTrack = nil
        end

        local animation = Instance.new("Animation")
        animation.AnimationId = FakeParryAnimations[VD.SURV_FakeParryAnim] or FakeParryAnimations["Enten"]

        local track = animator:LoadAnimation(animation)
        track.Priority = Enum.AnimationPriority.Action
        track:Play()
        getgenv().KYS_FakeParryTrack = track
    end)
end

if not getgenv().KYS_FakeParryInputConn then
    getgenv().KYS_FakeParryInputConn = game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.V then
            VD_PlayFakeParry()
        end
        if input.KeyCode == Enum.KeyCode.B then
            if type(VD_ToggleFakeGen) == "function" then VD_ToggleFakeGen() end
        end
    end)
end

setupFakeParryBtn()
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    setupFakeParryBtn()
    if FakeParryData.Button and type(VD) == "table" then
        FakeParryData.Button.Visible = VD.SURV_FakeParry
    end
end)

-- ==========================================
-- FAKE GENERATOR LOGIC & MOBILE BUTTON
-- ==========================================
getgenv().KYS_FakeGenTrack = nil
FakeGenData = {
    UI = nil,
    Button = nil,
    DragLocked = false,
    Dragging = false,
    DragStart = nil,
    DragStartPos = nil
}

function VD_ToggleFakeGen()
    if not VD.SURV_FakeGen then
        if getgenv().KYS_FakeGenTrack then
            pcall(function() getgenv().KYS_FakeGenTrack:Stop() end)
            getgenv().KYS_FakeGenTrack = nil
        end
        if FakeGenData.Button then
            FakeGenData.Button.BackgroundColor3 = Color3.fromRGB(20, 30, 0)
        end
        return
    end

    if getgenv().KYS_FakeGenTrack then
        pcall(function() getgenv().KYS_FakeGenTrack:Stop() end)
        getgenv().KYS_FakeGenTrack = nil
        if FakeGenData.Button then
            FakeGenData.Button.BackgroundColor3 = Color3.fromRGB(20, 30, 0)
        end
    else
        pcall(function()
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            if not character then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end

            local animator = humanoid:FindFirstChildOfClass("Animator")
            if not animator then
                animator = Instance.new("Animator")
                animator.Parent = humanoid
            end

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://83160743983246"

            local track = animator:LoadAnimation(animation)
            track.Looped = true
            track.Priority = Enum.AnimationPriority.Action
            track:Play()
            getgenv().KYS_FakeGenTrack = track
            
            if FakeGenData.Button then
                FakeGenData.Button.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
            end
        end)
    end
end

function setupFakeGenBtn()
    local player = game:GetService("Players").LocalPlayer
    local oldUI = player.PlayerGui:FindFirstChild("FakeGenUI")
    if oldUI then oldUI:Destroy() end

    FakeGenData.UI = Instance.new("ScreenGui")
    FakeGenData.UI.Name = "FakeGenUI"
    FakeGenData.UI.ResetOnSpawn = false
    FakeGenData.UI.IgnoreGuiInset = true
    FakeGenData.UI.Parent = player:WaitForChild("PlayerGui")

    FakeGenData.Button = Instance.new("ImageButton")
    FakeGenData.Button.Name = "FakeGenButton"
    FakeGenData.Button.Size = UDim2.new(0, 60, 0, 60)
    FakeGenData.Button.Position = UDim2.new(0.4, 0, 0.75, 0)
    FakeGenData.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    FakeGenData.Button.BackgroundColor3 = Color3.fromRGB(20, 30, 0)
    FakeGenData.Button.BackgroundTransparency = 0.15
    FakeGenData.Button.AutoButtonColor = true
    if type(VD) == "table" then FakeGenData.Button.Visible = VD.SURV_FakeGen else FakeGenData.Button.Visible = false end
    FakeGenData.Button.ZIndex = 10
    FakeGenData.Button.Parent = FakeGenData.UI
    Instance.new("UICorner", FakeGenData.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", FakeGenData.Button)
    s.Color = Color3.fromRGB(150, 255, 70)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", FakeGenData.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "FAKE\nGEN"
    lbl.TextColor3 = Color3.fromRGB(200, 255, 150)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    FakeGenData.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if FakeGenData.DragLocked then return end
            FakeGenData.Dragging = true
            FakeGenData.DragStart = input.Position
            FakeGenData.DragStartPos = FakeGenData.Button.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if FakeGenData.Dragging and not FakeGenData.DragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - FakeGenData.DragStart
            FakeGenData.Button.Position = UDim2.new(
                FakeGenData.DragStartPos.X.Scale, FakeGenData.DragStartPos.X.Offset + delta.X, 
                FakeGenData.DragStartPos.Y.Scale, FakeGenData.DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    FakeGenData.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            FakeGenData.Dragging = false
        end
    end)

    FakeGenData.Button.MouseButton1Click:Connect(VD_ToggleFakeGen)
end

setupFakeGenBtn()

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if getgenv().KYS_FakeGenTrack then
        pcall(function() getgenv().KYS_FakeGenTrack:Stop() end)
        getgenv().KYS_FakeGenTrack = nil
    end
    task.wait(0.5)
    setupFakeGenBtn()
    if FakeGenData.Button and type(VD) == "table" then
        FakeGenData.Button.Visible = VD.SURV_FakeGen
    end
end)

    -- =====================================================
    -- FAKE PERKS (CLIENT-SIDE PERK SIMULATOR)
    -- =====================================================
    local fakePerkSection = MainFeatureTabs.Survivor:AddSection({
        Position = "Center",
        Name = "Fake Perks",
        Icon      = "solar:stars-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    local FP = {
        Conns = {},
        ActiveBuffs = {},
        HB = nil,
        LastBuffEnd = 0,
        CooldownTime = 10,
    }

    local function FP_Char()
        return LocalPlayer.Character
    end

    local function FP_Hum()
        local c = FP_Char()
        return c and c:FindFirstChildOfClass("Humanoid")
    end

    local function FP_GetTotalSpeedBuff()
        local total = 0
        for name, b in pairs(FP.ActiveBuffs) do
            if tick() < b.endTime then
                total = total + b.amt
            end
        end
        return total
    end

    local function FP_ApplySpeedToCharacter()
        local char = FP_Char()
        local hum = FP_Hum()
        local totalBuff = FP_GetTotalSpeedBuff()

        if char then
            if totalBuff > 0 then
                local multiplier = 1 + (totalBuff / 14)
                char:SetAttribute("speedboost", multiplier)
            else
                char:SetAttribute("speedboost", 1)
            end
        end

        if hum then
            local base = 16
            if totalBuff > 0 then
                hum.WalkSpeed = base + totalBuff
            end
        end
    end

    local function FP_EnsureHB()
        if FP.HB then return end
        FP.HB = game:GetService("RunService").Heartbeat:Connect(function()
            local expired = {}
            for name, b in pairs(FP.ActiveBuffs) do
                if tick() >= b.endTime then
                    table.insert(expired, name)
                end
            end
            for _, name in ipairs(expired) do
                FP.ActiveBuffs[name] = nil
            end

            if #expired > 0 then
                if FP_GetTotalSpeedBuff() <= 0 then
                    FP.LastBuffEnd = tick()
                end
            end

            FP_ApplySpeedToCharacter()

            if FP_GetTotalSpeedBuff() <= 0 and next(FP.ActiveBuffs) == nil then
                if FP.HB then FP.HB:Disconnect(); FP.HB = nil end
                local char = FP_Char()
                if char then char:SetAttribute("speedboost", 1) end
            end
        end)
    end

    local function FP_StopHB()
        if FP.HB then FP.HB:Disconnect(); FP.HB = nil end
        FP.ActiveBuffs = {}
        local char = FP_Char()
        if char then char:SetAttribute("speedboost", 1) end
    end

    local function FP_TryBuff(name, amt, dur)
        if FP.ActiveBuffs[name] then return end
        if tick() - FP.LastBuffEnd < FP.CooldownTime and next(FP.ActiveBuffs) == nil then return end

        FP.ActiveBuffs[name] = { amt = amt, endTime = tick() + dur }
        FP_ApplySpeedToCharacter()
        FP_EnsureHB()
        VD_Notify("Fake Perks", "[" .. name .. "] Aktif! +" .. amt .. " Speed (" .. dur .. "s)", 3)
    end

    local function FP_Clean(name)
        if FP.Conns[name] then
            for _, c in ipairs(FP.Conns[name]) do pcall(function() c:Disconnect() end) end
            FP.Conns[name] = nil
        end
    end

    local function FP_Reg(name, conn)
        if not FP.Conns[name] then FP.Conns[name] = {} end
        table.insert(FP.Conns[name], conn)
    end

    -- SHARED COOLDOWN SLIDER
    fakePerkSection:AddSlider({
        Name = "Cooldown (semua perks)",
        Flag = "FP_Cooldown",
        Min = 0,
        Max = 60,
        Default = 10,
        Increment = 1,
        Suffix = "s",
        Callback = function(val) FP.CooldownTime = val end
    })

    -- ========================
    -- FLOWSTATE
    -- Trigger: Vault window / pallet slide
    -- Effect: +5 speed for 3 seconds + Finesse Vault
    -- ========================
    local flowstateOn = false
    fakePerkSection:AddToggle({
        Name = "Flowstate",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "FP_Flowstate",
        Default = false,
        Callback = function(val)
            if val and false then
                pcall(VD_Notify, "Premium Required ??", "Fitur Fake Perks hanya untuk pengguna Key Premium!", 5)
                return
            end
            flowstateOn = val
            local char = FP_Char()
            if char then
                char:SetAttribute("Flowstate", val)
            end

            if val then
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local w = r and r:FindFirstChild("Window")
                local p = r and r:FindFirstChild("Pallet")

                local function onVaultAction()
                    if not flowstateOn then return end
                    task.delay(0.5, function()
                        if flowstateOn then
                            FP_TryBuff("Flowstate", 5, 3)
                        end
                    end)
                end

                if w then
                    local vb = w:FindFirstChild("Vaultbindable")
                    if vb and vb:IsA("BindableEvent") then
                        FP_Reg("Flowstate", vb.Event:Connect(onVaultAction))
                    end
                end

                if p then
                    local sb = p:FindFirstChild("Slidebindable")
                    if sb and sb:IsA("BindableEvent") then
                        FP_Reg("Flowstate", sb.Event:Connect(onVaultAction))
                    end
                end

                -- Backup trigger via character animation/attributes
                local function hookChar(c)
                    if not c then return end
                    local conn = c:GetAttributeChangedSignal("__VaultFireCount"):Connect(function()
                        if flowstateOn then onVaultAction() end
                    end)
                    FP_Reg("Flowstate", conn)
                end
                hookChar(LocalPlayer.Character)
                FP_Reg("Flowstate", LocalPlayer.CharacterAdded:Connect(function(c)
                    if flowstateOn then
                        c:SetAttribute("Flowstate", true)
                        hookChar(c)
                    end
                end))

                VD_Notify("Fake Perks", "Flowstate ON � +5 speed selama 3 detik setelah vault/slide", 4)
            else
                FP_Clean("Flowstate")
                FP.ActiveBuffs["Flowstate"] = nil
                local c = FP_Char()
                if c then c:SetAttribute("Flowstate", false) end
                VD_Notify("Fake Perks", "Flowstate OFF", 3)
            end
        end
    })

    -- ========================
    -- QUICK RECOVERY
    -- Trigger: Selesai di-heal
    -- Effect: +6 speed for 3 seconds
    -- ========================
    local quickRecOn = false
    fakePerkSection:AddToggle({
        Name = "Quick Recovery",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "FP_QuickRecovery",
        Default = false,
        Callback = function(val)
            if val and false then
                pcall(VD_Notify, "Premium Required ??", "Fitur Fake Perks hanya untuk pengguna Key Premium!", 5)
                return
            end
            quickRecOn = val
            if val then
                local function onHealed()
                    if not quickRecOn then return end
                    FP_TryBuff("QuickRecovery", 6, 3)
                end

                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local healFolder = r and r:FindFirstChild("Healing")
                if healFolder then
                    local hd = healFolder:FindFirstChild("Healdone")
                    if hd and hd:IsA("BindableEvent") then
                        FP_Reg("QuickRecovery", hd.Event:Connect(onHealed))
                    end
                    local scv = healFolder:FindFirstChild("Skillcheckvalidated")
                    if scv and scv:IsA("BindableEvent") then
                        FP_Reg("QuickRecovery", scv.Event:Connect(onHealed))
                    end
                end

                local function hookHealth(c)
                    if not c then return end
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local lastHP = hum.Health
                        local conn = hum.HealthChanged:Connect(function(newHP)
                            if not quickRecOn then return end
                            if newHP > lastHP and (newHP >= hum.MaxHealth or (newHP - lastHP) >= 15) then
                                onHealed()
                            end
                            lastHP = newHP
                        end)
                        FP_Reg("QuickRecovery", conn)
                    end
                    local conn2 = c:GetAttributeChangedSignal("IsBeingHealed"):Connect(function()
                        if not quickRecOn then return end
                        if c:GetAttribute("IsBeingHealed") == false then
                            onHealed()
                        end
                    end)
                    FP_Reg("QuickRecovery", conn2)
                end
                hookHealth(LocalPlayer.Character)
                FP_Reg("QuickRecovery", LocalPlayer.CharacterAdded:Connect(hookHealth))

                VD_Notify("Fake Perks", "Quick Recovery ON � +6 speed selama 3 detik setelah di-heal", 4)
            else
                FP_Clean("QuickRecovery")
                FP.ActiveBuffs["QuickRecovery"] = nil
                VD_Notify("Fake Perks", "Quick Recovery OFF", 3)
            end
        end
    })

    -- ========================
    -- PERFECT LANDING
    -- Trigger: Landing dari ketinggian
    -- Effect: +8 speed for 3 seconds
    -- ========================
    local perfLandOn = false
    fakePerkSection:AddToggle({
        Name = "Perfect Landing",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "FP_PerfectLanding",
        Default = false,
        Callback = function(val)
            if val and false then
                pcall(VD_Notify, "Premium Required ??", "Fitur Fake Perks hanya untuk pengguna Key Premium!", 5)
                return
            end
            perfLandOn = val
            if val then
                local function hookFall(c)
                    if not c then return end
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if not hum then return end

                    local wasFalling = false
                    local fallStart = 0
                    local conn = hum.StateChanged:Connect(function(old, new)
                        if not perfLandOn then return end
                        if new == Enum.HumanoidStateType.Freefall then
                            wasFalling = true
                            fallStart = tick()
                        end
                        if wasFalling and (new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Running) then
                            local fallTime = tick() - fallStart
                            wasFalling = false
                            if fallTime >= 0.25 then
                                FP_TryBuff("PerfectLanding", 8, 3)
                            end
                        end
                    end)
                    FP_Reg("PerfectLanding", conn)
                end
                hookFall(LocalPlayer.Character)
                FP_Reg("PerfectLanding", LocalPlayer.CharacterAdded:Connect(hookFall))

                VD_Notify("Fake Perks", "Perfect Landing ON � +8 speed selama 3 detik setelah landing", 4)
            else
                FP_Clean("PerfectLanding")
                FP.ActiveBuffs["PerfectLanding"] = nil
                VD_Notify("Fake Perks", "Perfect Landing OFF", 3)
            end
        end
    })

    -- ========================
    -- ADRENALINE RUSH
    -- Trigger: HP drop <= 50 (kena hit killer)
    -- Effect: +4 speed for 5 seconds
    -- ========================
    local adrenalineOn = false
    fakePerkSection:AddToggle({
        Name = "Adrenaline Rush",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "FP_AdrenalineRush",
        Default = false,
        Callback = function(val)
            if val and false then
                pcall(VD_Notify, "Premium Required ??", "Fitur Fake Perks hanya untuk pengguna Key Premium!", 5)
                return
            end
            adrenalineOn = val
            if val then
                local function hookDamage(c)
                    if not c then return end
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if not hum then return end

                    local lastHP = hum.Health
                    local conn = hum.HealthChanged:Connect(function(newHP)
                        if not adrenalineOn then return end
                        if newHP < lastHP and newHP <= 50 and newHP > 0 then
                            FP_TryBuff("AdrenalineRush", 4, 5)
                        end
                        lastHP = newHP
                    end)
                    FP_Reg("AdrenalineRush", conn)
                end
                hookDamage(LocalPlayer.Character)
                FP_Reg("AdrenalineRush", LocalPlayer.CharacterAdded:Connect(hookDamage))

                VD_Notify("Fake Perks", "Adrenaline Rush ON � +4 speed selama 5 detik saat HP drop ke 50", 4)
            else
                FP_Clean("AdrenalineRush")
                FP.ActiveBuffs["AdrenalineRush"] = nil
                VD_Notify("Fake Perks", "Adrenaline Rush OFF", 3)
            end
        end
    })
do -- Killer Tab
    local combatKiller = MainKillerFeatureTabs.Killer:AddSection({
        Position = "Center",
        Name = "Killer",
        Icon      = "solar:danger-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    combatKiller:AddToggle({ Default = false, Name = "Auto Attack", Flag = "Auto Attack", Callback = function(v) VD.AUTO_Attack = v end })
    combatKiller:AddSlider({
        Name = "Attack Range", Flag = "Attack Range",
        Min = 5, Max = 20, Default = 12,
        Callback = function(v)
            VD.AUTO_AttackRange =
                v
        end
    })
    combatKiller:AddToggle({ Default = false, Name = "Hitbox Expand", Flag = "Hitbox Expand", Callback = function(v) VD.HITBOX_Enabled = v end })
    combatKiller:AddSlider({
        Name = "Hitbox Size", Flag = "Hitbox Size",
        Min = 5, Max = 40, Default = 15,
        Callback = function(v)
            VD.HITBOX_Size =
                v
        end
    })
    combatKiller:AddToggle({ Default = false, Name = "Infinite Lunge (Basic Attack)", Flag = "Infinite Lunge (Basic Attack)", Callback = function(v)
        VD.KILLER_InfLunge = v
    end })

    -- removed KillerTab AddDivider

    local abilityKiller = MainKillerFeatureTabs.Ability:AddSection({
        Position = "Center",
        Name = "Killer Ability",
        Icon      = "solar:bolt-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })


    abilityKiller:AddToggle({ Default = false, Name = "Infinite Abyssal Burst (Abyss)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Abyssal Burst (Abyss)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Abyssal Burst (Abyss) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BypassCooldown = v
        if v then
            KYS_StartAbyssCooldownBypass()
        else
            KYS_StopAbyssCooldownBypass()
        end
    end })
    abilityKiller:AddToggle({ Default = false, Name = "Infinite Skill (Hidden)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Skill (Hidden)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Skill (Hidden) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BypassLeap = v
        if v then
            pcall(KYS_StartHiddenCooldownBypass)
        else
            pcall(KYS_StopHiddenCooldownBypass)
        end
    end })
    abilityKiller:AddToggle({ Default = false, Name = "Infinite Frenzy (Jeff)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Frenzy (Jeff)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Frenzy (Jeff) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_InfFrenzy = v
        if v then
            pcall(KYS_StartJeffCooldownBypass)
        else
            pcall(KYS_StopJeffCooldownBypass)
        end
    end })

    abilityKiller:AddToggle({ Default = false, Name = "Infinite Lake Mist (Jason)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Lake Mist (Jason)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Lake Mist (Jason) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_InfLakeMist = v
        if v then
            pcall(KYS_StartSlasherCooldownBypass)
        else
            pcall(KYS_StopSlasherCooldownBypass)
        end
    end })

    abilityKiller:AddToggle({ Default = false, Name = "Infinite Pursuit (Jason)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Pursuit (Jason)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Pursuit (Jason) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_InfPursuit = v
        if v then
            pcall(KYS_StartSlasherCooldownBypass)
        else
            pcall(KYS_StopSlasherCooldownBypass)
        end
    end })



    abilityKiller:AddToggle({ Default = false, Name = "Infinite Grab (Myers)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Grab (Myers)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Grab (Myers) hanya untuk pengguna Key Premium!", 5)
            return
        end
        setMyersGrab(v)
    end })
    
    abilityKiller:AddToggle({ Default = false, Name = "Fake Attack (Counter Parry)", Locked = false, TextLocked = "Premium Required", Flag = "Fake Attack (Counter Parry)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Fake Attack hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_FakeAttack = v
        pcall(KYS_ToggleFakeAttack, v)
    end })

    abilityKiller:AddToggle({ Default = false, Name = "Undraggable Button (Inf Grab)", Locked = false, TextLocked = "Premium Required", Flag = "Undraggable Button (Inf Grab)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Undraggable Button hanya untuk pengguna Key Premium!", 5)
            return
        end
        setMyersDragLocked(v)
    end })
    pcall(function()
        local customMaskedMasks = {"Richard", "Tony", "Brandon", "Jake", "Richter", "Graham", "Alex"}
        abilityKiller:AddDropdown({
            Name = "Custom Masked",
            Locked = false,
            TextLocked = "Premium Required",
            Flag = "Custom Masked",
            Values = customMaskedMasks,
            Multi = false,
            Default = VD.KILLER_CustomMasked or "Richard",
            Callback = function(v)
                if v and false then
                    return
                end
                if type(v) == "table" then
                    v = v[1]
                end
                VD.KILLER_CustomMasked = v or "Richard"
            end
        })
        abilityKiller:AddButton({
            Name = "Apply Custom Masked",
            Locked = false,
            TextLocked = "Premium Required",
            Callback = function()
                if false then
                    pcall(VD_Notify, "Premium Required ✨", "Fitur Custom Masked hanya untuk pengguna Key Premium!", 5)
                    return
                end
                pcall(KYS_ApplyCustomMasked, VD.KILLER_CustomMasked)
            end
        })
        abilityKiller:AddButton({
            Name = "Random Custom Masked",
            Locked = false,
            TextLocked = "Premium Required",
            Callback = function()
                if false then
                    pcall(VD_Notify, "Premium Required ✨", "Fitur Custom Masked hanya untuk pengguna Key Premium!", 5)
                    return
                end
                local mask = customMaskedMasks[math.random(1, #customMaskedMasks)]
                VD.KILLER_CustomMasked = mask
                pcall(KYS_ApplyCustomMasked, mask)
            end
        })
    end)

    local utilKiller = MainKillerFeatureTabs.Utilities:AddSection({
        Position = "Center",
        Name = "Utilities",
        Icon      = "solar:settings-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    utilKiller:AddToggle({ Default = false, Name = "Auto Hook", Flag = "Auto Hook", Callback = function(v) VD.KILLER_AutoHook = v end })
    utilKiller:AddToggle({ Default = false, Name = "Destroy Pallets", Flag = "Destroy Pallets", Callback = function(v) VD.KILLER_DestroyPallets = v end })
    utilKiller:AddToggle({ Default = false, Name = "Auto Kick Generator", Flag = "Auto Kick Generator", Callback = function(v) VD.KILLER_AutoBreakGene = v end })
    utilKiller:AddToggle({ Default = false, Name = "Block All Vaults", Locked = false, TextLocked = "Premium Required", Flag = "Block All Vaults", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Block All Vaults hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BlockVaults = v
    end })
    utilKiller:AddToggle({ Default = false, Name = "Auto Drop All Pallets", Locked = false, TextLocked = "Premium Required", Flag = "Auto Drop All Pallets", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Auto Drop All Pallets hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BlockPallets = v
    end })
    utilKiller:AddToggle({ Default = false, Name = "Break All Pallet", Locked = false, TextLocked = "Premium Required", Flag = "Break All Pallet", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Break All Pallet hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BlockPalletDrop = v
    end })

    utilKiller:AddToggle({
        Default = false,
        Name = "Anti Blind (Flashlight)", Flag = "Anti Blind (Flashlight)",
        Callback = function(v)
            VD.KILLER_AntiBlind = v; pcall(SetupAntiBlind)
        end
    })
    utilKiller:AddToggle({
        Default = false,
        Name = "Remove Palletwrong (All)", Flag = "Remove Palletwrong (All)",
        Callback = function(v)
            VD.KILLER_NoPalletStun = v; pcall(SetupNoPalletStun)
        end
    })
    utilKiller:AddToggle({ Default = false, Name = "No Slowdown", Flag = "No Slowdown", Callback = function(v) VD.KILLER_NoSlowdown = v end })
    utilKiller:AddToggle({ Default = false, Name = "Beat Killer (auto kill)", Flag = "Beat Killer (auto kill)", Callback = function(v) VD.BEAT_Killer = v end })

    utilKiller:AddDivider({ Text = "Target Lock" })

    utilKiller:AddToggle({ Default = false, Name = "Target Lock", Flag = "Target Lock", Callback = function(v)
        if getgenv().VD_SetAimLockButtonVisible then
            getgenv().VD_SetAimLockButtonVisible(v)
        else
            VD.AimLockButton = v
        end
    end })
    utilKiller:AddToggle({ Default = false, Name = "Lock Target Lock Button", Flag = "Lock Target Lock Button", Callback = function(v)
        VD.AimLockButtonLocked = v and true or false
    end })
    utilKiller:AddSlider({
        Name = "Target Lock Max Distance", Flag = "Target Lock Max Distance",
        Min = 10, Max = 200, Default = 50,
        Callback = function(v)
            VD.AimLockMaxDistance = v
        end
    })
end

do -- Escape Tab
    local escapeSurv = MainFeatureTabs.Escape:AddSection({
        Position = "Center",
        Name = "Escape",
        Icon      = "solar:exit-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    escapeSurv:AddToggle({ Default = false, Name = "Bypass Gate", Flag = "Bypass Gate", Callback = function(v) VD.BypassGate = v; if not v then pcall(VD_RestoreGateParts) end end })
    escapeSurv:AddToggle({ Default = false, Name = "Beat Survivor (auto exit)", Locked = false, TextLocked = "Premium Required", Flag = "Beat Survivor (auto exit)", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Beat Survivor hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.BEAT_Survivor = v 
    end })

    escapeSurv:AddToggle({ Default = false, Name = "Flee Killer", Flag = "Flee Killer", Callback = function(v) VD.SURV_FleeKiller = v end })
    escapeSurv:AddSlider({
        Name = "Flee Distance", Flag = "Flee Distance",
        Min = 15, Max = 80, Default = 40,
        Callback = function(v) VD.SURV_FleeDistance = v end
    })
end

do -- Generator Tab

    -- removed GeneratorTab AddDivider

    local genAuto = MainFeatureTabs.Automation:AddSection({
        Position = "Center",
        Name = "Automation",
        Icon      = "solar:bolt-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })


    genAuto:AddToggle({ Default = false, Name = "Auto Skillcheck", Flag = "Auto Skillcheck", Callback = function(v) VD_SetAutoSkillcheck(v) end })
    genAuto:AddToggle({ Default = false, Name = "Hide Skillcheck UI", Flag = "Hide Skillcheck UI", Callback = function(v) VD.HideSkillUI = v end })
    genAuto:AddToggle({ Default = false, Name = "Boost Gen Bypass", Locked = false, TextLocked = "Premium Required", Flag = "Boost Gen Bypass", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Boost Gen Bypass hanya untuk pengguna Key Premium!", 5)
            return
        end
        setGenBypass(v)
    end })
    genAuto:AddDropdown({
        Name = "Skillcheck Mode",
        Flag = "Skillcheck Mode",
        Values = { "Normal", "Perfect", "Instant" },
        Default = "Normal",
        DisabledOptions = false and { "Instant" } or {},
        Multi = false,
        Callback = function(option)
            if type(option) == "table" then option = option[1] end
            if option == "Instant" and false then
                pcall(VD_Notify, "Premium Required ✨", "Opsi Instant hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.AutoSkillcheckMode = option or "Normal"
            if VD.AutoSkillcheckMode ~= "Instant" and AutoSkill.InstantRotationConnection then
                AutoSkill.InstantRotationConnection:Disconnect()
                AutoSkill.InstantRotationConnection = nil
                AutoSkill.InstantHasClicked = false
            end
            VD_Notify("Skillcheck Mode", tostring(VD.AutoSkillcheckMode) .. " selected", 2)
        end
    })
end

do -- Fling Tab
    local flingSection = PlayerFeatureTabs.Fling:AddSection({
        Position = "Center",
        Name = "Fling",
        Icon      = "solar:wind-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    flingSection:AddToggle({ Default = false, Name = "Enable Fling", Locked = false, TextLocked = "Premium Required", Flag = "Enable Fling", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Fling hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.FLING_Enabled = v 
    end })
    flingSection:AddSlider({
        Name = "Fling Strength", Flag = "Fling Strength",
        Min = 1000, Max = 50000, Default = 10000,
        Callback = function(
            v)
            VD.FLING_Strength = v
        end
    })

    -- removed FlingTab AddDivider

    flingSection:AddButton({ Name = "Fling Nearest", Locked = false, TextLocked = "Premium Required", Callback = function() 
        if false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Fling hanya untuk pengguna Key Premium!", 5)
            return
        end
        pcall(function() KYS_FlingNearest() end) 
    end })
    flingSection:AddButton({ Name = "Fling All", Locked = false, TextLocked = "Premium Required", Callback = function() 
        if false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Fling hanya untuk pengguna Key Premium!", 5)
            return
        end
        pcall(KYS_FlingAll) 
    end })
end

-- =====================================================
-- PLAYER EMOTE SYSTEM (Logic from PanduHub1.lua)
-- =====================================================
local SelectedAnim = "rbxassetid://83229063951016"
local SelectedSound = "rbxassetid://85355610204255"
local currentTrack = nil
local currentSound = nil

local EmoteOptions = {
    "Friday Night",
    "WarCry",
    "24 Hour Cinderella",
    "Applause",
    "Arm Swing",
    "Backflip",
    "California Girls",
    "Christmas Spirit",
    "Floating Rest",
    "Ghoul",
    "Griddy",
    "Kyoufuu",
    "OnePlays",
    "Vulnerable",
}

local function SelectEmoteData(value)
    if value == "Friday Night" then
        SelectedAnim = "rbxassetid://83229063951016"
        SelectedSound = "rbxassetid://85355610204255"
    elseif value == "WarCry" then
        SelectedAnim = "rbxassetid://82600868380136"
        SelectedSound = "rbxassetid://120101930689931"
    elseif value == "24 Hour Cinderella" then
        SelectedAnim = "rbxassetid://137195203725366"
        SelectedSound = "rbxassetid://121099446613414"
    elseif value == "Applause" then
        SelectedAnim = "rbxassetid://96328361165090"
        SelectedSound = "rbxassetid://115490787020749"
    elseif value == "Arm Swing" then
        SelectedAnim = "rbxassetid://80552139463944"
        SelectedSound = "rbxassetid://74216458932348"
    elseif value == "Backflip" then
        SelectedAnim = "rbxassetid://74705617908505"
        SelectedSound = nil
    elseif value == "California Girls" then
        SelectedAnim = "rbxassetid://123552803041504"
        SelectedSound = "rbxassetid://87899327891544"
    elseif value == "Christmas Spirit" then
        SelectedAnim = "rbxassetid://137859761110514"
        SelectedSound = nil
    elseif value == "Floating Rest" then
        SelectedAnim = "rbxassetid://114593021219597"
        SelectedSound = nil
    elseif value == "Ghoul" then
        SelectedAnim = "rbxassetid://130415594909401"
        SelectedSound = "rbxassetid://123004139176580"
    elseif value == "Griddy" then
        SelectedAnim = "rbxassetid://75586690784894"
        SelectedSound = nil
    elseif value == "Kyoufuu" then
        SelectedAnim = "rbxassetid://137322894494527"
        SelectedSound = "rbxassetid://129064643026442"
    elseif value == "OnePlays" then
        SelectedAnim = "rbxassetid://140625405103474"
        SelectedSound = "rbxassetid://94749073728335"
    elseif value == "Vulnerable" then
        SelectedAnim = "rbxassetid://121773684313913"
        SelectedSound = "rbxassetid://135265751184744"
    end
end

local function PlayEmote()
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end
    if currentSound then
        currentSound:Destroy()
        currentSound = nil
    end

    if SelectedAnim then
        local anim = Instance.new("Animation")
        anim.AnimationId = SelectedAnim
        currentTrack = hum:LoadAnimation(anim)
        currentTrack.Looped = true
        currentTrack:Play()
    end

    if SelectedSound then
        currentSound = Instance.new("Sound")
        currentSound.SoundId = SelectedSound
        currentSound.Looped = true
        currentSound.Volume = 2
        currentSound.Parent = hrp
        currentSound:Play()
    end
end

local function StopEmote()
    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end
    if currentSound then
        currentSound:Destroy()
        currentSound = nil
    end
end

do -- Emote Tab
    local emoteSection = PlayerFeatureTabs.Emote:AddSection({
        Position = "Center",
        Name = "Player Emote [BETA]",
        Icon      = "solar:music-note-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    VD.SelectedEmote = "Friday Night"
    VD.EmoteEnabled = false

    emoteSection:AddToggle({
        Default = false,
        Name = "Enable Emote",
        Flag = "Enable Emote",
        Callback = function(v)
            VD.EmoteEnabled = v
            if v then
                PlayEmote()
            else
                StopEmote()
            end
        end
    })

    emoteSection:AddDropdown({
        Name = "Select Emote",
        Flag = "Select Emote",
        Values = EmoteOptions,
        Default = "Friday Night",
        Multi = false,
        Callback = function(option)
            if type(option) == "table" then option = option[1] end
            VD.SelectedEmote = option or "Friday Night"
            SelectEmoteData(VD.SelectedEmote)
            if VD.EmoteEnabled then
                PlayEmote()
            end
        end
    })
end

do -- Fun Tab
    local funSection = PlayerMiscFeatureTabs.Fun:AddSection({
        Position = "Center",
        Name = "Spoof Stats [Visual Only]",
        Icon = "solar:gamepad-bold",
        Box = true,
        BoxBorder = true,
        Opened = true,
    })

    local spoofLevel, spoofGears, spoofScrews = "0", "0", "0"

    funSection:AddTextInput({
        Name = "Set Level",
        Flag = "SpoofLevel",
        Numeric = true,
        Default = "0",
        Callback = function(value) spoofLevel = value end
    })

    funSection:AddTextInput({
        Name = "Set Gears",
        Flag = "SpoofGears",
        Numeric = true,
        Default = "0",
        Callback = function(value) spoofGears = value end
    })

    funSection:AddTextInput({
        Name = "Set Screws",
        Flag = "SpoofScrews",
        Numeric = true,
        Default = "0",
        Callback = function(value) spoofScrews = value end
    })

    funSection:AddButton({
        Name = "Apply Spoof Data",
        Callback = function()
            local p = LocalPlayer
            if p then
                p:SetAttribute("Level", tonumber(spoofLevel) or 0)
                p:SetAttribute("Gears", tonumber(spoofGears) or 0)
                p:SetAttribute("Screws", tonumber(spoofScrews) or 0)
                if VD_Notify then
                    VD_Notify("Spoof Data", "Level, Gears, dan Screws diperbarui", 3)
                end
            end
        end
    })
end

do -- Streamer Mode Tab
    local streamerSection = PlayerMiscFeatureTabs.Streamer:AddSection({
        Position = "Center",
        Name = "Streamer Mode",
        Icon      = "solar:users-group-rounded-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    local FakeNameConnection = nil

    local function shouldHideNameObject(object)
        local ok, isTextObj = pcall(function()
            return object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")
        end)
        if not ok or not isTextObj then
            return false
        end
        local text = ""
        pcall(function() text = tostring(object.Text or "") end)
        return text == LocalPlayer.Name or text == LocalPlayer.DisplayName or text:find(LocalPlayer.Name, 1, true) ~= nil
    end

    local function enableFakeName(enabled)
        if FakeNameConnection then
            pcall(function() FakeNameConnection:Disconnect() end)
            FakeNameConnection = nil
        end
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then
            return
        end
        local function process(object)
            if shouldHideNameObject(object) then
                object.Visible = not enabled
            end
        end
        for _, descendant in ipairs(playerGui:GetDescendants()) do
            process(descendant)
        end
        if enabled then
            FakeNameConnection = playerGui.DescendantAdded:Connect(function(object)
                task.defer(process, object)
            end)
        end
    end

    streamerSection:AddToggle({
        Default = false,
        Name = "Hide Name",
        Flag = "Hide Name",
        Callback = function(v)
            pcall(enableFakeName, v)
        end
    })
end

local KorlessMorph = {
    Connection = nil
}

local function ApplyKorless()
    local function Morph()
        repeat task.wait()
        until LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            and LocalPlayer.Character:FindFirstChild("Right Leg")

        task.wait(0.1)
        local char = LocalPlayer.Character

        pcall(function()
            char.Head.Transparency = 1

            local face = char.Head:FindFirstChild("face")
            if face then
                face:Destroy()
            end

            char["Right Leg"].Transparency = 1

            local mesh = Instance.new("MeshPart")
            mesh.Name = "KorlessHead"
            mesh.Size = Vector3.new(1.5, 1.5, 1.5)
            mesh.CanCollide = false
            mesh.MeshId = "rbxassetid://902942096"
            mesh.TextureID = "rbxassetid://902843398"
            mesh.CFrame = char["Right Leg"].CFrame * CFrame.new(0, 0.5, 0)
            mesh.Parent = char

            local weld = Instance.new("WeldConstraint")
            weld.Part0 = char["Right Leg"]
            weld.Part1 = mesh
            weld.Parent = mesh
        end)
    end

    Morph()

    if KorlessMorph.Connection then
        KorlessMorph.Connection:Disconnect()
    end

    KorlessMorph.Connection = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        Morph()
    end)
end

do -- Korless Tab
    local avatarSection = PlayerMiscFeatureTabs.Avatar:AddSection({
        Position = "Center",
        Name = "Korless Morph",
        Icon      = "solar:users-group-rounded-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    avatarSection:AddButton({
        Name = "APPLY KORLESS",
        Callback = function()
            ApplyKorless()
            VD_Notify("Korless Morph", "Korless Morph Applied successfully!", 3)
        end
    })

    avatarSection:AddButton({
        Name = "RESET KORLESS",
        Callback = function()
            if KorlessMorph.Connection then
                pcall(function() KorlessMorph.Connection:Disconnect() end)
                KorlessMorph.Connection = nil
            end
            pcall(function()
                local korHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("KorlessHead")
                if korHead then korHead:Destroy() end
            end)
            VD_Notify("Korless Morph", "Korless Morph berhasil direset!", 3)
        end
    })

    local copyAvatarSection = PlayerMiscFeatureTabs.Avatar:AddSection({
        Position = "Center",
        Name = "Copy Avatar",
        Icon      = "solar:user-id-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    local selectedAvatarPlayer = nil

    local copyAvatarDropdown = copyAvatarSection:AddDropdown({
        Name = "Select Player",
        Flag = "CopyAvatar_SelectPlayer",
        Values = {},
        Multi = false,
        Callback = function(v)
            if type(v) == "table" then
                selectedAvatarPlayer = v[1]
            else
                selectedAvatarPlayer = v
            end
        end
    })

    local function UpdatePlayerDropdown()
        local list = {}
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(list, p.Name)
            end
        end
        pcall(function() copyAvatarDropdown:SetValues(list) end)
    end
    
    UpdatePlayerDropdown()
    game:GetService("Players").PlayerAdded:Connect(UpdatePlayerDropdown)
    game:GetService("Players").PlayerRemoving:Connect(UpdatePlayerDropdown)

    local originalAvatarCache = {}
    local originalAvatarSaved = false
    local originalHeadMeshScale = nil

    local function AddAccessoryLocal(char, accessory)
        local handle = accessory:FindFirstChild("Handle")
        if not handle then return end
        
        local accAtt = nil
        for _, v in ipairs(handle:GetChildren()) do
            if v:IsA("Attachment") then
                accAtt = v
                break
            end
        end
        if not accAtt then return end
        
        local charAtt, targetPart = nil, nil
        local fh = char:FindFirstChild("FakeCopiedHead")
        if fh then
            local att = fh:FindFirstChild(accAtt.Name)
            if att and att:IsA("Attachment") then
                charAtt = att
                targetPart = fh
            end
        end
        if not charAtt then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "FakeCopiedHead" then
                    local att = part:FindFirstChild(accAtt.Name)
                    if att and att:IsA("Attachment") then
                        charAtt = att
                        targetPart = part
                        break
                    end
                end
            end
        end
        if not charAtt then return end
        
        for _, v in ipairs(handle:GetChildren()) do
            if v:IsA("JointInstance") or v:IsA("WeldConstraint") or v:IsA("Constraint") or v:IsA("Script") or v:IsA("LocalScript") then
                v:Destroy()
            end
        end
        
        accessory.Parent = char
        local weld = Instance.new("Weld")
        weld.Name = "AccessoryWeld"
        weld.Part0 = handle
        weld.Part1 = targetPart
        weld.C0 = accAtt.CFrame
        weld.C1 = charAtt.CFrame
        weld.Parent = handle
    end

    local standardParts = {
        Head=true, Torso=true, ["Left Arm"]=true, ["Right Arm"]=true, ["Left Leg"]=true, ["Right Leg"]=true, HumanoidRootPart=true,
        UpperTorso=true, LowerTorso=true, LeftUpperArm=true, LeftLowerArm=true, LeftHand=true, RightUpperArm=true, RightLowerArm=true, RightHand=true, LeftUpperLeg=true, LeftLowerLeg=true, LeftFoot=true, RightUpperLeg=true, RightLowerLeg=true, RightFoot=true
    }

    local function SaveOriginalAvatar()
        if originalAvatarSaved then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then
                table.insert(originalAvatarCache, obj:Clone())
            elseif obj:IsA("BasePart") and not standardParts[obj.Name] and obj.Name ~= "FakeCopiedHead" then
                table.insert(originalAvatarCache, obj:Clone())
            end
        end
        local head = char:FindFirstChild("Head")
        if head then
            local sm = head:FindFirstChildOfClass("SpecialMesh")
            if sm then originalHeadMeshScale = sm.Scale end
            for _, v in ipairs(head:GetChildren()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    table.insert(originalAvatarCache, v:Clone())
                end
            end
        end
        originalAvatarSaved = true
    end

    local function ApplyTargetAvatar(targetChar)
        local myChar = LocalPlayer.Character
        if not myChar or not targetChar then return false end
        
        for _, obj in ipairs(myChar:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then
                obj:Destroy()
            elseif obj:IsA("BasePart") and not standardParts[obj.Name] and obj.Name ~= "FakeCopiedHead" then
                obj:Destroy()
            end
        end
        
        local myHead = myChar:FindFirstChild("Head")
        if myHead then
            for _, v in ipairs(myHead:GetChildren()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end
        
        local targetHead = targetChar:FindFirstChild("Head")
        if targetHead and myHead then
            myHead.Transparency = 1
            local oldFake = myChar:FindFirstChild("FakeCopiedHead")
            if oldFake then oldFake:Destroy() end
            
            local fakeHead = targetHead:Clone()
            fakeHead.Name = "FakeCopiedHead"
            fakeHead.CanCollide = false
            fakeHead.Massless = true
            local targetBc = targetChar:FindFirstChildOfClass("BodyColors")
            if targetBc then fakeHead.Color = targetBc.HeadColor3 else fakeHead.Color = targetHead.Color end
            local mySm = myHead:FindFirstChildOfClass("SpecialMesh")
            if mySm then mySm.Scale = Vector3.new(0, 0, 0) end
            myHead.LocalTransparencyModifier = 1
            for _, v in ipairs(fakeHead:GetChildren()) do
                if v:IsA("Motor6D") or v:IsA("Weld") or v:IsA("WeldConstraint") or v:IsA("Script") or v:IsA("LocalScript") then
                    v:Destroy()
                end
            end
            fakeHead.Parent = myChar
            
            local hw = Instance.new("Weld")
            hw.Name = "FakeHeadWeld"
            hw.Part0 = myHead
            hw.Part1 = fakeHead
            hw.C0 = CFrame.new()
            hw.C1 = CFrame.new()
            hw.Parent = fakeHead
        end
        
        for _, obj in ipairs(targetChar:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                AddAccessoryLocal(myChar, obj:Clone())
            elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then
                obj:Clone().Parent = myChar
            elseif obj:IsA("BasePart") and not standardParts[obj.Name] and obj.Name ~= "FakeCopiedHead" then
                local clone = obj:Clone()
                for _, v in ipairs(clone:GetDescendants()) do
                    if v:IsA("JointInstance") or v:IsA("WeldConstraint") or v:IsA("Constraint") or v:IsA("Script") or v:IsA("LocalScript") then
                        v:Destroy()
                    end
                end
                
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
                local myRoot = myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso")
                
                if targetRoot and myRoot then
                    local offset = targetRoot.CFrame:Inverse() * obj.CFrame
                    clone.CFrame = myRoot.CFrame * offset
                    
                    local wc = Instance.new("WeldConstraint")
                    wc.Part0 = clone
                    wc.Part1 = myRoot
                    wc.Parent = clone
                end
                
                clone.Parent = myChar
            end
        end
        return true
    end

    copyAvatarSection:AddButton({
        Name = "Apply Ava",
        Callback = function()
            if not selectedAvatarPlayer or selectedAvatarPlayer == "" then
                VD_Notify("Copy Avatar", "Pilih player dulu!", 3)
                return
            end
            local targetPlayer = game:GetService("Players"):FindFirstChild(selectedAvatarPlayer)
            if targetPlayer and targetPlayer.Character then
                pcall(SaveOriginalAvatar)
                local success = ApplyTargetAvatar(targetPlayer.Character)
                if success then
                    VD_Notify("Copy Avatar", "Berhasil copy avatar " .. targetPlayer.Name .. "!", 3)
                else
                    VD_Notify("Copy Avatar", "Gagal mengcopy avatar!", 3)
                end
            else
                VD_Notify("Copy Avatar", "Player / Character tidak ditemukan!", 3)
            end
        end
    })

    copyAvatarSection:AddButton({
        Name = "Reset Ava",
        Callback = function()
            local char = LocalPlayer.Character
            if not char or not originalAvatarSaved then
                VD_Notify("Reset Avatar", "Tidak ada data original avatar tersimpan!", 3)
                return
            end
            pcall(function()
                for _, obj in ipairs(char:GetChildren()) do
                    if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then
                        obj:Destroy()
                    end
                end
                local head = char:FindFirstChild("Head")
                if head then
                    local face = head:FindFirstChildOfClass("Decal")
                    if face then face:Destroy() end
                    local oldFake = char:FindFirstChild("FakeCopiedHead")
                    if oldFake then oldFake:Destroy() end
                    head.Transparency = 0
                    head.LocalTransparencyModifier = 0
                    local mySm = head:FindFirstChildOfClass("SpecialMesh")
                    if mySm and originalHeadMeshScale then
                        mySm.Scale = originalHeadMeshScale
                    elseif mySm then
                        mySm.Scale = Vector3.new(1.25, 1.25, 1.25)
                    end
                end
                local myHum = char:FindFirstChildOfClass("Humanoid")
                for _, obj in ipairs(originalAvatarCache) do
                    local clone = obj:Clone()
                    if clone:IsA("Decal") then
                        if head then clone.Parent = head end
                    elseif clone:IsA("Accessory") then
                        AddAccessoryLocal(char, clone)
                    else
                        clone.Parent = char
                    end
                end
            end)
            VD_Notify("Copy Avatar", "Avatar dikembalikan ke semula!", 3)
        end
    })

end

end -- end if Window then

print("KYS HUB Violence District v1.5.7 Loaded")
pcall(function()
    VD_Notify("A2", "Violence District v1.5.7 Loaded Successfully!", 5)
end)

-- =====================================================
-- ROLE HELPERS
-- =====================================================
function GetRole()
    if not LocalPlayer.Team then return "Unknown" end
    local name = LocalPlayer.Team.Name
    if name == "Killer" then return "Killer" end
    if name == "Survivors" then return "Survivor" end
    return "Lobby"
end

function IsKiller(player)
    return player and player.Team and player.Team.Name == "Killer"
end

function IsSurvivor(player)
    return player and player.Team and player.Team.Name == "Survivors"
end

function KYS_ApplyCustomMasked(maskName)
    local selectedMask = maskName or VD.KILLER_CustomMasked or "Richard"
    if type(selectedMask) == "table" then
        selectedMask = selectedMask[1]
    end
    if type(selectedMask) ~= "string" or selectedMask == "" then
        selectedMask = "Richard"
    end

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local killers = remotes and remotes:FindFirstChild("Killers")
    local masked = killers and killers:FindFirstChild("Masked")
    local activatePower = masked and masked:FindFirstChild("Activatepower")

    if activatePower and activatePower:IsA("RemoteEvent") then
        activatePower:FireServer(selectedMask)
        return true
    end
    return false
end

function VD_GetGameValue(obj, name)
    if typeof(obj) ~= "Instance" then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child and child:IsA("ValueBase") then return child.Value end
    return nil
end

function VD_IsStatusActive(value)
    return value == true or (type(value) == "number" and value > 0)
end

function VD_RunAntiKnock()
    if not VD.SURV_AntiKnock or GetRole() ~= "Survivor" then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum then return end

    local isKnocked = VD_IsStatusActive(VD_GetGameValue(char, "Knocked"))
        or VD_IsStatusActive(VD_GetGameValue(char, "IsKnocked"))
    local isCarried = VD_IsStatusActive(VD_GetGameValue(char, "Carried"))
        or VD_IsStatusActive(VD_GetGameValue(char, "IsCarried"))
        or VD_IsStatusActive(VD_GetGameValue(char, "Grabbed"))

    if not isKnocked and not isCarried then return end
    local now = tick()
    if VD._LastAntiKnock and now - VD._LastAntiKnock < 0.3 then return end
    VD._LastAntiKnock = now

    for _, flag in ipairs({ "Knocked", "IsKnocked", "Carried", "IsCarried", "Grabbed", "Ragdolled", "Captured", "Disabled" }) do
        pcall(function()
            if char:GetAttribute(flag) ~= nil then char:SetAttribute(flag, false) end
            local obj = char:FindFirstChild(flag)
            if obj and obj:IsA("BoolValue") then
                obj.Value = false
            elseif obj and (obj:IsA("NumberValue") or obj:IsA("IntValue")) then
                obj.Value = 0
            end
        end)
    end

    pcall(function()
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        if hum:GetState() == Enum.HumanoidStateType.Physics
            or hum:GetState() == Enum.HumanoidStateType.Ragdoll
            or hum:GetState() == Enum.HumanoidStateType.FallingDown
            or hum:GetState() == Enum.HumanoidStateType.PlatformStanding then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        if root then root.AssemblyLinearVelocity = Vector3.zero end
        task.defer(function()
            pcall(function()
                hum.Health = hum.MaxHealth
                hum.WalkSpeed = math.max(hum.WalkSpeed, 16)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end)
    end)
end

function VD_ClearSurvivorWarnings()
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local warn = root and root:FindFirstChild("KYS_SurvivorKillerWarn")
        if warn then warn:Destroy() end
    end
end

local VD_WarnIconPaths = {
    Yellow = "/tmp/codex-web-uploads/f-LtzTRl/file_000000004f9871fa9d73773e3af21740.png",
    red = "/tmp/codex-web-uploads/f-Yo5gYu/file_00000000fb90720782fb54bce5fe8099.png",
}
local VD_WarnIconAssetIds = {
    Yellow = "113063284092207",
    red = "87337602602637",
}
local VD_WarnIconCache = {}

function VD_FormatAssetId(assetId)
    assetId = tostring(assetId or "")
    if assetId == "" then return nil end
    if assetId:find("rbxassetid://", 1, true) then return assetId end
    if assetId:find("rbxthumb://", 1, true) then return assetId end
    if assetId:match("^%d+$") then
        return "rbxthumb://type=Asset&id=" .. assetId .. "&w=150&h=150"
    end
    return "rbxassetid://" .. assetId
end

function VD_GetWarnIcon(colorName, path)
    local asset = VD_FormatAssetId(VD_WarnIconAssetIds[colorName])
    if asset then return asset end
    if VD_WarnIconCache[path] ~= nil then return VD_WarnIconCache[path] or nil end
    if not getcustomasset then
        VD_WarnIconCache[path] = false
        return nil
    end
    local ok, asset = pcall(getcustomasset, path)
    VD_WarnIconCache[path] = ok and asset or false
    return VD_WarnIconCache[path] or nil
end

function VD_EnsureWarnImage(parent, name, image, position)
    local img = parent:FindFirstChild(name)
    if not img then
        img = Instance.new("ImageLabel")
        img.Name = name
        img.BackgroundTransparency = 1
        img.ImageTransparency = 0
        img.ScaleType = Enum.ScaleType.Fit
        img.ZIndex = 2
        img.Parent = parent
    end
    img.Image = image or ""
    img.Position = position or UDim2.fromScale(0, 0)
    img.Size = UDim2.fromScale(0.5, 1)
    img.Visible = image ~= nil
    return img
end

function VD_UpdateSurvivorWarnings()
    if not VD.SURV_WarnKiller then
        if VD._WarnKillerActive then
            VD_ClearSurvivorWarnings()
            VD._WarnKillerActive = false
        end
        return
    end
    local now = tick()
    if VD._WarnKillerKyst and now < VD._WarnKillerKyst then return end
    VD._WarnKillerKyst = now + 0.15
    VD._WarnKillerActive = true

    local killers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsKiller(player) and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then table.insert(killers, root) end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if IsSurvivor(player) and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local nearest = math.huge
                for _, killerRoot in ipairs(killers) do
                    nearest = math.min(nearest, (root.Position - killerRoot.Position).Magnitude)
                end

                local warn = root:FindFirstChild("KYS_SurvivorKillerWarn")
                if nearest <= 60 then
                    local danger = nearest <= 40
                    if not warn then
                        warn = Instance.new("BillboardGui")
                        warn.Name = "KYS_SurvivorKillerWarn"
                        warn.Adornee = root
                        warn.AlwaysOnTop = true
                        warn.Size = UDim2.new(0, 76, 0, 44)
                        warn.StudsOffset = Vector3.new(0, 4.8, 0)
                        warn.MaxDistance = 2000
                        warn.Parent = root

                        local label = Instance.new("TextLabel")
                        label.Name = "FallbackLabel"
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.fromScale(1, 1)
                        label.Font = Enum.Font.GothamBlack
                        label.TextScaled = true
                        label.Visible = false
                        label.Parent = warn

                        local stroke = Instance.new("UIStroke")
                        stroke.Thickness = 1.5
                        stroke.Color = Color3.new(0, 0, 0)
                        stroke.Parent = label
                    end
                    local yellowIcon = VD_GetWarnIcon("Yellow", VD_WarnIconPaths.Yellow)
                    local purpleIcon = VD_GetWarnIcon("Red", VD_WarnIconPaths.red)
                    local canUseImages = yellowIcon ~= nil and (not danger or purpleIcon ~= nil)
                    warn.Size = danger and UDim2.new(0, 76, 0, 56) or UDim2.new(0, 56, 0, 56)

                    local yellow = VD_EnsureWarnImage(warn, "YellowIcon", yellowIcon, UDim2.fromScale(0, 0))
                    local purple = VD_EnsureWarnImage(warn, "redIcon", purpleIcon, UDim2.fromScale(0.38, 0))
                    yellow.Size = danger and UDim2.fromScale(0.62, 1) or UDim2.fromScale(1, 1)
                    purple.Size = UDim2.fromScale(0.62, 1)
                    yellow.Visible = canUseImages
                    purple.Visible = canUseImages and danger

                    local label = warn:FindFirstChild("FallbackLabel")
                    if label then
                        label.Visible = not canUseImages
                        label.Text = danger and "!!" or "!"
                        label.TextColor3 = danger and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(255, 225, 0)
                    end
                elseif warn then
                    warn:Destroy()
                end
            end
        end
    end
end

local VD_GateOriginal = setmetatable({}, { __mode = "k" })
function VD_SetPartState(part, props)
    if not part or not part:IsA("BasePart") then return end
    if not VD_GateOriginal[part] then
        VD_GateOriginal[part] = {
            Transparency = part.Transparency,
            CanCollide = part.CanCollide,
        }
    end
    pcall(function()
        if props.Transparency ~= nil then part.Transparency = props.Transparency end
        if props.CanCollide ~= nil then part.CanCollide = props.CanCollide end
    end)
end

function VD_RestoreGateParts()
    for part, props in pairs(VD_GateOriginal) do
        if part and part.Parent then
            pcall(function()
                part.Transparency = props.Transparency
                part.CanCollide = props.CanCollide
            end)
        end
    end
    VD_GateOriginal = setmetatable({}, { __mode = "k" })
end

function VD_UpdateBypassGate()
    if not VD.BypassGate then
        if next(VD_GateOriginal) then VD_RestoreGateParts() end
        return
    end
    if VD._KystBypassGate and tick() < VD._KystBypassGate then return end
    VD._KystBypassGate = tick() + 1
    for _, gate in ipairs(Workspace:GetDescendants()) do
        if gate:IsA("Model") and gate.Name == "Gate" then
            VD_SetPartState(gate:FindFirstChild("LeftGate"), { Transparency = 1, CanCollide = false })
            VD_SetPartState(gate:FindFirstChild("RightGate"), { Transparency = 1, CanCollide = false })
            VD_SetPartState(gate:FindFirstChild("LeftGate-end"), { Transparency = 0, CanCollide = true })
            VD_SetPartState(gate:FindFirstChild("RightGate-end"), { Transparency = 0, CanCollide = true })
            VD_SetPartState(gate:FindFirstChild("Box"), { CanCollide = false })
        end
    end
end

local VD_InvisibleNV = {
    Active = false,
    Seat = nil,
    Weld = nil,
    OriginalSpeed = nil,
    Position = Vector3.new(-25.95, 84, 3537.55),
}

function VD_SetCharacterTransparency(character, transparency)
    for _, descendant in ipairs(character:GetDescendants()) do
        if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant.Name ~= "HumanoidRootPart" then
            pcall(function() descendant.Transparency = transparency end)
        end
    end
end

function VD_SetInvisibleNotVisual(state)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not hum or not root or not torso then return end

    if state then
        if VD_InvisibleNV.Active then
            hum.WalkSpeed = VD.InvisibleSpeed or 16
            return
        end

        VD_InvisibleNV.Active = true
        VD_InvisibleNV.OriginalSpeed = hum.WalkSpeed
        local savedCFrame = root.CFrame

        char:MoveTo(VD_InvisibleNV.Position)
        task.wait(0.15)

        local seat = Instance.new("Seat")
        seat.Name = "KYS_InvisibleSeat"
        seat.Anchored = false
        seat.CanCollide = false
        seat.Transparency = 1
        seat.CFrame = CFrame.new(VD_InvisibleNV.Position)
        seat.Parent = Workspace

        local weld = Instance.new("Weld")
        weld.Part0 = seat
        weld.Part1 = torso
        weld.Parent = seat

        VD_InvisibleNV.Seat = seat
        VD_InvisibleNV.Weld = weld

        task.wait()
        seat.CFrame = savedCFrame
        VD_SetCharacterTransparency(char, 0.5)
        hum.WalkSpeed = VD.InvisibleSpeed or 16
    else
        VD.InvisibleNotVisual = false
        VD_InvisibleNV.Active = false
        if VD_InvisibleNV.Seat and VD_InvisibleNV.Seat.Parent then
            pcall(function() VD_InvisibleNV.Seat:Destroy() end)
        end
        VD_InvisibleNV.Seat = nil
        VD_InvisibleNV.Weld = nil
        VD_SetCharacterTransparency(char, 0)
        if VD_InvisibleNV.OriginalSpeed then
            hum.WalkSpeed = VD_InvisibleNV.OriginalSpeed
        end
        VD_InvisibleNV.OriginalSpeed = nil
    end
end

local VD_OriginalLungeBoost = nil
function VD_UpdateInfiniteLunge()
    local char = LocalPlayer.Character
    if not char then return end
    
    if VD.KILLER_InfLunge then
        if char:GetAttribute("lungeboost") ~= 999999 then
            VD_OriginalLungeBoost = char:GetAttribute("lungeboost") or 1
            char:SetAttribute("lungeboost", 999999)
        end
    else
        if VD_OriginalLungeBoost then
            char:SetAttribute("lungeboost", VD_OriginalLungeBoost)
            VD_OriginalLungeBoost = nil
        end
    end
end

function VD_UpdateInvisibleNotVisual()
    if not VD.InvisibleNotVisual then
        if VD_InvisibleNV.Active then VD_SetInvisibleNotVisual(false) end
        return
    end
    VD_SetInvisibleNotVisual(true)
end

local VD_MoonwalkState = {
    LastEnabled = false,
    Yaw = nil,
    Sway = 0,
    ButtonGui = nil,
    Button = nil,
    ButtonLabel = nil,
    SyncingUI = false,
}

function VD_RefreshMoonwalkButton()
    local btn = VD_MoonwalkState.Button
    if not (btn and btn.Parent) then return end
    btn.BackgroundColor3 = VD.Moonwalk and Color3.fromRGB(35, 185, 95) or Color3.fromRGB(20, 0, 30)
    local label = VD_MoonwalkState.ButtonLabel
    if label and label.Parent then
        label.Text = VD.Moonwalk and "ON" or "OFF"
        label.TextColor3 = VD.Moonwalk and Color3.fromRGB(190, 255, 210) or Color3.fromRGB(255, 255, 255)
    end
end

function VD_SetMoonwalk(state)
    VD.Moonwalk = state and true or false
    VD_RefreshMoonwalkButton()
end
getgenv().VD_SetMoonwalk = VD_SetMoonwalk

function VD_DestroyMoonwalkButton()
    if VD_MoonwalkState.ButtonGui then
        pcall(function() VD_MoonwalkState.ButtonGui:Destroy() end)
    end
    VD_MoonwalkState.ButtonGui = nil
    VD_MoonwalkState.Button = nil
    VD_MoonwalkState.ButtonLabel = nil
end

function VD_CreateMoonwalkButton()
    local parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
    if not parent then
        task.delay(1, VD_CreateMoonwalkButton)
        return
    end
    if VD_MoonwalkState.ButtonGui and VD_MoonwalkState.ButtonGui.Parent then
        VD_RefreshMoonwalkButton()
        return
    end

    local old = parent:FindFirstChild("KYS_MoonwalkButton")
    if old then pcall(function() old:Destroy() end) end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KYS_MoonwalkButton"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999999
    sg.Parent = parent

    local btn = Instance.new("ImageButton")
    btn.Name = "MoonwalkButton"
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(0.88, 0, 0.43, 0)
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Visible = true
    btn.ZIndex = 10
    btn.Parent = sg
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.2

    local lbl = Instance.new("TextLabel", btn)
    lbl.Name = "StateLabel"
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "OFF"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)

        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end

    pcall(applyShine, btn, Color3.fromRGB(20, 0, 30))
    pcall(applyShine, lbl, Color3.fromRGB(255, 0, 255))
    pcall(applyShine, stroke, Color3.fromRGB(255, 0, 255))

    local dragging = false
    local dragStart, startPos
    local moved = false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            moved = false
            if VD.MoonwalkButtonLocked then return end
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if VD.MoonwalkButtonLocked then return end
        if not dragging or not dragStart or not startPos then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then moved = true end
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end)

    btn.MouseButton1Click:Connect(function()
        if moved and not VD.MoonwalkButtonLocked then return end
        moved = false
        VD_SetMoonwalk(not VD.Moonwalk)
    end)

    VD_MoonwalkState.ButtonGui = sg
    VD_MoonwalkState.Button = btn
    VD_MoonwalkState.ButtonLabel = lbl
    VD_RefreshMoonwalkButton()
end

function VD_SetMoonwalkButtonVisible(state)
    VD.MoonwalkButton = state and true or false
    local flagName = VD_To_Flag and VD_To_Flag.MoonwalkButton
    local elem = flagName and Window and Window.ConfigElements and Window.ConfigElements[flagName]
    if elem and elem.Set and not VD_MoonwalkState.SyncingUI then
        VD_MoonwalkState.SyncingUI = true
        pcall(function() elem:Set(VD.MoonwalkButton) end)
        VD_MoonwalkState.SyncingUI = false
    end

    if VD.MoonwalkButton then
        VD_CreateMoonwalkButton()
    else
        VD_SetMoonwalk(false)
        VD_DestroyMoonwalkButton()
    end
end
getgenv().VD_SetMoonwalkButtonVisible = VD_SetMoonwalkButtonVisible

task.spawn(function()
    while getgenv().VD and not getgenv().VD.Destroyed do
        if VD.MoonwalkButton and not (VD_MoonwalkState.ButtonGui and VD_MoonwalkState.ButtonGui.Parent) then
            pcall(VD_CreateMoonwalkButton)
        elseif VD.MoonwalkButton then
            VD_RefreshMoonwalkButton()
        elseif VD_MoonwalkState.ButtonGui then
            VD_DestroyMoonwalkButton()
        end
        task.wait(3)
    end
end)

-- =====================================================
-- AIM LOCK - External Toggle Button + Logic
-- =====================================================
do
local VD_AimLockState = {
    Active = false,
    CurrentTarget = nil,
    ButtonGui = nil,
    Button = nil,
    ButtonLabel = nil,
    SyncingUI = false,
}

local function VD_AimLock_IsSurvivor(p)
    return p.Team and p.Team.Name == "Survivors"
end

local function VD_AimLock_IsDowned(character)
    if not character then return true end
    if character:GetAttribute("Knocked") == true then return true end
    if character:GetAttribute("IsHooked") == true then return true end
    local hum = character:FindFirstChild("Humanoid")
    if hum and hum.Health <= 0 then return true end
    return false
end

local function VD_AimLock_GetClosest()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local maxDist = VD.AimLockMaxDistance or 50
    local bestTarget = nil
    local bestDistance = maxDist + 1

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character and VD_AimLock_IsSurvivor(otherPlayer) then
            if not VD_AimLock_IsDowned(otherPlayer.Character) then
                local otherHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                local otherHum = otherPlayer.Character:FindFirstChild("Humanoid")

                if otherHrp and otherHum and otherHum.Health > 0 then
                    local distance = (otherHrp.Position - hrp.Position).Magnitude
                    if distance <= maxDist and distance < bestDistance then
                        bestDistance = distance
                        bestTarget = otherHrp
                    end
                end
            end
        end
    end

    return bestTarget
end

local function VD_RefreshAimLockButton()
    local btn = VD_AimLockState.Button
    if not (btn and btn.Parent) then return end
    btn.BackgroundColor3 = VD_AimLockState.Active and Color3.fromRGB(185, 50, 50) or Color3.fromRGB(20, 0, 30)
    local label = VD_AimLockState.ButtonLabel
    if label and label.Parent then
        label.Text = VD_AimLockState.Active and "ON" or "OFF"
        label.TextColor3 = VD_AimLockState.Active and Color3.fromRGB(255, 200, 200) or Color3.fromRGB(255, 255, 255)
    end
end

local function VD_SetAimLockActive(state)
    VD_AimLockState.Active = state and true or false
    if not VD_AimLockState.Active then
        VD_AimLockState.CurrentTarget = nil
    end
    VD_RefreshAimLockButton()
end
getgenv().VD_SetAimLockActive = VD_SetAimLockActive

local function VD_DestroyAimLockButton()
    if VD_AimLockState.ButtonGui then
        pcall(function() VD_AimLockState.ButtonGui:Destroy() end)
    end
    VD_AimLockState.ButtonGui = nil
    VD_AimLockState.Button = nil
    VD_AimLockState.ButtonLabel = nil
end

local function VD_CreateAimLockButton()
    local parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
    if not parent then
        task.delay(1, VD_CreateAimLockButton)
        return
    end
    if VD_AimLockState.ButtonGui and VD_AimLockState.ButtonGui.Parent then
        VD_RefreshAimLockButton()
        return
    end

    local old = parent:FindFirstChild("KYS_AimLockButton")
    if old then pcall(function() old:Destroy() end) end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KYS_AimLockButton"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999998
    sg.Parent = parent

    local btn = Instance.new("ImageButton")
    btn.Name = "AimLockButton"
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(0.88, 0, 0.55, 0)
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Visible = true
    btn.ZIndex = 10
    btn.Parent = sg
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255, 70, 70)
    stroke.Thickness = 2
    stroke.Transparency = 0.2

    local lbl = Instance.new("TextLabel", btn)
    lbl.Name = "StateLabel"
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "OFF"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)

        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end

    pcall(applyShine, btn, Color3.fromRGB(20, 0, 30))
    pcall(applyShine, lbl, Color3.fromRGB(255, 50, 50))
    pcall(applyShine, stroke, Color3.fromRGB(255, 50, 50))

    local dragging = false
    local dragStart, startPos
    local moved = false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            moved = false
            if VD.AimLockButtonLocked then return end
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if VD.AimLockButtonLocked then return end
        if not dragging or not dragStart or not startPos then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then moved = true end
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end)

    btn.MouseButton1Click:Connect(function()
        if moved and not VD.AimLockButtonLocked then return end
        moved = false
        VD_SetAimLockActive(not VD_AimLockState.Active)
    end)

    VD_AimLockState.ButtonGui = sg
    VD_AimLockState.Button = btn
    VD_AimLockState.ButtonLabel = lbl
    VD_RefreshAimLockButton()
end

local function VD_SetAimLockButtonVisible(state)
    VD.AimLockButton = state and true or false
    local flagName = VD_To_Flag and VD_To_Flag.AimLockButton
    local elem = flagName and Window and Window.ConfigElements and Window.ConfigElements[flagName]
    if elem and elem.Set and not VD_AimLockState.SyncingUI then
        VD_AimLockState.SyncingUI = true
        pcall(function() elem:Set(VD.AimLockButton) end)
        VD_AimLockState.SyncingUI = false
    end

    if VD.AimLockButton then
        VD_CreateAimLockButton()
    else
        VD_SetAimLockActive(false)
        VD_DestroyAimLockButton()
    end
end
getgenv().VD_SetAimLockButtonVisible = VD_SetAimLockButtonVisible

-- Keybind B untuk toggle Aim Lock
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.B and VD.AimLockButton then
        VD_SetAimLockActive(not VD_AimLockState.Active)
    end
end)

-- Reset aim lock saat respawn
LocalPlayer.CharacterAdded:Connect(function()
    if VD_AimLockState.Active then
        VD_SetAimLockActive(false)
    end
    VD_AimLockState.CurrentTarget = nil
end)

-- Keep-alive loop untuk Aim Lock button
task.spawn(function()
    while getgenv().VD and not getgenv().VD.Destroyed do
        if VD.AimLockButton and not (VD_AimLockState.ButtonGui and VD_AimLockState.ButtonGui.Parent) then
            pcall(VD_CreateAimLockButton)
        elseif VD.AimLockButton then
            VD_RefreshAimLockButton()
        elseif VD_AimLockState.ButtonGui then
            VD_DestroyAimLockButton()
        end
        task.wait(3)
    end
end)

-- Aim Lock update setiap frame (RenderStepped)
RunService.RenderStepped:Connect(function()
    if not VD_AimLockState.Active or not VD.AimLockButton then
        VD_AimLockState.CurrentTarget = nil
        return
    end

    local targetPart = VD_AimLock_GetClosest()
    if not targetPart then
        VD_AimLockState.CurrentTarget = nil
        return
    end

    VD_AimLockState.CurrentTarget = targetPart
    pcall(function()
        local cam = Workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
    end)
end)
end -- end AimLock scope

function VD_UpdateMoonwalk(deltaTime)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local cam = Workspace.CurrentCamera

    if VD.Moonwalk ~= VD_MoonwalkState.LastEnabled then
        if hum then hum.AutoRotate = not VD.Moonwalk end
        VD_MoonwalkState.LastEnabled = VD.Moonwalk
        if VD.Moonwalk and root then
            local _, y = root.CFrame:ToEulerAnglesYXZ()
            VD_MoonwalkState.Yaw = math.deg(y)
        end
    end

    if not VD.Moonwalk then
        return
    end
    if not root or not hum or not cam or hum.Health <= 0 then return end

    hum.AutoRotate = false
    local look = cam.CFrame.LookVector
    local targetYaw = math.deg(math.atan2(look.X, look.Z)) + 180
    local currentYaw = VD_MoonwalkState.Yaw or targetYaw
    local diff = (targetYaw - currentYaw + 180) % 360 - 180
    local lerpSpeed = 0.22 * math.clamp((deltaTime or 1 / 60) * 60, 0, 3)
    currentYaw = currentYaw + diff * lerpSpeed
    VD_MoonwalkState.Yaw = currentYaw

    local moving = hum.MoveDirection.Magnitude > 0.01
    local targetSway = 0
    if moving then
        targetSway = math.sin(tick() * (VD.MoonwalkZigzagSpeed or 11)) * 48
    end
    VD_MoonwalkState.Sway = (VD_MoonwalkState.Sway or 0) + (targetSway - (VD_MoonwalkState.Sway or 0)) * 0.38
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(currentYaw + VD_MoonwalkState.Sway), 0)

    if moving then
        hum:Move(hum.MoveDirection * (VD.MoonwalkBoostPower or 1.08), false)
    end
end

LocalPlayer.CharacterRemoving:Connect(function()
    if VD_InvisibleNV.Seat and VD_InvisibleNV.Seat.Parent then
        pcall(function() VD_InvisibleNV.Seat:Destroy() end)
    end
    VD_InvisibleNV.Active = false
    VD_InvisibleNV.Seat = nil
    VD_InvisibleNV.Weld = nil
    VD_MoonwalkState.LastEnabled = false
    VD_MoonwalkState.Yaw = nil
    VD_MoonwalkState.Sway = 0
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if VD.InvisibleNotVisual then pcall(VD_SetInvisibleNotVisual, true) end
end)

local VD_PalletwrongConnection = nil
local VD_PalletwrongScanning = false

function VD_DestroyPalletwrong(inst)
    if inst and inst:IsA("Model") and inst.Name == "Palletwrong" then
        pcall(function() inst:Destroy() end)
    end
end

function VD_StartRemovePalletwrong()
    if VD_PalletwrongConnection then return end

    VD_PalletwrongConnection = Workspace.DescendantAdded:Connect(function(inst)
        if VD.KILLER_NoPalletStun then
            VD_DestroyPalletwrong(inst)
        end
    end)

    if VD_PalletwrongScanning then return end
    VD_PalletwrongScanning = true
    task.spawn(function()
        local descendants = Workspace:GetDescendants()
        for i, inst in ipairs(descendants) do
            if not VD.KILLER_NoPalletStun then break end
            VD_DestroyPalletwrong(inst)
            if i % 250 == 0 then task.wait() end
        end
        VD_PalletwrongScanning = false
    end)
end

function VD_StopRemovePalletwrong()
    if VD_PalletwrongConnection then
        pcall(function() VD_PalletwrongConnection:Disconnect() end)
        VD_PalletwrongConnection = nil
    end
    VD_PalletwrongScanning = false
end

function VD_UpdateRemovePalletwrong()
    if VD.KILLER_NoPalletStun then
        VD_StartRemovePalletwrong()
    else
        VD_StopRemovePalletwrong()
    end
end

do
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if not VD.AntiAFK then return end
        pcall(function()
            vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            task.wait(0.2)
            vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end)
    end)
end

-- =====================================================
-- MAP CACHE (Generators / Gates / Hooks / Pallets / Windows)
-- =====================================================
local KYS_Cache = {
    Generators  = {},
    Gates       = {},
    Hooks       = {},
    Pallets     = {},
    Windows     = {},
    ClosestHook = nil,
    ExitPos     = nil
}

function KYS_ScanMap()
    local map = Workspace:FindFirstChild("Map")
    if not map then
        KYS_Cache = {
            Generators = {}, Zombies = {}, Gates = {}, Hooks = {}, Pallets = {}, Windows = {}, ClosestHook = nil, ExitPos = nil, ExitPart = nil
        }
        return
    end

    local newGens, newZombies, newGates, newHooks, newPallets, newWindows = {}, {}, {}, {}, {}, {}
    local exitPos = nil
    local exitPart = nil

    if map:FindFirstChild("churchbell") then
        exitPart = map:FindFirstChild("churchbell")
        if exitPart:IsA("Model") then exitPart = exitPart.PrimaryPart or exitPart:FindFirstChildWhichIsA("BasePart") end
        if exitPart then exitPos = exitPart.Position else exitPos = Vector3.new(760.98, -20.14, -78.48) end
    end

    local finish = map:FindFirstChild("Finishline") or map:FindFirstChild("FinishLine") or map:FindFirstChild("Fininshline")
    if finish then
        local fp = finish:IsA("BasePart") and finish or (finish:IsA("Model") and finish:FindFirstChildWhichIsA("BasePart"))
        if fp then exitPos = fp.Position; exitPart = fp end
    end

    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") then
            local part = obj:FindFirstChild("HitBox", true) or obj:FindFirstChild("GeneratorPoint", true) or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
            if part then
                local n = obj.Name
                if n == "Generator" then
                    table.insert(newGens, { model = obj, part = part })
                elseif n == "Gate" or n == "ExitGate" or obj:FindFirstChild("ExitLever") then
                    table.insert(newGates, { model = obj, part = part })
                elseif n == "Hook" then
                    table.insert(newHooks, { model = obj, part = part })
                elseif n == "Palletwrong" or n:lower():find("pallet") then
                    table.insert(newPallets, { model = obj, part = part })
                elseif n == "Window" then
                    table.insert(newWindows, { model = obj, part = part })
                end
            end
        elseif obj:IsA("BasePart") then
            if not exitPos and obj.Name:lower():find("finish") then
                exitPos = obj.Position
                exitPart = obj
            end
            if not exitPos and obj:IsA("MeshPart") then
                if obj.Material == Enum.Material.Limestone then
                    exitPos = Vector3.new(-947.90, 152.12, -7579.52)
                    exitPart = obj
                elseif obj.Material == Enum.Material.Leather then
                    exitPos = Vector3.new(1546.12, 152.21, -796.72)
                    exitPart = obj
                end
            end
            -- Tambahkan VaultTrigger ke cache window jika ditemukan
            if obj.Name == "VaultTrigger" then
                table.insert(newWindows, { model = obj.Parent, part = obj })
            end
            -- Tambahkan VaultPoint di dalam VaultTrigger (untuk path workspace.Map.Vaults:GetChildren()[4]:GetChildren()[2].VaultPoint)
            if obj.Name == "VaultPoint" and obj.Parent and obj.Parent.Name == "VaultTrigger" then
                table.insert(newWindows, { model = obj.Parent, part = obj })
            end
            -- Tambahkan PalletPoint dan PalletPointSlide ke cache pallet
            -- Spy confirmed: server menerima PalletPointSlide sebagai target drop
            if obj.Name == "PalletPoint" or obj.Name == "PalletPointSlide" then
                table.insert(newPallets, { model = obj.Parent, part = obj })
            end
        end
    end

    KYS_Cache.Generators = newGens
    KYS_Cache.Gates      = newGates
    KYS_Cache.Hooks      = newHooks
    KYS_Cache.Pallets    = newPallets
    KYS_Cache.Windows    = newWindows
    KYS_Cache.ExitPos    = exitPos
    KYS_Cache.ExitPart   = exitPart
    print("[KYS ScanMap] Generators:", #newGens, "Gates:", #newGates, "Hooks:", #newHooks, "Windows:", #newWindows)

    local root           = Root
    if root and #KYS_Cache.Hooks > 0 then
        local closest, closestDist = nil, math.huge
        for _, hook in ipairs(KYS_Cache.Hooks) do
            if hook.part then
                local d = (hook.part.Position - root.Position).Magnitude
                if d < closestDist then
                    closestDist = d; closest = hook
                end
            end
        end
        KYS_Cache.ClosestHook = closest
    end
end

-- =====================================================
-- RADAR SYSTEM
-- =====================================================
local radarGui = nil
local radarFrame = nil
local radarDots = {}
local radarObjectDots = {}

local RADAR_COLORS = {
    Killer = Color3.fromRGB(255, 0, 0), -- Merah untuk Killer
    Survivor = Color3.fromRGB(255, 165, 0), -- Oranye untuk Survivor (tim)
    Generator = Color3.fromRGB(255, 140, 0),
    Gate = Color3.fromRGB(100, 200, 255),
    Pallet = Color3.fromRGB(53, 189, 166),
    Hook = Color3.fromRGB(252, 116, 116),
    Window = Color3.fromRGB(80, 160, 255),
    Zombie = Color3.fromRGB(150, 255, 50)
}

local MaskColors = {
    Abysswalker = Color3.fromRGB(110, 20, 255),
    Cure = Color3.fromRGB(0, 100, 255),
    Hidden = Color3.fromRGB(170, 170, 170),
    Killer = Color3.fromRGB(255, 40, 40),
    Masked = Color3.fromRGB(255, 90, 20),
    Stalker = Color3.fromRGB(255, 0, 140),
    Veil = Color3.fromRGB(0, 200, 255),
    Slasher = Color3.fromRGB(180, 0, 255),
}

function GetKillerColorForRadar(killerPlayer)
    return RADAR_COLORS.Killer -- Selalu merah sesuai permintaan
end

function CreateRadarGUI()
    local parent = GetSafeGuiParent()
    if not parent then return false end
    
    if radarGui then pcall(function() radarGui:Destroy() end) end
    
    radarGui = Instance.new("ScreenGui")
    radarGui.Name = "KysHub_RadarGUI"
    radarGui.ResetOnSpawn = false
    radarGui.IgnoreGuiInset = true
    radarGui.Parent = parent
    
    radarFrame = Instance.new("Frame")
    radarFrame.Name = "RadarFrame"
    radarFrame.Size = UDim2.new(0, VD.RADAR_Size, 0, VD.RADAR_Size)
    radarFrame.Position = UDim2.new(0, 10, 0, 120)
    radarFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    radarFrame.BackgroundTransparency = 1 - VD.RADAR_Transparency
    radarFrame.BorderSizePixel = 0
    radarFrame.Active = true
    radarFrame.Draggable = true
    radarFrame.Parent = radarGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = VD.RADAR_Circle and UDim.new(1, 0) or UDim.new(0, 8)
    corner.Parent = radarFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = radarFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, 0, 0, 20)
    titleText.BackgroundTransparency = 1
    titleText.Text = "A2 RADAR"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextSize = 12
    titleText.Parent = radarFrame
    
    local crossH = Instance.new("Frame")
    crossH.Size = UDim2.new(1, -40, 0, 1)
    crossH.Position = UDim2.new(0, 20, 0.5, 0)
    crossH.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    crossH.BorderSizePixel = 0
    crossH.Parent = radarFrame
    
    local crossV = Instance.new("Frame")
    crossV.Size = UDim2.new(0, 1, 1, -40)
    crossV.Position = UDim2.new(0.5, 0, 0, 20)
    crossV.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    crossV.BorderSizePixel = 0
    crossV.Parent = radarFrame
    
    local centerDot = Instance.new("Frame")
    centerDot.Size = UDim2.new(0, 8, 0, 8)
    centerDot.Position = UDim2.new(0.5, -4, 0.5, -4)
    centerDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Hijau untuk kita
    centerDot.BorderSizePixel = 0
    centerDot.Parent = radarFrame
    
    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(1, 0)
    centerCorner.Parent = centerDot
    
    local rangeText = Instance.new("TextLabel")
    rangeText.Name = "RangeText"
    rangeText.Size = UDim2.new(1, 0, 0, 14)
    rangeText.Position = UDim2.new(0, 0, 1, -14)
    rangeText.BackgroundTransparency = 1
    rangeText.Text = "Range: ".. VD.RADAR_Range.. "m"
    rangeText.TextColor3 = Color3.fromRGB(200, 200, 200)
    rangeText.Font = Enum.Font.SourceSans
    rangeText.TextSize = 10
    rangeText.Parent = radarFrame
    
    radarDots = {}
    for i = 1, 30 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
        dot.BorderSizePixel = 0
        dot.Visible = false
        dot.Parent = radarFrame
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot
        table.insert(radarDots, dot)
    end
    
    radarObjectDots = {}
    for i = 1, 80 do
        local objDot = Instance.new("Frame")
        objDot.Size = UDim2.new(0, 4, 0, 4)
        objDot.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
        objDot.BorderSizePixel = 0
        objDot.Visible = false
        objDot.Parent = radarFrame
        local objCorner = Instance.new("UICorner")
        objCorner.CornerRadius = UDim.new(1, 0)
        objCorner.Parent = objDot
        table.insert(radarObjectDots, objDot)
    end
    
    return true
end

function UpdateRadar()
    if not VD.RADAR_Enabled then
        if radarGui then radarGui.Enabled = false end
        return
    end
    
    if not radarGui or not radarFrame or not radarGui.Parent then
        if not CreateRadarGUI() then return end
    end
    
    radarGui.Enabled = true
    radarFrame.Visible = true
    
    local camera = workspace.CurrentCamera
    local root = Root or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
    if not camera or not root then return end
    
    radarFrame.Size = UDim2.new(0, VD.RADAR_Size, 0, VD.RADAR_Size)
    radarFrame.BackgroundTransparency = 1 - VD.RADAR_Transparency
    
    local corner = radarFrame:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = VD.RADAR_Circle and UDim.new(1, 0) or UDim.new(0, 8)
    end
    
    local rangeText = radarFrame:FindFirstChild("RangeText")
    if rangeText then rangeText.Text = "Range: ".. VD.RADAR_Range.. "m" end
    
    for _, dot in ipairs(radarDots) do dot.Visible = false end
    for _, dot in ipairs(radarObjectDots) do dot.Visible = false end
    
    local halfSize = VD.RADAR_Size / 2
    local margin = 5
    local usableHalf = halfSize - margin
    local scale = usableHalf / VD.RADAR_Range
    
    local cameraLook = camera.CFrame.LookVector
    local playerAngle = math.atan2(-cameraLook.X, -cameraLook.Z)
    local cosAngle = math.cos(playerAngle)
    local sinAngle = math.sin(playerAngle)
    local playerPos = root.Position
    
    local function WorldToRadar(worldPos)
        local deltaX = worldPos.X - playerPos.X
        local deltaZ = worldPos.Z - playerPos.Z
        local distance = math.sqrt(deltaX * deltaX + deltaZ * deltaZ)
        if distance > VD.RADAR_Range then return nil end
        
        local rotatedX = deltaX * cosAngle - deltaZ * sinAngle
        local rotatedZ = deltaX * sinAngle + deltaZ * cosAngle
        local radarX = rotatedX * scale
        local radarY = rotatedZ * scale
        local clampedX = math.clamp(radarX, -usableHalf + 4, usableHalf - 4)
        local clampedY = math.clamp(radarY, -usableHalf + 4, usableHalf - 4)
        return Vector2.new(halfSize + clampedX, halfSize + clampedY)
    end
    
    local dotIndex = 1
    local objIndex = 1
    local drawnPlayers = {}
    local drawnObjects = {}
    
    local function AddObjectDot(pos, color, size, identifier)
        if not pos or drawnObjects[identifier] then return end
        drawnObjects[identifier] = true
        if objIndex <= #radarObjectDots then
            local dot = radarObjectDots[objIndex]
            dot.Size = UDim2.new(0, size, 0, size)
            dot.Position = UDim2.new(0, pos.X - (size/2), 0, pos.Y - (size/2))
            dot.BackgroundColor3 = color
            dot.Visible = true
            objIndex = objIndex + 1
        end
    end
    
    -- Player dots
    if VD.RADAR_ShowKiller or VD.RADAR_ShowSurvivor then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if playerRoot then
                    local isKiller = IsKiller(player)
                    local shouldShow = (isKiller and VD.RADAR_ShowKiller) or (not isKiller and VD.RADAR_ShowSurvivor)
                    if shouldShow and not drawnPlayers[player.UserId] then
                        local pos = WorldToRadar(playerRoot.Position)
                        if pos and dotIndex <= #radarDots then
                            drawnPlayers[player.UserId] = true
                            local dot = radarDots[dotIndex]
                            if isKiller then
                                dot.Size = UDim2.new(0, 7, 0, 7)
                                dot.Position = UDim2.new(0, pos.X - 3.5, 0, pos.Y - 3.5)
                                dot.BackgroundColor3 = GetKillerColorForRadar(player)
                            else
                                dot.Size = UDim2.new(0, 6, 0, 6)
                                dot.Position = UDim2.new(0, pos.X - 3, 0, pos.Y - 3)
                                dot.BackgroundColor3 = RADAR_COLORS.Survivor -- Oranye untuk Survivor (tim)
                            end
                            dot.Visible = true
                            dotIndex = dotIndex + 1
                        end
                    end
                end
            end
        end
    end
    
    -- Generator dots
    if VD.RADAR_ShowGenerator then
        for _, gen in ipairs(KYS_Cache.Generators or {}) do
            if gen.model and gen.model.Parent and gen.part then
                local pos = WorldToRadar(gen.part.Position)
                if pos then AddObjectDot(pos, RADAR_COLORS.Generator, 5, "gen_" .. tostring(gen.model)) end
            end
        end
    end
    
    -- Pallet dots
    if VD.RADAR_ShowPallet then
        for _, pallet in ipairs(KYS_Cache.Pallets or {}) do
            if pallet.model and pallet.model.Parent and pallet.part then
                local isBroken = false
                local ok, db = pcall(function() return pallet.model:GetAttribute("Destroyed") or pallet.model:GetAttribute("Broken") or pallet.model:GetAttribute("IsBroken") end)
                if ok and db then isBroken = true end
                if not isBroken and not pallet.model:FindFirstChildWhichIsA("BasePart", true) then
                    isBroken = true
                end
                if not isBroken then
                    local pos = WorldToRadar(pallet.part.Position)
                    if pos then AddObjectDot(pos, RADAR_COLORS.Pallet, 4, "pallet_" .. tostring(pallet.model)) end
                end
            end
        end
    end
    
    -- Hook dots
    if VD.RADAR_ShowHook then
        for _, hook in ipairs(KYS_Cache.Hooks or {}) do
            if hook.model and hook.model.Parent and hook.part then
                local pos = WorldToRadar(hook.part.Position)
                if pos then AddObjectDot(pos, RADAR_COLORS.Hook, 5, "hook_" .. tostring(hook.model)) end
            end
        end
    end
    
    -- Gate dots
    if VD.RADAR_ShowGate then
        for _, gate in ipairs(KYS_Cache.Gates or {}) do
            if gate.model and gate.model.Parent and gate.part then
                local pos = WorldToRadar(gate.part.Position)
                if pos then AddObjectDot(pos, RADAR_COLORS.Gate, 5, "gate_" .. tostring(gate.model)) end
            end
        end
    end
    
    -- Window dots
    if VD.RADAR_ShowWindow then
        for _, window in ipairs(KYS_Cache.Windows or {}) do
            if window.model and window.model.Parent and window.part then
                local pos = WorldToRadar(window.part.Position)
                if pos then AddObjectDot(pos, RADAR_COLORS.Window, 4, "window_" .. tostring(window.model)) end
            end
        end
    end
    
    -- Zombie/SCP dots
    if VD.RADAR_ShowZombie then
        if KYS_WorldReg and KYS_WorldReg.SCPZombie then
            for model, entry in pairs(KYS_WorldReg.SCPZombie) do
                if model and model.Parent then
                    local refPart = model:FindFirstChild("HumanoidRootPart") or (entry and entry.part) or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    if refPart then
                        local pos = WorldToRadar(refPart.Position)
                        if pos then AddObjectDot(pos, RADAR_COLORS.Zombie, 5, "zombie_" .. tostring(model)) end
                    end
                end
            end
        end
    end
end

-- =====================================================
-- TELEPORT HELPERS
-- =====================================================
local originalCanCollide = {}

function KYS_TeleportToPosition(pos)
    if not pos then return false end
    local root = Root
    if not root then return false end

    if LocalPlayer.Character then
        root.Anchored = true -- Tahan agar tidak jatuh ke luar map saat CanCollide mati
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if originalCanCollide[part] == nil then originalCanCollide[part] = part.CanCollide end
                part.CanCollide = false
            end
        end
    end

    root.CFrame = CFrame.new(pos + Vector3.new(0, VD.TP_Offset, 0))

    task.delay(0.3, function()
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    pcall(function()
                        part.CanCollide = (originalCanCollide[part] ~= nil) and originalCanCollide[part] or true
                    end)
                end
            end
            root.Anchored = false -- Lepas tahanan setelah collision aktif
        end
        originalCanCollide = {}
    end)
    return true
end

function KYS_TeleportToGenerator(index)
    if not KYS_Cache or not KYS_Cache.Generators or #KYS_Cache.Generators == 0 then print("[KYS HUB] Generator tidak ditemukan") return false end

    local sorted = {}
    for _, gen in ipairs(KYS_Cache.Generators) do
        table.insert(sorted, {gen = gen, dist = (Root and (gen.part.Position - Root.Position).Magnitude) or math.huge})
    end
    table.sort(sorted, function(a, b) return a.dist < b.dist end)

    local target = sorted[index or 1]
    if not target then return false end
    return KYS_TeleportToPosition(target.gen.part.Position)
end

function KYS_TeleportToGate()
    if not KYS_Cache or not KYS_Cache.Gates or #KYS_Cache.Gates == 0 then print("[KYS HUB] Gate tidak ditemukan") return false end
    local closest, closestDist = nil, math.huge
    for _, gate in ipairs(KYS_Cache.Gates) do
        local dist = (Root and (gate.part.Position - Root.Position).Magnitude) or math.huge
        if dist < closestDist then
            closestDist = dist
            closest = gate
        end
    end

    if not closest then return false end
    return KYS_TeleportToPosition(closest.part.Position)
end

function KYS_TeleportToHook()
    if not KYS_Cache or not KYS_Cache.ClosestHook then print("[KYS HUB] Hook tidak ditemukan") return false end
    return KYS_TeleportToPosition(KYS_Cache.ClosestHook.part.Position)
end

-- MAP CHANGE DETECTION
local CurrentMapName = nil
local MapWatchConnections = {}
local MapScanQueued       = false

function DisconnectMapWatchers()
    for _, conn in ipairs(MapWatchConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    MapWatchConnections = {}
end

function CheckMapChange()
    local map = Workspace:FindFirstChild("Map")
    local mapName = map and map.Name or "Unknown"
    if CurrentMapName ~= mapName then
        -- print("[KYS HUB] Map berubah: " .. tostring(CurrentMapName) .. " -> " .. mapName)
        VD._BeatSurvivorDone = false
        VD._BeatKillerDone = false
        VD._LastTeleAway = 0
        VD._KillerTarget = nil
    end
    CurrentMapName = mapName

    KYS_ScanMap()
end

function QueueMapScan(delaySec)
    if MapScanQueued then return end
    MapScanQueued = true
    task.delay(delaySec or 0.15, function()
        MapScanQueued = false
        if VD.Destroyed then return end
        CheckMapChange()
    end)
end

function WatchCurrentMap(map)
    DisconnectMapWatchers()
    if not map then return end

    local function onDescendantAdded(descendant)
        if descendant:IsA("Model") or descendant:IsA("Folder") then
            local n = descendant.Name:lower()
            if n:find("generator") or n:find("mesin") or n:find("pallet") or n:find("window") or n:find("hook") or n:find("gate") then
                task.delay(0.5, function()
                    if not descendant.Parent then return end
                    local part = descendant:FindFirstChild("HitBox", true) or descendant:FindFirstChild("GeneratorPoint", true) or descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart", true)
                    if part then
                        if n:find("generator") or n:find("mesin") then table.insert(KYS_Cache.Generators, {model=descendant, part=part})
                        elseif n:find("pallet") then table.insert(KYS_Cache.Pallets, {model=descendant, part=part})
                        elseif n:find("window") then table.insert(KYS_Cache.Windows, {model=descendant, part=part})
                        elseif n:find("hook") then table.insert(KYS_Cache.Hooks, {model=descendant, part=part})
                        elseif n:find("gate") then table.insert(KYS_Cache.Gates, {model=descendant, part=part})
                        end
                    end
                end)
            end
        end
    end

    table.insert(MapWatchConnections, map.DescendantAdded:Connect(onDescendantAdded))

    table.insert(MapWatchConnections, map.AncestryChanged:Connect(function(_, parent)
        if not parent then QueueMapScan(0.05) end
    end))
end

Workspace.ChildAdded:Connect(function(child)
    if child and child.Name == "Map" then
        WatchCurrentMap(child)
        QueueMapScan(0.05)
    end
    
    if child and child.Name == "Spearprojectile" and VD.SURV_AutoDodgeSpear and GetRole() == "Survivor" then
        task.spawn(function()
            if getgenv().KYS_IsDodging then return end
            
            local root = Root
            if not root then return end
            
            -- Biarkan projectile inisialisasi arahnya beberapa frame
            task.wait(0.05)
            
            -- Cari part fisiknya (Hitbox atau Spear1)
            -- Cari part fisiknya
            local mainPart = child:WaitForChild("Hitbox", 1) or child:WaitForChild("Spear1", 1) or child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
            if not mainPart then return end
            
            -- Biarkan posisinya set set dulu oleh gamenya (1 frame)
            task.wait()
            
            local originPos = mainPart.Position
            -- Berdasarkan bedah module game, Spear diputar CFrame.Angles(-math.pi/2, 0, 0)
            -- Ini membuat UpVector (Y) berubah menjadi arah lintasan (LookVector/Z).
            local spearDir = mainPart.CFrame.UpVector
            
            local toPlayer = (root.Position - originPos).Unit
            local dot = spearDir:Dot(toPlayer)
            
            -- Jika dot mendekati 1, tombak mengarah sangat dekat ke kita
            if dot > 0.85 then 
                if dot > 0.85 then -- Sudut cukup sempit, berbahaya!
                    getgenv().KYS_IsDodging = true
                    
                    local originalCFrame = root.CFrame
                    
                    -- Teleport ke samping sejauh 8 stud
                    local rightVector = root.CFrame.RightVector
                    root.CFrame = root.CFrame + (rightVector * 8)
                    
                    pcall(VD_Notify, "Auto Dodge", "Spear terdeteksi! Menghindar otomatis...", 2)
                    
                    -- Tunggu 1 detik lalu balik ke posisi awal
                    task.wait(1)
                    
                    if Root then
                        Root.CFrame = originalCFrame
                    end
                    
                    getgenv().KYS_IsDodging = false
                end
            end
        end)
    end
end)

Workspace.ChildRemoved:Connect(function(child)
    if child and child.Name == "Map" then
        DisconnectMapWatchers()
        QueueMapScan(0.05)
    end
end)

do
    local map = Workspace:FindFirstChild("Map")
    if map then WatchCurrentMap(map) end
    CheckMapChange()
end

-- =====================================================
-- AUTO ATTACK (Killer)
-- =====================================================
do -- begin Auto Features scope
local function KYS_AutoAttack()
    if not VD.AUTO_Attack or GetRole() ~= "Killer" then return end
    local root = Root
    if not root then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local tHum = player.Character:FindFirstChildOfClass("Humanoid")

            if tRoot and tHum and tHum.MaxHealth > 0 then
                local pct = tHum.Health / tHum.MaxHealth
                if pct > 0.25 and (tRoot.Position - root.Position).Magnitude <= VD.AUTO_AttackRange then
                    pcall(function()
                        local r = ReplicatedStorage:FindFirstChild("Remotes")
                        local a = r and r:FindFirstChild("Attacks")
                        local b = a and a:FindFirstChild("BasicAttack")
                        if b then b:FireServer(false) end
                    end)
                    break
                end
            end
        end
    end
end

-- =====================================================
-- AUTO VAULT (Survivor) - otomatis saat dekat Window
-- =====================================================
-- Lacak window yang sudah di-vault agar tidak loop terus
local _vaultedWindows  = {}  -- [rootWindow] = lastTime
local _lastVaultScan   = 0

RunService.Heartbeat:Connect(function()
    if VD.SURV_FastVault then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                char:SetAttribute("vaultspeed", (VD.SURV_VaultSpeed or 13) / 10)
            end
        end)
    end
    
    if VD.SURV_FleeKiller then
        pcall(function()
            local root = Root
            if not root then return end
            if GetRole() == "Killer" then return end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and IsKiller(player) then
                    local killerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if killerRoot and (killerRoot.Position - root.Position).Magnitude <= (VD.SURV_FleeDistance or 40) then
                        local direction = (root.Position - killerRoot.Position).Unit
                        root.CFrame = CFrame.new(root.Position + direction * ((VD.SURV_FleeDistance or 40) + 15), root.Position + direction * 100)
                        break
                    end
                end
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    if not VD.SURV_AutoVault then return end
    if GetRole() ~= "Survivor" then return end
    if tick() - _lastVaultScan < 0.15 then return end  -- cek 6-7x per detik
    _lastVaultScan = tick()

    pcall(function()
        local char   = LocalPlayer.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        local hum    = char and char:FindFirstChildOfClass("Humanoid")
        if not myRoot or not hum or hum.Health <= 0 then return end

        -- Hanya vault kalau sedang bergerak (kecepatan > 1)
        local vel = myRoot.AssemblyLinearVelocity
        if vel.Magnitude < 1 then return end

        local remotes   = ReplicatedStorage:FindFirstChild("Remotes")
        local winFolder = remotes and remotes:FindFirstChild("Window")
        local vaultEv   = winFolder and winFolder:FindFirstChild("VaultCommit")
        if not vaultEv then return end

        -- Kelompokkan part vault per window secara akurat
        local windowGroups = {}
        for _, win in ipairs(KYS_Cache.Windows or {}) do
            local part = win.part or win.model
            if part then
                local rootWindow = part.Parent
                -- Jika part adalah VaultPoint, root windownya adalah parent dari VaultTrigger
                if part.Name == "VaultPoint" and part.Parent and part.Parent.Name == "VaultTrigger" then
                    rootWindow = part.Parent.Parent
                elseif part.Name == "VaultTrigger" and part.Parent then
                    rootWindow = part.Parent
                end

                if rootWindow then
                    windowGroups[rootWindow] = windowGroups[rootWindow] or {}
                    -- Hindari duplikasi
                    local exists = false
                    for _, p in ipairs(windowGroups[rootWindow]) do
                        if p == part then exists = true break end
                    end
                    if not exists then
                        table.insert(windowGroups[rootWindow], part)
                    end
                end
            end
        end

        -- Untuk setiap group window, cek jika player dekat salah satu part
        for rootWindow, parts in pairs(windowGroups) do

            -- Kumpulkan SEMUA VaultTrigger dari rootWindow secara langsung.
            -- Dikonfirmasi dari remote spy:
            --   Aâ†’B pakai VaultTrigger ke-2 (GetChildren()[4])
            --   Bâ†’A pakai VaultTrigger pertama (.VaultTrigger = FindFirstChild)
            -- Arah ditentukan dari VaultTrigger MANA yang dikirim, bukan posisi player.
            -- VaultTrigger terdekat dengan player = sisi yang sama = trigger yang benar.
            local function getVTPosition(vt)
                if vt:IsA("BasePart") then
                    return vt.Position
                end
                -- Jika Model, ambil dari PrimaryPart atau BasePart pertama
                if vt:IsA("Model") then
                    if vt.PrimaryPart then return vt.PrimaryPart.Position end
                    local bp = vt:FindFirstChildWhichIsA("BasePart", true)
                    if bp then return bp.Position end
                end
                return nil
            end

            local allVTs = {}
            for _, child in ipairs(rootWindow:GetChildren()) do
                if child.Name == "VaultTrigger" then
                    table.insert(allVTs, child)
                end
            end

            -- Jika tidak ada VaultTrigger di rootWindow, skip window ini
            if #allVTs == 0 then continue end

            -- Cari VaultTrigger TERDEKAT dengan player (= trigger sisi yang sama = benar)
            local nearestVT, nearestVTDist = nil, math.huge
            for _, vt in ipairs(allVTs) do
                local pos = getVTPosition(vt)
                if pos then
                    local d = (myRoot.Position - pos).Magnitude
                    if d < nearestVTDist then
                        nearestVTDist = d
                        nearestVT = vt
                    end
                end
            end

            -- Player harus dalam radius 6.0 studs dari VaultTrigger terdekat
            if not nearestVT or nearestVTDist > 6.0 then continue end

            -- Cek cooldown per-rootWindow (3.0s)
            local lastUsed = _vaultedWindows[rootWindow] or 0
            if tick() - lastUsed < 3.0 then continue end

            -- finalTarget = VaultTrigger terdekat (sesuai sisi player)
            local finalTarget = nearestVT

            local remotes2 = ReplicatedStorage:FindFirstChild("Remotes")
            local winFold  = remotes2 and remotes2:FindFirstChild("Window")
            if winFold and finalTarget then
                local vaultEvent     = winFold:FindFirstChild("VaultEvent")
                local vaultBindable  = winFold:FindFirstChild("Vaultbindable")
                local fastvault      = winFold:FindFirstChild("fastvault")
                local vaultComplete1 = winFold:FindFirstChild("VaultCompleteEventpart1")
                local vaultComplete  = winFold:FindFirstChild("VaultCompleteEvent")

                -- Sesuai spy: VaultEvent(nearestVT, true) â†’ fastvault â†’ Complete1 â†’ CompleteEvent(nearestVT, false)
                if vaultEvent    then pcall(function() vaultEvent:FireServer(finalTarget, true) end) end
                if vaultBindable then pcall(function() vaultBindable:Fire(finalTarget, true) end) end
                if fastvault     then pcall(function() fastvault:FireServer(LocalPlayer) end) end
                if vaultComplete1 then pcall(function() vaultComplete1:FireServer() end) end
                if vaultComplete  then pcall(function() vaultComplete:FireServer(finalTarget, false) end) end
            end

            _vaultedWindows[rootWindow] = tick()
            break
        end

    end)
end)

-- =====================================================
-- AUTO PALLET DROP (Survivor) - otomatis saat killer dekat
-- =====================================================
-- Spy confirmed: PalletDropEvent:FireServer(PalletPointSlide)
-- Hanya 1 event yang perlu dikirim (bukan Commit/Anim)
-- Pallet ada di workspace.Map.Rooftop â†’ scan scope diperluas
local _lastPalletDrop  = 0
local _usedPallets     = {}  -- [palletwrong model] = true

local function getKillerRoot()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if IsSurvivor and IsSurvivor(plr) then continue end
        local char = plr.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then return root end
        end
    end
    return nil
end

local _lastPalletScan = 0
RunService.Heartbeat:Connect(function()
    if not VD.SURV_AutoPallet then return end
    if GetRole() ~= "Survivor" then return end
    if tick() - _lastPalletScan < 0.2 then return end
    _lastPalletScan = tick()
    if tick() - _lastPalletDrop < 2.5 then return end

    pcall(function()
        local char   = LocalPlayer.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        local hum    = char and char:FindFirstChildOfClass("Humanoid")
        if not myRoot or not hum or hum.Health <= 0 then return end

        local killerRoot = getKillerRoot()
        if not killerRoot then return end
        if (myRoot.Position - killerRoot.Position).Magnitude > VD.SURV_AutoPalletDist then return end

        local remotes    = ReplicatedStorage:FindFirstChild("Remotes")
        local palletFold = remotes and remotes:FindFirstChild("Pallet")
        local dropEvent  = palletFold and palletFold:FindFirstChild("PalletDropEvent")
        if not dropEvent then return end

        -- Scan pallet dari KYS_Cache + langsung dari workspace
        -- Cari Palletwrong terdekat yang belum di-drop
        local bestPalletwrong, bestDist = nil, 8  -- max 8 studs

        -- Helper: cari PalletPointSlide di dalam Palletwrong model
        local function findPalletPointSlide(model)
            -- Spy: target = Palletwrong.PalletPointSlide
            local slide = model:FindFirstChild("PalletPointSlide")
            if slide then return slide end
            -- Fallback: cari di descendants
            for _, child in ipairs(model:GetDescendants()) do
                if child.Name == "PalletPointSlide" then return child end
            end
            -- Fallback terakhir: PalletPoint
            return model:FindFirstChild("PalletPoint")
        end

        -- Iterasi KYS_Cache.Pallets untuk cari Palletwrong terdekat
        for _, pal in ipairs(KYS_Cache.Pallets or {}) do
            local palModel = pal.model  -- ini adalah Palletwrong model
            if not palModel then continue end
            if _usedPallets[palModel] then continue end

            -- Gunakan PalletPoint/PalletPointSlide sebagai referensi posisi
            local refPart = pal.part or palModel:FindFirstChild("PalletPoint")
                         or palModel:FindFirstChild("PalletPointSlide")
            if not refPart then continue end

            local ok, pos = pcall(function() return refPart.Position end)
            if not ok or not pos then continue end

            local d = (myRoot.Position - pos).Magnitude
            if d < bestDist then
                bestDist = d
                bestPalletwrong = palModel
            end
        end

        if bestPalletwrong then
            -- Cari PalletPointSlide di dalam Palletwrong (sesuai spy)
            local fireTarget = findPalletPointSlide(bestPalletwrong)
            if fireTarget then
                -- Spy confirmed: hanya PalletDropEvent(PalletPointSlide)
                pcall(function() dropEvent:FireServer(fireTarget) end)
                _usedPallets[bestPalletwrong] = true
                _lastPalletDrop = tick()
            end
        end
    end)
end)

-- =====================================================
-- HITBOX EXPAND (Killer)
-- =====================================================
local OriginalHitboxSizes = {}

local function KYS_UpdateHitboxes()
    local function restoreAll()
        for player, originalSize in pairs(OriginalHitboxSizes) do
            if player and player.Character then
                local r = player.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    r.Size = originalSize; r.Transparency = 1; r.CanCollide = true
                end
            end
        end
        OriginalHitboxSizes = {}
    end

    if GetRole() ~= "Killer" or not VD.HITBOX_Enabled then
        restoreAll()
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum  = char:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    if not OriginalHitboxSizes[player] then
                        OriginalHitboxSizes[player] = root.Size
                    end
                    local sz          = VD.HITBOX_Size
                    root.Size         = Vector3.new(sz, sz, sz)
                    root.CanCollide   = false
                    root.Transparency = 0.7
                elseif root and OriginalHitboxSizes[player] then
                    root.Size                   = OriginalHitboxSizes[player]
                    root.Transparency           = 1
                    root.CanCollide             = true
                    OriginalHitboxSizes[player] = nil
                end
            end
        end
    end
end

-- =====================================================
-- DESTROY ALL PALLETS (Killer)
-- =====================================================
local IsBreakingPallet = false

local function KYS_DestroyAllPallets()
    if not VD.KILLER_DestroyPallets or GetRole() ~= "Killer" then return end
    if IsBreakingPallet then return end

    local char = LocalPlayer.Character
    local root = Root
    if not char or not root then return end

    -- Check character attributes to prevent breaking while stunned, carrying, etc.
    local stunned = char:GetAttribute("IsStunned") or char:GetAttribute("isStunned")
    local immobile = char:GetAttribute("Immobile") or char:GetAttribute("immobile")
    local carrying = char:GetAttribute("IsCarrying") or char:GetAttribute("isCarrying")
    local pursuit = char:GetAttribute("Pursuit") or char:GetAttribute("pursuit")
    local ci = char:FindFirstChild("CheckInterractable")
    local action = ci and (ci:GetAttribute("action") or ci:GetAttribute("Action"))

    if stunned or immobile or carrying or pursuit or action then return end

    -- Find nearby pallet using the PalletPointSlide tag
    local CollectionService = game:GetService("CollectionService")
    local pts = CollectionService:GetTagged("PalletPointSlide")
    local nearest, minDist = nil, 6 -- 6 studs range
    for _, p in ipairs(pts) do
        if p:IsA("BasePart") and not CollectionService:HasTag(p, "doing action") then
            local d = (p.Position - root.Position).Magnitude
            if d < minDist then
                minDist = d
                nearest = p
            end
        end
    end

    if nearest then
        IsBreakingPallet = true
        task.spawn(function()
            pcall(function()
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local p = r and r:FindFirstChild("Pallet")
                local j = p and p:FindFirstChild("Jason")
                if j then
                    local dg = j:FindFirstChild("Destroy-Global")
                    local commit = j:FindFirstChild("PalletBreakCommit")
                    
                    if dg and dg:IsA("RemoteEvent") then
                        dg:FireServer(nearest)
                    end
                    if commit and commit:IsA("RemoteEvent") then
                        commit:FireServer(nearest)
                    end
                end
            end)

            -- Wait for breaking animation to finish (based on Immobile attribute)
            task.wait(0.2)
            local startTime = os.clock()
            while char and char.Parent and (char:GetAttribute("Immobile") or char:GetAttribute("immobile")) do
                if os.clock() - startTime > 3 then break end -- timeout safety
                task.wait(0.1)
            end
            IsBreakingPallet = false
        end)
    end
end

-- =====================================================
-- AUTO KICK GENERATOR (Killer)
-- =====================================================
getgenv().KYS_IsBreakingGenerator = false

function KYS_AutoBreakGene()
    if not VD.KILLER_AutoBreakGene or GetRole() ~= "Killer" then return end
    if getgenv().KYS_IsBreakingGenerator then return end

    local char = LocalPlayer.Character
    local root = Root
    if not char or not root then return end

    -- Check character attributes to prevent breaking while stunned, carrying, etc.
    local stunned = char:GetAttribute("IsStunned") or char:GetAttribute("isStunned")
    local immobile = char:GetAttribute("Immobile") or char:GetAttribute("immobile")
    local carrying = char:GetAttribute("IsCarrying") or char:GetAttribute("isCarrying")
    local pursuit = char:GetAttribute("Pursuit") or char:GetAttribute("pursuit")
    local ci = char:FindFirstChild("CheckInterractable")
    local action = ci and (ci:GetAttribute("action") or ci:GetAttribute("Action"))

    if stunned or immobile or carrying or pursuit or action then return end

    -- Find nearby generator using the GeneratorPoint tag
    local CollectionService = game:GetService("CollectionService")
    local pts = CollectionService:GetTagged("GeneratorPoint")
    local nearest, minDist = nil, 6 -- 6 studs range
    for _, p in ipairs(pts) do
        if p:IsA("BasePart") and not CollectionService:HasTag(p, "doing action") then
            -- Check if generator can be kicked (progress > 0, progress < 100, kickcount <= 7)
            local genModel = p.Parent
            if genModel then
                local progress = genModel:GetAttribute("RepairProgress") or genModel:GetAttribute("repairProgress") or 0
                local kickcount = genModel:GetAttribute("kickcount") or genModel:GetAttribute("KickCount") or 0
                if progress > 0 and progress < 100 and kickcount <= 7 then
                    local d = (p.Position - root.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        nearest = p
                    end
                end
            end
        end
    end

    if nearest then
        getgenv().KYS_IsBreakingGenerator = true
        task.spawn(function()
            pcall(function()
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local g = r and r:FindFirstChild("Generator")
                if g then
                    local event = g:FindFirstChild("BreakGenEvent")
                    local commit = g:FindFirstChild("BreakGenCommit")
                    
                    if event and event:IsA("RemoteEvent") then
                        event:FireServer(nearest)
                    end
                    if commit and commit:IsA("RemoteEvent") then
                        commit:FireServer(nearest)
                    end
                end
            end)

            -- Wait for breaking animation to finish (based on Immobile attribute)
            task.wait(0.2)
            local startTime = os.clock()
            while char and char.Parent and (char:GetAttribute("Immobile") or char:GetAttribute("immobile")) do
                if os.clock() - startTime > 3 then break end -- timeout safety
                task.wait(0.1)
            end
            task.wait(0.3)
            getgenv().KYS_IsBreakingGenerator = false
        end)
    end
end

-- =====================================================
-- BLOCK ALL VAULTS (Killer)
-- =====================================================
getgenv().KYS_LastVaultBlockTime = 0

function KYS_BlockAllVaults()
    if not VD.KILLER_BlockVaults or GetRole() ~= "Killer" then return end
    
    local now = tick()
    if now - getgenv().KYS_LastVaultBlockTime < 1.5 then return end
    getgenv().KYS_LastVaultBlockTime = now

    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local vaultEvent = remotes and remotes:FindFirstChild("Window") and remotes.Window:FindFirstChild("VaultEvent")
        if not vaultEvent then return end

        local map = workspace:FindFirstChild("Map")
        local vaultsFolder = map and map:FindFirstChild("Vaults")
        
        if vaultsFolder then
            for _, vault in ipairs(vaultsFolder:GetChildren()) do
                for _, part in ipairs(vault:GetChildren()) do
                    if part:IsA("BasePart") then
                        pcall(function() vaultEvent:FireServer(part, true) end)
                    end
                end
            end
        else
            -- Fallback using KYS_Cache.Windows if Map structure is not default
            for _, win in ipairs(KYS_Cache.Windows or {}) do
                local window = win.model
                if window and window.Parent then
                    for _, child in ipairs(window:GetDescendants()) do
                        if child:IsA("BasePart") then
                            pcall(function() vaultEvent:FireServer(child, true) end)
                        end
                    end
                end
            end
        end
    end)
end

-- =====================================================
-- AUTO DROP ALL PALLETS (Killer)
-- =====================================================
getgenv().KYS_LastPalletBlockTime = 0

function KYS_BlockAllPalletDrops()
    if not VD.KILLER_BlockPallets or GetRole() ~= "Killer" then return end

    local now = tick()
    if now - getgenv().KYS_LastPalletBlockTime < 2 then return end
    getgenv().KYS_LastPalletBlockTime = now

    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local palletFold = remotes and remotes:FindFirstChild("Pallet")
        local dropEvent = palletFold and palletFold:FindFirstChild("PalletDropEvent")
        if not dropEvent then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        -- Scan semua Palletwrong di Map
        for _, obj in ipairs(map:GetDescendants()) do
            if obj.Name == "Palletwrong" and (obj:IsA("Model") or obj:IsA("Folder")) then
                local target = obj:FindFirstChild("PalletPointSlide") or obj:FindFirstChild("PalletPoint")
                if target then
                    pcall(function() dropEvent:FireServer(target) end)
                end
            end
        end

        -- Fallback: gunakan KYS_Cache.Pallets
        for _, pal in ipairs(KYS_Cache.Pallets or {}) do
            local palModel = pal.model
            if palModel and palModel.Parent then
                local target = palModel:FindFirstChild("PalletPointSlide") or palModel:FindFirstChild("PalletPoint") or pal.part
                if target then
                    pcall(function() dropEvent:FireServer(target) end)
                end
            end
        end
    end)
end

-- =====================================================
-- BLOCK PALLET DROP (Killer) - Drop + TP Break semua pallet
-- =====================================================
getgenv().KYS_LastPalletBlockDropTime = 0
getgenv().KYS_IsBlockingPallets = false

-- Helper: force bersihkan semua attribute yang bisa bikin stuck
local function KYS_ForceUnstuck(char)
    pcall(function()
        char:SetAttribute("Immobile", nil)
        char:SetAttribute("immobile", nil)
        char:SetAttribute("IsStunned", nil)
        char:SetAttribute("isStunned", nil)
        char:SetAttribute("Pursuit", nil)
        char:SetAttribute("pursuit", nil)
    end)
    -- Pastikan WalkSpeed tidak nol
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed <= 0 then
            hum.WalkSpeed = 16
        end
    end)
end

function KYS_BlockPalletDrop()
    if not VD.KILLER_BlockPalletDrop or GetRole() ~= "Killer" then return end
    if getgenv().KYS_IsBlockingPallets then return end

    local now = tick()
    if now - getgenv().KYS_LastPalletBlockDropTime < 4 then return end
    getgenv().KYS_LastPalletBlockDropTime = now

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Skip jika sedang stunned/carrying
    local stunned = char:GetAttribute("IsStunned") or char:GetAttribute("isStunned")
    local immobile = char:GetAttribute("Immobile") or char:GetAttribute("immobile")
    local carrying = char:GetAttribute("IsCarrying") or char:GetAttribute("isCarrying")
    if stunned or immobile or carrying then return end

    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local palletFold = remotes and remotes:FindFirstChild("Pallet")
        local dropEvent = palletFold and palletFold:FindFirstChild("PalletDropEvent")
        local jasonFold = palletFold and palletFold:FindFirstChild("Jason")
        local destroyGlobal = jasonFold and jasonFold:FindFirstChild("Destroy-Global")
        local breakCommit = jasonFold and jasonFold:FindFirstChild("PalletBreakCommit")
        local destroySingle = jasonFold and jasonFold:FindFirstChild("Destroy")
        if not dropEvent or not destroyGlobal or not breakCommit then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        -- Helper: kumpulkan semua target pallet yang masih ada
        local function collectTargets()
            local targets = {}
            local seen = {}
            for _, obj in ipairs(map:GetDescendants()) do
                if obj.Name == "Palletwrong" and (obj:IsA("Model") or obj:IsA("Folder")) then
                    local target = obj:FindFirstChild("PalletPointSlide") or obj:FindFirstChild("PalletPoint")
                    if target and target:IsA("BasePart") and not seen[target] then
                        table.insert(targets, target)
                        seen[target] = true
                    end
                end
            end
            for _, pal in ipairs(KYS_Cache.Pallets or {}) do
                local palModel = pal.model
                if palModel and palModel.Parent then
                    local target = palModel:FindFirstChild("PalletPointSlide") or palModel:FindFirstChild("PalletPoint") or pal.part
                    if target and target:IsA("BasePart") and not seen[target] then
                        table.insert(targets, target)
                        seen[target] = true
                    end
                end
            end
            return targets
        end

        local targets = collectTargets()
        if #targets == 0 then return end

        getgenv().KYS_IsBlockingPallets = true

        -- Simpan WalkSpeed awal
        local hum = char:FindFirstChildOfClass("Humanoid")
        local origWalkSpeed = hum and hum.WalkSpeed or 16

        task.spawn(function()
            pcall(function()
                local originalCF = root.CFrame

                -- Helper: proses satu pallet (drop → teleport → break)
                local function processPallet(target)
                    if not target or not target.Parent then return end
                    pcall(function()
                        -- Drop pallet dulu
                        dropEvent:FireServer(target)
                        task.wait(0.12)

                        -- Teleport ke pallet
                        root.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.15)

                        -- Hancurkan pallet - kirim semua remote
                        destroyGlobal:FireServer(target)
                        breakCommit:FireServer(target)
                        if destroySingle then
                            destroySingle:FireServer(target)
                        end

                        task.wait(0.12)

                        -- Force unstuck
                        KYS_ForceUnstuck(char)
                    end)
                end

                -- Pass 1: proses semua pallet
                for _, target in ipairs(targets) do
                    processPallet(target)
                end

                -- Teleport balik dulu
                task.wait(0.1)
                pcall(function() root.CFrame = originalCF end)
                KYS_ForceUnstuck(char)

                -- Pass 2: cek pallet yang masih tersisa, proses lagi
                task.wait(0.5)
                local remaining = collectTargets()
                if #remaining > 0 then
                    originalCF = root.CFrame
                    for _, target in ipairs(remaining) do
                        processPallet(target)
                    end
                    task.wait(0.1)
                    pcall(function() root.CFrame = originalCF end)
                end

                -- Final unstuck + restore
                task.wait(0.1)
                KYS_ForceUnstuck(char)
                if hum then
                    pcall(function() hum.WalkSpeed = origWalkSpeed end)
                end
            end)

            -- Safety net: loop unstuck selama 1 detik
            task.spawn(function()
                for i = 1, 10 do
                    task.wait(0.1)
                    if char and char.Parent then
                        KYS_ForceUnstuck(char)
                        if hum and hum.WalkSpeed <= 0 then
                            pcall(function() hum.WalkSpeed = origWalkSpeed end)
                        end
                    end
                end
            end)

            getgenv().KYS_IsBlockingPallets = false
        end)
    end)
end

-- =====================================================
-- BYPASS COOLDOWN (Abyss) (Killer)
-- =====================================================
getgenv().KYS_AbyssCooldownBypassConnection = nil
getgenv().KYS_CorruptHandlerFunc = nil

function KYS_StartAbyssCooldownBypass()
    if not getgenv().KYS_CorruptHandlerFunc then
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and islclosure(v) then
                local constants = debug.getconstants(v)
                if table.find(constants, "corrupt") and table.find(constants, "Immobile") then
                    getgenv().KYS_CorruptHandlerFunc = v
                    break
                end
            end
        end
    end

    if not getgenv().KYS_CorruptHandlerFunc then
        return
    end
    
    if getgenv().KYS_AbyssCooldownBypassConnection then 
        getgenv().KYS_AbyssCooldownBypassConnection:Disconnect() 
    end
    
    getgenv().KYS_AbyssCooldownBypassConnection = RunService.Heartbeat:Connect(function()
        if not VD.KILLER_BypassCooldown then return end
        if getgenv().KYS_CorruptHandlerFunc then
            local upvalues = debug.getupvalues(getgenv().KYS_CorruptHandlerFunc)
            for idx, val in pairs(upvalues) do
                if type(val) == "boolean" then
                    if val == false then
                        debug.setupvalue(getgenv().KYS_CorruptHandlerFunc, idx, true)
                    end
                end
            end
        end
    end)
end

function KYS_StopAbyssCooldownBypass()
    if getgenv().KYS_AbyssCooldownBypassConnection then
        getgenv().KYS_AbyssCooldownBypassConnection:Disconnect()
        getgenv().KYS_AbyssCooldownBypassConnection = nil
    end
end

-- =====================================================
-- BYPASS COOLDOWN (Jeff / The Killer)
-- =====================================================
getgenv().KYS_JeffCooldownBypassThread = nil

function KYS_StartJeffCooldownBypass()
    if getgenv().KYS_JeffCooldownBypassThread then return end
    getgenv().KYS_JeffCooldownBypassThread = task.spawn(function()
        -- NOTE: jangan pernah SetAttribute("Frenzy", true) -> itu bikin ultimate
        -- langsung kepake tanpa pencet tombol skill.
        -- Sama seperti Hidden: cuma reset cooldown/anti-spam, aktivasi tetap manual.
        local frenzyFunc

        local function scanGC()
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "function" and islclosure(v) then
                        local ok, consts = pcall(debug.getconstants, v)
                        if ok and consts then
                            local hasFrenzy, hasCooldown = false, false
                            for _, c in pairs(consts) do
                                if c == "Frenzy" then hasFrenzy = true end
                                if c == "Cooldown" or c == "cooldown" or c == "TweenInfo" or c == "action" then hasCooldown = true end
                            end
                            if hasFrenzy and hasCooldown then
                                frenzyFunc = v
                                break
                            end
                        end
                    end
                end
            end)
        end

        scanGC()
        local lastScan = os.clock()

        while task.wait(0.1) do
            if not VD.KILLER_InfFrenzy then break end

            if not frenzyFunc and os.clock() - lastScan >= 2 then
                lastScan = os.clock()
                scanGC()
            end

            if frenzyFunc then
                pcall(function()
                    for i, val in pairs(debug.getupvalues(frenzyFunc)) do
                        if type(val) == "boolean" and val == true then
                            debug.setupvalue(frenzyFunc, i, false)
                        end
                    end
                end)
            end
        end

        getgenv().KYS_JeffCooldownBypassThread = nil
    end)
end

function KYS_StopJeffCooldownBypass()
    -- Loop berhenti sendiri saat VD.KILLER_InfFrenzy = false.
    -- Tidak menyentuh attribute/remote apa pun supaya skill tidak ikut ke-trigger.
end

getgenv().KYS_SlasherCooldownBypassThread = nil

function KYS_StartSlasherCooldownBypass()
    if getgenv().KYS_SlasherCooldownBypassThread then return end
    
    -- BOOLEAN ARITHMETIC FAILSAFE FOR AWARDLOG
    pcall(function()
        local b = true
        local mt = debug.getmetatable(b)
        if not mt then
            mt = {}
            debug.setmetatable(b, mt)
        end
        if setreadonly then setreadonly(mt, false) end
        mt.__div = function() return 0 end
        mt.__mul = function() return 0 end
        mt.__add = function() return 0 end
        mt.__sub = function() return 0 end
        if setreadonly then setreadonly(mt, true) end
    end)
    
    getgenv().KYS_SlasherCooldownBypassThread = task.spawn(function()
        local toggleFunc = nil
        local pursuitHandler = nil
        
        local function scanGCForSlasher()
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "function" and islclosure(v) then
                        local consts = debug.getconstants(v)
                        local hasOffset, hasLinear, hasAction, hasTweenInfo = false, false, false, false
                        local hasPursuit, hasWalkSpeed = false, false
                        
                        for _, c in pairs(consts) do
                            if c == "Offset" then hasOffset = true end
                            if c == "Linear" then hasLinear = true end
                            if c == "action" then hasAction = true end
                            if c == "TweenInfo" then hasTweenInfo = true end
                            if c == "Pursuit" then hasPursuit = true end
                            if c == "WalkSpeed" then hasWalkSpeed = true end
                        end
                        
                        if hasOffset and hasLinear and hasAction and hasTweenInfo and not hasPursuit then
                            toggleFunc = v
                        end
                        
                        if hasPursuit and hasTweenInfo and hasAction and hasWalkSpeed then
                            pursuitHandler = v
                        end
                    end
                    if toggleFunc and pursuitHandler then break end
                end
            end)
        end

        scanGCForSlasher()
        local lastScan = os.clock()
        local wasLakeMistActive = false
        local wasPursuitActive = false
        
        while task.wait(0.1) do
            if not VD.KILLER_InfLakeMist and not VD.KILLER_InfPursuit then
                break
            end
            
            if not (toggleFunc and pursuitHandler) then
                if os.clock() - lastScan >= 2 then
                    scanGCForSlasher()
                    lastScan = os.clock()
                end
            end
            
            -- Sama seperti Hidden: cuma reset flag cooldown/anti-spam (boolean true -> false).
            -- Tidak ada FireServer / aktivasi paksa, jadi skill baru jalan kalau tombol dipencet.
            if toggleFunc and VD.KILLER_InfLakeMist then
                pcall(function()
                    for i, val in pairs(debug.getupvalues(toggleFunc)) do
                        if type(val) == "boolean" and val == true then
                            debug.setupvalue(toggleFunc, i, false)
                        end
                    end
                end)
            end

            if pursuitHandler and VD.KILLER_InfPursuit then
                pcall(function()
                    for i, val in pairs(debug.getupvalues(pursuitHandler)) do
                        if type(val) == "boolean" and val == true then
                            debug.setupvalue(pursuitHandler, i, false)
                        end
                    end
                end)
            end
        end
        
        getgenv().KYS_SlasherCooldownBypassThread = nil
    end)
end

function KYS_StopSlasherCooldownBypass()
    -- Loop berhenti sendiri saat kedua toggle mati.
    -- Tidak fire remote apa pun supaya skill tidak ke-trigger sendiri.
end

-- ==============================================
-- KILLER FAKE ATTACK (COUNTER AUTO PARRY)
-- ==============================================
getgenv().KYS_FakeAttackThread = nil
function KYS_ToggleFakeAttack(enabled)
    if not enabled then
        if getgenv().KYS_FakeAttackThread then
            task.cancel(getgenv().KYS_FakeAttackThread)
            getgenv().KYS_FakeAttackThread = nil
        end
        return
    end
    
    if getgenv().KYS_FakeAttackThread then return end
    
    getgenv().KYS_FakeAttackThread = task.spawn(function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        while VD.KILLER_FakeAttack do
            local char = LocalPlayer.Character
            if char then
                local Animator = char:FindFirstChild("Humanoid") and char.Humanoid:FindFirstChild("Animator")
                if Animator then
                    local myRoot = char:FindFirstChild("HumanoidRootPart")
                    local near = false
                    if myRoot then
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" then
                                local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                                if r and (myRoot.Position - r.Position).Magnitude <= 15 then
                                    near = true
                                    break
                                end
                            end
                        end
                    end
                    
                    if near then
                        pcall(function()
                            local bait = Instance.new("Animation")
                            bait.AnimationId = "rbxassetid://117042998468241"
                            local track = Animator:LoadAnimation(bait)
                            track:Play()
                            track:AdjustWeight(0) -- event AnimationPlayed terpancar, killer tetap diam
                            task.wait(0.05)
                            track:Stop()
                        end)
                    end
                end
            end
            task.wait(0.3)
        end
        getgenv().KYS_FakeAttackThread = nil
    end)
end


getgenv().KYS_CureFlaskLaserThread = nil
getgenv().KYS_CureFlaskLaserPart = nil

function KYS_UpdateCureFlaskLaser()
    local char = game:GetService("Players").LocalPlayer.Character
    if not char then return end
    
    local targetPos = nil
    local originPos = nil

    local closest = nil
    local minDst = math.huge
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        originPos = hand and hand.Position or hrp.Position
        
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if not v.Character:GetAttribute("IsKiller") then
                    local dst = (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dst < minDst then
                        minDst = dst
                        closest = v
                    end
                end
            end
        end
    end
    
    if closest then
        targetPos = closest.Character.HumanoidRootPart.Position
    end
    
    -- Check if we have action attribute true (which means charging/holding flask)
    local actionActive = false
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("LocalScript") and child:GetAttribute("action") == true then
            actionActive = true
            break
        end
    end

    if originPos and targetPos and actionActive then
        if not getgenv().KYS_CureFlaskLaserPart then
            local laser = Instance.new("Part")
            laser.Name = "FlaskSilentAimLaser"
            laser.Anchored = true
            laser.CanCollide = false
            laser.CanTouch = false
            laser.CastShadow = false
            laser.Material = Enum.Material.Neon
            laser.Color = Color3.fromRGB(0, 100, 255)
            laser.Transparency = 0
            laser.Parent = workspace
            getgenv().KYS_CureFlaskLaserPart = laser
        end
        
        local dist = (targetPos - originPos).Magnitude
        if dist > 0.1 then
            local laser = getgenv().KYS_CureFlaskLaserPart
            laser.Size = Vector3.new(0.16, 0.16, dist)
            laser.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
            laser.Transparency = 0
        end
    else
        if getgenv().KYS_CureFlaskLaserPart then
            getgenv().KYS_CureFlaskLaserPart.Transparency = 1
        end
    end
end

function KYS_StartCureFlaskLaser()
    if getgenv().KYS_CureFlaskLaserThread then return end
    getgenv().KYS_CureFlaskLaserThread = game:GetService("RunService").RenderStepped:Connect(function()
        if not VD.KILLER_FlaskLaser then
            if getgenv().KYS_CureFlaskLaserPart then
                pcall(function() getgenv().KYS_CureFlaskLaserPart:Destroy() end)
                getgenv().KYS_CureFlaskLaserPart = nil
            end
            if getgenv().KYS_CureFlaskLaserThread then
                getgenv().KYS_CureFlaskLaserThread:Disconnect()
                getgenv().KYS_CureFlaskLaserThread = nil
            end
            return
        end
        pcall(KYS_UpdateCureFlaskLaser)
    end)
end

-- =====================================================
-- BYPASS COOLDOWN (Hidden)
-- =====================================================
getgenv().KYS_HiddenLeapBypassThread = nil

function KYS_StartHiddenCooldownBypass()
    if getgenv().KYS_HiddenLeapBypassThread then return end
    getgenv().KYS_HiddenLeapBypassThread = task.spawn(function()
        local leapFunction, m2Function, toggleFunc, pursuitFunc
        
        local function scanGC()
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "function" and islclosure(v) then
                        local info
                        pcall(function() info = debug.getinfo(v) end)
                        if info then
                            if info.name == "tryActivate" then
                                leapFunction = v
                            elseif info.name == "playM2Animation" then
                                m2Function = v
                            end
                        end
                    end
                    if leapFunction and m2Function then break end
                end
            end)
        end

        scanGC()

        local lastScan = os.clock()
        while task.wait(0.1) do
            if not VD.KILLER_BypassLeap then
                break
            end
            
            -- If functions are not found, retry scanning every 2 seconds
            if not (leapFunction and m2Function) then
                local now = os.clock()
                if now - lastScan >= 2 then
                    lastScan = now
                    scanGC()
                end
            end
            
            -- Bypass cooldown by setting boolean upvalues from true to false
            if leapFunction then
                pcall(function()
                    for i, val in pairs(debug.getupvalues(leapFunction)) do
                        if type(val) == "boolean" and val == true then
                            debug.setupvalue(leapFunction, i, false)
                        end
                    end
                end)
            end
            if m2Function then
                pcall(function()
                    for i, val in pairs(debug.getupvalues(m2Function)) do
                        if type(val) == "boolean" and val == true then
                            debug.setupvalue(m2Function, i, false)
                        end
                    end
                end)
            end
        end
        getgenv().KYS_HiddenLeapBypassThread = nil
    end)
end

function KYS_StopHiddenCooldownBypass()
    -- Loop terminates automatically when VD.KILLER_BypassLeap is false
end



-- =====================================================
-- FLING
-- =====================================================
function KYS_FlingNearest()
    if not VD.FLING_Enabled then return end
    local root = Root
    if not root then return end
    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local dist = (tr.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist; closest = player
                end
            end
        end
    end
    if closest and closest.Character then
        local tr = closest.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local originalPos = root.CFrame
            for _ = 1, 10 do
                root.CFrame      = tr.CFrame
                root.Velocity    = Vector3.new(VD.FLING_Strength, VD.FLING_Strength / 2, VD.FLING_Strength)
                root.RotVelocity = Vector3.new(9999, 9999, 9999)
                task.wait()
            end
            root.CFrame      = originalPos
            root.Velocity    = Vector3.zero
            root.RotVelocity = Vector3.zero
        end
    end
end

function KYS_FlingAll()
    if not VD.FLING_Enabled then return end
    local root = Root
    if not root then return end
    local originalPos = root.CFrame
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                for _ = 1, 5 do
                    root.CFrame      = tr.CFrame
                    root.Velocity    = Vector3.new(VD.FLING_Strength, VD.FLING_Strength / 2, VD.FLING_Strength)
                    root.RotVelocity = Vector3.new(9999, 9999, 9999)
                    task.wait()
                end
            end
        end
    end
    root.CFrame      = originalPos
    root.Velocity    = Vector3.zero
    root.RotVelocity = Vector3.zero
end


-- =====================================================
-- BEAT GAME SURVIVOR (teleport to exit)
-- =====================================================
local function KYS_BeatGameSurvivor()
    if not VD.BEAT_Survivor or GetRole() ~= "Survivor" then return end
    local root = Root
    if not root then return end
    local map = Workspace:FindFirstChild("Map")

    local exitPos = nil
    local finishPart = nil
    
    -- Cara 1: Scan finishline dari seluruh workspace descendants (Seperti di fallens.lua)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            local nameLower = string.lower(obj.Name)
            if (nameLower == "fininshline" or nameLower == "finishline") and obj:IsA("BasePart") then
                finishPart = obj
                exitPos = obj.Position
                break
            end
        end
    end)

    -- Cara 2: Fallback ke pengecekan spesifik map
    if not exitPos and map then
        pcall(function()
            if map:FindFirstChild("RooftopHitbox") or map:FindFirstChild("Rooftop") then
                finishPart = map:FindFirstChild("RooftopHitbox") or map:FindFirstChild("Rooftop")
                if finishPart:IsA("Model") then finishPart = finishPart.PrimaryPart or finishPart:FindFirstChildWhichIsA("BasePart") end
                if finishPart then exitPos = finishPart.Position else exitPos = Vector3.new(3098.16, 454.04, -4918.74) end
                return
            end
            if map:FindFirstChild("HooksMeat") then
                finishPart = map:FindFirstChild("HooksMeat")
                if finishPart:IsA("Model") then finishPart = finishPart.PrimaryPart or finishPart:FindFirstChildWhichIsA("BasePart") end
                if finishPart then exitPos = finishPart.Position else exitPos = Vector3.new(1546.12, 152.21, -796.72) end
                return
            end
            if KYS_Cache and KYS_Cache.ExitPos then
                exitPos = KYS_Cache.ExitPos
                finishPart = KYS_Cache.ExitPart
                return
            end
        end)
    end

    if not exitPos then return end
    VD._LastFinishPos    = VD._LastFinishPos or nil
    VD._BeatSurvivorDone = VD._BeatSurvivorDone or false
    if VD._BeatSurvivorDone then return end

    VD._BeatSurvivorDone = true
    VD._LastFinishPos    = exitPos

    task.spawn(function()
        task.delay(4, function()
            if VD._BeatSurvivorDone then VD._BeatSurvivorDone = false end
        end)

        for i = 1, 10 do
            if not Root or not Root.Parent then break end

            pcall(function()
                local event = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Game"):FindFirstChild("PlayerActionEvent")
                if event then
                    if event:IsA("RemoteEvent") then
                        event:FireServer("ESCAPED", 200)
                    elseif event:IsA("BindableEvent") then
                        event:Fire("ESCAPED", 200)
                    end
                end
            end)

            if firetouchinterest and finishPart then
                pcall(function() firetouchinterest(Root, finishPart, 0) end)
                pcall(function() firetouchinterest(Root, finishPart, 1) end)
            end

            if i == 1 then
                Root.Velocity = Vector3.zero
                if exitPos then
                    Root.CFrame = CFrame.new(exitPos + Vector3.new(0, 3, 0))
                end
            end

            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:MoveTo(exitPos) --
                end
            end)

            task.wait(0.2)
        end
    end)
end

-- =====================================================
-- BEAT GAME KILLER (auto chase & attack survivors)
-- =====================================================
local function KYS_BeatGameKiller()
    if not VD.BEAT_Killer then
        VD._KillerTarget = nil; return
    end
    if GetRole() ~= "Killer" then
        VD._KillerTarget = nil; return
    end
    local root = Root
    if not root then return end

    local target        = VD._KillerTarget
    local needNewTarget = true
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        local th = target.Character:FindFirstChildOfClass("Humanoid")
        if tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25 then
            needNewTarget = false
        else
            VD._KillerTarget = nil
        end
    end

    if needNewTarget then
        local survivors = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
                local pr = player.Character:FindFirstChild("HumanoidRootPart")
                local ph = player.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and ph.MaxHealth > 0 and (ph.Health / ph.MaxHealth) > 0.25 then table.insert(survivors, player) end
            end
        end
        if #survivors > 0 then
            local closest, closestDist = nil, math.huge
            for _, player in ipairs(survivors) do
                local pr   = player.Character:FindFirstChild("HumanoidRootPart")
                local dist = (pr.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist; closest = player
                end
            end
            VD._KillerTarget = closest
            target           = closest
        else
            VD._KillerTarget = nil; return
        end
    end

    if not target or not target.Character then return end
    local tr = target.Character:FindFirstChild("HumanoidRootPart")
    local th = target.Character:FindFirstChildOfClass("Humanoid")
    if not tr or not th then
        VD._KillerTarget = nil; return
    end
    if th.MaxHealth <= 0 or (th.Health / th.MaxHealth) <= 0.25 then
        VD._KillerTarget = nil; return
    end

    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then pcall(function() part.CanCollide = false end) end
    end

    local dir = (root.Position - tr.Position).Unit
    if dir.Magnitude ~= dir.Magnitude then dir = Vector3.new(1, 0, 0) end
    root.CFrame = CFrame.new(tr.Position + dir * 3 + Vector3.new(0, 1, 0), tr.Position)

    pcall(function()
        local r  = ReplicatedStorage:FindFirstChild("Remotes")
        local a  = r and r:FindFirstChild("Attacks")
        local ba = a and a:FindFirstChild("BasicAttack")
        if ba then ba:FireServer(false) end
    end)
end

-- =====================================================
-- AUTO HOOK (Killer)
-- =====================================================
local IsAutoHooking = false

local function KYS_AutoHook()
    if not VD.KILLER_AutoHook or GetRole() ~= "Killer" then return end
    if IsAutoHooking then return end

    local root = Root
    if not root then return end

    -- Check if we are already carrying a survivor
    local char = LocalPlayer.Character
    local isCarrying = false
    if char then
        isCarrying = char:GetAttribute("IsCarrying") or char:GetAttribute("isCarrying")
    end

    -- If we are already carrying, we bypass pickup and look straight for a hook
    if isCarrying then
        -- Find occupied hooks
        local occupiedPositions = {}
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local isHooked = v.Character:GetAttribute("IsHooked") or v.Character:GetAttribute("isHooked")
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if isHooked and hrp then
                    table.insert(occupiedPositions, hrp.Position)
                end
            end
        end

        -- Find nearest empty hook to our current position
        local closestHook, hDist = nil, math.huge
        for _, h in ipairs(KYS_Cache.Hooks or {}) do
            if h.part then
                local isOccupied = false
                for _, occPos in ipairs(occupiedPositions) do
                    if (h.part.Position - occPos).Magnitude < 10 then
                        isOccupied = true
                        break
                    end
                end
                if not isOccupied then
                    local hd = (h.part.Position - root.Position).Magnitude
                    if hd < hDist then
                        hDist = hd; closestHook = h
                    end
                end
            end
        end

        if closestHook then
            IsAutoHooking = true
            task.spawn(function()
                -- Teleport to Hook
                root.CFrame = CFrame.new(closestHook.part.Position + Vector3.new(0, 3, 0))
                task.wait(0.4)

                -- Fire Hook Event and Hook Commit
                pcall(function()
                    local carryFolder = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Carry")
                    local event = carryFolder and carryFolder:FindFirstChild("HookEvent")
                    local commit = carryFolder and carryFolder:FindFirstChild("HookCommit")
                    
                    local hookPoint = nil
                    if closestHook.model then
                        hookPoint = closestHook.model:FindFirstChild("HookPoint") or closestHook.model:FindFirstChild("HookHitbox")
                    end
                    if not hookPoint then hookPoint = closestHook.part end

                    if event and event:IsA("RemoteEvent") then
                        event:FireServer(hookPoint)
                    end
                    if commit and commit:IsA("RemoteEvent") then
                        commit:FireServer(hookPoint)
                    end
                end)
                task.wait(0.5)
                IsAutoHooking = false
            end)
        end
        return
    end

    -- If not carrying, find the closest downed survivor
    local closestDowned, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tr  = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum then
                local pct = (hum.MaxHealth > 0) and (hum.Health / hum.MaxHealth) or 0
                if pct <= 0.25 and pct > 0 then
                    local isHooked = false
                    if KYS_Cache and KYS_Cache.Hooks then
                        for _, hh in ipairs(KYS_Cache.Hooks) do
                            if hh.part and (hh.part.Position - tr.Position).Magnitude < 4.5 then
                                isHooked = true; break
                            end
                        end
                    end

                    if not isHooked then
                        local dist = (tr.Position - root.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist; closestDowned = tr
                        end
                    end
                end
            end
        end
    end

    if closestDowned then
        -- Find occupied hooks
        local occupiedPositions = {}
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local isHooked = v.Character:GetAttribute("IsHooked") or v.Character:GetAttribute("isHooked")
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if isHooked and hrp then
                    table.insert(occupiedPositions, hrp.Position)
                end
            end
        end

        -- Find nearest empty hook to the downed survivor
        local closestHook, hDist = nil, math.huge
        for _, h in ipairs(KYS_Cache.Hooks or {}) do
            if h.part then
                local isOccupied = false
                for _, occPos in ipairs(occupiedPositions) do
                    if (h.part.Position - occPos).Magnitude < 10 then
                        isOccupied = true
                        break
                    end
                end
                if not isOccupied then
                    local hd = (h.part.Position - closestDowned.Position).Magnitude
                    if hd < hDist then
                        hDist = hd; closestHook = h
                    end
                end
            end
        end

        if closestHook then
            IsAutoHooking = true
            task.spawn(function()
                -- Teleport to downed survivor
                root.CFrame = CFrame.new(closestDowned.Position + Vector3.new(0, 3, 0), closestDowned.Position)
                task.wait(0.3)

                -- Perform Carry via RemoteEvent directly!
                pcall(function()
                    local carryFolder = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Carry")
                    local carryEvent = carryFolder and carryFolder:FindFirstChild("CarrySurvivorEvent")
                    if carryEvent and carryEvent:IsA("RemoteEvent") then
                        carryEvent:FireServer(closestDowned.Parent)
                    end
                end)

                -- Wait for pickup to complete/register
                task.wait(0.8)

                -- Verify if we successfully picked them up
                local currentCarrying = false
                local myChar = LocalPlayer.Character
                if myChar then
                    currentCarrying = myChar:GetAttribute("IsCarrying") or myChar:GetAttribute("isCarrying")
                end

                -- If successfully carrying, teleport to hook
                if currentCarrying and root and root.Parent then
                    -- Teleport to Hook
                    root.CFrame = CFrame.new(closestHook.part.Position + Vector3.new(0, 3, 0))
                    task.wait(0.4)

                    -- Fire Hook Event and Hook Commit
                    pcall(function()
                        local carryFolder = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Carry")
                        local event = carryFolder and carryFolder:FindFirstChild("HookEvent")
                        local commit = carryFolder and carryFolder:FindFirstChild("HookCommit")
                        
                        local hookPoint = nil
                        if closestHook.model then
                            hookPoint = closestHook.model:FindFirstChild("HookPoint") or closestHook.model:FindFirstChild("HookHitbox")
                        end
                        if not hookPoint then hookPoint = closestHook.part end

                        if event and event:IsA("RemoteEvent") then
                            event:FireServer(hookPoint)
                        end
                        if commit and commit:IsA("RemoteEvent") then
                            commit:FireServer(hookPoint)
                        end
                    end)
                end

                task.wait(1)
                IsAutoHooking = false
            end)
        end
    end
end

-- =====================================================
-- MAP SCAN LOOP & MAIN AUTO LOOP
-- =====================================================
task.spawn(function()
    while not VD.Destroyed do
        if Root and KYS_Cache.Hooks and #KYS_Cache.Hooks > 0 then
            local closest, closestDist = nil, math.huge
            for _, hook in ipairs(KYS_Cache.Hooks) do
                if hook.part then
                    local d = (hook.part.Position - Root.Position).Magnitude
                    if d < closestDist then
                        closestDist = d; closest = hook
                    end
                end
            end
            KYS_Cache.ClosestHook = closest
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while not VD.Destroyed do
        pcall(KYS_AutoAttack)
        pcall(KYS_UpdateHitboxes)
        pcall(KYS_DestroyAllPallets)
        pcall(KYS_AutoBreakGene)
        pcall(KYS_BlockAllVaults)
        pcall(KYS_BlockAllPalletDrops)
        pcall(KYS_BlockPalletDrop)

        pcall(KYS_BeatGameSurvivor)
        pcall(KYS_BeatGameKiller)
        pcall(KYS_AutoHook)
        task.wait(0.12)
    end
end)
end -- end Auto Features scope



-- =====================================================
-- AIMBOT (Camera-based) + Spear Aimbot
-- =====================================================
local Aimbot = {}
local State  = { AimTarget = nil, AimHolding = false }

function Aimbot.GetClosestTarget(cam)
    if not cam then return nil end
    if GetRole() ~= "Survivor" then return nil end

    local root = Root
    if not root then return nil end

    local closestPlayer = nil
    local closestDist   = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsKiller(player) and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local dist = (tr.Position - root.Position).Magnitude

                local passVis = true
                if VD.AIM_VisCheck then
                    local camPos = cam.CFrame.Position
                    local params = RaycastParams.new()
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    params.FilterDescendantsInstances = { cam, LocalPlayer.Character, player.Character }
                    local ray = workspace:Raycast(camPos, tr.Position - camPos, params)
                    passVis = (ray == nil)
                end

                if passVis and dist < closestDist then
                    closestDist = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

function Aimbot.GetPredictedPosition(target, targetPart)
    if not target or not targetPart then return nil end
    local pos = targetPart.Position
    if VD.AIM_Predict then
        local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if root then pos = pos + root.AssemblyLinearVelocity * 0.1 end
    end
    return pos
end

function Aimbot.AimAt(cam, targetPos)
    if not cam or not targetPos then return end
    local cur    = cam.CFrame
    local smooth = VD.AIM_Smooth or 0.3
    cam.CFrame   = cur:Lerp(CFrame.new(cur.Position, targetPos), smooth)
end

function Aimbot.Update(cam, screenSize, screenCenter)
    if not VD.AIM_Enabled or GetRole() ~= "Survivor" then
        State.AimTarget = nil; return
    end
    if VD.AIM_UseRMB and not State.AimHolding then
        State.AimTarget = nil; return
    end
    local target = Aimbot.GetClosestTarget(cam)
    State.AimTarget = target
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local pred = Aimbot.GetPredictedPosition(target, tr)
            if pred then Aimbot.AimAt(cam, pred) end
        end
    end
end

-- Spear Aimbot (gravity compensation)
function SpearAimbotCalc(targetPos)
    if not VD.SPEAR_Aimbot or GetRole() ~= "Killer" then return nil end
    local root = Root
    if not root then return nil end
    local startPos = root.Position + Vector3.new(0, 2, 0)
    local distance = (targetPos - startPos).Magnitude
    local gravity  = VD.SPEAR_Gravity or 50
    local speed    = VD.SPEAR_Speed or 100
    local time     = distance / speed
    local drop     = 0.5 * gravity * time * time
    return targetPos + Vector3.new(0, drop, 0)
end

-- =====================================================
-- SPEAR AIMBOT: Manual Target List + Cycle (Panah GUI)
-- =====================================================
function GetSpearTargetList()
    local root = Root
    local list = {}
    if not root then return list end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            local th = player.Character:FindFirstChildOfClass("Humanoid")
            if tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25 then
                local dist = (tr.Position - root.Position).Magnitude
                table.insert(list, { Player = player, Dist = dist })
            end
        end
    end
    table.sort(list, function(a, b) return a.Dist < b.Dist end)
    local players = {}
    for _, v in ipairs(list) do table.insert(players, v.Player) end
    return players
end

function CycleSpearTarget(direction)
    local list = GetSpearTargetList()
    if #list == 0 then
        SpearBtnData.ManualTarget = nil
        SpearBtnData.TargetIndex = 0
        pcall(VD_Notify, "Spear Aimbot", "Tidak ada target survivor.", 2)
        return
    end

    -- Cari index target saat ini di list terbaru (posisi survivor berubah tiap saat)
    local curIdx = nil
    if SpearBtnData.ManualTarget then
        for i, p in ipairs(list) do
            if p == SpearBtnData.ManualTarget then curIdx = i; break end
        end
    end

    local nextIdx
    if curIdx then
        nextIdx = curIdx + direction
        if nextIdx > #list then nextIdx = 1 end
        if nextIdx < 1 then nextIdx = #list end
    else
        nextIdx = 1
    end

    SpearBtnData.TargetIndex  = nextIdx
    SpearBtnData.ManualTarget = list[nextIdx]

    pcall(VD_Notify, "Spear Aimbot", "Target: " .. SpearBtnData.ManualTarget.Name, 2)
    pcall(UpdateSpearTargetLabel)
end

function UpdateSpearTargetLabel()
    if not (SpearBtnData and SpearBtnData.TargetLabel) then return end
    if SpearBtnData.ManualTarget and SpearBtnData.ManualTarget.Parent then
        SpearBtnData.TargetLabel.Text = SpearBtnData.ManualTarget.Name
        SpearBtnData.TargetLabel.Visible = true
    else
        SpearBtnData.TargetLabel.Text = "AUTO"
        SpearBtnData.TargetLabel.Visible = true
    end
end

function UpdateSpearAim()
    if not VD.SPEAR_Aimbot or (SpearBtnData and not SpearBtnData.Active) or GetRole() ~= "Killer" then return end
    local root = Root
    if not root then return end

    local target = nil

    -- Pakai target manual kalau masih valid (masih di server, karakter ada, hidup, HP > 25%)
    if SpearBtnData.ManualTarget then
        local p = SpearBtnData.ManualTarget
        local valid = p.Parent and IsSurvivor(p) and p.Character
        if valid then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local th = p.Character:FindFirstChildOfClass("Humanoid")
            valid = tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25
        end
        if valid then
            target = p
        else
            -- Target manual sudah tidak valid (mati/keluar) -> balik ke auto
            SpearBtnData.ManualTarget = nil
            pcall(UpdateSpearTargetLabel)
        end
    end

    -- Fallback: auto pilih target terdekat
    if not target then
        local closest, closestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
                local tr = player.Character:FindFirstChild("HumanoidRootPart")
                local th = player.Character:FindFirstChildOfClass("Humanoid")
                if tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25 then
                    local dist = (tr.Position - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist; closest = player
                    end
                end
            end
        end
        target = closest
    end

    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local aimPos = SpearAimbotCalc(tr.Position)
            if aimPos then
                local cam = workspace.CurrentCamera
                if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos) end
            end
        end
    end
end

-- Helper: check if touch is on Gui-mob shoot button (mobile)
local function KYS_IsTouchOnAttackButton(input)
    local pos = input.Position
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    local survMob = playerGui:FindFirstChild("Survivor-mob")
    if not survMob then return false end
    local controls = survMob:FindFirstChild("Controls")
    if not controls then return false end
    local guiMob = controls:FindFirstChild("Gui-mob")
    if not guiMob or not guiMob:IsA("GuiObject") or not guiMob.Visible then return false end
    
    local absPos = guiMob.AbsolutePosition
    local absSize = guiMob.AbsoluteSize
    return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
        and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if State.Unloaded then return end
    if VD.AIM_Enabled and VD.AIM_UseRMB then
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            State.AimHolding = true
        elseif input.UserInputType == Enum.UserInputType.Touch and not gpe then
            -- Mobile: only lock aimbot when touching attack/shoot button
            if KYS_IsTouchOnAttackButton(input) then
                State.AimHolding = true
            end
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if State.Unloaded then return end
    if VD.AIM_Enabled and VD.AIM_UseRMB then
        if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = false
            State.AimTarget  = nil
        end
    end
end)


do -- Teleport Tab
    local tpMapSection = MappingTab:AddSection({
        Position = "Center",
        Name = "Teleport",
        Icon      = "solar:map-point-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })
    local function getTeleportPlayerNames()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        table.sort(names)
        return names
    end

    local tpPlayerDropdown = tpMapSection:AddDropdown({
        Name = "Select Player to Teleport",
        Flag = "TP_TargetPlayer",
        Values = getTeleportPlayerNames(),
        Multi = false,
        Callback = function(option)
            if type(option) == "table" then option = option[1] end
            VD.TP_TargetPlayer = option or ""
        end
    })

    tpMapSection:AddButton({ Name = "Refresh Players", Callback = function()
        pcall(function() tpPlayerDropdown:SetValues(getTeleportPlayerNames()) end)
    end })

    tpMapSection:AddButton({ Name = "Teleport to Player", Callback = function()
        pcall(function()
            local targetName = VD.TP_TargetPlayer
            if not targetName or targetName == "" then return end
            local player = Players:FindFirstChild(targetName)
            local root = Root
            local targetRoot = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and targetRoot then
                root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
            end
        end)
    end })

    tpMapSection:AddButton({ Name = "TP to Gen", Callback = function() pcall(function() KYS_TeleportToGenerator(1) end) end })
    tpMapSection:AddButton({ Name = "TP to Gate", Callback = function() pcall(KYS_TeleportToGate) end })
    tpMapSection:AddButton({ Name = "TP to Hook", Callback = function() pcall(KYS_TeleportToHook) end })
end

do -- Radar Tab
    local radarTab = MappingFeatureTabs.Radar
    if radarTab then
        local radarSection = radarTab:AddSection({
            Position = "Center",
            Name = "Radar Configuration",
            Icon      = "solar:radar-bold",
            Box       = true,
            BoxBorder = true,
            Opened    = false,
        })
        
        radarSection:AddToggle({
            Default = false,
            Name = "Radar Enabled", Flag = "Radar Enabled",
            Callback = function(state)
                VD.RADAR_Enabled = state
                if not state and radarGui then radarGui.Enabled = false end
            end
        })
        
        radarSection:AddSlider({
            Name = "Radar Size", Flag = "Radar Size",
            Min = 100, Max = 300, Default = 150,
            Callback = function(value) VD.RADAR_Size = value end
        })
        
        radarSection:AddSlider({
            Name = "Radar Range", Flag = "Radar Range",
            Min = 50, Max = 500, Default = 250,
            Callback = function(value) VD.RADAR_Range = value end
        })
        
        radarSection:AddSlider({
            Name = "Radar Transparency", Flag = "Radar Transparency",
            Min = 0, Max = 100, Default = 20,
            Callback = function(value) VD.RADAR_Transparency = value / 100 end
        })
        
        radarSection:AddToggle({
            Default = false,
            Name = "Radar Circle Mode", Flag = "Radar Circle Mode",
            Callback = function(state) VD.RADAR_Circle = state end
        })
        
        local radarFilterSection = radarTab:AddSection({
            Position = "Center",
            Name = "Radar Filters",
            Icon      = "solar:filter-bold",
            Box       = true,
            BoxBorder = true,
            Opened    = false,
        })
        
        radarFilterSection:AddToggle({ Default = false, Name = "Show Killer", Flag = "Radar Show Killer", Callback = function(state) VD.RADAR_ShowKiller = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Survivor", Flag = "Radar Show Survivor", Callback = function(state) VD.RADAR_ShowSurvivor = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Generator", Flag = "Radar Show Generator", Callback = function(state) VD.RADAR_ShowGenerator = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Pallet", Flag = "Radar Show Pallet", Callback = function(state) VD.RADAR_ShowPallet = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Hook", Flag = "Radar Show Hook", Callback = function(state) VD.RADAR_ShowHook = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Gate", Flag = "Radar Show Gate", Callback = function(state) VD.RADAR_ShowGate = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "ShowWindow", Flag = "Radar Show Window", Callback = function(state) VD.RADAR_ShowWindow = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Zombie", Flag = "Radar Show Zombie", Callback = function(state) VD.RADAR_ShowZombie = state end })
    end
end


-- =====================================================
-- REMOVE PALLETWRONG (replaces patched No Pallet Stun)
-- =====================================================
function SetupNoPalletStun()
    pcall(VD_UpdateRemovePalletwrong)
end

-- =====================================================
-- ANTI BLIND (Flashlight)
-- =====================================================
function SetupAntiBlind()
    pcall(function()
        local r  = ReplicatedStorage:FindFirstChild("Remotes")
        local i  = r and r:FindFirstChild("Items")
        local fl = i and i:FindFirstChild("Flashlight")
        local gb = fl and fl:FindFirstChild("GotBlinded")
        if not (gb and gb:IsA("RemoteEvent")) then return end

        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local old = mt.__namecall
                local _genv = getgenv()
                mt.__namecall = newcclosure(function(self, ...)
                    if not checkcaller() and _genv.VD and _genv.VD.KILLER_AntiBlind and self == gb then
                        local method = getnamecallmethod()
                        if method == "FireServer" and GetRole() == "Killer" then
                            return nil -- Block pengiriman sinyal buta
                        end
                    end
                    return old(self, ...)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end
pcall(SetupAntiBlind)

-- =====================================================
-- KYST KILLER DISPLAY
-- =====================================================
getgenv().KYS_KystKillerGui = nil
getgenv().KYS_KystKillerRunning = false

function SetupKystKillerIndicator()
    if getgenv().KYS_KystKillerGui then pcall(function() getgenv().KYS_KystKillerGui:Destroy() end) end
    getgenv().KYS_KystKillerGui = nil
    KYS_SetMainInfoPanelText("KystKiller", "Kyst Killer Display", "Waiting...")
end

function StartKystKiller()
    if getgenv().KYS_KystKillerRunning then return end
    getgenv().KYS_KystKillerRunning = true
    SetupKystKillerIndicator()
    task.spawn(function()
        local _genv = getgenv()
        while _genv.VD and _genv.VD.VIS_KystKiller and _genv.KYS_KystKillerRunning do
            local playersList = Players:GetPlayers()
            table.sort(playersList, function(a, b)
                local aA = a:GetAttribute("AllowKiller") or false
                local bB = b:GetAttribute("AllowKiller") or false
                if aA ~= bB then return aA == true end
                return (a:GetAttribute("KillerChance") or 0) > (b:GetAttribute("KillerChance") or 0)
            end)
            
            local nk = playersList[1]
            if nk then
                KYS_SetMainInfoPanelText("KystKiller", "Kyst Killer Display", "Kyst Killer: " .. (nk == LocalPlayer and "YOU" or nk.DisplayName or nk.Name))
            else
                KYS_SetMainInfoPanelText("KystKiller", "Kyst Killer Display", "Kyst Killer: None")
            end
            task.wait(2)
        end
    end)
end

function StopKystKiller()
    getgenv().KYS_KystKillerRunning = false
    if getgenv().KYS_KystKillerGui then
        pcall(function() getgenv().KYS_KystKillerGui:Destroy() end)
        getgenv().KYS_KystKillerGui = nil
    end
    KYS_SetMainInfoPanelText("KystKiller", "Kyst Killer Display", "Off")
end

-- =====================================================
-- SPECTATOR COUNTER
-- =====================================================
if getgenv().KYS_SpectatorCounterGui then
    pcall(function() getgenv().KYS_SpectatorCounterGui:Destroy() end)
end
getgenv().KYS_SpectatorCounterGui = nil
getgenv().KYS_SpectatorCounterRunning = false

function SetupSpectatorCounter()
    if getgenv().KYS_SpectatorCounterGui then pcall(function() getgenv().KYS_SpectatorCounterGui:Destroy() end) end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KYS_SpectatorCounterGui"
    sg.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Name = "CounterFrame"
    frame.Size = UDim2.new(0, 88, 0, 28)
    frame.Position = UDim2.new(0.02, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    frame.BackgroundTransparency = 0.18
    frame.BorderSizePixel = 0
    frame.Parent = sg

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 9)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 1
    stroke.Transparency = 0.35
    stroke.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 8)
    layout.Parent = frame

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://13321848320"
    icon.ImageColor3 = Color3.fromRGB(205, 185, 255)
    icon.Parent = frame

    local label = Instance.new("TextLabel")
    label.Name = "SpectatorCount"
    label.Size = UDim2.new(0, 42, 0, 28)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = "0"
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local pg = GetSafeGuiParent()
    if pg then
        local oldGui = pg:FindFirstChild("KYS_SpectatorCounterGui")
        if oldGui then pcall(function() oldGui:Destroy() end) end
        sg.Parent = pg
    else
        task.spawn(function()
            local pgui = LocalPlayer:WaitForChild("PlayerGui", 10)
            if pgui then sg.Parent = pgui end
        end)
    end

    getgenv().KYS_SpectatorCounterGui = sg
end

function StartSpectatorCounter()
    if getgenv().KYS_SpectatorCounterRunning then return end
    getgenv().KYS_SpectatorCounterRunning = true
    SetupSpectatorCounter()

    task.spawn(function()
        local _genv = getgenv()
        while _genv.VD and _genv.VD.VIS_SpectatorCounter and _genv.KYS_SpectatorCounterRunning and getgenv().KYS_SpectatorCounterGui do
            local sg = getgenv().KYS_SpectatorCounterGui
            if not sg or not sg.Parent then break end

            local count = 0
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Team and player.Team.Name == "Spectator" then
                    count = count + 1
                end
            end

            local label = sg:FindFirstChild("SpectatorCount", true)
            if label then
                label.Text = tostring(count)
            end

            task.wait(1)
        end
    end)
end

function StopSpectatorCounter()
    getgenv().KYS_SpectatorCounterRunning = false
    if getgenv().KYS_SpectatorCounterGui then
        pcall(function() getgenv().KYS_SpectatorCounterGui:Destroy() end)
        getgenv().KYS_SpectatorCounterGui = nil
    end
end

-- =====================================================
-- KILLER PERKS DISPLAY
-- Reads killer perk objects directly from Workspace character models.
-- =====================================================
do -- begin Killer Perks scope
if getgenv().KYS_KillerPerksGui then
    pcall(function() getgenv().KYS_KillerPerksGui:Destroy() end)
end
getgenv().KYS_KillerPerksGui = nil

local KYS_KillerPerksCollapsed = false
local KYS_KillerPerksLocked = false
getgenv().KYS_KillerPerksRunning = false

local KYS_KillerPerkNames = {
    KystInLine = "Kyst in Line",
    ["Kyst in Line"] = "Kyst in Line",
    EchoLocation = "Echo Location",
    ["Echo Location"] = "Echo Location",
    KingsScourge = "King's Scourge",
    KingScourge = "King's Scourge",
    ["King's Scourge"] = "King's Scourge",
}

function KYS_EscapeRichText(text)
    text = tostring(text or "")
    text = text:gsub("&", "&amp;")
    text = text:gsub("<", "&lt;")
    text = text:gsub(">", "&gt;")
    return text
end

local function KYS_FormatPerkName(name)
    name = tostring(name or "")
    if KYS_KillerPerkNames[name] then return KYS_KillerPerkNames[name] end

    local clean = name:gsub("_", " "):gsub("-", " ")
    clean = clean:gsub("(%l)(%u)", "%1 %2")
    clean = clean:gsub("(%a)(%d)", "%1 %2")
    clean = clean:gsub("(%d)(%a)", "%1 %2")
    clean = clean:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    return clean ~= "" and clean or "Unknown Perk"
end

local function KYS_GetKillerPlayer()
    for _, player in ipairs(Players:GetPlayers()) do
        local teamName = player.Team and player.Team.Name
        if teamName and teamName:lower():find("killer") then
            return player
        end
    end
    return nil
end

local function KYS_AddWorkspacePerk(result, seen, rawName, displayName, level)
    if not rawName then return end
    rawName = tostring(rawName)
    if rawName == "" or rawName == "nil" then return end
    if rawName:lower():find("template") then return end
    if seen[rawName] then return end

    seen[rawName] = true
    table.insert(result, {
        Raw = rawName,
        Name = displayName and tostring(displayName) or KYS_FormatPerkName(rawName),
        Level = level and tostring(level) or nil,
    })
end

local function KYS_IsPerkContainer(inst)
    local name = inst.Name:lower()
    return name == "perks"
        or name == "killerperks"
        or name == "equippedperks"
        or name == "equippedkillerperks"
        or name:find("perkfolder") ~= nil
        or name:find("perklist") ~= nil
end

local function KYS_ParseWorkspacePerkName(name)
    name = tostring(name or "")
    local perkName, level = name:match("^(.+)%s+(%d+)$")
    if not perkName then return nil end

    perkName = perkName:gsub("^%s+", ""):gsub("%s+$", "")
    if perkName == "" then return nil end

    local lower = perkName:lower()
    local excluded = {
        head = true,
        torso = true,
        humanoid = true,
        ["left arm"] = true,
        ["right arm"] = true,
        ["left leg"] = true,
        ["right leg"] = true,
        ["humanoidrootpart"] = true,
    }
    if excluded[lower] then return nil end

    return perkName, level
end

local function KYS_ReadPerksFromWorkspace(killer)
    if not killer then return {} end

    local char = killer.Character or Workspace:FindFirstChild(killer.Name) or Workspace:FindFirstChild(killer.DisplayName)
    if not char then return {} end

    local result = {}
    local seen = {}

    local function scanAttributes(inst)
        if not inst.GetAttributes then return end
        local attrs = inst:GetAttributes()
        for key, value in pairs(attrs) do
            local lowerKey = tostring(key):lower()
            if lowerKey:find("perk") then
                if type(value) == "string" then
                    KYS_AddWorkspacePerk(result, seen, value)
                elseif value == true then
                    KYS_AddWorkspacePerk(result, seen, key)
                elseif type(value) == "number" and lowerKey:find("level") then
                    local baseName = tostring(key):gsub("[Ll]evel", ""):gsub("[Pp]erk", "")
                    if baseName ~= "" then
                        KYS_AddWorkspacePerk(result, seen, baseName, nil, value)
                    end
                end
            end
        end
    end

    local function readValueObject(inst)
        if inst:IsA("StringValue") then
            return inst.Value
        elseif inst:IsA("IntValue") or inst:IsA("NumberValue") then
            return inst.Name, inst.Value
        elseif inst:IsA("BoolValue") and inst.Value == true then
            return inst.Name
        end
        return nil
    end

    scanAttributes(char)

    for _, child in ipairs(char:GetChildren()) do
        local perkName, level = KYS_ParseWorkspacePerkName(child.Name)
        if perkName then
            KYS_AddWorkspacePerk(result, seen, child.Name, perkName, level)
        end
    end

    for _, inst in ipairs(char:GetDescendants()) do
        scanAttributes(inst)

        if KYS_IsPerkContainer(inst) then
            for _, child in ipairs(inst:GetChildren()) do
                local value, level = readValueObject(child)
                KYS_AddWorkspacePerk(result, seen, value or child.Name, nil, level)
            end
        else
            local lowerName = inst.Name:lower()
            if lowerName:find("perk") then
                local value, level = readValueObject(inst)
                KYS_AddWorkspacePerk(result, seen, value or inst.Name, nil, level)
            end
        end
    end

    table.sort(result, function(a, b) return tostring(a.Name) < tostring(b.Name) end)
    return result
end

local function KYS_BuildKillerPerksText()
    local killer = KYS_GetKillerPlayer()
    local killerName = killer and (killer.DisplayName or killer.Name) or "Unknown"
    local perks = KYS_ReadPerksFromWorkspace(killer)

    if #perks == 0 then
        for _, player in ipairs(Players:GetPlayers()) do
            local candidatePerks = KYS_ReadPerksFromWorkspace(player)
            if #candidatePerks > 0 then
                killer = player
                killerName = player.DisplayName or player.Name
                perks = candidatePerks
                break
            end
        end
    end

    local lines = {
        'Killer Perks [<font color="rgb(255,80,80)">' .. KYS_EscapeRichText(killerName) .. '</font>]',
    }

    if #perks == 0 then
        table.insert(lines, '<font color="rgb(255,204,80)">- Waiting for perk data...</font>')
    else
        for i = 1, math.min(#perks, 4) do
            local perk = perks[i]
            local levelText = perk.Level and (" lvl " .. tostring(perk.Level)) or ""
            table.insert(lines, '<font color="rgb(255,204,80)">- ' .. KYS_EscapeRichText(perk.Name) .. KYS_EscapeRichText(levelText) .. '</font>')
        end
    end

    return table.concat(lines, "\n"), #perks
end

local function SetupKillerPerksDisplay()
    if getgenv().KYS_KillerPerksGui then pcall(function() getgenv().KYS_KillerPerksGui:Destroy() end) end
    getgenv().KYS_KillerPerksGui = nil
    KYS_SetMainInfoPanelText("KillerPerks", "Spectate Killer Perks", "Waiting for perk data...")
end

function StartKillerPerksDisplay()
    if getgenv().KYS_KillerPerksRunning then return end
    getgenv().KYS_KillerPerksRunning = true
    SetupKillerPerksDisplay()

    task.spawn(function()
        local _genv = getgenv()
        while _genv.VD and _genv.VD.VIS_KillerPerks and _genv.KYS_KillerPerksRunning do
            local text = KYS_BuildKillerPerksText()
            KYS_SetMainInfoPanelText("KillerPerks", "Spectate Killer Perks", text)
            task.wait(1)
        end
    end)
end

function StopKillerPerksDisplay()
    getgenv().KYS_KillerPerksRunning = false
    if getgenv().KYS_KillerPerksGui then
        pcall(function() getgenv().KYS_KillerPerksGui:Destroy() end)
        getgenv().KYS_KillerPerksGui = nil
    end
    KYS_SetMainInfoPanelText("KillerPerks", "Spectate Killer Perks", "Off")
end
end -- end Killer Perks scope

-- =====================================================
-- PREDICT MAP
-- Tries early map data remotes first, then confirms from workspace.Map.
-- =====================================================
do -- begin Predict Map scope
if getgenv().KYS_PredictMapGui then
    pcall(function() getgenv().KYS_PredictMapGui:Destroy() end)
end
if getgenv().KYS_PredictMapConnections then
    for _, conn in ipairs(getgenv().KYS_PredictMapConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
getgenv().KYS_PredictMapGui = nil
getgenv().KYS_PredictMapConnections = {}
getgenv().KYS_PredictMapRunning = false

local KYS_PredictMapState = {
    Name = "Unknown",
    Desc = "Waiting for map data...",
    Source = "Idle",
    Phase = "",
    TimeLeft = nil,
}

local function KYS_MapStringFromValue(value)
    if type(value) == "string" then
        return value
    elseif typeof and typeof(value) == "Instance" then
        return value.Name
    elseif type(value) == "table" then
        return value.Title
            or value.title
            or value.Name
            or value.name
            or value.Map
            or value.map
            or value.MapName
            or value.mapName
            or value.Location
            or value.location
    end
    return nil
end

local function KYS_MapDescFromValue(value)
    if type(value) ~= "table" then return nil end
    return value.Desc or value.desc or value.Description or value.description
end

local function KYS_SetPredictedMap(name, desc, source)
    name = KYS_MapStringFromValue(name) or name
    if not name or tostring(name) == "" then return end
    KYS_PredictMapState.Name = tostring(name)
    if desc and tostring(desc) ~= "" then
        KYS_PredictMapState.Desc = tostring(desc)
    end
    KYS_PredictMapState.Source = source or "Detected"
end

local function KYS_ReadCurrentWorkspaceMap()
    local map = Workspace:FindFirstChild("Map")
    if not map then return nil end

    local camScene = map:FindFirstChild("Camerascene1", true)
    local title = camScene and camScene:GetAttribute("title")
    local desc = camScene and camScene:GetAttribute("desc")
    if title then
        return tostring(title), desc and tostring(desc) or nil
    end

    for _, child in ipairs(map:GetChildren()) do
        local childTitle = child:GetAttribute("title") or child:GetAttribute("Title") or child:GetAttribute("MapName")
        if childTitle then
            return tostring(childTitle), child:GetAttribute("desc") or child:GetAttribute("Description")
        end
    end

    return map.Name ~= "Map" and map.Name or "Map Loaded", nil
end

local function KYS_TryPredictMapRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local mechanics = remotes and remotes:FindFirstChild("Mechanics")
    local chat = mechanics and mechanics:FindFirstChild("Chat")
    local getMapData = chat and chat:FindFirstChild("GetMapData")
    if not (getMapData and getMapData:IsA("RemoteFunction")) then return false end

    local attempts = {
        {},
        { "Current" },
        { "Kyst" },
        { "Map" },
    }

    for _, args in ipairs(attempts) do
        local ok, data = pcall(function()
            return getMapData:InvokeServer(table.unpack(args))
        end)
        if ok and data ~= nil then
            local name = KYS_MapStringFromValue(data)
            local desc = KYS_MapDescFromValue(data)
            if name then
                KYS_SetPredictedMap(name, desc, "Predicted")
                return true
            end
        end
    end

    return false
end

local function KYS_PredictMapText()
    local name = KYS_EscapeRichText(KYS_PredictMapState.Name or "Unknown")
    local source = KYS_EscapeRichText(KYS_PredictMapState.Source or "Idle")
    local phase = tostring(KYS_PredictMapState.Phase or "")
    local timeLeft = KYS_PredictMapState.TimeLeft
    local timerText = ""
    if timeLeft then
        timerText = " [" .. phase .. " " .. tostring(timeLeft) .. "s]"
    elseif phase ~= "" then
        timerText = " [" .. phase .. "]"
    end

    local lines = {
        'Map: <font color="rgb(255,204,80)">' .. name .. '</font>',
        '<font color="rgb(190,170,255)">' .. source .. timerText .. '</font>',
    }

    return table.concat(lines, "\n")
end

local function SetupPredictMapGui()
    if getgenv().KYS_PredictMapGui then pcall(function() getgenv().KYS_PredictMapGui:Destroy() end) end
    getgenv().KYS_PredictMapGui = nil
    KYS_SetMainInfoPanelText("PredictMap", "Predict Map", KYS_PredictMapText())
end

local function KYS_BindPredictMapEvents()
    local conns = getgenv().KYS_PredictMapConnections
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end

    local messages = remotes:FindFirstChild("Messages")
    local mapInfo = messages and messages:FindFirstChild("Mapinfo")
    if mapInfo and mapInfo:IsA("RemoteEvent") then
        table.insert(conns, mapInfo.OnClientEvent:Connect(function(a, b, c)
            local name = KYS_MapStringFromValue(a) or KYS_MapStringFromValue(b) or KYS_MapStringFromValue(c)
            local desc = KYS_MapDescFromValue(a) or KYS_MapDescFromValue(b) or KYS_MapDescFromValue(c)
            if name then
                KYS_SetPredictedMap(name, desc, "Predicted")
            end
        end))
    end

    local timeEvent = remotes:FindFirstChild("TimeUpdateEvent")
    if timeEvent and timeEvent:IsA("RemoteEvent") then
        table.insert(conns, timeEvent.OnClientEvent:Connect(function(phase, timeLeft)
            KYS_PredictMapState.Phase = tostring(phase or "")
            KYS_PredictMapState.TimeLeft = tonumber(timeLeft)
            if tostring(phase) == "Intermission" and tonumber(timeLeft) and tonumber(timeLeft) <= 20 then
                pcall(KYS_TryPredictMapRemote)
            end
        end))
    end

    table.insert(conns, Workspace.ChildAdded:Connect(function(child)
        if child and child.Name == "Map" then
            task.delay(0.25, function()
                local name, desc = KYS_ReadCurrentWorkspaceMap()
                if name then KYS_SetPredictedMap(name, desc, "Confirmed") end
            end)
        end
    end))
end

function StartPredictMap()
    if getgenv().KYS_PredictMapRunning then return end
    getgenv().KYS_PredictMapRunning = true
    SetupPredictMapGui()
    KYS_BindPredictMapEvents()

    task.spawn(function()
        while VD and VD.VIS_PredictMap and getgenv().KYS_PredictMapRunning do
            local currentName, currentDesc = KYS_ReadCurrentWorkspaceMap()
            if currentName then
                KYS_SetPredictedMap(currentName, currentDesc, "Confirmed")
            else
                pcall(KYS_TryPredictMapRemote)
            end

            KYS_SetMainInfoPanelText("PredictMap", "Predict Map", KYS_PredictMapText())

            task.wait(1)
        end
    end)
end

function StopPredictMap()
    getgenv().KYS_PredictMapRunning = false
    if getgenv().KYS_PredictMapGui then
        pcall(function() getgenv().KYS_PredictMapGui:Destroy() end)
        getgenv().KYS_PredictMapGui = nil
    end
    if getgenv().KYS_PredictMapConnections then
        for _, conn in ipairs(getgenv().KYS_PredictMapConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    getgenv().KYS_PredictMapConnections = {}
    KYS_SetMainInfoPanelText("PredictMap", "Predict Map", "Off")
end
end -- end Predict Map scope

-- =====================================================
-- CAMERA / FOV / THIRD PERSON / SHIFT LOCK
-- =====================================================
getgenv().KYS_OriginalFOV          = nil
getgenv().KYS_OriginalCameraType   = nil
getgenv().KYS_OriginalCameraOffset = nil
getgenv().KYS_ThirdPersonWasActive = false
getgenv().KYS_FOVWasActive         = false

function UpdateCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end

    if VD.CAM_FOVEnabled then
        if not getgenv().KYS_FOVWasActive then
            getgenv().KYS_OriginalFOV = cam.FieldOfView
            getgenv().KYS_FOVWasActive = true
        end
        cam.FieldOfView = VD.CAM_FOV or 90
    elseif getgenv().KYS_FOVWasActive then
        if getgenv().KYS_OriginalFOV then cam.FieldOfView = getgenv().KYS_OriginalFOV end
        getgenv().KYS_OriginalFOV = nil
        getgenv().KYS_FOVWasActive = false
    end
end

function UpdateThirdPerson()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local shouldBeActive = VD.CAM_ThirdPerson and GetRole() == "Killer"
    if shouldBeActive then
        if not getgenv().KYS_ThirdPersonWasActive then
            getgenv().KYS_OriginalCameraType = cam.CameraType
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            getgenv().KYS_OriginalCameraOffset = hum and hum.CameraOffset or Vector3.new(0, 0, 0)
        end
        cam.CameraType = Enum.CameraType.Custom
        local char     = LocalPlayer.Character
        local hum      = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = Vector3.new(2, 1, 8) end
        getgenv().KYS_ThirdPersonWasActive = true
    elseif getgenv().KYS_ThirdPersonWasActive then
        if getgenv().KYS_OriginalCameraType then
            cam.CameraType = getgenv().KYS_OriginalCameraType; getgenv().KYS_OriginalCameraType = nil
        end
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = getgenv().KYS_OriginalCameraOffset or Vector3.new(0, 0, 0) end
        getgenv().KYS_OriginalCameraOffset = nil
        getgenv().KYS_ThirdPersonWasActive = false
    end
end

getgenv().KYS_shiftLockWasActive = false

function UpdateShiftLock()
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local cam  = workspace.CurrentCamera

    if VD.CAM_ShiftLock then
        if not char or not root or not cam then return end

        -- Matikan rotasi bawaan game saat jalan
        if hum then hum.AutoRotate = false end
        getgenv().KYS_shiftLockWasActive = true

        local flatLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
        -- Cegah NaN kalau arah kamera tegak lurus ke atas/bawah
        if flatLook.Magnitude > 0.001 then
            local lookUnit = flatLook.Unit
            root.CFrame = CFrame.new(root.Position, root.Position + lookUnit)
        end
    else
        -- Kembalikan rotasi bawaan kalau shiftlock dimatikan
        if getgenv().KYS_shiftLockWasActive then
            if hum then hum.AutoRotate = true end
            getgenv().KYS_shiftLockWasActive = false
        end
    end
end

-- =====================================================
-- NO FOG
-- =====================================================
getgenv().KYS_FogCache = {}

function RemoveFog()
    pcall(function()
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, obj in ipairs(map:GetDescendants()) do
                if obj.Name:lower():find("fog") or obj:IsA("Atmosphere") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then
                    if not getgenv().KYS_FogCache[obj] then
                        getgenv().KYS_FogCache[obj] = {
                            enabled = obj:IsA("PostEffect") and obj.Enabled or true,
                            parent =
                                obj.Parent
                        }
                    end
                    if obj:IsA("PostEffect") then obj.Enabled = false else obj.Parent = nil end
                end
            end
        end
    end)
    pcall(function()
        local lt = game:GetService("Lighting")
        for _, obj in ipairs(lt:GetChildren()) do
            if obj:IsA("Atmosphere") or obj.Name:lower():find("fog") then
                if not getgenv().KYS_FogCache[obj] then getgenv().KYS_FogCache[obj] = { enabled = true, parent = obj.Parent } end
                if obj:IsA("Atmosphere") then obj.Density = 0 else obj.Parent = nil end
            end
        end
        lt.FogEnd   = 100000
        lt.FogStart = 0
    end)
end

function RestoreFog()
    pcall(function()
        for obj, data in pairs(getgenv().KYS_FogCache) do
            if obj and data.parent then
                if obj:IsA("PostEffect") then obj.Enabled = data.enabled else obj.Parent = data.parent end
            end
        end
        getgenv().KYS_FogCache = {}
        game:GetService("Lighting").FogEnd = 1000
    end)
end

-- =====================================================
-- NO SLOWDOWN
-- =====================================================
function UpdateNoSlowdown()
    if not VD.KILLER_NoSlowdown or GetRole() ~= "Killer" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed < 16 then hum.WalkSpeed = VD.SPEED_Value or 16 end
end

-- =====================================================
-- KUNCI KECEPATAN / ANTI BEKU (__newindex Hook)
-- =====================================================
function SetupAntiStunSlowdown()
    if getgenv().KYS_AntiStunHooked then return end
    getgenv().KYS_AntiStunHooked = true

    pcall(function()
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local oldNI = mt.__newindex
                local _genv = getgenv()
                mt.__newindex = newcclosure(function(t, k, v)
                    if k == "WalkSpeed" or k == "Anchored" then
                        if not checkcaller() and _genv.VD and _genv.VD.KILLER_NoSlowdown and GetRole() == "Killer" then
                            -- Cegah perintah yang mengurangi WalkSpeed drastis (Efek Stun/Kesandung)
                            if k == "WalkSpeed" and typeof(v) == "number" and v < 16 and typeof(t) == "Instance" and t:IsA("Humanoid") then
                                return oldNI(t, k, _genv.VD.SPEED_Value or 16)
                            end
                            -- Cegah perintah yang membekukan posisi karakter (Anchored Stun)
                            if k == "Anchored" and v == true and typeof(t) == "Instance" and t:IsA("BasePart") and t.Name == "HumanoidRootPart" then
                                return oldNI(t, k, false)
                            end
                        end
                    end
                    return oldNI(t, k, v)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end
task.spawn(SetupAntiStunSlowdown)

-- =====================================================
-- FOV CIRCLE
-- =====================================================
local FOVCircle = nil
if DrawingAvailable then
    FOVCircle = SafeDrawing("Circle")
    if FOVCircle then
        FOVCircle.Thickness    = 1
        FOVCircle.Color        = Color3.fromRGB(220, 70, 70)
        FOVCircle.Filled       = false
        FOVCircle.NumSides     = 64
        FOVCircle.Transparency = 0.8
        FOVCircle.Visible      = false
    end
end

-- =====================================================
-- NO CUTSCENE BYPASS & HOOK
-- =====================================================
local fakeBindable = Instance.new("BindableEvent")
local fakeRemote = Instance.new("RemoteEvent")

function SetupNoCutsceneHook()
    if getgenv().KYS_NoCutsceneHooked then return end
    getgenv().KYS_NoCutsceneHooked = true

    pcall(function()
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local oldIndex = mt.__index
                local _genv = getgenv()
                
                mt.__index = newcclosure(function(t, k)
                    if k == "OnClientEvent" or k == "Event" then
                        if _genv.VD and _genv.VD.NoCutscene and not checkcaller() and typeof(t) == "Instance" then
                            local name = t.Name
                            if name == "cutscene" and k == "Event" then
                                local parent = t.Parent
                                if parent and parent.Name == "Game" then
                                    return fakeBindable.Event
                                end
                            elseif (name == "cutsceneEnd" or name == "cutsceneEnd2" or name == "cutsceneEndwithownchar" or name == "endscreencutscene") then
                                local parent = t.Parent
                                if parent and parent.Name == "Game" then
                                    return fakeRemote.OnClientEvent
                                end
                            end
                        end
                    end
                    return oldIndex(t, k)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end

function KYS_SetupNoCutsceneListeners()
    task.spawn(function()
        local gameFolder = ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("Game", 10)
        if not gameFolder then return end
        
        local endscreencutscene = gameFolder:WaitForChild("endscreencutscene", 10)
        local cutsceneEnd = gameFolder:WaitForChild("cutsceneEnd", 10)
        local cutsceneEnd2 = gameFolder:WaitForChild("cutsceneEnd2", 10)
        local cutsceneEndwithownchar = gameFolder:WaitForChild("cutsceneEndwithownchar", 10)
        
        function showInstantResults()
            if not getgenv().VD or not getgenv().VD.NoCutscene then return end
            
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CameraType = Enum.CameraType.Custom
                    cam.FieldOfView = 70
                end
                game:GetService("UserInputService").MouseIconEnabled = true
                pcall(function() game:GetService("SoundService"):WaitForChild("chase").Volume = 0 end)
                LocalPlayer:SetAttribute("isspectating", true)
                
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                if pg then
                    local Results = pg:FindFirstChild("Results")
                    local EndScreen = pg:FindFirstChild("EndScreen")
                    local Darkness = pg:FindFirstChild("Darkness")
                    
                    if Results then Results.Enabled = true end
                    if EndScreen then 
                        EndScreen.Enabled = true 
                        local blackout = EndScreen:FindFirstChild("blackout")
                        if blackout then blackout.BackgroundTransparency = 1 end
                    end
                    if Darkness then
                        Darkness.Enabled = true
                        local frame2 = Darkness:FindFirstChild("Frame2")
                        if frame2 then frame2.BackgroundTransparency = 1 end
                    end
                end
            end)
        end
        
        if endscreencutscene then endscreencutscene.OnClientEvent:Connect(showInstantResults) end
        if cutsceneEnd then cutsceneEnd.OnClientEvent:Connect(showInstantResults) end
        if cutsceneEnd2 then cutsceneEnd2.OnClientEvent:Connect(showInstantResults) end
        if cutsceneEndwithownchar then cutsceneEndwithownchar.OnClientEvent:Connect(showInstantResults) end
    end)
end

task.spawn(SetupNoCutsceneHook)
task.spawn(KYS_SetupNoCutsceneListeners)

-- =====================================================
-- RENDERSTEP: Drawing ESP / Aimbot / Camera
-- =====================================================
function OnRenderStep()
    if VD.Destroyed then
        if DrawingAvailable then
            if FOVCircle then SafeRemove(FOVCircle) end
        end
        return
    end

    Camera = Workspace.CurrentCamera or Camera
    local cam = Camera
    if not cam then return end
    local screenSize   = cam.ViewportSize
    local screenCenter = Vector2.new(screenSize.X / 2, screenSize.Y / 2)

    -- Aimbot
    pcall(function()
        if VD.AIM_Enabled then
            Aimbot.Update(cam, cam.ViewportSize, Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2))
        end
    end)

    pcall(UpdateSpearAim)
    UpdateCameraFOV()
    UpdateThirdPerson()
    UpdateShiftLock()

    -- FOV circle
    if FOVCircle and DrawingAvailable then
        if VD.AIM_Enabled and VD.AIM_ShowFOV then
            FOVCircle.Position = screenCenter
            FOVCircle.Radius   = VD.AIM_FOV or 120
            FOVCircle.Color    = State.AimTarget and Color3.fromRGB(90, 220, 120) or Color3.fromRGB(220, 70, 70)
            FOVCircle.Visible  = true
        else
            FOVCircle.Visible = false
        end
    end
end


-- =====================================================
-- MOBILE GUI (Aimbot Button + FOV Circle)
-- =====================================================
getgenv().KYS_MobileGui = getgenv().KYS_MobileGui or { AimBtn=nil, FOVFrame=nil, FOVStroke=nil }

function CreateMobileUI()
    local pg = GetSafeGuiParent()
    if not pg then return end

    -- === MAIN SCREENGUI ===
    local sg = Instance.new("ScreenGui")
    sg.Name           = "KYS_MobileUI"
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 100
    sg.Parent         = pg
    -- === FOV CIRCLE ===
    local fovF = Instance.new("Frame")
    fovF.Name                 = "FOVCircle"
    fovF.BackgroundTransparency = 1
    fovF.AnchorPoint          = Vector2.new(0.5,0.5)
    fovF.Position             = UDim2.new(0.5,0,0.5,0)
    fovF.Size                 = UDim2.new(0,240,0,240)
    fovF.Visible              = false
    fovF.Parent               = sg
    Instance.new("UICorner", fovF).CornerRadius = UDim.new(1,0)
    local fovStk = Instance.new("UIStroke")
    fovStk.Color = Color3.fromRGB(220,70,70); fovStk.Thickness = 1.5; fovStk.Transparency = 0.2
    fovStk.Parent = fovF
    getgenv().KYS_MobileGui.FOVFrame = fovF; getgenv().KYS_MobileGui.FOVStroke = fovStk

    -- === AIMBOT BUTTON (ScreenGui terpisah agar AlwaysOnTop) ===
    local aimSG = Instance.new("ScreenGui")
    aimSG.Name           = "KYS_AimBtn"
    aimSG.ResetOnSpawn   = false
    aimSG.IgnoreGuiInset = true
    aimSG.ZIndexBehavior = Enum.ZIndexBehavior.AlwaysOnTop
    aimSG.Parent         = pg
    local btn = Instance.new("TextButton")
    btn.Name                = "AimHold"
    btn.Size                = UDim2.new(0,75,0,75)
    btn.Position            = UDim2.new(1,-95,1,-170)
    btn.BackgroundColor3    = Color3.fromRGB(200,55,55)
    btn.BackgroundTransparency = 0.2
    btn.Text                = "🎯\nAIM"
    btn.TextColor3          = Color3.new(1,1,1)
    btn.TextSize            = 14
    btn.Font                = Enum.Font.GothamBold
    btn.Visible             = false
    btn.ZIndex              = 20
    btn.Parent              = aimSG
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local aStk = Instance.new("UIStroke")
    aStk.Color = Color3.fromRGB(255,100,100); aStk.Thickness = 2; aStk.Parent = btn

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = true
            btn.BackgroundColor3 = Color3.fromRGB(50,200,80)
            aStk.Color = Color3.fromRGB(50,230,80)
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = false; State.AimTarget = nil
            btn.BackgroundColor3 = Color3.fromRGB(200,55,55)
            aStk.Color = Color3.fromRGB(255,100,100)
        end
    end)
    getgenv().KYS_MobileGui.AimBtn = btn
end

-- =====================================================
-- SPEAR AIMBOT MOBILE FLOATING BUTTON
-- =====================================================
SpearBtnData = {
    UI = nil,
    Button = nil,
    Active = true,
    DragLocked = false,
    Dragging = false,
    DragStart = nil,
    DragStartPos = nil,
    ManualTarget = nil,   -- Player yang dipilih manual lewat panah, nil = auto (terdekat)
    TargetIndex = 0,
    TargetLabel = nil,    -- label kecil nampilin nama target / "AUTO"
    LeftArrow = nil,
    RightArrow = nil,
}

function setupSpearAimbotBtn()
    if SpearBtnData.UI then pcall(function() SpearBtnData.UI:Destroy() end) end

    local player = game:GetService("Players").LocalPlayer
    local pg = player:WaitForChild("PlayerGui")

    SpearBtnData.UI = Instance.new("ScreenGui")
    SpearBtnData.UI.Name = "SpearAimbotUI"
    SpearBtnData.UI.ResetOnSpawn = false
    SpearBtnData.UI.IgnoreGuiInset = true
    SpearBtnData.UI.Parent = pg

    -- Main toggle button
    SpearBtnData.Button = Instance.new("TextButton")
    SpearBtnData.Button.Name = "SpearAimbotButton"
    SpearBtnData.Button.Size = UDim2.new(0, 65, 0, 65)
    SpearBtnData.Button.Position = UDim2.new(0.15, 0, 0.75, 0)
    SpearBtnData.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    SpearBtnData.Button.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    SpearBtnData.Button.BackgroundTransparency = 0.15
    SpearBtnData.Button.AutoButtonColor = true
    SpearBtnData.Button.Text = "SPEAR\nAIM"
    SpearBtnData.Button.TextColor3 = Color3.fromRGB(255, 100, 100)
    SpearBtnData.Button.TextSize = 11
    SpearBtnData.Button.Font = Enum.Font.GothamBold
    SpearBtnData.Button.Visible = false
    SpearBtnData.Button.ZIndex = 10
    SpearBtnData.Button.Parent = SpearBtnData.UI
    Instance.new("UICorner", SpearBtnData.Button).CornerRadius = UDim.new(1, 0)

    local spearStk = Instance.new("UIStroke", SpearBtnData.Button)
    spearStk.Color = Color3.fromRGB(255, 80, 80)
    spearStk.Thickness = 2
    spearStk.Transparency = 0.2

    -- Lock/Unlock drag button (small, top-right corner)
    local lockBtn = Instance.new("TextButton")
    lockBtn.Name = "LockDrag"
    lockBtn.Size = UDim2.new(0, 22, 0, 22)
    lockBtn.Position = UDim2.new(1, -5, 0, -5)
    lockBtn.AnchorPoint = Vector2.new(1, 0)
    lockBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    lockBtn.BackgroundTransparency = 0.3
    lockBtn.Text = "L"
    lockBtn.TextSize = 10
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextColor3 = Color3.new(1, 1, 1)
    lockBtn.ZIndex = 11
    lockBtn.Parent = SpearBtnData.Button
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)

    lockBtn.MouseButton1Click:Connect(function()
        SpearBtnData.DragLocked = not SpearBtnData.DragLocked
        lockBtn.Text = SpearBtnData.DragLocked and "X" or "L"
        lockBtn.BackgroundColor3 = SpearBtnData.DragLocked and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(60, 60, 60)
    end)

    -- Target label (nampilin nama target aktif / "AUTO"), muncul di atas tombol utama
    local targetLabel = Instance.new("TextLabel")
    targetLabel.Name = "SpearTargetLabel"
    targetLabel.Size = UDim2.new(0, 90, 0, 18)
    targetLabel.Position = UDim2.new(0.5, 0, 0, -22)
    targetLabel.AnchorPoint = Vector2.new(0.5, 0)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "AUTO"
    targetLabel.TextColor3 = Color3.fromRGB(255, 220, 220)
    targetLabel.TextSize = 12
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextTruncate = Enum.TextTruncate.AtEnd
    targetLabel.ZIndex = 11
    targetLabel.Visible = false
    targetLabel.Parent = SpearBtnData.Button
    SpearBtnData.TargetLabel = targetLabel

    -- Tombol panah kiri: ganti target ke arah sebelumnya di daftar
    local leftArrow = Instance.new("TextButton")
    leftArrow.Name = "SpearTargetLeft"
    leftArrow.Size = UDim2.new(0, 28, 0, 28)
    leftArrow.Position = UDim2.new(0, -34, 0.5, 0)
    leftArrow.AnchorPoint = Vector2.new(0.5, 0.5)
    leftArrow.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    leftArrow.BackgroundTransparency = 0.15
    leftArrow.Text = "<"
    leftArrow.TextColor3 = Color3.fromRGB(255, 150, 150)
    leftArrow.TextSize = 16
    leftArrow.Font = Enum.Font.GothamBold
    leftArrow.ZIndex = 10
    leftArrow.Parent = SpearBtnData.Button
    Instance.new("UICorner", leftArrow).CornerRadius = UDim.new(1, 0)
    local leftStk = Instance.new("UIStroke", leftArrow)
    leftStk.Color = Color3.fromRGB(255, 80, 80)
    leftStk.Thickness = 1.5
    leftStk.Transparency = 0.3
    SpearBtnData.LeftArrow = leftArrow

    leftArrow.MouseButton1Click:Connect(function()
        pcall(CycleSpearTarget, -1)
    end)

    -- Tombol panah kanan: ganti target ke arah berikutnya di daftar
    local rightArrow = Instance.new("TextButton")
    rightArrow.Name = "SpearTargetRight"
    rightArrow.Size = UDim2.new(0, 28, 0, 28)
    rightArrow.Position = UDim2.new(1, 34, 0.5, 0)
    rightArrow.AnchorPoint = Vector2.new(0.5, 0.5)
    rightArrow.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    rightArrow.BackgroundTransparency = 0.15
    rightArrow.Text = ">"
    rightArrow.TextColor3 = Color3.fromRGB(255, 150, 150)
    rightArrow.TextSize = 16
    rightArrow.Font = Enum.Font.GothamBold
    rightArrow.ZIndex = 10
    rightArrow.Parent = SpearBtnData.Button
    Instance.new("UICorner", rightArrow).CornerRadius = UDim.new(1, 0)
    local rightStk = Instance.new("UIStroke", rightArrow)
    rightStk.Color = Color3.fromRGB(255, 80, 80)
    rightStk.Thickness = 1.5
    rightStk.Transparency = 0.3
    SpearBtnData.RightArrow = rightArrow

    rightArrow.MouseButton1Click:Connect(function()
        pcall(CycleSpearTarget, 1)
    end)

    -- Drag logic
    SpearBtnData.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if SpearBtnData.DragLocked then return end
            SpearBtnData.Dragging = true
            SpearBtnData.DragStart = input.Position
            SpearBtnData.DragStartPos = SpearBtnData.Button.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if SpearBtnData.Dragging and not SpearBtnData.DragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - SpearBtnData.DragStart
            SpearBtnData.Button.Position = UDim2.new(
                SpearBtnData.DragStartPos.X.Scale, SpearBtnData.DragStartPos.X.Offset + delta.X,
                SpearBtnData.DragStartPos.Y.Scale, SpearBtnData.DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    SpearBtnData.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SpearBtnData.Dragging = false
        end
    end)

    -- Toggle Spear Aimbot function on/off (GUI stays visible)
    SpearBtnData.Button.MouseButton1Click:Connect(function()
        SpearBtnData.Active = not SpearBtnData.Active
        if SpearBtnData.Active then
            SpearBtnData.Button.BackgroundColor3 = Color3.fromRGB(10, 40, 10)
            SpearBtnData.Button.TextColor3 = Color3.fromRGB(80, 255, 120)
            spearStk.Color = Color3.fromRGB(80, 255, 120)
            pcall(VD_Notify, "Spear Aimbot", "Spear Aimbot AKTIF!", 3)
        else
            SpearBtnData.Button.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
            SpearBtnData.Button.TextColor3 = Color3.fromRGB(255, 100, 100)
            spearStk.Color = Color3.fromRGB(255, 80, 80)
            pcall(VD_Notify, "Spear Aimbot", "Spear Aimbot NONAKTIF", 3)
        end
    end)
    
    print("[KysHub] Spear Aimbot Button created successfully")
end

task.spawn(function()
    task.wait(3)
    setupSpearAimbotBtn()
end)

function UpdateMobileFOV()
    if not getgenv().KYS_MobileGui.FOVFrame then return end
    if VD.AIM_Enabled and VD.AIM_ShowFOV then
        local r = (VD.AIM_FOV or 120)
        getgenv().KYS_MobileGui.FOVFrame.Size = UDim2.new(0, r*2, 0, r*2)
        getgenv().KYS_MobileGui.FOVStroke.Color = State.AimTarget and Color3.fromRGB(90,220,120) or Color3.fromRGB(220,70,70)
        getgenv().KYS_MobileGui.FOVFrame.Visible = true
    else
        getgenv().KYS_MobileGui.FOVFrame.Visible = false
    end
end

task.spawn(function()
    task.wait(2)
    pcall(CreateMobileUI)
end)

-- =====================================================
-- RENDER LOOP: PC (RenderStepped, pakai Drawing)
-- =====================================================
if DrawingAvailable then
    RunService.RenderStepped:Connect(OnRenderStep)
end
RunService.RenderStepped:Connect(function()
    pcall(VD_RunCrosshairLoop)
end)

-- =====================================================
-- HEARTBEAT UNIVERSAL: Berjalan di PC & Mobile
-- =====================================================
RunService.Heartbeat:Connect(function(deltaTime)
    if VD.Destroyed then return end
    local cam = workspace.CurrentCamera
    if not cam then return end



    if not DrawingAvailable and (not getgenv().KYS_MobileGui.FOVFrame or not getgenv().KYS_MobileGui.FOVFrame.Parent) then
        pcall(CreateMobileUI)
    end

    if not DrawingAvailable then
        UpdateCameraFOV()
        UpdateThirdPerson()
        UpdateShiftLock()
        pcall(UpdateSpearAim)
    end
    if not DrawingAvailable and VD.AIM_Enabled and State.AimHolding then
        local sc = cam.ViewportSize
        pcall(function() Aimbot.Update(cam, sc, Vector2.new(sc.X/2, sc.Y/2)) end)
    end


    if not DrawingAvailable then
        if getgenv().KYS_MobileGui.AimBtn then getgenv().KYS_MobileGui.AimBtn.Visible = VD.AIM_Enabled end
        pcall(UpdateMobileFOV)
    end
    -- Spear Aimbot button: always update (works on all executors)
    if SpearBtnData and SpearBtnData.Button then
        local spearVisible = (VD.SPEAR_Aimbot and GetRole() == "Killer")
        SpearBtnData.Button.Visible = spearVisible
        if spearVisible then pcall(UpdateSpearTargetLabel) end
    end
    pcall(UpdateRadar)
    pcall(VD_RunAntiKnock)
    pcall(VD_UpdateSurvivorWarnings)
    pcall(VD_UpdateBypassGate)
    pcall(VD_UpdateInfiniteLunge)
    pcall(VD_UpdateWeatherAnchor)
    pcall(VD_UpdateInvisibleNotVisual)
    pcall(VD_UpdateMoonwalk, deltaTime)
    pcall(VD_UpdateRemovePalletwrong)
end)

-- =====================================================
getgenv().KYS_SyncLoadedFeatures = function()

    -- Sync Killer Modifiers
    if type(SetupAntiBlind) == "function" then pcall(SetupAntiBlind) end
    if type(SetupNoPalletStun) == "function" then pcall(SetupNoPalletStun) end
    if type(VD_UpdateCrosshair) == "function" then pcall(VD_UpdateCrosshair) end
    
    -- Sync Kyst Killer Display
    if VD.VIS_KystKiller then
        pcall(StartKystKiller)
    else
        pcall(StopKystKiller)
    end

    -- Sync Spectator Counter
    if VD.VIS_SpectatorCounter then
        pcall(StartSpectatorCounter)
    else
        pcall(StopSpectatorCounter)
    end

    -- Sync Killer Perks Display
    if VD.VIS_KillerPerks then
        pcall(StartKillerPerksDisplay)
    else
        pcall(StopKillerPerksDisplay)
    end

    -- Sync Predict Map
    if VD.VIS_PredictMap then
        pcall(StartPredictMap)
    else
        pcall(StopPredictMap)
    end

    -- Sync Hide Survivor Icon
    if getgenv().KYS_SetHideSurvivorIcon then
        pcall(getgenv().KYS_SetHideSurvivorIcon, VD.VIS_HideSurvivorIcon)
    end

    -- Sync Ping & FPS Display
    if getgenv().KYS_SetShowPingFPS then
        pcall(getgenv().KYS_SetShowPingFPS, VD.VIS_ShowPingFPS)
    end

    -- Sync Hook Counter
    if getgenv().KYS_SetShowHookCounter then
        pcall(getgenv().KYS_SetShowHookCounter, VD.VIS_ShowHookCounter)
    end

    -- Sync Twist of Fate silent aim
    if getgenv().KYS_SetToFSilentAim then
        pcall(getgenv().KYS_SetToFSilentAim, VD.TOF_SilentAim)
    end

    -- Sync Flashlight silent aim
    if getgenv().KYS_SetFlashlightSilentAim then
        pcall(getgenv().KYS_SetFlashlightSilentAim, VD.FLASH_SilentAim)
    end

    -- Sync Moonwalk external button
    if getgenv().VD_SetMoonwalkButtonVisible then
        pcall(getgenv().VD_SetMoonwalkButtonVisible, VD.MoonwalkButton)
    end

    -- Sync Hidden Cooldown Bypass
    if VD.KILLER_BypassLeap then
        pcall(KYS_StartHiddenCooldownBypass)
    end
end

;(function()
local function readConfigElementValue(flagName)
    local elem = Window and Window.ConfigElements and Window.ConfigElements[flagName]
    if not elem then return nil end

    local ok, value = pcall(function()
        if type(elem.Get) == "function" then return elem:Get() end
        if type(elem.GetValue) == "function" then return elem:GetValue() end
        if elem.Value ~= nil then return elem.Value end
        if elem.CurrentValue ~= nil then return elem.CurrentValue end
        if elem.State ~= nil then return elem.State end
        if elem.Enabled ~= nil then return elem.Enabled end
        if elem.Default ~= nil then return elem.Default end
        if type(elem.Config) == "table" then
            if elem.Config.Value ~= nil then return elem.Config.Value end
            if elem.Config.Default ~= nil then return elem.Config.Default end
        end
    end)

    if ok then return value end
    return nil
end

getgenv().KYS_SyncUILibraryConfigRuntime = function()
    local tofValue = readConfigElementValue("Silent Aim Twist Of Fate")
    if type(tofValue) == "boolean" and tofValue ~= VD.TOF_SilentAim and getgenv().KYS_SetToFSilentAim then
        pcall(getgenv().KYS_SetToFSilentAim, tofValue)
    elseif type(tofValue) == "boolean" then
        VD.TOF_SilentAim = tofValue
        if tofValue and getgenv().KYS_SetToFSilentAim then
            pcall(getgenv().KYS_SetToFSilentAim, true)
        end
    end

    local flashValue = readConfigElementValue("Silent Aim Flashlight")
    if type(flashValue) == "boolean" and flashValue ~= VD.FLASH_SilentAim and getgenv().KYS_SetFlashlightSilentAim then
        pcall(getgenv().KYS_SetFlashlightSilentAim, flashValue)
    elseif type(flashValue) == "boolean" then
        VD.FLASH_SilentAim = flashValue
        if flashValue and getgenv().KYS_SetFlashlightSilentAim then
            pcall(getgenv().KYS_SetFlashlightSilentAim, true)
        end
    end
end

task.spawn(function()
    local lastToF, lastFlash = nil, nil
    while getgenv().VD and not getgenv().VD.Destroyed do
        local tofValue = readConfigElementValue("Silent Aim Twist Of Fate")
        local flashValue = readConfigElementValue("Silent Aim Flashlight")

        if type(tofValue) == "boolean" and tofValue ~= lastToF then
            lastToF = tofValue
            if getgenv().KYS_SetToFSilentAim then
                pcall(getgenv().KYS_SetToFSilentAim, tofValue)
            else
                VD.TOF_SilentAim = tofValue
            end
        end

        if type(flashValue) == "boolean" and flashValue ~= lastFlash then
            lastFlash = flashValue
            if getgenv().KYS_SetFlashlightSilentAim then
                pcall(getgenv().KYS_SetFlashlightSilentAim, flashValue)
            else
                VD.FLASH_SilentAim = flashValue
            end
        end

        task.wait(1)
    end
end)
end)();
end
__KysHub_Init_Main__()
