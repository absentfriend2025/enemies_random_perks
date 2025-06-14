dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk_list.lua")

function GivePerkToEnemy(perk_data, entity_who_picked, entity_item, num_pickups)
  local x, y = EntityGetTransform(entity_who_picked)

  local perk_id = perk_data.id

  if perk_data.game_effect ~= nil then
    local game_effect_comp = GetGameEffectLoadTo(entity_who_picked, perk_data.game_effect, true)
    if game_effect_comp ~= nil then
      ComponentSetValue(game_effect_comp, "frames", "-1")
    end
  end

  if perk_data.func_enemy ~= nil then
    perk_data.func_enemy(entity_item, entity_who_picked, nil, num_pickups)
  elseif perk_data.func ~= nil then
    perk_data.func(entity_item, entity_who_picked, nil, num_pickups)
  end

  -- Looked at pudy248's code for this one, thank you pudy!! :entity_hamis:
  if perk_data.particle_effect ~= nil then
    local particle_id = EntityLoad("data/entities/particles/perks/" .. perk_data.particle_effect .. ".xml")
    EntityAddTag(particle_id, "perk_entity")
    EntityAddChild(entity_who_picked, particle_id)
  end

  local entity_icon = EntityLoad("data/entities/misc/perks/enemy_icon.xml", x, y)
  local sc = EntityGetFirstComponentIncludingDisabled(entity_icon, "SpriteComponent")
  if sc then
    ComponentSetValue2(sc, "image_file", perk_data.ui_icon)
    ComponentSetValue2(sc, "z_index", -10)
  end
  EntityAddChild(entity_who_picked, entity_icon)
end

function GiveRandomPerkToEnemy(entity_id)
  local x, y = EntityGetTransform(entity_id)
  SetRandomSeed(x + GameGetFrameNum(), y - GameGetRealWorldTimeSinceStarted() + 100)

  local worm = EntityGetComponent(entity_id, "WormAIComponent")
  local dragon = EntityGetComponent(entity_id, "BossDragonComponent")
  local ghost = EntityGetComponent(entity_id, "GhostComponent")
  local lukki = EntityGetComponent(entity_id, "LimbBossComponent")
  if worm == nil and dragon == nil and ghost == nil and lukki == nil then
    local valid_perks = {}

    local no_glass_cannon = ModSettingGet("enemies_random_perks.no_glass_cannon")
    local no_ghost_perks = ModSettingGet("enemies_random_perks.no_ghost_perks")

    for i, perk_data in ipairs(perk_list) do
      if perk_data.usable_by_enemies ~= nil and perk_data.usable_by_enemies == true then

        if no_glass_cannon and perk_data.id == "GLASS_CANNON" then
          -- Glass Cannon disabled
        elseif no_ghost_perks and (perk_data.id == "HUNGRY_GHOST" or perk_data.id == "ANGRY_GHOST") then
          -- Ghost-type perks disabled
        else
          table.insert(valid_perks, perk_data)
        end
      end
    end

    if #valid_perks > 0 then
      local rnd = Random(1, #valid_perks)
      local perk_data = valid_perks[rnd]

      GivePerkToEnemy(perk_data, entity_id, 0, 1)
    end
  end
end
