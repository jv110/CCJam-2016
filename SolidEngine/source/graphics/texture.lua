texture = {
  colorLookup = {},

  new = function(width, height, pixels)
    local t = {
      type = "texture",
      
      pixels = pixels or {},
      bgcolor = colors.black,
      width = width or 0,
      height = height or 0,
      ppu = 0.0625,
      
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
        return self.pixels[x + y * (self.width + 1)] or self.bgcolor
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
            
            result[y][x] = self.pixels[x + y * self.width + 1] or self.bgcolor
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
  end,

  loadFile = function(path)
    local h = fs.open(path, "r")
    if h then
      local d = h.readAll()
      h.close()
      return texture.load(d)
    end
    return nil
  end,

  load = function(data)
    local tex = texture.new()

    -- Load paintutils image
    local lines = split(data, "\n")
    local llines = #lines
    tex.height = llines
    local image = {}
    for y = 1, llines do
      local line = lines[y]
      local lline = #line
      if lline > tex.width then tex.width = lline end
      local c = {}

      for x = 1, lline do
        c[x] = texture.colorLookup[string.byte(line,x,x)] or 0
      end

      table.insert(image, c)
    end

    -- Transform into texture
    for y = 1, tex.height + 1 do
      for x = 1, tex.width + 1 do
        if image[y] and image[y][x] then
          tex.pixels[x + y * tex.width] = image[y][x]
        else
          tex.pixels[x + y * tex.width] = 0
        end
      end
    end

    return tex
  end,

  fromGIF = function(gif)
  
    return texture.new(width, height, pixels)
  end
}

for i = 1, 16 do
  texture.colorLookup[string.byte("0123456789abcdef", i, i)] = 2 ^ (i - 1)
end