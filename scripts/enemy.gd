extends CharacterBody3D
@onready var death_sound = $DeathSound
@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var collision_shape_3d = $CollisionShape3D

var move_speed = 2.0
var attack_range = 1.0
var dead = false

func kill():
	animated_sprite_3d.play("death")
	death_sound.play()
	collision_shape_3d.disabled = true
	dead = true
	

func attempt_to_kill_player():
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > attack_range:
		return
		
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eye_line, player.global_position+eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result.is_empty():
		player.kill()
	
	
	
func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
		
	var direction = player.global_position - global_position
	direction.y = 0.0
	direction = direction.normalized()
	
	velocity = direction * move_speed
	move_and_slide()
	attempt_to_kill_player()
	
