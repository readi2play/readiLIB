--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, rdl = ...
--[[----------------------------------------------------------------------------
READI:PagedFrame
--------------------------------------------------------------------------------
@param data table: 
@param opts table: 
----------------------------------------------------------------------------]]--
function READI:PagedFrame(data, opts)
  --[[----------------------------------------------------------------------------
  ERROR HANDLING
  ----------------------------------------------------------------------------]]--
  READI:CheckFactoryParams(data, opts, "pagedFrame", "name")
  --[[----------------------------------------------------------------------------
  DEFINE DEFAULTS
  ----------------------------------------------------------------------------]]--
  local set = READI.Helper.table:Merge({
    activePage = 1,
    width = nil,
    height = nil,
    inset = 10,
    numPages = 1,
    allowMouseWheel = true,
    alwaysShowPaging = true,
  }, opts)

  local pagedFrame = CreateFrame("Frame", set.name, set.parent, "BackdropTemplate")
  pagedFrame:SetClipsChildren(true)
  pagedFrame:SetSize(set.width, set.height)
  pagedFrame:SetPoint(RD.ANCHOR_TOPLEFT, set.parent, RD.ANCHOR_TOPLEFT, set.inset, set.inset)

  for i=1, set.numPages do
    local region = pagedFrame
    local anchorTo = RD.ANCHOR_TOPLEFT
    local width = pagedFrame:GetWidth() - set.inset * 2
    local height = pagedFrame:GetHeight() - set.inset * 2
    local offsetX = set.inset
    local offsetY = set.inset
    if i > 1 then
      region = pagedFrame.children[i-1]
      anchorTo = RD.ANCHOR_TOPRIGHT
      offsetY = 0
    end
    pagedFrame.children[i] = CreateFrame("Frame", set.name.."Page"..i, pagedFrame, "BackdropTemplate")
    pagedFrame.children[i]:SetSize(width, height)
    pagedFrame.children[i]:SetPoint(RD.ANCHOR_TOPLEFT, region, anchorTo, offsetX, offsetY)
  end
  return pagedFrame
end