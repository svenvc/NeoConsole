accessing
knownMetrics
	^ KnownMetrics ifNil: [ KnownMetrics := OrderedCollection new ]