initialization-release
on: input
	super on: input.
	arguments := self argument findTokens: Character separators.
	arguments := arguments allButFirst 