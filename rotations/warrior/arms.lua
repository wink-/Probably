-- SPEC ID 71
ProbablyEngine.rotation.register(71, {

  -- Buffs
  { "Berserker Rage", "!player.buff(Enrage)" },

  -- Survival
  { "Rallying Cry", {
    "player.health < 20",
  }},

  { "Shield Wall", {
    "player.health < 40"
  }},

  { "Die by the Sword", {
    "player.health < 60",
  }},

  { "Hamstring", {
    "!target.debuff(Hamstring)",
    "modifier.player"
  }},

  { "Impending Victory", "player.health < 80" },
  { "Victory Rush", "player.health < 80" },

  -- Kicks
  { "Pummel", "modifier.interrupts" },
  { "Disrupting Shout", "modifier.interrupts" },

  -- Cooldowns
  { "Bloodbath", "modifier.cooldowns" },
  { "Avatar", "modifier.cooldowns" },
  { "Recklessness", "modifier.cooldowns" },
  { "Skull Banner", "modifier.cooldowns" },
  

  -- AoE
  { "Sweeping Strikes", "modifier.multitarget" },
  { "Thunder Clap", "modifier.multitarget" },
  { "Bladestorm", "modifier.multitarget" },  
  { "Whirlwind", "modifier.multitarget" },
  { "Dragon Roar", "modifier.multitarget" },
  { "Dragon Roar", "modifier.cooldowns" },

  -- Rotation
  { "Storm Bolt" },
  { "Colossus Smash",
    "!target.debuff(Colossus Smash)"},
  { "Execute", 
    "!player.buff(Sudden Execute)",
    "!target.debuff(Colossus Smash)" }},
  { "Mortal Strike"},
  { "Overpower" },
  { "Heroic Strike", {
    "player.rage > 60",
    "target.debuff(Colossus Smash)"
  }},
  {"Slam"},
  {"Heroic Throw"},
  {"Battle Shout"}


})
