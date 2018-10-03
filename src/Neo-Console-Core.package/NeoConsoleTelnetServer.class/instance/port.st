accessing
port
	^ port ifNil: [ port := 4999 ]