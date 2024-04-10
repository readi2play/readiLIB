--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, rdl = ...
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
  READI.Helper.table:Merge(set, opts, "icon", "texture")
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

  icon.tex:SetRotation(math.pi * 2)
  
  return icon
end