local mouse = game.Players.LocalPlayer:GetMouse()
--_G.color = Color3.new(1,0.4,0)
if not _G.color then 
    _G.color = Color3.new(0,0,0)
end
connections = {}
local function isInTable(p)
    for i, v in pairs(connections) do
        if v == p then
            return i
        end
    end
end
mouse.Button1Up:Connect(function()
    if mouse.Target.Name == "Province" then
        local bool = isInTable(mouse.Target)
        if bool ~= nil then
            table.remove(connections, bool)
        else
            table.insert(connections, mouse.Target)
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.P) then
            for i, v in pairs(game.Workspace.Provinces:GetChildren()) do
                if v.Color == mouse.Target.Color and ((v.Position - mouse.Target.Position).Magnitude < 250) then
                    table.insert(connections, v)
                end
            end
        end
        end
    end
end)
while wait(0.1) do
    for x=-360, 360, 18 do
        wait(0.1)
    --c = math.sin(math.rad(x))/2+0.5
    --_G.color = Color3.new(math.abs(c-1), math.abs(c-1), c*1)
    for i, v in pairs(connections) do
        if v.BrickColor ~= BrickColor.new(_G.color) then
            print(v.Color, _G.color)
            coroutine.wrap(function()
                local args = {
                    [1] = "PaintPart",
                    [2] = {
                        ["Part"] = v,
                        ["Color"] = _G.color
                    }
                }
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Remotes.ServerControls:InvokeServer(unpack(args))
            end)()
        end
    end
end
end
