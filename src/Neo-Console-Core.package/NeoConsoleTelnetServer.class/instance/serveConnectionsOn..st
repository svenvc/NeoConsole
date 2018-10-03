protocol
serveConnectionsOn: listeningSocket
	"We wait up to acceptWaitTimeout seconds for an incoming connection.
	If we get one we wrap it in a SocketStream and #executeRequestResponseLoopOn: on it"
		 
	| stream socket |
	socket := listeningSocket waitForAcceptFor: 300.
	socket ifNil: [ ^ self ].
	stream := self socketStreamOn: socket.
	[ [ [ self executeRequestResponseLoopOn: stream ]
		ensure: [ [ stream close ] on: Exception do: [ ] ] ]
			ifCurtailed: [ socket destroy ] ]
				forkAt: Processor lowIOPriority
				named: self workerProcessName 