
local M = {}


--########################################  Angle-Diff (radians)  ########################################
function M.anglediff_rad(rad1, rad2)
	local a = rad1 - rad2
	a = (a + math.pi) % (math.pi * 2) - math.pi
	return a
end

--########################################  Round  ########################################
function M.round(x)
	local a = x % 1
	x = x - a
	if a < 0.5 then a = 0
	else a = 1 end
	return x + a
end

--########################################  Clamp  ########################################
function M.clamp(x, min, max)
	return math.max(min, math.min(max, x))
end

--########################################  Find (in array)  ########################################
function M.find(t, val)
	for i, v in ipairs(t) do
		if v == val then return i end
	end
end

--########################################  Find & Remove (from array)  ########################################
function M.find_remove(t, val)
	for i, v in ipairs(t) do
		if v == val then
			table.remove(t, i)
			return i
		end
	end
end

--########################################  Next index in array (looping)  ########################################
function M.nexti(t, i)
	if #t == 0 then return 0 end
	i = i + 1
	if i > #t then i = 1 end
	return i
end

--########################################  Previous index in array (looping)  ########################################
function M.previ(t, i)
	i = i - 1
	if i < 1 then i = #t end
	return i
end

--########################################  Next value in array (looping)  ########################################
function M.nextval(t, i)
	return t[M.nexti(t, i)]
end

--########################################  Previous value in array (looping)  ########################################
function M.prevval(t, i)
	return t[M.previ(t, i)]
end

--########################################  Vect to Quat  ########################################
function M.vect_to_quat(vect)
	return vmath.quat_rotation_z(math.atan2(vect.y, vect.x))
end

--########################################  Script URL  ########################################
function M.scripturl(path)
	return msg.url(nil, path, "script")
end


return M
