#!/bin/bash

. test-utils.sh

clean

heif-convert image.heic -f jpg -q 90
heif-convert image.heic -f png
heif-convert multi-frame-image.heic -f jpg -q 90
heif-convert multi-frame-image.heic -f png

run_compare

exit $?
