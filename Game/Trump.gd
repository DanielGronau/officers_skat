class_name Trump

enum {NONE = -1, ACORN, LEAVES, HEARTS, BELLS, GRAND}

static func as_string(trump: int) -> String:
	match trump:
		ACORN: return "Acorn"
		LEAVES: return "Leaves"
		HEARTS: return "Hearts"
		BELLS: return "Bells"
		GRAND: return "Grand"
		_: return "None" 
