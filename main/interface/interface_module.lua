
local M = {}

local presscolor = vmath.vector4(0.8, 0.8, 0.8, 1)
local normalcolor = vmath.vector4(0.3, 0.3, 0.3, 1)
local hovercolor = vmath.vector4(0.6, 0.6, 0.6, 1)

local panelcolor = vmath.vector4(0.2, 0.2, 0.2, 0.9)

M.color_transparent = vmath.vector4(0)
M.color_black = vmath.vector4(0, 0, 0, 1)

local h_up = hash("up")
local h_down = hash("down")
local h_left = hash("left")
local h_right = hash("right")


--########################################  New Button  ########################################
function M.newbutton(name, node, parent, array)
	local button = {
		name = name,
		node = node,
		parent = parent,
		active = false,
		enabled = true, -- i.e. visible, Defold's term
		pressed = false,
		hovered = false,
		text = "button text",
		hover = M.hover_button,
		unhover = M.unhover_button,
		press = M.press_button,
		pressfunc = nil,
		release = M.release_button,
		releasefunc = nil,
		set_active = M.button_set_active,
		set_enabled = M.button_set_enabled,
		neighbor_up = nil,
		neighbor_down = nil,
		neighbor_left = nil,
		neighbor_right = nil,
		hover_adj = M.button_hover_adjacent
	}
	array[name] = button
	gui.set_color(node, normalcolor)
	return button
end

--########################################  New Panel  ########################################
function M.newpanel(name, node, parent, array)
	local panel = M.newbutton(name, node, parent, array)
	gui.set_color(node, panelcolor)
	panel.hover = nil;  panel.unhover = nil;  panel.press = nil;  panel.release = nil
	return panel
end

--########################################  Hover Button  ########################################
function M.hover_button(self)
	self.hovered = true
	gui.set_color(self.node, hovercolor)
	msg.post(self.parent, "button hovered", {btn = self.name})
end

--########################################  Unhover Button  ########################################
function M.unhover_button(self)
	self.hovered = false
	gui.set_color(self.node, normalcolor)
	msg.post(self.parent, "button unhovered", {btn = self.name})
end

--########################################  Press Button  ########################################
function M.press_button(self)
	self.pressed = true
	print(self.name, " button pressed")
	gui.set_color(self.node, presscolor)
	if self.pressfunc then self.pressfunc() end
end

--########################################  Release Button  ########################################
function M.release_button(self)
	self.pressed = false
	print(self.name, " button released")
	gui.set_color(self.node, normalcolor)
	if self.releasefunc then self.releasefunc() end
end

--########################################  Button - Set Active  ########################################
function M.button_set_active(self, active) -- need to keep track of enabled/disabled widgets in parent script so it's not global.
	self.active = active
	if active then
		msg.post(self.parent, "button activated", {btn = self.name})
		if not self.enabled then self:set_enabled(true) end -- automatically enable when activated
	else
		msg.post(self.parent, "button deactivated", {btn = self.name})
		if self.hovered then self:unhover() end
	end
end

--########################################  Button - Set Enabled  ########################################
function M.button_set_enabled(self, enabled)
	self.enabled = enabled
	gui.set_enabled(self.node, enabled)
	if not enabled then	self:set_active(false) end -- make sure we can't interact with it when its invisible
end

--########################################  Button - Hover Adjacent  ########################################
function M.button_hover_adjacent(self, dirstring) -- for keyboard navigation - not yet used
	local newbtn = self["neighbor_" .. dirstring]
	if newbtn then
		newbtn:hover()
		self:unhover()
	end
	return newbtn
end

--########################################  Update Button  ########################################
function M.update_button(self, posx, posy)
	local hovered = gui.pick_node(self.node, posx, posy)
	if hovered and not self.hovered then
		if self.hover then self:hover() end
	elseif not hovered and self.hovered then
		if self.unhover then self:unhover() end
	end
end

--########################################  Update Array of Buttons  ########################################
function M.update_buttons_array(array, posx, posy)
	for i, v in ipairs(array) do
		M.update_button(v, posx, posy)
	end
end


return M
