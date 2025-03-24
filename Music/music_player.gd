extends AudioStreamPlayer

# Plays audio in the background in all scenes. Always loops, so there is always something playing.

const VOLUME_SCALE_MAX_DB: int = 12 # a scale from -12 to +12 dB. Note that 0 manually turns it off

var defaultStream: AudioStream = preload("res://Music/Digital Lemonade.mp3")
var queue: Array[AudioStream] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = defaultStream
	play()
	finished.connect(play_next)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	volume_db = (SaveData.music_volume * 2 * VOLUME_SCALE_MAX_DB / 100) - VOLUME_SCALE_MAX_DB

	if SaveData.music_volume == 0:
		stream_paused = true
	else:
		stream_paused = false

# Change the song to something else. There should always be some music playing. This will not re-start the song if it is the same as was already playing.
func change_track(new_track: AudioStream) -> void:
	if new_track != stream:
		stream = new_track
		play()

# Plays the next song. Called when the song finishes.
func play_next() -> void:
	if queue.is_empty():
		play()
	else:
		stream = queue.pop_front()
		queue.push_back(stream)
		play()

# Play a set of tracks in a random order, until the track is changed to something else
func change_track_to_random(list: Array[AudioStream]) -> void:
	list.shuffle()
	queue = list
	play_next()