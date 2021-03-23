"
Save the image

save - save the image and quit
"
Class {
	#name : #NeoConsoleSaveCommand,
	#superclass : #NeoConsoleCommand,
	#category : #'Neo-Console-Core'
}

{ #category : #accessing }
NeoConsoleSaveCommand class >> prefix [
	^ 'save'
]

{ #category : #public }
NeoConsoleSaveCommand >> execute [
	| resuming |
	resuming := Smalltalk snapshot: true andQuit: false.
	resuming
		ifTrue: [ ^ nil "will quit the loop" ] 
		ifFalse: [ result := 'Image saved.' ]
]
