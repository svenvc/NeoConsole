protocol
executeRequestResponseLoopOn: stream
	| in out command executeResult |
	in := ZnCharacterReadStream on: stream.
	out := ZnCharacterWriteStream on: stream.
	self writeLine: ('Neo Console ', SystemVersion current asString) to: out.
	[
		stream nextPutAll: 'pharo> '; flush.
		command := (self readInputFrom: in).
		executeResult := [ command execute ] 
			on: Error 
			do: [ :exception | command printString, ' failed with ', exception printString ].
		self writeOutput: command result to: out.
		executeResult notNil	] whileTrue