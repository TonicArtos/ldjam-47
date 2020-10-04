class_name Story

const text = {
	"msg from future1": """Transmitted: 00:15:23 10 October 3030 EET
	Received: 00:10:18 10 October 3030 EET""",
	
	"msg from future2": "The main ship reactor has malfunctioned and the RIP drive has become unstable. Error code 137: foreign contaminant in the recursion continuum fluid. You must enter the reactor room, remove the contaminant, and repair the fault. The RIP drive will undergo catastrophic meltdown after activation, so you can use it only once. Good luck.",
	
	"look at room1": "room1 description",
	
	"look at battery": """Mini-Fuse 5778K
“The power of the Sun in the palm of your hand.”""",

	"operate rip drive": "You start the rip sequence to head back to civilisation and the RIP Drive thrums to life, but something seems to be wrong. The radio signal appears to have modified its programming. A tiny rip in space tears open before you as you hear the ship's reactor containment alarm begin to sound.",
	
	"look at ripdrive": "The R.I.P. Drive™."
}

static func default_done() -> Option:
	return Option.new(100, "done")

class Option:
	var id: int
	var label: String
	
	func _init(id: int, label: String):
		self.id = id
		self.label = label

class Message:
	var text_id: String
	var options #Option
	
	func _init(text_id: String, options):
		self.options = options
		self.text_id = text_id
