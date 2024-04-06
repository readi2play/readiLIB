--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, readi = ...
--------------------------------------------------------------------------------
-- READI:DropDown
--------------------------------------------------------------------------------
-- A factory function for easily creating UI Checkboxes with Lua
--
---@param data table:
-- * addon [string] : A string representing the addon that uses this library function, could be the name or an abbreviation
-- * keyword [string] : A keyword used for custom event registration
--
---@param opts table:
-- * values [table] : A table, representing the values of the dropdown list
-- * selected [string] : the currently selected value
-- * onChange [function] : Callback function for what to happen when the button is clicked
-- * name (optional) [string] : The name the created frame should have (defaults to: nil)
-- * region (optional) [frame] : The frame the new one should relate to (defaults to: nil)
-- * template (optional) [string] : The Template that should be used for creating the button (defaults to: "UIDropDownMenuTemplate")
-- * width (optional) [number] : The element's width in pixel (defaults to 200)
-- * anchor (optional) [string] : The positioning anchor of the new frame (defaults to "TOPLEFT")
-- * offsetX (optional) [number] : The x-axis offset of the created frame (defaults to: 0)
-- * offsetY (optional) [number] : The y-axis offset of the created frame (defaults to: 0)
-- * enabled (optional) [boolean] : determine if the button should be enabled (true) or disabled (false) (defaults to: true)
-- * colors (optional) [table] : the color table to be used for different enabled and disabled state of the checkbox (defaults to <LIB>.Colors)
-- * enabled_color (optional) [string] : the label color of enabled checkboxes (defaults to "white")
-- * disabled_color (optional) [string] : the label color of disabled checkboxes (defaults to "grey")
-- * parent (optional) [frame] : The frame the new one should be positioned relative to
-- * p_anchor (optional) [string] : The anchor point of the parent frame (defaults to: "BOTTOMLEFT")
-- * onReset (optional) [function] : Callback function for what to happen when the current window's editables are reset to default 
function READI:DropDown(data, opts)
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
    error(READI:l10n("errors.dropdown.opts_is_nil"), 2)
    return 
  end
  --------------------------------------------------------------------------------
  -- SETTING DEFAULTS
  --------------------------------------------------------------------------------
  local set = {
    storage = {},
    name = nil,
    region = nil,
    template = "UIDropDownMenuTemplate",
    width = 200,
    anchor = "TOPLEFT",
    parent = nil,
    p_anchor = "BOTTOMLEFT",
    offsetX = 0,
    offsetY = 0,
    enabled = true,
    onReset = function() end,
  }
  READI.Helper.table:Merge(set, opts)
  --------------------------------------------------------------------------------
  -- CREATING THE FRAME
  --------------------------------------------------------------------------------
  local dd = _G[set.name] or CreateFrame("Frame", set.name, set.region, set.template) 
  dd:SetPoint(set.anchor, set.parent, set.p_anchor, set.offsetX, set.offsetY)
  
  UIDropDownMenu_SetWidth(dd, set.width)
  UIDropDownMenu_SetText(dd, set.storage[set.option])

  UIDropDownMenu_Initialize(dd, function(self, level)
    local info = UIDropDownMenu_CreateInfo()
    if (level or 1) == 1 then
      for i,v in ipairs(set.values) do
        info.text, info.arg1, info.checked = gsub(v, "_", " "), v, v == set.storage[set.option]
        info.func = function(self, arg1, arg2, checked)
          set.storage[set.option] = self.value
          UIDropDownMenu_SetText(dd, self.value)
          self.checked = true
          EventRegistry:TriggerEvent(format("%s.%s.%s", data.addon, data.keyword, "OnChange"))
        end
        UIDropDownMenu_AddButton(info)
      end
    end
  end)

  if not set.enabled then
    UIDropDownMenu_DisableDropDown(dd)
  else
    UIDropDownMenu_EnableDropDown(dd)
  end
  
  EventRegistry:RegisterCallback(format("%s.%s.%s", data.addon, data.keyword, "OnReset"), set.onReset)
  EventRegistry:RegisterCallback(format("%s.%s.%s", data.addon, data.keyword, "OnChange"), set.onChange)

  return dd
end