private
responseForMetricNamed: metricName
	| metric |
	metric := NeoConsoleMetric named: metricName.
	^ self okResponse: metric value asString