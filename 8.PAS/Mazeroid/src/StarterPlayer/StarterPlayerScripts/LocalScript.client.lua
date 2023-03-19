local step = game:GetService('RunService');
local uis = game:GetService('UserInputService');

local rocket = game.Workspace.Rocket;
local root = rocket.PrimaryPart;
local meteor = script.Meteor;

local cam = game.Workspace.CurrentCamera;
cam.CameraType = Enum.CameraType.Scriptable;

local cameraInterval = Vector2.new(15, 25);
local speedInterval = Vector2.new(5, 50)
local currentSpeed = speedInterval.X;
local acceleration = 25;

local turnAngle = 120;

local meteors = {};

local function Lerp(a, b, alpha)
	return a + (b - a) * alpha;
end

local function UpdateVariables(t, moveVec)
	local deltaSpeed = acceleration * t * moveVec.Y;
	currentSpeed = math.clamp(currentSpeed + (deltaSpeed), speedInterval.X, speedInterval.Y);
end

local function UpdateRocketPosition(t, moveVec)
	local deltaAngle = math.rad(turnAngle) * t * moveVec.X;
	local deltaDist = currentSpeed * t;
	rocket:PivotTo(root.CFrame*CFrame.new(0,0, -deltaDist)*CFrame.Angles(0, -deltaAngle, 0));
end

local function SetupGame()
	for i,v in pairs(game.Workspace.Layers:GetChildren()) do
		v.Transparency = 1;
	end
	script.Skybox.Parent = game.Lighting;
	
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

local function CheckCollisions()
	local rocketPos = Vector2.new(root.Position.X, root.Position.Z);
	local rocketR = root.Size.X/2;
	
	for i,v in pairs(meteors) do
		local distVec = v.Position - rocketPos
		local distSqr = distVec.X^2 + distVec.Y^2;
		if (distSqr <= (rocketR + v.Radius)^2) then
			return true, i;
		end
	end
	return false, -1;
end

step.RenderStepped:Connect(function()
	local zDist = Lerp(cameraInterval.X, cameraInterval.Y, (currentSpeed - speedInterval.X)/(speedInterval.Y - speedInterval.X))
	cam.CFrame = CFrame.new(root.Position)*CFrame.Angles(-math.pi/2,0,0)*CFrame.new(0,0,zDist)
end)

step.Stepped:Connect(function(totalT, t)
	local forward = uis:IsKeyDown(Enum.KeyCode.W);
	local backward = uis:IsKeyDown(Enum.KeyCode.S);
	local left = uis:IsKeyDown(Enum.KeyCode.A);
	local right = uis:IsKeyDown(Enum.KeyCode.D);
	
	local moveVec = Vector2.new(((left == true) and -1 or 0) + ((right == true) and 1 or 0), ((forward == true) and 1 or 0) + ((backward == true) and -1 or 0));
	
	UpdateVariables(t, moveVec);
	UpdateRocketPosition(t, moveVec);
	local res, index = CheckCollisions();
	if res == true then
		warn("YES");
		meteors[index].Model:Destroy();
		table.remove(meteors, index);
	end
end)

SetupGame();
