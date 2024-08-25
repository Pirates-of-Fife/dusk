extends Node3D

@onready
var player : Node3D 

@onready
var ambiant_sound_player : AmbientSoundPlayer

@onready
var island0 : Node3D

@export
var island_0_min_distance : float

@export
var island_0_max_distance : float

@onready
var island1 : Node3D

@export
var island_1_min_distance : float

@export
var island_1_max_distance : float

@onready
var island2 : Node3D

@export
var island_2_min_distance : float

@export
var island_2_max_distance : float

@onready
var island3 : Node3D

@export
var island_3_min_distance : float

@export
var island_3_max_distance : float

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent_node_3d().get_node("Player")
	ambiant_sound_player = get_parent_node_3d().get_node("AmbientSound")
	
	island0 = get_parent_node_3d().get_node("Island0Terrain")
	island1 = get_parent_node_3d().get_node("Island1Terrain")
	island2 = get_parent_node_3d().get_node("Island2Terrain")
	island3 = get_parent_node_3d().get_node("Island3Terrain")


#this code is ass oh my god there are much better solutions out therehaefkjbsdgkjbsgls-gbr
func set_ocean_volume() -> void:
	var distance_island_0 : float = distance_to_player(island0)
	var distance_island_1 : float = distance_to_player(island1)
	var distance_island_2 : float = distance_to_player(island2)
	var distance_island_3 : float = distance_to_player(island3)
	
	#print("Distance to Island 0: ", distance_island_0)
	#print("Distance to Island 1: ", distance_island_1)
	#print("Distance to Island 2: ", distance_island_2)
	#print("Distance to Island 3: ", distance_island_3)
	
	var list : Array = [distance_island_0, distance_island_1, distance_island_2, distance_island_3]
	list.sort()
	
	var closest_distance = list[0]
	
	if closest_distance == distance_island_0:
		ambiant_sound_player.set_ocean_volume(closest_distance, island_0_min_distance, island_0_max_distance)
		#print("Using Island 0 : " + str(closest_distance))
	elif closest_distance == distance_island_1:
		ambiant_sound_player.set_ocean_volume(closest_distance, island_1_min_distance, island_1_max_distance)
		#print("Using Island 1 : " + str(closest_distance))
	elif closest_distance == distance_island_2:
		ambiant_sound_player.set_ocean_volume(closest_distance, island_2_min_distance, island_2_max_distance)
		#print("Using Island 2 : " + str(closest_distance))
	elif closest_distance == distance_island_3:
		ambiant_sound_player.set_ocean_volume(closest_distance, island_3_min_distance, island_3_max_distance)
		#print("Using Island 3 : " + str(closest_distance))
	
func distance_to_player(island : Node3D) -> float:
	return (island.get_node("Center").global_position - player.global_position).length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_ocean_volume()

	
