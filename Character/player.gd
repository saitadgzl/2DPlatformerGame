extends CharacterBody2D

const SPEED = 600.0
const speed_crouch = 300
const JUMP_VELOCITY = -600.0
const double_jump_velocity = -400.0
var has_double_jumped : bool = false 
@onready var cshape = $CollisionShape2D
@onready var crouch_raycast1 = $CrouchRayCast1
@onready var crouch_raycast2 = $CrouchRayCast2
@onready var damage_raycast_right = $DamageRayCastRight
@onready var damage_raycast_left = $DamageRayCastLeft


@onready var Gunshot = $Gunshot
@onready var PlayerHurt1 = $PlayerHurt1

const bulletPath = preload("res://Character/Bullet/Bullet.tscn")

var duration  # Adjust the duration as needed
var timer = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_in_control = true
var is_crouching = false
var stuck_under_object = false
var hit_by_bug_right = false
var hit_by_monke_right = false
var hit_by_bug_left = false
var hit_by_monke_left = false
var is_on_machine =  false

var standing_cshape = preload("res://Resources/player_standing_chshape.tres")
var crouching_cshape = preload("res://Resources/player_crouching_cshape.tres")

@onready var anim = get_node("AnimationPlayer")


func _physics_process(delta):

	if is_in_control== true:
		
		if not is_on_floor():
			velocity.y += gravity * delta
		else :
			has_double_jumped = false
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				anim.play("Jump")
			elif not has_double_jumped:
				velocity.y += double_jump_velocity
				anim.play("Jump")
				has_double_jumped = true

		var direction = Input.get_axis("left", "right")
		
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
			
		elif direction == 1:
			get_node("AnimatedSprite2D").flip_h = false
			
			
		if Input.is_action_just_pressed("crouch"):
			crouch()
		elif Input.is_action_just_released("crouch"):
			if above_head_control():
				stand()
			else:
				if stuck_under_object != true:
					stuck_under_object = true
					print ("control")
		
		if stuck_under_object && above_head_control():
			stand()
			stuck_under_object = false
		
		if direction:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				if is_crouching:
					anim.play("Crouch_Walk")
				else:
					anim.play("Run")
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				if is_crouching:
					anim.play("Crouch")
				else:
					if timer > 0:
						timer -= delta
					else:
						anim.play("Idle")  
		
		if velocity.y > 0:
			anim.play("Fall")
			
		if Input.is_action_just_pressed("shoot"):
			if Global.ammo != 0:
				shoot()
				Global.ammo = Global.ammo - 1
	else:
		pass
			
	if Global.health <= 0:
		death()
		pass
		
	if is_on_machine == true:
		if Input.is_action_just_pressed("interact"):
			machinecontrol()
		if Input.is_action_just_pressed("out"):
			is_in_control = true
			anim.play("Idle")
			Global.machine = false
	

	if hit_by_bug_right == true:
		if is_in_control== true:
			duration = 0.4
			Global.health -= 15
			PlayerHurt1.play()
			anim.play("DamageRight")
			print("Damaged from right(bug)")
			knockback(Vector2.LEFT, -2000, 0)
			timer = duration
			hit_by_bug_right = false
		
	if hit_by_bug_left == true:
		if is_in_control== true:
			duration = 0.4
			Global.health -= 15
			PlayerHurt1.play()
			anim.play("DamageLeft")
			print("Damaged from left(bug)")
			knockback(Vector2.RIGHT, 2000, 0)
			timer = duration
			hit_by_bug_left = false
		
	if hit_by_monke_right == true:
		if is_in_control== true:
			duration = 1.0
			Global.health -= 500
			anim.play("Bounce")
			print("Damaged from right(monke)")
			knockback(Vector2.LEFT, -5000, -800)
			timer = duration
			hit_by_monke_right = false
		
	if hit_by_monke_left == true:
		if is_in_control== true:
			duration = 1.0
			Global.health -= 500
			anim.play("Bounce")
			print("Damaged from left(monke)")
			knockback(Vector2.RIGHT, 5000,-800)
			timer = duration
			hit_by_monke_left = false
		
	move_and_slide()

func knockback(direction: Vector2,x,y):
	if is_in_control == true:
		velocity.x = x 
		velocity.y = y
		
func monkeknockback(direction: Vector2,x,y):
	if is_in_control == true:
		velocity.x = x
		velocity.y = y


func crouch():
	if is_crouching:
		return
	is_crouching = true
	cshape.shape = crouching_cshape
	cshape.position.y = 13
	cshape.position.x = 5
	
func machinecontrol():
	is_in_control = false
	anim.play("None")
	Global.machine = true
		
func stand():
	if is_crouching == false:
		return
	is_crouching = false 
	cshape.shape = standing_cshape
	cshape.position.y = -2.5
	cshape.position.x = 0.94
	
func above_head_control() -> bool:
	var result = !crouch_raycast1.is_colliding() && !crouch_raycast2.is_colliding()
	return result
	
func death():
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
		print("ÖLDÜN")
		
func shoot():
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	Gunshot.play()
	Global.camera.shake(0.2 , 3)
	
	if Input.is_action_pressed("up"):
		bullet.position = $Node2D/MarkerUp.global_position
		bullet.velocity_bullet = Vector2(0, -1)  # Shoot upwards
		bullet.rotation_degrees = -90
		
	else:
		if get_node("AnimatedSprite2D").flip_h == true:
			if is_crouching == false:
				bullet.position = $Node2D/MarkerLeft.global_position
				bullet.velocity_bullet = Vector2(-1, 0)  # Shoot to the left
				bullet.get_node("Sprite2D").flip_h = true
			
			elif is_crouching == true:
				bullet.position = $Node2D/MarkerDownLeft.global_position
				bullet.velocity_bullet = Vector2(-1, 0)  # Shoot to the left
				bullet.get_node("Sprite2D").flip_h = true
			
		elif get_node("AnimatedSprite2D").flip_h == false:
			if is_crouching == false:
				bullet.position = $Node2D/MarkerRight.global_position
				bullet.velocity_bullet = Vector2(1, 0)  # Shoot to the right
			elif is_crouching == true:
				bullet.position = $Node2D/MarkerDownRight.global_position
				bullet.velocity_bullet = Vector2(1, 0)  # Shoot to the right
