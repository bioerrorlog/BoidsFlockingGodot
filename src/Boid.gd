extends Node2D
class_name Boid


var boids = []
var move_speed = 600
var perception_radius = 50
var centralization_force_radius = 10
var velocity = Vector2()
var acceleration = Vector2()
var steer_force = 50.0
var alignment_force = 1.2
var cohesion_force = 0.5
var seperation_force = 1.0
var avoidance_force = 30.0
var centralization_force = 0.5
var prey_position: Vector2 = Vector2(0, 0)

export (Array, Color) var colors

func _ready():
	randomize()
	position = Vector2(rand_range(-800, 800), rand_range(-600, -200))
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * move_speed
	modulate = colors[rand_range(0, colors.size())]


func _process(delta):
	var neighbors = get_neighbors(perception_radius)
	
	acceleration += process_alignments(neighbors) * alignment_force
	acceleration += process_cohesion(neighbors) * cohesion_force
	acceleration += process_seperation(neighbors) * seperation_force
	acceleration += process_centralization(prey_position) * centralization_force
		
	velocity += acceleration * delta
	velocity = velocity.clamped(move_speed)
	rotation = velocity.angle()
	
	translate(velocity * delta)


func set_prey_position(position: Vector2):
	prey_position = position
	
func process_centralization(centor: Vector2):
	if position.distance_to(centor) < centralization_force_radius:
		return Vector2()
		
	return steer((centor - position).normalized() * move_speed)	

func process_cohesion(neighbors):
	var vector = Vector2()
	if neighbors.empty():
		return vector
	for boid in neighbors:
		vector += boid.position
	vector /= neighbors.size()
	
	return steer((vector - position).normalized() * move_speed)
		

func process_alignments(neighbors):
	var vector = Vector2()
	if neighbors.empty():
		return vector
		
	for boid in neighbors:
		vector += boid.velocity
	vector /= neighbors.size()
	
	return steer(vector.normalized() * move_speed)
	

func process_seperation(neighbors):
	var vector = Vector2()
	var close_neighbors = []
	for boid in neighbors:
		if position.distance_to(boid.position) < perception_radius / 2:
			close_neighbors.push_back(boid)
	if close_neighbors.empty():
		return vector
	
	for boid in close_neighbors:
		var difference = position - boid.position
		vector += difference.normalized() / difference.length()
	
	vector /= close_neighbors.size()
	
	return steer(vector.normalized() * move_speed)
	

func steer(var target):
	var steer = target - velocity
	steer = steer.normalized() * steer_force
	
	return steer
	

func get_neighbors(view_radius):
	var neighbors = []

	for boid in boids:
		if position.distance_to(boid.position) <= view_radius and not boid == self:
			neighbors.push_back(boid)
			
	return neighbors
