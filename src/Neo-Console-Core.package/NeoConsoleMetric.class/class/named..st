accessing
named: metricName
	^ self knownMetrics detect: [ :each | each name = metricName ] ifNone: [ NotFound signalFor: metricName ]