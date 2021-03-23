"
Save the image

save - save the image (do not quit)
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
	resuming ifFalse: [ result := 'Image saved.' ]
]
