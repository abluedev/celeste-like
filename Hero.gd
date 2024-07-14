extends CharacterBody2D

@onready var animatedSprite2D = $AnimatedSprite2D
@onready var timer = $Timer
@onready var dashTimer = $DashTimer

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
var is_in_unblocked_left_area = true
var is_not_dashing = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const DASH = 1000
const LEFT_SIDE = -1
const TOP_SIDE = -1
const RIGHT_SIDE = 1
const BOTTOM_SIDE = 1

func _ready():
	timer.connect("timeout", Callable(self, "_on_animation_fall"))

func _physics_process(delta):
	
	var direction = Input.get_axis("ui_left", "ui_right")

	_on_dash_action(direction, delta)
	move_and_slide()
	_on_animation_jump(delta)
	
	# Get the input direction and handle the movement/deceleration.
	if direction and is_not_dashing:
		if is_in_unblocked_left_area:
			velocity.x = direction * SPEED
		elif not is_in_unblocked_left_area and direction == 1: 
			velocity.x = direction * SPEED
		elif not is_in_unblocked_left_area and direction == -1: 
			velocity.x = 0
		if is_on_floor() and timer.is_stopped():
			animatedSprite2D.play("run")
		animatedSprite2D.flip_h = direction < 1
	elif is_on_floor_only():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if timer.is_stopped():
			animatedSprite2D.play("idle")
	
func _on_animation_fall():
	animatedSprite2D.play("fall")


func _on_animation_jump(delta):
		# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animatedSprite2D.play("jump")
			timer.start()

		# Add the gravity.		
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_hero_entered(body):
	if body.name == 'Hero':
		is_in_unblocked_left_area = false

func _on_hero_exited(body):
	if body.name == 'Hero':
		is_in_unblocked_left_area = true


func _on_dash_action(direction, delta):
		
	if Input.is_action_pressed("Dash") and is_not_dashing:
		is_not_dashing = false
		dashTimer.start()
		
		if not animatedSprite2D.flip_h:
			velocity.x = Vector2.RIGHT.x * DASH
		else:
			velocity.x = Vector2.LEFT.x * DASH
		# Avoid perma dash when is on floor
	if is_on_floor() and not Input.is_action_pressed("Dash"):
			is_not_dashing = true	
	if not is_not_dashing and dashTimer.is_stopped():
		velocity.x = 0
		velocity.x += direction * SPEED
