private
printLimited: valuable 
	^ [ valuable value printStringLimitedTo: 64 ] on: Error do: [ '<error while printing>' ]