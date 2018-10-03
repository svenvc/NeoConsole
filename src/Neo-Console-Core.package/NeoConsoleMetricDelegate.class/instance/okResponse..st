private
okResponse: text
	| output |
	output := String new: text size + 10 streamContents: [ :out |
		text lines do: [ :each | out << each ] separatedBy: [ out lf ].
		out lf ].
	^ ZnResponse ok: (ZnEntity text: output)