"
I am NeoConsoleTelnetServerTests, holding functional unit tests for NeoConsoleTelnetServer
"
Class {
	#name : #NeoConsoleTelnetServerTests,
	#superclass : #TestCase,
	#instVars : [
		'server'
	],
	#category : #'Neo-Console-Core'
}

{ #category : #accessing }
NeoConsoleTelnetServerTests >> localhost [
	^ #[127 0 0 1] asSocketAddress
]

{ #category : #running }
NeoConsoleTelnetServerTests >> setUp [ 
	super setUp.
	server := NeoConsoleTelnetServer new start
]

{ #category : #running }
NeoConsoleTelnetServerTests >> tearDown [
	server stop.
	super tearDown 
]

{ #category : #testing }
NeoConsoleTelnetServerTests >> testConnect [
	| connection in out line |
	connection := ZdcSocketStream openConnectionToHost: self localhost port: server port timeout: 10.
	in := ZnCharacterReadStream on: connection.
	out := ZnCharacterWriteStream on: connection.
	line := in nextLine.
	self assert: (line includesSubstring: 'NeoConsole').
	line := in next: 7.
	self assert: line equals: 'pharo> '.
	out nextPutAll: 'quit'; lf; flush.
	line := in nextLine.
	self assert: line equals: 'Bye!'.
	connection close
]

{ #category : #testing }
NeoConsoleTelnetServerTests >> testEvalSum [
	| connection in out line x y |
	connection := ZdcSocketStream openConnectionToHost: self localhost port: server port timeout: 10.
	in := ZnCharacterReadStream on: connection.
	out := ZnCharacterWriteStream on: connection.
	line := in nextLine.
	self assert: (line includesSubstring: 'NeoConsole').
	line := in next: 7.
	self assert: line equals: 'pharo> '.
	x := 999 atRandom.
	y := 999 atRandom.
	out nextPutAll: ('eval {1} + {2}' format: { x. y }); lf; lf; flush.
	line := in nextLine.
	self assert: line asNumber equals: x + y.
	out nextPutAll: 'quit'; lf; flush.
	connection close
]

{ #category : #testing }
NeoConsoleTelnetServerTests >> testGetSystemTimestamp [
	| connection in out line |
	connection := ZdcSocketStream openConnectionToHost: self localhost port: server port timeout: 10.
	in := ZnCharacterReadStream on: connection.
	out := ZnCharacterWriteStream on: connection.
	in nextLine.
	in next: 7.
	out nextPutAll: 'get system.timestamp'; lf; flush.
	line := in nextLine.
	self assert: DateAndTime now - (DateAndTime fromString: line) < 5 seconds.
	out nextPutAll: 'quit'; lf; flush.
	connection close
]

{ #category : #testing }
NeoConsoleTelnetServerTests >> testSumMultiline [
	| connection in out line x y |
	connection := ZdcSocketStream openConnectionToHost: self localhost port: server port timeout: 10.
	in := ZnCharacterReadStream on: connection.
	out := ZnCharacterWriteStream on: connection.
	line := in nextLine.
	self assert: (line includesSubstring: 'NeoConsole').
	line := in next: 7.
	self assert: line equals: 'pharo> '.
	x := 999 atRandom.
	y := 999 atRandom.
	out print: x; lf; nextPut: $+; lf; print: y; lf; lf; flush.
	line := in nextLine.
	self assert: line asNumber equals: x + y.
	out nextPutAll: 'quit'; lf; flush.
	connection close
]
