extends KinematicBody2D

onready var ray = $RayCast2D

var health = 5

var Arrow = preload("res://Arrow.tscn")
var arrow_cooldown = true

var speed = 110
var tile_size = 10

var last_position = Vector2() #last idle position
var target_position = Vector2() #desired position to move toward
var movedir = Vector2() #move direction

var level_end = false

func _ready():	
	position = position.snapped(Vector2(tile_size,tile_size)) #snap player to grid
	last_position = position
	target_position = position
	
	ray.set_collide_with_areas(true)

func get_movedir():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
	if movedir.x != 0 && movedir.y != 0: #prevent diagonals
		movedir = Vector2.ZERO
	if movedir != Vector2.ZERO:
		ray.cast_to = movedir * tile_size / 2
		
	if LEFT:
		$AnimatedSprite.flip_h = true
		$Position2D.position.x = -tile_size
	if RIGHT:
		$AnimatedSprite.flip_h = false
		$Position2D.position.x = tile_size
		
func _process(delta):

	#Movement
	if ray.is_colliding():
		position = last_position
		target_position = last_position
	else:
		position += speed * movedir * delta

	if position.distance_to(last_position) >= tile_size:
		position = target_position

	#Idle
	if position == target_position:
		get_movedir()
		last_position = position
		target_position += movedir * tile_size

	if Input.is_action_pressed("ui_accept") and !level_end:
		if arrow_cooldown:
			$AnimatedSprite.play("fire")
			$ArrowFire.play()

			var a = Arrow.instance()
			a.start($Position2D.global_position,$AnimatedSprite.flip_h)
			get_parent().add_child(a)
			
			arrow_cooldown = false
			$ArrowCooldown.start()
			
	if health <= 0:
		$PlayerDie.play()
		call_deferred("free")

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("default")
	
func _on_ArrowCooldown_timeout():
	arrow_cooldown = true

func player_hit(damage):
	health -= damage
