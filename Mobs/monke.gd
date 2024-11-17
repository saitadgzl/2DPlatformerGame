extends CharacterBody2D

var SPEED = 100
var JUMP_VELOCITY = -600
var player
var chase
var health = 300
var damaged = false

@onready var MonkeHit2 = $MonkeHit2
@onready var MonkeHit1 = $MonkeHit1

const Bullet = preload("res://Character/Bullet/Bullet.gd")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("CollisionShape2D/AnimatedSprite2D").play("MonkeIdle")


func _physics_process(delta):
	velocity.y += gravity * delta
	if chase == true:
		if get_node("CollisionShape2D/AnimatedSprite2D").animation != "MonkeDeath" and get_node("CollisionShape2D/AnimatedSprite2D").animation != "MonkeHit" :
			get_node("CollisionShape2D/AnimatedSprite2D").play("MonkeRun")
		player = get_node("../../Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("CollisionShape2D/AnimatedSprite2D").flip_h = true
		else:
			get_node("CollisionShape2D/AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		if get_node("CollisionShape2D/AnimatedSprite2D").animation != "MonkeDeath":
			get_node("CollisionShape2D/AnimatedSprite2D").play("MonkeIdle")
		velocity.x = 0
			
	if damaged == true:
		knockback(Vector2.RIGHT, 2000,0)
	
	if health <= 0:
		death()
		
	move_and_slide()
	
	
func death():
	chase = false
	get_node("CollisionShape2D/AnimatedSprite2D").play("MonkeDeath")
	await get_node("CollisionShape2D/AnimatedSprite2D").animation_finished
	self.queue_free()


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_player_detection_body_exited(body):
		if body.name == "Player":
			chase = false

func _on_player_damage_body_entered(body):
		if body.name == "Player":
			MonkeHit1.play()
			if self.global_position.x > body.global_position.x:
				get_node("CollisionShape2D/AnimatedSprite2D").play("MonkeHit")
				await get_node("CollisionShape2D/AnimatedSprite2D").animation_finished
				Global.camera.shake(0.4 , 7)
				MonkeHit2.play()
				body.hit_by_monke_right = true
			else:
				get_node("CollisionShape2D/AnimatedSprite2D").play("MonkeHit")
				await get_node("CollisionShape2D/AnimatedSprite2D").animation_finished
				Global.camera.shake(0.4 , 7)
				MonkeHit2.play()
				body.hit_by_monke_left = true
			
func _on_damage_detection_body_entered(body):
	if body is Bullet:
		print(health) 
		body.queue_free()
		health = health -15


func knockback(direction: Vector2,x,y):
	velocity.x = x 
	velocity.y = y
