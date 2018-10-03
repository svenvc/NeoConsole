testing
isRunning
	"Return true when I am running"
	
	^ process notNil and: [ serverSocket notNil ]