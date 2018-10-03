initialization
initializeMemoryMetrics
	self addNamed: 'memory.total' 
		description: 'Total allocated memory' 
		reader: [ self memoryTotal ].
	self addNamed: 'memory.free'
		description: 'Free memory'
		reader: [ self memoryFree ].
	self addNamed: 'memory.gc'
		description: 'Garbage collect, return free memory'
		reader: [ Smalltalk garbageCollect. self memoryFree ].