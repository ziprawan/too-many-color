extends Node

var time_start = 0

func _ready() -> void:
	time_start = Time.get_unix_time_from_system()

func rgb_to_xyz(rgb: Color, normalized = true):
	var r = rgb.r
	var g = rgb.g
	var b = rgb.b
	var x = 0.412453 * r + 0.357580 * g + 0.180423 * b
	var y = 0.212671 * r + 0.715160 * g + 0.072169 * b
	var z = 0.019334 * r + 0.119193 * g + 0.950227 * b

	if normalized: return [x / 95.047, y / 100.0, z / 108.883]
	else: return [x, y, z]

func transform(x: float):
	const delta = 6.0 / 29.0
	if x > (delta) ** 3:
		return x ** (1.0 / 3.0)
	else:
		return x / (3 * delta ** 2) + 4.0 / 29.0

func get_deltaE(c1: Color, c2: Color):
	var xyz1 = rgb_to_xyz(c1)
	var xyz2 = rgb_to_xyz(c2)
	var lab1 = [116 * transform(xyz1[1]) - 16, 500 * (transform(xyz1[0]) - transform(xyz1[1])), 200 * (transform(xyz1[1]) - transform(xyz1[2]))]
	var lab2 = [116 * transform(xyz2[1]) - 16, 500 * (transform(xyz2[0]) - transform(xyz2[1])), 200 * (transform(xyz2[1]) - transform(xyz2[2]))]
	return sqrt((lab2[0] - lab1[0]) ** 2 + (lab2[1] - lab1[1]) ** 2 + (lab2[2] - lab1[2]) ** 2)

func round_to_dec(num: float, digit: int):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func get_elapsed_time():
	return Time.get_unix_time_from_system() - time_start
