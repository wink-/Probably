-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("UNIT_SPELLCAST_START", function(...)
  local unitID = ...
  if unitID == "player" then
    if ProbablyEngine.module.queue.queue == name then
      ProbablyEngine.module.queue.queue = nil
    end
    ProbablyEngine.module.player.casting = true
    ProbablyEngine.parser.lastCast = UnitCastingInfo("player")
  end
end)
