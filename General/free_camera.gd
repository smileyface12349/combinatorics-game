extends Camera2D

var move_camera: bool = false
var last_mouse_position: Vector2

const min_zoom: Vector2 = Vector2(0.3, 0.3)
const max_zoom: Vector2 = Vector2(2, 2)
const min_pos: Vector2 = Vector2(0, 0)
const max_pos: Vector2 = Vector2(30000, 2000)
const keyboard_move_amount: Vector2 = Vector2(1500, 250)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	# Middle mouse button to move camera
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_MIDDLE:
		# Pressed
		if event.pressed:
			move_camera = true
		# Released
		else:
			move_camera = false
			
	# Middle mouse button scroll
	if Input.is_action_just_released("zoom_in"):
		# Zoom around mouse position by ensuring the mouse does not move in world space
		var mouse_before_zoom: Vector2 = get_global_mouse_position()
		self.zoom *= 1.1
		if self.zoom > max_zoom:
			self.zoom = max_zoom
		self.position += mouse_before_zoom - get_global_mouse_position()
	if Input.is_action_just_released("zoom_out"):
		# Zoom around mouse position by ensuring the mouse does not move in world space
		var mouse_before_zoom: Vector2 = get_global_mouse_position()
		self.zoom *= 0.9
		if self.zoom < min_zoom:
			self.zoom = min_zoom
		self.position += mouse_before_zoom - get_global_mouse_position()
		
	# Keyboard control
	if Input.is_action_just_pressed("ui_left"):
		self.position.x -= keyboard_move_amount.x
	if Input.is_action_just_pressed("ui_right"):
		self.position.x += keyboard_move_amount.x
	if Input.is_action_just_pressed("ui_up"):
		self.position.y -= keyboard_move_amount.y
	if Input.is_action_just_pressed("ui_down"):
		self.position.y += keyboard_move_amount.y
	if Input.is_action_just_pressed("zoom_out_key"):
		# Zoom out around centre of screen
		self.zoom *= 0.8
		if self.zoom < min_zoom:
			self.zoom = min_zoom
	if Input.is_action_just_pressed("zoom_in_key"):
		# Zoom in around centre of screen
		self.zoom *= 1.3
		if self.zoom > max_zoom:
			self.zoom = max_zoom
		
		
func _process(_delta: float) -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	if mouse_position != last_mouse_position:
		if move_camera:
			self.position -= (mouse_position - last_mouse_position) / self.zoom.x
			if self.position.x < min_pos.x:
				self.position.x = min_pos.x
			if self.position.y < min_pos.y:
				self.position.y = min_pos.y
			if self.position.x > max_pos.x:
				self.position.x = max_pos.x
			if self.position.y > max_pos.y:
				self.position.y = max_pos.y
		last_mouse_position = mouse_position
		queue_redraw()
