extends Node 

@onready var line:Texture2D = preload("res://line.png")
@onready var triangle:Texture2D = preload("res://3-gon.png")
@onready var square:Texture2D = preload("res://4-gon.png")
@onready var pentagon:Texture2D = preload("res://5-gon.png")
@onready var hexagon:Texture2D = preload("res://6-gon.png")
@onready var heptagon:Texture2D = preload("res://7-gon.png")
@onready var octagon:Texture2D = preload("res://8-gon.png")
@onready var white:Texture2D = preload("res://white.png")
@onready var black:Texture2D = preload("res://black.png")


# private class (leading '_')
class _DisappearingLine extends Node2D:
	var lease: int
	var remaining: int
	var end: Vector2
	func _init(lease: int):
		self.lease = lease
		self.remaining = lease
	func _draw():
		# VIS.line is a 1x1 white pixel
		draw_texture(VIS.line,Vector2(0,0),Color.WHITE)

# example of VIS-provided utilities
class ProgressTrail extends Node2D:
	var lifespan: int
	var width: float = 1
	var lines: Array[_DisappearingLine]
	func _init(lifespan: int):
		self.lifespan = lifespan
	func _enter_tree():
		# do not move/translate with parent
		top_level = true
	func _process(delta):
		add_line(get_parent().position)
		for line in lines:
			# decrease alpha
			line.modulate.a = float(line.remaining) / line.lease
			# decrease width
			line.scale.y = line.modulate.a * width
			line.remaining -= 1
		# remove oldest line if aged out
		if lines[0].remaining <= 0:
			lines.pop_front().queue_free()
	func add_line(here:Vector2):
		# add a line to our collection of lines making the path
		lines.append(_DisappearingLine.new(lifespan))
		add_child(lines[-1])
		lines[-1].end = here
		if lines.size() > 1:
			var last := lines[-2].end
			lines[-1].translate(Vector2(last))
			lines[-1].scale = Vector2((here - last).length(), 3)
			lines[-1].rotate(last.angle_to_point(here))
			
var args:Dictionary

func engine_version():
	return(Engine.get_version_info()['hex'])
func pck_version():
	return("0.1")

func update():
	print("checking for updates...")
	ProjectSettings.load_resource_pack("user://")
