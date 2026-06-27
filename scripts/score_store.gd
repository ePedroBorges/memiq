extends Node

const SAVE_PATH: String = "user://memiq_scores.cfg"

var best_survival: int = 0
var best_adventure: int = 0
var best_adventure_level: int = 0
var best_adventure_phase: int = 1
var adventure_phase: int = 1
var adventure_level: int = 1
var adventure_xp: int = 0
var best_overall: int = 0
var adventure_unlocked: int = 1
var adventure_best: Dictionary = {}
var games_played: int = 0
var survival_runs: int = 0
var adventure_runs: int = 0
var unlocked_achievements: Dictionary = {}
var unlocked_rewards: Dictionary = {}
var selected_background: String = "bg_neon"
var selected_board_style: String = "board_classic"


func _ready() -> void:
	load_scores()


func load_scores() -> void:
	var config: ConfigFile = ConfigFile.new()
	var error: int = config.load(SAVE_PATH)
	if error != OK:
		_ensure_default_rewards()
		return

	best_survival = int(config.get_value("survival", "best", 0))
	best_adventure = int(config.get_value("adventure", "best", 0))
	best_adventure_level = int(config.get_value("adventure", "best_level", 0))
	best_adventure_phase = int(config.get_value("adventure", "best_phase", 1))
	adventure_phase = int(config.get_value("adventure", "phase", 1))
	adventure_level = int(config.get_value("adventure", "level", 1))
	adventure_xp = int(config.get_value("adventure", "xp", 0))
	best_overall = int(config.get_value("general", "best", maxi(best_survival, best_adventure)))
	games_played = int(config.get_value("general", "games_played", 0))
	survival_runs = int(config.get_value("survival", "runs", 0))
	adventure_runs = int(config.get_value("adventure", "runs", 0))
	adventure_unlocked = int(config.get_value("adventure", "unlocked", 1))
	selected_background = String(config.get_value("rewards", "selected_background", "bg_neon"))
	selected_board_style = String(config.get_value("rewards", "selected_board_style", "board_classic"))
	adventure_best.clear()
	unlocked_achievements.clear()
	unlocked_rewards.clear()

	if config.has_section("achievements"):
		for key in config.get_section_keys("achievements"):
			unlocked_achievements[String(key)] = bool(config.get_value("achievements", key, false))

	if config.has_section("rewards_unlocked"):
		for key in config.get_section_keys("rewards_unlocked"):
			unlocked_rewards[String(key)] = bool(config.get_value("rewards_unlocked", key, false))

	_ensure_default_rewards()

	if not config.has_section("adventure_best"):
		return

	for key in config.get_section_keys("adventure_best"):
		adventure_best[int(key)] = int(config.get_value("adventure_best", key, 0))


func save_scores() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("general", "best", best_overall)
	config.set_value("general", "games_played", games_played)
	config.set_value("survival", "best", best_survival)
	config.set_value("survival", "runs", survival_runs)
	config.set_value("adventure", "best", best_adventure)
	config.set_value("adventure", "best_level", best_adventure_level)
	config.set_value("adventure", "best_phase", best_adventure_phase)
	config.set_value("adventure", "phase", adventure_phase)
	config.set_value("adventure", "level", adventure_level)
	config.set_value("adventure", "xp", adventure_xp)
	config.set_value("adventure", "runs", adventure_runs)
	config.set_value("adventure", "unlocked", adventure_unlocked)
	config.set_value("rewards", "selected_background", selected_background)
	config.set_value("rewards", "selected_board_style", selected_board_style)

	for phase in adventure_best.keys():
		config.set_value("adventure_best", str(phase), adventure_best[phase])

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


func record_adventure(phase: int, score: int, completed: bool) -> bool:
	var previous: int = int(adventure_best.get(phase, 0))
	var improved: bool = score > previous
	if improved:
		adventure_best[phase] = score

	if completed and phase >= adventure_unlocked:
		adventure_unlocked = phase + 1
		improved = true

	if improved:
		save_scores()

	return improved


func get_adventure_best(phase: int) -> int:
	return int(adventure_best.get(phase, 0))


func record_adventure_run(score: int) -> bool:
	var changed: bool = false
	var new_record: bool = false
	games_played += 1
	adventure_runs += 1
	changed = true

	if score > best_adventure:
		best_adventure = score
		changed = true
		new_record = true

	if score > best_overall:
		best_overall = score
		changed = true
		new_record = true

	if changed:
		save_scores()

	return new_record


func record_adventure_run_with_level(score: int, reached_level: int) -> bool:
	var new_record: bool = record_adventure_run(score)

	if reached_level > best_adventure_level:
		best_adventure_level = reached_level
		save_scores()

	return new_record


func xp_to_next_level(current_level: int = -1) -> int:
	var level_to_check: int = adventure_level if current_level < 0 else current_level
	return 45 + (level_to_check - 1) * 30


func record_adventure_phase_clear(cleared_phase: int, xp_gain: int) -> bool:
	var leveled_up: bool = false
	adventure_phase = maxi(adventure_phase, cleared_phase + 1)
	best_adventure_phase = maxi(best_adventure_phase, adventure_phase)
	adventure_xp += xp_gain

	while adventure_xp >= xp_to_next_level(adventure_level):
		adventure_xp -= xp_to_next_level(adventure_level)
		adventure_level += 1
		best_adventure_level = maxi(best_adventure_level, adventure_level)
		leveled_up = true

	save_scores()
	return leveled_up


func record_adventure_run_finished(phases_cleared: int) -> void:
	games_played += 1
	adventure_runs += 1
	best_adventure = maxi(best_adventure, phases_cleared)
	save_scores()


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
