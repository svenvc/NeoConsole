"
I am NeoConsoleTests, containing some functional tests for NeoConsole.
"
Class {
	#name : 'NeoConsoleTests',
	#superclass : 'TestCase',
	#category : 'Neo-Console-Core',
	#package : 'Neo-Console-Core'
}

{ #category : 'tests' }
NeoConsoleTests >> testEnvironment [
	NeoConsole env at: #SECRET ifPresent: [ self fail ].
	NeoConsole env at: #SECRET put: 42 asWords.
	self assert: (NeoConsole env includesKey: #SECRET).
	self assert: (NeoConsole env at: #SECRET) equals: 42 asWords.
	NeoConsole env removeKey: #SECRET.
	self deny: (NeoConsole env includesKey: #SECRET).
	
	NeoConsole env loadOSEnvironment.
	self assert: ((NeoConsole env includesKey: #PATH) or: [ NeoConsole env includesKey: #Path ]).
	

	
]

{ #category : 'tests' }
NeoConsoleTests >> testMetrics [
	NeoConsoleMetric knownMetrics do: [ :each |
		self deny: each value isNil.
		self deny: each name isEmptyOrNil.
		self deny: each description isEmptyOrNil ]
]

{ #category : 'tests' }
NeoConsoleTests >> testUptime [
	| uptime uptime1 uptime2 |
	uptime := (NeoConsoleMetric named: 'system.uptime') value.
	self assert: uptime isString.
	self deny: uptime isEmpty .
	uptime1 := (NeoConsoleMetric named: 'system.uptimeseconds') value.
	self assert: uptime1 isInteger.
	self assert: uptime1 > 1.
	1 second wait.
	uptime2 := (NeoConsoleMetric named: 'system.uptimeseconds') value.
	self assert: uptime2 > uptime1 
]
