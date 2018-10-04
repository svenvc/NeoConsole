# NeoConsole

NeoConsole offers a command line (REPL) interface to a Pharo image.

[![Build Status](https://travis-ci.org/svenvc/NeoConsole.svg?branch=master)](https://travis-ci.org/svenvc/NeoConsole)

In your headless Pharo server image, start a REPL process, locally bound, like this:

    NeoConsoleTelnetServer new start.
    
From a shell, on the same machine only, you can now interact with your headless Pharo server image, like this:

````
$ telnet localhost 4999
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Neo Console Pharo-7.0.0+alpha.build.1276.sha.6c09bd43bb0d76c18958c720649aaf6834870bb5 (64 Bit)
pharo> help
help <command>
known commands are:
  add
  describe
  eval DEFAULT
  get
  help
  history
  quit
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
Status OK - Clock 2018-10-04T14:11:43.630604+02:00 - Allocated 200,417,280 bytes - 99.29 % free.
pharo> 42 factorial

1405006117752879898543142606244511569936384000000000
pharo> NeoConsoleTelnetServer allInstances

an Array(a NeoConsoleTelnetServer(running 4999))
pharo> SystemVersion current

Pharo-7.0.0+alpha.build.1276.sha.6c09bd43bb0d76c18958c720649aaf6834870bb5 (64 Bit)
pharo> ==
self: Pharo-7.0.0+alpha.build.1276.sha.6c09bd43bb0d76c18958c720649aaf6...etc...
class: SystemVersion
date: 28 September 2018
highestUpdate: nil
type: 'Pharo'
major: 7
minor: 0
patch: 0
suffix: 'alpha'
build: 1276
commitHash: '6c09bd43bb0d76c18958c720649aaf6834870bb5'
pharo> quit
Bye!
Connection closed by foreign host.
````
