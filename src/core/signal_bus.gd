extends Node

signal microwave_start(item: Microwave.Item, wait_time: float)
signal microwave_done(item: Microwave.Item)
signal slow_applied(time_scale: float)
signal player_died
signal microwave_mouse_entered
signal microwave_mouse_exited
signal health_updated(health: int)
signal healed
signal slow_done
signal gameover
