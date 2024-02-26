extends Node

@export var mob_scene : PackedScene
var score

## Called when the node enters the scene tree for the first time.
#func _ready():
#	#new_game()
#	pass
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
	# Stop the music & Play game over music
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPossition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	# Play the music
	$Music.play()
	
	# Mobs group disappeared in new game
	get_tree().call_group("mobs", "queue_tree")

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
# xem ki ( hoi kho hieu )
func _on_mob_timer_timeout():
	# create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# choose a random location in Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity to the mob
	var velocity = Vector2(randf_range(150.0, 200.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene
	add_child(mob)
	
