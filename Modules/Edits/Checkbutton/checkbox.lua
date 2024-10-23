--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, rdl = ...
--------------------------------------------------------------------------------
-- READI:CheckBox
--------------------------------------------------------------------------------
-- A factory function for easily creating UI Checkboxes with Lua
--
---@param data table:
-- * addon string : A string representing the addon that uses this library function, could be the name or an abbreviation
-- * keyword string : A keyword used for custom event registration
-- * colors table : A table representing the color scheme of the addon using the LIB
--
---@param opts table:
-- * onClick function : Callback function for what to happen when the button is clicked
-- * label string : The text that should appear on the button (defaults to: "")
-- * anchor (optional) string : The positioning anchor of the new frame (defaults to "TOPLEFT")
-- * offsetX (optional) number : The x-axis offset of the created frame (defaults to: 0)
-- * offsetY (optional) number : The y-axis offset of the created frame (defaults to: 0)
-- * width (optional) number : The width for the element (defaults to nil)
-- * name (optional) string : The name the created frame should have (defaults to: nil)
-- * region (optional) frame : The frame the new one should relate to (defaults to: nil)
-- * template (optional) string : The Template that should be used for creating the button (defaults to: "InterfaceOptionsCheckButtonTemplate")
-- * text (optional) string : An additional text to be conditionally shown below the button (defaults to: "")
-- * condition (optional) boolean : the condition for the additional text (defaults to: false)
-- * enabled (optional) boolean : determine if the button should be enabled (true) or disabled (false) (defaults to: true)
-- * colors (optional) table : the color table to be used for different enabled and disabled state of the checkbox (defaults to <LIB>.Colors)
-- * enabled_color (optional) string : the label color of enabled checkboxes (defaults to "white")
-- * disabled_color (optional) string : the label color of disabled checkboxes (defaults to "grey")
-- * parent (optional) frame : The frame the new one should be positioned relative to
-- * p_anchor (optional) string : The anchor point of the parent frame (defaults to: "BOTTOMLEFT")
-- * onReset (optional) function : Callback function for what to happen when the current window's editables are reset to default 
-- * onClear (optional) function : Callback function for what to happen when an UnselectAll event fires
-- * onSelectAll (optional) function : Callback function for what to happen when a SelectAll event fires
function READI:CheckBox(data, opts)
  --------------------------------------------------------------------------------
  -- Error Handling
  --------------------------------------------------------------------------------
  READI:CheckFactoryParams(data, opts, "checkbox", "label")
  --------------------------------------------------------------------------------
  -- default values
  --------------------------------------------------------------------------------
  local set = READI.Helper.table:Merge({
    name = nil,
    region = nil,
    template = "InterfaceOptionsCheckButtonTemplate",
    text = "",
    condition = false,
    enabled = true,
    colors = READI.Colors,
    enabled_color = "white",
    disabled_color = "grey",
    anchor = "TOPLEFT",
    parent = nil,
    p_anchor = "BOTTOMLEFT",
    offsetX = 0,
    offsetY = 0,
    onReset = function() end,
    onClear = function() end,
    onSelectAll = function() end,
  }, opts)
  --------------------------------------------------------------------------------
  -- Creating the checkbox
  --------------------------------------------------------------------------------
  local cb = _G[set.name] or CreateFrame("CheckButton", set.name, set.region, set.template)
  --------------------------------------------------------------------------------
  -- Define methods
  --------------------------------------------------------------------------------
  function cb:SetState(enabled)
    if enabled == nil then enabled = true end
    cb.Text:SetText(nil)

    if enabled then
      cb:Enable()
      cb.Text:SetText( READI.Helper.color:Get(set.enabled_color, set.colors, set.label.string or set.label) )
    else
      cb:Disable()
      cb.Text:SetText( READI.Helper.color:Get(set.disabled_color, set.colors, set.label.string or set.label) )
    end
    cb.Text:SetPoint("LEFT", cb, "RIGHT", 5, 0)

    if type(set.label) == "table" then
      cb.Text:SetSpacing(set.label.spacing)
      cb.Text:SetTextScale(set.label.scale)
    end

    if opts.width ~= nil then
      cb.Text:SetJustifyH("LEFT")
      cb.Text:SetJustifyV("TOP")
      cb.Text:SetWordWrap(true)
      cb.Text:SetWidth(opts.width)
    end

    return cb
  end
  --------------------------------------------------------------------------------
  -- Positioning and Method-Calls
  --------------------------------------------------------------------------------
  cb:SetPoint(set.anchor, set.parent, set.p_anchor, set.offsetX, set.offsetY)
  cb:SetState(opts.enabled)
  --------------------------------------------------------------------------------
  -- Event Handling
  --------------------------------------------------------------------------------
  cb:HookScript("OnClick", set.onClick)
  --------------------------------------------------------------------------------
  -- Register Custom Events
  --------------------------------------------------------------------------------
  EventRegistry:RegisterCallback(format("%s.%s.%s", data.prefix, data.keyword, "OnReset"), set.onReset)
  EventRegistry:RegisterCallback(format("%s.%s.%s", data.prefix, data.keyword, "OnClear"), set.onClear)
  EventRegistry:RegisterCallback(format("%s.%s.%s", data.prefix, data.keyword, "OnSelectAll"), set.onSelectAll)

  return cb
end