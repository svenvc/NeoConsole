accessing
at: key put: value
	"I will store value for key.
	Return value."
	
	^ environment at: key asSymbol put: value