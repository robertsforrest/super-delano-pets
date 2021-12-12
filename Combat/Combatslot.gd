extends Node2D

# ---------------
# - Member data -
# ---------------
onready var pet = null
export var next_slot_path:NodePath # Slots are implemented as nodes in a singly-linked list
onready var next_slot = get_node(next_slot_path)

# --------------
# - Initialize -
# --------------
func _ready():
	pass

# -------------
# - Functions -
# -------------
# Returns pointer to the old value of pet
func set_pet(new_pet):
	var old_pet = pet
	# Being passed a null value is an expected behavior to let the
	# slot know to remove its pet and dirty the pointer
	# This makes the cascading queue system way less of a pain in the dick to implement
	if (!is_instance_valid(new_pet)):
		remove_pet()
		return old_pet
	# When provided a valid pet, simply reparent
	if (is_instance_valid(new_pet.get_parent())):
		new_pet.get_parent().remove_child(new_pet)
	remove_child(old_pet)
	pet = new_pet
	add_child(pet)
	return old_pet

# Yoinks the current pet, returning it as a pointer
func remove_pet():
	var old_pet = pet
	remove_child(pet)
	pet = null # Dirty the pointer for is_instance_valid checks
	return old_pet

# Returns pointer to the currently active pet
func get_pet():
	return pet

# Returns pointer to the next slot in the list
func get_next_slot():
	return next_slot
