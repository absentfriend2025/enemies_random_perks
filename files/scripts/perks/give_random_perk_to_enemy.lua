dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/game_helpers.lua")
dofile_once("data/scripts/perks/perk_list.lua")

function GiveRandomPerkToEnemy(entity_id)
  local x, y = EntityGetTransform(entity_id)
  SetRandomSeed(x + GameGetFrameNum(), y - GameGetRealWorldTimeSinceStarted() + 100)

  local worm = EntityGetComponent(entity_id, "WormAIComponent")
  local dragon = EntityGetComponent(entity_id, "BossDragonComponent")
  local ghost = EntityGetComponent(entity_id, "GhostComponent")
  local lukki = EntityGetComponent(entity_id, "LimbBossComponent")

  if worm == nil and dragon == nil and ghost == nil and lukki == nil then
    local valid_perks = {}

    for i, perk_data in ipairs(perk_list) do
      if type(perk_data) == "table" and
      perk_data.id ~= nil and
      perk_data.id ~= "ATTACK_FOOT" and
      perk_data.id ~= "LEGGY_FEET" and
      perk_data.usable_by_enemies ~= nil and
      perk_data.usable_by_enemies == true then

      table.insert(valid_perks, i)
      end
    end

    if #valid_perks > 0 then
      local rnd = Random(1, #valid_perks)
      local result = valid_perks[rnd]

      local perk_data = perk_list[result]

      -- Have to do this manually because it's somehow broken
      if perk_data.id == "PROJECTILE_REPULSION" then
				local child_id = EntityLoad("data/entities/misc/perks/projectile_repulsion_field.xml", x, y)
				EntityAddTag(child_id, "perk_entity")
				EntityAddChild(entity_id, child_id)

        local particles = EntityLoad("mods/enemies_random_perks/files/entities/projectile_repulsion_field.xml", x, y)
        EntityAddChild(entity_id, particles)
        
        local damagemodels = EntityGetComponent(entity_id, "DamageModelComponent")
        if damagemodels ~= nil then
          for i, damagemodel in ipairs(damagemodels) do
            local projectile_resistance = ComponentObjectGetValue2(damagemodel, "damage_multipliers", "projectile")
            projectile_resistance = projectile_resistance * 1.26
            ComponentObjectSetValue2(damagemodel, "damage_multipliers", "projectile", projectile_resistance)
          end
        end
        
        local entity_icon = EntityLoad("data/entities/misc/perks/enemy_icon.xml", x, y)
	      local sc = EntityGetFirstComponentIncludingDisabled(entity_icon, "SpriteComponent")
        if sc then
          ComponentSetValue2(sc, "image_file", perk_data.ui_icon)
          EntityAddChild(entity_id, entity_icon)
        end
        return perk_data
      end

      give_perk_to_enemy(perk_data, entity_id, nil)
    end
  end
end