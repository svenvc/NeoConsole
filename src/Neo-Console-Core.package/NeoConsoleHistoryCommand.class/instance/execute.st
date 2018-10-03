public
execute
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