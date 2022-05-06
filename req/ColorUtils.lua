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

---Returns the color as a hexadecimal string
---@return string
function Color:hex()
	if self.a < 1 then
		return string.format("%02x%02x%02x%02x", self.a * 255, self.r * 255, self.g * 255, self.b * 255)
	else
		return string.format("%02x%02x%02x", self.r * 255, self.g * 255, self.b * 255)
	end
end
