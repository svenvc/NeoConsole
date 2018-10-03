initialization
loadOSEnvironment
	OSPlatform current environment 
		keysAndValuesDo: [ :key :value | 
			self at: key put: value ]