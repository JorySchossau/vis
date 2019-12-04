extends Node

## Description
# this script reads in a CSV file,
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

var file:File

## used in example of easy way to draw lines
#class Grid extends Node2D:
#    func _draw():
#        for i in range(100):
#            draw_line(Vector2(10*i,0),Vector2(10*i,300),Color.white)
#        for i in range(100):
#            draw_line(Vector2(0,10*i),Vector2(300,10*i),Color.white)

## used in example of bit more efficient way to draw lines
#class Line extends Node2D:
#    func _draw():
#        # VIS.line is a 1x1 white pixel
#        draw_texture(VIS.line,Vector2(0,0),Color.white)

## base class for Predator and Prey
class Agent extends Node2D:
    const scalemovement:int = 6
    const scalesize:float = 0.2
    var screensize:Vector2 # compact array of floats
    func _init():
        screensize = OS.get_window_size()
        self.scale = Vector2(scalesize,scalesize)
    func gotoCenterOffset(newpos:Vector2):
        # assume newpos is an offset from 0,0,
        # but we want 0,0 to  appear to be the center of the screen
        self.transform.origin = Vector2(screensize[0]/2+newpos.x*scalemovement,screensize[1]/2+newpos.y*scalemovement)

class Predator extends Agent:
    func _init():
        ._init() # call base class _init
    func _draw(): # godot calls this automatically, then does smart caching
        draw_texture(VIS.triangle,Vector2(-50,-50),Color.red)

var predator:Predator

class Prey extends Agent:
    func _init():
        ._init()
    func _draw():
        draw_texture(VIS.hexagon,Vector2(-50,-50),Color.blue)

var preys:Array

# fires automatically
func _ready():
    OS.window_size = Vector2(1024,600)
    var screensize = OS.get_window_size() # should be identical
    # some fullscreen useful commands
    #OS.window_fullscreen = true
    #get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,SceneTree.STRETCH_ASPECT_EXPAND,Vector2(1920,1080))
    if VIS.args.has("--file"):
        file = File.new()
        var openok = file.open(VIS.args["--file"],File.READ)
        if openok != 0:
            print("couldn't open file'"+VIS.args["--file"]+"'")
            get_tree().quit()
    else:
        print("Error: --file= csv not provided")
        get_tree().quit()
    predator = Predator.new()
    self.add_child(predator)
    predator.translate(Vector2(screensize[0]/2,screensize[1]/2))

    ## easy way of drawing lines
    #var grid = Grid.new()
    #self.add_child(grid)

    ## bit more efficient way of drawing lines
    ## example of making horizontal lines
    #for i in range(100):
    #    var l1 = Line.new()
    #    self.add_child(l1)
    #    l1.translate(Vector2(0,10*i))
    #    l1.scale = Vector2(300,1)
    ## example of making vertical lines
    #for i in range(100):
    #    var l1 = Line.new()
    #    self.add_child(l1)
    #    l1.translate(Vector2(10*i,0))
    #    l1.scale = Vector2(1,300)

# example of user input
#func _input(event):
#    if Input.is_key_pressed(KEY_Q): # this behavior (and ESC) exists already
#        get_tree().quit() # quits the visualizer

func _process(delta):
    #OS.delay_msec(10) # use this to slow it down to a constant FPS
    var no_match:bool = true
    while not file.eof_reached() and no_match:
        no_match = false # assume we will match a csv chunk (looking for 'positional' in this case)
        var line_items = file.get_csv_line() # returns array of strings for 1 line
        var num_food:int
        match line_items[0]: # this is a gdscript switch block
            "positional":
                line_items = file.get_csv_line()
                predator.gotoCenterOffset( Vector2(float(line_items[0]), float(line_items[1])) )
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
