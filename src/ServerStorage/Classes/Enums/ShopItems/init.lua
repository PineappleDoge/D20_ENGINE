local Framework = _G.Framework

local newParentEnum = _G.Class:new()
newParentEnum:setName(script.Name)

--shop items are handled like this
--	"[Item Type] [Item Name]"

--creates class:
--	name: count of item
--	item: item name
--	type: item type

function createItem(name, props)
	local newEnum = _G.Class:new()
	newEnum:setName(name)
	newEnum:setParent(newParentEnum)
	newEnum.costType = props.costType
	newEnum.cost = props.cost
	for i,v in next, props.items do
		local newSub = _G.Class:new()
		newSub:setName(v)
		newSub:setParent(newEnum)
		newSub.item = v:sub(v:find(" ")+1)
		newSub.type = v:sub(1,v:find(" ")-1)
	end
end

for i,v in next, script:GetChildren() do
	createItem(v.Name, require(v))
end

return newParentEnum