public
startOn: port
	"self startOn: 1707"
	
	^ (ZnServer on: port)
		delegate: self new;
		bindingAddress: NetNameResolver loopBackAddress;
		logLevel: 2;
		start;
		yourself