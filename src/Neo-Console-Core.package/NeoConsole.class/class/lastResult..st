accessing
lastResult: anObject
	| results |
	results := self results.
	anObject = results ifTrue: [ ^ results ].
	results at: 1 put: (results at: 2).
	results at: 2 put: (results at: 3).
	results at: 3 put: anObject.
	^ results