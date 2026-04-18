# TBS Hasher

tbshasher is a teeny tiny utility written in Go that calculates the TBS hash of a PEM-encoded certificate. It adheres to the Unix philosophy of doing one thing well.

## Usage

tbshasher is compiled into a single static binary and there is no configuration to worry about when deploying or running.

```
Usage: tbshasher -|CERTFILE
Purpose: prints the TBS hash of the (pre)certificate at CERTFILE (or stdin)
```

## Compiling

It should be simple to checkout and build the code, assuming you have a suitable [Go toolchain installed](https://golang.org/doc/install). Running the following commands in a terminal will compile binaries for various operating systems and processor architectures and place them in `./bin`:

```bash
git clone https://github.com/CHTJonas/tbshasher.git
cd tbshasher
make clean && make all
```

## Copyright

tbshasher is licensed under the [Mozilla Public License Version 2.0](https://github.com/CHTJonas/tbshasher/blob/main/LICENSE).

Copyright (C) 2026 Charlie Jonas  
Copyright (C) 2016-2026 Opsmate, Inc.
