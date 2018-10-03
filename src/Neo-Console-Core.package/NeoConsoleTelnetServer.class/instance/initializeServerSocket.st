private
initializeServerSocket
	serverSocket := Socket newTCP.
	serverSocket setOption: 'TCP_NODELAY' value: 1.
	serverSocket 
		listenOn: self port 
		backlogSize: 10 
		interface: NetNameResolver loopBackAddress.
	serverSocket isValid
		ifFalse: [ self error: 'Cannot create socket on port ' , self port printString ]