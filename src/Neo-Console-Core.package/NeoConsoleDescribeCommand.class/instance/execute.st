public
execute
	| object |
	object := NeoConsole last.
	result := String streamContents: [ :out |
		out << 'self: '; << (self printLimited: [ object ]); cr.
		out << 'class: '; << object class name; cr.
		object class allInstVarNames do: [ :each |
			out << each; << ': '; << (self printLimited: [ object instVarNamed: each ]); cr ].
		object class isVariable ifTrue: [
			object size <= 20
				ifTrue: [
					1 to: object size do: [ :index |
						out print: index; << ': '; << (self printLimited: [ object at: index ]); cr ] ]
				ifFalse: [ 
					1 to: 10 do: [ :index |
						out print: index; << ': '; << (self printLimited: [ object at: index ]); cr ].
					out << '...'; cr.
					object size - 10 to: object size do: [ :index |
						out print: index; << ': '; << (self printLimited: [ object at: index ]); cr ] ] ] ]