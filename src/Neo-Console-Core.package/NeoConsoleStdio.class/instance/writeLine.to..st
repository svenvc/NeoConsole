protocol
writeLine: string to: stream
	stream nextPutAll: string; lf "; flush"