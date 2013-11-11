-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

local ProbablyEngineTempTable1 = { }
local rangeCheck = LibStub("LibRangeCheck-2.0")
local LibDispellable = LibStub("LibDispellable-1.0")

GetSpellID = function(spell)
  if type(spell) == "number" then return spell end
  local match = string.match(GetSpellLink(spell) or '', 'Hspell:(%d+)|h')
  if match then return tonumber(match) else return false end
end

GetSpellName = function(spell)
  if tonumber(spell) then
    local spellID = tonumber(spell)
    return GetSpellInfo(spellID)
  end
  return spell
end

PE_WalkBuffs = function(target, spell)
  local buff, count, caster, expires, spellID
  if tonumber(spell) then 
    local i = 0; local go = true
    while i <= 40 and go do
      i = i + 1
      buff,_,_,count,_,_,expires,caster,_,_,spellID = UnitBuff(target, i)
      if spellID == tonumber(spell) then go = false end
    end
  else
    buff,_,_,count,_,_,expires,caster = UnitBuff(target, spell)
  end
  return buff, count, expires, caster
end

PE_WalkDebuffs = function(target, spell)
  local debuff, count, caster, expires, spellID
  if tonumber(spell) then 
    local i = 0; local go = true
    while i <= 40 and go do
      i = i + 1
      debuff,_,_,count,_,_,expires,caster,_,_,spellID = UnitDebuff(target, i)
      if spellID == tonumber(spell) then go = false end
    end
  else
    debuff,_,_,count,_,_,expires,caster = UnitDebuff(target, spell)
  end
  return debuff, count, expires, caster
end

ProbablyEngine.condition.register("dispellable", function(target, spell)
  if LibDispellable:CanDispelWith(target, GetSpellID(GetSpellName(spell))) then
    return true
  end
  return false
end)

ProbablyEngine.condition.register("buff", function(target, spell)
  local buff,_,_,caster = PE_WalkBuffs(target, spell)
  if not not buff and (caster == 'player' or caster == 'pet') then
    return true
  end
  return false
end)

ProbablyEngine.condition.register("buff.count", function(target, spell)
  local buff,count,_,caster = PE_WalkBuffs(target, spell)
  if not not buff and (caster == 'player' or caster == 'pet') then
    return count
  end
  return 0
end)

ProbablyEngine.condition.register("debuff", function(target, spell)
  local debuff,_,_,caster = PE_WalkDebuffs(target, spell)
  if not not debuff and (caster == 'player' or caster == 'pet') then
    return true
  end
  return false
end)

ProbablyEngine.condition.register("debuff.count", function(target, spell)
  local debuff,count,_,caster = PE_WalkDebuffs(target, spell)
  if not not debuff and (caster == 'player' or caster == 'pet') then
    return count
  end
  return 0
end)

ProbablyEngine.condition.register("debuff.duration", function(target, spell)
  local debuff,_,expires,caster = PE_WalkDebuffs(target, spell)
  if not not debuff and (caster == 'player' or caster == 'pet') then
    return (expires - (GetTime()-(ProbablyEngine.lag/1000)))
  end
  return 0
end)

ProbablyEngine.condition.register("buff.duration", function(target, spell)
  local buff,_,expires,caster = PE_WalkBuffs(target, spell)
  if not not buff and (caster == 'player' or caster == 'pet') then
    return (expires - (GetTime()-(ProbablyEngine.lag/1000)))
  end
  return 0
end)

ProbablyEngine.condition.register("stance", function(target, spell)
  return GetShapeshiftForm()
end)

ProbablyEngine.condition.register("form", function(target, spell)
  return GetShapeshiftForm()
end)

ProbablyEngine.condition.register("seal", function(target, spell)
  return GetShapeshiftForm()
end)

ProbablyEngine.condition.register("focus", function(target, spell)
  return UnitPower(target, SPELL_POWER_FOCUS)
end)

ProbablyEngine.condition.register("holypower", function(target, spell)
  return UnitPower(target, SPELL_POWER_HOLY_POWER)
end)

ProbablyEngine.condition.register("shadoworbs", function(target, spell)
  return UnitPower(target, SPELL_POWER_SHADOW_ORBS)
end)

ProbablyEngine.condition.register("energy", function(target, spell)
  return UnitPower(target, SPELL_POWER_ENERGY)
end)

ProbablyEngine.condition.register("timetomax", function(target, spell)
  local max = UnitPowerMax(target)
  local curr = UnitPower(target)
  local regen = select(2, GetPowerRegen(target))
  return (max - curr) * (1.0 / regen)
end)

ProbablyEngine.condition.register("rage", function(target, spell)
  return UnitPower(target, SPELL_POWER_RAGE)
end)

ProbablyEngine.condition.register("chi", function(target, spell)
  return UnitPower(target, SPELL_POWER_CHI)
end)

ProbablyEngine.condition.register("demonicfury", function(target, spell)
  return UnitPower(target, SPELL_POWER_DEMONIC_FURY)
end)

ProbablyEngine.condition.register("embers", function(target, spell)
  return UnitPower(target, SPELL_POWER_BURNING_EMBERS, true)
end)

ProbablyEngine.condition.register("behind", function(target, spell)
  return ProbablyEngine.module.player.behind
end)

ProbablyEngine.condition.register("combopoints", function()
  return GetComboPoints('player', 'target')
end)

ProbablyEngine.condition.register("alive", function(target, spell)
  if UnitExists(target) and UnitHealth(target) > 0 then
    return true
  end
  return false
end)

ProbablyEngine.condition.register("exists", function(target)
  return not not UnitExists(target)
end)

ProbablyEngine.condition.register("modifier.shift", function()
  return IsShiftKeyDown() == 1
end)

ProbablyEngine.condition.register("modifier.control", function()
  return IsControlKeyDown() == 1
end)

ProbablyEngine.condition.register("modifier.alt", function()
  return IsAltKeyDown() == 1
end)

ProbablyEngine.condition.register("modifier.lshift", function()
  return IsLeftShiftKeyDown() == 1
end)

ProbablyEngine.condition.register("modifier.lcontrol", function()
  return IsLeftControlKeyDown() == 1
end)

ProbablyEngine.condition.register("modifier.lalt", function()
  return IsLeftAltKeyDown() == 1
end)

ProbablyEngine.condition.register("modifier.rshift", function()
  return IsRightShiftKeyDown() == 1
end)

ProbablyEngine.condition.register("modifier.rcontrol", function()
  return IsRightControlKeyDown() == 1
end)

ProbablyEngine.condition.register("modifier.ralt", function()
  return IsRightAltKeyDown() == 1
end)

ProbablyEngine.condition.register("modifier.player", function()
  return UnitIsPlayer("target") == 1
end)

ProbablyEngine.condition.register("modifier.boss", function()
  return UnitClassification("target") == "worldboss"
end)

ProbablyEngine.condition.register("toggle", function(toggle, spell)
  return ProbablyEngine.condition["modifier.toggle"](toggle)
end)

ProbablyEngine.condition.register("modifier.toggle", function(toggle)
  return ProbablyEngine.toggle.states[toggle] or false;
end)

ProbablyEngine.condition.register("modifier.taunt", function()
  if ProbablyEngine.condition["modifier.toggle"]('taunt') then
    if UnitThreatSituation("player", "target") then
      local status = UnitThreatSituation("player", target)
      return (status < 3)
    end
    return false
  end
  return false
end)

ProbablyEngine.condition.register("threat", function(target, spell)
  if UnitThreatSituation("player", target) then
    local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("player", target)
    return scaledPercent
  end
  return 0
end)


ProbablyEngine.condition.register("balance.sun", function(target, spell)
  local direction = GetEclipseDirection()
  if direction == 'none' or direction == 'sun' then return true end
end)

ProbablyEngine.condition.register("balance.moon", function(target, spell)
  local direction = GetEclipseDirection()
  if direction == 'moon' then return true end
end)

ProbablyEngine.condition.register("moving", function(target, spell)
  return GetUnitSpeed(target) ~= 0
end)

-- DK Power

ProbablyEngine.condition.register("runicpower", function(target, spell)
  return UnitPower(target, SPELL_POWER_RUNIC_POWER)
end)

ProbablyEngine.condition.register("runes.count", function(target, rune)
  rune = string.lower(rune)
  if rune == 'frost' then
    local r1 = select(3, GetRuneCooldown(5))
    local r2 = select(3, GetRuneCooldown(6))
    local f1 = GetRuneType(5)
    local f2 = GetRuneType(6)
    if (r1 and f1 == 3) and (r2 and f2 == 3) then
      return 2
    elseif (r1 and f1 == 3) or (r2 and f2 == 3) then
      return 1
    else
      return 0
    end
  elseif rune == 'blood' then
    local r1 = select(3, GetRuneCooldown(1))
    local r2 = select(3, GetRuneCooldown(2))
    local b1 = GetRuneType(1)
    local b2 = GetRuneType(2)
    if (r1 and b1 == 1) and (r2 and b2 == 1) then
      return 2
    elseif (r1 and b1 == 1) or (r2 and b2 == 1) then
      return 1
    else
      return 0
    end
  elseif rune == 'unholy' then
    local r1 = select(3, GetRuneCooldown(3))
    local r2 = select(3, GetRuneCooldown(4))
    local u1 = GetRuneType(3)
    local u2 = GetRuneType(4)
    if (r1 and u1 == 2) and (r2 and u2 == 2) then
      return 2
    elseif (r1 and u1 == 2) or (r2 and u2 == 2) then
      return 1
    else
      return 0
    end
  elseif rune == 'death' then
    local r1 = select(3, GetRuneCooldown(1))
    local r2 = select(3, GetRuneCooldown(2))
    local r3 = select(3, GetRuneCooldown(3))
    local r4 = select(3, GetRuneCooldown(4))
    local d1 = GetRuneType(1)
    local d2 = GetRuneType(2)
    local d3 = GetRuneType(3)
    local d4 = GetRuneType(4)
    local total = 0
    if (r1 and d1 == 4) then
      total = total + 1
    end
    if (r2 and d2 == 4) then
      total = total + 1
    end
    if (r3 and d3 == 4) then
      total = total + 1
    end
    if (r4 and d4 == 4) then
      total = total + 1
    end
    return total
  end
  return 0
end)

ProbablyEngine.condition.register("runes.depleted", function(target, spell)
    local regeneration_threshold = 1
    for i=1,6,2 do
        local start, duration, runeReady = GetRuneCooldown(i)
        local start2, duration2, runeReady2 = GetRuneCooldown(i+1)
        if not runeReady and not runeReady2 and duration > 0 and duration2 > 0 and start > 0 and start2 > 0 then
            if (start-GetTime()+duration)>=regeneration_threshold and (start2-GetTime()+duration2)>=regeneration_threshold then
                return true
            end
        end
    end

    return false
end)

ProbablyEngine.condition.register("runes", function(target, rune)
  return ProbablyEngine.condition["runes.count"](target, rune)
end)

ProbablyEngine.condition.register("health", function(target, spell)
  if UnitExists(target) then
    return math.floor((UnitHealth(target) / UnitHealthMax(target)) * 100)
  end
  return 0
end)

ProbablyEngine.condition.register("mana", function(target, spell)
  if UnitExists(target) then
    return math.floor((UnitMana(target) / UnitManaMax(target)) * 100)
  end
  return 0
end)

ProbablyEngine.condition.register("modifier.multitarget", function()
  return ProbablyEngine.condition["modifier.toggle"]('multitarget')
end)

ProbablyEngine.condition.register("modifier.cooldowns", function()
  return ProbablyEngine.condition["modifier.toggle"]('cooldowns')
end)

ProbablyEngine.condition.register("modifier.cooldown", function()
  return ProbablyEngine.condition["modifier.toggle"]('cooldowns')
end)

ProbablyEngine.condition.register("modifier.interrupts", function()
  if ProbablyEngine.condition["modifier.toggle"]('interrupt') then
    local stop = ProbablyEngine.condition["casting"]('target')
    if stop then SpellStopCasting() end
    return stop
  end
  return false
end)

ProbablyEngine.condition.register("modifier.interrupt", function()
  if ProbablyEngine.condition["modifier.toggle"]('interrupt') then
    return ProbablyEngine.condition["casting"]('target')
  end
  return false
end)


ProbablyEngine.condition.register("modifier.last", function(target, spell)
  return ProbablyEngine.parser.lastCast == GetSpellName(spell)
end)

ProbablyEngine.condition.register("modifier.enemies", function()
  return ProbablyEngine.module.world.count
end)

ProbablyEngine.condition.register("enchant.mainhand", function()
  return (select(1, GetWeaponEnchantInfo()) == 1)
end)

ProbablyEngine.condition.register("enchant.offhand", function()
  return (select(4, GetWeaponEnchantInfo()) == 1)
end)

ProbablyEngine.condition.register("totem", function(target, totem)
  for index = 1, 4 do
    local _, totemName, startTime, duration = GetTotemInfo(index)
    if totemName == totem then
      return true
    end
  end
  return false
end)

ProbablyEngine.condition.register("totem.duration", function(target, totem)
  for index = 1, 4 do
    local _, totemName, startTime, duration = GetTotemInfo(index)
    if totemName == totem then
      return floor(startTime + duration - GetTime())
    end
  end
  return 0
end)

ProbablyEngine.condition.register("casting", function(target, spell)
  local castName,_,_,_,_,endTime,_,_,notInterruptibleCast = UnitCastingInfo(target)
  local channelName,_,_,_,_,endTime,_,notInterruptibleChannel = UnitChannelInfo(target)
  spell = GetSpellName(spell)
  if (castName == spell or channelName == spell) and not not spell then
    return true
  elseif notInterruptibleCast == false or notInterruptibleChannel == false then
    return true
  end
  return false
end)

ProbablyEngine.condition.register("spell.cooldown", function(target, spell)
  local start, duration, enabled = GetSpellCooldown(spell)
  if not start then return false end
  if start ~= 0 then
    return (start + duration - GetTime())
  end
  return 0
end)

ProbablyEngine.condition.register("spell.usable", function(target, spell)
  return not not IsUsableSpell(spell)
end)

ProbablyEngine.condition.register("spell.exists", function(target, spell)
  return not not IsPlayerSpell(GetSpellID(spell))
end)

ProbablyEngine.condition.register("spell.casted", function(target, spell)
  return ProbablyEngine.module.player.casted(GetSpellName(spell))
end)

ProbablyEngine.condition.register("spell.charges", function(target, spell)
  return select(1, GetSpellCharges(spell))
end)

ProbablyEngine.condition.register("spell.cd", function(target, spell)
  return ProbablyEngine.condition["spell.cooldown"](target, spell)
end)

ProbablyEngine.condition.register("spell.range", function(target, spell)
  return IsSpellInRange(GetSpellName(spell), target) == 1
end)

ProbablyEngine.condition.register("range", function(target, range)
  local minRange, maxRange = rangeCheck:GetRange(target)
  return maxRange
end)

ProbablyEngine.condition.register("level", function(target, range)
  return UnitLevel(target)
end)

ProbablyEngine.condition.register("combat", function(target, range)
  return UnitAffectingCombat(target)
end)
