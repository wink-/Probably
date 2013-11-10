-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("UI_ERROR_MESSAGE", function(...)
  local error = ...
  if error == SPELL_FAILED_NOT_BEHIND then
    ProbablyEngine.module.player.behind = false
    ProbablyEngine.module.player.behindTime = time()
  end
end)
