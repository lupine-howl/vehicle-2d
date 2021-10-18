extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(0, 0)
var gravity = Vector2(0, 80)
var friction = 1 - 0.1
var up = Vector2.UP
var jump_force = 1000
var acceleration = 100

export var controls = {
	"left":"ui_left",
	"right":"ui_right",
	"jump":"ui_accept"
}

func _ready():
	pass
	
func get_input():
	if(is_on_floor()):
		if(Input.is_action_pressed(controls.right)):
			velocity.x += acceleration
		elif(Input.is_action_pressed(controls.left)):
			velocity.x -= acceleration
		if(Input.is_action_just_pressed(controls.jump)):
			velocity.y = -jump_force
	pass

func handle_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider
		var name = collider.name
		if(name == "Vehicle2" || name == "Vehicle"):
			collider.velocity = velocity.length() * 1 * -collision.normal
			velocity += velocity.bounce(collision.normal) * 1
	pass

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity.rotated(rotation), Vector2.UP)
	if is_on_floor():
		velocity *= friction
		rotation = get_floor_normal().angle() + PI/2
	velocity += gravity
	handle_collisions()
	velocity = velocity.rotated(-rotation)
