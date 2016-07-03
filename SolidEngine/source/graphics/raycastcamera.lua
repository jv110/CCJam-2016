@include math/mat4x4.lua
@include math/vec3.lua
@include renderer2d.lua

camera2d = {
  new = function()
    return {
      screenSpaceTransform = mat4x4.new(),
      renderer = renderer2d.new(),
      buffer = texture.new(),
      pos = vec4.new(),
      rot = vec3.new(),
      
      viewport = function(self, x, y, width, height, hires)
        self.buffer.x, self.buffer.y, self.buffer.width, self.buffer.height = x, y, width, height
        
        self.screenSpaceTransform:setScreenSpaceTransform(width / 2, height / 2)
        self.hires = hires
      end,
      
      setPosition = function(self, x, y, z)
        if type(x) == "table" then
          self.pos = x
        else
          if x then self.pos.x = x end
          if y then self.pos.y = y end
          if z then self.pos.z = z end
        end
      end,
      
      setRotation = function(self, x, y, z)
        if type(x) == "table" then
          self.rot = x
        else
          if x then self.rot.x = x end
          if y then self.rot.y = y end
          if z then self.rot.z = z end
        end
      end,
      
      clear = function(self, color)
        self.buffer.bgcolor = color
        self.buffer.pixels = {}
      end,

      raycast = function(self, angle)
        local sin = math.sin(angle);
        local cos = math.cos(angle);
        
        local xStepX, xStepY, xStepLength = step(sin, cos, self.x, self.pos.y)
        local yStepX, yStepY, yStepLength = step(cos, sin, self.y, self.pos.x, true)
        local nextStep = xStepLength < stepY.xStepLength ? inspect(stepX, 1, 0, origin.distance, stepX.y) : inspect(stepY, 0, 1, origin.distance, stepY.x)

        return [origin].concat(ray(nextStep))
        local function step(a, b, x, y, inverted)
          if (run === 0) return 0, 0, inf
          local dx = b > 0 ? Math.floor(x + 1) - x : Math.ceil(x - 1) - x
          local dy = dx * (a / b)
          return inverted and y + dy or x + dx, inverted and x + dx or y + dy, dx * dx + dy * dy
        end
        
      end,

      drawColumn = function()
        local texture = map.wallTexture;
        local left = Math.floor(column * this.spacing);
        local width = Math.ceil(this.spacing);
        local hit = -1;
        while (++hit < ray.length && ray[hit].height <= 0);
        for (var s = ray.length - 1; s >= 0; s--) {
          var step = ray[s];
          var rainDrops = Math.pow(Math.random(), 3) * s;
          var rain = (rainDrops > 0) && this.project(0.1, angle, step.distance);
          if (s === hit) {
            var textureX = Math.floor(texture.width * step.offset);
            var wall = this.project(step.height, angle, step.distance);
            ctx.globalAlpha = 1;
            ctx.drawImage(texture.image, textureX, 0, 1, texture.height, left, wall.top, width, wall.height);
            
            ctx.fillStyle = '#000000';
            ctx.globalAlpha = Math.max((step.distance + step.shading) / this.lightRange - map.light, 0);
            ctx.fillRect(left, wall.top, width, wall.height);
          }
          
          ctx.fillStyle = '#ffffff';
          ctx.globalAlpha = 0.15;
          while (--rainDrops > 0) ctx.fillRect(left, Math.random() * rain.top, 1, rain.height);
        }
      };

      render = function(self, level)
        for column = 1, self.buffer.width do
          local x = column / self.buffer.width - 0.5;
          local angle = math.atan2(x, 0.8);
          local ray = self:raycast(player.direction + angle);
          self:drawColumn(column, ray, angle, map);
        end
        
        if self.hires then
          local blbuffer = self.buffer:toBLittle()
          blittle.draw(blbuffer)
        else
          paintutils.drawImage(self.buffer:toPaintUtils(), 1, 1)
        end
      end
    }
  end
}