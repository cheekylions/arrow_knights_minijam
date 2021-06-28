extends Node2D

var player_count
var enemy_count

var directory = Directory.new()
var doFileExists

export var level = 1

var title_screen = "res://TitleScreen.tscn"
export var next_level = "res://Level2.tscn"

var reason = "next_level"

func _ready():
	$LevelWait.set_wait_time(1)

func _process(_delta):
	var all_players = get_tree().get_nodes_in_group("player")
	player_count = all_players.size()
	
	var all_enemies = get_tree().get_nodes_in_group("enemies")
	enemy_count = all_enemies.size()
	
	if player_count == 0:
		var all_arrows = get_tree().get_nodes_in_group("arrow")
		for each in all_arrows:
			each.queue_free()
			
		$ColorRect2.visible = true
		$Label.visible = true
	
	if player_count == 0 and Input.is_action_just_pressed("ui_accept"):
		reason = "reload"
		$LevelWait.start()
	
	if enemy_count == 0:
		var all_arrows = get_tree().get_nodes_in_group("arrow")
		for each in all_arrows:
			each.queue_free()
			
		for each in all_players:
			each.level_end = true
			
		$ColorRect2.visible = true
		$Label.set_text("You Are Won!\nPress fire to continue")
		$Label.visible = true
		
		if Input.is_action_just_pressed("ui_accept"):
			$LevelWait.start()

func _on_LevelWait_timeout():
	$LevelWait.stop()
	$LevelWait.set_wait_time(1)
	
	if reason == "reload":
		get_tree().reload_current_scene()
	if reason == "next_level":
		get_tree().change_scene(next_level)
