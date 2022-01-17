#!/bin/sh

# If 'yes', create a map file.
IS_CREATE_MAP_FILE=no

TARGET_PATH_LIST="
lib/js_worker/my_worker.dart
"

################################################################################
__remove_map_file() {
  local OUTPUT_NAME=$1
  local deps_name="${OUTPUT_NAME}.deps"
  local map_name="${OUTPUT_NAME}.map"

  if [ -f "${deps_name}" ]; then
    \rm -f "${deps_name}"
  fi
  if [ -f "${map_name}" ]; then
    \rm -f "${map_name}"
  fi
}

################################################################################
set -u

dart_path=$( which dart )
dart_dir=$( dirname "$dart_path" )
dart2js_path=$( find ${dart_dir} -name "dart2js" -type f -perm -a=rx )

for F in ${TARGET_PATH_LIST}; do
  OUTPUT_NAME=./web/$( basename ${F} dart )js
  echo "==> ${dart2js_path} $F -o $OUTPUT_NAME"
  ${dart2js_path} $F -o $OUTPUT_NAME
  __remove_map_file $OUTPUT_NAME
  echo
done
