extends Node

const SAVE_PATH: String = "user://memiq_scores.cfg"

var best_survival: int = 0
var best_survival_level: int = 1
var survival_level: int = 1
var survival_xp: int = 0
var best_overall: int = 0
var games_played: int = 0
var survival_runs: int = 0
var unlocked_achievements: Dictionary = {}
var unlocked_rewards: Dictionary = {}
var selected_background: String = "bg_neon"
var selected_board_style: String = "board_classic"
var audio_muted: bool = false
var visual_theme: String = "dark"


func _ready() -> void:
	load_scores()


func load_scores() -> void:
	var config: ConfigFile = ConfigFile.new()
	var error: int = config.load(SAVE_PATH)
	if error != OK:
		_ensure_default_rewards()
		return

	best_survival = int(config.get_value("survival", "best", 0))
	best_survival_level = int(config.get_value("survival", "best_level", int(config.get_value("adventure", "best_level", 1))))
	survival_level = int(config.get_value("survival", "level", int(config.get_value("adventure", "level", 1))))
	survival_xp = int(config.get_value("survival", "xp", int(config.get_value("adventure", "xp", 0))))
	best_overall = int(config.get_value("general", "best", best_survival))
	games_played = int(config.get_value("general", "games_played", 0))
	survival_runs = int(config.get_value("survival", "runs", 0))
	selected_background = String(config.get_value("rewards", "selected_background", "bg_neon"))
	selected_board_style = String(config.get_value("rewards", "selected_board_style", "board_classic"))
	audio_muted = bool(config.get_value("settings", "audio_muted", false))
	visual_theme = String(config.get_value("settings", "visual_theme", "dark"))
	unlocked_achievements.clear()
	unlocked_rewards.clear()

	if config.has_section("achievements"):
		for key in config.get_section_keys("achievements"):
			unlocked_achievements[String(key)] = bool(config.get_value("achievements", key, false))

	if config.has_section("rewards_unlocked"):
		for key in config.get_section_keys("rewards_unlocked"):
			unlocked_rewards[String(key)] = bool(config.get_value("rewards_unlocked", key, false))

	_ensure_default_rewards()


func save_scores() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("general", "best", best_overall)
	config.set_value("general", "games_played", games_played)
	config.set_value("survival", "best", best_survival)
	config.set_value("survival", "best_level", best_survival_level)
	config.set_value("survival", "level", survival_level)
	config.set_value("survival", "xp", survival_xp)
	config.set_value("survival", "runs", survival_runs)
	config.set_value("rewards", "selected_background", selected_background)
	config.set_value("rewards", "selected_board_style", selected_board_style)
	config.set_value("settings", "audio_muted", audio_muted)
	config.set_value("settings", "visual_theme", visual_theme)

	for id in unlocked_achievements.keys():
		config.set_value("achievements", String(id), bool(unlocked_achievements[id]))

	for id in unlocked_rewards.keys():
		config.set_value("rewards_unlocked", String(id), bool(unlocked_rewards[id]))

	config.save(SAVE_PATH)


func record_survival(score: int) -> bool:
	var changed: bool = false
	var new_record: bool = false
	games_played += 1
	survival_runs += 1
	changed = true

	if score > best_survival:
		best_survival = score
		changed = true
		new_record = true

	if score > best_overall:
		best_overall = score
		changed = true
		new_record = true

	if changed:
		save_scores()

	return new_record


func xp_to_next_survival_level(current_level: int = -1) -> int:
	var level_to_check: int = survival_level if current_level < 0 else current_level
	return 60 + (level_to_check - 1) * 34


func add_survival_xp(points: int) -> bool:
	var leveled_up: bool = false
	survival_xp += points

	while survival_xp >= xp_to_next_survival_level(survival_level):
		survival_xp -= xp_to_next_survival_level(survival_level)
		survival_level += 1
		best_survival_level = maxi(best_survival_level, survival_level)
		leveled_up = true

	save_scores()
	return leveled_up


func unlock_achievement(id: String) -> bool:
	if bool(unlocked_achievements.get(id, false)):
		return false

	unlocked_achievements[id] = true
	save_scores()
	return true


func is_achievement_unlocked(id: String) -> bool:
	return bool(unlocked_achievements.get(id, false))


func unlock_reward(id: String, kind: String) -> bool:
	if bool(unlocked_rewards.get(id, false)):
		return false

	unlocked_rewards[id] = true
	if kind == "background":
		selected_background = id
	elif kind == "board":
		selected_board_style = id

	save_scores()
	return true


func select_reward(id: String, kind: String) -> void:
	if not is_reward_unlocked(id):
		return

	if kind == "background":
		selected_background = id
	elif kind == "board":
		selected_board_style = id

	save_scores()


func set_audio_muted(value: bool) -> void:
	audio_muted = value
	save_scores()


func set_visual_theme(value: String) -> void:
	visual_theme = "light" if value == "light" else "dark"
	save_scores()


func is_light_theme() -> bool:
	return visual_theme == "light"


func is_reward_unlocked(id: String) -> bool:
	return bool(unlocked_rewards.get(id, false))


func unlocked_reward_count() -> int:
	var total: int = 0
	for id in unlocked_rewards.keys():
		if bool(unlocked_rewards[id]):
			total += 1

	return total


func _ensure_default_rewards() -> void:
	unlocked_rewards["bg_neon"] = true
	unlocked_rewards["board_classic"] = true

	if selected_background == "":
		selected_background = "bg_neon"
	if selected_board_style == "":
		selected_board_style = "board_classic"
