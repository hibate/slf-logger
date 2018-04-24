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

# release / debug
BUILD_APP_OPTIM=$1
BUILD_PROJECT_DIR=$2

build_install_dir=""
if [ "${BUILD_APP_OPTIM}" == "debug" ]; then
    build_install_dir=${debug_libs_dir}
fi
if [ "${BUILD_APP_OPTIM}" == "release" ]; then
    build_install_dir=${release_libs_dir}
fi

echo ""
echo "Build ${BUILD_APP_OPTIM} static library"
echo ""

${_EXECNDK} APP_OPTIM=${BUILD_APP_OPTIM} BUILD_SHARED=false PROJECT_PATH=${BUILD_PROJECT_DIR}
if [ $? -ne 0 ]; then
    exit 1
fi

if [ ! -d "${objs_dir}" ]; then
    exit 1
fi

objs_local_dir=${objs_dir}/local
for abi in ${APP_ABI[@]}
do
    if [ -d "${objs_local_dir}/${abi}" ]; then
        if [ ! -d "${build_install_dir}/${abi}" ]; then
            mkdir -p ${build_install_dir}/${abi}
        fi
        cp ${objs_local_dir}/${abi}/*.a ${build_install_dir}/${abi}/
    fi
done