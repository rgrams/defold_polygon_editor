
local M = {}

local basestring = "shape_type: TYPE_HULL"
local string = basestring
local fileExt = "convexshape"
local defaultFilename = "my_polygon"

M.baseDialogPath = sys.get_application_path()

--########################################  Sort Verts Anticlockwise  ########################################
local function sort_verts_anticlockwise(verts)
	print("Sorting verts into counter-clockwise order . . . ")
	local center = vmath.vector3() -- Get center pos (average pos of all verts)
	for i, v in ipairs(verts) do
		center = center + v
	end
	center = center * (1/#verts)

	-- Make new array of verts keyed by angle from centerpoint
	local verts_angles = {}
	for i, v in ipairs(verts) do
		local vect = v - center
		local angle = math.atan2(vect.y, vect.x)
		verts_angles[angle] = v
	end

	local anglekeys = {} -- put keys into an array to sort
	for k in pairs(verts_angles) do
		table.insert(anglekeys, k)
	end
	table.sort(anglekeys)

	local sorted_verts = {} -- reconstruct vert array in counterclockwise order
	for i, v in ipairs(anglekeys) do
		table.insert(sorted_verts, verts_angles[v])
	end
	return sorted_verts
end

--########################################  String - Add Points  ########################################
local function string_add_points(...)
	local args = sort_verts_anticlockwise({...})
	print("File Manager - adding points to string")
	for i, v in ipairs(args) do
		string = string.format("%s\ndata: %.3f\ndata: %.3f\ndata: %.1f", string, v.x, v.y, 0)
	end
end

--########################################  Ensure File Extension  ########################################
function M.ensure_file_extension(path)
	local dotPos = string.find(path, "%.[^%.]+$")
	if dotPos and string.sub(path, dotPos+1) == fileExt then
		return path
	else
		path = path .. "." .. fileExt
	end
	return path
end

--########################################  Get Path Directory  ########################################
function M.get_path_dir(path)
	local slashPos = string.find(path, "[/\\][^/\\]*$")
	return string.sub(path, 1, slashPos)
end

--########################################  Open Polygon  ########################################
function M.open_polygon(path)
	print("File Manager - opening file -"..path.."-")
	local numberarray = {}
	local file, err = io.open(path)
	print(file, err)
	for line in io.lines(path) do
		local _, number_index = string.find(line, "data:%s*[-%d]")
		if number_index then
			local number = tonumber(string.sub(line, number_index))
			table.insert(numberarray, number)
		end
	end

	local pointarray = {}
	for p = 1, (#numberarray / 3) do
		local i = ((p - 1) * 3) + 1
		local x = numberarray[i]
		local y = numberarray[i + 1]
		local z = numberarray[i + 2]
		local pos = vmath.vector3(x, y, z)
		table.insert(pointarray, pos)
	end

	msg.post("main#gui", "display message", {text = "Polygon Opened"})
	return pointarray
end

--########################################  Save Polygon  ########################################
function M.save_polygon(path, ...)
	print("File Manager - saving file")
	string = basestring
	string_add_points(...)
	io.output(path)
	io.write(string)
	io.output():close()
	msg.post("main#gui", "display message", {text = "Polygon Saved To:\n"..path})
end

--########################################  Get Save Path  ########################################
function M.get_save_path()
	local code, path
	if diags then
		print("Using native extension dialogs...")
		code, path = diags.save(nil, M.baseDialogPath)
		if code ~= 1 then path = nil end
	elseif sys.get_sys_info().system_name == "Linux" then -- Try using Zenity.
		print("On Linux, trying Zenity...")
		if os.execute("command -v zenity >/dev/null 2>&1") == 0 then
			local file = io.popen("zenity --file-selection --save --filename=" .. M.baseDialogPath, "r")
			for line in file:lines() do
				path = line
				break
			end
			file:close()
			if path == "" then path = nil end
		else -- Zenity failed, use a generic name in the application folder.
			print("  Zenity failed, saving into application folder...")
			local dir = sys.get_application_path() .. "/"
			local filename = defaultFilename .. socket.gettime() .. "." .. fileExt
			path = dir .. filename
		end
	end
	return path
end

--########################################  Get Open Path  ########################################
function M.get_open_path()
	local code, path
	if diags then
		print("Using native extension dialogs...")
		code, path = diags.open(nil, M.baseDialogPath)
		if code ~= 1 then path = nil end
	elseif sys.get_sys_info().system_name == "Linux" then -- Try using Zenity.
		print("On Linux, trying Zenity...")
		if os.execute("command -v zenity >/dev/null 2>&1") == 0 then
			local file = io.popen("zenity --file-selection --filename=" .. M.baseDialogPath, "r")
			for line in file:lines() do
				path = line
				break
			end
			file:close()
			if path == "" then path = nil end
		end
	end
	return path
end



return M
