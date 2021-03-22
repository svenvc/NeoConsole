"
NeoConsoleStdio offers a command line interface to a Pharo image over Stdio.

  $ ./pharo Pharo.image eval NeoConsoleStdio run

End with quit or an empty line.
"
Class {
	#name : #NeoConsoleStdio,
	#superclass : #Object,
	#category : #'Neo-Console-Core'
}

{ #category : #utilities }
NeoConsoleStdio class >> nextLineFrom: stdin [
	"Read a CR, LF or CRLF terminated line from stdin, 
	returning the contents of the line without the EOL. 
	Return nil when stdin is #atEnd."
	
	stdin atEnd ifTrue: [ ^ nil ].
	^ (ByteArray streamContents: [ :out | | eol |
		eol := false.
		[ eol ] whileFalse: [ 
			stdin atEnd
				ifTrue: [ eol := true ]
				ifFalse: [
					stdin next ifNotNil: [ :byte |
						byte = 10 "CR"
							ifTrue: [ eol := true ]
							ifFalse: [ 
								byte = 13 "LF"
									ifTrue: [ eol := true. stdin peek = 13 "CR" ifTrue: [ stdin next ] ]
									ifFalse: [ out nextPut: byte ] ] ] ] ] ]) utf8Decoded.
	
	"Stdio stdin next returns nil when there is no input (yet), 
	while atEnd is still not true, we do a busy wait."

]

{ #category : #public }
NeoConsoleStdio class >> run [
	^ self new run
]

{ #category : #protocol }
NeoConsoleStdio >> executeRequestResponseLoop [
	| in out command executeResult |
	in := Stdio stdin.
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

{ #category : #printing }
NeoConsoleStdio >> printOn: stream [
	stream nextPutAll: self class name
]

{ #category : #protocol }
NeoConsoleStdio >> readInputFrom: stdin [
	| input line commandClass |
	line := (self class nextLineFrom: stdin) trimBoth.
	line isEmptyOrNil ifTrue: [ ^ NeoConsoleQuitCommand new ].
	commandClass := NeoConsoleCommand forLine: line.
	commandClass isSingleLine
		ifTrue: [ ^ commandClass new on: line; yourself ].
	input := String new writeStream.
	input nextPutAll: line; cr.
	[ 
		line := (self class nextLineFrom: stdin) trimBoth.
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
