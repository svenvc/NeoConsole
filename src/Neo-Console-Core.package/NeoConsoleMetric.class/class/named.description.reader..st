instance creation
named: metricName description: description reader: valueable
	^ self new
		name: metricName;
		description: description;
		reader: valueable;
		yourself