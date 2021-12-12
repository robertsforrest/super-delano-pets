extends Node2D

const TEAM_SIZE = 5
const SLOT_SPACING = 72

# ------------
# - Preloads -
# ------------
onready var trollface = preload("res://Pets/Trollface.tscn") # I hate this
onready var fuuu = preload("res://Pets/Fuuu.tscn")

# ---------------
# - Member data -
# ---------------
export var facing = 0 # 0 = left to right (player team), 1 = right to left (enemy team)
onready var front_slot = null
# You may be able to rely on get_children() returning in order which would make this
# useless but for now I'm doing it this way
onready var slots = [$Slot1, $Slot2, $Slot3, $Slot4, $Slot5]

# --------------
# - Initialize -
# --------------
func _ready():
	# Set positioning of slots for combat queue
	# I was lazy and decided to make all of the links for slot nodes export vars so I could just
	# drag and drop them in the editor; if you want to add more slots I'd recommend doing it that
	# way but you could take a crack at doing it programmatically here if you really wanted to
	for n in slots.size():
		if (facing == 0):
			# Orient left-to-right
			# This should work lol idk
			slots[n].position = Vector2((slots.size()*SLOT_SPACING) - (n*SLOT_SPACING), 0)
		else:
			# Orient right-to-left
			slots[n].position = Vector2(n*SLOT_SPACING, 0)
	
	# TEMP DEBUG CODE: populate w/ trollfaces
	for slot in slots:
		slot.set_pet(trollface.instance())
	slots[1].set_pet(fuuu.instance())

# ------------
# - Function -
# ------------
func get_team_front():
	return slots[0].get_pet()

# Updates the team queue after a combat round
# Handles dead pets, reparenting, etc.
func update_queue():
	# Handle individual slots
	for slot in slots:
		if (is_instance_valid(slot.get_pet())):
			# Delete dead pets
			if (!slot.get_pet().is_alive()):
				slot.remove_pet().queue_free()
	# Cascade pets down the queue as needed
	# this is fucked lol I suck at this
	for slot in slots:
		if (is_instance_valid(slot.get_pet())):
			while (is_instance_valid(slot.get_next_slot())
				&& !is_instance_valid(slot.get_next_slot().get_pet())):
				# Cascade through linked list
				slot.get_next_slot().set_pet(slot.get_pet())
				slot.remove_pet()
