public
execute
	result := String 
		streamContents: [ :out | 
			[ 	| compiler evaluationResult |
				compiler := self class compiler.
				NeoConsole history add: self argument.
				evaluationResult := compiler evaluate: self argument.
				NeoConsole lastResult: evaluationResult. 
				out print: evaluationResult ]
					on: Error , SyntaxErrorNotification 
					do: [ :exception | self logException: exception on: out ] ]
		limitedTo: self outputLimit.
	result size < self outputLimit 
		ifFalse: [ result := result , ' ... (truncated) ...' ]