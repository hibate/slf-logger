#!/bin/sh
#
# Copyright (C) 2017 Hibate <ycaia86@126.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

BUILD_APP_OPTIM=$1
BUILD_PROJECT_DIR=$2

for library_tp in ${LIBRARY_TYPE[@]}
do
    case ${library_tp} in
        shared)
            . ${BUILD_SHARED} ${BUILD_APP_OPTIM} ${BUILD_PROJECT_DIR}
            ;;
        static)
            . ${BUILD_STATIC} ${BUILD_APP_OPTIM} ${BUILD_PROJECT_DIR}
            ;;
    esac

    if [ $? -ne 0 ]; then
        exit 1
    fi
done