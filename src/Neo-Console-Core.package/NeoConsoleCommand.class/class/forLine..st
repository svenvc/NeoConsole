accessing
forLine: line
	| commandClass |
	commandClass := self knownCommands 
		detect: [ :each | each handlesLine: line ] 
		ifNone: [ self defaultCommand ].
	^ commandClass