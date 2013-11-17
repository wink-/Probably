-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- lets write to the global, how dirty...

-- since this doesn't exist, make it!
GetSpellID = function(spell)
  if type(spell) == "number" then return spell end
  local match = string.match(GetSpellLink(spell) or '', 'Hspell:(%d+)|h')
  if match then return tonumber(match) else return false end
end

-- this is also useful
GetSpellName = function(spell)
  if tonumber(spell) then
    local spellID = tonumber(spell)
    return GetSpellInfo(spellID)
  end
  return spell
end

GetItemID = function(item)
  if type(item) == "number" then return item end
  local match = string.match(select(2, GetItemInfo(item)) or '', 'Hitem:(%d+):')
  if match then return tonumber(match) else return false end
end