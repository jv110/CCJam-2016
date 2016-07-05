fileutils = {
  readFile = function(path)
    local h = fs.open(shell.resolve(path), "r")

    if h then
      local r = h.readAll()
      h.close()
      return r
    end

    return nil
  end,

  writeFile = function(path, data)
    local h = fs.open(shell.resolve(path), "w")

    if h then
      h.write(data)
      h.close()
    end
  end,

  appendFile = function(path, data)
    local h = fs.open(shell.resolve(path), "a")

    if h then
      h.append(data)
      h.close()
    end
  end,

  mkdir = function(path, data)
    fs.mkdir(shell.resolve(path))
  end,

  exists = function(path, data)
    return fs.exists(shell.resolve(path))
  end
}