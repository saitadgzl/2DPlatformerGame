extends CharacterBody2D

var velocity_bullet = Vector2(1, 0)
var speed = 900.0
var elapsed_time = 0.0
@export var damaged: bool = false
func _physics_process(delta):
	
	var collision_info = move_and_collide(velocity_bullet.normalized()* delta * speed)
	
	elapsed_time += delta
	
	if elapsed_time >= 1.0:
		queue_free()
