--[[----------------------------------------------------------------------------
BASICS
------------------------------------------------------------------------------]]
local AddonName, rdl = ...
--[[----------------------------------------------------------------------------
READI:OptionPanel
--------------------------------------------------------------------------------
@param data table :
@param opts table :
 * name [string] : the name to give the panel
 * parent (optional) [string] : the name of the parent panel if this one is not the main panel itself (defaults to: nil)
 * title (optional) [table] : a table defining the settings for the panel headline (defaults to: nil)
 * template [string] : the template to be used for the headline
 * text [string] :  the headline text itself
 * color [string] : the headline color
 * callback [function] : a function to be called right after creating the panel. This function gets the panel, the container and the headline as arguments to enhance positioning of additional content. (defaults to: nil)
]]--
function READI:OptionPanel(data, opts)
  --------------------------------------------------------------------------------
  -- ERROR HANDLING
  --------------------------------------------------------------------------------
  READI:CheckFactoryParams(data, opts, "panel", "name")
  --------------------------------------------------------------------------------
  -- DEFINE DEFAULT VALUES
  --------------------------------------------------------------------------------
  local set = READI.Helper.table:Merge({
    parent = nil,
    isScrollable = false,
    title = {
      text = nil,
      template = "GameFontHighlightLarge",
      color = "white"
    },
  }, opts)

  -- create the panel frame and set its name
  local panel = CreateFrame("Frame")
  panel.name = set.name

  -- if the panel is not meant to be the addon's main config panel set its parent to the AddonName
  if set.parent then panel.parent = set.parent end

  local container = CreateFrame("Frame", nil, panel)
  container.name = READI.Helper.string:Capitalize(set.name).."SettingsContainer"
  container:SetPoint("TOPLEFT", 5, -5)
  container:SetPoint("BOTTOMRIGHT", -25, 55)
  if set.panelHidden then container:Hide() end

  -- if the panel is not meant to be the main config panel for the addon set its name or title as headline
  local anchorline = nil
  if set.parent then
    local __txt = set.name
    if set.title.text then __txt = set.title.text end

    local headline = container:CreateFontString("ARTWORK", nil, set.title.template)
    headline:SetPoint("TOP", container, 0, -20)
    headline:SetText(READI.Helper.color:Get(set.title.color, data.colors, __txt))

    anchorline = CreateFrame("Frame", nil, container)
    anchorline:SetPoint("TOP", headline, "BOTTOM", 0,-10)
    anchorline:SetPoint("LEFT", container, "LEFT", 0, 0)
    anchorline:SetPoint("RIGHT", container, "RIGHT", 0, 0)
    anchorline:SetHeight(2)
    anchorline.texture = anchorline:CreateTexture()
    anchorline.texture:SetTexture(READI.T.rdl150002)
    anchorline.texture:SetAllPoints(anchorline)
  end

  return panel, container, anchorline
end

--[[----------------------------------------------------------------------------
READI:OptionsContainer
--------------------------------------------------------------------------------
@param data table :
@param opts table :
 * name [string] : the name to give the panel
 * parent (optional) [string] : the name of the parent panel if this one is not the main panel itself (defaults to: nil)
 * title (optional) [table] : a table defining the settings for the panel headline (defaults to: nil)
 * template [string] : the template to be used for the headline
 * text [string] :  the headline text itself
 * color [string] : the headline color
 * callback [function] : a function to be called right after creating the panel. This function gets the panel, the container and the headline as arguments to enhance positioning of additional content. (defaults to: nil)
]]--
function READI:OptionsContainer(data, opts)
  --------------------------------------------------------------------------------
  -- ERROR HANDLING
  --------------------------------------------------------------------------------
  READI:CheckFactoryParams(data, opts, "name")
  --------------------------------------------------------------------------------
  -- DEFINE DEFAULT VALUES
  --------------------------------------------------------------------------------
  local set = READI.Helper.table:Merge({
    parent = nil,
    width = nil,
    background = nil,
    border = nil,
    clipChildren = false,
    left = {
      offsetX = 0,
      offsetY = 0,
    },
    right = {
      offsetX = -25,
      offsetY = 55,
    },
    title = {
      text = nil,
      template = "GameFontHighlightLarge",
      color = "white",
    },
  }, opts)

  
  local container = CreateFrame("Frame", data.prefix.."ConfigContainer", panel, "BackdropTemplate")
  if set.parent then container:SetParent(set.parent) end

  container:SetClipsChildren(set.clipChildren)

  if set.background then
    local r, g, b, a = strsplit(",", set.background, 4)
    container.background = container:CreateTexture(set.name.."BACKGROUND", RD.BACKGROUND)
    container.background:SetAllPoints()
    container.background:SetColorTexture(r, g, b, tonumber(a))
  end
  if set.border then
    local r,g,b,a = strsplit(",", set.border)
    container:SetBackdrop({
      edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
      edgeSize = 8,
      insets = {left = 0, right = 0, top = 0, bottom = 0},
    })
    container:SetBackdropBorderColor(r,g,b,tonumber(a))
  end
 
  if set.width then
    container:SetWidth(set.width)
    container:SetPoint(RD.ANCHOR_TOPLEFT, set.left.offsetX, set.left.offsetY)
    container:SetPoint(RD.ANCHOR_BOTTOMLEFT, set.left.offsetX, set.right.offsetY)
  else
    container:SetPoint(RD.ANCHOR_TOPLEFT, set.left.offsetX, set.left.offsetY)
    container:SetPoint(RD.ANCHOR_BOTTOMRIGHT, set.right.offsetX, set.right.offsetY)
  end

  if set.hidden then
    container:Hide()
  end

  -- if the panel is not meant to be the main config panel for the addon set its name or title as headline
  local __txt, headline, anchorline
  if set.parent then
    if not set.title.text then return container, anchorline end

    __txt = set.title.text

    headline = container:CreateFontString("ARTWORK", nil, set.title.template)
    headline:SetPoint("TOP", container, 0, -20)
    headline:SetText(READI.Helper.color:Get(set.title.color, data.colors, __txt))

    anchorline = _G[container:GetName().."Anchorline"] or CreateFrame("Frame", container:GetName().."Anchorline", container)
    anchorline:SetPoint("TOP", headline, "BOTTOM", 0,-20)
    anchorline:SetPoint("LEFT", container, "LEFT", 0, 0)
    anchorline:SetPoint("RIGHT", container, "RIGHT", 0, 0)
    anchorline:SetHeight(2)
    anchorline.texture = anchorline:CreateTexture()
    anchorline.texture:SetTexture(READI.T.rdl150002)
    anchorline.texture:SetAllPoints(anchorline)
  end

  return container, anchorline
end