extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec)
var screen_size # size of the game window

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1	
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed 
		$AnimatedSprite2D.play() 
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Choosing Animations
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false # ko cho lật theo chiều ngang
		# See the note below about boolean assignment
		$AnimatedSprite2D.flip_h = velocity.x < 0 # lật khi sang trái
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # lật theo chiều dọc
	
func _on_body_entered(body):
	hide() # Player biến mất khi bị đánh trúng
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true) 
	
	# Disabling the area's collision shape can cause an error if it happens 
	# in the middle of the engine's collision processing. 
	# Using set_deferred() tells Godot to wait to disable the shape until 
	# it's safe to do so.

# Reset player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

