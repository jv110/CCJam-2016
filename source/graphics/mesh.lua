@include util/textutils.lua
@include math/vertex.lua

mesh = {
  loadOBJ = function(data)
    local vertices = {}
    local indices = {}
    local texcoords = {}
    local texindices = {}
    local lines = textutils.split(data, "\n")

    for i = 1, #lines do
      local line = lines[i]
      local t = textutils.split(line, " ")

      if t[1] == "v" then
        vertices[#vertices + 1] = vector.new(tonumber(t[2]), tonumber(t[3]), tonumber(t[4]))
      end

      if t[1] == "f" then
        local s1 = textutils.split(t[2], "/")
        if #s1 > 1 then
          local s2 = textutils.split(t[3], "/")
          local s3 = textutils.split(t[4], "/")

          indices[#indices + 1] = tonumber(s1[1])
          indices[#indices + 1] = tonumber(s2[1])
          indices[#indices + 1] = tonumber(s3[1])
          texindices[#texindices + 1] = tonumber(s1[2])
          texindices[#texindices + 1] = tonumber(s2[2])
          texindices[#texindices + 1] = tonumber(s3[2])
        else
          indices[#indices + 1] = tonumber(t[2])
          indices[#indices + 1] = tonumber(t[3])
          indices[#indices + 1] = tonumber(t[4])
        end
      end

      if t[1] == "vt" then
        texcoords[#texcoords + 1] = vector.new(tonumber(t[2]), tonumber(t[3]), tonumber(t[4]))
      end
    end

    local verts = {}
    local uvs = {}
    
    local res = {
      type = "mesh"
    }

    for i = 1, #indices do
      if not res[i] then res[i] = vertex.new() end
      res[i].pos = vertices[indices[i]]
    end

    for i = 1, #texindices do
      if not res[i] then res[i] = vertex.new() end
      res[i].texcoords = texcoords[texindices[i]]
    end

    return res
  end
}