extends CharacterBody2D

signal took_damage
signal fired_shot

var speed = 325
var rocket_scene = preload("res://scenes/rocket.tscn")
@onready var rocket_container = $RocketContainer
@onready var rocket_fired_sound = $RocketFiredSound

func _physics_process(delta):
	velocity = Vector2(0,0)
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_up"):
		velocity.y = -speed
	if Input.is_action_pressed("move_down"):
		velocity.y = speed
	
	move_and_slide()
	
	# Check if player is past boundaries and repostion accordingly
	var screen_size = get_viewport_rect().size

	# Hyper-optimized using Godot built-in clamp as part of global_position
	global_position = global_position.clamp(Vector2(0,0), screen_size)

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
func shoot():
	emit_signal("fired_shot")
	rocket_fired_sound.play()
	var rocket_instance = rocket_scene.instantiate()
	rocket_container.add_child(rocket_instance)
	rocket_instance.global_position = global_position
	rocket_instance.global_position.x += 75

func take_damage():
	emit_signal("took_damage")
	print("damaged") # TODO: Cleanup print debug output!
	
func die():
	queue_free()
