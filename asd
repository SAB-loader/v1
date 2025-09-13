local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()

local Window = ReGui:Window({
	Title = "Hello world! v1",
	Size = UDim2.fromOffset(300, 200)
})

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teleport = ReplicatedStorage.RemoteEvents.Teleport

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local running = false
local speed = 50
local stepX = 17
local fixedY = -7.3
local minX, maxX = -187, 187
local zValues = {-190, 190}

local function tweenTo(position)
	local distance = (humanoidRootPart.Position - position).Magnitude
	local tweenTime = distance / speed
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
	tween:Play()
	tween.Completed:Wait()
end

Window:InputText({
	Label = "Speed (studs/sec)",
	Value = "65",
	Callback = function(self, Value)
		local num = tonumber(Value)
		if num and num > 0 then
			speed = num
		end
	end
})

Window:Checkbox({
	Value = false,
	Label = "Check box",
	Callback = function(self, Value)
		running = Value
		if Value then
			task.spawn(function()
				while running do
					-- teleport to lobby each loop
					Teleport:FireServer("lobby")
					task.wait(0.5)
					local targetPosition = workspace.Lobby.Teleporter.Hitbox.Position
					humanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0,3,0))
					task.wait(1)

					-- Forward sweep
					for x = minX, maxX, stepX do
						if not running then break end
						for _, z in ipairs(zValues) do
							if not running then break end
							tweenTo(Vector3.new(x, fixedY, z))
						end
					end

					-- Backward sweep
					for x = maxX, minX, -stepX do
						if not running then break end
						for _, z in ipairs(zValues) do
							if not running then break end
							tweenTo(Vector3.new(x, fixedY, z))
						end
					end

					-- Size check after a full sweep
					local sizeValue = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Size")
					if sizeValue and sizeValue.Value > 10000000 then
						Teleport:FireServer("lobby")
						task.wait(80)
					end
				end
			end)
		end
	end
})

local bb = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:Connect(function()
    bb:CaptureController()
    bb:ClickButton2(Vector2.new())
end)
