"
I am NeoConsoleCommand. I describe a command that can be executed by the NeoConsole infrastructure. I am abstract.

The class comments of my subclasses are used as help texts in the command line interface.
"
Class {
	#name : #NeoConsoleCommand,
	#superclass : #Object,
	#instVars : [
		'arguments',
		'result'
	],
	#category : 'Neo-Console-Core'
}

{ #category : #accessing }
NeoConsoleCommand class >> defaultCommand [
	^ NeoConsoleEvalCommand 
]

{ #category : #accessing }
NeoConsoleCommand class >> forLine: line [
	| commandClass |
	commandClass := self knownCommands 
		detect: [ :each | each handlesLine: line ] 
		ifNone: [ self defaultCommand ].
	^ commandClass
]

{ #category : #testing }
NeoConsoleCommand class >> handlesLine: line [
	^ line beginsWith: self prefix
]

{ #category : #accessing }
NeoConsoleCommand class >> helpText [
	^ String streamContents: [ :out |
			out << self name; cr.
			self comment linesDo: [ :each | 
				out space; space; << each; cr ] ]
]

{ #category : #testing }
NeoConsoleCommand class >> isMultiLine [
	^ self isSingleLine not
]

{ #category : #testing }
NeoConsoleCommand class >> isSingleLine [
	^ true
]

{ #category : #accessing }
NeoConsoleCommand class >> knownCommands [
	^ self subclasses
]

{ #category : #accessing }
NeoConsoleCommand class >> prefix [
	^ self subclassResponsibility 
]

{ #category : #accessing }
NeoConsoleCommand >> argument [
	^ arguments first
]

{ #category : #accessing }
NeoConsoleCommand >> arguments [
	^ arguments 
]

{ #category : #public }
NeoConsoleCommand >> execute [
	self subclassResponsibility 
]

{ #category : #testing }
NeoConsoleCommand >> hasArguments [
	^ arguments notNil and: [ arguments notEmpty ]
]

{ #category : #private }
NeoConsoleCommand >> logException: exception on: out [
	out print: exception; cr.
	exception signalerContext printDetails: out.
	exception signalerContext sender debugStack: 8 on: out
]

{ #category : #'initialization-release' }
NeoConsoleCommand >> on: input [
	arguments := Array with: input trimBoth
]

{ #category : #accessing }
NeoConsoleCommand >> result [
	^ result
]
