extends BaseRoom

func enter_from(from: String, player: PlayerState, animate_door: bool = false):
	_enter_player(player)
	match from:
		"LinkRoom":
			player.set_position(RIGHT_ENTER_POS)
