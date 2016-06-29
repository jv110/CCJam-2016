@include math/vec4.lua
@include math/vec3.lua
@include renderer.lua

spriterenderer = {
  new = function()
    return {
      type = "renderer",
      
      render = function(self, view)
        local tex = texture.new(2, 2, {colors.blue, colors.yellow, colors.red, colors.orange, colors.magenta, colors.gray, colors.white, colors.lightGray, colors.pink})--self.parent:getComponent("texture")
        
        if tex then -- Sprite model, a 2D square
          local vertices = {vec4.new(-1, 0, 1, 1),
                            vec4.new(0, 0, 1, 1),
                            vec4.new(-1, -1, 1, 1),
                            vec4.new(0, 0, 1, 1),
                            vec4.new(0, -1, 1, 1),
                            vec4.new(-1, -1, 1, 1)}
          local uvs = {vec3.new(0, 0), vec3.new(1, 0), vec3.new(0, 1), vec3.new(1, 0), vec3.new(1, 1), vec3.new(0, 1)}
          
          renderer:submit(vertices, uvs, tex)
          renderer:flush()
        end
      end
    }
  end
}