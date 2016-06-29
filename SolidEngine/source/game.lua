function rungame(game)
  local function run()
    local fps = 1 / game.fps
    
    while true do
      sleep(fps)
      game:update()
      game:render()
    end
  end
  
  local function input()
    while true do
      local event, p1, p2, p3, p4, p5 = os.pullEvent()
      
      for _, v in ipairs(game.inputmanagers) do
        v:handleEvent(event, p1, p2, p3, p4, p5)
      end
    end
  end
  
  parallel.waitForAll(run, input)
end

function stopgame()
  error()
end