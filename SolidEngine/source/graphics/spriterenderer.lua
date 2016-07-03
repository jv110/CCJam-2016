@include math/vec4.lua
@include math/vec3.lua

spriterenderer = {
  new = function()
    return {
      type = "renderer",
      
      render = function(self, cam)
        local tex = self.parent:getComponent("texture")
        
        if tex then
          local pos = self.parent.pos - cam.pos
          local scale = self.parent.scale
          local size = vec3.new(scale.x * tex.width * tex.ppu, scale.y * tex.height * tex.ppu)
          --local rot = self.parent.rot + cam.rot
          
          local topLeft =     cam.screenSpaceTransform * vec4.new(pos.x - size.x, pos.y + size.y, pos.z, pos.w)
          local topRight =    cam.screenSpaceTransform * vec4.new(pos.x + size.x, pos.y + size.y, pos.z, pos.w)
          local bottomLeft =  cam.screenSpaceTransform * vec4.new(pos.x - size.x, pos.y - size.y, pos.z, pos.w)
          local bottomRight = cam.screenSpaceTransform * vec4.new(pos.x + size.x, pos.y - size.y, pos.z, pos.w)
          local xDist = topRight.x - topLeft.x
          local yDist = bottomLeft.y - topLeft.y
          local texCoordXStep = tex.width / xDist
          local texCoordYStep = tex.height / yDist
          
          local texCoordY = 0
          for y = math.floor(topLeft.y), math.floor(bottomLeft.y) do
            local texCoordX = 1

            for x = math.floor(topLeft.x), math.floor(topRight.x) do
              cam.buffer:setPixel(x, y, tex:getPixel(math.floor(texCoordX + 0.5), math.floor(texCoordY + 0.5)))
              texCoordX = texCoordX + texCoordXStep
            end
            
            texCoordY = texCoordY + texCoordYStep
          end
        end
      end
    }
  end
}