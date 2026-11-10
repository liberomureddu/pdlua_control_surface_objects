local square = pd.Class:new():register("rotatingsquarelua")

function square:initialize(sel, atoms)
    self.inlets = 1
    self.outlets = 1
    self.phase = 0
    self:set_size(200, 200)
    self.clock = pd.Clock:new():register(self, "squarelua")
    self.clock:delay(33) -- approximately 30 FPS
    return true
end

function square:paint(g)
    local width, height = self:get_size()
    local cx, cy = width / 2, height / 2
    local size = 100
    local half_size = size / 2

    g:set_color(0)
    g:fill_all()

    g:set_color(1)
    g:translate(cx, cy)
    local angle = self.phase * 2 * math.pi
    local x1 = half_size * math.cos(angle)
    local y1 = half_size * math.sin(angle)
    g:fill_rect(-x1, -y1, size, size)
end

function square:clock_tick()
    self.phase = self.phase + (1 / 60) -- 1 rotation every 2 seconds
    if self.phase >= 1 then
        self.phase = self.phase - 1
    end
    self:repaint()
    self.clock:delay(33) -- reschedule the clock
end

function square:in_1_float(state)
    if state ~= 0 then
        self:clock_tick()
    else
        self.clock:unset()
    end
end
