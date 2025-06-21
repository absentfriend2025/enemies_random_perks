---@diagnostic disable: lowercase-global
dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "enemies_random_perks"
settings = {
  {
    id = "perk_chance",
    ui_name = "Chance",
    ui_description = "Chance to give enemies perks.",
    value_default = 100,
		value_min = 0,
		value_max = 100,
		value_display_multiplier = 1,
		value_display_formatting = " $0%",
    scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
  },
  {
    id = "no_glass_cannon",
    ui_name = "Disable Glass Cannon",
    ui_description = "Enemies will no longer get the Glass Cannon perk.",
    value_default = false,
    scope = MOD_SETTING_SCOPE_RUNTIME,
  },
  {
    id = "no_ghost_perks",
    ui_name = "Disable Ghost-type Perks",
    ui_description = "Enemies will no longer get ghost-type perks.\nAdded this option because of bugs regarding ghost-type perks.\nCheck the Steam workshop of this mod for more information.",
    value_default = true,
    scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
  },
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
