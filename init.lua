dofile_once("mods/enemies_random_perks/files/scripts/perks/give_random_perk_to_enemy.lua")

function OnWorldPostUpdate()
  local player = EntityGetWithTag("player_unit")[1]
  local x, y = EntityGetTransform(player)

  local enemies = EntityGetInRadiusWithTag(x, y, 1024, "enemy")
  if not enemies then return end

  SetRandomSeed(#enemies + GameGetFrameNum(), GameGetRealWorldTimeSinceStarted())

  local percent = ModSettingGet("enemies_random_perks.perk_chance")
  percent = tonumber(percent)
  percent = math.max(0, math.min(100, percent))

  for _, enemy in ipairs(enemies) do
    if not EntityHasTag(enemy, "has_random_perk") and not EntityHasTag(enemy, "dont_give_perk") then

      local chance = Random(1, 100)
      if chance <= percent then
        GiveRandomPerkToEnemy(enemy)
        EntityAddTag(enemy, "has_random_perk")
      else
        EntityAddTag(enemy, "dont_give_perk")
      end
    end
  end
end