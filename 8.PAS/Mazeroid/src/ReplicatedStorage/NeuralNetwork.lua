local class = {};

local function Lerp(a, b, alpha)
	return a + (b - a) * alpha;
end

local function DeepCopy(t)
	local newT = {};
end

function class:relu(x)
	return math.max(0, x);
end

function class:sigmoid(x)
	return 1 / (1 + math.exp(-x));
end

function class:tanh(x)
	return math.tanh(x);
end

function class:mergeAIs(ai1,ai2, fitness1, fitness2, mutationChance)
	local layersCount = table.clone(ai1.LayersCount);
	table.remove(layersCount,1);
	table.remove(layersCount, #layersCount);
	--warn(layersCount);
	
	local newAI = class:new(ai1.InputsCount, layersCount, ai1.OutputsCount, ai1.ActivationFunctions);
	
	--warn((fitness2)/(fitness1 + fitness2))
	
	for i = 1,#newAI.Layers do
		for j = 1,#(newAI.Layers[i]) do
			for h = 1, #(newAI.Layers[i][j]) do
				newAI.Layers[i][j][h] = Lerp(ai1.Layers[i][j][h], ai2.Layers[i][j][h], (fitness2)/(fitness1 + fitness2));
				if math.random() <= mutationChance then
					warn('MUTATION');
					newAI.Layers[i][j][h] = newAI.Layers[i][j][h]*((math.random()-0.5)/0.5*1.5);
				end
			end
		end
	end
	
	return newAI;
end

function class:new(inputsCount, layersCount, ouputsCount, activationFunctions)
	-- activationFunctions = 1-RELU 2-Sigmoid 3-Tanh
	local self = setmetatable({},{__index = class});

	table.insert(layersCount, 1, inputsCount)
	layersCount[#layersCount + 1] = ouputsCount;
	layersCount[#layersCount + 1] = 0;

	local layers = {};
	for i = 1,#layersCount-1 do
		layers[i] = {};
		for j = 1,layersCount[i] do
			layers[i][j] = {};
			for h = 1,layersCount[i + 1] do
				layers[i][j][h + 1] = (math.random()-0.5)/0.5*10;
			end
		end
	end
	layersCount[#layersCount] = nil;

	self.LayersCount = layersCount;
	self.ActivationFunctions = activationFunctions;
	self.InputsCount = inputsCount;
	self.OutputsCount = ouputsCount;
	self.Layers = layers;
	
	self:ResetValues();

	return self;
end

function class:ResetValues()
	for i = 1,#self.LayersCount do
		for j = 1,self.LayersCount[i] do
			self.Layers[i][j][1] = 0;
		end
	end
end

function class:PropagateForward(inputs)
	self:ResetValues();

	--print("GOT INPUTS: ",inputs);

	for i = 1,self.InputsCount do
		self.Layers[1][i][1] = inputs[i];
	end

	for i = 1,#self.LayersCount-1 do
		for h = 1,self.LayersCount[i + 1] do
			for j = 1,self.LayersCount[i] do
				self.Layers[i + 1][h][1] = self.Layers[i + 1][h][1] + self.Layers[i][j][h + 1] * self.Layers[i][j][1]
			end
			self.Layers[i + 1][h][1] = self:tanh(self.Layers[i + 1][h][1]);
		end
	end

	local outputs = {};
	for i = 1,self.LayersCount[#self.LayersCount] do
		outputs[i] = self.Layers[#self.LayersCount][i][1];
	end

	return outputs;
end

function class:Destroy()
end

return class;