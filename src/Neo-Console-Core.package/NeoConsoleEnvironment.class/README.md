NeoConsoleEnvironment holds a number of configuration key/value pairs and can be used for system configuration during startup. NeoConsoleEnvironment offers a single, central place for configuration.

For example, in your run/startup script you could write: 

NeoConsoleEnvironment current
	at: #DatabaseUsername put: 'webapp';
	at: #DatabasePassword put: 'secret'.
	
And use those values when you make a database connection once your application starts up.

You can optionally request to load the key/value of your OS environment using #loadOSEnvironment.

NeoConsoleEnvironment current
	loadOSEnvironment;
	yourself.

Keys are stored as symbols.
