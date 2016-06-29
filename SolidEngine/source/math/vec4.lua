vec4 = {
  new = function(x, y, z, w)
    local v = {
      x = x or 0,
      y = y or 0,
      z = z or 0,
      w = w or 0,
      
      dot = function(self, o)
        return self.x * o.x + self.y * o.y + self.z * o.z + self.w * o.w
      end,
      
      cross = function(self, o)
        return vec4.new(
          self.y * o.z - self.z * o.y,
          self.z * o.x - self.x * o.z,
          self.x * o.y - self.y * o.x
        )
      end,
      
      length = function(self)
        return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w)
      end,
      
      normalize = function(self)
        return self * 1 / self:length()
      end,
      
      round = function(self, nTolerance)
          nTolerance = nTolerance or 1
          return vec4.new(
            math.floor((self.x + (nTolerance * 0.5)) / nTolerance) * nTolerance,
            math.floor((self.y + (nTolerance * 0.5)) / nTolerance) * nTolerance,
            math.floor((self.z + (nTolerance * 0.5)) / nTolerance) * nTolerance,
            math.floor((self.w + (nTolerance * 0.5)) / nTolerance) * nTolerance
          )
      end
    }
    
    setmetatable(v, {
      __index = v,
      
      __tostring = function(self)
        return self.x .. ", " .. self.y .. ", " .. self.z .. ", " .. self.w
      end,
      
      __add = function(self, o)
        return vec4.new(
          self.x + o.x,
          self.y + o.y,
          self.z + o.z,
          self.w + o.w
        )
      end,
      
      __sub = function( self, o )
        return vec4.new(
          self.x - o.x,
          self.y - o.y,
          self.z - o.z,
          self.w - o.w
        )
      end,
      
      __mul = function( self, m )
        return vec4.new(
          self.x * m,
          self.y * m,
          self.z * m,
          self.w * m
        )
      end,
      
      __div = function( self, m )
        return vec4.new(
          self.x / m,
          self.y / m,
          self.z / m,
          self.w / m
        )
      end,
      
      __unm = function( self )
        return vec4.new(
          -self.x,
          -self.y,
          -self.z,
          -self.w 
        )
      end
    })
    
    return v
  end
}