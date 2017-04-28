--########################################  To Use This Module  ########################################
-- Needs set_camera() called on init and anytime the camera z pos or near/far settings are changed.
-- Needs set_window_res() called anytime the window is changed

local M = {}

M.view = vmath.matrix4()
M.proj = vmath.matrix4()

M.window_res = vmath.vector3()
M.window_halfres = vmath.vector3()

local nearz = 100
local farz = 1000
local abs_nearz = nearz -- absolute nearz and farz
local abs_farz = farz -- regular nearz and farz are relative to camera z
local world_plane_z = 0
local camz = 1000


--########################################  Set Camera  ########################################
function M.set_camera(zpos, near, far) -- near & far args are optional
	nearz = near or nearz
	farz = far or farz

	camz = zpos
	abs_nearz = camz - nearz
	abs_farz = camz - farz
end

--########################################  Set Window Resolution  ########################################
function M.set_window_res(x, y)
	M.window_res.x = x;  M.window_res.y = y
	M.window_halfres.x = x / 2;  M.window_halfres.y = y / 2
end

--########################################  Screen to World  ########################################
function M.screen_to_world(x, y)
	local m = vmath.inv(M.proj * M.view)

	-- Remap coordinates to range -1 to 1
	local x1 = (x - M.window_halfres.x) / M.window_res.x * 2
	local y1 = (y - M.window_halfres.y) / M.window_res.y * 2

	local np = m * vmath.vector4(x1, y1, -1, 1)
	local fp = m * vmath.vector4(x1, y1, 1, 1)
	np = np * (1/np.w)
	fp = fp * (1/fp.w)

	local t = (world_plane_z - abs_nearz) / (abs_farz - abs_nearz)
	local worldpos = vmath.lerp(t, np, fp)
	return vmath.vector3(worldpos.x, worldpos.y, worldpos.z)
end

--########################################  World to Screen  ########################################
function M.world_to_screen(pos)
	local m = M.proj * M.view
	pos = vmath.vector4(pos.x, pos.y, pos.z, 1)

	pos = m * pos
	pos = pos * (1/pos.w)
	pos.x = (pos.x / 2 + 0.5) * M.window_res.x
	pos.y = (pos.y / 2 + 0.5) * M.window_res.y

	return vmath.vector3(pos.x, pos.y, 0)
end


return M
