local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local transparencyValue = 1 -- Tamamen görünmez
local increment = 0.1

-- Bildirim gönderme fonksiyonu
local function sendNotification(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 3
    })
end

-- Transparanlık güncelle
local function updateTransparency()
    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
        if part:IsA("Part") and part.Name:match("_Expanded") then
            part.Transparency = transparencyValue
        end
    end
end

local function increaseTransparency()
    sendNotification("Transparência Máxima", "Kutular zaten görünmez.")
end

local function decreaseTransparency()
    sendNotification("Transparência Mínima", "Kutular zaten görünmez.")
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        increaseTransparency()
    elseif input.KeyCode == Enum.KeyCode.N then
        decreaseTransparency()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        wait(5)
        updateTransparency()
    end)
end)

local function createAndStabilizePart(part, size, name, transparency)
    local existingClone = part.Parent:FindFirstChild(name)
    if existingClone then
        existingClone:Destroy()
    end

    local clone = Instance.new("Part")
    clone.Size = size
    clone.CanCollide = false
    clone.Transparency = 1 -- Burayı da 1 yaptık
    clone.Name = name
    clone.Position = part.Position
    clone.Anchored = false
    clone.Parent = part.Parent

    local originalAttachment = Instance.new("Attachment")
    originalAttachment.Name = "OriginalAttachment"
    originalAttachment.Parent = part

    local cloneAttachment = Instance.new("Attachment")
    cloneAttachment.Name = "CloneAttachment"
    cloneAttachment.Parent = clone

    local alignPosition = Instance.new("AlignPosition")
    alignPosition.Attachment0 = cloneAttachment
    alignPosition.Attachment1 = originalAttachment
    alignPosition.RigidityEnabled = true
    alignPosition.Parent = clone

    local alignOrientation = Instance.new("AlignOrientation")
    alignOrientation.Attachment0 = cloneAttachment
    alignOrientation.Attachment1 = originalAttachment
    alignOrientation.RigidityEnabled = true
    alignOrientation.Parent = clone

    return clone
end

local function expandParts()
    local character = LocalPlayer.Character
    if character then
        local function expand(part, baseName)
            if not part then return end
            local clone1 = createAndStabilizePart(part, Vector3.new(20, 20, 20), baseName .. "_Expanded", 1)
            local clone2 = createAndStabilizePart(clone1, Vector3.new(15, 15, 15), baseName .. "_MidExpanded1", 1)
            local clone3 = createAndStabilizePart(clone2, Vector3.new(6, 6, 6), baseName .. "_HalfExpanded", 1)
            createAndStabilizePart(clone3, Vector3.new(3, 3, 3), baseName .. "_MidExpanded2", 1)
        end

        expand(character:FindFirstChild("LowerTorso"), "LowerTorso")
        expand(character:FindFirstChild("UpperTorso"), "UpperTorso")
        expand(character:FindFirstChild("HumanoidRootPart"), "HumanoidRootPart")
        expand(character:FindFirstChild("Left Arm"), "LeftArm")
        expand(character:FindFirstChild("Right Arm"), "RightArm")
        expand(character:FindFirstChild("Left Leg"), "LeftLeg")
        expand(character:FindFirstChild("Right Leg"), "RightLeg")
        expand(character:FindFirstChild("LeftHand"), "LeftHand")
        expand(character:FindFirstChild("RightHand"), "RightHand")
        expand(character:FindFirstChild("LeftFoot"), "LeftFoot")
        expand(character:FindFirstChild("RightFoot"), "RightFoot")
    end
end

local function createCustomGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ExpandPartsGui"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 70)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.2
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    title.BorderSizePixel = 0
    title.Text = "Parts Expander"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.BorderSizePixel = 0
    button.Text = "Expand Parts"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = frame

    button.MouseButton1Click:Connect(expandParts)
end

local function onKeyPress(input)
    if input.KeyCode == Enum.KeyCode.T then
        expandParts()
    end
end

UserInputService.InputBegan:Connect(onKeyPress)

local function onCharacterAdded()
    createCustomGUI()
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end
