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
local rectangle = require(game.ReplicatedStorage.Rectangle);
local quadTree = require(game.ReplicatedStorage.QuadTree);
local neuralNetwork = require(game.ReplicatedStorage.NeuralNetwork);

local meteors = {};
local quadMeteors = nil;
local meteorsCount = 10000;
local meteorsCountAI = 2500;
local meteorSize = Vector3.new(2,5);

local rockets = {};
local artificialInteligence = {};

local aiCount = 30;
local aiHandler = nil;
local aiCameraSwitchSpeed = 300;
local aiTimeScale = Vector2.new(1,4);
local aiInputs = 9;
local aiResolutionAngle = 120;
local aiResolutionLength = 30;
local aiMutationChance = 0.0005;

local sliderCallback = nil;

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

local function DestroyMeteors()
	if quadMeteors then
		quadMeteors = nil;
	end
	game.Workspace.Meteors:ClearAllChildren();
	game.Workspace.Rockets:ClearAllChildren();
end

local function GenerateMeteors(count)
	local spawnLocations = game.Workspace.MeteorSpawnLocations;
	local start = spawnLocations.Origin.Position;
	local r = (start - spawnLocations.End.Position).Magnitude;

	local bounds = rectangle:new(start.X - r, start.Z - r, r*2, r*2);
	quadMeteors = quadTree:new(bounds);

	local innerCircle = 0.1/32;

	for i = 1, count do
		local radius = meteorSize.X + (meteorSize.Y - meteorSize.X) * math.random();
		local newMeteor = meteor:Clone();
		newMeteor.Parent = game.Workspace.Meteors;
		newMeteor.CFrame = CFrame.new(start)
			*CFrame.Angles(0,math.random()*math.pi*2,0)
			*CFrame.new(0,0,math.sqrt(innerCircle+(1-innerCircle)*math.random())*r)
			*CFrame.Angles(math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2);
		newMeteor.Size = Vector3.new(1,1,1) * radius * 2;
		quadMeteors:insert({x = newMeteor.Position.X, y = newMeteor.Position.Z, radius = radius});
		if i % 250 == 0 then
			wait();
		end
	end
end

local function ClearGame()
	ui.GetRich.Visible = false;
	ui.AIFrame.Visible = false;
	
	if aiHandler then
		aiHandler:Disconnect();
		aiHandler = nil;
	end
	DestroyMeteors();
	
	ui.Buttons.Visible = true;
	states.IsPlaying = false;
	states.IsTesting = false;
	
	ui.AIFrame.Slider.Bar.Circle.Position = UDim2.new(0, 0, 0.5, 0);
	
	sliderCallback = nil;
	meteors = {};
	for i,v in pairs(rockets) do
		v:Destroy();
	end
	for i,v in pairs(artificialInteligence) do
		v:Destroy();
	end
	rockets = {};
	artificialInteligence = {};
end

local function SetupSoloGame()
	ui.Buttons.Visible = false;
	states.IsPlaying = true;
	
	GenerateMeteors(meteorsCount);
	local spawnLocations = game.Workspace.MeteorSpawnLocations;
	local start = spawnLocations.Origin.Position;
	local r = (start - spawnLocations.End.Position).Magnitude;

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

		local meteorsToCheck = {};
		local insert = function(point)
			meteorsToCheck[#meteorsToCheck + 1] = point;
		end
		quadMeteors:queryRange({x = rocketPos.X, y = rocketPos.Y}, rocketR + meteorSize.Y, insert);

		for i,v in pairs(meteorsToCheck) do
			local distVec = Vector2.new(v.x, v.y) - rocketPos
			local distSqr = distVec.X^2 + distVec.Y^2;
			if (distSqr <= (rocketR + v.radius)^2) then
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
	end):Start();
	rockets[#rockets + 1] = playerRocket;
	
	local cameraInterval = Vector2.new(25, 50);
	cameraTarget = function()
		local zDist = Lerp(cameraInterval.X, cameraInterval.Y, playerRocket:GetSpeedAlpha())
		return CFrame.new(playerRocket.Object.PrimaryPart.Position)*CFrame.Angles(-math.pi/2,0,0)*CFrame.new(0,0,zDist)
	end
end

local function SetupAITraining()
	ui.Buttons.Visible = false;
	ui.AIFrame.Visible = true;
	states.IsTesting = true;
	
	GenerateMeteors(meteorsCountAI);
	local spawnLocations = game.Workspace.MeteorSpawnLocations;
	local start = spawnLocations.Origin.Position;
	local r = (start - spawnLocations.End.Position).Magnitude;

	wait(0.5)
	FadeOut(1);
	
	local generation = 1;
	local rocketsData = {};
	local timeScale = 1;
	local timePassed = 0;
	local restarting = false;
	local function restartTraining()
		if restarting == true then return; end
		restarting = true;
		
		for i,v in pairs(rockets) do
			v:Pause();
		end
		
		generation += 1;
		warn("GENERATION:",generation);
		
		for i,v in pairs(rocketsData) do
			if v.TimeFinished == 0 then
				v.TimeFinished = timePassed;
			end
		end
		
		local fitness = {};
		local fitnessSum = 0;
		for i = 1,aiCount do
			local data = rocketsData[i];
			--print('FITNESS VALUES: ', data.Distance, data.TimeFinished)
			fitness[i] = (data.Distance^6)/data.TimeFinished;
			fitnessSum += fitness[i];
		end
		--print(fitness);
		local newAIs = {};
		for i = 1,aiCount do
			local val = math.random()*fitnessSum;
			--print(val);
			local ai1 = -1;
			for j = 1, aiCount do
				if val <= fitness[j] then
					ai1 = j;
					break;
				else
					val -= fitness[j];
				end
			end
			
			local val2 = math.random()*fitnessSum;
			--print(val2);
			local ai2 = -1;
			for j = 1, aiCount do
				if val2 <= fitness[j] then
					ai2 = j;
					break;
				else
					val2 -= fitness[j];
				end
			end
			
			newAIs[#newAIs + 1] = neuralNetwork:mergeAIs(artificialInteligence[ai1],artificialInteligence[ai2],fitness[ai1],fitness[ai2], aiMutationChance);
		end
		artificialInteligence = newAIs;
		
		DestroyMeteors();
		for i,v in pairs(rockets) do
			v.Object:PivotTo(CFrame.new(start));
		end
		GenerateMeteors(meteorsCountAI);
		for i,v in pairs(rocketsData) do
			v.Distance = 0;
			v.TimeFinished = 0;
			v.Collided = false;
		end
		for i,v in pairs(rockets) do
			v:ResetVariables();
			v:Run();
		end
		timePassed = 0;
		restarting = false;
	end
	
	for i = 1, aiCount, 1 do
		rocketsData[i] = {
			Distance = 0;
			TimeFinished = 0;
			Collided = false;
		};
		local ai = neuralNetwork:new(aiInputs + 2, {8, 4, 2}, 2);
		local rocket = rocketHandler:new();
		rocket:SetInputsGetter(function()
			local root = rocket.Object.PrimaryPart.CFrame;
			local inputs = {root.LookVector.X, root.LookVector.Z};
			for i = -(aiInputs-1)/2,(aiInputs-1)/2,1 do
				local angleDelta = aiResolutionAngle/aiInputs*i;
				local newCF = root*CFrame.Angles(0, math.rad(angleDelta), 0);
				
				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Include
				raycastParams.FilterDescendantsInstances = {game.Workspace.Meteors}
				raycastParams.IgnoreWater = true
				
				local dist = aiResolutionLength;
				local pos = newCF.Position + newCF.LookVector * aiResolutionLength;
				local raycastResult = workspace:Raycast(newCF.Position, newCF.LookVector * aiResolutionLength, raycastParams)
				if raycastResult then
					dist = (raycastResult.Position-newCF.Position).Magnitude;
					pos = raycastResult.Position;
				end
				inputs[#inputs + 1] = dist/aiResolutionLength;
				
				--local p = Instance.new('Part');
				--p.Parent = game.Workspace;
				--p.Anchored = true;
				--p.CanCollide = false;
				--p.Size = Vector3.new(1,1,1)*0.2;
				--p.CFrame = CFrame.new(pos);
			end
			local outputs = artificialInteligence[i]:PropagateForward(inputs);
			return Vector2.new(outputs[1],outputs[2]);
		end):SetCheckCollisions(function()
			local root = rocket.Object.PrimaryPart;
			local rocketPos = Vector2.new(root.Position.X, root.Position.Z);
			local rocketR = rocket.Settings.Radius;
			
			local meteorsToCheck = {};
			local insert = function(point)
				meteorsToCheck[#meteorsToCheck + 1] = point;
			end
			quadMeteors:queryRange({x = rocketPos.X, y = rocketPos.Y}, rocketR + meteorSize.Y, insert);

			for i,v in pairs(meteorsToCheck) do
				local distVec = Vector2.new(v.x, v.y) - rocketPos
				local distSqr = distVec.X^2 + distVec.Y^2;
				if (distSqr <= (rocketR + v.radius)^2) then
					return true;
				end
			end
			return false;
		end):SetOnCollision(function()
			rocketsData[i].TimeFinished = timePassed;
			rocketsData[i].Collided = true;
			
			rocket:Pause();
			local explosionNew = explosion:Clone();
			explosionNew.Parent = game.Workspace;
			explosionNew.Position = rocket.Object.PrimaryPart.Position;
			explosionNew.ParticleEmitter:Emit(100);
			game.Debris:AddItem(explosionNew, 2);
		end):SetFinishChecker(function()
			local rocketPos = rocket.Object.PrimaryPart.Position;
			local distSqrt = rocketPos - start;
			distSqrt = distSqrt:Dot(distSqrt);
			
			rocketsData[i].Distance = math.sqrt(distSqrt);

			if distSqrt >= r*r then
				return true;
			else
				return false;
			end
		end):SetOnFinish(function()
			rocketsData[i].TimeFinished = timePassed;
			
			rocket:Pause();
			restartTraining();
		end):Start();
		rockets[#rockets + 1] = rocket;
		artificialInteligence[#artificialInteligence + 1] = ai;
	end
	
	
	local val = Instance.new('NumberValue'); val.Value = 1;
	local cameraOffset = CFrame.new(0,0,0);
	local cameraIndex = 1;
	local cameraInterval = Vector2.new(25, 50);
	cameraTarget = function()
		local rocket = rockets[cameraIndex];
		local zDist = Lerp(cameraInterval.X, cameraInterval.Y, rocket:GetSpeedAlpha());
		local originCF = CFrame.new(rocket.Object.PrimaryPart.Position)*CFrame.Angles(-math.pi/2,0,0)*CFrame.new(0,0,zDist);
		return cameraOffset:Lerp(originCF, val.Value);
	end
	
	aiHandler = step.RenderStepped:Connect(function(t)
		timePassed += t * timeScale;
		
		local minIndex = -1;
		local minValue = -1;
		for i,v in pairs(rocketsData) do
			if rockets[i]:GetStatus() == 1 and v.Distance > minValue then
				minValue = v.Distance;
				minIndex = i;
			end
		end
		
		if minIndex ~= -1 then
			--print(timePassed, r/(rockets[minIndex].Settings.Speed.Y*0.9));
			if timePassed > r/((rockets[minIndex].Settings.Speed.X+rockets[minIndex].Settings.Speed.Y)/2) then
				restartTraining();
			end
			
			if minIndex ~= cameraIndex then
				local dist = (rockets[minIndex].Object.PrimaryPart.Position - rockets[cameraIndex].Object.PrimaryPart.Position).Magnitude;
				cameraIndex = minIndex;
				cameraOffset = cam.CFrame;
				val.Value = 0;
				ts:Create(val, TweenInfo.new(dist/aiCameraSwitchSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {Value = 1}):Play();
			end
		else
			restartTraining();
		end
	end)
	
	sliderCallback = function(alpha)
		local num = Lerp(aiTimeScale.X, aiTimeScale.Y, alpha)
		local intPart = math.floor(num)
		local fracPart = math.floor((num - intPart) * 100)
		ui.AIFrame.Slider.Bar.TextLabel.Text = 'x'..tostring(intPart)..string.format(".%02d", fracPart);
		ui.AIFrame.Slider.Bar.TextLabel.TextLabel.Text = ui.AIFrame.Slider.Bar.TextLabel.Text;
		
		timeScale = num;
		for i,v in pairs(rockets) do
			v:SetTimeScale(num);
		end
	end
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
				return;				-- Sa nu patesti function haulting. Odata apasat, nu mai poate fi activat pana nu se termina de procesat
			end
		end
		
		FadeIn(1);
		wait(1)
		SetupSoloGame();
	end)
	
	ui.Buttons.TrainAI.Activated:Connect(function()
		for i,v in pairs(states) do
			if v == true then
				return;				-- Sa nu patesti function haulting. Odata apasat, nu mai poate fi activat pana nu se termina de procesat
			end
		end

		FadeIn(1);
		wait(1)
		SetupAITraining();
	end)
	
	ui.AIFrame.Back.Activated:Connect(function()
		if states.IsTesting == true then
			FadeIn(1.5);
			wait(2)
			ClearGame();
			FadeOut(1.5);
			ShowScene();
		end
	end)
	
	local event;
	ui.AIFrame.Slider.MouseButton1Down:Connect(function()
		if event then
			event:Disconnect();
			event = nil;
		end
		
		event = step.RenderStepped:Connect(function()
			local xPos = plr:GetMouse().X;
			xPos -= ui.AIFrame.Slider.Bar.AbsolutePosition.X;
			local alpha = math.clamp(xPos/ui.AIFrame.Slider.Bar.AbsoluteSize.X, 0, 1);
			ui.AIFrame.Slider.Bar.Circle.Position = UDim2.new(alpha, 0, 0.5, 0);
			if sliderCallback then
				sliderCallback(alpha);
			end
		end)
	end)
	ui.AIFrame.Slider.MouseButton1Up:Connect(function()
		if event then
			event:Disconnect();
			event = nil;
		end
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
