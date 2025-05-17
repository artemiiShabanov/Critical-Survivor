extends CharacterBody2D
@export var player_speed = 10
@export var friction = 0.18
@export var dash_speed = 50

var dash_direction = Vector2()
var can_dash = true
var mouse_pos = Vector2()

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	turn_player()
	
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * player_speed, 0.1)
	velocity *= 1.0 - (friction * delta)
	
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		dash_direction = Vector2.RIGHT.rotated(rotation)
		print(dash_direction)
		velocity = dash_direction * dash_speed
		velocity *= 1.0 - (friction * delta)
		$DashCD.start()

	move_and_collide(velocity)

func turn_player():
	mouse_pos = get_global_mouse_position()
	var targetDir = get_angle_to(mouse_pos - position.normalized())
	rotation += sin(targetDir * 1)

func _on_dash_cd_timeout() -> void:
	can_dash = true
