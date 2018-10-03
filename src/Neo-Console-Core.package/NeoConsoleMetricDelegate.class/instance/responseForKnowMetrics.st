private
responseForKnowMetrics
	| text |
	text := String cr join: (NeoConsoleMetric knownMetrics collect: [ :each |
		'/metrics/' , each name, ' - ', each description ]).
	^ self okResponse: text