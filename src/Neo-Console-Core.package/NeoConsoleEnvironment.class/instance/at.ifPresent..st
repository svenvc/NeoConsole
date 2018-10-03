accessing
at: key ifPresent: block
	"Return the value of evaluating block with my value for key.
	Return self, in effect do nothing, in case I do not know key."

	^ environment at: key ifPresent: block