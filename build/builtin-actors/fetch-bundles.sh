#!/bin/bash
set -e

cd "$(dirname "$0")"

# gateway to use
dweb="dweb.link"

actors7_cid=""
actors7_hash=""
actors8_cid="bafybeichorra562qhrv4mv2rhz5csi2qvwrpm43jt6xpnfafipmz6b2ofy"
actors8_hash="a235fe7d6502a2347ca90b10232a2f61fc778cdb5aa979d6d8a46787e0e2de55"

die() {
    echo "$1"
    exit 1
}

check() {
    file=$1
    hash=$2
    if [ -e "$file" ]; then
        echo "$hash  $file" | shasum -a 256 --check
    else
        return 1
    fi
}

fetch() {
    output=$1
    cid=$2
    hash=$3
    if (check "$output" "$hash"); then
        return 0
    else
        echo "fetching $cid to $output"
        curl -k "https://$dweb/ipfs/$cid" -o "$output"
        check "$output" "$hash" || die "hash mismatch"
    fi
}

if [ -n "$actors7_cid" ]; then
    fetch builtin-actors-v7.car "$actors7_cid" "$actors7_hash"
else
    touch builtin-actors-v7.car
fi

if [ -n "$actors8_cid" ]; then
    fetch builtin-actors-v8.car "$actors8_cid" "$actors8_hash"
else
    touch builtin-actors-v8.car
fi
