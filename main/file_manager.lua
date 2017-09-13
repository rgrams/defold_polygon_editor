
local M = {}

local basestring = "shape_type: TYPE_HULL"
local string = "shape_type: TYPE_HULL"
local filename_base = "polygon_"
local filename_ext = ".convexshape"


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
function M.string_add_points(...)
	local args = sort_verts_anticlockwise({...})
	print("File Manager - adding points to string")
	for i, v in ipairs(args) do
		string = string.format("%s\ndata: %.3f\ndata: %.3f\ndata: %.1f", string, v.x, v.y, 0)
	end
end

--########################################  Save Polygon  ########################################
function M.save_polygon(...)
	print("File Manager - saving file")
	string = basestring
	M.string_add_points(...)
	local path = filename_base .. tostring(os.time()) .. filename_ext
	io.output(path)
	io.write(string)
	io.output():close()
end


return M
