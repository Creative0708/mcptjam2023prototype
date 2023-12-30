extends Node2D

const SCENES = {
	"menu": preload("res://scenes/menu.tscn"),
	"intro": preload("res://scenes/game_intro.tscn"),
	"game": preload("res://scenes/game.tscn"),
	"options": preload("res://scenes/options.tscn"),
	"death": preload("res://scenes/death.tscn")
}

const MUSIC = {
	"menu": [null, preload("res://music/menu_theme.ogg")],
	"game": [preload("res://music/battle_theme_intro.ogg"), preload("res://music/battle_theme_loop.ogg")],
	"boss": [null, preload("res://music/boss_theme.ogg")],
}

@onready var splash_screen = $"Current Scene/SplashScreen"

@onready var transition = $Transition

@onready var audio = $Audio

@onready var scene_node = $"Current Scene"

func instantiate(scene: PackedScene):
	var node = scene.instantiate()
	scene_node.add_child(node)
	return node

var next_scene

func _ready():
	await splash_screen.done
	next_scene = "menu"
	
	var loaded_gun
	while true:
		transition.transition()
		await transition.transition_done
		scene_node.get_child(0).queue_free()
		
		var scene = instantiate(SCENES[next_scene])
		match next_scene:
			"menu":
				play_music("menu")
				next_scene = await scene.scene_change
			"intro":
				var chosen_type = await scene.weapon_chosen
				match chosen_type:
					0:
						loaded_gun = load("res://scenes/component/pistol.tscn")
					1:
						loaded_gun = load("res://scenes/component/rifle.tscn")
					2:
						loaded_gun = load("res://scenes/component/shotgun.tscn")
				next_scene = "game"
			"game":
				play_music("game")
				scene.set_gun(loaded_gun)
				# scene.audio_change.connect()
				next_scene = await scene.scene_change
			"options":
				await scene.go_back
				next_scene = "menu"
			"death":
				await scene.okay
				next_scene = "menu"

var current_music_id: String

func play_music(music_id: String):
	if current_music_id == music_id:
		return
	
	current_music_id = music_id
	if MUSIC[music_id][0] != null:
		audio.stream = MUSIC[music_id][0]
		audio.play()
	else:
		loop_music()

func loop_music():
	audio.stream = MUSIC[current_music_id][1]
	audio.play()

func _on_audio_finished():
	if current_music_id:
		loop_music()
