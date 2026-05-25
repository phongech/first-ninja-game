extends CharacterBody2D

const test = 3.0
const SPEED = 150.0
const JUMP_VELOCITY = -320.0
const WALL_JUMP_VELOCITY = Vector2(400,-320)
var has_double_jumped = false

@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if is_on_floor():
		has_double_jumped = false
	# Add the gravity.
	if not is_on_floor():
		if is_on_wall() and velocity.y > 0:
			velocity += get_gravity() * 0.1 * delta 
		else:
			velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif not has_double_jumped:
			velocity.y = JUMP_VELOCITY
			has_double_jumped = true
			animated_sprite_2d.play("double_jump")
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	update_animations(direction)
	move_and_slide()

func update_animations(direction):
	if animated_sprite_2d.animation == "double_jump" and animated_sprite_2d.is_playing():
		return
		
	if is_on_floor():
		if direction:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		if is_on_wall():
			animated_sprite_2d.play("wall_jump")
		elif velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
