initialization
initializeSystemStatusMetric
	self addNamed: 'system.status' 
		description: 'Simple system status' 
		reader: [
			'Status OK - Clock {1} - Allocated {2} bytes - {3} % free.' format: { 
				DateAndTime now.
				self memoryTotal asStringWithCommas. 
				(self memoryFree / self memoryTotal * 100.0) printShowingDecimalPlaces: 2 } ]