extends Area2D

const Player = preload("res://Character/player.gd")
@onready var animplayer = $Player/AnimationPlayer

@onready var HitRockSound = $HitRock

@onready var NormalSprite = $Normal

@onready var CrackedSprite = $Cracked

var sound_played = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_detect_player_body_entered(body):
	if body is Player and Global.hit_rock == false:
		if sound_played == false:
			HitRockSound.play()
			sound_played = true
		NormalSprite.hide()
		Global.hit_rock = true
		
