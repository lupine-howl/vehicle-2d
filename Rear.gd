extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(0, 0)
var gravity = Vector2(0, 100)
var friction = 0.97
var snap = Vector2(0, 1)
var up = Vector2.UP
var is_jumping = false
var jump_speed = 120
var x_accel = 70

onready var front_node = get_parent().find_node("Vehicle")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func get_input():
	if(is_on_floor()):
		if(Input.is_action_pressed("ui_right")):
			velocity.x += x_accel
		elif(Input.is_action_pressed("ui_left")):
			velocity.x -= x_accel
		if(Input.is_action_just_pressed("ui_up")):
			velocity.y = -1000
	pass


func _physics_process(delta):
	#get_input()
	var new_velocity = move_and_slide(velocity.rotated(rotation), Vector2.UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider
		var name = collider.name
		if(name == "Vehicle2"):
			#collider.velocity.x += 1000
			collider.velocity = velocity.length() * 0.8 * -collision.normal
			velocity = velocity.bounce(collision.normal) * 0.8
	velocity = new_velocity.rotated(-rotation)
	var distance_to_front = position.distance_to(front_node.position)
	var front_node_speed = front_node.velocity.length()
	var angle_to_front = position.angle_to(front_node.position)
	var new_force = Vector2((distance_to_front),0).rotated(angle_to_front + PI/2)
	if(position.distance_to(front_node.position) > 110):
		velocity += new_force
	elif(position.distance_to(front_node.position) < 90):
		velocity -= new_force
	if is_on_floor():
		#velocity.y = 0
		velocity *= friction
		rotation = get_floor_normal().angle() + PI/2
			
	velocity += gravity.rotated(-rotation)
	
	print(position.distance_to(front_node.position))
