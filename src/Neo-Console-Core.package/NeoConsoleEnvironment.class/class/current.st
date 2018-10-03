accessing
current
	^ UniqueInstance ifNil: [ UniqueInstance := self new ]