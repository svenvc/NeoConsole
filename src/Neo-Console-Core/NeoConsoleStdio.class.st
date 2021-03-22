"
NeoConsoleStdio offers a command line interface to a Pharo image over Stdio.

  $ ./pharo Pharo.image NeoConsoleStdio run

End with quit or an empty line.
"
Class {
	#name : #NeoConsoleStdio,
	#superclass : #Object,
	#category : #'Neo-Console-Core'
}

{ #category : #public }
NeoConsoleStdio class >> run [
	^ self new run
]

{ #category : #protocol }
NeoConsoleStdio >> executeRequestResponseLoop [
	| in out command executeResult |
	in := ZnCharacterReadStream on: Stdio stdin.
	out := ZnCharacterWriteStream on: Stdio stdout.
	self writeOutput: ('Neo Console ', SystemVersion current asString) to: out.
	[
		out nextPutAll: 'pharo> ' "; flush".
		command := (self readInputFrom: in).
		executeResult := [ command execute ] 
			on: Error 
			do: [ :exception | command printString, ' failed with ', exception printString ].
		self writeOutput: command result to: out.
		executeResult notNil ] whileTrue
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
NeoConsoleStdio >> writeOutput: string to: stream [
	string lines
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream lf ].
	stream lf "; flush"
]
