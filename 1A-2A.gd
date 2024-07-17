extends Area2D
@onready var camera2D = get_parent().get_parent().get_parent().get_parent().get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_hero_tp"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hero_tp(body):
	# if body.name == 'Hero':
		pass
