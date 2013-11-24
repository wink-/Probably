-- SPEC ID 103
ProbablyEngine.rotation.register(103, {

  -- Survival
  { "Renewal", "player.health <= 30" },
  { "Cenarion Ward", "player.health <75" },
  { "Survival Instincts", "player.health <75" },
  { "Cenarion Ward", "player.health <75" },

  -- Cat
  { "Cat Form", "!player.buff(Cat Form)" },

  --Cooldowns
  { "106737", {
    "player.spell(106737).charges > 2",
    "!modifier.last(106737)"
  }}, --Force of Nature
  { "Beserk", "modifier.cooldowns" },
  { "Nature's Vigil", "modifier.cooldowns" },
  { "Incarnation", "modifier.cooldowns" },

  --Keybinds
  { "Ursol's Vortex", "modifier.shift", "ground" },
  { "Disorienting Roar", "modifier.shift" },
  { "Mighty Bash", "modifier.shift" },
  { "Typhoon", "modifier.alt" },
  { "Mass Entanglement", "modifier.shift" },

  --Interrupts
  { "Skull Bash", { "target.casting", "modifier.interrupt" }},

  -- Stealth
  { "5215", "target.enemy" },

  -- Self Heals
  { "Healing Touch", {"player.buff(Predatory Swiftness)", "player.health < 70"} },
  { "Regrowth", {"player.buff(Predatory Swiftness)", "player.health < 90"} },

  -- AoE
  { "Swipe", "modifier.multitarget" },
  { "106830", {"modifier.multitarget", "target.debuff(Thrash).duration <= 1.5"} },

  -- Debuffs
  { "Faerie Fire", "!target.debuff(Weakened Armor)" },
  { "Faerie Swarm", { "!target.debuff(Weakened Armor)", "player.spell(106707).exists" } },

  -- Buffs
  { "Savage Roar", {
    "!player.buff(Savage Roar)",
    "player.combopoints = 0",
  "!player.combat",
  "target.enemy"
  }},
  { "Savage Roar", {
    "player.buff(Savage Roar).duration < 5",
    "player.combopoints = 5"
  }},
  { "Savage Roar", {
    "player.buff(Savage Roar).duration < 3",
    "player.combopoints >= 2"
  }},

  -- Free Thrash
  { "Thrash", "player.buff(Omen of Clarity)" },

  -- Spend Combo
  -- Tiger's Fury
  { "Tiger's Fury", "player.energy <= 35"},

  -- Rake
  { "Rake", "target.debuff(Rake).duration <= 4" },

  -- Rip
  { "Rip", {
    "!target.debuff(Rip)",
    "player.combopoints = 5"
  }},
  { "Rip", {
    "target.health > 25",
    "target.debuff(Rip).duration < 5",
    "player.combopoints = 5"
  }},

  -- Ferocious Bite
  -- Target Health is less then 25%
  { "Ferocious Bite", {
    "target.debuff(Rip)",
    "target.health < 25",
    "player.combopoints = 5"
  }},

  -- Max Combo and Rip or Savage do not need refreshed
  { "Ferocious Bite", {
    "player.combopoints = 5",
    "target.debuff(Rip).duration > 5",
    "player.buff(Savage Roar).duration > 5",
  }},

  -- Build Combo
  -- Shred
  { "Shred", {"player.buff(Clearcasting)", "player.behind"}},
  { "Shred", {"player.buff(Berserk)", "player.behind"}},
  { "Shred", {"player.combopoints < 5", "player.behind"}},
  -- Mangle
  { "Mangle", {"player.buff(Clearcasting)", "player.infront"}},
  { "Mangle", {"player.buff(Berserk)", "player.infront"}},
  { "Mangle", {"player.combopoints < 5",  "player.infront"}},
}, {

  { "Mangle", {
    "target.range < 10",
    "!player.behind",
    "player.buff(Prowl)",
    "target.exists"
  }, "target" },

  { "Ravage", {
    "target.range < 10",
    "player.behind",
    "player.buff(Prowl)",
    "target.exists"
  }, "target" },

  { "Prowl", {
    "player.buff(Cat Form)",
    "target.enemy"
  }},

  { "Cat Form", {
    "player.buff(Mark of the Wild)",
  }},

  { "!/cancelaura Cat Form", {
    "player.buff(Cat Form)",
    "!player.buff(Mark of the Wild)"
  }},

  { "Mark of the Wild", {
    "!player.buff(Mark of the Wild)",
    "!player.buff(Cat Form)"
  }},

})
