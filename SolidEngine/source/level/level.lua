level = {
  new = function()
    return {
      objects = {},
      
      addObject = function(self, obj)
        table.insert(self.objects, obj)
      end,

      isInObject = function(self, a)
        for _, v in ipairs(self.objects) do
          local b = v:getComponent("collider")

          if (not (a.parent and a.parent == v)) and b and b:isAABBInside(a)then
            return true, v
          end
        end 
      end,

      update = function(self)
        for _, o in ipairs(self.objects) do
          o:update(self)

          for _, c in pairs(o.components) do
            if not (c.update == nil) then
              c:update(self)
            end
          end
        end
      end
    }
  end
}