testing
handlesLine: line
	^ line first = Character end "Ctrl-D" or: [ super handlesLine: line ]