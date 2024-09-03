local xy_controller = pd.Class:new():register("xylua")

function xy_controller:initialize(sel, atoms)
   self.inlets = 2
   self.outlets = 2
   self.value_x = 0.5
   self.value_y = 0.5
   self:set_size(127, 127)
   return true
end

function xy_controller:in_1_float(x)
   self.value_x = math.max(0, math.min(1, x))
   self:repaint()
end

function xy_controller:in_2_float(y)
   self.value_y = math.max(0, math.min(1, y))
   self:repaint()
end

function xy_controller:in_1_bang()
   self:outlet(1, "float", {self.value_x})
   self:outlet(2, "float", {self.value_y})
end

function xy_controller:mouse_down(x, y)
   self:mouse_drag(x, y)
end

function xy_controller:mouse_drag(x, y)
   local width, height = self:get_size()
   self.value_x = math.max(0, math.min(1, x / width))
   self.value_y = math.max(0, math.min(1, y / height))
   self:in_1_bang()
   self:repaint()
end

function xy_controller:paint(g)
   local width, height = self:get_size()

   -- standard object border, fill with bg color
   g:set_color(0)
   g:fill_all()

   -- xy controller area
   g:set_color(0.8)
   g:fill_rect(2, 2, width - 4, height - 4)

   -- xy controller handle
   local handle_size = math.min(width, height) * 0.13
   local handle_x = self.value_x * (width - handle_size) + 1
   local handle_y = self.value_y * (height - handle_size) + 1

   g:set_color(1)
   g:fill_rect(handle_x, handle_y, handle_size, handle_size)
end
