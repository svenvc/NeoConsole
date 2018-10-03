initialization-release
on: input
	super on: input.
	(self argument beginsWith: self class prefix)
		ifTrue: [ arguments := Array with: (self argument allButFirst: self class prefix size) trimBoth ]
	