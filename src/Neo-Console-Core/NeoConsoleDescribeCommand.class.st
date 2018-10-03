"
Describe the result of the last evaluation
showing the structure of that object

You can use the single character alias =

describe - describe the result of the last evaluation

Examples

eval 1@2

- create a new Point

describe

- show the structure of the Point we just created

"
Class {
	#name : #NeoConsoleDescribeCommand,
	#superclass : #NeoConsoleCommand,
	#category : 'Neo-Console-Core'
}

{ #category : #testing }
NeoConsoleDescribeCommand class >> handlesLine: line [
	^ line first = $= or: [ super handlesLine: line ]
]

{ #category : #accessing }
NeoConsoleDescribeCommand class >> prefix [
	^ 'describe'
]

{ #category : #public }
NeoConsoleDescribeCommand >> execute [
	| object |
	object := NeoConsole last.
	result := String streamContents: [ :out |
		out << 'self: '; << (self printLimited: [ object ]); cr.
		out << 'class: '; << object class name; cr.
		object class allInstVarNames do: [ :each |
			out << each; << ': '; << (self printLimited: [ object instVarNamed: each ]); cr ].
		object class isVariable ifTrue: [
			object size <= 20
				ifTrue: [
					1 to: object size do: [ :index |
						out print: index; << ': '; << (self printLimited: [ object at: index ]); cr ] ]
				ifFalse: [ 
					1 to: 10 do: [ :index |
						out print: index; << ': '; << (self printLimited: [ object at: index ]); cr ].
					out << '...'; cr.
					object size - 10 to: object size do: [ :index |
						out print: index; << ': '; << (self printLimited: [ object at: index ]); cr ] ] ] ]
]

{ #category : #'initialization-release' }
NeoConsoleDescribeCommand >> on: input [
	super on: input.
	arguments := self argument findTokens: Character separators.
	arguments := arguments allButFirst 
]

{ #category : #private }
NeoConsoleDescribeCommand >> printLimited: valuable [ 
	^ [ valuable value printStringLimitedTo: 64 ] on: Error do: [ '<error while printing>' ]
]
