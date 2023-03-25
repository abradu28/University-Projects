local class = {}

local rectangle = require(game.ReplicatedStorage.Rectangle);

function class:new(bounds, capacity)
	local self = setmetatable({}, {__index = class});
	self.bounds = bounds;
	self.capacity = capacity or 4;
	self.points = {};
	self.divided = false;
	
	return self;
end

function class:insert(point)
	if not self.bounds:contains(point) then return false; end

	if not self.divided and #self.points < self.capacity then
		table.insert(self.points, point);
		return true;
	end

	if not self.divided then
		self:subdivide();
		for _, p in ipairs(self.points) do
			self:insert(p);
		end
		self.points = {};
	end

	if self.northwest:insert(point) then return true; end
	if self.northeast:insert(point) then return true; end
	if self.southwest:insert(point) then return true; end
	if self.southeast:insert(point) then return true; end

	return false
end

function class:subdivide()
	local x = self.bounds.x;
	local y = self.bounds.y;
	local w = self.bounds.width / 2;
	local h = self.bounds.height / 2;
	self.northwest = class:new(rectangle:new(x, y, w, h), self.capacity);
	self.northeast = class:new(rectangle:new(x + w, y, w, h), self.capacity);
	self.southwest = class:new(rectangle:new(x, y + h, w, h), self.capacity);
	self.southeast = class:new(rectangle:new(x + w, y + h, w, h), self.capacity);
	self.divided = true;
end

function class:queryRange(point, range, insert)
	if not self.bounds:intersectsCircle(point, range) then return; end

	if not self.divided then
		for _, p in ipairs(self.points) do
			local vec = Vector2.new(point.x - p.x, point.y - p.y);
			if vec:Dot(vec) <= range*range then
				insert(p);
			end
		end
	else
		self.northwest:queryRange(point, range, insert);
		self.northeast:queryRange(point, range, insert);
		self.southwest:queryRange(point, range, insert);
		self.southeast:queryRange(point, range, insert);
	end
end

return class;