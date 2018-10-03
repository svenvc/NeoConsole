accessing
helpText
	^ String streamContents: [ :out |
			out << self name; cr.
			self comment linesDo: [ :each | 
				out space; space; << each; cr ] ]