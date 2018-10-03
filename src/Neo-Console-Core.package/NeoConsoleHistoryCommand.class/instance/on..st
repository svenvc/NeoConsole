initialization-release
on: input
	super on: input.
	self argument first = $!
		ifTrue: [ 
			arguments := self argument allButFirst findTokens: Character separators ]
		ifFalse: [ 
			arguments := self argument findTokens: Character separators.
			arguments := arguments allButFirst ]