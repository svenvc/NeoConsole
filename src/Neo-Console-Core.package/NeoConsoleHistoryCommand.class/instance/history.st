private
history
	result := String streamContents: [ :out |
		1 to: NeoConsole history size do: [ :each |
			out print: each; << ': '; << (NeoConsole history at: each); cr ] ]