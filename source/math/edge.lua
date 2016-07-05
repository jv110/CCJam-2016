edge = {
  new = function(gradient, minYVert, maxYVert, minYVertIndex)
    e = {
      getX = function(self) return self.x end,
      getYStart = function(self) return self.yStart end,
      getYEnd = function(self) return self.yEnd end,
      getTexCoordX = function(self) return self.texCoordX end,
      getTexCoordY = function(self) return self.texCoordY end,
      getOneOverZ = function(self) return self.oneOverZ end,
      getDepth = function(self) return self.depth end,
      
      step = function(self)
        self.x = self.x + self.xStep
        self.texCoordX = self.texCoordX + self.texCoordXStep
        self.texCoordY = self.texCoordY + self.texCoordYStep
        self.oneOverZ = self.oneOverZ + self.oneOverZStep
        self.depth = self.depth + self.depthStep
      end,
    
      init = function(self, gradient, minYVert, maxYVert, minYVertIndex)
        self.yStart = math.ceil(minYVert:getY())
        self.yEnd = math.ceil(maxYVert:getY())
    
        local yDist = maxYVert:getY() - minYVert:getY()
        local xDist = maxYVert:getX() - minYVert:getX()
    
        local yPreStep = self.yStart - minYVert:getY()
        self.xStep = xDist / yDist
        self.x = minYVert:getX() + yPreStep * self.xStep
        local xPreStep = self.x - minYVert:getX()
        
        self.texCoordX = gradient:getTexCoordX(minYVertIndex) + gradient:getTexCoordXXStep() * xPreStep + gradient:getTexCoordXYStep() * yPreStep
        self.texCoordXStep = gradient:getTexCoordXYStep() + gradient:getTexCoordXXStep() * self.xStep
        
        self.texCoordY = gradient:getTexCoordY(minYVertIndex) + gradient:getTexCoordYXStep() * xPreStep + gradient:getTexCoordYYStep() * yPreStep
        self.texCoordYStep = gradient:getTexCoordYYStep() + gradient:getTexCoordYXStep() * self.xStep
        
        self.oneOverZ = gradient:getOneOverZ(minYVertIndex) + gradient:getOneOverZXStep() * xPreStep + gradient:getOneOverZYStep() * yPreStep
        self.oneOverZStep = gradient:getOneOverZYStep() + gradient:getOneOverZXStep() * self.xStep
        
        self.depth = gradient:getDepth(minYVertIndex) + gradient:getDepthXStep() * xPreStep + gradient:getDepthYStep() * yPreStep
        self.depthStep = gradient:getDepthYStep() + gradient:getDepthXStep() * self.xStep
      end
    }
    
    e:init(gradient, minYVert, maxYVert, minYVertIndex)
    e.init = nil
    
    return e
  end
}