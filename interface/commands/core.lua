-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.command.register_handler({'version', 'ver', 'v'}, function()
  ProbablyEngine.command.print('You are running build ' .. ProbablyEngine.version)
end)

ProbablyEngine.command.register_handler({'cycle', 'pew', 'run'}, function()
  ProbablyEngine.cycle(true)
end)

ProbablyEngine.command.register_handler({'toggle', 'enable', 'disable'}, function()
  ProbablyEngine.buttons.toggle('MasterToggle')
end)

ProbablyEngine.command.register_handler({'cd', 'cooldown', 'cooldowns'}, function()
  ProbablyEngine.buttons.toggle('cooldowns')
end)

ProbablyEngine.command.register_handler({'kick', 'interrupts', 'interrupt', 'silence'}, function()
  ProbablyEngine.buttons.toggle('interrupt')
end)

ProbablyEngine.command.register_handler({'aoe', 'multitarget'}, function()
  ProbablyEngine.buttons.toggle('multitarget')
end)

ProbablyEngine.command.register_handler({'ct', 'combattracker', 'ut', 'unittracker', 'tracker'}, function()
  UnitTracker.toggle()
end)

ProbablyEngine.command.register_handler({'al', 'log', 'actionlog'}, function()
  PE_ActionLog:Show()
end)

ProbablyEngine.command.register_handler({'lag', 'cycletime'}, function()
  PE_CycleLag:Show()
end)

ProbablyEngine.command.register_handler({'turbo', 'godmode'}, function()
  ProbablyEngine.config.toggle('pe_turbo')
  local state = ProbablyEngine.config.data['pe_turbo']
  if state then
    ProbablyEngine.print('Turbo Mode Enabled!')
    SetCVar('maxSpellStartRecoveryOffset', 1)
    SetCVar('reducedLagTolerance', 1)
  else
    ProbablyEngine.print('Turbo Mode Disabled.')
  end
end)