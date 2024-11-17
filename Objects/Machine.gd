extends Area2D

@onready var MachineGunshot = $MachineGunshot

var is_on = false
var is_shooting = false
var is_label_timed_out = false

var label2_timer = 0.0
var label2_visible_time = 3.0  # Set the time in seconds

const MachineBullet = preload("res://Objects/machine_bullet.gd")

const bulletPath = preload("res://Objects/machine_bullet.tscn")

func _ready():
	var label = $Label
	var label2 = $Label2
	label.hide()
	label2.hide()
	
func _process(delta):
	var label2 = $Label2
	if Global.machine== true:
		is_on = true
	if Global.machine == false:
		is_on = false
		is_label_timed_out = false
		label2.hide()

func _physics_process(delta):
	var label = $Label
	var label2 = $Label2
	if is_on == true:
		label.hide()
		if is_label_timed_out == false:
			label2.show()
			$Label2Timer.start()
		var pos = get_global_mouse_position()
		var posy =pos.y
		if posy < 360:
			$Barrel.look_at(get_global_mouse_position())

		if Input.is_action_just_pressed("shoot"):
			is_shooting = true
		elif Input.is_action_just_released("shoot"):
			is_shooting = false
			get_node("Barrel").play("Barrel")	
	
	if is_shooting == true:
		shoot()
		
		
func _on_body_entered(body):
	var label = $Label
	if body.name == "Player":
		print("Girdin")
		label.show()
		body.is_on_machine = true
		
func _on_body_exited(body):
	var label = $Label
	if body.name == "Player":
		label.hide()
		body.is_on_machine = false

func shoot():
	get_node("Barrel").play("Shoot")
	await get_node("Barrel").animation_finished
	var bullet = bulletPath.instantiate()
	bullet.direction = $Barrel/Marker2D.global_position - global_position
	bullet.global_position = $Barrel/Marker2D.global_position
	get_parent().add_child(bullet)
	MachineGunshot.play()
	Global.camera.shake(0.2 , 3)
	
	
func _on_label_2_timer_timeout():
	var label2 = $Label2
	label2.hide()
	print("bitti")
	is_label_timed_out = true

	
func _on_take_damage_body_entered(body):
	if body.name != "Player":
		if body != MachineBullet:
			Global.health = Global.health - 30
			print(body.name)
			body.damaged = true
			
