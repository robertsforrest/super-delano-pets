extends Node2D

const MOVE_SPEED = 8.0

# --------------
# - Load nodes -
# --------------
onready var lbl_hp = $HpDisplay/LblHpValue
onready var lbl_atk = $AtkDisplay/LblAtkValue

# -------------
# - Pet stats -
# -------------
export var hp = 1
export var atk = 1
export var ability_string = ""
var item = null

# --------------
# - Initialize -
# --------------
func _ready():
	# Use set_hp and set_dmg here to override hp & atk in children
	pass

# -------------
# - Game loop -
# -------------
func _process(delta):
	# Re-parenting is used to set pet position in the queue;
	# just lerp to 0,0 to inherit the parent's position
	position = position.linear_interpolate(Vector2.ZERO, delta * MOVE_SPEED)

# ----------
# - Battle -
# ----------
# If you want to add more types of ability triggers, i.e. "friend ahead attacks"
# or something to that effect, define it as an empty method here, override it in
# a child script, & add a call to the turn_process flow in Combat.gd

# Called whenever the pet drops below 1hp
func pet_killed():
	pass

# Called before attack is processed
func before_attack():
	pass

# Called after attack is processed
func after_attack():
	pass

# Called when the pet kills a member of the opposing team
func got_kill():
	pass

# Returns a boolean indicating whether this was a death blow
func take_damage(amount):
	set_hp(hp-amount)

# -------------
# - Functions -
# -------------
# Instance a new item for this pet from a preloaded PackedScene
func give_item(item_scene:PackedScene):
	pass

func set_hp(new_hp):
	hp = new_hp
	lbl_hp.set_text(str(hp))
	if (hp <= 0):
		pet_killed()

func set_atk(new_atk):
	atk = new_atk
	lbl_atk.set_text(str(atk))

func get_atk():
	return atk

func get_hp():
	return hp

# Seperating this out in case there ever needs to be a more robust
# determination of what makes a pet alive or dead
# For now it's just a simple HP check
func is_alive():
	return hp > 0
	
