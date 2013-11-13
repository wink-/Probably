-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- lets write to the global, how dirty...

-- since this doesn't exist, make it!
GetSpellID = function(spell)
  if type(spell) == "number" then return spell end
  local _, spellId = GetSpellBookItemInfo(spell)
  if spellId then return spellId end
  return false
end

-- this is also useful
GetSpellName = function(spell)
  if tonumber(spell) then
    local spellID = tonumber(spell)
    return GetSpellInfo(spellID)
  end
  return spell
end