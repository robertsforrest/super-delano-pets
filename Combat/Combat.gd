extends Node2D

# -------------
# - Constants -
# -------------
const PLAYER_TEAM_POS = Vector2(0, 128)
const ENEMY_TEAM_POS = Vector2(300, 256)
const TURN_PROCESS_WAIT = 10 # Seconds to wait between each step of combat for animations & such

# ------------------
# - Preload scenes -
# ------------------
onready var combat_team_scene = preload("res://Combat/CombatTeam.tscn")

# ---------------
# - Member data -
# ---------------
var player_team = null
var enemy_team = null

# --------------
# - Initialize -
# --------------
func _ready():
	# TEMP - hard code 2 teams for testing purposes
	player_team = combat_team_scene.instance()
	player_team.position = PLAYER_TEAM_POS
	enemy_team = combat_team_scene.instance()
	enemy_team.facing = 1
	enemy_team.position = ENEMY_TEAM_POS
	add_child(player_team)
	add_child(enemy_team)

# ----------
# - Combat -
# ----------
# Process a single turn
# This is where to hook in any new types of ability triggers from Pet.gd
# TODO: put fucken yield calls here
func process_turn():
	# Pull frontline pets
	var player = player_team.get_team_front()
	var enemy = enemy_team.get_team_front()
	# Call before attack behaviors
	player.before_attack()
	enemy.before_attack()
	# Perform attack calculations
	player.take_damage(enemy.get_atk())
	enemy.take_damage(player.get_atk())
	# Check to determine whether to call got_kill triggers
	if (player.is_alive() && !enemy.is_alive()):
		player.got_kill()
	if (enemy.is_alive() && !player.is_alive()):
		enemy.got_kill()
	# Call after attack behaviors
	if (player.is_alive()):
		player.after_attack()
	if (enemy.is_alive()):
		enemy.after_attack()
	# Reparent pets to slots as needed in the team queues
	player_team.update_queue()
	enemy_team.update_queue()
