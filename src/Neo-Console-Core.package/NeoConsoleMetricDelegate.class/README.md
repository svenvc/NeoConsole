NeoConsoleMetricDelegate is a Zinc HTTP Components Server delegate that offers HTTP web service access to all metrics.

Start a safe (locally bound) & dedicated HTTP server using: 

	NeoConsoleMetricDelegate startOn: 1707.

Try GET http://localhost:1707/metrics/system.status 

	ZnClient new get: 'http://localhost:1707/metrics/system.status'
	
To list all metrics GET /metrics
