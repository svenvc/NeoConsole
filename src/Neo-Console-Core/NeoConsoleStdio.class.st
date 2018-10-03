"
NeoConsoleStdio offers a command line interface to a Pharo image over Stdio.

  $ ./pharo Pharo.image NeoConsoleStdio run

End with quit or an empty line.

Security warning: this service opens up your image for access to those with access to your local network (i.e. those logged in to your machine), without any further authenication, allowing them to do absolutely anything. Think and make sure that you know what you are doing.
"
Class {
	#name : #NeoConsoleStdio,
	#superclass : #Object,
	#category : 'Neo-Console-Core'
}

{ #category : #public }
NeoConsoleStdio class >> run [
	^ self new run
]

{ #category : #protocol }
NeoConsoleStdio >> executeRequestResponseLoop [
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
]

{ #category : #protocol }
NeoConsoleStdio >> readInputFrom: stream [
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

{ #category : #public }
NeoConsoleStdio >> run [
	self executeRequestResponseLoop 

]

{ #category : #protocol }
NeoConsoleStdio >> writeLine: string to: stream [
	stream nextPutAll: string; lf "; flush"
]

{ #category : #protocol }
NeoConsoleStdio >> writeOutput: string to: stream [
	string lines
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream lf ].
	stream lf "; flush"
]
