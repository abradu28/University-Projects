local class = {};

local step = game:GetService('RunService');

function class:Start()
	if self.Overwrite.CheckCollisions == nil then return warn("Can't run Rocket Class if Collision function is not overloaded"); end
	if self.Overwrite.GetInputs == nil then return warn("Can't run Rocket Class if GetInputs function is not overloaded"); end
	if self.Overwrite.FinishChecker == nil then return warn("Can't run Rocket Class if FinishChecker function is not overloaded"); end
	if self.Overwrite.OnFinish == nil then return warn("Can't run Rocket Class if OnFinish function is not overloaded"); end
	
	self:Run();
	
	self._trash.PhysicsHandler = step.Heartbeat:Connect(function(t)
		if self.RunningStatus ~= 1 then return; end
		
		local count = math.round(t*60)*self.TimeScale;
		for i = 1,count do
			t = 1/60;
			local inputs = self.Overwrite.GetInputs();

			self:UpdateVariables(inputs, t);
			self:UpdateRocketPosition(inputs, t);
			if self.Overwrite.CheckCollisions() == true then
				if (self.Overwrite.OnCollision ~= nil) then
					return self.Overwrite.OnCollision();
				end
			end
			
			if self.Overwrite.FinishChecker() == true then
				return self.Overwrite.OnFinish();
			end
		end
	end)
end

function class:Run()
	if self.RunningStatus ~= 1 then
		self.RunningStatus = 1;
	end
end

function class:Pause()
	if self.RunningStatus == 1 then
		self.RunningStatus = 2;
	end
end

function class:Stop()
	if self.RunningStatus == 1 or self.RunningStatus == 2 then
		self.RunningStatus = 0;
		self._trash.PhysicsHandler:Disconnect();
		self._trash.PhysicsHandler = nil;
	end
end

function class:GetStatus()
	return self.RunningStatus;
end


function class:SetInputsGetter(lambda)
	self.Overwrite.GetInputs = lambda;
	return self;
end

function class:SetCheckCollisions(lambda)
	self.Overwrite.CheckCollisions = lambda;
	return self;
end

function class:SetOnCollision(lambda)
	self.Overwrite.OnCollision = lambda;
	return self;
end

function class:SetFinishChecker(lambda)
	self.Overwrite.FinishChecker = lambda;
	return self;
end

function class:SetOnFinish(lambda)
	self.Overwrite.OnFinish = lambda;
	return self;
end

function class:SetTimeScale(nr)
	self.TimeScale = nr or 1;
end


function class:GetSpeedAlpha()
	return (self.CurrentSpeed - self.Settings.Speed.X)/(self.Settings.Speed.Y - self.Settings.Speed.X)
end


function class:UpdateRocketPosition(inputs, t)
	local deltaAngle = math.rad(self.Settings.TurnSpeed) * t * inputs.X;
	local deltaDist = self.CurrentSpeed * t;
	self.Object:PivotTo(self.Object.PrimaryPart.CFrame*CFrame.new(0,0, -deltaDist)*CFrame.Angles(0, -deltaAngle, 0));
end

function class:UpdateVariables(inputs, t)
	local deltaSpeed = self.Settings.Acceleration * t * inputs.Y;
	self.CurrentSpeed = math.clamp(self.CurrentSpeed + (deltaSpeed), self.Settings.Speed.X, self.Settings.Speed.Y);
end

function class:ResetVariables()
	self.CurrentSpeed = self.Settings.Speed.X
end

function class:new(sett)
	sett = sett or {
		Speed = Vector2.new(5, 50);	-- UDM/Secunda
		Acceleration = 25;			-- UDM/Secunda
		
		TurnSpeed = 120;				-- Grade/Secunda
		Radius = 1;
	};
	
	local self = setmetatable({
		Object = game.ReplicatedStorage.Rocket:Clone();
		
		RunningStatus = 0; 			-- 0=Stop 1=Running 2=Pause
		CurrentSpeed = sett.Speed.X;
		Settings = sett;
		
		TimeScale = 1;
		
		Overwrite = {
			CheckCollisions = nil;
			OnCollision = nil;
			FinishChecker = nil;
			OnFinish = nil;
			
			GetInputs = nil;
		};
		
		_trash = {};
	},{__index = class});
	
	self.Object.Parent = game.Workspace;
	
	return self;
end

function class:Destroy()
	for i,v in pairs(self._trash) do
		v:Disconnect();
	end
	self.Overwrite.CheckCollisions = nil;
	self.Object:Destroy();
end

return class
