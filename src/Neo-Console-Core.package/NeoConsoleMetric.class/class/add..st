accessing
add: metric
	^ self knownMetrics 
		removeAllSuchThat: [ :each | each name = metric name ]; 
		add: metric