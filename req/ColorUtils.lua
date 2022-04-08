---Returns a grayscale version of the color by taking the average of all color channels
---@return Color
function Color:grayscale()
	local avg = (self.r + self.g + self.b) / 3
	return Color(self.a, avg, avg, avg)
end

---Returns the inverse of the color, optionally inverting the alpha channel aswell
---@param invert_alpha? boolean @wether to invert the alpha channel
---@return Color
function Color:invert(invert_alpha)
	return Color(invert_alpha and 1 - self.a or self.a, 1 - self.r, 1 - self.g, 1 - self.b)
end
