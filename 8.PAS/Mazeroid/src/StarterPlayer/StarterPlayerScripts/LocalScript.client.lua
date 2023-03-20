local step = game:GetService('RunService');
local uis = game:GetService('UserInputService');

local meteor = game.ReplicatedStorage.Meteor;

local plr = game.Players.LocalPlayer;
local plrGui = plr:WaitForChild('PlayerGui');
local cam = game.Workspace.CurrentCamera;
cam.CameraType = Enum.CameraType.Scriptable;

local rocketHandler = require(game.ReplicatedStorage.RocketHandler);

local meteors = {};

local function Lerp(a, b, alpha)
	return a + (b - a) * alpha;
end

local function SetEffects()
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
	for i,v in pairs(game.Workspace.Layers:GetChildren()) do
		v.Transparency = 1;
	end
	game.ReplicatedStorage.Skybox.Parent = game.Lighting;

	local spawnLocations = game.Workspace.MeteorSpawnLocations;
	local start = spawnLocations.Origin.Position;
	local r = (start - spawnLocations.End.Position).Magnitude;
	for i = 1,1000 do
		local newMeteor = meteor:Clone();
		newMeteor.Parent = game.Workspace;
		newMeteor.CFrame = CFrame.new(start-Vector3.new(0,40+math.random()*40,0))
			*CFrame.Angles(0,math.random()*math.pi*2,0)
			*CFrame.new(0,0,math.sqrt(math.random())*r)
			*CFrame.Angles(math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2);
		newMeteor.Size = Vector3.new(10,10,10)+Vector3.new(20,20,20)*math.random()
		newMeteor.BrickColor = BrickColor.Blue();
	end
end

local function SetupGame()
	SetEffects();
	
	local spawnLocations = game.Workspace.MeteorSpawnLocations;
	local start = spawnLocations.Origin.Position;
	local r = (start - spawnLocations.End.Position).Magnitude;
	
	for i = 1,10000 do
		local radius = 1 + 6 * math.random();
		local newMeteor = meteor:Clone();
		newMeteor.Parent = game.Workspace;
		newMeteor.CFrame = CFrame.new(start)
			*CFrame.Angles(0,math.random()*math.pi*2,0)
			*CFrame.new(0,0,math.sqrt(math.random())*r)
			*CFrame.Angles(math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2);
		newMeteor.Size = Vector3.new(1,1,1) * radius;
		meteors[#meteors + 1] = {
			Position = Vector2.new(newMeteor.CFrame.Position.X, newMeteor.CFrame.Position.Z);
			Radius = radius/2;
			Model = newMeteor;
		};
	end
	
	local explosion = game.Workspace.Explosion;
	explosion.Parent = nil;
	local playerRocket = rocketHandler:new();
	local cameraTarget = playerRocket;
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
		explosion.Parent = game.Workspace;
		explosion.Position = playerRocket.Object.PrimaryPart.Position;
		explosion.ParticleEmitter:Emit(100);
		playerRocket:Destroy();
		cameraTarget = nil;
	end):Run();
	
	local cameraInterval = Vector2.new(25, 50);
	step.RenderStepped:Connect(function()
		if cameraTarget == nil then return; end
		
		local zDist = Lerp(cameraInterval.X, cameraInterval.Y, cameraTarget:GetSpeedAlpha())
		cam.CFrame = CFrame.new(cameraTarget.Object.PrimaryPart.Position)*CFrame.Angles(-math.pi/2,0,0)*CFrame.new(0,0,zDist)
	end)
end


SetupGame();
