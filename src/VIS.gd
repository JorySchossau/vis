extends Node 

onready var line:Texture = preload("res://line.png")
onready var triangle:Texture = preload("res://3-gon.png")
onready var square:Texture = preload("res://4-gon.png")
onready var pentagon:Texture = preload("res://5-gon.png")
onready var hexagon:Texture = preload("res://6-gon.png")
onready var heptagon:Texture = preload("res://7-gon.png")
onready var octagon:Texture = preload("res://8-gon.png")

var args:Dictionary

func engine_version():
	return(Engine.get_version_info()['hex'])
func pck_version():
	return("0.1")

func update():
	print("checking for updates...")
	ProjectSettings.load_resource_pack("user://")
