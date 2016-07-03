aabb = {
  new = function(x1, y1, z1, x2, y2, z2)
    local a = {
      type = "collider",
      
      x1 = 0,
      y1 = 0,
      z1 = 0,
      x2 = 0,
      y2 = 0,
      z2 = 0,

      matchParent = function(self)
        self.matchParentMode = true

        return self
      end,

      isAABBInside = function(self, a)
        if self.x2 < a.x1 then return false end
        if self.x1 > a.x2 then return false end
        if self.y2 < a.y1 then return false end
        if self.y1 > a.y2 then return false end
        if self.z2 < a.z1 then return false end
        if self.z1 > a.z2 then return false end

        return true
      end,

      isInside = function(self, x, y, z)
        return x > self.x1 and x < self.x2 and y > self.y1 and y < self.y2 and z > self.z1 and z < self.z2
      end,

      update = function(self, level)
        local tex = self.parent:getComponent("texture")

        if self.matchParentMode and tex then
          local scale = self.parent.scale
          local size = vec3.new(scale.x * tex.width * tex.ppu, scale.y * tex.height * tex.ppu)
          self.x1 = self.parent.pos.x - size.x
          self.y1 = self.parent.pos.y - size.y
          self.z1 = self.parent.pos.z - size.z
          self.x2 = self.parent.pos.x + size.x
          self.y2 = self.parent.pos.y + size.y
          self.z2 = self.parent.pos.z + size.z
        end
      end
    }

    if type(x1) == "table" then
      a.x1 = x1.x
      a.y1 = x1.y
      a.z1 = x1.z

      if type(y1) == "table" then
        a.x1 = y1.x
        a.y1 = y1.y
        a.z1 = y1.z
      end
    else
      if x1 then a.x1 = x1 end
      if y1 then a.y1 = y1 end
      if z1 then a.z1 = z1 end
      if x2 then a.x2 = x2 end
      if y2 then a.y2 = y2 end
      if z2 then a.z2 = z2 end
    end

    setmetatable(a, {
      __add = function(self, v)
        local r = aabb.new(self.x1 + v.x, self.y1 + v.y, self.z1 + v.z, self.x2 + v.x, self.y2 + v.y, self.z2 + v.z)
        r.parent = self.parent
        return r
      end,

      __sub = function(self, v)
        local r = aabb.new(self.x1 - v.x, self.y1 - v.y, self.z1 - v.z, self.x2 - v.x, self.y2 - v.y, self.z2 - v.z)
        r.parent = self.parent
        return r
      end
    })

    return a
  end
}