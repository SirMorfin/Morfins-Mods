print("executed")
local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = library.subs.Wait -- Only returns if the GUI has not been terminated. For 'while Wait() do' loops

local connections = {}
lyrics = [[We’re no strangers to love,
			You know the rules and so do I.
			A full commitment’s what I’m thinking of,
			You wouldnt get this from any other guy.
			I just wanna tell you how I’m feeling,
			Gotta make you understand…
			Never gonna give you up,
			Never gonna let you down,
			Never gonna run around and desert you.
			Never gonna make you cry,
			Never gonna say goodbye,
			Never gonna tell a lie and hurt you.
			We’ve known each other for so long
			Your heart’s been aching
			But you’re too shy to say it.
			Inside we both know what’s been going on,
			We know the game and we’re gonna play it.
			Annnnnd if you ask me how I’m feeling,
			Don’t tell me you’re too blind to see…
			Never gonna give you up,
			Never gonna let you down,
			Never gonna run around and desert you.]]


			
local function n(p, name)
	local args = {
		[1] = p .. "",
		[2] = name or ""
	}
				
	game:GetService("ReplicatedStorage"):WaitForChild("newsbroadcast"):FireServer(unpack(args))
end


local PepsisWorld = library:CreateWindow({
Name = "Morfin's Mods",
Themeable = {
Info = "GUI By Morfin",
Background = 0,
Credit = true,
Theme = {
    Main = Color3.new(1, 0.5, 0)
}
}
})
local GeneralTab = PepsisWorld:CreateTab({
Name = "General"
})

local Config = GeneralTab:CreateSection({
	Name = "Config"
})
Config:AddSlider({
    Name = "Refresh Delay",
    Value = 0.1,
    Flag = "Refresh",
    Min = 0,
    Max = 0.5,
    --Decimals = 0.03
})
local PAura = GeneralTab:CreateSection({
Name = "Paint Aura"
})

PAura:AddLabel({
    Text = "WARNING: May cause high ping."
})
PAura:AddToggle({
Name = "Toggled",
Flag = "PAura"
})

Config:AddColorpicker({
    Name = "Paint Color",
    Value = "random",
    Flag = "PaintColor",
    Callback = function(a)
    end
})

PAura:AddSlider({
    Name = "Range",
    Value = 10,
    Flag = "PAuraRange",
    Min = 0,
    Max = 1000
})

local MapClaim = GeneralTab:CreateSection({
	Name = "Claim Land",
	Text = ""
})

MapClaim:AddLabel({
	Text = "Hold down the 'P' key and click on a color to automatically claim all territories of that color"
})
MapClaim:AddToggle({
	Name = "Toggled",
	Flag = "MapClaim"
})

MapClaim:AddButton({
	Name = "Reset Land",
	Callback = function()
		connections = {}
	end
})

local News = GeneralTab:CreateSection({
	Name = "News"
})

News:AddButton({
	Name = "Rickroll Server",
	Callback = function()
		l = string.split(lyrics, "\n")
		for _, line in pairs(l) do
			str = ""
			line = string.split(line, " ")
			for _, word in pairs(line) do
				str = str .. " " .. word
				n(str, "Rick")
				wait(#word/12)
			end
			wait(0.15)
		end
	end
})

--[[
Nametags:AddToggle({
    Name = "Nametag Spam",
    Flag = "NametagSpam",
})
local Misc = GeneralTab:CreateSection({
    Name = "Misc",
})
Misc:AddToggle({
    Name = "Autoclicker(Paint Tool)",
    Flag = "Autoclicker",
    Callback = function(v)
        if v then
            library.signals.AC = game.Players.LocalPlayer:GetMouse().Move:connect(function()
                print(game.Players.LocalPlayer:GetMouse().Target)
            end)
        else
            if library.signals.AC then
                library.signals.AC:Disconnect()
            end
        end
    end
})
]]
--scripts

local plr = game.Players.LocalPlayer
local r = 100


local part = Instance.new("Part")
--[[
part.Anchored = true
part.Parent = game.workspace
part.CanCollide = false
part.Transparency = 1
part.CFrame = plr.Character.PrimaryPart.CFrame
]]
print("a")

local mouse = game.Players.LocalPlayer:GetMouse()

local function isInTable(p)
    for i, v in pairs(connections) do
        if v == p then
            return i
        end
    end
end
mouse.Button1Up:Connect(function()
    if mouse.Target.Name == "Province" and library.flags["MapClaim"] then
        local bool = isInTable(mouse.Target)
        if bool ~= nil then
            table.remove(connections, bool)
        else
            table.insert(connections, mouse.Target)
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.P) then
            	for i, v in pairs(game.Workspace.Map:GetChildren()) do
                	if v.Color == mouse.Target.Color and ((v.Position - mouse.Target.Position).Magnitude < 250) and v.Name == "Province" then
                	    table.insert(connections, v)
                	end
				end
            end
        end
    end
end)
local function PaintPart(p)
	coroutine.wrap(function()
		local args = {
			[1] = "PaintPart",
			[2] = {
				["Part"] = p,
				["Color"] = library.flags["PaintColor"]
			}
		}
		game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Remotes.ServerControls:InvokeServer(unpack(args))
	end)()
end
while true do
    wait(library.flags["Refresh"])
    r = library.flags["PAuraRange"]
    if r == 0 then 
        r = math.huge
    end
    --part.Size = Vector3.new(r, r, r)
    --part.CFrame = plr.Character.PrimaryPart.CFrame
	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool") then
    if library.flags["PAura"] then
        --print("c")
        --print("c-1")
        local region = Region3.new(plr.Character.PrimaryPart.Position - Vector3.new(r/2,r/2,r/2), plr.Character.PrimaryPart.Position + Vector3.new(r/2,r/2,r/2))
        --print("c-2")
        local parts = workspace:FindPartsInRegion3(region, part, math.huge)
        --print("c-3")
        for _, brick in pairs(parts) do
        	if brick ~= nil then
        	    pcall(function()
        			if (brick.Position - plr.Character.PrimaryPart.Position).Magnitude < r and brick.Color ~= library.flags["PaintColor"] and brick.Name == "Province" then
						PaintPart(brick)    
        			end
    			end)
			end
		end
	end
	if library.flags["MapClaim"] then
		for i, v in pairs(connections) do
			if v.BrickColor ~= BrickColor.new(library.flags["PaintColor"]) then
				print(v.Color, library.flags["PaintColor"])
				PaintPart(v)
			end
		end
	end
end
end
