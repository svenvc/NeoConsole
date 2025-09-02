"
Command line handler to invoke/start NeoConsole functionality like the REPL (read-eval-print-loop).

Usage: NeoConsole repl

	Run the REPL directly on standard input/output.

Usage: NeoConsole server

	Start the Telnet REPL server waiting for connections.
	
REPL:

	Type help inside the REPL for more information, type quit to leave the REPL.
	You can persist your changes by saving the image, type save.

Usage: NeoConsole get [ metric ]

	Return the value of a specific metric, or list all known metrics 

Examples:

	pharo Pharo.image NeoConsole repl
	pharo Pharo.image NeoConsole server
	pharo Pharo.image NeoConsole get
	pharo Pharo.image NeoConsole get system.status

"
Class {
	#name : 'NeoConsoleCommandLineHandler',
	#superclass : 'CommandLineHandler',
	#category : 'Neo-Console-Core',
	#package : 'Neo-Console-Core'
}

{ #category : 'accessing' }
NeoConsoleCommandLineHandler class >> commandName [
	^ 'NeoConsole'
]

{ #category : 'accessing' }
NeoConsoleCommandLineHandler class >> description [
	^ 'Invoke/start NeoConsole functionality like the repl (read-eval-print-loop)'
]

{ #category : 'activation' }
NeoConsoleCommandLineHandler >> activate [
	self activateHelpWithoutArguments
		ifTrue: [ ^ self ].
	self arguments first = 'repl'
		ifTrue: [ ^ self repl ].
	self arguments first = 'server'
		ifTrue: [ ^ self server ].
	self arguments first = 'get'
		ifTrue: [ ^ self get ].
	self exitFailure: 'Unknown subcommand: ' , self arguments first
]

{ #category : 'actions' }
NeoConsoleCommandLineHandler >> get [
	self arguments size = 1
		ifTrue: [
			self stdout nextPutAll: 'get [metric] - list of known metrics:'; lf.
			(NeoConsoleMetric knownMetrics sorted: #name ascending) do: [ :each |
				self stdout space; space; nextPutAll: each name; nextPutAll: ' - '; nextPutAll: each description; lf ].
			self exitSuccess ]
		ifFalse: [ 
			[ | metric |
				metric := NeoConsoleMetric named: self arguments second.
				self stdout nextPutAll: metric value asString; lf.
				self exitSuccess ]
					on: NotFound 
					do: [ self exitFailure: 'unknown metric: ' , self arguments second ] ]
]

{ #category : 'actions' }
NeoConsoleCommandLineHandler >> repl [
	NeoConsole repl.
	self exitSuccess
]

{ #category : 'actions' }
NeoConsoleCommandLineHandler >> server [
	self stdout
		nextPutAll: 'Started';
		space;
		nextPutAll: NeoConsole startServer printString;
		lf.
	"we do not exit but keep on running the image"
]
