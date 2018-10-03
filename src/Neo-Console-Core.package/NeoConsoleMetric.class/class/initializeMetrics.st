initialization
initializeMetrics
	self initializeSystemStatusMetric.
	self initializeMemoryMetrics.
	self initializeChronologyMetrics.
	self initializeProcessMetrics.
	self initializeVersionMetrics.