protocol
writeOutput: string to: stream
	string lines
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream lf ].
	stream lf "; flush"