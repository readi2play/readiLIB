--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
READI.Helper.string = READI.Helper.string or {}

function READI.Helper.string:Split(str)
  local words = {}
  for word in string.gmatch(str, "%w+") do table.insert(words, word) end
  return words
end

function READI.Helper.string.Capitalize(...)
  local size = select("#", ...)
  local str = select(1, ...)
  if size > 1 then str = select(2, ...) end

  local words = READI.Helper.string:Split(str)
  for i=1, #words do
    words[i] = words[i]:gsub("^%l", string.upper)
  end
  return table.concat(words, " ")
end