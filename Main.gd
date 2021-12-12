extends Node2D

# ------------------
# - Preload scenes -
# ------------------
onready var combat_scene = preload("res://Combat/Combat.tscn")
onready var combat_team_scene = preload("res://Combat/CombatTeam.tscn")

# ---------------
# - Member data -
# ---------------
var current_combat

# --------------
# - Initialize -
# --------------
func _ready():
	# TEMP: hard-code in a couple of teams
	current_combat = combat_scene.instance()
	add_child(current_combat)

# -------------
# - Game loop -
# -------------
func _process(delta):
	# TEMP: press Space to advance 1 round, no animations or nothing just raw calculations
	# Don't press during turn execution - currently no good coroutine management for this
	if (Input.is_action_just_pressed("next_turn") && !current_combat.is_turn_ongoing()):
		current_combat.process_turn()
