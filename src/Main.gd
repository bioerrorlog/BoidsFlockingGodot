extends Node2D

const BOIDS_COUNT = 200

onready var boid_scene = preload("res://src/Boid.tscn")
onready var boids_container = $Boids

var boids = []

func _ready():
	for i in BOIDS_COUNT:
		var boid = boid_scene.instance()
		boids_container.add_child(boid)
		boids.push_back(boid)
	
	for boid in boids_container.get_children():
		boid.boids = boids
		
	if OS.get_name()=="HTML5":
		OS.set_window_maximized(true)
