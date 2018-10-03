"
Quit

You can also hit <ENTER> (input an empty line) or enter <CTRL-D><ENTER>.

quit - Quit the REPL

"
Class {
	#name : #NeoConsoleQuitCommand,
	#superclass : #NeoConsoleCommand,
	#category : 'Neo-Console-Core'
}

{ #category : #testing }
NeoConsoleQuitCommand class >> handlesLine: line [
	^ line first = Character end "Ctrl-D" or: [ super handlesLine: line ]
]

{ #category : #accessing }
NeoConsoleQuitCommand class >> prefix [
	^ 'quit'
]

{ #category : #public }
NeoConsoleQuitCommand >> execute [
	result := 'Bye!'.
	^ nil
]
