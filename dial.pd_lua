local dial = pd.Class:new():register("dial")

function dial:initialize(sel, atoms)
   self.inlets = 1
   self.outlets = 1
   self.phase = 0
   self:set_size(127, 127)
   return true
end

function dial:in_1_float(x)
   self.phase = x
   self:repaint()
end

function dial:in_1_bang()
   self:outlet(1, "float", {self.phase})
end

-- calculate the x, y position of the tip of the hand
function dial:tip()
   local width, height = self:get_size()
   local x, y = math.sin(self.phase*math.pi), -math.cos(self.phase*math.pi)
   x, y = (x/2*0.8+0.5)*width, (y/2*0.8+0.5)*height
   return x, y
end

function dial:mouse_down(x, y)
   self.tip_x, self.tip_y = self:tip()
end

function dial:mouse_drag(x, y)
   local width, height = self:get_size()

   local x1, y1 = x/width-0.5, y/height-0.5
   -- calculate the normalized phase, shifted by 0.5, since we want zero to be
   -- the center up position
   local phase = math.atan(y1, x1)/math.pi + 0.5
   -- renormalize if we get an angle > 1, to account for the phase shift
   if phase > 1 then
      phase = phase - 2
   end

   self.phase = phase

   local tip_x, tip_y = self:tip();

   if tip_x ~= self.tip_x or tip_y ~= self.tip_y then
      self.tip_x = tip_x
      self.tip_y = tip_y
      self:in_1_bang()
      self:repaint()
   end
end

function dial:paint(g)
   local width, height = self:get_size()
   local x, y = self:tip()

   -- standard object border, fill with bg color
   g:set_color(0)
   g:fill_all()

   -- dial face
   g:fill_ellipse(2, 2, width - 4, height - 4)
   g:set_color(1)
   -- dial border
   g:stroke_ellipse(2, 2, width - 4, height - 4, 4)
   -- center point
   g:fill_ellipse(width/2 - 3.5, height/2 - 3.5, 7, 7)
   -- dial hand
   g:draw_line(x, y, width/2, height/2, 2)
end