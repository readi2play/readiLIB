--[[----------------------------------------------------------------------------
-- BASICS
----------------------------------------------------------------------------]]--
local AddonName, rdl = ...

--[[----------------------------------------------------------------------------
-- MOUNT FILTERS
----------------------------------------------------------------------------]]--
RD.MOUNT_COLLECTED = 1
RD.MOUNT_NOT_COLLECTED = 2
RD.MOUNT_UNUSABLE = 3

RD.MOUNT_TYPE_GROUNDED = 1
RD.MOUNT_TYPE_FLYING = 2
RD.MOUNT_TYPE_AQUATIC = 3
RD.MOUNT_TYPE_DYNAMIC = 5

RD.MOUNT_TYPES = {
  RD.MOUNT_TYPE_GROUNDED,
  RD.MOUNT_TYPE_FLYING,
  RD.MOUNT_TYPE_AQUATIC,
  RD.MOUNT_TYPE_DYNAMIC,
}

--[[----------------------------------------------------------------------------
-- SOURCE FILTERS
----------------------------------------------------------------------------]]--
RD.SOURCE_DROP = 1
RD.SOURCE_QUEST = 2
RD.SOURCE_VENDOR = 3
RD.SOURCE_PROFESSION = 4
RD.SOURCE_PET_BATTLE = 5
RD.SOURCE_ACHIEVEMENT = 6
RD.SOURCE_WORLD_EVENT = 7
RD.SOURCE_PROMO = 8
RD.SOURCE_TCG = 9
RD.SOURCE_SHOP = 10
RD.SOURCE_DISCOVERY = 11