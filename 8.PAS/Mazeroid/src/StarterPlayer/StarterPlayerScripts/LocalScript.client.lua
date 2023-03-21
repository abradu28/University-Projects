local step = game:GetService('RunService');
local uis = game:GetService('UserInputService');
local ts = game:GetService('TweenService');

local plr = game.Players.LocalPlayer;
local plrGui = plr:WaitForChild('PlayerGui');
local ui = game.StarterGui:WaitForChild('UI');
ui.Parent = plrGui;

local states = {
	IsFading = false;
	IsPlaying = false;
	IsTesting = false;
}

local scene = game.ReplicatedStorage.Scene;
scene.Parent = nil;
local meteor = game.ReplicatedStorage.Meteor;
meteor.Parent = nil;
local explosion = game.ReplicatedStorage.Explosion;
explosion.Parent = nil;

local cameraTarget = nil;

local cam = game.Workspace.CurrentCamera;
cam.CameraType = Enum.CameraType.Scriptable;

local rocketHandler = require(game.ReplicatedStorage.RocketHandler);

local meteors = {};
local rockets = {};

local function Lerp(a, b, alpha)
	return a + (b - a) * alpha;
end

function FadeIn(t)
	local tween = ts:Create(ui.Fade.Main, TweenInfo.new(t, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0),
		{Size = UDim2.new(0.001,0,0.001,0)})
	
	states.IsFading = true;
	tween.Completed:Connect(function(a)
		if a == Enum.PlaybackState.Completed then
			ui.Fade.BackgroundTransparency = 0;
			states.IsFading = false;
		end
	end)
	tween:Play();
end

function FadeOut(t)
	local tween = ts:Create(ui.Fade.Main, TweenInfo.new(t, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0),
		{Size = UDim2.new(1.5,0,1.5,0)})
	ui.Fade.BackgroundTransparency = 1;
	
	states.IsFading = true;
	tween.Completed:Connect(function(a)
		if a == Enum.PlaybackState.Completed then
			states.IsFading = false;
		end
	end)
	tween:Play();
end

local function SetEffects()
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
	for i,v in pairs(game.Workspace.Details.Layers:GetChildren()) do
		v.Transparency = 1;
	end
	game.ReplicatedStorage.Skybox.Parent = game.Lighting;

	local spawnLocations = game.Workspace.MeteorSpawnLocations;
	local start = spawnLocations.Origin.Position;
	local r = (start - spawnLocations.End.Position).Magnitude;
	for i = 1,1000 do
		local newMeteor = meteor:Clone();
		newMeteor.Parent = game.Workspace.Meteors_Effect;
		newMeteor.CFrame = CFrame.new(start-Vector3.new(0,40+math.random()*40,0))
							*CFrame.Angles(0,math.random()*math.pi*2,0)
							*CFrame.new(0,0,math.sqrt(math.random())*r)
							*CFrame.Angles(math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2);
		newMeteor.Size = Vector3.new(10,10,10)+Vector3.new(20,20,20)*math.random()
		newMeteor.BrickColor = BrickColor.Blue();
	end
	
	local rotSpeed = 90;
	step.RenderStepped:Connect(function(t)
		scene.Rocket:PivotTo(scene.Rocket.PrimaryPart.CFrame*CFrame.Angles(-math.rad(rotSpeed)*t,0,0));
	end)
end

local function ClearGame()
	ui.GetRich.Visible = false;
	ui.Buttons.Visible = true;
	game.Workspace.Meteors:ClearAllChildren();
	game.Workspace.Rockets:ClearAllChildren(); -- TODO scoate functionalul de racheta
	states.IsPlaying = false;
	meteors = {};
	for i,v in pairs(rockets) do
		v:Destroy();
	end
	rockets = {};
end

local function SetupSoloGame()
	ui.Buttons.Visible = false;
	
	local spawnLocations = game.Workspace.MeteorSpawnLocations;
	local start = spawnLocations.Origin.Position;
	local r = (start - spawnLocations.End.Position).Magnitude;
	
	local innerCircle = 0.0125/4;
	
	for i = 1,10000 do
		local radius = 1 + 6 * math.random();
		local newMeteor = meteor:Clone();
		newMeteor.Parent = game.Workspace.Meteors;
		newMeteor.CFrame = CFrame.new(start)
			*CFrame.Angles(0,math.random()*math.pi*2,0)
			*CFrame.new(0,0,math.sqrt(innerCircle+(1-innerCircle)*math.random())*r)
			*CFrame.Angles(math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2);
		newMeteor.Size = Vector3.new(1,1,1) * radius;
		meteors[#meteors + 1] = {
			Position = Vector2.new(newMeteor.CFrame.Position.X, newMeteor.CFrame.Position.Z);
			Radius = radius/2;
			Model = newMeteor;
		};
	end
	
	wait(0.5)
	FadeOut(1);
	
	local function finishGame()
		FadeIn(1.5);
		wait(2)
		ClearGame();
		FadeOut(1.5);
		ShowScene();
	end
	
	local playerRocket = rocketHandler:new();
	playerRocket:SetInputsGetter(function()
		local forward = uis:IsKeyDown(Enum.KeyCode.W);
		local backward = uis:IsKeyDown(Enum.KeyCode.S);
		local left = uis:IsKeyDown(Enum.KeyCode.A);
		local right = uis:IsKeyDown(Enum.KeyCode.D);

		return Vector2.new(((left == true) and -1 or 0) + ((right == true) and 1 or 0), ((forward == true) and 1 or 0) + ((backward == true) and -1 or 0));
	end):SetCheckCollisions(function()
		local root = playerRocket.Object.PrimaryPart;
		local rocketPos = Vector2.new(root.Position.X, root.Position.Z);
		local rocketR = playerRocket.Settings.Radius;

		local s = os.clock();
		for i,v in pairs(meteors) do
			local distVec = v.Position - rocketPos
			local distSqr = distVec.X^2 + distVec.Y^2;
			if (distSqr <= (rocketR + v.Radius)^2) then
				return true;
			end
		end
		return false;
	end):SetOnCollision(function()
		playerRocket:Stop();
		local explosionNew = explosion:Clone();
		explosionNew.Parent = game.Workspace;
		explosionNew.Position = playerRocket.Object.PrimaryPart.Position;
		explosionNew.ParticleEmitter:Emit(100);
		game.Debris:AddItem(explosionNew, 2);
		
		ui.GetRich.Text = 'DIE TRYING';
		ui.GetRich.TextLabel.Text = 'DIE TRYING';
		ui.GetRich.Visible = true;
		ui.GetRich.TextTransparency = 1;
		ui.GetRich.TextStrokeTransparency = 1;
		ui.GetRich.TextLabel.TextTransparency = 1;
		ui.GetRich.TextLabel.TextStrokeTransparency = 1;

		ts:Create(ui.GetRich, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0),
			{TextTransparency = 0, TextStrokeTransparency = 0}):Play();
		ts:Create(ui.GetRich.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0),
			{TextTransparency = 0, TextStrokeTransparency = 0}):Play();
		wait(3);
		
		finishGame();
	end):SetFinishChecker(function()
		local rocketPos = playerRocket.Object.PrimaryPart.Position;
		local distSqrt = rocketPos - start;
		distSqrt = distSqrt:Dot(distSqrt);
		
		if distSqrt >= r*r then
			return true;
		else
			return false;
		end
	end):SetOnFinish(function()

		ui.GetRich.Text = 'GET RICH OR DIE TRYING';
		ui.GetRich.TextLabel.Text = 'GET RICH OR DIE TRYING';
		
		ui.GetRich.Visible = true;
		ui.GetRich.TextTransparency = 1;
		ui.GetRich.TextStrokeTransparency = 1;
		ui.GetRich.TextLabel.TextTransparency = 1;
		ui.GetRich.TextLabel.TextStrokeTransparency = 1;

		ts:Create(ui.GetRich, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0),
			{TextTransparency = 0, TextStrokeTransparency = 0}):Play();
		ts:Create(ui.GetRich.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0),
			{TextTransparency = 0, TextStrokeTransparency = 0}):Play();
		wait(3);
		finishGame();
	end):Run();
	
	rockets[#rockets + 1] = playerRocket;
	
	local cameraInterval = Vector2.new(25, 50);
	cameraTarget = function()
		local zDist = Lerp(cameraInterval.X, cameraInterval.Y, playerRocket:GetSpeedAlpha())
		return CFrame.new(playerRocket.Object.PrimaryPart.Position)*CFrame.Angles(-math.pi/2,0,0)*CFrame.new(0,0,zDist)
	end
	states.IsPlaying = true;
end

function SetupCamera()
	step.RenderStepped:Connect(function()
		if cameraTarget == nil then return; end
		
		cam.CFrame = cameraTarget();
	end)
end

function SetupButtons()
	ui.Buttons.PlaySolo.Activated:Connect(function()
		for i,v in pairs(states) do
			if v == true then
				return;				-- Sa nu paresti function haulting. Odata apasat, nu mai poate fi activat pana nu se termina de procesat
			end
		end
		
		FadeIn(1);
		wait(1)
		SetupSoloGame();
	end)
end

function ShowScene()
	scene.Parent = game.Workspace;
	cameraTarget = function()
		return scene.Camera.CFrame
	end
end

function Start()
	SetupButtons();
	SetEffects();
	ShowScene();
	SetupCamera();
end


Start()
