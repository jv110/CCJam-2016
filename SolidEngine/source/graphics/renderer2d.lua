@include math/gradient.lua
@include math/mat4x4.lua
@include math/vertex.lua
@include math/edge.lua
@include texture.lua

renderer2d = {
  new = function()
    return {
      meshes = {},
      
      submit = function(self, mesh, tex)
        mesh.tex = tex
        table.insert(self.meshes, mesh)
      end,
      
      fillTriangle = function(self, v1, v2, v3, texture, cam)
        local minYVert = v1:transform(cam.screenSpaceTransform)
        local midYVert = v2:transform(cam.screenSpaceTransform)
        local maxYVert = v3:transform(cam.screenSpaceTransform)
        
        local handedness = minYVert:triangleAreaTimesTwo(maxYVert, midYVert) >= 0
        
        if handedness then
          return nil
        end
        
        if maxYVert:getY() < midYVert:getY() then
          local temp = maxYVert
          maxYVert = midYVert
          midYVert = temp
        end
        
        if(midYVert:getY() < minYVert:getY()) then
          local temp = midYVert
          midYVert = minYVert
          minYVert = temp
        end
        
        if(maxYVert:getY() < midYVert:getY()) then
          local temp = maxYVert
          maxYVert = midYVert
          midYVert = temp
        end
        
        self:scanEdges(minYVert, maxYVert, minYVert, midYVert, texture, cam.buffer)
        self:scanEdges(minYVert, maxYVert, midYVert, maxYVert, texture, cam.buffer)
      end,
      
      scanEdges = function(self, leftMinYVert, leftMaxYVert, rightMinYVert, rightMaxYVert, texture, buffer)
        local xMin = math.ceil(leftMinYVert:getX())
        local xMax = math.ceil(rightMinYVert:getX())
        local yStart = math.ceil(rightMinYVert:getY())
        local yEnd = math.ceil(rightMaxYVert:getY())
        
        local xDist = rightMinYVert:getX() - leftMinYVert:getX()
        local yDist = rightMaxYVert:getY() - rightMinYVert:getY()
        
        local texCoordX = 1
        local texCoordXStep = texture.width / xDist --/ texture.width
        
        local texCoordY = 0
        local texCoordYStep = texture.height / yDist --/ texture.height
        
        for j = yStart, yEnd do
          local itexCoordX = texCoordX
          
          for i = xMin, xMax do
            local srcX = math.floor(itexCoordX + 0.5)
            local srcY = math.floor(texCoordY + 0.5)
            
            buffer:setPixel(i, j, texture:getPixel(srcX, srcY))

            itexCoordX = itexCoordX + texCoordXStep
          end
          
          texCoordY = texCoordY + texCoordYStep
        end
      end,

      flush = function(self, cam)
        for _, mesh in ipairs(self.meshes) do
          for i = 1, #mesh, 3 do
            local tex = mesh.tex
            
            if tex then
              self:fillTriangle(mesh[i], mesh[i + 1], mesh[i + 2], tex, cam)
            end
          end
        end
        
        self.meshes = {}
      end
    }
  end
}