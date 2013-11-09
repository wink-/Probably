-- SPEC ID 261
ProbablyEngine.rotation.register(261, {
  -- Buffs
  { "Deadly Poison", "!player.buff(Deadly Poison)" },
  { "Leeching Poison", "!player.buff(Leeching Poison)" },
  -- Cooldowns
  { "Shadow Blades", "modifier.cooldowns" },
  { "Slice and Dice", {
    "!player.buff(Slice and Dice)",
    "player.combopoints = 5"
  }},
  { "Vanish", {
    "!player.buff(Shadow Dance)",
    "modifier.cooldowns"
  }},
  -- Rotation
  { "Eviscerate", "player.combopoints = 5" },
  { "Hemorrhage", "target.debuff(Hemorrhage).duration <= 4" },
  {{
    { "Fan of Knives", "modifier.multitarget" },
    { "Backstab", "player.behind" },
    { "Hemorrhage", "!player.behind" },
  }, "player.combopoints < 5" },

}, {
  { "Ambush", {
    "player.buff(Vanish)"
  }, "target" },
})