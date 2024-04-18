extends Resource

class_name Order

@export var recipe_sprites: Array[Item]
@export var item: Item
@export var item_master_piece: Item
@export var expire_time_in_seconds: float

@export var deliver_values : Dictionary = {
	"Good": 3,
	"Ok": 2,
	"Meh": 1
}
