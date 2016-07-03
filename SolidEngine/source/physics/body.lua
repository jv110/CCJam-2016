@include util/time.lua

body = {
  new = function()
    return {
      type = "body",

      velocity = vec4.new(),
      acceleration = vec4.new(0, -0.25, 0),

      update = function(self, level)
        local c = self.parent:getComponent("collider")
        
        local vp = self.velocity * time.deltaTime
        
        if c == nil or not level:isInObject(c + vp) then
          self.parent.pos = self.parent.pos + vp
          self.velocity = self.velocity + self.acceleration * time.deltaTime
        else
          self.velocity = vec4.new()
        end
      end
    }
  end
}
