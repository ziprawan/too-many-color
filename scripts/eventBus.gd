# The EventBus global class is used to let nodes communicate via signals
extends Node

# Changes game speed by ratio
signal change_game_speed(ratio : float)
# Changes player movement speed by ratio
signal change_player_move_speed(ratio : float)
# Changes how often droplets dropo by ratio
signal change_droplet_rate(ratio : float)
# Changes droplet velocity by ratio
signal change_droplet_velocity(ratio : float)
# Reduces how many rain drops can fall per cycle
signal reduce_droplet_count(reduce_by : int)
# Inverses colors before blending
signal toggle_inverse_blend
# Colors that P1 catches go to P2 and vice versa
signal uno_reverse

# Emitted when a new round starts
signal round_start(round_number: int)
# Emitted when a round ends
signal round_end
# Emitted when a set starts
signal set_start(set_number: int)
# Emitted when a set ends
signal set_end
# Emitted when current game ends
signal game_over
# Buat countdown
signal countdown_over
# Broadcast what event has started
signal event_started(event : Event)

# Emit to change a background group's color
signal change_background_color(group : int, color : Color)
