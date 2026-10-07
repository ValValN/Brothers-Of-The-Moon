extends Control

@onready var buttons = [
	$Botones/Comenzar,
	$Botones/Salir
]
@onready var cursor = $Cursor
@onready var sfx_hover = $AudioHover
@onready var sfx_click = $AudioClick
@onready var sfx_exit = $AudioExit
@onready var musica = $Title

var index = 0
var can_input = true

func _ready():
	musica.stream.loop = true
	musica.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor.z_index = 100
	
	buttons[0].mouse_entered.connect(_on_comenzar_mouse_entered)
	buttons[1].mouse_entered.connect(_on_salir_mouse_entered)
	
	can_input = false
	await get_tree().process_frame
	update_cursor()
	can_input = true

func _process(delta):
	cursor.global_position = get_global_mouse_position().round() + Vector2(8, 8)
	for i in range(buttons.size()):
		if i == index:
			buttons[i].scale = Vector2(1.05, 1.05)
		else:
			buttons[i].scale = Vector2(1, 1)

func _input(event):
	if !can_input:
		return
	if event.is_action_pressed("ui_down"):
		index = (index + 1) % buttons.size()
		sfx_hover.play()
		update_cursor()
	if event.is_action_pressed("ui_up"):
		index = (index - 1 + buttons.size()) % buttons.size()
		sfx_hover.play()
		update_cursor()
	elif event.is_action_pressed("ui_accept"):
		select_option()

func update_cursor():
	var btn = buttons[index]
	cursor.global_position = btn.global_position + Vector2(-60, btn.size.y / 2 - 10)

func select_option():
	match index:
		0:
			sfx_click.play()
			_on_comenzar_pressed()
		1:
			sfx_exit.play()
			_on_salir_pressed()

func _on_comenzar_mouse_entered() -> void:
	index = 0
	sfx_hover.play()
	update_cursor()

func _on_salir_mouse_entered() -> void:
	index = 1
	sfx_hover.play()
	update_cursor()

func _on_comenzar_pressed() -> void:
	if not can_input:
		return
	can_input = false

	var tree := get_tree()  # Se guarda antes del await, mientras el nodo está en el árbol
	sfx_click.play()
	await sfx_click.finished

	if not is_instance_valid(self):
		return
	tree.change_scene_to_file("res://Escenas/selector.tscn")

func _on_salir_pressed() -> void:
	can_input = false
	sfx_exit.play()
	await sfx_exit.finished
	get_tree().quit()
