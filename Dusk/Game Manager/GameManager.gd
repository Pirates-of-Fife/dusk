extends Node3D

class_name GameManager

@export
var player : Node3D

@export
var boat : Node3D

var player_map : Map
var boat_map : Map
var boat_map2 : Map

@onready
var lightning_spawner : LightningSpawner

var player_rain : GPUParticles3D
var boat_rain : GPUParticles3D

func _ready():
	player_map = player.find_child("Map")
	boat_map = boat.find_child("Map")
	boat_map2 = boat.find_child("Map2")
	lightning_spawner = get_parent_node_3d().get_node("AmbientSound/LightningSpawner")
	
	player_rain = get_parent_node_3d().get_node("Player/RainParticles")
	boat_rain = get_parent_node_3d().get_node("Boat/ShipHull/RainParticles")
	
	set_weather_intensity(0)

func map_collected() -> void:
	player_map.unlock_map_section()
	boat_map.unlock_map_section()
	boat_map2.unlock_map_section()
	set_weather_intensity(player_map.unlocked_parts)
	
func set_weather_intensity(maps_collected : int) -> void:
	match maps_collected:
		0:
			lightning_spawner.min_spawn_time = 30
			lightning_spawner.max_spawn_time = 60
			
			player_rain.amount_ratio = 0.4
			boat_rain.amount_ratio = 0.4
		1:
			lightning_spawner.min_spawn_time = 20
			lightning_spawner.max_spawn_time = 60
			
			player_rain.amount_ratio = 0.5
			boat_rain.amount_ratio = 0.5
		2:
			lightning_spawner.min_spawn_time = 20
			lightning_spawner.max_spawn_time = 50
			
			player_rain.amount_ratio = 0.6
			boat_rain.amount_ratio = 0.6
		3:
			lightning_spawner.min_spawn_time = 10
			lightning_spawner.max_spawn_time = 40
			
			player_rain.amount_ratio = 0.8
			boat_rain.amount_ratio = 0.8
		4:
			lightning_spawner.min_spawn_time = 2
			lightning_spawner.max_spawn_time = 15
			
			player_rain.amount_ratio = 1
			boat_rain.amount_ratio = 1
