extends Area2D

@onready var anim = $AnimatedSprite2D

func _ready():
	pass

func _process(delta):
	pass

func _on_body_entered(body):
	if body.name == "Player":
		anim.play("Collected")
		Global.ammo += 14

func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "Collected":
		queue_free()
