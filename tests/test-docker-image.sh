#!/bin/bash

. test-utils.sh

clean

docker run -v "$(pwd)":/usr/app/out --rm nevermendel/heif-convert image.heic -f jpg -q 90
docker run -v "$(pwd)":/usr/app/out --rm nevermendel/heif-convert image.heic -f png
docker run -v "$(pwd)":/usr/app/out --rm nevermendel/heif-convert multi-frame-image.heic -f jpg -q 90
docker run -v "$(pwd)":/usr/app/out --rm nevermendel/heif-convert multi-frame-image.heic -f png

run_compare

exit $?
