--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
READI.Helper.color = READI.Helper.color or {}
RD.hlp.col = READI.Helper.color 

function READI.Helper.color:Get(name, table, ...)
  table = table or RD.Colors
  if not table[name] then error("Requested color ".. name .." could not be found within color tables.", 2) end
  if select("#", ...) > 0 then
    local string = select(1, ...)
    return format("|cFF%s%s|r", table[name], string)
  end 
  return table[name] 
end