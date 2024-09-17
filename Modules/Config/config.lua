--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
local AddonName, rdl = ...
local data = CopyTable(RD.data)
data.keyword = "config"

RD.Config = {}


function READI:InitConfig(dbName, db, _defaults)
  local charName = format("%s-%s", GetUnitName("player"), GetRealmName())
  -- get or create the overall SavedVariables
  db = db or { use_profiles = false }

  -- get or create the global table
  db.global = db.global or {}
  READI.Helper.table:Move(_defaults, db, db.global)
  if not next(db.global) then
    db.global = CopyTable(_defaults)
  else
    db.global = READI.Helper.table:Merge({}, CopyTable(_defaults), db.global)
  end

  -- get or create the character specific table
  db.chars = db.chars or {}
  if db.use_profiles then
    db.chars[charName] = db.chars[charName] or CopyTable(_defaults)
    
    db.chars[charName].assigned_profile = db.chars[charName].assigned_profile or charName
    local _ap = db.chars[charName].assigned_profile

    if _ap ~= "global" then
      db.chars[_ap] = READI.Helper.table:Merge({}, CopyTable(_defaults), db.chars[_ap])
    end
  end

  -- perform a cleanup to remove no longer used keys
  READI.Helper.table:CleanUp(_defaults, db, "assigned_profile")
  return db, _char
end

function RD:SetupConfig()
  local panelName = "readi-AddonFamily"

  RD.Config.panel, RD.Config.container, RD.Config.anchorline = RD:OptionPanel(data, {
    name = panelName,
    parent = nil,
    title = {
      text = panelName,
      color = "readi"
    }
  })

  if Settings and Settings.RegisterCanvasLayoutCategory then
    local category = Settings.RegisterCanvasLayoutCategory(RD.Config.panel, panelName)
    category.ID = panelName
    Settings.RegisterAddOnCategory(category)
  else
    InterfaceOptions_AddCategory(RD.Config.panel)
  end
end