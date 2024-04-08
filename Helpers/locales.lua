--------------------------------------------------------------------------------
-- simple localization function
--------------------------------------------------------------------------------
function READI:l10n(key, tbl, count)
  tbl = tbl or "READI.Localization"
  local loc = GetLocale()
  local plural = ""
  if count then
    if count > 1 then
      plural = ".some"
    elseif count < 1 then
      plural = ".none"
    else
      plural = ".one"
    end
  end
  local __tmp = format([=[
    if not READI.Helper.table:VerifyDepth(%1$s.%s, "%3$s") then
      return %1$s.enUS.%3$s%4$s
    end
    return %1$s.%2$s.%3$s%4$s
  ]=], tbl, loc, key, plural)
  return loadstring(__tmp)()
end

RD.loc = READI.l10n