@include math/mat4x4.lua
@include math/vec3.lua
@include renderer.lua

camera = {
  new = function()
    return {
      pos = vec3.new(),
      rot = vec3.new(),
      
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
      
      render = function(self, level)
        for _, v in ipairs(level.objects) do
          local r = v:getComponent("renderer")
          
          if r then
            local orientation = mat4x4.new():setRotation(vec3.new(self.rot.x), vec3.new(0, self.rot.y), vec3.new(0, 0, self.rot.z))
            
            local view = orientation --* self.pos
            
            r:render(view)
          end
        end
        
        renderer:flush()
      end
    }
  end
}