local slider = pd.Class:new():register("sliderlua")

function slider:initialize(sel, atoms)
   self.inlets = 1
   self.outlets = 1
   self.value = 0
   self:set_size(200, 30)
   return true
end

function slider:in_1_float(x)
   self.value = math.max(0, math.min(1, x))
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
   self.value = math.max(0, math.min(1, x / width))
   self:in_1_bang()
   self:repaint()
end

function slider:paint(g)
   local width, height = self:get_size()

   -- standard object border, fill with bg color
   g:set_color(0)
   g:fill_all()

   -- slider track
   g:set_color(0.8)
   g:fill_rect(2, height / 2 - 4, width - 4, 8)

   -- slider handle
   local handle_width = width * 0.06
   local handle_margin = 2 -- Fixed margin from top and bottom
   local handle_height = height - 2 * handle_margin
   local handle_x = self.value * (width - handle_width) + 1
   local handle_y = handle_margin + 1

   g:set_color(1)
   g:fill_rect(handle_x, handle_y, handle_width, handle_height)
end
