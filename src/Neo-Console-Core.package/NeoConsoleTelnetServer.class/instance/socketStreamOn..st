private
socketStreamOn: socket
	^ (ZdcSocketStream on: socket)
		binary;
		shouldSignal: true;
		autoFlush: false;
		timeout: self timeout;
		yourself