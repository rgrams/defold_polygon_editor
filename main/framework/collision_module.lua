
local M = {}


--########################################  Collide Capsule-Point  ########################################
function M.collide_capsule_point(linestart, lineend, capsuleradius, point)
	local linevect = lineend - linestart
	local length = vmath.length(linevect)
	local percentrun = vmath.dot(point - linestart, linevect) / (length * length)
	percentrun = math.min(1, math.max(0, percentrun)) -- clamp to 0-1
	local closestpoint = vmath.lerp(percentrun, linestart, lineend)
	local dist = vmath.length(point - closestpoint)
	if dist <= capsuleradius then return dist, closestpoint
	else return nil
	end
end

--########################################  Collide Circle-Circle  ########################################
function M.collide_circle_circle(center1, r1, center2, r2)
	local dist = vmath.length(center1 - center2)
	if dist <= r1 + r2 then return dist
	else return nil
	end
end


return M
