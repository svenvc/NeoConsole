protocol
executeRequestResponseLoop
	| in out command executeResult |
	in := ZnCharacterReadStream on: FileStream stdin binary.
	out := ZnCharacterWriteStream on: Stdio stdout.
	self writeLine: ('Neo Console ', SystemVersion current asString) to: out.
	[
		out nextPutAll: 'pharo> ' "; flush".
		command := (self readInputFrom: in).
		executeResult := [ command execute ] 
			on: Error 
			do: [ :exception | command printString, ' failed with ', exception printString ].
		self writeOutput: command result to: out.
		executeResult notNil	] whileTrue