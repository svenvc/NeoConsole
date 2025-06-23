"
Show the source code of a class or method

show <Class> - show the definition of <Class>
show <Class>>>#<Method> - show the source code of <Method> in <Class>

Examples

show Point

- show the definition of Point

show Point>>#hash

- show the source code of the method #hash of class Point

show Character class>>#euro

- show the source code of the class method #euro of class Point



"
Class {
	#name : 'NeoConsoleShowCommand',
	#superclass : 'NeoConsoleCommand',
	#category : 'Neo-Console-Core',
	#package : 'Neo-Console-Core'
}

{ #category : 'accessing' }
NeoConsoleShowCommand class >> prefix [
	^ 'show'
]

{ #category : 'public' }
NeoConsoleShowCommand >> execute [
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
]

{ #category : 'initialization-release' }
NeoConsoleShowCommand >> on: input [
	super on: input.
	(self argument beginsWith: self class prefix)
		ifTrue: [ arguments := Array with: (self argument allButFirst: self class prefix size) trimBoth ]
]
