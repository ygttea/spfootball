-- Hizmetleri al
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Başlangıç değeri
local transparencyValue = 0.97
local increment = 0.01

-- Bildirim fonksiyonu
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

-- Artır
local function increaseTransparency()
    if transparencyValue < 1 then
        transparencyValue = math.min(transparencyValue + increment, 1)
        updateTransparency()
        sendNotification("Transparanlık Arttı", "Şu an: " .. transparencyValue)
    else
        sendNotification("Max Şeffaflık", "Daha fazla artamaz.")
    end
end

-- Azalt
local function decreaseTransparency()
    if transparencyValue > 0 then
        transparencyValue = math.max(transparencyValue - increment, 0)
        updateTransparency()
        sendNotification("Transparanlık Azaldı", "Şu an: " .. transparencyValue)
    else
        sendNotification("Min Şeffaflık", "Daha fazla azalmaz.")
    end
end

-- Tuş dinleme
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        increaseTransparency()
    elseif input.KeyCode == Enum.KeyCode.N then
        decreaseTransparency()
    end
end)

-- Respawn sonrası
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        wait(5)
        updateTransparency()
    end)
end)

-- Parça oluşturucu
local function createAndStabilizePart(part, size, name, transparency)
    local existingClone = part.Parent:FindFirstChild(name)
    if existingClone then
        existingClone:Destroy()
    end

    local clone = Instance.new("Part")
    clone.Size = size
    clone.CanCollide = false
    clone.Transparency = transparency
    clone.Name = name
    clone.Position = part.Position
    clone.Anchored = false
    clone.Parent = part.Parent

    local originalAttachment = Instance.new("Attachment", part)
    originalAttachment.Name = "OriginalAttachment"

    local cloneAttachment = Instance.new("Attachment", clone)
    cloneAttachment.Name = "CloneAttachment"

    local alignPosition = Instance.new("AlignPosition", clone)
    alignPosition.Attachment0 = cloneAttachment
    alignPosition.Attachment1 = originalAttachment
    alignPosition.RigidityEnabled = true

    local alignOrientation = Instance.new("AlignOrientation", clone)
    alignOrientation.Attachment0 = cloneAttachment
    alignOrientation.Attachment1 = originalAttachment
    alignOrientation.RigidityEnabled = true

    return clone
end

-- Parçaları genişlet
local function expandParts()
    local character = LocalPlayer.Character
    if not character then return end

    local function expand(part, baseName)
        local clone1 = createAndStabilizePart(part, Vector3.new(20, 20, 20), baseName .. "_Expanded", 0.97)
        local clone2 = createAndStabilizePart(clone1, Vector3.new(15, 15, 15), baseName .. "_MidExpanded1", 0.98)
        local clone3 = createAndStabilizePart(clone2, Vector3.new(6, 6, 6), baseName .. "_HalfExpanded", 0.98)
        createAndStabilizePart(clone3, Vector3.new(3, 3, 3), baseName .. "_MidExpanded2", 0.98)
    end

    local partsToExpand = {
        "LowerTorso", "UpperTorso", "HumanoidRootPart",
        "Left Arm", "Right Arm", "Left Leg", "Right Leg",
        "LeftHand", "RightHand", "LeftFoot", "RightFoot"
    }

    for _, name in ipairs(partsToExpand) do
        local part = character:FindFirstChild(name)
        if part then expand(part, name:gsub(" ", "")) end
    end
end

-- GUI oluştur
local function createCustomGUI()
    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "ExpandPartsGui"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 220, 0, 70)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BackgroundTransparency = 0.2

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "Parts Expander"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, 30)
    button.Text = "Expand Parts"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

    button.MouseButton1Click:Connect(expandParts)
end

-- Tuşla expand
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        expandParts()
    end
end)

-- Respawn GUI
LocalPlayer.CharacterAdded:Connect(function()
    createCustomGUI()
end)

if LocalPlayer.Character then
    createCustomGUI()
end
