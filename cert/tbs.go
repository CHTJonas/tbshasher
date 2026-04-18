// Copyright (C) 2026 Charlie Jonas
// Copyright (C) 2026 Opsmate, Inc.
//
// This Source Code Form is subject to the terms of the Mozilla
// Public License, v. 2.0. If a copy of the MPL was not distributed
// with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// This software is distributed WITHOUT A WARRANTY OF ANY KIND.
// See the Mozilla Public License for details.

// Much of the code here has been taken directly from the fantastic
// Cert Spotter project.

package cert

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/pem"
	"fmt"
	"io"
	"os"

	"software.sslmate.com/src/certspotter"
)

func ReadCertFile(path string) ([]byte, error) {
	if path == "-" {
		return io.ReadAll(os.Stdin)
	} else {
		return os.ReadFile(path)
	}
}

func ParseCertificate(certBytes []byte) ([]byte, error) {
	block, _ := pem.Decode(certBytes)
	if block != nil {
		if block.Type == "CERTIFICATE" {
			return block.Bytes, nil
		}
		return nil, fmt.Errorf("PEM block type is %q, expected CERTIFICATE", block.Type)
	}
	return nil, fmt.Errorf("no PEM data found")
}

func ComputeTbsHash(certDER []byte) ([32]byte, error) {
	certInfo, err := certspotter.MakeCertInfoFromRawCert(certDER)
	if err != nil {
		return [32]byte{}, fmt.Errorf("error parsing certificate: %w", err)
	}
	precertTBS, err := certspotter.ReconstructPrecertTBS(certInfo.TBS)
	if err != nil {
		return [32]byte{}, fmt.Errorf("error reconstructing precertificate TBSCertificate: %w", err)
	}
	return sha256.Sum256(precertTBS.Raw), nil
}

func ComputeTbsStringFromFile(certPath string) (string, error) {
	certBytes, err := ReadCertFile(certPath)
	if err != nil {
		return "", fmt.Errorf("error reading certificate: %w", err)
	}

	certDer, err := ParseCertificate(certBytes)
	if err != nil {
		return "", fmt.Errorf("error parsing certificate: %w", err)
	}

	tbsHash, err := ComputeTbsHash(certDer)
	if err != nil {
		return "", fmt.Errorf("error computing TBS hash: %w", err)
	}

	return hex.EncodeToString(tbsHash[:]), nil
}
