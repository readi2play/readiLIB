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
    onOkay = nil,
    onCancel = nil,
    buttonSet = {
      confirm = READI:l10n("general.labels.buttons.okay"),
      cancel = READI:l10n("general.labels.buttons.cancel"),
    }
  }, opts)

  local offsetY = set.width
  if set.height >= set.width / 2 then offsetY = 0 end

  local dialog = CreateFrame("Frame", set.name, UIParent, "BackdropTemplate")
  dialog.buttons = {
    confirmation = nil,
    cancellation = nil,
  }

  dialog:SetSize(set.width,set.height)
  dialog:SetFrameStrata("DIALOG")
  dialog:SetPoint("CENTER", UIParent, "CENTER", 0, offsetY)
  dialog:SetBackdrop({
    bgFile = 136449,
    edgeFile = 2447130,
    edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
  })
  dialog:SetBackdropBorderColor(0, 0.977, 0.828)

  if set.icon then
    set.icon.region = dialog
    dialog.icon = READI:Icon(data, set.icon)
    dialog.icon:SetParent(dialog)
  end

  if set.title ~= "" then
    dialog.title = dialog:CreateFontString("ARTWORK", nil, "GameFontNormal")
    dialog.title:SetText(READI.Helper.color:Get("white", nil, set.title))
    dialog.title:SetPoint("TOP", dialog, "TOP", 0,-10)
    dialog.titleDivider = CreateFrame("Frame", nil, container)
    dialog.titleDivider:SetParent(dialog)
    dialog.titleDivider:SetPoint("TOP", dialog.title, "BOTTOM", 0,-5)
    dialog.titleDivider:SetPoint("LEFT", dialog, "LEFT", 20,0)
    dialog.titleDivider:SetPoint("RIGHT", dialog, "RIGHT", -20,0)
    dialog.titleDivider:SetHeight(2)
    dialog.titleDivider.texture = dialog.titleDivider:CreateTexture()
    dialog.titleDivider.texture:SetTexture(READI.T.rdl150002)
    dialog.titleDivider.texture:SetAllPoints(dialog.titleDivider)
  end

  if set.createHidden then
    dialog:Hide()
  end

  if set.closeOnEsc then
    table.insert(UISpecialFrames, set.name)
  end

  if set.onCancel then
    dialog.buttons.cancellation = READI:Button(data, {
      name = set.name.."CancellationButton",
      region = dialog,
      label = set.buttonSet.cancel,
      onClick = function()
        set.onCancel()
        if set.onClose then set.onClose() end
        dialog:Hide()
      end,
      anchor = "BOTTOMRIGHT",
      parent = dialog,
      p_anchor = "BOTTOMRIGHT",
      offsetX = -10,
      offsetY = 10,
    })
  end

  if set.onOkay then
    local anchor_to = "BOTTOMLEFT"
    local yAxis = 0
    if not dialog.buttons.cancellation then
      anchor_to = "BOTTOMRIGHT"
      yAxis = 10
    end

    dialog.buttons.confirmation = READI:Button(data, {
      name = set.name.."ConfirmationButton",
      region = dialog,
      label = set.buttonSet.confirm,
      onClick = function()
        set.onOkay()
        if set.onClose then set.onClose() end
        dialog:Hide()
      end,
      anchor = "BOTTOMRIGHT",
      parent = dialog.buttons.cancellation or dialog,
      p_anchor = anchor_to,
      offsetX = -10,
      offsetY = yAxis,
    })
  end

  dialog:HookScript("OnKeyDown", function(evt, key, down)
    if not READI.Helper.table:Contains(key, { "ESCAPE", "ENTER" }) then return end

    if key == "ESCAPE" then
      if dialog.buttons.cancellation then
        dialog.buttons.cancellation:Click()      
      end
    elseif key == "ENTER" then
      dialog.buttons.confirmation:Click()
    end
  end)

  return dialog
end