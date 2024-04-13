--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, rdl = ...
--------------------------------------------------------------------------------
-- READI:EditBox
--------------------------------------------------------------------------------
-- A factory function for easily creating UI EditBoxes with Lua
--
---@param data table :
-- * addon string : A string representing the addon that uses this library function, could be the name or an abbreviation
-- * keyword string : A keyword used for custom event registration
---@param opts table :
-- * onChange function : Callback function for what to happen when the value changes
-- * name (optional) string : The name the created frame should have (defaults to: nil)
-- * region (optional) frame : The frame the new one should relate to (defaults to: nil)
-- * type (optional) string : The type the edit box should represent, e.g. "number" or "text" 
-- * min (optional) number : The minimum value for a number input (defaults to 0)
-- * max (optional) number : The maximum value for a number input (defaults to 100)
-- * step (optional) number : The step-width for a number input when clicking on + or - buttons (defaults to nil)
-- * value (optional) number : The initial value for the the input field (defaults to "" or 0 depending on type)
-- * width (optional) number : The element's width in pixel (defaults to 200)
-- * height (optional) number : The element's height in pixel (defaults to 32)
-- * anchor (optional) string : The positioning anchor of the new frame (defaults to "TOPLEFT")
-- * parent (optional) frame : The frame the new one should be positioned relative to
-- * p_anchor (optional) string : The anchor point of the parent frame (defaults to: "BOTTOMLEFT")
-- * offsetX (optional) number : The x-axis offset of the created frame (defaults to: 0)
-- * offsetY (optional) number : The y-axis offset of the created frame (defaults to: 0)
-- * showButtons (optional) boolean : Determine if additional buttons ("OK" for text, "+" and "-" for number) should be added to the button (defaults to true)
-- * okayForNumber (optional) boolean : Determine if the "okay" Button of a text field should also be used for number fields (defaults to false) 
-- * onReset (optional) function : Callback function for what to happen when the current window's editables are reset to default
function READI:EditBox(data, opts)
  --------------------------------------------------------------------------------
  -- ERROR HANDLING
  --------------------------------------------------------------------------------
  READI:CheckFactoryParams(data, opts, "slider", "onChange")
  --------------------------------------------------------------------------------
  -- DEFINE DEFAULTS
  --------------------------------------------------------------------------------
  local set = READI.Helper.table:Merge({
    name = nil,
    region = nil,
    type = "text",
    min = nil,
    max = nil,
    step = nil,
    value = "",
    width = 200,
    height = 32,
    anchor = "TOPLEFT",
    parent = nil,
    p_anchor = "BOTTOMLEFT",
    offsetX = 0,
    offsetY = 0,
    showButtons = true,
    okayForNumber = false,
    onReset = function() end,
  },opts)
  --------------------------------------------------------------------------------
  -- CREATING THE FRAME
  --------------------------------------------------------------------------------
  local eb = _G[set.name] or CreateFrame("EditBox", set.name, set.region, "InputBoxTemplate")
  eb:SetPoint(set.anchor, set.parent, set.p_anchor, set.offsetX, set.offsetY)
  eb:SetFrameStrata("DIALOG")
  eb:SetSize(set.width, set.height)
  eb:SetAutoFocus(false)
  eb:SetFontObject("GameFontNormal")
  eb:SetTextColor(1,1,1,1)
  eb:SetJustifyH("LEFT")
  if set.type == "number" and not set.okayForNumber then
    eb:SetJustifyH("CENTER")
  end
  eb:SetJustifyV("TOP")
  eb:SetText(set.value)
  eb:SetCursorPosition(0)

  EventRegistry:RegisterCallback(format("%s.%s.%s", data.prefix, data.keyword, "OnChange"), set.onChange)
  EventRegistry:RegisterCallback(format("%s.%s.%s", data.prefix, data.keyword, "OnReset"), set.onReset)

  if not set.showButtons then return eb end
  if set.type == "text" or set.okayForNumber then
    eb.ok = CreateFrame("Button", nil, eb, "UIPanelButtonTemplate")
    eb.ok.parent = eb
    eb.ok:SetPoint("RIGHT", eb, "RIGHT", 1 , 1)
    eb.ok:SetWidth(eb.ok:GetHeight() + 10)
    eb.ok:SetText(READI:l10n("general.labels.buttons.okay"))
    eb.ok:Hide()
    eb:SetTextInsets(3, eb.ok:GetWidth() + 3 , 0, 0)

    eb:HookScript("OnEnterPressed", function (self)
      eb.ok:Click()
    end)
    eb:SetScript("OnEditFocusGained", function(self) eb.ok:Show() end)
    eb:SetScript("OnEditFocusLost", function(self) eb.ok:Hide() end)
    eb.ok:SetScript("OnClick", function()
      eb:ClearFocus()
      set.onChange()
    end)
  elseif set.type == "number" then
    eb.inc = CreateFrame("Button", nil, eb, "UIPanelButtonTemplate")
    eb.inc.parent = eb
    eb.inc:SetPoint("RIGHT", eb, "RIGHT", 1 , 1)
    eb.inc:SetWidth(eb.inc:GetHeight() + 10)
    eb.inc:SetText("+")

    eb.dec = CreateFrame("Button", nil, eb, "UIPanelButtonTemplate")
    eb.dec.parent = eb
    eb.dec:SetPoint("LEFT", eb, "LEFT", -6 , 1)
    eb.dec:SetWidth(eb.dec:GetHeight() + 10)
    eb.dec:SetText("-")
   
    eb:SetTextInsets(eb.dec:GetWidth() + 3, eb.inc:GetWidth() + 3 , 0, 0)

    eb:HookScript("OnEnterPressed", function()
      eb:ClearFocus()
      EventRegistry:TriggerEvent(format("%s.%s.%s", data.prefix, data.keyword, "OnChange"))
    end)
    eb.inc:SetScript("OnClick", function()
      local value = tonumber(eb:GetText()) + set.step
      eb:SetText(value)
      EventRegistry:TriggerEvent(format("%s.%s.%s", data.prefix, data.keyword, "OnChange"))
    end)

    eb.dec:SetScript("OnClick", function()
      local value = tonumber(eb:GetText()) - set.step
      eb:SetText(value)
      EventRegistry:TriggerEvent(format("%s.%s.%s", data.prefix, data.keyword, "OnChange"))
    end)
  end


  return eb
end