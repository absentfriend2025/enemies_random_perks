---@diagnostic disable: lowercase-global
dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "enemies_random_perks"
settings = {
  {
    id = "no_glass_cannon",
    ui_name = "Disable Glass Cannon",
    ui_description = "Enemies will no longer get the Glass Cannon perk.",
    value_default = false,
    scope = MOD_SETTING_SCOPE_RUNTIME,
  }
}

function ModSettingsUpdate(init_scope)
  mod_settings_update(mod_id, settings, init_scope)
end

function ModSettingsGuiCount()
  return mod_settings_gui_count(mod_id, settings)
end

function ModSettingsGui(gui, in_main_menu)
  mod_settings_gui(mod_id, settings, gui, in_main_menu)
end
