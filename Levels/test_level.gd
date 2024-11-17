extends Node2D

@onready var player = $Player

@onready var animplayer = $Player/AnimationPlayer

@onready var cutscenecam = $OpeningCutscene/Path2D/PathFollow2D/CutsceneCam

@onready var FallSound = $StartFalling

var hit_rock_control = false


func _ready():
	pass 
	
func _process(delta):
	if Global.hit_rock == true and hit_rock_control == false:
		animplayer.play("HitRock")
		FallSound.stop()
		Global.hit_rock = false
		hit_rock_control = true
		await get_node("Player/AnimationPlayer").animation_finished
		animplayer.play("GetUp")
		await get_node("Player/AnimationPlayer").animation_finished
		animplayer.play("Jump")
		player.is_in_control = true
	


func _on_starting_detection_body_entered(body):
	if body == player:
		print("Success")
		player.is_in_control = false
		player.velocity.y += 1000
		animplayer.play("StartFall")
		FallSound.play()
