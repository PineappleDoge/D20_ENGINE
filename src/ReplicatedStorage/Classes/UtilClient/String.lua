local String = {}

function String:plural(n)
	return n ~= 1 and "s" or ""
end

function String:getTime(n)
	local y = math.floor(n/(86400 * 365))
	local mo = math.fmod(math.floor(n/(86400 * 30)),12)
	local d = math.fmod(math.floor(n/86400),30)
	local h = math.fmod(math.floor(n/3600),24)
	local m = math.fmod(math.floor(n/60),60)
	local s = math.fmod(math.floor(n),60)
	local t = {}
	if y > 0 then
		t[#t+1] = y.." year"..String:plural(mo)
	end
	if mo > 0 then
		t[#t+1] = mo.." month"..String:plural(mo)
	end
	if d > 0 then
		t[#t+1] = d.." day"..String:plural(d)
	end
	if h > 0 then
		t[#t+1] = h.." hour"..String:plural(h)
	end
	if m > 0 then
		t[#t+1] = m.." minute"..String:plural(m)
	end
	if s > 0 then
		t[#t+1] = s.." second"..String:plural(s)
	end
	local st = ""
	for i = 1,#t do
		local v = t[i]
		if i == #t and i ~= 1 then
			st = st.." and "..v
		elseif i == 1 then
			st = v
		else
			st = st..", "..v
		end
	end
	return st
end

function String:concatInstances(tab)
	local str = ""
	for i,v in next, tab do
		if i == #tab and i ~= 1 then
			str = str.." and "..v.Name
		elseif i == 1 then
			str = v.Name
		else
			str = str..", "..v.Name
		end
	end
	return str
end

function String:concat(tab)
	local str = ""
	for i,v in next, tab do
		if i == #tab and i ~= 1 then
			str = str.." and "..v
		elseif i ~= 1 then
			str = v
		else
			str = str..", "..v
		end
	end
	return str
end

function String:extractTime(str)
	local n = ""
	local t = {}
	for i = 1,#str do
		local v = str:sub(i,i)
		if tonumber(v) then
			n = n..v
		else
			t[v] = tonumber(n)
			n = ""
		end
	end
	local times = {
		y = 86400 * 365,
		M = 86400 * 30,
		d = 86400,
		h = 3600,
		m = 60,
		s = 1
	}
	local sum = 0
	for i,v in next,t do
		if times[i] then
			sum = sum + times[i] * v
		end
	end
	return sum
end

function String:separateCommas(num)
	num = tostring(num)
	local str = ""
	for i = 1,#num do
		if math.fmod(i,3) == 1 and i ~= 1 then
			str = ","..str
		end
		local c = num:sub(-i,-i)
		str = c..str
	end
	return str
end

return String