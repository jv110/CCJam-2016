@include math/gradient.lua
@include math/mat4x4.lua
@include math/vertex.lua
@include math/edge.lua
@include texture.lua

renderer = {
  projectionmat = mat4x4.new():setPerspective(70, 1, 0.1, 100),
  buffer = texture.new(),
  meshes = {},
  zBuffer = {},
  
  project = function(self, vec)
    v = self.projectionmat * vec
    v.z = v.z + 1
    
    if v.z > 0 then
      v.x = v.x / v.z
      v.y = v.y / v.z
      --v.z = v.z - 1
      return v
    end
    
    return nil
  end,
  
  submit = function(self, vertices, uvs, tex)
    table.insert(self.meshes, {vertices = vertices, uvs = uvs, tex = tex})
  end,
  
  fillTriangle = function(self, v1, v2, v3, texture)
    local screenSpaceTransform = mat4x4.new():setScreenSpaceTransform(self.buffer.width / 2, self.buffer.height / 2)
    local perspective = mat4x4.new():setPerspective(70, 1, 0.1, 100)
    
    local minYVert = v1:transform(screenSpaceTransform):perspectiveDivide()--:transform(perspective)
    local midYVert = v2:transform(screenSpaceTransform):perspectiveDivide()--:transform(perspective)
    local maxYVert = v3:transform(screenSpaceTransform):perspectiveDivide()--:transform(perspective)
    
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
    
    self:scanTriangle(minYVert, midYVert, maxYVert, handedness, texture)
  end,
  
  scanTriangle = function(self, minYVert, midYVert, maxYVert, handedness, texture)
    local gradient       = gradient.new(minYVert, midYVert, maxYVert)
    local topToBottom    = edge.new(gradient, minYVert, maxYVert, 1)
    local topToMiddle    = edge.new(gradient, minYVert, midYVert, 1)
    local middleToBottom = edge.new(gradient, midYVert, maxYVert, 2)
    
    self:scanEdges(gradient, topToBottom, topToMiddle, handedness, texture)
    self:scanEdges(gradient, topToBottom, middleToBottom, handedness, texture)
  end,
  
  scanEdges = function(self, gradient, a, b, handedness, texture)
    local left = a
    local right = b
    
    if handedness then
      local temp = left
      left = right
      right = temp
    end

    local yStart = b:getYStart()
    local yEnd   = b:getYEnd()
    
    for j = yStart, yEnd do
      self:drawScanLine(gradient, left, right, j, texture)
      left:step()
      right:step()
    end
  end,
  
  drawScanLine = function(self, gradient, left, right, j, texture)
    local xMin = math.ceil(left:getX())
    local xMax = math.ceil(right:getX())
    local xPreStep = xMin - left:getX()
    
    local texCoordXXStep = gradient:getTexCoordXXStep()
    local texCoordYXStep = gradient:getTexCoordYXStep()
    local oneOverZXStep = gradient:getOneOverZXStep()
    local depthXStep = gradient:getDepthXStep()
    
    local texCoordX = left:getTexCoordX() + texCoordXXStep * xPreStep
    local texCoordY = left:getTexCoordY() + texCoordYXStep * xPreStep
    local oneOverZ = left:getOneOverZ() + oneOverZXStep * xPreStep
    local depth = left:getDepth() + depthXStep * xPreStep
    
    for i = xMin, xMax do
      local index = i + j * self.buffer.width
      
      if not self.zBuffer[index] or depth < self.zBuffer[index] then
        self.zBuffer[index] = depth
        local z = 1 / oneOverZ
        local srcX = math.floor(texCoordX * z * (texture:getWidth()) + 0.5)
        local srcY = math.floor(texCoordY * z * (texture:getHeight()) + 0.5)
        
        self.buffer:setPixel(i, j, texture:getPixel(srcX, srcY))
        
        --local blbuffer = self.buffer:toBLittle()
        --blittle.draw(blbuffer)
        --local blbuffer = self.buffer:toPaintUtils()
        --paintutils.drawImage(blbuffer, 1, 1)
      end
      
      oneOverZ = oneOverZ + oneOverZXStep
      texCoordX = texCoordX + texCoordXXStep
      texCoordY = texCoordY + texCoordYXStep
      depth = depth + depthXStep
      
      os.queueEvent("f")
      os.pullEvent("f")
    end
  end,
  
  flush = function(self, camera)
    for _, mesh in ipairs(self.meshes) do
      for i = 1, #mesh.vertices, 3 do
        local tex = mesh.tex
        
        if tex then
          local v1 = vertex.new(mesh.vertices[i], mesh.uvs[i])
          local v2 = vertex.new(mesh.vertices[i + 1], mesh.uvs[i + 1])
          local v3 = vertex.new(mesh.vertices[i + 2], mesh.uvs[i + 2])
          
          self:fillTriangle(v1, v2, v3, tex)
        end
      end
    end
    
    self.zBuffer = {}
    self.meshes = {}
    
    local blbuffer = self.buffer:toBLittle()
    blittle.draw(blbuffer)
  end
}