@include gameobject/sprite.lua
@include graphics/camera.lua
@include level/level.lua
@include game.lua

os.loadAPI("blittle")

local cam = camera.new()
local lev = level.new()
local sp = sprite.new(texture.new(0, 0, {colors.blue, colors.yellow, colors.red, colors.magenta}))
sp.pos = vec4.new(-0.5, -0.5, 1, 1)
lev:addObject(sp)

local ot = os.clock()

game = {
  inputmanagers = {
    {
      handleEvent = function(self, event, p1, p2, p3, p4, p5)
        if event == "mouse_click" then print "lol" end
      end
    }
  },
  
  fps = 20,
  
  init = function(self)
    
  end,
  
  update = function(self)
    
  end,
  
  render = function(self)
    cam:render(lev)
    local t = os.clock()
    term.setCursorPos(1, 1)
    print("Took", (t - ot) / 0.05, "ticks")
    ot = t
  end
}

rungame(game)