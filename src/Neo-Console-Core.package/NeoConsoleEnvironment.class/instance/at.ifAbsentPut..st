accessing
at: key ifAbsentPut: block
	"Return my value for key.
	Store and return the value of evaluating block in case I do not know key."

	^ environment at: key ifAbsentPut: block