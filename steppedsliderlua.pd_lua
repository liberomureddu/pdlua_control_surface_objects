local slider = pd.Class:new():register("steppedsliderlua")

function slider:initialize(sel, atoms)
   self.inlets = 1
   self.outlets = 1
   self.value = 0
   self.steps = atoms[1] or 10  -- Default to 10 steps if not provided
   self:set_size(200, 30)
   return true
end

function slider:in_1_float(x)
   local step_size = 1 / (self.steps - 1)
   self.value = math.max(0, math.min(1, math.floor(x / step_size + 0.5) * step_size))
   self:repaint()
end

function slider:in_1_bang()
   self:outlet(1, "float", {self.value})
end

function slider:mouse_down(x, y)
   self:mouse_drag(x, y)
end

function slider:mouse_drag(x, y)
   local width, height = self:get_size()
   local step_size = 1 / (self.steps - 1)
   self.value = math.max(0, math.min(1, math.floor(x / width / step_size + 0.5) * step_size))
   self:in_1_bang()
   self:repaint()
end

function slider:paint(g)
   local width, height = self:get_size()

   -- standard object border, fill with bg color
   g:set_color(0)
   g:fill_all()

   -- slider handle
   local handle_width = width * 0.06
   local handle_height = height * 0.9
   local handle_x = self.value * (width - handle_width) + 1
   local handle_y = (height - handle_height) / 2 + 1

   g:set_color(1)
   g:fill_rect(handle_x, handle_y, handle_width, handle_height)
end
