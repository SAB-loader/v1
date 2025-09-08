local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Full List of Waypoints
local points = {
    Vector3.new(-194.69, -7.32, -196.58),
    Vector3.new(196.68, -7.32, -196.63),
    Vector3.new(196.69, -7.32, -174.62),
    Vector3.new(-194.79, -7.32, -171.81),
    Vector3.new(-191.40, -7.32, -140.26),
    Vector3.new(196.44, -7.32, -148.28),
    Vector3.new(196.60, -7.32, -116.73),
    Vector3.new(-194.61, -7.32, -112.18),
    Vector3.new(-194.16, -7.32, -75.26),
    Vector3.new(196.64, -7.32, -83.18),
    Vector3.new(196.75, -7.32, -47.36),
    Vector3.new(-194.76, -7.32, -39.34),
    Vector3.new(-191.51, -7.32, 2.88),
    Vector3.new(195.26, -7.32, -6.47),
    Vector3.new(195.55, -7.32, 34.08),
    Vector3.new(-194.78, -7.32, 39.14),
    Vector3.new(-193.85, -7.32, 82.00),
    Vector3.new(196.62, -7.32, 74.39),
    Vector3.new(195.70, -7.32, 107.38),
    Vector3.new(-194.66, -7.32, 116.92),
    Vector3.new(196.81, -7.32, 147.66),
    Vector3.new(-194.71, -7.32, 157.14),
    Vector3.new(-190.59, -7.32, 196.41),
    Vector3.new(194.92, -7.32, 191.86),
    Vector3.new(-185.228, -7.316, -184.773),
    Vector3.new(-180.600, -7.316, 187.640),
    Vector3.new(185.044, -7.316, 182.593),
    Vector3.new(180.540, -7.316, -187.041),
    Vector3.new(159.968, -7.316, -170.422),
    Vector3.new(-165.648, -7.316, -161.574),
    Vector3.new(-152.611, -7.316, 166.010),
    Vector3.new(169.397, -7.316, 157.422),
    Vector3.new(141.520, -7.316, 126.048),
    Vector3.new(141.584, -7.316, -142.517),
    Vector3.new(-127.768, -7.316, -128.225),
    Vector3.new(-131.226, -7.316, 131.054),
    Vector3.new(138.297, -7.316, 134.382),
    Vector3.new(104.018, -7.316, 101.161),
    Vector3.new(117.077, -7.316, -113.765),
    Vector3.new(-102.100, -7.316, -99.331),
    Vector3.new(-109.336, -7.316, 107.410),
    Vector3.new(105.013, -7.316, 93.694),
    Vector3.new(70.270, -7.316, 69.137),
    Vector3.new(79.294, -7.316, -110.268),
    Vector3.new(-100.602, -7.316, -99.403),
    Vector3.new(-86.971, -7.316, 105.222),
    Vector3.new(83.608, -7.316, 76.991),
    Vector3.new(50.269, -7.316, 45.868),
    Vector3.new(58.054, -7.316, -76.007),
    Vector3.new(-69.009, -7.316, -73.060),
    Vector3.new(-62.581, -7.316, 70.597),
    Vector3.new(55.626, -7.316, 51.913),
    Vector3.new(17.839, -7.316, 13.710),
    Vector3.new(27.530, -7.316, -41.172),
    Vector3.new(-38.859, -7.316, -38.479),
    Vector3.new(-31.502, -7.316, 31.360),
    Vector3.new(25.411, -7.316, 30.029),
    Vector3.new(-5.979, -7.316, -9.870)
}


-- UI Elements
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "MovementGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10) -- Top-left position
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5

local startStopButton = Instance.new("TextButton", frame)
startStopButton.Size = UDim2.new(0, 100, 0, 50)
startStopButton.Position = UDim2.new(0.5, -50, 0, 10)
startStopButton.Text = "Start"
startStopButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -60, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

local speedInput = Instance.new("TextBox", frame)
speedInput.Size = UDim2.new(0, 200, 0, 30)
speedInput.Position = UDim2.new(0.5, -100, 0, 70)
speedInput.Text = "16"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedInput.PlaceholderText = "Speed (1-100)"

-- Movement control variables
local isMoving = false
local currentIndex = 1
local speed = tonumber(speedInput.Text) or 16

-- Check if character reached target
local function hasReachedTarget(targetPos)
    return (humanoidRootPart.Position - targetPos).Magnitude < 3  -- 3-stud tolerance
end

-- CFrame movement function
local function moveToNextPoint()
    while isMoving do
        if currentIndex > #points then
            currentIndex = 1 -- Loop back to start
        end

        local targetPos = points[currentIndex]

        -- Move with CFrame in steps
        while isMoving and not hasReachedTarget(targetPos) do
            local direction = (targetPos - humanoidRootPart.Position).unit
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + (direction * speed * 0.05) -- Adjust movement step size
            wait(0.05) -- Prevent lag
        end

        -- If reached, move to the next waypoint
        if hasReachedTarget(targetPos) then
            currentIndex = currentIndex + 1
        end
    end
end

-- Start/Stop Button Handler
startStopButton.MouseButton1Click:Connect(function()
    isMoving = not isMoving

    if isMoving then
        startStopButton.Text = "Stop"
        startStopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        task.spawn(moveToNextPoint)
    else
        startStopButton.Text = "Start"
        startStopButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end
end)

-- Speed Input Handler
speedInput.FocusLost:Connect(function()
    local newSpeed = tonumber(speedInput.Text)
    if newSpeed and newSpeed >= 1 and newSpeed <= 200 then
        speed = newSpeed
    else
        speedInput.Text = tostring(speed) -- Reset to last valid speed
    end
end)

-- Close Button Handler
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
