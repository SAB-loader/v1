local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua"))()

local Window = ReGui:Window({
	Title = "Sweep Bot v1.01",
	Size = UDim2.fromOffset(300, 200)
})

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local Teleport = ReplicatedStorage.RemoteEvents.Teleport

-- Anti AFK
local bb = game:GetService("VirtualUser")
player.Idled:Connect(function()
	bb:CaptureController()
	bb:ClickButton2(Vector2.new())
end)

-- Config
local stepX = 17
local fixedY = -7.3
local minX, maxX = -187, 187
local zValues = {-190, 190}

-- State
local running = false
local speed = 65 -- default speed (studs per second)

-- Functions
local function tweenTo(position)
	local distance = (humanoidRootPart.Position - position).Magnitude
	local duration = distance / speed
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
	tween:Play()
	tween.Completed:Wait()
end

local function checkAndTeleport()
	if player.leaderstats and player.leaderstats:FindFirstChild("Size") then
		if player.leaderstats.Size.Value > 5000000 then
			Teleport:FireServer("lobby")
			task.wait(0.5)
			humanoidRootPart.CFrame = CFrame.new(workspace.Lobby.Teleporter.Hitbox.Position + Vector3.new(0,3,0))
			task.wait(60) -- wait 60s before resuming
		end
	end
end

local function startLoop()
	task.spawn(function()
		while running do
			checkAndTeleport()

			-- forward sweep
			for x = minX, maxX, stepX do
				if not running then break end
				for _, z in ipairs(zValues) do
					if not running then break end
					tweenTo(Vector3.new(x, fixedY, z))
				end
			end

			-- return to starting corner
			if running then
				tweenTo(Vector3.new(minX, fixedY, -190))
			end
		end
	end)
end

-- GUI
Window:Checkbox({
	Value = false,
	Label = "Enable Sweep",
	Callback = function(self, Value)
		running = Value
		if running then
			Teleport:FireServer("lobby")
			task.wait(0.5)
			humanoidRootPart.CFrame = CFrame.new(workspace.Lobby.Teleporter.Hitbox.Position + Vector3.new(0,3,0))
			task.wait(1)
			startLoop()
		end
	end
})

Window:InputText({
	Label = "Speed (studs/s)",
	Value = tostring(speed),
	Callback = function(self, Value)
		local num = tonumber(Value)
		if num and num > 0 then
			speed = num
		end
	end
})
