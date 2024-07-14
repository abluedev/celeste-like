extends Area2D
@onready var hero = get_parent().get_parent().get_parent().get_node("Hero")


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(hero, "_on_hero_entered"))
	connect("body_exited", Callable(hero, "_on_hero_exited"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
