local Colors = {}

function Colors:invert(color)
	return Color3.new(1 - color.r, 1 - color.b, 1 - color.g)
end

function Colors:shadow(pri, sec)
	local color = pri:lerp(sec, .5)
	local h, s, v = Color3.toHSV(color)
	if v < .5 then
		color = color:lerp(Color3.new(1,1,1),.75)
	else
		color = color:lerp(Color3.new(),.75)
	end
	return color
end

function Colors:shift(color)
	local h, s, v = Color3.toHSV(color)
	if v < .5 then
		color = color:lerp(Color3.new(1,1,1),.5)
	else
		color = color:lerp(Color3.new(),.125)
	end
	return color
end

return Colors