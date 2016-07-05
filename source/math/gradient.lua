gradient = {
  new = function(minYVert, midYVert, maxYVert)
    local g = {
      getTexCoordX = function(self, loc) return self.texCoordX[loc] end,
      getTexCoordY = function(self, loc) return self.texCoordY[loc] end,
      getOneOverZ = function(self, loc) return self.oneOverZ[loc] end,
      getDepth = function(self, loc) return self.depth[loc] end,
      
      getTexCoordXXStep = function(self) return self.texCoordXXStep end,
      getTexCoordXYStep = function(self) return self.texCoordXYStep end,
      getTexCoordYXStep = function(self) return self.texCoordYXStep end,
      getTexCoordYYStep = function(self) return self.texCoordYYStep end,
      getOneOverZXStep = function(self) return self.oneOverZXStep end,
      getOneOverZYStep = function(self) return self.oneOverZYStep end,
      getDepthXStep = function(self) return self.depthXStep end,
      getDepthYStep = function(self) return self.depthYStep end,
      
      calcXStep = function(self, values, minYVert, midYVert, maxYVert, oneOverdX)
        return (((values[2] - values[3]) * (minYVert:getY() - maxYVert:getY())) - ((values[1] - values[3]) * (midYVert:getY() - maxYVert:getY()))) * oneOverdX
      end,
      
      calcYStep = function(self, values, minYVert, midYVert, maxYVert, oneOverdY)
        return (((values[2] - values[3]) * (minYVert:getX() - maxYVert:getX())) - ((values[1] - values[3]) * (midYVert:getX() - maxYVert:getX()))) * oneOverdY
      end,
      
      saturate = function(self, val)
        if val > 1 then
          return 1
        end
        
        if val < 0 then
          return 0
        end
        
        return val
      end,
      
      init = function(self, minYVert, midYVert, maxYVert)
        local oneOverdX = 1 / (((midYVert:getX() - maxYVert:getX()) * (minYVert:getY() - maxYVert:getY())) - ((minYVert:getX() - maxYVert:getX()) * (midYVert:getY() - maxYVert:getY())))
        local oneOverdY = -oneOverdX
        
        self.oneOverZ = {}
        self.texCoordX = {}
        self.texCoordY = {}
        self.depth = {}
        
        self.depth[1] = minYVert:getZ()
        self.depth[2] = midYVert:getZ()
        self.depth[3] = maxYVert:getZ()
        
        -- Note that the W component is the perspective Z value
        -- The Z component is the occlusion Z value
        self.oneOverZ[1] = 1 / minYVert:getW()
        self.oneOverZ[2] = 1 / midYVert:getW()
        self.oneOverZ[3] = 1 / maxYVert:getW()
        
        self.texCoordX[1] = minYVert.texcoords.x * self.oneOverZ[1]
        self.texCoordX[2] = midYVert.texcoords.x * self.oneOverZ[2]
        self.texCoordX[3] = maxYVert.texcoords.x * self.oneOverZ[3]
        
        self.texCoordY[1] = minYVert.texcoords.y * self.oneOverZ[1]
        self.texCoordY[2] = midYVert.texcoords.y * self.oneOverZ[2]
        self.texCoordY[3] = maxYVert.texcoords.y * self.oneOverZ[3]
        
        self.texCoordXXStep = self:calcXStep(self.texCoordX, minYVert, midYVert, maxYVert, oneOverdX)
        self.texCoordXYStep = self:calcYStep(self.texCoordX, minYVert, midYVert, maxYVert, oneOverdY)
        self.texCoordYXStep = self:calcXStep(self.texCoordY, minYVert, midYVert, maxYVert, oneOverdX)
        self.texCoordYYStep = self:calcYStep(self.texCoordY, minYVert, midYVert, maxYVert, oneOverdY)
        self.oneOverZXStep = self:calcXStep(self.oneOverZ, minYVert, midYVert, maxYVert, oneOverdX)
        self.oneOverZYStep = self:calcYStep(self.oneOverZ, minYVert, midYVert, maxYVert, oneOverdY)
        self.depthXStep = self:calcXStep(self.depth, minYVert, midYVert, maxYVert, oneOverdX)
        self.depthYStep = self:calcYStep(self.depth, minYVert, midYVert, maxYVert, oneOverdY)
      end
    }
    
    g:init(minYVert, midYVert, maxYVert)
    g.init = nil
    
    return g
  end
}