private
executeHistoryLast
	| size |
	size := NeoConsole history size.
	size isZero 
		ifTrue: [ result := 'history is empty' ]
		ifFalse: [ self executeHistoryAt: size ]