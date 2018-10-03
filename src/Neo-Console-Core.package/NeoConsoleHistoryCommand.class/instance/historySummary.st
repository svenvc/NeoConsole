private
historySummary
	result := String streamContents: [ :out | | size |
		size := NeoConsole history size.
		(1 max: (size - self historySummarySize)) to: size do: [ :each |
			out print: each; << ': '; << (NeoConsole history at: each); cr ] ]