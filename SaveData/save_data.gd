extends Node

# User settings
var music_volume: int
var effects_volume: int
var fullscreen: bool

# State to handle progression
var seen_dialogue: Array[String] = []
var bijection_levels_done: Array[int] = []

# Updates the data in memory with that on disk. Must be called each time the game is launched
func read() -> void:
	# Make a new file to store the config in
	var config: ConfigFile = ConfigFile.new()
	
	# Attempt to load existing file
	var err: Error = config.load("user://data.cfg")

	# If no such file exists, there's no need to load anything. A file will be created once write() is called, but we don't need one yet.
	if err != OK:
		return

	# Update current data with the data from disk
	music_volume = config.get_value("settings", "music_volume", 50)
	effects_volume = config.get_value("settings", "effects_volume", 50)
	fullscreen = config.get_value("settings", "fullscreen", true)
	seen_dialogue.assign(config.get_value("progress", "seen_dialogue", []))


# Updates the data on disk to match that on memory. Must be called each time data is updated (not just when the game is quit)
func write() -> void:
	# Make a new file to store the config in
	var config: ConfigFile = ConfigFile.new()

	# Update the settings
	config.set_value("settings", "music_volume", music_volume)
	config.set_value("settings", "effects_volume", effects_volume)
	config.set_value("settings", "fullscreen", fullscreen)
	config.set_value("progress", "seen_dialogue", seen_dialogue)

	# Write to disk
	config.save("user://data.cfg")

