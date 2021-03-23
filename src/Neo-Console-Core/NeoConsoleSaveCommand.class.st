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
	Smalltalk snapshot: true andQuit: false.
	result := 'Image saved.'.
]
