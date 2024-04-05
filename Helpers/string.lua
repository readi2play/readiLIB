--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
READI.Helper.string = READI.Helper.string or {}
RD.hlp.str = READI.Helper.string

function READI.Helper.string:GetWords(str)
  local words = {}
  for word in str:gmatch("%S+") do table.insert(words, word) end
  return words
end

<<<<<<< Updated upstream
function READI.Helper.string:Capizalize(str)
  local words = READI.Helper.string:Split(str)
=======
function READI.Helper.string.Capitalize(...)
  local size = select("#", ...)
  local str = select(1, ...)
  if size > 1 then str = select(2, ...) end

  local words = READI.Helper.string:GetWords(str)
>>>>>>> Stashed changes
  for i=1, #words do
    words[i] = words[i]:gsub("^%l", string.upper)
  end
  return table.concat(words, " ")
end