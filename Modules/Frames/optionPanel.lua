--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, readi = ...
--------------------------------------------------------------------------------
-- READI:OptionPanel
--------------------------------------------------------------------------------
---@param data table :
---@param opts table :
-- * name [string] : the name to give the panel
-- * parent (optional) [string] : the name of the parent panel if this one is not the main panel itself (defaults to: nil)
-- * title (optional) [table] : a table defining the settings for the panel headline (defaults to: nil)
---- * template [string] : the template to be used for the headline
---- * text [string] :  the headline text itself
---- * color [string] : the headline color
-- * callback [function] : a function to be called right after creating the panel. This function gets the panel, the container and the headline as arguments to enhance positioning of additional content. (defaults to: nil)
function READI:OptionPanel(data, opts)
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
  if not opts.name then
    error(READI:l10n("errors.panel.no_name_given"), 2)
    return 
  end
  --------------------------------------------------------------------------------
  -- DEFINE DEFAULT VALUES
  --------------------------------------------------------------------------------
  local set = {
    parent = nil,
    title = nil,
  }  
  READI.Helper.table:Merge(set, opts)

  -- create the panel frame and set its name
  local panel = CreateFrame("Frame")
  panel.name = set.name

  -- if the panel is not meant to be the addon's main config panel set its parent to the AddonName
  if set.parent then panel.parent = set.parent end

  local container = CreateFrame("Frame", nil, panel)
  container.name = READI.Helper.string:Capitalize(set.name).." Container"
  container:SetPoint("TOPLEFT", 5, -5)
  container:SetPoint("BOTTOMRIGHT", -5, 5)

  -- if the panel is not meant to be the main config panel for the addon set its name or title as headline
  local anchorline = nil
  if set.parent then
    local __txt = set.name
    if set.title then __txt = set.title.text end

    local headline = container:CreateFontString("ARTWORK", nil, set.title.template or "GameFontHighlightLarge")
    headline:SetPoint("TOP", container, 0, -20)
    headline:SetText(READI.Helper.color:Get(set.title.color, data.colors, __txt))

    anchorline = CreateFrame("Frame")
    anchorline:SetPoint("TOP", headline, "BOTTOM", 0,0)
    anchorline:SetPoint("LEFT", container, "LEFT", 0, 0)
    anchorline:SetPoint("RIGHT", container, "RIGHT", 0, 0)
  end

  return panel, container, anchorline
end