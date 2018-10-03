"
History of evaluation input previously entered

You can use the single character alias ! even without a space

history - print a summary of the history
history all - print the full history
history clear - clear the full history
history <integer> - execute a previous input again
history last - execute the last input again
history ! - execute the last input again
"
Class {
	#name : #NeoConsoleHistoryCommand,
	#superclass : #NeoConsoleCommand,
	#category : 'Neo-Console-Core'
}

{ #category : #testing }
NeoConsoleHistoryCommand class >> handlesLine: line [
	^ line first = $! or: [ super handlesLine: line ]
]

{ #category : #accessing }
NeoConsoleHistoryCommand class >> prefix [
	^ 'history'
]

{ #category : #public }
NeoConsoleHistoryCommand >> execute [
	self hasArguments
		ifTrue: [
			self argument = 'all' 
				ifTrue: [ self history ].
			self argument = 'clear' 
				ifTrue: [ self historyClear ].
			(Integer readFrom: self argument ifFail: [ nil ]) 
				ifNotNil: [ :index | self executeHistoryAt: index ].
			(#(last !) includes: self argument)
				ifTrue: [ self executeHistoryLast ] ]
		ifFalse: [ self historySummary ]
]

{ #category : #private }
NeoConsoleHistoryCommand >> executeHistoryAt: index [
	| input evalCommand |
	[ 
	input := NeoConsole history at: index.
	evalCommand := NeoConsoleEvalCommand new on: input.
	evalCommand execute.
	result := input , String cr , String cr , evalCommand result ]
		on: SubscriptOutOfBounds
		do: [ result := 'no history item @ ' , index asString ]
]

{ #category : #private }
NeoConsoleHistoryCommand >> executeHistoryLast [
	| size |
	size := NeoConsole history size.
	size isZero 
		ifTrue: [ result := 'history is empty' ]
		ifFalse: [ self executeHistoryAt: size ]
]

{ #category : #private }
NeoConsoleHistoryCommand >> history [
	result := String streamContents: [ :out |
		1 to: NeoConsole history size do: [ :each |
			out print: each; << ': '; << (NeoConsole history at: each); cr ] ]
]

{ #category : #private }
NeoConsoleHistoryCommand >> historyClear [
	NeoConsole history removeAll.
	result := 'history cleared'
]

{ #category : #private }
NeoConsoleHistoryCommand >> historySummary [
	result := String streamContents: [ :out | | size |
		size := NeoConsole history size.
		(1 max: (size - self historySummarySize)) to: size do: [ :each |
			out print: each; << ': '; << (NeoConsole history at: each); cr ] ]
]

{ #category : #accessing }
NeoConsoleHistoryCommand >> historySummarySize [
	^ 10
]

{ #category : #'initialization-release' }
NeoConsoleHistoryCommand >> on: input [
	super on: input.
	self argument first = $!
		ifTrue: [ 
			arguments := self argument allButFirst findTokens: Character separators ]
		ifFalse: [ 
			arguments := self argument findTokens: Character separators.
			arguments := arguments allButFirst ]
]
