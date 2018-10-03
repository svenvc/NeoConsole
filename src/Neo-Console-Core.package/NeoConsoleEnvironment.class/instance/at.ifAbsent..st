accessing
at: key ifAbsent: block
	"Return my value for key.
	Return the value of evaluating block in case I do not know key."
	
	^ environment at: key ifAbsent: block