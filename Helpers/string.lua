--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
READI.Helper.string = READI.Helper.string or {}

function READI.Helper.string:Split(str)
  local words = {}
  for word in str:gmatch("%S+") do table.insert(words, word) end
  return words
end

function READI.Helper.string:Capizalize(str)
  local words = READI.Helper.string:Split(str)
  for i=1, #words do
    words[i] = words[i]:gsub("^%l", string.upper)
  end
  return table.concat(words, " ")
end