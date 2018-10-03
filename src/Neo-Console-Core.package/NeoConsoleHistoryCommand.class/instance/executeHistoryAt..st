private
executeHistoryAt: index
	| input evalCommand |
	[ 
	input := NeoConsole history at: index.
	evalCommand := NeoConsoleEvalCommand new on: input.
	evalCommand execute.
	result := input , String cr , String cr , evalCommand result ]
		on: SubscriptOutOfBounds
		do: [ result := 'no history item @ ' , index asString ]