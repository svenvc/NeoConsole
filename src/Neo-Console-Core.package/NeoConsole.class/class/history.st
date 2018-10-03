accessing
history
	^ History ifNil: [ History := OrderedCollection new ]