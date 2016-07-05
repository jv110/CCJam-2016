@include vec4.lua

mat4x4 = {
  new = function()
    local m = {
      values = {0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0},
      
      getValue = function(self, x, y)
        return self.values[x + y * 4 + 1]
      end,
      
      setValue = function(self, x, y, v)
        self.values[x + y * 4 + 1] = v
      end,
      
      setValues = function(self, v)
        self.values = v
      end,
      
      setIdentity = function(self)
        self.values = {1, 0, 0, 0,
                       0, 1, 0, 0,
                       0, 0, 1, 0,
                       0, 0, 0, 1}
        
        return self
      end,
      
      setRotation = function(self, x, y, z)
        self.values = {x.x, x.y, x.z, 0,
                       y.x, y.y, y.z, 0,
                       z.x, z.y, z.z, 0,
                       0, 0, 0, 1}
        
        return self
      end,
      
      setPerspective = function(self, fov, aspectRatio, near, far)
        local tanHalfFOV = math.tan(fov / 2)
        local range = near - far
        
        self.values = {1.0f / (tanHalfFOV * aspectRatio), 0, 0, 0,
                       0, 1.0f / tanHalfFOV, 0, 0,
                       0, 0, -near - far / range, 2 * far * near / range,
                       0, 0, 1, 0}
        
        return self
      end,
    
      setOrthographic = function(self, left, right, bottom, top, near, far)
        local width = right - left
        local height = top - bottom
        local depth = far - near
        
        self.values = {2 / width, 0, 0, -(right + left) / width,
                       0, 2 / height, 0, -(top + bottom) / height,
                       0, 0, -2 / depth, -(far + near) / depth,
                       0, 0, 0, 1}
        
        return this
      end,
      
      setScreenSpaceTransform = function(self, halfWidth, halfHeight)
        self.values = {halfWidth, 0, 0, halfWidth - 0.5f,
                       0, -halfHeight, 0, halfHeight - 0.5f,
                       0, 0, 1, 0,
                       0, 0, 0, 1}
        
        return self
      end,
      
      fromVector = function(self, vec)
        self.values = {vec.x, 0, 0, 0,
                       vec.y, 0, 0, 0,
                       vec.z, 0, 0, 0,
                       0, 0, 0, 0}
        
        return self
      end,
      
      toVector = function(self)
        return vec3.new(self:getValue(0, 0), self:getValue(0, 1), self:getValue(0, 2) + self:getValue(1, 0) + self:getValue(2, 0) + self:getValue(3, 0), self:getValue(0, 0) + self:getValue(1, 1) + self:getValue(2, 1) + self:getValue(3, 1), self:getValue(0, 2) + self:getValue(1, 2) + self:getValue(2, 2) + self:getValue(3, 2))
      end
    }
    
    setmetatable(m, {
      __mul = function(self, m)
        --print(m)
        local out = vec4.new()
        
        out.x = m.x * self:getValue(0, 0) + m.y * self:getValue(1, 0) + m.z * self:getValue(2, 0) + self:getValue(3, 0)
        out.y = m.x * self:getValue(0, 1) + m.y * self:getValue(1, 1) + m.z * self:getValue(2, 1) + self:getValue(3, 1)
        out.z = m.x * self:getValue(0, 2) + m.y * self:getValue(1, 2) + m.z * self:getValue(2, 2) + self:getValue(3, 2)
        out.w = m.x * self:getValue(0, 3) + m.y * self:getValue(1, 3) + m.z * self:getValue(2, 3) + self:getValue(3, 3)
        
        if not out.w == 1 then
          --out.x = out.x / out.w
          --out.y = out.y / out.w
          --out.z = out.z / out.w
        end
        
        --print(out)
        
        return out
      end
    })
    
    return m
  end
}