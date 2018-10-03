private
sessionAge
	^ (Smalltalk includesKey: #Session)
		ifTrue: [ (Smalltalk at: #Session) current age ]
		ifFalse: [ DateAndTime now - (Smalltalk at: #SessionManager) default currentSession creationTime ]