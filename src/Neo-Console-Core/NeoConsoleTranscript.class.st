"
I am NeoConsoleTranscript, a NonInteractiveTranscript that writes to a dated file, switching to a new file each day.

	(NeoConsoleTranscript onFileNamed: 'server-{1}.log') install.

"
Class {
	#name : #NeoConsoleTranscript,
	#superclass : #NonInteractiveTranscript,
	#instVars : [
		'date'
	],
	#category : 'Neo-Console-Core'
}

{ #category : #constants }
NeoConsoleTranscript class >> defaultLogFileName [
	"The default file name that will be used to write to.
	This needs to have a slot where the date will come."
	
	^ 'PharoTranscript-{1}.log'
]

{ #category : #accessing }
NeoConsoleTranscript >> fileNameWithDate [
	| newName |
	newName := self fileName format: { date yyyymmdd }.
	self 
		assert: self fileName ~= newName 
		description: 'The filename should include a {1} slot for the date'.
	^ newName
]

{ #category : #'initialize-release' }
NeoConsoleTranscript >> initialize [
	super initialize.
	date := Date today
]

{ #category : #private }
NeoConsoleTranscript >> initializeStream [
	"Open the file stream that I write to or connect to #stdout.
	I use the proper line end convention.
	I will append to regular files.
	Overwrtitten to use #fileNameWithDate"
	
	stream := self isStdout 
		ifTrue: [ FileStream stdout ]
		ifFalse: [ FileStream fileNamed: self fileNameWithDate ].
	stream wantsLineEndConversion: true.
	self isStdout
		ifTrue: [ stream converter "Force lazy initialization of converter" ] 
		ifFalse: [ stream setToEnd ].
	^ stream
]

{ #category : #accessing }
NeoConsoleTranscript >> stream [ 
	"Overwritten to check if the date changed on each access"
	
	Date today > date
		ifTrue: [ 
			"The date changed: close the old file and advance the date"
			self close.
			date := Date today ].
	"Since stream is now nil, #initializeStream will be called"
	^ super stream
]
