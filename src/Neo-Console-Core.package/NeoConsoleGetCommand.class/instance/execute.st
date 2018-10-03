public
execute
	self hasArguments 
		ifTrue: [ 
			[ result := (NeoConsoleMetric named: self argument) value asString ] 
				on: NotFound 
				do: [ :exception | 
					result := (NeoConsoleMetric matching: self argument)
						ifEmpty: [ exception printString ]
						ifNotEmpty: [ :matchingMetrics |
							String streamContents: [ :out |
								out << 'matching metrics:'; cr.
								self renderMetrics: matchingMetrics on: out ] ] ] ]
		ifFalse: [ 
			result := String streamContents: [ :out |
				out << 'known metrics:'; cr.
				self renderMetrics: NeoConsoleMetric knownMetrics on: out ] ]