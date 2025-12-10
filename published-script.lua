pcall(function()
	if _G.AimESP_RS_CONN and _G.AimESP_RS_CONN.Connected then _G.AimESP_RS_CONN:Disconnect() end
	if _G.AimESP_CACHE_CONNECTIONS then for _,c in pairs(_G.AimESP_CACHE_CONNECTIONS) do c:Disconnect() end; _G.AimESP_CACHE_CONNECTIONS = nil end
	if _G.AimESP_FOV_CIRCLE then _G.AimESP_FOV_CIRCLE:Remove() end
    if _G.AimESP_DrawingCache then for _,t in pairs(_G.AimESP_DrawingCache) do for i,v in pairs(t) do v:Remove() end end; _G.AimESP_DrawingCache = nil end
	if _G.AimESP_Originals then
		pcall(function() game:GetService("Lighting").Ambient = _G.AimESP_Originals.Ambient end)
		pcall(function() game:GetService("Lighting").Brightness = _G.AimESP_Originals.Brightness end)
		pcall(function() game:GetService("Lighting").GlobalShadows = _G.AimESP_Originals.GlobalShadows end)
		pcall(function() workspace.CurrentCamera.FieldOfView = _G.AimESP_Originals.Fov end)
	end
	pcall(function()
		local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
		if playerGui and playerGui:FindFirstChild("AimESP_UI") then playerGui:FindFirstChild("AimESP_UI"):Destroy() end
		if playerGui and playerGui:FindFirstChild("KeyAuthScreenGui") then playerGui:FindFirstChild("KeyAuthScreenGui"):Destroy() end
		local coreGui = game:GetService("CoreGui")
		if coreGui and coreGui:FindFirstChild("AimESP_UI") then coreGui:FindFirstChild("AimESP_UI"):Destroy() end
		if coreGui and coreGui:FindFirstChild("KeyAuthScreenGui") then coreGui:FindFirstChild("KeyAuthScreenGui"):Destroy() end
	end)
end)

local KeySystem = {}
KeySystem.KeyVerified = false

local DiscordLink = "https://discord.gg/E65ED5PQqS"

local Keys = {
    "shanegray",
    "nv1zPwz59UV3GkNOsfTX3gCzfo8Kro4rOb1uUF5hnSY",
    "alexwicke"
}

function KeySystem:CreateUI()
    local KeyAuthScreenGui = Instance.new("ScreenGui")
    KeyAuthScreenGui.Name = "KeyAuthScreenGui"
    KeyAuthScreenGui.ResetOnSpawn = false
    KeyAuthScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    KeyAuthScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 220)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyAuthScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(80, 80, 85)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Title.Text = "AldoAimV4 - Key Authentication"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Parent = MainFrame
    local titleCorner = Instance.new("UICorner", Title); titleCorner.CornerRadius = UDim.new(0, 8)

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 35)
    KeyInput.Position = UDim2.new(0.5, 0, 0.40, 0)
    KeyInput.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyInput.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 14
    KeyInput.TextColor3 = Color3.fromRGB(220, 220, 220)
    KeyInput.Parent = MainFrame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 20)
    StatusLabel.Position = UDim2.new(0.5, 0, 0.58, 0)
    StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 14
    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    StatusLabel.Parent = MainFrame

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0.5, -30, 0, 40)
    SubmitButton.Position = UDim2.new(0.75, 0, 0.82, 0)
    SubmitButton.AnchorPoint = Vector2.new(0.5, 0.5)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    SubmitButton.Text = "Verify"
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.TextSize = 16
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.Parent = MainFrame
    Instance.new("UICorner", SubmitButton).CornerRadius = UDim.new(0, 6)

    local GetKeyButton = Instance.new("TextButton")
    GetKeyButton.Size = UDim2.new(0.5, -30, 0, 40)
    GetKeyButton.Position = UDim2.new(0.25, 0, 0.82, 0)
    GetKeyButton.AnchorPoint = Vector2.new(0.5, 0.5)
    GetKeyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
    GetKeyButton.Text = "Get Key"
    GetKeyButton.Font = Enum.Font.GothamBold
    GetKeyButton.TextSize = 16
    GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyButton.Parent = MainFrame
    Instance.new("UICorner", GetKeyButton).CornerRadius = UDim.new(0, 6)

    SubmitButton.MouseButton1Click:Connect(function()
        local enteredKey = KeyInput.Text
        local isValid = false
        for _, validKey in ipairs(Keys) do
            if enteredKey == validKey then
                isValid = true
                break
            end
        end

        if isValid then
            StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
            StatusLabel.Text = "Success! Loading..."
            task.wait(1)
            KeySystem.KeyVerified = true
            KeyAuthScreenGui:Destroy()
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            StatusLabel.Text = "Invalid Key"
            task.wait(2)
            StatusLabel.Text = ""
        end
    end)

    GetKeyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DiscordLink)
            StatusLabel.TextColor3 = Color3.fromRGB(80, 180, 255)
            StatusLabel.Text = "Discord Link Copied!"
            task.wait(2)
            StatusLabel.Text = ""
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            StatusLabel.Text = "Clipboard not available."
            task.wait(2)
            StatusLabel.Text = ""
        end
    end)
end

KeySystem:CreateUI()

repeat task.wait() until KeySystem.KeyVerified == true

if KeySystem.KeyVerified then

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Vim = game:GetService("VirtualInputManager")

local settings = {
	aimbotEnabled = true,
	aimMethod = "Camera",
	fovCircle = true,
	aimRadius = 150,
	smoothness = 0.10,
	aimPart = "Head",
	hitboxExpanderEnabled = false,
	hitboxSize = 15,
	hitboxTransparency = 1,

	flyEnabled = false,
	flySpeed = 75,

	espEnabled = true,
	boxESP = true,
	skelESP = false,
	healthBar = true,
	infoESP = true,
	espVisibleColor = Color3.fromRGB(0, 255, 180),
	espOccludedColor = Color3.fromRGB(255, 80, 80),

	targetPlayers = true,
	
	noclipEnabled = false,
	fullBright = true,
    killAllClick = true,

	keybinds = {
		toggleGUI = Enum.KeyCode.RightControl,
		toggleFly = Enum.KeyCode.N,
		aimbotKey = Enum.UserInputType.MouseButton2,
		loopKillKey = Enum.KeyCode.H,
        killAllKey = Enum.KeyCode.F
	}
}

local WeaponsFolder = ReplicatedStorage:WaitForChild("Weapons", 10)
local OriginalWeaponData = {}
local gunModSettings = {
	infiniteAmmo = false,
	fastFire = false,
	fireRate = 0.05,
	noRecoil = false,
	allAuto = false,
	noSpread = false
}

local function backupSingleWeapon(weapon)
    if weapon and not OriginalWeaponData[weapon] then
        OriginalWeaponData[weapon] = {}
        for _, prop in ipairs(weapon:GetChildren()) do
            if prop:IsA("ValueBase") then
                OriginalWeaponData[weapon][prop.Name] = prop.Value
            end
        end
    end
end

local function applyGunModsToWeapon(weapon)
    if not weapon or not OriginalWeaponData[weapon] then return end
    if gunModSettings.infiniteAmmo then
        if not weapon:FindFirstChild("Infinite") then Instance.new("Folder", weapon).Name = "Infinite" end
    else
        if weapon:FindFirstChild("Infinite") then weapon.Infinite:Destroy() end
    end
    if weapon:FindFirstChild("FireRate") then
        weapon.FireRate.Value = gunModSettings.fastFire and gunModSettings.fireRate or OriginalWeaponData[weapon].FireRate
    end
    if weapon:FindFirstChild("RecoilControl") then
        weapon.RecoilControl.Value = gunModSettings.noRecoil and 0 or OriginalWeaponData[weapon].RecoilControl
    end
    if weapon:FindFirstChild("Auto") then
        weapon.Auto.Value = gunModSettings.allAuto or OriginalWeaponData[weapon].Auto
    end
    if weapon:FindFirstChild("Spread") then
        weapon.Spread.Value = gunModSettings.noSpread and 0 or OriginalWeaponData[weapon].Spread
    end
end

local function updateAllWeaponMods()
	if not WeaponsFolder then return end
	for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
		applyGunModsToWeapon(weapon)
	end
end

local function restoreAllWeaponData()
	if not WeaponsFolder then return end
	for weapon, data in pairs(OriginalWeaponData) do
		pcall(function()
			for propName, origValue in pairs(data) do
				if weapon and weapon:FindFirstChild(propName) then
					weapon[propName].Value = origValue
				end
			end
			if weapon and weapon:FindFirstChild("Infinite") then
				weapon.Infinite:Destroy()
			end
		end)
	end
end

if WeaponsFolder then
	for _, weapon in ipairs(WeaponsFolder:GetChildren()) do backupSingleWeapon(weapon) end
	WeaponsFolder.ChildAdded:Connect(function(weapon) task.wait(); backupSingleWeapon(weapon); applyGunModsToWeapon(weapon) end)
end

local isAimbotKeyPressed = false
local targetModel = nil
local listeningForKeybind = nil
local updateCounter = 0
local characterCache = {}
local lastPlayerIndex = 0

_G.AimESP_Originals = { Fov = Camera.FieldOfView, Ambient = Lighting.Ambient, Brightness = Lighting.Brightness, GlobalShadows = Lighting.GlobalShadows }

local function isEnemy(plr)
    if not plr or plr == LocalPlayer then
        return false
    end

    local myTeam = LocalPlayer.Team
    local theirTeam = plr.Team

    if not myTeam then
        return true
    end

    if not theirTeam then
        return false
    end

    return myTeam.TeamColor ~= theirTeam.TeamColor
end

local hrp, humanoid = nil, nil
local flyLV, flyAO, flyAttachment = nil, nil, nil

local function enableFly()
	if not hrp or not humanoid or flyLV then return end
	
    flyAttachment = Instance.new("Attachment", hrp)
    
	flyLV = Instance.new("LinearVelocity", hrp)
	flyLV.Attachment0 = flyAttachment
	flyLV.MaxForce = math.huge
	flyLV.VectorVelocity = Vector3.new(0, 0, 0)
	flyLV.RelativeTo = Enum.ActuatorRelativeTo.World

	flyAO = Instance.new("AlignOrientation", hrp)
	flyAO.Attachment0 = flyAttachment
	flyAO.Mode = Enum.OrientationAlignmentMode.OneAttachment
	flyAO.Responsiveness = 200
	flyAO.MaxTorque = math.huge

	humanoid.PlatformStand = true
	local anim = hrp.Parent and hrp.Parent:FindFirstChild("Animate")
	if anim then pcall(function() anim.Disabled = true end) end
end

local function disableFly()
	if flyLV then flyLV:Destroy(); flyLV = nil end
	if flyAO then flyAO:Destroy(); flyAO = nil end
	if flyAttachment then flyAttachment:Destroy(); flyAttachment = nil end
	
	if humanoid then
		humanoid.PlatformStand = false
	end
	local anim = hrp and hrp.Parent and hrp.Parent:FindFirstChild("Animate")
	if anim then pcall(function() anim.Disabled = false end) end
end

local function setFlyEnabled(v)
	settings.flyEnabled = v and true or false
	if settings.flyEnabled then enableFly() else disableFly() end
end

local noclipConnection = nil
local function setNoclipEnabled(enabled)
	settings.noclipEnabled = enabled
	if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
	local char = LocalPlayer.Character; if not char then return end
	if enabled then
		noclipConnection = RunService.Stepped:Connect(function()
			if not settings.noclipEnabled or not LocalPlayer.Character then if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end return end
			for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
		end)
	else
		for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
	end
end

local function setFullBright(enabled)
	settings.fullBright = enabled
	if enabled then
		Lighting.Ambient = Color3.fromRGB(180, 180, 180)
		Lighting.Brightness = 2
		Lighting.GlobalShadows = false
	else
		Lighting.Ambient = _G.AimESP_Originals.Ambient
		Lighting.Brightness = _G.AimESP_Originals.Brightness
		Lighting.GlobalShadows = _G.AimESP_Originals.GlobalShadows
	end
end

local function setLocalPlayerViewModel(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 0.8
        end
    end
end

local function onCharacterAdded(char)
	hrp = char:WaitForChild("HumanoidRootPart", 5); humanoid = char:WaitForChild("Humanoid", 5)
	if settings.flyEnabled then disableFly(); enableFly() else disableFly() end
	if settings.noclipEnabled then setNoclipEnabled(true) end
	if humanoid then humanoid.Died:Connect(function() disableFly(); if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end end) end
	setLocalPlayerViewModel(char)
end

if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterAppearanceLoaded:Connect(setLocalPlayerViewModel)

local function isAlive(hum) return hum and hum.Health and hum.Health > 0 end
local fovCircle = Drawing.new("Circle"); fovCircle.Color = Color3.fromRGB(255, 64, 64); fovCircle.Thickness = 2; fovCircle.Filled = false; fovCircle.NumSides = 64; fovCircle.Radius = settings.aimRadius; fovCircle.Visible = settings.fovCircle; fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

task.spawn(function()
    task.wait(0.5) -- Give the library a moment to create the GUI
    pcall(function()
        local drawingGui = game:GetService("CoreGui"):FindFirstChild("Drawing") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Drawing")
        if drawingGui then
            for _, child in ipairs(drawingGui:GetChildren()) do
                if child:IsA("Frame") and child.Size == UDim2.fromScale(1, 1) then
                    child.Visible = false -- Hide the canvas frame
                    break
                end
            end
        end
    end)
end)
_G.AimESP_FOV_CIRCLE = fovCircle


local function screenPoint(v3) local v2, on = Camera:WorldToViewportPoint(v3); return Vector2.new(v2.X, v2.Y), on, v2.Z end

local function hasLineOfSight(model)
    local myChar = LocalPlayer.Character
    if not (myChar and model) then return false end

    local theirTargetPart = model:FindFirstChild(settings.aimPart) or model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
    if not theirTargetPart then return false end

    local origin = Camera.CFrame.Position
    local direction = theirTargetPart.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {myChar}
    params.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, params)

    if not result then
        return true
    end

    if result.Instance:IsDescendantOf(model) then
        return true
    end

    if result.Instance:IsA("BasePart") and result.Instance.Transparency >= 0.5 then
        return true
    end

    return false
end

local function isValidTarget(model)
    if not (model and model:IsA("Model") and model.Parent == workspace) then return false end

	if model:FindFirstChildOfClass("ForceField") then return false end
    
	local hum = model:FindFirstChildOfClass("Humanoid")
    if not isAlive(hum) then return false end

	local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local targetHrp = model:FindFirstChild("HumanoidRootPart")
	if not myHrp or not targetHrp then return false end
    
    if targetHrp.Position.Magnitude < 20 then
        return false
    end

	if math.abs(myHrp.Position.Y - targetHrp.Position.Y) > 500 then
		return false
	end

	local groundCheckParams = RaycastParams.new()
	groundCheckParams.FilterType = Enum.RaycastFilterType.Exclude
	groundCheckParams.FilterDescendantsInstances = {model}
	local groundCast = workspace:Raycast(targetHrp.Position, Vector3.new(0, -15, 0), groundCheckParams)
	
    if not groundCast and hum.MoveDirection.Magnitude == 0 then
        return false
    end

    local upwardCheckParams = RaycastParams.new()
    upwardCheckParams.FilterType = Enum.RaycastFilterType.Exclude
    upwardCheckParams.FilterDescendantsInstances = {model}
    local upwardCast = workspace:Raycast(targetHrp.Position, Vector3.new(0, 5, 0), upwardCheckParams)
    if upwardCast and (upwardCast.Position - targetHrp.Position).Magnitude < 1 then
        return false
    end

	local plr = Players:GetPlayerFromCharacter(model)
	if plr then
        if not settings.targetPlayers or not isEnemy(plr) or plr == LocalPlayer then return false end
    end
    
	return true
end

local function isDestinationSafe(position)
    local safetyParams = RaycastParams.new()
    safetyParams.FilterType = Enum.RaycastFilterType.Exclude
    safetyParams.FilterDescendantsInstances = {LocalPlayer.Character}

    local groundCheck = workspace:Raycast(position + Vector3.new(0, 3, 0), Vector3.new(0, -6, 0), safetyParams)

    if groundCheck and groundCheck.Instance then
        return true
    end

    return false
end
local isKillAllActive = false
local killAllConnection = nil

local function getClosestValidTargetInWorld()
    local closestTarget, minDist = nil, math.huge
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) and isValidTarget(player.Character) then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local dist = (myHRP.Position - targetHRP.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closestTarget = player.Character
                end
            end
        end
    end
    return closestTarget
end

local function killAllTask()
    while isKillAllActive do
        for i, v in pairs(Players:GetPlayers()) do
            if not isKillAllActive then break end
            if v.TeamColor.Color == Players.LocalPlayer.TeamColor.Color then continue end
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.NRPBS.Health.Value > 0 then
                if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local Tick = tick()
                    while tick() - Tick <= 1 do
                        if not isKillAllActive then break end
                        if not v.Status.Alive.Value then break end
                        if not Players.LocalPlayer.Status.Alive.Value then break end

                        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and v.NRPBS.Health.Value > 0 then
                            if v.Character.HumanoidRootPart.Position.Y <= -155 then break end
                            if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Players.LocalPlayer.NRPBS.Health.Value > 0 then
                                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame - (v.Character.HumanoidRootPart.CFrame.LookVector * 3)
                                Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, v.Character.Head.Position)
                                if settings.killAllClick then
                                    Vim:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2, 0, true, nil, 0)
                                    task.wait(0.01)
                                    Vim:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2, 0, false, nil, 0)
                                end
                            else break end
                        else break end
                        task.wait()
                    end
                end
            end
        end
        task.wait()
    end
end

local function toggleKillAllLoop()
    isKillAllActive = not isKillAllActive
    if isKillAllActive then
        if killAllConnection then task.cancel(killAllConnection) end
        killAllConnection = task.spawn(killAllTask)
    else
        if killAllConnection then
            task.cancel(killAllConnection)
            killAllConnection = nil
        end
    end
end
local isLoopKillActive = false
local loopKillTargetName = ""
local loopKillTextBox
local currentLoopKillThread = nil

local function loopKillTask()
    local targetPlayer = Players:FindFirstChild(loopKillTargetName)
    while isLoopKillActive do
        if not (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and isEnemy(targetPlayer) and targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0) then
            isLoopKillActive = false
            break
        end

        local myChar = LocalPlayer.Character
        if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then
            isLoopKillActive = false
            break
        end

        local Tick = tick()
        while tick() - Tick <= 1 and isLoopKillActive do
            if not (targetPlayer and targetPlayer.Character and targetPlayer.Status.Alive.Value) then break end
            
            myChar.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame - (targetPlayer.Character.HumanoidRootPart.CFrame.LookVector * 6)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPlayer.Character.Head.Position)
            
            if settings.killAllClick then
                Vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                Vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
            task.wait()
        end
        task.wait()
    end
end

local function toggleLoopKill()
    if currentLoopKillThread then
        isLoopKillActive = false
        task.cancel(currentLoopKillThread)
        currentLoopKillThread = nil
    end

    isLoopKillActive = not isLoopKillActive
    
    if isLoopKillActive then
        if loopKillTextBox then
            local targetName = loopKillTextBox.Text
            if targetName and #targetName > 0 and Players:FindFirstChild(targetName) then
                loopKillTargetName = targetName
                currentLoopKillThread = task.spawn(loopKillTask)
            else
                isLoopKillActive = false
            end
        end
    end
end

local MainESP = { cache = {} }
local function newLine() local ln = Drawing.new("Line"); ln.Thickness = 2; ln.Visible = false; return ln end
local function getCache(model)
	local c = MainESP.cache[model]; if c then return c end
	c = { box = Drawing.new("Square"), lines = {}, healthBarBg = Drawing.new("Square"), healthBar = Drawing.new("Square"), infoText = Drawing.new("Text") }
	c.box.Thickness = 2; c.box.Filled = false; c.box.Visible = false; c.healthBarBg.Thickness = 1; c.healthBarBg.Filled = true; c.healthBarBg.Color = Color3.fromRGB(20,20,20); c.healthBarBg.Visible = false; c.healthBar.Thickness = 0; c.healthBar.Filled = true; c.healthBar.Visible = false; c.infoText.Size = 13; c.infoText.Center = true; c.infoText.Outline = true; c.infoText.Visible = false
	for i = 1, 24 do table.insert(c.lines, newLine()) end
	MainESP.cache[model] = c; return c
end
local function hideCache(model)
	local c = MainESP.cache[model]; if not c then return end
	if c.box then c.box.Visible = false end; if c.healthBar then c.healthBar.Visible = false end; if c.healthBarBg then c.healthBarBg.Visible = false end; if c.infoText then c.infoText.Visible = false end; for _, ln in ipairs(c.lines) do ln.Visible = false end
end
local function removeCache(model)
	local c = MainESP.cache[model]; if not c then return end; pcall(function() c.box:Remove() end); pcall(function() c.healthBar:Remove() end); pcall(function() c.healthBarBg:Remove() end); pcall(function() c.infoText:Remove() end); for _, ln in ipairs(c.lines) do pcall(function() ln:Remove() end) end; MainESP.cache[model] = nil
end

local function getBones(model)
    local bones = {}
    local parts = {
        Head = model:FindFirstChild("Head"),
        UpperTorso = model:FindFirstChild("UpperTorso"),
        LowerTorso = model:FindFirstChild("LowerTorso"),
        LeftUpperArm = model:FindFirstChild("LeftUpperArm"),
        RightUpperArm = model:FindFirstChild("RightUpperArm"),
        LeftUpperLeg = model:FindFirstChild("LeftUpperLeg"),
        LeftLowerLeg = model:FindFirstChild("LeftLowerLeg"),
        RightUpperLeg = model:FindFirstChild("RightUpperLeg"),
        RightLowerLeg = model:FindFirstChild("RightLowerLeg"),
    }
    
	if parts.Head and parts.UpperTorso then table.insert(bones, {parts.Head, parts.UpperTorso}) end
    if parts.UpperTorso and parts.LowerTorso then table.insert(bones, {parts.UpperTorso, parts.LowerTorso}) end
    if parts.UpperTorso and parts.LeftUpperArm and parts.LeftLowerArm then table.insert(bones, {parts.UpperTorso, parts.LeftUpperArm}); table.insert(bones, {parts.LeftUpperArm, parts.LeftLowerArm}) end
	if parts.LeftLowerArm and parts.LeftHand then table.insert(bones, {parts.LeftLowerArm, parts.LeftHand}) end
    if parts.UpperTorso and parts.RightUpperArm and parts.RightLowerArm then table.insert(bones, {parts.UpperTorso, parts.RightUpperArm}); table.insert(bones, {parts.RightUpperArm, parts.RightLowerArm}) end
	if parts.RightLowerArm and parts.RightHand then table.insert(bones, {parts.RightLowerArm, parts.RightHand}) end
    if parts.LowerTorso and parts.LeftUpperLeg and parts.LeftLowerLeg then table.insert(bones, {parts.LowerTorso, parts.LeftUpperLeg}); table.insert(bones, {parts.LeftUpperLeg, parts.LeftLowerLeg}) end
	if parts.LeftLowerLeg and parts.LeftFoot then table.insert(bones, {parts.LeftLowerLeg, parts.LeftFoot}) end
    if parts.LowerTorso and parts.RightUpperLeg and parts.RightLowerLeg then table.insert(bones, {parts.LowerTorso, parts.RightUpperLeg}); table.insert(bones, {parts.RightUpperLeg, parts.RightLowerLeg}) end
	if parts.RightLowerLeg and parts.RightFoot then table.insert(bones, {parts.RightLowerLeg, parts.RightFoot}) end
    
    return bones
end

local function updateESP(model)
	local hum = model:FindFirstChildOfClass("Humanoid"); if not isAlive(hum) or not settings.espEnabled then hideCache(model) return end; local cache = getCache(model); local isVisible = hasLineOfSight(model); local espColor = isVisible and settings.espVisibleColor or settings.espOccludedColor; cache.box.Color = espColor; cache.infoText.Color = espColor; for _, ln in ipairs(cache.lines) do ln.Color = espColor end;

	local points = {
		model:FindFirstChild("Head"), model:FindFirstChild("HumanoidRootPart"),
		model:FindFirstChild("LeftFoot"), model:FindFirstChild("RightFoot"),
		model:FindFirstChild("LeftHand"), model:FindFirstChild("RightHand")
	}

	local anyOn, minX, minY, maxX, maxY = false, math.huge, math.huge, -math.huge, -math.huge
	for _, part in ipairs(points) do
		if part and part:IsA("BasePart") then
			local sp, on = screenPoint(part.Position)
			if on then anyOn = true; minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y); maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y) end
		end
	end

	if anyOn then
		if settings.boxESP then cache.box.Visible = true; cache.box.Position = Vector2.new(minX, minY); cache.box.Size = Vector2.new(math.max(2, maxX - minX), math.max(2, maxY - minY)) else cache.box.Visible = false end
		if settings.healthBar then local boxHeight = math.max(2, maxY - minY); local healthPercent = hum.Health / hum.MaxHealth; cache.healthBarBg.Visible = true; cache.healthBar.Visible = true; cache.healthBarBg.Position = Vector2.new(minX - 6, minY); cache.healthBarBg.Size = Vector2.new(4, boxHeight); cache.healthBar.Position = Vector2.new(minX - 6, minY + (boxHeight * (1 - healthPercent))); cache.healthBar.Size = Vector2.new(4, boxHeight * healthPercent); cache.healthBar.Color = Color3.fromHSV(0.33 * healthPercent, 1, 1) else cache.healthBarBg.Visible = false; cache.healthBar.Visible = false end
		if settings.infoESP then local player = Players:GetPlayerFromCharacter(model); local name = player and player.DisplayName or model.Name; local dist = (hrp and (hrp.Position - model.HumanoidRootPart.Position).Magnitude) or 0; cache.infoText.Visible = true; cache.infoText.Text = string.format("%s [%.0fm]", name, dist); cache.infoText.Position = Vector2.new(minX + (maxX - minX) / 2, minY - 15) else cache.infoText.Visible = false end
	else hideCache(model) end; local used = 0
	if settings.skelESP and anyOn then for _, pair in ipairs(getBones(model)) do local a, b = pair[1], pair[2]; if a and b and a:IsA("BasePart") then local a2, aon = screenPoint(a.Position); local b2, bon = screenPoint(b.Position); if aon and bon then used = used + 1; local ln = cache.lines[used] or newLine(); cache.lines[used] = ln; ln.From = a2; ln.To = b2; ln.Visible = true end end end end
	for i = used + 1, #cache.lines do cache.lines[i].Visible = false end
end

workspace.ChildRemoved:Connect(function(child) if MainESP.cache[child] then removeCache(child) end end)

local validTargets = {}
local aimbotTarget = nil

local function updateTargetsAndESP()
    local playerList = Players:GetPlayers()
    local playersToUpdate = 7 
    
    for i = 1, playersToUpdate do
        lastPlayerIndex = (lastPlayerIndex % #playerList) + 1
        local player = playerList[lastPlayerIndex]
        
        if player then
            local char = player.Character
            if char and isValidTarget(char) then
                updateESP(char)
                validTargets[player] = char
            else
                if validTargets[player] then
                    hideCache(char)
                    validTargets[player] = nil
                end
            end
        end
    end
    
    local bestDist = settings.aimRadius
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    aimbotTarget = nil
    
    for player, char in pairs(validTargets) do
        if hasLineOfSight(char) then
            local aimPart = char:FindFirstChild(settings.aimPart) or char:FindFirstChild("Head")
            if aimPart then
                local sp, onScreen = screenPoint(aimPart.Position)
                if onScreen then
                    local dist = (sp - center).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        aimbotTarget = char
                    end
                end
            end
        end
    end
end

local function aimAt(model)
	if not model then return end
	local targetPart = model:FindFirstChild(settings.aimPart) or model:FindFirstChild("Head"); if not targetPart then return end
	
    local backOffset = targetPart.CFrame * CFrame.new(0, 0, 1)

	if settings.aimMethod == "Camera" then
		local desired = CFrame.new(Camera.CFrame.Position, backOffset.Position)
		local s = tonumber(settings.smoothness) or 0
		if s <= 0 then Camera.CFrame = desired else Camera.CFrame = Camera.CFrame:Lerp(desired, 1 - math.clamp(s, 0.01, 0.99)) end
	elseif settings.aimMethod == "Mouse" then
		if mousemoverel then
			local targetPos, onScreen = screenPoint(backOffset.Position)
			if onScreen then
				local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
				local delta = targetPos - center
				local smoothFactor = math.clamp(settings.smoothness, 0, 1)
				local moveX = delta.X * (1 - smoothFactor)
				local moveY = delta.Y * (1 - smoothFactor)
				mousemoverel(moveX, moveY)
			end
		end
	end
end

coroutine.resume(coroutine.create(function()
    while task.wait(0.6) do
        if settings.hitboxExpanderEnabled then
            local sizeVec = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local transparencyValue = not isEnemy(player) and 1 or settings.hitboxTransparency

                    pcall(function()
                        local char = player.Character
                        char.RightUpperLeg.CanCollide = false
                        char.RightUpperLeg.Transparency = transparencyValue
                        char.RightUpperLeg.Size = sizeVec
                        
                        char.LeftUpperLeg.CanCollide = false
                        char.LeftUpperLeg.Transparency = transparencyValue
                        char.LeftUpperLeg.Size = sizeVec
                        
                        if char:FindFirstChild("HeadHB") then
                            char.HeadHB.CanCollide = false
                            char.HeadHB.Transparency = transparencyValue
                            char.HeadHB.Size = sizeVec
                        end
                        
                        char.HumanoidRootPart.CanCollide = false
                        char.HumanoidRootPart.Transparency = transparencyValue
                        char.HumanoidRootPart.Size = sizeVec
                    end)
                end
            end
        end
    end
end))

local guiElements = {}
local mainGuiFrame 

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if listeningForKeybind then
		local newKey
		if input.UserInputType.Name:find("Mouse") then newKey = input.UserInputType else newKey = input.KeyCode end
		settings.keybinds[listeningForKeybind.Name] = newKey
		listeningForKeybind.Text = tostring(newKey.Name)
		listeningForKeybind = nil
		return
	end
	if input.UserInputType == settings.keybinds.aimbotKey or input.KeyCode == settings.keybinds.aimbotKey then isAimbotKeyPressed = true end
	if input.KeyCode == settings.keybinds.toggleFly then setFlyEnabled(not settings.flyEnabled); if guiElements.flyEnabled and guiElements.flyEnabled.Update then guiElements.flyEnabled.Update() end end
	if input.KeyCode == settings.keybinds.toggleGUI then if mainGuiFrame then mainGuiFrame.Visible = not mainGuiFrame.Visible end end
	if input.KeyCode == settings.keybinds.loopKillKey then toggleLoopKill() end
    if input.KeyCode == settings.keybinds.killAllKey then
        toggleKillAllLoop()
    end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == settings.keybinds.aimbotKey or input.KeyCode == settings.keybinds.aimbotKey then isAimbotKeyPressed = false end
end)

local rsConn
rsConn = RunService.RenderStepped:Connect(function(delta)
	fovCircle.Visible = settings.fovCircle; fovCircle.Radius = settings.aimRadius; fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
	
	updateTargetsAndESP()
	
	if settings.aimbotEnabled and isAimbotKeyPressed and aimbotTarget then
		aimAt(aimbotTarget)
	end
	
	if settings.flyEnabled and flyLV and flyAO then
		local dir = Vector3.new()
		local cam = workspace.CurrentCamera
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

		flyLV.VectorVelocity = (dir.Magnitude > 0) and (dir.Unit * settings.flySpeed) or Vector3.new(0, 0, 0)
		flyAO.CFrame = cam.CFrame
	end
end)
_G.AimESP_RS_CONN = rsConn

local sg = Instance.new("ScreenGui"); sg.Name = "AimESP_UI"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true; sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
local function safeParentGui(gui) local ok, cg = pcall(function() return game:GetService("CoreGui") end); if ok and cg then gui.Parent = cg else gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end end
safeParentGui(sg)

local main = Instance.new("Frame"); main.Name = "Main"; main.Size = UDim2.new(0, 700, 0, 645); main.Position = UDim2.new(0.06, 0, 0.22, 0); main.BackgroundColor3 = Color3.fromRGB(18, 18, 20); main.BorderSizePixel = 0; main.Active = true; main.Draggable = false; main.Parent = sg
mainGuiFrame = main
local uiCorner = Instance.new("UICorner", main); uiCorner.CornerRadius = UDim.new(0, 12)
local uiStroke = Instance.new("UIStroke", main); uiStroke.Thickness = 2; uiStroke.Color = Color3.fromRGB(60,60,60)
local titleBar = Instance.new("Frame"); titleBar.Size = UDim2.new(1, 0, 0, 38); titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 32); titleBar.BorderSizePixel = 0; titleBar.Parent = main
local tbCorner = Instance.new("UICorner", titleBar); tbCorner.CornerRadius = UDim.new(0, 12)

local dragging = false; local dragStart = Vector2.new(0,0); local startPos = UDim2.new(0,0,0,0)
titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = main.Position end end)
titleBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

local title = Instance.new("TextLabel"); title.BackgroundTransparency = 1; title.Position = UDim2.new(0, 12, 0, 0); title.Size = UDim2.new(1, -200, 1, 0); title.Text = "AldoAimV4"; title.TextXAlignment = Enum.TextXAlignment.Left; title.TextColor3 = Color3.fromRGB(255, 255, 255); title.Font = Enum.Font.GothamBold; title.TextSize = 12; title.Parent = titleBar
local function topBtn(txt, xOff, isIcon) local b = Instance.new("TextButton"); b.Size = isIcon and UDim2.new(0, 28, 0, 28) or UDim2.new(0, 75, 0, 28); b.Position = UDim2.new(0, xOff, 0, 5); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(38,38,42); b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = isIcon and Enum.Font.SourceSansBold or Enum.Font.GothamBold; b.TextSize = isIcon and 20 or 14; b.Parent = titleBar; local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0, 6); local s = Instance.new("UIStroke", b); s.Thickness = 1; s.Color = Color3.fromRGB(70,70,72); return b end
local tabAimbotBtn = topBtn("Aimbot", 150); local tabESPBtn = topBtn("ESP", 230); local tabGunModsBtn = topBtn("Gun Mods", 310); local tabMiscBtn = topBtn("Misc", 390); local tabSettingsBtn = topBtn("⚙", 470, true)
local btnClose = Instance.new("TextButton"); btnClose.Name = "Close"; btnClose.Size = UDim2.new(0, 28, 0, 28); btnClose.Position = UDim2.new(1, -34, 0, 5); btnClose.Text = "X"; btnClose.BackgroundColor3 = Color3.fromRGB(55,35,35); btnClose.TextColor3 = Color3.fromRGB(255,120,120); btnClose.Font = Enum.Font.GothamBold; btnClose.TextSize = 16; btnClose.Parent = titleBar; Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 6)

local sidebar = Instance.new("Frame"); sidebar.Name = "Sidebar"; sidebar.Position = UDim2.new(0, 12, 0, 50); sidebar.Size = UDim2.new(0, 130, 1, -62); sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 28); sidebar.BorderSizePixel = 0; sidebar.Parent = main; Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

tabAimbotBtn.Parent = sidebar
tabESPBtn.Parent = sidebar
tabGunModsBtn.Parent = sidebar
tabMiscBtn.Parent = sidebar
tabSettingsBtn.Parent = sidebar

local buttonWidth = 114
local buttonHeight = 36
local buttonSpacing = 8

tabAimbotBtn.Size = UDim2.new(0, buttonWidth, 0, buttonHeight); tabAimbotBtn.Position = UDim2.new(0.5, -buttonWidth / 2, 0, buttonSpacing)
tabESPBtn.Size = UDim2.new(0, buttonWidth, 0, buttonHeight); tabESPBtn.Position = UDim2.new(0.5, -buttonWidth / 2, 0, buttonSpacing * 2 + buttonHeight)
tabGunModsBtn.Size = UDim2.new(0, buttonWidth, 0, buttonHeight); tabGunModsBtn.Position = UDim2.new(0.5, -buttonWidth / 2, 0, buttonSpacing * 3 + buttonHeight * 2)
tabMiscBtn.Size = UDim2.new(0, buttonWidth, 0, buttonHeight); tabMiscBtn.Position = UDim2.new(0.5, -buttonWidth / 2, 0, buttonSpacing * 4 + buttonHeight * 3)
tabSettingsBtn.Size = UDim2.new(0, buttonWidth, 0, buttonHeight); tabSettingsBtn.Position = UDim2.new(0.5, -buttonWidth/2, 1, -(buttonHeight + buttonSpacing))

local pages = Instance.new("Frame"); pages.Position = UDim2.new(0, 12 + 130 + 12, 0, 50); pages.Size = UDim2.new(1, -(12 + 130 + 12 + 12), 1, -62); pages.BackgroundColor3 = Color3.fromRGB(24, 24, 28); pages.BorderSizePixel = 0; pages.Parent = main; Instance.new("UICorner", pages).CornerRadius = UDim.new(0, 10)
local pageAim = Instance.new("Frame", pages); local pageESP = Instance.new("Frame", pages); local pageGunMods = Instance.new("Frame", pages); local pageMisc = Instance.new("Frame", pages); local pageSettings = Instance.new("Frame", pages); local allPages = { aim = pageAim, esp = pageESP, gunmods = pageGunMods, misc = pageMisc, settings = pageSettings }; for _, page in pairs(allPages) do page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = false end; pageAim.Visible = true
local function showPage(pageName) for name, page in pairs(allPages) do page.Visible = (name == pageName) end end
tabAimbotBtn.MouseButton1Click:Connect(function() showPage("aim") end); tabESPBtn.MouseButton1Click:Connect(function() showPage("esp") end); tabGunModsBtn.MouseButton1Click:Connect(function() showPage("gunmods") end); tabMiscBtn.MouseButton1Click:Connect(function() showPage("misc") end); tabSettingsBtn.MouseButton1Click:Connect(function() showPage("settings") end)
local hint = Instance.new("TextLabel"); hint.BackgroundTransparency = 1; hint.Position = UDim2.new(0, 12, 1, -22); hint.Size = UDim2.new(1, -24, 0, 16); hint.Font = Enum.Font.Gotham; hint.TextSize = 12; hint.TextXAlignment = Enum.TextXAlignment.Left; hint.TextColor3 = Color3.fromRGB(200,200,205); hint.Text = "dont steal this pls"; hint.Parent = main

local function restorePlayerCharacters()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            pcall(function()
                local char = player.Character
                local partsToRestore = {
                    char:FindFirstChild("RightUpperLeg"),
                    char:FindFirstChild("LeftUpperLeg"),
                    char:FindFirstChild("HumanoidRootPart"),
                    char:FindFirstChild("HeadHB")
                }
                for _, part in ipairs(partsToRestore) do
                    if part and part:IsA("BasePart") then
                        part.CanCollide = true
                        part.Transparency = 0
						part.Size = Vector3.new(1, 1, 1)
                    end
                end
            end)
        end
    end
end

btnClose.MouseButton1Click:Connect(function()
    if rsConn then rsConn:Disconnect() end
    if _G.AimESP_CACHE_CONNECTIONS then 
        for _,c in pairs(_G.AimESP_CACHE_CONNECTIONS) do c:Disconnect() end
    end

    setNoclipEnabled(false)
    setFullBright(false)
    disableFly()
    settings.hitboxExpanderEnabled = false

    pcall(function() if _G.AimESP_Originals then Camera.FieldOfView = _G.AimESP_Originals.Fov end end)
    restoreAllWeaponData()
    restorePlayerCharacters()

    if fovCircle then pcall(function() fovCircle:Remove() end) end
    for m,_ in pairs(MainESP.cache) do removeCache(m) end

    _G.AimESP_RS_CONN = nil
    _G.AimESP_CACHE_CONNECTIONS = nil
    _G.AimESP_FOV_CIRCLE = nil
    _G.AimESP_Originals = nil

    sg:Destroy() 
end)

local function mkToggle(parent, label, getVal, setVal, y) local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, -24, 0, 34); btn.Position = UDim2.new(0, 12, 0, y); btn.Text = ""; btn.BackgroundColor3 = Color3.fromRGB(34,34,38); btn.Parent = parent; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8); local st = Instance.new("UIStroke", btn); st.Thickness = 1; st.Color = Color3.fromRGB(70,70,74); local lbl = Instance.new("TextLabel"); lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1, -12, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0); lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = label; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 14; lbl.Parent = btn; local statusCircle = Instance.new("Frame"); statusCircle.Size = UDim2.new(0, 14, 0, 14); statusCircle.Position = UDim2.new(1, -25, 0.5, -7); statusCircle.BorderSizePixel = 0; statusCircle.Parent = btn; Instance.new("UICorner", statusCircle).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", statusCircle).Color = Color3.fromRGB(18,18,20); local function updateVisuals() local value = getVal(); if type(value) == "boolean" then statusCircle.Visible = true; if value then statusCircle.BackgroundColor3 = Color3.fromRGB(40, 160, 80) else statusCircle.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end; lbl.Text = label else statusCircle.Visible = false; lbl.Text = string.format("%s: %s", label, tostring(value)) end end; btn.MouseButton1Click:Connect(function() local currentValue = getVal(); if type(currentValue) == "boolean" then setVal(not currentValue); updateVisuals() end end); updateVisuals(); return {Button = btn, Label = lbl, Update = updateVisuals, Stroke = st} end
local function mkSlider(parent, label, minV, maxV, step, getV, setV, y) local lbl = Instance.new("TextLabel"); lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 12, 0, y); lbl.Size = UDim2.new(1, -24, 0, 20); lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = label.. ": ".. tostring(getV()); lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 14; lbl.Parent = parent; local bar = Instance.new("Frame"); bar.Position = UDim2.new(0, 12, 0, y + 24); bar.Size = UDim2.new(1, -24, 0, 12); bar.BackgroundColor3 = Color3.fromRGB(18, 18, 20); bar.BorderSizePixel = 0; bar.Parent = parent; Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6); local barStroke = Instance.new("UIStroke", bar); barStroke.Thickness = 1; barStroke.Color = Color3.fromRGB(80,80,80); local fill = Instance.new("Frame"); fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255); fill.BorderSizePixel = 0; fill.Size = UDim2.new((getV()-minV)/(maxV - minV), 0, 1, 0); fill.Parent = bar; Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6); local dragging = false; local function setFromMouse(x) local rel = math.clamp((x - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1); local raw = minV + (maxV - minV) * rel; local stepped = (step >= 1 and math.floor(raw/step+0.5)*step) or (tonumber(string.format("%."..string.len(tostring(step):split(".")[2]).."f", math.floor(raw/step+0.5)*step))); stepped = math.clamp(stepped, minV, maxV); setV(stepped); lbl.Text = label.. ": ".. tostring(stepped); fill.Size = UDim2.new((stepped-minV)/(maxV - minV), 0, 1, 0) end; bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; setFromMouse(i.Position.X) end end); UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then setFromMouse(i.Position.X) end end); UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end); return {Label = lbl, Fill = fill, Min = minV, Max = maxV, Bar = bar, BarStroke = barStroke} end
local function mkButton(parent, text, y, x, w) local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0, w, 0, 34); btn.Position = UDim2.new(0, x, 0, y); btn.Text = text; btn.BackgroundColor3 = Color3.fromRGB(34,34,38); btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = Enum.Font.Gotham; btn.TextSize = 14; btn.Parent = parent; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8); local st = Instance.new("UIStroke", btn); st.Thickness = 1; st.Color = Color3.fromRGB(70,70,74); return btn, st end
local function mkKeybind(parent, name, label, y) local lbl = Instance.new("TextLabel", parent); lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 12, 0, y); lbl.Size = UDim2.new(0, 250, 0, 34); lbl.Text = label; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 14; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.TextXAlignment = Enum.TextXAlignment.Left; guiElements[name .. "_label"] = {Label=lbl}; local btn, stroke = mkButton(parent, tostring(settings.keybinds[name].Name), y, 282, 260); btn.Name = name; btn.MouseButton1Click:Connect(function() if listeningForKeybind then listeningForKeybind.Text = tostring(settings.keybinds[listeningForKeybind.Name].Name) end; listeningForKeybind = btn; btn.Text = "..." end); guiElements[name .. "_button"] = {Button = btn, Stroke = stroke}; return btn end

guiElements.aimbotEnabled = mkToggle(pageAim, "Aimbot Enabled", function() return settings.aimbotEnabled end, function(v) settings.aimbotEnabled = v end, 8)
local aimMethods = {"Camera", "Mouse"}; local currentAimMethodIdx = 1
guiElements.aimMethod = mkToggle(pageAim, "Aim Method", function() return settings.aimMethod end, function() end, 50)
guiElements.aimMethod.Button.MouseButton1Click:Connect(function() currentAimMethodIdx = (currentAimMethodIdx % #aimMethods) + 1; settings.aimMethod = aimMethods[currentAimMethodIdx]; guiElements.aimMethod.Update() end)
guiElements.fovCircle = mkToggle(pageAim, "Show FOV Circle", function() return settings.fovCircle end, function(v) settings.fovCircle = v end, 92)
guiElements.aimRadius = mkSlider(pageAim, "FOV Radius", 50, 1400, 1, function() return settings.aimRadius end, function(v) settings.aimRadius = v end, 134)
guiElements.smoothness = mkSlider(pageAim, "Smoothness (0=Snap)", 0, 1, 0.01, function() return tonumber(string.format("%.2f", settings.smoothness)) end, function(v) settings.smoothness = tonumber(string.format("%.2f", v)) end, 194)
local aimParts = {"Head", "UpperTorso", "HumanoidRootPart"}; local currentAimPartIdx = table.find(aimParts, settings.aimPart) or 1
guiElements.aimPart = mkToggle(pageAim, "Aim Part", function() return settings.aimPart end, function() end, 254)
guiElements.aimPart.Button.MouseButton1Click:Connect(function() currentAimMethodIdx = (currentAimMethodIdx % #aimParts) + 1; settings.aimPart = aimParts[currentAimPartIdx]; guiElements.aimPart.Update() end)
mkToggle(pageAim, "Hitbox Expander", function() return settings.hitboxExpanderEnabled end, function(v) settings.hitboxExpanderEnabled = v end, 296)
mkToggle(pageAim, "Triggerbot: press J to Deactivate", function() return settings.triggerbot end, function(v) settings.triggerbot = v end, 338)


local hitboxSizeLabel = Instance.new("TextLabel"); hitboxSizeLabel.Name = "HitboxSizeLabel"; hitboxSizeLabel.BackgroundTransparency = 1; hitboxSizeLabel.Position = UDim2.new(0, 12, 0, 380); hitboxSizeLabel.Size = UDim2.new(1, -24, 0, 20); hitboxSizeLabel.Font = Enum.Font.Gotham; hitboxSizeLabel.TextSize = 14; hitboxSizeLabel.Text = "Hitbox Size (1-50) dont put it over like 20 it might not work"; hitboxSizeLabel.TextXAlignment = Enum.TextXAlignment.Left; hitboxSizeLabel.TextColor3 = Color3.fromRGB(255,255,255); hitboxSizeLabel.Parent = pageAim
local hitboxSizeInput = Instance.new("TextBox"); hitboxSizeInput.Name = "HitboxSizeInput"; hitboxSizeInput.Size = UDim2.new(1, -24, 0, 34); hitboxSizeInput.Position = UDim2.new(0, 12, 0, 404); hitboxSizeInput.BackgroundColor3 = Color3.fromRGB(34,34,38); hitboxSizeInput.TextColor3 = Color3.fromRGB(220,220,220); hitboxSizeInput.Font = Enum.Font.Code; hitboxSizeInput.TextSize = 14; hitboxSizeInput.ClearTextOnFocus = false; hitboxSizeInput.Text = tostring(settings.hitboxSize); hitboxSizeInput.TextXAlignment = Enum.TextXAlignment.Left; hitboxSizeInput.Parent = pageAim; Instance.new("UICorner", hitboxSizeInput).CornerRadius = UDim.new(0, 8); local hsiStroke = Instance.new("UIStroke", hitboxSizeInput); hsiStroke.Thickness = 1; hsiStroke.Color = Color3.fromRGB(70,70,74)
hitboxSizeInput.FocusLost:Connect(function(enterPressed)
	local num = tonumber(hitboxSizeInput.Text)
	if num then
		num = math.floor(math.clamp(num, 1, 50))
		settings.hitboxSize = num
	end
	hitboxSizeInput.Text = tostring(settings.hitboxSize)
end)

mkSlider(pageAim, "Hitbox Transparency (Enemies)", 0, 1, 0.01, function() return tonumber(string.format("%.2f", settings.hitboxTransparency)) end, function(v) settings.hitboxTransparency = tonumber(string.format("%.2f", v)) end, 446)

guiElements.espEnabled = mkToggle(pageESP, "ESP Enabled", function() return settings.espEnabled end, function(v) settings.espEnabled = v end, 8)
guiElements.boxESP = mkToggle(pageESP, "Box ESP", function() return settings.boxESP end, function(v) settings.boxESP = v end, 50)
guiElements.skelESP = mkToggle(pageESP, "Skeleton ESP", function() return settings.skelESP end, function(v) settings.skelESP = v end, 92)
guiElements.healthBar = mkToggle(pageESP, "Health Bar", function() return settings.healthBar end, function(v) settings.healthBar = v end, 134)
guiElements.infoESP = mkToggle(pageESP, "Info (Name/Dist)", function() return settings.infoESP end, function(v) settings.infoESP = v end, 176)
guiElements.targetPlayers = mkToggle(pageESP, "Include Players", function() return settings.targetPlayers end, function(v) settings.targetPlayers = v end, 218)

guiElements.infiniteAmmo = mkToggle(pageGunMods, "Infinite Ammo", function() return gunModSettings.infiniteAmmo end, function(v) gunModSettings.infiniteAmmo = v; updateAllWeaponMods() end, 8)
guiElements.fastFire = mkToggle(pageGunMods, "Fast Fire", function() return gunModSettings.fastFire end, function(v) gunModSettings.fastFire = v; updateAllWeaponMods() end, 50)
guiElements.fireRate = mkSlider(pageGunMods, "Fire Rate", 0.01, 0.2, 0.01, function() return gunModSettings.fireRate end, function(v) gunModSettings.fireRate = v; if gunModSettings.fastFire then updateAllWeaponMods() end end, 92)
guiElements.noRecoil = mkToggle(pageGunMods, "No Recoil", function() return gunModSettings.noRecoil end, function(v) gunModSettings.noRecoil = v; updateAllWeaponMods() end, 152)
guiElements.allAuto = mkToggle(pageGunMods, "All Automatic", function() return gunModSettings.allAuto end, function(v) gunModSettings.allAuto = v; updateAllWeaponMods() end, 194)
guiElements.noSpread = mkToggle(pageGunMods, "No Spread", function() return gunModSettings.noSpread end, function(v) gunModSettings.noSpread = v; updateAllWeaponMods() end, 236)

guiElements.flyEnabled = mkToggle(pageMisc, "Fly Enabled", function() return settings.flyEnabled end, setFlyEnabled, 8)
guiElements.noclipEnabled = mkToggle(pageMisc, "Noclip", function() return settings.noclipEnabled end, setNoclipEnabled, 50)
guiElements.fullBright = mkToggle(pageMisc, "Full Bright", function() return settings.fullBright end, setFullBright, 92)
guiElements.flySpeed = mkSlider(pageMisc, "Fly Speed", 10, 200, 5, function() return settings.flySpeed end, function(v) settings.flySpeed = v end, 134)
local killAllBtn, killAllStroke = mkButton(pageMisc, "Toggle Kill All (F)", 194, 12, 530)
killAllBtn.MouseButton1Click:Connect(toggleKillAllLoop)
mkToggle(pageMisc, "Click", function() return settings.killAllClick end, function(v) settings.killAllClick = v end, 236)

local loopKillLabel = Instance.new("TextLabel"); loopKillLabel.Name = "LoopKillLabel"; loopKillLabel.BackgroundTransparency = 1; loopKillLabel.Position = UDim2.new(0, 12, 0, 278); loopKillLabel.Size = UDim2.new(1, -24, 0, 20); loopKillLabel.Font = Enum.Font.Gotham; loopKillLabel.TextSize = 14; loopKillLabel.Text = "Loop Kill Target (Key: H)"; loopKillLabel.TextXAlignment = Enum.TextXAlignment.Left; loopKillLabel.TextColor3 = Color3.fromRGB(255,255,255); loopKillLabel.Parent = pageMisc
loopKillTextBox = Instance.new("TextBox"); loopKillTextBox.Name = "LoopKillInput"; loopKillTextBox.Size = UDim2.new(0, 260, 0, 34); loopKillTextBox.Position = UDim2.new(0, 12, 0, 302); loopKillTextBox.BackgroundColor3 = Color3.fromRGB(34,34,38); loopKillTextBox.TextColor3 = Color3.fromRGB(220,220,220); loopKillTextBox.Font = Enum.Font.Code; loopKillTextBox.TextSize = 14; loopKillTextBox.ClearTextOnFocus = false; loopKillTextBox.PlaceholderText = "Enter player name..."; loopKillTextBox.TextXAlignment = Enum.TextXAlignment.Left; loopKillTextBox.Parent = pageMisc; Instance.new("UICorner", loopKillTextBox).CornerRadius = UDim.new(0, 8); local lktbStroke = Instance.new("UIStroke", loopKillTextBox); lktbStroke.Thickness = 1; lktbStroke.Color = Color3.fromRGB(70,70,74)
local openPlayerListBtn, openPlayerListStroke = mkButton(pageMisc, "Open Player List", 302, 282, 260)

local playerListMainFrame = Instance.new("Frame")
playerListMainFrame.Name = "PlayerListGUI"
playerListMainFrame.Size = UDim2.new(0, 300, 0, 400)
playerListMainFrame.Position = UDim2.new(1, 10, 0, 0)
playerListMainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
playerListMainFrame.BorderSizePixel = 0
playerListMainFrame.Visible = false
playerListMainFrame.Parent = main
local plCorner = Instance.new("UICorner", playerListMainFrame); plCorner.CornerRadius = UDim.new(0, 8)
local plStroke = Instance.new("UIStroke", playerListMainFrame); plStroke.Color = Color3.fromRGB(80, 80, 85); plStroke.Thickness = 1
local plTitleBar = Instance.new("Frame", playerListMainFrame); plTitleBar.Name = "TitleBar"; plTitleBar.Size = UDim2.new(1, 0, 0, 35); plTitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45); plTitleBar.BorderSizePixel = 0
local plTitleCorner = Instance.new("UICorner", plTitleBar); plTitleCorner.CornerRadius = UDim.new(0, 8)
local plTitleLabel = Instance.new("TextLabel", plTitleBar); plTitleLabel.Name = "TitleLabel"; plTitleLabel.Size = UDim2.new(1, 0, 1, 0); plTitleLabel.BackgroundTransparency = 1; plTitleLabel.Font = Enum.Font.GothamBold; plTitleLabel.Text = "Player List"; plTitleLabel.TextColor3 = Color3.fromRGB(220, 220, 225); plTitleLabel.TextSize = 16
local plScrollingFrame = Instance.new("ScrollingFrame", playerListMainFrame); plScrollingFrame.Name = "PlayerList"; plScrollingFrame.Size = UDim2.new(1, -20, 1, -80); plScrollingFrame.Position = UDim2.new(0, 10, 0, 45); plScrollingFrame.BackgroundTransparency = 1; plScrollingFrame.BorderSizePixel = 0; plScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 125); plScrollingFrame.ScrollBarThickness = 5
local plListLayout = Instance.new("UIListLayout", plScrollingFrame); plListLayout.Padding = UDim.new(0, 5); plListLayout.SortOrder = Enum.SortOrder.LayoutOrder
local plSelectedPlayerLabel = Instance.new("TextLabel", playerListMainFrame); plSelectedPlayerLabel.Name = "SelectedPlayerLabel"; plSelectedPlayerLabel.Size = UDim2.new(1, -20, 0, 25); plSelectedPlayerLabel.Position = UDim2.new(0, 10, 1, -35); plSelectedPlayerLabel.BackgroundTransparency = 1; plSelectedPlayerLabel.Font = Enum.Font.Gotham; plSelectedPlayerLabel.Text = "Selected: None"; plSelectedPlayerLabel.TextColor3 = Color3.fromRGB(180, 180, 185); plSelectedPlayerLabel.TextSize = 14; plSelectedPlayerLabel.TextXAlignment = Enum.TextXAlignment.Left

local function updatePlayerListGUI()
    for _, child in ipairs(plScrollingFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    local players = Players:GetPlayers()
    table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)
    for i, player in ipairs(players) do
        local playerFrame = Instance.new("Frame", plScrollingFrame); playerFrame.Name = "PlayerEntry"; playerFrame.Size = UDim2.new(1, 0, 0, 50); playerFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50); playerFrame.BorderSizePixel = 0; playerFrame.LayoutOrder = i; Instance.new("UICorner", playerFrame).CornerRadius = UDim.new(0, 6)
        local thumbnail = Instance.new("ImageLabel", playerFrame); thumbnail.Name = "Thumbnail"; thumbnail.Size = UDim2.new(0, 40, 0, 40); thumbnail.Position = UDim2.new(0, 5, 0.5, -20); thumbnail.BackgroundTransparency = 1; Instance.new("UICorner", thumbnail).CornerRadius = UDim.new(1, 0)
        local nameLabel = Instance.new("TextLabel", playerFrame); nameLabel.Name = "NameLabel"; nameLabel.Size = UDim2.new(1, -70, 1, 0); nameLabel.Position = UDim2.new(0, 55, 0, 0); nameLabel.BackgroundTransparency = 1; nameLabel.Font = Enum.Font.Gotham; nameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"; nameLabel.TextColor3 = Color3.fromRGB(210, 210, 215); nameLabel.TextSize = 14; nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        local selectButton = Instance.new("TextButton", playerFrame); selectButton.Name = "SelectButton"; selectButton.Size = UDim2.new(0, 60, 0, 30); selectButton.Position = UDim2.new(1, -65, 0.5, -15); selectButton.BackgroundColor3 = Color3.fromRGB(80, 80, 85); selectButton.Font = Enum.Font.GothamBold; selectButton.Text = "Select"; selectButton.TextColor3 = Color3.fromRGB(255, 255, 255); selectButton.TextSize = 14; Instance.new("UICorner", selectButton).CornerRadius = UDim.new(0, 5)
        
        local success, content, isReady = pcall(Players.GetUserThumbnailAsync, Players, player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        if success and isReady then thumbnail.Image = content end
        
        selectButton.MouseButton1Click:Connect(function()
            plSelectedPlayerLabel.Text = "Selected: " .. player.DisplayName
            if loopKillTextBox then
                loopKillTextBox.Text = player.Name
            end
        end)
        
        selectButton.MouseEnter:Connect(function() selectButton.BackgroundColor3 = Color3.fromRGB(100, 100, 105) end)
        selectButton.MouseLeave:Connect(function() selectButton.BackgroundColor3 = Color3.fromRGB(80, 80, 85) end)
    end
end

openPlayerListBtn.MouseButton1Click:Connect(function()
    playerListMainFrame.Visible = not playerListMainFrame.Visible
    if playerListMainFrame.Visible then updatePlayerListGUI() end
end)
Players.PlayerAdded:Connect(function() if playerListMainFrame.Visible then updatePlayerListGUI() end end)
Players.PlayerRemoving:Connect(function() if playerListMainFrame.Visible then updatePlayerListGUI() end end)
local configTextBox = Instance.new("TextBox"); configTextBox.Size = UDim2.new(1, -24, 0, 60); configTextBox.Position = UDim2.new(0, 12, 0, 8); configTextBox.BackgroundColor3 = Color3.fromRGB(34,34,38); configTextBox.TextColor3 = Color3.fromRGB(220,220,220); configTextBox.Font = Enum.Font.Code; configTextBox.TextSize = 14; configTextBox.ClearTextOnFocus = false; configTextBox.PlaceholderText = "Paste config string here..."; configTextBox.TextXAlignment = Enum.TextXAlignment.Left; configTextBox.TextYAlignment = Enum.TextYAlignment.Top; configTextBox.MultiLine = true; configTextBox.Parent = pageSettings; Instance.new("UICorner", configTextBox).CornerRadius = UDim.new(0, 8); local tbStroke = Instance.new("UIStroke", configTextBox); tbStroke.Thickness = 1; tbStroke.Color = Color3.fromRGB(70,70,74)
local saveBtn, saveBtnStroke = mkButton(pageSettings, "Copy Config to Clipboard", 76, 12, 260)
local loadBtn, loadBtnStroke = mkButton(pageSettings, "Load Config from Textbox", 76, 282, 260)
guiElements.toggleGUIKeybind = mkKeybind(pageSettings, "toggleGUI", "Toggle GUI", 120)
guiElements.toggleFlyKeybind = mkKeybind(pageSettings, "toggleFly", "Toggle Fly", 162)
guiElements.aimbotKeyKeybind = mkKeybind(pageSettings, "aimbotKey", "Aimbot Key", 204)
guiElements.loopKillKeybind = mkKeybind(pageSettings, "loopKillKey", "Loop Kill Key", 246)
local legitBtn, legitBtnStroke = mkButton(pageSettings, "Load Legit Config", 296, 12, 260)
local rageBtn, rageBtnStroke = mkButton(pageSettings, "Load Rage Config ", 296, 282, 260)

local autoAimBtn, autoAimBtnStroke = mkButton(pageSettings, "Load AutoAim Config(just look in someones vicinity)", 338, 12, 530)

local autoAimConfig = {
    aimbotEnabled = true,
    fovCircle = true, 
    aimRadius = 300,  
    smoothness = 0, 

    espEnabled = true,
    boxESP = true,
    skelESP = false,
    healthBar = false,
    infoESP = true,

    hitboxExpanderEnabled = true,
    hitboxSize = 24,
    hitboxTransparency = 1,

    fullBright = true
}

local autoAimGunConfig = {
    infiniteAmmo = true,
    fastFire = true,
    fireRate = 0.01,
    noRecoil = true,
    allAuto = true,
    noSpread = true
}

local themeTitle = Instance.new("TextLabel", pageSettings); themeTitle.Size=UDim2.new(1,-24,0,20); themeTitle.Position=UDim2.new(0,12,0,392); themeTitle.BackgroundTransparency=1; themeTitle.Font=Enum.Font.GothamBold; themeTitle.Text="Themes"; themeTitle.TextColor3=Color3.new(1,1,1); themeTitle.TextXAlignment=Enum.TextXAlignment.Left; themeTitle.TextSize=16
local themeDarker, themeDarkerStroke = mkButton(pageSettings, "Darker", 412, 12, 125)
local themeBright, themeBrightStroke = mkButton(pageSettings, "Bright", 412, 147, 125)
local themeOcean, themeOceanStroke = mkButton(pageSettings, "Ocean", 412, 282, 125)
local themeAmethyst, themeAmethystStroke = mkButton(pageSettings, "Amethyst", 412, 417, 125)

local function updateGUIFromSettings()
    for name, el in pairs(guiElements) do
        if el.Update then el.Update() end
        if el.Label and el.Fill then
            local value
            if settings[name] then
                value = settings[name]
            elseif gunModSettings[name] then
                value = gunModSettings[name]
            end
            if value ~= nil then
                el.Label.Text = el.Label.Text:match("(.+):") .. " " .. tostring(value)
                local range = el.Max - el.Min
                if range > 0 then
                    el.Fill.Size = UDim2.new((value - el.Min) / range, 0, 1, 0)
                end
            end
        end
    end
    guiElements.toggleGUIKeybind_button.Button.Text = settings.keybinds.toggleGUI.Name
    guiElements.toggleFlyKeybind_button.Button.Text = settings.keybinds.toggleFly.Name
    guiElements.aimbotKeyKeybind_button.Button.Text = settings.keybinds.aimbotKey.Name
    guiElements.loopKillKeybind_button.Button.Text = settings.keybinds.loopKillKey.Name
end

local function loadConfig(mainSettings, gunSettings)
    if mainSettings then
        for k, v in pairs(mainSettings) do
            if settings[k] ~= nil then
                settings[k] = v
            end
        end
    end

    if gunSettings then
        for k, v in pairs(gunSettings) do
            if gunModSettings[k] ~= nil then
                gunModSettings[k] = v
            end
        end
        updateAllWeaponMods()
    end
    setFullBright(settings.fullBright)
    
    updateGUIFromSettings() 
    
    hint.Text = "Config loaded!"; task.wait(2); hint.Text = "dont steal this pls"
end

saveBtn.MouseButton1Click:Connect(function() if setclipboard then pcall(function() setclipboard(HttpService:JSONEncode(settings)) end); hint.Text = "Config copied!" else hint.Text = "setclipboard unavailable." end; task.wait(2); hint.Text = "dont steal this pls" end)
loadBtn.MouseButton1Click:Connect(function() local content = configTextBox.Text; if content and #content > 0 then local s, d = pcall(HttpService.JSONDecode, HttpService, content); if s and d then for k, v in pairs(d) do if k=="keybinds" then for key, val in pairs(v) do settings.keybinds[key]=Enum.KeyCode[val.Name] or Enum.UserInputType[val.Name] end elseif string.find(k, "Color") then settings[k]=Color3.new(v.r,v.g,v.b) else settings[k]=v end end; hint.Text="Config loaded!"; updateGUIFromSettings() else hint.Text="Invalid config." end else hint.Text="Textbox is empty." end; task.wait(2); hint.Text="dont steal this pls" end)
legitBtn.MouseButton1Click:Connect(function() loadConfig({aimbotEnabled=true, fovCircle=false, aimRadius=80, smoothness=0.5, espEnabled=true, boxESP=true, skelESP=false, healthBar=true, infoESP=true, fullBright=false, noclipEnabled=false}) end)
rageBtn.MouseButton1Click:Connect(function() loadConfig({aimbotEnabled=true, fovCircle=true, aimRadius=300, smoothness=1.0, espEnabled=true, boxESP=true, skelESP=true, healthBar=true, infoESP=true, fullBright=true, noclipEnabled=true}) end)
autoAimBtn.MouseButton1Click:Connect(function() loadConfig(autoAimConfig, autoAimGunConfig) end)autoAimBtn.MouseButton1Click:Connect(function() loadConfig(autoAimConfig, autoAimGunConfig) end)
local themes = { Darker = {main=Color3.fromRGB(18,18,20), title=Color3.fromRGB(28,28,32), page=Color3.fromRGB(24,24,28), item=Color3.fromRGB(34,34,38), stroke=Color3.fromRGB(70,70,74), text=Color3.fromRGB(255,255,255), fill=Color3.fromRGB(255,255,255), bar=Color3.fromRGB(18,18,20)}, Bright = {main=Color3.fromRGB(245,245,245), title=Color3.fromRGB(230,230,230), page=Color3.fromRGB(255,255,255), item=Color3.fromRGB(220,220,220), stroke=Color3.fromRGB(180,180,180), text=Color3.fromRGB(10,10,10), fill=Color3.fromRGB(50,50,50), bar=Color3.fromRGB(200,200,200)}, Ocean = {main=Color3.fromRGB(20, 30, 45), title=Color3.fromRGB(25, 40, 60), page=Color3.fromRGB(22, 35, 50), item=Color3.fromRGB(30, 50, 75), stroke=Color3.fromRGB(80, 120, 160), text=Color3.fromRGB(200, 220, 255), fill=Color3.fromRGB(100, 180, 255), bar=Color3.fromRGB(20, 30, 45)}, Amethyst = {main=Color3.fromRGB(40, 25, 50), title=Color3.fromRGB(55, 35, 70), page=Color3.fromRGB(45, 30, 60), item=Color3.fromRGB(60, 40, 80), stroke=Color3.fromRGB(140, 90, 180), text=Color3.fromRGB(230, 210, 255), fill=Color3.fromRGB(190, 140, 255), bar=Color3.fromRGB(40, 25, 50)}}
local function applyTheme(theme) currentTheme = theme; main.BackgroundColor3, titleBar.BackgroundColor3, pages.BackgroundColor3, sidebar.BackgroundColor3, hint.TextColor3 = theme.main, theme.title, theme.page, theme.page, theme.stroke; title.TextColor3, themeTitle.TextColor3 = theme.text, theme.text; for name, el in pairs(guiElements) do if el.Button then el.Button.BackgroundColor3=theme.item; el.Label.TextColor3=theme.text; if el.Stroke then el.Stroke.Color=theme.stroke end end; if el.Bar then el.Bar.BackgroundColor3=theme.bar; el.BarStroke.Color=theme.stroke; el.Fill.BackgroundColor3=theme.fill; el.Label.TextColor3=theme.text end end; for btn, _ in pairs({[themeDarker]=1, [themeBright]=1, [themeOcean]=1, [themeAmethyst]=1, [tabAimbotBtn]=1, [tabESPBtn]=1, [tabGunModsBtn]=1, [tabMiscBtn]=1, [tabSettingsBtn]=1, [killAllBtn]=1}) do btn.BackgroundColor3 = theme.item; btn.TextColor3 = theme.text; for _,c in ipairs(btn:GetChildren()) do if c:IsA("UIStroke") then c.Color = theme.stroke end end end; configTextBox.BackgroundColor3, configTextBox.TextColor3, tbStroke.Color = theme.item, theme.text, theme.stroke; saveBtn.BackgroundColor3, loadBtn.BackgroundColor3, legitBtn.BackgroundColor3, rageBtn.BackgroundColor3 = theme.item, theme.item, theme.item, theme.item; saveBtn.TextColor3, loadBtn.TextColor3, legitBtn.TextColor3, rageBtn.TextColor3 = theme.text, theme.text, theme.text, theme.text; saveBtnStroke.Color, loadBtnStroke.Color, legitBtnStroke.Color, rageBtnStroke.Color, themeDarkerStroke.Color, themeBrightStroke.Color, themeOceanStroke.Color, themeAmethystStroke.Color, killAllStroke.Color, openPlayerListStroke.Color = theme.stroke, theme.stroke, theme.stroke, theme.stroke, theme.stroke, theme.stroke, theme.stroke, theme.stroke, theme.stroke, theme.stroke; loopKillLabel.TextColor3, loopKillTextBox.BackgroundColor3, loopKillTextBox.TextColor3, lktbStroke.Color = theme.text, theme.item, theme.text, theme.stroke; hitboxSizeLabel.TextColor3 = theme.text; hitboxSizeInput.BackgroundColor3 = theme.item; hitboxSizeInput.TextColor3 = theme.text; hsiStroke.Color = theme.stroke; 
playerListMainFrame.BackgroundColor3 = theme.title 
plTitleBar.BackgroundColor3 = theme.page      
plStroke.Color = theme.stroke              
plTitleLabel.TextColor3 = theme.text        
plSelectedPlayerLabel.TextColor3 = theme.text 

for _, frame in ipairs(plScrollingFrame:GetChildren()) do
    if frame:IsA("Frame") then
        frame.BackgroundColor3 = theme.item 
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("TextLabel") then
                child.TextColor3 = theme.text 
            elseif child:IsA("TextButton") then
                child.BackgroundColor3 = theme.page 
                child.TextColor3 = theme.text       
            end
        end
    end
end
end

for btn, theme in pairs({[themeDarker]=themes.Darker, [themeBright]=themes.Bright, [themeOcean]=themes.Ocean, [themeAmethyst]=themes.Amethyst}) do btn.MouseButton1Click:Connect(function() applyTheme(theme) end) end
applyTheme(themes.Darker)

local resizeHandle = Instance.new("Frame"); resizeHandle.Size = UDim2.new(0, 15, 0, 15); resizeHandle.AnchorPoint = Vector2.new(1, 1); resizeHandle.Position = UDim2.new(1, 0, 1, 0); resizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 80); resizeHandle.ZIndex = main.ZIndex + 2; resizeHandle.Parent = main; local resizing, resizeStartPos, resizeStartSize, minSize = false, Vector2.new(), Vector2.new(), Vector2.new(450, 400); resizeHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = true; resizeStartPos = UIS:GetMouseLocation(); resizeStartSize = main.AbsoluteSize; pcall(function() input:StopPropagation() end) end end); UIS.InputChanged:Connect(function(input) if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then local mouseDelta = UIS:GetMouseLocation() - resizeStartPos; local newSize = resizeStartSize + mouseDelta; main.Size = UDim2.new(0, math.max(minSize.X, newSize.X), 0, math.max(minSize.Y, newSize.Y)) end end); UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end end)

_G.AimESP_CACHE_CONNECTIONS = {}
local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(char)
        if char:FindFirstChildOfClass("Humanoid") then
		    char.Humanoid.Died:Connect(function()
			    if MainESP.cache[char] then removeCache(char) end
		    end)
        end
	end)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.Died:Connect(function()
            if MainESP.cache[player.Character] then removeCache(player.Character) end
        end)
    end
end

for _, player in ipairs(Players:GetPlayers()) do onPlayerAdded(player) end
table.insert(_G.AimESP_CACHE_CONNECTIONS, Players.PlayerAdded:Connect(onPlayerAdded))
table.insert(_G.AimESP_CACHE_CONNECTIONS, Players.PlayerRemoving:Connect(function(player)
	if player.Character and MainESP.cache[player.Character] then
		removeCache(player.Character)
	end
end))
end