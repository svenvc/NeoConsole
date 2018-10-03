public
start
	self stop.
	process := [ [ self listenLoop ] repeat ] 
					forkAt: Processor highIOPriority 
					named: self serverProcessName