--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
READI.Helper.color = READI.Helper.color or {}

function READI.Helper.color:Get(name, table, ...)
  table = table or READI.Colors
  if not table[name] then error("Requested color could not be found within color tables.") end
  if select("#", ...) > 0 then
    return format("|cFF%s%s|r", table[name], select(1, ...))
  end 
  return table[name] 
end