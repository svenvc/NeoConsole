"
Evaluate a Pharo expression

eval <expression>
<expression>*
<empty line>
- evaluate a multi line expression and show the result

Eval is normally the default command, no need to type 'eval'

eval 1+2

- evaluate the expression 1+2

(1 to: 10) collect: [ :each |
  each * each ]

- evaluate the multi line expression, doubling the numbers 1 to 10 in a collection
"
Class {
	#name : #NeoConsoleEvalCommand,
	#superclass : #NeoConsoleCommand,
	#category : 'Neo-Console-Core'
}

{ #category : #testing }
NeoConsoleEvalCommand class >> isSingleLine [
	^ false
]

{ #category : #accessing }
NeoConsoleEvalCommand class >> prefix [
	^ 'eval'
]

{ #category : #public }
NeoConsoleEvalCommand >> execute [
	result := String 
		streamContents: [ :out | 
			[ 	| compiler evaluationResult |
				compiler := self class compiler.
				NeoConsole history add: self argument.
				evaluationResult := compiler evaluate: self argument.
				NeoConsole lastResult: evaluationResult. 
				out print: evaluationResult ]
					on: Error , SyntaxErrorNotification 
					do: [ :exception | self logException: exception on: out ] ]
		limitedTo: self outputLimit.
	result size < self outputLimit 
		ifFalse: [ result := result , ' ... (truncated) ...' ]
]

{ #category : #'initialization-release' }
NeoConsoleEvalCommand >> on: input [
	super on: input.
	(self argument beginsWith: self class prefix)
		ifTrue: [ arguments := Array with: (self argument allButFirst: self class prefix size) trimBoth ]
]

{ #category : #accessing }
NeoConsoleEvalCommand >> outputLimit [
	^ 16384
]
