--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, b2h = ...
--------------------------------------------------------------------------------
-- READI:Button
--------------------------------------------------------------------------------
-- A simple factory function for easily creating UI Buttons with Lua
--
---@param data table:
-- * addon [string] : A string representing the addon that uses this library function, could be the name or an abbreviation
-- * keyword [string] : The keyword within the data storage to address
--
---@param opts table:
-- * onClick [function] : Callback function for what to happen when the button is clicked
-- * anchor (optional) [string] : The positioning anchor of the new frame (defaults to "TOPLEFT")
-- * offsetX (optional) [number] : The x-axis offset of the created frame (defaults to: 0)
-- * offsetY (optional) [number] : The y-axis offset of the created frame (defaults to: 0)
-- * name (optional) [string] : The name the created frame should have (defaults to: nil)
-- * region (optional) [frame] : The frame the new one should relate to (defaults to: nil)
-- * template (optional) [string] : The Template that should be used for creating the button (defaults to: "UIPanelButtonTemplate")
-- * label (optional) [string] : The text that should appear on the button (defaults to: "")
-- * text (optional) [string] : An additional text to be conditionally shown below the button (defaults to: "")
-- * condition (optional) [boolean] : the condition for the additional text (defaults to: false)
-- * enabled (optional) [boolean] : determine if the button should be enabled (true) or disabled (false) (defaults to: true)
-- * parent (optional) [frame] : The frame the new one should be positioned relative to
-- * p_anchor (optional) [string] : The anchor point of the parent frame (defaults to: "BOTTOMLEFT")
-- * width (optional) [number] : The button's width (defaults to TextWidth + 30, respectively to 130 if no text is set)
-- * height (optional) [number] : The button's height (defaults to TextHeight + 10, respectively to 22 if no text is set)
-- * onReset (optional) [function] : Callback function for what to happen when the current window's editables are reset 
-- * onClear (optional) [function] : Callback function for what to happen when all fields within the window are cleared
function READI:Button(data, opts)
  --------------------------------------------------------------------------------
  -- Error Handling
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
    error(READI:l10n("errors.button.opts_is_nil"), 2)
    return 
  end

  --------------------------------------------------------------------------------
  -- default values
  --------------------------------------------------------------------------------
  local set = {
    name = nil,
    region = nil,
    template = "UIPanelButtonTemplate",
    label = "",
    text = "",
    condition = false,
    enabled = true,
    anchor = "TOPLEFT",
    parent = nil,
    p_anchor = "BOTTOMLEFT",
    offsetX = 0,
    offsetY = 0,
    width = nil,
    height = nil,
    onReset = function() end,
    onClear = function() end
  }
  READI.Helper.table:Merge(set, opts)

  --------------------------------------------------------------------------------
  -- Creating the button
  --------------------------------------------------------------------------------
  local btn = _G[set.name] or CreateFrame("Button", set.name, set.region, set.template)
  if set.parent and set.p_anchor then
    btn:SetPoint(set.anchor, set.parent, set.p_anchor, set.offsetX, set.offsetY)
  else
    btn:SetPoint(set.anchor, set.offsetX, set.offsetY)
  end
  
  if set.label then btn:SetText(set.label) end
  btn:SetWidth(set.width or (btn:GetTextWidth() or 100) + 30)
  btn:SetHeight(set.height or (btn:GetTextHeight() or 22) + 10)

  btn:SetScript("OnClick", set.onClick)

  if set.text and set.text ~= "" then
    local conText = set.region:CreateFontString("ARTWORK", nil, "GameFontHighlight")
    conText:SetPoint("TOP", btn, "BOTTOM", 0, -5)
    conText:SetText(text)
    conText:Hide()
  end

  if set.condition then set.conText:Show() end
  if not set.enabled then btn:Disable() end

  --------------------------------------------------------------------------------
  -- Register Custom Events
  --------------------------------------------------------------------------------
  EventRegistry:RegisterCallback(format("%s.%s.%s", data.addon, data.keyword, "OnReset"), set.onReset)
  EventRegistry:RegisterCallback(format("%s.%s.%s", data.addon, data.keyword, "OnClear"), set.onClear)

  return btn
end