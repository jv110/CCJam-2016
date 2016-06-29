@include graphics/spriterenderer.lua
@include gameobject.lua

sprite = {
  new = function(tex)
    local go = gameobject.new()
    local sr = spriterenderer.new()
    go:addComponent(sr, "renderer")
    if tex then go:addComponent(tex, "texture") end
    
    return go
  end
}