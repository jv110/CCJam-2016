texture = {
  new = function(width, height, pixels)
    local t = {
      type = "texture",
      
      pixels = pixels or {},
      width = width or 51 * 2,
      height = height or 19 * 3,
      ppu = 1,
      
      getWidth = function(self)
        return self.width
      end,
      
      getHeight = function(self)
        return self.height
      end,
      
      setPixel = function(self, x, y, color)
        if x >= 1 and y >= 1 and x <= self.width and y <= self.height then
          self.pixels[x + y * self.width + 1] = color
        end
      end,
      
      getPixel = function(self, x, y)
        return self.pixels[x + y * self.width + 1] or colors.pink
      end,
      
      setSize = function(self, width, height)
        self.width, self.height = width, height
      end,
      
      setWidth = function(self, width)
        self.width = width
      end,
      
      setHeight = function(self, height)
        self.height = height
      end,
      
      toPaintUtils = function(self)
        local result = {}
        
        for x = 1, self.width do
          for y = 1, self.height do
            if not result[y] then result[y] = {} end
            
            result[y][x] = self.pixels[x + y * self.width + 1] or colors.black
          end
        end
        
        return result
      end,
      
      toBLittle = function(self)
        os.loadAPI("blittle")
        
        return blittle.shrink(self:toPaintUtils())
      end
    }
    
    return t
  end
}