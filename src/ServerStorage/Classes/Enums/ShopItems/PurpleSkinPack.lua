local props = {
	cost = 1000,
	costType = "Dice",
	items = {
		"Skin Cool",
		"Skin Warm",
		"Skin Aesthetic",
		"Skin Rainbow"
	}
}
local t1 = {"Black", "White"}
local t2 = {"Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Pink"}
for i,w1 in next,t1 do
	for i,w2 in next,t2 do
		props.items[#props.items + 1] = "Skin "..w1.." & "..w2
		props.items[#props.items + 1] = "Skin "..w2.." & "..w1
	end
end

return props