@include util/textutils.lua
@include util/fileutils.lua
@include notes.lua

sound = {
  playing = {},
  cb = nil,

  new = function(notes, speed)
    local s = {
      notes = notes or {},
      speed = speed or 0,
      
      addBreak = function(self)
        table.insert(self.notes, {note = 3})
      end,

      addNote = function(self, note, instrument)
        if type(note) == "string" then
          table.insert(self.notes, {note = notes[note] or 3, instrument = instrument or "harp"})
        elseif type(note) == "number" then
          table.insert(self.notes, {note = note or 3, instrument = instrument or "harp"})
        end
      end
    }

    return s
  end,

  connect = function(side)
    local cb = peripherals.wrap(side)
    if cb then self.cb = cb end
  end,

  load = function(data)
    local result = sound.new()
    local lines = textutils.split(data, "\n")
    local f = data

    for i = 1, #lines do
      if #lines[i] > 0 then
        f = lines[i]
      end
    end
    
    local notes = textutils.chars(f)
    local speed = notes[1]:byte(1)
    
    if (not speed) or tonumber(notes[2]:byte(1)) <= 200 then return nil end
    
    result.speed = speed
    instruments = {
      "bass",
      "bd",
      "harp",
      "hat",
      "pling",
      "snare"
    }

    curinstrument = 0

    for i = 2, #notes do
      local rnote = {}
      local note = notes[i]
      local b = notes[i]:byte(1)

      if b == 255 then
        result:addBreak()
      elseif b > 200 then
        curinstrument = instruments[b - 200]
      else
        result:addNote(b / 100, curinstrument)
      end
    end

    return result
  end,

  loadFile = function(path)
    return sound.load(fileutils.readFile(path))
  end,

  playNote = function(note, volume)
    if note.note == 3 then return nil end

    if commands and commands.exec then
      commands.exec("playsound note." .. note.instrument .. " @p ~ ~ ~ " .. (volume or 100) .. " " .. note.note)
    elseif self.cb then
      self.cb.setCommand("playsound note." .. note.instrument .. " @p ~ ~ ~ " .. (volume or 100) .. " " .. note.note)
      self.cb.runCommand()
    end
  end,

  continue = function()
    for _, v in ipairs(sound.playing) do
      v:continue()
    end
  end,

  playSound = function(s, volume)
    local c = {
      notes = s.notes,
      nps = 1 / s.speed,
      volume = volume,
      t = os.time() * 1000 + 1 / s.speed,
      stage = 1,

      continue = function(self)
        if os.time() * 1000 >= self.t then
          sound.playNote(self.notes[self.stage], volume)
          self.stage = self.stage + 1
          self.t = os.time() * 1000 + self.nps
        end
      end
    }

    table.insert(sound.playing, c)
    c:continue()
  end
}