#!/usr/bin/env sh

set -u

openssl s_client -showcerts -connect directoraccess-cert.emishealthinsights.co.uk:443 2>/dev/null </dev/null | \
        sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | \
        awk 'split_after == 1 {n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1} {print > n+1 ".crt"}'
