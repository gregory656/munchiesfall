extends Node
## Local profile and settings storage. Gameplay systems can update the same profile later.

const SAVE_PATH := "user://munchies_fall.cfg"

var profile: Dictionary = {
	"name": "Soko Rookie",
	"level": 1,
	"xp": 0,
	"coins": 0,
	"gems": 0,
	"best_score": 12450,
	"latest_score": 0,
	"games_played": 48,
	"items_collected": 3720,
	"highest_combo": 12,
	"onboarding_complete": false
}

var settings: Dictionary = {
	"music_volume": 0.8,
	"sfx_volume": 0.8,
	"music_enabled": true,
	"sound_enabled": true,
	"vibration_enabled": true,
	"graphics_quality": "High",
	"language": "English"
}

func _ready() -> void:
	load_local()

func load_local() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	var saved_profile: Dictionary = config.get_value("profile", "data", {})
	var saved_settings: Dictionary = config.get_value("settings", "data", {})
	for key in saved_profile:
		profile[key] = saved_profile[key]
	for key in saved_settings:
		settings[key] = saved_settings[key]

func save_local() -> void:
	var config := ConfigFile.new()
	config.set_value("profile", "data", profile)
	config.set_value("settings", "data", settings)
	config.save(SAVE_PATH)

func set_setting(key: String, value: Variant) -> void:
	settings[key] = value
	save_local()

func finish_onboarding() -> void:
	profile["onboarding_complete"] = true
	save_local()
