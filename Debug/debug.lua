------------------------------------------------------------
--- Debug
------------------------------------------------------------
READI.Debug = READI.Debug or {}
------------------------------------------------------------
function READI.Debug:Debug(addonName, con, ...)
  if not con then return end
  print(
    format([=[
      ------------------------------------------
      %s [%s]: %s
      ------------------------------------------
    ]=], addonName, date("%H:%M:%S"), select(1,...))
  , select(2,...))
end
function READI.Debug:Notify(addonName, con, ...)
  if not con then return end
  print(
    format("%s: %s", addonName, select(1,...)),
    select(2,...)
  )
end