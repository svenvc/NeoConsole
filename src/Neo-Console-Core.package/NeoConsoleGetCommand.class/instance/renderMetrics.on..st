private
renderMetrics: metrics on: out
	(metrics sorted: #name ascending)
		do: [ :each | out space; space; << each name; << ' - '; << each description ] 
		separatedBy: [ out cr ]