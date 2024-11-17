extends CharacterBody2D


var direction = Vector2.RIGHT
var speed = 1500.0
var elapsed_time = 0.0
@export var damaged: bool = false

func _physics_process(delta):
	
	translate(direction.normalized() * speed * delta)
	#var collision_info = move_and_collide(velocity_bullet.normalized()* delta * speed)
	
	elapsed_time += delta
	
	if elapsed_time >= 1.0:
		queue_free()


func _on_give_damage_body_entered(body):
	body.health = body.health - 200
