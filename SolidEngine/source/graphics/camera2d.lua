@include math/mat4x4.lua
@include math/vec3.lua
@include renderer2d.lua

camera2d = {
  new = function()
    return {
      screenSpaceTransform = mat4x4.new(),
      renderer = renderer2d.new(),
      buffer = texture.new(),
      pos = vec4.new(),
      rot = vec3.new(),
      
      viewport = function(self, x, y, width, height, hires)
        self.buffer.x, self.buffer.y, self.buffer.width, self.buffer.height = x, y, width, height
        
        self.screenSpaceTransform:setScreenSpaceTransform(width / 2, height / 2)
        self.hires = hires
      end,
      
      setPosition = function(self, x, y, z)
        if type(x) == "table" then
          self.pos = x
        else
          if x then self.pos.x = x end
          if y then self.pos.y = y end
          if z then self.pos.z = z end
        end
      end,
      
      setRotation = function(self, x, y, z)
        if type(x) == "table" then
          self.rot = x
        else
          if x then self.rot.x = x end
          if y then self.rot.y = y end
          if z then self.rot.z = z end
        end
      end,
      
      clear = function(self, color)
        self.buffer.bgcolor = color
        self.buffer.pixels = {}
      end,

      render = function(self, level)
        for _, v in ipairs(level.objects) do
          local mesh = v:getComponent("mesh")
          local tex = v:getComponent("texture")
          local r = v:getComponent("renderer")
          
          if r then
            r:render(self)
          elseif mesh and tex then
            self.renderer:submit(mesh, tex)
          end
        end
        
        self.renderer:flush(self)
        
        if self.hires then
          local blbuffer = self.buffer:toBLittle()
          blittle.draw(blbuffer)
        else
          paintutils.drawImage(self.buffer:toPaintUtils(), 1, 1)
        end
      end
    }
  end
}