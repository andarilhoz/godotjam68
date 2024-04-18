extends Resource

class_name Order

@export var recipe_sprites: Array[Item]
@export var item: Item
@export var expire_time_in_seconds: float

@export var deliver_values = {
	"Good": 25,
	"Ok": 15,
	"Meh": 5
}
