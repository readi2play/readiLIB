--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, b2h = ...

function READI:CheckFactoryParams(data, opts, ...)
  -- return early and throw an informative error message when ...
  -- ... the 'data' argument is nil
  if not data then
    error(READI:l10n("errors.general.data_is_nil"), 3)
    return 
  end
  -- ... no addon abbreviation was provided
  if not data.prefix or data.prefix == "" then
    error(READI:l10n("errors.general.invalid_addonname_or_abbreviation"), 3)
    return
  end
  -- ... no data storage key has been given
  if not data.keyword then
    error(READI:l10n("errors.general.no_data_storage"), 3)
    return
  end

  -- prevent the error handler throwing errors for not defined variables
  if not ... then return end
  local factory = select(1, ...)
  if not opts then
    error(READI:l10n(format("errors.%s.opts_is_nil", factory)), 3)
  end

  for i=2, select("#", ...) do
    local key = select(i, ...)
    if not opts[key] then
      error(READI:l10n(format("errors.%s.no_%s", factory, key)), 3)
    end
  end
end