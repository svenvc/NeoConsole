"
Command line handler to invoke the NeoConsole REPL (read-eval-print-loop).

Usage: NeoConsole repl

Type help inside the REPL for more information, type quit to leave the REPL.
You can persist your changes by saving the image, type save.

Examples:

	pharo Pharo.image NeoConole repl
"
Class {
	#name : #NeoConsoleCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Neo-Console-Core'
}

{ #category : #accessing }
NeoConsoleCommandLineHandler class >> commandName [
	^ 'NeoConsole'
]

{ #category : #accessing }
NeoConsoleCommandLineHandler class >> description [
	^ 'Invoke the NeoConsole repl (read-eval-print-loop)'
]

{ #category : #activation }
NeoConsoleCommandLineHandler >> activate [
	self activateHelpWithoutArguments
		ifTrue: [ ^ self ].
	self arguments first = 'repl'
		ifTrue: [
			NeoConsole repl.
			^ self exitSuccess ].
	self exitFailure: 'Unknown subcommand: ' , self arguments first
]
