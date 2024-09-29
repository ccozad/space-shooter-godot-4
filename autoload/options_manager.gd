extends Node

const options_path = "user://options.data"

func read_options():
	var options = {}
	var file = FileAccess.open(options_path, FileAccess.READ)
	if file:
		options = file.get_var()
		file.close()
	return options

func write_options(options):
	var file = FileAccess.open(options_path, FileAccess.WRITE)
	file.store_var(options)
	file.close()
