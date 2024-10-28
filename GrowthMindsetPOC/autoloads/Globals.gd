extends Node

const TILE_SIZE: Vector2 = Vector2i(32, 32)

func strip_instance_id(input: String) -> String:
	return input.split("_")[0].to_lower()


## Generates n random numbers in which the sum is less than max_num
## Only append results 1 or greater
func generate_numbers(n: int, max_sum: int) -> Array:
	var numbers = []
	var current_sum = 0

	while numbers.size() < n and current_sum < max_sum:
		# Generate a number in the range [0, max_sum]
		var new_number = randi_range(0, max_sum)
		
		if new_number >= 1 and current_sum + new_number <= max_sum:
			numbers.append(new_number)
		current_sum += new_number

	return numbers
