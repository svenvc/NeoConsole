initialization
initializeChronologyMetrics
	self addNamed: 'system.uptime' 
		description: 'Image uptime human readeable' 
		reader: [ (self sessionAge roundTo: 1 minute) humanReadablePrintString ].	
	self addNamed: 'system.uptimeseconds' 
		description: 'Image uptime seconds' 
		reader: [ self sessionAge asSeconds ].	
	self addNamed: 'system.date' 
		description: 'Current date' 
		reader: [ Date today printString ].
	self addNamed: 'system.time'
		description: 'Current time'
		reader: [ Time now printString ].
	self addNamed: 'system.timestamp'
		description: 'Current timestamp'
		reader: [ DateAndTime now printString ].