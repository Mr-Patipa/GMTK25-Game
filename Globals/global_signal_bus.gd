extends Node

@warning_ignore("unused_signal")
signal wheel_was_spun
@warning_ignore("unused_signal")
signal player_saved
@warning_ignore("unused_signal")
signal player_readyed
@warning_ignore("unused_signal")
signal time_change_notified
@warning_ignore("unused_signal")
signal time_ran_out
@warning_ignore("unused_signal")
signal not_much_time_left
@warning_ignore("unused_signal")
signal time_updated
@warning_ignore("unused_signal")
signal game_ended
@warning_ignore("unused_signal")
signal dialogue_triggered
@warning_ignore("unused_signal")
signal dialogue_sent
@warning_ignore("unused_signal")
signal dialogue_name_sent
@warning_ignore("unused_signal")
signal player_has_died
@warning_ignore("unused_signal")
signal difficulty_changed
@warning_ignore("unused_signal")
signal wheel_dialogue_needed
@warning_ignore("unused_signal")
signal dialogue_opened
@warning_ignore("unused_signal")
signal player_collided


var GameWon : bool = false
var BestTime : int
var MostTime : int
var CurrentTime : int


func _ready() -> void:
	CurrentTime = 0
