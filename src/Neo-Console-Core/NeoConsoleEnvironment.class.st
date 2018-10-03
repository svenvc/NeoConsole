"
NeoConsoleEnvironment holds a number of configuration key/value pairs and can be used for system configuration during startup. NeoConsoleEnvironment offers a single, central place for configuration.

For example, in your run/startup script you could write: 

NeoConsoleEnvironment current
	at: #DatabaseUsername put: 'webapp';
	at: #DatabasePassword put: 'secret'.
	
And use those values when you make a database connection once your application starts up.

You can optionally request to load the key/value of your OS environment using #loadOSEnvironment.

NeoConsoleEnvironment current
	loadOSEnvironment;
	yourself.

Keys are stored as symbols.

"
Class {
	#name : #NeoConsoleEnvironment,
	#superclass : #Object,
	#instVars : [
		'environment'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : 'Neo-Console-Core'
}

{ #category : #accessing }
NeoConsoleEnvironment class >> current [
	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : #accessing }
NeoConsoleEnvironment class >> default [
	^ self current
]

{ #category : #accessing }
NeoConsoleEnvironment >> at: key [
	"Return my value for key.
	Signal NotFound if I do not know key."
	
	^ environment at: key
]

{ #category : #accessing }
NeoConsoleEnvironment >> at: key ifAbsent: block [
	"Return my value for key.
	Return the value of evaluating block in case I do not know key."
	
	^ environment at: key ifAbsent: block
]

{ #category : #accessing }
NeoConsoleEnvironment >> at: key ifAbsentPut: block [
	"Return my value for key.
	Store and return the value of evaluating block in case I do not know key."

	^ environment at: key ifAbsentPut: block
]

{ #category : #accessing }
NeoConsoleEnvironment >> at: key ifPresent: block [
	"Return the value of evaluating block with my value for key.
	Return self, in effect do nothing, in case I do not know key."

	^ environment at: key ifPresent: block
]

{ #category : #accessing }
NeoConsoleEnvironment >> at: key put: value [
	"I will store value for key.
	Return value."
	
	^ environment at: key asSymbol put: value
]

{ #category : #testing }
NeoConsoleEnvironment >> includesKey: key [
	^ environment includesKey: key
]

{ #category : #initialization }
NeoConsoleEnvironment >> initialize [
	environment := Dictionary new
]

{ #category : #accessing }
NeoConsoleEnvironment >> keys [
	^ environment keys
]

{ #category : #enumeration }
NeoConsoleEnvironment >> keysAndValuesDo: block [
	environment keysAndValuesDo: block
]

{ #category : #initialization }
NeoConsoleEnvironment >> loadOSEnvironment [
	OSPlatform current environment 
		keysAndValuesDo: [ :key :value | 
			self at: key put: value ]
]
