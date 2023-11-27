#!/bin/bash

status_code=0

compare_hashes() {
  local file=$1
  local expected_hash=$2

  actual_hash=$(sha256sum "${file}" | awk '{print $1}')

  if [[ "${expected_hash}" != "${actual_hash}" ]]; then
    echo "hash for ${file} differs from expected. Expected: ${expected_hash}, Actual: ${actual_hash}"
    status_code=1
  fi
}

rm -f image.jpg image.png \
  multi-frame-image-1.jpg multi-frame-image-2.jpg multi-frame-image-3.jpg \
  multi-frame-image-1.png multi-frame-image-2.png multi-frame-image-3.png

docker run -v "$(pwd)":/usr/app/out --rm nevermendel/heif-convert image.heic -f jpg -q 90
docker run -v "$(pwd)":/usr/app/out --rm nevermendel/heif-convert image.heic -f png

compare_hashes image.jpg "3fb5fff1c6bb5f0f5d76d9839f82564d857e81f71e748da1ec480affde10fa8e"
compare_hashes image.png "f6e29566f59bcce7d0486c9745602354cd903da0dbfce3facb8bba476abeee54"

docker run -v "$(pwd)":/usr/app/out --rm nevermendel/heif-convert multi-frame-image.heic -f jpg -q 90
docker run -v "$(pwd)":/usr/app/out --rm nevermendel/heif-convert multi-frame-image.heic -f png

compare_hashes multi-frame-image-1.jpg "af3702d302d18f36880bba6f12d607a959476d253b2771298abb869d74080e05"
compare_hashes multi-frame-image-2.jpg "4211c3a9bf70c7cad46cfd10cb6fd7ec0ad96dd745c510f659ca7326d0112935"
compare_hashes multi-frame-image-3.jpg "373eb58a99dbe78f0e35d0f1fe2bc12d0be0a0291b4aeafb997b36ae2aa82d49"
compare_hashes multi-frame-image-1.png "685082920811508dd981cbe08223345902a380d83968655685a0b9d4283faf6a"
compare_hashes multi-frame-image-2.png "68964a74bbc8f48471bdf27acca0b7bd8eb1cd66e17d4bd59c5388d80db479aa"
compare_hashes multi-frame-image-3.png "cad0cc0238e7e099f77108d3b9bc4d8bd5f8b3bdb9b842e7f893299103e417e9"

exit $status_code
