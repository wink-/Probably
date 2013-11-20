-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.parser = {
  lastCast = '',
  items = {
    head     = "HeadSlot",
    helm     = "HeadSlot",
    neck     = "NeckSlot",
    shoulder = "ShoulderSlot",
    shirt    = "ShirtSlot",
    chest    = "ChestSlot",
    belt     = "WaistSlot",
    waist    = "WaistSlot",
    legs     = "LegsSlot",
    pants    = "LegsSlot",
    feet     = "FeetSlot",
    boots    = "FeetSlot",
    wrist    = "WristSlot",
    bracers  = "WristSlot",
    gloves   = "HandsSlot",
    hands    = "HandsSlot",
    finger1  = "Finger0Slot",
    finger2  = "Finger1Slot",
    trinket1 = "Trinket0Slot",
    trinket2 = "Trinket1Slot",
    back     = "BackSlot",
    cloak    = "BackSlot",
    mainhand = "MainHandSlot",
    offhand  = "SecondaryHandSlot",
    weapon   = "MainHandSlot",
    weapon1  = "MainHandSlot",
    weapon2  = "SecondaryHandSlot",
    ranged   = "RangedSlot"
  }
}

ProbablyEngine.turbo = {
  modifier = ProbablyEngine.config.read('turbo_modifier', 1.3)
}

ProbablyEngine.parser.can_cast =  function(spell, unit)

  local turbo = ProbablyEngine.config.data['pe_turbo']
  if turbo then
    -- Turbo Mode Engage
    local castEnds = select(6, UnitCastingInfo("player"))
    local channelEnds = select(6, UnitChannelInfo("player"))
    if castEnds or channelEnds then
      local endTime = castEnds or channelEnds
      local timeNow = GetTime()
      local canCancel = ((endTime / 1000) - timeNow) * 1000
      if canCancel < (ProbablyEngine.lag*ProbablyEngine.turbo.modifier) then
        SpellStopCasting()
      end
    end
  end

  -- Credits to iLulz (JPS) for this function
  if spell == nil then return false end
  if unit == "ground" then unit = nil end
  if unit == nil then unit = "target" end
  local spellId = GetSpellID(spell)
  local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = ProbablyEngine.gsi.call(spellId)
  local skillType, spellId = GetSpellBookItemInfo(spell)
  local isUsable, notEnoughMana = IsUsableSpell(spell)
  if not isUsable then return false end
  if notEnoughMana then return false end
  if not UnitExists(unit) then return false end
  if not UnitIsVisible(unit) then return false end
  if UnitBuff("player", GetSpellInfo(80169)) then return false end -- Eat
  if UnitBuff("player", GetSpellInfo(87959)) then return false end -- Drink
  if UnitBuff("player", GetSpellInfo(11392)) then return false end -- Invis
  if UnitBuff("player", GetSpellInfo(3680)) then return false end  -- L. Invis
  if UnitIsDeadOrGhost(unit) then return false end
  if SpellHasRange(spell) == 1 and IsSpellInRange(spell, unit) == 0 then return false end
  if select(2, GetSpellCooldown(spell)) > 1 then return false end
  if ProbablyEngine.module.player.casting == true and turbo == false then return false end
  -- handle Surging Mists manually :(
  if spellId == 116694 or spellId == 124682 then return true end
  if UnitChannelInfo("player") == nil then return true else return false end
  return true
end

ProbablyEngine.parser.can_cast_queue =  function(spell)
  local isUsable, notEnoughMana = IsUsableSpell(spell)
  if not isUsable then return false end
  if notEnoughMana then return false end
  if select(2, GetSpellCooldown(spell)) ~= 0 then return false end
  return true
end


ProbablyEngine.parser.nested = function(evaluationTable, event, target)
  local eval
  for _, evaluation in pairs(evaluationTable) do
    local evaluationType, eval = type(evaluation), true
    if evaluationType == "function" then
      eval = evaluation()
    elseif evaluationType == "table" then
      eval = ProbablyEngine.parser.nested(evaluation, event, target) -- for the lulz
    elseif evaluationType == "string" then
      if string.sub(evaluation, 1, 1) == '@' then
        eval = ProbablyEngine.library.parse(event, evaluation, target)
      else
        eval = ProbablyEngine.dsl.parse(evaluation, event)
      end
    elseif evaluationType == "nil" then
      eval = false
    elseif evaluationType == "boolean" then
      eval = evaluation
    end
    if not eval then return false end
  end
  return true
end

ProbablyEngine.parser.table = function(spellTable, fallBackTarget)

  for _, arguments in pairs(spellTable) do

    ProbablyEngine.dsl.parsedTarget = nil

    local eventType = type(arguments[1])
    local event = arguments[1]
    local evaluationType = type(arguments[2])
    local evaluation = arguments[2]
    local target = arguments[3] or fallBackTarget
    local slotId = 0
    local itemName = ''
    local itemId = 0

    if eventType == "string" then
      if string.sub(event, 1, 1) == '!' then
        eventType = "macro"
      elseif string.sub(event, 1, 1) == '#' then
        eventType = "item"
      end
    end

    -- is our eval a lib call ?
    if evaluationType == "string" then
      if string.sub(evaluation, 1, 1) == '@' then
        evaluationType = "library"
      end
    end

    -- healing?
    if target == "lowest" then
      target = ProbablyEngine.raid.lowestHP()
      if target == false then return end
    elseif target == "tank" then
      if UnitExists("focus") then
        target = "focus"
      else
        target = ProbablyEngine.raid.tank()
      end
    end

    if eventType == "string" then
      if evaluationType == "string"  then
        evaluation = ProbablyEngine.dsl.parse(evaluation, event)
      elseif evaluationType == "table" then
        evaluation = ProbablyEngine.parser.nested(evaluation, event, target)
      elseif evaluationType == "function" then
        evaluation = evaluation()
      elseif evaluationType == "library" then
        evaluation = ProbablyEngine.library.parse(event, evaluation, target)
      elseif evaluationType == "nil" then
        evaluation = true
        target = "target"
      end
    elseif eventType == "table" or eventType == "macro" or eventType == "item" then
      if evaluationType == "string"  then
        evaluation = ProbablyEngine.dsl.parse(evaluation, '')
      elseif evaluationType == "table" then
        evaluation = ProbablyEngine.parser.nested(evaluation, '', target)
      elseif evaluationType == "function" then
        evaluation = evaluation()
      elseif evaluationType == "library" then
        evaluation = ProbablyEngine.library.parse(event, evaluation, target)
      elseif evaluationType == "nil" then
        evaluation = true
      end
    end

    if target == nil then
      target = ProbablyEngine.dsl.parsedTarget or "target"
    end

    if eventType == "item" then
      local slot = string.sub(event, 2)
      if ProbablyEngine.parser.items[slot] then
        slotId = GetInventorySlotInfo(ProbablyEngine.parser.items[slot])
        if slotId then
          local itemStart, itemDuration, itemEnable = GetInventoryItemCooldown("player", slotId)
          if itemEnable == 1 and itemStart > 0 then
            evaluation = false
          elseif not GetItemSpell(GetInventoryItemID("player", slotId)) then
            evaluation = false
          end
        end
      else
        eventType = "bagItem"
        local item = slot
        if not tonumber(item) then
          item = GetItemID(item)
        end
        itemId = item
        if itemId then
          itemName = GetItemInfo(itemId)
          local itemStart, itemDuration, itemEnable = GetItemCooldown(itemId)
          if itemEnable == 1 and itemStart > 0 then
            evaluation = false
          end
        end
      end
    end

    if evaluation then
      if eventType == "table" then
        local tableNestSpell, tableNestTarget = ProbablyEngine.parser.table(event, target)
        if tableNestSpell ~= false then return tableNestSpell, tableNestTarget end
      elseif eventType == "macro" then
        RunMacroText(string.sub(event, 2))
        return false
      elseif eventType == "item" then
        UseInventoryItem(slotId)
        return false
      elseif eventType == "bagItem" then
        UseItemByName(itemName, target)
        return false
      elseif event == "pause" then
        return false
      else
        if ProbablyEngine.parser.can_cast(event, target) then
          return event, target
        end
      end
    end

  end

  return false
end
