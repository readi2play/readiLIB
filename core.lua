------------------------------------------------------------
-- BASICS
------------------------------------------------------------
local AddonName, rdl = ...

-- define the main frame to add all attributes and methods to
READI = CreateFrame("Frame", AddonName)
-- creating an abbreviated alias
RD = READI
RD.GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
RD.title = READI.GetAddOnMetadata(AddonName, "Title")
RD.icon = READI.GetAddOnMetadata(AddonName, "IconTexture")
RD.version = READI.GetAddOnMetadata(AddonName, "Version")
RD.author = READI.GetAddOnMetadata(AddonName, "Author")

RD.UIPanelNineTile = "Interface\\AddOns\\readiLIB\\Media\\Textures\\UIPanelNineTile"