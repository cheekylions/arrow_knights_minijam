extends Node2D

var isVisible = true

func _ready():
	pass

func _process(_delta):
	
	if Input.is_action_just_pressed("ui_accept") and $StartTimer.is_stopped():
		$StartTimer.start()
		isVisible = false
		$BlinkTimer.start()
		
	if isVisible:
		$PressFire.visible = true
		
	if not isVisible:
		$PressFire.visible = false

func _on_StartTimer_timeout():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Level1.tscn")

func _on_BlinkTimer_timeout():
	$BlinkTimer.stop()
	
	if isVisible and $BlinkTimer.is_stopped():
		isVisible = false
		$BlinkTimer.start()

	if not isVisible and $BlinkTimer.is_stopped():
		isVisible = true
		$BlinkTimer.start()
