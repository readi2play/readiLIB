--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
READI.Helper.functions = READI.Helper.functions or {}
RD.hlp.func = READI.Helper.functions

function READI.Helper.functions:Exists(func)
  local _f = loadstring("return "..func)
  if _f == nil then
    error("Invalid function name: "..func)
  end

  return type(_f()) == "function"
end