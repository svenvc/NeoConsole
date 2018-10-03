"
Add a method to a class

add <class>
<selectorAndArguments>
<source>*
<empty line>
- add (compile) selectorAndArguments with source to (in) class

Examples

add FooBar
test1
  ^ true

- add an instance method #test1 to FooBar that returns true

add FooBar class
example1
  ^ self new

- add a class method #example1 to FooBar that creates a new instance of FooBar

"
Class {
	#name : #NeoConsoleAddCommand,
	#superclass : #NeoConsoleCommand,
	#category : 'Neo-Console-Core'
}

{ #category : #testing }
NeoConsoleAddCommand class >> isSingleLine [
	^ false
]

{ #category : #accessing }
NeoConsoleAddCommand class >> prefix [
	^ 'add'
]

{ #category : #public }
NeoConsoleAddCommand >> execute [
	| lines targetClass source |
	(lines := self argument lines) ifEmpty: [ ^ result := self class comment ].
	targetClass := Smalltalk globals
		at: (lines first findTokens: ' ') first asSymbol
		ifAbsent: [ ^ result := 'Class ' , lines first , ' not found' ].
	(lines first findTokens: ' ') last = 'class'
		ifTrue: [ targetClass := targetClass class ].
	source := Character cr join: lines allButFirst.
	result := String
		streamContents: [ :out | 
			[ | compileResult |
			compileResult := targetClass compile: source.
			NeoConsole lastResult: compileResult.
			out print: compileResult ]
				on: Error , SyntaxErrorNotification
				do: [ :exception | self logException: exception on: out ] ]
]

{ #category : #'initialization-release' }
NeoConsoleAddCommand >> on: input [
	super on: input.
	(self argument beginsWith: self class prefix)
		ifTrue: [ arguments := Array with: (self argument allButFirst: self class prefix size) trimBoth ]
	
]
