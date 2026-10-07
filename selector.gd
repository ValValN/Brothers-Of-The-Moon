extends Control

@export var Personajes: Array[CharacterData]
 
@onready var spr = $Sprite2D2

@onready var cursor = $Cursor

@onready var animation_player = $Intro
@onready var musica = $Title


var cont: int = 0

func _ready():
	musica.stream.loop = true  # que repita
	musica.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	cursor.z_index = 100
	
	spr.texture = Personajes[0].Imagen

func _process(delta):

	cursor.global_position = get_global_mouse_position().round()

func sig() -> void:
	cont += 1
	if cont>= Personajes.size():
		cont = 0	
	spr.texture = Personajes[cont].Imagen
	
func ant() -> void:
	cont -= 1
	if cont<0:
		cont = Personajes.size()-1	
	spr.texture = Personajes[cont].Imagen
		
func select() ->void:
	Global.currentPlayer = Personajes[cont].Scene

func _on_siguiente_pressed() -> void:
	sig()


func _on_seleccionar_pressed() -> void:
	select()
	get_tree().change_scene_to_file("res://Escenas/intro.tscn")


func _on_anterior_pressed() -> void:
	ant()
