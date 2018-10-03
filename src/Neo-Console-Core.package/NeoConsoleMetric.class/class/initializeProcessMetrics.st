initialization
initializeProcessMetrics
	self addNamed: 'process.count' 
		description: 'Current process count' 
		reader: [ (Process allSubInstances reject: #isTerminated) size asString ].
	self addNamed: 'process.list'
		description: 'Current list of processes'
		reader: [ String cr join: ((Process allSubInstances reject: #isTerminated) collect: #name as: Array) ].