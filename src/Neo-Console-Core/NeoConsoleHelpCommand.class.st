"
Get some minimal help

You can use the single character alias ?

help - list all commands
help <command> - print help about <command>
"
Class {
	#name : #NeoConsoleHelpCommand,
	#superclass : #NeoConsoleCommand,
	#category : 'Neo-Console-Core'
}

{ #category : #testing }
NeoConsoleHelpCommand class >> handlesLine: line [
	^ line first = $? or: [ super handlesLine: line ]
]

{ #category : #accessing }
NeoConsoleHelpCommand class >> prefix [
	^ 'help'
]

{ #category : #public }
NeoConsoleHelpCommand >> execute [
	self hasArguments 
		ifTrue: [ 
			(NeoConsoleCommand knownCommands 
					detect: [ :each | each prefix = self argument ] ifNone: [ nil ])
				ifNil: [ result := 'unknown command <{1}>' format: { self argument } ] 
				ifNotNil: [ :command | result := command helpText ] ]
		ifFalse: [ 
			result := String streamContents: [ :out |
				out << 'help <command>'; cr.
				out << 'known commands are:'; cr.
				NeoConsoleCommand knownCommands 
					do: [ :each | 
						out space; space; << each prefix.
						NeoConsoleCommand defaultCommand = each ifTrue: [ out << ' DEFAULT' ] ] 
					separatedBy: [ out cr ] ] ]
]

{ #category : #'initialization-release' }
NeoConsoleHelpCommand >> on: input [
	super on: input.
	arguments := self argument findTokens: Character separators.
	arguments := arguments allButFirst 
]
