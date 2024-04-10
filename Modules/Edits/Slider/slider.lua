--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, b2h = ...
--------------------------------------------------------------------------------
-- READI:Slider
--------------------------------------------------------------------------------
-- A factory function for easily creating UI Option Sliders with Lua
--
---@param data table :
-- * addon string : A string representing the addon that uses this library function, could be the name or an abbreviation
-- * keyword string : A keyword used for custom event registration
---@param opts table :
-- * onChange function : Callback function for what to happen when the value changes
-- * name (optional) string : The name the created frame should have (defaults to: nil)
-- * region (optional) frame : The frame the new one should relate to (defaults to: nil)
-- * min (optional) number : The minimum value for the slider (defaults to 0)
-- * max (optional) number : The maximum value for the slider (defaults to 100)
-- * step (optional) number : The step-width for the slider's thumb to move (defaults to nil)
-- * value (optional) number : The initial value for the the slider (defaults to 0)
-- * width (optional) number : The element's width in pixel (defaults to 200)
-- * anchor (optional) string : The positioning anchor of the new frame (defaults to "TOPLEFT")
-- * parent (optional) frame : The frame the new one should be positioned relative to
-- * p_anchor (optional) string : The anchor point of the parent frame (defaults to: "BOTTOMLEFT")
-- * offsetX (optional) number : The x-axis offset of the created frame (defaults to: 0)
-- * offsetY (optional) number : The y-axis offset of the created frame (defaults to: 0)
-- * onReset (optional) function : Callback function for what to happen when the current window's editables are reset to default
  function READI:Slider(data, opts)
  --------------------------------------------------------------------------------
  -- ERROR HANDLING
  --------------------------------------------------------------------------------
  READI:CheckFactoryParams(data, opts, "slider", "onChange")
  --------------------------------------------------------------------------------
  -- DEFINE DEFAULTS
  --------------------------------------------------------------------------------
  local set = {
    region = nil,
    name = nil,
    min = 0,
    max = 100,
    step = nil,
    value = 0,
    width = 200,
    anchor = "TOPLEFT",
    parent = nil,
    p_anchor = "BOTTOMLEFT",
    offsetX = 0,
    offsetY = 0,
    onReset = function() end,
  }
  READI.Helper.table:Merge(set,opts)
  --------------------------------------------------------------------------------
  -- CREATING THE FRAME
  --------------------------------------------------------------------------------
  local sl = _G[set.name] or CreateFrame("Slider", set.name, set.region, "OptionsSliderTemplate")
  sl.name = set.name
  sl:SetPoint(set.anchor, set.parent, set.p_anchor, set.offsetX, set.offsetY)
  sl:SetThumbTexture(READI.T.rdl100003)
  sl:SetOrientation("HORIZONTAL")
  sl:SetWidth(set.width)
  sl:SetMinMaxValues(set.min, set.max)
  if set.step then
    sl:SetObeyStepOnDrag(true)
    sl:SetValueStep(set.step)
  end
  sl:SetValue(set.value)
  _G[sl.name.."Low"]:SetText(set.min)
  _G[sl.name.."High"]:SetText(set.max)
  _G[sl.name.."Text"]:SetText(sl:GetValue())
  _G[sl.name.."Text"]:ClearAllPoints()
  _G[sl.name.."Text"]:SetPoint("TOP", sl, "BOTTOM", 0, -10)

  sl:SetScript("OnValueChanged", set.onChange)
  EventRegistry:RegisterCallback(format("%s.%s.%s", data.prefix, data.keyword, "OnReset"), set.onReset)

  return sl
end