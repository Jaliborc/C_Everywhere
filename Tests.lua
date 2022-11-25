local Tests = WoWUnit and WoWUnit('C_Everywhere', 'PLAYER_LOGIN')
if not Tests then return end

local C = LibStub('C_Everywhere')
local AreEqual = WoWUnit.AreEqual

function Tests:NamespaceTranslation()
  local target = C_CVar and C_CVar.GetCVar or GetCVar
  AreEqual(target, C.CVar.GetCVar)
end

function Tests:OutputPacking()
  for slot = 1,6 do
    local first, second = (C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo)(0,slot)
    if first then
      local info = C.Container.GetContainerItemInfo(0,slot)
      if second then
        AreEqual(first, info.iconFileID)
        AreEqual(second, info.stackCount)
      else
        AreEqual(first, info)
      end
    else
      AreEqual(nil, C.Container.GetContainerItemInfo(0,slot))
    end
  end
end
