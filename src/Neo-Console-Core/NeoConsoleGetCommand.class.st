"
Get the value of a metric (gauge or counter)

get - list all metrics
get <metric> - show the current value of <metric>

Examples

get

- list all existing metrics

get system.status

- show the result of a specific metric

get system.*

- list all metrics starting with system.

get status

- list all metrics containing 'status'
"
Class {
	#name : 'NeoConsoleGetCommand',
	#superclass : 'NeoConsoleCommand',
	#category : 'Neo-Console-Core',
	#package : 'Neo-Console-Core'
}

{ #category : 'accessing' }
NeoConsoleGetCommand class >> prefix [
	^ 'get'
]

{ #category : 'public' }
NeoConsoleGetCommand >> execute [
	self hasArguments 
		ifTrue: [ 
			[ result := (NeoConsoleMetric named: self argument) value asString ] 
				on: NotFound 
				do: [ :exception | 
					result := (NeoConsoleMetric matching: self argument)
						ifEmpty: [ exception printString ]
						ifNotEmpty: [ :matchingMetrics |
							String streamContents: [ :out |
								out << 'matching metrics:'; cr.
								self renderMetrics: matchingMetrics on: out ] ] ] ]
		ifFalse: [ 
			result := String streamContents: [ :out |
				out << 'known metrics:'; cr.
				self renderMetrics: NeoConsoleMetric knownMetrics on: out ] ]
]

{ #category : 'initialization-release' }
NeoConsoleGetCommand >> on: input [
	super on: input.
	arguments := self argument findTokens: Character separators.
	arguments := arguments allButFirst 
]

{ #category : 'private' }
NeoConsoleGetCommand >> renderMetrics: metrics on: out [
	(metrics sorted: #name ascending)
		do: [ :each | out space; space; << each name; << ' - '; << each description ] 
		separatedBy: [ out cr ]
]
