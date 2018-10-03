public
execute
	self hasArguments 
		ifTrue: [ | thing |
			thing := [ self class compiler evaluate: self argument ] on: Exception do: [ nil ].
			thing
				ifNil: [ result := 'Not a class or method ', self argument ]
				ifNotNil: [ 
					result := 'Not a class or method ', thing printString.
					thing isClass 
						ifTrue: [ result := thing definition ].
					(thing respondsTo: #sourceCode)
						ifTrue: [ result := thing printString, String cr, thing sourceCode ] ] ]
		ifFalse: [ 
			result := self class comment ]