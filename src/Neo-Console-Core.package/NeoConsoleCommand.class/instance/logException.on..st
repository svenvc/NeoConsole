private
logException: exception on: out
	out print: exception; cr.
	exception signalerContext printDetails: out.
	exception signalerContext sender debugStack: 8 on: out