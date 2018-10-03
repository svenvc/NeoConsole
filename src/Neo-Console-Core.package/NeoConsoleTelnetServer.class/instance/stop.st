public
stop
	self isRunning ifFalse: [ ^ self ].
	process terminate. 
	process := nil.
