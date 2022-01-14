#!/bin/sh

TARGET_PATH_LIST="
lib/js_worker/my_worker.dart
"

set -u

dart_path=$( which dart )
dart_dir=$( dirname "$dart_path" )
dart2js_path=$( find ${dart_dir} -name "dart2js" -type f -perm -a=rx )

for F in ${TARGET_PATH_LIST}; do
  OUTPUT_NAME=./web/$( basename ${F} dart )js
  echo "==> ${dart2js_path} $F -o $OUTPUT_NAME"
  ${dart2js_path} $F -o $OUTPUT_NAME
  echo
done
