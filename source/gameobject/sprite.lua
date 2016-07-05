@include graphics/spriterenderer.lua
@include gameobject.lua

sprite = {
  new = function(tex)
    local go = gameobject.new()
    go:addComponent(spriterenderer.new(), "renderer")
    if tex then go:addComponent(tex, "texture") end
    
    return go
  end
}