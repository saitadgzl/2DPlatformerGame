extends CharacterBody2D

var SPEED = 100
var player_node_path = "../../Player"
var player
var chase = false
var health = 30
var damaged = false
const Bullet = preload("res://Character/Bullet/Bullet.gd")

func _ready():
	get_node("CollisionShape2D/AnimatedSprite2D").play("Fly")
	update_player_reference()

func update_player_reference():
	var potential_player = get_node_or_null(player_node_path)
	if potential_player and is_instance_valid(potential_player):
		player = potential_player
	else:
		player = null
		chase = false

func _physics_process(delta):
	if not is_instance_valid(player):
		update_player_reference()
	
	if chase and is_instance_valid(player):
		get_node("CollisionShape2D/AnimatedSprite2D").play("Fly")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("CollisionShape2D/AnimatedSprite2D").flip_h = true
		else:
			get_node("CollisionShape2D/AnimatedSprite2D").flip_h = false
		velocity = direction * SPEED
	else:
		if get_node("CollisionShape2D/AnimatedSprite2D").animation != "Death":
			get_node("CollisionShape2D/AnimatedSprite2D").play("Fly")
		velocity = Vector2.ZERO
	
	if damaged:
		knockback(Vector2.RIGHT, 2000, 0)
	
	if health <= 0:
		death()
	
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player = body
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false
		player = null

func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()

func _on_player_collision_body_entered(body):
	if body.name == "Player":
		if self.global_position.x > body.global_position.x:
			body.hit_by_bug_right = true
		else:
			body.hit_by_bug_left = true

func _on_damage_detection_body_entered(body):
	if body is Bullet:
		print("Vurdun") 
		body.queue_free()
		health = health - 15

func death():
	chase = false
	get_node("CollisionShape2D/AnimatedSprite2D").play("Death")
	await get_node("CollisionShape2D/AnimatedSprite2D").animation_finished
	queue_free()

func knockback(direction: Vector2, x, y):
	velocity.x = x 
	velocity.y = y
