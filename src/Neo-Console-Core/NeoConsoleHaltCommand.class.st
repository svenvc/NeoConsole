"
Halt

Quit the image itself, without saving.

halt - Quit the image

"
Class {
	#name : 'NeoConsoleHaltCommand',
	#superclass : 'NeoConsoleCommand',
	#category : 'Neo-Console-Core',
	#package : 'Neo-Console-Core'
}

{ #category : 'accessing' }
NeoConsoleHaltCommand class >> prefix [
	^ 'halt'
]

{ #category : 'public' }
NeoConsoleHaltCommand >> execute [
	Smalltalk quitPrimitive 
]
