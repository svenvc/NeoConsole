initialization
initializeVersionMetrics
	self addNamed: 'system.version' 
		description: 'Image version info' 
		reader: [ SystemVersion current ].
	self addNamed: 'system.mcversions' 
		description: 'Monticello packages version info' 
		reader: [ String cr join: (MCWorkingCopy allManagers collect: #description) sorted ].