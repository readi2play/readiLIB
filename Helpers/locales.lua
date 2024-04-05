--------------------------------------------------------------------------------
-- simple localization function
--------------------------------------------------------------------------------
function READI:l10n(key, tbl)
  tbl = tbl or "READI.Localization"
  local loc = GetLocale()
  local __tmp = format([=[
    function ()
      local str = %s.%s.%s
      if str then return str end
    end
  ]=], tbl, loc, key)
  local val = loadstring(__tmp) or
                 loadstring(format("return %s.%s.%s", tbl, "enUS", key))

  return val()
end

RD.loc = READI.l10n