protocol
readInputFrom: stream
	| input lineReader line commandClass |
	lineReader := ZnFastLineReader on: stream.
	line := [ lineReader nextLine trimBoth ] on: ConnectionClosed, ConnectionTimedOut do: [ nil ].
	line isEmptyOrNil ifTrue: [ ^ NeoConsoleQuitCommand new ].
	commandClass := NeoConsoleCommand forLine: line.
	commandClass isSingleLine
		ifTrue: [ ^ commandClass new on: line; yourself ].
	input := String new writeStream.
	input nextPutAll: line; cr.
	[ 
		line := [ lineReader nextLine trimBoth ] on: ConnectionClosed, ConnectionTimedOut do: [ '' ].
		input nextPutAll: line; cr.
		line isEmpty ] whileFalse.
	^ commandClass new on: input contents; yourself