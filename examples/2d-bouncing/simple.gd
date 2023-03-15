extends Node2D


# _functions are called automatically by the display engine
# at different times depending on the function.
# _ready() after node is added to scene
# _process() every frame update
# _init() when instantiated
# _input() when mouse or key pressed


## used in example of bit more efficient way to draw lines
class Line extends Node2D:
	func _draw():
		# VIS.line is a 1x1 white pixel
		draw_texture(VIS.line,Vector2(0,0),Color.DARK_SLATE_GRAY)


## used in example of easy way to draw lines
class Grid extends Node2D:
	func _init(width:int, height:int, cols:int, rows:int):
		# bit more efficient way of drawing lines from sprites
		# example of making horizontal lines
		var colsize = width / cols
		var rowsize = height / rows
		for i in range(rows+1):
			var l1 = Line.new()
			self.add_child(l1)
			#l1.translate(Vector2(-600,colsize*i-600))
			l1.translate(Vector2(-400,rowsize*i-400))
			l1.scale = Vector2(width,1)
		# example of making vertical lines
		for i in range(cols+1):
			var l1 = Line.new()
			self.add_child(l1)
			l1.translate(Vector2(colsize*i-400,-400))
			l1.scale = Vector2(1,height)
	## less efficient line-drawing, but more classical
#	func _draw():
#		return
#		for i in range(100):
#			draw_line(Vector2(20*i,0),Vector2(20*i,20*100),Color.DARK_SLATE_GRAY)
#		for i in range(100):
#			draw_line(Vector2(0,20*i),Vector2(20*100,20*i),Color.DARK_SLATE_GRAY)


class Ball extends Node2D:
	var extents:Rect2 # compact array of floats
	var movement:= Vector2(400, 300)
	var size:Vector2
	func _init():
		# constructor (not yet in display list)
		pass
	func _enter_tree():
		# once it's in the display hierarchy
		var screensize = get_viewport().content_scale_size
		var top_left_bounds = screensize/2 * -1
		extents = Rect2(top_left_bounds, screensize)
		size = VIS.hexagon.get_size()
	func _draw():
		# only called once unless determined needs a redraw
		draw_texture(VIS.hexagon,Vector2(0,0),Color.LIGHT_BLUE)
	func _process(delta):
		position += movement * delta
		if position.x + size.x >= extents.end.x or position.x <= extents.position.x:
			movement.x *= -1
		if position.y + size.y >= extents.end.y or position.y <= extents.position.y:
			movement.y *= -1


# fires automatically
func _ready():
	## easy way of drawing some lines
	var grid = Grid.new(800, 600, 10, 6)
	self.add_child(grid)

	var ball = Ball.new()
	add_child(ball) # implicit `self`

func _process(delta):
	# happens every frame
	#OS.delay_msec(30) # can force delays, also can fix the FPS in settings
	pass


# example of user input
var FlastPressed = 0 # for rate-limiting fullscreen key 'F' presses
func _input(event):
	if Input.is_action_pressed("ui_accept"):
		print("spacebar")
	if Input.is_action_pressed("ui_left"):
		print("left arrow")
	if Input.is_action_pressed("ui_right"):
		print("right arrow")
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit() # quits the visualizer
	# fullscreen, and rate-limit user presses to 1 per 0.5 seconds because HW cannot respond that fast
	if Input.is_key_pressed(KEY_F) and Time.get_ticks_msec() > FlastPressed+500:
		FlastPressed = Time.get_ticks_msec()
		if DisplayServer.window_get_mode() >= DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
