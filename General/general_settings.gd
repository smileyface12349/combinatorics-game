extends Node


# When a popup is open, we don't want to process the inputs for anything behind it
var is_popup_open: bool = false
var car_position: Vector2 = Vector2(0, 0)
var boat_position: Vector2 = Vector2(0, 0)