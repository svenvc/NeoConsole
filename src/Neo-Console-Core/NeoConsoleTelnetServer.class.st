"
NeoConsoleTelnetServer offers a command line interface to a Pharo image over a network connection.

Inspect:

  NeoConsoleTelnetServer new start.

In a terminal do:

  $  telnet localhost 4999

End with quit or an empty line.

Security warning: this service opens up your image for access to those with access to your local network (i.e. those logged in to your machine), without any further authenication, allowing them to do absolutely anything. Think and make sure that you know what you are doing.
"
Class {
	#name : #NeoConsoleTelnetServer,
	#superclass : #Object,
	#instVars : [
		'port',
		'process',
		'serverSocket'
	],
	#classVars : [
		'ManagedServers'
	],
	#category : #'Neo-Console-Core'
}

{ #category : #'class initialization' }
NeoConsoleTelnetServer class >> initialize [
	SessionManager default registerNetworkClassNamed: self name
]

{ #category : #accessing }
NeoConsoleTelnetServer class >> managedServers [
	^ ManagedServers ifNil: [ ManagedServers := IdentitySet new ]
]

{ #category : #'system startup' }
NeoConsoleTelnetServer class >> register: server [
	"Arrange for server to be sent start/stop on system startUp/shutDown"
	
	self managedServers add: server
]

{ #category : #'system startup' }
NeoConsoleTelnetServer class >> shutDown: quiting [
	"Our system shutDown hook: stop all servers we manage"
	
	quiting
		ifTrue: [
			self managedServers do: [ :each | each stop: false ] ]
]

{ #category : #public }
NeoConsoleTelnetServer class >> startOn: port [
	"self startOn: 4999"
	
	^ self new
		port: port;
		start
]

{ #category : #'system startup' }
NeoConsoleTelnetServer class >> startUp: resuming [
	"Our system startUp hook: start all servers we manage.
	We do this using deferred startup actions to allow normal error handling."

	resuming
		ifTrue: [
			SessionManager default currentSession addDeferredStartupAction: [ 
				self managedServers do: [ :each | each start ] ] ]
]

{ #category : #'system startup' }
NeoConsoleTelnetServer class >> unregister: server [
	"No longer send server start/stop on system startUp/shutDown"
	
	self managedServers remove: server ifAbsent: [ ]
]

{ #category : #protocol }
NeoConsoleTelnetServer >> executeRequestResponseLoopOn: stream [
	| in out command executeResult |
	in := ZnCharacterReadStream on: stream.
	out := ZnCharacterWriteStream on: stream.
	self writeOutput: ('NeoConsole ', SystemVersion current asString) to: out.
	[
		stream nextPutAll: 'pharo> '; flush.
		command := (self readInputFrom: in).
		executeResult := [ command execute ] 
			on: Error 
			do: [ :exception | command printString, ' failed with ', exception printString ].
		self writeOutput: command result to: out.
		executeResult notNil ] whileTrue
]

{ #category : #private }
NeoConsoleTelnetServer >> initializeServerSocket [
	serverSocket := Socket newTCP.
	serverSocket setOption: 'TCP_NODELAY' value: 1.
	serverSocket 
		listenOn: self port 
		backlogSize: 10 
		interface: NetNameResolver loopBackAddress.
	serverSocket isValid
		ifFalse: [ self error: 'Cannot create socket on port ' , self port printString ]
]

{ #category : #testing }
NeoConsoleTelnetServer >> isRunning [
	"Return true when I am running"
	
	^ process notNil and: [ serverSocket notNil ]
]

{ #category : #protocol }
NeoConsoleTelnetServer >> listenLoop [
	"We create a listening Socket, then wait for a connection.
	After each connection we also check that the listening Socket is still valid 
	- if not we just make a recursive call to this method to start over."

	self initializeServerSocket.
	[ [ 
		serverSocket isValid 
			ifFalse: [
				"will trigger #ifCurtailed: block and destroy socket"
				^ self listenLoop ].
		self serveConnectionsOn: serverSocket ] repeat ]

		ifCurtailed: [ self releaseServerSocket ]
]

{ #category : #accessing }
NeoConsoleTelnetServer >> port [
	^ port ifNil: [ port := 4999 ]
]

{ #category : #accessing }
NeoConsoleTelnetServer >> port: integer [
	port := integer
]

{ #category : #printing }
NeoConsoleTelnetServer >> printOn: stream [
	super printOn: stream.
	stream << $(.
	self isRunning ifTrue: [ stream << #running; space; print: self port ].
	stream << $)
]

{ #category : #protocol }
NeoConsoleTelnetServer >> readInputFrom: stream [
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
]

{ #category : #private }
NeoConsoleTelnetServer >> releaseServerSocket [
	(Delay forMilliseconds: 10) wait.
	serverSocket destroy.
	serverSocket := nil
]

{ #category : #protocol }
NeoConsoleTelnetServer >> serveConnectionsOn: listeningSocket [
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
]

{ #category : #accessing }
NeoConsoleTelnetServer >> serverProcessName [
	^ self class name asString , ' port ' , self port asString
]

{ #category : #private }
NeoConsoleTelnetServer >> socketStreamOn: socket [
	^ (ZdcSocketStream on: socket)
		binary;
		shouldSignal: true;
		autoFlush: false;
		timeout: self timeout;
		yourself
]

{ #category : #public }
NeoConsoleTelnetServer >> start [
	self stop.
	self class register: self.
	process := [ 
		[ self listenLoop ] repeat 
	] 
		forkAt: Processor highIOPriority 
		named: self serverProcessName
]

{ #category : #public }
NeoConsoleTelnetServer >> stop [
	self stop: true
]

{ #category : #public }
NeoConsoleTelnetServer >> stop: unregister [
	unregister ifTrue: [ self class unregister: self ].
	self isRunning ifFalse: [ ^ self ].
	process terminate. 
	process := nil.

]

{ #category : #accessing }
NeoConsoleTelnetServer >> timeout [
	^ 60
]

{ #category : #accessing }
NeoConsoleTelnetServer >> workerProcessName [
	^ self serverProcessName, ' Connection Handler'
]

{ #category : #protocol }
NeoConsoleTelnetServer >> writeOutput: string to: stream [
	string isEmptyOrNil
		ifTrue: [ ^ self ].
	string lines
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream lf ].
	stream lf; flush
]
