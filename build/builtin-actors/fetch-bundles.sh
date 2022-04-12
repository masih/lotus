#!/bin/bash
set -e

cd $(dirname "$0")

# gateway to use
dweb="dweb.link"

actors7_cid=""
actors7_hash=""
actors8_cid="bafybeihbbovgjvdovnzqika3he5ndakeya43xhiwk5dmksjnzurde2vm7i"
actors8_hash="a18b48616d47c06d0d8a43c50d5dfe8280acb512a54f2f78fdfdf6c50ca845e1"

die() {
    echo "$1"
    exit 1
}

check() {
    file=$1
    hash=$2
    if [ -e "$file" ]; then
        echo "$hash $file" | sha256sum --check
    else
        return 1
    fi
}

fetch() {
    output=$1
    cid=$2
    hash=$3
    if (check $output $hash); then
        return 0
    else
        echo "fetching $cid to $output"
        curl -k "https://$dweb/ipfs/$cid" -o $output
        check $output $hash || die "hash mismatch"
    fi
}

if [ ! -z "$actors7_cid" ]; then
    fetch builtin-actors-v7.car "$actors7_cid" "$actors7_hash"
else
    touch builtin-actors-v7.car
fi

if [ ! -z "$actors8_cid" ]; then
    fetch builtin-actors-v8.car "$actors8_cid" "$actors8_hash"
else
    touch builtin-actors-v8.car
fi
