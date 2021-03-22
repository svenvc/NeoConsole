"
I am a class facade offering access to some global state held by the NeoConsole package.

I hold the history of all evaluated commands.

I hold the last 3 results.

I offer quick access to NeoConsoleEnvironment current and NeoConsoleStdio run.
"
Class {
	#name : #NeoConsole,
	#superclass : #Object,
	#classVars : [
		'History',
		'Results'
	],
	#category : #'Neo-Console-Core'
}

{ #category : #accessing }
NeoConsole class >> clearResults [
	^ self results 
		atAllPut: nil; 
		yourself
]

{ #category : #accessing }
NeoConsole class >> env [
	^ NeoConsoleEnvironment current
]

{ #category : #accessing }
NeoConsole class >> history [
	^ History ifNil: [ History := OrderedCollection new ]
]

{ #category : #accessing }
NeoConsole class >> last [
	^ self results last
]

{ #category : #accessing }
NeoConsole class >> lastResult: anObject [
	| results |
	results := self results.
	anObject = results ifTrue: [ ^ results ].
	results at: 1 put: (results at: 2).
	results at: 2 put: (results at: 3).
	results at: 3 put: anObject.
	^ results
]

{ #category : #accessing }
NeoConsole class >> repl [
	^ NeoConsoleStdio run
]

{ #category : #accessing }
NeoConsole class >> results [
	^ Results ifNil: [ Results := Array new: 3 ]
]

{ #category : #server }
NeoConsole class >> startServer [
	^ NeoConsoleTelnetServer new start
]

{ #category : #server }
NeoConsole class >> startServerOn: port [
	^ NeoConsoleTelnetServer startOn: port
]
