local class = {};

function class:new(x, y, width, height)
	local self = setmetatable({}, {__index = class});
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	
	return self;
end

function class:contains(point)
	return point.x >= self.x and point.x < self.x + self.width and point.y >= self.y and point.y < self.y + self.height;
end

function class:intersectsCircle(center, radius)
	local nearestX = math.max(self.x, math.min(center.x, self.x + self.width));
	local nearestY = math.max(self.y, math.min(center.y, self.y + self.height));
	local dx = center.x - nearestX;
	local dy = center.y - nearestY;
	return (dx * dx + dy * dy) <= (radius * radius);
end

return class;