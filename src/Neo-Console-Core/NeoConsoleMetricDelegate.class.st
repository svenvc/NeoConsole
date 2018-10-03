"
NeoConsoleMetricDelegate is a Zinc HTTP Components Server delegate that offers HTTP web service access to all metrics.

Start a safe (locally bound) & dedicated HTTP server using: 

	NeoConsoleMetricDelegate startOn: 1707.

Try GET http://localhost:1707/metrics/system.status 

	ZnClient new get: 'http://localhost:1707/metrics/system.status'
	
To list all metrics GET /metrics

"
Class {
	#name : #NeoConsoleMetricDelegate,
	#superclass : #Object,
	#category : 'Neo-Console-Core'
}

{ #category : #public }
NeoConsoleMetricDelegate class >> startOn: port [
	"self startOn: 1707"
	
	^ (ZnServer on: port)
		delegate: self new;
		bindingAddress: NetNameResolver loopBackAddress;
		logLevel: 2;
		start;
		yourself
]

{ #category : #public }
NeoConsoleMetricDelegate >> handleRequest: request [
	((#(GET HEAD) includes: request method) and: [ request uri firstPathSegment = #metrics ])
		ifFalse: [ ^ ZnResponse notFound: request uri ].
	request uri pathSegments size = 1
		ifTrue: [ ^ self responseForKnowMetrics ].
	^ [ self responseForMetricNamed: request uri lastPathSegment ]
		on: NotFound
		do: [ ZnResponse notFound: request uri ]
]

{ #category : #private }
NeoConsoleMetricDelegate >> okResponse: text [
	| output |
	output := String new: text size + 10 streamContents: [ :out |
		text lines do: [ :each | out << each ] separatedBy: [ out lf ].
		out lf ].
	^ ZnResponse ok: (ZnEntity text: output)
]

{ #category : #private }
NeoConsoleMetricDelegate >> responseForKnowMetrics [
	| text |
	text := String cr join: (NeoConsoleMetric knownMetrics collect: [ :each |
		'/metrics/' , each name, ' - ', each description ]).
	^ self okResponse: text
]

{ #category : #private }
NeoConsoleMetricDelegate >> responseForMetricNamed: metricName [
	| metric |
	metric := NeoConsoleMetric named: metricName.
	^ self okResponse: metric value asString
]
