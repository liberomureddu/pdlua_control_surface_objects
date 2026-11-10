local rangeslider = pd.Class:new():register("rangesliderlua")

function rangeslider:initialize(sel, atoms)
   self.inlets = 2
   self.outlets = 2
   self.min_value = 0
   self.max_value = 1
   self.dragging = nil
   self:set_size(200, 30)
   return true
end

function rangeslider:in_1_float(x)
   self.min_value = math.max(0, math.min(self.max_value, x))
   self:repaint()
end

function rangeslider:in_2_float(x)
   self.max_value = math.max(self.min_value, math.min(1, x))
   self:repaint()
end

function rangeslider:mouse_down(x, y)
   local width, height = self:get_size()
   local handle_width = width * 0.06
   local min_x = self.min_value * (width - handle_width) + handle_width / 2
   local max_x = self.max_value * (width - handle_width) + handle_width / 2

   if math.abs(x - min_x) < handle_width / 2 then
      self.dragging = "min"
   elseif math.abs(x - max_x) < handle_width / 2 then
      self.dragging = "max"
   elseif x > min_x + handle_width / 2 and x < max_x - handle_width / 2 then
      self.dragging = "range"
      self.drag_offset = x - min_x
   end
end

function rangeslider:mouse_drag(x, y)
   local width, height = self:get_size()
   local handle_width = width * 0.06

   if self.dragging == "min" then
      self.min_value = math.max(0, math.min(self.max_value, (x - handle_width / 2) / (width - handle_width)))
   elseif self.dragging == "max" then
      self.max_value = math.max(self.min_value, math.min(1, (x - handle_width / 2) / (width - handle_width)))
   elseif self.dragging == "range" then
      local range_width = self.max_value - self.min_value
      local new_min = (x - self.drag_offset - handle_width / 2) / (width - handle_width)
      new_min = math.max(0, math.min(1 - range_width, new_min))
      self.min_value = new_min
      self.max_value = new_min + range_width
   end

   self:outlet(1, "float", {self.min_value})
   self:outlet(2, "float", {self.max_value})
   self:repaint()
end

function rangeslider:mouse_up(x, y)
   self.dragging = nil
end

function rangeslider:paint(g)
   local width, height = self:get_size()

   -- standard object border, fill with bg color
   g:set_color(0)
   g:fill_all()

   -- slider track
   g:set_color(0.8)
   g:fill_rect(2, height / 2 - 4, width - 4, 8)

   -- dark grey area between sliders
   local handle_width = width * 0.06
   local handle_x1 = self.min_value * (width - handle_width) + handle_width / 2
   local handle_x2 = self.max_value * (width - handle_width) + handle_width / 2
   g:set_color(0.3)
   g:fill_rect(handle_x1, height / 2 - 4, handle_x2 - handle_x1, 8)

   -- slider handles
   local handle_height = height * 0.9
   local handle_y = (height - handle_height) / 2 + 1

   g:set_color(1)
   g:fill_rect(handle_x1 - handle_width / 2, handle_y, handle_width, handle_height)
   g:fill_rect(handle_x2 - handle_width / 2, handle_y, handle_width, handle_height)
end
