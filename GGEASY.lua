local AvatarChatService = game:GetService("AvatarChatService")
repeat wait() until AvatarChatService:GetAttribute("Enabled") == "KUYRAIINAHEE"
AvatarChatService:SetAttribute("Enabled", nil)

local Debug = true

local ProjectName = "Prospecting"

local UiName = "WindUI"
_G.BreakAllFunction = false

for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do 
	if v:IsA("ScreenGui") and v.Name == UiName then 
		v:Destroy()
		_G.BreakAllFunction = true
	end 
end 

task.wait(1)
_G.BreakAllFunction = false 


local _Blank = function() end
local Debug_Log = function(...) if Debug then print(...) end end 

local game = game
local Collection = {}; Collection.__index = Collection
local function getService(service)
	return game:GetService(service); -- create service return stuff
end
local Services = setmetatable({}, {
	__index = function(_, k) 
		return getService(k)
	end
})

---------------------------------------------- [ Exploits Variables ] ----------------------------------------------

_sethiddenproperty = sethiddenproperty or set_hidden_property or set_hidden_prop
_gethiddenproperty = gethiddenproperty or get_hidden_property or get_hidden_prop
_setsimulationradius = setsimulationradius or set_simulation_radius
_clone_function_ = clonefunction or clone_function or function(...) return ... end

_queue_on_teleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
_http_request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
_getcustomasset = (syn and getsynasset) or getcustomasset
local IsWave = getexecutorname and getexecutorname():find("Wave")

--------------------------- [[ Services ]] ---------------------------

local JobId = tostring(game.JobId)
local PlaceId = tonumber(game.PlaceId);
local TweenService = Services.TweenService
local VirtualUser = Services.VirtualUser
local UserInputService = Services.UserInputService
local ReplicatedStorage = Services.ReplicatedStorage
local CoreGui = Services.CoreGui
local TeleportService = Services.TeleportService
local Lighting = Services.Lighting
local HttpService = Services.HttpService
local PathfindingService = Services.PathfindingService
local RunService = Services.RunService
local CollectionService = Services.CollectionService
local Teams = Services.Teams
local GuiService = Services.GuiService
local Players = Services.Players
local CurrentCamera = workspace.CurrentCamera
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
local Camera = workspace:FindFirstChildOfClass("Camera")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Mobile = false

local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

local IsLoaded = false

local filename = "VyseHub/SaveSettings/" .. ProjectName.."/" .. tostring(game.Players.LocalPlayer.Name) ..".json"

local FunctionTask = {}
local SaveSettings = {}
getgenv().SaveSettings = SaveSettings or {}

function Collection:Load()
	if readfile and writefile and isfile and isfolder then
		if not isfolder("VyseHub") then
			makefolder("VyseHub")
		end
		if not isfolder("VyseHub/SaveSettings") then
			makefolder("VyseHub/SaveSettings")
		end
		if not isfolder("VyseHub/SaveSettings/" .. ProjectName) then
			makefolder("VyseHub/SaveSettings/" .. ProjectName)
		end
		if not isfile(filename) then
			writefile(filename, HttpService:JSONEncode(SaveSettings))
		else
			local fileContent = readfile(filename)
			-- print("File content:", fileContent) -- Debugging print

			local success, Decode = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)

			if not success then
				warn("Failed to parse JSON. Check the content of the file:", filename)
				return false -- Early exit if JSON is invalid
			end

			for i, v in pairs(Decode) do
				SaveSettings[i] = v
			end
			for i,v in pairs(SaveSettings) do 
				SaveSettings[i] = v
			end 
		end
	else
		warn("[VyseHub] Failed to load script... (Please Contact Admins)")
		return false
	end
end

function Collection:Save()
	if readfile and writefile and isfile then
		if not isfile(filename) then
			Collection:Load()
		else
			local fileContent = readfile(filename)
			-- print("File content before saving:", fileContent) -- Debugging print

			local success, Decode = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)

			if not success then
				warn("Failed to parse JSON while saving. Check the content of the file:", filename)
				return false -- Early exit if JSON is invalid
			end

			local Array = {}
			for i, v in pairs(SaveSettings) do
				Array[i] = v
			end
			writefile(filename, HttpService:JSONEncode(Array))
		end
	else
		warn("[VyseHub] Failed to save")
		return false
	end
end

Collection:Load()


local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
	Title = "Vyse Hub | "..ProjectName,
	Icon = "door-open",
	IconThemed = true,
	Author = "",
	Folder = "Vyse-Hub",
	Size = UDim2.fromOffset(580, 460),
	-- KeySystem = {
	--     Key = { "1234", "5678" },
	--     Note = "The Key is '1234' or '5678",
	--     URL = "https://github.com/Footagesus/WindUI",
	--     SaveKey = true,
	-- },
	User = {
		Enabled = true, -- <- or false
		Callback = function() print("clicked") end, -- <- optional
		Anonymous = true -- <- or true
	},
	ScrollBarEnabled = true,
	Transparent = true,
	Theme = "Dark",
	SideBarWidth = 200,
	HasOutline = false,
})


--- About UI ---

function Collection:AddToggle(Path,Title,Default)
	-- Configuration = {
	--  Title = "Enable Feature",
	--  Default = true,
	--  Callback = function(state) print("Feature enabled: " .. tostring(state)) end
	-- }
	local value 
	if _G.Configs and _G.Configs[Title] then 
		value = _G.Configs[Title]
		SaveSettings[Title] = _G.Configs[Title]
	else 
		if SaveSettings[Title] then 
			value = SaveSettings[Title]
		else 
			value = Default
		end 

	end 

	local Toggles_ = Path:Toggle(
		{
			Title = Title,
			Value = value,
			Callback = function(state) 
				if state == true and Title == "Reduce CPU" then 
					for i,v in pairs(game.Workspace:GetDescendants()) do 
						if v:IsA("ParticleEmitter") then 
							v:Destroy()
						end 
					end 
					task.spawn(function()
						for i,v in pairs(game.Workspace:GetDescendants()) do 
							if v:IsA("ParticleEmitter") then 
								v:Destroy()
							end 
						end 
						UserSettings():GetService("UserGameSettings").MasterVolume = 0
						UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1

						function Collection:TextureLow()
							-- ApLocalPlayer changes to the existing environment
							local g = game
							local w = g.Workspace
							local l = g:GetService"Lighting"
							local t = w:WaitForChild"Terrain"

							t.WaterWaveSize = 0
							t.WaterWaveSpeed = 0
							t.WaterReflectance = 0
							t.WaterTransparency = 1
							l.GlobalShadows = false
							-- Function to change object properties
							function change(v)
								pcall(function()
									if v.Material ~= Enum.Material.SmoothPlastic then
										pcall(function() v.Reflectance = 0 end)
										pcall(function() v.Material = Enum.Material.SmoothPlastic end)
										pcall(function() v.TopSurface = Enum.SurfaceType.SmoothNoOutlines end)
									end
								end)
							end

							-- ApLocalPlayer changes to new objects added to the game
							game.DescendantAdded:Connect(function(v)
								pcall(function()
									if v:IsA"Part" then change(v)
									elseif v:IsA"MeshPart" then change(v)
									elseif v:IsA"TrussPart" then change(v)
									elseif v:IsA"UnionOperation" then change(v)
									elseif v:IsA"CornerWedgePart" then change(v)
									elseif v:IsA"WedgePart" then change(v) end
								end)
							end)

							-- ApLocalPlayer changes to all existing descendants
							for i, v in pairs(game:GetDescendants()) do
								pcall(function()
									if v:IsA"Part" then change(v)
									elseif v:IsA"MeshPart" then change(v)
									elseif v:IsA"TrussPart" then change(v)
									elseif v:IsA"UnionOperation" then change(v)
									elseif v:IsA"CornerWedgePart" then change(v)
									elseif v:IsA"WedgePart" then change(v) end
								end)
							end
						end

						Collection:TextureLow()

						while true do
							if _G.BreakAllFunction then break end
							pcall(function()
								for _, obj in pairs(game.Players:GetDescendants()) do
									if obj:IsA("ParticleEmitter") then

										-- ตั้งค่าคุณสมบัติต่างๆ ของ ParticleEmitter เป็น 0
										obj.Enabled = false
										obj.Rate = 0
										obj.Lifetime = NumberRange.new(0)
										obj.Speed = NumberRange.new(0)
										obj.Rotation = NumberRange.new(0)
										obj.Size = NumberSequence.new(0)
										obj.Transparency = NumberSequence.new(1)  -- ทำให้โปร่งใสเต็มที่ (ไม่มองเห็น)
										-- สามารถเพิ่มคุณสมบัติอื่นๆ ตามความจำเป็น
										--print(obj:GetFullName() .. " has been set to zero.")  -- พิมพ์เส้นทางของอ็อบเจค
									end
									task.wait(0)
								end
								for _, obj in pairs(workspace:GetDescendants()) do
									if obj:IsA("ParticleEmitter") then

										-- ตั้งค่าคุณสมบัติต่างๆ ของ ParticleEmitter เป็น 0
										obj.Enabled = false
										obj.Rate = 0
										obj.Lifetime = NumberRange.new(0)
										obj.Speed = NumberRange.new(0)
										obj.Rotation = NumberRange.new(0)
										obj.Size = NumberSequence.new(0)
										obj.Transparency = NumberSequence.new(1)  -- ทำให้โปร่งใสเต็มที่ (ไม่มองเห็น)
										-- สามารถเพิ่มคุณสมบัติอื่นๆ ตามความจำเป็น
										--print(obj:GetFullName() .. " has been set to zero.")  -- พิมพ์เส้นทางของอ็อบเจค
									end
									task.wait(0)
								end
							end)
							task.wait(0)
						end
					end)
				end 
				SaveSettings[Title] = state
				Collection:Save()
			end
		}
	)

	return Toggles_
end

function Collection:AddDropdown(Path,Title,Values,Default,Multi)

	if _G.Configs and _G.Configs[Title] then
		SaveSettings[Title] = _G.Configs[Title]
	else 
		if not SaveSettings[Title] then 
			SaveSettings[Title] = Default
			Collection:Save()
		end 
	end 

	local Dropdown_ = Path:Dropdown(
		{
			Title = Title,
			Values = Values,
			Value = _G.Configs and _G.Configs[Title] or SaveSettings[Title] or Default,
			Multi = Multi,
			AllowNone = true,
			Callback = function(option) 
				SaveSettings[Title] = option
				Collection:Save()
			end
		}
	)


	Collection:Save()
	return Dropdown_
end
function Collection:AddInput(Path,Title,Default,Placeholder)

	if _G.Configs and _G.Configs[Title] then
		SaveSettings[Title] = _G.Configs[Title]
	else 
		if not SaveSettings[Title] then 
			SaveSettings[Title] = Default
			Collection:Save()
		end 
	end 
	local Input = Path:Input(
		{
			Title = Title,
			Value = _G.Configs and _G.Configs[Title] or SaveSettings[Title] or Default,
			PlaceholderText = Placeholder,
			Callback = function(input) 
				if Title == "Fps Cap" then 
					if not tonumber(input) then 
						Collection:Notify("Only Number Type")
					else 
						SaveSettings[Title] = tonumber(input)
						Collection:Save()
					end 

				else 
					SaveSettings[Title] = input
					Collection:Save()
				end 
			end
		}
	)


	Collection:Save()
	--Dropdown:Refresh(Value) -- {"Options 1","Options 2"}
	return Input
end

function Collection:AddSlider(Path,Title,Min,Max,Default)
	if _G.Configs and _G.Configs[Title] then
		SaveSettings[Title] = _G.Configs[Title]
	else 
		if not SaveSettings[Title] then 
			SaveSettings[Title] = Default
			Collection:Save()
		end 
	end 
	Path:Slider({
		Title = Title,
		Value = {
			Min = Min,
			Max = Max,
			Default = _G.Configs and _G.Configs[Title] or SaveSettings[Title] or Default,
		},
		Callback = function(value) 
			SaveSettings[Title] = value
			Collection:Save()  
		end
	})

	Collection:Save()
	--Dropdown:Refresh(Value) -- {"Options 1","Options 2"}
	return Path
end

----------------

local Main = Window:Tab({ Title = "Main", Icon = "toggle-left" })
local Misc = Window:Tab({ Title = "Miscellaneous", Icon = "fan" })
local PlayerTab = Window:Tab({ Title = "Players", Icon = "users" })
local Visuals = Window:Tab({ Title = "Visuals", Icon = "user-round-cog" })
local Teleport = Window:Tab({ Title = "Teleport", Icon = "clock-arrow-down" })
local Configs = Window:Tab({ Title = "Configs", Icon = "brain" })
Window:Divider()
local WindowTab = Window:Tab({ Title = "Window and File Configuration", Icon = "settings" })
local CreateThemeTab = Window:Tab({ Title = "Create Theme", Icon = "palette" })

Window:SelectTab(1)

Main:Section({ Title = "Auto Farm" })

Collection:AddToggle(Main,"Auto Farm",false)
Collection:AddDropdown(Main,"Auto Farm Settings",{"Auto Dig","Auto Shake"},{"Auto Dig","Auto Shake"},true)

Main:Divider()

local DigPos = SaveSettings["Dig Pos"]
local ShakePos = SaveSettings["Shake Pos"]
local AutoFarmStatus = Main:Paragraph({
	Title = "Auto Farm Status :",
	Desc = table.concat({
		(DigPos and "✅ Set, Dig Pos: " .. tostring(DigPos)) or "🟡 ❌ Not Set, Dig Pos",
		"",
		(ShakePos and "✅ Set, Shake Pos: " .. tostring(ShakePos)) or "🔵 ❌ Not Set, Shake Pos",
	}, "\n")
})
Main:Divider()

Main:Button({
	Title = "Set Dig Position",
	Desc = "Click to set your current position as Dig Position.",
	Callback = function()
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			SaveSettings["Dig Pos"] = tostring(hrp.Position)
			Collection:Save()
		end
	end,
})

Main:Button({
	Title = "Set Shake Position",
	Desc = "Click to set your current position as Shake Position.",
	Callback = function()
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			SaveSettings["Shake Pos"] = tostring(hrp.Position)
			Collection:Save()
		end
	end,
})

Main:Section({ Title = "Auto Sell" })

Collection:AddToggle(Main,"Auto Sell",false)
Collection:AddDropdown(Main,"Auto Sell Settings",{"Auto Sell When Max","Auto Sell With Time"},"Auto Sell When Max",false)
spawn(function()
	repeat task.wait()

	until SaveSettings["Auto Sell Settings"] == "Auto Sell With Time"
	Collection:AddSlider(Main,"Sell Time Interval (Min)",1,20,5)
end)

Main:Section({ Title = "Events" })

Collection:AddToggle(Main,"Auto Events",false)
Collection:AddDropdown(Main,"Auto Events Settings",{"SolarFlares","VolcanoRocks"},{"SolarFlares"},true)


Misc:Section({ Title = "Auto Lock" })
Collection:AddDropdown(Misc,"Auto Lock Settings",{"Raritys","Names"},{""},true)
spawn(function()
	repeat task.wait()
	until table.find(SaveSettings["Auto Lock Settings"],"Raritys")
	Collection:AddDropdown(Main,"Raritys",{"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"},{"Legendary"},true)
end)

spawn(function()
	repeat task.wait()
	until table.find(SaveSettings["Auto Lock Settings"],"Names")
	Collection.OreName = {}
	
	for i,v in pairs(game:GetService("ReplicatedStorage").Items.Valuables:GetChildren()) do 
		if v:IsA("Tool") then 
			table.insert(Collection.OreName,v.Name)
		end
	end
	Collection:AddDropdown(Main,"Names",Collection.OreName,{""},true)
end)

PlayerTab:Section({ Title = "Walk Speed" })

Collection:AddToggle(PlayerTab,"Walk Speed",false)
Collection:AddSlider(PlayerTab,"Speed",16,100,16)

PlayerTab:Section({ Title = "Jump Power" })

Collection:AddToggle(PlayerTab,"Jump Height",false)

Collection:AddSlider(PlayerTab,"Height",7,100,7)

PlayerTab:Section({ Title = "No-Clip" })

Collection:AddToggle(PlayerTab,"No-Clip",false)

Visuals:Section({ Title = "CPU" })

Collection:AddToggle(Visuals,"Reduce CPU",false)

Visuals:Section({ Title = "Core Gui Name" })

Collection:AddToggle(Visuals,"Protect Name",false)

Visuals:Section({ Title = "Game" })

Collection:AddToggle(Visuals,"Fps Lock",false)

Collection:AddInput(Visuals,"Fps Cap",240,"Enter Fps Number")

Collection:AddToggle(Visuals,"White Screen",false)

Visuals:Button({
	Title = "Rejoin Server",
	Desc = "If you click this button, You will rejoin the server.",
	Callback = function() 
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end,
})
Visuals:Button({
	Title = "Hop Server",
	Desc = "If you click this button, You will hop the server.",
	Callback = function() 
		local PlaceID = game.PlaceId
		local AllIDs = {}
		local foundAnything = ""
		local actualHour = os.date("!*t").hour
		local Deleted = false
		local File = pcall(function()
			AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
		end)
		if not File then
			table.insert(AllIDs, actualHour)
			writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
		end
		function TPReturner()
			local Site;
			if foundAnything == "" then
				Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
			else
				Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
			end
			local ID = ""
			if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
				foundAnything = Site.nextPageCursor
			end
			local num = 0;
			for i,v in pairs(Site.data) do
				local Possible = true
				ID = tostring(v.id)
				if tonumber(v.maxPlayers) > tonumber(v.playing) then
					for _,Existing in pairs(AllIDs) do
						if num ~= 0 then
							if ID == tostring(Existing) then
								Possible = false
							end
						else
							if tonumber(actualHour) ~= tonumber(Existing) then
								local delFile = pcall(function()
									delfile("NotSameServers.json")
									AllIDs = {}
									table.insert(AllIDs, actualHour)
								end)
							end
						end
						num = num + 1
					end
					if Possible == true then
						table.insert(AllIDs, ID)
						wait()
						pcall(function()
							writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
							wait()
							game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
						end)
						wait(4)
					end
				end
			end
		end

		function Teleport()
			while wait() do
				pcall(function()
					TPReturner()
					if foundAnything ~= "" then
						TPReturner()
					end
				end)
			end
		end

		-- If you'd like to use a script before server hopping (Like a Automatic Chest collector you can put the Teleport() after it collected everything.
		Teleport()
	end,
})


Configs:Button({
	Title = "Generate Configs",
	Desc = "Before clicking, the script will generate your current function to configs.",
	Callback = function() 
		_G.Configs = {}
		local String = [[_G.Configs = {
]]

		for key, value in pairs(SaveSettings) do
			_G.Configs[key] = value
			local text = ('    ["%s"] = '):format(key)
			local value_text = ""
			local value_type = type(value)
			if value_type == "boolean" then
				value_text = tostring(value) .. ",\n"
			elseif value_type == "table" then
				value_text = "{\n       "
				for k, v in pairs(value) do
					value_text = value_text .. ('"%s",\n        '):format(tostring(v))
				end
				value_text:sub(1, -2)
				value_text = value_text .. "},\n"
			else
				value_text = ('"%s",\n'):format(tostring(value))
			end

			String = String .. text .. value_text
			task.wait()
		end

		String = String .. "}"

		setclipboard(String)
	end,
})



Collection.OnShake = false 
Collection.LastState = nil 
Collection.TweenSpeed = 150 

local Action = {
	["OnSolarFlares"] = false, 
	["OnVolcanoRocks"] = false,
}

function Collection:getCharacterTool()
	local char = LocalPlayer.Character
	return char and char:FindFirstChildOfClass("Tool")
end

local function StringToVector3(posString)
	local x, y, z = string.match(posString, "([^,]+),%s*([^,]+),%s*([^,]+)")
	if x and y and z then
		return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
	else
		warn("Invalid position string:", posString)
		return nil
	end
end

function Collection:isNear(pos1, pos2, threshold)
	return (pos1 - pos2).Magnitude <= threshold
end

function Collection:teleportTo(position)
	local char = LocalPlayer.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp or Collection:isNear(hrp.Position, position, 5) then return end

	local distance = (hrp.Position - position).Magnitude
	local duration = distance / Collection.TweenSpeed

	local tween = TweenService:Create(hrp, TweenInfo.new(
		duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out
		), {CFrame = CFrame.new(position)})

	tween:Play()
	tween.Completed:Wait()
end

function Collection:equipPanFromBackpack()
	for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
		if item:IsA("Tool") and item:GetAttribute("ItemType") == "Pan" then
			LocalPlayer.Character.Humanoid:EquipTool(item)
			break
		end
	end
end

function Collection:clickMouse(isPress)
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, isPress, game, 0)
end

function Collection:tryCollect(panScript)
	local collectResult = panScript:WaitForChild("Collect"):InvokeServer(1)
	return collectResult
end

function Collection:processShake(panScript)

	Collection.OnShake = true
	Collection:teleportTo(StringToVector3(SaveSettings["Shake Pos"]))
	panScript:WaitForChild("Pan"):InvokeServer()
	panScript:WaitForChild("Shake"):FireServer()
end

function Collection:processDig(panScript)
	local digUI = LocalPlayer.PlayerGui:FindFirstChild("ToolUI")
	local digBarVisible = digUI and digUI:FindFirstChild("DigBar") and digUI.DigBar.Visible

	if not digBarVisible then
		Collection:clickMouse(true)
	else
		Collection:tryCollect(panScript)
	end
end


FunctionTask["Auto Farm"] = function()
	while true do
		if _G.BreakAllFunction then
			break
		end
		local Succ,Err = pcall(function()
			if SaveSettings["Auto Farm"] and not Action["OnSolarFlares"] and not Action["OnVolcanoRocks"] then

				local character = LocalPlayer.Character
				local stats = LocalPlayer:FindFirstChild("Stats")

				local tool = Collection:getCharacterTool()
				local isPan = tool and tool:GetAttribute("ItemType") == "Pan"
				local pan = isPan and tool or nil

				if pan then
					local panScript = pan:FindFirstChild("Scripts")

					local panFill = pan:GetAttribute("Fill") or 0
					local maxCapacity = stats:GetAttribute("Capacity") or math.huge
					local collectFunc = panScript:WaitForChild("Collect")

					if panFill >= maxCapacity or Collection.OnShake == true then
						if table.find(SaveSettings["Auto Farm Settings"],"Auto Shake") then
							if SaveSettings["Shake Pos"] then 
								Collection.OnShake = true
								Collection:teleportTo(StringToVector3(SaveSettings["Shake Pos"]))

								repeat task.wait(0.1)
									local collected = collectFunc:InvokeServer()
									panFill = pan:GetAttribute("Fill") or 0

									if collected == false or collected == nil then
										local digUI = LocalPlayer.PlayerGui:FindFirstChild("ToolUI")
										if digUI and digUI:FindFirstChild("DigBar") and digUI:FindFirstChild("DigBar").Visible then
											Collection:clickMouse(false)
										end

										Collection:processShake(panScript)
									end
								until panFill <= 0 or not SaveSettings["Auto Farm"] or Action["OnSolarFlares"] or Action["OnVolcanoRocks"]

								Collection.OnShake = false
							end

						end

					else
						if table.find(SaveSettings["Auto Farm Settings"],"Auto Dig") then
							if SaveSettings["Dig Pos"] then 
								if not Collection.OnShake then
									if collectFunc:InvokeServer() ~= true then
										Collection:teleportTo(StringToVector3(SaveSettings["Dig Pos"]))
									else
										Collection:processDig(panScript)
									end
								end
							end
						end
					end
				else
					Collection:equipPanFromBackpack()
				end

			end
		end)
		task.wait()
		if Err and Debug then
			warn("[Auto Farm] Caught Error: ",Err)
		end
	end
end

function Collection:GetOreAmount() 
	local count = 0 
	for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do 
		if v:IsA("Tool") and v:GetAttribute("ItemType") and v:GetAttribute("ItemType") == "Valuable" then 
			count += 1
		end
	end
	return count
end
FunctionTask["Auto Sell"] = function()
	local lastSellTime = 0
	while true do
		if _G.BreakAllFunction then
			break
		end
		local Succ,Err = pcall(function()
			if SaveSettings["Auto Sell"] then
				local currentTime = tick()
				if SaveSettings["Auto Sell Settings"] == "Auto Sell When Max" then 
					if Collection:GetOreAmount() >= 500 then 
						ReplicatedStorage.Remotes.Shop.SellAll:FireServer()
					end
				end
				if SaveSettings["Auto Sell Settings"] == "Auto Sell With Time" then
					local interval = tonumber(SaveSettings["Sell Time Interval (Min)"]) or 1 
					if currentTime - lastSellTime >= interval * 60 then
						ReplicatedStorage.Remotes.Shop.SellAll:FireServer()
						lastSellTime = currentTime
					end
				end

			end 
		end)
		task.wait()
		if Err and Debug then
			warn("[Auto Sell] Caught Error: ",Err)
		end
	end
end

local function getNearestSolarFlare()
	local character = LocalPlayer.Character
	if not character then return nil end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local closestPart = nil
	local shortestDistance = math.huge

	for _, part in pairs(workspace.Map.EventStuff.SolarFlares:GetChildren()) do
		if part:IsA("BasePart") then
			local dist = (hrp.Position - part.Position).Magnitude
			if dist < shortestDistance then
				shortestDistance = dist
				closestPart = part
			end
		end
	end

	return closestPart
end

FunctionTask["Auto Events"] = function()
	while true do
		if _G.BreakAllFunction then break end
		local Succ,Err = pcall(function()
			if SaveSettings["Auto Events"] then
				if table.find(SaveSettings["Auto Events Settings"],"SolarFlares") then
					local solarFlares = workspace.Map.EventStuff.SolarFlares:GetChildren()
					if #solarFlares > 0 then 
						Action["OnSolarFlares"] = true 
					else 
						Action["OnSolarFlares"] = false
					end

					local nearestFlare = getNearestSolarFlare()
					if not nearestFlare then return end

					while SaveSettings["Auto Events"] and nearestFlare and nearestFlare.Parent do
						local character = LocalPlayer.Character
						local stats = LocalPlayer:FindFirstChild("Stats")

						local tool = Collection:getCharacterTool()
						local isPan = tool and tool:GetAttribute("ItemType") == "Pan"
						local pan = isPan and tool or nil

						if pan then
							local panScript = pan:FindFirstChild("Scripts")
							local panFill = pan:GetAttribute("Fill") or 0
							local maxCapacity = stats:GetAttribute("Capacity") or math.huge
							local collectFunc = panScript:WaitForChild("Collect")

							if panFill >= maxCapacity or Collection.OnShake == true then
								if SaveSettings["Shake Pos"] then
									Collection.OnShake = true
									Collection:teleportTo(StringToVector3(SaveSettings["Shake Pos"]))

									repeat task.wait(0.1)
										local collected = collectFunc:InvokeServer()
										panFill = pan:GetAttribute("Fill") or 0

										if collected == false or collected == nil then
											local digUI = LocalPlayer.PlayerGui:FindFirstChild("ToolUI")
											if digUI and digUI:FindFirstChild("DigBar") and digUI.DigBar.Visible then
												Collection:clickMouse(false)
											end

											Collection:processShake(panScript)
										end
									until panFill <= 0 or not SaveSettings["Auto Events"]
									Collection.OnShake = false
								end
							else
								if not Collection.OnShake then
									if collectFunc:InvokeServer() ~= true then
										Collection:teleportTo(nearestFlare.Position)
									else
										Collection:processDig(panScript)
									end
								end
							end
						else
							Collection:equipPanFromBackpack()
						end
						task.wait()
					end
				end
			end
		end)
		task.wait()
		if Err and Debug then
			warn("[Auto Events] Caught Error: ",Err)
		end
	end
end


FunctionTask["Auto Lock"] = function()
	while true do
		if _G.BreakAllFunction then
			break
		end
		local Succ,Err = pcall(function()
			if SaveSettings["Auto Lock"] then
				if table.find(SaveSettings["Auto Lock Settings"],"Raritys") then 
					for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do 
						if v:IsA("Tool") and v:GetAttribute("ItemType") and v:GetAttribute("ItemType") == "Valuable" and v:GetAttribute("Rarity") then
							if table.find(SaveSettings["Raritys"],tostring(v:GetAttribute("Rarity"))) then

								ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Inventory"):WaitForChild("ToggleLock"):FireServer(v)

							end
						end
					end
				elseif table.find(SaveSettings["Auto Lock Settings"],"Names") then 
					for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do 
						if v:IsA("Tool") and v:GetAttribute("ItemType") and v:GetAttribute("ItemType") == "Valuable" and v:GetAttribute("Rarity") then
							if table.find(SaveSettings["Names"],v.Name) then

								ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Inventory"):WaitForChild("ToggleLock"):FireServer(v)

							end
						end
					end

				end
			end 
		end)
		task.wait()
		if Err and Debug then
			warn("[Auto Lock] Caught Error: ",Err)
		end
	end
end

FunctionTask["Walk Speed"] = function()
	local W, A, S, D
	local xVelo, yVelo
	while true do
		if _G.BreakAllFunction then
			break
		end

		local success, err = pcall(function()
			if SaveSettings["Walk Speed"] then
				
				local walkSpeed = SaveSettings["Speed"]
				local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart
				local C = game.Workspace.CurrentCamera
				local LV = C.CFrame.LookVector
				for i,v in pairs(UserInputService:GetKeysPressed()) do
					if v.KeyCode == Enum.KeyCode.W then
						W = true
					end
					if v.KeyCode == Enum.KeyCode.A then
						A = true
					end
					if v.KeyCode == Enum.KeyCode.S then
						S = true
					end
					if v.KeyCode == Enum.KeyCode.D then
						D = true
					end
				end

				if W == true and S == true then
					yVelo = false
					W,S = nil
				end

				if A == true and D == true then
					xVelo = false
					A,D = nil
				end

				if yVelo ~= false then
					if W == true then
						if xVelo ~= false then
							if A == true then
								local LeftLV = (C.CFrame * CFrame.Angles(0, math.rad(45), 0)).LookVector
								HRP.Velocity = Vector3.new((LeftLV.X * walkSpeed), HRP.Velocity.Y, (LeftLV.Z * walkSpeed))
								W,A = nil
							else
								if D == true then
									local RightLV = (C.CFrame * CFrame.Angles(0, math.rad(-45), 0)).LookVector
									HRP.Velocity = Vector3.new((RightLV.X * walkSpeed), HRP.Velocity.Y, (RightLV.Z * walkSpeed))
									W,D = nil
								end
							end
						end
					else
						if S == true then
							if xVelo ~= false then
								if A == true then
									local LeftLV = (C.CFrame * CFrame.Angles(0, math.rad(135), 0)).LookVector
									HRP.Velocity = Vector3.new((LeftLV.X * walkSpeed), HRP.Velocity.Y, (LeftLV.Z * walkSpeed))
									S,A = nil
								else
									if D == true then
										local RightLV = (C.CFrame * CFrame.Angles(0, math.rad(-135), 0)).LookVector
										HRP.Velocity = Vector3.new((RightLV.X * walkSpeed), HRP.Velocity.Y, (RightLV.Z * walkSpeed))
										S,D = nil
									end
								end
							end
						end
					end
				end

				if W == true then
					HRP.Velocity = Vector3.new((LV.X * walkSpeed), HRP.Velocity.Y, (LV.Z * walkSpeed))
				end
				if S == true then
					HRP.Velocity = Vector3.new(-(LV.X * walkSpeed), HRP.Velocity.Y, -(LV.Z * walkSpeed))
				end
				if A == true then
					local LeftLV = (C.CFrame * CFrame.Angles(0, math.rad(90), 0)).LookVector
					HRP.Velocity = Vector3.new((LeftLV.X * walkSpeed), HRP.Velocity.Y, (LeftLV.Z * walkSpeed))
				end
				if D == true then
					local RightLV = (C.CFrame * CFrame.Angles(0, math.rad(-90), 0)).LookVector
					HRP.Velocity = Vector3.new((RightLV.X * walkSpeed), HRP.Velocity.Y, (RightLV.Z * walkSpeed))
				end

				xVelo, yVelo, W, A, S, D = nil
		
			
			end
		end)

		if err and Debug then
			warn("[Walk Speed] Caught Error: ", err)
		end

		task.wait() 
	end
end

FunctionTask["Jump Height"] = function()
	while true do
		if _G.BreakAllFunction then
			break
		end

		local success, err = pcall(function()
			if SaveSettings["Jump Height"] then
				if LocalPlayer.Character:FindFirstChild("Humanoid") then 
					if LocalPlayer.Character:FindFirstChild("Humanoid").JumpHeight ~= SaveSettings["Height"] then
						LocalPlayer.Character:FindFirstChild("Humanoid").JumpHeight = SaveSettings["Height"]
					end  
				end 
			else 
				if LocalPlayer.Character:FindFirstChild("Humanoid") then 
					if LocalPlayer.Character:FindFirstChild("Humanoid").JumpHeight == SaveSettings["Height"] then
						LocalPlayer.Character:FindFirstChild("Humanoid").JumpHeight = 7.2
					end  
				end 
			end
		end)

		if err and Debug then
			warn("[Jump Height] Caught Error: ", err)
		end

		task.wait() 
	end
end

FunctionTask["Protect Name"] = function()
	while true do
		if _G.BreakAllFunction then
			break
		end
		local Succ,Err = pcall(function()
			if SaveSettings["Protect Name"] then
				if LocalPlayer.Character:FindFirstChild("Nametag") then 
					LocalPlayer.Character:FindFirstChild("Nametag"):Destroy()
				end
				if game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame["p_"..game.Players.LocalPlayer.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text ~= "Protected By Vyse Hub" then 
					game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame["p_"..game.Players.LocalPlayer.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text = "Protected By Vyse Hub"
				end
			else 
				if LocalPlayer.Character:FindFirstChild("Nametag") then 
					LocalPlayer.Character:FindFirstChild("Nametag"):Destroy()
				end
				if game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame["p_"..game.Players.LocalPlayer.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text == "Protected By Vyse Hub" then 
					game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame["p_"..game.Players.LocalPlayer.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text = LocalPlayer.DisplayName
				end
			end
		end)
		task.wait()
		if Err and Debug then
			warn("[Protect Name] Caught Error: ",Err)
		end
	end
end

if _G.Configs and _G.Configs["Reduce CPU"] then
	task.spawn(function()
		for i,v in pairs(game.Workspace:GetDescendants()) do 
			if v:IsA("ParticleEmitter") then 
				v:Destroy()
			end 
		end 
		UserSettings():GetService("UserGameSettings").MasterVolume = 0
		UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1

		function Collection:TextureLow()
			-- ApLocalPlayer changes to the existing environment
			local g = game
			local w = g.Workspace
			local l = g:GetService"Lighting"
			local t = w:WaitForChild"Terrain"

			t.WaterWaveSize = 0
			t.WaterWaveSpeed = 0
			t.WaterReflectance = 0
			t.WaterTransparency = 1
			l.GlobalShadows = false
			-- Function to change object properties
			function change(v)
				pcall(function()
					if v.Material ~= Enum.Material.SmoothPlastic then
						pcall(function() v.Reflectance = 0 end)
						pcall(function() v.Material = Enum.Material.SmoothPlastic end)
						pcall(function() v.TopSurface = Enum.SurfaceType.SmoothNoOutlines end)
					end
				end)
			end

			-- ApLocalPlayer changes to new objects added to the game
			game.DescendantAdded:Connect(function(v)
				pcall(function()
					if v:IsA"Part" then change(v)
					elseif v:IsA"MeshPart" then change(v)
					elseif v:IsA"TrussPart" then change(v)
					elseif v:IsA"UnionOperation" then change(v)
					elseif v:IsA"CornerWedgePart" then change(v)
					elseif v:IsA"WedgePart" then change(v) end
				end)
			end)

			-- ApLocalPlayer changes to all existing descendants
			for i, v in pairs(game:GetDescendants()) do
				pcall(function()
					if v:IsA"Part" then change(v)
					elseif v:IsA"MeshPart" then change(v)
					elseif v:IsA"TrussPart" then change(v)
					elseif v:IsA"UnionOperation" then change(v)
					elseif v:IsA"CornerWedgePart" then change(v)
					elseif v:IsA"WedgePart" then change(v) end
				end)
			end
		end

		Collection:TextureLow()

		while true do
			if Library.Unloaded or Collection.UnLoaded or Collection.BreakLoop then break end
			pcall(function()
				for _, obj in pairs(game.Players:GetDescendants()) do
					if obj:IsA("ParticleEmitter") then

						-- ตั้งค่าคุณสมบัติต่างๆ ของ ParticleEmitter เป็น 0
						obj.Enabled = false
						obj.Rate = 0
						obj.Lifetime = NumberRange.new(0)
						obj.Speed = NumberRange.new(0)
						obj.Rotation = NumberRange.new(0)
						obj.Size = NumberSequence.new(0)
						obj.Transparency = NumberSequence.new(1)  -- ทำให้โปร่งใสเต็มที่ (ไม่มองเห็น)
						-- สามารถเพิ่มคุณสมบัติอื่นๆ ตามความจำเป็น
						--print(obj:GetFullName() .. " has been set to zero.")  -- พิมพ์เส้นทางของอ็อบเจค
					end
					task.wait(0)
				end
				for _, obj in pairs(workspace:GetDescendants()) do
					if obj:IsA("ParticleEmitter") then

						-- ตั้งค่าคุณสมบัติต่างๆ ของ ParticleEmitter เป็น 0
						obj.Enabled = false
						obj.Rate = 0
						obj.Lifetime = NumberRange.new(0)
						obj.Speed = NumberRange.new(0)
						obj.Rotation = NumberRange.new(0)
						obj.Size = NumberSequence.new(0)
						obj.Transparency = NumberSequence.new(1)  -- ทำให้โปร่งใสเต็มที่ (ไม่มองเห็น)
						-- สามารถเพิ่มคุณสมบัติอื่นๆ ตามความจำเป็น
						--print(obj:GetFullName() .. " has been set to zero.")  -- พิมพ์เส้นทางของอ็อบเจค
					end
					task.wait(0)
				end
			end)
			task.wait(0)
		end
	end)
end


coroutine.wrap(function()
	while RunService.Stepped:wait() do
		local LogError = false
		if _G.BreakAllFunction then 
			break
		end

		local Success , err = pcall(function()
			local DigPos = SaveSettings["Dig Pos"]
			local ShakePos = SaveSettings["Shake Pos"]
			AutoFarmStatus:SetDesc(
				table.concat({
					(DigPos and "✅ Set, Dig Pos: " .. tostring(DigPos)) or "❌ Not Set, Dig Pos",
					"",
					(ShakePos and "✅ Set, Shake Pos: " .. tostring(ShakePos)) or "❌ Not Set, Shake Pos",
				}, "\n")
			)
			local Humanoid = Collection:GetHum(LocalPlayer.Character) 
			local Root = Collection:GetRoot(LocalPlayer.Character)
			if (SaveSettings["Auto Farm"] or SaveSettings["Auto Events"]) then
				local Humanoid = Collection:GetHum(LocalPlayer.Character) 
				local Root = Collection:GetRoot(LocalPlayer.Character)
				if false then
					if Humanoid then
						setfflag("HumanoidParallelRemoveNoPhysics", "False")
						setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
						Humanoid:ChangeState(11)
					end
				else
					for i, v in pairs(LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide == true then
							v.CanCollide = false
						end
					end
				end
				if not Root:FindFirstChild("KRNLONAIR")  then
					local KRNLONAIR = Instance.new("BodyVelocity")
					KRNLONAIR.Name = "KRNLONAIR"
					KRNLONAIR.MaxForce = Vector3.new(100000, 100000, 100000)
					KRNLONAIR.Velocity = Vector3.zero
					KRNLONAIR.Parent = Root
				end
			elseif Collection:GetRoot(LocalPlayer.Character):FindFirstChild("KRNLONAIR") then
				Collection:GetRoot(LocalPlayer.Character)["KRNLONAIR"]:Destroy()
			end
			if SaveSettings["White Screen"]  then 
				game:GetService("RunService"):Set3dRenderingEnabled(false)
			else 
				game:GetService("RunService"):Set3dRenderingEnabled(true)
			end
			if SaveSettings["Fps Lock"] and tonumber(SaveSettings["Fps Cap"]) then 
				pcall(setfpscap, tonumber(SaveSettings["Fps Cap"]))
				pcall(set_fps_cap, tonumber(SaveSettings["Fps Cap"]))
			else 
				pcall(setfpscap, 240)
				pcall(set_fps_cap, 240)
			end
			if sethiddenproperty then
				_sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
			end
			if SaveSettings["No-Clip"] then 
				local Humanoid = Collection:GetHum(LocalPlayer.Character) 
				local Root = Collection:GetRoot(LocalPlayer.Character)
				if false then
					if Humanoid then
						setfflag("HumanoidParallelRemoveNoPhysics", "False")
						setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
						Humanoid:ChangeState(11)
					end
				else
					for i, v in pairs(LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide == true then
							v.CanCollide = false
						end
					end
				end
			else 
				if false then
					if Humanoid then
						setfflag("HumanoidParallelRemoveNoPhysics", "True")
						setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "True")
						Humanoid:ChangeState(18)
					end
				else
					for i, v in pairs(LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") and (v.Name == "Head" or v.Name == "Torso") then
							v.CanCollide = true 
						end
					end
				end
			end 
		end)
		if err and LogError then
			warn("CAUGHT ERROR! : " .. err)
		end 
	end
end)()

for TaskName, TaskFunction in pairs(FunctionTask) do
	coroutine.wrap(function()
		repeat
			task.wait(1)
		until SaveSettings[TaskName] == true or (type(SaveSettings[TaskName]) == "table" and #SaveSettings[TaskName] > 0)

		print("Starting Task:", TaskName)  -- Debugging print
		TaskFunction()
	end)()
end

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Configuration

local HttpService = game:GetService("HttpService")

local folderPath = "WindUI"
makefolder(folderPath)

local function SaveFile(fileName, data)
	local filePath = folderPath .. "/" .. fileName .. ".json"
	local jsonData = HttpService:JSONEncode(data)
	writefile(filePath, jsonData)
end

local function LoadFile(fileName)
	local filePath = folderPath .. "/" .. fileName .. ".json"
	if isfile(filePath) then
		local jsonData = readfile(filePath)
		return HttpService:JSONDecode(jsonData)
	end
end

local function ListFiles()
	local files = {}
	for _, file in ipairs(listfiles(folderPath)) do
		local fileName = file:match("([^/]+)%.json$")
		if fileName then
			table.insert(files, fileName)
		end
	end
	return files
end

WindowTab:Section({ Title = "Window" })

local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
	table.insert(themeValues, name)
end

local themeDropdown = WindowTab:Dropdown({
	Title = "Select Theme",
	Multi = false,
	AllowNone = false,
	Value = nil,
	Values = themeValues,
	Callback = function(theme)
		WindUI:SetTheme(theme)
	end
})
themeDropdown:Select(WindUI:GetCurrentTheme())

local ToggleTransparency = WindowTab:Toggle({
	Title = "Toggle Window Transparency",
	Callback = function(e)
		Window:ToggleTransparency(e)
	end,
	Value = WindUI:GetTransparency()
})

WindowTab:Section({ Title = "Save" })

local fileNameInput = ""
WindowTab:Input({
	Title = "Write File Name",
	PlaceholderText = "Enter file name",
	Callback = function(text)
		fileNameInput = text
	end
})

WindowTab:Button({
	Title = "Save File",
	Callback = function()
		if fileNameInput ~= "" then
			SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
		end
	end
})

WindowTab:Section({ Title = "Load" })

local filesDropdown
local files = ListFiles()

filesDropdown = WindowTab:Dropdown({
	Title = "Select File",
	Multi = false,
	AllowNone = true,
	Values = files,
	Callback = function(selectedFile)
		fileNameInput = selectedFile
	end
})

WindowTab:Button({
	Title = "Load File",
	Callback = function()
		if fileNameInput ~= "" then
			local data = LoadFile(fileNameInput)
			if data then
				WindUI:Notify({
					Title = "File Loaded",
					Content = "Loaded data: " .. HttpService:JSONEncode(data),
					Duration = 5,
				})
				if data.Transparent then 
					Window:ToggleTransparency(data.Transparent)
					ToggleTransparency:SetValue(data.Transparent)
				end
				if data.Theme then WindUI:SetTheme(data.Theme) end
			end
		end
	end
})

WindowTab:Button({
	Title = "Overwrite File",
	Callback = function()
		if fileNameInput ~= "" then
			SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
		end
	end
})

WindowTab:Button({
	Title = "Refresh List",
	Callback = function()
		filesDropdown:Refresh(ListFiles())
	end
})

local currentThemeName = WindUI:GetCurrentTheme()
local themes = WindUI:GetThemes()

local ThemeAccent = themes[currentThemeName].Accent
local ThemeOutline = themes[currentThemeName].Outline
local ThemeText = themes[currentThemeName].Text
local ThemePlaceholderText = themes[currentThemeName].PlaceholderText

function updateTheme()
	WindUI:AddTheme({
		Name = currentThemeName,
		Accent = ThemeAccent,
		Outline = ThemeOutline,
		Text = ThemeText,
		PlaceholderText = ThemePlaceholderText
	})
	WindUI:SetTheme(currentThemeName)
end

local CreateInput = CreateThemeTab:Input({
	Title = "Theme Name",
	Value = currentThemeName,
	Callback = function(name)
		currentThemeName = name
	end
})

CreateThemeTab:Colorpicker({
	Title = "Background Color",
	Default = Color3.fromHex(ThemeAccent),
	Callback = function(color)
		ThemeAccent = color:ToHex()
	end
})

CreateThemeTab:Colorpicker({
	Title = "Outline Color",
	Default = Color3.fromHex(ThemeOutline),
	Callback = function(color)
		ThemeOutline = color:ToHex()
	end
})

CreateThemeTab:Colorpicker({
	Title = "Text Color",
	Default = Color3.fromHex(ThemeText),
	Callback = function(color)
		ThemeText = color:ToHex()
	end
})

CreateThemeTab:Colorpicker({
	Title = "Placeholder Text Color",
	Default = Color3.fromHex(ThemePlaceholderText),
	Callback = function(color)
		ThemePlaceholderText = color:ToHex()
	end
})

CreateThemeTab:Button({
	Title = "Update Theme",
	Callback = function()
		updateTheme()
	end
})

