public
handleRequest: request
	((#(GET HEAD) includes: request method) and: [ request uri firstPathSegment = #metrics ])
		ifFalse: [ ^ ZnResponse notFound: request uri ].
	request uri pathSegments size = 1
		ifTrue: [ ^ self responseForKnowMetrics ].
	^ [ self responseForMetricNamed: request uri lastPathSegment ]
		on: NotFound
		do: [ ZnResponse notFound: request uri ]