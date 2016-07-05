vertex = {
  new = function(pos, texcoords)
    local v = {
      pos = pos,
      texcoords = texcoords or vec3.new(),
      
      getX = function(self)
        return self.pos.x
      end,
      
      getY = function(self)
        return self.pos.y
      end,
      
      getZ = function(self)
        return self.pos.z
      end,
      
      getW = function(self)
        return self.pos.w
      end,
      
      transform = function(self, transform)
        return vertex.new(transform * self.pos, self.texcoords)
      end,
      
      perspectiveDivide = function(self)
        return vertex.new(vec4.new(self.pos.x / self.pos.w, self.pos.y / self.pos.w, self.pos.z / self.pos.w, self.pos.w), self.texcoords)
      end,
      
      triangleAreaTimesTwo = function(self, b, c)
        local x1 = b:getX() - self.pos.x
        local y1 = b:getY() - self.pos.y
        
        local x2 = c:getX() - self.pos.x
        local y2 = c:getY() - self.pos.y
    
        return x1 * y2 - x2 * y1
      end
    }
    
    return v
  end
}