--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, rdl = ...
--[[----------------------------------------------------------------------------
READI:Dialog
--------------------------------------------------------------------------------
@param data table :
@param opts table :
  * name string : the name for the dialog frame to be created
  * title string (optional) : the title to be shown in a title bar (defaults to: ""; omitting this will result in a dialog without title bar) 
  * width number (optional) : the width for the respective dialog window (defaults to: 400)
  * height number (optional) : the height for the respective dialog window (defaults to: 80)
  * closeOnEsc boolean (optional) : whether the respective dialog should be closed on hitting esc (defaults to: false)
  * onOkay function (optional) : a function to be called when the dialog's  "Okay" button is hit (defaults to: nil; omitting this will not create any "Okay" button within the respective dialog)
  * onCancel function (optional) : a function to be called when the dialog's "Cancel" buttin is hit (defaults to: nil; omitting this will not generate any "Cancel" button within the respective dialog)
  * onClose function (optional) : a function to be called when the dialog gets closed in any way (defaults to nil)
  * texture table (optional) :
    * path string : the path string representing the texture file
    * width
    * height
    * per_row
    * rows
------------------------------------------------------------------------------]]--
function READI:Dialog(data,opts)
  --[[----------------------------------------------------------------------------
  ERROR HANDLING
  ----------------------------------------------------------------------------]]--
  READI:CheckFactoryParams(data, opts, "dialog", "name")
  --[[----------------------------------------------------------------------------
  DEFINE DEFAULTS
  ----------------------------------------------------------------------------]]--
  local set = READI.Helper.table:Merge({
    width = 400,
    height = 100,
    title = "",
    icon = nil,
    createHidden = false, 
    closeOnEsc = false,
    closeXButton = {
      hidden = false,
      tex = nil,
      width = 24,
      height = 24,
      offsetX = 0,
      offsetY = 0,
      OnClick = function() return true end
    },
    onOkay = nil,
    onCancel = nil,
    buttonSet = {
      confirm = READI:l10n("general.labels.buttons.okay"),
      cancel = READI:l10n("general.labels.buttons.cancel"),
    },
    texture = nil
  }, opts)
  --[[----------------------------------------------------------------------------
  HELPER FUNCTIONS
  ----------------------------------------------------------------------------]]--
  local function GetTexureSlice(tex, slice, row, col)
    return
      ((col - 1) * slice.width) / tex.width,
      (col * slice.width) / tex.width,
      ((row - 1) * slice.height) / tex.height,
      (row * slice.height) / tex.height
  end
  
  local function GetTextureWrapping(row, col)
    if row ~= 2 and col ~= 2 then
      return "CLAMP", "CLAMP"
    elseif row == 2 and col ~=2 then
      return "CLAMP", "REPEAT"
    elseif row ~= 2 and col == 2 then
      return "REPEAT", "CLAMP"
    else
      return "REPEAT", "REPEAT"
    end
  end

  local function GetSliceSize(frame, slice, row, col)
    if row ~= 2 and col ~= 2 then
      return slice.width, slice.height
    elseif row == 2 and col ~=2 then
      return slice.width, frame:GetHeight() - (2 * slice.height)
    elseif row ~= 2 and col == 2 then
      return frame:GetWidth() - (2 * slice.width), slice.height
    else
      return frame:GetWidth() - (2 * slice.width), frame:GetHeight() - (2 * slice.height)
    end
  end
  --[[----------------------------------------------------------------------------
  FRAME CREATION
  ----------------------------------------------------------------------------]]--
  local template = nil
  local offsetY = set.width
  if set.height >= set.width / 2 then offsetY = 0 end

  if not set.texture then template = "BackdropTemplate" end

  local dialog = CreateFrame("Frame", set.name, UIParent, template)
  dialog.buttons = {}
  dialog:SetSize(set.width,set.height)
  dialog:SetFrameStrata(RD.DIALOG)
  dialog:SetPoint(RD.ANCHOR_CENTER, UIParent, RD.ANCHOR_CENTER, 0, offsetY)
  dialog:EnableMouse(true)

  if not set.texture then
    dialog:SetBackdrop({
      bgFile = 136449,
      edgeFile = 2447130,
      edgeSize = 12,
      insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    dialog:SetBackdropBorderColor(0, 0.977, 0.828)
  else
    local slice = {
      width = set.texture.width / set.texture.per_row,
      height = set.texture.height / set.texture.rows,
    }
    local idx = 1
    for i=1, set.texture.per_row do
      for x=1, set.texture.rows do
        local row = i
        local col = x

        dialog[READI.Anchors[idx]] = dialog:CreateTexture(nil, READI.BORDER)
        dialog[READI.Anchors[idx]]:SetTexture(set.texture.path, GetTextureWrapping(row, col))
        dialog[READI.Anchors[idx]]:SetPoint(READI.Anchors[idx], dialog, READI.Anchors[idx])
        dialog[READI.Anchors[idx]]:SetSize(GetSliceSize(dialog, slice, row, col))
        dialog[READI.Anchors[idx]]:SetTexCoord(GetTexureSlice(set.texture, slice, row, col))

        idx = idx + 1
      end
    end
  end

  if not set.closeXButton.hidden then
    dialog.closeX = CreateFrame("Button", set.name.."CloseXButton", dialog, "UIPanelCloseButton")
    dialog.closeX:SetFrameStrata(READI.DIALOG)
    if set.closeXButton.tex then
      dialog.closeX:SetHighlightTexture(set.closeXButton.tex.highlight or READI.T.rdl130002)
      dialog.closeX:SetPushedTexture(set.closeXButton.tex.pushed or READI.T.rdl130003)
      dialog.closeX:SetNormalTexture(set.closeXButton.tex.normal or READI.T.rdl130001)
    end
    dialog.closeX:SetPoint(READI.ANCHOR_TOPRIGHT, dialog, READI.ANCHOR_TOPRIGHT, set.closeXButton.offsetX, set.closeXButton.offsetY)
    dialog.closeX:SetSize(set.closeXButton.width,set.closeXButton.height)
    dialog.closeX:SetScript("OnClick", function()
      dialog:Hide()
      EventRegistry:TriggerEvent(format("%s_%s_CLOSED", data.prefix, string.upper(data.keyword)))
      set.closeXButton.OnClick()
    end)  
  end

  if set.icon then
    set.icon.region = dialog
    set.icon.name = set.icon.name or set.name.."_ICON"
    dialog.icon = READI:Icon(data, set.icon)
    dialog.icon:SetPoint(READI.ANCHOR_TOPLEFT, set.icon.region, READI.ANCHOR_TOPLEFT, -10, 10)
  end

  if set.title then
    if type(set.title) == "table" then
      dialog.title = dialog:CreateFontString(RD.ARTWORK, nil, "GameFontNormal")
      dialog.title:SetText(READI.Helper.color:Get("white", nil, set.title.text))
      dialog.title:SetPoint(set.title.anchor or RD.ANCHOR_TOP, dialog, set.title.parent_anchor or RD.ANCHOR_TOP, set.title.offsetX or 0,set.title.offsetY or 0)
    else
      dialog.title = dialog:CreateFontString(RD.ARTWORK, nil, "GameFontNormal")
      dialog.title:SetText(READI.Helper.color:Get("white", nil, set.title))
      dialog.title:SetPoint(RD.ANCHOR_TOP, dialog, RD.ANCHOR_TOP, 0,-10)
      dialog.titleDivider = CreateFrame("Frame", nil, container)
      dialog.titleDivider:SetParent(dialog)
      dialog.titleDivider:SetPoint(RD.ANCHOR_TOP, dialog.title, "BOTTOM", 0,-5)
      dialog.titleDivider:SetPoint(RD.ANCHOR_LEFT, dialog, RD.ANCHOR_LEFT, 20,0)
      dialog.titleDivider:SetPoint(RD.ANCHOR_RIGHT, dialog, RD.ANCHOR_RIGHT, -20,0)
      dialog.titleDivider:SetHeight(2)
      dialog.titleDivider.texture = dialog.titleDivider:CreateTexture()
      dialog.titleDivider.texture:SetTexture(READI.T.rdl150002)
      dialog.titleDivider.texture:SetAllPoints(dialog.titleDivider)
    end
  end

  if set.createHidden then dialog:Hide() end

  if set.closeOnEsc then table.insert(UISpecialFrames, set.name) end

  if set.buttonSet then
    for i, val in ipairs(set.buttonSet) do
      local btnSet = READI.Helper.table:Merge({
        anchor = RD.ANCHOR_BOTTOMRIGHT,
        parent = {
          region = dialog.buttons[i-1] or dialog,
          anchor = RD.ANCHOR_BOTTOMRIGHT
        },
        offsetX = -10,
        offsetY = 0,
      }, val)
  
        dialog.buttons[i] = dialog.buttons[i] or RD:Button(data, {
        name = set.name .. RD.Helper.string:Capitalize(btnSet.key).."Button",
        parent = btnSet.parent.region,
        region = btnSet.parent.region,
        label = btnSet.label or btnSet.key,
        onClick = function()
          if btnSet.onClick then btnSet.onClick() end
          dialog:Hide()
          if set.onClose then set.onClose() end
        end,
        anchor = btnSet.anchor,
        p_anchor = btnSet.parent.anchor,
        offsetX = btnSet.offsetX,
        offsetY = btnSet.offsetY,
      })
    end
  end

  if not set.allowKeyboard then return dialog end
  dialog:HookScript("OnKeyDown", function(evt, key, down)
    if not READI.Helper.table:Contains(key, { "ESCAPE", "ENTER" }) then return end

    if key == "ESCAPE" then
      if _G[set.name .. "CancelButton"] then
        _G[set.name .. "CancelButton"]:Click()
      end
    elseif key == "ENTER" then
      if _G[set.name .. "ConfirmButton"] then
        _G[set.name .. "ConfirmButton"]:Click()
      end
    end
  end)

  return dialog
end