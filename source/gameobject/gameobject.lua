@include math/vec4.lua
@include math/vec3.lua

gameobject = {
  new = function()
    return {
      pos = vec4.new(),
      rot = vec3.new(),
      scale = vec3.new(1, 1, 1),
      components = {},
      
      getComponent = function(self, t)
        return self.components[t]
      end,
      
      addComponent = function(self, component, t)
        self.components[t or component.type] = component
        component.parent = self
      end,
      
      update = function(self)
      
      end
    }
  end
}

setmetatable(gameobject, {__index = gameobject, __call = gameobject.new})