--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
READI.Helper.string = READI.Helper.string or {}
RD.hlp.str = READI.Helper.string

function READI.Helper.string:Split(str, sep)
  sep = sep or "%s"
  local t={}
  for str in string.gmatch(str, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end
function READI.Helper.string:GetWords(str)
  local words = {}
  for word in string.gmatch(str, "%w+") do table.insert(words, word) end
  return words
end
function READI.Helper.string.Capitalize(...)
  local size = select("#", ...)
  local str = select(1, ...)
  if size > 1 then str = select(2, ...) end

  local words = READI.Helper.string:GetWords(str)
  for i=1, #words do
    words[i] = words[i]:gsub("^%l", string.upper)
  end
  return table.concat(words, " ")
end
function READI.Helper.string:Trim(str)
  local trimmed = {}
  for line in str:gmatch("([^\n]*)\n?") do
    table.insert(trimmed, string.trim(line))
  end
  return table.concat(trimmed, "\n")
end
function READI.Helper.string.Contains(str, pat)
  return string.find(str, pat) ~= nil
end