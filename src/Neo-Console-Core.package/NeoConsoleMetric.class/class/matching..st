accessing
matching: pattern
	| patternToSearchFor |
	patternToSearchFor := (pattern includes: $*) ifTrue: [ pattern ] ifFalse: [ '*' , pattern , '*' ]. 
	^ self knownMetrics select: [ :each | patternToSearchFor match: each name ]