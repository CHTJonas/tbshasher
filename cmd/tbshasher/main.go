package main

import (
	"fmt"
	"os"
	"runtime"

	"github.com/CHTJonas/tbshasher/cert"
)

var version = "dev-edge"

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintf(os.Stderr, "tbshasher %s (%s)\n", version, runtime.Version())
		fmt.Fprintf(os.Stderr, "Usage: %s -|CERTFILE\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "Purpose: prints the TBS hash of the (pre)certificate at CERTFILE (or stdin)\n")
		os.Exit(2)
	}

	certPath := os.Args[1]
	tbsHashStr, err := cert.ComputeTbsStringFromFile(certPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s: %s\n", os.Args[0], err)
		os.Exit(1)
	}
	fmt.Println(tbsHashStr)
}
