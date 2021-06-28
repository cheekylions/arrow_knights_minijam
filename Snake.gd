extends KinematicBody2D

var nearest_player
var velocity = Vector2()
var collide

export var health = 5
export var speed = 30
export var damage = 1
export var wait_time = 0.25
var tile_size = 10

var isMove = true
var isAttack = false

func _ready():
	get_target()

func get_target():
	var players = []
	
	players += get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		nearest_player = players[0]

	for player in players:
		if player.global_position.distance_to(global_position) < nearest_player.global_position.distance_to(global_position):
			nearest_player = player
	
func _process(delta):
	
	if isMove and is_instance_valid(nearest_player):
		velocity = (nearest_player.position - global_position).normalized() * speed
		if $MoveOn.is_stopped():
			$MoveOn.start()
			
		collide = move_and_collide(velocity * delta)
		
	if collide and isMove:
		isMove = false
		var collider = collide.collider
		if is_instance_valid(collider) and collider.is_in_group("player"):
			$AnimatedSprite.play("attack")
			$SnakeAttack.play()
			if collider.has_method("player_hit"):
				collider.player_hit(damage)
		if $MoveOn.is_stopped():
			$MoveOn.start()
	
	if health <= 0:
		call_deferred("free")

func enemy_hit(dmg):
	health -= dmg
	
func _on_MoveOn_timeout():

	$MoveOn.stop()
	isMove = false
	
	get_target()
	
	$AnimatedSprite.play("default")
	if $MoveOff.is_stopped():
		$MoveOff.start()
		
	$MoveOn.set_wait_time(wait_time)

func _on_CoolDown_timeout():
	
	$MoveOff.stop()
	isMove = true
	
	$AnimatedSprite.play("move")
	
	$MoveOff.set_wait_time(wait_time)
