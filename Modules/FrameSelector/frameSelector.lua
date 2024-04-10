local AddonName, rdl = ...

local selectorWrapper, frameSelector, origMouseFocus, origMouseFocusName

function READI:StartFrameSelector(data, db_path, field)
  origMouseFocusName = db_path
  if not selectorWrapper then
    selectorWrapper = CreateFrame("Frame")
    frameSelector = CreateFrame("Frame", "RDLFrameSelector", selectorWrapper, "BackdropTemplate")
    frameSelector:SetFrameStrata("FULLSCREEN_DIALOG")
    frameSelector:SetBackdrop({
      edgeFile = 2447130,
      edgeSize = 8,
      insets = {left = 0, right = 0, top = 0, bottom = 0}
    })
    frameSelector:SetBackdropBorderColor(0, 0.977, 0.828);
    frameSelector:Hide();
    frameSelector.tooltip = CreateFrame("GameTooltip", "RDLFrameSelectorTooltip", UIPARENT, "GameTooltipTemplate")
    frameSelector:SetScript("OnEnter", function(self)
      self.tooltip:SetOwner(self, "ANCHOR_LEFT")
      self.tooltip:ClearLines()
      self.tooltip:AddLine(origMouseFocusName, 1, 1, 1, true)
      self.tooltip:Show()
    end)
    frameSelector:SetScript("OnLeave", function(self)
      self.tooltip:Hide()
    end)
  end

  if SettingsPanel:IsVisible() then SettingsPanel:Hide() end

  SetCursor("CAST_CURSOR")
  selectorWrapper:SetScript("OnUpdate", function()
    if IsMouseButtonDown("LeftButton") and origMouseFocusName then
      READI:StopFrameSelector(data, db_path, field)
    else

      local focusedFrame = GetMouseFocus()
      local focusedFrameName = nil

      if focusedFrame then
        focusedFrameName = focusedFrame:GetName()
        if (not focusedFrameName) or
          READI.Helper.string.Contains(focusedFrameName, data.addon) or
          READI.Helper.string.Contains(focusedFrameName, data.prefix) or
          READI.Helper.string.Contains(focusedFrameName, "ObjectiveTracker") or
          focusedFrameName == "WorldFrame"
        then
          focusedFrameName = nil
        end

        if focusedFrame ~= origMouseFocus and focusedFrame ~= frameSelector then
          if focusedFrameName then
            frameSelector:ClearAllPoints()
            frameSelector:SetPoint("TOPRIGHT", focusedFrame, "TOPRIGHT", 2,2)
            frameSelector:SetPoint("BOTTOMLEFT", focusedFrame, "BOTTOMLEFT", -2,-2)
            origMouseFocusName = focusedFrameName
            frameSelector:Show();
          end
          origMouseFocus = focusedFrame
        end
      end
      if not focusedFrameName then
        frameSelector:Hide()
      end
    end
  end)
end

function READI:StopFrameSelector(data, db_path, field)
  if selectorWrapper then
    selectorWrapper:SetScript("OnUpdate", nil)
    frameSelector:Hide()
  end
  if not SettingsPanel:IsVisible() then SettingsPanel:Show() end
  ResetCursor()

  field:SetText(origMouseFocusName)
  EventRegistry:TriggerEvent(format("%s.%s.%s", data.prefix, data.keyword, "OnChange"))
end

function READI:CancelFrameSelector()
  if selectorWrapper then
    selectorWrapper:SetScript("OnUpdate", nil)
    frameSelector:Hide()
  end
  if not SettingsPanel:IsVisible() then SettingsPanel:Show() end
  ResetCursor()
end