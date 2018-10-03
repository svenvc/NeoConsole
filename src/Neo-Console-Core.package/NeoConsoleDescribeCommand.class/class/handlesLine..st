testing
handlesLine: line
	^ line first = $= or: [ super handlesLine: line ]