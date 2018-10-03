printing
printOn: stream
	super printOn: stream.
	stream << $(.
	self isRunning ifTrue: [ stream << #running; space; << self port ].
	stream << $)