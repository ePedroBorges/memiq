extends Node

signal data_changed

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
var selected_sound_theme: String = "sound_classic"
var selected_music_theme: String = "music_neon_night"
var audio_muted: bool = false
var visual_theme: String = "dark"
var display_orientation: String = "sensor"
var display_name: String = "Jogador MEMIQ"
var avatar_id: String = "avatar_neon"
var banner_id: String = "banner_grid"
var name_style: String = "style_default"
var featured_achievement: String = ""
var gold: int = 0
var diamonds: int = 0
var multiplayer_rating: int = 1000
var rank_name: String = "Bronze"
var multiplayer_wins: int = 0
var multiplayer_losses: int = 0
var multiplayer_loss_streak: int = 0
var multiplayer_win_streak: int = 0
var monthly_completed_phases: Dictionary = {}
var purchased_items: Dictionary = {}


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
	selected_sound_theme = String(config.get_value("settings", "selected_sound_theme", "sound_classic"))
	selected_music_theme = String(config.get_value("settings", "selected_music_theme", "music_neon_night"))
	audio_muted = bool(config.get_value("settings", "audio_muted", false))
	visual_theme = String(config.get_value("settings", "visual_theme", "dark"))
	display_orientation = String(config.get_value("settings", "display_orientation", "sensor"))
	if display_orientation not in ["sensor", "portrait", "landscape"]:
		display_orientation = "sensor"
	display_name = String(config.get_value("profile", "display_name", "Jogador MEMIQ"))
	avatar_id = String(config.get_value("profile", "avatar_id", "avatar_neon"))
	banner_id = String(config.get_value("profile", "banner_id", "banner_grid"))
	name_style = String(config.get_value("profile", "name_style", "style_default"))
	featured_achievement = String(config.get_value("profile", "featured_achievement", ""))
	gold = int(config.get_value("wallet", "gold", 0))
	diamonds = int(config.get_value("wallet", "diamonds", 0))
	multiplayer_rating = int(config.get_value("multiplayer", "rating", 1000))
	rank_name = String(config.get_value("multiplayer", "rank_name", _rank_for_rating(multiplayer_rating)))
	multiplayer_wins = int(config.get_value("multiplayer", "wins", 0))
	multiplayer_losses = int(config.get_value("multiplayer", "losses", 0))
	multiplayer_loss_streak = int(config.get_value("multiplayer", "loss_streak", 0))
	multiplayer_win_streak = int(config.get_value("multiplayer", "win_streak", 0))
	unlocked_achievements.clear()
	unlocked_rewards.clear()
	monthly_completed_phases.clear()
	purchased_items.clear()

	if config.has_section("achievements"):
		for key in config.get_section_keys("achievements"):
			unlocked_achievements[String(key)] = bool(config.get_value("achievements", key, false))

	if config.has_section("rewards_unlocked"):
		for key in config.get_section_keys("rewards_unlocked"):
			unlocked_rewards[String(key)] = bool(config.get_value("rewards_unlocked", key, false))

	if config.has_section("monthly_phases"):
		for key in config.get_section_keys("monthly_phases"):
			monthly_completed_phases[String(key)] = bool(config.get_value("monthly_phases", key, false))

	if config.has_section("purchased_items"):
		for key in config.get_section_keys("purchased_items"):
			purchased_items[String(key)] = bool(config.get_value("purchased_items", key, false))

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
	config.set_value("settings", "selected_sound_theme", selected_sound_theme)
	config.set_value("settings", "selected_music_theme", selected_music_theme)
	config.set_value("settings", "audio_muted", audio_muted)
	config.set_value("settings", "visual_theme", visual_theme)
	config.set_value("settings", "display_orientation", display_orientation)
	config.set_value("profile", "display_name", display_name)
	config.set_value("profile", "avatar_id", avatar_id)
	config.set_value("profile", "banner_id", banner_id)
	config.set_value("profile", "name_style", name_style)
	config.set_value("profile", "featured_achievement", featured_achievement)
	config.set_value("wallet", "gold", gold)
	config.set_value("wallet", "diamonds", diamonds)
	config.set_value("multiplayer", "rating", multiplayer_rating)
	config.set_value("multiplayer", "rank_name", rank_name)
	config.set_value("multiplayer", "wins", multiplayer_wins)
	config.set_value("multiplayer", "losses", multiplayer_losses)
	config.set_value("multiplayer", "loss_streak", multiplayer_loss_streak)
	config.set_value("multiplayer", "win_streak", multiplayer_win_streak)

	for id in unlocked_achievements.keys():
		config.set_value("achievements", String(id), bool(unlocked_achievements[id]))

	for id in unlocked_rewards.keys():
		config.set_value("rewards_unlocked", String(id), bool(unlocked_rewards[id]))

	for id in monthly_completed_phases.keys():
		config.set_value("monthly_phases", String(id), bool(monthly_completed_phases[id]))

	for id in purchased_items.keys():
		config.set_value("purchased_items", String(id), bool(purchased_items[id]))

	config.save(SAVE_PATH)
	data_changed.emit()


func set_display_orientation(value: String) -> void:
	if value not in ["sensor", "portrait", "landscape"]:
		return
	if display_orientation == value:
		return
	display_orientation = value
	save_scores()


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
		gold += 8 + score
		save_scores()

	return new_record


func record_phase_result(score: int, completed: bool) -> void:
	games_played += 1
	best_overall = maxi(best_overall, score)
	gold += 3 + score + (5 if completed else 0)
	save_scores()


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


func set_background_theme(value: String) -> void:
	selected_background = value
	save_scores()


func set_board_style(value: String) -> void:
	selected_board_style = value
	save_scores()


func set_sound_theme(value: String) -> void:
	selected_sound_theme = value
	save_scores()


func set_music_theme(value: String) -> void:
	if not is_reward_unlocked(value) and not is_item_purchased(value):
		return
	selected_music_theme = value
	save_scores()


func update_profile(new_name: String, new_avatar: String, new_banner: String, new_style: String, new_featured_achievement: String) -> void:
	display_name = new_name.strip_edges()
	if display_name == "":
		display_name = "Jogador MEMIQ"
	avatar_id = new_avatar
	banner_id = new_banner
	name_style = new_style
	featured_achievement = new_featured_achievement
	save_scores()


func add_currency(gold_amount: int, diamond_amount: int = 0) -> void:
	gold = maxi(0, gold + gold_amount)
	diamonds = maxi(0, diamonds + diamond_amount)
	save_scores()


func purchase_item(id: String, currency: String, cost: int) -> bool:
	if bool(purchased_items.get(id, false)):
		return true
	if currency == "gold":
		if gold < cost:
			return false
		gold -= cost
	elif currency == "diamonds":
		if diamonds < cost:
			return false
		diamonds -= cost
	else:
		return false
	purchased_items[id] = true
	save_scores()
	return true


func is_item_purchased(id: String) -> bool:
	return bool(purchased_items.get(id, false))


func grant_item(id: String) -> bool:
	if bool(purchased_items.get(id, false)):
		return false
	purchased_items[id] = true
	save_scores()
	return true


func grant_all_content(reward_definitions: Array, shop_definitions: Array) -> bool:
	var changed: bool = false
	for reward in reward_definitions:
		var reward_id: String = String(reward.get("id", ""))
		if reward_id != "" and not bool(unlocked_rewards.get(reward_id, false)):
			unlocked_rewards[reward_id] = true
			changed = true
	for item in shop_definitions:
		var item_id: String = String(item.get("id", ""))
		if item_id != "" and not bool(purchased_items.get(item_id, false)):
			purchased_items[item_id] = true
			changed = true
	if changed:
		save_scores()
	return changed


func record_multiplayer_result(won: bool, opponent_rating: int = 1000) -> int:
	var previous_rating: int = multiplayer_rating
	var delta: int = 20 + clampi(int((opponent_rating - multiplayer_rating) / 50), -8, 12)
	var old_rank: String = _rank_for_rating(multiplayer_rating)
	if won:
		multiplayer_wins += 1
		multiplayer_win_streak += 1
		multiplayer_loss_streak = 0
		multiplayer_rating += maxi(12, delta)
		gold += 35
	else:
		multiplayer_losses += 1
		multiplayer_loss_streak += 1
		multiplayer_win_streak = 0
		var protected_loss: bool = old_rank in ["Bronze", "Prata"] and multiplayer_loss_streak < 2
		if not protected_loss:
			multiplayer_rating -= _loss_penalty_for_rank(old_rank)
		gold += 12
	multiplayer_rating = maxi(0, multiplayer_rating)
	rank_name = _rank_for_rating(multiplayer_rating)
	save_scores()
	return multiplayer_rating - previous_rating


func complete_monthly_phase(month_key: String, phase_number: int) -> Dictionary:
	var key: String = "%s_%02d" % [month_key, phase_number]
	if bool(monthly_completed_phases.get(key, false)):
		return {"gold": 0, "diamonds": 0, "item": ""}
	monthly_completed_phases[key] = true
	var reward_gold: int = 25 + phase_number * 3 + (100 if phase_number % 10 == 0 else 0)
	var reward_diamonds: int = 3 if phase_number % 5 == 0 else 0
	if phase_number % 10 == 0:
		reward_diamonds += 7
	var milestone_items: Dictionary = {10: "avatar_pixel", 20: "music_arcade", 30: "banner_temporada", 40: "music_dream"}
	var reward_item: String = String(milestone_items.get(phase_number, ""))
	gold += reward_gold
	diamonds += reward_diamonds
	if reward_item != "":
		purchased_items[reward_item] = true
	save_scores()
	return {"gold": reward_gold, "diamonds": reward_diamonds, "item": reward_item}


func complete_season_phase(season_key: String, phase_number: int) -> Dictionary:
	return complete_monthly_phase(season_key, phase_number)


func reset_season_phases(season_key: String) -> void:
	var prefix: String = "%s_" % season_key
	var keys: Array = monthly_completed_phases.keys()
	for id in keys:
		if String(id).begins_with(prefix):
			monthly_completed_phases.erase(id)
	save_scores()


func season_phase_completed(season_key: String, phase_number: int) -> bool:
	return monthly_phase_completed(season_key, phase_number)


func completed_phase_count() -> int:
	var total: int = 0
	for id in monthly_completed_phases.keys():
		if bool(monthly_completed_phases[id]):
			total += 1
	return total


func monthly_phase_completed(month_key: String, phase_number: int) -> bool:
	return bool(monthly_completed_phases.get("%s_%02d" % [month_key, phase_number], false))


func to_cloud_payload() -> Dictionary:
	return {
		"best_survival": best_survival,
		"best_survival_level": best_survival_level,
		"survival_level": survival_level,
		"survival_xp": survival_xp,
		"best_overall": best_overall,
		"games_played": games_played,
		"survival_runs": survival_runs,
		"unlocked_achievements": unlocked_achievements,
		"unlocked_rewards": unlocked_rewards,
		"selected_background": selected_background,
		"selected_board_style": selected_board_style,
		"selected_sound_theme": selected_sound_theme,
		"selected_music_theme": selected_music_theme,
		"audio_muted": audio_muted,
		"visual_theme": visual_theme,
		"display_name": display_name,
		"avatar_id": avatar_id,
		"banner_id": banner_id,
		"name_style": name_style,
		"featured_achievement": featured_achievement,
		"gold": gold,
		"diamonds": diamonds,
		"multiplayer_rating": multiplayer_rating,
		"rank_name": rank_name,
		"multiplayer_wins": multiplayer_wins,
		"multiplayer_losses": multiplayer_losses,
		"multiplayer_loss_streak": multiplayer_loss_streak,
		"multiplayer_win_streak": multiplayer_win_streak,
		"monthly_completed_phases": monthly_completed_phases,
		"purchased_items": purchased_items
	}


func apply_cloud_payload(payload: Dictionary) -> void:
	best_survival = maxi(best_survival, int(payload.get("best_survival", best_survival)))
	best_survival_level = maxi(best_survival_level, int(payload.get("best_survival_level", best_survival_level)))
	survival_level = maxi(survival_level, int(payload.get("survival_level", survival_level)))
	survival_xp = maxi(survival_xp, int(payload.get("survival_xp", survival_xp)))
	best_overall = maxi(best_overall, int(payload.get("best_overall", best_overall)))
	games_played = maxi(games_played, int(payload.get("games_played", games_played)))
	survival_runs = maxi(survival_runs, int(payload.get("survival_runs", survival_runs)))
	selected_background = String(payload.get("selected_background", selected_background))
	selected_board_style = String(payload.get("selected_board_style", selected_board_style))
	selected_sound_theme = String(payload.get("selected_sound_theme", selected_sound_theme))
	selected_music_theme = String(payload.get("selected_music_theme", selected_music_theme))
	audio_muted = bool(payload.get("audio_muted", audio_muted))
	visual_theme = String(payload.get("visual_theme", visual_theme))
	display_name = String(payload.get("display_name", display_name))
	avatar_id = String(payload.get("avatar_id", avatar_id))
	banner_id = String(payload.get("banner_id", banner_id))
	name_style = String(payload.get("name_style", name_style))
	featured_achievement = String(payload.get("featured_achievement", featured_achievement))
	gold = maxi(gold, int(payload.get("gold", gold)))
	diamonds = maxi(diamonds, int(payload.get("diamonds", diamonds)))
	multiplayer_rating = int(payload.get("multiplayer_rating", multiplayer_rating))
	rank_name = String(payload.get("rank_name", _rank_for_rating(multiplayer_rating)))
	multiplayer_wins = maxi(multiplayer_wins, int(payload.get("multiplayer_wins", multiplayer_wins)))
	multiplayer_losses = maxi(multiplayer_losses, int(payload.get("multiplayer_losses", multiplayer_losses)))
	multiplayer_loss_streak = int(payload.get("multiplayer_loss_streak", multiplayer_loss_streak))
	multiplayer_win_streak = int(payload.get("multiplayer_win_streak", multiplayer_win_streak))
	_merge_dictionary(unlocked_achievements, payload.get("unlocked_achievements", {}))
	_merge_dictionary(unlocked_rewards, payload.get("unlocked_rewards", {}))
	_merge_dictionary(monthly_completed_phases, payload.get("monthly_completed_phases", {}))
	_merge_dictionary(purchased_items, payload.get("purchased_items", {}))
	_ensure_default_rewards()
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
	unlocked_rewards["music_neon_night"] = true
	purchased_items["avatar_neon"] = true
	purchased_items["banner_grid"] = true
	purchased_items["style_default"] = true

	if selected_background == "":
		selected_background = "bg_neon"
	if selected_board_style == "":
		selected_board_style = "board_classic"


func _rank_for_rating(rating: int) -> String:
	if rating >= 2200:
		return "Lendario"
	if rating >= 1800:
		return "Diamante"
	if rating >= 1500:
		return "Ouro"
	if rating >= 1250:
		return "Prata"
	return "Bronze"


func _loss_penalty_for_rank(current_rank: String) -> int:
	if current_rank in ["Diamante", "Lendario"]:
		return 28
	if current_rank == "Ouro":
		return 22
	return 16


func _merge_dictionary(target: Dictionary, value: Variant) -> void:
	if not (value is Dictionary):
		return
	for key in value.keys():
		target[String(key)] = value[key]
