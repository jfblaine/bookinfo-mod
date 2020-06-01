#!/bin/bash
#
# Copyright 2018 Istio Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

set -o errexit

display_usage() {
    echo
    echo "USAGE: ./build_push_update_images.sh <version> [-h|--help] [--prefix=value] [--scan-images]"
    echo "	version : Version of the sample app images (Required)"
    echo "	-h|--help : Prints usage information"
    echo "	--prefix: Use the value as the prefix for image names. By default, 'istio' is used"
    echo -e "	--scan-images : Enable security vulnerability scans for docker images \n\t\t\trelated to bookinfo sample apps. By default, this feature \n\t\t\tis disabled."
    exit 1
}

# Check if there is atleast one input argument
if [[ -z "$1" ]] ; then
	echo "Missing version parameter"
        display_usage
else
	VERSION="$1"
	shift
fi

# Process the input arguments. By default, image scanning is disabled. 
PREFIX=istio
ENABLE_IMAGE_SCAN=false
echo "$@"
for i in "$@"
do
	case "$i" in
		--prefix=* )
		   PREFIX="${i#--prefix=}" ;;
		--scan-images )
		   ENABLE_IMAGE_SCAN=true ;;
		-h|--help )
		   echo
		   echo "Build the docker images for bookinfo sample apps, push them to docker hub and update the yaml files."
		   display_usage ;;
		* )
		   echo "Unknown argument: $i"
		   display_usage ;;
	esac
done

#Build docker images
src/reviews-build-services.sh "${VERSION}" "${PREFIX}"

