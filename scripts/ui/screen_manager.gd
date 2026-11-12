extends CanvasLayer
## Builds the responsive portrait UI and routes between the onboarding and menu screens.

const MARKET_BG := "res://assets/munchies_beach.jpg"
const HERO_ART := "res://assets/munchies_first_character.jpg"
const WELCOME_ART := "res://assets/munchies_welcome.jpg"
const CHAOS_ART := "res://assets/running.png"
const COLORS := {
	"ink": Color("30204d"), "plum": Color("52247e"), "purple": Color("7438a8"),
	"orange": Color("f28a27"), "gold": Color("ffc949"), "cream": Color("fff3d1"),
	"brown": Color("754322"), "green": Color("59c748"), "blue": Color("39a9ee"),
	"red": Color("e85546"), "paper": Color("fff9e9")
}

var screen_root: Control
var screen_body: VBoxContainer
var active_screen := ""
var transition_busy := false
var save_data

func _ready() -> void:
	get_tree().root.content_scale_size = Vector2i(480, 854)
	save_data = get_node_or_null("/root/SaveData")
	if save_data == null:
		push_error("SaveData autoload is missing. Check project.godot.")
		return
	build_shell()
	show_screen("home" if save_data.profile.get("onboarding_complete", false) else "welcome", false)

func build_shell() -> void:
	screen_root = Control.new()
	screen_root.name = "ScreenRoot"
	screen_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_root.clip_contents = true
	add_child(screen_root)

func show_screen(screen_name: String, animate := true, payload := "") -> void:
	if transition_busy:
		return
	transition_busy = true
	if animate and screen_root.get_child_count() > 0:
		var fade := create_tween()
		fade.tween_property(screen_root, "modulate:a", 0.0, 0.12)
		await fade.finished
	for child in screen_root.get_children():
		child.queue_free()
	active_screen = screen_name
	var page := Control.new()
	page.name = screen_name.capitalize() + "Screen"
	page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_root.add_child(page)
	add_backdrop(page)
	var safe := MarginContainer.new()
	safe.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	safe.add_theme_constant_override("margin_left", 18)
	safe.add_theme_constant_override("margin_right", 18)
	safe.add_theme_constant_override("margin_top", 18)
	safe.add_theme_constant_override("margin_bottom", 16)
	page.add_child(safe)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	safe.add_child(scroll)
	screen_body = VBoxContainer.new()
	screen_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	screen_body.add_theme_constant_override("separation", 12)
	scroll.add_child(screen_body)
	match screen_name:
		"welcome": build_welcome()
		"home": build_home()
		"settings": build_settings()
		"scores": build_scores()
		"profile": build_profile()
		"game": build_game_placeholder()
		"coming": build_coming(payload)
		_: build_home()
	screen_root.modulate.a = 0.0
	if animate:
		var appear := create_tween()
		appear.tween_property(screen_root, "modulate:a", 1.0, 0.22)
		await appear.finished
	else:
		screen_root.modulate.a = 1.0
	transition_busy = false

func add_backdrop(parent: Control) -> void:
	var image := TextureRect.new()
	image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	image.texture = load(MARKET_BG)
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(image)
	var tint := ColorRect.new()
	tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tint.color = Color(0.12, 0.08, 0.17, 0.35)
	tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(tint)

func build_welcome() -> void:
	add_top_brand("KARIBU TO THE SOKO", "✦  NAIROBI MARKET DISTRICT  ✦")
	var hero := TextureRect.new()
	hero.texture = load(WELCOME_ART)
	hero.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hero.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hero.custom_minimum_size = Vector2(0, 205)
	hero.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hero.mouse_filter = Control.MOUSE_FILTER_IGNORE
	screen_body.add_child(hero)
	var panel := wood_panel(screen_body, COLORS.brown, 18)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 8)
	panel.add_child(stack)
	add_label(stack, "WELCOME TO", 16, COLORS.gold, HORIZONTAL_ALIGNMENT_CENTER)
	add_label(stack, "MUNCHIES FALL!", 30, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, true)
	add_label(stack, "Your Soko adventure starts here. Catch delicious surprises, discover extraordinary characters and become a legend of the market!", 16, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER)
	var tagline := add_label(screen_body, "THE SKY IS RAINING SNACKS.\nTHE MARKET IS YOURS.", 14, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER, true)
	tagline.add_theme_constant_override("line_spacing", 3)
	var continue_button := action_button("LET'S EXPLORE  →", COLORS.orange, 58)
	continue_button.pressed.connect(func():
		save_data.finish_onboarding()
		show_screen("home")
	)
	screen_body.add_child(continue_button)
	var hand := add_label(screen_body, "👇  TAP TO ENTER THE CHAOS  ✨", 15, COLORS.gold, HORIZONTAL_ALIGNMENT_CENTER, true)
	var bob := create_tween().set_loops()
	bob.tween_property(hand, "scale", Vector2(1.04, 1.04), 0.5).set_trans(Tween.TRANS_SINE)
	bob.tween_property(hand, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_SINE)
	var bottom := action_button("⚙   SETTINGS", COLORS.ink, 48)
	bottom.pressed.connect(func(): show_screen("settings"))
	screen_body.add_child(bottom)

func build_home() -> void:
	add_top_brand("MUNCHIES FALL", "CHAOS IN THE SOKO")
	var profile_card := wood_panel(screen_body, COLORS.ink, 13)
	var profile_row := HBoxContainer.new()
	profile_row.add_theme_constant_override("separation", 11)
	profile_card.add_child(profile_row)
	add_avatar(profile_row, 64)
	var identity := VBoxContainer.new()
	identity.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_label(identity, str(save_data.profile.name), 19, Color.WHITE, HORIZONTAL_ALIGNMENT_LEFT, true)
	var xp_text := add_label(identity, "LEVEL %02d   •   %d / 100 XP" % [save_data.profile.level, save_data.profile.xp], 12, COLORS.gold)
	var xp := ProgressBar.new()
	xp.custom_minimum_size = Vector2(0, 9)
	xp.max_value = 100
	xp.value = save_data.profile.xp
	xp.show_percentage = false
	identity.add_child(xp)
	var wallet := HBoxContainer.new()
	wallet.add_theme_constant_override("separation", 6)
	profile_row.add_child(identity)
	profile_row.add_child(wallet)
	wallet.add_child(wallet_chip("🪙", str(save_data.profile.coins), COLORS.gold))
	wallet.add_child(wallet_chip("💎", str(save_data.profile.gems), Color("e69cff")))

	var play_panel := wood_panel(screen_body, Color("6b318e"), 14)
	var play_stack := VBoxContainer.new()
	play_stack.add_theme_constant_override("separation", 7)
	play_panel.add_child(play_stack)
	var season := add_label(play_stack, "☀  TODAY IN THE SOKO  ☀", 13, COLORS.gold, HORIZONTAL_ALIGNMENT_CENTER, true)
	var play_button := action_button("▶   PLAY", COLORS.green, 70)
	play_button.add_theme_font_size_override("font_size", 29)
	play_button.pressed.connect(func(): show_screen("game"))
	play_stack.add_child(play_button)
	add_label(play_stack, "FALLING CHAOS  •  QUICK MARKET RUN", 12, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER)

	add_label(screen_body, "PICK YOUR NEXT ADVENTURE", 14, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER, true)
	var row_one := HBoxContainer.new()
	row_one.add_theme_constant_override("separation", 9)
	screen_body.add_child(row_one)
	add_feature(row_one, "🧑🏿‍🍳", "CHARACTERS", "Meet the legends", "Characters", COLORS.purple)
	add_feature(row_one, "🏪", "MARKET", "Explore the stalls", "Market", COLORS.orange)
	var row_two := HBoxContainer.new()
	row_two.add_theme_constant_override("separation", 9)
	screen_body.add_child(row_two)
	add_feature(row_two, "📈", "SOKO TYCOON", "Grow your empire", "Soko Tycoon", Color("3484ae"))
	add_feature(row_two, "🎁", "DAILY REWARDS", "A little market magic", "Daily Rewards", Color("d74f8e"))
	var row_three := HBoxContainer.new()
	row_three.add_theme_constant_override("separation", 9)
	screen_body.add_child(row_three)
	add_feature(row_three, "🏆", "CHALLENGES", "Test your hustle", "Challenges", Color("cb7b24"))
	add_feature(row_three, "🌍", "LEADERBOARD", "The soko legends", "Leaderboard", Color("387b72"))

	var stats := wood_panel(screen_body, Color("55301f"), 12)
	var stat_row := HBoxContainer.new()
	stat_row.add_theme_constant_override("separation", 3)
	stats.add_child(stat_row)
	add_stat(stat_row, "🏆", "BEST SCORE", comma(save_data.profile.best_score))
	add_stat(stat_row, "✨", "LAST RUN", comma(save_data.profile.latest_score))
	add_stat(stat_row, "🎮", "RUNS", comma(save_data.profile.games_played))
	add_stat(stat_row, "🥑", "SNACKS", comma(save_data.profile.items_collected))
	add_label(screen_body, "LOCAL PLACEHOLDER STATS  •  READY FOR GAMEPLAY DATA", 9, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER)
	var nav := HBoxContainer.new()
	nav.add_theme_constant_override("separation", 8)
	screen_body.add_child(nav)
	var score_btn := action_button("📊  SCORES", COLORS.blue, 46)
	score_btn.pressed.connect(func(): show_screen("scores"))
	nav.add_child(score_btn)
	var profile_btn := action_button("👤  PROFILE", COLORS.purple, 46)
	profile_btn.pressed.connect(func(): show_screen("profile"))
	nav.add_child(profile_btn)
	var settings_btn := action_button("⚙", COLORS.ink, 46)
	settings_btn.custom_minimum_size.x = 54
	settings_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	settings_btn.pressed.connect(func(): show_screen("settings"))
	nav.add_child(settings_btn)

func build_settings() -> void:
	add_screen_heading("⚙", "SETTINGS", "Tune your market soundtrack")
	var panel := wood_panel(screen_body, COLORS.brown, 16)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 12)
	panel.add_child(list)
	add_setting_slider(list, "♫  Music volume", "music_volume")
	add_setting_slider(list, "🔊  Sound effects", "sfx_volume")
	add_setting_toggle(list, "♫  Market music", "music_enabled")
	add_setting_toggle(list, "🔊  Sound effects", "sound_enabled")
	add_setting_toggle(list, "📳  Vibration", "vibration_enabled")
	add_setting_choice(list, "✨  Graphics quality", "graphics_quality", ["Low", "Medium", "High"])
	add_setting_choice(list, "🌐  Language", "language", ["English", "Kiswahili"])
	var replay := action_button("↻   REPLAY WELCOME", COLORS.orange, 50)
	replay.pressed.connect(func(): show_screen("welcome"))
	screen_body.add_child(replay)
	add_back_button(screen_body)

func build_scores() -> void:
	add_screen_heading("🏆", "SOKO RECORDS", "Every legend starts with one run")
	var entries := [
		["BEST SCORE", comma(save_data.profile.best_score), "Your all-time market high"],
		["LATEST RUN", comma(save_data.profile.latest_score), "Your most recent dash"],
		["TOTAL RUNS", comma(save_data.profile.games_played), "Times you hit the market"],
		["BEST COMBO", "×%d" % save_data.profile.highest_combo, "A delicious chain reaction"],
		["SNACKS SAVED", comma(save_data.profile.items_collected), "Mandazi never stood a chance"]
	]
	for entry in entries:
		var card := wood_panel(screen_body, Color("55301f"), 10)
		var row := HBoxContainer.new()
		card.add_child(row)
		var detail := VBoxContainer.new()
		detail.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(detail)
		add_label(detail, entry[0], 13, COLORS.gold, HORIZONTAL_ALIGNMENT_LEFT, true)
		add_label(detail, entry[2], 12, COLORS.cream)
		add_label(row, entry[1], 23, Color.WHITE, HORIZONTAL_ALIGNMENT_RIGHT, true)
	add_label(screen_body, "LOCAL PLACEHOLDER RECORDS  •  ONLINE RANKINGS ARRIVE LATER", 10, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER)
	add_back_button(screen_body)

func build_profile() -> void:
	add_screen_heading("👤", "YOUR MARKET STORY", "A rookie with legendary potential")
	var card := wood_panel(screen_body, COLORS.ink, 16)
	var profile_row := HBoxContainer.new()
	profile_row.add_theme_constant_override("separation", 12)
	card.add_child(profile_row)
	add_avatar(profile_row, 92)
	var details := VBoxContainer.new()
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	profile_row.add_child(details)
	add_label(details, str(save_data.profile.name), 21, Color.WHITE, HORIZONTAL_ALIGNMENT_LEFT, true)
	add_label(details, "MARKET CHAMPION • LEVEL %02d" % save_data.profile.level, 12, COLORS.gold)
	add_label(details, "%d / 100 XP TO THE NEXT STALL" % save_data.profile.xp, 11, COLORS.cream)
	var xp := ProgressBar.new()
	xp.max_value = 100
	xp.value = save_data.profile.xp
	xp.show_percentage = false
	details.add_child(xp)
	var rows := [
		["Runs played", comma(save_data.profile.games_played)],
		["Best score", comma(save_data.profile.best_score)],
		["Snacks collected", comma(save_data.profile.items_collected)],
		["Best combo", "×%d" % save_data.profile.highest_combo],
		["Soko Coins", comma(save_data.profile.coins)]
	]
	for row_data in rows:
		var line := wood_panel(screen_body, Color("754322"), 8)
		var h := HBoxContainer.new()
		line.add_child(h)
		var key := add_label(h, row_data[0], 14, COLORS.cream)
		key.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_label(h, row_data[1], 15, COLORS.gold, HORIZONTAL_ALIGNMENT_RIGHT, true)
	add_back_button(screen_body)

func build_game_placeholder() -> void:
	add_screen_heading("🌪️", "THE SKY IS OPEN!", "Your first market run is being built")
	var hero := TextureRect.new()
	hero.texture = load(CHAOS_ART)
	hero.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hero.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hero.custom_minimum_size = Vector2(0, 205)
	screen_body.add_child(hero)
	var panel := wood_panel(screen_body, COLORS.brown, 16)
	panel.add_child(make_label("Falling mandazi. Flying samosas. One very brave rookie. The first playable market level is under construction.", 17, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER))
	var teaser := wood_panel(screen_body, COLORS.ink, 10)
	teaser.add_child(make_label("COMING UP: CATCH • DODGE • COMBO • SURVIVE", 13, COLORS.gold, HORIZONTAL_ALIGNMENT_CENTER, true))
	add_back_button(screen_body)

func build_coming(feature_name: String) -> void:
	var data := coming_details(feature_name)
	add_screen_heading(data.icon, data.title, "A new corner of the soko is taking shape")
	var art := wood_panel(screen_body, data.color, 18)
	var vignette := VBoxContainer.new()
	vignette.alignment = BoxContainer.ALIGNMENT_CENTER
	vignette.add_theme_constant_override("separation", 10)
	art.add_child(vignette)
	add_label(vignette, data.icon, 82, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	add_label(vignette, data.stamp, 18, COLORS.gold, HORIZONTAL_ALIGNMENT_CENTER, true)
	add_label(vignette, data.description, 16, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	var teaser := wood_panel(screen_body, COLORS.brown, 12)
	teaser.add_child(make_label("UNDER CONSTRUCTION\nThe market builders are on it. Come back after another snack run!", 16, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER, true))
	add_back_button(screen_body)

func add_top_brand(title: String, subtitle: String) -> void:
	var brand := wood_panel(screen_body, COLORS.ink, 10)
	brand.add_child(make_label("✦  " + title + "  ✦", 20, COLORS.gold, HORIZONTAL_ALIGNMENT_CENTER, true))
	brand.add_child(make_label(subtitle, 11, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER))

func add_screen_heading(icon: String, title: String, subtitle: String) -> void:
	var header := wood_panel(screen_body, COLORS.brown, 13)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	header.add_child(row)
	add_label(row, icon, 34, COLORS.gold)
	var labels := VBoxContainer.new()
	labels.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(labels)
	add_label(labels, title, 22, Color.WHITE, HORIZONTAL_ALIGNMENT_LEFT, true)
	add_label(labels, subtitle, 12, COLORS.cream)

func add_avatar(parent: Control, size: int) -> void:
	var frame := PanelContainer.new()
	frame.custom_minimum_size = Vector2(size, size)
	frame.add_theme_stylebox_override("panel", flat_style(COLORS.gold, 100, 3, Color("fff2bb")))
	parent.add_child(frame)
	var pic := TextureRect.new()
	pic.texture = load(HERO_ART)
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	frame.add_child(pic)

func add_feature(parent: Control, icon: String, title: String, caption: String, route: String, color: Color) -> void:
	var button := Button.new()
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.custom_minimum_size = Vector2(0, 78)
	button.text = "%s\n%s\n%s" % [icon, title, caption]
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_stylebox_override("normal", flat_style(color, 13, 2, color.lightened(0.27)))
	button.add_theme_stylebox_override("hover", flat_style(color.lightened(0.12), 13, 2, COLORS.gold))
	button.add_theme_stylebox_override("pressed", flat_style(color.darkened(0.15), 13, 2, COLORS.gold))
	button.pressed.connect(func(): show_screen("coming", true, route))
	parent.add_child(button)

func add_stat(parent: Control, icon: String, title: String, value: String) -> void:
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.add_theme_constant_override("separation", 2)
	parent.add_child(column)
	add_label(column, icon, 19, COLORS.gold, HORIZONTAL_ALIGNMENT_CENTER)
	add_label(column, value, 15, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, true)
	add_label(column, title, 9, COLORS.cream, HORIZONTAL_ALIGNMENT_CENTER)

func add_setting_slider(parent: Control, title: String, key: String) -> void:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	parent.add_child(box)
	var row := HBoxContainer.new()
	box.add_child(row)
	var name := add_label(row, title, 15, COLORS.cream)
	name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var value_label := add_label(row, "%d%%" % int(float(save_data.settings[key]) * 100.0), 13, COLORS.gold, HORIZONTAL_ALIGNMENT_RIGHT, true)
	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.05
	slider.value = save_data.settings[key]
	slider.custom_minimum_size.y = 24
	slider.value_changed.connect(func(value: float):
		save_data.set_setting(key, value)
		value_label.text = "%d%%" % int(value * 100.0)
	)
	box.add_child(slider)

func add_setting_toggle(parent: Control, title: String, key: String) -> void:
	var row := HBoxContainer.new()
	parent.add_child(row)
	var text := add_label(row, title, 15, COLORS.cream)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var toggle := CheckButton.new()
	toggle.button_pressed = save_data.settings[key]
	toggle.add_theme_color_override("font_color", COLORS.gold)
	toggle.toggled.connect(func(value: bool): save_data.set_setting(key, value))
	row.add_child(toggle)

func add_setting_choice(parent: Control, title: String, key: String, options: Array) -> void:
	var row := HBoxContainer.new()
	parent.add_child(row)
	var text := add_label(row, title, 14, COLORS.cream)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var option := OptionButton.new()
	for item in options:
		option.add_item(item)
	var current_index := options.find(str(save_data.settings[key]))
	option.select(maxi(current_index, 0))
	option.item_selected.connect(func(index: int): save_data.set_setting(key, option.get_item_text(index)))
	row.add_child(option)

func add_back_button(parent: Control) -> void:
	var back := action_button("←   BACK TO THE SOKO", COLORS.blue, 50)
	back.pressed.connect(func(): show_screen("home" if save_data.profile.onboarding_complete else "welcome"))
	parent.add_child(back)

func wallet_chip(icon: String, value: String, color: Color) -> PanelContainer:
	var chip := PanelContainer.new()
	chip.add_theme_stylebox_override("panel", flat_style(Color("241b36"), 12, 1, color))
	var label := make_label(icon + " " + value, 13, color, HORIZONTAL_ALIGNMENT_CENTER, true)
	chip.add_child(label)
	return chip

func action_button(text: String, color: Color, height: int) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, height)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color("fff1c4"))
	button.add_theme_stylebox_override("normal", flat_style(color.darkened(0.12), 16, 3, color.lightened(0.25)))
	button.add_theme_stylebox_override("hover", flat_style(color, 16, 3, COLORS.gold))
	button.add_theme_stylebox_override("pressed", flat_style(color.darkened(0.26), 16, 2, COLORS.gold))
	button.pressed.connect(func():
		var tween := create_tween()
		tween.tween_property(button, "scale", Vector2(0.97, 0.97), 0.06)
		tween.tween_property(button, "scale", Vector2.ONE, 0.1)
	)
	return button

func wood_panel(parent: Control, color: Color, radius: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", flat_style(color, radius, 2, COLORS.gold.darkened(0.25)))
	parent.add_child(panel)
	return panel

func flat_style(color: Color, radius: int, border_width: int, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(radius)
	style.set_border_width_all(border_width)
	style.border_color = border_color
	style.shadow_color = Color(0, 0, 0, 0.28)
	style.shadow_size = 4
	style.shadow_offset = Vector2(0, 3)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 9
	style.content_margin_bottom = 9
	return style

func add_label(parent: Control, text: String, size: int, color: Color, align := HORIZONTAL_ALIGNMENT_LEFT, bold := false) -> Label:
	var label := make_label(text, size, color, align, bold)
	parent.add_child(label)
	return label

func make_label(text: String, size: int, color: Color, align := HORIZONTAL_ALIGNMENT_LEFT, bold := false) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = align
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	if bold:
		label.add_theme_color_override("font_shadow_color", Color("21132b"))
		label.add_theme_constant_override("shadow_offset_x", 1)
		label.add_theme_constant_override("shadow_offset_y", 2)
	return label

func comma(number: int) -> String:
	var digits := str(number)
	var result := ""
	while digits.length() > 3:
		result = "," + digits.substr(digits.length() - 3, 3) + result
		digits = digits.substr(0, digits.length() - 3)
	return digits + result

func coming_details(feature_name: String) -> Dictionary:
	var content := {
		"Characters": ["🧑🏿‍🍳", "THE MUNCHIE CREW", "Meet Mandazi Mike, Samosa Queen and the colourful crew waiting to join your market runs.", COLORS.purple],
		"Market": ["🏪", "MARKET DISTRICT", "Discover lively stalls, hidden recipes and the vendors who know every soko secret.", COLORS.orange],
		"Soko Tycoon": ["📈", "SOKO TYCOON", "Turn a humble stall into a bustling food empire. Hire, trade and grow your corner of Nairobi.", Color("3484ae")],
		"Daily Rewards": ["🎁", "A GIFT FROM THE SOKO", "A fresh little surprise is waiting each day. Check back soon to start your streak.", Color("d74f8e")],
		"Challenges": ["🏆", "MARKET CHALLENGES", "Take on wild daily missions, chase combos and prove you have the fastest hands in the market.", Color("cb7b24")],
		"Leaderboard": ["🌍", "SOKO LEGENDS", "The global market board is getting built. Online rankings will arrive when secure score validation is ready.", Color("387b72")]
	}
	var values: Array = content.get(feature_name, content["Market"])
	return {"icon": values[0], "title": values[1], "description": values[2], "color": values[3], "stamp": "COMING SOON"}
