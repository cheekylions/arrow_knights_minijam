var time = 0.0
var max_time = 0.0

func _init(input_max):
	self.max_time = input_max
	self.time = 0
	
func tick(delta):
	if time > 0:
		return false
	time = max(time - delta,0)
	
func is_ready():
	if time > 0:
		return false
	time = max_time
	return true	

#Example Use: Copy this code into script

#const Cooldown = preload("res://cooldown.gd")

#shoot every second, heal every ten seconds
#onready var shoot_cooldown = Cooldown.new(1)
#onready var heal_cooldown = Cooldown.new(10)

#func _process(delta):
	#shoot_cooldown.tick(delta)
	#if Input.is_action_pressed("shoot") and shoot_cooldown.is_ready():
		#pass # Shooting code goes here!
