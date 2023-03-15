extends Node


## Description
# this visualization script reads in a CSV file,
# the CSV data includes position information
# as well as lots of information we don't care about
# so we only read the position data for
# the agent (x,y,rot)
# and the 50 prey locations (health,x,y)
# that follow, for each timepoint.
# Predator is red triangle
# Prey is blue hexagon

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
		for i in range(cols+1):
			var l1 = Line.new()
			self.add_child(l1)
			l1.translate(Vector2(-400,colsize*i-200))
			l1.scale = Vector2(width,1)
		# example of making vertical lines
		for i in range(rows+1):
			var l1 = Line.new()
			self.add_child(l1)
			l1.translate(Vector2(rowsize*i-400,-200))
			l1.scale = Vector2(1,height)
	## less efficient line-drawing, but more classical
#	func _draw():
#		return
#		for i in range(100):
#			draw_line(Vector2(20*i,0),Vector2(20*i,20*100),Color.DARK_SLATE_GRAY)
#		for i in range(100):
#			draw_line(Vector2(0,20*i),Vector2(20*100,20*i),Color.DARK_SLATE_GRAY)


## base class for Predator and Prey
class Agent extends Node2D:
	const scalemovement:int = 20
	const scalesize:float = 0.2
	var screensize:Vector2 # compact array of floats
	func _init():
		screensize = DisplayServer.window_get_min_size()
		self.scale = Vector2(scalesize,scalesize)
	func gotoCenterOffset(newpos:Vector2):
		# assume newpos is an offset from 0,0,
		# but we want 0,0 to  appear to be the center of the screen
		#self.transform.origin = Vector2(screensize[0]/2+newpos.x*scalemovement,screensize[1]/2+newpos.y*scalemovement)
		self.transform.origin = Vector2(newpos.x*scalemovement,newpos.y*scalemovement)
	func getCenterOffset(newpos:Vector2) -> Vector2:
		return Vector2(newpos.x*scalemovement,newpos.y*scalemovement)

class Predator extends Agent:
	func _init():
		super._init() # call base class _init
	func _draw(): # godot calls this automatically, then does smart caching
		draw_texture(VIS.triangle,Vector2(-50,-50),Color.RED)


class Prey extends Agent:
	func _init():
		super._init()
	func _draw():
		draw_texture(VIS.hexagon,Vector2(-50,-50),Color.BLUE)


# globals
var file:FileAccess # for reading in a csv file for this visualizer
var predator:Predator
var preys:Array
var trail: VIS.ProgressTrail

# fires automatically
func _ready():
	DisplayServer.window_set_min_size(Vector2(1024,600))
	var screensize = DisplayServer.window_get_min_size()
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if VIS.args.has("--file"):
		file = FileAccess.open(VIS.args["--file"],FileAccess.READ)
		if file == null:
			print("couldn't open file'"+VIS.args["--file"]+"'")
			get_tree().quit()
	else:
		print("Error: --file= csv not provided")
		get_tree().quit()
	predator = Predator.new()
	self.add_child(predator)
	predator.translate(Vector2(screensize[0]/2,screensize[1]/2))
	trail = VIS.ProgressTrail.new(92)
	predator.add_child(trail)

	## easy way of drawing some lines
	var grid = Grid.new(800, 800, 10, 10)
	self.add_child(grid)


func _process(delta):
	OS.delay_msec(30)
	#OS.delay_msec(10) # use this to slow it down to a constant FPS
	var no_match:bool = true
	while not file.eof_reached() and no_match:
		no_match = false # assume we will match a csv chunk (looking for 'positional' in this case)
		var line_items = file.get_csv_line() # returns array of strings for 1 line
		var num_food:int
		match line_items[0]: # this is a gdscript switch block
			"positional":
				line_items = file.get_csv_line()
				var predpos := Vector2(float(line_items[0]), float(line_items[1]))
				#trail.add(predator.getCenterOffset(predpos))
				predator.gotoCenterOffset( predpos )
				predator.rotation = float(line_items[2])
				num_food = int(file.get_csv_line()[0])
				# create prey items if we haven't done that yet AND ALSO set positions
				if (preys.size() == 0):
					preys.resize(num_food)
					for i in range(num_food):
						preys[i] = Prey.new()
						line_items = file.get_csv_line()
						self.add_child(preys[i])
						preys[i].gotoCenterOffset( Vector2(float(line_items[0]), float(line_items[1])) )
					# ensure predator is drawn on top
					remove_child(predator)
					add_child(predator)
				# otherwise only move the positions
				else:
					for i in range(num_food):
						line_items = file.get_csv_line()
						# [strength/quantity, x, y] (so we skip strength)
						preys[i].gotoCenterOffset( Vector2(float(line_items[1]), float(line_items[2])) )
			_: # in c++, this is 'default:'
				no_match = true # if we got default, then we didn't match
	if file.eof_reached():
		get_tree().quit()


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
