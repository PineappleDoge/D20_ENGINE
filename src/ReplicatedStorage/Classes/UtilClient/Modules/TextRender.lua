local TextRender = {}
TextRender.__index = TextRender

local ExampleLabel = game.Players.LocalPlayer.PlayerGui:WaitForChild("GUIs").MainHUD.ExampleLabel

TextRender.DefaultProperties = {
	font = {"Gotham"},
	size = {"24"},
	color = {"#000000"}
}

TextRender.Properties = {}

function TextRender:GetProperty(Property,PropertyTable)
	if PropertyTable and PropertyTable[Property] and #PropertyTable[Property] > 0 then
		return PropertyTable[Property][#PropertyTable[Property]]
	end
	return self.Properties[Property] or self.DefaultProperties[Property]
end

function TextRender:ParseColor(c)
	if BrickColor.new(c:sub(2)).Name ~= c:sub(2) then
		local r,g,b = tonumber(c:sub(2,3),16),tonumber(c:sub(4,5),16),tonumber(c:sub(6,7),16)
		return Color3.fromRGB(r,g,b)
	else
		return BrickColor.new(c:sub(2)).Color
	end
end

function TextRender:ParseNumber(n, Default)
	return tonumber(n) or Default or 0
end

TextRender.Functions = {}

function TextRender:AddFunction(Name, Function)
	local FEnv = getfenv(Function)
	FEnv.self = self
	setfenv(Function, FEnv)
	self.Functions[Name] = Function
end

TextRender.AfterFunctions = {}

function TextRender:AddAfterFunction(Name, Function)
	local FEnv = getfenv(Function)
	FEnv.self = self
	setfenv(Function, FEnv)
	self.AfterFunctions[Name] = Function
end

function TextRender:ParseTable(Text, PropSeparator)
	local Prop = {}
	for v in Text:gmatch("[^:]+") do
		Prop[#Prop + 1] = v
	end
	return Prop
end

function TextRender:ParseText(Text)
	local Separator = "%[?[^%[^%]]*%]?"
	local PropSeparator = ":"
	
	local Table = {}
	
	if Text:sub(1,1) == " " then
		repeat
			Text = Text:sub(2)
		until not Text:sub(1,1) == " "
	end
	
	for v in Text:gmatch(Separator) do
		local isProperty = v:sub(1,1) == "[" and v:sub(-1) == "]"
		if isProperty then
			v = v:sub(2,-2)
			if v:sub(1,1) == "/" then
				v = "clear:"..v:sub(2)
			end
			Table[#Table + 1] = self:ParseTable(v, PropSeparator)
		else
			Table[#Table + 1] = v
		end
	end
	
	return Table
end

function TextRender:RenderText(Table, MaxLength, MaxHeight)
	MaxLength = MaxLength or math.huge
	local PropertyTable = {}
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	local MaxX, MaxY = 0,0
	local X,Y = 0,0
	local CurrentMaxSize = 0
	local Labels = 0
	for _,Value in next,Table do
		if type(Value) == "table" then
			if Value[1] == "reset" then
				local Property = Value[2]
				if Property then
					PropertyTable[Property] = {}
					if self.DefaultProperties[Property] then
						for i,v in next,self.DefaultProperties[Property] do
							PropertyTable[Property][i] = v
						end
					end
				else
					PropertyTable = {}
					for i,v in next,self.DefaultProperties do
						PropertyTable[i] = {}
						for i2,v2 in next, v do
							PropertyTable[i][i2] = v2
						end
					end
				end
			elseif Value[1] == "clear" then
				local Property = Value[2]
				table.remove(PropertyTable[Property],#PropertyTable[Property])
			elseif Value[1] == "image" then
				local TextSize = self:ParseNumber(self:GetProperty("size",PropertyTable)[1])
				local Image = "rbxassetid://"..Value[2]
				local Ratio = tonumber(Value[3]) or 1
				if X + Ratio * TextSize > MaxLength then
					X = 0
					Y = Y + CurrentMaxSize
					CurrentMaxSize = TextSize
				end
				MaxY = math.max(MaxY,Y + CurrentMaxSize)
				if MaxY < MaxHeight then
					local ImageLabel = Instance.new("ImageLabel")
					ImageLabel.Parent = Frame
					ImageLabel.Image = Image
					ImageLabel.ClipsDescendants = true
					ImageLabel.Size = UDim2.new(0,Ratio * TextSize,0,TextSize)
					ImageLabel.Position = UDim2.new(0,X,0,Y)
					ImageLabel.BackgroundTransparency = 1
					ImageLabel.TextScaled = true
					ImageLabel.Font = self:GetProperty("font",PropertyTable)[1]
					Labels = Labels + 1
					ImageLabel.Name = Labels
					for Prop,Func in next,self.Functions do
						if self:GetProperty(Prop,PropertyTable) then
							Func(ImageLabel,unpack(self:GetProperty(Prop,PropertyTable)))
						end
					end
					for Prop,Func in next,self.AfterFunctions do
						if self:GetProperty(Prop,PropertyTable) then
							Func(ImageLabel,unpack(self:GetProperty(Prop,PropertyTable)))
						end
					end
					X = X + Ratio * TextSize
					MaxX = math.max(X,MaxX)
				end
			elseif self.Functions[Value[1]] or self.AfterFunctions[Value[1]] then
				local Property = Value[1]
				table.remove(Value,1)
				PropertyTable[Property] = PropertyTable[Property] or {}
				PropertyTable[Property][#PropertyTable[Property] + 1] = Value
			end
		else
			local TextSize = self:ParseNumber(self:GetProperty("size",PropertyTable)[1])
			ExampleLabel.Font = self:GetProperty("font",PropertyTable)[1]
			ExampleLabel.TextSize = TextSize
			ExampleLabel.Text = Value
			local SpaceAtBegin = Value:sub(1,1) == " "
			local SpaceAtEnd = Value:sub(-1) == " "
			MaxY = math.max(MaxY,Y + CurrentMaxSize)
			CurrentMaxSize = math.max(CurrentMaxSize,TextSize)
			ExampleLabel.Text = " "
			local SpaceLength = ExampleLabel.TextBounds.X/ExampleLabel.TextBounds.Y * TextSize
			if SpaceAtBegin then
				X = X + SpaceLength
				MaxX = math.max(X,MaxX)
			end
			local Words = {}
			for v in Value:gmatch("[^%s]+") do
				Words[#Words + 1] = v
			end
			for i,v in next,Words do
				ExampleLabel.Text = v
				local WordLength = ExampleLabel.TextBounds.X/ExampleLabel.TextBounds.Y * TextSize
				if X ~= 0 and X + WordLength > MaxLength then
					X = 0
					Y = Y + CurrentMaxSize
					CurrentMaxSize = TextSize
				end
				MaxY = math.max(MaxY,Y + CurrentMaxSize)
				for i2 = 1,#v do
					local Character = v:sub(i2,i2)
					ExampleLabel.Text = Character
					if X + ExampleLabel.TextBounds.X/ExampleLabel.TextBounds.Y * TextSize > MaxLength then
						X = 0
						Y = Y + CurrentMaxSize
						CurrentMaxSize = TextSize
					end
					MaxY = math.max(MaxY,Y + CurrentMaxSize)
					if MaxY < MaxHeight then
						local TextLabel = Instance.new("TextLabel")
						TextLabel.Parent = Frame
						TextLabel.Text = Character
						TextLabel.ClipsDescendants = true
						TextLabel.Size = UDim2.new(0,ExampleLabel.TextBounds.X/ExampleLabel.TextBounds.Y * TextSize,0,TextSize)
						TextLabel.Position = UDim2.new(0,X,0,Y)
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextScaled = true
						TextLabel.Font = self:GetProperty("font",PropertyTable)[1]
						Labels = Labels + 1
						TextLabel.Name = Labels
						for Prop,Func in next,self.Functions do
							if self:GetProperty(Prop,PropertyTable) then
								Func(TextLabel,unpack(self:GetProperty(Prop,PropertyTable)))
							end
						end
						for Prop,Func in next,self.AfterFunctions do
							if self:GetProperty(Prop,PropertyTable) then
								Func(TextLabel,unpack(self:GetProperty(Prop,PropertyTable)))
							end
						end
						X = X + ExampleLabel.TextBounds.X/ExampleLabel.TextBounds.Y * TextSize
						MaxX = math.max(X,MaxX)
					end
				end
				if i ~= #Words or SpaceAtEnd then
					X = X + SpaceLength
					MaxX = math.max(X,MaxX)
				end
			end
		end
	end
	Frame.Size = UDim2.new(0,MaxX,0,MaxY)
	
	return Frame
end

function TextRender:ToScale(Frame)
	for i,v in next,Frame:GetChildren() do
		v.Position = UDim2.new(v.Position.X.Offset/Frame.AbsoluteSize.X,0,v.Position.Y.Offset/Frame.AbsoluteSize.Y,0)
		v.Size = UDim2.new(v.Size.X.Offset/Frame.AbsoluteSize.X,0,v.Size.Y.Offset/Frame.AbsoluteSize.Y,0)
	end
end

function TextRender:AlignCenter(Frame)
	local Y = {}
	local YSZ = {}
	for i,v in next,Frame:GetChildren() do
		Y[v.Position.Y.Offset] = Y[v.Position.Y.Offset] or {}
		table.insert(Y[v.Position.Y.Offset],1,v)
		YSZ[v.Position.Y.Offset] = math.max((YSZ[v.Position.Y.Offset] or 0),v.Position.X.Offset + v.Size.X.Offset)
	end
	for i,v in next,YSZ do
		local CenterAdd = Frame.Size.X.Offset/2 - v/2
		for i,v in next,Y[i] do
			v.Position = v.Position + UDim2.new(0,CenterAdd,0,0)
		end
	end
end
function TextRender:AlignRight(Frame)
	local Y = {}
	local YSZ = {}
	for i,v in next,Frame:GetChildren() do
		Y[v.Position.Y.Offset] = Y[v.Position.Y.Offset] or {}
		table.insert(Y[v.Position.Y.Offset],1,v)
		YSZ[v.Position.Y.Offset] = math.max((YSZ[v.Position.Y.Offset] or 0),v.Position.X.Offset + v.Size.X.Offset)
	end
	for i,v in next,YSZ do
		local CenterAdd = Frame.Size.X.Offset - v
		for i,v in next,Y[i] do
			v.Position = v.Position + UDim2.new(0,CenterAdd,0,0)
		end
	end
end

function TextRender:Clone()
	local Table = {}
	for i,v in next,self do
		Table[i] = v
	end
	return Table
end

function TextRender:new(Table)
	local New = self:Clone()
	setmetatable(New, self)
	return New
end

--ADDING FUNCTIONS
TextRender:AddFunction("font",function(TextLabel, Font)
	--Handled automatically by TextRender
end)
TextRender:AddFunction("size",function(TextLabel, TextSize)
	--Handled automatically by TextRender
end)
TextRender:AddFunction("color",function(TextLabel, TextColor)
	if TextLabel:IsA("TextLabel") then
		TextLabel.TextColor3 = TextRender:ParseColor(TextColor)
	else
		TextLabel.ImageColor3 = TextRender:ParseColor(TextColor)
	end
end)
TextRender:AddFunction("stroke",function(TextLabel,StrokeTransparency,StrokeColor)
	if TextLabel:IsA("TextLabel") then
		TextLabel.TextStrokeTransparency = TextRender:ParseNumber(StrokeTransparency,0)/100
		TextLabel.TextStrokeColor3 = TextRender:ParseColor(StrokeColor) or Color3.new()
	end
end)
TextRender:AddFunction("transparency",function(TextLabel, Transparency)
	if TextLabel:IsA("TextLabel") then
		TextLabel.TextTransparency = TextRender:ParseNumber(Transparency,0)/100
	else
		TextLabel.ImageTransparency = TextRender:ParseNumber(Transparency,0)/100
	end
end)
TextRender:AddAfterFunction("gradient", function(TextLabel, ...)
	local t = {...}
	if #t%2 == 1 then
		return
	end
	local Gradients = {}
	for i = 1,#t,2 do
		Gradients[#Gradients + 1] = {t[i]/100,t[i + 1]}
	end
	table.sort(Gradients,function(a,b)
		return a[1] <= b[1]
	end)
	Gradients[#Gradients+1] = {1}
	for i = 1,#Gradients - 1 do
		local From,To = Gradients[i],Gradients[i + 1]
		local Frame = Instance.new("Frame")
		Frame.Parent = TextLabel
		Frame.BackgroundTransparency = 1
		Frame.ClipsDescendants = true
		Frame.Position = UDim2.new(0,0,From[1],0)
		Frame.Size = UDim2.new(1,0,To[1] - From[1],0)
		local TextLabel2 = TextLabel:Clone()
		TextLabel2.Parent = Frame
		if TextLabel2:IsA("TextLabel") then
			TextLabel2.TextColor3 = TextRender:ParseColor(From[2]) or Color3.new()
		else
			TextLabel2.ImageColor3 = TextRender:ParseColor(From[2]) or Color3.new()
		end
		TextLabel2.Size = UDim2.new(1,2,1 / (To[1] - From[1]),2)
		TextLabel2.Position = UDim2.new(0,0,-(1 / (To[1] - From[1])) * From[1],0)
	end
	TextLabel.TextTransparency = 1
end)
--END OF ADDING FUNCTIONS

return TextRender