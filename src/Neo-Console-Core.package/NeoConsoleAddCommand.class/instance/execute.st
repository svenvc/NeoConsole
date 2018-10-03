public
execute
	| lines targetClass source |
	(lines := self argument lines) ifEmpty: [ ^ result := self class comment ].
	targetClass := Smalltalk globals
		at: (lines first findTokens: ' ') first asSymbol
		ifAbsent: [ ^ result := 'Class ' , lines first , ' not found' ].
	(lines first findTokens: ' ') last = 'class'
		ifTrue: [ targetClass := targetClass class ].
	source := Character cr join: lines allButFirst.
	result := String
		streamContents: [ :out | 
			[ | compileResult |
			compileResult := targetClass compile: source.
			NeoConsole lastResult: compileResult.
			out print: compileResult ]
				on: Error , SyntaxErrorNotification
				do: [ :exception | self logException: exception on: out ] ]