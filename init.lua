dofile_once("mods/enemies_random_perks/files/scripts/perks/give_random_perk_to_enemy.lua")

function OnWorldPostUpdate()
  local player = EntityGetWithTag("player_unit")[1]
  if not player then return end
  local x, y = EntityGetTransform(player)
  local enemies = EntityGetInRadiusWithTag(x, y, 1024, "enemy")
  if not enemies then return end

  for _, enemy in ipairs(enemies) do
    if not EntityHasTag(enemy, "has_random_perk") then
      GiveRandomPerkToEnemy(enemy)
      EntityAddTag(enemy, "has_random_perk")
    end
  end
end