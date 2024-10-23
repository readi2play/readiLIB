--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, b2h = ...
--------------------------------------------------------------------------------
--- READI.RadioButton
--------------------------------------------------------------------------------
--- A factory function for easy creation of radio buttons
---@param data table:
-- * addon string : A string representing the addon that uses this library function, could be the name or an abbreviation
-- * keyword string : A keyword used for custom event registration
-- * colors table : A table representing the color scheme of the addon using the LIB
--
---@param opts table:
-- * onClick function : Callback function for what to happen when the button is clicked
-- * option string : the option the radio button belongs to
-- * value string | number | boolean : the value for the created radio button to represent
-- * label string : The text that should appear on the button
-- * anchor (optional) string : The positioning anchor of the new frame (defaults to "TOPLEFT")
-- * offsetX (optional) number : The x-axis offset of the created frame (defaults to: 0)
-- * offsetY (optional) number : The y-axis offset of the created frame (defaults to: 0)
-- * name (optional) string : The name the created frame should have (defaults to: nil)
-- * region (optional) frame : The frame the new one should relate to (defaults to: nil)
-- * template (optional) string : The Template that should be used for creating the button (defaults to: "UIRadioButtonTemplate")
-- * text (optional) string : An additional text to be conditionally shown below the button (defaults to: "")
-- * condition (optional) boolean : the condition for the additional text (defaults to: false)
-- * enabled (optional) boolean : determine if the button should be enabled (true) or disabled (false) (defaults to: true)
-- * enabled_color (optional) string : the label color of enabled checkboxes (defaults to "white")
-- * disabled_color (optional) string : the label color of disabled checkboxes (defaults to "grey")
-- * parent (optional) frame : The frame the new one should be positioned relative to
-- * p_anchor (optional) string : The anchor point of the parent frame (defaults to: "BOTTOMLEFT")
-- * onReset (optional) function : Callback function for what to happen when the current window's editables are reset to default 
function READI:RadioButton(data, opts)
    --------------------------------------------------------------------------------
  -- ERROR HANDLING
  --------------------------------------------------------------------------------
  READI:CheckFactoryParams(data, opts, "radiobutton", "option", "value", "onClick")
  --------------------------------------------------------------------------------
  -- SETTING DEFAULTS
  --------------------------------------------------------------------------------
  local set = READI.Helper.table:Merge({
    name = nil,
    region = nil,
    template = "UIRadioButtonTemplate",
    width = 32,
    height = 32,
    textures = {
      normal = nil,
      highlight = nil,
      active = nil,
    },
    model = nil,
    text = "",
    tooltip = nil,
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
  }, opts)
  --------------------------------------------------------------------------------
  -- CREATING THE FRAME
  --------------------------------------------------------------------------------
  local rb = _G[set.name] or CreateFrame("CheckButton", set.name, set.region, set.template)
  local subName = format("%s_RadioButton_%s_%s_%s", data.prefix, set.option, set.value, "%s")

  if set.textures.normal then
    -- remove the defaults textures
    local normalTex = rb:GetNormalTexture()
    normalTex:ClearAllPoints()

    local highlightTex = rb:GetHighlightTexture()
    highlightTex:ClearAllPoints()

    local checkedTex = rb:GetCheckedTexture()
    checkedTex:ClearAllPoints()

    rb.tex = rb:CreateTexture(format(subName, "Background"), RD.ARTWORK)
    rb.tex:SetAllPoints(rb)
    rb.tex:SetTexture(set.textures.normal)
  end
  if set.name then subName = format("%s_%s", set.name, "%s") end
  
  rb.option = set.option
  rb.value = set.value
  rb.tooltip = CreateFrame("GameTooltip", format(subName, "Tooltip"), UIParent, "GameTooltipTemplate")

  rb:SetPoint(set.anchor, set.parent, set.p_anchor, set.offsetX, set.offsetY)
  rb:SetSize(set.width,set.height)

  if set.condition and not rb:GetChecked() then
    rb:SetChecked(true)
    rb.tex:SetTexture(set.textures.active)
  end

  local function OnEnter(self)
    if not self.tooltip then return end
    self.tooltip:SetOwner(self, "ANCHOR_LEFT")
    self.tooltip:ClearLines()
    self.tooltip:AddLine(self.tt_txt or set.tooltip or self.value, 1, 1, 1, true)
    self.tooltip:Show()

    if (not self:GetChecked()) and self.tex and set.textures and set.textures ~= {} then
      self.tex:SetTexture(set.textures.highlight)
    end
  end

  local function OnLeave(self)
    if not self.tooltip then return end

    self.tooltip:Hide()
    if (not self:GetChecked()) and self.tex and set.textures and set.textures ~= {} then
      self.tex:SetTexture(set.textures.normal)
    end
  end

  rb:SetScript("OnEnter", OnEnter)
  rb:SetScript("OnLeave", OnLeave)
  rb:HookScript("OnClick", set.onClick)

  EventRegistry:RegisterCallback(format("%s.%s.%s", data.prefix, data.keyword, "OnReset"), set.onReset)

  return rb
end
