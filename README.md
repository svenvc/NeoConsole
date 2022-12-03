# NeoConsole

NeoConsole offers a command line (REPL) interface to a Pharo image, as well as other tools.

[![CI](https://github.com/svenvc/NeoConsole/actions/workflows/CI.yml/badge.svg)](https://github.com/svenvc/NeoConsole/actions/workflows/CI.yml)

## Overview

The NeoConsole project includes a number of tools
to improve command line interaction with a Pharo image.

- a set of command objects
- a command line handler 
- a direct stdin/stdout REPL for experimentation
- a REPL server for connecting to a running image
- a metrics package
- an HTTP handler to access metrics for monitoring
- a store of configuration key/values incuding environment variables
- a Transcript replacement to log to a daily rotated file or stdout


## REPL

A REPL, a read-eval-print-loop, is textual interface to a Pharo image.
You type commands or expressions to evaluate that are read.
Next this input is evaluated (parsed and executed) with possible side effects.
Finally, the result is printed.
This continues in a loop.

NeoConsole has a set of command objects that can be invoked,
one of which is the eval command that is the default.
Although a bunch of commands are simple single line expressions,
some, including eval, are multi line and are terminated by a blank line.

Starting the direct stdin/stdout REPL can be done as follows:

```
$ ./pharo Pharo.image NeoConsole repl
NeoConsole Pharo-9.0.0+build.1201.sha.e4cffcf6af8c3a6d5f81ee0cc292bee7c91f2ae4 (64 Bit)
pharo> get system.timestamp
2021-03-24T11:01:52.488876+01:00
pharo> 42 factorial

1405006117752879898543142606244511569936384000000000
pharo> quit
Bye!
```

In your headless Pharo server image, start a REPL process, locally bound, like this:

    NeoConsoleTelnetServer new start.

Alternatively, you can also do:

    $ ./pharo Pharo.image NeoConsole server &
    [1] 40432
    Started a NeoConsoleTelnetServer(running 4999)
    
From a shell, on the same machine only, you can now interact with your headless Pharo server image, like this:

````
$ telnet localhost 4999
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Neo Console Pharo-9.0.0+build.1201.sha.e4cffcf6af8c3a6d5f81ee0cc292bee7c91f2ae4 (64 Bit)
pharo> help
help <command>
known commands are:
  add
  describe
  eval DEFAULT
  get
  halt
  help
  history
  quit
  save
  show
pharo> get
known metrics:
  memory.free - Free memory
  memory.gc - Garbage collect, return free memory
  memory.total - Total allocated memory
  process.count - Current process count
  process.list - Current list of processes
  system.date - Current date
  system.mcversions - Monticello packages version info
  system.status - Simple system status
  system.time - Current time
  system.timestamp - Current timestamp
  system.uptime - Image uptime human readeable
  system.uptimeseconds - Image uptime seconds
  system.version - Image version info
pharo> get system.status
Status OK - Clock 2021-03-24T11:08:13.387309+01:00 - Allocated 125,444,096 bytes - 21.05 % free.
pharo> 42 factorial

1405006117752879898543142606244511569936384000000000
pharo> NeoConsoleTelnetServer allInstances

an Array(a NeoConsoleTelnetServer(running 4999))
pharo> SystemVersion current

Pharo-9.0.0+build.1201.sha.e4cffcf6af8c3a6d5f81ee0cc292bee7c91f2ae4 (64 Bit)
pharo> ==
self: Pharo-9.0.0+build.1201.sha.e4cffcf6af8c3a6d5f81ee0cc292bee7c91f2...etc...
class: SystemVersion
date: 11 March 2021
highestUpdate: nil
type: 'Pharo'
major: 9
minor: 0
patch: 0
suffix: ''
build: 1201
commitHash: 'e4cffcf6af8c3a6d5f81ee0cc292bee7c91f2ae4'
pharo> quit
Bye!
Connection closed by foreign host.
````


## HTTP Metrics

The class NeoConsoleMetricsDelegate implements the handling of a resource space to access all known metrics.
You can start a safe (locally bound) & dedicated HTTP server as follows:

````
NeoConsoleMetricDelegate startOn: 1707
````

Which you can then access (locally on the same machine) with any HTTP client:

````
$ curl http://localhost:1707/metrics
/metrics/memory.free - Free memory
/metrics/memory.gc - Garbage collect, return free memory
/metrics/memory.total - Total allocated memory
/metrics/process.count - Current process count
/metrics/process.list - Current list of processes
/metrics/system.date - Current date
/metrics/system.mcversions - Monticello packages version info
/metrics/system.status - Simple system status
/metrics/system.time - Current time
/metrics/system.timestamp - Current timestamp
/metrics/system.uptime - Image uptime human readeable
/metrics/system.uptimeseconds - Image uptime seconds
/metrics/system.version - Image version info

$ curl http://localhost:1707/metrics/system.version
Pharo-11.0.0+build.323.sha.e6c76cf1e64aa02779926645ff2d31101aee6273 (64 Bit)

$ curl http://localhost:1707/metrics/system.status
Status OK - Clock 2022-12-03T16:53:32.669806+01:00 - Allocated 219,152,384 bytes - 17.72 % free.
````


## Metrics

Metrics are implemented using the class NeoConsoleMetric which also keeps a list of all known/defined metrics.
This is how you would define a new metric:

````
NeoConsoleMetric addNamed: 'test.random' description: 'A random test' reader: [ 1e9 atRandom asString ].
````

The URI to access your new metric would then be /metrics/test.random

The reader block is evaluated each time the value of the metric is needed.


## Installation

You can load NeoConsole using Metacello

```Smalltalk
Metacello new
  repository: 'github://svenvc/NeoConsole/src';
  baseline: 'NeoConsole';
  load.
```

You can use the following dependency from your own Metacello configuration or baseline

```Smalltalk
spec baseline: 'NeoConsole' with: [ spec repository: 'github://svenvc/NeoConsole/src' ].
```

When you download Pharo using the Zeroconf tools (https://get.pharo.org),
you can add the NeoConsole code to your image as follows:

```
$ ./pharo Pharo.image metacello install github://svenvc/NeoConsole/src BaselineOfNeoConsole

MetacelloNotification: Fetched -> BaselineOfNeoConsole-CompatibleUserName.1616520420 --- git@github.com:svenvc/NeoConsole.git[master] --- git@github.com:svenvc/NeoConsole.git[master]
MetacelloNotification: Loading -> BaselineOfNeoConsole-CompatibleUserName.1616520420 --- git@github.com:svenvc/NeoConsole.git[master] --- git@github.com:svenvc/NeoConsole.git[master]
MetacelloNotification: Loaded -> BaselineOfNeoConsole-CompatibleUserName.1616520420 --- git@github.com:svenvc/NeoConsole.git[master] --- git@github.com:svenvc/NeoConsole.git[master]
MetacelloNotification: Loading baseline of BaselineOfNeoConsole...
MetacelloNotification: Fetched -> Neo-Console-Core-CompatibleUserName.1616520420 --- git@github.com:svenvc/NeoConsole.git[master] --- git@github.com:svenvc/NeoConsole.git[master]
MetacelloNotification: Loading -> Neo-Console-Core-CompatibleUserName.1616520420 --- git@github.com:svenvc/NeoConsole.git[master] --- cache
MetacelloNotification: Loaded -> Neo-Console-Core-CompatibleUserName.1616520420 --- git@github.com:svenvc/NeoConsole.git[master] --- cache
MetacelloNotification: ...finished baseline
```

MIT Licensed.
