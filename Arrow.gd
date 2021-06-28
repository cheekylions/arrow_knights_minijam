extends KinematicBody2D

export var speed = 256
var damage = 1
var tile_size = 10
var velocity = Vector2()

func start(pos,dir):
	position = pos
	
	if dir:
		velocity.x = speed * -1
		$AnimatedSprite.flip_h = true
	else:
		velocity.x = speed
		$AnimatedSprite.flip_h = false

func _process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if collision.collider.has_method("enemy_hit"):
			collision.collider.enemy_hit(damage)
		call_deferred("free")
		
