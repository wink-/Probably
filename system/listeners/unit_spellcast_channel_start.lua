-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("UNIT_SPELLCAST_CHANNEL_START", function(...)
  local unitID = ...
  if unitID == "player" then
    ProbablyEngine.module.player.casting = true
    ProbablyEngine.parser.lastCast = UnitCastingInfo("player")
  end
end)
