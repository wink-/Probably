-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("UNIT_SPELLCAST_SENT", function(...)
  local unitID, spell = ...
  if unitID == "player" then
    ProbablyEngine.parser.lastCast = spell
    if ProbablyEngine.module.queue.queue == spell then
      ProbablyEngine.module.queue.queue = nil
    end
  end
end)
