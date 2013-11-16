-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

local ignoreSpells = { 75 }

ProbablyEngine.listener.register("UNIT_SPELLCAST_SUCCEEDED", function(...)
  local turbo = ProbablyEngine.config.data['pe_turbo']
  local unitID, spell, rank, lineID, spellID = ...
  if unitID == "player" then
    local name, _, icon, _, _, _, _, _, _ = ProbablyEngine.gsi.call(spell)
    if ProbablyEngine.module.queue.queue == name then
      ProbablyEngine.module.queue.queue = nil
    end
    ProbablyEngine.actionLog.insert('Spell Cast Succeed', name, icon)
    ProbablyEngine.module.player.cast(spell)
  end
end)
