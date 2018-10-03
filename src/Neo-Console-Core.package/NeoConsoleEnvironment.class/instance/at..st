accessing
at: key
	"Return my value for key.
	Signal NotFound if I do not know key."
	
	^ environment at: key