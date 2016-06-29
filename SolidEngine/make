local args = {...}
local dir = shell.resolve("")
local root = fs.getDir(dir)
local makefilehandle = fs.open(shell.resolve("makefile"), "r")
local makefile = {}
local included = {}
local defined = {}

if not makefilehandle and (not fs.exists(dir) or fs.isDir(dir)) then
  makefilehandle.close()
  error("Not a file")
end

function contains(t, v)
  for i = 1, #t do
    if t[i] == v then
      return true
    end
  end
  
  return false
end

function startswith(str, start)
  if str and start then
    return string.sub(str, 1, string.len(start)) == start
  else
    return false
  end
end

function split(inputstr, sep)
  sep = sep or "%s"
  
  local t = {}
  local i = 1
  
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  
  return t
end

local s = makefilehandle.readAll()
makefile = assert(loadstring("return {" .. s .. "}"))()
makefilehandle.close()

if not makefile.source then
  error("No source to build")
end

if not makefile.output then
  makefile.output = "build"
end

if not makefile.include then
  makefile.include = {}
end

if fs.exists(shell.resolve(makefile.output)) and fs.isDir(shell.resolve(makefile.output)) then
  error("Directory exists at \"" .. makefile.output .. "\"")
end

local sourcedir
local sourcehandle

sourcedir = shell.resolve(makefile.source)

if makefile.root then
  root = shell.resolve(makefile.root)
else
  root = fs.getDir(shell.resolve(makefile.source))
end

sourcehandle = fs.open(sourcedir, "r")

if not sourcehandle then
  error("No source to build")
end

local sourcename = fs.getName(makefile.source)
local source = split(sourcehandle.readAll(), "\n")
sourcehandle.close()

function parseSource(source, srcdir)
  local fsource = ""
  local ifdef = true
  
  for i = 1, #source do
    local line = source[i]
    
    if startswith(line, "@") then
      local a = split(line, " ")
      
      if a[1] == "@include" then
        local includefile = fs.combine(srcdir, a[2])
        
        if not fs.exists(includefile) or fs.isDir(includefile) then
          includefile = fs.combine(root, a[2])
        end
        
        if not fs.exists(includefile) or fs.isDir(includefile) then
          for i = 1, #makefile.include do
            includefile = shell.resolve(fs.combine(makefile.include[i], a[2]))
            if fs.exists(includefile) and not fs.isDir(includefile) then
              break
            end
          end
        end
        
        if not fs.exists(includefile) or fs.isDir(includefile) then
          error(sourcename .. ", line " .. i .. ": Invalid include file")
        end
        
        local includehandle = fs.open(includefile, "r")
        
        if not includehandle then
          error(sourcename .. ", line " .. i .. ": Invalid include file")
        end
        
        if not contains(included, includefile) then
          included[#included + 1] = includefile
          fsource = fsource .. "\n" .. parseSource(split(includehandle.readAll(), "\n"), fs.getDir(includefile)) .. "\n"
        end
        
        includehandle.close()
      elseif a[1] == "@define" and ifdef then
        defined[a[2]] = a[3] or 0
      elseif a[1] == "@undefine" and ifdef then
        defined[a[2]] = nil
      elseif a[1] == "@ifdef" then
        if defined[a[2]] then
          ifdef = true
        else
          ifdef = false
        end
      elseif a[1] == "@ifndef" then
        if defined[a[2]] then
          ifdef = false
        else
          ifdef = true
        end
      elseif a[1] == "@else" then
        ifdef = not ifdef
      elseif a[1] == "@endif" then
        ifdef = true
      else
        error(sourcename .. ", line " .. i .. ": Invalid command")
      end
    elseif ifdef then
      fsource = fsource .. (line or "") .. "\n"
    end
  end
  
  return fsource
end

local fsource = parseSource(source, fs.getDir(sourcedir))

local outhandle = fs.open(shell.resolve(makefile.output), "w")
outhandle.write(fsource)
outhandle.close()