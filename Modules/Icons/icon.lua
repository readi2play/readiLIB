--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, readi = ...
--------------------------------------------------------------------------------
-- READI:Icon
--------------------------------------------------------------------------------
---@param data table :
---@param opts table :
-- * name (optional) [string] : a unique name for the icon (defaults to nil)
-- * region (optional) [string] : the name of the parent panel if this one is not the main panel itself (defaults to: nil)
-- * texture [string] : either the texture path or texture id of the icon to display
-- * width [number] : the width of the created icon. (defaults to: 32)
-- * height [number] : the height of the created icon. (defaults to: 32)
  function READI:Icon(data, opts)
  --------------------------------------------------------------------------------
  -- ERROR HANDLING
  --------------------------------------------------------------------------------
  -- return early and throw an informative error message when ...
  -- ... the 'data' argument is nil
  if not data then
    error(READI:l10n("errors.general.data_is_nil"), 2)
    return 
  end
  -- ... no addon abbreviation was provided
  if not data.addon or data.addon == "" then
    error(READI:l10n("errors.general.invalid_addonname_or_abbreviation"), 2)
    return
  end
  -- ... no data storage key has been given
  if not data.keyword then
    error(READI:l10n("errors.general.no_data_storage"), 2)
    return
  end
  -- ... the 'opts' argument is nil
  if not opts then
    error(READI:l10n("errors.panel.opts_is_nil"), 2)
    return 
  end
  -- ... no name has been given
  if not opts.texture then
    error(READI:l10n("errors.icon.no_texture_set"), 2)
    return 
  end
  --------------------------------------------------------------------------------
  -- DEFINE DEFAULT VALUES
  --------------------------------------------------------------------------------
  local set = {
    name = nil,
    region = nil,
    width = 32,
    height = 32,
  }
  READI.Helper.table:Merge(set, opts)
  --------------------------------------------------------------------------------
  -- CREATE THE ICON
  --------------------------------------------------------------------------------
  local icon = nil
  if set.name and set.region then
    icon = CreateFrame("Frame", set.name, set.region)
  elseif not set.region then
    icon = CreateFrame("Frame", set.name)
  else
    icon = CreateFrame("Frame")
  end
  icon:SetSize(set.width, set.height)
  icon.tex = icon:CreateTexture()
  icon.tex:SetAllPoints(icon)
  icon.tex:SetTexture(set.texture)
  
  return icon
end