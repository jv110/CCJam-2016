@include gameobject/sprite.lua
@include graphics/camera2d.lua
@include graphics/mesh.lua
@include physics/aabb.lua
@include physics/body.lua
@include level/level.lua
@include sound/sound.lua
@include game.lua

local cam = camera2d.new()
local lvl = level.new()
local sp = sprite.new(texture.load([[
@include assets/textures/link
]]))

sp.scale = vec3.new(0.0625, 0.0625, 1) 

local b = body.new()

sp:addComponent(aabb.new():matchParent())
sp:addComponent(b)

local sp2 = sprite.new(texture.new(1, 1, {colors.blue, colors.yellow, colors.red, colors.magenta}))

sp2.pos.y = -0.5
sp2.scale.x = 16

sp2:addComponent(aabb.new():matchParent())

lvl:addObject(sp)
lvl:addObject(sp2)

sound.playSound(sound.load("Í}ÿÿÿ}ÿ}}}}ÿnÿ}"))

game = {
  inputmanagers = {
    {
      handleEvent = function(self, event, p1, p2, p3, p4, p5)
        if event == "mouse_click" then b.velocity.y = 0.25 end
      end
    }
  },
  
  fps = 20,
  
  init = function(self)
    local termWidth, termHeight = term.getSize()
    cam:viewport(1, 1, termWidth * 2, termHeight * 3, true)
    b.velocity.x = 0.125
  end,
  
  update = function(self)
    lvl:update()
    term.setCursorPos(1, 1)
    print(time.deltaTime / 20)
  end,
  
  render = function(self)
    cam:clear(colors.black)
    cam:render(lvl)
  end
}

rungame(game)