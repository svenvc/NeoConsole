"
I am BaselineOfNeoConsole, I load the NeoConsole project's code.
I am a BaselineOf.

NeoConsole offers a command line (REPL) interface to a Pharo image.
"
Class {
	#name : #BaselineOfNeoConsole,
	#superclass : #BaselineOf,
	#category : #BaselineOfNeoConsole
}

{ #category : #baselines }
BaselineOfNeoConsole >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'Neo-Console-Core' ]
]
