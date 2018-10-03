public
execute
	self hasArguments 
		ifTrue: [ 
			(NeoConsoleCommand knownCommands 
					detect: [ :each | each prefix = self argument ] ifNone: [ nil ])
				ifNil: [ result := 'unknown command <{1}>' format: { self argument } ] 
				ifNotNil: [ :command | result := command helpText ] ]
		ifFalse: [ 
			result := String streamContents: [ :out |
				out << 'help <command>'; cr.
				out << 'known commands are:'; cr.
				NeoConsoleCommand knownCommands 
					do: [ :each | 
						out space; space; << each prefix.
						NeoConsoleCommand defaultCommand = each ifTrue: [ out << ' DEFAULT' ] ] 
					separatedBy: [ out cr ] ] ]