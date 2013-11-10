-- SPEC ID 263

ProbablyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return ProbablyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
  needsDispelled = function(spell)
    for unit,_ in pairs(ProbablyEngine.raid.roster) do
      if UnitDebuff(unit, spell) then
        ProbablyEngine.dsl.parsedTarget = unit
        return true
      end
    end
  end,
})

ProbablyEngine.rotation.register(264, {

  -- buffs
  { "Earthliving Weapon", "!player.enchant.mainhand" },
  { "Water Shield", "!player.buff" },

  -- tank
  { "Earth Shield", "!tank.buff" },
  { "Riptide", "!tank.buff" },

  -- healing totem
  { "Healing Stream Totem" },
  { "Mana Tide Totem", "player.mana < 40" },
  { "Healing Tide Totem", "@coreHealing.needsHealing(60, 4)", "lowest" },

  -- Dispell
  { "Purify Spirit", "@coreHealing.needsDispelled('Aqua Bomb')" },

  -- aoe
  { "Healing Rain", "modifier.shift", "ground" },

  -- Unleash Life
  { "Greater Healing Wave", {
    "lowest.health < 50",
    "player.buff(Unleash Life)",
  }, "lowest" },
  { "Unleash Elements", "lowest.health < 50" },

  { "Healing Wave", {
    "lowest.health < 91",
    "lowest.debuff(Chomp)"
  }},

  -- regular healing
  { "Healing Surge", "lowest.health < 40" },
  { "Greater Healing Wave", {
    "lowest.health < 55",
    "player.buff(Tidal Waves).count = 2"
  }},
  { "Chain Heal", "@coreHealing.needsHealing(80, 4)", "lowest" },
  { "Healing Wave", "lowest.health < 75" },
  { "Riptide", {
    "!lowest.buff",
    "lowest.health < 80"
  }},

  -- caus we dps too right ?!?
  { "Searing Totem", {
    "toggle.totems",
    "!player.totem(Fire Elemental Totem)",
    "!player.totem(Searing Totem)"
  }},
  { "Lightning Bolt", {
    "focustarget.exists",
  }, "focustarget" },

},
{
  { "Earthliving Weapon", "!player.enchant.mainhand" },
  { "Water Shield", "!player.buff" },
  { "Healing Wave", "@coreHealing.needsHealing(80, 1)" },
  { "Healing Wave", "lowest.health < 85" },
})