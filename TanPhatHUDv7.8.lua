--// 🌌 TanPhatHUD + Fly V3 (Full GUI + Integrated)
-- by Heheboy + TanPhatHUD + XNEO 😎

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
repeat task.wait() until player.Character and player.Character:FindFirstChild("Humanoid")

local char = player.Character
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-----------------------------------------------------------
-- 🌈 TanPhatHUD GUI
-----------------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TanPhatHUD"
gui.ResetOnSpawn = false

-- Toggle Button
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 70, 0, 70)
toggleBtn.Position = UDim2.new(1, -85, 1, -100)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://137676684711350"
toggleBtn.ImageColor3 = Color3.fromRGB(0, 255, 255)
toggleBtn.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5, 0)
corner.Parent = toggleBtn

local UserInputService = game:GetService("UserInputService")

local dragging
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	toggleBtn.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = toggleBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		update(input)
	end
end)

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 250)
frame.Position = UDim2.new(0.5, -100, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui
frame.Size = UDim2.new(0, 200, 0, 320)

--// Kéo thả frame (hỗ trợ cả PC và điện thoại)
local UIS = game:GetService("UserInputService")
local dragging, dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		mousePos = input.Position
		framePos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement 
		or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		frame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end)

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 255, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3

local title = Instance.new("TextLabel", frame)
title.Text = "🚀 TanPhatHUD"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 25)

-- Helper to create buttons
local function makeBtn(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9, 0, 0, 40)
	b.Position = UDim2.new(0.05, 0, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 18
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	b.Parent = frame
	return b
end

-- Buttons
local flyBtn = makeBtn("✈️ Fly", 30)
local invisBtn = makeBtn("👻 Invisible: OFF", 75)
local speedBtn = makeBtn("💨 Speed: OFF", 120)
local noclipBtn = makeBtn("🚪 NoClip: OFF", 165)
local espBtn = makeBtn("🔍 ESP: OFF", 210)
local teleBtn = makeBtn("🌀 Teleport", 255)

-----------------------------------------------------------
-- 🌀 TELEPORT - Chọn người chơi để bay tới
-----------------------------------------------------------
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- Khung danh sách người chơi
local teleFrame = Instance.new("Frame")
teleFrame.Size = UDim2.new(0.9, 0, 0, 200)
teleFrame.Position = UDim2.new(0.05, 0, 0, 300)
teleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
teleFrame.BackgroundTransparency = 0.1
teleFrame.Visible = false
teleFrame.Active = true -- Bật Active để nhận touch mobile
teleFrame.ZIndex = 10 -- ZIndex cao hơn để không bị che
teleFrame.Parent = frame

Instance.new("UICorner", teleFrame).CornerRadius = UDim.new(0, 10)

-- Scroll
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.Active = true  -- Bật Active để touch bên trong hoạt động
scroll.Selectable = true   -- Hỗ trợ mobile/gamepad
scroll.ZIndex = 11
scroll.Parent = teleFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0, 5)

-- Thêm nút player
local function addPlayerButton(target)
	if target == player then return end
	if not target.Character then return end

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = target.Name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.ZIndex = 12 -- Luôn nằm trên ScrollFrame
	btn.Parent = scroll
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		if player.Character and target.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
			if hrp and targetHRP then
				local tween = TweenService:Create(
					hrp,
					TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)}
				)
				tween:Play()
			end
		end
	end)
end

-- Refresh danh sách player
local function refreshPlayerList()
	for _, child in pairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	for _, p in pairs(Players:GetPlayers()) do
		addPlayerButton(p)
	end
end

-- Nút Teleport
teleBtn.MouseButton1Click:Connect(function()
	teleFrame.Visible = not teleFrame.Visible
	if teleFrame.Visible then
		refreshPlayerList()
	end
end)

-- Cập nhật khi player vào/ra
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 5)
end)

-----------------------------------------------------------
-- 👻 Invisible
-----------------------------------------------------------
local invisible = false
invisBtn.MouseButton1Click:Connect(function()
	invisible = not invisible
	for _, p in pairs(char:GetDescendants()) do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
			p.LocalTransparencyModifier = invisible and 1 or 0
		elseif p:IsA("Decal") then
			p.Transparency = invisible and 1 or 0
		end
	end
	TweenService:Create(invisBtn, TweenInfo.new(0.3), {
		BackgroundColor3 = invisible and Color3.fromRGB(0,200,255) or Color3.fromRGB(60,60,60)
	}):Play()
	invisBtn.Text = invisible and "👻 Invisible: ON" or "👻 Invisible: OFF"
end)

-----------------------------------------------------------
-- 💨 Speed
-----------------------------------------------------------
local speedBoost = false
local NORMAL_WALK, BOOST_SPEED = 16, 90
speedBtn.MouseButton1Click:Connect(function()
	speedBoost = not speedBoost
	hum.WalkSpeed = speedBoost and BOOST_SPEED or NORMAL_WALK
	TweenService:Create(speedBtn, TweenInfo.new(0.3), {
		BackgroundColor3 = speedBoost and Color3.fromRGB(0,200,255) or Color3.fromRGB(60,60,60)
	}):Play()
	speedBtn.Text = speedBoost and "💨 Speed: ON" or "💨 Speed: OFF"
end)

-----------------------------------------------------------
-- 🚪 NoClip
-----------------------------------------------------------
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	TweenService:Create(noclipBtn, TweenInfo.new(0.3), {
		BackgroundColor3 = noclip and Color3.fromRGB(0,200,255) or Color3.fromRGB(60,60,60)
	}):Play()
	noclipBtn.Text = noclip and "🚪 NoClip: ON" or "🚪 NoClip: OFF"
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _, v in pairs(char:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	else
		for _, v in pairs(char:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end
end)

-----------------------------------------------------------
-- 🔍 ESP người chơi
-----------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local espEnabled = false
local espObjects = {}

-- Hàm tạo ESP cho 1 player
local function createESP(target)
	if not target.Character then return end
	local head = target.Character:FindFirstChild("Head")
	if not head then return end

	-- Nếu đã có ESP cũ thì xóa
	if espObjects[target] then
		if espObjects[target].connection then
			espObjects[target].connection:Disconnect()
		end
		if espObjects[target].billboard then
			espObjects[target].billboard:Destroy()
		end
		espObjects[target] = nil
	end

	-- Billboard GUI
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP"
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.AlwaysOnTop = true
	billboard.Adornee = head
	billboard.Parent = head

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 16
	textLabel.TextStrokeTransparency = 0.5
	textLabel.Parent = billboard

	-- Cập nhật khoảng cách + đổi màu cầu vồng
	local connection
	connection = RunService.RenderStepped:Connect(function()
		if head and espEnabled then
			local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local distance = (hrp.Position - head.Position).Magnitude
				textLabel.Text = string.format("%s (%.0fm)", target.Name, distance)

				-- 🌈 Hiệu ứng bảy màu
				local t = tick() * 2 -- tốc độ đổi màu
				local r = math.sin(t) * 127 + 128
				local g = math.sin(t + 2) * 127 + 128
				local b = math.sin(t + 4) * 127 + 128
				textLabel.TextColor3 = Color3.fromRGB(r, g, b)
			end
		else
			connection:Disconnect()
		end
	end)

	espObjects[target] = {billboard = billboard, connection = connection}
end

-- Xóa ESP
local function removeESP(target)
	if espObjects[target] then
		if espObjects[target].connection then
			espObjects[target].connection:Disconnect()
		end
		if espObjects[target].billboard then
			espObjects[target].billboard:Destroy()
		end
		espObjects[target] = nil
	end
end

-- Toggle ESP
local function toggleESP()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "🔍 ESP: ON" or "🔍 ESP: OFF"
	espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0,200,255) or Color3.fromRGB(60,60,60)

	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				createESP(p)
			end
		end
	else
		for p, _ in pairs(espObjects) do
			removeESP(p)
		end
	end
end

espBtn.MouseButton1Click:Connect(toggleESP)

-- Gắn listener cho player mới
for _, p in pairs(Players:GetPlayers()) do
	if p ~= player then
		p.CharacterAdded:Connect(function()
			if espEnabled then
				createESP(p)
			end
		end)
	end
end

Players.PlayerAdded:Connect(function(p)
	if p ~= player then
		p.CharacterAdded:Connect(function()
			if espEnabled then
				createESP(p)
			end
		end)
	end
end)

Players.PlayerRemoving:Connect(removeESP)
-- Cập nhật khi có người ra/vào game
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-----------------------------------------------------------
-- ✈️ Fly V3 GUI (Integrated)
-----------------------------------------------------------

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false
main.Enabled = false
flyBtn.MouseButton1Click:Connect(function()
	main.Enabled = true
end)

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "FLY GUI V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "FLY GUI V3";
	Text = "BY XNEO";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;

Frame.Active = true -- main = gui
Frame.Draggable = true

onof.MouseButton1Down:connect(function()

	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true



		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end




	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then



		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			--	game.Players.LocalPlayer.Character.Animate.Disabled = true
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false




	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false



	end





end)

local tis

up.MouseButton1Down:connect(function()
	tis = up.MouseEnter:connect(function()
		while tis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
		end
	end)
end)

up.MouseLeave:connect(function()
	if tis then
		tis:Disconnect()
		tis = nil
	end
end)

local dis

down.MouseButton1Down:connect(function()
	dis = down.MouseEnter:connect(function()
		while dis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
		end
	end)
end)

down.MouseLeave:connect(function()
	if dis then
		dis:Disconnect()
		dis = nil
	end
end)


game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false

end)


plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then


		tpwalking = false
		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
	end
end)
mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'cannot be less than 1'
		wait(1)
		speed.Text = speeds
	else
		speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()

					local hb = game:GetService("RunService").Heartbeat	


					tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end

				end)
			end
		end
	end
end)

closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	up.Visible = false
	down.Visible = false
	onof.Visible = false
	plus.Visible = false
	speed.Visible = false
	mine.Visible = false
	mini.Visible = false
	mini2.Visible = true
	main.Frame.BackgroundTransparency = 1
	closebutton.Position =  UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible = true
	down.Visible = true
	onof.Visible = true
	plus.Visible = true
	speed.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0 
	closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)

-- 🎛️ Toggle GUI (trượt lên/xuống)
local guiVisible = false
toggleBtn.MouseButton1Click:Connect(function()
	guiVisible = not guiVisible
	if guiVisible then
		frame.Visible = true
		-- trượt lên từ dưới màn hình lên giữa
		TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -100, 0.5, -160)
		}):Play()
		toggleBtn.ImageColor3 = Color3.fromRGB(255, 80, 80)
	else
		-- trượt xuống từ giữa màn hình xuống dưới
		TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, -100, 1.2, 0)
		}):Play()
		-- ẩn frame sau khi tween xong
		task.delay(0.4, function()
			frame.Visible = false
		end)
		toggleBtn.ImageColor3 = Color3.fromRGB(0, 255, 255)
	end
end)

local targetPlayers = {
	["red_game43"] = true,
	["rip_indra"] = true,
	["Axiore"] = true,
	["Polkster"] = true,
	["wenlocktoad"] = true,
	["Daigrock"] = true,
	["SpyderSammy"] = true,
	["oofficialnoobie"] = true,
	["Uzoth"] = true,
	["Azarth"] = true,
	["arlthmetic"] = true,
	["Death_King"] = true,
	["Lunoven"] = true,
	["TheGreateAced"] = true,
	["rip_fud"] = true,
	["drip_mama"] = true,
	["layandikit12"] = true,
	["Sammy"] = true
}

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceId = game.PlaceId
local JobId = game.JobId

function Hop()
	local servers = {}
	local cursor = ""

	for i = 1, 3 do -- thử tối đa 3 lần
		local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
		if cursor ~= "" then
			url = url .. "&cursor=" .. cursor
		end

		local req = game:HttpGet(url)
		local data = HttpService:JSONDecode(req)

		for _, server in pairs(data.data) do
			if server.playing < server.maxPlayers and server.id ~= JobId then
				table.insert(servers, server.id)
			end
		end

		if data.nextPageCursor then
			cursor = data.nextPageCursor
		else
			break
		end
	end

	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
	end
end

spawn(function()
	while true do
		wait(1)
		for _, v in pairs(game.Players:GetPlayers()) do
			if targetPlayers[v.Name] then
				Hop()
				break
			end
		end
	end
end)
local lastNotificationTime = 0
local notificationCooldown = 10
local currentTime = tick()
if currentTime - lastNotificationTime >= notificationCooldown then
	game.StarterGui:SetCore("SendNotification", {
		Title = "TanPhat HUD",
		Text = "Successfully",
		Icon = "rbxassetid://137676684711350", -- dấu phẩy không thừa
		Duration = 1
	})
	lastNotificationTime = currentTime
end

-----------------------------------------------------------
--               ⚠️ Thông báo Script                     --
-----------------------------------------------------------
-- hiện script đang trong quá trình thử nghiệm và có thể có lỗi.
-- vui lòng báo cáo nếu có lỗi để fix nhanh chóng.
-- cảm ơn đã chơi!
-- by tiktok: @duongtanphat14072013.
-- by facebook: Dương Phát.
-- sẽ có thêm nhiều tính năng trong tương lai.
-- sẽ cố gắng rep facebook nhanh nhất.
-- mọi thắc mắc vui lòng ib facebook bên trên để được giải đáp nhanh chóng.
-- thêm tính năng chạy nhanh hơn.
-- nút mở đóng có thể di chuyển.
-- thông báo rõ hơn trên tiktok: @nobitalienminhuyenthoai.
-- chức năng đi xuyên tường.
-- fix fly mobile.
-- fix lại fly.
-- thích hợp pc và mobile.

-- The script is currently in the testing phase and may contain errors.
-- Please report any errors for quick fixes.
-- Thank you for playing!
-- by tiktok: @nobitalienminhuyenthoai.
-- by facebook: Dương Phát.
-- there will be more features in the future.
-- i will try to reply to facebook as soon as possible.
-- For any inquiries, please message us on the Facebook above for a quick response.
-- Added faster running feature.
-- The open/close button can be moved.
-- Clearer announcement on TikTok: @duongtanphat14072013.
-- Added through wall function.
-- Fixed mobile flying.
-- Fixed flying again.
-- Suitable for PC and mobile.
